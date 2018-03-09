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
 * @fileOverview This file contains declarations of refresh controllers used by WebSphere Commerce AJAX services for the shipping and billing pages.
 */

/**
 * @class This class stores the common parameters and functions for the controllers.
 */
SBControllersDeclarationJS = { 

	/** 
	 * This variable stores the true/false value that indicates if the 'SinglePageCheckout' feature is enabled/disabled.
	 * When it is true, both shipping and billing information are captured in a single page. If it is false, checkout will
	 * be a two step process where shipping is captured in first step and billing in second step.
	 * It is set to true by default.
	 * 
	 * @private
	 */
	singlePageCheckout: true,
	
	/**
		* This variable is used to indicate if ShippingChargeType flexflow option is enabled or not.
		*/
	shipChargeEnabled: false,

	 /**
	  * This function sets the URL parameter for a given refresh area.
	  *
	  * @param {String} refreshAreaId The ID of the refresh area of which the URL parameter will be set.
	  * @param {String} url The new URL parameter for the controller.
	  */
	setRefreshURL:function(refreshAreaId, url){
		$("#" + refreshAreaId).attr("refreshurl", url);
	},


	/**
	 * Sets the SinglePageCheckout variable to indicate if the 'SinglePageCheckout' feature is enabled or disabled.
	 * 
	 * @param {Boolean} singlePageCheckout. A true/false value that indicates if the 'SinglePageCheckout' feature is enabled.
	 *
	 * @see CheckoutHelperJS.isSinglePageCheckout
	 */
	setSinglePageCheckout:function(singlePageCheckout){
		this.singlePageCheckout = singlePageCheckout;
	},
	
	
	/**
	 * Returns the singlePageCheckout variable that indicates if the 'SinglePageCheckout' feature is enabled/disabled.
	 * 
	 * @returns {Boolean} singlePageCheckout A true/false value that indicates if the 'SinglePageCheckout' feature is
	 * enabled/disabled.
	 *
	 * @see CheckoutHelperJS.setSinglePageCheckout
	 */
	isSinglePageCheckout:function(){
		return this.singlePageCheckout;
	},
	
	/**
	 * Sets the shipChargeEnabled variable to indicate if the 'ShippingChargeType' feature is enabled.
	 * 
	 * @param {Boolean} enabled A true/false value that indicates if the 'ShippingChargeType' feature is enabled.
	 */
	setShipChargeEnabled:function(enabled){
		this.shipChargeEnabled = enabled;
	}
};


/**
 * Refresh controller declaration for the main page area on the 'Shipping & Billing' page.
 * @constructor
 */
function declareControllerForMainAndAddressDiv() {
	/* this a local context..no need to define URL for this */
	var myWidgetObj = $("#content_wrapper");
	wcRenderContext.addRefreshAreaId("contextForMainAndAddressDiv", "content_wrapper");
	var myRCProperties = wcRenderContext.getRenderContextProperties("contextForMainAndAddressDiv");
	
	myWidgetObj.refreshWidget({
		/**
		 * Calls {@link CheckoutHelperJS.showHideDivs} to display and hide the areas defined in renderContext.
		 */
		renderContextChangedHandler: function() {
			CheckoutHelperJS.showHideDivs(myRCProperties["showArea"],myRCProperties["hideArea"]);
		}
	});

};


/**
 * Refresh controller declaration for the order items area on the single shipment 'Shipping & Billing' page.
 * @constructor
 */
