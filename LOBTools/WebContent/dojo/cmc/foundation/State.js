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
	"cmc/foundation/EventUtil",
	"exports"
], function(declare, Node, EventUtil, exports) {
	exports.Class = declare(Node.Class, {
		__state: true,
		active: false,
		savedConstrainedVariables: null,

		set_active: function(value) {
			if (this.active != value) {
				this.active = value;
				if (value) {
					this.activate();
				}
				else {
					this.deactivate();
				}
			}
			EventUtil.trigger(this, "onactive", value);
		},
		
		initializeVariables: function() {
			if (this.initPendingVariables) {
				var newInitPendingVariables = [];
				for (var i = 0; i < this.initPendingVariables.length; i++) {
					if (this.initPendingVariables[i].name == "active") {
						newInitPendingVariables.push(this.initPendingVariables[i]);
					}
				}
				this.initPendingVariables = newInitPendingVariables;
				this.inherited(arguments);
			}
		},
		
		activate: function() {
			if (this.variables) {
				var newConstrainedVariables = [];
				for (var i = 0; i < this.variables.length; i++) {
					var variable = this.variables[i];
					if (variable.name != "active" && variable.name != "name") {
						if (this.parent.constrainedVariables && this.parent.constrainedVariables[variable.name]) {
							var constrainedVariable = this.parent.constrainedVariables[variable.name];
							if (this.parent.variables) {
								for (var j = 0; j < this.parent.variables.length; j++) {
									if (this.parent.variables[j] == constrainedVariable) {
										if (this.savedConstrainedVariables == null) {
											this.savedConstrainedVariables = {};
										}
										this.savedConstrainedVariables[constrainedVariable.name] = constrainedVariable;
										break;
									}
								}
							}
							this.parent.removeConstrainedVariable(variable.name);
						}
						if (typeof variable.initializeMethod != "undefined") {
							variable.initializeMethod.call(this.parent);
						}
						if (typeof variable.updateMethod != "undefined") {
							newConstrainedVariables.push(variable);
						}
						if ("value" in variable) {
							if (this.parent["set_"+variable.name]) {
								this.parent["set_"+variable.name](variable.value);
							}
							else {
								this.parent[variable.name] = variable.value;
							}
						}
						else if ("getValue" in variable) {
							if (this.parent["set_"+variable.name]) {
								this.parent["set_"+variable.name](variable.getValue());
							}
							else {
								this.parent[variable.name] = variable.getValue();
							}
						}
					}
				}
				for (var i = 0; i < newConstrainedVariables.length; i++) {
					this.parent.addConstrainedVariable(newConstrainedVariables[i].name, newConstrainedVariables[i]);
				}
			}
		},
		
		deactivate: function() {
			if (this.variables) {
				for (var i = 0; i < this.variables.length; i++) {
					var variable = this.variables[i];
					if (variable.name != "active" && variable.name != "name") {
						if (this.parent.constrainedVariables[variable.name]) {
							var constrainedVariable = this.parent.constrainedVariables[variable.name];
							if (constrainedVariable == variable) { 
								this.parent.removeConstrainedVariable(variable.name);
							}
						}
						if (this.savedConstrainedVariables && this.savedConstrainedVariables[variable.name]) {
							this.parent.addConstrainedVariable(variable.name, this.savedConstrainedVariables[variable.name], this.parent[variable.name]);
						}
					}
				}
				this.savedConstrainedVariables = null;
			}
		}
	});
    return exports;
});
