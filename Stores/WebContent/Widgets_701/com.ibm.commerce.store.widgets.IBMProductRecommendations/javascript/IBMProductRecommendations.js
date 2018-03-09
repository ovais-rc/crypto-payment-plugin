//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides the render context used to display
 * the recommendations from Coremetrics Intelligent Offer. It also
 * contains the zone population function called with the results to
 * display.
 */
 
dojo.require("wc.render.common");
dojo.require("wc.render.RefreshController");
dojo.require("wc.render.Context");
dojo.require("wc.widget.RefreshArea");

/** 
 * @class The IntelligentOfferJS class defines the render context used to display
 * the recommendations from Coremetrics Intelligent Offer.
 */
IntelligentOfferJS = {
	/* The common parameters used in service calls. */
		langId: "-1",
		storeId: "",
		catalogId: "",
	
	/**
	 * This function initializes common parameters used in all service calls.
	 * @param {int} langId The language id to use.
	 * @param {int} storeId The store id to use.
	 * @param {int} catalogId The catalog id to use.
	 */
		setCommonParameters:function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
		
	/**
	 *  Displays the Intelligent Offer recommendations. 
	 *  @param {string} controllerURL The URL of the refresh area contents to point to upon a widget refresh.
	 *  @param {string} pageNumber The updated page number to display.
	 */	
	showNextResults: function(pageNumber){
			if(!submitRequest()){
				return;
			}
			cursor_wait(); 
			

			if(null != dojo.byId("widget_Offer_"+pageNumber)){
				dojo.byId("widget_Offer_"+pageNumber).style.display = "none";
				
			}
			
			pageNumber++;
			
			if(null != dojo.byId("widget_Offer_"+pageNumber)){
				dojo.byId("widget_Offer_"+pageNumber).style.display = "block";
				
			}
			cursor_clear();
	},
	
	showPrevResults: function(pageNumber){
			if(!submitRequest()){
				return;
			}
			cursor_wait(); 
			

			if(null != dojo.byId("widget_Offer_"+pageNumber)){
				dojo.byId("widget_Offer_"+pageNumber).style.display = "none";
				
			}
			
			pageNumber--;
			
			if(null != dojo.byId("widget_Offer_"+pageNumber)){
				dojo.byId("widget_Offer_"+pageNumber).style.display = "block";
				
			}
			cursor_clear();
	},
	/**
	 *  This function declares a context and a refresh area controller that has the given context ID and controller ID.
	 *	@param {string} controllerId The ID of the controller that is going to be declared.
	 *	@param {string} contextId The ID of the context that is going to be declared.
	 */
	declareRefreshController: function(controllerId, contextId, updateSwatch){
		 
		wc.render.declareContext(contextId,{partNumbers: "", zoneId: "", espotTitle: "", updateSwatch: updateSwatch},"")
		 
		//console.debug("entering IntelligentOfferJS.declareRefreshController with contextId = " + contextId + " and controller id = " + controllerId);
		if(wc.render.getRefreshControllerById(controllerId)){ 
			//console.debug("controller with id = " + controllerId + " already exists. No declaration will be done");
			return;
		}
		
		wc.render.declareRefreshController({
			id: controllerId, 
			renderContext: wc.render.getContextById(contextId),
			url: "",
	    formId: ""
	    
     /** 
      * Refreshes the Intelligent Offer Recommendations e-Marketing Spot area.
      * This function is called when a render context changed event is detected. 
      * @param {string} message The model changed event message
      * @param {object} widget The registered refresh area
      */	    
	   ,modelChangedHandler: function(message, widget) {
          var renderContext = this.renderContext;
			}

     /** 
      * Refreshes the Intelligent Offer Recommendations e-Marketing Spot area.
      * This function is called when a render context changed event is detected. 
      * @param {string} message The model changed event message
      * @param {object} widget The registered refresh area
      */
     ,renderContextChangedHandler: function(message, widget) {
          var renderContext = this.renderContext;

          widget.refresh(renderContext.properties);
			}
    
     /** 
      * Post handling for the Intelligent Offer Recommendations e-Marketing Spot area.
      * This function is called after a successful refresh. 
      * @param {object} widget The registered refresh area
      */    
     ,postRefreshHandler: function(widget) {
	    		var renderContext = this.renderContext;	   
	    		cursor_clear();
	    		// updateSwatch should be set to true if swatches should be selected by default
	    		if(renderContext.properties.updateSwatch == "true"){
	    			shoppingActionsJS.updateSwatchListView();
	    		}
	    		// need to process cm_cr tags
	    		cX("onload");
     	}
		});
	}
};	


/**
 * Declares a render context for the product rankings ESpot.
 */
	wc.render.declareContext("IntelligentOffer_Context",{emsName: ""},"");

/** 
 * Declares a new refresh controller for Product rankings ESpot
 */
	wc.render.declareRefreshController({
			id : "IntelligentOffer_Controller",
			renderContext: wc.render.getContextById("IntelligentOffer_Context"),
			url : "",
			formId : ""
			
			/** 
			* Retrieves the product rankings.
			* This function is called when a render context changed event is detected. 
			* 
			* @param {string} message The render context changed event message
			* @param {object} widget The registered refresh area
			*/
			
			,renderContextChangedHandler: function(message,widget) {
				var controller = this;
				var renderContext = this.renderContext;
								
				if(controller.testForChangedRC(["emsName"])){					
					widget.refresh(renderContext.properties);
				}
			}
					
	});	
	
/**
 *  This function is the zone population function called by Coremetrics Intelligent Offer.
 *  It creates a comma separated list of the partnumbers to display, and then updates
 *  the refresh area that will display the recommendations.
 */
function io_rec_zp(a_product_ids,zone,symbolic,target_id,category,rec_attributes,target_attributes,target_header_txt) {
	if (symbolic !== '_NR_') {
		var n_recs = a_product_ids.length;
		var rec_part_numbers;
		for (var ii=0; ii < n_recs; ii++) {
			if (ii == 0) {
 				rec_part_numbers = a_product_ids[ii];
			} else {
				rec_part_numbers = rec_part_numbers + ',' + a_product_ids[ii];
			}
			
		}
		
		var zoneId = zone.replace(/\s+/g,'');
		wc.render.updateContext('WC_IntelligentOfferESpot_context_ID_' + zoneId, {'partNumbers':rec_part_numbers, 'zoneId': zoneId, 'espotTitle': target_header_txt});
	}
	else{
		var  rec_part_numbers;
		var zoneId = zone.replace(/\s+/g,'');
		target_header_txt = '';
		wc.render.updateContext('WC_IntelligentOfferESpot_context_ID_' + zoneId, {'partNumbers':rec_part_numbers, 'zoneId': zoneId, 'espotTitle': target_header_txt});
	}
};
