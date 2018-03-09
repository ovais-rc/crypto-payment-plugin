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
	"cmc/foundation/Node",
	"cmc/foundation/Timer",
	"cmc/foundation/EventUtil",
	"cmc/foundation/EventHandler",
	"exports"
], function(declare, Node, Timer, EventUtil, EventHandler, exports) {
	exports.Class = declare(Node.Class, {
		variable: null,
		from: null,
		to: null,
		start: true,
		duration: 0,
		startTime: null,
		destroyOnStop: false,
		started: false,
		init: function() {
			this.inherited(arguments);
			this.updateDel = new EventHandler.Class(this, "update");
			if (this.start) {
				this.doStart();
			}
		},
		destroy: function() {
			Timer.removeTimer(this.updateDel);
			this.updateDel.disconnectAll();
			delete this.updateDel;
			this.inherited(arguments);
		},
		doStart: function() {
			if (this.started) {
				this.doStop();
			}
			this.started = true;
			this.startTime = new Date().getTime();
			Timer.addTimer(this.updateDel, 25);
		},
		doStop: function() {
			if (this.started) {
				this.started = false;
				Timer.removeTimer(this.updateDel);
				EventUtil.trigger(this, "onstop", this);
				if (this.destroyOnStop) {
					this.destroy();
				}
			}
		},
		update: function() {
			var currentTime = new Date().getTime();
			var elapsedTime = currentTime - this.startTime;
			if (elapsedTime > this.duration || this.duration == 0) {
				this.immediateParent.setVariable(this.variable, this.to);
				this.doStop();
			}
			else {
				var totalDelta = this.to - this.from;
				var currentFraction = elapsedTime / this.duration;
				this.immediateParent.setVariable(this.variable, this.from + (totalDelta * currentFraction));
				if (this.started) {
					Timer.resetTimer(this.updateDel, 25);
				}
			}
		}
	});
	return exports;
});
