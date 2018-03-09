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
	"cmc/foundation/Component",
	"cmc/foundation/TrackUtil",
	"cmc/foundation/EventUtil",
	"exports"
], function(declare, Component, TrackUtil, EventUtil, exports) {
	exports.Class = declare(Component.Class, {
		moduleName: "cmc/foundation/TrackComponent",
		tracking: false,
		
		constructor: function(parent, args) {
			this.trackGroupName = "trackGroup" + this.getUID();
		},
		
		init: function() {
			this.inherited(arguments);
			TrackUtil.register(this, this.trackGroupName);
			EventUtil.connect(this, "onmousedown", this, "activateTracking");
			EventUtil.connect(this, "onmouseup", this, "deactivateTracking");
		},
		
		destroy: function() {
			EventUtil.disconnect(this, "onmouseup", this, "deactivateTracking");
			EventUtil.disconnect(this, "onmousedown", this, "activateTracking");
			TrackUtil.unregister(this, this.trackGroupName);
			this.inherited(arguments);
		},
		
		addChildComponent: function(childComponent) {
			this.inherited(arguments);
			TrackUtil.register(childComponent, this.trackGroupName);
			EventUtil.connect(childComponent, "onmousedown", this, "activateTracking");
			EventUtil.connect(childComponent, "onmouseup", this, "deactivateTracking");
		},
		
		removeChildComponent: function(childComponent) {
			EventUtil.disconnect(childComponent, "onmouseup", this, "deactivateTracking");
			EventUtil.disconnect(childComponent, "onmousedown", this, "activateTracking");
			TrackUtil.unregister(childComponent, this.trackGroupName);
			this.inherited(arguments);
		},
		
		set_tracking: function(value) {
			if (this.tracking != value) {
				this.tracking = value;
				if (value) {
					TrackUtil.activate(this.trackGroupName);
				}
				else {
					TrackUtil.deactivate(this.trackGroupName);
				}
			}
			EventUtil.trigger(this, "ontracking");
		},
		
		activateTracking: function() {
			this.setVariable("tracking", true);
		},
		
		deactivateTracking: function() {
			this.setVariable("tracking", false);
		}

	});
	return exports;
});
