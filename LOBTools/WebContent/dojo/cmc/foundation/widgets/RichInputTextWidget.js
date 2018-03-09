//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015, 2017 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"cmc/foundation/widgets/ComponentWidget",
	"dojo/dom-construct",
	"dojo/query",
	"dojo/on",
	"dojo/aspect",
	"dojo/dom-style",
	"dojo/_base/lang",
	"cmc/foundation/ModalUtil",
	"cmc/foundation/KeyUtil",
	"cmc/foundation/MouseUtil",
	"cmc/foundation/FocusUtil"
], function(declare, ComponentWidget, domConstruct, query, on, aspect, domStyle, lang, ModalUtil, KeyUtil, MouseUtil, FocusUtil) {
	return declare(ComponentWidget, {
		cachedSelectionPosition: undefined,
		buildRendering: function() {
			if (!this.domNode) {
				this.domNode = domConstruct.toDom("<div class=\"CMCtextarea richInputText\" style=\"position: absolute; overflow:hidden\"></div>");
				this.textAreaNode = domConstruct.toDom("<textarea></textarea>");
				this.domNode.appendChild(this.textAreaNode);
			}
			this.createEditor(this.component.ckeditorConfig);	
			this.inherited(arguments);
		},
		destroy: function() {
			if (this.swithModeHandler != null) {
				this.swithModeHandler.remove();
				this.swithModeHandler = null;
			}
			if (this._ckeditor){
				this._ckeditor.destroy();
			}
			this.inherited(arguments);
		},
		getText: function() {
			if (this._ckeditor){
				return this._ckeditor.getData();
			}
			else {
				return null;
			}
		},
		applyText: function() {
			if (!this.settingText ){
				if (this._ckeditor && this._ckeditor.instanceReady){
					if (!this.settingData){
						this.settingData = true;
						var thisWidget = this;
						this._ckeditor.setData(this.component.text, {
							noSnapshot: true,
							//do not save snapshot with auto format/corrected data when we set data
							callback: function(){
								thisWidget.settingData = false;
								thisWidget.applyTextCallback();
							}
						});
					}
					else {
						this.pendingApplyText = true;
					}
				}
			}
		},
		applyTextCallback: function(){
			if (this.pendingApplyText){
				this.pendingApplyText = false;
				this.applyText();
			}
		},
		insertText: function(text){
			var editor = this._ckeditor;
			// Check the active editing mode.
			if ( editor && editor.mode == 'wysiwyg' )
			{
				editor.insertText( text );
			}
			else if (editor && editor.mode == 'source' && this.component.cachedSelectionPosition != null) {
				var editable = editor.editable().$;
				var pos = this.component.cachedSelectionPosition;
				var size = this.component.cachedSelectionSize;
				var textAreaText = editable.value;
				var newText = textAreaText.substring(0, pos) + text +  textAreaText.substring(pos + size);
				editable.value = newText;
				this.component.cachedSelectionPosition = pos + text.length;
				this.component.cachedSelectionSize = 0;
				this.handleInputChange();
			}
		},
		applyWidth: function() {
			if (this._ckeditor){
				var editable = this._ckeditor.editable();
				if (editable){
					this.inherited(arguments);
					this._ckeditor.resize(this.component.width, this.component.height);
					this.component.updateInputTextHeight();
				}
				else{
					this._ckeditor.on('contentDom', lang.hitch(this, "applyWidth"));
				}
			}
		},
		applyHeight: function() {
			if (this._ckeditor){
				var editable = this._ckeditor.editable();
				if (editable){
					this._ckeditor.resize(this.component.width, this.component.height);
				}
				else{
					this._ckeditor.on('contentDom', lang.hitch(this, "applyHeight"));
				}
			}
		},
		applyEnabled: function() {
			if (this._ckeditor){
				var editable = this._ckeditor.editable();
				if (editable){
					this._ckeditor.setReadOnly(!this.component.enabled);
				}
				else{
					this._ckeditor.on('contentDom', lang.hitch(this, "applyEnabled"));
				}
			}
		},
		applyRichTextMode: function(){
			if (this._ckeditor){
				var isRichMode = this.component.parentTextEditor.richTextMode;
				var editorRichTextMode = (this._ckeditor.mode != "source" );
				if (editorRichTextMode != isRichMode){
					this._ckeditor.setMode(isRichMode ? 'wysiwyg' : 'source');
				}
			}
		},
		getContentHeight: function(){
			var height = null;
			if (this._ckeditor){
				if (this._ckeditor.mode != 'source'){
					//richtext mode
					var doc = this._ckeditor.document;
					if (doc){
						var scrollable =  doc.getDocumentElement().$;
						var body = doc.getBody().$;
						//horizontal scrollbar exists, add 25
						height = Math.max(
							Math.max(scrollable ? scrollable.offsetHeight : 0, body ? body.offsetHeight : 0),
							Math.max(scrollable ? scrollable.scrollHeight : 0, body ? body.scrollHeight : 0),
							Math.max(scrollable ? scrollable.clientHeight : 0, body ? body.clientHeight : 0)
							) + (
								Math.max(
								Math.max(scrollable ? scrollable.offsetWidth : 0, body ? body.offsetWidth : 0),
								Math.max(scrollable ? scrollable.scrollWidth : 0, body ? body.scrollWidth : 0),
								Math.max(scrollable ? scrollable.clientWidth : 0, body ? body.clientWidth : 0))
								> this.component.width ? 25 : 3);
					}
				}
				else {
					//source mode
					var scrollable = this._ckeditor.editable().$;
					height = Math.max(scrollable.offsetHeight, scrollable.scrollHeight, scrollable.clientHeight);
				}
			}
			return height;
		},
		getToolbarHeight: function(){
			var height = null;
			if (this._ckeditor){
				var editable = this._ckeditor.editable();
				if (editable){
					var top = this._ckeditor.ui.space('top');
					var bottom = this._ckeditor.ui.space( 'bottom' );
					height = top.$.offsetHeight + bottom.$.offsetHeight;
				}
			}
			return height;
		},
		handleInputChange: function(){
			this.settingText = true;
			var text = this.getText();
			if (text == null){
				//this should never happen here, this function is invoked upon user input
				text = "";
			}
			this.component.setVariable("text", text);
			this.settingText = false;
		},
		handleModeChange: function(){
			if(FocusUtil.getFocus() == this.component){
				this.setFocus(true);
			}
			var isRichMode = (this._ckeditor.mode != 'source');
			this.component.switchModes(isRichMode);
		},
		getSelectionSize: function(){
			var size = -1;
			var editor = this._ckeditor;
			if ( editor && editor.mode == 'source' )
			{
				var editable = editor.editable().$;
				size = Math.abs(editable.selectionEnd - editable.selectionStart);
			}
			return size;
		},
		getSelectionPosition: function(){
			var pos = -1;
			var editor = this._ckeditor;
			if ( editor && editor.mode == 'source' )
			{
				var editable = editor.editable().$;
				var start = editable.selectionStart;
				var end = editable.selectionEnd;
				pos = (start > end) ? end : start;
			}
			return pos;
		},
		setFocus: function(force) {
			if (force == null) {
				force = false;
			}
			if (force){
				this.domNode.tabIndex = -1;
				KeyUtil.clearIframeBlurTimeout();
				KeyUtil.iframeFocusing = false;
				var editor = this._ckeditor;
				if (editor){
					if (editor.mode == 'wysiwyg'){
						KeyUtil.iframeFocusing = true;
					}
					editor.focus();
				}
				else {
					this.domNode.focus();
				}
			}
		},
		restoreFocus: function(){
			var editor = this._ckeditor;
			if ( editor && editor.mode == 'source' && this.cachedSelectionPosition)
			{
				var editable = editor.editable().$;
				if (editable.setSelectionRange) {
					editable.focus();
					editable.setSelectionRange(this.cachedSelectionPosition, this.cachedSelectionPosition);
				}
				else if (editable.createTextRange) {
					var range = editable.createTextRange();
					range.collapse(true);
					range.moveEnd('character', this.cachedSelectionPosition);
					range.moveStart('character', this.cachedSelectionPosition);
					range.select();
				}
			}
		},
		removeCKEditor: function(){
			//if the parent element was moved in the dom, the iframe will reload with empty content,
			//use this to fix the iframe content
			if (this._ckeditor && this.component.getRichTextMode()){
				if (this._ckeditor.instanceReady) {
					this._ckeditor.destroy();
				}
				else {
					this._destroyPendingCKEditor = this._ckeditor;
				}
				this._ckeditor = null;
				if (this.swithModeHandler != null) {
					this.swithModeHandler.remove();
					this.swithModeHandler = null;
				}
			}
		},
		restoreCKEditor: function(){
			//if the parent element was moved in the dom, the iframe will reload with empty content,
			//use this to fix the iframe content
			if (this._destroyPendingCKEditor) {
				this._ckeditor = this._destroyPendingCKEditor;
				this._destroyPendingCKEditor = null;
			}
			else if (!this._ckeditor){
				var config = this.component.ckeditorConfig;
				config.startupMode = this.component.getRichTextMode() ? 'wysiwyg': 'source';
				this.createEditor(config);
			}
		},
		updateDisplayLanguage: function(){
			if (this._ckeditor){
				this._ckeditor.destroy();
				this._ckeditor = null;
				if (this.swithModeHandler != null) {
					this.swithModeHandler.remove();
					this.swithModeHandler = null;
				}
				this.restoreCKEditor();
			}
		},
		createEditor: function(config){
			var configs = JSON.parse(JSON.stringify(config));
			var thisWidget = this;
			var eventListeners = {
				//listener for this ckeditor
				change: function(evt){
					thisWidget.handleInputChange();
				},
				instanceReady: function(evt){
					if (thisWidget._destroyPendingCKEditor) {
						evt.removeListener();
						thisWidget._destroyPendingCKEditor.destroy();
						thisWidget._destroyPendingCKEditor = null;
					}
					else {
						if (FocusUtil.getFocus() == thisWidget.component) {
							thisWidget.setFocus(true);
						}
						var edt = evt.editor;
						if (!thisWidget.swithModeHandler){
							thisWidget.swithModeHandler = aspect.before(edt, 'execCommand', function(commandName){
								if(commandName === 'source'){
									//prevent auto formating/correction save back to component during mode change
									this.fire('lockSnapshot');
								}
							});
						}
						evt.removeListener();
						if (evt.editor.mode == 'source'){
							var editable = evt.editor.editable();
							editable.attachListener(editable, 'input', function() {
								thisWidget.cachedSelectionPosition = thisWidget.getSelectionPosition();
								thisWidget.handleInputChange();
								if (navigator.userAgent.toUpperCase().indexOf("TRIDENT")>-1){
									//handle IE 11 lose focus after resizing the widget
									thisWidget.restoreFocus();
								}
							});
						}					
						thisWidget.pendingApplyText = false;
						thisWidget.settingData = false;
						thisWidget.settingText = false;
						evt.editor.on("mode", function(evt){
							thisWidget.handleModeChange();
							if (evt.editor.mode == 'source'){
								var editable = evt.editor.editable();
						        editable.attachListener(editable, 'input', function() {
						        	thisWidget.cachedSelectionPosition = thisWidget.getSelectionPosition();
						        	thisWidget.handleInputChange();
						        	if (navigator.userAgent.toUpperCase().indexOf("TRIDENT")>-1){
						        		//handle IE 11 lose focus after resizing the widget
						        		thisWidget.restoreFocus();
						        	}
						        });
							}
							evt.editor.fire('unlockSnapshot');
						}, null, null, 100);
						evt.editor.on("contentDom", function(e){
							thisWidget.component.setEditorDomReady(true);
							thisWidget.component.updateInputTextHeight();
							var editor = e.editor;
							if  (editor.mode == 'wysiwyg'){
								//richtext mode
								var doc = editor.document.$;
								doc.addEventListener("keydown", function(e){
									var keyCode = e.keyCode;
									if (keyCode == KeyUtil.keyCodes["tab"] || keyCode == KeyUtil.keyCodes["shift"]){
										if (keyCode == KeyUtil.keyCodes["tab"]){
											e.stopPropagation();
											e.preventDefault();
										}
										KeyUtil.handleKeyDown(e);
									}
								});
								doc.addEventListener("keyup", function(e){
									var keyCode = e.keyCode;
									if (keyCode == KeyUtil.keyCodes["tab"] || keyCode == KeyUtil.keyCodes["shift"]){
										if (keyCode == KeyUtil.keyCodes["tab"]){
											e.stopPropagation();
											e.preventDefault();
										}
										KeyUtil.handleKeyUp(e);
									}
								});
								doc.addEventListener("mousedown", function(e){
									MouseUtil.handleMouseDown(thisWidget.component);
								});
								doc.addEventListener("mouseup", function(e){
									MouseUtil.handleMouseUp(e);
								});
								var editable = editor.editable();
								editable.attachListener(editor, "blur", function(e){
									KeyUtil.setIframeBlurTimeout();
								});
							}
						});
						thisWidget.applyEnabled();
						thisWidget.applyText();
						thisWidget.applyWidth();
					}
				}
			};
			if(configs.startupMode != 'source'){
				this.component.setEditorDomReady(false);
			}
			else {
				this.component.setEditorDomReady(true);
			}
			configs.on = eventListeners;
			this._ckeditor = CKEDITOR.replace(this.textAreaNode, configs);
		}
	});
});
