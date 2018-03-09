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

var FindByCSRUtilities = function(){


    this.showHide = function(nodeId, hiddenClassName, activeClassName){
        $('#'+nodeId).toggleClass(hiddenClassName);
        $('#'+nodeId).toggleClass(activeClassName);
    };

    this.changeDropDownArrow = function(nodeId, arrowClass){
        $('#'+nodeId).toggleClass(arrowClass);
    };


    this.toggleSelection = function(nodeCSS,nodeId,parentNode,cssClassName){
        // Get list of all active nodes with cssClass = nodeCSS under parentNode.
        var activeNodes = $('.'+cssClassName, "#"+parentNode);

        // Toggle the css class for the node with id = nodeId
        $('#'+nodeId,  "#"+parentNode).toggleClass(cssClassName);

        // Remove the css class for all the active nodes.
        activeNodes.removeClass(cssClassName);
    };

    this.handleErrorScenario = function(){
        var errorMessageObj = $("#errorMessageFindOrders");
        var errorSectionObj = $("#errorMessage_sectionFindOrders");
        if(errorMessageObj.length){
            var errorMessage = errorMessageObj.val();

            if(errorMessage != null && errorMessage != undefined && errorSectionObj != null){
                 $(errorSectionObj).css('display', 'block');
                 $(errorSectionObj).css('color', '#CA4200');
                 // TODO - set focus to error div..for accessibility...
                 $(errorSectionObj).text(errorMessage);
            }
        } else {

             $(errorSectionObj).css('display', 'none');
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
        $('.'+nodeCSS, "#"+parentNode).removeClass(cssClassName);
    };

    this.resetActionButtonStyle = function(nodeCSS,parentNode,hiddenClassName,activeClassName){
        $('.'+nodeCSS, "#"+parentNode).addClass(hiddenClassName);
        $('.'+nodeCSS, "#"+parentNode).removeClass(activeClassName);
    };

    this.toggleCSSClass = function(nodeCSS,nodeId,parentNode,hiddenClassName,activeClassName){
        // Get the list of current nodes
        var activeNodes = $('.'+activeClassName, "#"+parentNode);

        // For the clicked node, toggle the CSS Class. If hidden then display / If displayed then hide.
        $('#'+nodeId, "#"+parentNode).toggleClass(hiddenClassName);
        $('#'+nodeId, "#"+parentNode).toggleClass(activeClassName);

        // For all activeNodes, remove the activeCSS and add the hiddenCSS
        activeNodes.removeClass(activeClassName);
        activeNodes.addClass(hiddenClassName);
    };


    this.setUserInSession = function(userId, selectedUser,landingURL){

        var renderContext = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContextCSR');
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
        wcService.invoke("AjaxRunAsUserSetInSessionCSR", params);
    };

    this.onUserSetInSession = function(){
        var renderContext = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContextCSR');
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



    this.enableDisableUserAccount = function(userId, status,logonId){

        //Save it in context
        var context = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContextCSR");
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
        wcService.invoke("AjaxRESTUserRegistrationAdminUpdateStatusCSR", {'userId' : userId, 'userStatus':status, 'logonId' : logonId});
    };

    this.onEnableDisableUserStatusAccount = function(serviceResponse){
        var message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_ENABLE_SUCCESS");
        if(serviceResponse.userStatus == '0'){
            message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_DISABLE_SUCCESS");
        }
        MessageHelper.displayStatusMessage(message);
        onBehalfUtilitiesJS.updateUIAndRenderContext(serviceResponse,"UserRegistrationAdminUpdateStatusContextCSR");
    };



};


$(document).ready(function() {
    findbyCSRJS = new FindByCSRUtilities();

});


/**
 * Declares a new render context for find orders  result list - To display orders based on search criteria.
 */
wcRenderContext.declare("findOrdersSearchResultsContextCSR",[],{'isPaginatedResults':'false'});


//Declare context and service for updating the status of user.
wcRenderContext.declare("UserRegistrationAdminUpdateStatusContextCSR",[],{});
wcService.declare({
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
wcService.declare({
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
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_CUSTOMER_ACCOUNT_ACCESS"));

        findbyCSRJS.onUserSetInSession();
        setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display shoppers cart details...
        var landingURL = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContextCSR')["landingURL"];
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


