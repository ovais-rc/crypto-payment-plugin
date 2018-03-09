//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012, 2016 All Rights Reserved.
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

/** 
 * @class The IntelligentOfferJS class defines the render context used to display
 * the recommendations from Coremetrics Intelligent Offer.
 */
IntelligentOfferJS = {
	/* The common parameters used in service calls. */
	langId: "-1",
	storeId: "",
	catalogId: "",
	widgetsCurCount: 0,
	widgetsTotalCount: 0,
	
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
	 * Declare the controller function for the Intelligent Offer Recommendations e-Marketing Spot refressh area.
	 * @param {array} contains wc site zone id and updateSwatch
	 */
	declareWC_IntelligentOfferESpot_controller: function(args) {
		var WC_zone = args[0];
		var updateSwatch = args[1];
		var contextId = "WC_IntelligentOfferESpot_context_ID_" + WC_zone;
		var containerId = "WC_IntelligentOfferESpot_container_ID_" + WC_zone;
		var myWidgetObj = $("#" + containerId);

		if (!wcRenderContext.checkIdDefined(contextId)) {
			wcRenderContext.declare(contextId, [], {partNumbers: "", zoneId: "", espotTitle: "", updateSwatch: updateSwatch});
		}
		wcRenderContext.addRefreshAreaId(contextId, containerId);
		var myRCProperties = wcRenderContext.getRenderContextProperties(contextId);
		
		// initialize widget
		myWidgetObj.refreshWidget({

			/** 
			 * Refreshes the Intelligent Offer Recommendations e-Marketing Spot area.
			 * This function is called when a render context changed event is detected. 
			 */
			renderContextChangedHandler: function() {
				myWidgetObj.refreshWidget("refresh", myRCProperties);
			},
			
			/** 
			 * Post handling for the Intelligent Offer Recommendations e-Marketing Spot area.
			 * This function is called after a successful refresh.
			 */
			postRefreshHandler: function() {
				cursor_clear();
				// updateSwatch should be set to true if swatches should be selected by default
				if(myRCProperties.updateSwatch === "true"){
					shoppingActionsJS.updateSwatchListView();
				}
				// need to process cm_cr tags
				cX("onload");
			}
		});
		this.widgetsTotalCount++;
	}
};

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
			if (ii === 0) {
 				rec_part_numbers = a_product_ids[ii];
			} else {
				rec_part_numbers = rec_part_numbers + ',' + a_product_ids[ii];
			}
			
		}
		
		var zoneId = zone.replace(/\s+/g,'');
		wcRenderContext.updateRenderContext('WC_IntelligentOfferESpot_context_ID_' + zoneId, {'partNumbers':rec_part_numbers, 'zoneId': zoneId, 'espotTitle': target_header_txt});
	}
	else{
		var  rec_part_numbers;
		var zoneId = zone.replace(/\s+/g,'');
		target_header_txt = '';
		wcRenderContext.updateRenderContext('WC_IntelligentOfferESpot_context_ID_' + zoneId, {'partNumbers':rec_part_numbers, 'zoneId': zoneId, 'espotTitle': target_header_txt});
	}
};
