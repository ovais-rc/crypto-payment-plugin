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
	"cmc/foundation/EventUtil",
	"exports"
], function (declare, EventUtil, exports) {
	exports.Class = declare(null, {
		context: null,
		method: null,
		constructor: function(context, method, eventSource, eventName) {
			this.context = context;
			this.method = method;
			if (eventSource && eventName) {
				this.connect(eventSource, eventName);
			}
		},

		connect: function(eventSource, eventName) {
			EventUtil.connect(eventSource, eventName, this, "execute");
		},
		
		execute: function(args) {
			this.context[this.method].call(this.context, args);
		},
	
		disconnectAll: function() {
			EventUtil.disconnectAll(this, "execute");
		},

		disconnect: function(eventSource, eventName){
			EventUtil.disconnect(eventSource, eventName, this, "execute");
		},
		
		disable: function() {
			EventUtil.disable(this, "execute");
		},
		
		enable: function() {
			EventUtil.enable(this, "execute");
		},
		
		getEventCount: function(context, method, scope) {
			return EventUtil.getEventCount(this, "execute");
		}
	});
	return exports;
});
