//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the Approval List pages to control the refresh areas.
 * @version 1.2
 */

/**
 * Declares a new refresh controller for order approval.
 */
var declareOrderDetailItemTableController = function() {
    var myWidgetObj = $("#OrderDetailItemTable_Widget");
    
    /**
     * Declares a new render context for order approval list table
     */
    wcRenderContext.declare("OrderDetailItemTable_Context", ["OrderDetailItemTable_Widget"], {
        "beginIndex": "0"
    });
    
    myWidgetObj.refreshWidget({
        /** 
        * Displays the previous/next page of order items in order approval details page
        * This function is called when a render context changed event is detected. 
        * 
        * @param {string} message The render context changed event message
        * @param {object} widget The registered refresh area
        */
        renderContextChangedHandler: function () {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("OrderDetailItemTable_Context"));
        },

        /** 
         * Clears the progress bar
         * 
         * @param {object} widget The registered refresh area
         */
        postRefreshHandler: function(widget) {
            cursor_clear();
            $("#orderSummaryContainer_minusImage_link").focus();
        }
    });
};