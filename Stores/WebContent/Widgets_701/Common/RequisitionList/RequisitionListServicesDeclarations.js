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
 * @fileOverview This javascript is used by the Requisition List pages to handle the services for 
 * adding/removing/updating items from a requisition list.
 * @version 1.10
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * This service allows customer to update an existing requisition list
 * @constructor
 */
wc.service.declare({
	id:"requisitionListUpdate",
	actionId:"requisitionListUpdate",
	url:"AjaxRESTRequisitionListUpdate",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		requestSubmitted = false;
		document.location.href="RequisitionListDetailView?storeId="+serviceResponse.storeId+"&langId="+serviceResponse.langId+"&catalogId="+serviceResponse.catalogId+"&requisitionListId="+serviceResponse.requisitionListId+"&createdBy="+serviceResponse.createdBy;				
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
 * This service allows customer to create add/update an item to an existing requisition list
 * @constructor
 */
wc.service.declare({
	id:"requisitionListAddItem",
	actionId:"requisitionListAddItem",
	url:"AjaxRESTRequisitionListItemUpdate",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		
		if(serviceResponse.operation == "addItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ADD_SUCCESS"]);
		} else if (serviceResponse.operation == "deleteItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ITEM_DELETE_SUCCESS"]);
		} else if (serviceResponse.operation == "updateQty") {
			ReqListItemsJS.showUpdatedMessage(serviceResponse.row);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			var errorMsg = serviceResponse.errorMessage;
			//If the errorMessage param is the generic error message
			//Display the systemMessage instead
			if (errorMsg.search("CMN1009E") !=-1 ) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
			}else if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					if (serviceResponse.errorMessageKey!=null) {
						var msgKey = serviceResponse.errorMessageKey;
						if (msgKey == '_ERR_GETTING_SKU' || msgKey =='_ERR_PROD_NOT_EXISTING') {
							MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
						}else {
							MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
						}
					}else{					
						MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
					}
				} else {
					//If systemMessage is empty, then just display the generic error message
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
			} else {
				//If errorMessage is not generic, display errorMessage
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
 * This service allows customer to create update an item in an existing requisition list
 * @constructor
 */
wc.service.declare({
	id:"requisitionListUpdateItem",
	actionId:"requisitionListUpdateItem",
	url:"AjaxRESTRequisitionListUpdateItem",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		if(serviceResponse.operation == "addItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ADD_SUCCESS"]);
		} else if (serviceResponse.operation == "deleteItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ITEM_DELETE_SUCCESS"]);
		} else if (serviceResponse.operation == "updateQty") {
			ReqListItemsJS.showUpdatedMessage(serviceResponse.row);
		}
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			var errorMsg = serviceResponse.errorMessage;
			//If the errorMessage param is the generic error message
			//Display the systemMessage instead
			if (errorMsg.search("CMN1009E") !=-1 ) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
			}else if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					if (serviceResponse.errorMessageKey!=null) {
						var msgKey = serviceResponse.errorMessageKey;
						if (msgKey == '_ERR_GETTING_SKU' || msgKey =='_ERR_PROD_NOT_EXISTING') {
							MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
						}else {
							MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
						}
					}else{					
						MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
					}
				} else {
					//If systemMessage is empty, then just display the generic error message
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
			} else {
				//If errorMessage is not generic, display errorMessage
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	},			
}),

/**
 * This service allows customer to delete an item to an existing requisition list
 * @constructor
 */
wc.service.declare({
	id:"requisitionListDeleteItem",
	actionId:"requisitionListDeleteItem",
	url:"AjaxRESTRequisitionListItemDelete",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		if (serviceResponse.operation == "deleteItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ITEM_DELETE_SUCCESS"]);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			var errorMsg = serviceResponse.errorMessage;
			//If the errorMessage param is the generic error message
			//Display the systemMessage instead
			if (errorMsg.search("CMN1009E") !=-1 ) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
			}else if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					if (serviceResponse.errorMessageKey!=null) {
						var msgKey = serviceResponse.errorMessageKey;
						if (msgKey == '_ERR_GETTING_SKU' || msgKey =='_ERR_PROD_NOT_EXISTING') {
							MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
						}else {
							MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
						}
					}else{					
						MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
					}
				} else {
					//If systemMessage is empty, then just display the generic error message
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
			} else {
				//If errorMessage is not generic, display errorMessage
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
 * this services allows users to submit a requisition list for order processing.
 */
wc.service.declare({
	id:"requisitionListAjaxPlaceOrder",
	actionId:"AjaxAddOrderItem",
	url:"AjaxRESTRequisitionListSubmit",
	formId:""

	 /**
    * Hides all the messages and the progress bar, and redirect to the shopping cart page 
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		document.location.href="RESTOrderCalculate?calculationUsage=-1,-2,-3,-4,-5,-6,-7&updatePrices=1&doConfigurationValidation=Y&errorViewName=AjaxOrderItemDisplayView&orderId=.&langId="+serviceResponse.langId+"&storeId="+serviceResponse.storeId+"&catalogId="+serviceResponse.catalogId+"&URL=AjaxOrderItemDisplayView";
	}	
	/**
    * display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
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
		 } else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
}), 

/**
* Add an item to a shopping cart in Ajax mode. A message is displayed after the service call.
* The URL "AjaxRESTOrderAddPreConfigurationToCart" is a superset of the URL
* "AjaxRESTOrderItemAdd", allowing dynamic kit partnumbers to be entered into the quick order form.
*/
wc.service.declare({
		id: "ReqListAddOrderItem",
		actionId: "AddOrderItem",
		url: "AjaxRESTOrderAddPreConfigurationToCart",
		formId: ""
		
		/**
		* display a success message
		* @param (object) serviceResponse The service response object, which is the
		* JSON object returned by the service invocation
		*/
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			// MessageHelper.displayStatusMessage(MessageHelper.messages["ADDED_TO_ORDER"]);
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

	})