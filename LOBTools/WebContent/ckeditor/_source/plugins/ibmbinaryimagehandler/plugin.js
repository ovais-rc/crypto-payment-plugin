/*Copyright IBM Corp. 2010-2014 All Rights Reserved. */
/**
 * @class ibmbinaryimagehandler This plugin handles pasting/drag-and-drop of binary images into the editor. 
 * The editor will intercept the paste/drop operation and detect whether the pasted content contains a data URI image. 
 * If so, plugin will extract that binary content and send it to a image upload service, which needs to be provided/implemented by each product.
 * This image upload service will decode the binary image data and save the image as a file on the server side. A url to the image will then be sent back to CKEditor.
 * The image url will then be inserted into the CKEditor content.
 * 
 * Why to use this plugin:
 * 
 * - The resulting image will display when the document is opened in any browser. Where if the binary image data left in the content, 
 * the image would only display in browsers that support binary images.
 * - The size of user generated content is massively reduced.
 * - Images can be cached and reused for performance improvement.

 * **NOTE:**
 *  
 * - Each product will need to implement the backend support to expose this feature.
 * 
 * - This plugin can only detect that a binary image has been pasted into the rich text editor 
 * if the underlying browser supports it and exposes this information to the editor, please refer to the **Table 1** below for more information.
 * 
 * {@img table.png}
 * 
 */
