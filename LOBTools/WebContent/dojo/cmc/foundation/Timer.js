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
	"cmc/foundation/EventUtil"
], function(declare, EventUtil) {
	return new declare(null, {
		timers: null,
		
		constructor: function() {
			this.timers = [];
		},
		
		addTimer: function(eventHandler, interval) {
			this.removeTimer(eventHandler);
			var Timer = this;
			var timerId = window.setTimeout(function() {
				Timer.removeTimer(eventHandler);
				eventHandler.execute();
			}, interval);
			this.timers.push({id: timerId, eventHandler: eventHandler});
		},
		
		removeTimer: function(eventHandler) {
			for (var i = 0; i < this.timers.length; i++) {
				if (this.timers[i].eventHandler == eventHandler) {
					window.clearTimeout(this.timers[i].id);
					this.timers.splice(i, 1);
					break;
				}
			}
		},
		
		resetTimer: function(eventHandler, interval) {
			this.removeTimer(eventHandler);
			this.addTimer(eventHandler, interval);
		}
	})();
});
