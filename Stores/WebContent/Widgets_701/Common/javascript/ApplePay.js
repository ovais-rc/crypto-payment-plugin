//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//
// Simple AJAX framework - START
//

// Make a simple AJAX call
// args: JSON - {requestType, requestUrl, requestParameters, async}
// Returns: JSON - {status : success, data} or {status : error, args, error};
function simpleAjax(args) {
	var out = null;
	this.xhr = new XMLHttpRequest();
	var requestURL = args.requestUrl;
	if (args.requestType === 'GET') {
		requestURL = requestURL + args.requestParameters;
	}
	this.xhr.open(args.requestType, requestURL, args.async);
	this.xhr.onreadystatechange = function() {
		if (this.readyState === this.DONE) {
			if (this.status === 200) {
				var jsonText = this.responseText.replace(/(\/\*|\*\/)/g, '');
				var resp = JSON.parse(jsonText);
				var responseError = responseHasErrorCode(resp);
				if (responseError != null) {
					out = handleError(responseError, args);
				} else {
					out = {"status" : STATUS_SUCCESS, "data" : resp};
				}
			} else {
				out = handleError(createError(null, null, MessageHelper.messages["ajaxError"] + this.status));
			}
		}
	}
	if (args.requestType === 'GET') {
		this.xhr.send();
	} else {
		this.xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
		this.xhr.send(args.requestParameters);
	}
	return out;
}
function responseHasErrorCode(resp) {
	if (resp.errorMessageKey) {
		return createError(resp.errorCode, resp.errorMessageKey, resp.errorMessage);
	}
	else {
		return null;
	}
}
function handleError(error, args) {
	return {"status" : STATUS_ERROR, "args" : args, "error" : error};
}
function createError(errorCode, errorMessageKey, errorMessage) {
	return {"errorCode" : errorCode, "errorMessageKey" : errorMessageKey, "errorMessage" : errorMessage};
}
//
// Simple AJAX framework - END
//

//
// Global ApplePay MerchantIdentifier - START
//
function getMerchantIdentifier() {
	if (sessionStorage.getItem('merchantIdentifier') == null || sessionStorage.getItem('merchantIdentifier') === "") {
		var result = simpleAjax({
			requestType: 'GET',
			requestUrl: getAbsoluteURL() + 'GetApplePayMerchantInfo?',
			requestParameters: getCommonParameters(),
			async: false
		});
		if (result.status === STATUS_SUCCESS) {
			sessionStorage.setItem('merchantIdentifier', result.data.merchantIdentifier);
		}
		else {
			displayError("getMerchantIdentifier", result.error);
		};
	}
	return sessionStorage.getItem('merchantIdentifier');
}
//
// Global ApplePay MerchantIdentifier - END
//

//
// Global WC authToken - START
//
var authToken = null;
function initAuthToken() {
	if (authToken == null || authToken === "") {
		var currentURL = document.URL;
		var currentProtocol = "";
		if (currentURL.indexOf("://") != -1) {
			currentProtocol = currentURL.substring(0, currentURL.indexOf("://"));
		}
		if (currentProtocol == 'https') {
			authToken = document.getElementById("csrf_authToken");
			if (authToken) {
				return authToken = encodeURIComponent(authToken.value);
			}
			else {
				var result = simpleAjax({
					requestType: 'GET',
					requestUrl: getAbsoluteURL() + 'GetCSRFAuthToken?',
					requestParameters: getCommonParameters(),
					async: false
				});
				if (result.status === STATUS_SUCCESS) {
					return authToken = encodeURIComponent(result.data.authToken);
				}
				else {
					displayError("initAuthToken", result.error);
					return null;
				};
			}
		}
		// Apple Pay isn't allowed on non-https, so this should not happen
		return null;
	} else {
		return authToken;
	}
}
function getAuthTokenUrlParameter() {
	initAuthToken();
	if (authToken) {
		return '&authToken=' + authToken;
	}
	else {
		// Missing authToken error probably already handled
		return null;
	}
}
//
// Global WC authToken - END
//

//
// Global order ID - START
//
var currentOrderId = "";
function getOrderIdUrlParameter(orderId) {
	var id;
	if (this.isEmpty(orderId)) {
		if (this.isEmpty(currentOrderId)) {
			displayError("getOrderIdUrlParameter", handleError(createError(null, null, MessageHelper.messages["ajaxError"] + this.status)));
		}
		else {
			id = currentOrderId;
		}
	}
	else {
		id = orderId;
	}
	return "&orderId=" + id;
}
//
// Global order ID - END
//

//
// Global BOPIS parameters - START
//
var mobileBOPISShipModeId = "";
var mobileBOPISStoreId = "";
function setMobileBOPISShipMode(inMobileShipModeId) {
	mobileBOPISShipModeId = inMobileShipModeId;
}
function setMobileBOPISStore(inMobileStoreId) {
	mobileBOPISStoreId = inMobileStoreId;
}

