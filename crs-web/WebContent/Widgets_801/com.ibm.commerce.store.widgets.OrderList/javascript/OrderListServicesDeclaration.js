//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript contains declarations of AJAX services used within
 * WebSphere Commerce.
 */

/**
 * @class This class stores common parameters needed to make the service call.
 */
OrderListServicesDeclarationJS = {
    /* The common parameters used in service calls */
    langId: "-1",
    storeId: "",
    catalogId: "",

    /**
     * This function initializes common parameters used in all service calls.
     * @param {int} langId The language id to use.
     * @param {int} storeId The store id to use.
     * @param {int} catalogId The catalog id to use.
     */
    setCommonParameters:function(langId,storeId,catalogId){
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
    }
}

/**
 *  This service enables customer to Reorder an already existing order.
 *  @constructor
 */
wcService.declare({
    id: "OrderCopy",
    actionId: "OrderCopy",
    url: "AjaxRESTOrderCopy",
    formId: ""

    /**
     *  Copies all the items from the existing order to the shopping cart and redirects to the shopping cart page.
     *  @param (object) serviceResponse The service response object, which is the
     *  JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        for (var prop in serviceResponse) {
            console.debug(prop + "=" + serviceResponse[prop]);
        }
        if (serviceResponse.newOrderItemsCount != null && serviceResponse.newOrderItemsCount <= 0){
            MessageHelper.displayErrorMessage(MessageHelper.messages["CANNOT_REORDER_ANY_MSG"]);
        }
        else {
            setDeleteCartCookie();

            var postRefreshHandlerParameters = [];
            var initialURL = "AjaxRESTOrderPrepare";
            var urlRequestParams = [];
            urlRequestParams["orderId"] = serviceResponse.orderId;
            urlRequestParams["storeId"] = OrderListServicesDeclarationJS.storeId;

            postRefreshHandlerParameters.push({"URL":"AjaxCheckoutDisplayView","requestType":"GET", "requestParams":{}}); 
            var service = getCustomServiceForURLChaining(initialURL,postRefreshHandlerParameters,null);
            wcService.invoke(service.getParam("id"), urlRequestParams);
        }
    }

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey === "_ERR_PROD_NOT_ORDERABLE") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
        } else if (serviceResponse.errorMessageKey === "_ERR_INVALID_ADDR") {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        }else {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            }
            else {
                    if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
            }
        }
        cursor_clear();
    }
}),

/**
 *  This service enables customer to Reorder an already existing order in external system.
 *  @constructor
 */
wcService.declare({
    id: "SSFSOrderCopy",
    actionId: "SSFSOrderCopy",
    url: "AjaxSSFSOrderCopy",
    formId: ""

        /**
         *  Copies all the items from the existing order to the shopping cart and redirects to the shopping cart page.
        *  @param (object) serviceResponse The service response object, which is the
        *  JSON object returned by the service invocation.
        */
    ,successHandler: function(serviceResponse) {
        for (var prop in serviceResponse) {
            console.debug(prop + "=" + serviceResponse[prop]);
        }

        setDeleteCartCookie();
        document.location.href=appendWcCommonRequestParameters("AjaxCheckoutDisplayView?langId="+OrderListServicesDeclarationJS.langId+"&storeId="+OrderListServicesDeclarationJS.storeId+"&catalogId="+OrderListServicesDeclarationJS.catalogId);
    }

    /**
    * display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey === "_ERR_PROD_NOT_ORDERABLE") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
        } else if (serviceResponse.errorMessageKey === "_ERR_INVALID_ADDR") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["INVALID_CONTRACT"]);
        }else {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            }
            else {
                    if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
            }
        }
        cursor_clear();
    }
}),

/**
 * This service cancels a subscription.
 * @constructor
 */
wcService.declare({
    id: "AjaxCancelSubscription",
    actionId: "AjaxCancelSubscription",
    url: "AjaxRESTRecurringOrSubscriptionCancel",
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        closeAllDialogs();
        if(serviceResponse.subscriptionType == "RecurringOrder"){
            if(serviceResponse.state == "PendingCancel"){
                MessageHelper.displayStatusMessage(MessageHelper.messages["SCHEDULE_ORDER_PENDING_CANCEL_MSG"]);
            }
            else{
                MessageHelper.displayStatusMessage(MessageHelper.messages["SCHEDULE_ORDER_CANCEL_MSG"]);
            }
        }
        else{
            if(serviceResponse.state == "PendingCancel"){
                MessageHelper.displayStatusMessage(MessageHelper.messages["SUBSCRIPTION_PENDING_CANCEL_MSG"]);
            }
            else{
                MessageHelper.displayStatusMessage(MessageHelper.messages["SUBSCRIPTION_CANCEL_MSG"]);
            }
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
        cursor_clear();
    }
}),

/**
 *  This service enables customer to Renew a subscription.
 *  @constructor
 */
wcService.declare({
    id: "SubscriptionRenew",
    actionId: "SubscriptionRenew",
    url: "AjaxRESTOrderCopy",
    formId: ""

    /**
     *  Copies all the items from the existing subscription to the shopping cart and calls service to update requested shipping date.
    *  @param (object) serviceResponse The service response object, which is the
    *  JSON object returned by the service invocation.
    */
    ,successHandler: function(serviceResponse) {
        for (var prop in serviceResponse) {
            console.debug(prop + "=" + serviceResponse[prop]);
        }

        var params = [];

        params.storeId      = OrderListServicesDeclarationJS.storeId;
        params.catalogId    = OrderListServicesDeclarationJS.catalogId;
        params.langId       = OrderListServicesDeclarationJS.langId;
        params.orderId      = serviceResponse.orderId;
        params.calculationUsage  = "-1,-2,-3,-4,-5,-6,-7";
        params.requestedShipDate = OrderListJS.getSubscriptionDate();

        OrderListJS.subscriptionOrderId = serviceResponse.orderId;
        OrderListJS.subscriptionOrderItemId = serviceResponse.orderItemId[0];

        wcService.invoke("SetRequestedShippingDate",params);
    }

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey == "_ERR_PROD_NOT_ORDERABLE") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
        } else if (serviceResponse.errorMessageKey == "_ERR_INVALID_ADDR") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["INVALID_CONTRACT"]);
        }else {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            }
            else {
                    if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
            }
        }
        cursor_clear();
    }

}),

