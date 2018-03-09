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
		update: function() {
			if (!this.locked && this.components.length >= 3) {
				this.lock();
				this.updateHandler.disconnectAll();
				this.updateHandler.connect(this.immediateParent, this.axis == "y" ? "onheight" : "onwidth");
				var totalSize = this.immediateParent[this.axis == "y" ? "height" : "width"];
				var c1 = this.components[0];
				var c2 = this.components[1];
				var c3 = this.components[2];
				this.updateHandler.connect(c1, this.axis == "y" ? "onheight" : "onwidth");
				this.updateHandler.connect(c3, this.axis == "y" ? "onheight" : "onwidth");
				var size1 = this.axis == "y" ? c1.height : c1.width;
				var size3 = this.axis == "y" ? c3.height : c3.width;
				var size2 = totalSize - size1 - size3;
				if (size2 < 0) {
					size2 = 0;
				}
				c1.setVariable(this.axis, 0);
				c3.setVariable(this.axis, totalSize - size3);
				c2.setVariable(this.axis, size1);
				c2.setVariable(this.axis == "y" ? "height" : "width", size2);
				this.locked = false;
			}
		}
	});
	return exports;
});