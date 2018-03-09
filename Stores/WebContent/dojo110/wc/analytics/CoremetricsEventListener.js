// wrapped by build app
define("wc/analytics/CoremetricsEventListener", ["dijit","dojo","dojox","dojo/require!wc/analytics/GenericEventListener"], function(dijit,dojo,dojox){
/*
	Copyright (c) 2009, 2011, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["wc.analytics.CoremetricsEventListener"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["wc.analytics.CoremetricsEventListener"] = true;
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * This file is Coremetrics-specific analytics event listener 
  * @version 1.0
 * 
 **/

/**
* @class This class handles the page view and product view events and calls the appropriate 
* One and only one global analyticsJS should be created. Therefore, we create this object only when it is not present in Coremetrics JavaScript functions to register such calls.
*
**/
dojo.provide("wc.analytics.CoremetricsEventListener");

dojo.require("wc.analytics.GenericEventListener");

dojo.declare("wc.analytics.CoremetricsEventListener", wc.analytics.GenericEventListener, {
	
	PARAM_STORE_ID: "storeId",

	/** 
	 *  This function is the handler for PageView events .This is the method called when a PageView event is triggered via the "/wc/analytics/pageview" topic.
	 * @param{Object} obj JSON object containing the following fields;
	 * 	              pagename (optional), the name of the page, accordion panel, etc. that is being viewed.
	 * 	             If not provided, the HTML page title will be used.
	 * 	             category (optional), the category of the page that is being viewed. If not provided,
	 * 	             no category data will be sent.
	 * 	             searchTerms (optional), the terms that the user searched for and is required for search results pages.
	 * 	             searchCount (optional), the total number of results returned by the search and required when searchTerm is set.
	 * 
	 */

	handlePageView: function(obj) {
		
		// For debug purposes
		var internalDebug = false;
		if (internalDebug) {
			window.alert("handlePageView");
		}
		
		var PARAM_PAGENAME = "pagename";
		var PARAM_PAGETYPE = "pageType";
		var PARAM_CATEGORY = "category";
		var PARAM_SEARCHTERMS = "searchTerms";
		var PARAM_SEARCHCOUNT = "searchCount";

		var PARAM_OPTIONS = "options";
		var PARAM_DEBUG = "debug";
		var PARAM_EXTRA_PARAM = "extraParams";
		var PARAM_ATTRIBUTES = "attributes";
		var PARAM_VALUE_USEDDX = "useDDX";
		var PARAM_VALUE_TRUE = "true";

		// set some defaults
		var pagename = document.title;
		var pageType = null;
		var category = null;
		var searchTerms = null;
		var searchCount = null;
		
		var attributes = null;
		var extraParams = null;

		var storeId = this._getStoreId();
		var args = new Array();

		var useDDX = false;
		var debug = false;
		
		// search object for known values and save the unknown ones
		for(x in obj) {
			if(x == PARAM_OPTIONS) {
				var options = obj[x];
				if (options == PARAM_VALUE_USEDDX) {
					useDDX = true;
				}
			} else if (x == PARAM_DEBUG) {
				var debugParam = obj[x];
				if (debugParam == PARAM_VALUE_TRUE) {
					debug = true;
				}
			} else if(x == PARAM_PAGENAME) {
				pagename = obj[x];
			}
			else if(x == PARAM_PAGETYPE) {
				pageType = obj[x];	
			}
			else if(x == PARAM_CATEGORY) {
				if (obj[x] == "null" || obj[x] == "") {
					category = null;
				} else {
					category = obj[x];	
				}
			}
			else if(x == PARAM_SEARCHTERMS) {
				if (obj[x] == "null" || obj[x] == "") {
					searchTerms = null;
				} else {
					searchTerms = obj[x];	
				}
			}
			else if(x == PARAM_SEARCHCOUNT) {
				if (obj[x] == "null" || obj[x] == "") {
					searchCount = null;
				} else {
					searchCount = obj[x];	
				}
				
			}
			else if(x == this.PARAM_STORE_ID) {
				storeId = obj[x];
			}
			else {
				// Attributes and extra parameters are interpreted differently depending on DDX settings
				if (!useDDX) {
					// When not using DDX, the attributes and parameters are passed on the same entry
					args.push(obj[x]);
					if (extraParams != null) {
						extraParams += ", ";
					} else {
						extraParams = "";
					}
					
					if (obj[x] == null || obj[x] == "null") {
						extraParams += "null";
					} else if (obj[x].charAt(0) == "\"" && obj[x].charAt(obj[x].length-1) == "\"") {
						extraParams += obj[x];
					} else {
						extraParams += "\"" + obj[x] + "\"";
					}
				} else {
					// When using DDX, the attributes and parameters are passed separately
					if(x == PARAM_EXTRA_PARAM) {
						extraParams = obj[x];
					} else if(x == PARAM_ATTRIBUTES) {
						attributes = obj[x];
					}
				}
			}
		}

		if (!useDDX) {
			/** useDDX is disabled **/
			if(!this._useHostedCMLib){
				/** put known variables at the beginning**/		
				args.unshift(pagename, category, searchTerms, searchCount, storeId);
			} else {
				/** put known variables at the beginning**/		
				args.unshift(pagename, category, searchTerms, searchCount);
			}

			/** call Coremetrics tag**/			
			cmCreatePageviewTag.apply({}, args);
		} else {
			/** useDDX is enabled **/
			if (pagename == null || pagename == "null" || pagename == "'null'") { pagename = '' };
			if (searchTerms == null || searchTerms == "null" || searchTerms == "'null'") { searchTerms = '' };
			if (searchCount == null || searchCount == "null" || searchCount == "'null'") { searchCount = '' };
			if (category == null || category == "null" || category == "'null'") { category = '' };
			if (attributes == null || attributes == "null" || attributes == "'null'") { attributes = '' };
			if (extraParams == null || extraParams == "null" || extraParams == "'null'") { extraParams = '' };
			if (pageType == null || pageType == "null" || pageType == "'null'") { pageType = '' };

			if (typeof digitalData === "undefined") {
				digitalData = {};
			}

			digitalData.page = {pageInfo:{pageID: pagename, onsiteSearchTerm: searchTerms, onsiteSearchResults: searchCount}, category:{primaryCategory: category}, attributes:{exploreAttributes: attributes ,extraFields: extraParams }};
			digitalData.pageInstanceID = pageType;
			// For debug purposes
			if (internalDebug) {
				window.alert(JSON.stringify(digitalData));
			}
		}

		var JSONtoLog = JSON.stringify(obj);
		var obj = document.getElementById('cm-pageview');
		if (debug && obj != null) {
			if (!useDDX) {
				var toLog = "cmCreatePageviewTag(";
				if (pagename != null && pagename != "" && pagename != "null") {
					toLog += "\"" + pagename + "\", ";
				} else {
					toLog += "null, ";
				}
				if (category != null && category != "" && category != "null") {
					toLog += "\"" + category + "\", ";
				} else {
					toLog += "null, ";
				}	
				if (searchTerms != null && searchTerms != "" && searchTerms != "null") {
					toLog += "\"" + searchTerms + "\", ";
				} else {
					toLog += "null, ";
				}		
				if (searchCount != null && searchCount != "" && searchCount != "null") {
					toLog += "\"" + searchCount + "\"";
				} else {
					toLog += "null";
				}	
				if (!this._useHostedCMLib) {
					if (storeId != null && storeId != "" && storeId != "null") {
						toLog += ", \"" + storeId + "\"";
					} else {
						toLog += ", null";
					}				
				}
				if (extraParams != null) {
					toLog += ", " + extraParams;
				}			
				toLog += ");";
			} else {
				var toLog = "digitalData = { ";
				toLog += "page:{pageInfo:{pageID: '" + pagename + "', onsiteSearchTerm: '" + searchTerms + "', onsiteSearchResults: '" + searchCount + "'}, category:{primaryCategory: '" + category + "'},";
				toLog += "attributes:{exploreAttributes: '" + attributes + "' ,extraFields: '" + extraParams + "'}},";
				toLog += "pageInstanceID: '" + pageType + "' };";
				// For debug purposes
				if (internalDebug) {
					window.alert(toLog);
				}
			}
			
			var JSONtoLogNode = document.createTextNode(JSONtoLog);
			obj.appendChild(JSONtoLogNode); 
			obj.appendChild(document.createElement('br'));
			
			var toLogNode = document.createTextNode(toLog);
			obj.appendChild(toLogNode); 
			obj.appendChild(document.createElement('br'));
		}
		
	},
	
	/** 
	 * Handler function for non eCommerce conversion events. Triggered when the topic "/wc/analytics/conversionevent" topic is published.
	 * @param{Object} obj JSON object containing the following fields;
	 * 		eventId		:  A unique identifier for the type of conversion, such as �Account Creation� or �Add to Wishlist�. 
	 * 		actionType	: A value of �1� or �2� depending upon whether a conversion initiation or a successful conversion 
	 * 						completion is generated. A value of 1 should be used when an event is initiated. A value of 2 should 
	 * 						be used when an event is successfully completed. Single-Step conversions should be represented by a 
	 * 						value of �2�.
	 *		category	: Allows grouping of event IDs into categories. 
	 *		points		: A point value used in establishing an arbitrary �value� for a conversion. The point value allows relative 
	 *						weighting of and Event�s �initiation� and �completion�.
	 * 
	 */
	handleConversionEvent: function(obj) {

		// For debug purposes
		var internalDebug = false;
		if (internalDebug) {
			window.alert("handleConversionEvent");
		}

		var PARAM_EVENTID = "eventId";
		var PARAM_CATEGORY = "category";
		var PARAM_ACTIONTYPE = "actionType";
		var PARAM_POINTS = "points";

		var PARAM_OPTIONS = "options";
		var PARAM_DEBUG = "debug";
		var PARAM_EXTRA_PARAM = "extraParams";
		var PARAM_ATTRIBUTES = "attributes";
		var PARAM_VALUE_USEDDX = "useDDX";
		var PARAM_VALUE_TRUE = "true";

		// set some defaults
		var eventId = null;
		var category = null;
		var actionType = null;
		var points = null;

		var attributes = null;
		var extraParams = null;

		var storeId = this._getStoreId();
		var args = new Array();
		
		var useDDX = false;
		var debug = false;

		// search object for known values and save the unknown ones
		for(x in obj) {
			if(x == PARAM_OPTIONS) {
				var options = obj[x];
				// useDDX is NOT supported for this case by Digital Analytics
				// Enable the three lines below when DDX is supported for this case
				// if (options == PARAM_VALUE_USEDDX) {
				//	useDDX = true;
				// }
			} else if (x == PARAM_DEBUG) {
				var debugParam = obj[x];
				if (debugParam == PARAM_VALUE_TRUE) {
					debug = true;
				}
			} else if(x == PARAM_EVENTID) {
				eventId = obj[x];
			}
			else if(x == PARAM_CATEGORY) {
				category = obj[x];
			}
			else if(x == PARAM_ACTIONTYPE) {
				actionType = obj[x];
			}
			else if(x == PARAM_POINTS) {
				points = obj[x];
			}
			else {
				// Attributes and extra parameters are interpreted differently depending on DDX settings
				if (!useDDX) {
					// When not using DDX, the attributes and parameters are passed on the same entry
					args.push(obj[x]);
				} else {
					// When using DDX, the attributes and parameters are passed separately
					if(x == PARAM_EXTRA_PARAM) {
						extraParams = obj[x];
					} else if(x == PARAM_ATTRIBUTES) {
						attributes = obj[x];
					}
				}
			}
		}
		
		if (!useDDX) {
			/** useDDX is disabled **/
			/** put known variables at the beginning**/
			args.unshift(eventId, actionType, category, points);
	
			/** call Coremetrics tag**/
			cmCreateConversionEventTag.apply({}, args);
		} else {
			/** useDDX is enabled **/
			if (eventId == null || eventId == "null" || eventId == "'null'") { eventId = '' };
			if (actionType == null || actionType == "null" || actionType == "'null'") { actionType = '' };
			if (points == null || points == "null" || points == "'null'") { points = '' };
			if (category == null || category == "null" || category == "'null'") { category = '' };
			if (attributes == null || attributes == "null" || attributes == "'null'") { attributes = '' };
			if (extraParams == null || extraParams == "null" || extraParams == "'null'") { extraParams = '' };
			
			if (typeof digitalData === "undefined") {
				digitalData = {};
				digitalData.pageInstanceID = 'wcs-standardpage_wcs-conversionevent';
			}

			digitalData.event = [{eventInfo:{eventName: eventId, eventAction: actionType, eventPoints: points}, category:{primaryCategory: category}, attributes:{exploreAttributes: attributes, extraFields: extraParams}}];
			// For debug purposes
			if (internalDebug) {
				window.alert(JSON.stringify(digitalData));
			}
		}
		
		var JSONtoLog = JSON.stringify(obj);
		var obj = document.getElementById('cm-conversionevent');
		if (debug && obj != null) {
			if (!useDDX) {
				var toLog = "cmCreateConversionEventTag(";
				if (eventId != null && eventId != "") {
					toLog += "\"" + eventId + "\", ";
				} else {
					toLog += "null, ";
				}
				if (actionType != null && actionType != "") {
					toLog += "\"" + actionType + "\", ";
				} else {
					toLog += "null, ";
				}		
				if (category != null && category != "") {
					toLog += "\"" + category + "\", ";
				} else {
					toLog += "null, ";
				}	
				if (points != null && points != "") {
					toLog += "\"" + points + "\"";
				} else {
					toLog += "null";
				}	
				toLog += ");";
			} else {
				var toLog = "digitalData = { ";
				if (digitalData.pageInstanceID != null && digitalData.pageInstanceID != "") {
			        	toLog += "pageInstanceID:'" + digitalData.pageInstanceID + "', ";
				}
			        toLog += "event:[{eventInfo:{eventName: '" + eventId + "', eventAction: '" + actionType + "', eventPoints: '" + points + "'}, category:{primaryCategory: '" + category + "'}, attributes:{exploreAttributes: '" + attributes + "', extraFields: '" + extraParams + "'}}]}";
				// For debug purposes
				if (internalDebug) {
					window.alert(toLog);
				}
			}
			
			var JSONtoLogNode = document.createTextNode(JSONtoLog);
			obj.appendChild(JSONtoLogNode); 
			obj.appendChild(document.createElement('br'));

			var toLogNode = document.createTextNode(toLog);
			obj.appendChild(toLogNode); 
			obj.appendChild(document.createElement('br'));
		}
		
	},	
	
	/** 
	 *  This function is the handler for ProductView events .This is the method called when a ProductView event is triggered via the "/wc/analytics/productview" topic.
	 * @param{Object} obj JSON object containing the following fields;
	 * 	                productId (required), the product identifier for the product being viewed. Typically contains the SKU.
	 *                  name (required), the name of the product.
	 *                  category (required), the catalog category of the product being viewed or virtual category
	 *                  such as "Search" or "Cross-sell".
	 *                  masterCategory (required), the catalog category of the product being viewed from the store's master catalog
	 * 
	 */
	handleProductView: function(obj) {

		// For debug purposes
		var internalDebug = false;
		if (internalDebug) {
			window.alert("handleProductView");
		}

		var PARAM_PRODUCTID = "productId";
		var PARAM_PRODUCTNAME = "name";
		var PARAM_CATEGORY = "category";
		var PARAM_MASTERCATEGORY = "masterCategory";
		var PARAM_VIRTUAL_CATEGORY = "virtualCategory";
		var PARAM_ATTRIBUTES = "attributes";
		var PARAM_VALUE_USEDDX = "useDDX";
		var PARAM_VALUE_TRUE = "true";
	
		/** set some defaults**/
		var productId = null;
		var productName = null;
		var category = null;
		var masterCategory = null;

		var attributes = null;
		var virtualCategory = null;
	
		var storeId = this._getStoreId();
		var extraParams = null;

		var useDDX = false;
		var debug = false;

		if(obj.options == PARAM_VALUE_USEDDX) {
			useDDX = true;
		}
		
		if (obj.debug == PARAM_VALUE_TRUE) {
			debug = true;
		}

		if(obj.product && dojo.isArrayLike(obj.product)) {
			if (useDDX) {
				if (typeof digitalData === "undefined") {
					digitalData = {};
					digitalData.pageInstanceID='wcs-standardpage_wcs-productdetail';
				}
				digitalData.product = new Array();
			}

			var product = obj.product;
			for(var i = 0; i < product.length; i++) {
				var values = product[i];
				var args = new Array();
				
				/** search object for known values and save the unknown ones **/
				for(x in values) {
					if(x == PARAM_PRODUCTID) {
						productId = values[x];
					}
					else if(x == PARAM_PRODUCTNAME) {
						productName = values[x];
					}
					else if(x == PARAM_CATEGORY) {
						category = values[x];
					}
					else if(x == PARAM_MASTERCATEGORY) {
						masterCategory = values[x];
					}
					else if(x == this.PARAM_STORE_ID) {
						storeId = values[x];
					}
					else {
						// Attributes and extra parameters are interpreted differently depending on DDX settings
						if (!useDDX) {
							// When not using DDX, the attributes and parameters are passed on the same entry
							args.push(values[x]);
							if (extraParams != null) {
								extraParams += ", ";
							} else {
								extraParams = "";
							}
						
							if (values[x] == null || values[x] == "null") {
								extraParams += "null";
							} else if (values[x].charAt(0) == "\"" && values[x].charAt(values[x].length-1) == "\"") {
								extraParams += values[x];
							} else {
								extraParams += "\"" + values[x] + "\"";
							}
						} else {
							// When using DDX, the attributes and virtual category are passed separately
							if(x == PARAM_ATTRIBUTES) {
								attributes = values[x];
							} else if(x == PARAM_VIRTUAL_CATEGORY) {
								virtualCategory = values[x];
							}
						}
					}
				}
				
				/** enforce required parameters **/
				if((productId == null) || (productName == null) || (category == null) || (masterCategory == null)) {

				}
				else {
					if (!useDDX) {
						if(!this._useHostedCMLib){
							/** put known variables at the beginning **/
							args.unshift(null, productId, productName, category, storeId, "N", masterCategory);
						} else {
							/** put known variables at the beginning **/
							args.unshift(productId, productName, category);
						}
					
						/** call Coremetrics tag **/
						cmCreateProductviewTag.apply({}, args);
					} else {
						/** useDDX is enabled **/
						if (productId == null || productId == "null" || productId == "'null'") { productId = '' };
						if (productName == null || productName == "null" || productName == "'null'") { productName = '' };
						if (category == null || category == "null" || category == "'null'") { category = '' };
						if (virtualCategory == null || virtualCategory == "null" || virtualCategory == "'null'") { virtualCategory = '' };
						if (attributes == null || attributes == "null" || attributes == "'null'") { attributes = '' };
						
						digitalData.product[i] = {productInfo:{productID: productId, productName: productName}, category:{primaryCategory: category, virtualCategory: virtualCategory}, attributes:{exploreAttributes: attributes}};
						// For debug purposes
						if (internalDebug) {
							window.alert(JSON.stringify(digitalData));
						}
					}
					
					var JSONtoLog = JSON.stringify(obj);
					var obj = document.getElementById('cm-productview');
					if (debug && obj != null) {
						if (!useDDX) {
							var toLog = "";
							if(!this._useHostedCMLib){
								toLog = "cmCreateProductviewTag(null, ";
							} else {
								toLog = "cmCreateProductviewTag(";
							}
							if (productId != null && productId != "") {
								toLog += "\"" + productId + "\", ";
							} else {
								toLog += "null, ";
							}
							if (productName != null && productName != "") {
								productName = productName.replace(/\"/g, '\\\"');
								toLog += "\"" + productName + "\", ";
							} else {
								toLog += "null, ";
							}	
							if (category != null && category != "") {
								toLog += "\"" + category + "\"";
							} else {
								toLog += "null";
							}	
							if(!this._useHostedCMLib){
								if (storeId != null && storeId != "") {
									toLog += ", \"" + storeId + "\", \"N\", ";
								} else {
									toLog += ", null, \"N\", ";
								}		
								if (masterCategory != null && masterCategory != "") {
									toLog += "\"" + masterCategory + "\"";
								} else {
									toLog += "null";
								}				
							}
							if (extraParams != null) {
								toLog += ", " + extraParams;
							}
							toLog += ");";
						} else {
							// TODO: For simplicitly, we are only logging the contents of digitalData.product
							// And not digitalData.pageInstanceID
							
							var toLog = "digitalData.product[" + i + "] = { ";
							toLog += "productInfo:{productID: '" + productId + "', productName: '" + productName + "'},category:{primaryCategory: '" + category + "', virtualCategory: '" + virtualCategory + "'},attributes:{exploreAttributes: '" + attributes + "'}};";
							// For debug purposes
							if (internalDebug) {
								window.alert(toLog);
							}
						}

						var JSONtoLogNode = document.createTextNode(JSONtoLog);
						obj.appendChild(JSONtoLogNode); 
						obj.appendChild(document.createElement('br'));
			
						var toLogNode = document.createTextNode(toLog);
						obj.appendChild(toLogNode); 
						obj.appendChild(document.createElement('br'));
					}			
				}
			}
		}
	},

	/**
	 *  This function is a handler for CartView events.This is the method called when a CartView event is triggered via the "/wc/analytics/cartview" topic.
	 * @param{Object} obj  JSON object with a single 'cart' array where each element is an Object containing the following fields;
		*       productId (required), the product identifier for the product being viewed. Typically contains the SKU.
		*       name (required), the name of the product.
		*       category (required), the catalog category of the product being viewed or virtual category
		*       such as "Search" or "Cross-sell".
		*       masterCategory (required), the catalog category of the product being viewed from the store's master catalog.
		*       quantity (required), the number of units ordered.
		*       price (required), the selling price fo the product.
		*       currency (required), the currency of the price.
	 */

	handleCartView: function(obj) {

		// For debug purposes
		var internalDebug = false;
		if (internalDebug) {
			window.alert("handleCartView");
		}

		var PARAM_PRODUCTID = "productId";
		var PARAM_PRODUCTNAME = "name";
		var PARAM_CATEGORY = "category";
		var PARAM_MASTERCATEGORY = "masterCategory";
		var PARAM_QTY = "quantity";
		var PARAM_PRICE = "price";
		var PARAM_CURRENCY = "currency";
		var PARAM_EXTRA_PARAM = "extraParams";
		var PARAM_ATTRIBUTES = "attributes";
		var PARAM_VALUE_USEDDX = "useDDX";
		var PARAM_VALUE_TRUE = "true";
		var PARAM_VALUE_FALSE = "false";

		var attributes = null;
		var extraParams = null;
		// virtualCategory is not used
		var virtualCategory = null;

		var useDDX = false;
		// By default, we must use cmSetupOther
		var useCMSetupOther = true;
		var debug = false;

		if(obj.options == PARAM_VALUE_USEDDX) {
			useDDX = true;
		}

		if (obj.useCMSetupOther == PARAM_VALUE_TRUE) {
			useCMSetupOther = true;
		} else if (obj.useCMSetupOther == PARAM_VALUE_FALSE) {
			useCMSetupOther = false;
		}
		
		if (obj.debug == PARAM_VALUE_TRUE) {
			debug = true;
		}

		var shop5created = false;

		if(obj.cart && dojo.isArrayLike(obj.cart)) {
			if (useDDX) {
				if (typeof digitalData === "undefined") {
					digitalData = {};
					digitalData.pageInstanceID='wcs-standardpage_wcs-cart';
				}
				digitalData.cart = {};
				digitalData.cart.item = new Array();
			}

			var cart = obj.cart;
			for(var i = 0; i < cart.length; i++) {
				// set some defaults
				var productId = null;
				var productName = null;
				var category = null;
				var masterCategory = null;
				var quantity = null;
				var price = null;
				var currency = null;
			
				var storeId = this._getStoreId();
				var args = new Array();
				var extraParams = null;
				
				var values = cart[i];

				/** search object for known values and save the unknown ones **/
				for(x in values) {
					if(x == PARAM_PRODUCTID) {
						productId = values[x];
					}
					else if(x == PARAM_PRODUCTNAME) {
						productName = values[x];
					}
					else if(x == PARAM_CATEGORY) {
						category = values[x];
					}
					else if(x == PARAM_MASTERCATEGORY) {
						masterCategory = values[x];
					}
					else if(x == PARAM_QTY) {
						quantity = values[x];
					}
					else if(x == PARAM_PRICE) {
						price = values[x];
					}
					else if(x == PARAM_CURRENCY) {
						currency = values[x];
					}
					else if(x == this.PARAM_STORE_ID) {
						storeId = values[x];
					}
					else {
						// Attributes and extra parameters are interpreted differently depending on DDX settings
						if (!useDDX) {
							args.push(values[x]);
							if (extraParams != null) {
								extraParams += ", ";
							} else {
								extraParams = "";
							}
						
							if (values[x] == null || values[x] == "null") {
								extraParams += "null";
							} else if (values[x].charAt(0) == "\"" && values[x].charAt(values[x].length-1) == "\"") {
								extraParams += values[x];
							} else {
								extraParams += "\"" + values[x] + "\"";
							}
						} else {
							// When using DDX, the attributes and parameters are passed separately
							if(x == PARAM_ATTRIBUTES) {
								attributes = values[x];
							} else if(x == PARAM_EXTRA_PARAM) {
								extraParams = values[x];
							}
						}
					}
				}

				/**enforce required parameters**/
				if((productId == null) || (productName == null) || (category == null) || (masterCategory == null) ||
						(quantity == null) || (price == null) || (currency == null)) {

				}
				else {
					if (!useDDX) {
						shop5created = true;
					
						/** put known variables at the beginning**/
						if (!this._useHostedCMLib) {
							args.unshift(productId, productName, quantity, price, category, storeId, currency, masterCategory);
							/**
						 	*  call Coremetrics tag
						 	*/
							cmCreateShopAction5Tag.apply({}, args);
						} else {
							cmSetCurrencyCode(currency);
							var logObj = document.getElementById('cm-shopAction');
							if (debug && logObj != null) {
								var tlog = "cmSetCurrencyCode(\"" + currency + "\");";
								var tNode = document.createTextNode(tlog);
								logObj.appendChild(tNode); 
								logObj.appendChild(document.createElement('br'));
							}
						
							args.unshift(productId, productName, quantity, price, category);	
							cmCreateShopAction5Tag.apply({}, args);
						}
					} else {
						/** useDDX is enabled **/
						if (productId == null || productId == "null" || productId == "'null'") { productId = '' };
						if (productName == null || productName == "null" || productName == "'null'") { productName = '' };
						if (quantity == null || quantity == "null" || quantity == "'null'") { quantity = '' };
						if (price == null || price == "null" || price == "'null'") { price = '' };
						if (currency == null || currency == "null" || currency == "'null'") { currency = '' };
						if (category == null || category == "null" || category == "'null'") { category = '' };
						if (virtualCategory == null || virtualCategory == "null" || virtualCategory == "'null'") { virtualCategory = '' };
						if (attributes == null || attributes == "null" || attributes == "'null'") { attributes = '' };
						if (extraParams == null || extraParams == "null" || extraParams == "'null'") { extraParams = '' };

						digitalData.cart.item[i] = {};
						digitalData.cart.item[i] = {productInfo:{productID: productId, productName: productName}, quantity: quantity, price: price, currency: currency, category:{primaryCategory: category, virtualCategory: virtualCategory}, attributes:{exploreAttributes: attributes, extraFields: extraParams}};

						if (useCMSetupOther) {
							cmSetupOther({"cm_currencyCode":"\"" + currency + "\""});
						}

						// For debug purposes
						if (internalDebug) {
							window.alert(JSON.stringify(digitalData));
						}
					}
					
					var JSONtoLog = JSON.stringify(obj);
					var obj = document.getElementById('cm-shopAction');
					if (debug && obj != null) {
						if (!useDDX) {
							var toLog = "cmCreateShopAction5Tag(";
							if (productId != null && productId != "") {
								toLog += "\"" + productId + "\", ";
							} else {
								toLog += "null, ";
							}
							if (productName != null && productName != "") {
								productName = productName.replace(/\"/g, '\\\"');
								toLog += "\"" + productName + "\", ";
							} else {
								toLog += "null, ";
							}	
							if (quantity != null && quantity != "") {
								toLog += "\"" + quantity + "\", ";
							} else {
								toLog += "null, ";
							}
							if (price != null && price != "") {
								toLog += "\"" + price + "\", ";
							} else {
								toLog += "null, ";
							}	
							if (category != null && category != "") {
								toLog += "\"" + category + "\"";
							} else {
								toLog += "null";
							}
							if (!this._useHostedCMLib) {
								if (storeId != null && storeId != "") {
									toLog += ", \"" + storeId + "\", ";
								} else {
									toLog += ", null, ";
								}
								if (currency != null && currency != "") {
									toLog += "\"" + currency + "\", ";
								} else {
									toLog += "null, ";
								}								
								if (masterCategory != null && masterCategory != "") {
									toLog += "\"" + masterCategory + "\"";
								} else {
									toLog += "null";
								}				
							}
							if (extraParams != null) {
								toLog += ", " + extraParams;
							}
							toLog += ");";
						} else {
							// TODO: For simplicitly, we are only logging the contents of digitalData.cart
							// And not digitalData.pageInstanceID
							
							var toLog = "digitalData.cart.item[" + i + "] = { ";
							toLog += "productInfo:{productID: '" + productId + "', productName: '" + productName + "'}, quantity: '" + quantity + "', price: '" + price + "', currency: '" + currency + "', category:{primaryCategory: '" + category + "', virtualCategory: '" + virtualCategory + "'}, attributes:{exploreAttributes: '" + attributes + "', extraFields: '" + extraParams + "'}};";

							if (useCMSetupOther) { 
								toLog += "cmSetupOther({\"cm_currencyCode\":\"" + currency + "\"});";
							}

							// For debug purposes
							if (internalDebug) {
								window.alert(toLog);
							}
						}
						
						var JSONtoLogNode = document.createTextNode(JSONtoLog);
						obj.appendChild(JSONtoLogNode); 
						obj.appendChild(document.createElement('br'));
			
						var toLogNode = document.createTextNode(toLog);
						obj.appendChild(toLogNode); 
						obj.appendChild(document.createElement('br'));
					}
				}
			}
		}
		else {

		}
		
		if(shop5created) {
			cmDisplayShop5s();
			var logObj = document.getElementById('cm-shopAction');
			if (debug && logObj != null) {
				var tlog = "cmDisplayShop5s();";
				var tNode = document.createTextNode(tlog);
				logObj.appendChild(tNode); 
				logObj.appendChild(document.createElement('br'));
			}
		}
		
	},

	/**
	 *  This function is a handler for AddCart events.This is the method called when an AddCart event is triggered via the "/wc/analytics/addcart" topic.
	 * @param{Object} obj  JSON object with a single 'cart' array where each element is an Object containing the following fields;
		*       productId (required), the product identifier for the product being viewed. Typically contains the SKU.
		*       name (required), the name of the product.
		*       category (required), the catalog category of the product being viewed or virtual category
		*       such as "Search" or "Cross-sell".
		*       masterCategory (required), the catalog category of the product being viewed from the store's master catalog.
		*       quantity (required), the number of units ordered.
		*       price (required), the selling price fo the product.
		*       currency (required), the currency of the price.
	 */

	handleAddCart: function(obj) {

		// For debug purposes
		var internalDebug = false;
		if (internalDebug) {
			window.alert("handleAddCart");
		}

		var PARAM_PRODUCTID = "productId";
		var PARAM_PRODUCTNAME = "name";
		var PARAM_CATEGORY = "category";
		var PARAM_MASTERCATEGORY = "masterCategory";
		var PARAM_QTY = "quantity";
		var PARAM_PRICE = "price";
		var PARAM_CURRENCY = "currency";
		var PARAM_EXTRA_PARAM = "extraParams";
		var PARAM_ATTRIBUTES = "attributes";
		var PARAM_VALUE_USEDDX = "useDDX";
		var PARAM_VALUE_TRUE = "true";
		var PARAM_VALUE_FALSE = "false";

		var attributes = null;
		var extraParams = null;
		// virtualCategory is not used
		var virtualCategory = null;

		var useDDX = false;
		// By default, we must use cmSetupOther
		var useCMSetupOther = true;
		var debug = false;

		// useDDX is NOT supported for this case by Digital Analytics
		// Enable the three lines below when DDX is supported for this case
		// if(obj.options == PARAM_VALUE_USEDDX) {
		//	useDDX = true;
		// }

		if (obj.useCMSetupOther == PARAM_VALUE_TRUE) {
			useCMSetupOther = true;
		} else if (obj.useCMSetupOther == PARAM_VALUE_FALSE) {
			useCMSetupOther = false;
		}
		
		if (obj.debug == PARAM_VALUE_TRUE) {
			debug = true;
		}

		var shop5created = false;

		if(obj.cart && dojo.isArrayLike(obj.cart)) {
			if (useDDX) {
				if (typeof digitalData === "undefined") {
					digitalData = {};
					digitalData.pageInstanceID='wcs-standardpage_wcs-cart';
				}
				digitalData.cart = {};
				digitalData.cart.item = new Array();
			}

			var cart = obj.cart;
			for(var i = 0; i < cart.length; i++) {
				// set some defaults
				var productId = null;
				var productName = null;
				var category = null;
				var masterCategory = null;
				var quantity = null;
				var price = null;
				var currency = null;
			
				var storeId = this._getStoreId();
				var args = new Array();
				var extraParams = null;
				
				var values = cart[i];

				/** search object for known values and save the unknown ones **/
				for(x in values) {
					if(x == PARAM_PRODUCTID) {
						productId = values[x];
					}
					else if(x == PARAM_PRODUCTNAME) {
						productName = values[x];
					}
					else if(x == PARAM_CATEGORY) {
						category = values[x];
					}
					else if(x == PARAM_MASTERCATEGORY) {
						masterCategory = values[x];
					}
					else if(x == PARAM_QTY) {
						quantity = values[x];
					}
					else if(x == PARAM_PRICE) {
						price = values[x];
					}
					else if(x == PARAM_CURRENCY) {
						currency = values[x];
					}
					else if(x == this.PARAM_STORE_ID) {
						storeId = values[x];
					}
					else {
						// Attributes and extra parameters are interpreted differently depending on DDX settings
						if (!useDDX) {
							args.push(values[x]);
							if (extraParams != null) {
								extraParams += ", ";
							} else {
								extraParams = "";
							}
						
							if (values[x] == null || values[x] == "null") {
								extraParams += "null";
							} else if (values[x].charAt(0) == "\"" && values[x].charAt(values[x].length-1) == "\"") {
								extraParams += values[x];
							} else {
								extraParams += "\"" + values[x] + "\"";
							}
						} else {
							// When using DDX, the attributes and parameters are passed separately
							if(x == PARAM_ATTRIBUTES) {
								attributes = values[x];
							} else if(x == PARAM_EXTRA_PARAM) {
								extraParams = values[x];
							}
						}
					}
				}

				/**enforce required parameters**/
				if((productId == null) || (productName == null) || (category == null) || (masterCategory == null) ||
						(quantity == null) || (price == null) || (currency == null)) {

				}
				else {
					if (!useDDX) {
						shop5created = true;
					
						/** put known variables at the beginning**/
						if (!this._useHostedCMLib) {
							args.unshift(productId, productName, quantity, price, category, storeId, currency, masterCategory);
							/**
						 	*  call Coremetrics tag
						 	*/
							cmCreateShopAction5Tag.apply({}, args);
						} else {
							cmSetCurrencyCode(currency);
							var logObj = document.getElementById('cm-shopAction');
							if (debug && logObj != null) {
								var tlog = "cmSetCurrencyCode(\"" + currency + "\");";
								var tNode = document.createTextNode(tlog);
								logObj.appendChild(tNode); 
								logObj.appendChild(document.createElement('br'));
							}
						
							args.unshift(productId, productName, quantity, price, category);	
							cmCreateShopAction5Tag.apply({}, args);
						}
					} else {
						/** useDDX is enabled **/
						if (productId == null || productId == "null" || productId == "'null'") { productId = '' };
						if (productName == null || productName == "null" || productName == "'null'") { productName = '' };
						if (quantity == null || quantity == "null" || quantity == "'null'") { quantity = '' };
						if (price == null || price == "null" || price == "'null'") { price = '' };
						if (currency == null || currency == "null" || currency == "'null'") { currency = '' };
						if (category == null || category == "null" || category == "'null'") { category = '' };
						if (virtualCategory == null || virtualCategory == "null" || virtualCategory == "'null'") { virtualCategory = '' };
						if (attributes == null || attributes == "null" || attributes == "'null'") { attributes = '' };
						if (extraParams == null || extraParams == "null" || extraParams == "'null'") { extraParams = '' };

						digitalData.cart.item[i] = {};
						digitalData.cart.item[i] = {productInfo:{productID: productId, productName: productName}, quantity: quantity, price: price, currency: currency, category:{primaryCategory: category, virtualCategory: virtualCategory}, attributes:{exploreAttributes: attributes, extraFields: extraParams}};

						if (useCMSetupOther) {
							cmSetupOther({"cm_currencyCode":"\"" + currency + "\""});
						}

						// For debug purposes
						if (internalDebug) {
							window.alert(JSON.stringify(digitalData));
						}
					}
					
					var JSONtoLog = JSON.stringify(obj);
					var obj = document.getElementById('cm-shopAction');
					if (debug && obj != null) {
						if (!useDDX) {
							var toLog = "cmCreateShopAction5Tag(";
							if (productId != null && productId != "") {
								toLog += "\"" + productId + "\", ";
							} else {
								toLog += "null, ";
							}
							if (productName != null && productName != "") {
								productName = productName.replace(/\"/g, '\\\"');
								toLog += "\"" + productName + "\", ";
							} else {
								toLog += "null, ";
							}	
							if (quantity != null && quantity != "") {
								toLog += "\"" + quantity + "\", ";
							} else {
								toLog += "null, ";
							}
							if (price != null && price != "") {
								toLog += "\"" + price + "\", ";
							} else {
								toLog += "null, ";
							}	
							if (category != null && category != "") {
								toLog += "\"" + category + "\"";
							} else {
								toLog += "null";
							}
							if (!this._useHostedCMLib) {
								if (storeId != null && storeId != "") {
									toLog += ", \"" + storeId + "\", ";
								} else {
									toLog += ", null, ";
								}
								if (currency != null && currency != "") {
									toLog += "\"" + currency + "\", ";
								} else {
									toLog += "null, ";
								}								
								if (masterCategory != null && masterCategory != "") {
									toLog += "\"" + masterCategory + "\"";
								} else {
									toLog += "null";
								}				
							}
							if (extraParams != null) {
								toLog += ", " + extraParams;
							}
							toLog += ");";
						} else {
							// TODO: For simplicitly, we are only logging the contents of digitalData.cart
							// And not digitalData.pageInstanceID
							
							var toLog = "digitalData.cart.item[" + i + "] = { ";
							toLog += "productInfo:{productID: '" + productId + "', productName: '" + productName + "'}, quantity: '" + quantity + "', price: '" + price + "', currency: '" + currency + "', category:{primaryCategory: '" + category + "', virtualCategory: '" + virtualCategory + "'}, attributes:{exploreAttributes: '" + attributes + "', extraFields: '" + extraParams + "'}};";

							if (useCMSetupOther) { 
								toLog += "cmSetupOther({\"cm_currencyCode\":\"" + currency + "\"});";
							}

							// For debug purposes
							if (internalDebug) {
								window.alert(toLog);
							}
						}
						
						var JSONtoLogNode = document.createTextNode(JSONtoLog);
						obj.appendChild(JSONtoLogNode); 
						obj.appendChild(document.createElement('br'));
			
						var toLogNode = document.createTextNode(toLog);
						obj.appendChild(toLogNode); 
						obj.appendChild(document.createElement('br'));
					}
				}
			}
		}
		else {

		}
		
		if(shop5created) {
			cmDisplayShop5s();
			var logObj = document.getElementById('cm-shopAction');
			if (debug && logObj != null) {
				var tlog = "cmDisplayShop5s();";
				var tNode = document.createTextNode(tlog);
				logObj.appendChild(tNode); 
				logObj.appendChild(document.createElement('br'));
			}
		}
		
	},

	/**
	* This function is a handler for Element events.This is the method called when an Element event is triggered via the "/wc/analytics/element" topic. This is an empty placeholder that should be extended by the implementation.
	* @param{Object} obj JSON object containing the following fields;
	*    elementId (required), the identifier for the element being interacted with.
	*       category (optional), the category of the element.
	*       pageId (optional), the ID of the associated page that the element is on.
	*       pageCategory (optional), the category of the associated page that the element is on.
	*       location (optional), the location of the element on the page. For example, "top navigation" or "footer". 
	 */

	handleElement: function(obj) {
		
		// For debug purposes
		var internalDebug = false;
		if (internalDebug) {
			window.alert("handleElement");
		}

		var PARAM_ELEMENTID = "elementId";
		var PARAM_CATEGORY = "category";
		var PARAM_PAGEID = "pageId";
		var PARAM_PAGECATEGORY = "pageCategory";
		var PARAM_LOCATION = "location";
	
		var PARAM_OPTIONS = "options";
		var PARAM_DEBUG = "debug";
		var PARAM_EXTRA_PARAM = "extraParams";
		var PARAM_VALUE_USEDDX = "useDDX";
		var PARAM_VALUE_TRUE = "true";

		/** set some defaults**/
		var elementId = null;
		var category = null;
		var pageId = null;
		var pageCategory = null;
		var elementLocation = null;
	
		var extraParams = null;

		var storeId = this._getStoreId();
		var args = new Array();
	
		var useDDX = false;
		var debug = false;

		/** search object for known values and save the unknown ones**/
		for(x in obj) {
			if(x == PARAM_OPTIONS) {
				var options = obj[x];
				if (options == PARAM_VALUE_USEDDX) {
					useDDX = true;
				}
			} else if (x == PARAM_DEBUG) {
				var debugParam = obj[x];
				if (debugParam == PARAM_VALUE_TRUE) {
					debug = true;
				}
			} else if(x == PARAM_ELEMENTID) {
				elementId = obj[x];
			}
			else if(x == PARAM_CATEGORY) {
				category = obj[x];
			}
			else if(x == PARAM_PAGEID) {
				pageId = obj[x];
			}
			else if(x == PARAM_PAGECATEGORY) {
				pageCategory = obj[x];
			}
			else if(x == PARAM_LOCATION) {
				elementLocation = obj[x];
			}
			else if(x == this.PARAM_STORE_ID) {
				storeId = obj[x];
			}
			else {
				// Attributes and extra parameters are interpreted differently depending on DDX settings
				if (!useDDX) {
					// When not using DDX, the parameters are passed on the same entry
					args.push(obj[x]);
				} else {
					// When using DDX, the parameters are passed separately
					// Notice that in this case, the explore attributes are stored under extraParams
					// This is for consistency with the non-DDX scenario	
					if(x == PARAM_EXTRA_PARAM) {
						extraParams = obj[x];
					}
				}
			}
		}
		
		/** enforce required parameters**/
		if(elementId == null) {
		}
		else {
			if (!useDDX) {
				/** useDDX is disabled **/
				/** put known variables at the beginning**/
			
				if (!this._useHostedCMLib) {
					args.unshift(elementId, category, pageId, pageCategory, elementLocation, storeId);
					/** call Coremetrics tag**/
					cmCreatePageElementTag.apply({}, args);

				} else {
					args.unshift(elementId, category);
					/** call Coremetrics tag**/
					cmCreateElementTag.apply({}, args);
				}
			} else {
				/** useDDX is enabled **/
				if (elementId == null || elementId == "null" || elementId == "'null'") { elementId = '' };
				if (category == null || category == "null" || category == "'null'") { category = '' };
				if (extraParams == null || extraParams == "null" || extraParams == "'null'") { extraParams = '' };
		
				// Notice that in this case, the explore attributes are stored under extraParams
				// This is for consistency with the non-DDX scenario	
				if (typeof digitalData === "undefined") {
					digitalData = {};
					digitalData.pageInstanceID = 'wcs-standardpage_wcs-element';
				}

				digitalData.component = [{componentInfo:{componentID: elementId},category:{primaryCategory: category},attributes:{exploreAttributes: extraParams}}];	
				// For debug purposes
				if (internalDebug) {
					window.alert(JSON.stringify(digitalData));
				}
			}
				
			var JSONtoLog = JSON.stringify(obj);
			var obj = document.getElementById('cm-element');
			if (debug && obj != null) {
				if (!useDDX) {
					var toLog = "";
					if (!this._useHostedCMLib) {
						toLog = "cmCreatePageElementTag("; 
					} else {
						toLog = "cmCreateElementTag(";
					}
				
					if (elementId != null && elementId != "") {
						toLog += "\"" + elementId + "\", ";
					} else {
						toLog += "null, ";
					}
					if (category != null && category != "") {
						toLog += "\"" + category + "\"";
					} else {
						toLog += "null";
					}	
				
					if (!this._useHostedCMLib) {
						if (pageId != null && pageId != "") {
							toLog += ", \"" + pageId + "\", ";
						} else {
							toLog += ", null, ";
						}	
						if (pageCategory != null && pageCategory != "") {
							toLog += "\"" + pageCategory + "\", ";
						} else {
							toLog += "null, ";
						}
						if (elementLocation != null && elementLocation != "") {
							toLog += "\"" + elementLocation + "\", ";
						} else {
							toLog += "null, ";
						}	
						if (storeId != null && storeId != "") {
							toLog += "\"" + storeId + "\"";
						} else {
							toLog += "null";
						}									
					}
					toLog += ");";
				} else {
					var toLog = "digitalData = { ";
					if (digitalData.pageInstanceID != null && digitalData.pageInstanceID != "") {
			        		toLog += "pageInstanceID:'" + digitalData.pageInstanceID + "', ";
					}
					toLog += "component:[{componentInfo:{componentID: '" + elementId + "'},category:{primaryCategory: '" + category + "'},attributes:{exploreAttributes: '" + extraParams + "'}}]}";	
					// For debug purposes
					if (internalDebug) {
						window.alert(toLog);
					}
				}
				
				var JSONtoLogNode = document.createTextNode(JSONtoLog);
				obj.appendChild(JSONtoLogNode); 
				obj.appendChild(document.createElement('br'));

				var toLogNode = document.createTextNode(toLog);
				obj.appendChild(toLogNode); 
				obj.appendChild(document.createElement('br'));
			}
			
		}
	},
	/**
	 * This function is a handler for Registration events
	 * @param obj JSON object containing the following fields:
	 *            userId,userEmail,userCity,userState,userZip,newsletterName,subscribedFlag,storeId,userCountry,age,gender,maritalStatus,numChildren,numInHousehold
	 *            companyName,hobbies,income
	 */
	handleRegistration: function(obj) {

		// For debug purposes
		var internalDebug = false;
		if (internalDebug) {
			window.alert("handleRegistration");
		}

		// known parameters
		var PARAM_USERID = "userId";
		var PARAM_USEREMAIL = "userEmail";
		var PARAM_USERCITY = "userCity";
		var PARAM_USERSTATE = "userState";
		var PARAM_USERZIP = "userZip";
		var PARAM_NEWSLETTERNAME = "newsletterName";
		var PARAM_SUBSCRIBEDFLAG = "subscribedFlag";
		var PARAM_STOREID = "storeId";
		var PARAM_USERCOUNTRY = "userCountry";
		var PARAM_AGE = "age";
		var PARAM_GENDER = "gender";
		var PARAM_MARITALSTATUS = "maritalStatus";
		var PARAM_NUMCHILDREN = "numChildren";
		var PARAM_NUMINHOUSEHOLD = "numInHousehold";
		var PARAM_COMPANYNAME = "companyName";
		var PARAM_HOBBIES = "hobbies";
		var PARAM_INCOME = "income";
		// For registration tag we only use extraParams 0
		var PARAM_ATTRIBS = "extraParams0";

		var PARAM_OPTIONS = "options";
		var PARAM_DEBUG = "debug";
		var PARAM_EXTRA_PARAM = "extraParams";
		var PARAM_VALUE_USEDDX = "useDDX";
		var PARAM_VALUE_TRUE = "true";

		var userId = null;
		var userEmail = null;
		var userCity = null;
		var userState = null;
		var userZip = null;
		var newsletterName = null;
		var subscribedFlag = null;
		var userCountry = null;
		var age = null;
		var gender = null;
		var maritalStatus = null;
		var numChildren = null;
		var numInHousehold = null;
		var companyName = null;
		var hobbies = null;
		var income = null;
		var attribs = null;
		var storeId = this._getStoreId();
		var args = new Array();
		var extraParams = null;

		var useDDX = false;
		var debug = false;
		
		/** search object for known values and save the unknown ones**/
		for(x in obj) {
			if(x == PARAM_OPTIONS) {
				var options = obj[x];
				if (options == PARAM_VALUE_USEDDX) {
					useDDX = true;
				}
			} else if (x == PARAM_DEBUG) {
				var debugParam = obj[x];
				if (debugParam == PARAM_VALUE_TRUE) {
					debug = true;
				}
			} else if(x == PARAM_USERID) {
				userId = obj[x];
			}
			else if(x == PARAM_USEREMAIL ) {
				userEmail = obj[x];
			}
			else if(x == PARAM_USERCITY) {
				userCity = obj[x];
			}
			else if(x == PARAM_USERSTATE) {
				userState = obj[x];
			}
			else if(x == PARAM_USERZIP) {
				userZip = obj[x];
			}
			else if(x == PARAM_NEWSLETTERNAME ) {
				newsletterName = obj[x];
			}
			else if(x == PARAM_SUBSCRIBEDFLAG) {
				subscribedFlag = obj[x];
			}
			else if(x == PARAM_STOREID) {
				storeId = obj[x];
			}
			else if(x == PARAM_USERCOUNTRY) {
				userCountry = obj[x];
			}
			else if(x == PARAM_AGE) {
				
				var temp = obj[x];
				if(temp == "0" || temp == ""){
					age = "null"
				}else{
					age = temp;
				}
				
			}
			else if(x == PARAM_GENDER ) {
				var temp = obj[x];
				if(temp == ""){
					gender = "null"
				}else{
					gender = temp;
				}
							
			}
			else if(x == PARAM_MARITALSTATUS) {
				var temp = obj[x];
				if(temp == ""){
					maritalStatus = "null"
				}else{
					maritalStatus = temp;
				}
				
			}
			else if(x == PARAM_NUMCHILDREN) {
				
				var temp = obj[x];
				if(temp == "0" || temp == ""){
					numChildren = "null"
				}else{
					numChildren = temp;
				}
				
				
			}
			else if(x == PARAM_NUMINHOUSEHOLD) {
				var temp = obj[x];
				if(temp == "0" || temp == ""){
					numInHousehold = "null"
				}else{
					numInHousehold = temp;
				}
				
				
			}			
			else if(x == PARAM_COMPANYNAME) {
				var temp = obj[x];
				if(temp == ""){
					companyName = "null"
				}else{
					companyName = temp;
				}
				
			}
			else if(x == PARAM_HOBBIES) {
				var temp = obj[x];
				if(temp == ""){
					hobbies = "null"
				}else{
					hobbies = temp;
				}
				
			}
			else if(x == PARAM_INCOME ) {
				var temp = obj[x];
				if(temp == "0" || temp == ""){
					income = "null"
				}else{
					income = temp;
				}

				
			}
			else if (x == PARAM_ATTRIBS) {
				var temp = obj[x];
				if(temp == "0" || temp == ""){
					attribs = "null"
				}else{
					attribs = temp;
				}
				
			}
			else {
				// Attributes and extra parameters are interpreted differently depending on DDX settings
				if (!useDDX) {
					args.push(obj[x]);
					if (extraParams == null) {
						extraParams = "\"" + obj[x] + "\"";
					} else {
						extraParams = ", \"" + obj[x] + "\"";
					}
				} else {
					// When using DDX, the parameters are passed separately
					if(x == PARAM_EXTRA_PARAM) {
						extraParams = obj[x];
					}
				}
			}
		}

		/** put known variables at the beginning**/
		
		var attribString = "";
		// Form the string for explore attributes if using hosted libraries or if we are using DDX
		if (this._useHostedCMLib || useDDX) {
			if (age == null || age == "null") {
				age = "";
			}			
			if (gender == null || gender == "null") {
				gender = "";
			}
			if (maritalStatus == null || maritalStatus == "null") {
				maritalStatus = "";
			}
			if (numChildren == null || numChildren == "null") {
				numChildren = "";
			}
			if (numInHousehold == null || numInHousehold == "null") {
				numInHousehold = "";
			}
			if (companyName == null || companyName == "null") {
				companyName = "";
			}
			if (hobbies == null || hobbies == "null") {
				hobbies = "";
			}
			if (income == null || income == "null") {
				income = "";
			}
			attribString = age + "-_-" + gender + "-_-" + maritalStatus + "-_-" + numChildren + "-_-" + numInHousehold + "-_-" + companyName + "-_-" + hobbies + "-_-" + income;
			if (attribs != null && attribs != "null") {
				attribString += "-_-" + attribs;
			}
			args.unshift(userId, userEmail, userCity, userState, userZip, userCountry, attribString);
		} else {
			args.unshift(userId, userEmail, userCity, userState, userZip, newsletterName, subscribedFlag, storeId, userCountry, age, gender, 
					maritalStatus, numChildren, numInHousehold, companyName, hobbies, income);
		}
	
		if (!useDDX) {	
			/** useDDX is disabled **/
			/** call Coremetrics tag**/
			cmCreateRegistrationTag.apply({}, args);
		} else {
			/** useDDX is enabled **/
			if (userId == null || userId == "null" || userId == "'null'") { userId = '' };
			if (userEmail == null || userEmail == "null" || userEmail == "'null'") { userEmail = '' };
			if (attribString == null || attribString == "null" || attribString == "'null'") { attribString = '' };
			if (userCity == null || userCity == "null" || userCity == "'null'") { userCity = '' };
			if (userState == null || userState == "null" || userState == "'null'") { userState = '' };
			if (userZip == null || userZip == "null" || userZip == "'null'") { userZip = '' };
			if (userCountry == null || userCountry == "null" || userCountry == "'null'") { userCountry = '' };
			
			// Notice that in this case, the explore attributes are set as attribString and extraParams are not used
			if (typeof digitalData === "undefined") {
				digitalData = {};
				digitalData.pageInstanceID = 'wcs-standardpage_wcs-registration';
			}

			digitalData.user = [{profile:[{profileInfo:{profileID: userId, profileEmail: userEmail, exploreAttributes: attribString}, address:{city: userCity, state_province: userState ,postalcode: userZip, country: userCountry}}]}];	

			// For debug purposes
			if (internalDebug) {
				window.alert(JSON.stringify(digitalData));
			}
		}
		
		var JSONtoLog = JSON.stringify(obj);
		var obj = document.getElementById('cm-registration');
		if (debug && obj != null) {
			if (!useDDX) {
				var toLog = "cmCreateRegistrationTag(";
				if (userId != null && userId != "" && userId != "null") {
					toLog += "\"" + userId + "\", ";
				} else {
					toLog += "null, ";
				}
				if (userEmail != null && userEmail != "" && userEmail != "null") {
					toLog += "\"" + userEmail + "\", ";
				} else {
					toLog += "null, ";
				}	
				if (userCity != null && userCity != "" && userCity != "null") {
					toLog += "\"" + userCity + "\", ";
				} else {
					toLog += "null, ";
				}	
				if (userState != null && userState != "" && userState != "null") {
					toLog += "\"" + userState + "\", ";
				} else {
					toLog += "null, ";
				}
				if (userZip != null && userZip != "" && userZip != "null") {
					toLog += "\"" + userZip + "\", ";
				} else {
					toLog += "null, ";
				}	
			
				if (!this._useHostedCMLib) {
					if (newsletterName != null && newsletterName != "" && newsletterName != "null") {
						toLog += "\"" + newsletterName + "\", ";
					} else {
						toLog += "null, ";
					}
					if (subscribedFlag != null && subscribedFlag != "" && subscribedFlag != "null") {
						toLog += "\"" + subscribedFlag + "\", ";
					} else {
						toLog += "null, ";
					}
					if (storeId != null && storeId != "" && storeId != "null") {
						toLog += "\"" + storeId + "\", ";
					} else {
						toLog += "null, ";
					}	
				}
				if (userCountry != null && userCountry != "" && userCountry != "null") {
					toLog += "\"" + userCountry + "\", ";
				} else {
					toLog += "null, ";
				}
				
				if (this._useHostedCMLib) {
					toLog += "\"" + attribString + "\"";
				} else {
					if (age != null && age != "" && age != "null") {
						toLog += "\"" + age + "\", ";
					} else {
						toLog += "null, ";
					}	
					
					if (gender != null && gender != "" && gender != "null") {
						toLog += "\"" + gender + "\", ";
					} else {
						toLog += "null, ";
					}
					if (maritalStatus != null && maritalStatus != "" && maritalStatus != "null") {
						toLog += "\"" + maritalStatus + "\", ";
					} else {
						toLog += "null, ";
					}	
					if (numChildren != null && numChildren != "" && numChildren != "null") {
						toLog += "\"" + numChildren + "\", ";
					} else {
						toLog += "null, ";
					}	
					if (numInHousehold != null && numInHousehold != "" && numInHousehold != "null") {
						toLog += "\"" + numInHousehold + "\", ";
					} else {
						toLog += "null, ";
					}
					if (companyName != null && companyName != "" && companyName != "null") {
						toLog += "\"" + companyName + "\", ";
					} else {
						toLog += "null, ";
					}				
					if (hobbies != null && hobbies != "" && hobbies != "null") {
						toLog += "\"" + hobbies + "\", ";
					} else {
						toLog += "null, ";
					}				
					if (income != null && income != "" && income != "null") {
						toLog += "\"" + income + "\"";
					} else {
						toLog += "null";
					}				
				}
				if (extraParams != null) {
					toLog += ", " + extraParams;
				}
				toLog += ");";
			} else {
				var toLog = "digitalData = { ";
				if (digitalData.pageInstanceID != null && digitalData.pageInstanceID != "") {
		        		toLog += "pageInstanceID:'" + digitalData.pageInstanceID + "', ";
				}
				toLog += "user:[{profile:[{profileInfo:{profileID: '" + userId + "', profileEmail: '"+ userEmail + "', exploreAttributes: '" + attribString + "'}, address:{city: '" + userCity + "', state_province: '" + userState + "',postalcode: '" + userZip + "', country: '" + userCountry + "'}}]}]}";
				// For debug purposes
				if (internalDebug) {
					window.alert(toLog);
				}
			}
			
			var JSONtoLogNode = document.createTextNode(JSONtoLog);
			obj.appendChild(JSONtoLogNode); 
			obj.appendChild(document.createElement('br'));

			var toLogNode = document.createTextNode(toLog);
			obj.appendChild(toLogNode); 
			obj.appendChild(document.createElement('br'));
		}
	},
	
	/**
	 * _getStoreId This function returns the store identifier of the page currently being viewed
	 * @return{String} returns the store identifier of the page currently being viewed
	 */
	_getStoreId: function() {
		
		var pairs = window.location.search.substr(1).split("&");
		for(var i = 0; i < pairs.length; i++) {
			var nvp = pairs[i].split("=");
			if((nvp.length == 2) && (nvp[0] == this.PARAM_STORE_ID)) {
				return nvp[1];
			}
		}
		return null;
	}
});

}

}); 