function declareTraditionalShipmentDetailsController() {
	var myWidgetObj = $("#WC_ShipmentDisplay_div_17");
	wcRenderContext.addRefreshAreaId("traditionalShipmentDetailsContext", "WC_ShipmentDisplay_div_17");
	var myRCProperties = wcRenderContext.getRenderContextProperties("traditionalShipmentDetailsContext");
	
	var events = $.extend({}, order_updated,
			{"OrderShippingInfoUpdate": "OrderShippingInfoUpdate"},
			{"AjaxDeleteOrderItemForShippingBillingPage": "AjaxDeleteOrderItemForShippingBillingPage"},
			{"AjaxDeleteOrderItemForShippingBillingPage": "AjaxDeleteOrderItemForShippingBillingPage"},
			{"AjaxPrepareOrderForShipChargeUpdate": "AjaxPrepareOrderForShipChargeUpdate"},
			{"OrderItemAddressShipInstructionsUpdate": "OrderItemAddressShipInstructionsUpdate"},
			{"OrderItemAddressShipInstructionsUpdate1": "OrderItemAddressShipInstructionsUpdate1"},
			{"AjaxAddUnboundPaymentInstructionToThisOrder": "AjaxAddUnboundPaymentInstructionToThisOrder"},
			{"AjaxDeleteUnboundPaymentInstructionFromThisOrder": "AjaxDeleteUnboundPaymentInstructionFromThisOrder"},
			{"OrderItemAddressShipMethodUpdate": "OrderItemAddressShipMethodUpdate"});
	
	/**
	 * Refreshes the item details area with the properties defined in renderContext if the actionId of the input message parameter is from an order update service or if it is 'OrderShippingInfoUpdate'.
	 */
	wcTopic.subscribe(events, function(returnData) {
		myWidgetObj.refreshWidget("refresh", myRCProperties);
		if(returnData.actionId != 'OrderItemAddressShipMethodUpdate') {
			submitRequest(); //Till shop cart is refreshed, do not allow any other requests..
			cursor_wait();
		}
		
	});
	
	myWidgetObj.refreshWidget({
		/**
		 * Refreshes the order item details area with the properties defined in renderContext.
		 */
		renderContextChangedHandler: function() {
			if(wcRenderContext.testForChangedRC("traditionalShipmentDetailsContext", ["beginIndex"])){
				myWidgetObj.refreshWidget("refresh", myRCProperties);
			}
		},
		
		/**
		 * Clears the progress bar after a successful refresh.
		 */
		postRefreshHandler: function() {
			resetRequest(); //Shop cart is refreshed, give the control to shopper...
			cursor_clear();

			if (myRCProperties["initializeJS"] == 'true') {
				$('input[id^="orderItem_"]').each(function(i, orderItem) {
					var initJS = 'addReqListsJS' + orderItem.value + ' = new AddToRequisitionListsJS(' + 
							myRCProperties["storeId"] + ',' + 
							myRCProperties["catalogId"] + ',' +
							myRCProperties["langId"] + ',' +
							'"' + orderItem.value + 'requisitionListContent",' + 
							'"' + orderItem.value + 'requisitionListSelect",' +
							'"' + orderItem.value + 'createNewListMenu",' + 
							'"' + orderItem.value + 'listTypeMenu",' + 
							'"' + orderItem.value + 'newListNameInput",' + 
							'"' + orderItem.value + 'listType",' + 
							'"' + orderItem.value + 'productAdded",' + 
							'"",' + 
							'"AddToRequisitionListsJS' + orderItem.value + '"' + 
							');' + 
							'addReqListsJS' + orderItem.value + '.setCatEntryId("' + $('#catalogId_' + (orderItem.id.substring(orderItem.id.indexOf('_') + 1))).val() + '");';
					eval(initJS);
				});
				$('div[id^="shoppingListScript_"]').each(function(i, node){
					$.globalEval(node.innerHTML);
				});
			}
		}
	});
};


/**
 * Refresh controller declaration for the shipping address area on the single shipment 'Shipping & Billing' page.
 * @constructor
 */
function declareShippingAddressSelectBoxAreaController() {
	var myWidgetObj = $("#shippingAddressSelectBoxArea");
	wcRenderContext.addRefreshAreaId("shippingAddressDropDownBoxContext", "shippingAddressSelectBoxArea");
	var myRCProperties = wcRenderContext.getRenderContextProperties("shippingAddressDropDownBoxContext");
	
	var events = $.extend({}, address_updated, 
			{"AjaxUpdateOrderItemsAddressId": "AjaxUpdateOrderItemsAddressId"},
			{"AddBillingAddressInCheckOut": "AddBillingAddressInCheckOut"});
	
	/**
	 * Refreshes the shipping address area with the properties defined in renderContext.
	 */
	wcTopic.subscribe(events, function(returnData) {
			if (returnData.actionId in address_updated){
				//This means, invokeService for Address Add/Edit has been called..so update our select box area
				wcRenderContext.updateRenderContext('contextForMainAndAddressDiv', {'showArea':'mainContents','hideArea':'editAddressContents'});
				selectedAddressId = returnData.data.addressId;
				myRCProperties.addressId=selectedAddressId;
				if (CheckoutHelperJS.orderItemIds.length != 0) {
					CheckoutHelperJS.updateAddressIdOFItemsOnCreateEditAddress(selectedAddressId[0]);
				}					
				cursor_clear();  
			} else if (returnData.actionId == "AjaxUpdateOrderItemsAddressId"){
				//This means, new shipping address is created / edited and all the items are updated with this new address id
				// and ajax prepare order is called.. we need to update our shipping address drop down...
				myWidgetObj.refreshWidget("refresh", myRCProperties);
				cursor_clear();
			} else if (returnData.actionId == "AddBillingAddressInCheckOut" && 
					returnData.data.addBillingAddressInCheckOutAddressType == 'ShippingAndBilling' &&
					document.getElementById("singleShipmentAddress")){
				myRCProperties.addressId = document.getElementById("singleShipmentAddress").value;
				myWidgetObj.refreshWidget("refresh", myRCProperties);
				cursor_clear();
			}
	});

	myWidgetObj.refreshWidget({
		/**
		 * Sets focus after shipping address is altered.
		 */
		postRefreshHandler: function() {
			if (CheckoutHelperJS.getLastAddressLinkIdToFocus() != null && CheckoutHelperJS.getLastAddressLinkIdToFocus() != 'undefined' && CheckoutHelperJS.getLastAddressLinkIdToFocus() != '') {
				document.getElementById(CheckoutHelperJS.getLastAddressLinkIdToFocus()).focus();
			}
			// Initialize shippingAddressDisplayArea refresh widget
			declareShippingAddressDisplayAreaController();
		}
	});

};


