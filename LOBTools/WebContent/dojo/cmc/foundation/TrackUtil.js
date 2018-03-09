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
	"cmc/foundation/EventHandler",
	"cmc/foundation/EventUtil",
	"cmc/foundation/MouseUtil",
	"cmc/foundation/Timer"
], function(declare, EventHandler, EventUtil, MouseUtil, Timer) {
	return new declare(null, {
		constructor: function() {
			EventUtil.connect(MouseUtil, "onmouseup", this, "doMouseUp");
			this.registeredGroups = {};
			this.activeGroups = [];
			this.doTrackDel = new EventHandler.Class(this, "doTrack");
		},
		activate: function(groupName) {
			var group = this.registeredGroups[groupName];
			if (group && !group.active) {
				group.active = true;
				if (this.activeGroups.length == 0) {
					Timer.addTimer(this.doTrackDel, 50);
				}
				this.activeGroups.push(group);
			}
		},
		deactivate: function(groupName) {
			var group = this.registeredGroups[groupName];
			if (group && group.active) {
				for (var i = 0; i < this.activeGroups.length; ++i) {
					if (this.activeGroups[i] == group) {
						this.activeGroups.splice(i, 1);
						break;
					}
				}
				if (this.activeGroups.length == 0) {
					Timer.removeTimer(this.doTrackDel);
				}
				group.active = false;
				if (this.lastMouseUpComponent == group.lastMouseOverComponent) {
					this.lastMouseUpComponent = null;
				}
				group.lastMouseOverComponent = null;
			}
		},
		register: function(component, groupName) {
			if (component != null && groupName != null) {
				var group = this.registeredGroups[groupName];
				if (!group) {
					group = {
						components: [],
						active: false,
						lastMouseOverComponent: null
					};
					this.registeredGroups[groupName] = group;
				}
				group.components.push(component);
				EventUtil.connect(component, "ondestroy", this, "handleDestroy");
			}
		},
		unregister: function(component, groupName) {
			if (component != null && groupName != null) {
				var group = this.registeredGroups[groupName];
				if (group) {
					for (var i = 0; i < group.components.length; i++) {
						if (group.components[i] == component) {
							if (group.lastMouseOverComponent == component) {
								if (this.lastMouseUpComponent == component) {
									this.lastMouseUpComponent = null;
								}
								group.lastMouseOverComponent = null;
							}
						}
						group.components.splice(i, 1);
						break;
					}
					if (group.components.length == 0) {
						if (group.active) {
							this.deactivate(groupName);
						}
						delete this.registeredGroups[groupName];
					}
				}
				EventUtil.disconnect(component, "ondestroy", this, "handleDestroy");
			}
		},
		doTrack: function() {
			var components = [];
			var groups = this.activeGroups.slice();
			for (var i = 0; i < groups.length; ++i) {
				var group = groups[i];
				var mouseOverList = [];
				for (var j = 0; j < group.components.length; j++) {
					var c = group.components[j];
					if (c.visible) {
						var mousePos = c.getMouse(null);
						if (c.containsPt(mousePos.x, mousePos.y)) {
							mouseOverList.push(c);
						}
					}
				}
				var topComponent = null;
				if (mouseOverList.length > 0) {
					var topComponent = this.findTopComponent(mouseOverList);
					if (topComponent == group.lastMouseOverComponent) continue;
					components.push(topComponent);
				}
				if (group.lastMouseOverComponent != null) {
					EventUtil.trigger(group.lastMouseOverComponent, "onmousetrackout", group.lastMouseOverComponent);
				}
				group.lastMouseOverComponent = topComponent;
			}
			for (var i = 0; i < components.length; i++) {
				var c = components[i];
				EventUtil.trigger(c, "onmousetrackover", c);
			}
			if (this.activeGroups.length > 0) {
				Timer.resetTimer(this.doTrackDel, 50);
			}
		},
		findTopComponent: function(components) {
			var top = components[0];
			for (var i = 1; i < components.length; i++) {
				top = this.getTopComponent(top, components[i]);
			}
			return top;
		},
		getTopComponent: function(c1, c2) {
			var temp1 = c1;
			var temp2 = c2;
			while (temp1.level < temp2.level) {
				temp2 = temp2.immediateParent;
				if (temp2 == c1) {
					return c2;
				}
			}
			while (temp2.level < temp1.level) {
				temp1 = temp1.immediateParent;
				if (temp1 == c2) {
					return c1;
				}
			}
			while (temp1.immediateParent != temp2.immediateParent) {
				temp1 = temp1.immediateParent;
				temp2 = temp2.immediateParent;
			}
			return (temp1.getWidgetIndex() > temp2.getWidgetIndex()) ? c1 : c2;
		},
		doMouseUp: function() {
			var groups = this.activeGroups.slice();
			for (var i = 0; i < groups.length; i++) {
				var lastMouseOverComponent = groups[i].lastMouseOverComponent;
				if (lastMouseOverComponent != null) {
					if (this.lastMouseUpComponent == lastMouseOverComponent) {
						this.lastMouseUpComponent = null;
					}
					else {
                        this.lastMouseUpComponent = lastMouseOverComponent;
						EventUtil.trigger(lastMouseOverComponent, "onmousetrackup", lastMouseOverComponent);
                    }
                }
            }
        }
	})();
});