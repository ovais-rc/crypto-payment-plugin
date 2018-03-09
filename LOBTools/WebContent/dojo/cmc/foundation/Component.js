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
	"cmc/foundation/Node",
	"cmc/foundation/KeyUtil",
	"cmc/foundation/EventUtil",
	"cmc/foundation/MouseUtil",
	"cmc/foundation/widgets/ComponentWidget",
	"cmc/RootComponent",
	"cmc/foundation/ImageRegistry",
	"cmc/foundation/AxisLayout",
	"dojo/dom-geometry",
	"dojo/json",
	"exports"
], function(declare, Node, KeyUtil, EventUtil, MouseUtil, ComponentWidget, RootComponent, ImageRegistry, AxisLayout, domGeometry, json, exports) {
	exports.Class = declare(Node.Class, {
		moduleName: "cmc/foundation/Component",
		focusable: false,
		visible: true,
		width: undefined,
		height: undefined,
		x: 0,
		y: 0,
		yoffset: 0,
		xoffset: 0,
		hasSetHeight: false,
		hasSetWidth: false,
		bgcolor: null,
		fgcolor: null,
		widgetClass: ComponentWidget,
		widget: undefined,
		childComponents: undefined,
		style: null,
		layouts: null,
		ignoreLayout: false,
		ignoreSize: false,
		layoutProperties: null,
		stretchable: false,
		imageSet: null,
		totalImages: 0,
		currentImage: 1,
		currentImageSource: null,
		currentImageWidth: null,
		currentImageHeight: null,
		imageSource: null,
		imageNaturalWidth: null,
		imageNaturalHeight: null,
		align: null,
		valign: null,
		stretches: null,
		fontstyle: null,
		fontsize: null,
		value: null,
		clip: false,
		opacity: null,
		enabled: true,
		level: 0,
		updateSizeLock: 0,
		focustrap: false,
		contextMenu: null,
		ancestorsDisplayed: false,
		stopDoubleClickPropagation: false,
		clickable: false,
		
		constructor: function(parent, args) {
			if (parent == null && RootComponent != this.module) {
				this.parent = RootComponent.Singleton;
				this.immediateParent = RootComponent.Singleton;
			}
			if (typeof this.width != "undefined") {
				this.hasSetWidth = true;
			}
			if (typeof this.height != "undefined") {
				this.hasSetHeight = true;
			}
			if (this.initPendingVariables) {
				for (var i = 0; i < this.initPendingVariables.length; i++) {
					if (this.initPendingVariables[i].name == "width") {
						this.hasSetWidth = true;		
					}
					else if (this.initPendingVariables[i].name == "height") {
						this.hasSetHeight = true;
					}
				}
			}
			this.layouts = [];
			this.childComponents = [];
			if (this.immediateParent instanceof exports.Class) {
				this.immediateParent.addChildComponent(this);
			}
		},
		
		postscript: function(parent, args) {
			this.inherited(arguments);
			if (this.layoutProperties != null) {
				var propertyString = "{" + this.layoutProperties + "}";
				new AxisLayout.Class(this, json.parse(propertyString, false));
			}
		},
		
		destroy: function() {
			if (this.immediateParent instanceof exports.Class) {
				this.immediateParent.removeChildComponent(this);
			}
			if (this.widget) {
				this.widget.destroyRecursive();
				this.widget = null;
			}
			this.inherited(arguments);
		},
		
		doInit: function(parent, args) {
			if (!this.inited) {
				if (this.immediateParent == null || (this.immediateParent.ancestorsDisplayed && this.immediateParent.visible)) {
					this.setAncestorsDisplayed();
				}
				this.createWidget();
				this.inherited(arguments);
				this._applystyle(this.style);
				this.updateSize();
				if (!this.ignoreSize && this.immediateParent && this.immediateParent.updateSize) {
					this.immediateParent.updateSize();
				}
				if (this.layouts) {
					for (var i = 0; i < this.layouts.length; i++) {
						this.layouts[i].locked = false;
						if (this.layouts[i].active) {
							this.layouts[i].update();
						}
					}
				}
			}
		},
		
		createWidget: function() {
			if (this.widget == null && this.widgetClass && (this.immediateParent == null || this.immediateParent.widget)) {
				var widgetArgs = {
					component: this
				};
				if (this.immediateParent && this.immediateParent.widget) {
					widgetArgs.parentWidget = this.immediateParent.widget;
				}
				this.widget = new this.widgetClass(widgetArgs);
				if (this.moduleName) {
					this.widget.domNode.setAttribute("moduleName", this.moduleName);
				}
				this.createChildWidgets();
			}
		},
		
		createSiblingWidgets: function() {
			if (this.immediateParent != null && this.immediateParent.childComponents != null) {
				this.createChildWidgets();
			}
		},
		
		createChildWidgets: function() {
			if (this.childComponents != null) {
				var components = this.childComponents;
				for (var i = 0; i < components.length; i++) {
					var c = components[i];
					if (c.initstage != "defer") {
						c.createWidget();
					}
				}
			}
		},
		
		addChildComponent: function(childComponent) {
			childComponent.level = this.level + 1;
			if (this.childComponents == null) {
				this.childComponents = [];
			}
			this.childComponents.push(childComponent);
			if (this.layouts != null && !childComponent.ignoreLayout) {
				for (var i = 0; i < this.layouts.length; i++) {
					this.layouts[i].addComponent(childComponent);
				}
			}
			EventUtil.trigger(this, "onaddChildComponent", childComponent);
		},
		
		removeChildComponent: function(childComponent) {
			if (this.childComponents != null) {
				var index = this.childComponents.indexOf(childComponent);
				if (index != -1) {
					this.childComponents.splice(index, 1);
				}
			}
			if (this.layouts != null) {
				for (var i = 0; i < this.layouts.length; i++) {
					this.layouts[i].removeComponent(childComponent);
				}
			}
		},
		
		initializeVariables: function() {
			if (RootComponent.Singleton) {
				this.style = RootComponent.Singleton.style;
			}
			this.inherited(arguments);
		},
		
		addEvent: function(eventName) {
			if (!this.clickable) {
				switch (eventName) {
				case "onclick":
				case "ondblclick":
				case "onmousedown":
				case "onmouseout":
				case "onmouseover":
				case "onmouseup":
					this.setVariable("clickable", true);
				}
			}
		},
		
		set_visible: function(value) {
			this.visible = value;
			if (this.widget) {
				this.widget.applyVisible();
			}
			if (this.ancestorsDisplayed && this.visible) {
				this.setChildComponentsAncestorsDisplayed();
				if (this.widget) {
					this.widget.applyCurrentImageSource();
				}
			}
			if (this.inited) {
				if (this.visible) {
					this.updateChildComponentsSize();
					this.updateSize(true);
				}
				if (!this.ignoreSize && this.immediateParent && this.immediateParent.updateSize) {
					this.immediateParent.updateSize();
				}
				EventUtil.trigger(this, "onvisible", value);
			}
		},
		
		setAncestorsDisplayed: function() {
			if (!this.ancestorsDisplayed) {
				this.ancestorsDisplayed = true;
				if (this.visible) {
					this.setChildComponentsAncestorsDisplayed();
					if (this.widget) {
						this.widget.applyCurrentImageSource();
					}
				}
			}
		},
		
		setChildComponentsAncestorsDisplayed: function() {
			if (this.childComponents) {
				for (var i = 0; i < this.childComponents.length; i++) {
					var c = this.childComponents[i];
					c.setAncestorsDisplayed();
				}
			}
		},
		
		set_width: function(value) {
			if (value === null || typeof value == "undefined") {
				this.hasSetWidth = false;
				this.width = undefined;
				this.updateSize();
			}
			else {
				this.hasSetWidth = true;
				this.width = value;
				if (this.widget) {
					this.widget.applyWidth();
					this.widget.applyStretches();
				}
				if (!this.ignoreSize && this.immediateParent && this.immediateParent.updateSize) {
					this.immediateParent.updateSize();
				}
				EventUtil.trigger(this, "onwidth", value);
			}
		},
	
		set_height: function(value) {
			if (value === null || typeof value == "undefined") {
				this.hasSetHeight = false;
				this.height = undefined;
				this.updateSize();
			}
			else {
				this.hasSetHeight = true;
				this.height = value;
				if (this.widget) {
					this.widget.applyHeight();
					this.widget.applyStretches();
				}
				if (!this.ignoreSize && this.immediateParent && this.immediateParent.updateSize) {
					this.immediateParent.updateSize();
				}
				EventUtil.trigger(this, "onheight", value);
			}
		},
		
		set_x: function(value) {
			this.x = value;
			if (this.widget) {
				this.widget.applyX();
			}
			if (!this.ignoreSize && this.immediateParent && this.immediateParent.updateSize) {
				this.immediateParent.updateSize();
			}
			EventUtil.trigger(this, "onx", value);
		},
	
		set_y: function(value) {
			this.y = value;
			if (this.widget) {
				this.widget.applyY();
			}
			if (!this.ignoreSize && this.immediateParent && this.immediateParent.updateSize) {
				this.immediateParent.updateSize();
			}
			EventUtil.trigger(this, "ony", value);
		},
		
		set_xoffset: function(value) {
			this.xoffset = value;
			if (this.widget) {
				this.widget.applyX();
			}
			EventUtil.trigger(this, "xoffset", value);
		},
		
		set_yoffset: function(value) {
			this.yoffset = value;
			if (this.widget) {
				this.widget.applyY();
			}
			EventUtil.trigger(this, "yoffset", value);
		},
		
		set_contextMenu: function(value){
			this.contextMenu = value;
			if(this.widget){
				this.widget.applyContextMenu();
			}
			EventUtil.trigger(this, "oncontextMenu", value);
		},
		
		lockUpdateSize: function() {
			this.updateSizeLock++;
		},
		
		unlockUpdateSize: function() {
			if (this.updateSizeLock > 0) {
				this.updateSizeLock--;
				if (this.updateSizeLock == 0) {
					this.updateSize();
				}
			}
		},
		
		hasDerivedSize: function() {
			return (this.childComponents == null || this.childComponents.length == 0) && this.imageSet == null && this.imageSource == null;
		},
		
		updateSize: function(skipParentUpdate) {
			if (!this.updateSizeLock && (!this.hasSetWidth || !this.hasSetHeight)) {
				var newWidth = 0;
				var newHeight = 0;
				var updateWidget = false;
				if (this.hasDerivedSize()) {
					if (this.widget != null) {
						newWidth = this.widget.getWidgetWidth() + this.xoffset;
						newHeight = this.widget.getWidgetHeight() + this.yoffset;
					}
				}
				else {
					updateWidget = true;
					if (this.childComponents != null) {
						for (var i = 0; i < this.childComponents.length; i++) {
							var c = this.childComponents[i];
							if (c.visible && !c.ignoreSize) {
								var w = (c.x > 0 ? c.x : 0) + c.width + c.xoffset;
								if (newWidth < w) {
									newWidth = w;
								}
								var h = (c.y > 0 ? c.y : 0) + c.height + c.yoffset;
								if (newHeight < h) {
									newHeight = h;
								}
							}
						}
					}
					if (this.currentImageWidth != null && this.currentImageWidth > newWidth) {
						newWidth = this.currentImageWidth;
					}
					if (this.currentImageHeight != null && this.currentImageHeight > newHeight) {
						newHeight = this.currentImageHeight;
					}
					if (this.imageNaturalWidth != null && this.imageNaturalWidth > newWidth) {
						newWidth = this.imageNaturalWidth;
					}
					if (this.imageNaturalHeight != null && this.imageNaturalHeight > newHeight) {
						newHeight = this.imageNaturalHeight;
					}
				}
				
				var sizeChanged = false;
				if (!this.hasSetWidth && newWidth !== this.width) {
					sizeChanged = true;
					this.width = newWidth;
					if (this.widget) {
						if (updateWidget) {
							this.widget.applyWidth();
						}
						this.widget.applyStretches();
					}
					EventUtil.trigger(this, "onwidth", newWidth);
				}
				if (!this.hasSetHeight && newHeight !== this.height) {
					sizeChanged = true;
					this.height = newHeight;
					if (this.widget) {
						if (updateWidget) {
							this.widget.applyHeight();
						}
						this.widget.applyStretches();
					}
					EventUtil.trigger(this, "onheight", newHeight);
				}
				if (sizeChanged) {
					if (!skipParentUpdate && !this.ignoreSize && this.immediateParent && this.immediateParent.updateSize) {
						this.immediateParent.updateSize();
					}					
				}
			}
		},
		
		updateChildComponentsSize: function() {
			if (this.childComponents) {
				for (var i = 0; i < this.childComponents.length; i++) {
					var c = this.childComponents[i];
					if (c.visible) {
						c.updateChildComponentsSize();
						c.updateSize(true);
					}
				}
			}
		},

		set_imageSet: function(value) {
			this.imageSet = value;
			this.updateImage();
			EventUtil.trigger(this, "onimageSet", value);
			EventUtil.trigger(this, "ontotalImages", value);
		},
		
		set_currentImage: function(value) {
			if (value != this.currentImage) {
				this.currentImage = value;
				this.updateImage();
				EventUtil.trigger(this, "oncurrentImage", value);
			}
		},
		
		updateImage: function() {
			var newSource = null;
			var newWidth = null;
			var newHeight = null;
			var newTotalImages = 0;
			if (this.imageSet && ImageRegistry[this.imageSet]) {
				var imageSet = ImageRegistry[this.imageSet];
				var image = null;
				var imageIndex = this.currentImage - 1;
				if (imageIndex >= imageSet.length) {
					imageIndex = imageSet.length - 1;
				}
				if (imageIndex >= 0) {
					image = imageSet[imageIndex];
					var imageUri = image.uri;
					var imageHeight = image.height;
					var imageWidth = image.width;
					if (RootComponent.Singleton.rtlMirroring && image.rtl_uri) {
						imageUri = image.rtl_uri;
						imageHeight = image.rtl_height;
						imageWidth = image.rtl_width;
					}
					if (cmcConfig.serviceContextRoot) {
						newSource = cmcConfig.serviceContextRoot + imageUri;
					}
					else {
						newSource = "/lobtools" + imageUri;
					}
					if (typeof imageWidth != "undefined") {
						newWidth = imageWidth;
					}
					if (typeof imageHeight != "undefined") {
						newHeight = imageHeight;
					}
				}
				newTotalImages = imageSet.length;
			}
			this.currentImageWidth = newWidth;
			this.currentImageHeight = newHeight;
			if (this.widget) {
				this.widget.applyStretches();
			}
			this.totalImages = newTotalImages;
			this.currentImageSource = newSource;
			if (this.widget) {
				this.widget.applyCurrentImageSource();
			}
			this.updateSize();
		},
		
		set_imageSource: function(value) {
			this.imageSource = value;
			if (this.widget) {
				this.widget.applyImageSource();
			}
			EventUtil.trigger(this, "onimageSource", value);
		},
		
		set_align: function(value) {
			if (this.align == "right") {
				EventUtil.disconnectAll(this, "_alignRight");
			}
			else if (this.align == "center") {
				EventUtil.disconnectAll(this, "_alignCenter");
			}
			this.align = value;
			if (this.align == "right") {
				this._alignRight();
			}
			else if (this.align == "center") {
				this._alignCenter();
			}
			EventUtil.trigger(this, "onalign", value);
		},
		
		_alignRight: function() {
			EventUtil.disconnectAll(this, "_alignRight");
			this.setVariable("x", Math.max(this.immediateParent.width - this.width, 0));
			EventUtil.connect(this, "onwidth", this, "_alignRight");
			if (this.immediateParent) {
				EventUtil.connect(this.immediateParent, "onwidth", this, "_alignRight");
			}
			if (!this.inited) {
				EventUtil.connect(this, "oninit", this, "_alignRight");
			}
		},
		
		_alignCenter: function() {
			EventUtil.disconnectAll(this, "_alignCenter");
			this.setVariable("x", Math.max(this.immediateParent.width / 2 - this.width / 2, 0));
			EventUtil.connect(this, "onwidth", this, "_alignCenter");
			if (this.immediateParent) {
				EventUtil.connect(this.immediateParent, "onwidth", this, "_alignCenter");
			}
			if (!this.inited) {
				EventUtil.connect(this, "oninit", this, "_alignCenter");
			}
		},
		
		set_valign: function(value) {
			if (this.valign == "bottom") {
				EventUtil.disconnectAll(this, "_valignBottom");
			}
			else if (this.valign == "middle") {
				EventUtil.disconnectAll(this, "_valignMiddle");
			}
			this.valign = value;
			if (this.valign == "bottom") {
				this._valignBottom();
			}
			else if (this.valign == "middle") {
				this._valignMiddle();
			}
			EventUtil.trigger(this, "onvalign", value);
		},
		
		_valignBottom: function() {
			EventUtil.disconnectAll(this, "_valignBottom");
			this.setVariable("y", Math.max(this.immediateParent.height - this.height, 0));
			EventUtil.connect(this, "onheight", this, "_valignBottom");
			if (this.immediateParent) {
				EventUtil.connect(this.immediateParent, "onheight", this, "_valignBottom");
			}
			if (!this.inited) {
				EventUtil.connect(this, "oninit", this, "_valignBottom");
			}
		},
		
		_valignMiddle: function() {
			EventUtil.disconnectAll(this, "_valignMiddle");
			this.setVariable("y", Math.max(this.immediateParent.height / 2 - this.height / 2, 0));
			EventUtil.connect(this, "onheight", this, "_valignMiddle");
			if (this.immediateParent) {
				EventUtil.connect(this.immediateParent, "onheight", this, "_valignMiddle");
			}
			if (!this.inited) {
				EventUtil.connect(this, "oninit", this, "_valignMiddle");
			}
		},
		
		set_bgcolor: function(value) {
			this.bgcolor = value;
			if (this.widget) {
				this.widget.applyBGColor();
			}
			EventUtil.trigger(this, "onbgcolor", value);
		},
		
		set_fgcolor: function(value) {
			this.fgcolor = value;
			if (this.widget) {
				this.widget.applyFGColor();
			}
			EventUtil.trigger(this, "onfgcolor", value);
		},
		
		set_stretches: function(value) {
			this.stretches = value;
			if (this.widget) {
				this.widget.applyStretches();
			}
			EventUtil.trigger(this, "onstretches", value);
		},

		set_fontstyle: function(value) {
			this.fontstyle = value;
			if (this.widget) {
				this.widget.applyFontstyle();
			}
			EventUtil.trigger(this, "onfontstyle", value);
		},
		
		set_fontsize: function(value) {
			this.fontsize = value;
			if (this.widget) {
				this.widget.applyFontsize();
			}
			EventUtil.trigger(this, "onfontsize", value);
		},
		
		set_clickable: function(value) {
			this.clickable = value;
			if (this.widget) {
				this.widget.applyClickable();
			}
			EventUtil.trigger(this, "onclickable", value);
		},
		
		setValue: function(value) {
			this.setVariable("value", value);
		},
		
		set_clip: function(value) {
			this.clip = value;
			if (this.widget) {
				this.widget.applyClip();
			}
			EventUtil.trigger(this, "onclip", value);
		},
		
		set_opacity: function(value) {
			this.opacity = value;
			if (this.widget) {
				this.widget.applyOpacity();
			}
			EventUtil.trigger(this, "onopacity", value);
		},
		
		clear: function() {
			
		},
		containsPt: function(x, y) {
			return x >= 0 && x <= this.width && y >= 0 && y <= this.height;
		},
		getVariableRelative: function(prop, refComponent) {
			var relativeValue = this[prop];
			if (this.widget && refComponent.widget) {
				var widgetPos = domGeometry.position(this.widget.domNode, true);
				var refDomNode = refComponent.widget.parentWidget ? refComponent.widget.parentWidget.domNode : refComponent.widget.domNode.parentElement;
				var refWidgetPos = domGeometry.position(refDomNode, true);
				if (prop == "x") {
					if (RootComponent.Singleton.rtlMirroring) {
						relativeValue = (refWidgetPos.x + refWidgetPos.w) - (widgetPos.x + widgetPos.w);						
					}
					else {
						relativeValue = widgetPos.x - refWidgetPos.x;
					}
				}
				else if (prop == "y") {
					relativeValue = widgetPos.y - refWidgetPos.y;
				}
			}
			return relativeValue;
		},
		getBounds: function() {
			return {
				x: this.x,
				y: this.y,
				width: this.width,
				height: this.height
			};
		},
		getDepthList: function() {
			return [];
		},
		getNextSelection: function() {
			return null;
		},
		getPrevSelection: function() {
			return null;
		},
		isMouseOver: function() {
			return false;
		},
		sendBehind: function(component) {
			if (this.widget) {
				this.widget.sendBehind(component);
			}
		},
		sendInFrontOf: function(component) {
			if (this.widget) {
				this.widget.sendInFrontOf(component);
			}
		},
		bringToFront: function() {
			this.createSiblingWidgets();
			if (this.widget) {
				this.widget.bringToFront();
			}
		},
		sendToBack: function() {
			if (this.widget) {
				this.widget.sendToBack();
			}
		},
		updateResourceSize: function() {
		},
		getValue: function() {
			return this.value;
		},
		_applystyle: function(s) {
			
		},
		getMouse: function(coord) {
			var mousePos = (coord != "x" && coord != "y") ? {x:0,y:0} : 0;
			if (this.widget) {
				var widgetPos = domGeometry.position(this.widget.domNode, true);
				if (coord == "x") {
					if (RootComponent.Singleton.rtlMirroring) {
						mousePos = MouseUtil.mouseX - (RootComponent.Singleton.width - widgetPos.x - widgetPos.w);
					}
					else {
						mousePos = MouseUtil.mouseX - widgetPos.x;
					}
				}
				else if (coord == "y") {
					mousePos = MouseUtil.mouseY - widgetPos.y;
				}
				else {
					if (RootComponent.Singleton.rtlMirroring) {
						mousePos.x = MouseUtil.mouseX - (RootComponent.Singleton.width - widgetPos.x - widgetPos.w);
					}
					else {
						mousePos.x = MouseUtil.mouseX - widgetPos.x;
					}
					mousePos.y = MouseUtil.mouseY - widgetPos.y;
				}
			}
			return mousePos;
		},
		getNewDragPosition: function(coord, newPos) {
			var min = this['drag_min_' + coord];
			var max = this['drag_max_' + coord];
			if ((min != null) && (newPos < min)) newPos = min;
			if ((max != null) && (newPos > max)) newPos = max;
			return newPos;
		},
		getWidgetIndex: function() {
			var index = -1;
			if (this.widget) {
				return this.widget.getIndex();
			}
			return index;
		},
		getInvisibleParent: function() {
			var currentComponent = this;
			while(currentComponent.visible && currentComponent.immediateParent != null){
				currentComponent = currentComponent.immediateParent;
			}
			if (!currentComponent.visible){
				return currentComponent;
			}
			else {
				return null;
			}
		},
		updateRtlMirroring: function() {
			if (this.widget) {
				this.updateImage();
				this.widget.applyX();
			}
			if (this.childComponents) {
				for (var i = 0; i < this.childComponents.length; i++) {
					var c = this.childComponents[i];
					c.updateRtlMirroring();
				}
			}
		}
	});
	return exports;
});
