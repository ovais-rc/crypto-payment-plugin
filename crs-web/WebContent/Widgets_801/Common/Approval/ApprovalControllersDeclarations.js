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
 * @fileOverview This javascript is used by the Approval List pages to control the refresh areas.
 * @version 1.2
 */
var declareOrderApprovalListRefreshArea = function() {
    var myWidgetObj = $("#OrderApprovalTable_Widget");

    wcRenderContext.declare("OrderApprovalTable_Context", ["OrderApprovalTable_Widget"], {"beginIndex":"0", "orderId": "", "firstName": "", "lastName":"","startDate":"","endDate":"","approvalStatus":"0"});

    wcTopic.subscribe(["AjaxApproveOrderRequest","AjaxRejectOrderRequest"], function() {
        myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("OrderApprovalTable_Context"));
    });

    myWidgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("OrderApprovalTable_Context"));
        }, 
        postRefreshHandler: function() {
            OrderApprovalListJS.restoreToolbarStatus();
            cursor_clear();
        }
    });
}        
 
/**
 * Declares a new refresh controller for buyer approval.
 */
var declareBuyerApprovalTableRefreshArea = function() {
	var myWidgetObj = $("#BuyerApprovalTable_Widget");
    
    /**
     * Declares a new render context for buyer approval list table
     */
	wcRenderContext.declare("BuyerApprovalTable_Context", ["BuyerApprovalTable_Widget"], {
        "beginIndex": "0",
        "approvalId": "",
        "firstName": "",
        "lastName": "",
        "startDate": "",
        "endDate": "",
        "approvalStatus": "0"
	});
  	
	wcTopic.subscribe(["AjaxApproveBuyerRequest","AjaxRejectBuyerRequest"], function() {
		myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("BuyerApprovalTable_Context"));
	});
    
	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function () {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("BuyerApprovalTable_Context"));
        },

        postRefreshHandler: function() {
        	BuyerApprovalListJS.restoreToolbarStatus();
            cursor_clear();
        }
	});
}

/**
 * Declares a new refresh controller for buyer approval comment.
 */
var declareApprovalCommentController = function() {    
    var myWidgetObj = $("#ApprovalComment_Widget");
    
    /**
     * Declares a new render context for approval comments widget
     */
    wcRenderContext.declare("ApprovalComment_Context", ["ApprovalComment_Widget"], {
       "approvalStatus": "all"
    });
    
    /** 
	* Refreshes the approval comment widget if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	* 
	* @param {string} message The model changed event message
	* @param {object} widget The registered refresh area
	*/    
    wcTopic.subscribe(["AjaxApproveRequest","AjaxRejectRequest"], function() {
		myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("ApprovalComment_Context"));
	});
    
    myWidgetObj.refreshWidget({
        /** 
        * This function is called when a render context changed event is detected. 
        * 
        * @param {string} message The render context changed event message
        * @param {object} widget The registered refresh area
        */
        renderContextChangedHandler: function () {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("ApprovalComment_Context"));
        }
    });
};