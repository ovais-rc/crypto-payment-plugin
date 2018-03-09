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
	"dojo/dom-style",
	"cmc/RootComponent"
], function(declare, ComponentWidget, domConstruct, domStyle, RootComponent) {
	return declare(ComponentWidget, {
		newLineRegExp: RegExp("$", "gm"),
		buildRendering: function() {
			if (!this.domNode) {
				//this.domNode = domConstruct.toDom("<div style=\"position: absolute;\"><span></span></div>");
				this.domNode = domConstruct.toDom("<div style=\"position:absolute;overflow:hidden;word-wrap:break-word;-moz-user-select:none;outline:none;pointer-events:none;font-family:Helvetica,Arial,sans-serif;padding-top:2px;padding-bottom:2px;padding-left:2px;padding-right:2px;\"></div>");
			}
			this.containerNode = this.domNode;
			//this.textAreaNode = query("span", this.domNode)[0];
			this.inherited(arguments);
			this.applyMultiline();
			this.applySelectable();
			this.applyLineHeight();
			this.applyText();
			this.applyUnderline();
			this.applyTextAlign();
		},
		getTextWidth: function() {
			var textWidth = 0;
			if (this.component.text != null && this.component.text != "") {
				var testNode = this.getTestNode();
				if (testNode != null) {
					testNode.innerHTML = this.component.text;
					textWidth = testNode.offsetWidth;
				}
			}
			return textWidth;
		},
		getTextHeight: function() {
			var textHeight = 0;
			if (this.component.multiline && this.component.text != null && this.component.text != "") {
				textHeight = this.domNode.offsetHeight;
			}
			else {
				var testNode = this.getTestNode();
				if (testNode != null) {
					testNode.innerHTML = "Yqgy9_\";";
					textHeight = testNode.offsetHeight;
				}
			}
			return textHeight;
		},
		getTestNode: function() {
			var testNode = null;
			if (RootComponent.Singleton != null && RootComponent.Singleton.widget != null && RootComponent.Singleton.widget.domNode != null) {
				testNode = RootComponent.Singleton.widget.testNode;
				if (testNode == null) {
					testNode = domConstruct.toDom("<div style=\"position:absolute;display:block;left:-1000px;overflow:hidden;-moz-user-select:none;outline:none;pointer-events:none;font-family:Helvetica,Arial,sans-serif;padding-top:2px;padding-bottom:2px;padding-left:2px;padding-right:2px;white-space:nowrap;\"></div>");
					RootComponent.Singleton.widget.testNode = testNode;
					RootComponent.Singleton.widget.domNode.insertBefore(testNode, RootComponent.Singleton.widget.domNode.firstChild);
				}
				var fontsize = 13;
				var c = this.component;
				while (c != null) {
					if (c.fontsize != null && !isNaN(c.fontsize)) {
						fontsize = c.fontsize;
						break;
					}
					c = c.immediateParent;
				}
				var fontWeight = "normal";
				var fontStyle = "normal";
				c = this.component;
				while (c != null) {
					if (c.fontstyle != null) {
						if (c.fontstyle == "bold") {
							fontWeight = "bold";
							fontStyle = "normal";
						}
						else if (c.fontstyle == "bolditalic") {
							fontWeight = "bold";
							fontStyle = "italic";
						}
						else if (c.fontstyle == "italic") {
							fontWeight = "normal";
							fontStyle = "italic";
						}
						else if (c.fontstyle == "plain") {
							fontWeight = "normal";
							fontStyle = "normal";
						}
						break;
					}
					c = c.immediateParent;
				}
				var lineHeight = "normal";
				c = this.component;
				if (c.lineHeight != null) {
					lineHeight = c.lineHeight + "px";
				}
				domStyle.set(testNode, "fontSize", fontsize + "px");
				domStyle.set(testNode, "fontWeight", fontWeight);
				domStyle.set(testNode, "fontStyle", fontStyle);
				domStyle.set(testNode, "lineHeight", lineHeight);
			}
			return testNode;
		},
		applyClip: function() {
			// override clip behaviour - text components always clip
		},
		applyText: function() {
			var text = this.component.text;
			if (this.component.multiline && text != null && text.indexOf('\n') != -1) {
				text = text.replace(this.newLineRegExp, "<br/>");
			}
			this.domNode.innerHTML = text;
		},
		applyMultiline: function() {
			domStyle.set(this.domNode, "whiteSpace", this.component.multiline ? "normal" : "nowrap");
		},
		applySelectable: function() {
			domStyle.set(this.domNode, "-webkit-user-select", this.component.selectable ? "text" : "none");
		},
		applyUnderline: function() {
			domStyle.set(this.domNode, "textDecoration", this.component.underline ? "underline" : "");
		},
		applyTextAlign: function() {
			var textAlign = this.component.textAlign;
			var dir = "";
			if (RootComponent.Singleton.rtlMirroring) {
				if (textAlign == "left" || textAlign == null) {
					textAlign = "right";
					dir = "rtl";
				}
				else {
					textAlign = "left";
					dir = "ltr";
				}
			}
			domStyle.set(this.domNode, "textAlign", textAlign != null ? textAlign : "");
			this.domNode.dir = dir;
		},
		applyLineHeight: function() {
			var lineHeight = "normal";
			if (this.component.lineHeight != null && !isNaN(this.component.lineHeight)) {
				lineHeight = this.component.lineHeight + "px";
			}
			domStyle.set(this.domNode, "lineHeight", lineHeight);
		},
		getWidgetHeight: function() {
			return this.getTextHeight();
		}
	});
});
