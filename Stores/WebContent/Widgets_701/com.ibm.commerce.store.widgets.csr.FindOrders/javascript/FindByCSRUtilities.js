//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

require([
			 "dojo/html",
			 "dojo/on", 
			 "dojo/query", 
			 "dojo/topic", 
			 "dojo/dom",
			 "dojo/dom-style",
			 "dojo/dom-class",
			 "dojo/_base/event",
			 "dojo/_base/array",
			 "dojo/NodeList-manipulate",
			 "dojo/domReady!"], function(html,on, query, topic, dom, domStyle, domClass, event, array,nodelist) {

	FindByCSRUtilities = function(){
				

	this.showHide = function(nodeId, hiddenClassName, activeClassName){
		query('#'+nodeId).toggleClass(hiddenClassName);
		query('#'+nodeId).toggleClass(activeClassName);
	};

	this.changeDropDownArrow = function(nodeId, arrowClass){
		query('#'+nodeId).toggleClass(arrowClass);
	};


	this.toggleSelection = function(nodeCSS,nodeId,parentNode,cssClassName){
		// Get list of all active nodes with cssClass = nodeCSS under parentNode.
		var activeNodes = query('.'+cssClassName, parentNode); 

		// Toggle the css class for the node with id = nodeId
		query('#'+nodeId, parentNode).toggleClass(cssClassName);

		// Remove the css class for all the active nodes.
		activeNodes.removeClass(cssClassName);
	};

	this.handleErrorScenario = function(){
		var errorMessageObj = dojo.byId("errorMessageFindOrders");
		var errorSectionObj = dojo.byId("errorMessage_sectionFindOrders");
		if(errorMessageObj != null){
			var errorMessage = errorMessageObj.value;
	
			if(errorMessage != null && errorMessage.length != "" && errorSectionObj != null){
				 domStyle.set(errorSectionObj, 'display', 'block');
				 domStyle.set(errorSectionObj, 'color', '#CA4200');
				 // TODO - set focus to error div..for accessibility...
				 html.set(errorSectionObj, errorMessage);
			} 
		} else {
		
			domStyle.set(errorSectionObj, 'display', 'none');
		}
	};

	this.cancelEvent =  function(e) {
		if (e.stopPropagation) {
			e.stopPropagation();
		}
		if (e.preventDefault) {
			e.preventDefault();
		}
		e.cancelBubble = true;
		e.cancel = true;
		e.returnValue = false;
	};

	this.closeActionButtons = function(nodeCSS,parentNode,cssClassName,hiddenClassName,activeClassName){
		query('.'+nodeCSS, parentNode).removeClass(cssClassName);
	};

	this.resetActionButtonStyle = function(nodeCSS,parentNode,hiddenClassName,activeClassName){
		query('.'+nodeCSS, parentNode).addClass(hiddenClassName);
		query('.'+nodeCSS, parentNode).removeClass(activeClassName);
	};

	this.toggleCSSClass = function(nodeCSS,nodeId,parentNode,hiddenClassName,activeClassName){
		// Get the list of current nodes
		var activeNodes = query('.'+activeClassName, parentNode); 

		// For the clicked node, toggle the CSS Class. If hidden then display / If displayed then hide.
		query('#'+nodeId, parentNode).toggleClass(hiddenClassName);
		query('#'+nodeId, parentNode).toggleClass(activeClassName);

		// For all activeNodes, remove the activeCSS and add the hiddenCSS
		activeNodes.removeClass(activeClassName);
		activeNodes.addClass(hiddenClassName);
	};
	

	this.setUserInSession = function(userId, selectedUser,landingURL){

		var renderContext = wc.render.getContextById('findOrdersSearchResultsContextCSR');
		if(selectedUser != '' && selectedUser != null) {
			renderContext.properties["selectedUser"] = escapeXml(selectedUser, true);
		}
		if(landingURL != '' && landingURL != null){
			renderContext.properties["landingURL"] = landingURL;
		}

	// If we are setting a forUser in session here, it has to be CSR role. Save this info in context.
		// Once user is successfully set, we will set this info in cookie.
		renderContext.properties["WC_OnBehalf_Role_"] = "CSR";

		var params = [];
		params.runAsUserId = userId;
		params.storeId = WCParamJS.storeId;
		wc.service.invoke("AjaxRunAsUserSetInSessionCSR", params);
	};

	this.onUserSetInSession = function(){
		var renderContext = wc.render.getContextById('findOrdersSearchResultsContextCSR');
		var selectedUser = renderContext.properties["selectedUser"];
		if(selectedUser != '' && selectedUser != null){
			//write the cookie.
			setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, escapeXml(selectedUser, true), {path:'/', domain:cookieDomain});
		}
		var onBehalfRole = renderContext.properties["WC_OnBehalf_Role_"];
		if(onBehalfRole != '' && onBehalfRole != null){
			//write the cookie.
			setCookie("WC_OnBehalf_Role_"+WCParamJS.storeId, onBehalfRole, {path:'/', domain:cookieDomain});
		}
	};


		
	this.enableDisableUserAccount = function(userId, status,logonId){
	
		//Save it in context
		var context = wc.render.getContextById("UserRegistrationAdminUpdateStatusContextCSR");
		context.properties["userId"] = userId;

		// If userStatus is already available in context, then use it. 
		// This means, the status is updated by making an Ajax call after the page is loaded and status is updated.
		var updatedStatus = context.properties[userId+"_updatedStatus"];
		if(updatedStatus != null){
			if(updatedStatus == '0'){
				status = '1';
			} else {
				status = '0';
			}
		}
		context.properties[userId+"_userStatus"] = status;
		// Invoke service
		wc.service.invoke("AjaxRESTUserRegistrationAdminUpdateStatusCSR", {'userId' : userId, 'userStatus':status, 'logonId' : logonId});
	};

	this.onEnableDisableUserStatusAccount = function(serviceResponse){
		var message = storeNLS["CUSTOMER_ACCOUNT_ENABLE_SUCCESS"];
		if(serviceResponse.userStatus == '0'){
			message = storeNLS["CUSTOMER_ACCOUNT_DISABLE_SUCCESS"];
		}
		MessageHelper.displayStatusMessage(message);
		onBehalfUtilitiesJS.updateUIAndRenderContext(serviceResponse,"UserRegistrationAdminUpdateStatusContextCSR");
	};

	
	
};
	
});


