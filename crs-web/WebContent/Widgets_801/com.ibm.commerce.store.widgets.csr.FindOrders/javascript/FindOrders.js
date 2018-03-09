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

var FindOrders = function(){

    this.searchListData = {
                            "progressBarId":"FindOrdersList_form_botton_1", "formId":"FindOrders_searchForm",
                            "searchButtonId":"FindOrdersList_form_botton_1", "clearButtonId":"FindOrdersList_form_botton_2",
                             "searchOptionLabel" : "searchOptionLabel"
                          },


     /**
        Setup events for Search and Clear Results button in Find Orders Page
    */
    this.setUpEvents = function(){

        var scope = this;
        var target = document.getElementById(this.searchListData.searchButtonId);
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


    this.clearFilter = function(){

        this.clearSearchResults();

        // Remove search criteria..
        $('#FindOrders_searchForm input[id ^= "findOrders_"]').each(function(i, inputElement){
            inputElement.value = null;
        });

        //Remove search criteria from select menu
        $('#FindOrders_searchForm select[id ^= "findOrders_"]').each(function(j, inputElement){
            var jqueryObject = $('#' + inputElement.id);
            if(jqueryObject.length){
                jqueryObject.val('');
                jqueryObject.Select("refresh_noResizeButton");
            }

            if(inputElement.id === "findOrders_Form_Input_state") {
                $("#" + inputElement.id).replaceWith('<input type="text" id="findOrders_Form_Input_state" name="state" />');
            }
        });

        //Remove input in date pickers
        $('#datepickerFrom').val("");
        $('#datepickerTo').val("");
    };

    this.doSearch = function(){
        this.clearSearchResults();

        //Do we have any search criteria to search ?
        var doSearch = false;
        $('#'+this.searchListData.formId+' input[id ^= "findOrders_"]').each(function(i, inputElement){
                 var value = inputElement.value;
                 if(value != null && value != ''){
                     doSearch = true;
                 }
             });


        if(!doSearch){
            $('#'+this.searchListData.formId+' select[id ^= "findOrders_"]').each(function(j, inputElement){
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


        var renderContextProperties = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContext');
        renderContextProperties["searchInitialized"] = "true";

        setCurrentId(this.searchListData.progressBarId);
        if(!submitRequest()){
            return;
        }

        cursor_wait();
        var params = {};
        // code level formatting can be taken care or in js. Based on server REST need, include formatting here.
        //this.formatDate();
        $("#findOrdersRefreshArea").refreshWidget("updateFormId", this.searchListData.formId);
        wcRenderContext.updateRenderContext("findOrdersSearchResultsContext", params);

    };



    this.toggleOrderSummarySection = function(orderId){
        findbyCSRJS.showHide('orderDetailsExpandedContent_'+orderId, 'collapsed', 'expanded');
        findbyCSRJS.changeDropDownArrow('dropDownArrow_'+orderId,'expanded');
        return true;
    };

    this.handleActionDropDown = function(event,memberId){
        findbyCSRJS.cancelEvent(event);
        findbyCSRJS.toggleSelection('actionDropdown','actionDropdown_'+memberId, 'findOrdersSearchResults', 'active');
        findbyCSRJS.toggleCSSClass('actionButton','actionButton7_'+memberId,'findOrdersSearchResults','actionDropdownAnchorHide','actionDropdownAnchorDisplay');
        return false;
    }

    this.clearSearchResults = function(){
        // Remove search results
        if($("#findOrdesResultList_table").length){
            $("#findOrdesResultList_table").css("display","none");
        }
    };






    this.accessOrderDetails = function(userId, selectedUser, landingURL)
    {


        var renderContextProperties = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContext');
        // First need to set user in sesison before accessing orderDetails page...

        // in case of order details display, landing URL will be different. So set that here before calling setUserInSession command.
        // in case of guest orders, landingURL will be coming null and it will pass null as well..
        if(landingURL != '' && landingURL != null){
            renderContextProperties["landingURL"] = landingURL;
        }
        // currently landingUrl is registered customers account link...if it is guest user, landing url will be differnt..
        findbyCSRJS.setUserInSession(userId,selectedUser,landingURL);

    };


    this.lockUnlockOrder = function(orderId, isLocked, takeOverLock){

        //Save it in context
        var context = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext");
        context["orderId"] = orderId;
        var takeOverLockStatus = context[orderId+"_takeOverLock"];
        if(takeOverLockStatus != null){
            //if context has already  saved data then pick up from conetxt
            takeOverLock = takeOverLockStatus;
        }

        if(takeOverLock == 'true')
        {
            //take over lock first and then call unlock order
            wcService.invoke("AjaxRESTTakeOverlock", {'orderId' : orderId, 'filterOption' : "All", 'takeOverLock' : 'Y',  'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});

        }
        else
        {
            // this is required to set value in context back when CSR decides to unlock again..
            var lockStatus = context[orderId+"_isLocked"];
            if(lockStatus != null){
                //if context has already  saved data then pick up from conetxt
                    isLocked = lockStatus;
            }
            // Invoke service : if order is already locked, call unlock cart to unlock the same else lock it
            if(isLocked=='true')
            {
                //unlock order
                wcService.invoke("AjaxRESTOrderUnlock", {'orderId' : orderId, 'filterOption' : "All", 'isLocked':isLocked, 'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});

            }else
            {
                //lock order...
                wcService.invoke("AjaxRESTOrderLock", {'orderId' : orderId, 'filterOption' : "All", 'isLocked':isLocked, 'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});

            }
        }


    };



    this.onlockUnlockOrder = function(serviceResponse){

        var message = Utils.getLocalizationMessage("SUCCESS_ORDER_LOCK");
        var lockStatusText = Utils.getLocalizationMessage('UNLOCK_CUSTOMER_ORDER_CSR');
        if(serviceResponse.isLocked[0] == 'true'){
            message = Utils.getLocalizationMessage("SUCCESS_ORDER_UNLOCK");
            lockStatusText = Utils.getLocalizationMessage('LOCK_CUSTOMER_ORDER_CSR');
        }
        MessageHelper.displayStatusMessage(message);

        var renderContext = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext"); //this should be orderlock related context
        var orderId = renderContext["orderId"];  // orderid
        var lockStatus = renderContext[orderId+"_isLocked"];

        // Update widget text...
        $("#orderLocked_"+orderId).html(lockStatusText);

        if($("#minishopcart_lock_"+orderId) != null){
            var node = $("#minishopcart_lock_"+orderId);
            if(renderContext[orderId+"_isLocked"] == "true")
            {
                 $(node).attr("class", "");
            }
            else
            {
                $(node).attr("class", "nodisplay");
            }
        }
    };

    this.displayCSROrderSummaryPage = function(orderId){
        document.location.href = "CSROrderSummaryView"+"?"+getCommonParametersQueryString()+"&orderId="+orderId;
    };
};


$(document).ready(function() {
    findOrdersJS = new FindOrders();
    findOrdersJS.setUpEvents();

});

function declareFindOrdersRefreshArea() {
    // ============================================
    // div: findOrdersRefreshArea refresh area
    // eclares a new refresh controller for the Find Orders List
    var myWidgetObj = $("#findOrdersRefreshArea");

    /**
     * Declares a new render context for find orders  result list - To display orders based on search criteria.
     */
    wcRenderContext.declare("findOrdersSearchResultsContext", ["findOrdersRefreshArea"], {'searchInitialized':'false', 'isPaginatedResults':'false'},"");

    var myRCProperties = wcRenderContext.getRenderContextProperties("findOrdersSearchResultsContext");
    var baseURL = getAbsoluteURL()+'FindOrdersResultListViewV2';

    var renderContextChangedHandler = function() {
        myWidgetObj.refreshWidget("updateUrl", baseURL +"?"+getCommonParametersQueryString());
        myWidgetObj.html("");
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    };

    var postRefreshHandler = function() {
        findbyCSRJS.handleErrorScenario();
        console.debug("Post refresh handler of findOrdersController");
        cursor_clear();
    }

    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});

};

//Declare context and service for updating the status of user.
wcRenderContext.declare("OrderLockUnlockContext",[],{});

wcService.declare({
        id: "AjaxRESTOrderLock",
        actionId: "AjaxRESTOrderLock",
        url:  getAbsoluteURL()+'AjaxRESTOrderLock',
        formId: ""


     /**
      *  This method refreshes the panel
      *  @param (object) serviceResponse The service response object, which is the
      *  JSON object returned by the service invocation.
      */
    ,successHandler: function(serviceResponse) {
        // set context of lock for this orderid as true... as it has been locked..

        var renderContext = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext"); //this should be orderlock related context
        var orderId = renderContext["orderId"];  // orderid
        renderContext[orderId+"_isLocked"] = "true";
        findOrdersJS.onlockUnlockOrder(serviceResponse);
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
wcService.declare({

    id: "AjaxRESTOrderUnlock",
    actionId: "AjaxRESTOrderUnlock",
    url:  getAbsoluteURL()+'AjaxRESTOrderUnlock',
    formId: ""


 /**
  *  This method refreshes the panel
  *  @param (object) serviceResponse The service response object, which is the
  *  JSON object returned by the service invocation.
  */
,successHandler: function(serviceResponse) {
    //var lockStatus = context.properties[orderId+"_isLocked"];
    // set context of lock for this orderid as false... as it has been unlocked..
    var renderContext = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext"); //this should be orderlock related context
    var orderId = renderContext["orderId"];  // orderid
    renderContext[orderId+"_isLocked"] = "false";

    findOrdersJS.onlockUnlockOrder(serviceResponse);
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

wcService.declare({

    id: "AjaxRESTTakeOverlock",
    actionId: "AjaxRESTTakeOverlock",
    url:  getAbsoluteURL()+'/AjaxRESTTakeOverlock',
    formId: ""


 /**
  *  This method refreshes the panel
  *  @param (object) serviceResponse The service response object, which is the
  *  JSON object returned by the service invocation.
  */
,successHandler: function(serviceResponse) {
    //findOrdersJS.onlockUnlockOrder(serviceResponse);
    //after successfully taking over lock, it should call unlock
    var context = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext");
    var orderId = context["orderId"];
    context[orderId+"_takeOverLock"] = "false";
    findOrdersJS.lockUnlockOrder(orderId, 'true', 'false');
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
