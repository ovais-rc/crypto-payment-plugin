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
		spacing: 0,
		update: function() {
			if (!this.locked) {
				this.lock();
				this.updateHandler.disconnectAll();
				this.updateHandler.connect(this.immediateParent, this.axis == "y" ? "onheight" : "onwidth");
				var stretchableCount = 0;
				var stretchableSize = this.immediateParent[this.axis == "y" ? "height" : "width"];
				var first = true;
				for (var i = 0; i < this.components.length; i++) {
					var c = this.components[i];
					this.updateHandler.connect(c, "onvisible");
					if (c.visible) {
						if (!first) {
							stretchableSize -= this.spacing;
						}
						else {
							first = false;
						}
						stretchableSize -= this.spacing;
						if (c.stretchable) {
							stretchableCount++;
						}
						else {
							this.updateHandler.connect(c, this.axis == "y" ? "onheight" : "onwidth");
							stretchableSize -= this.axis == "y" ? c.height : c.width;
						}
					}
				}
				if (stretchableSize > 0 && stretchableCount != 0) {
					stretchableSize /= stretchableCount;
				}
				else {
					stretchableSize = 0;
				}
				var pos = 0;
				for (var i = 0; i < this.components.length; i++) {
					var c = this.components[i];
					if (c.visible) {
						c.setVariable(this.axis, pos);
						if (c.stretchable) {
							c.setVariable(this.axis == "y" ? "height" : "width", stretchableSize);
						}	
						pos += this.spacing + c[this.axis == "y" ? "height" : "width"];
					}
				}
			}
			this.locked = false;
		}
	});
	return exports;
});
