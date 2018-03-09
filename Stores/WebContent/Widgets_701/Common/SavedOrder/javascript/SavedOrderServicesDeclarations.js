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
 * @fileOverview This javascript is used by the Saved order details pages to handle the services for 
 * updating saved order info and adding/removing/updating items from a saved order.
 * @version 
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");
dojo.require("wc.widget.Tooltip");

/**
 * This service allows customer to update an existing saved order info
 * @constructor
 */
wc.service.declare({
	id:"savedOrderUpdateDescription",
	actionId:"savedOrderUpdateDescription",
	url: getAbsoluteURL() + "AjaxRESTOrderCopy",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["SAVEDORDERINFO_UPDATE_SUCCESS"]);		
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
 * This service removes an item from a saved order.
 * @constructor
 */
wc.service.declare({
	id:"AjaxSavedOrderDeleteItem",
	actionId:"AjaxSavedOrderDeleteItem",
	url: getAbsoluteURL() + "AjaxRESTOrderItemDelete",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["SAVEDORDERITEM_DELETE_SUCCESS"]);		
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
 * Updates an order item in the saved order. 
 * A message is displayed after the service call.  
 * An error message will be displayed otherwise.
 * @constructor
*/
wc.service.declare({
	id: "AjaxSavedOrderUpdateItem",
	actionId: "AjaxSavedOrderUpdateItem",
	url: getAbsoluteURL() + "AjaxRESTOrderItemUpdate",
	formId: ""
	
	/**
     * Hides all messages and the progress bar
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
			if (serviceResponse.errorCode == "CMN1654E") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]);
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
* This service adds an item to a saved order. A message is displayed after the service call.
* The URL "AjaxRESTOrderAddPreConfigurationToCart" is a superset of the URL
* "AjaxRESTOrderItemAdd", allowing dynamic kit partnumbers to be added to the saved order.
* @constructor
*/
wc.service.declare({
	id: "AjaxAddOrderItem",
	actionId: "AjaxAddOrderItem",
	url: getAbsoluteURL() + "AjaxRESTOrderAddPreConfigurationToCart",
	formId: ""
	
	/**
     * Hides all messages and the progress bar
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(MessageHelper.messages["SAVEDORDERITEM_ADD_SUCCESS"]);
		cursor_clear();
	}

    /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_CONTRACT_EXPIRED"]);
			} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_RETRIEVE_PRICE"]);
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
 * Set the current order to be that of a saved order.
 * Perform the service or command call.
 */
wc.service.declare({
	id: "AjaxSetPendingOrder",
	actionId: "AjaxSetPendingOrder",
	url: "AjaxRESTSetPendingOrder",
	formId: ""

 /**
 * display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_SET_AS_CURRENT_SUCCESS"]);
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
 * Updates the currently selected saved order setting it to the current shopping cart.
 * The main function of this service is to keep the cpendorder database table in line with the current shopping cart.
 * Perform the service or command call.
 * @constructor
 */
wc.service.declare({
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
		
		MessageHelper.hideAndClearMessage();
		
		if (serviceResponse.nextAction != 'undefined' && serviceResponse.nextAction != null && serviceResponse.nextAction)
		{
			document.location.href = SavedOrderItemsJS.getCurrentShoppingCartURL();
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
				 MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_NOT_SET_CURRENT"]);
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
