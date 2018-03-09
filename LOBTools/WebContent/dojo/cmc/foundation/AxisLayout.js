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
	"cmc/foundation/Layout",
	"exports"
], function(declare, Layout, exports) {
	exports.Class = declare(Layout.Class, {
		axis: "y",
		inset: 0,
		spacing: 0,
		addComponent: function(component) {
			this.updateHandler.connect(component, "onvisible");
			this.updateHandler.connect(component, this.axis == "y" ? "onheight" : "onwidth");
			this.inherited(arguments);
		},
		removeComponent: function(component) {
			this.updateHandler.disconnectAll();
			for (var i = 0; i < this.components.length; i++) {
				var c = this.components[i];
				if (c != component) {
					this.updateHandler.connect(c, "onvisible");
					this.updateHandler.connect(c, this.axis == "y" ? "onheight" : "onwidth");
				}
			}
			this.inherited(arguments);
		},
		update: function() {
			if (!this.locked) {
				var pos = this.inset;
				this.immediateParent.lockUpdateSize();
				for (var i = 0; i < this.components.length; i++) {
					var c = this.components[i];
					if (c.visible) {
						c.setVariable(this.axis, pos);
						pos += this.spacing + c[this.axis == "y" ? "height" : "width"];
					}
				}
				this.immediateParent.unlockUpdateSize();
			}
		}
	});
	return exports;
});
