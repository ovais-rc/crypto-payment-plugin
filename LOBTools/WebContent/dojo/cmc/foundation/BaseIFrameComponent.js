//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2017 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"cmc/foundation/Component",
	"cmc/foundation/widgets/BaseIFrameWidget",
	"cmc/foundation/EventUtil",
	"exports"
], function(declare, Component, BaseIFrameWidget, EventUtil, exports) {
	exports.Class = declare(Component.Class, {
		moduleName: "cmc/foundation/BaseIFrameComponent",
		widgetClass: BaseIFrameWidget,
		src: "",
		set_src: function(src) {
			this.src = src;
			if (this.widget != null) {
				this.widget.applySrc();
			}
			EventUtil.trigger(this, "onsrc", src);
		},
		getSrc: function() {
			return this.src;
		}
	});
	return exports;
});