/**
 * Refresh controller declaration for the order totals summary area.
 * @constructor
 */
function declareCurrentOrderTotalsAreaController() {
	var myWidgetObj = $("#WC_ShipmentDisplay_div_18");
	wcRenderContext.addRefreshAreaId("currentOrder_Context", "WC_ShipmentDisplay_div_18");
	var myRCProperties = wcRenderContext.getRenderContextProperties("currentOrder_Context");
	
	/**
	 * Payment type promotion: add message.actionId == 'AjaxPrepareOrderForPaymentSubmit' to cause the order total
	 * to refresh when order prepare is called.
	 */
	var events = $.extend({}, order_updated, 
			{"AjaxDeleteOrderItemForShippingBillingPage": "AjaxDeleteOrderItemForShippingBillingPage"},
			{"OrderItemAddressShipMethodUpdate": "OrderItemAddressShipMethodUpdate"},
			{"AjaxPrepareOrderForShipChargeUpdate": "AjaxPrepareOrderForShipChargeUpdate"},
			{"OrderItemAddressShipInstructionsUpdate": "OrderItemAddressShipInstructionsUpdate"},
			{"OrderItemAddressShipInstructionsUpdate1": "OrderItemAddressShipInstructionsUpdate1"},
			{"AjaxUpdateOrderAfterAddressUpdate": "AjaxUpdateOrderAfterAddressUpdate"},
			{"AjaxAddShippingAndBillingAddressForPersonDuringCheckout": "AjaxAddShippingAndBillingAddressForPersonDuringCheckout"},
			{"AjaxPrepareOrderForPaymentSubmit": "AjaxPrepareOrderForPaymentSubmit"});
	
	/**
	 * Refreshes the area with the properties defined in renderContext if the actionId of the input message is from an order update service.
	 */
	wcTopic.subscribe(events, function(returnData) {
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});
	
	myWidgetObj.refreshWidget({
		/**
		 * Updates the display style of relevant sections on the page after a successful refresh.
		 */
		postRefreshHandler: function() {
			// Order level discount tooltip section - if the tooltip is defined, show the section after area is refreshed
			if($("#discountDetailsSection").length )  {
				$("#discountDetailsSection").css("display", "block");
			}
			
			// Promotion code tooltip section - if the tooltip is defined, show the section after area is refreshed
			if($("#appliedPromotionCodes").length ) {
				$("#appliedPromotionCodes").css("display", "block");
			}		
		}
	});
};

/**
 * Refresh controller declaration for the shipping charge area in a single shipment check-out scenario.
 * @constructor
 */
function declareSingleShipmentShipChargeController() {
	var myWidgetObj = $("#WC_SingleShipmentDisplay_ShipCharge_Area");
	wcRenderContext.addRefreshAreaId("singleShipmentShipChargeContext", "WC_SingleShipmentDisplay_ShipCharge_Area");
	var myRCProperties = wcRenderContext.getRenderContextProperties("singleShipmentShipChargeContext");
	
	/**
	 * Only refresh this area when shipping method is updated
	 */
	wcTopic.subscribe(["OrderItemAddressShipMethodUpdate"], function() {
		if (SBControllersDeclarationJS.shipChargeEnabled) {
			myWidgetObj.refreshWidget("refresh", myRCProperties);
		}
	});
	
	myWidgetObj.refreshWidget({
		/**
		 * Clears the progress bar after a successful refresh.
		 */
		postRefreshHandler: function() {
			cursor_clear();
		}
	});
};

/**
 * Refresh controller declaration for the billing address area.
 * @constructor
 */
