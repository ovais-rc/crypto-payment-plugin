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

if (flowEnabled.SideBySideIntegration) {

	CallCenterIntegrationJS = function() {
		this.lookUpMode = 'lookup';
		this.normalMode = 'normal';

		this.setUpCookies = function(cookieValue){
			var cookieName = "WCC_Mode_"+WCParamJS.storeId;
			// Add new cookie.
			if(cookieValue != undefined && cookieValue != null) {
				if(cookieValue.length > 0){
					setCookie("WCC_Mode_"+WCParamJS.storeId, escapeXml(cookieValue, true), {path:'/', domain:cookieDomain});
				} else {
					//Empty value passed for wccModeCookie. Delete it.
					removeCookie(cookieName);
				}
			}
		};
		
		this.updateWCParamJS = function(key, value){
			WCParamJS[key] = value;
		};
		
		this.consumeAddToCartEvent = function(params, customParams){
			var wccModeCookie = getCookie("WCC_Mode_"+WCParamJS.storeId);
			if(wccModeCookie == this.lookUpMode) {
				params.action = "Sending_Product";
				$.extend( params, customParams );
				params = JSON.stringify(params);
				console.debug(params);
				window.parent.postMessage(params, WCParamJS.wcc_integration_origin);
				return true;
			} else {
				return false;
			}
		};
		
		this.postActionMessage = function(params,actionName){
			var wccModeCookie = getCookie("WCC_Mode_"+WCParamJS.storeId);
			if(wccModeCookie == this.lookUpMode || wccModeCookie == this.normalMode) {
				params.action = actionName;
				params = JSON.stringify(params);
				window.parent.postMessage(params, WCParamJS.wcc_integration_origin);
				return true;
			} 
		};
		
		window.addEventListener("message", function(event) {
			if (event.origin != WCParamJS.wcc_integration_origin) {
				console.warn("Unexpected WCC Integration server - " + event.origin);
				return;
			}
			try {
				console.debug(event.data);
				var data = JSON.parse(event.data);
				if (data.action && data.action === "Requesting_Cart_Details") {
					var orderIdCookie = getCookie("WC_CartOrderId_"+WCParamJS.storeId);
					var params = {};
					params.storeId = WCParamJS.storeId;
					params.action = 'Sending_Cart';
					params.custId = WCParamJS.logonId;
					params.orderId = orderIdCookie;
					event.source.postMessage(JSON.stringify(params), event.origin);
				} else if (data.action && data.action === "ADD_TO_EXTERNAL_CART_SUCCESS") {
						cursor_clear();
				} else if(data.action && data.action === "TERMINATE_ON_BEHALF_SESSION"){
					if(typeof GlobalLoginShopOnBehalfJS != 'undefined' && GlobalLoginShopOnBehalfJS != undefined && GlobalLoginShopOnBehalfJS != null){
						GlobalLoginShopOnBehalfJS.restoreCSRSessionAndRedirect(data.redirectURL);
					}
				} else if(data.action && data.action === "SET_USER_IN_SESSION"){
					if(typeof registeredCustomersJS != 'undefined' && registeredCustomersJS != undefined && registeredCustomersJS != null){
						registeredCustomersJS.setUserInSession(data.userId, data.userName, data.redirectURL);
					}
				}
				
			} catch (e) {
				// Likely invalid message.  Ignore or handle other messages here.
				console.warn("Unexpected message: " + event.data); 
			}					
		});				
	};

	$(document).ready(function(){		
		callCenterIntegrationJS = new CallCenterIntegrationJS();
	});

}

