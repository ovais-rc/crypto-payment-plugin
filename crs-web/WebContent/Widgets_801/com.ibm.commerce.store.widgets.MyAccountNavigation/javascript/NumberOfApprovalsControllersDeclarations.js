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
 * @fileOverview This javascript is used by the My Account Navigation widget to control the refresh areas.
 * @version 1.2
 */

/**
 * Declares a new refresh controller for number of order approvals.
 */
var declareNumberOfOrderApprovalsController = function() {
    var myWidgetObj = $("#NumberOfOrderApprovals_Widget");
    
    /** 
	* Refreshes the number of order approvals display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	*/    	   
	wcTopic.subscribe(["AjaxApproveOrderRequest", "AjaxRejectOrderRequest", "AjaxApproveRequest", "AjaxRejectRequest"], function () {
	    myWidgetObj.refreshWidget("refresh");
	});
    
    myWidgetObj.refreshWidget({
        /** 
        * Refresh number of order approval display to keep it consistent with table
        * This function is called when a render context changed event is detected. 
        */
        renderContextChangedHandler: function() {
            // Do not refresh the count in Left Navigation bar, when the search criteria changes in the main table view.
            // Left Nav displays the count of orders to approve without any filter applied.
            //widget.refresh();
        },

        postRefreshHandler: function() {
            //cursor_clear();

        }
    });
};

/**
 * Declares a new refresh controller for number of buyer approvals.
 */
var declareNumberOfBuyerApprovalsController = function() {
    var myWidgetObj = $("#NumberOfBuyerApprovals_Widget");

    /** 
	* Refreshes the number of buyer approvals display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	*/    	   
	wcTopic.subscribe(["AjaxApproveBuyerRequest", "AjaxRejectBuyerRequest", "AjaxApproveRequest", "AjaxRejectRequest"], function () {
		myWidgetObj.refreshWidget("refresh");
	});
    
    myWidgetObj.refreshWidget({
        /** 
        * Refresh number of buyer approval display to keep it consistent with table
        * This function is called when a render context changed event is detected. 
        */
        renderContextChangedHandler: function() {
            // Do not refresh the count in Left Navigation bar, when the search criteria changes in the main table view.
            // Left Nav displays the count of orders to approve without any filter applied.
        	//widget.refresh();
        },

        postRefreshHandler: function() {
            //cursor_clear();

        }
    });
};