function declareBillingAddressSelectBoxAreaController(widgetId) {
	if(typeof widgetId == "object" || typeof widgetId == "array") {
		widgetId = widgetId[0];
	}
	
	var myWidgetObj = $("#" + widgetId);
	wcRenderContext.addRefreshAreaId("billingAddressDropDownBoxContext", widgetId);
	var myRCProperties = wcRenderContext.getRenderContextProperties("billingAddressDropDownBoxContext");
	
	/**
	 * This function refreshes the billing address area with the properties defined in renderContext if the actionId of the input message parameter is AddBillingAddressInCheckOut or AjaxUpdateAddressForPerson.
	 */
	wcTopic.subscribe(["AddBillingAddressInCheckOut","UpdateBillingAddressInCheckout","AjaxUpdateAddressForPerson",
	                   "AjaxAddShippingAndBillingAddressForPersonDuringCheckout","AjaxUpdateShippingAndBillingAddressForPersonDuringCheckout"], function(returnData) {
		//If we are creating a new billing address or editing the existing address, then we should update our billing address drop down box area...
		//Make sure that even after we refresh the billing address drop down box, we pre-select the previously selected address for user...
		var objectId = myWidgetObj.attr("objectId");
		var addressId = myRCProperties["billingAddress"+objectId];
		if (myRCProperties["paymentTCId"+objectId] == "") {
			myWidgetObj.refreshWidget("updateUrl", myRCProperties["billingURL"+objectId]);
		} else {
			myWidgetObj.refreshWidget("updateUrl", myRCProperties["billingURL"+objectId]+"&paymentTCId="+myRCProperties["paymentTCId"+objectId]);
		}
		if(myRCProperties["billingAddress"+objectId] == -1){
			//Create address was selected from this billing drop down..so this drop down box should have new address selected by default...
			addressId = returnData.data.addressId;
			myWidgetObj.refreshWidget("refresh", {"paymentAreaNumber":objectId,"selectedAddressId":addressId,"paymentMethodSelected":myRCProperties["payment"+objectId]});
			myRCProperties["billingAddress"+objectId] = addressId;
			// Mark this address for update
			if(objectId <= CheckoutPayments.numberOfPaymentMethods){
				CheckoutPayments.updatePaymentObject(objectId, 'billing_address_id');
			}
		}
		else if(myRCProperties["billingAddress"+objectId] == 0){
			//Means user has not yet touched this select box..don't try to select anything...
			myWidgetObj.refreshWidget("refresh", {"paymentAreaNumber":objectId,"paymentMethodSelected":myRCProperties["payment"+objectId]});
		}
		else{
			// User changed the select box selection
			if (document.getElementById("singleShipmentAddress")) {
				// Applies to single shipment only
				shippingAddressId = document.getElementById("singleShipmentAddress").value;
				billingAddressId = document.getElementById("billing_address_id_" + objectId).value;
				if (shippingAddressId == billingAddressId && objectId <= CheckoutPayments.numberOfPaymentMethods) {
					//If shipping and billing addresses are the same and we are updating the address(updated address will have new id), 
					//widget refresh should be based on the new addressId, not the old one. 
					//However, we should ignore the case that adding address from shipping address section 
					if (returnData.data.originalServiceId != "AjaxAddAddressForPerson"){
						addressId = returnData.data.addressId;
					}
				}
			}
			myWidgetObj.refreshWidget("refresh", {"paymentAreaNumber":objectId,"selectedAddressId":addressId,"paymentMethodSelected":myRCProperties["payment"+objectId]});
			// Mark this address for update
			if(objectId <= CheckoutPayments.numberOfPaymentMethods){
				CheckoutPayments.updatePaymentObject(objectId, 'billing_address_id');
			}
		}
	});
	
	myWidgetObj.refreshWidget({
		/**
		 * Refreshes the Billing Address dropdown box with addresses corresponding to the newly selected payment method.
		 * 
		 * @param {Object} message The render context changed event message.
		 */
		renderContextChangedHandler: function() {
			var objectId = myWidgetObj.attr("objectId");
			if(wcRenderContext.testForChangedRC("billingAddressDropDownBoxContext",["payment"+objectId]) || wcRenderContext.testForChangedRC("billingAddressDropDownBoxContext",["paymentTCId"+objectId])){
				if (myRCProperties["paymentTCId"+objectId] == "") {
					myWidgetObj.refreshWidget("updateUrl", myRCProperties["billingURL"+objectId]);
				} else {
					myWidgetObj.refreshWidget("updateUrl", myRCProperties["billingURL"+objectId]+"&paymentTCId="+myRCProperties["paymentTCId"+objectId]);
				}
				var selectedAddressId = $("#billing_address_id_" + objectId).val();
				myWidgetObj.refreshWidget("refresh", {"paymentAreaNumber":objectId,"selectedAddressId":selectedAddressId,"paymentMethodSelected":myRCProperties["payment"+objectId]});
			}	
		},
	
		postRefreshHandler: function() {
			var objectId = myWidgetObj.attr("objectId");
			// After the section refreshes, shows or hides the edit and create links. 						
			CheckoutHelperJS.showHideEditBillingAddressLink((document.getElementsByName('billing_address_id'))[objectId-1], objectId);
			
			//Removes the Progress Bar if its still running.
			cursor_clear();
			var lastAddress = CheckoutHelperJS.getLastAddressLinkIdToFocus();
			if ((numAjaxRequests >= 0) && lastAddress != null && lastAddress != 'undefined' && lastAddress != '') {
				if (document.getElementById(lastAddress) != null){
					document.getElementById(lastAddress).focus();
				}else{
					var lastAddressArray = lastAddress.split("_");
					var lastAddressOrderId = (parseInt(lastAddressArray[lastAddressArray.length - 1]) + 1) + '';
					if (lastAddress.indexOf('WC_ShippingAddressSelectMultiple_link_2_') > -1){
						var lastAddressForFreeGift = 'WC_ShippingAddressSelectMultiple_link_2_' + lastAddressOrderId;
						if (document.getElementById(lastAddressForFreeGift) != null ){
							document.getElementById(lastAddressForFreeGift).focus();
						}
					}else{
						var lastAddressForFreeGift = 'WC_ShippingAddressSelectMultiple_link_3_' + lastAddressOrderId;
						if (document.getElementById(lastAddressForFreeGift) != null ){
							document.getElementById(lastAddressForFreeGift).focus();
						}
					}
				}			
			}
			declareBillingAddressDisplayAreaController("billingAddressDisplayArea_" + objectId);
		}
	});
	
};

