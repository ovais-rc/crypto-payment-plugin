/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

/**	@fileOverview Plugin to create new ibm toolbars and drop down menus used in the ibm toolbars.
 *	
 *	This plugin also adds the ability to create command button menus by specifing the
 *	definitions in a config file. The following configuration creates two menus,
 *	MenuLink and MenuPaste.
 *	
 *	config.menus = 
 *	{
 *		link :
 *		{
 *			buttonClass : 'cke_button_link',
 *			commands : ['urllink'],
 *			label : link.title
 *		},
 *		paste :
 *		{
 *			buttonClass : 'cke_button_paste',
 *			commands : ['paste', 'pastetext', 'pastefromword']
 *		}			
 *	};
 *	
 *	The menus will contain buttons for each command listed in the commands property. The
 *	label property should contain the name of a language object in the language file.
 *	The string 'link.title' will reference the string returned by editor.lang.link.title;
 *	If the label property is omitted the language property editor.lang.ibm.menu.<name> will
 *	be used, where <name> is the menu definition property name.	
 */
 	CKEDITOR.plugins.add('ibmtoolbars',
	{
		lang: 'ar,ca,cs,da,de,el,en,es,fi,fr,he,hr,hu,it,iw,ja,kk,ko,nb,nl,no,pl,pt,pt-br,ro,ru,sk,sl,sv,th,tr,uk,zh,zh-cn,zh-tw',
		requires : ['menubutton', 'toolbar'],
		init : function( editor )
		{
			//Listen for Shift+Alt+i / Shift+Alt+o keystrokes in order to indent/outdent paragraph
			editor.config.blockedKeystrokes.push(CKEDITOR.SHIFT + CKEDITOR.ALT + 73);
			editor.config.blockedKeystrokes.push(CKEDITOR.SHIFT + CKEDITOR.ALT + 79);
			editor.setKeystroke( CKEDITOR.SHIFT + CKEDITOR.ALT + 73 /*i*/, 'indent' );
			editor.setKeystroke( CKEDITOR.SHIFT + CKEDITOR.ALT + 79 /*o*/, 'outdent' );
			
			//only support floating toolbar if the ibmFloatToolbar config option is true. Do not support for quirks mode (position:fixed does not work on these browsers). Do not support in inline mode - the floatingspace plugin provides similar functionality for inline editors.
			if (!editor.config.ibmFloatToolbar || (CKEDITOR.env.quirks && CKEDITOR.env.ie) || editor.elementMode == CKEDITOR.ELEMENT_MODE_INLINE)
				return;
		
			var toolbarSpan, contentArea, editorIFrame, toolbarParent, win, iframeOffset, 
				prevHeight,		//used to monitor the height of the editor in IE so that the toolbar position can be updated when content is deleted from the editor
				toolbarFloated = false,
				toolbarItemFocused = false,		//the toolbar should remain floating for all toolbar invoked UI elements - menu, dialogs, font combo boxes, color panels, ALT+F10, ALT+F11
				hiddenDiv = new CKEDITOR.dom.element("div"),		//div used to set min width on editor when browser window is resized
				sizePercentUnit = /^(\d+(?:\.\d+)?)%$/;
					
			/* Overwrite the onOpen functions of panel buttons and rich combos so that we know when context menus, combo boxes, color panels etc are open.
			 * The floating toolbar should remain floated when these ui elements are visible. 
			 */
			var uiItems = editor.ui.items;	//reference to all toolbar elements
			
			for (var i in uiItems){
				if (uiItems[i].type == 'panelbutton' || uiItems[i].type == 'richcombo') {
									
					//store a reference to the onOpen function of uiItem if it exists
					if(uiItems[i].args[0].onOpen){	
						var uiItemOnOpen = uiItems[i].args[0].onOpen;
						uiItems[i].args[0].origOnOpen = uiItemOnOpen;		//add it to the uiItem so that it has the correct scope
					}
					
					//overwrite onOpen to execute origOnOpen() if it exists and then set the toolbarItemFocused flag
					uiItems[i].args[0].onOpen = function (){
						if (this.origOnOpen)			
							this.origOnOpen();	//call original onOpen() if it exists
						
						toolbarItemFocused = true;
					}
				}
			}
		
			//function called to remove scroll and resize event listeners from the browser window
			function removeListeners()
			{
				if (win.$.removeEventListener){
					win.$.removeEventListener('scroll', positionToolbar, false);
					win.$.removeEventListener('resize', resetToolbarProps, false);
				} else if (win.$.detachEvent){
					win.$.detachEvent('onscroll', positionToolbar);
					win.$.detachEvent('onresize', resetToolbarProps);
				}
			}
			
			//function called to add event listeners to the browser window's scroll and resize events
			function addListeners()
			{
				if (win.$.addEventListener){
					win.$.addEventListener('scroll', positionToolbar, false);
					win.$.addEventListener('resize', resetToolbarProps, false);
				} else if (win.$.attachEvent){
					win.$.attachEvent('onscroll', positionToolbar);
					win.$.attachEvent('onresize', resetToolbarProps);
				}
			}
			
			//dock the toolbar by removing the hidden div and cke_floating_toolbox class and resetting the width values
			function dockToolbar(){
				toolbarSpan.removeClass('cke_floating_toolbox');
				toolbarSpan.removeStyle('width');
				contentArea.removeStyle('width');				
				hiddenDiv.remove();
			}
			
			/*Resets the widths of the toolbar span and the content area
			  * element - the element which determines the new width
			  * clearWidths - boolean used to determine if old widths need to be cleared or not. Old widths should not be cleared when the toolbar is first floated
			  */
			function resetWidths(element, clearWidths){
				if(clearWidths){
					toolbarSpan.removeStyle('width');
					contentArea.removeStyle('width');
				}
				var newWidth = CKEDITOR.env.ie ? element.$.clientWidth : parseInt(element.getComputedStyle('width'), 10);
				toolbarSpan.setStyle('width', newWidth+'px');
				contentArea.setStyle('width', newWidth+'px');
			}
			
			//Sets the left position of the toolbar to match the left position of the editor iframe on resize or horizontal scroll.
			function resetLeft(){
				var iframeX = editorIFrame.getDocumentPosition().x,
					winX = win.getScrollPosition().x;
					toolbarSpan.setStyle('left', (iframeX-winX)+'px');
			}
			
			//function called when the browser is scrolled to determine whether to 'float' or 'dock' the toolbar
			var positionToolbar = function ()
			{
			
				//floating toolbar is only supported in wysiwyg mode, also check that the editor is visible
				if (editor.mode == 'wysiwyg' && editor.container.isVisible()){
				
					/* if a reference to the iframe element does not already exist, get it
					 * Also calling setData() on the editor recreates the iframe, therefore it is necessary to get the new editorIFrame each time setData() is called - editorIFrame.getParent() will be null if the iframe has been recreated because 
					 * it will be a reference to the old iframe e.g. onCancel() of the ibmSpellChecker plugin calls setData().
					 */
					if(!editorIFrame || editorIFrame.getParent() == null)
						editorIFrame = editor.container.getElementsByTag('iframe').getItem(0);
						
					/* When the toolbar is floating, the iframe position is decreased by the height of the toolbar. toolbarOffset is used to monitor this difference.
					 * When the toolbar is floating, the toolbarOffset is set to 30px to ensure the toolbar is docked when the user scrolls to the top of the editor using arrow keys.
					 * When the toolbar is docked, the toolbarOffset is set to 0px to ensure the toolbar starts to float as soon as the toolbar disappears out of the current view pane.
					 */
					var toolbarOffset = toolbarFloated ? 30 : 0;
					iframeOffset = editorIFrame.getDocumentPosition().y + toolbarOffset;
				
					var winHeight = win.getViewPaneSize().height;
					var currentScroll = win.getScrollPosition().y;
				}				

				if (editor.mode != 'wysiwyg' || (iframeOffset > currentScroll && iframeOffset < (currentScroll + winHeight))){ 
					
					//toolbar is visible in the current view pane or the editor is in source mode
					dockToolbar();
					
					if (toolbarFloated){
						if(win.$.dojo)
							fadeToolbar();
						toolbarFloated = false;
					}
					
				} else if (currentScroll > iframeOffset){		//if the user has already scrolled past the iframe - this prevents the toolbar being floated when the user scrolls to the page contents before the iframe
					//toolbar is not visible in the current view pane						
					
					//get the width of the largest toolbar group
					var largestGroupWidth = -1, 
						currentChild, currentWidth;
					for (var i = 0; i<toolbarSpan.getChildCount(); i++){
						currentChild = toolbarSpan.getChild(i);
						if (currentChild.getAttribute('class') == 'cke_toolbar'){
							currentWidth = CKEDITOR.env.ie ? currentChild.$.clientWidth : parseInt(currentChild.getComputedStyle('width'), 10);
							if(currentWidth > largestGroupWidth){
								largestGroupWidth = currentWidth;
							}
						}
					}					
				
					//apply the largest toolbar width to the hidden div
					if(largestGroupWidth != -1){
						hiddenDiv.setStyle('width', largestGroupWidth+'px');
					}
					
					//In IE, we need to reserve place for the toolbar when it is docked again - set the height of the hidden div to the height of the original toolbar div ref: RTC defect 22023
					var toolbarSpanHeight = CKEDITOR.env.ie ? toolbarSpan.$.clientHeight : parseInt(toolbarSpan.getComputedStyle('height'), 10);
					hiddenDiv.setStyle('height', toolbarSpanHeight+'px');
					
					//add the hidden div to the parent element of the toolbox - this will prevent the editor from getting narrower than the largest toolbar group when the browser is resized
					toolbarParent.append(hiddenDiv);
				
					if (!toolbarFloated){
							if (win.$.dojo)
								fadeToolbar();
						toolbarFloated = true;
					}
					
					//resize toolbar and content area
					if (editor.config.width) {
						var configWidth = editor.config.width;
						if(!sizePercentUnit.exec(configWidth)){				// config.width is set and is not %,
							if(parseInt(CKEDITOR.tools.convertToPx(configWidth), 10) < largestGroupWidth){	//config width value is smaller than the required space for the largest toolbar group
								resetWidths(contentArea);		//resize toolbar with content area
							} else {
								toolbarSpan.setStyle('width', configWidth);		//set the toolbar width to the config value
							}
						} else {
							resetWidths(contentArea);		//resize based on contentArea for % widths
						}
					} else {		//config.width is not set	
						if (CKEDITOR.env.webkit){							
							resetWidths(contentArea);						
						}else {
							resetWidths(toolbarParent);
						}
					}
					
					//Set the left postion
					resetLeft();					

					//float the toolbar
					toolbarSpan.addClass('cke_floating_toolbox');
					
				}
			}
			
			//function called to reset the toolbar width and left positioning when the browser window is resized
			var resetToolbarProps = function ()
			{
				if (toolbarFloated){
				
					if (editor.config.width ){	
						if (sizePercentUnit.exec(editor.config.width)){		//% width is specified - reset the widths of the toolbar and content area - use the content area here as the toolbar parent sometimes returns a width of 0 in IE
							resetWidths(contentArea, true);
						}
					}else {		//no width set, reset the widths of the toolbar and content area - do not use the toolbar parent here as it now has the width value of the hiddenDiv i.e. longest toolbar group.
													
						if(CKEDITOR.env.chrome){		//there is no way to get the required width in Chrome when the browser is resized, therefore keep the editor the existing width on resize
							resetWidths(toolbarSpan); 
						} else if (CKEDITOR.env.webkit){//safari
							resetWidths(contentArea, true);
						} else {
							resetWidths(toolbarSpan, true);	
						}
					}
						
					resetLeft();
				}
			}

			//use the dojo fade effect
			var fadeToolbar = function ()
			{
				var fadeTarget =  toolbarSpan.$;
				dojo.style(fadeTarget, "opacity", "0");
				var fadeArgs = {
					node: fadeTarget,
					duration: 500
				};
				dojo.fadeIn(fadeArgs).play();
			}
		
						
			//reset editorIFrame when the editor is destroyed - ref RTC defect #27389
			editor.on('destroy', function ()
			{
				editorIFrame = null;
			});

			editor.on( 'mode', function()
			{
			
				if (win) {		//instanceReady has already been called 
						
					if(editor.mode == 'wysiwyg'){ 	//wysiwyg mode
						
						//get a reference to the iframe element
						editorIFrame = editor.container.getElementsByTag('iframe').getItem(0);
						
						//focus event is not triggered when we switch mode - need to explicity add the listeners again
						addListeners();

								
					}else{	//editor is in source mode
					
						positionToolbar();

						//detach listeners for the browser scroll and resize events
						removeListeners();
					}
				}
			});
			
			editor.on('blur', function ()
			{
				setTimeout(function() {
					
					//detach listeners for the browser scroll and resize events
					removeListeners();
				
					if(editor.mode == 'wysiwyg' &&  !toolbarItemFocused){	//the blur event can be triggered in source mode, only dock the toolbar if in wysiwyg mode
						dockToolbar();
						toolbarFloated = false;
					}
				}, 100);
			});
			
			editor.on('focus', function ()
			{
				//if this is the first time the editor gets focus, get a reference to the toolbarSpan, window etc.
				if(!toolbarSpan){
					//find the toolbar element
					var spanElements = editor.container.getElementsByTag('span');
					for(var i=0; i<spanElements.count(); i++){
						if(spanElements.getItem(i).getAttribute('class') == "cke_toolbox"){
							toolbarSpan = spanElements.getItem(i);
							break;
						}
					}		
				
					if(!toolbarSpan)
						return;
				
					toolbarParent = toolbarSpan.getParent();
					win = toolbarSpan.getWindow();
					
					contentArea = toolbarSpan.getParent().getNext();

					prevHeight = editor.element.getSize('height');
				}
								
				toolbarItemFocused = false;	//reset toolbarItemFocused

				positionToolbar();

				if (editor.mode == 'wysiwyg'){
						//attach listeners for the browser scroll and resize events
						addListeners();
				}
					
			});
			
			// IE does not fire the onscroll event when content is deleted from a contentEditable area, therefore the positionToolbar handler does not get triggered.
			// For IE, we use the editor's resize event to monitor when the height of the editor gets smaller and trigger the positionToolbar hander function.
			editor.on('resize', function(){
				if (CKEDITOR.env.ie){
					var currentHeight = editor.element.getSize('height');
					if (currentHeight < prevHeight){
						positionToolbar();
					}
					prevHeight = currentHeight;
				}
			});

			//the toolbar should remain floating when a dialog is opened
			editor.on('dialogShow', function ( evt )
			{
				
				if (evt.data.getName() == 'find')
					toolbarItemFocused = false;
				else 
					toolbarItemFocused = true;
					
			});
			
			editor.on('dialogHide', function ( evt )
			{
				setTimeout(function() {
					if (evt.data.getName() == 'find'){
					
						var editor = evt.editor;
				
						//Determine whether the selection is visible or not
						var selection = editor.getSelection();
						var selectionYOffsetEditor = selection.getStartElement().getDocumentPosition().y;	//Y offset within the editor window
						
						//add 1px in IE because the very start of the selection is sometimes slightly outside the current view pane
						if (CKEDITOR.env.ie)
							selectionYOffsetEditor += 1;
							
						iframeOffset = editorIFrame.getDocumentPosition().y;	

						//Get the Yoffset in relation to the browser window. editor.window.getScrollPosition().y is the scroll position of the editor window. It will always be 0 if the editor does not have a scroll bar.
						var selectionYOffsetWindow = iframeOffset + selectionYOffsetEditor - editor.window.getScrollPosition().y;
							
						//when the toolbar is floated again the view pane will be reduce by the height of the toolbar
						var toolbarHeight = toolbarSpan.getParent().getSize('height', true);
						var currentScroll = win.getScrollPosition().y;
						var scrollPlusToolbar = currentScroll + toolbarHeight;		
						var winHeight = win.getViewPaneSize().height;
						var winLessToolbar =  winHeight - toolbarHeight;
										
						if (selectionYOffsetWindow < currentScroll || selectionYOffsetWindow > (currentScroll + winHeight)){
							//selection is entirely outside the current viewpane - should only occur in the case of a collapsed selection
							selection.scrollIntoView();
						} else if (!(selectionYOffsetWindow > scrollPlusToolbar && selectionYOffsetWindow < (scrollPlusToolbar + winLessToolbar))){
							//selection is not within the view pane when the toolbar is floated (i.e. the toolbar obstructs the selection)
							var newY = (win.getScrollPosition().y - toolbarHeight ) - 10;	//add a 10px margin to ensure no overlap with the toolbar
							win.$.scrollTo(win.getScrollPosition().x, newY);		//scroll the window by the height of the toolbar to make sure the selection can be seen
						}								
					}
				}, 0);
				
			});

			//the toolbar should remain floating when a menu is opened
			editor.on('menuShow', function ()
			{
				toolbarItemFocused = true;
			});
	
	
			//the toolbar should remain floating when ALT+F10 (toolbar navigation) and ALT+F11 (elements path navigation) are pressed
			editor.on('beforeCommandExec', function ( evt )
			{
				if(evt.data.name === 'toolbarFocus' || evt.data.name === 'elementsPathFocus'){
					toolbarItemFocused = true;
				}
			});
			
		},
		
		afterInit : function(editor)
		{
			var config = editor.config;
			if (config.menus)
			{
				this.createConfigCommandMenus(editor);				
				//this.replaceLinkButtonWithMenu(editor);		//no longer want to replace the link button with the menu - both Link and MenuLink are now valid toolbar entries
			}
		},
		
		createConfigCommandMenus : function(editor)
		{
			var menu;
			var menus = editor.config.menus;
			for (menu in menus)
			{
				var currentMenu = menus[menu];
				if (typeof currentMenu.buttonClass != 'string'
						|| typeof currentMenu.commands === 'undefined')
				{
					continue;
				}
				
				var label;
				if (typeof currentMenu.label === 'string')
				{
					// The label string can be 'ibm.menus.mymenu', therefore we need to
					// navigate the lang object to the mymenu property.
					label = editor.lang;
					var langNames = currentMenu.label.split('.');
					for(var i = 0, n = langNames.length; i < n; ++i)
					{
						label = label[langNames[i]];
					}	
				}
				else
				{
					label = editor.lang.ibmtoolbars.menu[menu];
				}
				
				var groupName = 'menu' + menu;
				if (typeof currentMenu.groupName === 'string')
				{
					groupName = currentMenu.groupName;
				}
				
				var menuHelper = new CKEDITOR.ibm.menus(editor, groupName);
				menuHelper.createCommandMenu(
							'Menu' + menu.substr(0,1).toUpperCase() + menu.substr(1), 
							label,
							currentMenu.buttonClass,
							currentMenu.commands,
							currentMenu.toolbar,
							menu);		//iconName
			}
		},
		
		replaceLinkButtonWithMenu : function(editor)
		{		
			var config = editor.config;		
			
			// If there is no link menu defined do nothing.
			if (!config.menus || !config.menus.link)
			{
				return;
			}
			
			// Determine what toolbar is being used.
			var toolbar = (config.toolbar instanceof Array ) ?
							editor.config.toolbar : 
							editor.config['toolbar_' + editor.config.toolbar];
			
			// [IE6] Create Array function to return index of array item.
			if (!Array.prototype.indexOf) {
			  Array.prototype.indexOf = function (obj, fromIndex) {
				if (fromIndex == null) {
					fromIndex = 0;
				} else if (fromIndex < 0) {
					fromIndex = Math.max(0, this.length + fromIndex);
				}
				for (var i = fromIndex, j = this.length; i < j; i++) {
					if (this[i] === obj)
						return i;
				}
				return -1;
			  };
			}
			
			for (var i = 0; i < toolbar.length; i++)
			{		
				if (typeof toolbar[i] === 'object') 
				{
					index = toolbar[i].items.indexOf('Link');
					if (index !== -1)
					{	
						toolbar[i].items[index] = 'MenuLink';
						break; // Assume only one Link button on toolbar.
					}
				} else { 
					var index = toolbar[i].indexOf('Link');
					if (index !== -1)
					{	
						toolbar[i][index] = 'MenuLink';
						break; // Assume only one Link button on toolbar.
					}
				}
			}			
		}
		
	});
	
	if (typeof CKEDITOR.ibm === 'undefined') { CKEDITOR.ibm = {}; }

	CKEDITOR.ibm.menus = CKEDITOR.tools.createClass(
	{	
		$ : function(editor, menuGroup)
		{
			this.editor = editor;			
			this._.menuGroup = menuGroup;
			this._.menuItemOrder = 0;
			
			if (typeof this.editor._.menuGroups[menuGroup] === 'undefined')
			{
				this.editor.addMenuGroup(menuGroup);
			}
		},
		
		privates :
		{
			getCommandLabel : function(commandName)
			{
				for (var name in this.editor.ui.items)
				{
					if (this.editor.ui.items[name].command === commandName)
					{
						return this.editor.ui.items[name].args[0].label;
					}
				}
				return '';
			},
			
			getMenuItemOrder : function()
			{
				return ++this._.menuItemOrder;
			},
			
			getMenuItemState : function( itemName )
			{				
				var item = this.editor.getMenuItem( itemName );
				if (typeof item === 'undefined')
				{
					return CKEDITOR.TRISTATE_OFF;
				}
				
				var cmd = this.editor.getCommand( item.cmdName );
				if (typeof cmd === 'undefined')
				{
					return CKEDITOR.TRISTATE_OFF;
				}

				return cmd.state;
			}			
		},
		
		proto :
		{
			getIconPath : function()
			{
				return this._.iconPath;
			},
			
			getMenuGroup : function()
			{
				return this._.menuGroup;
			},
			
			addMenuItem : function(commandName, menuName)
			{
				var cmd = this.editor.getCommand(commandName);
				if (typeof cmd !== 'object')
				{
					return;
				}

				this.editor.addMenuItem(menuName + '_' + commandName,
					{
						cmdName : commandName, 
						onClick : function() {
							// Use onClick with the command, this way it will be rendered even if disabled.
							this.editor.getCommand( this.cmdName ).exec();
						},
						icon : commandName,
						group : this.getMenuGroup(),
						label : this._.getCommandLabel(commandName),
						order : this._.getMenuItemOrder(),
						className:'toolbarContextMenu'
					});
			},
			
			createCommandMenu : function(name, label, className, commands, toolbar, iconName)
			{
				var me = this;
				var definition = 
				{
					label : label,
					title : label,
					className : className,
					icon : iconName == 'paste' ? 'pastetext' : iconName,
					toolbar: toolbar,
					requiredContent: iconName == 'link' ? 'a[href]' : '', 
					modes : { wysiwyg : 1 },
					onRender: function()
					{	
						for (var idx = 0; idx < commands.length; ++idx)
						{
							me.addMenuItem(commands[idx], name);
						}
					},
					onMenu : function(element, selection)
					{						
						var itemsToDisplay = {};
						for (var idx = 0; idx < commands.length; ++idx)
						{
							var itemName = name + '_' + commands[idx];
							itemsToDisplay[itemName] = me._.getMenuItemState(itemName);
						}
						return itemsToDisplay;						
					}		
				};
				this.createMenu(name, definition);
			},
			
			createMenu : function(name, definition)
			{			
				if(this.editor.getCommand('link') !== 'undefined' && this.editor.getCommand('link') != null)
					this.editor.ui.add(name, CKEDITOR.UI_MENUBUTTON, definition);			
			}
		}
		
	});	
	
