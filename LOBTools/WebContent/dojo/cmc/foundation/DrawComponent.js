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
	"cmc/foundation/Component",
	"cmc/foundation/widgets/DrawWidget",
	"exports"
], function(declare, Component, DrawWidget, exports) {
	exports.Class = declare(Component.Class, {
		moduleName: "cmc/foundation/DrawComponent",
		widgetClass: DrawWidget,
		strokeStyle: "#000000",
		lineWidth: 1,
		
		beginPath: function() {
			if (this.widget) {
				this.widget.beginPath();
			}
		},
			
		clear: function() {
			if (this.widget) {
				this.widget.clear();
			}
		},
		
		lineTo: function(x, y) {
			if (this.widget) {
				this.widget.lineTo(x, y);
			}
		},
		
		closePath: function() {
			if (this.widget) {
				this.widget.closePath();
			}
		},
		
		moveTo: function(x, y) {
			if (this.widget) {
				this.widget.moveTo(x, y);
			}
		},
		
		stroke: function() {
			if (this.widget) {
				this.widget.stroke();
			}
		},
		
		updateRtlMirroring: function() {
			this.inherited(arguments);
			if (this.widget) {
				this.widget.render();
			}
		}
	});
	return exports;
});
