/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,
{
	a11yHelp : function(dialogDefinition, editor)
	{

	
	if ('a11yHelp' !== dialogDefinition.dialog.getName())
		{
			return;
		}

		var infoTab = dialogDefinition.getContents( 'info' );
		var legends = infoTab.get('legends');
		var html = legends.html;
		
	dialogDefinition.onShow = function(){
			
			//add the ibmHelpDocumentationUrl class to the span too so that it can be styled
			var helpButton = this.getContentElement('info', 'ibmHelp').getInputElement();
			if (helpButton.getChildCount() > 0 && helpButton.getChild(0).getName() == 'span'){
				helpButton.getChild(0).addClass('ibmHelpDocumentationUrl');
			}
			
			this.setupContent();
		}
	
		var url = editor.config.ibmHelpDocumentationUrl ? editor.config.ibmHelpDocumentationUrl() : '';
		var descriptionID = CKEDITOR.tools.getNextId() + '_helpLinkDescription';
		
		infoTab.elements =
		[
			{
				type : 'vbox',
				widths : ['35%', '65%'],
				children :
				[
					{
						type : 'vbox',
						style :  url ? '' : 'display: none;',
						children :
						[
							{
								type : 'button',
								className : 'ibmHelpDocumentationUrl',
								id : 'ibmHelp',
								label : editor.lang.a11yhelp.ibm.helpLink,
								onClick : function()
								{
									var h = Math.max(window.screen.height / 4, 800);
									var w = Math.max(window.screen.width / 4, 800);
									var options = "height="+h+",width="+w+",status=yes,toolbar=yes,menubar=no,location=no,scrollbars=yes,resizable=yes";
							        window.open(url, "helpWindow", options).focus();
								},
								setup : function()
								{
									var dir = editor.config.contentsLangDirection;
									this.getElement().getParent().setStyle('text-align', dir == 'rtl' ? 'left' : 'right');
									var descriptionField = dialogDefinition.dialog.getContentElement('info', descriptionID);
									this.getInputElement().setAttribute('aria-describedby', descriptionField.domId);
								}
							},
							{
								type : 'html',
								id : descriptionID,
								html : '<div style="display:none;">'+editor.lang.a11yhelp.ibm.helpLinkDescription+'</div>'							
							},
							{
								type : 'html',
								html : '&nbsp;'
							}
						]
					},
					legends
				]
			}
			
		];		
	}
});
