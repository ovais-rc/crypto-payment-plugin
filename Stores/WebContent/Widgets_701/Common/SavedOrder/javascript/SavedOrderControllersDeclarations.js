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
 * @fileOverview This javascript is used by the Saved Order pages to control the refresh areas.
 * @version 1.1
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * map savedorder_updated to all the services that result in changes to a saved order
 * @static
 */
var savedorder_updated = {	
							'AjaxSavedOrderDeleteItem':'AjaxSavedOrderDeleteItem',
							'savedOrderUpdateDescription':'savedOrderUpdateDescription',
							'AjaxSavedOrderUpdateItem':'AjaxSavedOrderUpdateItem',
							'AjaxAddOrderItem':'AjaxAddOrderItem'
						};
/**
 * Declares a new refresh controller for the Saved Order Items table display.
 */
wc.render.declareRefreshController({
       id: "SavedOrderItemTable_Controller",
       renderContext: wc.render.getContextById("SavedOrderItemTable_Context"),
       url: "",
       formId: "" 

   	/** 
   	 * Refreshes the list table display if an item is updated.
   	 * This function is called when a render context event is detected. 
   	 * 
   	 * @param {string} message The render context changed event message
   	 * @param {object} widget The registered refresh area
   	 */    	   
    ,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;						
		widget.refresh(renderContext.properties);		
    }
	   
	/** 
	 * Refreshes the saved order items display if an item is updated.
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		if (message.actionId == 'AjaxSavedOrderDeleteItem' || message.actionId == 'AjaxSavedOrderUpdateItem' 
				|| message.actionId == 'AjaxAddOrderItem') {
			renderContext.properties["orderId"] = message.orderId;
			widget.refresh(renderContext.properties);
		}
	}

	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {
		 cursor_clear();		
		 if (SavedOrderItemsJS.getCurrentRow() != "" && SavedOrderItemsJS.getCurrentRow() != null && SavedOrderItemsJS.getCurrentRow() != 'undefined') {
			 SavedOrderItemsJS.showUpdatedMessage();
		 }
		 SavedOrderItemsJS.resetCurrentRow();

	}
});

/**
 * Declares a new refresh controller for the Saved Order Info display.
 */
wc.render.declareRefreshController({
       id: "SavedOrderInfo_Controller",
       renderContext: wc.render.getContextById("SavedOrderInfo_Context"),
       url: "",
       formId: "" 

   	/** 
   	 * Refreshes the saved order info display if the name of the saved order is changed 
   	 * or an update/delete in the saved order items table occurs.
   	 * This function is called when a render context event is detected. 
   	 * 
   	 * @param {string} message The render context changed event message
   	 * @param {object} widget The registered refresh area
   	 */    	   
    ,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;						
		widget.refresh(renderContext.properties);		
    }
	   
	/** 
	 * Refreshes the saved order info display if name is updated
	 * or an update/delete in the saved order items table occurs.
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;
		//add update actionId also
		if (message.actionId in savedorder_updated) {
			renderContext.properties["orderId"] = message.orderId;
			widget.refresh(renderContext.properties);
		}
	}

	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {
		 cursor_clear();
	}
});
