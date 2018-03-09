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
	"dojox/xml/parser",
	"cmc/RootComponent"
], function (declare, xmlParser, RootComponent) {
	return new declare(null, {
		declareModuleClass: function(classModule) {
			var baseClassModule = classModule.baseClassModule;
			var baseClass = baseClassModule ? baseClassModule.Class : null;
			if (typeof(baseClass) == "undefined") {
				if (!baseClassModule.pendingClassModules) {
					baseClassModule.pendingClassModules = [];
				}
				baseClassModule.pendingClassModules.push(classModule);
			}
			else {
				var inheritedVariables = null;
				var inheritedChildDefinitions = null;
				var inheritedHandlers = null;
				if (baseClass != null) {
					inheritedVariables = baseClass.prototype.variables;
					inheritedChildDefinitions = baseClass.prototype.childDefinitions;
					inheritedHandlers = baseClass.prototype.handlers;
				}
				var props = classModule.classProps;
				if (props.variables && inheritedVariables) {
					var variables = props.variables;
					var byNameVariables = {};
					for (var i = 0; i < variables.length; i++) {
						var variable = variables[i];
						byNameVariables[variable.name] = variable;
					}
					for (var i = 0; i < inheritedVariables.length; i++) {
						var variable = inheritedVariables[i];
						if (typeof byNameVariables[variable.name] == "undefined") {
							variables.push(variable);
						}
					}
					byNameVariables = null;
				}
				else if (inheritedVariables) {
					props.variables = inheritedVariables;
				}
				var variables = props.variables;
				if (variables && (baseClass == null || !baseClass.prototype.__state)) {
					for (var i = 0; i < variables.length; i++) {
						var variable = variables[i];
						if ("value" in variable && (typeof(variable.value) == "undefined" || (typeof(props["set_"+variable.name]) == "undefined" && (baseClass == null || typeof(baseClass.prototype["set_"+variable.name]) == "undefined")))) {
							props[variable.name] = variable.value;
							variables.splice(i, 1);
							i--;
						}
					}
				}
				var childDefinitions = props.childDefinitions;
				if (childDefinitions) {
					for (var i = 0; i < childDefinitions.length; i++) {
						childDefinitions[i].classProps.parentBaseClass = baseClass;
					}
					if (inheritedChildDefinitions) {
						props.childDefinitions = inheritedChildDefinitions.concat(childDefinitions);
					}
				}
				else if (inheritedChildDefinitions) {
					props.childDefinitions = inheritedChildDefinitions;
				}
				if (props.handlers && inheritedHandlers) {
					props.handlers = inheritedHandlers.concat(props.handlers);
				}
				else if (inheritedHandlers) {
					props.handlers = inheritedHandlers;
				}
				else if (!props.handlers) {
					props.handlers = [];
				}
				if (props.xmls != null) {
					for (var xmlName in props.xmls) {
						var xml = xmlParser.parse(props.xmls[xmlName]);
						props[xmlName] = xml != null ? xml.documentElement : null;
					}
				}
				props.moduleName = classModule.moduleName;
				props.module = classModule;
				props.nestingDepth = classModule.nestingDepth;
				classModule.Class = declare(baseClass, props);
				delete classModule.classProps;
				delete classModule.baseClassModule;
				if (classModule.pendingClassModules) {
					var modules = classModule.pendingClassModules;
					for (var i = 0; i < modules.length; i++) {
						this.declareModuleClass(modules[i]);
					}
					delete classModule.pendingClassModules;
				}
				if (classModule.pendingSingletonModules) {
					var modules = classModule.pendingSingletonModules;
					for (var i = 0; i < modules.length; i++) {
						this.createSingleton(modules[i]);
					}
					delete classModule.pendingSingletonModules;
				}
			}
		},
		
		createSingleton: function(singletonModule) {
			var baseClassModule = singletonModule.baseClassModule;
			var baseClass = baseClassModule.Class;
			if (typeof(baseClass) == "undefined") {
				if (!baseClassModule.pendingSingletonModules) {
					baseClassModule.pendingSingletonModules = [];
				}
				baseClassModule.pendingSingletonModules.push(singletonModule);
			}
			else {
				if (RootComponent == singletonModule) {
					var classProps = RootComponent.classProps;
					if (classProps == null) {
						classProps = {};
					}
					var childDefinitions = classProps.childDefinitions;
					if (childDefinitions == null) {
						childDefinitions = [];
					}
					var pendingSingletonModules = RootComponent.pendingSingletonModules;
					if (pendingSingletonModules) {
						for (var i = 0; i < pendingSingletonModules.length; i++) {
							pendingSingletonModules[i].assignSingleton = true;
							childDefinitions.push(pendingSingletonModules[i]);
						}
					}
					delete RootComponent.pendingSingletonModules;
					classProps.childDefinitions = childDefinitions;
					RootComponent.classProps = classProps;
					RootComponent.assignSingleton = true;
					this.declareModuleClass(RootComponent);
					RootComponent.Singleton = new RootComponent.Class(null, {});
					delete RootComponent.Class;
				}
				else if (RootComponent.Singleton) {
					singletonModule.assignSingleton = true;
					this.declareModuleClass(singletonModule);
					new singletonModule.Class(RootComponent.Singleton, {});
					delete singletonModule.Class;
				}
				else {
					if (!RootComponent.pendingSingletonModules) {
						RootComponent.pendingSingletonModules = [];
					}
					RootComponent.pendingSingletonModules.push(singletonModule);
				}
			}
		},
		
		createClassInstance: function(classModule, parent, args) {
			if (!classModule.Class) {
				this.declareModuleClass(classModule);
			}
			var instance = new classModule.Class(parent, args);
		},
		
		createDefinitionInstance: function(definition, parent, initArgs) {
			var variables = {};
			var ignoreBaseDefinition = definition.definitionClass.Class.prototype.ignoreBaseDefinition;
			this.prepareVariables(variables, parent, definition, ignoreBaseDefinition);
			if (initArgs) {
				for (var prop in initArgs) {
					variables[prop] = {
						value: initArgs[prop]
					}
				}
			}
			var resourceVariables = {};
			var args = {};
			for (var i in variables) {
				if (variables[i].resourceBundleModule != null) {
					var bundle = variables[i].resourceBundleModule.Singleton;
					var key = variables[i].resourceBundleKey;
					if (bundle[key]) {
						args[i] = bundle[key].string;
					}
					else {
						require(["cmc/shell/Logger"], function(Logger) {
							Logger.Singleton.log("com.ibm.commerce.lobtools.foundation.util", "WARNING", "cmc/foundation/DefinitionUtil", "createDefinitionInstance", "Unable to resolve resource bundle key " + key);
						});
					}
					resourceVariables[i] = variables[i];
				}
				else if (variables[i].deferLoadModuleName != null) {
					args[i + "_moduleName"] = variables[i].deferLoadModuleName;
				}
				else {
					args[i] = variables[i].value;
				}
			}
			var newInstance = new definition.definitionClass.Class(parent, args);
			for (var i in resourceVariables) {
				var resourceVariable = resourceVariables[i];
				resourceVariable.resourceBundleModule.Singleton.constrainVariable(resourceVariable.resourceBundleKey, newInstance, i);
			}
			if (newInstance.initstage != "defer") {
				this.completeCreateDefinitionChildren(newInstance);
			}
			return newInstance;
		},
		
		prepareVariables: function(variables, parent, definition, ignoreBaseDefinition) {
			if (!ignoreBaseDefinition || !definition.definitionName) {
				if (definition.baseDefinition != null) {
					this.prepareVariables(variables, parent, definition.baseDefinition, ignoreBaseDefinition);
					if ("isBaseDefinition" in variables) {
						delete variables.isBaseDefinition;
					}
				}
			}
			if (definition.variables) {
				for (var variableName in definition.variables) {
					variables[variableName] = definition.variables[variableName];
				}
			}
			variables._definition = {
				value: definition
			}
			if (ignoreBaseDefinition && definition.definitionName && definition.baseDefinition) {
				variables._baseDefinition = {
					value: definition.baseDefinition
				}
			}
		},
		
		createDefinitionChildren: function(parent, parentDefinition, ignoreBaseDefinition) {
			if (!ignoreBaseDefinition || !parentDefinition.definitionName) {
				var baseDefinition = parentDefinition.baseDefinition;
				if (baseDefinition) {
					this.createDefinitionChildren(parent, baseDefinition, ignoreBaseDefinition);
				}
			}
			var childDefinitions = parentDefinition.childDefinitions;
			if (childDefinitions) {
				for (var i = 0; i < childDefinitions.length; i++) {
					var childDefinition = childDefinitions[i];
					this.createDefinitionInstance(childDefinition, parent, null);
				}
			}
			var xmls = parentDefinition.xmls;
			if (xmls) {
				for (var i in xmls) {
					var xml = xmlParser.parse(xmls[i]);
					parent[i] = xml != null ? xml.documentElement : null;
				}
			}
		},
	
		completeCreateDefinitionChildren: function(definitionInstance) {
			if (definitionInstance._definition && !definitionInstance._definitionChildrenCreated) {
				var definition = definitionInstance._definition;
				this.createDefinitionChildren(definitionInstance, definition, definitionInstance.ignoreBaseDefinition);
				if (definitionInstance.postCreateDefinitionChildren) {
					definitionInstance.postCreateDefinitionChildren();
				}
				definitionInstance._definitionChildrenCreated = true;
			}
		}
	})(); 
});

