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
			 "dojo/domReady!"], function(html,on, query, topic, dom, domStyle, domClass, event, array) {

RegisteredCustomers = function(){
				
	this.searchListData = {
							"progressBarId":"RegisteredCustomersList_form_botton_1", "formId":"RegisteredCustomersSearch_searchForm", 
							"searchButtonId":"RegisteredCustomersList_form_botton_1", "clearButtonId":"RegisteredCustomersList_form_botton_2"
						  },

	this.csrResetPasswordIds = {
								"administratorPasswordId":"administratorPassword", "errorDivId":"csr_resetPassword_error", "errorMessageId":"csr_resetPassword_error_msg",
								"parentNodeId":"csr_reset_password", "resetPasswordButtonId":"csr_resetPassword_button", 
								 "resetPasswordDropDownPanelId":"csr_resetPassword_dropdown_panel"
							   },
	
	this.csrPasswordEnabled = false,
	
	/**
		Setup events for Search and Clear Results button in Find Registered Customer Page
	*/
	this.setUpEvents = function(){
		var scope = this;
		var target = dojo.byId(this.searchListData.searchButtonId);
		if(target != null) {
			on(target, "click", function(event){
				scope.doSearch();
			});
		}

		target = dojo.byId(this.searchListData.clearButtonId);
		if(target != null) {
			on(target, "click", function(event){
				scope.clearFilter();
			});
		}

	};

	/**
		Clear search results and search criteria.
	*/
	this.clearFilter = function(){
		
		this.clearSearchResults();
		// Remove search criteria..
		dojo.query('#RegisteredCustomersSearch_searchForm input[id ^= "RegisteredCustomersSearch_"]').forEach(function(inputElement){
			inputElement.value = null;
		});

		dojo.query('#RegisteredCustomersSearch_searchForm table[id ^= "RegisteredCustomersSearch_"]').forEach(function(inputElement){
			var dijitObject = dijit.byId(inputElement.id);
			if(dijitObject != null){
				dijitObject.setValue('-1');
			}
		});
	};

	/**
		Search for registered customers.
	*/
	this.doSearch = function(){
		
		this.clearSearchResults();

		//Do we have any search criteria to search ?
		var doSearch = false;
		dojo.query('#'+this.searchListData.formId+' input[id ^= "RegisteredCustomersSearch_"]').forEach(function(inputElement){
				 var value = inputElement.value;
				 if(value != null && value != ''){
					 doSearch = true;
				 }
			 });


		// Do we have some criteria in drop down boxes - State / Country ?
		if(!doSearch){
			dojo.query('#'+this.searchListData.formId+' table[id ^= "RegisteredCustomersSearch_"]').forEach(function(inputElement){
					var dijitObject = dijit.byId(inputElement.id);
					var value = dijitObject.value;
					if(value != '' ){
						doSearch = true;
					}
				 });
		}


		if(!doSearch) {
			MessageHelper.formErrorHandleClient(this.searchListData.searchButtonId, storeNLS["CSR_NO_SEARCH_CRITERIA"]);
			return false;
		}

		var renderContext = wc.render.getContextById('registeredCustomersSearchResultsContext');		
		renderContext.properties["searchInitializedForCustomers"] = "true";
		
		setCurrentId(this.searchListData.progressBarId);
		if(!submitRequest()){
			return;
		}

		cursor_wait();
		var params = {};
		wc.render.getRefreshControllerById("registeredCustomersController").formId = this.searchListData.formId;
		wc.render.updateContext("registeredCustomersSearchResultsContext", params);	
	};

	
	this.toggleMemberSummarySection = function(memberId){
		this.showHide('memberDetailsExpandedContent_'+memberId, 'collapsed', 'expanded');
		this.changeDropDownArrow('dropDownArrow_'+memberId,'expanded');
		return true;
	};

	
	this.handleActionDropDown = function(event,memberId, parentNode){
		this.cancelEvent(event);
		this.toggleSelection('actionDropdown','actionDropdown_'+memberId, parentNode, 'active');
		this.toggleCSSClass('actionButton','actionButton7_'+memberId,parentNode,'actionDropdownAnchorHide','actionDropdownAnchorDisplay');
		return false;
	}

	this.showHide = function(nodeId, hiddenClassName, activeClassName){
		query('#'+nodeId).toggleClass(hiddenClassName);
		query('#'+nodeId).toggleClass(activeClassName);
	};

	this.changeDropDownArrow = function(nodeId, arrowClass){
		query('#'+nodeId).toggleClass(arrowClass);
	};

	this.clearSearchResults = function(){
		// Remove search results
		if(dojo.byId("registeredCustomersList_table") != null){
			dojo.style("registeredCustomersList_table","display","none");
		}
	};

	this.toggleSelection = function(nodeCSS,nodeId,parentNode,cssClassName){
		// Get list of all active nodes with cssClass = nodeCSS under parentNode.
		var activeNodes = query('.'+cssClassName, parentNode); 

		// Toggle the css class for the node with id = nodeId
		query('#'+nodeId, parentNode).toggleClass(cssClassName);

		// Remove the css class for all the active nodes.
		activeNodes.removeClass(cssClassName);
	};

	this.resetPasswordByAdminOnBehalfForBuyers = function(userId){
		wc.service.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer", {'logonId':userId, 'URL':"test"});
	};

	this.resetPasswordByAdminOnBehalf = function(userId){
		
		var renderContext = wc.render.getContextById('registeredCustomersSearchResultsContext');
		if(this.csrPasswordEnabled) {
			//  Use this when CSR password is mandatory to reset customer password.
			var administratorPassword = dojo.byId(this.csrResetPasswordIds.administratorPasswordId).value;
			if(administratorPassword == null || administratorPassword == ''){
				var error = storeNLS['CSR_PASSWORD_EMPTY_MESSAGE'];
				this.onResetPasswordByAdminError(error);
				return false;
			}
			wc.service.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalf", {'administratorPassword': administratorPassword, 'logonId':userId, 'URL':"test"});
		} else {
			wc.service.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalf", {'logonId':userId, 'URL':"test"});
		}
	};

	this.resetPasswordByAdmin = function(userId,administratorPassword){
		wc.service.invoke("AjaxRESTMemberPasswordResetByAdmin", {'administratorPassword' : administratorPassword, 'logonId':userId, 'URL':"test"});
	};

	this.handleCSRPasswordReset = function(event){
		this.cancelEvent(event);

		if(this.csrPasswordEnabled) {
			dojo.byId(this.csrResetPasswordIds.administratorPasswordId).value = '';
		}
		// Change the sytling of the ResetPassword button
		query('#'+this.csrResetPasswordIds.resetPasswordButtonId, this.csrResetPasswordIds.parentNodeId).toggleClass('clicked');

		// Toggle the css class for the dropDown panel with id = nodeId
		query('#'+this.csrResetPasswordIds.resetPasswordDropDownPanelId, this.csrResetPasswordIds.parentNodeId).toggleClass('active');

		// Hide error div.
		query('#'+this.csrResetPasswordIds.errorDivId, this.csrResetPasswordIds.parentNodeId).addClass('hidden');

		return false;
	}

	this.hideErrorDiv = function(){
		// Hide error div.
		query('#'+this.csrResetPasswordIds.errorDivId, this.csrResetPasswordIds.parentNodeId).addClass('hidden');
	}

	this.onResetPasswordByAdminError = function(errorMessage, errorResponse){
		dojo.byId(this.csrResetPasswordIds.errorMessageId).innerHTML = errorMessage;
		// Display error div.
		query('#'+this.csrResetPasswordIds.errorDivId, this.csrResetPasswordIds.parentNodeId).removeClass('hidden');
		// focus to error div.
		dojo.byId(this.csrResetPasswordIds.errorMessageId).focus();
	}

	this.onResetPasswordByAdminSuccess = function(){
		// Change the sytling of the ResetPassword button
		query('#'+this.csrResetPasswordIds.resetPasswordButtonId, this.csrResetPasswordIds.parentNodeId).toggleClass('clicked');
		
		// Toggle the css class for the dropDown panel with id = nodeId
		query('#'+this.csrResetPasswordIds.resetPasswordDropDownPanelId, this.csrResetPasswordIds.parentNodeId).toggleClass('active');
		return false;
	}

	this.handleErrorScenario = function(){
		var errorMessageObj = dojo.byId("errorMessage");
		var errorSectionObj = dojo.byId("errorMessage_section");
		if(errorMessageObj != null){
			var errorMessage = errorMessageObj.value;
			if(errorMessage != null && errorMessage.length != "" && errorSectionObj != null){
				 domStyle.set(errorSectionObj, 'display', 'block');
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

	this.createGuestUser = function(landingURL){
		var renderContext = wc.render.getContextById('registeredCustomersSearchResultsContext');
		if((landingURL == null || landingURL == '') && !stringStartsWith(document.location.href, "https")){
			renderContext.properties["landingURL"] = '';
		} else {
			// Reload home page
			landingURL = WCParamJS.homePageURL;
			renderContext.properties["landingURL"] = landingURL;
		}
		
		var params = [];
		wc.service.invoke("AjaxRESTCreateGuestUser", params);
	};

	this.createRegisteredUser = function(landingURL){
		if(landingURL != null) {
			var renderContext = wc.render.getContextById('registeredCustomersSearchResultsContext');
			renderContext.properties["landingURL"] = landingURL;
		}
		
		var params = [];
		var form = dojo.byId("Register");
		if(form.guestUserId != null && form.guestUserId.value != null){
			// Guest user id exists. Use it while registering new user.
			params.userId = form.guestUserId.value;
		}
		// Do not set errorViewName, since we are making Ajax call. Handle the response back in same page.
		dojo.destroy(form.errorViewName);
		wc.service.invoke("AjaxRESTUserRegistrationAdminAdd", params);
	};

	this.setUserInSession = function(userId, selectedUser,landingURL){
		var renderContext = wc.render.getContextById('registeredCustomersSearchResultsContext');
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
		wc.service.invoke("AjaxRunAsUserSetInSession", params);
	};

	this.onUserSetInSession = function(){
		var renderContext = wc.render.getContextById('registeredCustomersSearchResultsContext');
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

	
	this.enableDisableUserAccount = function(userId, status){
		//Save it in context
		var context = wc.render.getContextById("UserRegistrationAdminUpdateStatusContext");
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
		wc.service.invoke("AjaxRESTUserRegistrationAdminUpdateStatus", {'userId' : userId, 'userStatus':status});
	};

	this.onEnableDisableUserStatusAccount = function(serviceResponse){
		var message = storeNLS["CUSTOMER_ACCOUNT_ENABLE_SUCCESS"];
		if(serviceResponse.userStatus == '0'){
			message = storeNLS["CUSTOMER_ACCOUNT_DISABLE_SUCCESS"];
		}
		MessageHelper.displayStatusMessage(message);
		onBehalfUtilitiesJS.updateUIAndRenderContext(serviceResponse,"UserRegistrationAdminUpdateStatusContext");

	};
};
	
});


dojo.addOnLoad(function(){
	registeredCustomersJS = new RegisteredCustomers();
	registeredCustomersJS.setUpEvents();
});


/**
 * Declares a new render context for registered customers list - To display registered customers based on search criteria.
 */
wc.render.declareContext("registeredCustomersSearchResultsContext",{'searchInitializedForCustomers':'false', 'isPaginatedResults':'false'},"");

/** 
 * Declares a new refresh controller for the Registered Customers List
 */
wc.render.declareRefreshController({
	   id: "registeredCustomersController",
	   renderContext: wc.render.getContextById("registeredCustomersSearchResultsContext"),
	   url: "",
	   baseURL:getAbsoluteURL()+'RegisteredCustomersListView',
	   formId: ""
	   
	   ,modelChangedHandler: function(message, widget) {
			 console.debug("modelChangedHandler of registeredCustomersController",widget);
	   }

	   ,renderContextChangedHandler: function(message, widget) {
			var controller = this;
			controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
			var renderContext = this.renderContext;
			widget.setInnerHTML("");
			console.debug(renderContext.properties);
			widget.refresh(renderContext.properties);
	   }       	   

	   ,postRefreshHandler: function(widget) {
			registeredCustomersJS.handleErrorScenario();
			console.debug("Post refresh handler of registeredCustomersController",widget);
			cursor_clear();
	   }
});



// Declare context and service for updating the status of user.
wc.render.declareContext("UserRegistrationAdminUpdateStatusContext",{},"");
wc.service.declare({
	id: "AjaxRESTUserRegistrationAdminUpdateStatus",
	actionId: "AjaxRESTUserRegistrationAdminUpdateStatus",
	url: getAbsoluteURL() +  "AjaxRESTUserRegistrationAdminUpdate",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		registeredCustomersJS.onEnableDisableUserStatusAccount(serviceResponse);
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
	id: "AjaxRunAsUserSetInSession",
	actionId: "AjaxRunAsUserSetInSession",
	url: getAbsoluteURL() + "AjaxRunAsUserSetInSession",
	formId: ""
	
	/**
	 * Clear messages on the page.
	 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(storeNLS["CSR_SUCCESS_CUSTOMER_ACCOUNT_ACCESS"]);
		registeredCustomersJS.onUserSetInSession();
		setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display shoppers cart details...
		var landingURL = wc.render.getContextById('registeredCustomersSearchResultsContext').properties["landingURL"];
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

// Service to Create Guest User and create on-behalf session
wc.service.declare({
	id: "AjaxRESTCreateGuestUser",
	actionId: "AjaxRESTCreateGuestUser",
	url: getAbsoluteURL() + "AjaxRESTCreateGuestUser",
	formId: ""
	
	/**
	 * Clear messages on the page.
	 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(storeNLS["CSR_SUCCESS_NEW_GUEST_USER_CREATION"]);
		var guestUserName = storeNLS["GUEST"];
		// Set this new guest user in session. Start on-behalf session for guest user.
		registeredCustomersJS.setUserInSession(serviceResponse.userId, guestUserName);
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


//Declare context for user registration admin add
wc.render.declareContext("UserRegistrationAdminAddContext",{'administratorPassword':'', 'userId':''},"");

// Service to register new user and start on-behalf user session.
wc.service.declare({
	id: "AjaxRESTUserRegistrationAdminAdd",
	actionId: "AjaxRESTUserRegistrationAdminAdd",
	url: getAbsoluteURL() + "AjaxRESTUserRegistrationAdminAdd",
	formId: "Register"
	
	/**
	 * Clear messages on the page.
	 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
	 */
	,successHandler: function(serviceResponse) {

		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(storeNLS["CSR_SUCCESS_NEW_REGISTERED_USER_CREATION"]);
		registeredCustomersJS.setUserInSession(serviceResponse.userId, serviceResponse.firstName+ ' ' + serviceResponse.lastName);
		cursor_clear();
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