CKEDITOR.plugins.add('ibmbinaryimagehandler', {
	lang: 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
	init : function(editor)	{
	
		var imgRexExp = /<img[^>]*>/i;

		// test that config.ibmBinaryImageUploadUrl is not empty and not whitespace or config.ibmPublishBinaryData defined
		if((/\S/.test(editor.config.ibmBinaryImageUploadUrl) || editor.config.ibmPublishBinaryData) && !editor.config.ibmFilterPastedDataUriImage) {
		
			//add a hidden iframe to the document which will be used to post the image data uri
			var iframe = document.createElement('iframe');
			iframe.style.display = 'none';
			document.body.appendChild(iframe);

			/**
			 * @method
			 * Concatenate required parameters to the url.
			 * 
			 * @param url the url to update
			 * @param params parameters to add
			 * 
			 * @ignore
			 */
			function addQueryString( url, params ) {
				var queryString = [];

				if ( !params )
					return url;
				else {
					for ( var i in params )
						queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
				}
				return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
			}
			
			/**
			 * @method
			 * Process binary images from the drop event.
			 * 
			 * @param file drop event data
			 * 
			 * @ignore
			 */
			function setup_reader(file) {
				if (file.type.match('image.*')) {
					var reader = new FileReader();
					reader.onload = function(){
						_html = reader.result;
						if(_html != null) {
							editor.fire( 'paste', { size: file.size, type: file.type, name: file.name, dataValue: "<img src=\""+_html +"\">"});
						}
					};
					reader.readAsDataURL(file);
				}
			}
				
			/**
			 * @method
			 * Callback function which will be invoked when the server responds with an array of objects (for each pasted image).
			 * 
			 * 	Response format: <script type="text/javascript">window.parent.CKEDITOR.tools.callFunction(Callback function number, [urlObj1, urlObj1], '');</script>
			 * 	where
			 * 			Callback function number: function number as indicated by CKEditor
			 * 			urlObj1: [id,'http://serverip/image.png']
			 * 			urlObj2: [id,'http://serverip/image2.png']
			 * 
			 * @ignore
			 */
			var insertImageURL = CKEDITOR.tools.addFunction( function(arrayOfUrlObjects, errorMsg) {
					if (arrayOfUrlObjects){			
						//for each url get an element by id and replace the binary content with a new url.
						for (var i=0; i< arrayOfUrlObjects.length; i++){
							var urlObject = arrayOfUrlObjects[i];
							var id = urlObject.id;
							var url = urlObject.url;
							
							//get image by id
							var image = editor.document.getById(id);
							if(image) {
								image.setAttribute('src', url);
								image.setAttribute('data-cke-saved-src', url);
							}
						}

						editor.fire( 'updateSnapshot' );
					}
				}, this );
			
			/**
			 * @method
			 * Callback function which will be invoked when the server responds with an array containing ids of images to be deleted
			 * 
			 * 	Response format: <script type="text/javascript">window.parent.CKEDITOR.tools.callFunction(Callback function number, ['id1', 'id2'], '');</script>
			 * 	where
			 * 			Callback function number: function number as indicated by CKEditor
			 * 
			 * @ignore
			 */
			var deleteImages = CKEDITOR.tools.addFunction( function(ids, errorMsg) {
					if (ids){			
						//for each id get an element by id and delete it
						for (var i=0; i< ids.length; i++){
							var id = ids[i];
							
							//get image by id
							var image = editor.document.getById(id);
							if(image) {
								//delete image from the page
								image.remove();
							}
						}

						editor.fire( 'updateSnapshot' );
					}
				}, this );
			
				
			//Remove the iframe and the callback funtion when the editor is destroyed
			editor.on('destroy', function(){
				document.body.removeChild(iframe);
			});
		
			// Add a paste event listener to get data uri images from pasted content
			editor.on('paste', function(evt) {
				
				var isDataURIImageRegex = /<img[^>]+src=["']{1}(data:image\/(?:(?!["'])[\w\W])*)["']{1}[^>]*[\/]?>/gi;
				
				var srcRegex = /src=["']data:image\/[^('|")]*["']/i,
					_html = evt.data.dataValue,	
					cd = CKEDITOR.env.ie ? iframe.contentWindow.document : iframe.contentDocument;

				if (isDataURIImageRegex.test(_html)){
				
					var timestamp = new Date().getTime();
					var params = {};
					if(editor.config.ibmBinaryImageUploadUrl) {
						//Create a form that will be used to post the binary image data
						var form = document.createElement('form');
						form.enctype ="multipart/form-data";
						form.method = "POST";
						
						//setup params that need to be passed with the POST request
						params.CKEditor = editor.name;
						params.CKEditorFuncNum = insertImageURL; 	//callback function that need to be invoked by the response
						params.CKEditorDeleteFuncNum = deleteImages;
						params.Timestamp = timestamp;
						params.idMapping = [];
					}	
															
					var dataUriImages = _html.match(isDataURIImageRegex);
					
					var binaryDataArray = [];
					
					for (var i=0; i<dataUriImages.length; i++){
						//generate an id
						var id = timestamp+'_'+i;
						//get the src attribute and value
						var binarySrc = dataUriImages[i].match(srcRegex);	
						_html = _html.replace(dataUriImages[i], dataUriImages[i].replace('<img','<img id="'+ id + '"'));
						
						if(editor.config.ibmPublishBinaryData){
							//setup params that need to be passed to the backend
							var imageObj=new Object();
							imageObj.data=binarySrc;
							if(evt.data.name){//get image name, type and size only for drag&drop event
								imageObj.name=evt.data.name;
								if(evt.data.size)
									imageObj.size=evt.data.size;
								if(evt.data.type)
									imageObj.type=evt.data.type;
							}
							imageObj.id=id;
						}
						else{
							var name = "imageUri"+i;
							params.idMapping.push('"'+name+'":"'+id+'"');
							form.innerHTML += '<input type="text" name="'+name+'" value='+binarySrc+'>';
						}	

						//create an array of binary data
						binaryDataArray.push(imageObj);
					}

					if(editor.config.ibmPublishBinaryData){
						editor.config.ibmPublishBinaryData(insertImageURL, deleteImages, editor.name, binaryDataArray);//post the binary image data
					}	
					else{
						form.action = addQueryString( editor.config.ibmBinaryImageUploadUrl, params );
						cd.body.appendChild(form);
						form.submit();	//post the binary image data
					}	
					
					evt.data.dataValue = _html;			//let the paste event continue		
				}
			});
		
			// Add a contentDom event listener to register a drop event each time the document is recreated
			editor.on('contentDom', function(evt) {
				if(CKEDITOR.env.webkit) {
					editor.document.on('paste', function(evt) {
						// Get the items from the clipboard
			      		var items = evt.data.$.clipboardData.items;
			      		if (items) {
			         		// Loop through all items, looking for images
			         		for (var i = 0; i < items.length; i++) {
			         			if(items[i].type.indexOf("text/rtf") !== -1 || items[i].type.indexOf("application/rtf") !== -1 || items[i].type.indexOf("application/x-rtf") !== -1){
			         				break;// we dont support pasting of images from MS Word/Wordpad/pdf(Adobe Reader XI), work item #75363
			         			}
			            		if (items[i].type.indexOf("image") !== -1) {
			               			var file = items[i].getAsFile();// Get image as a file
			               			evt.data.$.preventDefault();
			               			setup_reader(file);
			            		}
			         		}
		         		}
					});
				}
				// Add a drop event listener to cancel the drop event if the content contains data uri images
				evt.editor.document.on('drop', function (evt) {
					var type = CKEDITOR.env.ie ? 'url' : 'text/html';
					var _html = CKEDITOR.env.ie ? "<img src=\""+evt.data.$.dataTransfer.getData(type) +"\">" : evt.data.$.dataTransfer.getData(type);
					if(CKEDITOR.env.mac){
						//image dragged from the web page
						if(/\S/.test(evt.data.$.dataTransfer.getData('url')))
							_html = "<img src=\""+evt.data.$.dataTransfer.getData('url') +"\">";
						else
							_html = evt.data.$.dataTransfer.getData('text/html');//image from the file system
					}
					var isDataURIImageRegex = /<img[^>]+src=["']{1}(data:image\/(?:(?!["'])[\w\W])*)["']{1}[^>]*[\/]?>/gi;
					if(imgRexExp.test(_html) && isDataURIImageRegex.test(_html)) {//check if image has href://
						// Cannot modify the dataTransfer data on drop, so will call paste event instead to create the url for the binary image.
						evt.data.$.preventDefault();
						editor.fire( 'paste', { dataValue: _html});
					}
					else if (evt.data.$.dataTransfer.files.length > 0) {
						// Cannot modify the dataTransfer data on drop, so will call paste event instead to create the url for the binary image.
						evt.data.$.preventDefault();

						var files = evt.data.$.dataTransfer.files;
						for (var i = 0; i < files.length; i++) {
							var file = files[i];
							if (file.type.match('image.*')) {
								setup_reader(files[i]);
							}
						}
					}
				});
			}); 
		}
	}
});