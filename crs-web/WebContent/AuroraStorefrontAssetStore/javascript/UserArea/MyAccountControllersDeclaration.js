//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides the controller variables and functions for My Account pages, 
 * and links these controllers to listen to the defined render contexts in CommonContextsDeclarations.js.
 */

/** 
 * @class The MyAccountControllersDeclarationJS class defines the common variables and functions that control 
 * the defined render contexts on the My Account store pages. Controller provides the JavaScript logic 
 * that listens to changes in the render context and the model. A defined render context is a set of 
 * client-side context information which keeps track of information about a page. The context information 
 * helps decide if changes to refresh areas are needed. 
 */
MyAccountControllersDeclarationJS = {
        declareProcessedOrdersStatusDisplayRefreshArea: function() {
            // ============================================
            // div: ProcessedOrdersStatusDisplay refresh area
            // Declares a new refresh controller for the processed orders status display.
            var myWidgetObj = $("#ProcessedOrdersStatusDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("ProcessedOrdersStatusDisplay_Context");
            
            /** 
             * Displays the previous/next page of order items on the processed order status page.
             * This function is called when a render context changed event is detected. 
             */
            var renderContextChangedHandler = function() {
                if (wcRenderContext.testForChangedRC("ProcessedOrdersStatusDisplay_Context", ["beginIndex"])) {
                    myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            };
            
            /** 
             * Clears the progress bar
             */
            var postRefreshHandler = function() {
                 cursor_clear();
            };
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        },
        
        declareWaitingForApprovalOrdersStatusDisplayRefreshArea: function() {
            // ============================================
            // div: WaitingForApprovalOrdersStatusDisplay refresh area
            // Declares a new refresh controller for the waiting-for-approval orders status display.
            var myWidgetObj = $("#WaitingForApprovalOrdersStatusDisplay");
            var myRCProperties = wcRenderContext.getRenderContextProperties("WaitingForApprovalOrdersStatusDisplay_Context");
            
            /** 
             * Displays the previous/next page of order items in the order status page.
             * This function is called when a render context changed event is detected. 
             */
            var renderContextChangedHandler = function() {
                if(wcRenderContext.testForChangedRC("WaitingForApprovalOrdersStatusDisplay_Context", ["beginIndex"])){
                    myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            }
            
            /** 
             * Clears the progress bar
             */
            var postRefreshHandler = function() {
                 cursor_clear();
            }
            
            // initialize widget
            myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
        }
        
}



