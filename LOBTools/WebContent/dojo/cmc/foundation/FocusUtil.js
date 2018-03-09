//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2015, 2017 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

define([
	"dojo/_base/declare",
	"cmc/foundation/EventUtil",
	"cmc/foundation/KeyUtil",
], function(declare, EventUtil, KeyUtil) {
	return new declare(null, {
		lastFocus: null,
		currentFocus: null,
		currentFocusTrap: null,
		nextTarget: undefined,
		settingFocus: false,
		rootComponent: null,
		defaults: {},
		constructor: function() {
			EventUtil.connect(KeyUtil, "onkeydown", this, "handleKeyDown");
			EventUtil.connect(KeyUtil, "onkeyup", this, "handleKeyUp");
		},
		getFocus: function() {
			return this.currentFocus;
		},
		setFocus: function(target, isMouseEvent) {
			if (this.settingFocus) {
				this.nextTarget = target;
			}
			else if (this.currentFocus != target){
				if (target && !target.focusable) {
					target = this.getNext(target);
				}
				if (this.currentFocus != target) {
					var oldFocus = this.currentFocus;
					this.nextTarget = undefined;
					this.settingFocus = true;
					if (oldFocus != null) {
						EventUtil.trigger(oldFocus, "onblur", target);
						if (typeof this.nextTarget != "undefined") {
							target = this.nextTarget;
							this.nextTarget = undefined;
							if (target && !target.focusable) {
								target = this.getNext(target);
							}
						}
					}
					this.lastFocus = oldFocus;
					this.currentFocus = target;
					this.currentFocusTrap = this.findFocusTrap(target);
					if (target != null) {
						EventUtil.trigger(this, "onfocus", target);
						if (target.widget) {
							target.widget.setFocus(isMouseEvent);
						}
						EventUtil.trigger(target, "onfocus", target);
						if (typeof this.nextTarget != "undefined") {
							target = this.nextTarget;
							this.nextTarget = undefined;
							if (target && !target.focusable) {
								target = this.getNext(target);
							}
							this.settingFocus = false;
							this.setFocus(target);
							return;
						}
					}
					else if (oldFocus != null) {
						this.rootComponent.widget.setFocus();
						EventUtil.trigger(this, "onblur");
					}
					if (typeof this.nextTarget != "undefined") {
						target = this.nextTarget;
						this.nextTarget = undefined;
						if (target && !target.focusable) {
							target = this.getNext(target);
						}
						this.settingFocus = false;
						this.setFocus(target);
						return;
					}
					this.settingFocus = false;
				}
			}
			else if (target != null) {
				EventUtil.trigger(target, "onfocus", target);
			}
		},
		clearFocus: function() {
			this.setFocus(null);
		},
		getNext: function(target) {
			var next = null;
			var focusableComponents = this.getFocusableComponents(target);
			if (focusableComponents.length > 0) {
				var index = focusableComponents.indexOf(target);
				if (index == focusableComponents.length - 1) {
					index = -1;
				}
				next = focusableComponents[index + 1];
			}
			return next;
		},
		getPrev: function(target) {
			var prev = null;
			var focusableComponents = this.getFocusableComponents(target);
			if (focusableComponents.length > 0) {
				var index = focusableComponents.indexOf(target);
				if (index == 0) {
					index = focusableComponents.length;
				}
				prev = focusableComponents[index - 1];
			}
			return prev;
		},
		getFocusableComponents: function(current) {
			var focusableComponents = [];
			var root = this.findFocusTrap(current);
			if (root.visible && root.focusable) {
				focusableComponents.push(root);
			}
			var parents = [{parent:root,index:focusableComponents.length}];
			while (parents.length > 0) {
				var newParents = [];
				var indexDelta = 0;
				for (var i = 0; i < parents.length; i++) {
					var components = parents[i].parent.childComponents;
					var index = parents[i].index + indexDelta;
					for (var j = 0; j < components.length; j++) {
						var c = components[j];
						if (c.visible && !c.focustrap) {
							if (c.focusable || c == current) {
								focusableComponents.splice(index, 0, c);
								index++;
								indexDelta++;
							}
							newParents.push({parent:c,index:index});
						}
					}
				}
				parents = newParents;
			}
			return focusableComponents;
		},
		handleKeyUp: function(kc) {
			if (this.currentFocus != null && this._currentKeyDownFocus == this.currentFocus) {
				var current = this.currentFocus;
				EventUtil.trigger(this.currentFocus, "onkeyup", kc);
				if (current == this.currentFocus) {
					if (kc == 13) {
						if (this.currentFocus.doesenter && this.currentFocus.doEnterUp) {
							this.currentFocus.doEnterUp();
						}
						else {
							var defaultComponent = this.findDefaultComponent();
							if (defaultComponent != null && defaultComponent.doEnterUp) {
								defaultComponent.doEnterUp();
							}
						}
					}
					else if (kc == 32 && this.currentFocus.doSpaceUp) {
						this.currentFocus.doSpaceUp();
					}
				}
			}
		},
		handleKeyDown: function(kc) {
			this._currentKeyDownFocus = this.currentFocus;
			if (this.currentFocus != null) {
				var current = this.currentFocus;
				EventUtil.trigger(this.currentFocus, "onkeydown", kc);
				if (current == this.currentFocus) {
					if (kc == 13) {
						if (this.currentFocus.doesenter && this.currentFocus.doEnterDown) {
							this.currentFocus.doEnterDown();
						}
						else {
							var defaultComponent = this.findDefaultComponent();
							if (defaultComponent != null && defaultComponent.doEnterDown) {
								defaultComponent.doEnterDown();
							}
						}
					}
					else if (kc == 32 && this.currentFocus.doSpaceDown) {
						this.currentFocus.doSpaceDown();
					}
				}
			}
			if (kc == 9) {
				if (KeyUtil.isKeyDown("shift")) {
					this.prev();
				}
				else {
					this.next();
				}
			}
		},
		next: function() {
			var newFocus = null;
			if (this.currentFocus != null) {
				newFocus = this.currentFocus.getNextSelection();
			}
			if (newFocus == null) {
				var focusableComponents = this.getFocusableComponents(this.currentFocus != null ? this.currentFocus : this.rootComponent);
				if (focusableComponents.length > 0) {
					var index = -1;
					if (this.currentFocus != null) {
						index = focusableComponents.indexOf(this.currentFocus);
					}
					if (index == focusableComponents.length - 1) {
						index = -1;
					}
					newFocus = focusableComponents[index + 1];
				}
			}
			this.setFocus(newFocus);
		},
		prev: function() {
			var newFocus = null;
			if (this.currentFocus != null) {
				newFocus = this.currentFocus.getPrevSelection();
			}
			if (newFocus == null) {
				var focusableComponents = this.getFocusableComponents(this.currentFocus != null ? this.currentFocus : this.rootComponent);
				if (focusableComponents.length > 0) {
					var index = -1;
					if (this.currentFocus != null) {
						index = focusableComponents.indexOf(this.currentFocus);
					}
					if (index == 0) {
						index = focusableComponents.length;
					}
					newFocus = focusableComponents[index - 1];
				}
			}
			this.setFocus(newFocus);
		},
		findFocusTrap: function(component) {
			var focusTrap = component;
			while (focusTrap != null && !focusTrap.focustrap) {
				focusTrap = focusTrap.immediateParent;
			}
			return focusTrap;
		},
		registerDefault: function(component) {
			var focusTrap = this.findFocusTrap(component);
			if (focusTrap != null) {
				var focusTrapDefaults = this.defaults[focusTrap.getUID()];
				if (typeof focusTrapDefaults == "undefined") {
					focusTrapDefaults = [];
					this.defaults[focusTrap.getUID()] = focusTrapDefaults;
				}
				if (focusTrapDefaults.indexOf(component) == -1) {
					focusTrapDefaults.push(component);
				}
			}
		},
		unregisterDefault: function(component) {
			var focusTrap = this.findFocusTrap(component);
			if (focusTrap != null) {
				var focusTrapDefaults = this.defaults[focusTrap.getUID()];
				if (typeof focusTrapDefaults != "undefined") {
					var index = focusTrapDefaults.indexOf(component);
					if (index != -1) {
						focusTrapDefaults.splice(index, 1);
					}
				}
			}
		},
		findDefaultComponent: function() {
			var defaultComponent = null;
			if (this.currentFocusTrap != null && typeof this.defaults[this.currentFocusTrap.getUID()] != "undefined") {
				var focusTrapDefaults = this.defaults[this.currentFocusTrap.getUID()];
				for (var i = 0; i < focusTrapDefaults.length; i++) {
					if (focusTrapDefaults[i].enabled) {
						defaultComponent = focusTrapDefaults[i];
						break;
					}
				}
			}
			return defaultComponent;
		},
		fireOnblur: function(){
			if (this.currentFocus != null){
				EventUtil.trigger(this.currentFocus, "onblur");
			}
		}
	})();
});