function getBOPISParameters() {
	var urlParamStr = "";
	if (isBOPISCheckout() && document.getElementById("shipmodeForm") && PhysicalStoreCookieJS) {
		var shipModeIdBOPIS = "";
		var physicalStoreLocationId = "";
		shipModeIdBOPIS = document.getElementById("shipmodeForm").BOPIS_shipmode_id.value;
		physicalStoreLocationId = document.getElementById("physicalStoreForm").BOPIS_physicalstore_id.value;
		urlParamStr = '&shipModeId='+shipModeIdBOPIS+'&physicalStoreId='+physicalStoreLocationId;
	} else if (mobileBOPISShipModeId != '') {
		urlParamStr = '&shipModeId='+mobileBOPISShipModeId+'&physicalStoreId='+mobileBOPISStoreId;
	}
	return urlParamStr;
}
//
// Global BOPIS parameters - END
//

function getCommonParameters() {
	//  Always call this first for URL parameters
	return 'storeId='+WCParamJS.storeId+'&catalogId='+WCParamJS.catalogId+'&langId='+WCParamJS.langId+'&requesttype=ajax';
}


var isReturnDefaults = "false";
function setIsReturnDefaults(inReturnDefaults) {
	isReturnDefaults = inReturnDefaults;
}
function getIsReturnDefaults() {
	return isReturnDefaults;
}
function getIsReturnDefaultsParameter() {
	var urlParamStr = "";
	urlParamStr = '&returnDefaults='+isReturnDefaults;
	return urlParamStr;
}

function getDefaultShippingParameter() {
	return '&shipModeId='+defaultShipModeId+"&addressId="+defaultAddressId;
}

function IsShipModeValid() {
	return shipModeValid;
}

function getUnboundPIIdParameter() {
	var unboundPIParamStr = "";
	if (unboundPIId !== "") {
		unboundPIParamStr = "&unboundPIId=" + unboundPIId;
	}
	return unboundPIParamStr;
}

//
// Apple Pay button and payment sheet rendering - START
//
var paymentRequest = null;
var shipModeValid = false;
var defaultShipModeId = "";
var defaultAddressId = "";
var unboundPIId = "";
document.addEventListener("DOMContentLoaded", function()  {
	if (window.ApplePaySession) {
		if (getMerchantIdentifier() != null) {
			var promise = ApplePaySession.canMakePaymentsWithActiveCard(getMerchantIdentifier());
			promise.then(function(canMakePayments) {
				if (showDebug) {
					console.log("call back method called..." + canMakePayments);
				}
				if (canMakePayments) {
					showApplePayButtons();
				}
			}, function(reject) {
				console.log("canMakePaymentsWithActiveCard promise rejected");
			});
		}
	}
});

function toggleApplePayButtonInMiniCart() {
	// Show Apple Pay button when there is an order in the mini shop cart, otherwise, hide it
	var d = document.getElementById("applePayButtonDiv_minishopcart");
	if (d !== null) {
		if (document.querySelector("#currentOrderId") && document.querySelector("#currentOrderQuantity")
			&& !this.isEmpty(document.querySelector("#currentOrderId").value)
			&& !this.isEmpty(document.querySelector("#currentOrderQuantity").value)
			&& document.querySelector("#currentOrderQuantity").value !== "0") {
				d.classList.add("visible");
		}
		else {
			d.classList.remove("visible");
		}
	}
}

function showApplePayButtons() {
	if (window.ApplePaySession) {
		var x = document.getElementsByClassName("apple-pay-button");
		var i;
		for (i = 0; i < x.length; i++) {
			x[i].classList.add("visible");
		}

		if (!this.isEmpty(document.getElementById("applePayButtonDiv_minishopcart"))) {
			// Deal with the Apple Pay button in the mini shop cart as a special case
			toggleApplePayButtonInMiniCart();
		}
	}
}

