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
	"cmc/foundation/FocusUtil"
], function(declare, EventUtil, FocusUtil, RootComponent) {
	return new declare(null, {
		modalComponents: [],
		rootComponent: null,
		makeModal: function(component) {
			if (this.modalComponents.indexOf(component) == -1) {
				this.modalComponents.push(component);
				if (this.modalComponents.length > 1) {
					var previousComponent = this.modalComponents[this.modalComponents.length - 2];
					if (previousComponent.widget) {
						previousComponent.widget.applyModal();
					}
				}
				else if (rootComponent && rootComponent.widget) {
					rootComponent.widget.applyModal();
				}
				if (component.widget) {
	            	component.widget.applyModal();
	            }
				EventUtil.trigger(this, "onmode", component);
				var focusComponent = FocusUtil.getFocus();
	            if (focusComponent && !focusComponent.childOf(component)) {
	            	FocusUtil.clearFocus();
	            }
			}
		},
		release: function(component) {
			var index = this.modalComponents.indexOf(component)
			if (index != -1) {
				this.modalComponents.splice(index, 1);
				var newModalComponent = this.getModalComponent();
				if (component.widget) {
					component.widget.applyModal();
				}
				if (newModalComponent != null) {
					if (newModalComponent.widget) {
						newModalComponent.widget.applyModal();
					}
				}
				else if (rootComponent && rootComponent.widget) {
					rootComponent.widget.applyModal();
				}
				EventUtil.trigger(this, "onmode", newModalComponent);
				var focusComponent = FocusUtil.getFocus();
				if (focusComponent && focusComponent.childOf(component)) {
					FocusUtil.clearFocus();
				}
			}
		},
		getModalComponent: function() {
			return this.modalComponents.length > 0 ? this.modalComponents[this.modalComponents.length - 1] : null;
		},
		inputAllowed: function(component) {
			var allowed = true;
			var modalComponent = this.getModalComponent();
			if (modalComponent != null && !component.childOf(modalComponent)) {
				allowed = false;
			}
			return allowed;
		}
	})();
});