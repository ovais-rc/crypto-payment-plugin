//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

OnBehalfUtilities = function(){

	this.startCustomerService = function(node){
		var URL = node.getAttribute("data-customer-service-url");
		var buyOnBehalfName = getCookie("WC_BuyOnBehalf_"+WCParamJS.storeId);
		if(CSRWCParamJS.env_shopOnBehalfSessionEstablished === "true" && CSRWCParamJS.env_shopOnBehalfEnabled_CSR === "true"){
			//onbehalf session established by CSR. Show warning dialog before terminating it.
			wcTopic.subscribeOnce("onBehalfSessionTerminate", function(data){
				if (data.action === "YES"){
					document.location.href = URL;
				}
				if(data.action === "NO"){
				}
			});
			MessageHelper.showConfirmationDialog("onBehalfSessionTerminate",
						Utils.getLocalizationMessage('CSR_SESSION_TERMINATE_WARNING_MESSAGE', {0: escapeXml(buyOnBehalfName, true)}));
		} else {
			// Customer session is not yet started. Redirect to landing page.
			document.location.href = URL;
		}
	};

	this.updateUIAndRenderContext = function(response, masterContextName){
		
		//masterContextName - Name of the renderContext which was used to update user Status.
		// userStatus can be updated in FindOrders section or FindRegisteredCustomers section.
		// masterContext will contain the updated data.

		var userId1, userId2, updatedStatusOrder, updatedStatusUser = null;
		var contextExist = wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContext");
		if (contextExist) {
			userId1 = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContext")["userId"];
			updatedStatusUser = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContext")[userId1+"_userStatus"];
		}
		
		contextExist = wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContextCSR");
		if(contextExist) {
			userId2 = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContextCSR")["userId"];
			updatedStatusOrder = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContextCSR")[userId2+"_userStatus"];
		}

		var updatedStatus = null;
		var userId = null;
		if(masterContextName === "UserRegistrationAdminUpdateStatusContext"){
			updatedStatus = updatedStatusUser;
			userId = userId1;
		} else if(masterContextName === "UserRegistrationAdminUpdateStatusContextCSR") {
			updatedStatus = updatedStatusOrder;
			userId = userId2;
		}

		// Save it in context for future use.
		if(typeof(renderContextUser) !== 'undefined'){
			renderContextUser.properties[userId+"_updatedStatus"] = updatedStatus; 
		}
		if(typeof(renderContextOrder) !== 'undefined'){
			renderContextOrder.properties[userId+"_updatedStatus"] = updatedStatus; 
		}

		
		var userStatusText = Utils.getLocalizationMessage('DISABLE_CUSTOMER_ACCOUNT');
		if(updatedStatus === '0'){
			userStatusText = Utils.getLocalizationMessage('ENABLE_CUSTOMER_ACCOUNT');
		}
		// Update widget text...
		var toggleUserStatusControl = $("div[data-toggle-userStatus = 'userStatus_" + userId + "']");
		toggleUserStatusControl.forEach(function(node, index, arr){
			node.innerHTML = userStatusText;
		});
	};


	this.cancelOrder = function(orderId, reloadURL, onBehalf, authToken){
		//TODO - do we need forced cancel. ?
		wcRenderContext.getRenderContextProperties("onBehalfCommonContext")['cancelReloadURL'] = reloadURL;

		var service = wcService.getServiceById('AjaxCancelOrderAdministrator');
		if(onBehalf != null && onBehalf === 'true'){
			service.setUrl(getAbsoluteURL() +  "AjaxRESTCSROrderCancelOnbehalf");
		} else {
			service.setUrl(getAbsoluteURL() +  "AjaxRESTCSROrderCancelAsAdmin");
		}
		
		var params = [];
		params.orderId = orderId;
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;
		params["forcedCancel"] = "true";
		
		wcService.invoke("AjaxCancelOrderAdministrator", params);
	
	};

	this.unLockOrder = function(orderId, forceUnlock){
		if(forceUnlock != null && forceUnlock !== "" && forceUnlock === 'true'){
			// The order is locked by someone.. Need to first take over the lock and then unlock.
			this.takeOverLock(orderId, 'true');
			var removeHandler = wcTopic.subscribe("orderTakeOverSuccess", function(data){
				removeHandler.remove();
				// Now unlock the order.
				onBehalfUtilitiesJS.unLockOrder(orderId, "false");
			});

			return;
		}
		var service = this.getLockUnLockCartService('AjaxRESTOrderLockUnlockOnBehalf', getAbsoluteURL()+'AjaxRESTOrderUnlockOnBehalf', 'SUCCESS_ORDER_UNLOCK');
		var params = [];
		params["orderId"] = orderId;
		params["filterOption"] = "All";
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;	

		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke(service.getParam("id"), params);
	};

	this.lockOrder = function(orderId){
		var service = this.getLockUnLockCartService('AjaxRESTOrderLockUnlockOnBehalf', getAbsoluteURL()+'AjaxRESTOrderLockOnBehalf', 'SUCCESS_ORDER_LOCK');
		var params = [];
		params["orderId"] = orderId;
		params["filterOption"] = "All";
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;	

		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke(service.getParam("id"), params);
	};


	this.takeOverLock = function(orderId,publishTopic){
		var service = this.getLockUnLockCartService('AjaxRESTOrderLockUnlockOnBehalf', getAbsoluteURL()+'AjaxRESTOrderLockTakeOverOnBehalf',
				'SUCCESS_ORDER_TAKE_OVER', publishTopic);
		var params = [];
		params["orderId"] = orderId;
		params["filterOption"] = "All";
		params["takeOverLock"] = "Y"
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;	

		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke(service.getParam("id"), params);
	};

	this.getLockUnLockCartService = function(actionId,url,messageKey,publishTopic){

		var service = wcService.getServiceById('AjaxRESTOrderLockUnlockOnBehalf');

		if(service == null || service === undefined){

			wcService.declare({
				id: "AjaxRESTOrderLockUnlockOnBehalf",
				actionId: "AjaxRESTOrderLockUnlockOnBehalf",
				url: "",
				formId: "",
				successMessageKey:"",
				publishTopic:""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					cursor_clear();
					if(service.getParam("publishTopic") === 'true'){
						wcTopic.publish("orderTakeOverSuccess", serviceResponse);
						return;
					}
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(Utils.getLocalizationMessage(service.getParam("successMessageKey")));
					setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display updated cart lock status....
					if($('#quick_cart_container').length) {
						$('#quick_cart_container').hide();
					}
				}
				
				/**
				 * Displays an error message on the page if the request failed.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
				 */
				,failureHandler: function(serviceResponse) {
					if (serviceResponse.errorMessage) {
						MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
					} else {
						if (serviceResponse.errorMessageKey) {
							MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
						}
					}
				}
			});
			service = wcService.getServiceById('AjaxRESTOrderLockUnlockOnBehalf');
		}
		if(actionId != null && actionId !== 'undefined'){
			service.setActionId(actionId);
		}
		if(messageKey != null && messageKey !== 'undefined'){
			service.setParam("successMessageKey", messageKey);
		}
		if(publishTopic != null && publishTopic !== 'undefined'){
			service.setParam("publishTopic", publishTopic);
		} else {
			service.setParam("publishTopic", null);
		}
		if(url != null && url !== 'undefined'){
			service.setUrl(url);
		} else {
			service.setUrl(null);
		}
		return service;
	};
};


