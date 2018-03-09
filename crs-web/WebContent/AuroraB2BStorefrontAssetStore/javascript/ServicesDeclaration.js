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
ServicesDeclarationJS = {
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
	}
}

function nullCartTotalCookie(orderId){
	setCookie("WC_CartTotal_"+orderId, null, {expires: -1, path:'/', domain:cookieDomain});

	var cookies = document.cookie.split(";");
	for (var i = 0; i < cookies.length; i++) {
		var index = cookies[i].indexOf("=");
		var name = cookies[i].substr(0,index);
		var value = cookies[i].substr(index+1)
		name = name.replace(/^\s+|\s+$/g,"");
		value = value.replace(/^\s+|\s+$/g,"");
		if (value == orderId) {
			setCookie(name, null, {expires: -1, path:'/', domain:cookieDomain});
			break;
		}
	}
}

	/**
	* Adds an item to to the wishlist and remove the same item from the shopping
	* cart.
	* @constructor
	 */
	wcService.declare({
		id: "AjaxInterestItemAddAndDeleteFromCart",
		actionId: "AjaxInterestItemAddAndDeleteFromCart",
		url: getAbsoluteURL() + "AjaxInterestItemAdd",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			//Now delete from cart..
			MessageHelper.hideAndClearMessage();
			resetRequest();
			CheckoutHelperJS.deleteFromCart(serviceResponse.orderItemId,true);
			MessageHelper.displayStatusMessage(MessageHelper.messages["WISHLIST_ADDED"]);
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * Add an item to a shopping cart in Ajax mode. A message is displayed after
	 * the service call.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxAddOrderItem",
		actionId: "AjaxAddOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderItemAdd",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */

		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["SHOPCART_ADDED"]);
			cursor_clear();
			if(categoryDisplayJS){

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
					categoryDisplayJS.selectedAttributes = [];
					for(var i=0; i<attributes.length; i++){
						if(attributes[i] != null){
							attributes[i].value = "";
						}
					}
				}
			}
			if(typeof(ShipmodeSelectionExtJS)!= null && typeof(ShipmodeSelectionExtJS)!='undefined'){
				ShipmodeSelectionExtJS.setOrderItemId((serviceResponse.orderItem != null && serviceResponse.orderItem[0].orderItemId != null) ? serviceResponse.orderItem[0].orderItemId : serviceResponse.orderItemId);
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
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_CONTRACT_EXPIRED_GOTO_ORDER"]);
				} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_RETRIEVE_PRICE"]);
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

	}),

   /**
   * Add an item to a shopping cart in non-Ajax mode. Upon a successful request,
   * the shopping cart page is loaded. An error message is displayed otherwise.
   * @constructor
   */
	wcService.declare({
		id: "AjaxAddOrderItem_shopCart",
		actionId: "AjaxAddOrderItem",
		url: getAbsoluteURL() + "AjaxOrderChangeServiceItemAdd",
		formId: ""

	 /**
	 * redirects to the shopping cart page
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			//Now delete from cart..
			document.location.href =  appendWcCommonRequestParameters("AjaxOrderItemDisplayView?storeId=" + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId);
		}
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_CONTRACT_EXPIRED_GOTO_ORDER"]);
				} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_RETRIEVE_PRICE"]);
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

	}),

	/**
	 * Remove an item from shopping cart. A message is displayed after the service
	 * call.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxDeleteOrderItem",
		actionId: "AjaxDeleteOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderItemDelete",
		formId: ""
	/**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["SHOPCART_REMOVEITEM"]);
		}
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
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
	 * Removes an item from shopping cart on the shipping & billing page. A message is displayed after the service call.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxDeleteOrderItemForShippingBillingPage",
		actionId: "AjaxDeleteOrderItemForShippingBillingPage",
		url: getAbsoluteURL() + "AjaxRESTOrderItemDelete",
		formId: ""

		/**
		 * display a success message
		 * @param (object) serviceResponse The service response object, which is the
		 * JSON object returned by the service invocation
		 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["SHOPCART_REMOVEITEM"]);
		}

		/**
		 * display an error message
		 * @param (object) serviceResponse The service response object, which is the
		 * JSON object returned by the service invocation
		 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}
	}),


	/**
	 * Remove an item from shopping cart. A message is only displayed if the service
	 * call returns an error Message. It is used to remove an item from the shopping
	 * cart and add the same item to the wish list.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxDeleteOrderItemFromCart",
		actionId: "AjaxDeleteOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderItemDelete",
		formId: ""
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}


	}),

	/**
	 * Remove an item from shopping cart.
	 * Upon a successful request, this function will load the AjaxOrderItemDisplayView page or the OrderShippingBillingView page depending on what page the service was invoked from.
	 * An error message will be displayed otherwise.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxDeleteOrderItem1",
		actionId: "AjaxDeleteOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderItemDelete",
		formId: ""

	/**
	 *redirect to the Shopping Cart Page
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["SHOPCART_REMOVEITEM"]);
			if (!CheckoutHelperJS.pendingOrderDetailsPage)
			{
				setDeleteCartCookie();
				if(CheckoutHelperJS.shoppingCartPage){

					document.location.href = appendWcCommonRequestParameters("AjaxOrderItemDisplayView?storeId=" + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId);
				}else{
					document.location.href = appendWcCommonRequestParameters("OrderShippingBillingView?storeId=" + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId + "&orderId=" + serviceResponse.orderId);
				}
			}
			else
			{
				cursor_clear();
			}
		}

	/**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),


	/**
	 * This service updates an order item in the shopping cart.
	 * A message is displayed after the service call.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxUpdateOrderItem",
		actionId: "AjaxUpdateOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderItemUpdate",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.hideFormErrorHandle();
			cursor_clear();
		}

	/**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_RETRIEVE_PRICE_QTY_UPDATE"]);
				}
				else{
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
	 * Updates an order item in the shopping cart.
	 * Upon a successful request, this function will load the AjaxOrderItemDisplayView page
	 * An error message will be displayed otherwise.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxUpdateOrderItem1",
		actionId: "AjaxUpdateOrderItem",
		url: getAbsoluteURL() + "AjaxRESTOrderItemUpdate",
		formId: ""
	/**
	 *redirect to the Shopping Cart Page
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			if (!CheckoutHelperJS.pendingOrderDetailsPage)
			{
				if(CheckoutHelperJS.shoppingCartPage){
					document.location.href = appendWcCommonRequestParameters("AjaxOrderItemDisplayView?storeId=" + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId);
				}
			}
			else
			{
				cursor_clear();
			}
		}

	/**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_RETRIEVE_PRICE_QTY_UPDATE"]);
				}
				else{
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

	}),

	/**
	 * This service updates shipping information (shipping mode, shipping address)
	 * for a shopping cart. A message is displayed after the service call.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxUpdateOrderShippingInfo",
		actionId: "AjaxUpdateOrderShippingInfo",
		url: getAbsoluteURL() + "AjaxRESTOrderShipInfoUpdate",
		formId: ""
	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service prepares an order for submission. Upon success, it submits the order.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxPrepareOrderForSubmit",
		actionId: "AjaxPrepareOrderForSubmit",
		url: getAbsoluteURL() + "AjaxRESTOrderPrepare",
		formId: ""

	/**
	 * On success, checkout the order by calling order submit.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			CheckoutHelperJS.setOrderPrepared("true");
			CheckoutHelperJS.checkoutOrder(CheckoutHelperJS.getSavedParameter('tempOrderId'),CheckoutHelperJS.getSavedParameter('tempUserType'),CheckoutHelperJS.getSavedParameter('tempEmailAddresses'),CheckoutHelperJS.getSavedParameter('tempIsQuote'));
		}

	/**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),


	/**
	 * This service submits the order. Upon success, the order billing confirmation
	 * page is shown. A error message is displayed otherwise.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxSubmitOrder",
		actionId: "AjaxSubmitOrder",
		url: getAbsoluteURL() + "AjaxRESTOrderSubmit",
		formId: ""

	/**
	 *redirect to the Order Confirmation page
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			nullCartTotalCookie(serviceResponse.orderId);
			var shipmentTypeId = CheckoutHelperJS.getShipmentTypeId();
			document.location.href = appendWcCommonRequestParameters("OrderShippingBillingConfirmationView?storeId=" + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId + "&orderId=" + serviceResponse.orderId + "&shipmentTypeId=" + shipmentTypeId);
		}

	/**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service submits the quote. Upon success, the quote  confirmation
	 * page is shown. A error message is displayed otherwise.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxSubmitQuote",
		actionId: "AjaxSubmitQuote",
		url: getAbsoluteURL() + "AjaxSubmitQuote",
		formId: ""

   /**
	*redirect to the Quote Confirmation page
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation
	*/
		,successHandler: function(serviceResponse) {
			var redirectURL = "OrderShippingBillingConfirmationView?storeId=" + ServicesDeclarationJS.storeId
			+ "&catalogId=" + ServicesDeclarationJS.catalogId
			+ "&langId=" + ServicesDeclarationJS.langId
			+ "&orderId=" + CheckoutHelperJS.getOrderId()
			+ "&shipmentTypeId=" + CheckoutHelperJS.getShipmentTypeId()
			+ "&isQuote=true"
			+ "&quoteId=" + serviceResponse.outOrderId// outOrderId is the id of the new quote created.

			if(serviceResponse.outExternalQuoteId != undefined && serviceResponse.outExternalQuoteId != null){
				redirectURL += redirectURL + "&externalQuoteId=" + serviceResponse.outExternalQuoteId;
			}
			document.location.href = appendWcCommonRequestParameters(redirectURL);
		}

   /**
	* display an error message
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation
	*/
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service adds an address for the person. An error message is displayed
	 * if the service failed.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxAddAddressForPerson",
		actionId: "AjaxAddAddressForPerson",
		url: getAbsoluteURL() + "AjaxPersonChangeServiceAddressAdd",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			AddressHelper.updateOrderAfterAddressUpdate();
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service adds an address for the person. An error message is displayed
	 * if the service failed.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxUpdateAddressForPerson",
		actionId: "AjaxUpdateAddressForPerson",
		url: getAbsoluteURL() + "AjaxPersonChangeServiceAddressUpdate",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			AddressHelper.updateOrderAfterAddressUpdate();
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service calls AjaxRESTOrderItemUpdate to update order total after shipping address is updated in the order.
	 */
	wcService.declare({
		id: "AjaxUpdateOrderAfterAddressUpdate",
		actionId: "AjaxUpdateOrderAfterAddressUpdate",
		url: getAbsoluteURL() + "AjaxRESTOrderItemUpdate",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}

	/**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service adds an item to the wishlist. This is different from
	 * AjaxInterestItemAddAndDeleteFromCart in that this function does not remove
	 * the item from the shopping cart. It is used mainly in catalog browsing.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxInterestItemAdd",
		actionId: "AjaxInterestItemAdd",
		url: getAbsoluteURL() + "AjaxInterestItemAdd",
		formId: ""
	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			MessageHelper.displayStatusMessage(MessageHelper.messages["WISHLIST_ADDED"]);
			if(categoryDisplayJS)
			categoryDisplayJS.selectedAttributes = [];
		}
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service adds an item to the wishlist in non-Ajax mode. Upon success,
	 * the shopping cart page is displayed. This is different from
	 * AjaxInterestItemAddAndDeleteFromCart in that this function does not remove
	 * the item from the shopping cart. It is used mainly in catalog browsing.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxInterestItemAdd_shopCart",
		actionId: "AjaxInterestItemAdd",
		url: getAbsoluteURL() + "AjaxInterestItemAdd",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			document.location.href = appendWcCommonRequestParameters("AjaxOrderItemDisplayView?storeId=" + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId);
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

  /**
   * This service deletes an item from the wish list. An error message will be
   * displayed if the service call failed.
   */
	wcService.declare({
		id: "AjaxInterestItemDelete",
		actionId: "AjaxInterestItemDelete",
		url: getAbsoluteURL() + "AjaxInterestItemDelete",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service sends the wish list to a specified email address.
	 */
	wcService.declare({
		id: "AjaxInterestItemListMessage",
		actionId: "AjaxInterestItemListMessage",
		url: getAbsoluteURL() + "AjaxInterestItemListMessage",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
		}
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service applies the promotion code to the order(s).
	 */
	wcService.declare({
		id: "AjaxPromotionCodeManage",
		actionId: "AjaxPromotionCodeManage",
		url: getAbsoluteURL() + "AjaxRESTPromotionCodeApply",
		formId: ""

    /**
     * hides all the messages and the progress bar
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();

			var params = [];
			
			params.storeId		= ServicesDeclarationJS.storeId;
			params.catalogId	= ServicesDeclarationJS.catalogId;
			params.langId		= ServicesDeclarationJS.langId;
			params.orderItemId 	= "";
			params.orderId = serviceResponse.orderId;
			if(CheckoutHelperJS.shoppingCartPage){	
				params.calculationUsage = "-1,-2,-5,-6,-7";
			}else{
				params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
			}
			params.calculateOrder = "1";
			
			wcService.invoke("AjaxUpdateOrderItem",params);
			
		}

     /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service applies the promotion code to the order(s).
	 */
	wcService.declare({
		id: "AjaxPromotionCodeDelete",
		actionId: "AjaxPromotionCodeManage",
		url: getAbsoluteURL() + "AjaxRESTPromotionCodeRemove",
		formId: ""

    /**
     * hides all the messages and the progress bar
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();

			var params = [];
			
			params.storeId		= ServicesDeclarationJS.storeId;
			params.catalogId	= ServicesDeclarationJS.catalogId;
			params.langId		= ServicesDeclarationJS.langId;
			params.orderItemId 	= "";
			params.orderId = serviceResponse.orderId;
			if(CheckoutHelperJS.shoppingCartPage){	
				params.calculationUsage = "-1,-2,-5,-6,-7";
			}else{
				params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
			}
			params.calculateOrder = "1";
			
			wcService.invoke("AjaxUpdateOrderItem",params);
			
		}

     /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

  /**
   * This services adds or removes a coupon from the order(s).
   */
	wcService.declare({
		id: "AjaxCouponsAdd",
		actionId: "AjaxCouponsAddRemove",
		url: getAbsoluteURL() + "AjaxRESTCouponsAdd",
		formId: ""

    /**
     * Hides all the messages and the progress bar. It will then called the
     * AjaxRESTOrderItemUpdate service
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
      */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			
			var params = [];
			
			params.storeId		= ServicesDeclarationJS.storeId;
			params.catalogId	= ServicesDeclarationJS.catalogId;
			params.langId		= ServicesDeclarationJS.langId;
			params.orderItemId	= "";
			params.orderId = serviceResponse.orderId;
			if(CheckoutHelperJS.shoppingCartPage){	
				params.calculationUsage = "-1,-2,-5,-6,-7";
			}else{
				params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
			}
			params.calculateOrder = "1";
			
			wcService.invoke("AjaxUpdateOrderItem",params);

		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

  /**
   * This services adds or removes a coupon from the order(s).
   */
	wcService.declare({
		id: "AjaxCouponsRemove",
		actionId: "AjaxCouponsAddRemove",
		url: getAbsoluteURL() + "AjaxRESTCouponsRemove",
		formId: ""

    /**
     * Hides all the messages and the progress bar. It will then called the
     * AjaxRESTOrderItemUpdate service
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
      */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			
			var params = [];
			
			params.storeId		= ServicesDeclarationJS.storeId;
			params.catalogId	= ServicesDeclarationJS.catalogId;
			params.langId		= ServicesDeclarationJS.langId;
			params.orderItemId	= "";
			params.orderId = serviceResponse.orderId;
			if(CheckoutHelperJS.shoppingCartPage){	
				params.calculationUsage = "-1,-2,-5,-6,-7";
			}else{
				params.calculationUsage = "-1,-2,-3,-4,-5,-6,-7";
			}
			params.calculateOrder = "1";
			
			wcService.invoke("AjaxUpdateOrderItem",params);

		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

	/**
	 * This service adds a billing address to the order(s).
	 */
	wcService.declare({
		id: "AddBillingAddress",
		actionId: "AddBillingAddress",
		url: getAbsoluteURL() + "AjaxPersonChangeServiceAddressAdd",
		formId: ""

	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	}),

/**
 * This service schedules an order based on the input order date and order interval parameters.
 */
wcService.declare({
	id: "ScheduleOrder",
	actionId: "ScheduleOrder",
	url: getAbsoluteURL() + "AjaxRESTScheduleOrder",
	formId: ""

	/**
	 * Hides all the messages and the progress bar.
	 * Constructs a URL that deletes the current order and forward to the order confirmation page.
	 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		var originalOrderId = document.getElementById("orderIdToSchedule").value;
		var newOrderId = serviceResponse.orderId;
		nullCartTotalCookie(serviceResponse.orderId);
		var shipmentTypeId = CheckoutHelperJS.getShipmentTypeId();
		var purchaseOrderNumber = "";
		if(document.forms["purchaseOrderNumberInfo"].purchase_order_number.value != null){
			purchaseOrderNumber = document.forms["purchaseOrderNumberInfo"].purchase_order_number.value;
		}
		var url = "RESTOrderCancel?orderId=" + originalOrderId + "&storeId="  + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId + "&URL=OrderShippingBillingConfirmationView%3ForderId%3D" + newOrderId + "%26originalOrderId%3D" + originalOrderId + "%26shipmentTypeId%3D" + shipmentTypeId + "%26purchaseOrderNumber%3D" + purchaseOrderNumber;
		document.location.href = appendWcCommonRequestParameters(url);
	}

	/**
	 * Displays an error message if the the service call failed.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}
}),

/**
 * This service schedules an order based on the input order date and order interval parameters.
 */
wcService.declare({
	id: "SubmitRecurringOrder",
	actionId: "SubmitRecurringOrder",
	url: getAbsoluteURL() + "AjaxRESTSubmitRecurringOrSubscription",
	formId: ""

	/**
	 * Hides all the messages and the progress bar.
	 * Constructs a URL that deletes the current order and forward to the order confirmation page.
	 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		nullCartTotalCookie(serviceResponse.orderId);
		var shipmentTypeId = CheckoutHelperJS.getShipmentTypeId();
		var url = "OrderShippingBillingConfirmationView?storeId=" + ServicesDeclarationJS.storeId + "&catalogId=" + ServicesDeclarationJS.catalogId + "&langId=" + ServicesDeclarationJS.langId + "&orderId=" + serviceResponse.orderId + "&shipmentTypeId=" + shipmentTypeId;
		document.location.href = appendWcCommonRequestParameters(url);
		cursor_clear();
	}

	/**
	 * Displays an error message if the the service call failed.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}
}),

/**
 * This service updates the free gift choices made by the shopper for the
 * promotion.
 */
wcService.declare({
	id: "AjaxUpdateRewardOption",
	actionId: "AjaxUpdateRewardOption",
	url: getAbsoluteURL() + "AjaxRESTOrderRewardOptionUpdate",
	formId: ""

/**
 * Hides all the messages and the progress bar.
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();

	}
 /**
 * Display an error message.
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		}
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}

}),

	/**
	 * Create a new saved order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxOrderCreate",
		actionId: "AjaxOrderCreate",
		url: getAbsoluteURL() + "AjaxRESTOrderCreate",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CREATE_SUCCESS"]);

			cursor_clear();

		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {

				 if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CREATE_FAIL"]);
				 }
				 else
				 {
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
	}),

	/**
	 * Cancel a single saved order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxSingleOrderCancel",
		actionId: "AjaxSingleOrderCancel",
		url: getAbsoluteURL() + "AjaxRESTOrderCancel",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_DELETE_SUCCESS"]);
			cursor_clear();
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				 if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_DELETE_FAIL"]);
				 }
				 else
				 {
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
	}),

	/**
	 * Cancel a saved order. This service is used to delete multiple saved orders one at a time.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxOrderCancel",
		actionId: "AjaxOrderCancel",
		url: getAbsoluteURL() + "AjaxRESTOrderCancel",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			if (typeof(savedOrdersJS) != null && typeof(savedOrdersJS) != 'undefined') {
				// Call again to delete any other orders in the list.
				savedOrdersJS.cancelSavedOrder(false);
			}
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				 if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["ORDER_NOT_CANCELLED"]);
				 }
				 else
				 {
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
	}),

	/**
	 * Update the description of a saved order. This service is used to update the description of multiple saved orders one at a time.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxOrderSave",
		actionId: "AjaxOrderSave",
		url: getAbsoluteURL() + "AjaxRESTOrderCopy",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			if (typeof(savedOrdersJS) != null && typeof(savedOrdersJS) != 'undefined') {
				// Call again to delete any other orders in the list.
				savedOrdersJS.saveOrder(false);
			}
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				 if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["ORDER_NOT_SAVED"]);
				 }
				 else
				 {
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
	}),

	/**
	 * Set the current order to be that of a saved order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxSetPendingOrder",
		actionId: "AjaxSetPendingOrder",
		url: getAbsoluteURL() + "AjaxRESTSetPendingOrder",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */

		,successHandler: function(serviceResponse) {

			MessageHelper.hideAndClearMessage();

			MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_SET_AS_CURRENT_SUCCESS"]);
			
			if (typeof(savedOrdersJS) != null && typeof(savedOrdersJS) != 'undefined') {
				savedOrdersJS.determinePageForward("AjaxSetPendingOrder");
			}

			cursor_clear();

		}
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				 if (serviceResponse.errorCode == "CMN0409E" || serviceResponse.errorCode == "CMN1024E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_SET_AS_CURRENT_FAIL"]);
				 }
				 else
				 {
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

	}),


	/**
	 * Updates the current pending order setting it to the current shopping cart.
	 * This service does not cause a refresh of the ListOrdersDisplay_Controller registered widgets.
	 * The main function of this service is to keep the cpendorder database table in line with the current shopping cart.
	 * Perform the service or command call.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxUpdatePendingOrder",
		actionId: "AjaxUpdatePendingOrder",
		url: getAbsoluteURL() + "AjaxRESTSetPendingOrder",
		formId: ""

	 /**
	 * There is nothing to do in the event of a success of this service since it is executed in the background.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */

		,successHandler: function(serviceResponse) {
			if (typeof(savedOrdersJS) != null && typeof(savedOrdersJS) != 'undefined') {
				savedOrdersJS.determinePageForward("AjaxUpdatePendingOrder");
			}
			cursor_clear();

		}
	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["ORDER_NOT_SET_CURRENT"]);
				 }
				 else
				 {
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

	}),

	/**
	 * Copy a saved order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxSingleOrderCopy",
		actionId: "AjaxSingleOrderCopy",
		url: getAbsoluteURL() + "AjaxRESTOrderCopy",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */

		,successHandler: function(serviceResponse) {

		var params = [];

		params.storeId		= this.storeId;
		params.catalogId	= this.catalogId;
		params.langId		= this.langId;
		params.URL="";
		params.updatePrices = "1";

		params.orderId = serviceResponse.orderId;
		params.calculationUsageId = "-1";

		wcService.invoke("AjaxSingleOrderCalculate", params);
			MessageHelper.hideAndClearMessage();

		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				 if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["ORDER_NOT_COPIED"]);
				 }
				 else
				 {
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

	}),

	/**
	 * Copy a saved order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxOrderCopy",
		actionId: "AjaxOrderCopy",
		url: getAbsoluteURL() + "AjaxRESTOrderCopy",
		formId: ""

	/**
	* display a success message
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation
	*/

		,successHandler: function(serviceResponse) {

		var params = [];

		params.storeId		= ServicesDeclarationJS.storeId;
		params.catalogId	= ServicesDeclarationJS.catalogId;
		params.langId		= ServicesDeclarationJS.langId;
		params.URL="";
		params.updatePrices = "1";

		params.orderId = serviceResponse.orderId;
		params.calculationUsageId = "-1";

		wcService.invoke("AjaxOrderCalculate", params);
			MessageHelper.hideAndClearMessage();

		}

	/**
	* display an error message
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation
	*/
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				 if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["ORDER_NOT_COPIED"]);
				 }
				 else
				 {
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

	}),

	/**
	 * Perform the order calculation operations to compute the contract prices for the order items in an order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxSingleOrderCalculate",
		actionId: "AjaxSingleOrderCalculate",
		url: getAbsoluteURL() + "AjaxRESTOrderCalculate",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */

		,successHandler: function(serviceResponse) {

			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CALCULATE_SUCCESS"]);
			cursor_clear();
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CALCULATE_FAIL"]);
				 }
				 else
				 {
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

	}),

	/**
	 * Perform the order calculation operations to compute the contract prices for the order items in an order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxCurrentOrderCalculate",
		actionId: "AjaxCurrentOrderCalculate",
		url: getAbsoluteURL() + "AjaxRESTOrderCalculate",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */

		,successHandler: function(serviceResponse) {

			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["ORDER_SET_CURRENT"]);
			cursor_clear();
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["ORDER_NOT_COPIED"]);
				 }
				 else
				 {
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

	}),

	/**
	 * Perform the order calculation operations to compute the contract prices for the order items in an order.
	 * Perform the service or command call.
	 */
	wcService.declare({
		id: "AjaxOrderCalculate",
		actionId: "AjaxOrderCalculate",
		url: getAbsoluteURL() + "AjaxRESTOrderCalculate",
		formId: ""

	 /**
	 * display a success message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */

		,successHandler: function(serviceResponse) {

			MessageHelper.hideAndClearMessage();
			if (typeof(savedOrdersJS) != null && typeof(savedOrdersJS) != 'undefined') {
				// Call again to copy any other orders in the list.
				savedOrdersJS.copyOrder(false);
			}
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
				if (serviceResponse.errorCode == "CMN0409E")
				 {
					 MessageHelper.displayErrorMessage(MessageHelper.messages["ORDER_NOT_COPIED"]);
				 }
				 else
				 {
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

	}),


	/**
	 * Processes a punchout payment request.
	 */
	wcService.declare({
		id: "AjaxPunchoutPay",
		actionId: "AjaxPunchoutPay",
		url: "AjaxRESTOrderRePay",
		formId: ""

		/**
		 * Calls PunchoutJS.handleResponse to render the punchout payment section on the page.
		 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
		 */
		,successHandler: function(serviceResponse) {
			PunchoutJS.handleResponse(serviceResponse.orderId);
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}

		/**
		 * Displays an error message on the page if the request failed.
		 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
		 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} else {
				if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				}
			}
			cursor_clear();
		}
	}),


	/**
	 * Subscribes to or unsubscribes from receiving information related to a particular category in the store.
	 */
	wcService.declare({
		id: "AjaxCategorySubscribe",
		actionId: "AjaxCategorySubscribe",
		url: "AjaxRESTMarketingTriggerProcessServiceEvaluate",
		formId: ""

		/**
		 * Clear messages on the page.
		 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
		 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			MessageHelper.displayStatusMessage(MessageHelper.messages["SUBSCRIPTION_UPDATED"]);
		}

		/**
		 * Displays an error message on the page if the request failed.
		 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
		 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			} else {
				if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				}
			}
			cursor_clear();
		}
	}),

	/**
	 * Registers a marketing event for input parameters
	 */
	wcService.declare({
		id: "AjaxMarketingTriggerInvoke",
		actionId: "AjaxMarketingTriggerInvoke",
		url: "AjaxRESTMarketingTriggerProcessServiceEvaluate",
		formId: ""

		/**
		 * Clear messages on the page.
		 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
		 */
		,successHandler: function(serviceResponse) {
			console.debug("marketing event logged");
		}

		/**
		 * Displays an error message on the page if the request failed.
		 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
		 */
		,failureHandler: function(serviceResponse) {
			console.debug("marketing event logging failed");
		}
	})
