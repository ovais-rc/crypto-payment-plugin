/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,		
{
	find : function(dialogDefinition, editor)
	{
		if ('find' !== dialogDefinition.dialog.getName() && 'replace' !== dialogDefinition.dialog.getName())
		{
			return;
		}

		/* The dialog's dimensions are set in the skin's skin.js */
		
		/* The Find Tab */
		var findTab = dialogDefinition.getContents('find');

		var textToFind = findTab.get('txtFindFind');
		textToFind.labelLayout = "vertical";		
		
		var matchCase = findTab.get('txtFindCaseChk');
		matchCase.style = "margin-top:0px;";
		
		var matchWord = findTab.get('txtFindWordChk');		
		var matchCyclic = findTab.get('txtFindCyclic');
		
		var findButton = findTab.elements[0].children[1];
		findButton.style = 'margin-left: 5px; display: block;';
		findButton.id = 'findBtn';
		
		/* The Replace Tab */
		var replaceTab = dialogDefinition.getContents('replace');
		replaceTab.hidden = 'true';
		dialogDefinition.dialog.parts.dialog.addClass('cke_single_page');
		
		var buttonStyle = 'margin-left: 5px; margin-top: 8px; display: block;';
		
		var replaceButton = replaceTab.elements[0].children[1];
		replaceButton.style = buttonStyle;
		replaceTab.remove('btnFindReplace');
		
		var replaceAllButton = replaceTab.elements[1].children[1];
		replaceAllButton.style = buttonStyle;
		replaceTab.remove('btnReplaceAll');
		
		var textReplace = replaceTab.get('txtReplace');
		textReplace.labelLayout = "vertical";
		textReplace.style = 'margin-top: 5px';
						
		// Replace button
		var replaceOnClick = replaceButton.onClick;
		replaceButton.onClick = function() {
			var dialog = this.getDialog();
			dialog.setValueOf('replace', 'txtFindReplace', dialog.getValueOf('find', 'txtFindFind'));
			dialog.setValueOf('replace', 'txtReplace', dialog.getValueOf('find', 'txtReplace'));
			dialog.setValueOf('replace', 'txtReplaceCaseChk', dialog.getValueOf('find', 'txtFindCaseChk'));
			dialog.setValueOf('replace', 'txtReplaceWordChk', dialog.getValueOf('find', 'txtFindWordChk'));
			dialog.setValueOf('replace', 'txtReplaceCyclic', dialog.getValueOf('find', 'txtFindCyclic'));
			this.function2();
		};
		replaceButton.function2 = replaceOnClick;
		
		// Replace All button
		var replaceAllOnClick = replaceAllButton.onClick;
		replaceAllButton.onClick = function() {
			var dialog = this.getDialog();
			dialog.setValueOf('replace', 'txtFindReplace', dialog.getValueOf('find', 'txtFindFind'));
			dialog.setValueOf('replace', 'txtReplace', dialog.getValueOf('find', 'txtReplace'));
			dialog.setValueOf('replace', 'txtReplaceCaseChk', dialog.getValueOf('find', 'txtFindCaseChk'));
			dialog.setValueOf('replace', 'txtReplaceWordChk', dialog.getValueOf('find', 'txtFindWordChk'));
			dialog.setValueOf('replace', 'txtReplaceCyclic', dialog.getValueOf('find', 'txtFindCyclic'));
			this.function2();
		};
		replaceAllButton.function2 = replaceAllOnClick;
		
		findTab.style = 'width:100%'; //Overwrite the height 100%;
		findTab.elements = 
		[
			{
				type: 'hbox',
				widths: ['80%', '20%'],
				children: [
					{
						type: 'vbox',
						children: [textToFind, textReplace,
							{
								type : 'fieldset', 
								label : editor.lang.find.findOptions, 
								style : 'margin-top: 8px', 
								children :
								[
									{
										type: 'vbox',
										style: 'margin-top: 8px',
										children: [matchCase, matchWord, matchCyclic]
									}
								]
							}]
					},
					{
						type: 'vbox',
						style: 'margin-top: 2px',
						children: [findButton, replaceButton, replaceAllButton]
					}
				]
			}
		];		
		
		dialogDefinition.buttons=[ CKEDITOR.dialog.cancelButton.override( {
			label: editor.lang.common.close
		})];
		
		// Overwrite onShow() - onShow() in plugins/find/dialogs/find.js adds the replace tab back in. Overwrite it to remove the replace tab again.
		var dialog = dialogDefinition.dialog;
		var findOnShow = dialogDefinition.onShow;		//reference to onShow() in plugins/find/dialogs/find.js
		dialog.function2 = findOnShow;			//add it to the dialog so that it has the correct scope
		
		dialogDefinition.onShow = function() {
			this.function2();	//call original onShow()
			this.hidePage('replace');	//hide the replace tab
		};
	}	
}, true );