/**
 * Refresh controller declaration for the billing address display area.
 * @constructor
 */
function declareBillingAddressDisplayAreaController(widgetId) {
	if(typeof widgetId == "object" || typeof widgetId == "array") {
		widgetId = widgetId[0];
	}
	var myWidgetObj = $("#" + widgetId);
	
	wcRenderContext.addRefreshAreaId("billingAddressDropDownBoxContext", widgetId);
	var myRCProperties = wcRenderContext.getRenderContextProperties("billingAddressDropDownBoxContext");

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
			var areaNumber = myRCProperties["areaNumber"];	
			var objectId = widgetId;
			if (wcRenderContext.testForChangedRC("billingAddressDropDownBoxContext", ["billingAddress"+areaNumber]) && objectId.charAt(objectId.length-1) == areaNumber) {
				var addressId = myRCProperties["billingAddress"+areaNumber];
				myWidgetObj.refreshWidget("refresh", {"addressId": addressId});
			}
		},
	
		postRefreshHandler: function() {
			var areaNumber = myRCProperties["areaNumber"];
			CheckoutHelperJS.showHideEditBillingAddressLink((document.getElementsByName('billing_address_id'))[areaNumber-1],areaNumber);
			//clears the progress bar set from billingdropdowndisplay.jsp
			cursor_clear();
		}
	});

};

/**
 * Refresh controller declaration for the order total area.
 * @constructor
 */
function declareOrderTotalController() {
	var myWidgetObj = $("#orderTotalAmountArea");
	wcRenderContext.addRefreshAreaId("paymentContext", "orderTotalAmountArea");
	var myRCProperties = wcRenderContext.getRenderContextProperties("paymentContext");
	
	var events = $.extend({}, order_updated,
			{"OrderItemAddressShipMethodUpdate": "OrderItemAddressShipMethodUpdate"},
			{"AjaxPrepareOrderForShipChargeUpdate": "AjaxPrepareOrderForShipChargeUpdate"},
			{"OrderItemAddressShipInstructionsUpdate": "OrderItemAddressShipInstructionsUpdate"},
			{"OrderItemAddressShipInstructionsUpdate1": "OrderItemAddressShipInstructionsUpdate1"},
			{"AjaxUpdateOrderAfterAddressUpdate": "AjaxUpdateOrderAfterAddressUpdate"},
			{"AjaxDeleteOrderItemForShippingBillingPage": "AjaxDeleteOrderItemForShippingBillingPage"},
			{"AjaxUpdateOrderItemsAddressId": "AjaxUpdateOrderItemsAddressId"});

	wcTopic.subscribe(events, function() {
		cursor_wait();
		//updating the total
		CheckoutPayments.getTotalInJSON();
	});
	
	// initialize widget
	myWidgetObj.refreshWidget({
		postRefreshHandler: function(widget) {
			cursor_clear();
		}
	});
};

