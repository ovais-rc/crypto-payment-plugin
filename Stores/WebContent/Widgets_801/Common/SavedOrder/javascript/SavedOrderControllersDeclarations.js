//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/** 
 * @fileOverview This javascript is used by the Saved Order pages to control the refresh areas.
 * @version 1.1
 */

/**
 * List of all the services that result in changes to a saved order
 * @static
 */
var savedorder_updated = [
    'AjaxSavedOrderDeleteItem',
    'savedOrderUpdateDescription',
    'AjaxSavedOrderUpdateItem',
    'AjaxAddOrderItem'
];

/**
 * Declares a new render context for saved order details page item table.
 */
wcRenderContext.declare("SavedOrderItemTable_Context", ["SavedOrderItemTable_Widget"], {
    "beginIndex": "0"
});

/**
 * Declares a new refresh controller for the Saved Order Items table display.
 */
var declareSavedOrderItemTableController = function() {
    var myWidgetObj = $("#SavedOrderItemTable_Widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("SavedOrderItemTable_Context");
    
    // model change
    wcTopic.subscribe(["AjaxSavedOrderDeleteItem", "AjaxSavedOrderUpdateItem", "AjaxAddOrderItem"], function(returnAction){
        myRCProperties["orderId"] = returnAction.data.orderId;
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    });
    
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },
        postRefreshHandler: function() {
            cursor_clear();
            if (Utils.existsAndNotEmpty(SavedOrderItemsJS.getCurrentRow())) {
                 SavedOrderItemsJS.showUpdatedMessage();
            }
            SavedOrderItemsJS.resetCurrentRow();
        }
    });
};

/**
 * Declares a new render context for saved order details page information area.
 */
wcRenderContext.declare("SavedOrderInfo_Context", ["SavedOrderInfo_Widget"], {});

/**
 * Declares a new refresh controller for the Saved Order Info display.
 */
var declareSavedOrderInfoController = function() {
    var widgetObj = $("#SavedOrderInfo_Widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("SavedOrderInfo_Context");
    
    /** 
     * Refreshes the saved order info display if name is updated
     * or an update/delete in the saved order items table occurs.
     * This function is called when a modelChanged event is detected. 
     */
    wcTopic.subscribe(savedorder_updated, function(returnAction) {
        // update actionId
        myRCProperties["orderId"] = returnAction.data.orderId;
        widgetObj.refreshWidget("refresh", myRCProperties);
    });
    
    widgetObj.refreshWidget({
        /** 
         * Refreshes the saved order info display if the name of the saved order is changed 
         * or an update/delete in the saved order items table occurs.
         * This function is called when a render context event is detected. 
         */
         renderContextChangedHandler: function () {
            widgetObj.refreshWidget("refresh", myRCProperties);
         },

        /** 
         * Clears the progress bar
         */
        postRefreshHandler: function() {
             cursor_clear();
        }
    });
};