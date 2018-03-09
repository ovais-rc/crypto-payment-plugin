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
	"dojo/on",
	"dijit/registry",
	"cmc/foundation/EventUtil",
	"cmc/foundation/ModalUtil",
	"cmc/foundation/FocusUtil",
	"cmc/RootComponent"
], function(declare, on, registry, EventUtil, ModalUtil, FocusUtil, RootComponent) {
	return new declare(null, {
		mouseX: 0,
		mouseY: 0,
		currentMouseDownComponent: null,
		currentMouseOverComponent: null,
		constructor: function() {
			var MouseUtil = this;
			on(document, "mousemove", function(e) {
				MouseUtil.handleMouseMove(e);
			});
			on(document, "mousedown", function(e) {
				EventUtil.trigger(MouseUtil, "onmousedown");
				var widget = registry.getEnclosingWidget(e.target);
				if (widget && widget.component) {
					var component = widget.component;
					MouseUtil.handleMouseDown(component);
				}
			});
			on(document, "contextmenu", function(e){
				if (!MouseUtil.allowDefaultContexmenu(e)){
					e.preventDefault();//disable browser default contextmenu
				}
				var widget = registry.getEnclosingWidget(e.target);
				var component = null;
				if (widget && widget.component) {
					component = widget.component;
					if (component.immediateParent != null && component.immediateParent.changeFocus != null && typeof component.immediateParent.changeFocus == 'function'){
						//handle tree scenario
						component.immediateParent.changeFocus(null);
					}
					while(!component.focusable && component.immediateParent != null){
						component = component.immediateParent;
						if (component.immediateParent != null && component.immediateParent.changeFocus != null && typeof component.immediateParent.changeFocus == 'function'){
							//handle tree scenario
							component.immediateParent.changeFocus(null);
						}
					}
					if (component.focusable) {
						FocusUtil.setFocus(component);
					}
					else {
						FocusUtil.fireOnblur();//to reset the context menu of RootComponent
					}
					component = widget.component;
				}
				if(!component || !component.contextMenu || component.contextMenu.isCanvasMenu){
					component = RootComponent.Singleton;
				}
				if (component.contextMenu && !component.contextMenu.isCanvasMenu){
					//isCanvasMenu means no menuitem to display, in flash version of CMC,
					//it will display the flash default contextmenu
					component.contextMenu._show();
				}
			});
			on(document, "mouseup", function(e) {
				EventUtil.trigger(MouseUtil, "onmouseup");
				MouseUtil.handleMouseUp(e);
			});
		},
		handleMouseMove: function(e) {
			this.mouseX = (RootComponent.Singleton && RootComponent.Singleton.rtlMirroring) ? (RootComponent.Singleton.width - e.pageX) : e.pageX;
			this.mouseY = e.pageY;
			if (this.currentMouseDownComponent != null) {
				EventUtil.trigger(this.currentMouseDownComponent, "onmousemove");
			}
			EventUtil.trigger(this, "onmousemove");
		},
		handleMouseDown: function(component) {
			while (!component.clickable && component.immediateParent != null) {
				component = component.immediateParent;
			}
			if (component.clickable) {
				if (ModalUtil.inputAllowed(component)) {
					EventUtil.trigger(component, "onmousedown");
					this.currentMouseDownComponent = component;
					while(!component.focusable && component.immediateParent != null){
						component = component.immediateParent;
					}
					if (component.focusable) {
						if (FocusUtil.getFocus() != component) {
							FocusUtil.setFocus(component, true);
						}
					}
					else {
						FocusUtil.clearFocus();
					}
				}
			}
		},
		handleMouseUp: function(e) {
			if (this.currentMouseDownComponent != null) {
				EventUtil.trigger(this.currentMouseDownComponent, "onmouseup");
				this.currentMouseDownComponent = null;
			}
		},
		allowDefaultContexmenu: function(e){
		//textarea browser contextmenu should be enabled.
			return e.target.tagName.toUpperCase() =='TEXTAREA' || e.target.tagName.toUpperCase() =='INPUT'; 
		}
	})();
});