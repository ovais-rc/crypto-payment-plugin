//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage member group within.
 * This file is included in all pages with organization users member group actions.
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * This service allow administrator to update roles of member
 * @constructor
 */
wc.service.declare({
	id:"RESTUserMbrGrpMgtMemberUpdate",
	actionId:"RESTUserMbrGrpMgtMemberUpdate",
	url:"RESTupdateMemberUser",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS"]);
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
});

/**
 * This class defines the functions and variables that customers can use to create, update, and view their buyers list.
 * @class The UserMemberGroupManagementJS class defines the functions and variables that customers can use to manage their buyers list, 
 */
UserMemberGroupManagementJS = {		
	
	/**
	 * the widget name
	 * @private
	 */
	widgetShortName: "UserMemberGroupManagement",
	/** 
	 * This variable stores the ID of the language that the store currently uses. Its default value is set to -1, which corresponds to United States English.
	 * @private
	 */
	langId: "-1",
	
	/** 
	 * This variable stores the ID of the current store. Its default value is empty.
	 * @private
	 */
	storeId: "",
	
	/** 
	 * This variable stores the ID of the catalog. Its default value is empty.
	 * @private
	 */
	catalogId: "",
	
	/**
	 * The member group form Id.
	 * @private
	 */
	formId: "",
	
	/**
	 * The element Id for inclusion member group select dropdown dojo widget.
	 * @private
	 */
	includeGrpDropdownId: "",
	
	/**
	 * The element id for exclusion member group select dropdown dojo widget.
	 * @private
	 */
	excludeGrpDropdownId: "",
	
	/**
	 * The array of assigned include member group IDs.
	 * @private
	 */
	assignedIncGroups: new Array(),
	
	/**
	 * The array of assigned exclude member group IDs.
	 * @private
	 */
	assignedExcGroups: new Array(),
			
	/**
	 * Sets the common parameters for the current page. 
	 * For example, the language ID, store ID, and catalog ID.
	 * 
	 * @param {Integer} langId The ID of the language that the store currently uses.
	 * @param {Integer} storeId The ID of the current store.
	 * @param {Integer} catalogId The ID of the catalog.
	 * @param {String} formId The ID of the member group form.
	 * @param {String} includeGrpDropdownId The ID of the inclusive member group select option dropdown.
	 * @param {String} excludeGrpDropdownId The ID of the exclusive member group select option dropdown.
	 */
	setCommonParameters: function(langId,storeId,catalogId, formId, includeGrpDropdownId, excludeGrpDropdownId){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		this.formId = formId;
		this.includeGrpDropdownId = includeGrpDropdownId;
		this.excludeGrpDropdownId = excludeGrpDropdownId;
		cursor_clear();
	},
	
	/**
	 * Initialize assignedIncGroups and assignedExcGroups array on page load and after refresh.
	 */
	initializeData: function(){
		var form = document.getElementById(this.formId);
		var _this = this;
		if (form !== undefined && form !== null){
			require(["dojo/query"], function(query, lang) {
				_this.assignedExcGroups = [];
				_this.assignedIncGroups = [];
				query("#"+_this.formId).children("input[name='addAsExplicitInclusionToMemberGroupId']").forEach(function(input){
					this.assignedIncGroups.push(input.getAttribute('value').replace(/^\s+|\s+$/g, ''));
				}, _this);
				query("#"+_this.formId).children("input[name='addAsExplicitExclusionToMemberGroupId']").forEach( function(input){
					this.assignedExcGroups.push(input.getAttribute('value').replace(/^\s+|\s+$/g, ''));
				}, _this);
			});
		}
	},
	
	/**
	 * Initialize the URL for controller 'UserMemberGroupManagement_controller'. 	 
	 *
	 * @param {object} widgetUrl The URL for UserMemberGroupManagement_controller.
	 */
	initializeControllerUrl:function(widgetUrl){
		wc.render.getRefreshControllerById('UserMemberGroupManagement_controller').url = widgetUrl;
	},
	
	/**
	 * Subscribe to press cancel button event
	 */
	subscribeToToggleCancel: function(){
		var topicName = "sectionToggleCancelPressed";
 		var scope = this;
 		require(["dojo/topic"], function(topic) {
	 		topic.subscribe(topicName, function(data){
	 			if (data.target === 'WC_UserMemberGroupManagement_pageSection'){
	 				scope.doCancel();
	 			}
	 		});
 		});
	},
	
	/**
	 * Handle select a include group from include group select dropdown
	 * @param (Integer) grpId The ID of the member group to select
	 */
	selectIncGrp: function(grpId){
		var _this = this;
		if (grpId != ''){
			require(["dojo/query", "dijit/registry", "dojo/dom", "dojo/dom-construct" ], function(query, registry, dom, domConstruct) {
				//create the corresponding input
				var formNode = dom.byId(_this.formId);
				domConstruct.place("<input type='hidden' name='addAsExplicitInclusionToMemberGroupId' value='" + grpId + "'/>", formNode);
				//disable corresponding entry in select dropdown
				registry.byId(_this.includeGrpDropdownId).set('value','',false);
				var includeGrpDropdown = registry.byId(_this.includeGrpDropdownId);
				includeGrpDropdown.getOptions(grpId)['disabled']= true;
				includeGrpDropdown.updateOption([]);
				var excludeGrpDropdown = registry.byId(_this.excludeGrpDropdownId);
				excludeGrpDropdown.getOptions(grpId)['disabled']= true;
				excludeGrpDropdown.updateOption([]);
				query(".includeMbrGrp .entryField[data-grpId='"+grpId+"']")[0].setAttribute("aria-hidden", "false");
			});
		}
	},
	
	/**
	 * Handle click on a cross icon of a member group in Include member group section
	 * @param (Integer) grpId The ID of the member group to de-select
	 */
	deselectIncGrp: function(grpId){
		var _this = this;
		require(["dojo/query", "dijit/registry",  "dojo/dom", "dojo/NodeList-traverse"], function(query, registry, dom) {
			var formNode = dom.byId(_this.formId);
			//remove the corresponding input
			query("#"+_this.formId).children("input[value='"+grpId+"']").forEach(function(input){
				input.parentNode.removeChild(input);
			});
			
			//update the select dropdown
			var includeGrpDropdown = registry.byId(_this.includeGrpDropdownId);
			includeGrpDropdown.getOptions(grpId)['disabled']= false;
			includeGrpDropdown.updateOption([]);
			var excludeGrpDropdown = registry.byId(_this.excludeGrpDropdownId);
			excludeGrpDropdown.getOptions(grpId)['disabled']= false;
			excludeGrpDropdown.updateOption([]);
			query(".includeMbrGrp .entryField[data-grpId='"+grpId+"']")[0].setAttribute("aria-hidden", "true");
		});
	},
	
	/**
	 * Handle select a excluding group from exclude group select dropdown
	 * @param (Integer) grpId The ID of the member group to select 
	 */
	selectExcGrp: function(grpId){
		var _this = this;
		if (grpId != ''){
			require(["dojo/query", "dijit/registry", "dojo/dom", "dojo/dom-construct" ], function(query, registry, dom, domConstruct) {
				//create the corresponding input
				var formNode = dom.byId(_this.formId);
				domConstruct.place("<input type='hidden' name='addAsExplicitExclusionToMemberGroupId' value='" + grpId + "'/>", formNode);
				//disable corresponding entry in select dropdown
				registry.byId(_this.excludeGrpDropdownId).set('value','',false);
				var includeGrpDropdown = registry.byId(_this.includeGrpDropdownId);
				includeGrpDropdown.getOptions(grpId)['disabled']= true;
				includeGrpDropdown.updateOption([]);
				var excludeGrpDropdown = registry.byId(_this.excludeGrpDropdownId);
				excludeGrpDropdown.getOptions(grpId)['disabled']= true;
				excludeGrpDropdown.updateOption([]);
				query(".excludeMbrGrp .entryField[data-grpId='"+grpId+"']")[0].setAttribute("aria-hidden", "false");
			});
		}
	},
	
	/**
	 * Handle click on a cross icon of a member group in Exclude member group section
	 * @param (Integer) grpId The ID of the member group to de-select
	 */
	deselectExcGrp: function(grpId){
		var _this = this;
		require(["dojo/query", "dijit/registry",  "dojo/dom", "dojo/NodeList-traverse"], function(query, registry, dom) {
			var formNode = dom.byId(_this.formId);
			//remove the corresponding input
			query("#"+_this.formId).children("input[value='"+grpId+"']").forEach(function(input){
				input.parentNode.removeChild(input);
			});
			
			var includeGrpDropdown = registry.byId(_this.includeGrpDropdownId);
			includeGrpDropdown.getOptions(grpId)['disabled']= false;
			includeGrpDropdown.updateOption([]);
			var excludeGrpDropdown = registry.byId(_this.excludeGrpDropdownId);
			excludeGrpDropdown.getOptions(grpId)['disabled']= false;
			excludeGrpDropdown.updateOption([]);
			query(".excludeMbrGrp .entryField[data-grpId='"+grpId+"']")[0].setAttribute("aria-hidden", "true");
		});
	},
	
	/**
	 * Handle cancel call back when click on 'cancel' button
	 */
	doCancel: function(){
		var scope = this;
		require(["dojo/query", "dojo/_base/array", "dojo/dom","dijit/registry","dojo/dom-construct"], function(query, array, dom, registry, domConstruct) {
			
			// set disable to "false" for all options
			var includeGrpDropdown = registry.byId(scope.includeGrpDropdownId);
			var excludeGrpDropdown = registry.byId(scope.excludeGrpDropdownId);
			includeGrpDropdown.getOptions().forEach(function(option){
				option.disabled = false;
			});
			excludeGrpDropdown.getOptions().forEach(function(option){
				option.disabled = false;
			});
			
			var formNode = dom.byId(scope.formId);
			query("#"+scope.formId).children("input[name='addAsExplicitInclusionToMemberGroupId']").forEach(function(input){
				input.parentNode.removeChild(input);
			});
			query("#"+scope.formId).children("input[name='addAsExplicitExclusionToMemberGroupId']").forEach(function(input){
				input.parentNode.removeChild(input);
			});
			
			//set disabled to true for select groups
			array.forEach(scope.assignedIncGroups, function(incGrp){
				includeGrpDropdown.getOptions(incGrp).disabled = true;
				excludeGrpDropdown.getOptions(incGrp).disabled = true;
				var formNode = dom.byId(this.formId);
				domConstruct.place("<input type='hidden' name='addAsExplicitInclusionToMemberGroupId' value='" + incGrp + "'/>", formNode);
			}, scope );
			
			array.forEach(scope.assignedExcGroups, function(excGrp){
				includeGrpDropdown.getOptions(excGrp).disabled = true;
				excludeGrpDropdown.getOptions(excGrp).disabled = true;
				var formNode = dom.byId(this.formId);
				domConstruct.place("<input type='hidden' name='addAsExplicitExclusionToMemberGroupId' value='" + excGrp + "'/>", formNode);
			}, scope );
			
			includeGrpDropdown.updateOption([]);
			excludeGrpDropdown.updateOption([]);
			
			query(".includeMbrGrp .entryField").forEach(function(entry){
				var grpId = entry.getAttribute("data-grpId");
				if (array.indexOf(this.assignedIncGroups, grpId) < 0 ){
					entry.setAttribute("aria-hidden", "true");
				}
				else {
					entry.setAttribute("aria-hidden", "false");
				}
			}, scope);
			query(".excludeMbrGrp .entryField").forEach(function(entry){
				var grpId = entry.getAttribute("data-grpId");
				if (array.indexOf(this.assignedExcGroups,grpId) < 0 ){
					entry.setAttribute("aria-hidden", "true");
				}
				else {
					entry.setAttribute("aria-hidden", "false");
				}
			}, scope);
		});
	},
	
	/**
	 * Save changes when press "Save" button
	 */
	saveChange: function(){
		
		var params = {};
		params.removeFromMemberGroupId =  this.assignedExcGroups.concat(this.assignedIncGroups);
		wc.service.getServiceById('RESTUserMbrGrpMgtMemberUpdate').formId = this.formId;
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		wc.service.invoke('RESTUserMbrGrpMgtMemberUpdate', params);
	}
};
