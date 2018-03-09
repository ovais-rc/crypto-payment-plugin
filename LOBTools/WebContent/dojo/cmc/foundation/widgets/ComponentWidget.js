//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"dijit/_WidgetBase",
	"dojo/dom-construct",
	"dojo/on",
	"dojo/dom",
	"dojo/dom-class",
	"dijit/registry",
	"dojo/query",
	"cmc/foundation/EventUtil",
	"cmc/foundation/MouseUtil",
	"cmc/foundation/ModalUtil",
	"cmc/RootComponent"
], function(declare, _WidgetBase, domConstruct, on, dom, domClass, registry, query, EventUtil, MouseUtil, ModalUtil, RootComponent) {
	return declare(_WidgetBase, {
		component: null,
		parentWidget: null,
		mouseHandles: null,
		swfNode: null,
		imgNode: null,
		imgNodeHandles: null,
		buildRendering: function() {
			if (!this.domNode) {
				this.domNode = domConstruct.toDom("<div style=\"position:absolute;-moz-user-select:none;outline:none\"></div>");
			}
			this.containerNode = this.domNode;
			this.applyWidth();
			this.applyHeight();
			this.applyX();
			this.applyY();
			this.applyCurrentImageSource();
			this.applyImageSource();
			this.applyStretches();
			this.applyBGColor();
			this.applyFGColor();
			this.applyFontstyle();
			this.applyFontsize();
			this.applyVisible();
			this.applyClickable();
			this.applyClip();
			this.applyOpacity();
			this.applyModal();
			this.applyContextMenu();
			this.inherited(arguments);
		},
		postCreate: function() {
			this.inherited(arguments);
			if (this.parentWidget != null && this.parentWidget.containerNode != null) {
				this.parentWidget.containerNode.appendChild(this.domNode);
			}
		},
		destroy: function() {
			if (this.mouseHandles != null) {
				for (var i = 0; i < this.mouseHandles.length; i++) {
					this.mouseHandles[i].remove();
				}
				this.mouseHandles = null;
			}
			if (this.swfNode != null) {
				if(this.swfNode.parentNode)this.swfNode.parentNode.removeChild(this.swfNode);
				this.swfNode = null;
			}
			if (this.imgNodeHandles != null) {
				for (var i = 0; i < this.imgNodeHandles.length; i++) {
					this.imgNodeHandles[i].remove();
				}
				this.imgNodeHandles = null;
			}
			if (this.imgNode != null) {
				if(this.imgNode.parentNode) this.imgNode.parentNode.removeChild(this.imgNode);
				this.imgNode = null;
			}
			this.inherited(arguments);
			this.component.widget = null;
		},
		_attrToDom: function(/*String*/ attr, /*String*/ value, /*Object?*/ commands){
		},
		applyWidth: function() {
			var width = "";
			if (this.component.hasSetWidth || !this.component.hasDerivedSize()) {
				width = this.component.width + "px";
			}
			this.domNode.style.width = width;
		},
		applyHeight: function() {
			var height = "";
			if (this.component.hasSetHeight || !this.component.hasDerivedSize()) {
				height = this.component.height + "px";
			}
			this.domNode.style.height = height;
		},
		applyX: function() {
			if (RootComponent.Singleton.rtlMirroring) {
				this.domNode.style.left = "";
				this.domNode.style.right = (this.component.x - this.component.xoffset) + "px";
			}
			else {
				this.domNode.style.right = "";
				this.domNode.style.left = (this.component.x - this.component.xoffset) + "px";
			}
		},
		applyY: function() {
			this.domNode.style.top = (this.component.y - this.component.yoffset) + "px";
		},
		applyCurrentImageSource: function() {
			if (this.component.ancestorsDisplayed && this.component.visible) {
				if (this.swfNode) {
					if(this.swfNode.parentNode)this.swfNode.parentNode.removeChild(this.swfNode);
					this.swfNode = null;
				}
				var url = this.component.currentImageSource ? "url('" + this.component.currentImageSource + "')" : "none";
				if (this.component.currentImageSource && this.component.currentImageSource.endsWith(".swf")) {
					var scale = "default";
					var width = this.component.currentImageWidth;
					var height = this.component.currentImageHeight;
					var stretches = this.component.stretches;
					if (stretches == "both" || stretches == "width") {
						width = "100%";
						scale = "exactfit";
					}
					if (stretches == "both" || stretches == "height") {
						height = "100%"
						scale = "exactfit";
					}
					this.swfNode = domConstruct.toDom("<embed id=\"progressIndicatorOnFlashObject\" src=\"" + this.component.currentImageSource + "\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" menu=\"false\" width=\"" + width + "\" height=\"" + height + "\" scale=\"" + scale + "\" style=\"position: absolute; pointer-events:none;\" />");
					//pointer events set to none, so onclick event will be fired on this.domNode. 
					this.domNode.insertBefore(this.swfNode, this.domNode.firstChild);
					url = "none";
				}
				this.domNode.style.backgroundImage = url;
			}
		},
		applyImageSource: function() {
			if (this.imgNodeHandles != null) {
				for (var i = 0; i < this.imgNodeHandles.length; i++) {
					this.imgNodeHandles[i].remove();
				}
				this.imgNodeHandles = null;
				this.component.imageNaturalWidth = null;
				this.component.imageNaturalHeight = null;
				this.component.updateSize();
			}
			if (this.imgNode) {
				if (this.imgNode.parentNode) this.imgNode.parentNode.removeChild(this.imgNode);
				this.imgNode = null;
			}
			if (this.component.imageSource) {
				this.imgNode = domConstruct.toDom("<img style=\"position:absolute;-moz-user-select:none;outline:none\" src=\"" + this.component.imageSource + "\"></img>");
				if (this.imgNodeHandles == null) {
					this.imgNodeHandles = [];
					var widget = this;
					this.imgNodeHandles.push(on(this.imgNode, "load", function(e) {
						widget.component.imageNaturalHeight = widget.imgNode.naturalHeight;
						widget.component.imageNaturalWidth = widget.imgNode.naturalWidth;
						widget.component.updateSize();
						EventUtil.trigger(widget.component, "onload");
					}));
				}
				this.domNode.insertBefore(this.imgNode, this.domNode.firstChild);
			}
		},
		applyStretches: function() {
			var backgroundRepeat = "no-repeat";
			var backgroundSize = "";
			if (this.component.currentImageWidth != null && !isNaN(this.component.currentImageWidth) &&
				this.component.currentImageHeight != null && !isNaN(this.component.currentImageHeight) &&
				this.component.width != null && !isNaN(this.component.width) &&
				this.component.height != null && !isNaN(this.component.height)) {
				if (this.component.stretches == "width") {
					backgroundSize = this.component.width + "px " + this.component.currentImageHeight + "px";
				}
				else if (this.component.stretches == "height") {
					backgroundSize = this.component.currentImageWidth + "px " + this.component.height + "px";
				}
				else if (this.component.stretches == "both") {
					backgroundSize = this.component.width + "px " + this.component.height + "px";
				}
			}
			this.domNode.style.backgroundRepeat = backgroundRepeat;
			this.domNode.style.backgroundSize = backgroundSize;
			if (this.imgNode) {
				var imgWidth = "";
				var imgHeight = "";
				if (this.component.stretches == "width") {
					imgWidth = this.component.width + "px";
					imgHeight = this.imgNode.naturalHeight + "px";
				}
				else if (this.component.stretches == "height") {
					imgWidth = this.imgNode.naturalWidth + "px";
					imgHeight = this.component.height + "px";
				}
				else if (this.component.stretches == "both") {
					imgWidth = this.component.width + "px";
					imgHeight = this.component.height + "px";
				}
				this.imgNode.style.width = imgWidth;
				this.imgNode.style.height = imgHeight;
			}
		},
		applyBGColor: function() {
			this.domNode.style.backgroundColor = this.component.bgcolor ? this.component.bgcolor : "transparent";
		},
		applyFGColor: function() {
			this.domNode.style.color = this.component.fgcolor ? this.component.fgcolor : "currentColor";
		},
		applyFontstyle: function() {
			var fontWeight = "inherit";
			var fontStyle = "inherit";
			if (this.component.fontstyle == "bold") {
				fontWeight = "bold";
				fontStyle = "normal";
			}
			else if (this.component.fontstyle == "bolditalic") {
				fontWeight = "bold";
				fontStyle = "italic";
			}
			else if (this.component.fontstyle == "italic") {
				fontWeight = "normal";
				fontStyle = "italic";
			}
			else if (this.component.fontstyle == "plain") {
				fontWeight = "normal";
				fontStyle = "normal";
			}
			this.domNode.style.fontWeight = fontWeight;
			this.domNode.style.fontStyle = fontStyle;
		},
		applyFontsize: function() {
			var fontSize = "inherit";
			if (this.component.fontsize != null && !isNaN(this.component.fontsize)) {
				fontSize = this.component.fontsize + "px";
			}
			this.domNode.style.fontSize = fontSize;
		},
		applyVisible: function() {
			this.domNode.style.display = this.component.visible ? "block" : "none";
		},
		applyClickable: function() {
			if (this.component.clickable) {
				this.domNode.style.pointerEvents = "auto";
				domClass.add(this.domNode, "cmcClickable");
				if (this.mouseHandles == null) {
					this.mouseHandles = [];
					var widget = this;
					this.mouseHandles.push(on(this.domNode, "click", function(e) {
						if (ModalUtil.inputAllowed(widget.component)) {
							if (EventUtil.trigger(widget.component, "onclick")) {
								e.stopPropagation();
							}
						}
					}));
					this.mouseHandles.push(on(this.domNode, "dblclick", function(e) {
						if (ModalUtil.inputAllowed(widget.component)) {
							if (EventUtil.trigger(widget.component, "ondblclick") || widget.component.stopDoubleClickPropagation) {
								e.stopPropagation();
							}
						}
					}));
					this.mouseHandles.push(on(this.domNode, "mouseover", function(e) {
						var mouseOverComponent = null;
						var c = widget.component;
						while (c != null) {
							if (c.clickable && EventUtil.hasListener(c, "onmouseover")) {
								mouseOverComponent = c;
								break;
							}
							c = c.immediateParent;
						}
						if (MouseUtil.currentMouseOverComponent != mouseOverComponent) {
							if (MouseUtil.currentMouseOverComponent != null) {
								EventUtil.trigger(MouseUtil.currentMouseOverComponent, "onmouseout");
								EventUtil.trigger(MouseUtil, "onmouseout", MouseUtil.currentMouseOverComponent);
								MouseUtil.currentMouseOverComponent = null;
							}
							if (mouseOverComponent != null && ModalUtil.inputAllowed(widget.component)) {
								MouseUtil.currentMouseOverComponent = mouseOverComponent;
								EventUtil.trigger(mouseOverComponent, "onmouseover");
							}
						}
						e.stopPropagation();
						EventUtil.trigger(MouseUtil, "onmouseover", widget.component);
					}));
					this.mouseHandles.push(on(this.domNode, "mouseout", function(e) {
						var triggerMouseOut = widget.component == MouseUtil.currentMouseOverComponent;
						if (e.relatedTarget && dom.isDescendant(e.relatedTarget, widget.domNode)) {
							var relatedWidget = registry.getEnclosingWidget(e.relatedTarget);
							while (relatedWidget && !relatedWidget.component.clickable) {
								if (relatedWidget.component.immediateParent) {
									relatedWidget = relatedWidget.component.immediateParent.widget;
								}
								else {
									relatedWidget = null;
								}
							}
							if (relatedWidget == widget) {
								triggerMouseOut = false;
							}
						}
						if (triggerMouseOut) {
							MouseUtil.currentMouseOverComponent = null;
							EventUtil.trigger(widget.component, "onmouseout");
						}
						e.stopPropagation();
						EventUtil.trigger(MouseUtil, "onmouseout", widget.component);
					}));
				}
			}
			else {
				this.domNode.style.pointerEvents = "none";
				domClass.remove(this.domNode, "cmcClickable");
				if (this.mouseHandles != null) {
					for (var i = 0; i < this.mouseHandles.length; i++) {
						this.mouseHandles[i].remove();
					}
					this.mouseHandles = null;
				}
			}
		},
		applyContextMenu: function(){
			if (this.component.contextMenu){
				this.domNode.style.pointerEvents = "auto";
			}
		},
		applyClip: function() {
			this.domNode.style.overflow = this.component.clip ? "hidden" : "";
		},
		applyOpacity: function() {
			this.domNode.style.opacity = (this.component.opacity == null || isNaN(this.component.opacity)) ? "" : this.component.opacity;
		},
		applyModal: function() {
			var modal = ModalUtil.getModalComponent() == this.component;
			if (modal) {
				domClass.add(this.domNode, "cmcModal");
			}
			else {
				domClass.remove(this.domNode, "cmcModal");
			}
		},
		sendBehind: function(component) {
			var widget = component ? component.widget : null;
			if (widget != null && widget.parentWidget != null && widget.parentWidget.containerNode != null && widget.domNode != null &&
				this.parentWidget != null && widget.parentWidget.containerNode == this.parentWidget.containerNode && this.domNode != null) {
				this.removeCKEditor();
				widget.parentWidget.containerNode.insertBefore(this.domNode, widget.domNode);
				this.restoreCKEditor();
			}
		},
		sendInFrontOf: function(component) {
			var widget = component ? component.widget : null;
			if (widget != null && widget.parentWidget != null && widget.parentWidget.containerNode != null && widget.domNode != null &&
				this.parentWidget != null && widget.parentWidget.containerNode == this.parentWidget.containerNode && this.domNode != null) {
				widget.removeCKEditor();
				widget.parentWidget.containerNode.insertBefore(widget.domNode, this.domNode);
				widget.restoreCKEditor();
			}
		},
		sendToBack: function() {
			if (this.parentWidget != null && this.parentWidget.containerNode != null && this.parentWidget.containerNode.firstChild != this.domNode && this.domNode != null) {
				this.removeCKEditor();
				this.parentWidget.containerNode.insertBefore(this.domNode, this.parentWidget.containerNode.firstChild);
				this.restoreCKEditor();
			}
		},
		bringToFront: function() {
			if (this.parentWidget != null && this.parentWidget.containerNode != null && this.domNode != null && this.domNode != this.parentWidget.containerNode.lastChild) {
				this.removeCKEditor();
				this.parentWidget.containerNode.appendChild(this.domNode);
				this.restoreCKEditor();
			}
		},
		getIndex: function() {
			var index = -1;
			if (this.parentWidget != null && this.parentWidget.containerNode != null && this.domNode != null) {
				var nodeList = this.parentWidget.containerNode.children;
				for (var i = 0; i < nodeList.length; i++) {
					if (nodeList.item(i) == this.domNode) {
						index = i;
						break;
					}
				}
			}
			return index;
		},
		setFocus: function() {
			if (RootComponent.Singleton.widget) {
				RootComponent.Singleton.widget.domNode.tabIndex = -1;
				RootComponent.Singleton.widget.domNode.focus();
			}
		},
		getWidgetWidth: function() {
			return this.domNode != null ? this.domNode.offsetWidth : 0;
		},
		getWidgetHeight: function() {
			return this.domNode != null ? this.domNode.offsetHeight : 0;
		},
		restoreCKEditor: function(){
			var node = this.domNode;
			if (this.parentWidget.component && this.parentWidget.component.moduleName == "cmc/foundation/PropertyTabs"){
				node = this.parentWidget.containerNode.lastChild;
			}
			query('.CMCtextarea.richInputText', node).forEach(function(node){
				var w = registry.getEnclosingWidget(node);
				if (typeof w['restoreCKEditor'] == 'function'){
					w.restoreCKEditor();
				}
			});
		},
		removeCKEditor: function(){
			var node = this.domNode;
			if (this.parentWidget.component && this.parentWidget.component.moduleName == "cmc/foundation/PropertyTabs"){
				node = this.parentWidget.containerNode;
			}
			query('.CMCtextarea.richInputText', node).forEach(function(node){
				var w = registry.getEnclosingWidget(node);
				if (typeof w['removeCKEditor'] == 'function'){
					w.removeCKEditor();
				}
			});
		}
	});
});