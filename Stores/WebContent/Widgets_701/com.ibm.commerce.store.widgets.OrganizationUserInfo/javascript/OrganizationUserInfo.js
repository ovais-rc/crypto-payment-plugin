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
 * @fileOverview This file provides all the functions and variables to manage member info.
 * This file is included in all pages with organization users list actions.
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");
require(["wc/widget/Select"]);

/**
 * This service allows admin to update member info
 * @constructor
 */
wc.service.declare({
	id:"OrganizationUserInfoAdminUpdateMember",
	url:"AjaxRESTUserRegistrationAdminUpdate"

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSERINFO_UPDATE_SUCCESS"]);
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
 * This service allows admin to add/create new member
 * Upon successfully creating user, the successHandler will call 
 * UserRoleManagementJS.assignRole function
 * @constructor
 */
wc.service.declare({
	id:"chainedAjaxUserRegistrationAdminAdd",
	url:"AjaxRESTUserRegistrationAdminAdd",
	formId:"Register"

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		if (typeof(UserRoleManagementJS) != 'undefined' && !UserRoleManagementJS.isEmptySelectedRoles()){
			UserRoleManagementJS.chainedAssignRole(serviceResponse.userId);
		}
		else {
			document.location.href = OrganizationUserInfoJS.getChainedServiceRediretUrl();
			cursor_clear();		
			MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSER_CREATE_SUCCESS"]);
		}
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


require([				
 		"dojo/on",
 		"dojo/query",
 		"dijit/registry",
 		"dojo/topic",
 		"dojo/dom"
 	], function(on, query, registry, topic, dom) {
 	
	/**
	 * This class defines the functions and variables that customers can use to create, update, and view user.
	 * @class The OrganizationUserInfoJS class defines the functions and variables that can be used to manage Organization users 
	 */
	OrganizationUserInfoJS ={		
		
		widgetShortName: "OrgUserUserInfoWidget",
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
		 * This variable stores the redirect url for chained create user service upon success.
		 * 
		 */
		chainedServiceRedirectUrl: "",	
		
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters:function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
			cursor_clear();
		},	
		
		/**
		 * Initialize the URL of Buyer List widget controller. 	 
		 *
		 * @param {object} userDetailsUrl The userDetails controller's URL.
		 * @param {object} userAddressUrl The userAddress controller's URL.
		 */
		initOrganizationUserInfoControllerUrls:function(userDetailsUrl,userAddressUrl){
			wc.render.getRefreshControllerById('OrganizationUserInfo_userDetail_controller').url = userDetailsUrl;
			wc.render.getRefreshControllerById('OrganizationUserInfo_userAddress_controller').url = userAddressUrl;
		},
		
		/**
		 * Initialize the Parent org info that the buyer to be created under. Will be used for constructing url return
		 * to "Organizations and buyers" page with pre-selected org. 
		 *
		 * @param {object} parentOrgName The parent Organization name.
		 * @param {object} parentOrgId The parentOrganization ID.
		 */
		initializeParentOrgInfo:function(parentOrgName, parentOrgId){
			this._parentOrgEntityName = parentOrgName;
			this._parentOrgEntityId = parentOrgId;
		},
		
		/**
		 * Update member user account status to 'Enabled' or 'Disalbed', status 0 means disabled, status 1 means enabled.
		 * 
		 * @param formId The id of the form to update
		 */
		saveUserInfoChange:function(form){
			if (! this.validateAndPrepareUserInfo(form)) return;
			wc.service.getServiceById('OrganizationUserInfoAdminUpdateMember').formId = form.id;
			wc.service.getServiceById('OrganizationUserInfoAdminUpdateMember').actionId = "OrganizationUserInfoAdminUpdateMember_" + form.id;
			//console.debug(wc.service.getServiceById('OrganizationUserInfoAdminUpdateMember').actionId);
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.service.invoke('OrganizationUserInfoAdminUpdateMember');
		},
		
		/**
		 * This function validate and prepare the update form for submit, the form is used to update user info.
		 * @param {string} form The name of the form containing personal information of the customer.
		 */
		validateAndPrepareUserInfo:function(form){
			if (form.name != 'UserAddress') {
				if(typeof(form.logonPassword_old) != 'undefined' && typeof(form.logonPasswordVerify_old) != 'undefined'){
					if(form.logonPassword_old.name == "logonPassword") {
						form.logonPassword_old.name = "logonPassword_old";
						form.logonPasswordVerify_old.name = "logonPasswordVerify_old";
					}
					/*check whether the values in password and verify password fields match, if so, update the password. */ 
					if (form.logonPassword_old.value.length != 0)
					{
						if(form.logonPassword_old.value!= form.logonPasswordVerify_old.value)
						{
							MessageHelper.formErrorHandleClient(form.logonPasswordVerify_old.id,MessageHelper.messages["PWDREENTER_DO_NOT_MATCH"]);
							return false; 
						}
						form.logonPassword_old.name = "logonPassword";
						form.logonPasswordVerify_old.name = "logonPasswordVerify";
					}
				}
			}
			
			/** Uses the common validation function defined in AddressHelper class for validating first name, 
			 *  last name, street address, city, country/region, state/province, ZIP/postal code, e-mail address and phone number. 
			 */

			if(!AddressHelper.validateAddressForm(form)){
				return false;
			}
			
			/* Checks whether the customer has registered for promotional e-mails. */
			if(form.sendMeEmail && form.sendMeEmail.checked ){
			    if (form.receiveEmail) form.receiveEmail.value = true;
			}
			else {
				if (form.receiveEmail) form.receiveEmail.value = false;
			}
			
			if(form.sendMeSMSNotification && form.sendMeSMSNotification.checked){
				if (form.receiveSMSNotification) form.receiveSMSNotification.value = true;
			}
			else {
				if (form.receiveSMSNotification) form.receiveSMSNotification.value = false;
			}

			if(form.sendMeSMSPreference && form.sendMeSMSPreference.checked){
				if (form.receiveSMS)form.receiveSMS.value = true;
			}
			else {
				if (form.receiveSMS) form.receiveSMS.value = false;
			}

			if(form.mobileDeviceEnabled != null && form.mobileDeviceEnabled.value == "true"){
				if(!MyAccountDisplay.validateMobileDevice(form)){
					return false;
				}
			}
			if(form.birthdayEnabled != null && form.birthdayEnabled.value == "true"){
				if(!MyAccountDisplay.validateBirthday(form)){
					return false;
				}
			}
			return true;
		},

		/**
		* Publishes 'currentOrgIdRequest' topic.
		* Organization List widget will respond to this event and publishes the "currentOrgId" topic along with the orgId.
		* Responds to "currentOrgId" topic event by refreshing the organization summary data for the newOrgId
		*/
		publishOrgIdRequest:function(){
			var topicName = "currentOrgIdRequest";
			var scope = this;
			
			topic.subscribe("currentOrgId", function(data){
				if(data.requestor === scope.widgetShortName){
					// The original request was from me. So respond to this event.
					var parentMemberIdInput = dom.byId("WC_OrganizationUserInfo_userDetails_Form_Input_parentMemberId");
					parentMemberIdInput.setAttribute("value",data.newOrgId);
					scope._parentOrgEntityName = data.newOrgName;
					scope._parentOrgEntityId = data.newOrgId;
				}
				// Set the requestor to my widgetShortName. 
				// Respond to follow-up events, only if the event published was in response to my request. 
				// The requestor attribute in the data helps to check this.
				var data = {"requestor":scope.widgetShortName};
				topic.publish(topicName, data);
			});
		},
		
		/**
		* Subscribe to 'organizationChanged' topic.
		* Organization User Info widget will respond to this topic event by updating the parentMemberId to newOrgId
		*/
		subscribeToOrgChange:function() {
			var topicName = "organizationChanged";
			var scope = this;
			topic.subscribe(topicName, function(data){
				//console.debug("organizationChanged received");
				var parentMemberIdInput = dom.byId("WC_OrganizationUserInfo_userDetails_Form_Input_parentMemberId");
				parentMemberIdInput.setAttribute("value",data.newOrgId);
				scope._parentOrgEntityName = data.newOrgName;
				scope._parentOrgEntityId = data.newOrgId;
			});
		},
		 	
	 	resetFormValue: function(target){
	 		query("form", target).forEach(function(form){
				form.reset();
				query(".dijitSelect", form).forEach(function(select){
					registry.byNode(select).reset();
				})
			});
	 	},
	 	
	 	subscribeToToggleCancel: function(){
	 		var topicName = "sectionToggleCancelPressed";
	 		var scope = this;
	 		topic.subscribe(topicName, function(data){
	 			if (data.target === 'WC_OrganizationUserInfo_userDetails_pageSection' || data.target === 'WC_OrganizationUserInfo_userAddress_pageSection'){
	 				scope.resetFormValue(document.getElementById(data.target));
	 			}
	 		});
	 	},
	 	
	 	/**
	 	 * The function is called from add/create buyer page submit button, in 'chainedAjaxUserRegistrationAdminAdd' successHandler
	 	 * will call role assignment and member group widget's service.
	 	 * @param form the user details and address form to submit
	 	 * @url the url for the store page that will be displayed upon submit success.
	 	 */
	 	chainedServicePrepareSubmit: function(form, url) {

		if(CSRWCParamJS.env_shopOnBehalfSessionEstablished == 'true' || CSRWCParamJS.env_shopOnBehalfEnabled_CSR == 'true'){
			require(["dojo/dom-construct"],
			    function(domConstruct) {
					var random = Math.random();
					var randomPassword = random.toString(36).slice(-7); // Get last 7 chars. Will add one numeric char to make it 8 char long...
					var randomInt = Math.floor((random * 9) + 1); 
					randomPassword += randomInt; //Password should contain atleast one numeric character...
					if(dojo.byId("logonPassword") == null){
						domConstruct.create("input", {
							type: "hidden",
							value: randomPassword,
							name: "logonPassword",
							id: "logonPassword",
						}, form);
					}
					if(dojo.byId("logonPasswordVerify") == null){
						domConstruct.create("input", {
							type: "hidden",
							value: randomPassword,
							name: "logonPasswordVerify",
							id: "logonPasswordVerify"
						}, form);
					}
					if(dojo.byId("passwordExpired") == null){
						domConstruct.create("input", {
							type: "hidden",
							value: "1",
							name: "passwordExpired",
							id: "passwordExpired"
						}, form);
					}
			});
		}



	 		if (!LogonForm.validatePrepareForm(form)){
	 			return;
	 		}
	 		this.chainedServiceRedirectUrl = url;
	 		wc.service.getServiceById('chainedAjaxUserRegistrationAdminAdd').formId = form.id;
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.service.invoke('chainedAjaxUserRegistrationAdminAdd');
	 	},
	 	
	 	/**
	 	 * Return URL with pre-selected Organization info.
	 	 */
	 	getChainedServiceRediretUrl: function(){
	 		var url = this.chainedServiceRedirectUrl;
	 		if (url != '' && this._parentOrgEntityId !== undefined && this._parentOrgEntityId !== null){
	 			url = url + '&orgEntityId='+ this._parentOrgEntityId + '&orgEntityName='+ this._parentOrgEntityName;
	 		}
	 		return url;
	 	}
	 	
	};
 	
});