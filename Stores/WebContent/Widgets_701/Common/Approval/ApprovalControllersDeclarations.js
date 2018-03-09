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

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * Declares a new refresh controller for order approval.
 */
wc.render.declareRefreshController({
	id: "OrderApprovalTable_Controller",
	renderContext: wc.render.getContextById("OrderApprovalTable_Context"),
	url: "",
	formId: "",

	/** 
	* Refreshes the approval list display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	* 
	* @param {string} message The model changed event message
	* @param {object} widget The registered refresh area
	*/    	   
	modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		if (message.actionId =='AjaxApproveOrderRequest' || message.actionId == 'AjaxRejectOrderRequest') {
			widget.refresh(renderContext.properties);
		}
	},

	/** 
	* Displays the previous/next page of order approval list
	* This function is called when a render context changed event is detected. 
	* 
	* @param {string} message The render context changed event message
	* @param {object} widget The registered refresh area
	*/
	renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		widget.refresh(renderContext.properties);
	},
	
	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	postRefreshHandler: function(widget) {
		OrderApprovalListJS.restoreToolbarStatus();
		cursor_clear();
		//After approving/rejecting an item
		//Need to set the paging table begin index back to 0 as it will always return to the 1st page 
		//wc.render.updateContext('OrderApprovalTable_Context',{'beginIndex':0});
	}
}),

/**
 * Declares a new refresh controller for buyer approval.
 */
wc.render.declareRefreshController({
	id: "BuyerApprovalTable_Controller",
	renderContext: wc.render.getContextById("BuyerApprovalTable_Context"),
	url: "",
	formId: "",

	/** 
	* Refreshes the approval list display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	* 
	* @param {string} message The model changed event message
	* @param {object} widget The registered refresh area
	*/    	   
	modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		if (message.actionId =='AjaxApproveBuyerRequest' || message.actionId == 'AjaxRejectBuyerRequest') {
			widget.refresh(renderContext.properties);
		}
	},

	/** 
	* Displays the previous/next page of buyer approval list
	* This function is called when a render context changed event is detected. 
	* 
	* @param {string} message The render context changed event message
	* @param {object} widget The registered refresh area
	*/
	renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		widget.refresh(renderContext.properties);
	},
	
	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	postRefreshHandler: function(widget) {
		BuyerApprovalListJS.restoreToolbarStatus();
		cursor_clear();
		//After approving/rejecting an item
		//Need to set the paging table begin index back to 0 as it will always return to the 1st page 
		//wc.render.updateContext('BuyerApprovalTable_Context',{'beginIndex':0});
	}
}),

wc.render.declareRefreshController({
	id: "ApprovalComment_Controller",
	renderContext: wc.render.getContextById("ApprovalComment_Context"),
	url: "",
	formId: "",

	/** 
	* Refreshes the approval comment widget if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	* 
	* @param {string} message The model changed event message
	* @param {object} widget The registered refresh area
	*/    	   
	modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		if (message.actionId =='AjaxApproveRequest' || message.actionId == 'AjaxRejectRequest') {
			widget.refresh(renderContext.properties);
		}
	},

	/** 
	* This function is called when a render context changed event is detected. 
	* 
	* @param {string} message The render context changed event message
	* @param {object} widget The registered refresh area
	*/
	renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		widget.refresh(renderContext.properties);
	}
})