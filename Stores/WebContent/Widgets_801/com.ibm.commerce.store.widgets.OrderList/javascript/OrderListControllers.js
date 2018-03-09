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
 * Declares a new render context for order list.
 */
wcRenderContext.declare("OrderListTable_Context", [], {beginIndex: "0"});

/**
 * Declares a new refresh controller for order list.
 */
var declareOrderDisplayRefreshArea = function(widgetPrefix) {
    var myWidgetObj = $("#" + widgetPrefix + "OrderListTable_Widget");
    wcRenderContext.addRefreshAreaId("OrderListTable_Context", widgetPrefix + "OrderListTable_Widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("OrderListTable_Context");
    
    /**
     * Displays the previous/next page of orders.
     * This function is called when a render context changed event is detected.
     */
    wcTopic.subscribe(["AjaxCancelSubscription", "AjaxOrderCreate", "AjaxSingleOrderCancel", "AjaxSingleOrderCopy", "AjaxSetPendingOrder", "AjaxRESTOrderUnlockOnBehalf", "AjaxRESTOrderLockOnBehalf", "AjaxRESTOrderLockTakeOverOnBehalf"], function () {
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    });
    
    var renderContextChangedHandler = function() {
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    }
    
    var postRefreshHandler = function() {
        cursor_clear();

        if(OrderListJS.isSavedOrder()) {
            // If the current saved order gets deleted, we trigger the "AjaxUpdatePendingOrder" 
             // to set the first saved order in the list as the current saved order.
             if (OrderListJS.getFirstSavedOrderIdFromList() != null && OrderListJS.isCurrentOrderDeleted() == true) {
                 OrderListJS.updateCurrentOrder(OrderListJS.getFirstSavedOrderIdFromList());
             }

             // If it's the only saved order in the list and the current saved order div is not currently set,
             // ensure that it's set as the current saved order.
             if (Utils.existsAndNotEmpty(OrderListJS.getNewOrderId())) {
                 var newOrderId = OrderListJS.getNewOrderId();
                 OrderListJS.updateCurrentOrder(newOrderId);
                 OrderListJS.setNewOrderId(null);
             }

             if (OrderListJS.isCurrentOrderDeleted() == true) {
                 OrderListJS.setCurrentOrderDeleted(false);
             }

             toggleMobileView();
        }
    }
    
    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
}