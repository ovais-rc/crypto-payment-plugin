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
		axis: "x",
		spacing: 1,
		xinset: 0,
		yinset: 0,
		xspacing: undefined,
		yspacing: undefined,
		update: function() {
			if (!this.locked) {
				this.lock();
				this.updateHandler.disconnectAll();
				this.updateHandler.connect(this.immediateParent, this.axis == "y" ? "onheight" : "onwidth");
				var sizeVariable = this.axis == "x" ? "width" : "height";
				var rowSizeVariable = this.axis == "x" ? "height" : "width";
				var wrapSize = this.immediateParent[sizeVariable];
				var inset = this.axis == "x" ? this.xinset : this.yinset;
				var rowInset = this.axis == "x" ? this.yinset : this.xinset;
				var pos = inset;
				var rowPos = rowInset;
				var rowSize = 0;
				var rowCount = 0;
				var posVariable = this.axis;
				var rowPosVariable = this.axis == "x" ? "y" : "x";
				var xspacing = typeof(this.xspacing) == "undefined" ? this.spacing : this.xspacing;
				var yspacing = typeof(this.yspacing) == "undefined" ? this.spacing : this.yspacing;
				var rowSpacing = this.axis == "x" ? xspacing : yspacing;
				var rowSizeSpacing = this.axis == "x" ? yspacing : xspacing;
				for (var i = 0; i < this.components.length; i++) {
					var c = this.components[i];
					this.updateHandler.connect(c, "onvisible");
					if (c.visible) {
						this.updateHandler.connect(c, "onheight");
						this.updateHandler.connect(c, "onwidth");
						var size = c[sizeVariable];
						if (rowCount > 0 && (pos + size + this.spacing) > wrapSize) {
							pos = inset;
							rowPos += rowSize + rowSpacing;
							rowCount = 0;
							rowSize = 0;
						}
						c.setVariable(posVariable, pos);
						pos += size + rowSizeSpacing;
						c.setVariable(rowPosVariable, rowPos);
						if (rowSize < c[rowSizeVariable]) {
							rowSize = c[rowSizeVariable];
						}
						rowCount++;
					}
				}
			}
			this.locked = false;
		}
	});
	return exports;
});