/**
 * Refresh controller declaration for the payment area.
 * @constructor
 * There will be three controllers by default..
 * When paymentAreaController for paymentArea1 changes, the payment1 property of the context will be updated... So in that case for paymentAreaController for paymentArea1,
 * wcRenderContext.testForChangedRC(["payment1"])) will return true..and then we check for payment1 type ..if its VISA, then we load Visa.jsp.. similarly it works for other controllers
 */
function declarePaymentAreaController(divId) {
	if(typeof divId == "object") {
		divId = divId[0];
	}
	
	var myWidgetObj = $("#"+divId);
	wcRenderContext.addRefreshAreaId("paymentContext", divId);
	var myRCProperties = wcRenderContext.getRenderContextProperties("paymentContext");
	var paymentAreaNumber = divId[divId.length-1];

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
				if (myRCProperties.currentPaymentArea == paymentAreaNumber) {
					if ((wcRenderContext.testForChangedRC("paymentContext", ["payment" + paymentAreaNumber])  || wcRenderContext.testForChangedRC("paymentContext", ["paymentTCId" + paymentAreaNumber])
						|| (wcRenderContext.testForChangedRC("paymentContext", ["piAmount"])) && supportPaymentTypePromotions )
					) {
						if (myRCProperties["payment" + paymentAreaNumber] == "empty") {
							viewName = "EmptySnippetView";
						} else {
							viewName = paymentSnippetsURLMap[myRCProperties["payment" + paymentAreaNumber]];
						}
						myWidgetObj.refreshWidget("updateUrl", viewName + paymentAreaUrlParam);
						
						if (supportPaymentTypePromotions) {									
							if (CheckoutPayments.numberOfPaymentMethods != 1) {
								myWidgetObj.refreshWidget("refresh", myRCProperties);
							} else if (CheckoutPayments.numberOfPaymentMethods == 1 && paymentAreaNumber < 2) {
								myWidgetObj.refreshWidget("refresh", myRCProperties);
							}
						} else {
							myWidgetObj.refreshWidget("refresh", myRCProperties);
						}
					}
				}
		},
		
		postRefreshHandler: function() {
			/**
				if supportPaymentTypePromotions is true, CheckoutPayments.loadPaymentSnippet should have been called to 
				reload the entire payment refresh area. This will also refresh the amount field. Hence, we don't need to
				call update amount field again	(which will trigger a call to CheckoutPayments.loadPaymentSnippet ).
			**/
			if (!supportPaymentTypePromotions) { 
				var orderTotal = $("#OrderTotalAmount").val();
				CheckoutPayments.updateAmountFields(orderTotal);
			}
			
			var widgetId = "paymentArea" + paymentAreaNumber;
			TealeafWCJS.rebind(widgetId);
			
			var addressKey = "billingAddress" + paymentAreaNumber;
			//reset the billing address id in the billing address context to be the default selected address after payment method refresh
			wcRenderContext.updateRenderContext('billingAddressDropDownBoxContext', {addressKey:(document.getElementsByName('billing_address_id'))[paymentAreaNumber-1].value, 'areaNumber':paymentAreaNumber});

			cursor_clear();
		}
	});
	
};

/**
 * Refresh controller declaration for shipping address display area.
 * @constructor
 */
function declareShippingAddressDisplayAreaController() {
	var myWidgetObj = $("#shippingAddressDisplayArea");
	
	wcRenderContext.addRefreshAreaId("shippingAddressContext", "shippingAddressDisplayArea");
	var myRCProperties = wcRenderContext.getRenderContextProperties("shippingAddressContext");

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
			if (wcRenderContext.testForChangedRC("shippingAddressContext", ["shippingAddress"])) {
				var addressId = myRCProperties["shippingAddress"];
				myWidgetObj.refreshWidget("refresh", {"addressId": addressId});
			}
			cursor_clear();
		}
	});

};

/**
 * Refresh controller declaration for shipping address edit area.
 * @constructor
 */
function declareEditShippingAdddressAreaController() {
	var myWidgetObj = $("#editShippingAddressArea1");

	wcRenderContext.addRefreshAreaId("editShippingAddressContext", "editShippingAddressArea1");
	var myRCProperties = wcRenderContext.getRenderContextProperties("editShippingAddressContext");

	var events = $.extend({}, address_updated, {"UpdateBillingAddressInCheckout": "UpdateBillingAddressInCheckout"});
	
	wcTopic.subscribe(events, function(returnData) {
		if(shipmentTypeId == 2){
			//This means, invokeService for Address Add/Edit has been called..so update our select box area
			wcRenderContext.updateRenderContext('contextForMainAndAddressDiv', {'showArea':'mainContents','hideArea':'editAddressContents'});
			selectedAddressId = returnData.data.addressId;
			CheckoutHelperJS.updateAddressIdOFItemsOnCreateEditAddress(selectedAddressId[0]);
			cursor_clear();  
		}
	});
	
	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
			if (wcRenderContext.testForChangedRC("editShippingAddressContext", ["shippingAddress"])) {
				var addressId = myRCProperties["shippingAddress"];
				//reset the addressID..so that when user selects create address next time it works properly..
				myRCProperties["shippingAddress"] = 0;
				var addressType = myRCProperties["addressType"];
				myWidgetObj.refreshWidget("refresh", {"addressId": addressId,"addressType":addressType});
			}
		},
		postRefreshHandler: function() {
			cursor_clear();
			AddressHelper.loadStatesUI('shopcartAddressForm','','stateDiv','state', true);
			TealeafWCJS.rebind("centered_single_column_form");
		}
	});
};