$(document).ready(function() {
	onBehalfUtilitiesJS = new OnBehalfUtilities();
});

wcRenderContext.declare("onBehalfCommonContext", [], {});
wcRenderContext.declare("orderLockStatusContext", ["orderLockStatusRefreshArea"], {});

var declareOrderLockStatusRefreshArea = function(){
	// ============================================
	// div: orderLockStatusRefreshArea refresh area
	// Declares a new refresh controller for the fetching order Lock status.
	var myWidgetObj = $("#orderLockStatusRefreshArea");
	myWidgetObj.refreshWidget("updateUrl", getAbsoluteURL() + "OrderLockStatusView?" + getCommonParametersQueryString());
	var myRCProperties = wcRenderContext.getRenderContextProperties("orderLockStatusContext");

	// model change
	wcTopic.subscribe("AjaxRESTOrderLockUnlockOnBehalf", function() {
		console.debug("modelChangedHandler of orderLockStatusController");
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	var postRefreshHandler = function () {
		console.debug("Post refresh handler of orderLockStatus");
		cursor_clear();
	};

	// initialize widget
	myWidgetObj.refreshWidget({postRefreshHandler: postRefreshHandler});
};

wcService.declare({
	id: "AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer",
	actionId: "AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer",
	url: getAbsoluteURL() +  "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("RESET_PASSWORD_SUCCESS"));
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		 var errorMessage = Utils.getLocalizationMessage(serviceResponse.errorMessageKey);
		 if(errorMessage == null){
			if (serviceResponse.errorMessage) {
				errorMessage = serviceResponse.errorMessage;
			} else if (serviceResponse.errorMessageKey) {
				errorMessage = serviceResponse.errorMessageKey;
			}
		 }
		MessageHelper.displayErrorMessage(errorMessage);
	}

});

wcService.declare({
	id: "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	actionId: "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	url: getAbsoluteURL() +  "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("RESET_PASSWORD_SUCCESS"));
		if(typeof(registeredCustomersJS) !== 'undefined'){
			registeredCustomersJS.onResetPasswordByAdminSuccess();
		}
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		var errorMessage = "";
		if(typeof(registeredCustomersJS) !== 'undefined'){
			 errorMessage = Utils.getLocalizationMessage(serviceResponse.errorMessageKey);
			 if(errorMessage == null){
				if (serviceResponse.errorMessage) {
					errorMessage = serviceResponse.errorMessage;
				} else if (serviceResponse.errorMessageKey) {
					errorMessage = serviceResponse.errorMessageKey;
				}
			 }
			registeredCustomersJS.onResetPasswordByAdminError(errorMessage,serviceResponse);
		}
	}

});

wcService.declare({
	id: "AjaxRESTMemberPasswordResetByAdmin",
	actionId: "AjaxRESTMemberPasswordResetByAdmin",
	url: getAbsoluteURL() +  "AjaxRESTMemberPasswordResetByAdmin",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("RESET_PASSWORD_SUCCESS"));
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("ERROR_RESET_PASSWORD_ACCESS_ACCOUNT_TO_RESET"));
	}

});

wcService.declare({
	id: "AjaxCancelOrderAdministrator",
	actionId: "AjaxCancelOrderAdministrator",
	url: getAbsoluteURL() +  "AjaxRESTCSROrderCancelAsAdmin"+"?"+getCommonParametersQueryString()+"&forcedCancel=true",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORDER_CANCEL_SUCCESS"));
        var reloadURL = wcRenderContext.getRenderContextProperties("onBehalfCommonContext")['cancelReloadURL'];
		if(reloadURL !== '' && typeof(reloadURL) !== 'undefined'){
			document.location.href = reloadURL;
		} else {
			window.location.reload(1);
		}
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} else {
			if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			}
		}
	}

});
