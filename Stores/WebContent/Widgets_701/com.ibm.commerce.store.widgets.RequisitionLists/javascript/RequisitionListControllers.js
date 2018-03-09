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
 * Declares a new render context for creating a new list.
 */
wc.render.declareContext("RequisitionListTable_Context",{"beginIndex":"0","orderBy":""},"");


/**
 * Declares a new refresh controller for creating a new List.
 */
wc.render.declareRefreshController({
       id: "RequisitionListTable_controller",
       renderContext: wc.render.getContextById("RequisitionListTable_Context"),
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
	 * Refreshes the requisition list display if a requisition list is updated
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {
		var renderContext = this.renderContext;
		if (message.actionId =='requisitionListCreate' || message.actionId =='AjaxRequisitionListDelete' || message.actionId =='requisitionListCopy') {
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
		 
		 toggleMobileView();
	}
});