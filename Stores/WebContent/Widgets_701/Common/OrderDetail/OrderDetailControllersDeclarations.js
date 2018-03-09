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
	id: "OrderDetailItemTable_Controller",
	renderContext: wc.render.getContextById("OrderDetailItemTable_Context"),
	url: "",
	formId: "",

	/** 
	* Displays the previous/next page of order items in order approval details page
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
		cursor_clear();
		dojo.byId("orderSummaryContainer_minusImage_link").focus();
	}
	
})