/*Copyright IBM Corp. 2010-2014 All Rights Reserved.*/
CKEDITOR.dialog.add('permanentpen',	function(editor) {
	
	function styleMatch(oldStyleObj, newStyleObj){
		if (Object.keys) {
			var keys1 = Object.keys(oldStyleObj);
			var keys2 = Object.keys(newStyleObj);
			
			if (keys1.length != keys2.length){ //match keys size
				return false;
			}
		}
		for(var p in oldStyleObj){
	         if('undefined' !== typeof newStyleObj[p]){
	        	 if(p == 'textColor' || p == 'bgColor'){
            		 oldStyleObj[p] = CKEDITOR.tools.convertRgbToHex(oldStyleObj[p]);
            		 newStyleObj[p] = CKEDITOR.tools.convertRgbToHex(newStyleObj[p]);
            	 }
	             if(oldStyleObj[p] !== newStyleObj[p]){
	                 return false;
	             }
	         }
	         else{
	        	 return false;
	         }
	     }
	     return true;
	}
	
	var names = editor.config.fontSize_sizes.split( ';' );
	
	var fontSizeOptions = [[ editor.lang.common.notSet, '' ]];
	for ( var i = 0 ; i < names.length ; i++ )
	{
		var parts = names[ i ];
		if ( parts ) 
		{
			var nameValue = parts.split( '/' );
			fontSizeOptions.push(nameValue);
		}
	}
	
	var font_names = editor.config.font_names.split( ';' );
	
	var fontNameOptions = [[ editor.lang.common.notSet, '' ]];
	for ( var i = 0 ; i < font_names.length ; i++ )
	{
		var parts = font_names[ i ];
		if ( parts ) 
		{
			var nameValue = parts.split( '/' );
			fontNameOptions.push(nameValue);
		}
	}
	
	// A 2D array containing the colours in editor.lang.colors object. The colour value is run
	// through the browsers style to transform it into its native format. This eliminates
	// having to convert colour values to compare with browser styles later on.
	var listColors = function() {
		var lang = editor.lang,
			colors = lang.colorbutton.colors,
			colorsArray = [[lang.common.notSet, '']];
			div = CKEDITOR.document.createElement('div');

		for (var colorValue in colors) {

			// Convert the colour value into the browser's format.
			div.setStyle('color', '#' + colorValue)
			colorsArray.push([colors[colorValue], div.getStyle('color')]);
		}

		// Return the array sorted by the colour label.
		return colorsArray.sort(function(a, b) {return a[0] > b[0]});
	}();
	
	//convert a rgb color value to hex so that all color values display in the same format on the color dialog
	function colorToHex(rgbColor)
	{
	    var colorParts = rgbColor.substring(4, rgbColor.length - 1).split(',');

		if( colorParts[0] >= 0 && colorParts[0] <= 255 && colorParts[1] >= 0 && colorParts[1] <= 255
				&& colorParts[2] >= 0 && colorParts[2] <= 255){

			var red = parseInt(colorParts[0]).toString(16);
			if (red == '0'){
				red = '00';
			}

			var green = parseInt(colorParts[1]).toString(16);
			if (green == '0'){
				green = '00';
			}

			var blue = parseInt(colorParts[2]).toString(16);
			if (blue == '0') {
				blue = '00';
			}

			return '#' + red + green + blue;
		} else
			return false;
	}
	
	// Set the selected colour in an CKEDITOR.ui.dialog.select object.
	var setColorInList = function(selectObj, browserColor) {
		browserColor = browserColor.toLowerCase();
		var browserColorHex;

		// Attempt to convert to Hex
		if(browserColor.substring(0,3) == 'rgb') {
			browserColorHex = colorToHex(browserColor);
		} else if (browserColor.substring(0,1) == '#' && browserColor.length == 4){
			browserColorHex = convertTo6DigitHex(browserColor);
		}

		var selectElement = (selectObj == null) ? this : selectObj;
		var select = selectElement.getInputElement().$;
			for (var i = select.length; i--;) {
				var listOption = select.options[i].value.toLowerCase();

				if (listOption === browserColor ||
					listOption === browserColorHex ||
					colorToHex(listOption) === browserColor) {
					
						select.options[i].selected = 'selected';
						break;
				}
			}

			// If the colour did not exist in the list add it.
			if (i == -1) {
				selectElement.add(browserColor, browserColor);
				select.options[select.length - 1].selected = 'selected';
		}
	};

	//set up generated ids for the 2 color swatches
	var bgColorSwatchId = CKEDITOR.tools.getNextId() + '_' + 'bgcolorswatch',
		colorSwatchId = CKEDITOR.tools.getNextId() + '_' + 'textcolorswatch',
		swatchStyle = "border: 1px solid #A0A0A0; height: 20px; width: 20px;";
	
	// Apply the selected colour to the color swatch
	var setColorSwatch = function(colorValue, swatchId) {

		//If not a valid RGB or Hex color and value contains a space e.g. a complex color, then reset it.
		if ((!(colorValue.substring(0,3) == 'rgb' && colorValue.length <= 18) && 	//rgb color values will be 18 chars at most - rgb(RRR, GGG, BBB)
			!(colorValue.substring(0,1) == '#' && colorValue.length <= 7)) && 		//hex color values will be 7 chars at most - #RRGGBB
			colorValue.indexOf(' ') >= 0){	
				colorValue = ''; 
		}

		if (colorValue)
				CKEDITOR.document.getById( swatchId).setStyle( 'background-color', colorValue);
			else
				CKEDITOR.document.getById( swatchId ).removeStyle( 'background-color' );
	};
	/* function used to pass the current color value through to the color picker dialog and display it in the current color text field and swatch */
	function setDialogValue( dialogName, callback )
	{
		var onShow = function()
		{
			releaseHandlers( this );
			callback( this, this._.parentDialog );
		};
		var releaseHandlers = function( dialog )
		{
			dialog.removeListener( 'show', onShow );
		};
		var bindToDialog = function( dialog )
		{
			dialog.on( 'show', onShow );
		};
		if ( editor._.storedDialogs.colordialog )
			bindToDialog( editor._.storedDialogs.colordialog );
		else
		{
			CKEDITOR.on( 'dialogDefinition', function( e )
			{
				if ( e.data.name != dialogName )
					return;

				var definition = e.data.definition;

				e.removeListener();
				definition.onLoad = CKEDITOR.tools.override( definition.onLoad, function( orginal )
				{
					return function()
					{
						bindToDialog( this );
						definition.onLoad = orginal;
						if ( typeof orginal == 'function' )
							orginal.call( this );
					};
				} );
			});
		}
	}
	return {
		title : editor.lang.ibmpermanentpen.title,
		minWidth : 220,
		minHeight : 50,
		onOk : function()
		{
			this.commitContent();
			editor.config.styleDefined=true;//don't apply permanent pen default style if it was defined through the dialog
			
			var ibmPermanentPenStyle = {
					bgColor: this.getValueOf('info', 'bgColorList'),
					textColor: this.getValueOf('info', 'textColorList'),
					fontName: this.getValueOf('info', 'font'),
					fontSize: this.getValueOf('info', 'size'),
					boldValue: this.getValueOf('info', 'bold'),
					italicValue: this.getValueOf('info', 'italic'),
					underlineValue: this.getValueOf('info', 'underline'),
					strikethroughValue: this.getValueOf('info', 'strikethrough')
			};
			
			//compare styles and trigger the event
			if(editor.config.ibmPermanentPenStyle && !styleMatch(editor.config.ibmPermanentPenStyle, ibmPermanentPenStyle)){
            	editor.fire( 'permanentPenStyleUpdated', ibmPermanentPenStyle, editor );
            }
		},
		onShow : function(){
			this.setupContent();
		},
		contents : 
		[ 
		  {
			id : 'info',
			label : editor.lang.ibmpermanentpen.title,
			elements : 
			[ 
			  {
				type : 'vbox',
				widths : [ '40%', '5%', '40%' ],
				children : 
				[ 
					{
						type : 'hbox',
						children :	
						[
							{
								type : 'select',
								id : 'font',
								style: 'width : 100%;',
								label : editor.lang.ibmpermanentpen.font,
								items : fontNameOptions,
								requiredContent: 'span{font-family}',
								setup: function() {
							    	this.setValue(editor.config.fontName);
								},
							    commit : function()
								{
							    	editor.config.fontName = this.getValue();
								}
							},
							{
								type : 'select',
								id : 'size',
								style: 'width : 100%;',
								label : editor.lang.ibmpermanentpen.size,
								items : fontSizeOptions,
								requiredContent: 'span{font-size}',
								setup: function() {
							    	this.setValue(editor.config.fontSize);
								},
							    commit : function()
								{
							    	editor.config.fontSize = this.getValue();
								}
							}
						]	
				   },
				   {
						type : 'hbox',
						children :	
						[
							{
								type: 'checkbox',
							    id: 'bold',
							    label: editor.lang.ibmpermanentpen.bold,
							    requiredContent: ['strong','b'],
							    setup: function() {
							    	this.setValue(editor.config.boldValue);
								},
							    commit : function()
								{
							    	editor.config.boldValue = this.getValue();
								}
							},
							{
								type: 'checkbox',
							    id: 'italic',
							    requiredContent: ['em','i'],
							    label: editor.lang.ibmpermanentpen.italic,
							    setup: function() {
							    	this.setValue(editor.config.italicValue);
								},
							    commit : function()
								{
							    	editor.config.italicValue = this.getValue();
								}
							},
							{
								type: 'checkbox',
							    id: 'underline',
							    requiredContent: 'u',
							    label: editor.lang.ibmpermanentpen.underline,
						    	setup: function() {
							    	this.setValue(editor.config.underlineValue);
								},
							    commit : function()
								{
							    	editor.config.underlineValue = this.getValue();
								}
							},
							{
								type: 'checkbox',
							    id: 'strikethrough',
							    requiredContent: 's',
							    label: editor.lang.ibmpermanentpen.strikethrough,
							    setup: function() {
							    	this.setValue(editor.config.strikethroughValue);
								},
							    commit : function()
								{
							    	editor.config.strikethroughValue = this.getValue();
								}
							} 
						]	
				   },
				  {
					type : 'vbox',
					padding : 0,
					requiredContent: 'span{color}',
					children : 
					[
						{
							type : 'hbox',
							widths : [ '70%', '5%', '25%' ],
							children : [
								{
									type: 'select',
									id: 'textColorList',
									items: listColors,
									label: editor.lang.ibmpermanentpen.textcolor,
									style: 'width : 100%;',
									onShow : function() {
										if(editor.config.textColor)
											setColorInList.call(this, null, editor.config.textColor);	
									},
									onChange : function (){
										setColorSwatch(this.getValue(), colorSwatchId);
									},
									onKeyUp : function (){
										setColorSwatch(this.getValue(), colorSwatchId);
									},
									commit : function()
									{
										editor.config.textColor = this.getValue();
									}
								},
								{
									type : 'html',
									html : '<div id="' + colorSwatchId + '" style="'+ swatchStyle +'"></div>',
									onLoad : function()
									{
										var swatch = CKEDITOR.document.getById( colorSwatchId );
										if(CKEDITOR.env.hc){
											swatch.hide();
										} else {
											swatch.show();
											swatch.getParent().setStyle( 'vertical-align', 'bottom' );
										}
									}
								},
								{
									type: 'button',
									id: 'textColorToChoose',
									"class": 'colorChooser',
									label: editor.lang.ibmpermanentpen.color,
									onLoad: function() {
										// Stick the element to the bottom (#5587)
										this.getElement().getParent().setStyle( 'vertical-align', 'bottom' );
										if(CKEDITOR.env.hc){
											this.getElement().hide();
										} else {
											this.getElement().show();
											if (this.origOnLoad)
												this.origOnLoad();
						
											this.getElement().getParent().setStyle( 'padding-bottom', '5px' );
										}
									},
									onClick: function() {
										editor.getColorFromDialog( function( color ) {
											if ( color )
												this.getDialog().getContentElement( 'info', 'setTextColor' ).setValue( color );
											this.focus();
										}, this );
										var self = this;
										setDialogValue( 'colordialog', function( colorDialog )
										{
											var currentColor = self.getDialog().getContentElement( 'info', 'textColorList' ).getValue();
											
											if (!currentColor)
												return;
											
											if(currentColor.substring(0,3) == 'rgb') {
												currentColor = colorToHex(currentColor);
											} else if (currentColor.substring(0,1) == '#' && currentColor.length == 4){
												currentColor = convertTo6DigitHex(currentColor);
											}
											
											if (currentColor)
												colorDialog.getContentElement( 'picker', 'currentColor' ).setValue(currentColor);
										});
									}
								},
								{
									type: 'text',
									id: 'setTextColor',
									style: 'display : none;',// always hidden
									'default': '',
									onChange : function(){
										if (this.origOnChange)
											this.origOnChange(element);
										
										var colorValue = this.getValue();
										
										//Check if the submitted value is a valid color
										var div = CKEDITOR.document.createElement('div');
										div.setStyle('color', colorValue);
										var browserColor = div.getStyle('color');
										
										if (!browserColor) {	//invalid color - select <not set> and reset the color swatch
											colorValue = '';
										}
										setColorInList(this.getDialog().getContentElement('info', 'textColorList' ), colorValue);				
										setColorSwatch(colorValue, colorSwatchId);
									},
									setup: function() {
										this.getElement().hide();
										setColorSwatch(editor.config.textColor, colorSwatchId);
									}
								}
							]
						},
						{
							type : 'hbox',
							widths : ['70%', '5%', '25%' ],
							requiredContent: 'span{background-color}',
							children :
							[
								{
									type: 'select',
									id: 'bgColorList',
									label: editor.lang.ibmpermanentpen.background,
									items : listColors,
									style : 'width : 100%;',
									onShow : function() {
										if(editor.config.bgColor)
											setColorInList.call(this, null, editor.config.bgColor);	
									},
									onChange : function (element){
										setColorSwatch(this.getValue(), bgColorSwatchId);
									},
									onKeyUp : function (){
										setColorSwatch(this.getValue(), bgColorSwatchId);
									},
									commit : function()
									{
										editor.config.bgColor = this.getValue();
									}
								},
								{
									type : 'html',
									html : '<div id="' + bgColorSwatchId + '" style="'+ swatchStyle +'"></div>',
									onLoad : function()
									{
										var swatch = CKEDITOR.document.getById( bgColorSwatchId );
										if(CKEDITOR.env.hc){
											swatch.hide();
										} else {
											swatch.show();
											swatch.getParent().setStyle( 'vertical-align', 'bottom' );
										}
									}
								},
								{
									type: 'button',
									id: 'bgColorChoose',
									"class": 'colorChooser',
									label: editor.lang.ibmpermanentpen.color,
									onLoad: function() {
										
										if(CKEDITOR.env.hc){
											this.getElement().hide();
										} else {
											this.getElement().show();
											// Stick the element to the bottom (#5587)
											this.getElement().getParent().setStyle( 'vertical-align', 'bottom' );
											this.getElement().getParent().setStyle( 'padding-bottom', '5px' );
										}
									},
									onClick: function() {
										editor.getColorFromDialog( function( color ) {
											if ( color ){
												this.getDialog().getContentElement( 'info', 'bgColor' ).setValue( color );
											}
											this.focus();
										}, this );
										var self = this;
										setDialogValue( 'colordialog', function( colorDialog )
										{
											var currentColor = self.getDialog().getContentElement( 'info', 'bgColorList' ).getValue();
											
											if (!currentColor)
												return;
											
											if(currentColor.substring(0,3) == 'rgb') {
												currentColor = colorToHex(currentColor);
											} else if (currentColor.substring(0,1) == '#' && currentColor.length == 4){
												currentColor = convertTo6DigitHex(currentColor);
											}
											
											if (currentColor)
												colorDialog.getContentElement( 'picker', 'currentColor' ).setValue(currentColor);
										});
									}
								},
								{
									type: 'text',
									id: 'bgColor',
									style: 'display : none;',// always hidden
									'default': '',
									onChange : function(){
										var colorValue = this.getValue();
										
										//Check if the submitted value is a valid color
										var div = CKEDITOR.document.createElement('div');
										div.setStyle('background-color', colorValue);
										var browserColor = div.getStyle('background-color');
										
										if (!browserColor) {	//invalid color - select <not set> and reset the color swatch
											colorValue = '';
										}
										setColorInList(this.getDialog().getContentElement('info', 'bgColorList' ), colorValue);				
										setColorSwatch(colorValue, bgColorSwatchId);
									},
									setup: function() {
										this.getElement().hide();
										setColorSwatch(editor.config.bgColor, bgColorSwatchId);
									}
								}
							]
						}
					]
				  } 
			  ]
		  } 
	  ]
  } 
  ]
};
});