function applePayButtonClicked(entitledItemJSONId, quantity, catentryId, pageType, baseItemElement, ma_index) {
	if (typeof CSRWCParamJS !== 'undefined' && CSRWCParamJS.env_shopOnBehalfSessionEstablished === 'true') {
		// WC V8+ CSR enabled and currently either buyer admin or CSR.  Stop CSR/buyer admin here.
		displayError("applePayButtonClicked", handleError(createError(null, null, MessageHelper.messages["csrNotSupported"])));
	}
	else {
		// Normal flow
		if (((entitledItemJSONId && quantity && parseInt(quantity) > 0) || (catentryId) || pageType) ) {
			// Paying for a specific product, based on Add2ShopCartAjax()
			var catalogEntriesArray = new Object();
			if (catentryId) {
				//package or item
				catalogEntryId = catentryId;
				var oneCatEntry = [catentryId, quantity];
				catalogEntriesArray[catentryId] = oneCatEntry;
			} else {
				if (pageType === "plp") {
					//PLP - single product
					var entitledItemJSON = eval(document.getElementById(entitledItemJSONId).innerHTML);
					shoppingActionsJS.setEntitledItems(entitledItemJSON);
					var oneCatEntry = [shoppingActionsJS.getCatalogEntryId(entitledItemJSONId), quantity];
					catalogEntriesArray[shoppingActionsJS.getCatalogEntryId(entitledItemJSONId)] = oneCatEntry;
				} 
				else if (pageType === "bundle") {
					//bundle - N products
					for(productId in shoppingActionsJS.productList){
						var productDetails = shoppingActionsJS.productList[productId];
						var quantityForProduct = dojo.number.parse(productDetails.quantity);
						if (quantityForProduct == 0) {
							continue;
						}
						if(productDetails.id == 0){
							MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
							return;
						}
						if(isNaN(quantityForProduct) || quantityForProduct < 0){
							MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
							return;
						}
						var oneCatEntry = [productDetails.id, quantityForProduct];
						catalogEntriesArray[productDetails.id] = oneCatEntry;
					}
				}
				else if (pageType === "ma") {
					//merchandising association - deal with the associated product and a product page one
					//validation of associated product
					MerchandisingAssociationJS.associationIndex = ma_index;
					MerchandisingAssociationJS.validate();
					if(!isPositiveInteger(quantity)){
						MessageHelper.displayErrorMessage(storeNLS['QUANTITY_INPUT_ERROR']);
						return;
					}
					
					//Add the product page one to the cart.
					if(MerchandisingAssociationJS.baseItemParams.type == 'ItemBean'
						|| MerchandisingAssociationJS.baseItemParams.type == 'PackageBean'
						|| MerchandisingAssociationJS.baseItemParams.type == 'DynamicKitBean'){
						var oneCatEntry = [MerchandisingAssociationJS.baseItemParams.id, Math.abs(MerchandisingAssociationJS.baseItemParams.quantity)];
						catalogEntriesArray[MerchandisingAssociationJS.baseItemParams.id] = oneCatEntry;
					} else if(MerchandisingAssociationJS.baseItemParams.type=='BundleBean'){
						// Add items in the bundle
						for(idx=0;idx<MerchandisingAssociationJS.baseItemParams.components.length;idx++){
							var oneCatEntry = [MerchandisingAssociationJS.baseItemParams.components[idx].id, MerchandisingAssociationJS.baseItemParams.components[idx].quantity];
							catalogEntriesArray[MerchandisingAssociationJS.baseItemParams.components[idx].id] = oneCatEntry;
						}
					} else {
						// Resolve ProductBean to an ItemBean based on the attributes in the main page
						var sku = MerchandisingAssociationJS.resolveSKU();
						if(-1 == sku){
							MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
							return;
						} else {
							var oneCatEntry = [sku, Math.abs(MerchandisingAssociationJS.baseItemParams.quantity)];
							catalogEntriesArray[sku] = oneCatEntry;
						}
					}
					
					//Add the associated product to the cart.
					if (MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='ItemBean'
						|| MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='PackageBean'
						|| MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='DynamicKitBean'){
						var oneCatEntry = [MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].id, quantity];
						catalogEntriesArray[MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].id] = oneCatEntry;	
					} else if(MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='BundleBean'){
						// Add items in the bundle
						for(idx=0;idx<MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].components.length;idx++){
							var oneCatEntry = [MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].components[idx].id, MerchandisingAssociationJS.baseItemParams.components[idx].quantity];
							catalogEntriesArray[MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].components[idx].id] = oneCatEntry;
						}
					} else {
						// Resolve ProductBean to an ItemBean based on the attributes selected
						var entitledItemJSON = null;
						if (dojo.byId(entitledItemJSONId)!=null) {
							//the json object for entitled items are already in the HTML. 
							 entitledItemJSON = eval('('+ dojo.byId(entitledItemJSONId).innerHTML +')');
						}else{
							//if dojo.byId(entitledItemId) is null, that means there's no <div> in the HTML that contains the JSON object. 
							//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
							entitledItemJSON = shoppingActionsJS.getEntitledItemJsonObject(); 
						}
						shoppingActionsJS.setEntitledItems(entitledItemJSON);
						var catEntryID_MA_SKU = shoppingActionsJS.getCatalogEntryId(entitledItemJSONId);
						if(null == catEntryID_MA_SKU){
							MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
							return;
						} else {
							var oneCatEntry = [catEntryID_MA_SKU, quantity];
							catalogEntriesArray[catEntryID_MA_SKU] = oneCatEntry;
						}
					}
					// end ma
				}
				else {
					//Product or Item - single product
					var entitledItemJSON = eval(document.getElementById(entitledItemJSONId).innerHTML);
					productDisplayJS.setEntitledItems(entitledItemJSON);
					var oneCatEntry = [productDisplayJS.getCatalogEntryId(entitledItemJSONId), quantity];
					catalogEntriesArray[productDisplayJS.getCatalogEntryId(entitledItemJSONId)] = oneCatEntry;
				}
			}
			if (catalogEntriesArray) {
				var catEntryParametersToAdd = '';
				var counter = 0;
				for(i in catalogEntriesArray){
					counter++;
					catEntryParametersToAdd = catEntryParametersToAdd + '&catEntryId_' + counter + '=' + catalogEntriesArray[i][0] + '&quantity_' + counter + '=' + catalogEntriesArray[i][1];
				}
				var addToOrder = simpleAjax({
					requestType: 'POST',
					requestUrl: getAbsoluteURL() + 'AjaxRESTOrderItemAdd?',
					requestParameters: getCommonParameters() + '&inventoryValidation=true&calculateOrder=0' +
						getOrderIdUrlParameter("**") + catEntryParametersToAdd + 
						'&attributeName_ord=isPDP&attributeValue_ord=1',
					async: false
				});
				if (addToOrder.status === STATUS_SUCCESS) {
					currentOrderId = addToOrder.data.orderId;
					
					if (supportPaymentTypePromotions) {
						addUnboundPI();
					}
					prepareOrder().then(function(success) {
						retrieveWCOrderInformation().then(function(success) {
							if (IsShipModeValid()) {
								renderPaymentSheet();
							}
							else {
								updateShipMode().then(function(success) {
									retrieveWCOrderInformation().then(function(success) {
										renderPaymentSheet();
									})
									.catch(function(err) {
										displayError("DirectProductBuy: fail retrieve order information 2", err)
									});
								})
								.catch(function(err) {
									displayError("DirectProductBuy: fail update shipping", err)
								});
							}
						})
						.catch(function(err) {
							displayError("DirectProductBuy: fail retrieve order information", err)
						});
					})
					.catch(function(err) {
						displayError("DirectProductBuy: fail prepare order", err)
					});
				}
				else {
					displayError("DirectProductBuy: no catentry id 2", addToOrder, MessageHelper.messages["badCatentryId"]);
				}
			}
			else {
				displayError("DirectProductBuy: no catentry id", handleError(createError(null, null, MessageHelper.messages["badCatentryId"])));
			}
		}
		else {
			// Paying for whatever is in the shopping cart
			currentOrderId = ".";
			if (isBOPISCheckout()) {
				// BOPIS flow
				openStoreLocatorPopup();
			}
			else {
				// Shipping flow
				if (supportPaymentTypePromotions) {
					addUnboundPI();
				}
				setIsReturnDefaults("true");
				retrieveWCOrderInformation().then(function(success) {
					setIsReturnDefaults("false");
					updateShipMode().then(function(success) {
						prepareOrder().then(function(success) {
							retrieveWCOrderInformation().then(function(success) {
								renderPaymentSheet();
							})
							.catch(function(err) {
								displayError("fail LAST retrieve order information", err);
							});
						})
						.catch(function(err) {
							displayError("fail prepare order", err);
						});
					})
					.catch(function(err) {
						displayError("fail update shipping information", err);
					});
				})
				.catch(function(err) {
					setIsReturnDefaults("false");
					displayError("fail retrieve order information", err);
				});
			}
		}
	}
}

