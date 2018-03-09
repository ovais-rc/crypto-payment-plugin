//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2017 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"cmc/foundation/Component",
	"cmc/foundation/widgets/InputTextWidget",
	"cmc/foundation/EventUtil",
	"exports"
], function(declare, Component, InputTextWidget, EventUtil, exports) {
	exports.Class = declare(Component.Class, {
		enabled: true,
		multiline: false,
		password: false,
		text: "",
		widgetClass: InputTextWidget,
		focusable: true,
		clickable: true,
		textDir: null,
		restrict: null,
		stopDoubleClickPropagation: true,
		set_pattern: function(value){
			if (value == null || value == "") {
				this.restrict = null;
				EventUtil.trigger(this, "onpattern", value);
			} else if (value.substring(0,1) == "[" &&
					value.substring(value.length-2, value.length) == "]*") {
				this.restrict = new RegExp(value.substring(0, value.length - 1) + "|[\\r\\n]", "g");
				EventUtil.trigger(this, "onpattern", value);
			} else {
				require(["cmc/shell/Logger"], function(Logger) {
					Logger.Singleton.log("com.ibm.commerce.lobtools.foundation.view", "SEVERE", "cmc/foundation/InputTextComponent", "set_pattern", "unsupported pattern: " + value);
				});
			}
		},
		getText: function() {
			return this.text;
		},
		setText: function(text) {
			this.setVariable("text", text);
		},
		clearText: function() {
			this.setVariable("text", "");
		},
		highliteText: function(begin, last){
			if (this.widget != null) {
				this.widget.highliteText(begin, last);
			}
		},
		unhighliteText: function(){
			if (this.widget != null) {
				this.widget.applyText();
			}
		},
		set_text: function(text) {
			this.text = text;
			if (this.widget != null) {
				this.widget.applyText();
			}
			EventUtil.trigger(this, "ontext", text);
		},
		set_password: function(value) {
			this.password = value;
			if (this.widget != null) {
				this.widget.applyPassword();
			}
			EventUtil.trigger(this, "onpassword", value);
		},
		set_multiline: function(value) {
			if (this.multiline != value){
				this.multiline = value;
				if (this.widget != null) {
					this.widget.applyMultiline();
				}
				EventUtil.trigger(this, "onmultiline", value);
			}
		},
		set_enabled: function(value) {
			if (this.enabled != value){
				this.enabled = value;
				if (this.widget != null) {
					this.widget.applyEnabled();
				}
				EventUtil.trigger(this, "onenabled", value);
			}
		},
		set_textDir: function(value) {
			if (this.textDir != value){
				this.textDir = value;
				if (this.widget != null) {
					this.widget.applyTextDir();
				}
				EventUtil.trigger(this, "ontextDir", value);
			}
		},
		getSelectionPosition: function() {
			var pos = -1;
			if (this.widget != null) {
				pos = this.widget.getSelectionPosition();
			}
			return pos;
		},
		getSelectionSize: function() {
			var size = -1;
			if (this.widget != null) {
				size = this.widget.getSelectionSize();
			}
			return size;
		},
		hasDerivedSize: function() {
			return true;
		},
		getContentHeight: function(){
			if (this.widget){
				return this.widget.getContentHeight();
			}
			else{
				return null;
			}
		},
		replaceText: function(start, end, replacementText) {
			var newText = this.text.substring(0, start + 1) + replacementText + this.text.substring(end);
			this.setText(newText);
		}
	});
	return exports;
});