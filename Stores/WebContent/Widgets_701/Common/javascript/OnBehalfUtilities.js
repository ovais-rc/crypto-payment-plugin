//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.require("wc.widget.Tooltip");
require([
			 "dojo/html",
	 		 "dojo/_base/lang",
			 "dojo/on", 
			 "dojo/query", 
			 "dojo/topic", 
			 "dojo/dom",
			 "dojo/dom-style",
			 "dojo/dom-class",
			 "dojo/_base/event",
			 "dojo/_base/array",
			 "dojo/json",
			 "dojo/domReady!"], function(html,lang,on, query, topic, dom, domStyle, domClass, event, array,json) {

OnBehalfUtilities = function(){

	this.startCustomerService = function(node){
		var URL = node.getAttribute("data-customer-service-url");
		var buyOnBehalfName = getCookie("WC_BuyOnBehalf_"+WCParamJS.storeId);
		if(CSRWCParamJS.env_shopOnBehalfSessionEstablished == "true" && CSRWCParamJS.env_shopOnBehalfEnabled_CSR == "true"){
			//onbehalf session established by CSR. Show warning dialog before terminating it.
			var removeHandler = topic.subscribe("onBehalfSessionTerminate", function(data){
			removeHandler.remove();
			if (data.action == "YES"){
				document.location.href = URL;
			}
			if(data.action == "NO"){
			}
		});
		MessageHelper.showConfirmationDialog("onBehalfSessionTerminate",
						lang.replace(storeNLS['CSR_SESSION_TERMINATE_WARNING_MESSAGE'], [escapeXml(buyOnBehalfName, true)]));
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
		var renderContextUser = wc.render.getContextById("UserRegistrationAdminUpdateStatusContext");
		if(typeof(renderContextUser) != 'undefined') {
			userId1 = renderContextUser.properties["userId"];
			updatedStatusUser = renderContextUser.properties[userId1+"_userStatus"];
		}
		
		var renderContextOrder = wc.render.getContextById("UserRegistrationAdminUpdateStatusContextCSR");
		if(typeof(renderContextOrder) != 'undefined') {
			userId2 = renderContextOrder.properties["userId"];
			updatedStatusOrder = renderContextOrder.properties[userId2+"_userStatus"];
		}

		var updatedStatus = null;
		var userId = null;
		if(masterContextName == "UserRegistrationAdminUpdateStatusContext"){
			updatedStatus = updatedStatusUser;
			userId = userId1;
		} else if(masterContextName == "UserRegistrationAdminUpdateStatusContextCSR") {
			updatedStatus = updatedStatusOrder;
			userId = userId2;
		}

		// Save it in context for future use.
		if(typeof(renderContextUser) != 'undefined'){
			renderContextUser.properties[userId+"_updatedStatus"] = updatedStatus; 
		}
		if(typeof(renderContextOrder) != 'undefined'){
			renderContextOrder.properties[userId+"_updatedStatus"] = updatedStatus; 
		}

		
		var userStatusText = storeNLS['DISABLE_CUSTOMER_ACCOUNT'];
		if(updatedStatus == '0'){
			userStatusText = storeNLS['ENABLE_CUSTOMER_ACCOUNT'];
		}
		// Update widget text...
		var toggleUserStatusControl = query("div[data-toggle-userStatus = 'userStatus_" + userId + "']");
		toggleUserStatusControl.forEach(function(node, index, arr){
			node.innerHTML = userStatusText;
		});
	};


	this.cancelOrder = function(orderId, reloadURL, onBehalf){
		//TODO - do we need forced cancel. ?
		var renderContext = wc.render.getContextById('onBehalfCommonContext');
		renderContext.properties['cancelReloadURL'] = reloadURL;

		var service = wc.service.getServiceById('AjaxCancelOrderAdministrator');
		if(onBehalf != null && onBehalf == 'true'){
			service.url = getAbsoluteURL() +  "AjaxRESTCSROrderCancelOnbehalf";
		} else {
			service.url = getAbsoluteURL() +  "AjaxRESTCSROrderCancelAsAdmin";
		}
		
		var params = [];
		params.orderId = orderId;
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;
		params["forcedCancel"] = "true";
		
		wc.service.invoke("AjaxCancelOrderAdministrator", params);
	
	};

	this.unLockOrder = function(orderId, forceUnlock){
		if(forceUnlock != null && forceUnlock != "" && forceUnlock == 'true'){
			// The order is locked by someone.. Need to first take over the lock and then unlock.
			this.takeOverLock(orderId, 'true');
			var removeHandler = topic.subscribe("orderTakeOverSuccess", function(data){
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
		wc.service.invoke(service.id, params);
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
		wc.service.invoke(service.id, params);
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
		wc.service.invoke(service.id, params);
	};

	this.getLockUnLockCartService = function(actionId,url,messageKey,publishTopic){

		var service = wc.service.getServiceById('AjaxRESTOrderLockUnlockOnBehalf');

		if(service == null || service == undefined){

			wc.service.declare({
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
					if(service.publishTopic == 'true'){
						topic.publish("orderTakeOverSuccess", serviceResponse);
						return;
					}
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(storeNLS[service.successMessageKey]);
					setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display updated cart lock status....
					if(dijit.byId('quick_cart_container') != null) {
						dijit.byId('quick_cart_container').hide();
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
			service = wc.service.getServiceById('AjaxRESTOrderLockUnlockOnBehalf');
		}
		if(actionId != null && actionId != 'undefined'){
			service.actionId = actionId;
		}
		if(messageKey != null && messageKey != 'undefined'){
			service.successMessageKey = messageKey;
		}
		if(publishTopic != null && publishTopic != 'undefined'){
			service.publishTopic = publishTopic;
		} else {
			service.publishTopic = null;
		}
		if(url != null && url != 'undefined'){
			service.url = url;
		} else {
			service.url = null;
		}
		return service;
	};
};

});


dojo.addOnLoad(function(){
	onBehalfUtilitiesJS = new OnBehalfUtilities();
});

wc.render.declareContext("orderLockStatusContext",{},"");
wc.render.declareContext("onBehalfCommonContext", {},"");

/** 
 * Declares a new refresh controller for the fetching order Lock status.
 */
wc.render.declareRefreshController({
	   id: "orderLockStatusController",
	   renderContext: wc.render.getContextById("orderLockStatusContext"),
	   url: "",
	   baseURL:getAbsoluteURL()+'OrderLockStatusView',
	   formId: ""
	   
	   ,modelChangedHandler: function(message, widget) {
			console.debug("modelChangedHandler of orderLockStatusController",widget);
			var controller = this;
			var renderContext = this.renderContext;
			controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
			if(message.actionId == 'AjaxRESTOrderLockUnlockOnBehalf'){
				widget.refresh(renderContext.properties);
			}
	   }

	   ,renderContextChangedHandler: function(message, widget) {
			console.debug("renderContextChangedHandler of orderLockStatusController",widget);
	   }       	   

	   ,postRefreshHandler: function(widget) {
			console.debug("Post refresh handler of orderLockStatus",widget);
			cursor_clear();
	   }
});

wc.service.declare({
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
		MessageHelper.displayStatusMessage(storeNLS["RESET_PASSWORD_SUCCESS"]);
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		 var errorMessage = storeNLS[serviceResponse.errorMessageKey];
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

wc.service.declare({
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
		MessageHelper.displayStatusMessage(storeNLS["RESET_PASSWORD_SUCCESS"]);
		if(typeof(registeredCustomersJS) != 'undefined'){
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
		if(typeof(registeredCustomersJS) != 'undefined'){
			 errorMessage = storeNLS[serviceResponse.errorMessageKey];
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

wc.service.declare({
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
		MessageHelper.displayStatusMessage(storeNLS["RESET_PASSWORD_SUCCESS"]);
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		MessageHelper.displayErrorMessage(storeNLS["ERROR_RESET_PASSWORD_ACCESS_ACCOUNT_TO_RESET"]);
	}

});

wc.service.declare({
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
		MessageHelper.displayStatusMessage(storeNLS["ORDER_CANCEL_SUCCESS"]);
		var renderContext = wc.render.getContextById('onBehalfCommonContext');
		var reloadURL = renderContext.properties['cancelReloadURL'];
		if(reloadURL != '' && typeof(reloadURL) != 'undefined'){
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
