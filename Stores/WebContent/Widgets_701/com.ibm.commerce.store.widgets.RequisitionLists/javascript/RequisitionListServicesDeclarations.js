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
 * creating/deleting/updating requisition lists and adding/removing/updating items from a requisition list.
 * @version 1.10
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");

/**
 * This service allows customer to create a new requisition list
 * @constructor
 */
wc.service.declare({
	id:"requisitionListCreate",
	actionId:"requisitionListCreate",
	url:"AjaxRESTRequisitionListCreate",
	formId:""

	 /**
	 * Hides all the messages and the progress bar.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_REQUISITIONLIST_CREATE_SUCCESS"]);
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
 * This service deletes an existing requisition list.
 * @constructor
 */
wc.service.declare({
	id:"AjaxRequisitionListDelete",
	actionId:"AjaxRequisitionListDelete",
	url:"AjaxRESTRequisitionListDelete",
	formId:""

	 /**
	 * Hides all the messages and the progress bar.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_REQUISITIONLIST_DELETE_SUCCESS"]);
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
* This service allows customer to add a requisition list to shopping cart.
* @constructor
*/
wc.service.declare({
	id: "addRequisitionListToCart",
	actionId: "addRequisitionListToCart",
	url: "AjaxRESTRequisitionListSubmit",
	formId: ""

	 /**
	  *  Copies all the items from the existing order to the shopping cart.
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		for (var prop in serviceResponse) {
			console.debug(prop + "=" + serviceResponse[prop]);
		}
		setDeleteCartCookie();
		cursor_clear();
		document.location.href="RESTOrderCalculate?calculationUsage=-1,-2,-3,-4,-5,-6,-7&updatePrices=1&doConfigurationValidation=Y&errorViewName=AjaxOrderItemDisplayView&orderId=.&langId="+serviceResponse.langId+"&storeId="+serviceResponse.storeId+"&catalogId="+serviceResponse.catalogId+"&URL=AjaxCheckoutDisplayView";
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
* This service allows customer to create a requisition list from an existing requisition list.
* @constructor
*/
wc.service.declare({
	id:"requisitionListCopy",
	actionId:"requisitionListCopy",
	url:"AjaxRESTRequisitionListCopy",
	formId:""

	 /**
	* Hides all the messages and the progress bar.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_REQUISITIONLIST_CREATE_SUCCESS"]);
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
			if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
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
})