function declareMultipleShipmentOrderDetailsRefreshArea() {
	var widgetName = "WC_MultipleShipmentDisplay_div_18";
	var contextName = "multipleShipmentDetailsContext";
	
	if (!wcRenderContext.checkIdDefined(contextName)) {
		wcRenderContext.declare(contextName, [], {shipmentDetailsArea: "update"});
	}
	var myRCProperties = wcRenderContext.getRenderContextProperties(contextName);
	var myWidgetObj = $("#"+widgetName);
	
	wcRenderContext.addRefreshAreaId(contextName, widgetName);
	
	var actionIds = $.extend({}, order_updated,{'AjaxUpdateOrderItemsAddressId':'AjaxUpdateOrderItemsAddressId','AjaxDeleteOrderItemForShippingBillingPage':'AjaxDeleteOrderItemForShippingBillingPage','OrderItemAddressShipMethodUpdate':'OrderItemAddressShipMethodUpdate',
	'AjaxPrepareOrderForShipChargeUpdate':'AjaxPrepareOrderForShipChargeUpdate',
	'OrderItemAddressShipInstructionsUpdate':'OrderItemAddressShipInstructionsUpdate',
	'OrderItemAddressShipInstructionsUpdate1':'OrderItemAddressShipInstructionsUpdate1',
	'AjaxAddUnboundPaymentInstructionToThisOrder':'AjaxAddUnboundPaymentInstructionToThisOrder',
	'AjaxDeleteUnboundPaymentInstructionFromThisOrder':'AjaxDeleteUnboundPaymentInstructionFromThisOrder',
	'AddBillingAddressInCheckOut':'AddBillingAddressInCheckOut'});  
	 
	wcTopic.subscribe(actionIds, function(data){
		if(!CheckoutHelperJS.RequestShippingDateAction && (data.actionId != 'AddBillingAddressInCheckOut' || data.addBillingAddressInCheckOutAddressType != 'Billing')){
			myWidgetObj.refreshWidget("refresh", myRCProperties);
			submitRequest(); //Till shop cart is refreshed, do not allow any other requests..
			cursor_wait();
		} else {
			CheckoutHelperJS.RequestShippingDateAction = false;
		}		
	});
	
	var renderContextChangedHandler = function() {
		if(wcRenderContext.testForChangedRC(contextName,["beginIndex"])){
			myWidgetObj.refreshWidget("refresh", myRCProperties);
		}
	};

	// post refresh handler
	var postRefreshHandler = function() {
		resetRequest(); //Shop cart is refreshed, give the control to shopper...
		cursor_clear();

		if (myRCProperties["initializeJS"] == 'true') {
			$('input[id^="orderItem_"]').each(function(i, orderItem) {
				$.globalEval($('#addToRequisitionListScript_' + orderItem.value).html());
				var addReqObj = 'addReqListsJS' + orderItem.value;
				$.globalEval('if(typeof '+ addReqObj + ' !== "undefined") {' + addReqObj + '.setCatEntryId("' + document.getElementById('catalogId_' + (orderItem.id.substring(orderItem.id.indexOf('_') + 1))).value + '");}');
			});
			$('div[id^="shoppingListScript_"]').each(function(i, node){
				$.globalEval($(node).html());
			});
		}
		if ((numAjaxRequests >= 0) && CheckoutHelperJS.getLastAddressLinkIdToFocus() != null && CheckoutHelperJS.getLastAddressLinkIdToFocus() != 'undefined' && CheckoutHelperJS.getLastAddressLinkIdToFocus() != '') {
			if (document.getElementById(CheckoutHelperJS.getLastAddressLinkIdToFocus()) != null){
				document.getElementById(CheckoutHelperJS.getLastAddressLinkIdToFocus()).focus();
			}else{
				var lastAddress = CheckoutHelperJS.getLastAddressLinkIdToFocus();
				var lastAddressArray = lastAddress.split("_");
				var lastAddressOrderId = (parseInt(lastAddressArray[lastAddressArray.length - 1]) + 1) + '';
				if (lastAddress.indexOf('WC_ShippingAddressSelectMultiple_link_2_') > -1){
					var lastAddressForFreeGift = 'WC_ShippingAddressSelectMultiple_link_2_' + lastAddressOrderId;
					if (document.getElementById(lastAddressForFreeGift) != null ){
						document.getElementById(lastAddressForFreeGift).focus();
					}
				}else{
					var lastAddressForFreeGift = 'WC_ShippingAddressSelectMultiple_link_3_' + lastAddressOrderId;
					if (document.getElementById(lastAddressForFreeGift) != null ){
						document.getElementById(lastAddressForFreeGift).focus();
					}
				}
			}						
		} else if (CheckoutHelperJS.getLastFocus() != '' && tabPressed) {
			tabPressed = false;			
			if (document.getElementById(CheckoutHelperJS.getLastFocus()) != null){
				document.getElementById(CheckoutHelperJS.getLastFocus()).focus();
			}else{
				var lastAddress = CheckoutHelperJS.getLastFocus();
				var lastAddressArray = lastAddress.split("_");
				var lastAddressOrderId = (parseInt(lastAddressArray[lastAddressArray.length - 1]) + 1) + '';
				if (lastAddress.indexOf('WC_ShippingAddressSelectMultiple_link_2_') > -1){
					var lastAddressForFreeGift = 'WC_ShippingAddressSelectMultiple_link_2_' + lastAddressOrderId;
					if (document.getElementById(lastAddressForFreeGift) != null ){
						document.getElementById(lastAddressForFreeGift).focus();
					}
				}else{
					var lastAddressForFreeGift = 'WC_ShippingAddressSelectMultiple_link_3_' + lastAddressOrderId;
					if (document.getElementById(lastAddressForFreeGift) != null ){
						document.getElementById(lastAddressForFreeGift).focus();
					}
				}
			}									
			CheckoutHelperJS.setLastFocus('');
		}	
	};

	// initialize widget
	myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
};
		
