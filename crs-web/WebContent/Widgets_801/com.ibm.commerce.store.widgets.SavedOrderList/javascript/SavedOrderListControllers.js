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
 * Declares a new render context for creating a new saved order.
 */
wc.render.declareContext("SavedOrderListTable_Context",{"beginIndex":"0","orderBy":""},"");


/**
 * Declares a new refresh controller for creating a new saved order.
 */
wc.render.declareRefreshController({
       id: "SavedOrderListTable_controller",
       renderContext: wc.render.getContextById("SavedOrderListTable_Context"),
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
	 * Refreshes the saved order list display if an order is updated
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {
		var renderContext = this.renderContext;
		if (message.actionId == 'AjaxOrderCreate' || message.actionId == 'AjaxSingleOrderCancel' || message.actionId == 'AjaxSingleOrderCopy' || message.actionId == 'AjaxSetPendingOrder' 
		    || message.actionId == 'AjaxRESTOrderUnlockOnBehalf' || message.actionId == 'AjaxRESTOrderLockOnBehalf' || message.actionId == 'AjaxRESTOrderLockTakeOverOnBehalf') {
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
		 
		 // If the current saved order gets deleted, we trigger the "AjaxUpdatePendingOrder" 
		 // to set the first saved order in the list as the current saved order.
		 if (SavedOrderListJS.getFirstSavedOrderIdFromList() != null && SavedOrderListJS.isCurrentOrderDeleted() == true) {
			 SavedOrderListJS.updateCurrentOrder(SavedOrderListJS.getFirstSavedOrderIdFromList());
		 }
		 
		 // If it's the only saved order in the list and the current saved order div is not currently set,
		 // ensure that it's set as the current saved order.
		 if (SavedOrderListJS.getNewOrderId() != null && SavedOrderListJS.getNewOrderId() != 'undefined' && SavedOrderListJS.getNewOrderId() != "" ) {
			 var newOrderId = SavedOrderListJS.getNewOrderId();
			 SavedOrderListJS.updateCurrentOrder(newOrderId);
			 SavedOrderListJS.setNewOrderId(null);
		 }
		 
		 if (SavedOrderListJS.isCurrentOrderDeleted() == true) {
			 SavedOrderListJS.setCurrentOrderDeleted(false);
		 }
		 
		 toggleMobileView();
	}
});