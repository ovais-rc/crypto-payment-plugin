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
 * @fileOverview This javascript is used by the Saved Order List pages to handle the services for 
 * creating/deleting/updating saved orders and adding/removing/updating items from a saved order.
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * This service allows customer to create a new saved order
 * @constructor
 */
wc.service.declare({
	id:"AjaxOrderCreate",
	actionId:"AjaxOrderCreate",
	url:"AjaxRESTOrderCreate",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CREATE_SUCCESS"]);
		
		var firstSavedOrderId = SavedOrderListJS.getFirstSavedOrderIdFromList();
		if (firstSavedOrderId == null) {
			SavedOrderListJS.setNewOrderId(serviceResponse.outOrderId);
		}
	}
		
	/**
     * Display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
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
 * This service deletes an existing saved order.
 * @constructor
 */
wc.service.declare({
	id:"AjaxSingleOrderCancel",
	actionId:"AjaxSingleOrderCancel",
	url:"AjaxRESTOrderCancel",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_DELETE_SUCCESS"]);		

		//set the SavedOrderListJS.currentOrderDeleted flag to true if the current order was deleted.
		var deletedOrderId = serviceResponse.orderId;
		var currentOrderId = SavedOrderListJS.getCurrentOrderId();
		if (currentOrderId == deletedOrderId) {
			SavedOrderListJS.setCurrentOrderDeleted(true);
		} 
	}
		
	/**
     * Display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
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
* This service allows customer to create a saved order from an existing order.
* @constructor
*/
wc.service.declare({
	id:"AjaxSingleOrderCopy",
	actionId:"AjaxSingleOrderCopy",
	url:"AjaxRESTOrderCopy",
	formId:""

	 /**
    * Hides all the messages and the progress bar.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
	,successHandler: function(serviceResponse) {
		var params = {};
		params["storeId"] = SavedOrderListJS.storeId;
		params["catalogId"]	= SavedOrderListJS.catalogId;
		params["langId"] = SavedOrderListJS.langId;
		params["updatePrices"] = "1";
		params["orderId"] = serviceResponse.orderId;
		params["calculationUsageId"] = "-1";
		
		wc.service.invoke("AjaxSingleOrderCalculate", params);
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_COPY_SUCCESS"]);
	}
		
	/**
    * Display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			 if (serviceResponse.errorCode == "CMN0409E")
			 {
				 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_COPY_FAIL"]);
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
wc.service.declare({
	id: "AjaxSingleOrderCalculate",
	actionId: "AjaxSingleOrderCalculate",
	url: "AjaxRESTOrderCalculate",
	formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CALCULATE_SUCCESS"]);
		cursor_clear();
	}

 /**
 * Display an error message
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
})

/**
 * Invokes the order unlock action.
 * Perform the service or command call.
 */
wc.service.declare({
	id: "AjaxRESTOrderUnlockOnBehalf",
	actionId: "AjaxRESTOrderUnlockOnBehalf",
	url: "AjaxRESTOrderUnlockOnBehalf",
	formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_UNLOCK_SUCCESS"]);
		cursor_clear();
	}

 /**
 * Display an error message
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
})

/**
 * Invokes the order unlock action.
 * Perform the service or command call.
 */
wc.service.declare({
	id: "AjaxRESTOrderLockOnBehalf",
	actionId: "AjaxRESTOrderLockOnBehalf",
	url: "AjaxRESTOrderLockOnBehalf",
	formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_LOCK_SUCCESS"]);
		cursor_clear();
	}

 /**
 * Display an error message
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
})

/**
 * Invokes the order lock take over action.
 * Perform the service or command call.
 */
wc.service.declare({
	id: "AjaxRESTOrderLockTakeOverOnBehalf",
	actionId: "AjaxRESTOrderLockTakeOverOnBehalf",
	url: "AjaxRESTOrderLockTakeOverOnBehalf",
	formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_LOCK_SUCCESS"]);
		cursor_clear();
		if (serviceResponse['isCurrentOrder'] !== undefined && serviceResponse['isCurrentOrder'][0] == 'true'){
			document.location.reload();
			//refresh the page to update cart
		}
	}

 /**
 * Display an error message
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
})
