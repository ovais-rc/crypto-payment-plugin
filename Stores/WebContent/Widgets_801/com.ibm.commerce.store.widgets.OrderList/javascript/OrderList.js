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
 * @fileOverview This file provides all the functions and variables to manage order lists and the items within.
 * This file is included in all pages with order list actions.
 */

/**
 * This class defines the functions and variables that customers can use to re-order processed orders.
 * @class The OrderListJS class defines the functions and variables that customers can use to manage their previous orders.
 */
OrderListJS = {
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

    /** This variable stores the ID of the newly created saved order. Its default value is empty. **/
    newOrderId : "",

    /** A boolean used to indicate if the current saved order was just deleted. Its default value is false. **/
    currentOrderDeleted : false,

    /** 
     * This array stores the quantities of each product in the order. Its default value is empty.
     * @private
     */
    quantityList: {},

    /** 
     * A boolean used to indicate if the current order list is saved order list. Its default value is false.
     * @private
     */
    savedOrder: false,

    /**
     * This variable stores the current dropdown dialog element.
     * @private
     */
    dropDownDlg: null,

    /**
     * This variable stores the expiry date of a subscription. For renewal, the start date is expiry date plus one day.
     */
    subscriptionDate: "",

    /**
     * This variable stores the orderId for subscription renewal
     */
    subscriptionOrderId: "",

    /**
     * This variable stores the orderItemId for subscription renewal
     */
    subscriptionOrderItemId: "",

    /**
     * Sets the common parameters for the current page. 
     * For example, the language ID, store ID, catalog ID, and whether it's saved order list.
     *
     * @param {Integer} langId The ID of the language that the store currently uses.
     * @param {Integer} storeId The ID of the current store.
     * @param {Integer} catalogId The ID of the catalog.
     * @param {Boolean} savedOrder The indicator of saved order list.
     */
    setCommonParameters:function(langId,storeId,catalogId,savedOrder){
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        this.savedOrder = savedOrder;
        cursor_clear();
    },

    /**
     * return a boolean value which indicates whether this is a saved order list
     */
    isSavedOrder: function () {
        return this.savedOrder;
    },

    /**
     * Initialize the URL of Saved Order List widget controller.
     *
     * @param {object} widgetUrl The controller's URL.
     */
    initOrderListUrl:function(widgetPrefix, widgetUrl){
        $("#" + widgetPrefix + "OrderListTable_Widget").refreshWidget("updateUrl", widgetUrl);
    },

    /**
     * set the subscriptionDate variable
     * @param {string} The expiry date of the subscription to be renewed.
     */
    setSubscriptionDate: function (value) {
        this.subscriptionDate = value;
    },

    /**
     * return a string which indicates the start date of the renewed subscription. The start date is one day plus the end date of that subscription.
     */
    getSubscriptionDate: function () {
        var year = parseInt(this.subscriptionDate.substring(0,4),10);
        var month = parseInt(this.subscriptionDate.substring(5,7),10);
        var date = parseInt(this.subscriptionDate.substring(8,10),10);

        if(month == 2){
            if((year % 4 == 0) && (year % 100 != 0) && (year % 400 == 0))
            {
                if(date != 29)
                {
                    date = date + 1;
                    if(date < 10)
                        date = "0" + date;
                    month = "02";
                }
                else
                {
                    date = "01";
                    month = "03";
                }
            }
            else
            {
                if(date != 28)
                {
                    date = date + 1;
                    if(date < 10)
                        date = "0" + date;
                    month = "02";
                }
                else
                {
                    date = "01";
                    month = "03";
                }
            }
        }
        else if(month == 12){
            if(date != 31)
            {
                date = date + 1;
                if(date < 10)
                    date = "0" + date;
                month = "12";
            }
            else
            {
                date = "01";
                month = "01";
                year = year + 1;
            }
        }
        else if(month == 4 || month == 6 || month == 9 || month == 11){
            if(date != 30)
            {
                date = date + 1;
                if(date < 10)
                    date = "0" + date;
            }
            else
            {
                date = "01";
                month = month + 1;
            }
            if(month < 10)
                month = "0" + month;
        }
        else{
            if(date != 31)
            {
                date = date + 1;
                if(date < 10)
                    date = "0" + date;
            }
            else
            {
                date = "01";
                month = month + 1;
            }
            if(month < 10)
                month = "0" + month;
        }

        var start = this.subscriptionDate.indexOf("T",0);
        var end = this.subscriptionDate.indexOf("Z",start);
        var appendString= this.subscriptionDate.substring(start+1,end);
        var newDateString = year+'-'+month+'-'+date+'T'+appendString+'Z';
        return(newDateString);
    },

    /**
     * This function sets the url for subscriptionrenew service and then it invokes the service to renew the subscription.
     * @param {string} SubscriptionCopyURL The url for the subscription copy service.
     */
    prepareSubscriptionRenew:function(SubscriptionCopyURL){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.getServiceById("SubscriptionRenew").setUrl(SubscriptionCopyURL);
        wcService.invoke("SubscriptionRenew");
    },

    /**
     * This function sets the url for ordercopy service and then it invokes the service to copy the old order.
     * @param {string} OrderCopyURL The url for the order copy service.
     */
    prepareOrderCopy:function(OrderCopyURL){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.getServiceById("OrderCopy").setUrl(OrderCopyURL);
        wcService.invoke("OrderCopy");
    },

    /**
     * This function sets the url for ssfs order copy service and then it invokes the service to copy the old order.
     * @param {string} SSFSOrderCopyUrl The url for the ssfs order copy service.
     */
    prepareSSFSOrderCopy:function(SSFSOrderCopyUrl){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.getServiceById("SSFSOrderCopy").setUrl(SSFSOrderCopyUrl);
        wcService.invoke("SSFSOrderCopy");
    },

    /**
     * get the last order record info in render context
     * @param {Integer} The current page number.
     * @param {string} The last order external id in current page.
     * @param {string} The last order record info in render context.
     * @param {boolean} value either true or false. True if it's for next page. False otherwise.
     */
    getLastRecordInfo: function (currentPage, lastExtOrderId, lastRecordInfoInContext, nextOrNot) {
        var lastRecordArray = lastRecordInfoInContext.split(";");
        var refinedRecordInfoIncontext;

        if(!nextOrNot){
            //previous page
            if(lastRecordInfoInContext != '' && lastRecordInfoInContext != undefined){
                if(lastRecordInfoInContext.lastIndexOf(";")>-1){
                    refinedRecordInfoIncontext = lastRecordInfoInContext.substring(0, lastRecordInfoInContext.lastIndexOf(";"));
                }else{
                    refinedRecordInfoIncontext = "";
                }
            }
        }else{
            //next page
            if(currentPage==1 || currentPage==''|| currentPage == undefined){
                //first page
                if(lastExtOrderId !='' && lastExtOrderId!=undefined){
                    refinedRecordInfoIncontext = lastExtOrderId;
                }else{
                    refinedRecordInfoIncontext = " ";
                }
            }else{
                if(lastRecordInfoInContext != '' && lastRecordInfoInContext != undefined){
                    if(lastExtOrderId !='' && lastExtOrderId!=undefined){
                        refinedRecordInfoIncontext = lastRecordInfoInContext.concat(";").concat(lastExtOrderId);
                    }else{
                        refinedRecordInfoIncontext = lastRecordInfoInContext.concat(";").concat(" ");
                    }
                }
            }
        }

        return refinedRecordInfoIncontext;
    },

    /**
     * Displays the actions list drop down panel.
     * @param {object} event The event to retrieve the input keyboard key.
     * @param {string} dialogId The id of the content pane containing the action popup details
     */
    showActionsPopup: function(event, dialogId){
        if(event == null || event.keyCode === KeyCodes.DOWN_ARROW){
            var dialog = $("#" + dialogId).data("wc-WCDialog");
            if(dialog) {
                this.dropDownDlg = dialog;
                this.dropDownDlg.open();
            }
        }
    },

    /**
     *This function displays the Recurring Order / Subscription action popup.
     *@param {String} action This variable can be either recurring_order or subscription.
     *@param {String} subscriptionId This variable gives the subscription id to be canceled.
     *@param {String} popupIndex the index of the action popup (required to close it later)
     *@param {String} message This variable gives the message regarding cancel notice period.
     */
    showPopup:function(action, subscriptionId, popupIndex, message){
        var popup = $("#Cancel_"+action+"_popup").data("wc-WCDialog");
        if (popup !=null) {
            closeAllDialogs(); //close other dialogs(quickinfo dialog, etc) before opening this.
            popup.element.attr("data-popupIndex", popupIndex);
            popup.open();
            document.getElementById("Cancel_yes_"+action).setAttribute("onclick", "OrderListJS.cancelRecurringOrder("+ subscriptionId + "," + popupIndex + ");");

            if(document.getElementById("cancel_notice_"+action) && document.getElementById(message)){
                $("#cancel_notice_"+action).html($("#" + message).val());
            }
        }else {
            console.debug("Cancel_subscription_popup"+" does not exist");
        }
    },

    /**
     * This function cancels a recurring order.
     * @param {String} subscriptionId The unique ID of the subscription to cancel.
     * @param {int} popupIndex the index of the action drop down
     */
    cancelRecurringOrder:function(subscriptionId, popupIndex){
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();

        var params = {
            subscriptionId: subscriptionId,
            URL: "",
            storeId: OrderListServicesDeclarationJS.storeId,
            catalogId: OrderListServicesDeclarationJS.catalogId,
            langId: OrderListServicesDeclarationJS.langId
        };
        wcService.invoke("AjaxCancelSubscription", params);
    },

    /**
     * Display order list for pagination
     */
    showResultsPage:function(data){
        var pageNumber = data['pageNumber'],
        pageSize = data['pageSize'];
        pageNumber = parseInt(pageNumber);
        pageSize = parseInt(pageSize);

        setCurrentId(data["linkId"]);

        if(!submitRequest()){
            return;
        }

        var beginIndex = pageSize * ( pageNumber - 1 );
        cursor_wait();
        wcRenderContext.updateRenderContext('OrderListTable_Context', {'beginIndex':beginIndex});
        MessageHelper.hideAndClearMessage();
    },

    /**
     * Creates an empty order.
     */
    createNewList:function() {
        var form_name = document.getElementById("OrderList_NewListForm_Name");
        if (form_name !=null && this.isEmpty(form_name.value)) {
            MessageHelper.formErrorHandleClient(form_name.id,MessageHelper.messages["LIST_TABLE_NAME_EMPTY"]); return false;
        }
        service = wcService.getServiceById('AjaxOrderCreate');
        
        var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            description: $(form_name).val()
        };
            
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke('AjaxOrderCreate',params);
    },
    
    /**
     * Deletes a saved order
     * This method is invoked by the <b>Delete</b> action.
     * @param (string) orderId The orderId of the saved order.
     */
    deleteOrder:function (orderId) {
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        };
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxSingleOrderCancel", params);
    },
    
    /**
     * Duplicates a saved order.
     * This method is invoked by the <b>Duplicate order</b> action.
     * @param (string) orderId The order from which the new saved order is created.
     * @param (string) orderDesc The name of the saved order.
     */
    duplicateOrder:function (orderId, orderDesc) {
        MessageHelper.hideAndClearMessage();
        
        var params = {
            storeId: this.storeId,
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            fromOrderId_1: orderId,
            toOrderId: "**",
            copyOrderItemId_1: "*",
            keepOrdItemValidContract: "1",
            URL: "TableDetailsDisplayURL"
        };
        if (orderDesc != null && orderDesc != 'undefined'){
            params["description"] = orderDesc;
        }
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke('AjaxSingleOrderCopy',params);
    },
    
    /**
    * Sets the selected saved order as the current order in the saved orders table.
    * This method is invoked by the <b>Set as Current Order</b> action. 
    **/
    setCurrentOrder : function (orderId) {
        if (orderId != null && orderId != 'undefined') {
            if(!submitRequest()){
                return;
            }
            var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                orderId: orderId,
                URL: ""
            };
            wcService.invoke("AjaxSetPendingOrder", params);
        }
    },
    
    /**
     * Updates the current order in the database to match the order in the shopping cart.
     * This method is called when the Saved Order list page loads, and when a saved order is added/deleted. 
     * @param (string) currentOrderId The orderId to set as the current order.
     */
    updateCurrentOrder : function(currentOrderId) {
        if (currentOrderId != null) {
            var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                URL: "",
                orderId: currentOrderId
            };
            wcService.invoke("AjaxUpdatePendingOrder", params);
        }
    },
    
    /**
     * Returns the order ID of the first saved order in the table.
     * @returns {String} The order ID of the first saved order if not empty, otherwise, returns null.
     * 
     **/
    getFirstSavedOrderIdFromList : function() {
        var savedOrderLink = document.getElementById("WC_OrderList_Link_2_1");
        
        if (savedOrderLink && savedOrderLink != null && savedOrderLink != 'undefined' && savedOrderLink.innerHTML != null && savedOrderLink.innerHTML != 'undefined') {
            var savedOrderText = savedOrderLink.innerHTML,
            savedOrderId = savedOrderText.split(" ")[0];
            
            return savedOrderId;
        } else {
            return null;
        }
    },
    
    /**
     * Returns the current order ID from the currentOrderJSON div.
     * @returns {String} The order ID of the current order or null if the currentOrderJSON div cannot be found.
     * 
     **/
    getCurrentOrderId : function() {
        var jsonDIV = null;
        Utils.ifSelectorExists("#currentOrderJSON", function($node) {
            jsonDIV = JSON.parse($node.html());
        });
        if (jsonDIV != null && jsonDIV != 'undefined' && jsonDIV.currentOrderId != null && jsonDIV.currentOrderId != 'undefined') {
            return jsonDIV.currentOrderId;
        }
        else {
            return null;
        }
    },
    
    /**
     * Sets the newOrderId variable. This variable is only used to store the first saved order in the list.
     * @param newOrdId The order ID of the newly created saved order.
     */
    setNewOrderId : function(newOrdId) {
        this.newOrderId = newOrdId;
    },

    /**
     * Returns the ID of the new saved order. 
     * The newOrderId variable is set only when it is the first saved order in the list.
     * @returns {String} The ID of the newly created saved order.
     */
    getNewOrderId : function() {
        return this.newOrderId;
    },
    
    /**
     * Returns the currentOrderDeleted flag. 
     * @returns {boolean} true or false indicating whether the current saved order was deleted.
     * 
     */
    isCurrentOrderDeleted : function() {
        return this.currentOrderDeleted;
    },
    
    /**
     * Sets the currentOrderDeleted flag to true or false. 
     * This flag determines if the current saved order was deleted.
     * @param currOrderDeleted A boolean (true/false) indicating if the saved order was deleted.
     */
    setCurrentOrderDeleted : function(currOrderDeleted) {
        this.currentOrderDeleted = currOrderDeleted;
    },
    
    /**
    * Opens the saved order details view for the order.
    * This method is invoked by the <b>View Details</b> action.
    * @param (string) reqListURL The URL to the 
    **/
    viewDetails : function (reqListURL) {
        document.location.href = reqListURL;
    },
    
    /**
     * Checks if a string is null or empty.
     * @param (string) str The string to check.
     * @return (boolean) Indicates whether the string is empty.
     */
    isEmpty:function (str) {
        var reWhiteSpace = new RegExp(/^\s+$/);
        if (str == null || str =='' || reWhiteSpace.test(str) ) {
            return true;
        }
        return false;
    },
    
    /**
     * Remove the quantity of the SKU (e.g. when row is hidden)
     * @param (string) restUrl The rest url for getting order items
     * @param (string) params String with the params to be passed in
     */
    getOrderItems:function(restUrl, params){
        $.get(restUrl, params, function(order, textStatus, jqXHR) {
            OrderListJS.quantityList = {};
            if (order.orderItem == null) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('MYACCOUNT_SAVEDORDERLIST_EMPTY_ADD_TO_REQ_FAIL'));
                return;
            }
            for (var i = 0; i < order.orderItem.length; i++) {
                var orderId = order.orderId;

                if (!(orderId in OrderListJS.quantityList)) {
                    OrderListJS.quantityList[orderId] = {};
                }
                OrderListJS.quantityList[orderId][order.orderItem[i].productId] = order.orderItem[i].quantity;
            }

            if (typeof addReqListsJS != 'undefined') {
                addReqListsJS.toggleDropDownMenu(true,false);
            }
        });
    },
    
    /**
     *This method locks the order specified when the buyer administrator is browsing in an on behalf mode.
     */
    lockOrderOnBehalf: function(orderId){
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        };
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxRESTOrderLockOnBehalf", params);
    },
    
    /**
     * This method take over the lock on the order by other buyer administrator 
     * when the buyer administrator is browsing in an on behalf mode.
     */
    takeOverLockOrderOnBehalf: function(orderId, isCurrentOrder){
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            takeOverLock: "Y"
        };
        if (undefined !== isCurrentOrder && isCurrentOrder =='true'){
            setDeleteCartCookie();
            params["isCurrentOrder"] = 'true';
        } else {
            params["isCurrentOrder"] = 'false';
        }
        
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxRESTOrderLockTakeOverOnBehalf", params);
    },
        
    /**
     *This method unlocks the order specified when the buyer administrator is browsing in 
     *an on behalf mode.
     */
    unlockOrderOnBehalf: function(orderId){
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        };
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxRESTOrderUnlockOnBehalf", params);
    }
}
