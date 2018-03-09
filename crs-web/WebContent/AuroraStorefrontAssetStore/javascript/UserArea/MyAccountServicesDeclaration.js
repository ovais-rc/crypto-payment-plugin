//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript contains declarations of AJAX services used within
 * WebSphere Commerce.
 */

/**
 * @class This class stores common parameters needed to make the service call.
 */
MyAccountServicesDeclarationJS = {
	/* The common parameters used in service calls */
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
	}
}

	/**
	 *  Removes an item from the customer wishlist in Ajax mode.
	 *  @constructor
	 */
	wcService.declare({
		id: "InterestItemDelete",
		actionId: "InterestItemDelete",
		url: "AjaxInterestItemDelete",
		formId: ""

	/**
	 * display a success message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.displayStatusMessage(MessageHelper.messages["WISHLIST_REMOVEITEM"]);
			for (var prop in serviceResponse) {
				console.debug(prop + "=" + serviceResponse[prop]);
			}
			cursor_clear();
		}
	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
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
	 *  Adds an item to the customer wishlist in Ajax mode.
	 *  @constructor
	 */
	wcService.declare({
		id: "AjaxInterestItemAdd",
		actionId: "AjaxInterestItemAdd",
		url: "AjaxInterestItemAdd",
		formId: ""
	/**
	 * display a success message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			MessageHelper.displayStatusMessage(MessageHelper.messages["WISHLIST_ADDED"]);
		}
	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
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
	 *  This service enables the customer to email his/her wishlist.
	 *  @constructor
	 */
	wcService.declare({
		id: "InterestItemListMessage",
		actionId: "InterestItemListMessage",
		url: "AjaxInterestItemListMessage",
		formId: ""

	/**
	 * hdes the progress bar and displays a success message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,successHandler: function(serviceResponse) {
			for (var prop in serviceResponse) {
				console.debug(prop + "=" + serviceResponse[prop]);
			}
			cursor_clear();
		}
	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
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
	 * @constructor
	 */
	wcService.declare({
		id: "AddBillingAddress",
		actionId: "AddBillingAddress",
		url: "AjaxPersonChangeServiceAddressAdd",
		formId: ""

	 /**
	  *	 calls the saveAddress function defined in the AddressHelper class.
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
		,successHandler: function(serviceResponse) {
			resetRequest();
			javascript:AddressHelper.saveAddress('AddShippingAddress','shippingAddressCreateEditFormDiv_1');
		}

	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
						 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				  } else {
						 if (serviceResponse.errorMessageKey) {
								MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
						 }
				  }
		}

	}),

	/**
	 *  This service adds a shipping address to the order(s).
	 *  @constructor
	 */
	wcService.declare({
		id: "AddShippingAddress",
		actionId: "AddShippingAddress",
		url: "AjaxPersonChangeServiceAddressAdd",
		formId: ""

	/**
	 *  redirects to the Shipping and Billing Method page.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,successHandler: function(serviceResponse) {
			//document.location.href=appendWcCommonRequestParameters("OrderShippingBillingView?langId="+MyAccountServicesDeclarationJS.langId+"&storeId="+MyAccountServicesDeclarationJS.storeId+"&catalogId="+MyAccountServicesDeclarationJS.catalogId+"&shipmentType=single&orderPrepare=true");
			CheckoutHelperJS.updateAddressIdForOrderItem(serviceResponse.addressId);
		}

	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessage) {
						 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				  } else {
						 if (serviceResponse.errorMessageKey) {
								MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
						 }
				  }
		}

	}),

  /**
   * This services adds or removes a coupon from the order(s).
   * @constructor
   */
	wcService.declare({
		id: "AjaxCouponsAddRemove",
		actionId: "AjaxCouponsAddRemove",
		url: "AjaxCouponsAddRemove",
		formId: ""

   /**
	 * Hides all the messages and the progress bar.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}

	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
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
	 * This services deletes a coupon from the wallet.
	 * 
	 * @constructor
	 */
	wcService.declare({
		id : "AjaxRESTWalletCouponsDelete",
		actionId : "AjaxCouponsAddRemove",
		url : "AjaxRESTWalletCouponsDelete",
		formId : ""

		/**
		 * Hides all the messages and the progress bar.
		 * 
		 * @param (object)
		 *            serviceResponse The service response object,
		 *            which is the JSON object returned by the
		 *            service invocation.
		 */
		,
		successHandler : function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
		}

		/**
		 * display an error message.
		 * 
		 * @param (object)
		 *            serviceResponse The service response object,
		 *            which is the JSON object returned by the
		 *            service invocation.
		 */
		,
		failureHandler : function(serviceResponse) {

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
	 * This service adds or removes a wallet item.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxWalletItemProcessServiceDelete",
		actionId: "AjaxWalletItemProcessServiceDelete",
		url: "AjaxWalletItemProcessServiceDelete",
		formId: ""

	/**
	 * Hides all messages and the progress bar.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
	}

	/**
	 * Displays an error message in case of a failure.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
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
	 * This service cancels a subscription.
	 * @constructor
	 */
	wcService.declare({
		id: "AjaxCancelSubscription",
		actionId: "AjaxCancelSubscription",
		url: "AjaxRESTRecurringOrSubscriptionCancel",
		formId: ""

		/**
		 * Clear messages on the page.
		 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
		 */
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
            closeAllDialogs();
			if(serviceResponse.subscriptionType == "RecurringOrder"){
				if(serviceResponse.state == "PendingCancel"){
					MessageHelper.displayStatusMessage(MessageHelper.messages["SCHEDULE_ORDER_PENDING_CANCEL_MSG"]);
				}
				else{
					MessageHelper.displayStatusMessage(MessageHelper.messages["SCHEDULE_ORDER_CANCEL_MSG"]);
				}
			}
			else{
				if(serviceResponse.state == "PendingCancel"){
					MessageHelper.displayStatusMessage(MessageHelper.messages["SUBSCRIPTION_PENDING_CANCEL_MSG"]);
				}
				else{
					MessageHelper.displayStatusMessage(MessageHelper.messages["SUBSCRIPTION_CANCEL_MSG"]);
				}
			}
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
	 *  This service enables customer to Reorder an already existing order.
	 *  @constructor
	 */
	wcService.declare({
		id: "OrderCopy",
		actionId: "OrderCopy",
		url: "AjaxRESTOrderCopy",
		formId: ""

	 /**
	  *  Copies all the items from the existing order to the shopping cart and redirects to the shopping cart page.
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
		,successHandler: function(serviceResponse) {
			for (var prop in serviceResponse) {
				console.debug(prop + "=" + serviceResponse[prop]);
			}
			if (serviceResponse.newOrderItemsCount != null && serviceResponse.newOrderItemsCount<=0){
				MessageHelper.displayErrorMessage(MessageHelper.messages["CANNOT_REORDER_ANY_MSG"]);
			}
			else {
				setDeleteCartCookie();

				var postRefreshHandlerParameters = [];
				var initialURL = "AjaxRESTOrderPrepare";
				var urlRequestParams = [];
				urlRequestParams["orderId"] = serviceResponse.orderId;

				postRefreshHandlerParameters.push({"URL":"AjaxCheckoutDisplayView","requestType":"GET", "requestParams":{}}); 
				var service = getCustomServiceForURLChaining(initialURL,postRefreshHandlerParameters,null);
				wcService.invoke(service.getParam("id"), urlRequestParams);

			}
		}

	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessageKey == "_ERR_PROD_NOT_ORDERABLE") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
			} else if (serviceResponse.errorMessageKey == "_ERR_INVALID_ADDR") {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}else {
				if (serviceResponse.errorMessage) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
				else {
					 if (serviceResponse.errorMessageKey) {
						MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
					 }
				}
			}
			cursor_clear();
		}

	}),

	/**
	 *  This service enables customer to Reorder an already existing order in external system.
	 *  @constructor
	 */
	wcService.declare({
		id: "SSFSOrderCopy",
		actionId: "SSFSOrderCopy",
		url: "AjaxSSFSOrderCopy",
		formId: ""

		 /**
		  *  Copies all the items from the existing order to the shopping cart and redirects to the shopping cart page.
		  *  @param (object) serviceResponse The service response object, which is the
		  *  JSON object returned by the service invocation.
		  */
		,successHandler: function(serviceResponse) {
			for (var prop in serviceResponse) {
				console.debug(prop + "=" + serviceResponse[prop]);
			}

			setDeleteCartCookie();
			document.location.href=appendWcCommonRequestParameters("AjaxCheckoutDisplayView?langId="+MyAccountServicesDeclarationJS.langId+"&storeId="+MyAccountServicesDeclarationJS.storeId+"&catalogId="+MyAccountServicesDeclarationJS.catalogId);
		}

		/**
		* display an error message.
		* @param (object) serviceResponse The service response object, which is the
		* JSON object returned by the service invocation.
		*/
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessageKey == "_ERR_PROD_NOT_ORDERABLE") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
			} else if (serviceResponse.errorMessageKey == "_ERR_INVALID_ADDR") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["INVALID_CONTRACT"]);
			}else {
				if (serviceResponse.errorMessage) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
				else {
					 if (serviceResponse.errorMessageKey) {
						MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
					 }
				}
			}
			cursor_clear();
		}

	}),


	/**
	 *  This service enables customer to Renew a subscription.
	 *  @constructor
	 */
	wcService.declare({
		id: "SubscriptionRenew",
		actionId: "SubscriptionRenew",
		url: "AjaxRESTOrderCopy",
		formId: ""

	 /**
	  *  Copies all the items from the existing subscription to the shopping cart and calls service to update requested shipping date.
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
		,successHandler: function(serviceResponse) {
			for (var prop in serviceResponse) {
				console.debug(prop + "=" + serviceResponse[prop]);
			}

			var params = [];

			params.storeId		= MyAccountServicesDeclarationJS.storeId;
			params.catalogId	= MyAccountServicesDeclarationJS.catalogId;
			params.langId		= MyAccountServicesDeclarationJS.langId;
			params.orderId      = serviceResponse.orderId;
			params.calculationUsage  = "-1,-2,-3,-4,-5,-6,-7";
			params.requestedShipDate = MyAccountDisplay.getSubscriptionDate();

			MyAccountDisplay.subscriptionOrderId = serviceResponse.orderId;
			MyAccountDisplay.subscriptionOrderItemId = serviceResponse.orderItemId[0];

			wcService.invoke("SetRequestedShippingDate",params);
		}

	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessageKey == "_ERR_PROD_NOT_ORDERABLE") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
			} else if (serviceResponse.errorMessageKey == "_ERR_INVALID_ADDR") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["INVALID_CONTRACT"]);
			}else {
				if (serviceResponse.errorMessage) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
				else {
					 if (serviceResponse.errorMessageKey) {
						MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
					 }
				}
			}
			cursor_clear();
		}

	}),


	/**
	 *  This service sets the requested shipping date for a subscription renewal.
	 *  @constructor
	 */
	wcService.declare({
		id: "SetRequestedShippingDate",
		actionId: "SetRequestedShippingDate",
		url: "AjaxRESTOrderShipInfoUpdate",
		formId: ""
	/**
	 * hides all the messages and the progress bar
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,successHandler: function(serviceResponse) {
			cursor_clear();
			document.location.href=appendWcCommonRequestParameters("RESTOrderPrepare?langId="+MyAccountServicesDeclarationJS.langId+"&storeId="+MyAccountServicesDeclarationJS.storeId+"&catalogId="+MyAccountServicesDeclarationJS.catalogId+"&orderId="+serviceResponse.orderId+"&URL=AjaxCheckoutDisplayView?langId="+MyAccountServicesDeclarationJS.langId+"&storeId="+MyAccountServicesDeclarationJS.storeId+"&catalogId="+MyAccountServicesDeclarationJS.catalogId);
		}

	 /**
	 * display an error message
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation
	 */
		,failureHandler: function(serviceResponse) {
			if (serviceResponse.errorMessageKey == "_ERR_ORDER_ITEM_FUTURE_SHIP_DATE_OVER_MAXOFFSET") {
				var params = [];

				params.storeId		= MyAccountServicesDeclarationJS.storeId;
				params.catalogId	= MyAccountServicesDeclarationJS.catalogId;
				params.langId		= MyAccountServicesDeclarationJS.langId;
				params.orderId      = MyAccountDisplay.subscriptionOrderId;
				params.orderItemId      = MyAccountDisplay.subscriptionOrderItemId;
				params.calculationUsage  = "-1,-2,-3,-4,-5,-6,-7";
				wcService.invoke("RemoveSubscriptionItem",params);

				MessageHelper.displayStatusMessage(MessageHelper.messages["CANNOT_RENEW_NOW_MSG"]);
			}
			else{
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
		}

	}),

	/**
	 * This service removes the subscription item from the shopping cart if renewal fails.
	 * @constructor
	 */
	wcService.declare({
		id: "RemoveSubscriptionItem",
		actionId: "RemoveSubscriptionItem",
		url: "AjaxRESTOrderItemDelete",
		formId: ""

		/**
		 * @param (object) serviceResponse The service response object, which is the
		 * JSON object returned by the service invocation.
		 */
		,successHandler: function(serviceResponse) {
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
			if(serviceResponse.errorCode){
				wcTopic.publish("OrderError",serviceResponse);
			}
			cursor_clear();
		}

	}),

/**
 *  This service enables customer to cancel a scheduled order or an order waiting for approval.
 *  @constructor
 */
wcService.declare({
	id: "AjaxScheduledOrderCancel",
	actionId: "AjaxScheduledOrderCancel",
	url: "AjaxRESTRecurringOrSubscriptionCancel",
	formId: ""

	/**
	 * Displays a success message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MO_ORDER_CANCELED_MSG"]);
	}

	/**
	 * Displays an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
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
})
