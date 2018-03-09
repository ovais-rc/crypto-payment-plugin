//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2008, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This class contains declarations of AJAX services used by the Madisons store pages.
 */

/**
 * @class This class stores common parameters needed to make the service call.
 */
shoppingActionsServicesDeclarationJS = {
	langId: "-1", /* language of the  store */
	storeId: "", /*numeric unique identifier of the store */
	catalogId: "", /*catalog of the store that is currently in use */

	/**
	 * Sets common parameters used by the services
	 * @param (int) langId The language of the store.
	 * @param (int) storeId The store currently in use.
	 * @param (int) catalogId The catalog of the store currently in use.
	 */
	setCommonParameters:function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
	},

	registerMarketingEvent : function(params) {
		cursor_wait();
		wcService.invoke("AjaxMarketingTriggerInvoke",params);
	}

}

	/**
	 * Add an item to a shopping cart in Ajax mode. A message is displayed after
	 * the service call.
	 * @constructor
	 */
	wcService.declare({
		id: "AddOrderItem",
		actionId: "AddOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderItemAdd",
		formId: ""

     /**
     * display a success message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */

		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			// Do not show this message. When item is added, we open up mini cart to display the currently added item.
			// MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("SHOPCART_ADDED"));
			cursor_clear();
			if(shoppingActionsJS){
				
				var attributes_container = $('div[id^="attrValue_"]');
				
				if (($(".definingAttributes")[0]) != null) {
					var attributes_container = $(".definingAttributes");	
				}
				else if (($(".product_sizes")[0]) != null) {
					var attributes_container = $(".product_sizes");
				}
				else if (($(".product_info")[0]) != null) {
					var attributes_container = $(".product_info");
				}
				
				var attributes = new Array();
				for (var i = 0; i < attributes_container.length; i++) {
					var attribute_selectors = attributes_container[i].querySelectorAll(".dijitSelect");
					for (var j = 0; j < attribute_selectors.length; j++) {
						attributes = attributes.concat(attribute_selectors[j]);
					}
				}
				
				var dijitSelect = new Array();
				for (var i = 0; i < attributes.length; i++) {
					dijitSelect[i] = dijit.registry.byNode(attributes[i]);
				}
				
				var singleSKU = true;
				for(var i=0; i<dijitSelect.length; i++){
					if (dijitSelect[i].options.length > 2)
					{
						singleSKU = false;
					}
				}
				
				if (!singleSKU)
				{
					shoppingActionsJS.selectedAttributes = new Object();
					wcTopic.publish('DefiningAttributes_Resolved_'+shoppingActionsJS.baseCatalogEntryId, shoppingActionsJS.baseCatalogEntryId, -1);
					for(var i=0; i<dijitSelect.length; i++){
						if(dijitSelect[i] != null){
							dijitSelect[i].value = "";
						}
					}
				}
				
			}
			if(typeof(ShipmodeSelectionExtJS)!= null && typeof(ShipmodeSelectionExtJS)!='undefined'){
				ShipmodeSelectionExtJS.setOrderItemId((serviceResponse.orderItem != null && serviceResponse.orderItem[0].orderItemId != null) ? serviceResponse.orderItem[0].orderItemId : serviceResponse.orderItemId);
			}
			wcTopic.publish('ProductAddedToCart');
		}
     /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
			 	if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
			 		MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER"));
 				} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
					var tempString = Utils.getLocalizationMessage("GENERICERR_MAINTEXT", {0:Utils.getLocalizationMessage("GENERICERR_CONTACT_US")});
 					MessageHelper.displayErrorMessage(tempString);
 				} else {
 					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
 				}
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			
			if(serviceResponse.errorCode){
				wcTopic.publish("OrderError",serviceResponse);
			}

			cursor_clear();
		}

	}),
	
	/**
	 * Adds a pre-defined dynamic kit to a shopping cart in Ajax mode. A message is displayed after
	 * the service call.
	 * @constructor
	 */
	wcService.declare({
		id: "AddPreConfigurationToCart",
		actionId: "AddOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderAddPreConfigurationToCart",
		formId: ""

     /**
     * display a success message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */

		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			if(shoppingActionsJS){
				
				var attributes = document.getElementsByName("attrValue");
			
				var singleSKU = true;
				
				for(var i=0; i<attributes.length; i++){
					if (attributes[i].options.length > 1)
					{
						singleSKU = false;
					}
				}
				
				if (!singleSKU)
				{
					shoppingActionsJS.selectedAttributes = new Object();
					for(var i=0; i<attributes.length; i++){
						if(attributes[i] != null){
							attributes[i].value = "";
							attributes[i].onchange();
						}
					}
				}
			}
			if(typeof(ShipmodeSelectionExtJS)!= null && typeof(ShipmodeSelectionExtJS)!='undefined'){
				ShipmodeSelectionExtJS.setOrderItemId(serviceResponse.orderItem[0].orderItemId);
			}
		}
     /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
			 	if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
			 		MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER"));
 				} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
					var tempString = Utils.getLocalizationMessage("GENERICERR_MAINTEXT",{0:Utils.getLocalizationMessage("GENERICERR_CONTACT_US")});
 					MessageHelper.displayErrorMessage(tempString);
 				} else {
 					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
 				}
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	})
