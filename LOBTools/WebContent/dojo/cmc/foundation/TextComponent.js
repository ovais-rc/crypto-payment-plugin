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
	"cmc/foundation/Component",
	"cmc/foundation/widgets/TextWidget",
	"cmc/foundation/EventUtil",
	"cmc/foundation/StringUtil",
	"exports"
], function(declare, Component, TextWidget, EventUtil, StringUtil, exports) {
	exports.Class = declare(Component.Class, {
		widgetClass: TextWidget,
		text: "",
		underline: false,
		textAlign: null,
		lineHeight: null,
		set_text: function(text) {
			this.text = text;
			if (this.widget != null) {
				this.widget.applyText();
			}
			EventUtil.trigger(this, "ontext", text);
			this.updateSize();
		},
		set_multiline: function(value) {
			this.multiline = value;
			if (this.widget != null) {
				this.widget.applyMultiline();
			}
			EventUtil.trigger(this, "onmultiline", value);
			this.updateSize();
		},
		set_selectable: function(value) {
			this.selectable = value;
			if (this.widget != null) {
				this.widget.applySelectable();
			}
			EventUtil.trigger(this, "onselectable", value);
		},
		set_underline: function(value) {
			this.underline = value;
			if (this.widget) {
				this.widget.applyUnderline();
			}
			EventUtil.trigger(this, "onunderline", value);
		},
		set_textAlign: function(value) {
			this.textAlign = value;
			if (this.widget) {
				this.widget.applyTextAlign();
			}
			EventUtil.trigger(this, "ontextAlign", value);
		},
		set_lineHeight: function(value) {
			this.lineHeight = value;
			if (this.widget) {
				this.widget.applyLineHeight();
			}
			EventUtil.trigger(this, "onlineHeight", value);
			this.updateSize();
		},
		getText: function() {
			return this.text;
		},
		getTextWidth: function() {
			return this.widget != null ? this.widget.getTextWidth() : 0;
		},
		getTextHeight: function() {
			return this.widget != null ? this.widget.getTextHeight() : 0;
		},
		escapeText: function(text) {
			return StringUtil.Singleton.escapeText(text);
		},
		hasDerivedSize: function() {
			return true;
		},
		set_width: function(value) {
			this.inherited(arguments);
			if (this.hasSetWidth){
				this.updateSize();
			}
		},
		updateRtlMirroring: function() {
			this.inherited(arguments);
			if (this.widget) {
				this.widget.applyTextAlign();
			}
		}
	});
	return exports;
});