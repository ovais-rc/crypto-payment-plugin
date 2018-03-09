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
	"cmc/foundation/Node",
	"cmc/foundation/EventHandler",
	"cmc/foundation/EventUtil",
	"exports"
], function(declare, Node, EventHandler, EventUtil, exports) {
	exports.Class = declare(Node.Class, {
		locked: true,
		components: null,
		active: true,
		constructor: function(parent, args) {
			this.components = [];
			if (this.immediateParent.layouts == null) {
				this.immediateParent.layouts = [];
			}
			this.immediateParent.layouts.push(this);
			this.updateHandler = new EventHandler.Class(this, "update");
			var components = this.immediateParent.childComponents;
			if (components) {
				for (var i = 0; i < components.length; i++) {
					if (!components[i].ignoreLayout) {
						this.addComponent(components[i]);
					}
				}
			}
			if (this.immediateParent.inited) {
				this.locked = false;
				var callUpdate = true;
				if (this.initPendingVariables) {
					for (var i = 0; i < this.initPendingVariables.length; i++) {
						if (this.initPendingVariables[i].name == "active") {
							callUpdate = false;
							break;
						}
					}
				}
				if (callUpdate) {
					this.update();
				}
			}
		},
		
		destroy: function() {
			this.releaseLayout();
			this.inherited(arguments);
		},

		update: function() {
		},
		
		lock: function() {
			this.locked = true;
		},
		
		unlock: function() {
			this.locked = false;
			this.update();
		},
		
		releaseLayout: function() {
			if (this.parent.layouts != null) {
				var index = this.parent.layouts.indexOf(this);
				if (index != -1) {
					this.parent.layouts.splice(index, 1);
				}
			}
			this.updateHandler.disconnectAll();
		},
		
		setLayoutOrder: function(component1, component2) {
			var index2 = this.components.indexOf(component2);
			if (index2 != -1) {
				this.components.splice(index2, 1);
			}
			if (component1 == "first") {
				this.components.unshift(component2);
			}
			else if (component1 == "last") {
				this.components.push(component2);
			}
			else {
				var index1 = this.components.indexOf(component1);
				if (index1 != -1) {
					this.components.splice(index1 + 1, 0, component2);
				}
				else {
					this.components.push(component2);
				}
			}
			if (!this.locked) {
				this.update();
			}
		},
		
		swapComponentOrder: function(component1, component2) {
			var index1 = this.components.indexOf(component1);
			var index2 = this.components.indexOf(component2);
			if (index1 != -1 && index2 != -1) {
				this.components[index1] = component2;
				this.components[index2] = component1;
			}
			if (!this.locked) {
				this.update();
			}
		},
		
		addComponent: function(component) {
			if (this.components.indexOf(component) == -1) {
				this.components.push(component);
				if (!this.locked) {
					this.update();
				}
			}
		},
		
		removeComponent: function(component) {
			var index = this.components.indexOf(component);
			if (index != -1) {
				this.components.splice(index, 1);
				if (!this.locked) {
					this.update();
				}
			}
		},
		
		set_active: function(value) {
			if (this.active != value) {
				this.active = value;
				if (value) {
					this.updateHandler.enable();
					this.update();
				}
				else {
					this.updateHandler.disable();
				}
			}
			EventUtil.trigger(this, "onactive", value);
		}
	});
    return exports;
});