function mobileBOPISFlow(bopisShipMode, bopisStoreId) {
	// Paying for whatever is in the mobile shopping cart
	currentOrderId = ".";
	setMobileBOPISShipMode(bopisShipMode);
	setMobileBOPISStore(bopisStoreId);
	updateOrderForBOPIS().then(function(success) {
		prepareOrder().then(function(success) {
			retrieveWCOrderInformation().then(function(success) {
				renderPaymentSheet();
			})
			.catch(function(err) {
				displayError("mobileBOPIS: fail retrieve order information", err);
			});
		})
		.catch(function(err) {
			displayError("mobileBOPIS: fail prepare order", err);
		});
	})
	.catch(function(err) {
		displayError("mobileBOPIS: fail update shipping for BOPIS", err);
	});
}

function startApplePayBOPISFlow() {
	if (validateBOPISParameters()) {
		if (supportPaymentTypePromotions) {
			addUnboundPI();
		}
		updateOrderForBOPIS().then(function(success) {
			prepareOrder().then(function(success) {
				retrieveWCOrderInformation().then(function(success) {
					renderPaymentSheet();
				})
				.catch(function(err) {
					displayError("BOPIS: fail retrieve order information", err);
				});
			})
			.catch(function(err) {
				displayError("BOPIS: fail prepare order", err);
			});
		})
		.catch(function(err) {
			displayError("BOPIS: fail update shipping", err);
		});
	}
	else {
		displayError("BOPIS not valid", handleError(createError(null, null, MessageHelper.messages["noStoreSelected"])));
	}
}

