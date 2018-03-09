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
	"dojo/_base/declare"
], function(declare) {
	return new declare(null, {
		connect: function(eventSource, eventName, context, method, scope) {
			var agent = this._getAgent(context, method, scope, true);
			if (!eventSource["__cmcEventAgents"]) {
				eventSource["__cmcEventAgents"] = {};
			}
			if (!eventSource.__cmcEventAgents[eventName]) {
				eventSource.__cmcEventAgents[eventName] = [];
				if (eventSource.addEvent) {
					eventSource.addEvent(eventName);
				}
			}
			agent.events.push({source: eventSource, name: eventName});
			if (eventSource.__cmcEventAgents[eventName].indexOf(agent) == -1){
				eventSource.__cmcEventAgents[eventName].push(agent);
			}
		},
		
		disconnect: function(eventSource, eventName, context, method, scope) {
			var agent = this._getAgent(context, method, scope, false);
			if (agent != null) {
				for (var i = 0; i < agent.events.length; i++) {
					if (eventSource == agent.events[i].source && eventName == agent.events[i].name) {
						if (i == agent.events.length - 1) {
							agent.events.length = i;
						}
						else {
							agent.events.splice(i, 1);
						}
						i--;
					}
				}
				if (eventSource["__cmcEventAgents"]) {
					if (eventSource.__cmcEventAgents[eventName]) {
						var eventAgents = eventSource.__cmcEventAgents[eventName];
						for (var i = 0; i < eventAgents.length; i++) {
							if (eventAgents[i] == agent) {
								if (i == eventAgents.length - 1) {
									eventAgents.length = i;
								}
								else {
									eventAgents.splice(i, 1);
								}
								i--;
							}
						}
					}
				}
			}
		},
		
		trigger: function(eventSource, eventName, args) {
			var eventTriggered = false;
			if (eventSource["__cmcEventAgents"] && eventSource.__cmcEventAgents[eventName]) {
				var agents = eventSource.__cmcEventAgents[eventName];
				var executableAgents = [];
				for (var i = 0; i < agents.length; i++) {
					if (agents[i].enabled && !agents[i].locked && executableAgents.indexOf(agents[i]) == -1) {
						executableAgents.push(agents[i]);
					}
				}
				eventTriggered = executableAgents.length > 0;
				for (var i = 0; i < executableAgents.length; i++) {
					var agent = executableAgents[i];
					if (!agent.locked) {
						agent.locked = true;
						context = agent.context;
						method = agent.method;
						scope = agent.scope;
						if (context != null && method != null) {
							if (typeof method == "function") {
								method.call(context, args, scope);
							}
							else {
								context[method].call(context, args, scope);
							}
						}
						agent.locked = false;
					}
				}
			}
			return eventTriggered;
		},
		
		hasListener: function(eventSource, eventName, args) {
			var hasListener = false;
			if (eventSource["__cmcEventAgents"] && eventSource.__cmcEventAgents[eventName]) {
				var agents = eventSource.__cmcEventAgents[eventName];
				for (var i = 0; i < agents.length; i++) {
					if (agents[i].enabled && !agents[i].locked) {
						hasListener = true;
						break;
					}
				}
			}
			return hasListener;
		},
	
		disconnectAll: function(context, method, scope) {
			var agent = this._getAgent(context, method, scope, false);
			if (agent != null) {
				var events = agent.events;
				agent.events = [];
				for (var i = 0; i < events.length; i++) {
					this._disconnectEvents(events[i].source, events[i].name, agent);
				}
			}
		},
		
		disable: function(context, method, scope) {
			var agent = this._getAgent(context, method, scope, false);
			if (agent != null) {
				agent.enabled = false;
			}
		},
		
		enable: function(context, method, scope) {
			var agent = this._getAgent(context, method, scope, false);
			if (agent != null) {
				agent.enabled = true;
			}
		},
		
		getEventCount: function(context, method, scope) {
			var eventCount = 0
			var agent = this._getAgent(context, method, scope, false);
			if (agent != null) {
				eventCount = agent.events.length;
			}
			return eventCount;
		},
		
		_disconnectEvents: function(eventSource, eventName, agent) {
			if (eventSource["__cmcEventAgents"] && eventSource.__cmcEventAgents[eventName]) {
				var agents = eventSource.__cmcEventAgents[eventName];
				var i = 0;
				while (i < agents.length) {
					if (agents[i] == agent) {
						if (i == agents.length - 1) {
							agents.length = i;
						}
						else {
							agents.splice(i, 1);
						}
					}
					else {
						i++;
					}
				}
			}
		},
		
		_getAgent: function(context, method, scope, create) {
			if (typeof(scope) == "undefined") { scope = null; }
			var obj = null;
			if (scope != null) {
				obj = scope;
			}
			else {
				obj = context;
			}
			var agent = null;
			if (!obj["__cmcAgents"]) {
				if (create) {
					obj["__cmcAgents"] = [];
				}
			}
			else {
				for (var i = 0; i < obj.__cmcAgents.length; i++) {
					if (obj.__cmcAgents[i].context == context && obj.__cmcAgents[i].method == method && obj.__cmcAgents[i].scope == scope) {
						agent = obj.__cmcAgents[i];
						break;
					}
				}
			}
			if (agent == null && create) {
				agent = {context: context, method: method, scope: scope, enabled: true, locked: false, events: []};
				obj.__cmcAgents.push(agent);
			}
			return agent;
		}
	})();
});
