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
 * @fileOverview This javascript is used by the My Account Navigation widget to control the refresh areas.
 * @version 1.2
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * Declares a new refresh controller for number of order approvals.
 */
wc.render.declareRefreshController({
	id: "NumberOfOrderApprovals_Controller",
	renderContext: wc.render.getContextById("OrderApprovalTable_Context"),
	url: "",
	formId: "",

	/** 
	* Refreshes the number of order approvals display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	* 
	* @param {string} message The model changed event message
	* @param {object} widget The registered refresh area
	*/    	   
	modelChangedHandler: function(message, widget) {
		if (message.actionId =='AjaxApproveOrderRequest' || message.actionId == 'AjaxRejectOrderRequest' || message.actionId == 'AjaxApproveRequest' || message.actionId == 'AjaxRejectRequest') {
			widget.refresh();
		}
	},
	
	/** 
	* Refresh number of order approval display to keep it consistent with table
	* This function is called when a render context changed event is detected. 
	* 
	* @param {string} message The render context changed event message
	* @param {object} widget The registered refresh area
	*/
	renderContextChangedHandler: function(message, widget) {
		// Do not refresh the count in Left Navigation bar, when the search criteria changes in the main table view.
		// Left Nav displays the count of orders to approve without any filter applied.
		//widget.refresh();
	},
	
	postRefreshHandler: function(widget) {
		//cursor_clear();
		
	}
}),

/**
 * Declares a new refresh controller for number of buyer approvals.
 */
wc.render.declareRefreshController({
	id: "NumberOfBuyerApprovals_Controller",
	renderContext: wc.render.getContextById("BuyerApprovalTable_Context"),
	url: "",
	formId: "",

	/** 
	* Refreshes the number of buyer approvals display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	* 
	* @param {string} message The model changed event message
	* @param {object} widget The registered refresh area
	*/    	   
	modelChangedHandler: function(message, widget) {
		if (message.actionId =='AjaxApproveBuyerRequest' || message.actionId == 'AjaxRejectBuyerRequest' || message.actionId == 'AjaxApproveRequest' || message.actionId == 'AjaxRejectRequest') {
			widget.refresh();
		}
	},
	
	/** 
	* Refresh number of buyer approval display to keep it consistent with table
	* This function is called when a render context changed event is detected. 
	* 
	* @param {string} message The render context changed event message
	* @param {object} widget The registered refresh area
	*/
	renderContextChangedHandler: function(message, widget) {
		// Do not refresh the count in Left Navigation bar, when the search criteria changes in the main table view.
		// Left Nav displays the count of orders to approve without any filter applied.
		//widget.refresh();
	},
	
	postRefreshHandler: function(widget) {
		//cursor_clear();
		
	}
})