function renderPaymentSheet() {
	if (showDebug) {
		console.log("In renderPaymentSheet");
	}
	var session = new ApplePaySession(1, paymentRequest);
	session.begin();

	session.onvalidatemerchant = function (event) {
		if (showDebug) {
			console.log('onvalidatemerchant called...url is ' + event.validationURL);
		}
		performMerchantValidation(event.validationURL)
			.then(function(merchantSession) {
				if (showDebug) {
					//console.log(merchantSession.merchantSession);
				}
				session.completeMerchantValidation(JSON.parse(merchantSession.merchantSession));
			}, function(error) {
				displayError("performMerchantValidation", error);
				abortSession(error);
		   });
	}

	session.onshippingcontactselected = function (event) {
		if (showDebug) {
			console.log('onshippingcontactselected called');
		}
		saveShippingContact(event.shippingContact)
			.then(prepareOrder)
			.then(retrieveWCOrderInformation)
			.then(function() {
				if (!shipModeValid) {
					updateShipMode()
						.then(prepareOrder)
						.then(retrieveWCOrderInformation)
						.then(function() {
							session.completeShippingContactSelection(ApplePaySession.STATUS_SUCCESS, paymentRequest.shippingMethods, paymentRequest.total, paymentRequest.lineItems);
						})
						.catch(function(err) {
							displayError("updateShipModeAndOrder", err);
							session.completeShippingContactSelection(ApplePaySession.STATUS_INVALID_SHIPPING_POSTAL_ADDRESS);
						});
				}
				else {
					session.completeShippingContactSelection(ApplePaySession.STATUS_SUCCESS, paymentRequest.shippingMethods, paymentRequest.total, paymentRequest.lineItems);
				}
			})
			.catch(function(err) {
				displayError("saveShippingContact", err);
				session.completeShippingContactSelection(ApplePaySession.STATUS_INVALID_SHIPPING_POSTAL_ADDRESS);
			});
	}

	session.onshippingmethodselected = function (event) {
		if (showDebug) {
			console.log('onshippingmethodselected called');
			console.log(event.shippingMethod);
		}
		saveShippingMethod(event.shippingMethod)
			.then(prepareOrder)
			.then(retrieveWCOrderInformation)
			.then(function() {
				session.completeShippingMethodSelection(ApplePaySession.STATUS_SUCCESS, paymentRequest.total, paymentRequest.lineItems);
			})
			.catch(function(err) {
				displayError("saveShippingMethod", err);
				abortSession(err);
				session.completeShippingMethodSelection(ApplePaySession.STATUS_FAILURE);
			});
	}

	session.onpaymentmethodselected = function(event) {
		if (showDebug) {
			console.log('onpaymentmethodselected called');
			console.log(event.paymentMethod);
		}
		session.completePaymentMethodSelection(paymentRequest.total, paymentRequest.lineItems);
	}

	session.onpaymentauthorized = function(event) {
		if (showDebug) {
			console.log('onpaymentauthorized called');
			console.log(event.payment);
		}
		sendPaymentToken(event.payment)
			.then(function (success) {
				currentOrderId = success.orderId;
				if (showDebug) {
					console.log("currentOrderId=" + currentOrderId);
				}
				if (!this.isEmpty(currentOrderId)) {
					session.completePayment(ApplePaySession.STATUS_SUCCESS);
					setDeleteCartCookie();
					showConfirmation();
				} else {
					cancelApplePayOrder();
					session.completePayment(ApplePaySession.STATUS_FAILURE);
					displayError("sendPaymentToken", handleError(createError(null, null, MessageHelper.messages["failureSendPayment"])));
				}
			}, function(error) {
				if (error.errorMessageKey === "INVALID_SHIPPING_CONTACT") {
					session.completePayment(ApplePaySession.STATUS_INVALID_SHIPPING_CONTACT);
				}
				else if (error.errorMessageKey === "INVALID_BILLING_CONTACT") {
					session.completePayment(ApplePaySession.STATUS_INVALID_BILLING_POSTAL_ADDRESS);
				}
				else {
					session.completePayment(ApplePaySession.STATUS_FAILURE);
				}
				cancelApplePayOrder();
				displayError("sendPaymentToken", error);
			});
	}

	session.oncancel = function (event) {
		cancelApplePayOrder()
			.then(function(success) {
				if (showDebug) {
					console.log('Order cancel success');
				}
			})
			.catch(function(error) {
				displayError(CANCEL_METHOD, error);
			});
	}
}
//
// Apple Pay button and payment sheet rendering - END
//


//
// Apple Pay callback method implementations - START
//
function performMerchantValidation(appleServerURL) {
	return new Promise(function(resolve, reject) {
		var merchantValidate = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayMerchantValidation?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + '&paymentSystem=ApplePaySystem&paymentConfigGroup=default&validationURL='+appleServerURL,
			async: false
		});
		if (merchantValidate.status === STATUS_SUCCESS) {
			resolve(merchantValidate.data);
		}
		else {
			reject(merchantValidate);
		}
	});
}

function getContactAddressParameters(contact) {
	var address = '&city=' + encodeURIComponent(contact.locality) +
	'&state=' + encodeURIComponent(contact.administrativeArea) +
	'&country=' + encodeURIComponent(contact.country) +
	'&zipCode=' + encodeURIComponent(contact.postalCode) ;

	return address;
}

