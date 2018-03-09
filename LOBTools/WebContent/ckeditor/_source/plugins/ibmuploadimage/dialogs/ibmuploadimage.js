/**
 * @class ibmuploadimage
 * 
 * 
 */
( function() {
	var eventAttached = false;
	var imageDialog = function( editor, dialogType ) {
		// Load image preview.
		var IMAGE = 1,
			LINK = 2,
			PREVIEW = 4,
			CLEANUP = 8,
			regexGetSize = /^\s*(\d+)((px)|\%)?\s*$/i,
			regexGetSizeOrEmpty = /(^\s*(\d+)((px)|\%)?\s*$)|^$/i,
			pxLengthRegex = /^\d+px$/;

		var onSizeChange = function() {
			var value = this.getValue(),
			// This = input element.
				dialog = this.getDialog(),
				aMatch = value.match( regexGetSize ); // Check value
			if ( aMatch ) {
				if ( aMatch[ 2 ] == '%' ) // % is allowed - > unlock ratio.
					switchLockRatio( dialog, false ); // Unlock.
				value = aMatch[ 1 ];
			}

			// Only if ratio is locked
			if ( dialog.lockRatio ) {
				var oImageOriginal = dialog.originalElement;
				if ( oImageOriginal.getCustomData( 'isReady' ) == 'true' ) {
					if ( this.id == 'txtHeight' ) {
						if ( value && value != '0' )
							value = Math.round( oImageOriginal.$.width * ( value / oImageOriginal.$.height ) );
						if ( !isNaN( value ) )
							dialog.setValueOf( 'info', 'txtWidth', value );
					} else //this.id = txtWidth.
					{
						if ( value && value != '0' )
							value = Math.round( oImageOriginal.$.height * ( value / oImageOriginal.$.width ) );
						if ( !isNaN( value ) )
							dialog.setValueOf( 'info', 'txtHeight', value );
					}
				}
			}
			updatePreview( dialog );
		};

		var updatePreview = function( dialog ) {
			//Don't load before onShow.
			if ( !dialog.originalElement || !dialog.preview )
				return 1;

			// Read attributes and update imagePreview;
			dialog.commitContent( PREVIEW, dialog.preview );
			return 0;
		};

		// Custom commit dialog logic, where we're intended to give inline style
		// field (txtdlgGenStyle) higher priority to avoid overwriting styles contribute
		// by other fields.
		function commitContent() {
			var args = arguments;
			var inlineStyleField = this.getContentElement( 'advanced', 'txtdlgGenStyle' );
			inlineStyleField && inlineStyleField.commit.apply( inlineStyleField, args );

			this.foreach( function( widget ) {
				if ( widget.commit && widget.id != 'txtdlgGenStyle' )
					widget.commit.apply( widget, args );
			} );
		}

		// Avoid recursions.
		var incommit;

		// Synchronous field values to other impacted fields is uired, e.g. border
		// size change should alter inline-style text as well.
		function commitInternally( targetFields ) {
			if ( incommit )
				return;

			incommit = 1;

			var dialog = this.getDialog(),
				element = dialog.imageElement;
			if ( element ) {
				// Commit this field and broadcast to target fields.
				this.commit( IMAGE, element );

				targetFields = [].concat( targetFields );
				var length = targetFields.length,
					field;
				for ( var i = 0; i < length; i++ ) {
					field = dialog.getContentElement.apply( dialog, targetFields[ i ].split( ':' ) );
					// May cause recursion.
					field && field.setup( IMAGE, element );
				}
			}

			incommit = 0;
		}

		var switchLockRatio = function( dialog, value ) {
			if ( !dialog.getContentElement( 'info', 'ratioLock' ) )
				return null;

			var oImageOriginal = dialog.originalElement;

			// Dialog may already closed. (#5505)
			if ( !oImageOriginal )
				return null;

			// Check image ratio and original image ratio, but respecting user's preference.
			if ( value == 'check' ) {
				if ( !dialog.userlockRatio && oImageOriginal.getCustomData( 'isReady' ) == 'true' ) {
					var width = dialog.getValueOf( 'info', 'txtWidth' ),
						height = dialog.getValueOf( 'info', 'txtHeight' ),
						originalRatio = oImageOriginal.$.width * 1000 / oImageOriginal.$.height,
						thisRatio = width * 1000 / height;
					dialog.lockRatio = false; // Default: unlock ratio

					if ( !width && !height )
						dialog.lockRatio = true;
					else if ( !isNaN( originalRatio ) && !isNaN( thisRatio ) ) {
						if ( Math.round( originalRatio ) == Math.round( thisRatio ) )
							dialog.lockRatio = true;
					}
				}
			} else if ( value != undefined )
				dialog.lockRatio = value;
			else {
				dialog.userlockRatio = 1;
				dialog.lockRatio = !dialog.lockRatio;
			}

			var ratioButton = CKEDITOR.document.getById( btnLockSizesId );
			if ( dialog.lockRatio )
				ratioButton.removeClass( 'cke_btn_unlocked' );
			else
				ratioButton.addClass( 'cke_btn_unlocked' );

			ratioButton.setAttribute( 'aria-checked', dialog.lockRatio );

			// Ratio button hc presentation - WHITE SQUARE / BLACK SQUARE
			if ( CKEDITOR.env.hc ) {
				var icon = ratioButton.getChild( 0 );
				icon.setHtml( dialog.lockRatio ? CKEDITOR.env.ie ? '\u25A0' : '\u25A3' : CKEDITOR.env.ie ? '\u25A1' : '\u25A2' );
			}

			return dialog.lockRatio;
		};

		var resetSize = function( dialog ) {
			var oImageOriginal = dialog.originalElement;
			if ( oImageOriginal.getCustomData( 'isReady' ) == 'true' ) {
				var widthField = dialog.getContentElement( 'info', 'txtWidth' ),
					heightField = dialog.getContentElement( 'info', 'txtHeight' );
				widthField && widthField.setValue( oImageOriginal.$.width );
				heightField && heightField.setValue( oImageOriginal.$.height );
			}
			updatePreview( dialog );
		};

		var setupDimension = function( type, element ) {
			if ( type != IMAGE )
				return;

			function checkDimension( size, defaultValue ) {
				var aMatch = size.match( regexGetSize );
				if ( aMatch ) {
					if ( aMatch[ 2 ] == '%' ) // % is allowed.
					{
						aMatch[ 1 ] += '%';
						switchLockRatio( dialog, false ); // Unlock ratio
					}
					return aMatch[ 1 ];
				}
				return defaultValue;
			}

			var dialog = this.getDialog(),
				value = '',
				dimension = this.id == 'txtWidth' ? 'width' : 'height',
				size = element.getAttribute( dimension );

			if ( size )
				value = checkDimension( size, value );
			value = checkDimension( element.getStyle( dimension ), value );

			this.setValue( value );
		};

		var previewPreloader;

		var onImgLoadEvent = function() {
			// Image is ready.
			var original = this.originalElement,
				loader = CKEDITOR.document.getById( imagePreviewLoaderId );

			original.setCustomData( 'isReady', 'true' );
			original.removeListener( 'load', onImgLoadEvent );
			original.removeListener( 'error', onImgLoadErrorEvent );
			original.removeListener( 'abort', onImgLoadErrorEvent );

			// Hide loader.
			if ( loader )
				loader.setStyle( 'display', 'none' );

			// New image -> new domensions
			if ( !this.dontResetSize )
				resetSize( this );

			if ( this.firstLoad )
				CKEDITOR.tools.setTimeout( function() {
					switchLockRatio( this, 'check' );
				}, 0, this );

			this.firstLoad = false;
			this.dontResetSize = false;
		};

		var onImgLoadErrorEvent = function() {
			// Error. Image is not loaded.
			var original = this.originalElement,
				loader = CKEDITOR.document.getById( imagePreviewLoaderId );

			original.removeListener( 'load', onImgLoadEvent );
			original.removeListener( 'error', onImgLoadErrorEvent );
			original.removeListener( 'abort', onImgLoadErrorEvent );

			// Set Error image.
			var noimage = CKEDITOR.getUrl( CKEDITOR.plugins.get( 'ibmuploadimage' ).path + 'images/noimage.png' );

			if ( this.preview )
				this.preview.setAttribute( 'src', noimage );

			// Hide loader.
			if ( loader )
				loader.setStyle( 'display', 'none' );

			switchLockRatio( this, false ); // Unlock.
		};

		var numbering = function( id ) {
				return CKEDITOR.tools.getNextId() + '_' + id;
			},
			btnLockSizesId = numbering( 'btnLockSizes' ),
			btnResetSizeId = numbering( 'btnResetSize' ),
			imagePreviewLoaderId = numbering( 'ImagePreviewLoader' ),
			previewLinkId = numbering( 'previewLink' ),
			previewImageId = numbering( 'previewImage' );

		var	timeoutInIE;
		
		
		
		var uploadImageTimeout = editor.config.ibmUploadImage.timeout;
		var uploadImageMaxFileSize = editor.config.ibmUploadImage.maxFileSizeLimit;
		var isImageRegExp;
		if(editor.config.ibmUploadImage.supportedFileType != null){
			isImageRegExp = '\\.(';
			for(type in editor.config.ibmUploadImage.supportedFileType){
				isImageRegExp += editor.config.ibmUploadImage.supportedFileType[type] +'|';
			}
			isImageRegExp = isImageRegExp.substring(0, isImageRegExp.length - 1);
			isImageRegExp += ')$';
			isImageRegExp = new RegExp(isImageRegExp,"i");
		}else{
			isImageRegExp = /\.(gif|jpg|jpeg|tiff|png|svg)$/i;
		}
		
		/**
		*@method setUrlAndFireOk
		* Callback function that must be called once the url from the http response has been received in order to insert the image in the editor.
		* 
		*   @param {String} url it's the the actual address of the picture stored in the server
		*   @param dialog it's the imageUpload dialog
		*   
		*/
		var setUrlAndFireOkId = CKEDITOR.tools.addFunction( function (url,dialog){
			var imageURL = dialog.getContentElement('info', 'txtUrl').getInputElement().$;
			imageURL.value = url;
			dialog.getButton('progressButton').getChild(0).getElement().setStyle("visibility","hidden");
			if ( dialog.fire( 'ok', { hide: true } ).hide !== false ){
				dialog.getButton('progressButton').getChild(0).getElement().setStyle("visibility","hidden");
				dialog.hide();
			}
		}, this );
		
		
		
		function _validate(dialog){
			var valid = true;
			var fileToUpload = dialog.getContentElement( 'Upload', 'browseFileButton' ).getInputElement().$;
			var selectedFile = dialog.getContentElement('Upload', 'selectedFile').getInputElement().$;
			var isImageFile = (isImageRegExp).test(selectedFile.value);
			var size = null;
			if( !isImageFile && selectedFile.value !== editor.lang.ibmuploadimage.ibm.noFileChosen){
				alert(editor.lang.ibmuploadimage.ibm.notImageFile);
				loadingImage.setStyle("visibility","hidden");
				valid = false;
				return valid;
			}
			//validate image file before fire ok event
			if(!selectedFile || !selectedFile.value || selectedFile.value === '' || selectedFile.value === editor.lang.ibmuploadimage.ibm.noFileChosen){
				valid = false;
				alert(editor.lang.ibmuploadimage.ibm.notImageFile) ;
				return valid;
			}
			//validate image size, if previous is valid
			if( CKEDITOR.env.ie && CKEDITOR.env.version < 10){
				try{
					var fileSystem = new ActiveXObject("Scripting.FileSystemObject");
					var fileObject = fileSystem.getFile(selectedFile.value);
					size = fileObject.size;
					fileToUpload = fileObject;
				}catch(e){
					if( typeof console !== "undefined"){
						console.log(e.message);
					}
					// If valid to this point,
					alert(editor.lang.ibmuploadimage.ibm.enableActiveX);
					return;
				}
			}else{
				size = fileToUpload.files[0] && fileToUpload.files[0].size || null;
			}
			if(!size){
				valid = false;
				return valid;
			}
			if(size && size/(1024*1024) > uploadImageMaxFileSize){
				alert(editor.lang.ibmuploadimage.ibm.imageSize);
				loadingImage.setStyle("visibility","hidden");
				valid = false;
				return valid;
			}
			return valid;
		}
		
		
		function _uploadImage(editor,dialog,setUrlAndFireOkId){
			var isAborted = false;
			var req = -1;
			var formData;
			var fileToUpload = dialog.getContentElement( 'Upload', 'browseFileButton' ).getInputElement().$;
			var formUpload = fileToUpload.parentNode;
			var loadingImage = dialog.getButton('progressButton').getChild(0).getElement();
			if( CKEDITOR.env.ie && CKEDITOR.env.version < 10){
				
				var uploadFrame = document.getElementById(dialog.getContentElement( 'Upload', 'browseFileButton' )._.frameId);
				var backupHTML = uploadFrame.contentWindow.document.getElementsByTagName('html')[0].innerHTML;
				backupHTML = "<html>"+backupHTML+"</html>";
				var backupFrame = uploadFrame.cloneNode(true);

				dialog.on( 'cancel', function( evt ) {
					isAborted = true;
				});


				// Hack to prevent issue in IE where filebrowserSe is not loaded
				// The callback to setUrl is automitically triggered from the HTML Form response
				// Since, we do not need the logic to execute, we just mock the object that does not exist...
				var _fbNaNHandler = function(){
					if (typeof editor._.filebrowserSe == "undefined") {
						editor._.filebrowserSe = {
							getDialog: function () {
								return {
									getContentElement: function () {
										return {
											reset: function () {

											}
										}
									}
								};
							},
							'for': [],
							filebrowser: {
								onSelect: function () {

								}
							}
						}
					}
					uploadFrame.detachEvent('onreadystatechange', _fbNaNHandler);
				};

				uploadFrame.attachEvent('onreadystatechange',_fbNaNHandler);

				var _timeOutHandler = function(){
					if( uploadImageTimeout ){
						var timeout = parseInt(uploadImageTimeout);
						if( timeout > 0 ){
							timeoutInIE = setTimeout(function(){
								var parent = uploadFrame.parentNode;
								uploadFrame.removeNode(true);
								parent.appendChild(backupFrame);
								backupFrame.contentWindow.document.open();
								backupFrame.contentWindow.document.writeln(backupHTML);
								backupFrame.contentWindow.document.close();
								loadingImage.setStyle("visibility","hidden");
								alert(editor.lang.ibmuploadimage.ibm.fileUploadTimeout);
								eventAttached = false;
								timeoutInIE = null;
							},timeout);
						}
					}
					uploadFrame.detachEvent('onreadystatechange', _timeOutHandler);
				};

				uploadFrame.attachEvent('onreadystatechange',_timeOutHandler);

				if(!eventAttached){

					uploadFrame.attachEvent("onload", function(){

						// Carry on with parsing of the response.
						try{
							var ret = uploadFrame.contentWindow.document.getElementsByTagName('head')[0].innerHTML;
							var jsonP = ret.match(/(<script[^>]*>)?\W*window\.parent\.CKEDITOR\.tools\.callFunction\(\W*\d*\W*,\W*\[["']{1}(.*?)["']{1}\]\W*\);?\W*(<\/script>)?/i);
							if( jsonP && !isAborted){
								if(timeoutInIE)
									clearTimeout(timeoutInIE);
								var imageURL = dialog.getContentElement('info', 'txtUrl').getInputElement().$;
								imageURL.value = jsonP[2];
								dialog.getButton('progressButton').getChild(0).getElement().setStyle("visibility","hidden");
								if ( dialog.fire( 'ok', { hide: true } ).hide !== false ){
									dialog.getButton('progressButton').getChild(0).getElement().setStyle("visibility","hidden");
									dialog.hide();
								}
							} else{	//cancel image insert event
								if(timeoutInIE)
									clearTimeout(timeoutInIE);
								var parent = uploadFrame.parentNode;
								uploadFrame.removeNode(true);
								parent.appendChild(backupFrame);
								backupFrame.contentWindow.document.open();
								backupFrame.contentWindow.document.writeln(backupHTML);
								backupFrame.contentWindow.document.close();
								loadingImage.setStyle("visibility","hidden");
								eventAttached = false;
							}
						}catch(e){

							if(timeoutInIE){
								clearTimeout(timeoutInIE);
							}

							// Check wether iFrame is accessible (in case of a timeout, it isnt the case)
							if( typeof uploadFrame.contentWindow == "unknown"){
								clearTimeout(timeoutInIE);
								return;
							}

							var parent = uploadFrame.parentNode;
							uploadFrame.removeNode(true);
							parent.appendChild(backupFrame);
							backupFrame.contentWindow.document.open();
							backupFrame.contentWindow.document.writeln(backupHTML);
							backupFrame.contentWindow.document.close();
							loadingImage.setStyle("visibility","hidden");
							alert(editor.lang.ibmuploadimage.ibm.serverUnreachable);
							eventAttached = false;
						}
					});
					eventAttached = true;
				}


				formUpload.submit();
			}else{
			
				req = new XMLHttpRequest();
				formData = new FormData();
				formData.append('file', fileToUpload.files[0]);
				try{
					req.open('POST', formUpload.action, true); // send synchronous request
					req.onreadystatechange = function(){
						if( req.status && req.readyState == 4 ){
							if( req.status == 200){
								var jsonP = req.responseText.match(/(<script[^>]*>)?\W*window\.parent\.CKEDITOR\.tools\.callFunction\(\W*\d*\W*,\W*\[["']{1}(.*?)["']{1}\]\W*\);?\W*(<\/script>)?/i);
								if( jsonP ){
									// Update image URL manually without using the filebrowser
									CKEDITOR.tools.callFunction( setUrlAndFireOkId, jsonP[2], dialog );
								}
							} else {
								// incorrect responseCode received,
								// Request is aborted, and alert dialog displays
								isAborted = true;
								alert(editor.lang.ibmuploadimage.ibm.serverUnreachable);
								loadingImage.setStyle("visibility","hidden");
							}
						}
					};
					req.send(formData);
						dialog.on( 'cancel', function( evt ) {
						req.abort();
						isAborted = true;
					});
					if( uploadImageTimeout ){
						var timeout = parseInt(uploadImageTimeout);
						if( timeout > 0 ){
							setTimeout(
								function(){
									if( req.status !== 200 && !isAborted){
										req.abort();
										alert(editor.lang.ibmuploadimage.ibm.fileUploadTimeout);
										loadingImage.setStyle("visibility","hidden");
									}
								},timeout);
						}
					}
				}catch(err){
					isAborted = true;
				}
			}
		}
		
		/**
		*@method
		* Function that implements the process to upload an image in the editor.
		* 
		* 	@param editor the object of the editor passed to the overriding function 
		*   @param dialog the object of the ibmupload dialog passed to overriding function
		*   @param setUrlAndFireOkId Id of the callback function that set the image's address in the dialog and fire the ok event.
		*   The function has to be called with the CKEDITOR.tools.callFunction(setUrlAndFireOkId,url,dialog) method.
		*   
		*   
		*/
		var uploadImage = (function(){
			return editor.config.ibmUploadImage.uploadImage != null ? editor.config.ibmUploadImage.uploadImage : _uploadImage
		})();

		/**
		*@method
		* Function that has to be called in order to validate the file.
		* 
		*   @param dialog it's the imageUpload dialog
		*   @return {Boolean} must return false if the validation failed or true otherwise
		*/
		var validate = (function(){
			return editor.config.ibmUploadImage.validate != null ? editor.config.ibmUploadImage.validate : _validate;
		})();


		return {
			title: editor.lang.ibmuploadimage[ dialogType == 'image' ? 'title' : 'titleButton' ],
			minWidth : 220,
			minHeight : 50,
			onShow: function() {
				this.imageElement = false;
				this.linkElement = false;

				// Default: create a new element.
				this.imageEditMode = false;
				this.linkEditMode = false;

				this.lockRatio = true;
				this.userlockRatio = 0;
				this.dontResetSize = false;
				this.firstLoad = true;
				this.addLink = false;

				var editor = this.getParentEditor(),
					sel = editor.getSelection(),
					element = sel && sel.getSelectedElement(),
					link = element && editor.elementPath( element ).contains( 'a', 1 ),
					loader = CKEDITOR.document.getById( imagePreviewLoaderId );

				// Hide loader.
				if ( loader )
					loader.setStyle( 'display', 'none' );

				// Create the preview before setup the dialog contents.
				previewPreloader = new CKEDITOR.dom.element( 'img', editor.document );
				this.preview = CKEDITOR.document.getById( previewImageId );

				// Copy of the image
				this.originalElement = editor.document.createElement( 'img' );
				this.originalElement.setAttribute( 'alt', '' );
				this.originalElement.setCustomData( 'isReady', 'false' );

				//set the aria-describedby attribute on the txtUrl2 input field to the domId of the imageLinkLabel
				var descriptionField = this.definition.dialog.getContentElement('info', 'imageLinkLabel');
				var urlField = this.definition.dialog.getContentElement('info','txtUrl2');
				if(descriptionField && urlField)
					urlField.getInputElement().setAttribute('aria-describedby', descriptionField.domId);

				if ( link ) {
					this.linkElement = link;
					this.linkEditMode = true;

					// Look for Image element.
					var linkChildren = link.getChildren();
					if ( linkChildren.count() == 1 ) // 1 child.
					{
						var childTagName = linkChildren.getItem( 0 ).getName();
						if ( childTagName == 'img' || childTagName == 'input' ) {
							this.imageElement = linkChildren.getItem( 0 );
							if ( this.imageElement.getName() == 'img' )
								this.imageEditMode = 'img';
							else if ( this.imageElement.getName() == 'input' )
								this.imageEditMode = 'input';
						}
					}
					// Fill out all fields.
					if ( dialogType == 'image' )
						this.setupContent( LINK, link );
				}

				// Edit given image element instead the one from selection.
				if ( this.customImageElement ) {
					this.imageEditMode = 'img';
					this.imageElement = this.customImageElement;
					delete this.customImageElement;
				}
				else if ( element && element.getName() == 'img' && !element.data( 'cke-realelement' ) ||
					element && element.getName() == 'input' && element.getAttribute( 'type' ) == 'image' ) {
					this.imageEditMode = element.getName();
					this.imageElement = element;
				}

				if ( this.imageEditMode ) {
					// Use the original element as a buffer from  since we don't want
					// temporary changes to be committed, e.g. if the dialog is canceled.
					this.cleanImageElement = this.imageElement;
					this.imageElement = this.cleanImageElement.clone( true, true );

					// Fill out all fields.
					this.setupContent( IMAGE, this.imageElement );

					// Switch to Image Properties tab when editing an existing image
					this.selectPage( 'info' );

				} else
					this.imageElement = editor.document.createElement( 'img' );

				// Refresh LockRatio button
				switchLockRatio( this, true );

				// Dont show preview if no URL given.
				if ( !CKEDITOR.tools.trim( this.getValueOf( 'info', 'txtUrl' ) ) ) {
					this.preview.removeAttribute( 'src' );
					this.preview.setStyle( 'display', 'none' );
				}
			},
			onOk: function() {
				// Edit existing Image.
				if ( this.imageEditMode ) {
					var imgTagName = this.imageEditMode;

					// Image dialog and Input element.
					if ( dialogType == 'image' && imgTagName == 'input' && confirm( editor.lang.ibmuploadimage.button2Img ) ) {
						// Replace INPUT-> IMG
						imgTagName = 'img';
						this.imageElement = editor.document.createElement( 'img' );
						this.imageElement.setAttribute( 'alt', '' );
						editor.insertElement( this.imageElement );
					}
					// ImageButton dialog and Image element.
					else if ( dialogType != 'image' && imgTagName == 'img' && confirm( editor.lang.ibmuploadimage.img2Button ) ) {
						// Replace IMG -> INPUT
						imgTagName = 'input';
						this.imageElement = editor.document.createElement( 'input' );
						this.imageElement.setAttributes( {
							type: 'image',
							alt: ''
						} );
						editor.insertElement( this.imageElement );
					} else {
						// Restore the original element before all commits.
						this.imageElement = this.cleanImageElement;
						delete this.cleanImageElement;
					}
				} else // Create a new image.
				{
					// Image dialog -> create IMG element.
					if ( dialogType == 'image' )
						this.imageElement = editor.document.createElement( 'img' );
					else {
						this.imageElement = editor.document.createElement( 'input' );
						this.imageElement.setAttribute( 'type', 'image' );
					}
					this.imageElement.setAttribute( 'alt', '' );
				}

				// Create a new link.
				if ( !this.linkEditMode )
					this.linkElement = editor.document.createElement( 'a' );

				// Set attributes.
				this.commitContent( IMAGE, this.imageElement );
				this.commitContent( LINK, this.linkElement );

				// Remove empty style attribute.
				if ( !this.imageElement.getAttribute( 'style' ) )
					this.imageElement.removeAttribute( 'style' );

				// Insert a new Image.
				if ( !this.imageEditMode ) {
					if ( this.addLink ) {
						//Insert a new Link.
						if ( !this.linkEditMode ) {
							editor.insertElement( this.linkElement );
							this.linkElement.append( this.imageElement, false );
						} else //Link already exists, image not.
							editor.insertElement( this.imageElement );
					} else
						editor.insertElement( this.imageElement );
				} else // Image already exists.
				{
					//Add a new link element.
					if ( !this.linkEditMode && this.addLink ) {
						editor.insertElement( this.linkElement );
						this.imageElement.appendTo( this.linkElement );
					}
					//Remove Link, Image exists.
					else if ( this.linkEditMode && !this.addLink ) {
						editor.getSelection().selectElement( this.linkElement );
						editor.insertElement( this.imageElement );
					}
				}
			},
			onLoad: function() {
				if ( dialogType != 'image' )
					this.hidePage( 'Link' ); //Hide Link tab.
				var doc = this._.element.getDocument();

				if ( this.getContentElement( 'info', 'ratioLock' ) ) {
					this.addFocusable( doc.getById( btnLockSizesId ), 12 );
					this.addFocusable( doc.getById( btnResetSizeId ), 13 );
				}

				this.commitContent = commitContent;
			},
			onCancel: function() {
				//hide loading image if cancel button was pressed in the image upload dialog
				var loadingImage = this.getButton('progressButton').getChild(0).getElement();
				if(loadingImage)
					loadingImage.setStyle("visibility","hidden");
			},
			onHide: function() {
				if ( this.preview )
					this.commitContent( CLEANUP, this.preview );

				if ( this.originalElement ) {
					this.originalElement.removeListener( 'load', onImgLoadEvent );
					this.originalElement.removeListener( 'error', onImgLoadErrorEvent );
					this.originalElement.removeListener( 'abort', onImgLoadErrorEvent );
					this.originalElement.remove();
					this.originalElement = false; // Dialog is closed.
				}

				delete this.imageElement;
			},
			/**
			 * IBM Customizations
			 */
			contents: [
				{
					id: 'Upload',
					filebrowser: 'uploadButton',
					label: editor.lang.ibmuploadimage.upload,
					accessKey: 'U',

					elements: [
						{
							type: 'vbox',
							padding: 0,
							width: 340,
							children: [
								{
									type: 'hbox',
									padding: 0,
									children: [
										{
											type: 'html',
											id: 'fileUploadLabel',
											style: 'margin:0; padding-bottom: 15px; width:100%;',
											html: '<div>' + CKEDITOR.tools.htmlEncode(editor.lang.ibmuploadimage.ibm.fileUpload) + '</div>'
										}
									]
								},
								{
									type: 'hbox',
									padding: 0,
									style: 'display:none;',
									children: [
										{
											type: 'file',
											id: 'browseFileButton',
											label: editor.lang.ibmuploadimage.ibm.fileUpload,
											style: 'display:none;',
											onChange: function () {
												var dialog = this.getDialog();
												var selectedFile = dialog.getContentElement('Upload', 'selectedFile').getInputElement().$;
												selectedFile.value = this.getValue() !== '' ? this.getValue() : editor.lang.ibmuploadimage.ibm.noFileChosen ;
											}

										},
										{
											type: 'fileButton',
											id: 'uploadButton',
											filebrowser: {
												action: 'QuickUpload',
												target: 'info:txtUrl',
												url: editor.config.ibmUploadImage.uploadUrl != null && editor.config.ibmUploadImage.uploadUrl != '' ? editor.config.ibmUploadImage.uploadUrl : editor.config.ibmBinaryImageUploadUrl
											},
											style: 'display:none;',
											label: editor.lang.ibmuploadimage.btnUpload,
											'for': [ 'Upload', 'browseFileButton' ]
										}
									]
								},
								{
									type: 'hbox',
									padding: 0,
									style: 'height:300px;',
									widths: ['20%','80%'],
									children: [
										{
											type: 'button',
											id: 'browseFile',
											label: editor.lang.ibmuploadimage.ibm.browseFile,
											onLoad : function(){
												//set the aria-describedby attribute on the browseFile button to the domId of the fileUploadLabel
												var fileUploadLabel = this.getDialog().getContentElement('Upload', 'fileUploadLabel');
												if(fileUploadLabel)
													this.getInputElement().setAttribute('aria-describedby', fileUploadLabel.domId);
												this.getInputElement().setAttribute('class','cke_dialog_ui_primary_button');
												this.getInputElement().getChildren().getItem(0).setAttribute('class','cke_dialog_ui_primary_button');
											},
											onClick : function() {
												var dialog = this.getDialog();
												var browseButton = dialog.getContentElement( 'Upload', 'browseFileButton' ).getInputElement().$;
												browseButton.click();
											}
										},
										{
											type: 'text',
											id: 'selectedFile',
											label: editor.lang.ibmuploadimage.ibm.file,
											labelStyle: 'display:none',
											style: 'padding-left: 10px;',
											size: 38,
											className: 'cke_disabled',
											onLoad: function(){
												this.getInputElement().getParent().setStyle('border','none');
												this.getInputElement().getParent().setStyle('background','white');
												this.getInputElement().setStyle('background','white');
												this.setValue(editor.lang.ibmuploadimage.ibm.noFileChosen);
												this.getInputElement().setAttribute( 'readOnly', true );
												this.getElement().on(
													'keydown', function(e){
														if (e.data.$.keyCode == 13) {
															e.data.$.stopPropagation();
														}
													}, this.getDialog()
												);
											},
											onShow: function(){
												if( this.getValue() == '' )
													this.setValue(editor.lang.ibmuploadimage.ibm.noFileChosen);
												this.getInputElement().setStyle('background','white');
												this.getInputElement().setAttribute( 'readOnly', true );
											}
										}
									]
								}
							]
						}
					]
				},
				{
					id: 'info',
					label: editor.lang.ibmuploadimage.infoTab,
					accessKey: 'I',
					elements: [
						{
							type: 'vbox',
							padding: 0,
							style: 'margin:0; padding: 0; width:100%;',
							children: [
								{
									type: 'html',
									id: 'imageLinkLabel',
									style: 'margin:0; padding: 0; width:100%;',
									html: '<div>' + CKEDITOR.tools.htmlEncode(editor.lang.ibmuploadimage.ibm.imageLinkLabel) + '</div>'
								}
							]
						},
						{
							type: 'hbox',
							padding: 0,
							children: [
								{
									id: 'txtUrl2',
									type: 'text',
									label: editor.lang.ibmuploadimage.ibm.linkLabel,
									labelLayout: 'horizontal',
									widths: [ '13%', '87%' ],
									style: 'width:100%',
									'default': '',
									onShow:function(){
										//correction of the alignment of the Link textfield.
										this.getElement().findOne("td").removeClass("cke_dialog_ui_hbox_first").setStyle("vertical-align","middle");
									},
									setup: function( type, element ) {
										if ( type == LINK ) {
											var href = element.data( 'cke-saved-href' );
											if ( !href )
												href = element.getAttribute( 'href' );
											this.setValue( href );
										}
									},
									commit: function( type, element ) {
										if ( type == LINK ) {
											if ( this.getValue() || this.isChanged() ) {
												var url = this.getValue();
												element.data( 'cke-saved-href', url );
												element.setAttribute( 'href', url );

												if ( this.getValue() || !editor.config.image_removeLinkByEmptyURL )
													this.getDialog().addLink = true;
											}
										}
									}
								}
							]
						},
						{
							type: 'hbox',
							padding: 0,
							children: [
								{
									id: 'cmbTarget',
									type: 'select',
									style: 'width:100%',
									requiredContent: 'a[target]',
									label : editor.lang.common.target,
									labelLayout: 'horizontal',
									widths: [ '13%', '87%' ],
									'default': '',
									onShow:function(){
										//correction of the alignment of the Target textfield.
										this.getElement().findOne("td").removeClass("cke_dialog_ui_hbox_first").setStyle("vertical-align","middle");
									},
									items: [
										[ editor.lang.common.notSet, '' ],
										[ editor.lang.common.targetNew, '_blank' ],
										[ editor.lang.common.targetTop, '_top' ],
										[ editor.lang.common.targetSelf, '_self' ],
										[ editor.lang.common.targetParent, '_parent' ]
									],
									setup: function( type, element ) {
										if ( type == LINK )
											this.setValue( element.getAttribute( 'target' ) || '' );
									},
									commit: function( type, element ) {
										if ( type == LINK ) {
											if ( this.getValue() || this.isChanged() )
												element.setAttribute( 'target', this.getValue() );
										}
									}
								}
							]
						},
						{
							type: 'vbox',
							padding: 0,
							widths: [20,80],
							children: [
								{
									type: 'button',
									id: 'browse',
									filebrowser: {
										action: 'Browse',
										target: 'Link:txtUrl',
										url: editor.config.filebrowserImageBrowseLinkUrl
									},
									style: 'float:right',
									hidden: true,
									label: editor.lang.common.browseServer
								},
								{
									id: 'txtUrl',
									type: 'text',
									label: editor.lang.common.url,
									required: true,
									onChange: function() {
										var dialog = this.getDialog(),
											newUrl = this.getValue();

										//Update original image
										if ( newUrl.length > 0 ) //Prevent from load before onShow
										{
											dialog = this.getDialog();
											var original = dialog.originalElement;

											if ( dialog.preview ) {
												dialog.preview.removeStyle( 'display' );
											}

											original.setCustomData( 'isReady', 'false' );
											// Show loader.
											var loader = CKEDITOR.document.getById( imagePreviewLoaderId );
											if ( loader )
												loader.setStyle( 'display', '' );

											original.on( 'load', onImgLoadEvent, dialog );
											original.on( 'error', onImgLoadErrorEvent, dialog );
											original.on( 'abort', onImgLoadErrorEvent, dialog );
											original.setAttribute( 'src', newUrl );

											if ( dialog.preview ) {
												// Query the preloader to figure out the url impacted by based href.
												previewPreloader.setAttribute( 'src', newUrl );
												dialog.preview.setAttribute( 'src', previewPreloader.$.src );
												updatePreview( dialog );
											}
										}
										// Dont show preview if no URL given.
										else if ( dialog.preview ) {
											dialog.preview.removeAttribute( 'src' );
											dialog.preview.setStyle( 'display', 'none' );
										}
									},
									setup: function( type, element ) {
										if ( type == IMAGE ) {
											var url = element.data( 'cke-saved-src' ) || element.getAttribute( 'src' );
											var field = this;

											this.getDialog().dontResetSize = true;

											field.setValue( url ); // And call this.onChange()
											// Manually set the initial value.(#4191)
											field.setInitValue();
										}
									},
									commit: function( type, element ) {
										if ( type == IMAGE && ( this.getValue() || this.isChanged() ) ) {
											element.data( 'cke-saved-src', this.getValue() );
											element.setAttribute( 'src', this.getValue() );
										} else if ( type == CLEANUP ) {
											element.setAttribute( 'src', '' ); // If removeAttribute doesn't work.
											element.removeAttribute( 'src' );
										}
									},									
									validate: CKEDITOR.dialog.validate.notEmpty( editor.lang.ibmuploadimage.urlMissing )
								},
								{
									type: 'button',
									id: 'browse',
									// v-align with the 'txtUrl' field.
									// TODO: We need something better than a fixed size here.
									style: 'display:inline-block;margin-top:14px;',
									align: 'center',
									label: editor.lang.common.browseServer,
									hidden: true,
									filebrowser: 'info:txtUrl'
								},
								{
									id: 'txtAlt',
									type: 'text',
									label: editor.lang.ibmuploadimage.alt,
									accessKey: 'T',
									'default': '',
									onChange: function() {
										updatePreview( this.getDialog() );
									},
									setup: function( type, element ) {
										if ( type == IMAGE )
											this.setValue( element.getAttribute( 'alt' ) );
									},
									commit: function( type, element ) {
										if ( type == IMAGE ) {
											if ( this.getValue() || this.isChanged() )
												element.setAttribute( 'alt', this.getValue() );
										} else if ( type == PREVIEW )
											element.setAttribute( 'alt', this.getValue() );
										else if ( type == CLEANUP )
											element.removeAttribute( 'alt' );

									}
								},
								{
									type: 'hbox',
									requiredContent: 'img{width,height}',
									children: [
										{
											type: 'text',
											id: 'txtWidth',
											label: editor.lang.common.width,
											onKeyUp: onSizeChange,
											onChange: function() {
												commitInternally.call( this, 'advanced:txtdlgGenStyle' );
											},
											validate: function() {
												var aMatch = this.getValue().match( regexGetSizeOrEmpty ),
													isValid = !!( aMatch && parseInt( aMatch[ 1 ], 10 ) !== 0 );
												if ( !isValid )
													alert( editor.lang.common.invalidWidth );
												return isValid;
											},
											setup: setupDimension,
											commit: function( type, element, internalCommit ) {
												var value = this.getValue();
												if ( type == IMAGE ) {
													if ( value && editor.activeFilter.check( 'img{width,height}' ) )
														element.setStyle( 'width', CKEDITOR.tools.cssLength( value ) );
													else
														element.removeStyle( 'width' );

													!internalCommit && element.removeAttribute( 'width' );
												} else if ( type == PREVIEW ) {
													var aMatch = value.match( regexGetSize );
													if ( !aMatch ) {
														var oImageOriginal = this.getDialog().originalElement;
														if ( oImageOriginal.getCustomData( 'isReady' ) == 'true' )
															element.setStyle( 'width', oImageOriginal.$.width + 'px' );
													} else
														element.setStyle( 'width', CKEDITOR.tools.cssLength( value ) );
												} else if ( type == CLEANUP ) {
													element.removeAttribute( 'width' );
													element.removeStyle( 'width' );
												}
											}
										},
										{
											type: 'text',
											id: 'txtHeight',
											label: editor.lang.common.height,
											onKeyUp: onSizeChange,
											onChange: function() {
												commitInternally.call( this, 'advanced:txtdlgGenStyle' );
											},
											validate: function() {
												var aMatch = this.getValue().match( regexGetSizeOrEmpty ),
													isValid = !!( aMatch && parseInt( aMatch[ 1 ], 10 ) !== 0 );
												if ( !isValid )
													alert( editor.lang.common.invalidHeight );
												return isValid;
											},
											setup: setupDimension,
											commit: function( type, element, internalCommit ) {
												var value = this.getValue();
												if ( type == IMAGE ) {
													if ( value && editor.activeFilter.check( 'img{width,height}' ) )
														element.setStyle( 'height', CKEDITOR.tools.cssLength( value ) );
													else
														element.removeStyle( 'height' );

													!internalCommit && element.removeAttribute( 'height' );
												} else if ( type == PREVIEW ) {
													var aMatch = value.match( regexGetSize );
													if ( !aMatch ) {
														var oImageOriginal = this.getDialog().originalElement;
														if ( oImageOriginal.getCustomData( 'isReady' ) == 'true' )
															element.setStyle( 'height', oImageOriginal.$.height + 'px' );
													} else
														element.setStyle( 'height', CKEDITOR.tools.cssLength( value ) );
												} else if ( type == CLEANUP ) {
													element.removeAttribute( 'height' );
													element.removeStyle( 'height' );
												}
											}
										}
									]
								},
								{
									type: 'hbox',
									requiredContent: 'img{width,height}',
									children: [
										{
											type: 'text',
											id: 'txtHSpace',
											requiredContent: 'img{margin-left,margin-right}',
											label: editor.lang.ibmuploadimage.hSpace,
											'default': '',
											onKeyUp: function() {
												updatePreview( this.getDialog() );
											},
											onChange: function() {
												commitInternally.call( this, 'advanced:txtdlgGenStyle' );
											},
											validate: CKEDITOR.dialog.validate.integer( editor.lang.ibmuploadimage.validateHSpace ),
											setup: function( type, element ) {
												if ( type == IMAGE ) {
													var value, marginLeftPx, marginRightPx,
														marginLeftStyle = element.getStyle( 'margin-left' ),
														marginRightStyle = element.getStyle( 'margin-right' );

													marginLeftStyle = marginLeftStyle && marginLeftStyle.match( pxLengthRegex );
													marginRightStyle = marginRightStyle && marginRightStyle.match( pxLengthRegex );
													marginLeftPx = parseInt( marginLeftStyle, 10 );
													marginRightPx = parseInt( marginRightStyle, 10 );

													value = ( marginLeftPx == marginRightPx ) && marginLeftPx;
													isNaN( parseInt( value, 10 ) ) && ( value = element.getAttribute( 'hspace' ) );

													this.setValue( value );
												}
											},
											commit: function( type, element, internalCommit ) {
												var value = parseInt( this.getValue(), 10 );
												if ( type == IMAGE || type == PREVIEW ) {
													if ( !isNaN( value ) ) {
														element.setStyle( 'margin-left', CKEDITOR.tools.cssLength( value ) );
														element.setStyle( 'margin-right', CKEDITOR.tools.cssLength( value ) );
													} else if ( !value && this.isChanged() ) {
														element.removeStyle( 'margin-left' );
														element.removeStyle( 'margin-right' );
													}

													if ( !internalCommit && type == IMAGE )
														element.removeAttribute( 'hspace' );
												} else if ( type == CLEANUP ) {
													element.removeAttribute( 'hspace' );
													element.removeStyle( 'margin-left' );
													element.removeStyle( 'margin-right' );
												}
											}
										}, //TODO
										{
											type: 'text',
											id: 'txtVSpace',
											requiredContent: 'img{margin-top,margin-bottom}',
											label: editor.lang.ibmuploadimage.vSpace,
											'default': '',
											onKeyUp: function() {
												updatePreview( this.getDialog() );
											},
											onChange: function() {
												commitInternally.call( this, 'advanced:txtdlgGenStyle' );
											},
											validate: CKEDITOR.dialog.validate.integer( editor.lang.ibmuploadimage.validateVSpace ),
											setup: function( type, element ) {
												if ( type == IMAGE ) {
													var value, marginTopPx, marginBottomPx,
														marginTopStyle = element.getStyle( 'margin-top' ),
														marginBottomStyle = element.getStyle( 'margin-bottom' );

													marginTopStyle = marginTopStyle && marginTopStyle.match( pxLengthRegex );
													marginBottomStyle = marginBottomStyle && marginBottomStyle.match( pxLengthRegex );
													marginTopPx = parseInt( marginTopStyle, 10 );
													marginBottomPx = parseInt( marginBottomStyle, 10 );

													value = ( marginTopPx == marginBottomPx ) && marginTopPx;
													isNaN( parseInt( value, 10 ) ) && ( value = element.getAttribute( 'vspace' ) );
													this.setValue( value );
												}
											},
											commit: function( type, element, internalCommit ) {
												var value = parseInt( this.getValue(), 10 );
												if ( type == IMAGE || type == PREVIEW ) {
													if ( !isNaN( value ) ) {
														element.setStyle( 'margin-top', CKEDITOR.tools.cssLength( value ) );
														element.setStyle( 'margin-bottom', CKEDITOR.tools.cssLength( value ) );
													} else if ( !value && this.isChanged() ) {
														element.removeStyle( 'margin-top' );
														element.removeStyle( 'margin-bottom' );
													}

													if ( !internalCommit && type == IMAGE )
														element.removeAttribute( 'vspace' );
												} else if ( type == CLEANUP ) {
													element.removeAttribute( 'vspace' );
													element.removeStyle( 'margin-top' );
													element.removeStyle( 'margin-bottom' );
												}
											}
										}

									]

								},
								{
									type: 'hbox',
									requiredContent: 'img{width,height}',
									children: [
										{
											id: 'cmbAlign',
											requiredContent: 'img{float}',
											type: 'select',
											style: 'width:100%',
											label: editor.lang.common.align,
											'default': '',
											items: [
												[ editor.lang.common.notSet, '' ],
												[ editor.lang.common.alignLeft, 'left' ],
												[ editor.lang.common.alignRight, 'right' ]
												// Backward compatible with v2 on setup when specified as attribute value,
												// while these values are no more available as select options.
												//	[ editor.lang.image.alignAbsBottom , 'absBottom'],
												//	[ editor.lang.image.alignAbsMiddle , 'absMiddle'],
												//  [ editor.lang.image.alignBaseline , 'baseline'],
												//  [ editor.lang.image.alignTextTop , 'text-top'],
												//  [ editor.lang.image.alignBottom , 'bottom'],
												//  [ editor.lang.image.alignMiddle , 'middle'],
												//  [ editor.lang.image.alignTop , 'top']
											],
											onChange: function() {
												updatePreview( this.getDialog() );
												commitInternally.call( this, 'advanced:txtdlgGenStyle' );
											},
											setup: function( type, element ) {
												if ( type == IMAGE ) {
													var value = element.getStyle( 'float' );
													switch ( value ) {
														// Ignore those unrelated values.
														case 'inherit':
														case 'none':
															value = '';
													}

													!value && ( value = ( element.getAttribute( 'align' ) || '' ).toLowerCase() );
													this.setValue( value );
												}
											},
											commit: function( type, element, internalCommit ) {
												var value = this.getValue();
												if ( type == IMAGE || type == PREVIEW ) {
													if ( value )
														element.setStyle( 'float', value );
													else
														element.removeStyle( 'float' );

													if ( !internalCommit && type == IMAGE ) {
														value = ( element.getAttribute( 'align' ) || '' ).toLowerCase();
														switch ( value ) {
															// we should remove it only if it matches "left" or "right",
															// otherwise leave it intact.
															case 'left':
															case 'right':
																element.removeAttribute( 'align' );
														}
													}
												} else if ( type == CLEANUP )
													element.removeStyle( 'float' );

											}
										},
										{
											type: 'text',
											id: 'txtBorder',
											requiredContent: 'img{border-width}',
											label: editor.lang.ibmuploadimage.border,
											'default': '',
											onKeyUp: function() {
												updatePreview( this.getDialog() );
											},
											onChange: function() {
												commitInternally.call( this, 'advanced:txtdlgGenStyle' );
											},
											validate: CKEDITOR.dialog.validate.integer( editor.lang.ibmuploadimage.validateBorder ),
											setup: function( type, element ) {
												if ( type == IMAGE ) {
													var value,
														borderStyle = element.getStyle( 'border-width' );
													borderStyle = borderStyle && borderStyle.match( /^(\d+px)(?: \1 \1 \1)?$/ );
													value = borderStyle && parseInt( borderStyle[ 1 ], 10 );
													isNaN( parseInt( value, 10 ) ) && ( value = element.getAttribute( 'border' ) );
													this.setValue( value );
												}
											},
											commit: function( type, element, internalCommit ) {
												var value = parseInt( this.getValue(), 10 );
												if ( type == IMAGE || type == PREVIEW ) {
													if ( !isNaN( value ) ) {
														element.setStyle( 'border-width', CKEDITOR.tools.cssLength( value ) );
														element.setStyle( 'border-style', 'solid' );
													} else if ( !value && this.isChanged() )
														element.removeStyle( 'border' );

													if ( !internalCommit && type == IMAGE )
														element.removeAttribute( 'border' );
												} else if ( type == CLEANUP ) {
													element.removeAttribute( 'border' );
													element.removeStyle( 'border-width' );
													element.removeStyle( 'border-style' );
													element.removeStyle( 'border-color' );
												}
											}
										}
									]
								},
								{
									type: 'hbox',
									widths: ['5%','95%'],
									children: [
										{
											id: 'ratioLock',
											type: 'html',
											style: 'margin-top:17px;width:' + (CKEDITOR.env.hc ? '90px' : '20px') + ';height:50px;',
											onLoad: function() {
												// Activate Reset button
												var resetButton = CKEDITOR.document.getById( btnResetSizeId ),
													ratioButton = CKEDITOR.document.getById( btnLockSizesId );
												if ( resetButton ) {
													resetButton.on( 'click', function( evt ) {
														resetSize( this );
														evt.data && evt.data.preventDefault();
													}, this.getDialog() );
													resetButton.on( 'mouseover', function() {
														this.addClass( 'cke_btn_over' );
													}, resetButton );
													resetButton.on( 'mouseout', function() {
														this.removeClass( 'cke_btn_over' );
													}, resetButton );
												}
												// Activate (Un)LockRatio button
												if ( ratioButton ) {
													ratioButton.on( 'click', function( evt ) {
														var locked = switchLockRatio( this ),
															oImageOriginal = this.originalElement,
															width = this.getValueOf( 'info', 'txtWidth' );

														if ( oImageOriginal.getCustomData( 'isReady' ) == 'true' && width ) {
															var height = oImageOriginal.$.height / oImageOriginal.$.width * width;
															if ( !isNaN( height ) ) {
																this.setValueOf( 'info', 'txtHeight', Math.round( height ) );
																updatePreview( this );
															}
														}
														evt.data && evt.data.preventDefault();
													}, this.getDialog() );
													ratioButton.on( 'mouseover', function() {
														this.addClass( 'cke_btn_over' );
													}, ratioButton );
													ratioButton.on( 'mouseout', function() {
														this.removeClass( 'cke_btn_over' );
													}, ratioButton );
												}
											},
											html: '<div>' +
											'<a href="javascript:void(0)" tabindex="-1" title="' + editor.lang.ibmuploadimage.lockRatio +
											'" class="cke_btn_locked" id="' + btnLockSizesId + '" role="checkbox"><span class="cke_icon"></span><span class="cke_label">' + editor.lang.ibmuploadimage.lockRatio + '</span></a>' +
											'<a href="javascript:void(0)" tabindex="-1" title="' + editor.lang.ibmuploadimage.resetSize +
											'" class="cke_btn_reset" id="' + btnResetSizeId + '" role="button"><span class="cke_label">' + editor.lang.ibmuploadimage.resetSize + '</span></a>' +
											'</div>'
										},
										{
											type: 'html',
											id: 'htmlPreview',
											style: 'width:100%;',
											html: (function(){
												var html = '<div>' + CKEDITOR.tools.htmlEncode( editor.lang.common.preview ) + '<br>' +
													'<div id="' + imagePreviewLoaderId + '" class="ImagePreviewLoader" style="display:none"><div class="loading">&nbsp;</div></div>' +
													'<div class="ImagePreviewBox"><table><tr><td>' +
													'<a href="javascript:void(0)" target="_blank" onclick="return false;" id="' + previewLinkId + '">' +
													'<img id="' + previewImageId + '" alt="" /></a>';
												for(var i=0; i<15;i++){
													html += editor.lang.ibmuploadimage.ibm.previewText;
												}
												html += '</td></tr></table></div></div>';
												return html;
											})()
										}
									]
								}
							]
						}
					]
				}
			],
			buttons: [
				{
					type: 'hbox',
					id:'progressButton',
					children: [
						{
							id: 'progress',
							type: 'html',
							html:'<div style="float:left;padding-right: 60px;padding-top: 15px;" aria-live="polite" role="presentation"><img src="'+CKEDITOR.getUrl( CKEDITOR.plugins.get( 'ibmuploadimage' ).path + 'images/loading.gif' )+'" alt="'+editor.lang.ibmuploadimage.ibm.inserting+'"> '+editor.lang.ibmuploadimage.ibm.inserting+'</div>',
							onLoad: function() {
								this.getElement().setStyle("visibility","hidden");
							}
						}
					]
				},
				{
					id: 'ok',
					type: 'button',
					label: editor.lang.ibmuploadimage.ibm.insertButtonLabel,
					title: editor.lang.ibmuploadimage.ibm.insertTitle,
					'class': 'cke_dialog_ui_button_ok',
					onClick: function( evt ) {
						var dialog = evt.data.dialog;
						var valid = true;
						var loadingImage = dialog.getButton('progressButton').getChild(0).getElement();
						if(dialog.definition.dialog._.currentTabId=="Upload"){
							
							valid = validate(dialog);

							if( valid ){								
								if(!dialog.imageEditMode)
									dialog.getButton('progressButton').getChild(0).getElement().setStyle("visibility","visible");
								
								uploadImage(editor, dialog,setUrlAndFireOkId);
								
							}
						}else{
							if(!dialog.imageEditMode && dialog.definition.dialog._.currentTabId=='Upload')
								dialog.getButton('progressButton').getChild(0).getElement().setStyle("visibility","visible");
							if ( dialog.fire( 'ok', { hide: true } ).hide !== false ){
								dialog.getButton('progressButton').getChild(0).getElement().setStyle("visibility","hidden");
								dialog.hide();
							}
						}
					}
				},
				CKEDITOR.dialog.cancelButton
			]
		};
	};

	CKEDITOR.dialog.add( 'ibmuploadimage', function( editor ) {
		return imageDialog( editor, 'image' );
	} );

	CKEDITOR.dialog.add( 'imagebutton', function( editor ) {
		return imageDialog( editor, 'imagebutton' );
	} );
} )();

