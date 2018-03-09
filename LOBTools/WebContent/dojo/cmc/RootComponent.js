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
	"cmc/shell/ManagementCenter",
	"cmc/foundation/DefinitionUtil",
	"cmc/foundation/EventUtil",
	"cmc/foundation/FocusUtil",
	"cmc/foundation/ModalUtil",
	"cmc/foundation/widgets/ComponentWidget",
	"dojo/dom",
	"dojo/dom-class",
	"exports"
], function(declare, ManagementCenter, DefinitionUtil, EventUtil, FocusUtil, ModalUtil, ComponentWidget, dom, domClass, exports) {
	var RootComponentWidget = declare(ComponentWidget, {
		postCreate: function() {
			this.inherited(arguments);
			dom.byId("mainContent").appendChild(this.domNode);
		},
		applyModal: function() {
			var modal = ModalUtil.getModalComponent() == null;
			if (modal) {
				domClass.add(this.domNode, "cmcModal");
			}
			else {
				domClass.remove(this.domNode, "cmcModal");
			}
		}
	});
	exports.moduleName = "cmc/RootComponent";
	exports.baseClassModule = ManagementCenter;
	exports.classProps = {
		widgetClass: RootComponentWidget,
		focustrap: true,
		constructor: function(parent, args) {
			FocusUtil.rootComponent = this;
			ModalUtil.rootComponent = this;
		},
		createWidget: function() {
			this.inherited(arguments);
			EventUtil.connect(document, "onresize", this, "updateSize");
			this.updateSize();
		},
		updateSize: function() {
			var newWidth = document.documentElement.clientWidth;
			if (newWidth != this.width) {
				this.setVariable("width", newWidth);
			}
			var newHeight = document.documentElement.clientHeight;
			if (newHeight != this.height) {
				this.setVariable("height", newHeight);
			}
		},
		setDefaultContextMenu: function(menu) {
			this.setVariable("contextMenu", menu);
		}
	};
	DefinitionUtil.createSingleton(exports);
	return exports;
});