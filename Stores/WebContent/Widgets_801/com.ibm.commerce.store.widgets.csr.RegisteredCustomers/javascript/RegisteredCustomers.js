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


var RegisteredCustomers = function(){


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
        var target = $("#" +this.searchListData.searchButtonId);
        if(target != null) {
            $(target).on("click",function(event){
                scope.doSearch();
            });
        }

        target = $("#" +this.searchListData.clearButtonId);
        if(target != null) {
            $(target).on("click",function(event){
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

        $('#RegisteredCustomersSearch_searchForm input[id ^= "RegisteredCustomersSearch_"]').each(function(j, inputElement){
            inputElement.value = null;
        });

        // Remove search criteria in select menu
        $('#RegisteredCustomersSearch_searchForm select[id ^= "RegisteredCustomersSearch_"]').each(function(j, inputElement){
            var jqueryObject = $("#" + inputElement.id);
            if(jqueryObject != null){
                jqueryObject.val('');
                jqueryObject.Select("refresh_noResizeButton");
            }

            if(inputElement.id === "RegisteredCustomersSearch_Form_Input_state") {
                $("#" + inputElement.id).replaceWith('<input type="text" id="RegisteredCustomersSearch_Form_Input_state" name="state" />');
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
        $('#'+ this.searchListData.formId+' input[id ^= "RegisteredCustomersSearch_"]').each(function(i, inputElement){
                 var value = inputElement.value;
                 if(value != null && value != ''){
                     doSearch = true;
                 }
             });


        // Do we have some criteria in drop down boxes - State / Country ?
        if(!doSearch){
            $('#'+this.searchListData.formId+' select[id ^= "RegisteredCustomersSearch_"]').each(function(j, inputElement){
                    var jqueryObject = $('#' + inputElement.id);
                    var value = jqueryObject.val();
                    if(value != '' ){
                        doSearch = true;
                    }
                 });
        }


        if(!doSearch) {
        	MessageHelper.formErrorHandleClient(this.searchListData.searchButtonId, Utils.getLocalizationMessage("CSR_NO_SEARCH_CRITERIA"));
        	return false;
        }

        wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext')["searchInitializedForCustomers"] = "true";

        setCurrentId(this.searchListData.progressBarId);
        if(!submitRequest()){
            return;
        }

        cursor_wait();
        var params = {};
        $("#registeredCustomersRefreshArea").refreshWidget("updateFormId", this.searchListData.formId);
        wcRenderContext.updateRenderContext("registeredCustomersSearchResultsContext", params);
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
        $('#'+nodeId).toggleClass(hiddenClassName);
        $('#'+nodeId).toggleClass(activeClassName);
    };

    this.changeDropDownArrow = function(nodeId, arrowClass){
        $('#'+nodeId).toggleClass(arrowClass);
    };

    this.clearSearchResults = function(){
        // Remove search results
        if($("#registeredCustomersList_table") != null){
            $("#registeredCustomersList_table").css("display","none");
        }
    };

    this.toggleSelection = function(nodeCSS,nodeId,parentNode,cssClassName){
        // Get list of all active nodes with cssClass = nodeCSS under parentNode.
        var activeNodes = $('.'+cssClassName, "#"+parentNode);

        // Toggle the css class for the node with id = nodeId
        $('#'+nodeId, "#"+parentNode).toggleClass(cssClassName);

        // Remove the css class for all the active nodes.

        activeNodes.removeClass(cssClassName);
    };

    this.resetPasswordByAdminOnBehalfForBuyers = function(userId){
        wcService.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer", {'logonId':userId, 'URL':"test"});
    };

    this.resetPasswordByAdminOnBehalf = function(userId){
        if(this.csrPasswordEnabled) {
            //  Use this when CSR password is mandatory to reset customer password.
            var administratorPassword = $("#" +this.csrResetPasswordIds.administratorPasswordId).val();
            if(administratorPassword == null || administratorPassword == ''){
                var error = Utils.getLocalizationMessage('CSR_PASSWORD_EMPTY_MESSAGE');
                this.onResetPasswordByAdminError(error);
                return false;
            }
            wcService.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalf", {'administratorPassword': administratorPassword,'logonId':userId, 'URL':"test"});
        } else {
            wcService.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalf", {'logonId':userId,'URL':"test"});
        }
    };

    this.resetPasswordByAdmin = function(userId,administratorPassword){
        wcService.invoke("AjaxRESTMemberPasswordResetByAdmin", {'administratorPassword' : administratorPassword, 'logonId':userId, 'URL':"test"});
    };

    this.handleCSRPasswordReset = function(event){
        this.cancelEvent(event);

        if(this.csrPasswordEnabled) {
            $("#" +this.csrResetPasswordIds.administratorPasswordId).val('');
        }
        // Change the styling of the ResetPassword button
        $('#'+this.csrResetPasswordIds.resetPasswordButtonId ,'#'+this.csrResetPasswordIds.parentNodeId).toggleClass('clicked');

        // Toggle the css class for the dropDown panel with id = nodeId
        $('#'+this.csrResetPasswordIds.resetPasswordDropDownPanelId, '#'+this.csrResetPasswordIds.parentNodeId).toggleClass('active');

        // Hide error div.
        $('#'+this.csrResetPasswordIds.errorDivId, '#'+this.csrResetPasswordIds.parentNodeId).addClass('hidden');

        return false;
    }

    this.hideErrorDiv = function(){
        // Hide error div.
        $('#'+this.csrResetPasswordIds.errorDivId, '#'+ this.csrResetPasswordIds.parentNodeId).addClass('hidden');
    }

    this.onResetPasswordByAdminError = function(errorMessage, errorResponse){
        $("#" +this.csrResetPasswordIds.errorMessageId).html(errorMessage);
        // Display error div.
        $('#'+ this.csrResetPasswordIds.errorDivId, '#'+this.csrResetPasswordIds.parentNodeId).removeClass('hidden');
        // focus to error div.
        $("#" +this.csrResetPasswordIds.errorMessageId).focus();
    }

    this.onResetPasswordByAdminSuccess = function(){
        // Change the styling of the ResetPassword button
        $('#'+this.csrResetPasswordIds.resetPasswordButtonId, '#'+ this.csrResetPasswordIds.parentNodeId).toggleClass('clicked');

        // Toggle the css class for the dropDown panel with id = nodeId
        $('#'+this.csrResetPasswordIds.resetPasswordDropDownPanelId, '#'+ this.csrResetPasswordIds.parentNodeId).toggleClass('active');
        return false;
    }

    this.handleErrorScenario = function(){
            var errorMessageObj = $("#errorMessage");
        var errorSectionObj = $("#errorMessage_section");
        if(errorMessageObj.length){
            var errorMessage = errorMessageObj[0].value;
            if(errorMessage != null && errorMessage.length != "" && errorSectionObj != null){
                 $('#errorMessage_section').css( 'display', 'block');
                 // TODO - set focus to error div..for accessibility...
                 $('#errorMessage_section').text(errorMessage);

            }
        } else {
            $('#errorMessage_section').css( 'display', 'none');
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
        $('.'+nodeCSS, "#"+ parentNode).removeClass(cssClassName);
    };

    this.resetActionButtonStyle = function(nodeCSS,parentNode,hiddenClassName,activeClassName){
        $('.'+nodeCSS, "#"+parentNode).addClass(hiddenClassName);
        $('.'+nodeCSS, "#"+parentNode).removeClass(activeClassName);
    };

    this.toggleCSSClass = function(nodeCSS,nodeId,parentNode,hiddenClassName,activeClassName){
        // Get the list of current nodes
        var activeNodes = $('.'+activeClassName, "#"+parentNode);

        // For the clicked node, toggle the CSS Class. If hidden then display / If displayed then hide.
        $('#'+nodeId,"#"+ parentNode).toggleClass(hiddenClassName);
        $('#'+nodeId,"#"+ parentNode).toggleClass(activeClassName);

        // For all activeNodes, remove the activeCSS and add the hiddenCSS
        activeNodes.removeClass(activeClassName);
        activeNodes.addClass(hiddenClassName);
    };

    this.createGuestUser = function(landingURL){
        var renderContext = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext');
        if((landingURL == null || landingURL == '') && !stringStartsWith(document.location.href, "https")){
            renderContext["landingURL"] = '';
        } else {
            // Reload home page
            landingURL = WCParamJS.homePageURL;
            renderContext["landingURL"] = landingURL;
        }

        var params = [];
        wcService.invoke("AjaxRESTCreateGuestUser", params);
    };

    this.createRegisteredUser = function(landingURL){
        if(landingURL != null) {
           wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext')["landingURL"] = landingURL;
        }

        var params = [];
        var form = $("#Register");
        if(form.guestUserId != null && form.guestUserId.value != null){
            // Guest user id exists. Use it while registering new user.
            params.userId = form.guestUserId.value;
        }
        // Do not set errorViewName, since we are making Ajax call. Handle the response back in same page.
        $(form.errorViewName).remove();
        wcService.invoke("AjaxRESTUserRegistrationAdminAdd", params);
    };

    this.setUserInSession = function(userId, selectedUser,landingURL){
        var renderContext = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext');
        if(selectedUser != '' && selectedUser != null) {
            renderContext["selectedUser"] = escapeXml(selectedUser, true);
        }
        if(landingURL != '' && landingURL != null){
            renderContext["landingURL"] = landingURL;
        }
        // If we are setting a forUser in session here, it has to be CSR role. Save this info in context.
        // Once user is successfully set, we will set this info in cookie.
        renderContext["WC_OnBehalf_Role_"] = "CSR";

        var params = [];
        params.runAsUserId = userId;
        params.storeId = WCParamJS.storeId;
        wcService.invoke("AjaxRunAsUserSetInSession", params);
    };

    this.onUserSetInSession = function(){
        var renderContext = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext');
        var selectedUser = renderContext["selectedUser"];
        if(selectedUser != '' && selectedUser != null){
            //write the cookie.
            setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, escapeXml(selectedUser, true), {path:'/', domain:cookieDomain});
        }
        var onBehalfRole = renderContext["WC_OnBehalf_Role_"];
        if(onBehalfRole != '' && onBehalfRole != null){
            //write the cookie.
            setCookie("WC_OnBehalf_Role_"+WCParamJS.storeId, onBehalfRole, {path:'/', domain:cookieDomain});
        }
    };


    this.enableDisableUserAccount = function(userId, status){
        //Save it in context
	var context = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContext");
        context["userId"] = userId;

        // If userStatus is already available in context, then use it.
        // This means, the status is updated by making an Ajax call after the page is loaded and status is updated.
	var updatedStatus = context[userId+"_updatedStatus"];
        if(updatedStatus != null){
            if(updatedStatus == '0'){
                status = '1';
            } else {
                status = '0';
            }
        }
	context[userId+"_userStatus"] = status;

        // Invoke service
        wcService.invoke("AjaxRESTUserRegistrationAdminUpdateStatus", {'userId' : userId, 'userStatus':status});
    };

    this.onEnableDisableUserStatusAccount = function(serviceResponse){
        var message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_ENABLE_SUCCESS");
        if(serviceResponse.userStatus == '0'){
            message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_DISABLE_SUCCESS");
        }
        MessageHelper.displayStatusMessage(message);
        onBehalfUtilitiesJS.updateUIAndRenderContext(serviceResponse,"UserRegistrationAdminUpdateStatusContext");

    };

};

$(document).ready(function() {
    registeredCustomersJS = new RegisteredCustomers();
    registeredCustomersJS.setUpEvents();
});

    /**
     * Declares a new render context for registered customers list - To display registered customers based on search criteria.
     */
     if (!wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContext")) {
    wcRenderContext.declare("registeredCustomersSearchResultsContext", ["registeredCustomersRefreshArea"], {'searchInitializedForCustomers':'false', 'isPaginatedResults':'false'},"");
}
function declareRegisteredCustomersRefreshArea() {
    // ============================================
    // div: registeredCustomersRefreshArea refresh area
    // Declares a new refresh controller for the Registered Customers List
    var myWidgetObj = $("#registeredCustomersRefreshArea");

    var myRCProperties = wcRenderContext.getRenderContextProperties("registeredCustomersSearchResultsContext"),
    baseURL = getAbsoluteURL()+'RegisteredCustomersListViewV2',
    renderContextChangedHandler = function() {
	myWidgetObj.refreshWidget("updateUrl", baseURL +"?"+getCommonParametersQueryString());
        $("#registeredCustomersRefreshArea").html("");
        console.debug(myRCProperties);
        $("#registeredCustomersRefreshArea").refreshWidget("refresh", myRCProperties)
    },

    postRefreshHandler = function() {
        registeredCustomersJS.handleErrorScenario();
        console.debug("Post refresh handler of registeredCustomersController");
        cursor_clear();
    };

    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
}

// Declare context and service for updating the status of user.
 if (!wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContext")) {
wcRenderContext.declare("UserRegistrationAdminUpdateStatusContext", [], {});
}
wcService.declare({
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
wcService.declare({
    id: "AjaxRunAsUserSetInSession",
    actionId: "AjaxRunAsUserSetInSession",
    url: getAbsoluteURL() + "AjaxRunAsUserSetInSession",
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
		if(typeof callCenterIntegrationJS != 'undefined' && callCenterIntegrationJS != undefined && callCenterIntegrationJS != null){
			var params = {};
			params.status = "success";
			params.serviceResponse = serviceResponse;
			callCenterIntegrationJS.postActionMessage(params, "START_ON_BEHALF_SESSION_RESPONSE");	
		}
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_CUSTOMER_ACCOUNT_ACCESS"));
        registeredCustomersJS.onUserSetInSession();
        setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display shoppers cart details...
        var landingURL = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext')["landingURL"];
        if(landingURL != "-1"){
			window.location.href = landingURL; // if landingURL is null, it reloads same page. so don't check for != ''
		}

    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
		if(typeof callCenterIntegrationJS != 'undefined' && callCenterIntegrationJS != undefined && callCenterIntegrationJS != null){
			var params = {};
			params.status = "error";
			params.serviceResponse = serviceResponse;
			callCenterIntegrationJS.postActionMessage(params, "START_ON_BEHALF_SESSION_RESPONSE");	
		}
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
wcService.declare({
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
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_NEW_GUEST_USER_CREATION"));
        var guestUserName = Utils.getLocalizationMessage("GUEST");
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
//wcRenderContext.declare("UserRegistrationAdminAddContext", [], {'administratorPassword':'', 'userId':''});

// Service to register new user and start on-behalf user session.
wcService.declare({
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
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_NEW_REGISTERED_USER_CREATION"));
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