function getShippingAndBillingContactParameters(payment) {
	var address='' ;
	if (!this.isEmpty(payment.shippingContact)) {
		if (!this.isEmpty(payment.shippingContact.givenName)) {
			address += '&firstName_s=' + encodeURIComponent(payment.shippingContact.givenName);
		}
		if (!this.isEmpty(payment.shippingContact.familyName)) {
			address += '&lastName_s=' + encodeURIComponent(payment.shippingContact.familyName);
		}
		if (!this.isEmpty(payment.shippingContact.locality)) {
			address += '&city_s=' + encodeURIComponent(payment.shippingContact.locality);
		}
		if (!this.isEmpty(payment.shippingContact.postalCode)) {
			address += '&zipCode_s=' + encodeURIComponent(payment.shippingContact.postalCode);
		}
		if (!this.isEmpty(payment.shippingContact.addressLines) && !this.isEmpty(payment.shippingContact.addressLines[0])) {
			address += '&address1_s=' + encodeURIComponent(payment.shippingContact.addressLines[0]);
		}
		if (!this.isEmpty(payment.shippingContact.addressLines) && !this.isEmpty(payment.shippingContact.addressLines[1])) {
			address += '&address2_s=' + encodeURIComponent(payment.shippingContact.addressLines[1]);
		}
		if (!this.isEmpty(payment.shippingContact.phoneNumber)) {
			address += '&phone1_s=' + encodeURIComponent(payment.shippingContact.phoneNumber);
		}
		if (!this.isEmpty(payment.shippingContact.administrativeArea)) {
			address += '&state_s=' + encodeURIComponent(payment.shippingContact.administrativeArea);
		}
		if (!this.isEmpty(payment.shippingContact.country)) {
			address += '&country_s=' + encodeURIComponent(payment.shippingContact.country);
		}
		if (!this.isEmpty(payment.shippingContact.emailAddress)) {
			address += '&email1_s=' + encodeURIComponent(payment.shippingContact.emailAddress);
		}
	}
	if (!this.isEmpty(payment.billingContact)) {
		if (!this.isEmpty(payment.billingContact.givenName)) {
			address += '&firstName_b=' + encodeURIComponent(payment.billingContact.givenName);
		}
		if (!this.isEmpty(payment.billingContact.familyName)) {
			address += '&lastName_b=' + encodeURIComponent(payment.billingContact.familyName);
		}
		if (!this.isEmpty(payment.billingContact.locality)) {
			address += '&city_b=' + encodeURIComponent(payment.billingContact.locality);
		}
		if (!this.isEmpty(payment.billingContact.postalCode)) {
			address += '&zipCode_b=' + encodeURIComponent(payment.billingContact.postalCode);
		}
		if (!this.isEmpty(payment.billingContact.addressLines) && !this.isEmpty(payment.billingContact.addressLines[0])) {
			address += '&address1_b=' + encodeURIComponent(payment.billingContact.addressLines[0]);
		}
		if (!this.isEmpty(payment.billingContact.addressLines) && !this.isEmpty(payment.billingContact.addressLines[1])) {
			address += '&address2_b=' + encodeURIComponent(payment.billingContact.addressLines[1]);
		}
		if (!this.isEmpty(payment.billingContact.phoneNumber)) {
			address += '&phone1_b=' + encodeURIComponent(payment.billingContact.phoneNumber);
		}
		if (!this.isEmpty(payment.billingContact.administrativeArea)) {
			address += '&state_b=' + encodeURIComponent(payment.billingContact.administrativeArea);
		}
		if (!this.isEmpty(payment.billingContact.country)) {
			address += '&country_b=' + encodeURIComponent(payment.billingContact.country);
		}
		if (!this.isEmpty(payment.billingContact.emailAddress)) {
			address += '&email1_b=' + encodeURIComponent(payment.billingContact.emailAddress);
		}
	}

	return address;
}

function getPaymentTokenParameters(token){
	var paymentToken = '&applepay_paymentData_data=' + encodeURIComponent(token.paymentData.data)
		+ '&applepay_paymentData_header_publicKeyHash=' + encodeURIComponent(token.paymentData.header.publicKeyHash)
		+ '&applepay_paymentData_header_ephemeralPublicKey=' + encodeURIComponent(token.paymentData.header.ephemeralPublicKey)
		+ '&applepay_paymentData_header_transactionId=' + encodeURIComponent(token.paymentData.header.transactionId)
		+ '&applepay_paymentData_signature=' + encodeURIComponent(token.paymentData.signature)
		+ '&applepay_paymentData_version=' + encodeURIComponent(token.paymentData.version)
		+ '&applepay_paymentMethod_displayName=' + encodeURIComponent(token.paymentMethod.displayName)
		+ '&applepay_paymentMethod_network=' + encodeURIComponent(token.paymentMethod.network)
		+ '&applepay_paymentMethod_type=' + encodeURIComponent(token.paymentMethod.type)
		+ '&applepay_paymentMethod_paymentPass=' + encodeURIComponent(token.paymentMethod.paymentPass)
		+ '&applepay_transactionIdentifier=' + encodeURIComponent(token.transactionIdentifier);

	return paymentToken;
}

function saveShippingContact(shippingContact) {
	return new Promise(function(resolve, reject) {
		if (!validateInitialShippingContact(shippingContact)) {
			// Stop if contact information needed for shipping costs are not present
			reject(handleError(createError(null, "INVALID_SHIPPING_CONTACT", MessageHelper.messages["invalidShippingContact"])));
			return;
		}
		else {
			if (showDebug) {
				console.log("Update shipping Contact: " + JSON.stringify(shippingContact));
			}
			var saveResult = simpleAjax({
				requestType: 'POST',
				requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate',
				requestParameters: getCommonParameters() + getContactAddressParameters(shippingContact) + getAuthTokenUrlParameter() + getOrderIdUrlParameter(),
				async: false
			});
			if (saveResult.status === STATUS_SUCCESS) {
				resolve();
			}
			else {
				reject(saveResult);
			}
		}
	});
}

