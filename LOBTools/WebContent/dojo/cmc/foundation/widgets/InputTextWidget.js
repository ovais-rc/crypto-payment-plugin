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
	"dojo/dom-style",
	"dojo/_base/lang",
	"cmc/foundation/ModalUtil",
	"cmc/foundation/EventUtil",
	"cmc/shell/PreferenceManager"
], function(declare, ComponentWidget, domConstruct, query, on, domStyle, lang, ModalUtil, EventUtil, PreferenceManager) {
	return declare(ComponentWidget, {
		textDir: null,
		buildRendering: function() {
			if (!this.domNode) {
				var type = "text";
				if (this.component.password) {
					type = "password";
					this.component.multiline = false;
				}
				else if (this.component.multiline){
					type = "multiline";
				}
				this.domNode = domConstruct.toDom("<div style=\"position: absolute; overflow:hidden\"/>");
				this.createInputDiv(type);
				if (this.inputTextHighlighterNode){
					this.domNode.appendChild(this.inputTextHighlighterNode);
				}
				this.domNode.appendChild(this.inputTextNode);
				var widget = this;
				this.own(
					on(this.domNode, "textarea:input", function() {
						var txt = widget.getText();
						if (!widget.component.restrict){
							widget._settingText = true;
							widget.component.setVariable("text", txt);
							widget._settingText = false;
						}
						else {
							var matches = txt.match(widget.component.restrict);
							if (matches == null){
								txt = "";
							}
							else {
								txt = matches.join("");
							}
							if (txt != widget.getText()){
								var componentText = widget.component.getText();
								var widgetText = widget.getText();
								var l = (componentText.length > widgetText.length) ? widgetText.length : componentText.length;
								var pos = -1;
								for (var i = 0; pos == -1 && i < l; i++){
									if (componentText.charAt(i) != widgetText.charAt(i)){
										pos = i;
									}
								}
								if (pos == -1){
									pos = l;
								}
								widget.applyText();
								this.focus();
								this.setSelectionRange(pos, pos);
							}
							else {
								widget._settingText = true;
								widget.component.setVariable("text", txt);
								widget._settingText = false;
							}
						}
					}),
					on(this.domNode, "input:input", function() {
						var txt = widget.getText();
						if (!widget.component.restrict){
							widget._settingText = true;
							widget.component.setVariable("text", txt);
							widget._settingText = false;
						}
						else {
							var matches = txt.match(widget.component.restrict);
							if (matches == null){
								txt = "";
							}
							else {
								txt = matches.join("");
							}
							if (txt != widget.getText()){
								var componentText = widget.component.getText();
								var widgetText = widget.getText();
								var l = (componentText.length > widgetText.length) ? widgetText.length : componentText.length;
								var pos = -1;
								for (var i = 0; pos == -1 && i < l; i++){
									if (componentText.charAt(i) != widgetText.charAt(i)){
										pos = i;
									}
								}
								if (pos == -1){
									pos = l;
								}
								widget.applyText();
								this.focus();
								this.setSelectionRange(pos, pos);
							}
							else {
								widget._settingText = true;
								widget.component.setVariable("text", txt);
								widget._settingText = false;
							}
						}
					}),
					on(this.domNode, "textarea:mousedown", function(e) {
						if (!ModalUtil.inputAllowed(widget.component)) {
							e.stopPropagation();
							e.preventDefault();
						}
					}),
					on(this.domNode, "input:mousedown", function(e) {
						if (!ModalUtil.inputAllowed(widget.component)) {
							e.stopPropagation();
							e.preventDefault();
						}
					})
				);
			}
			this.applyText();
			this.applyTextDir();
			EventUtil.connect(PreferenceManager.Singleton, "preferenceChanged", this, "applyTextDir");
			this.inherited(arguments);
		},
		destroy: function() {
			EventUtil.disconnect(PreferenceManager.Singleton, "preferenceChanged", this, "applyTextDir");
			this.inherited(arguments);
		},
		getText: function() {
			return this.inputTextNode != null ? this.inputTextNode.value : "";
		},
		applyText: function() {
			if (this.inputTextNode != null && !this._settingText) {
				this.inputTextNode.value = this.component.text;
			}
			if (this.inputTextHighlighterNode){
				var textNode = document.createTextNode(this.component.text);
				this.inputTextHighlighterNode.innerHTML = '';
				this.inputTextHighlighterNode.appendChild(textNode);
			}
			this.checkTextDir();
		},
		applyPassword: function() {
			this.inputTextNode.type = this.component.password ? "password" : "text";
		},
		setFocus: function(isMouseEvent) {
			this.inputTextNode.focus();
			if (!isMouseEvent) {
				this.inputTextNode.select();
			}
		},
		createInputDiv: function(type){
			if (type === 'password'){
				this.inputTextNode = domConstruct.toDom("<input type=\"" + type + "\" autocomplete=\"off\" style=\"border-width: 0; background-image: none; background-color: transparent; color: #464646; outline: none; width: 100%; height: 100%; font: inherit; font-family: Helvetica,Arial,sans-serif;\" tabindex=\"-1\"/>");
				this.inputTextHighlighterNode = null;
			}
			else if (type === 'multiline'){
				this.inputTextNode = domConstruct.toDom("<textarea style=\"resize:none; border-width: 0px; position: absolute; background-image: none; background-color: transparent; color: #464646; outline: none; width: 100%; height: 100%; overflow: hidden; font: inherit; font-family: Helvetica,Arial,sans-serif; white-space:pre-wrap; word-wrap:break-word; word-spacing: 0px; margin: 0px; padding: 0px;\" tabindex=\"-1\"/>");
				this.inputTextHighlighterNode = domConstruct.toDom("<div style=\"border-width: 0px; position: absolute; background-image: none; background-color: transparent; color: transparent; outline: none; overflow: hidden; font: inherit; font-family: Helvetica,Arial,sans-serif; white-space:pre-wrap; word-wrap:break-word; word-spacing: 0px; margin: 0px; padding: 0px;\" tabindex=\"-1\"/>");
				this.own(on(this.inputTextNode, "scroll", lang.hitch(this, function(e) {
					this.setHighlighterPosition();
				})));
			}
			else {
				this.inputTextNode = domConstruct.toDom("<input type=\"" + type + "\" autocomplete=\"off\" style=\"border-width: 0; background-image: none; background-color: transparent; color: #464646; outline: none; width: 100%; height: 100%; font: inherit; font-family: Helvetica,Arial,sans-serif;\" tabindex=\"-1\"/>");
				this.inputTextHighlighterNode = null;
			}
			if (this.component.name && this.component.name != ''){
				this.inputTextNode.setAttribute('name', this.component.name);
			}
		},
		applyWidth: function() {
			this.inherited(arguments);
			if (this.component.multiline){
				this.setHighlighterPosition();
			}
		},
		applyHeight: function() {
			this.inherited(arguments);
			if (this.component.multiline){
				this.setHighlighterPosition();
			}
		},
		applyMultiline: function() {
			var oldTextNode = this.inputTextNode;
			var oldTextHighlighterNode = this.inputTextHighlighterNode;
			if (oldTextNode) {
				this.domNode.removeChild(oldTextNode);
			}
			if (oldTextHighlighterNode){
				this.domNode.removeChild(oldTextHighlighterNode);
			}
			this.createInputDiv(this.component.multiline? "multiline" : (this.component.password? "password": "text"));
			if (this.inputTextHighlighterNode){
				this.domNode.appendChild(this.inputTextHighlighterNode);
			}
			this.domNode.appendChild(this.inputTextNode);
			this.applyText();
			this.applyTextDir();
			if (this.component.multiline){
				this.setHighlighterPosition();
			}
		},
		applyEnabled: function() {
			if (this.component.enabled == false){
				this.inputTextNode.setAttribute("readonly", "true");
				this.inputTextNode.style.color = "#b1b1b1";
			}
			else {
				this.inputTextNode.removeAttribute("readonly");
				this.inputTextNode.style.color = "#464646";
			}
			
		},
		applyTextDir: function() {
			var newTextDir = this.component.textDir;
			if (newTextDir == null) {
				newTextDir = PreferenceManager.Singleton.getPreference("CMCTextDirection");
				if (newTextDir == null || typeof newTextDir == "undefined") {
					newTextDir = "";
				}
			}
			this.textDir = newTextDir;
			if (this.inputTextNode) {
				if (this.textDir == "auto") {
					this.checkTextDir()
				}
				else {
					this.inputTextNode.dir = this.textDir;
					if (this.inputTextHighlighterNode) {
						this.inputTextHighlighterNode.dir = newTextDir;
					}
				}
				this.setHighlighterPosition();
			}
		},
		checkTextDir: function() {
			if (this.textDir == "auto" && this.inputTextNode) {
				var fdc = /[A-Za-z\u05d0-\u065f\u066a-\u06ef\u06fa-\u07ff\ufb1d-\ufdff\ufe70-\ufefc]/.exec(this.component.text);
				if (fdc) {
					var newTextDir = fdc[0] <= 'z' ? "ltr" : "rtl";
					if (newTextDir != this.inputTextNode.dir) {
						this.inputTextNode.dir = newTextDir;
					}
					if (this.inputTextHighlighterNode && newTextDir != this.inputTextHighlighterNode.dir) {
						this.inputTextHighlighterNode.dir = newTextDir;
						this.setHighlighterPosition();
					}
				}
			}
		},
		getContentHeight: function(){
			if (this.component.multiline){
				return this.inputTextNode.scrollHeight;
			}
			else{
				return this.inputTextNode.clientHeight;
			}
		},
		setHighlighterPosition: function(){
			if (this.inputTextHighlighterNode){
				var topPos = 0 - this.inputTextNode.scrollTop;
				var h = this.inputTextNode.clientHeight + this.inputTextNode.scrollTop;
				var w = this.inputTextNode.clientWidth;
				domStyle.set(this.inputTextHighlighterNode, {
					top: topPos + "px",
					height: h + "px",
					width: w + "px"
				});
			}
		},
		highliteText: function(begin, last){
			if (this.inputTextHighlighterNode) {
				this.inputTextHighlighterNode.innerHTML = '';
				var text = this.getText();
				var t1 = text.substring(0, begin);
				var t2 = text.substring(begin, last);
				var t3 = text.substring(last);
				var markNode = domConstruct.toDom("<mark></mark>");
				if (t1 != ''){
					this.inputTextHighlighterNode.appendChild(document.createTextNode(t1));
				}
				if (t2 != ''){
					domStyle.set(markNode, {
						background: 'ffff00',
						color: 'transparent',
						margin: 0,
						padding: 0
					});
					markNode.appendChild(document.createTextNode(t2));
					this.inputTextHighlighterNode.appendChild(markNode);
				}
				if (t3 != ''){
					this.inputTextHighlighterNode.appendChild(document.createTextNode(t3));
				}
				if (t2 !=''){
					var topPos = markNode.offsetTop + this.inputTextHighlighterNode.offsetTop;
					if (topPos < 0 || topPos + 5 > this.domNode.clientHeight) {
						this.inputTextNode.scrollTop = this.inputTextNode.scrollTop + topPos;
					}
				}
			}
		},
		getSelectionSize: function(){
			var size = -1;
			if (this.component.multiline){
				size = Math.abs(this.inputTextNode.selectionEnd - this.inputTextNode.selectionStart);
			}
			return size;
		},
		getSelectionPosition: function(){
			var pos = -1;
			if (this.component.multiline){
				var start = this.inputTextNode.selectionStart;
				var end = this.inputTextNode.selectionEnd;
				pos = (start > end) ? end : start;
			}
			return pos;
		}
	});
});
