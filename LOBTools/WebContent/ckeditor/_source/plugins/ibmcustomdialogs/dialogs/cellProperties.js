/* Copyright IBM Corp. 2010-2014 All Rights Reserved. */
CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs, {

	cellProperties : function(dialogDefinition, editor) {

		if ('cellProperties' !== dialogDefinition.dialog.getName()) {
			return;
		}

		/* The dialog's dimensions are set in the skin's skin.js */

		dialogDefinition.title = editor.lang.table.cell.ibm.title;
		var infoTab = dialogDefinition.getContents('info');

		var widthField = infoTab.get('width');
		var widthUnitsField = infoTab.get('widthType');
		var heightField = infoTab.get('height');
		//var heightUnitsField = infoTab.get('htmlHeightType');

		var wordWrapField = infoTab.get('wordWrap');
		var hAlignField = infoTab.get('hAlign');
		var vAlignField = infoTab.get('vAlign');
		var cellTypeField = infoTab.get('cellType');
		var rowSpanField = infoTab.get('rowSpan');
		var colSpanField = infoTab.get('colSpan');
		var bgColorField = infoTab.get('bgColor');
		var borderColorField = infoTab.get('borderColor');
		var bgColorChooseButton = infoTab.get('bgColorChoose');
		var borderColorChooseButton = infoTab.get('borderColorChoose');

		//if the dialog contains any required fields we must re-add the '* Required' label that was already added in ibmcustomdialogs/plugin.js
		var requiredLabel = infoTab.get('requiredLabel') ? infoTab.get('requiredLabel') : {type: 'html', html: ''};

		widthField.labelLayout = null;
		widthField.widths = null;
		widthField.width = null;

		//overwrite setup to use parseFloat instead of parseInt - decimal values should be allowed
		widthField.setup = function( element )
		{
			var widthAttr = parseFloat( element[0].getAttribute( 'width' )),
				widthStyle = parseFloat( element[0].getStyle( 'width' ));

			!isNaN( widthAttr ) && this.setValue( widthAttr );
			!isNaN( widthStyle ) && this.setValue( widthStyle );
		};

		//overwrite commit to use parseFloat instead of parseInt - decimal values should be allowed
		widthField.commit = function( element )
		{
			var value = parseFloat(this.getValue()),
				unit = this.getDialog().getValueOf( 'info', 'widthType' );

			if ( !isNaN( value ) )
				element.setStyle( 'width', value + unit );
			else
				element.removeStyle( 'width' );

			element.removeAttribute( 'width' );
		};

		widthUnitsField.labelLayout = null;
		widthUnitsField.widths = null;
		widthUnitsField.style = this.styleWidth100Pc;
		widthUnitsField.labelStyle = null;

		//add all possible width units to the width unit field
		widthUnitsField.items =
		[
			[editor.lang.table.widthPx, 'px' ],
			[editor.lang.table.widthPc, '%' ],
			[editor.lang.ibm.common.widthIn, 'in'],
			[editor.lang.ibm.common.widthCm, 'cm'],
			[editor.lang.ibm.common.widthMm, 'mm'],
			[editor.lang.ibm.common.widthEm, 'em'],
			[editor.lang.ibm.common.widthEx, 'ex'],
			[editor.lang.ibm.common.widthPt, 'pt'],
			[editor.lang.ibm.common.widthPc, 'pc']
		];

		//overwrite setup to add support for all possible width units
		widthUnitsField.setup = function( selectedCell )
		{
			var widthPattern = /^(\d+(?:\.\d+)?)(px|%|in|cm|mm|em|ex|pt|pc)$/;
				var widthMatch = widthPattern.exec( selectedCell[0].getStyle( 'width' ) || selectedCell[0].getAttribute( 'width' ) );
				if ( widthMatch )
					this.setValue( widthMatch[2] );
		}

		heightField.labelLayout = null;
		heightField.widths = null;
		heightField.width = null;
		delete heightField.onLoad;
		//heightUnitsField.style = this.styleWidth100Pc + 'font-weight: bold;';
		//heightUnitsField.html = '<span><br />' + heightUnitsField.html + '</span>';

		wordWrapField.labelLayout = null;
		wordWrapField.widths = null;
		wordWrapField.style = this.styleWidth100Pc;
		hAlignField.labelLayout = null;
		hAlignField.widths = null;
		hAlignField.style = this.styleWidth100Pc;
		vAlignField.labelLayout = null;
		vAlignField.widths = null;
		vAlignField.style = this.styleWidth100Pc;
		cellTypeField.labelLayout = null;
		cellTypeField.widths = null;
		cellTypeField.style = this.styleWidth100Pc;
		rowSpanField.labelLayout = null;
		rowSpanField.widths = null;
		colSpanField.labelLayout = null;
		colSpanField.widths = null;
		//bgColorField.labelLayout = null;
		//bgColorField.widths = null;
		//borderColorField.labelLayout = null;
		//borderColorField.widths = null;
		borderColorChooseButton.style = '';		//needed to remove a margin styling specified in tableCell.js for borderColorChoose

		//store a reference to the setup function of bgColorField if it exists
		if(bgColorField.setup){
			var bgColorSetup = bgColorField.setup;
			bgColorField.origSetup = bgColorSetup;		//add it to the uiItem so that it has the correct scope
		}

		//overwrite setup to execute origSetup() if it exists and apply the value as the background color for the swatch
		bgColorField.setup = function (element){

				this.getElement().hide();
				if (this.origSetup)
					this.origSetup(element);

				setColorSwatch(this.getValue(), bgColorSwatchId);
		}

		//overwrite commit to do nothing - this field is always hidden and used only to pass the value to the color drop down field. Therefore it's value should not be committed.
		bgColorField.commit = function (element){
		}

		//store a reference to the onChange function of bgColorField if it exists
		if(bgColorField.onChange){
			var bgColorOnChange = bgColorField.onChange;
			bgColorField.origOnChange = bgColorOnChange;		//add it to the uiItem so that it has the correct scope
		}

		//overwrite onChange to execute origOnChange() if it exists and apply the value as the background color for the swatch
		bgColorField.onChange = function (element){

				if (this.origOnChange)
					this.origOnChange(element);

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
		}

		//store a reference to the setup function of borderColorField if it exists
		if(borderColorField.setup){
			var borderColorSetup = borderColorField.setup;
			borderColorField.origSetup = borderColorSetup;
		}

		//overwrite setup to execute origSetup() if it exists and apply the value as the background color for the swatch
		borderColorField.setup = function (element){
				this.getElement().hide();
				if (this.origSetup)
					this.origSetup(element);

				setColorSwatch(this.getValue(), borderColorSwatchId);
		}

		//overwrite commit to do nothing - this field is always hidden and used only to pass the value to the color drop down field. Therefore it's value should not be committed.
		borderColorField.commit = function (element){
		}

		//store a reference to the onChange function of borderColorField if it exists
		if(borderColorField.onChange){
			var borderColorOnChange = borderColorField.onChange;
			borderColorField.origOnChange = borderColorOnChange;
		}

		//overwrite onChange to execute origOnChange() if it exists and apply the value as the background color for the swatch
		borderColorField.onChange = function (element){

				if (this.origOnChange)
					this.origOnChange(element);
				
				var colorValue = this.getValue();
				
				//Check if the submitted value is a valid color
				var div = CKEDITOR.document.createElement('div');
				div.setStyle('border-color', colorValue);
				var browserColor = div.getStyle('border-color');
				
				if (!browserColor) {	//invalid color - select <not set> and reset the color swatch
					colorValue = '';
				}
				setColorInList(this.getDialog().getContentElement('info', 'borderColorList' ), colorValue);				
				setColorSwatch(colorValue, borderColorSwatchId);
		}

		//store a reference to the onLoad function of bgColorChooseButton if it exists
		if(bgColorChooseButton.onLoad){
			var bgColorChooseButtonOnLoad = bgColorChooseButton.onLoad;
			bgColorChooseButton.origOnLoad = bgColorChooseButtonOnLoad;
		}

		//overwrite setup to execute origOnLoad() if it exists
		bgColorChooseButton.onLoad = function (){
			if(CKEDITOR.env.hc){
				this.getElement().hide();
			} else {
				this.getElement().show();
				if (this.origOnLoad)
					this.origOnLoad();
				
				this.getElement().getParent().setStyle( 'padding-bottom', '5px' );
			}
		}

		//store a reference to the onLoad function of borderColorChooseButton if it exists
		if(borderColorChooseButton.onLoad){
			var borderColorChooseButtonOnLoad = borderColorChooseButton.onLoad;
			borderColorChooseButton.origOnLoad = borderColorChooseButtonOnLoad;
		}

		//overwrite setup to execute origOnLoad() if it exists
		borderColorChooseButton.onLoad = function (){
			if(CKEDITOR.env.hc){
				this.getElement().hide();
			} else {
				this.getElement().show();
				if (this.origOnLoad)
					this.origOnLoad();

				this.getElement().getParent().setStyle( 'padding-bottom', '5px' );
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
				div.setStyle('border-color', '#' + colorValue)
				colorsArray.push([colors[colorValue], div.getStyle('border-color')]);
			}

			// Return the array sorted by the colour label.
			return colorsArray.sort(function(a, b) {return a[0] > b[0]});
		}();

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

		// Create a CKEDITOR.ui.dialog.select UI element to display the list of border colours.
		var borderListColor = {
			type: 'select',
			id: 'borderColorList',
			items: listColors,
			label: editor.lang.table.cell.borderColor,
			style: 'width : 100%;',
			setup: function(element) {

				this.getElement().show();

				//get the browser specific color value
				var existingColor = (element[0].getStyle('border-color') || element[0].getAttribute('borderColor'));
				if (existingColor) 	//if a border color has been applied, select it in the drop down
					setColorInList.call(this, null, existingColor);				
			},
			commit: function(selectedCell) {
				var value = this.getValue();
				if (value){
					selectedCell.setStyle('border-color', value);
					selectedCell.setStyle('border-style','solid');
				} else {
					selectedCell.removeStyle('border-color');
				}

				selectedCell.removeAttribute('borderColor');
			},
			onChange : function (){
				setColorSwatch(this.getValue(), borderColorSwatchId);
			},
			onKeyUp : function (){
				setColorSwatch(this.getValue(), borderColorSwatchId);
			}
		};

		// Create a CKEDITOR.ui.dialog.select UI element to display the list of background colours.
		var backgroundListColor = {
			type: 'select',
			id: 'bgColorList',
			label: editor.lang.table.cell.bgColor,
			items : listColors,
			style : 'width : 100%;',
			setup : function(element) {

				this.getElement().show();

				//get the browser specific color value
				var existingColor = (element[0].getStyle('background-color') || element[0].getAttribute('bgColor'));
				if (existingColor) 	//if a background color has been applied, select it in the drop down
					setColorInList.call(this, null, existingColor);

			},
			commit : function(selectedCell) {
				var value = this.getValue();

				if (value) {
					selectedCell.setStyle('background-color', value);
				} else {
					selectedCell.removeStyle('background-color');
				}

				selectedCell.removeAttribute('bgColor');
			},
			onChange : function (element){
				setColorSwatch(this.getValue(), bgColorSwatchId);
			},
			onKeyUp : function (){
				setColorSwatch(this.getValue(), bgColorSwatchId);
			}
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

		//store a reference to the onClick function of bgColorChooseButton
		if(bgColorChooseButton.onClick){
			var bgColorChooseButtonOnClick = bgColorChooseButton.onClick;
			bgColorChooseButton.origOnClick = bgColorChooseButtonOnClick;
		}

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

		function convertTo6DigitHex(color)
		{
		    var red = color.substring(1, 2);
			var green = color.substring(2, 3);
			var blue = color.substring(3);

			return '#' + red + red + green + green + blue + blue;
		}

		//overwrite onClick to execute origOnClick() and then apply the current color to the current color swatch on the color picker dialog
		bgColorChooseButton.onClick = function (){

			if (this.origOnClick)
					this.origOnClick();

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

		//store a reference to the onClick function of borderColorChooseButton
		if(borderColorChooseButton.onClick){
			var borderColorChooseButtonOnClick = borderColorChooseButton.onClick;
			borderColorChooseButton.origOnClick = borderColorChooseButtonOnClick;
		}

		//overwrite onClick to execute origOnClick() and then apply the current color to the current color swatch on the color picker dialog
		borderColorChooseButton.onClick = function (){

			if (this.origOnClick)
					this.origOnClick();

			var self = this;
			setDialogValue( 'colordialog', function( colorDialog )
			{
				var currentColor = self.getDialog().getContentElement( 'info', 'borderColorList' ).getValue();
				
				if (!currentColor)
					return;
				
				if(currentColor.substring(0,3) == 'rgb') {
					currentColor = colorToHex(currentColor);
				} else if (currentColor.substring(0,1) == '#' && currentColor.length == 4){
					currentColor = convertTo6DigitHex(currentColor);
				}
				
				if (currentColor)
					colorDialog.getContentElement( 'picker', 'currentColor' ).setValue(currentColor);
			} );
		}

		//set up generated ids for the 2 color swatches
		var bgColorSwatchId = CKEDITOR.tools.getNextId() + '_' + 'bgcolorswatch',
			borderColorSwatchId = CKEDITOR.tools.getNextId() + '_' + 'bordercolorswatch',
			swatchStyle = "border: 1px solid #A0A0A0; height: 20px; width: 20px;";

		infoTab.style = 'width:100%'; //Overwrite the height 100%;
		infoTab.elements = [
			{
				type: 'hbox',
				children: [widthField, widthUnitsField]
			},
			{
				type: 'hbox',
				children: [
					heightField,
					{
						type: 'select',
						id: 'heightType',
						style: this.styleWidth100Pc,
						label: editor.lang.table.ibm.heightUnit,
						'default': 'px',
						items: [[editor.lang.table.widthPx, 'px']],
						setup: function(selectedCell) {

							if ('' === selectedCell[0].$.style.height) {
									return;
							}

							var match = /^(\d+(?:\.\d+)?)px$/.exec(selectedCell[0].$.style.height);
							if (match) {
								this.setValue('px');
							}
						}
					}
				]
			},
			{
				type : 'hbox',
				children : [hAlignField, vAlignField]
			},
			{
				type : 'hbox',
				children : [wordWrapField, cellTypeField]
			},
			{
				type : 'hbox',
				children : [rowSpanField, colSpanField]
			},
			{
				type : 'hbox',
				widths : ['70%', '5%', '25%' ],
				children :
				[
					backgroundListColor,
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
					bgColorChooseButton,
					bgColorField			//always hidden
				]
			},
			{
				type : 'hbox',
				widths : [ '70%', '5%', '25%' ],
				children : [
					borderListColor,
					{
						type : 'html',
						html : '<div id="' + borderColorSwatchId + '" style="'+ swatchStyle +'"></div>',
						onLoad : function()
						{
							var swatch = CKEDITOR.document.getById( borderColorSwatchId );
							if(CKEDITOR.env.hc){
								swatch.hide();
							} else {
								swatch.show();
								swatch.getParent().setStyle( 'vertical-align', 'bottom' );
							}
						}
					},
					borderColorChooseButton,
					borderColorField		//always hidden
				]
			},
			requiredLabel
		];
	}
}, true );