function saveShippingMethod(shippingMethod) {
	return new Promise(function(resolve, reject) {
		if (showDebug) {
			console.log("New Shipping Method: " + shippingMethod.identifier);
		}
		var saveResult = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate',
			requestParameters: getCommonParameters() + '&shipModeId=' + shippingMethod.identifier + getAuthTokenUrlParameter() + getOrderIdUrlParameter(),
			async: false
		});
		if (saveResult.status === STATUS_SUCCESS) {
			resolve();
		}
		else {
			reject(saveResult);
		}
	});
}

function validateInitialShippingContact(sc) {
	// Validate basic shipping contact for shipping costs
	if (this.isEmpty(sc)) {
		return false;
	}
	else {
		if (this.isEmpty(sc.locality)) {
			return false;
		}
		if (this.isEmpty(sc.postalCode)) {
			return false;
		}
		if (this.isEmpty(sc.administrativeArea)) {
			return false;
		}
		if (this.isEmpty(sc.country)) {
			return false;
		}
	}
	return true;
}
function validateFinalShippingContact(sc) {
	// Validate full contact for address book
	if (!validateInitialShippingContact) {
		return false;
	}
	else {
		if (this.isEmpty(sc.familyName)) {
			return false;
		}
		if (this.isEmpty(sc.addressLines) || this.isEmpty(sc.addressLines[0])) {
			return false;
		}
		if (this.isEmpty(sc.emailAddress)) {
			return false;
		}
	}
	return true;
}

function validateBillingContact(bc) {
	// Validate full billing contact
	if (this.isEmpty(bc)) {
		return false;
	}
	else {
		if (this.isEmpty(bc.familyName)) {
			return false;
		}
		if (this.isEmpty(bc.locality)) {
			return false;
		}
		if (this.isEmpty(bc.postalCode)) {
			return false;
		}
		if (this.isEmpty(bc.addressLines || this.isEmpty(bc.addressLines[0]))) {
			return false;
		}
		if (this.isEmpty(bc.administrativeArea)) {
			return false;
		}
		if (this.isEmpty(bc.country)) {
			return false;
		}
	}
	return true;
}

function sendPaymentToken(payment) {
	return new Promise(function(resolve, reject) {
		if (showDebug) {
			console.log("Sending payment token...");
		}
		if (!isBOPISCheckout()) {
			if (!validateFinalShippingContact(payment.shippingContact)) {
				reject(handleError(createError(null, "INVALID_SHIPPING_CONTACT", MessageHelper.messages["invalidShippingContact"])));
				return;
			}
		}
		if (!validateBillingContact(payment.billingContact)) {
			reject(handleError(createError(null, "INVALID_BILLING_CONTACT", MessageHelper.messages["invalidBillingContact"])));
			return;
		} else {
			var applePayOrderProcess = simpleAjax({
				requestType: 'POST',
				requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderProcess?',
				requestParameters: getCommonParameters() + '&notifyMerchant=1&notifyShopper=1&notifyOrderSubmitted=1' + getOrderIdUrlParameter(".") + 
					getAuthTokenUrlParameter() + getPaymentTokenParameters(payment.token) + getShippingAndBillingContactParameters(payment) + getUnboundPIIdParameter(),
				async: false
			});
			if (applePayOrderProcess.status === STATUS_SUCCESS) {
				resolve(applePayOrderProcess.data);
			}
			else {
				reject(applePayOrderProcess);
			}
		}
	});
}

function cancelApplePayOrder() {
	return new Promise(function(resolve, reject) {
		if (showDebug) {
			console.log("Cancelling order...");
		}
		var cancelOrder = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderCancel?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter("."),
			async: false
		});
		if (cancelOrder.status === STATUS_SUCCESS) {
			resolve(cancelOrder.data);
		}
		else {
			reject(cancelOrder);
		}
	});
}
//
// Apple Pay callback method implementations - END
//


//
// Global WC reusable task methods - START
//
var STATUS_SUCCESS = "success";
var STATUS_ERROR = "error";
var showDebug = false; // NOTE Set to false to turn off debug
var CANCEL_METHOD = "cancelApplePayOrder";

function isEmpty(v) {
	if (typeof v === "object") {
		if (Array.isArray(v)) {
			return !(v.length > 0);
		}
		else {
			return false;
		}
	}
	return !(typeof v === "string" && v.length > 0);
}

