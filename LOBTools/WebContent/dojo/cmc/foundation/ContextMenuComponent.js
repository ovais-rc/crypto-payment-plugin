//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"cmc/foundation/MouseUtil",
	"cmc/foundation/widgets/ContextMenuWidget",
	"cmc/foundation/FocusUtil",
	"cmc/RootComponent",
	"cmc/foundation/Component",
	"exports"
], function(declare, MouseUtil, ContextMenuWidget, FocusUtil, RootComponent, Component, exports) {
	exports.Class = declare(Component.Class, {
		moduleName: "cmc/foundation/ContextMenuComponent",
		visible: false,
		focusable: true,
		owner: null,
		widgetClass: ContextMenuWidget,
		ignoreLayout: true,
		restoreFocusView: null,
		select: function(offset) {
			if (this.owner) {
				this.hide();
				this.owner._select(offset);
			}
		},
		show: function() {
			if (this.restoreFocusView == null) {
				this.restoreFocusView = FocusUtil.getFocus();
			}
			this.sendToBack();
			this.setVariable('visible', true);
			var pos = {
				x: MouseUtil.mouseX,
				y: MouseUtil.mouseY
			};
			if (pos.x > RootComponent.Singleton.width - this.width) pos.x = RootComponent.Singleton.width - this.width;
			if (pos.y > RootComponent.Singleton.height - this.height) pos.y = RootComponent.Singleton.height - this.height;
			this.setVariable('x', pos.x);
			this.setVariable('y', pos.y);
			this.bringToFront();
			FocusUtil.setFocus(this);
		},
		hide: function() {
			if (this.owner) {
				this.owner._hide();
			}
			this.setVariable('visible', false);
			if (this.restoreFocusView) {
				FocusUtil.setFocus(this.restoreFocusView);
			}
		},
		setItems: function(newitems) {
			if (this.widget) {
				this.widget.set("items", newitems);
			}
		},
		checkMouse: function() {
			if (!this.containsPt(this.getMouse("x"), this.getMouse("y"))) {
				this.hide();
			}
		}
	});
	return exports;
});