CKEDITOR.tools.extend( CKEDITOR.config,
{
	ibmFloatToolbar : false
} );

CKEDITOR.config.toolbar_Slim =
[
	['Bold','Italic','Underline','Strike','TextColor','NumberedList','BulletedList','BidiLtr','BidiRtl','Language','Image','Link','Smiley']
];


CKEDITOR.config.toolbar_Medium =
[
	{ name: 'tools',		items :['Undo','Redo','MenuPaste','IbmSpellChecker']},
	{ name: 'styles',		items :['Font','FontSize','Bold','Italic','Underline','Strike','TextColor','BGColor']},
	{ name: 'paragraph',	items :['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock', 'NumberedList','BulletedList','Indent','Outdent','BidiLtr','BidiRtl','Language']},
	{ name: 'insert',		items :['Table','Image','MenuLink','Anchor','Smiley']}
];


CKEDITOR.config.toolbar_Large =
[
	{ name: 'tools',		items :['Undo','Redo','MenuPaste','Find','IbmSpellChecker','ShowBlocks','IbmPermanentPen']},
	{ name: 'styles',		items :['Format','Font','FontSize','Bold','Italic','Underline','Strike','TextColor','BGColor','Subscript','Superscript','RemoveFormat']},
	{ name: 'paragraph',	items :['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','NumberedList','BulletedList','Indent','Outdent','Blockquote','BidiLtr','BidiRtl','Language' ]},
	{ name: 'insert',		items :['Table','Image','MenuLink','Anchor','Iframe','Flash','PageBreak','HorizontalRule','SpecialChar', 'Smiley']}
];


CKEDITOR.config.toolbar = 'Large';
		