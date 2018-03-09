//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage member group within.
 * This file is included in all pages with organization users member group actions.
 */

/**
 * This service allow administrator to update roles of member
 * @constructor
 */
wcService.declare({
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
	 * The element Id for inclusion member group select dropdown widget.
	 * @private
	 */
	includeGrpDropdownId: "",
	
	/**
	 * The element id for exclusion member group select dropdown widget.
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
			
			_this.assignedExcGroups = [];
			_this.assignedIncGroups = [];

			$(form).find("input[name='addAsExplicitInclusionToMemberGroupId']").each( $.proxy(function(i, incGrp) {
				_this.assignedIncGroups.push($(incGrp).val().replace(/^\s+|\s+$/g, ''));
			}, _this));

			$(form).find("input[name='addAsExplicitExclusionToMemberGroupId']").each( $.proxy(function(i, excGrp) {
				_this.assignedExcGroups.push($(excGrp).val().replace(/^\s+|\s+$/g, ''));
			}, _this));

		}
	},
	
	/**
	 * Initialize the URL for controller 'declareUserMemberGroupManagement_controller'. 	 
	 *
	 * @param {object} widgetUrl The URL for declareUserMemberGroupManagement_controller.
	 */
	initializeControllerUrl:function(widgetUrl){
		$('#UserMemberGroupManagement').attr("refreshurl", widgetUrl);
	},
	
	/**
	 * Subscribe to press cancel button event
	 */
	subscribeToToggleCancel: function(){
		var topicName = "sectionToggleCancelPressed";
 		var scope = this;

		wcTopic.subscribe( topicName, function(data) {
			if (data.target === 'WC_UserMemberGroupManagement_pageSection'){
				scope.doCancel();
			}
		});
	},
	
	/**
	 * Handle select a include group from include group select dropdown
	 * @param (Integer) grpId The ID of the member group to select
	 */
	selectIncGrp: function(grpId){
		var _this = this;
		if (grpId != ''){
			//create the corresponding input
			var formNode = $("#" + _this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitInclusionToMemberGroupId' value='" + grpId + "'/>");
			//disable corresponding entry in select dropdown
			var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
			includeGrpDropdown.val("");
			includeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", true);
			includeGrpDropdown.Select("refresh");

			var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
			excludeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", true);
			excludeGrpDropdown.Select("refresh");
			
			$(".includeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "false");
		}
	},
	
	/**
	 * Handle click on a cross icon of a member group in Include member group section
	 * @param (Integer) grpId The ID of the member group to de-select
	 */
	deselectIncGrp: function(grpId){
		var _this = this;

		var formNode = $("#" + _this.formId);
		//remove the corresponding input
		$("#"+_this.formId+" input[value='"+grpId+"']").each(function(){
			this.parentNode.removeChild(this);
		});
		
		//update the select dropdown
		var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
		includeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		includeGrpDropdown.Select("refresh");
		
		var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
		excludeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		excludeGrpDropdown.Select("refresh");

		$(".includeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "true");
	},
	
	/**
	 * Handle select a excluding group from exclude group select dropdown
	 * @param (Integer) grpId The ID of the member group to select 
	 */
	selectExcGrp: function(grpId){
		var _this = this;
		if (grpId != ''){
			//create the corresponding input
			var formNode = $("#" + _this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitExclusionToMemberGroupId' value='" + grpId + "'/>");
			//disable corresponding entry in select dropdown
			var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
			includeGrpDropdown.find("[value='"+grpId+"']").attr("disabled", true);
			includeGrpDropdown.Select("refresh");
			
			var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
			excludeGrpDropdown.val("");
			excludeGrpDropdown.find("[value='"+grpId+"']").attr("disabled", true);
			excludeGrpDropdown.Select("refresh");

			$(".excludeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "false");
		}
	},
	
	/**
	 * Handle click on a cross icon of a member group in Exclude member group section
	 * @param (Integer) grpId The ID of the member group to de-select
	 */
	deselectExcGrp: function(grpId){
		var _this = this;

		var formNode = $("#" + _this.formId);
		//remove the corresponding input
		formNode.children("input[value='"+grpId+"']").each(function(){
			this.parentNode.removeChild(this);
		});
		
		var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
		includeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		includeGrpDropdown.Select("refresh");
		
		var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
		excludeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		excludeGrpDropdown.Select("refresh");
		
		$(".excludeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "true");
	},
	
	/**
	 * Handle cancel call back when click on 'cancel' button
	 */
	doCancel: function(){
		var scope = this;
			
		// set disable to "false" for all options
		var includeGrpDropdown = $("#" + scope.includeGrpDropdownId);
		var excludeGrpDropdown = $("#" + scope.excludeGrpDropdownId);
		includeGrpDropdown.find("option").each(function(){
			$(this).attr("disabled", false);
		});
		excludeGrpDropdown.find("option").each(function(){
			$(this).attr("disabled", false);
		});
		
		var formNode = $("#" + scope.formId);
		formNode.find("input[name='addAsExplicitInclusionToMemberGroupId']").each(function(i, incGrp) {
			incGrp.parentNode.removeChild(incGrp);
		});
		formNode.find("input[name='addAsExplicitExclusionToMemberGroupId']").each(function(i, excGrp) {
			excGrp.parentNode.removeChild(excGrp);
		});
		
		//set disabled to true for select groups
		$(scope.assignedIncGroups).each( $.proxy(function(index, incGrp){
			includeGrpDropdown.find("[value='" + incGrp + "']").attr("disabled", true);
			excludeGrpDropdown.find("[value='" + incGrp + "']").attr("disabled", true);
			var formNode = $("#" + this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitInclusionToMemberGroupId' value='" + incGrp + "'/>");
		}, scope));
		
		$(scope.assignedExcGroups).each( $.proxy(function(index, excGrp){
			includeGrpDropdown.find("[value='" + excGrp + "']").attr("disabled", true);
			excludeGrpDropdown.find("[value='" + excGrp + "']").attr("disabled", true);
			var formNode = $("#" + this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitExclusionToMemberGroupId' value='" + excGrp + "'/>");
		}, scope));
		
		$(".includeMbrGrp .entryField").each( $.proxy(function(index, entry){
			var grpId = $(entry).attr("data-grpId");
			if (this.assignedIncGroups.indexOf(grpId) < 0 ){
				$(entry).attr("aria-hidden", "true");
			}
			else {
				$(entry).attr("aria-hidden", "false");
			}
		}, scope));
		$(".excludeMbrGrp .entryField").each( $.proxy(function(index, entry){
			var grpId = $(entry).attr("data-grpId");
			if (this.assignedExcGroups.indexOf(grpId) < 0 ){
				$(entry).attr("aria-hidden", "true");
			}
			else {
				$(entry).attr("aria-hidden", "false");
			}
		}, scope));
		
		includeGrpDropdown.Select("refresh");
		excludeGrpDropdown.Select("refresh");
	},
	
	/**
	 * Save changes when press "Save" button
	 */
	saveChange: function(){
		
		var params = {};
		params.removeFromMemberGroupId =  this.assignedExcGroups.concat(this.assignedIncGroups);
		wcService.getServiceById('RESTUserMbrGrpMgtMemberUpdate').setFormId(this.formId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		wcService.invoke('RESTUserMbrGrpMgtMemberUpdate', params);
	}
};