function declareMultipleShipmentShipChargeRefreshArea() {

	var contextName = "multipleShipmentShipChargeContext";
	var widgetName = "WC_MultipleShipmentDisplay_ShipCharge_Area";
	var myWidgetObj = $("#"+widgetName);

	if (!wcRenderContext.checkIdDefined(contextName)) {
		wcRenderContext.declare(contextName, [],null);
	}
	var myRCProperties = wcRenderContext.getRenderContextProperties(contextName);
	wcRenderContext.addRefreshAreaId(contextName, widgetName);
	
	// model change
	wcTopic.subscribe(["OrderItemAddressShipMethodUpdate","AjaxDeleteOrderItemForShippingBillingPage"], function(data) {
		if (SBControllersDeclarationJS.shipChargeEnabled) {
			if (data.actionId=="OrderItemAddressShipMethodUpdate") {
				myWidgetObj.refreshWidget("refresh", myRCProperties);
			}
			if (data.actionId=="AjaxDeleteOrderItemForShippingBillingPage") {
				myWidgetObj.refreshWidget("refresh", myRCProperties);
			}
		}
	});
	
	var postRefreshHandler = function() {
		cursor_clear();
	};

	// initialize widget
	myWidgetObj.refreshWidget({postRefreshHandler: postRefreshHandler});
};

/**
 * Refresh controller declaration for shipping address edit area for DOMOrderShippingBillingDetails.jsp.
 * @constructor
 */
function declareDOMEditShippingAdddressAreaController() {
	var contextName = "editShippingAddressContext";
	var widgetName = "editShippingAddressArea1";
	
	var myWidgetObj = $("#" + widgetName);
	var myRCProperties = wcRenderContext.getRenderContextProperties(contextName);
	wcRenderContext.addRefreshAreaId(contextName, widgetName);
	
	wcTopic.subscribe(address_updated, function() {
		//This means, invokeService for Address Add/Edit has been called..so upadate our select box area
		wcRenderContext.updateRenderContext('contextForMainAndAddressDiv', {'showArea':'mainContents','hideArea':'editAddressContents'});
		cursor_clear();
	});
	
	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
			if (wcRenderContext.testForChangedRC(contextName, ["shippingAddress"])) {
				var addressId = myRCProperties["shippingAddress"];
				//reset the addressID..so that when user selects create address next time it works properly..
				myRCProperties["shippingAddress"] = 0;
				var addressType = myRCProperties["addressType"];
				myWidgetObj.refreshWidget("refresh", {"addressId": addressId,"addressType":addressType});
			}
		},
	
		postRefreshHandler: function() {
			cursor_clear();
		}
	});

};