function isBOPISCheckout() {
	return this.getShippingSelection() === "pickUp";
}
function getShippingSelection() {
	var result = "shopOnline";
	if (document.BOPIS_FORM != undefined){
		for (var i=0; i < document.BOPIS_FORM.shipType.length; i++) {
			if (document.BOPIS_FORM.shipType[i].checked) {
				if (showDebug) {
					console.log("Selected checkout option - " + document.BOPIS_FORM.shipType[i].value);
				}
				result = document.BOPIS_FORM.shipType[i].value;
			}
		}
	} else if (mobileBOPISShipModeId != "" && mobileBOPISStoreId != "") {
		result = "pickUp";
	}
	return result;
}
function validateBOPISParameters() {
	var shipModeIdBOPIS = "";
	var physicalStoreLocationId = "";
	var orderItemId = "";
	if (document.getElementById("shipmodeForm") && PhysicalStoreCookieJS) {
		shipModeIdBOPIS = document.getElementById("shipmodeForm").BOPIS_shipmode_id.value;
		if (PhysicalStoreCookieJS.getStoreIdsFromCookie().indexOf(",") == -1) {
			physicalStoreLocationId = PhysicalStoreCookieJS.getStoreIdsFromCookie();
		}
		orderItemId = document.getElementById("OrderFirstItemId").value;
		return !this.isEmpty(shipModeIdBOPIS) && !this.isEmpty(physicalStoreLocationId) && !this.isEmpty(orderItemId);
	}
}

function updateOrderForBOPIS() {
	return new Promise(function(resolve, reject) {
		var updateBOPIS = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter() + getBOPISParameters(),
			async: false
		});
		if (updateBOPIS.status === STATUS_SUCCESS) {
			currentOrderId = updateBOPIS.data.orderId;
			resolve(updateBOPIS);
		}
		else {
			reject(updateBOPIS);
		}
	});
}

function updateShipMode() {
	if (showDebug) {
		console.log("In updateShipMode");
	}
	return new Promise(function(resolve, reject) {
		var updateShipModeId = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter() + getDefaultShippingParameter(),
			async: false
		});
		if (updateShipModeId.status === STATUS_SUCCESS) {
			currentOrderId = updateShipModeId.data.orderId;
			resolve(updateShipModeId);
		}
		else {
			reject(updateShipModeId);
		}
	});
}

function addUnboundPI() {
	if (showDebug) {
		console.log("In addUnboundPI");
	}
	return new Promise(function(resolve, reject) {
		var addUnboundPICall = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxRESTOrderPIAdd?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter() + '&payMethodId=ApplePay&unbound=true',
			async: false
		});
		if (addUnboundPICall.status === STATUS_SUCCESS) {
			unboundPIId = addUnboundPICall.data.paymentInstruction[0].piId;
			resolve(addUnboundPICall);
		}
		else {
			reject(addUnboundPICall);
		}
	});
}

function prepareOrder() {
	if (showDebug) {
		console.log("In prepareOrder");
	}
	return new Promise(function(resolve, reject) {
		var applePayPrepare = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxRESTOrderPrepare?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter(),
			async: false
		});
		if (applePayPrepare.status === STATUS_SUCCESS) {
			if (showDebug) {
				console.log("Successful order prepare - " + applePayPrepare.data.orderId);
			}
			currentOrderId = applePayPrepare.data.orderId;
			resolve(applePayPrepare);
		}
		else {
			reject(applePayPrepare);
		}
	});
}
function retrieveWCOrderInformation() {
	if (showDebug) {
		console.log("In retrieveWCOrderInformation");
	}
	var urlParameters = "";
	if (getIsReturnDefaults() === "true") {
		urlParameters = getCommonParameters() + getBOPISParameters() + getIsReturnDefaultsParameter();
	} else {
		urlParameters = getCommonParameters() + getOrderIdUrlParameter() + getBOPISParameters() + getIsReturnDefaultsParameter();
	}
	return new Promise(function(resolve, reject) {
		var wcOrderInfo = simpleAjax({
			requestType: 'GET',
			requestUrl: getAbsoluteURL() + 'GetOrderInfoForApplePay?',
			requestParameters: urlParameters,
			async: false
		});
		if (wcOrderInfo.status === STATUS_SUCCESS) {
			if (wcOrderInfo.data.defaultShipModeId) {
				shipModeValid = false;
				defaultShipModeId = wcOrderInfo.data.defaultShipModeId;
				defaultAddressId = wcOrderInfo.data.defaultAddressId;
			} else {
				shipModeValid = true;
				paymentRequest = wcOrderInfo.data;
			}
			if (showDebug) {
				console.log("shipModeValid - " + shipModeValid);
			}
			resolve(wcOrderInfo);
		}
		else {
			reject(wcOrderInfo);
		}
	});
}

function showConfirmation() {
	if (showDebug) {
		console.log("In showConfirmation");
	}
	document.location.href = appendWcCommonRequestParameters("OrderShippingBillingConfirmationView?" + getCommonParameters() + getOrderIdUrlParameter());
}
function displayError(location, error, customMessage) {
	console.log("Error in " + location);
	console.log(JSON.stringify(error.error));
	if (typeof error.args !== 'undefined') {
		if (showDebug) {
			console.log(JSON.stringify(error.args));
		}
	}
	MessageHelper.displayErrorMessage(customMessage ? customMessage : error.error.errorMessage);

}
function abortSession(e) {
	var promise = cancelApplePayOrder();
	promise.then(function(success) {
		if (showDebug) {
			console.log('Order cancel success');
		}
	}, function(error) {
		displayError(CANCEL_METHOD, error);
	});
	session.abort();
}
//
// Global WC reusable task methods - END
//