dojo.addOnLoad(function(){
	findbyCSRJS = new FindByCSRUtilities();

});


/**
 * Declares a new render context for find orders  result list - To display orders based on search criteria.
 */
wc.render.declareContext("findOrdersSearchResultsContextCSR",{'isPaginatedResults':'false'},"");


//Declare context and service for updating the status of user.
wc.render.declareContext("UserRegistrationAdminUpdateStatusContextCSR",{},"");
wc.service.declare({
	id: "AjaxRESTUserRegistrationAdminUpdateStatusCSR",
	actionId: "AjaxRESTUserRegistrationAdminUpdateStatusCSR",
	url: getAbsoluteURL() +  "AjaxRESTUserRegistrationAdminUpdate",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		findbyCSRJS.onEnableDisableUserStatusAccount(serviceResponse);
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


// Service to start on-behalf user session.
wc.service.declare({
	id: "AjaxRunAsUserSetInSessionCSR",
	actionId: "AjaxRunAsUserSetInSessionCSR",
	url: getAbsoluteURL() + "AjaxRunAsUserSetInSession",
	formId: ""
	
	/**
	 * Clear messages on the page.
	 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		//Use this CSR_SUCCESS_ACCOUNT_ACCESS
		MessageHelper.displayStatusMessage(storeNLS["CSR_SUCCESS_CUSTOMER_ACCOUNT_ACCESS"]);
		
		findbyCSRJS.onUserSetInSession();
		setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display shoppers cart details...
		var landingURL = wc.render.getContextById('findOrdersSearchResultsContextCSR').properties["landingURL"];
		window.location.href = landingURL; // if landingURL is null, it reloads same page. so don't check for != ''
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
		cursor_clear();
	}
});


