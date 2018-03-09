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
 * @fileOverview This file provides all the functions and variables to manage buyers list and the items within.
 * This file is included in all pages with organization users list actions.
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");
dojo.require("wc.widget.Tooltip");

/**
 * This service allows customer to create a new requisition list
 * @constructor
 */
wc.service.declare({
	id:"OrganizationUsersListAdminUpdateMember",
	actionId:"OrganizationUsersListAdminUpdateMember",
	url:"AjaxRESTUserRegistrationAdminUpdate",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSERSLIST_UPDATE_USERSTATUS_SUCCESS"]);
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
 * @class The OrganizationUsersListJS class defines the functions and variables that customers can use to manage their buyers list, 
 */
OrganizationUsersListJS ={		
	
	widgetShortName: "OrgUsersListWidget",
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
	
	viewUserURL: "",
	
	addUserURL: "",
	
	/**
	 * Sets the common parameters for the current page. 
	 * For example, the language ID, store ID, and catalog ID.
	 *
	 * @param {Integer} langId The ID of the language that the store currently uses.
	 * @param {Integer} storeId The ID of the current store.
	 * @param {Integer} catalogId The ID of the catalog.
	 * @param {Integer} authToken The authToken for current user to perform operation on server.
	 * @param {String} viewUserURL The URL for viewing and editing user.
	 * @param {String} addUserURL The URL for adding a user.
	 */
	setCommonParameters:function(langId,storeId,catalogId,authToken,viewUserURL,addUserURL){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		this.authToken = authToken;
		this.viewUserURL = viewUserURL;
		this.addUserURL = addUserURL;
		cursor_clear();
	},	
	
	/**
	 * Initialize the URL of Buyer List widget controller. 	 
	 *
	 * @param {object} widgetUrl The controller's URL.
	 */
	initOrganizationUsersListUrl:function(widgetUrl){
		wc.render.getRefreshControllerById('OrganizationUsersListTable_controller').url = widgetUrl;
	},
	
	/**
	 * Initial context with Organization info.
	 */
	initContextOrgEntity:function(orgEntityId, orgEntityName){
		wc.render.getContextById("OrganizationUsersListTable_Context").properties.orgEntityId = orgEntityId;
		wc.render.getContextById("OrganizationUsersListTable_Context").properties.orgEntityName = orgEntityName;
	},
	
	/**
	 * Search for Organization users use the search terms specified in the toolbar search form.
	 * 
	 * @param formId	The id of toolbar search form element.
	 */
	doSearch:function(formId){
		var form = dojo.byId(formId);
		this.updateContext({"beginIndex":"0", "userFirstName":form.userFirstName.value, "userLastName":form.userLastName.value, "userLogonId":form.userLogonId.value, "userRoleId":form.userRoleId.value, "userAccountStatus":form.userAccountStatus.value});
	},
	
	/**
	 * Clear the context search term value set by search form
	 */
	reset:function(){
		this.updateContext({"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":""});
	},
	
	/**
	 * Save the toolbar aria-expanded attribute value
	 */
	saveToolbarStatus:function(){
		var toolbar = dojo.byId("OrganizationUsersList_toolbar");
		if (toolbar !== undefined && toolbar !== null){
			this.toolbarExpanded = toolbar.getAttribute("aria-expanded");
		}
	},
	
	/**
	 * Restore the toolbar aria-expanded attribute, called by post refresh handler
	 */
	restoreToolbarStatus:function(){
		if (this.toolbarExpanded !== undefined && this.toolbarExpanded !== null){
			dojo.byId("OrganizationUsersList_toolbar").setAttribute("aria-expanded", this.toolbarExpanded);
		}
	},
	
	/**
	 * Update the OrganizationUsersListTable context with given context object.
	 * 
	 * @param context The context object to update
	 */
	updateContext:function(context){
		this.saveToolbarStatus();
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wc.render.updateContext("OrganizationUsersListTable_Context", context);
	},
	
	/**
	 * Update member user account status to 'Enabled' or 'Disalbed', status 0 means disabled, status 1 means enabled.
	 * 
	 * @param memberId The is of the member to be enable or disable
	 * @param status The '0' or '1' status
	 */
	updateMemberStatus:function(memberId, status){
		var params = {};
		params.URL = "StoreView"; //old command still check the presence of the 'URL' parameter
		params.storeId = this.storeId;
		params.langId = this.langId;
		params.userId = memberId;
		params.userStatus = status;
		params.authToken = this.authToken;
		this.saveToolbarStatus();
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wc.service.invoke('OrganizationUsersListAdminUpdateMember',params);
	},
	
	/**
	 * Redirect to add user detail page.
	 */
	addUser:function(){
		var orgEntityId = wc.render.getContextById("OrganizationUsersListTable_Context").properties['orgEntityId'];
		var orgName = wc.render.getContextById("OrganizationUsersListTable_Context").properties['orgEntityName'];
		//if (parentMemberId == "") parentMemberId = "7000000000000000801"; 
		var URL = this.addUserURL + "&orgEntityId=" + orgEntityId + "&orgEntityName=" + orgName;
		setPageLocation(URL);
	},
	
	/**
	 * Redirect to view user details page.
	 * 
	 * @param memberId The ID of the user
	 */
	viewDetails:function(memberId){
		var URL = this.viewUserURL + "&memberId=" + memberId;
		setPageLocation(URL);
		return false;
	},
	
	/**
	 * Update context to show page according specific number.
	 * 
	 * @param data The data for updating context.
	 */
	showPage:function(data){
		var pageNumber = data['pageNumber'];
		var pageSize = data['pageSize'];
		pageNumber = dojo.number.parse(pageNumber);
		pageSize = dojo.number.parse(pageSize);
		var beginIndex = pageSize * ( pageNumber - 1 );
		setCurrentId(data["linkId"]);
		//client has no way to change pageSize, so default pageSize defined in EnvironmentSetup.jspf will be used
		this.updateContext({"beginIndex":beginIndex});
	},
	
	/**
	* Publishes 'currentOrgIdRequest' topic.
	* Organization List widget will respond to this event and publishes the "currentOrgId" topic along with the orgId.
	* Responds to "currentOrgId" topic event by refreshing the organization summary data for the newOrgId
	*/
	publishOrgIdRequest:function(){
		var topicName = "currentOrgIdRequest";
		var scope = this;
		require(["dojo/topic","dojo/domReady!"], function(topic){
			topic.subscribe("currentOrgId", function(data){
				if(data.requestor === scope.widgetShortName){
					// The original request was from me. So respond to this event.
					scope.toolbarExpanded = "false";
					if (data.newOrgId.replace(/^\s+|\s+$/g, '') == ''){
						return;
					}
					if(!submitRequest()){
						return;
					}			
					cursor_wait();
					wc.render.updateContext("OrganizationUsersListTable_Context", {"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":"","orgEntityId" : data.newOrgId, "orgEntityName": data.newOrgName});
				}
			});
			// Set the requestor to my widgetShortName. 
			// Respond to follow-up events, only if the event published was in response to my request. 
			// The requestor attribute in the data helps to check this.
			var data = {"requestor":scope.widgetShortName};
			topic.publish(topicName, data);
		});
	},
	
	/**
	* Subscribe to 'organizationChanged' topic.
	* Organization Users List widget will respond to this topic event by refreshing the organization user list data for the newOrgId
	*/
	subscribeToOrgChange:function(data) {
		var topicName = "organizationChanged";
		var scope = this;
		require(["dojo/topic","dojo/domReady!"], function(topic){
			topic.subscribe(topicName, function(data){
				//console.debug("organizationChanged received");
				var renderContext = wc.render.getContextById("OrganizationUsersListTable_Context");
				if(renderContext.properties["orgEntityId"] != data.newOrgId){
					scope.toolbarExpanded = "false";
					submitRequest();
					cursor_wait();
					wc.render.updateContext("OrganizationUsersListTable_Context", {"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":"","orgEntityId" : data.newOrgId, "orgEntityName": data.newOrgName});
				}
			});
		});
	}
};