/**
 *  This service sets the requested shipping date for a subscription renewal.
 *  @constructor
 */
wcService.declare({
    id: "SetRequestedShippingDate",
    actionId: "SetRequestedShippingDate",
    url: "AjaxRESTOrderShipInfoUpdate",
    formId: ""
/**
 * hides all the messages and the progress bar
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,successHandler: function(serviceResponse) {
        cursor_clear();
        document.location.href=appendWcCommonRequestParameters("RESTOrderPrepare?langId="+OrderListServicesDeclarationJS.langId+"&storeId="+OrderListServicesDeclarationJS.storeId+"&catalogId="+OrderListServicesDeclarationJS.catalogId+"&orderId="+serviceResponse.orderId+"&URL=AjaxCheckoutDisplayView?langId="+OrderListServicesDeclarationJS.langId+"&storeId="+OrderListServicesDeclarationJS.storeId+"&catalogId="+OrderListServicesDeclarationJS.catalogId);
    }

    /**
 * display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey == "_ERR_ORDER_ITEM_FUTURE_SHIP_DATE_OVER_MAXOFFSET") {
            var params = [];

            params.storeId      = OrderListServicesDeclarationJS.storeId;
            params.catalogId    = OrderListServicesDeclarationJS.catalogId;
            params.langId       = OrderListServicesDeclarationJS.langId;
            params.orderId      = OrderListJS.subscriptionOrderId;
            params.orderItemId      = OrderListJS.subscriptionOrderItemId;
            params.calculationUsage  = "-1,-2,-3,-4,-5,-6,-7";
            wcService.invoke("RemoveSubscriptionItem",params);

            MessageHelper.displayStatusMessage(MessageHelper.messages["CANNOT_RENEW_NOW_MSG"]);
        }
        else{
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
    }

}),

/**
 * This service removes the subscription item from the shopping cart if renewal fails.
 * @constructor
 */
wcService.declare({
    id: "RemoveSubscriptionItem",
    actionId: "RemoveSubscriptionItem",
    url: "AjaxRESTOrderItemDelete",
    formId: ""

    /**
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        cursor_clear();
    }

        /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
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
        if(serviceResponse.errorCode){
            wcTopic.publish("OrderError",serviceResponse);
        }
        cursor_clear();
    }

})

/**
 * This service allows customer to create a new saved order
 * @constructor
 */
wcService.declare({
    id:"AjaxOrderCreate",
    actionId:"AjaxOrderCreate",
    url:"AjaxRESTOrderCreate",
    formId:""

     /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CREATE_SUCCESS"]);
        
        var firstSavedOrderId = OrderListJS.getFirstSavedOrderIdFromList();
        if (firstSavedOrderId == null) {
            OrderListJS.setNewOrderId(serviceResponse.outOrderId);
        }
    }
        
    /**
     * Display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
             if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CREATE_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        } 
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
}),

/**
 * This service deletes an existing saved order.
 * @constructor
 */
wcService.declare({
    id:"AjaxSingleOrderCancel",
    actionId:"AjaxSingleOrderCancel",
    url:"AjaxRESTOrderCancel",
    formId:""

     /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_DELETE_SUCCESS"]);

        //set the OrderListJS.currentOrderDeleted flag to true if the current order was deleted.
        var deletedOrderId = serviceResponse.orderId;
        var currentOrderId = OrderListJS.getCurrentOrderId();
        if (currentOrderId == deletedOrderId) {
            OrderListJS.setCurrentOrderDeleted(true);
        } 
    }
        
    /**
     * Display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
             if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_DELETE_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        } 
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
}),

/**
* This service allows customer to create a saved order from an existing order.
* @constructor
*/
wcService.declare({
    id:"AjaxSingleOrderCopy",
    actionId:"AjaxSingleOrderCopy",
    url:"AjaxRESTOrderCopy",
    formId:""

     /**
    * Hides all the messages and the progress bar.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,successHandler: function(serviceResponse) {
        var params = {
            storeId: OrderListJS.storeId,
            catalogId: OrderListJS.catalogId,
            langId: OrderListJS.langId,
            updatePrices: "1",
            orderId: serviceResponse.orderId,
            calculationUsageId: "-1"
        };
        wcService.invoke("AjaxSingleOrderCalculate", params);
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_COPY_SUCCESS"]);
    }
        
    /**
    * Display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
             if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_COPY_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        }
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
}),

/**
 * Perform the order calculation operations to compute the contract prices for the order items in an order.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxSingleOrderCalculate",
    actionId: "AjaxSingleOrderCalculate",
    url: "AjaxRESTOrderCalculate",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CALCULATE_SUCCESS"]);
        cursor_clear();
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,failureHandler: function(serviceResponse) {
        
        if (serviceResponse.errorMessage) {
            if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CALCULATE_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        } 
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
})

/**
 * Invokes the order unlock action.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxRESTOrderUnlockOnBehalf",
    actionId: "AjaxRESTOrderUnlockOnBehalf",
    url: "AjaxRESTOrderUnlockOnBehalf",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_UNLOCK_SUCCESS"]);
        cursor_clear();
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
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
})

/**
 * Invokes the order unlock action.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxRESTOrderLockOnBehalf",
    actionId: "AjaxRESTOrderLockOnBehalf",
    url: "AjaxRESTOrderLockOnBehalf",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_LOCK_SUCCESS"]);
        cursor_clear();
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
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
})

/**
 * Invokes the order lock take over action.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxRESTOrderLockTakeOverOnBehalf",
    actionId: "AjaxRESTOrderLockTakeOverOnBehalf",
    url: "AjaxRESTOrderLockTakeOverOnBehalf",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_LOCK_SUCCESS"]);
        cursor_clear();
        if (serviceResponse['isCurrentOrder'] !== undefined && serviceResponse['isCurrentOrder'][0] == 'true'){
            document.location.reload();
            //refresh the page to update cart
        }
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
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
})