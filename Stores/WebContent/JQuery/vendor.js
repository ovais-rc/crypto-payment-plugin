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
 * This file is Generic analytics event listener 
 * @version 1.0
 * 
 **/

/**
* GenericEventListener is the base object from which various analtyic vendor implementations should extend from.
* 
**/

if(typeof(GenericEventListener) === "undefined" || !GenericEventListener || !GenericEventListener.topicNamespace){
	GenericEventListener = {

		_loaded: false,
		
		_useHostedCMLib: false,
		
		/**
		 * initializer Event listener initialization method an Empty placeholder method
		 */
		initializer: function () {
			
		},

		/**
		 *  This method sets up the listener to listen for the supported event types. Currently, they are "/wc/analytics/pageview",
		 *  	"/wc/analytics/productview", "/wc/analytics/cartview", "/wc/analytics/addcart" and "/wc/analytics/element".
		 *		For each event type, a corresponding handler method is defined. This method
		*		should be called by its creator before generating events.
		*/	
		load: function() {
			load(false);
		},
		
		/**
		 *  This method sets up the listener to listen for the supported event types. Currently, they are "/wc/analytics/pageview",
		 *  	"/wc/analytics/productview", "/wc/analytics/cartview", "/wc/analytics/addcart" and "/wc/analytics/element".
		 *		For each event type, a corresponding handler method is defined. This method
		*		should be called by its creator before generating events.
		*/
		load: function(useHostedLib) {
			if(this._loaded === false) {
				wcTopic.subscribe("/wc/analytics/pageview", $.proxy(this.handlePageView, this));
				wcTopic.subscribe("/wc/analytics/productview", $.proxy(this.handleProductView, this));
				wcTopic.subscribe("/wc/analytics/cartview", $.proxy(this.handleCartView, this));
				wcTopic.subscribe("/wc/analytics/addcart", $.proxy(this.handleAddCart, this));
				wcTopic.subscribe("/wc/analytics/element", $.proxy(this.handleElement, this));
				wcTopic.subscribe("/wc/analytics/registration", $.proxy(this.handleRegistration, this));
				wcTopic.subscribe("/wc/analytics/conversionevent", $.proxy(this.handleConversionEvent, this));

				this._loaded = true;
				
				if (useHostedLib === true) {
					this._useHostedCMLib = true;
				}
			}
		},
		
		/**
		 *  Handler for PageView events.This is the method called when a PageView event is triggered via the "/wc/analytics/pageview" topic.
		 *  	This is an empty placeholder that should be extended by the implementation.
		 *@param{Object} obj JSON object containing field names as expected by the specific implementation
		*/
		handlePageView: function(obj) {
			
		},
		
		/**
		 *  Handler for ProductView events .This is the method called when a ProductView event is triggered via the "/wc/analytics/productview" topic.
		 *  	This is an empty placeholder that should be extended by the implementation.
		 *@param{Object} obj JSON object containing field names as expected by the specific implementation
		*/
		handleProductView: function(obj) {
			
		},
		
		/**
		 *  Handler for CartView events.This is the method called when a CartView event is triggered via the "/wc/analytics/cartview" topic.
		 *  	This is an empty placeholder that should be extended by the implementation.
		 *@param{Object} obj JSON object with a single 'cart' array of objects that contain field names for each item
		*		as defined by the specific implementation.
		*/
		handleCartView: function(obj) {
			
		},
		
		/**
		 *  Handler for AddCart events.This is the method called when an AddCart event is triggered via the "/wc/analytics/addcart" topic.
		 *  	This is an empty placeholder that should be
		 *		extended by the implementation.
		*@param{Object} obj JSON object with a single 'cart' array of objects that contain field names for each item
		*		as defined by the specific implementation.
		*/
		handleAddCart: function(obj) {
			
		},
		
		/**
		 *  Handler for Element events . This is the method called when an Element event is triggered via the "/wc/analytics/element" topic.
		 *  	This is an empty placeholder that should be extended by the implementation.
		 * @param{Object} obj JSON object containing field names as expected by the specific implementation              
		 */
		handleElement: function(obj) {
			
		},
		
		/**
		 *  Handler for Registation events. This is the method called when an Registration event is triggered via the "/wc/analytics/registration" topic.
		 *  	This is an empty placeholder that should be extended by the implementation.
		 * @param{Object} obj JSON object containing field names as expected by the specific implementation
		 */
		handleRegistration: function(obj) {
			
		},	
		
		/**
		 *  Handler for non e-Commerce conversion events. This is the method called when the topic "/wc/analytics/conversionevent" is published.
		 *  	This is an empty place holder that should be extended by the implementation.
		 * @param{Object} obj  JSON object containing field names as expected by the specific implementation
		 */	
		handleConversionEvent: function(obj) {
			
		}
	};
}
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
* CoremetricsEventListener handles the page view and product view events and calls the appropriate one and only one global analyticsJS should be created.
* Therefore, we create this object only when it is not present in Coremetrics JavaScript functions to register such calls.
*
**/

if(typeof(CoremetricsEventListener) === "undefined" || !CoremetricsEventListener || !CoremetricsEventListener.topicNamespace){
	CoremetricsEventListener = $.extend(GenericEventListener, {
		
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
				if(x === PARAM_OPTIONS) {
					var options = obj[x];
					if (options === PARAM_VALUE_USEDDX) {
						useDDX = true;
					}
				} else if (x === PARAM_DEBUG) {
					var debugParam = obj[x];
					if (debugParam === PARAM_VALUE_TRUE) {
						debug = true;
					}
				} else if(x === PARAM_PAGENAME) {
					pagename = obj[x];
				}
				else if(x === PARAM_PAGETYPE) {
					pageType = obj[x];	
				}
				else if(x === PARAM_CATEGORY) {
					if (obj[x] === "null" || obj[x] === "") {
						category = null;
					} else {
						category = obj[x];	
					}
				}
				else if(x === PARAM_SEARCHTERMS) {
					if (obj[x] === "null" || obj[x] === "") {
						searchTerms = null;
					} else {
						searchTerms = obj[x];	
					}
				}
				else if(x === PARAM_SEARCHCOUNT) {
					if (obj[x] === "null" || obj[x] === "") {
						searchCount = null;
					} else {
						searchCount = obj[x];	
					}
					
				}
				else if(x === this.PARAM_STORE_ID) {
					storeId = obj[x];
				}
				else {
					// Attributes and extra parameters are interpreted differently depending on DDX settings
					if (!useDDX) {
						// When not using DDX, the attributes and parameters are passed on the same entry
						args.push(obj[x]);
						if (extraParams !== null) {
							extraParams += ", ";
						} else {
							extraParams = "";
						}
						
						if (obj[x] == null || obj[x] === "null") {
							extraParams += "null";
						} else if (obj[x].charAt(0) === "\"" && obj[x].charAt(obj[x].length-1) === "\"") {
							extraParams += obj[x];
						} else {
							extraParams += "\"" + obj[x] + "\"";
						}
					} else {
						// When using DDX, the attributes and parameters are passed separately
						if(x === PARAM_EXTRA_PARAM) {
							extraParams = obj[x];
						} else if(x === PARAM_ATTRIBUTES) {
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
				if (pagename == null || pagename === "null" || pagename === "'null'") { pagename = '' };
				if (searchTerms == null || searchTerms === "null" || searchTerms === "'null'") { searchTerms = '' };
				if (searchCount == null || searchCount === "null" || searchCount === "'null'") { searchCount = '' };
				if (category == null || category === "null" || category === "'null'") { category = '' };
				if (attributes == null || attributes === "null" || attributes === "'null'") { attributes = '' };
				if (extraParams == null || extraParams === "null" || extraParams === "'null'") { extraParams = '' };
				if (pageType == null || pageType === "null" || pageType === "'null'") { pageType = '' };

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
			if (debug && obj !== null) {
				if (!useDDX) {
					var toLog = "cmCreatePageviewTag(";
					if (pagename !== null && pagename !== "" && pagename !== "null") {
						toLog += "\"" + pagename + "\", ";
					} else {
						toLog += "null, ";
					}
					if (category !== null && category !== "" && category !== "null") {
						toLog += "\"" + category + "\", ";
					} else {
						toLog += "null, ";
					}	
					if (searchTerms !== null && searchTerms !== "" && searchTerms !== "null") {
						toLog += "\"" + searchTerms + "\", ";
					} else {
						toLog += "null, ";
					}		
					if (searchCount !== null && searchCount !== "" && searchCount !== "null") {
						toLog += "\"" + searchCount + "\"";
					} else {
						toLog += "null";
					}	
					if (!this._useHostedCMLib) {
						if (storeId !== null && storeId !== "" && storeId !== "null") {
							toLog += ", \"" + storeId + "\"";
						} else {
							toLog += ", null";
						}				
					}
					if (extraParams !== null) {
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
				if(x === PARAM_OPTIONS) {
					var options = obj[x];
					// useDDX is NOT supported for this case by Digital Analytics
					// Enable the three lines below when DDX is supported for this case
					// if (options === PARAM_VALUE_USEDDX) {
					//	useDDX = true;
					// }
				} else if (x === PARAM_DEBUG) {
					var debugParam = obj[x];
					if (debugParam === PARAM_VALUE_TRUE) {
						debug = true;
					}
				} else if(x === PARAM_EVENTID) {
					eventId = obj[x];
				}
				else if(x === PARAM_CATEGORY) {
					category = obj[x];
				}
				else if(x === PARAM_ACTIONTYPE) {
					actionType = obj[x];
				}
				else if(x === PARAM_POINTS) {
					points = obj[x];
				}
				else {
					// Attributes and extra parameters are interpreted differently depending on DDX settings
					if (!useDDX) {
						// When not using DDX, the attributes and parameters are passed on the same entry
						args.push(obj[x]);
					} else {
						// When using DDX, the attributes and parameters are passed separately
						if(x === PARAM_EXTRA_PARAM) {
							extraParams = obj[x];
						} else if(x === PARAM_ATTRIBUTES) {
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
				if (eventId == null || eventId === "null" || eventId === "'null'") { eventId = '' };
				if (actionType == null || actionType === "null" || actionType === "'null'") { actionType = '' };
				if (points == null || points === "null" || points === "'null'") { points = '' };
				if (category == null || category === "null" || category === "'null'") { category = '' };
				if (attributes == null || attributes === "null" || attributes === "'null'") { attributes = '' };
				if (extraParams == null || extraParams === "null" || extraParams === "'null'") { extraParams = '' };
				
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
			if (debug && obj !== null) {
				if (!useDDX) {
					var toLog = "cmCreateConversionEventTag(";
					if (eventId !== null && eventId !== "") {
						toLog += "\"" + eventId + "\", ";
					} else {
						toLog += "null, ";
					}
					if (actionType !== null && actionType !== "") {
						toLog += "\"" + actionType + "\", ";
					} else {
						toLog += "null, ";
					}		
					if (category !== null && category !== "") {
						toLog += "\"" + category + "\", ";
					} else {
						toLog += "null, ";
					}	
					if (points !== null && points !== "") {
						toLog += "\"" + points + "\"";
					} else {
						toLog += "null";
					}	
					toLog += ");";
				} else {
					var toLog = "digitalData = { ";
					if (digitalData.pageInstanceID !== null && digitalData.pageInstanceID !== "") {
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

			if(obj.options === PARAM_VALUE_USEDDX) {
				useDDX = true;
			}
			
			if (obj.debug === PARAM_VALUE_TRUE) {
				debug = true;
			}

			if(obj.product && $.isArray(obj.product)) {
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
						if(x === PARAM_PRODUCTID) {
							productId = values[x];
						}
						else if(x === PARAM_PRODUCTNAME) {
							productName = values[x];
						}
						else if(x === PARAM_CATEGORY) {
							category = values[x];
						}
						else if(x === PARAM_MASTERCATEGORY) {
							masterCategory = values[x];
						}
						else if(x === this.PARAM_STORE_ID) {
							storeId = values[x];
						}
						else {
							// Attributes and extra parameters are interpreted differently depending on DDX settings
							if (!useDDX) {
								// When not using DDX, the attributes and parameters are passed on the same entry
								args.push(values[x]);
								if (extraParams !== null) {
									extraParams += ", ";
								} else {
									extraParams = "";
								}
							
								if (values[x] == null || values[x] === "null") {
									extraParams += "null";
								} else if (values[x].charAt(0) === "\"" && values[x].charAt(values[x].length-1) === "\"") {
									extraParams += values[x];
								} else {
									extraParams += "\"" + values[x] + "\"";
								}
							} else {
								// When using DDX, the attributes and virtual category are passed separately
								if(x === PARAM_ATTRIBUTES) {
									attributes = values[x];
								} else if(x === PARAM_VIRTUAL_CATEGORY) {
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
							if (productId == null || productId === "null" || productId === "'null'") { productId = '' };
							if (productName == null || productName === "null" || productName === "'null'") { productName = '' };
							if (category == null || category === "null" || category === "'null'") { category = '' };
							if (virtualCategory == null || virtualCategory === "null" || virtualCategory === "'null'") { virtualCategory = '' };
							if (attributes == null || attributes === "null" || attributes === "'null'") { attributes = '' };
							
							digitalData.product[i] = {productInfo:{productID: productId, productName: productName}, category:{primaryCategory: category, virtualCategory: virtualCategory}, attributes:{exploreAttributes: attributes}};
							// For debug purposes
							if (internalDebug) {
								window.alert(JSON.stringify(digitalData));
							}
						}
						
						var JSONtoLog = JSON.stringify(obj);
						var obj = document.getElementById('cm-productview');
						if (debug && obj !== null) {
							if (!useDDX) {
								var toLog = "";
								if(!this._useHostedCMLib){
									toLog = "cmCreateProductviewTag(null, ";
								} else {
									toLog = "cmCreateProductviewTag(";
								}
								if (productId !== null && productId !== "") {
									toLog += "\"" + productId + "\", ";
								} else {
									toLog += "null, ";
								}
								if (productName !== null && productName !== "") {
									productName = productName.replace(/\"/g, '\\\"');
									toLog += "\"" + productName + "\", ";
								} else {
									toLog += "null, ";
								}	
								if (category !== null && category !== "") {
									toLog += "\"" + category + "\"";
								} else {
									toLog += "null";
								}	
								if(!this._useHostedCMLib){
									if (storeId !== null && storeId !== "") {
										toLog += ", \"" + storeId + "\", \"N\", ";
									} else {
										toLog += ", null, \"N\", ";
									}		
									if (masterCategory !== null && masterCategory !== "") {
										toLog += "\"" + masterCategory + "\"";
									} else {
										toLog += "null";
									}				
								}
								if (extraParams !== null) {
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

			if(obj.options === PARAM_VALUE_USEDDX) {
				useDDX = true;
			}

			if (obj.useCMSetupOther === PARAM_VALUE_TRUE) {
				useCMSetupOther = true;
			} else if (obj.useCMSetupOther === PARAM_VALUE_FALSE) {
				useCMSetupOther = false;
			}
			
			if (obj.debug === PARAM_VALUE_TRUE) {
				debug = true;
			}

			var shop5created = false;

			if(obj.cart && $.isArray(obj.cart)) {
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
						if(x === PARAM_PRODUCTID) {
							productId = values[x];
						}
						else if(x === PARAM_PRODUCTNAME) {
							productName = values[x];
						}
						else if(x === PARAM_CATEGORY) {
							category = values[x];
						}
						else if(x === PARAM_MASTERCATEGORY) {
							masterCategory = values[x];
						}
						else if(x === PARAM_QTY) {
							quantity = values[x];
						}
						else if(x === PARAM_PRICE) {
							price = values[x];
						}
						else if(x === PARAM_CURRENCY) {
							currency = values[x];
						}
						else if(x === this.PARAM_STORE_ID) {
							storeId = values[x];
						}
						else {
							// Attributes and extra parameters are interpreted differently depending on DDX settings
							if (!useDDX) {
								args.push(values[x]);
								if (extraParams !== null) {
									extraParams += ", ";
								} else {
									extraParams = "";
								}
							
								if (values[x] == null || values[x] === "null") {
									extraParams += "null";
								} else if (values[x].charAt(0) === "\"" && values[x].charAt(values[x].length-1) === "\"") {
									extraParams += values[x];
								} else {
									extraParams += "\"" + values[x] + "\"";
								}
							} else {
								// When using DDX, the attributes and parameters are passed separately
								if(x === PARAM_ATTRIBUTES) {
									attributes = values[x];
								} else if(x === PARAM_EXTRA_PARAM) {
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
								if (debug && logObj !== null) {
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
							if (productId == null || productId === "null" || productId === "'null'") { productId = '' };
							if (productName == null || productName === "null" || productName === "'null'") { productName = '' };
							if (quantity == null || quantity === "null" || quantity === "'null'") { quantity = '' };
							if (price == null || price === "null" || price === "'null'") { price = '' };
							if (currency == null || currency === "null" || currency === "'null'") { currency = '' };
							if (category == null || category === "null" || category === "'null'") { category = '' };
							if (virtualCategory == null || virtualCategory === "null" || virtualCategory === "'null'") { virtualCategory = '' };
							if (attributes == null || attributes === "null" || attributes === "'null'") { attributes = '' };
							if (extraParams == null || extraParams === "null" || extraParams === "'null'") { extraParams = '' };

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
						if (debug && obj !== null) {
							if (!useDDX) {
								var toLog = "cmCreateShopAction5Tag(";
								if (productId !== null && productId !== "") {
									toLog += "\"" + productId + "\", ";
								} else {
									toLog += "null, ";
								}
								if (productName !== null && productName !== "") {
									productName = productName.replace(/\"/g, '\\\"');
									toLog += "\"" + productName + "\", ";
								} else {
									toLog += "null, ";
								}	
								if (quantity !== null && quantity !== "") {
									toLog += "\"" + quantity + "\", ";
								} else {
									toLog += "null, ";
								}
								if (price !== null && price !== "") {
									toLog += "\"" + price + "\", ";
								} else {
									toLog += "null, ";
								}	
								if (category !== null && category !== "") {
									toLog += "\"" + category + "\"";
								} else {
									toLog += "null";
								}
								if (!this._useHostedCMLib) {
									if (storeId !== null && storeId !== "") {
										toLog += ", \"" + storeId + "\", ";
									} else {
										toLog += ", null, ";
									}
									if (currency !== null && currency !== "") {
										toLog += "\"" + currency + "\", ";
									} else {
										toLog += "null, ";
									}								
									if (masterCategory !== null && masterCategory !== "") {
										toLog += "\"" + masterCategory + "\"";
									} else {
										toLog += "null";
									}				
								}
								if (extraParams !== null) {
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
				if (debug && logObj !== null) {
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
			// if(obj.options === PARAM_VALUE_USEDDX) {
			//	useDDX = true;
			// }

			if (obj.useCMSetupOther === PARAM_VALUE_TRUE) {
				useCMSetupOther = true;
			} else if (obj.useCMSetupOther === PARAM_VALUE_FALSE) {
				useCMSetupOther = false;
			}
			
			if (obj.debug === PARAM_VALUE_TRUE) {
				debug = true;
			}

			var shop5created = false;

			if(obj.cart && $.isArray(obj.cart)) {
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
						if(x === PARAM_PRODUCTID) {
							productId = values[x];
						}
						else if(x === PARAM_PRODUCTNAME) {
							productName = values[x];
						}
						else if(x === PARAM_CATEGORY) {
							category = values[x];
						}
						else if(x === PARAM_MASTERCATEGORY) {
							masterCategory = values[x];
						}
						else if(x === PARAM_QTY) {
							quantity = values[x];
						}
						else if(x === PARAM_PRICE) {
							price = values[x];
						}
						else if(x === PARAM_CURRENCY) {
							currency = values[x];
						}
						else if(x === this.PARAM_STORE_ID) {
							storeId = values[x];
						}
						else {
							// Attributes and extra parameters are interpreted differently depending on DDX settings
							if (!useDDX) {
								args.push(values[x]);
								if (extraParams !== null) {
									extraParams += ", ";
								} else {
									extraParams = "";
								}
							
								if (values[x] == null || values[x] === "null") {
									extraParams += "null";
								} else if (values[x].charAt(0) === "\"" && values[x].charAt(values[x].length-1) === "\"") {
									extraParams += values[x];
								} else {
									extraParams += "\"" + values[x] + "\"";
								}
							} else {
								// When using DDX, the attributes and parameters are passed separately
								if(x === PARAM_ATTRIBUTES) {
									attributes = values[x];
								} else if(x === PARAM_EXTRA_PARAM) {
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
								if (debug && logObj !== null) {
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
							if (productId == null || productId === "null" || productId === "'null'") { productId = '' };
							if (productName == null || productName === "null" || productName === "'null'") { productName = '' };
							if (quantity == null || quantity === "null" || quantity === "'null'") { quantity = '' };
							if (price == null || price === "null" || price === "'null'") { price = '' };
							if (currency == null || currency === "null" || currency === "'null'") { currency = '' };
							if (category == null || category === "null" || category === "'null'") { category = '' };
							if (virtualCategory == null || virtualCategory === "null" || virtualCategory === "'null'") { virtualCategory = '' };
							if (attributes == null || attributes === "null" || attributes === "'null'") { attributes = '' };
							if (extraParams == null || extraParams === "null" || extraParams === "'null'") { extraParams = '' };

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
						if (debug && obj !== null) {
							if (!useDDX) {
								var toLog = "cmCreateShopAction5Tag(";
								if (productId !== null && productId !== "") {
									toLog += "\"" + productId + "\", ";
								} else {
									toLog += "null, ";
								}
								if (productName !== null && productName !== "") {
									productName = productName.replace(/\"/g, '\\\"');
									toLog += "\"" + productName + "\", ";
								} else {
									toLog += "null, ";
								}	
								if (quantity !== null && quantity !== "") {
									toLog += "\"" + quantity + "\", ";
								} else {
									toLog += "null, ";
								}
								if (price !== null && price !== "") {
									toLog += "\"" + price + "\", ";
								} else {
									toLog += "null, ";
								}	
								if (category !== null && category !== "") {
									toLog += "\"" + category + "\"";
								} else {
									toLog += "null";
								}
								if (!this._useHostedCMLib) {
									if (storeId !== null && storeId !== "") {
										toLog += ", \"" + storeId + "\", ";
									} else {
										toLog += ", null, ";
									}
									if (currency !== null && currency !== "") {
										toLog += "\"" + currency + "\", ";
									} else {
										toLog += "null, ";
									}								
									if (masterCategory !== null && masterCategory !== "") {
										toLog += "\"" + masterCategory + "\"";
									} else {
										toLog += "null";
									}				
								}
								if (extraParams !== null) {
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
				if (debug && logObj !== null) {
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
				if(x === PARAM_OPTIONS) {
					var options = obj[x];
					if (options === PARAM_VALUE_USEDDX) {
						useDDX = true;
					}
				} else if (x === PARAM_DEBUG) {
					var debugParam = obj[x];
					if (debugParam === PARAM_VALUE_TRUE) {
						debug = true;
					}
				} else if(x === PARAM_ELEMENTID) {
					elementId = obj[x];
				}
				else if(x === PARAM_CATEGORY) {
					category = obj[x];
				}
				else if(x === PARAM_PAGEID) {
					pageId = obj[x];
				}
				else if(x === PARAM_PAGECATEGORY) {
					pageCategory = obj[x];
				}
				else if(x === PARAM_LOCATION) {
					elementLocation = obj[x];
				}
				else if(x === this.PARAM_STORE_ID) {
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
						if(x === PARAM_EXTRA_PARAM) {
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
					if (elementId == null || elementId === "null" || elementId === "'null'") { elementId = '' };
					if (category == null || category === "null" || category === "'null'") { category = '' };
					if (extraParams == null || extraParams === "null" || extraParams === "'null'") { extraParams = '' };
			
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
				if (debug && obj !== null) {
					if (!useDDX) {
						var toLog = "";
						if (!this._useHostedCMLib) {
							toLog = "cmCreatePageElementTag("; 
						} else {
							toLog = "cmCreateElementTag(";
						}
					
						if (elementId !== null && elementId !== "") {
							toLog += "\"" + elementId + "\", ";
						} else {
							toLog += "null, ";
						}
						if (category !== null && category !== "") {
							toLog += "\"" + category + "\"";
						} else {
							toLog += "null";
						}	
					
						if (!this._useHostedCMLib) {
							if (pageId !== null && pageId !== "") {
								toLog += ", \"" + pageId + "\", ";
							} else {
								toLog += ", null, ";
							}	
							if (pageCategory !== null && pageCategory !== "") {
								toLog += "\"" + pageCategory + "\", ";
							} else {
								toLog += "null, ";
							}
							if (elementLocation !== null && elementLocation !== "") {
								toLog += "\"" + elementLocation + "\", ";
							} else {
								toLog += "null, ";
							}	
							if (storeId !== null && storeId !== "") {
								toLog += "\"" + storeId + "\"";
							} else {
								toLog += "null";
							}									
						}
						toLog += ");";
					} else {
						var toLog = "digitalData = { ";
						if (digitalData.pageInstanceID !== null && digitalData.pageInstanceID !== "") {
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
				if(x === PARAM_OPTIONS) {
					var options = obj[x];
					if (options === PARAM_VALUE_USEDDX) {
						useDDX = true;
					}
				} else if (x === PARAM_DEBUG) {
					var debugParam = obj[x];
					if (debugParam === PARAM_VALUE_TRUE) {
						debug = true;
					}
				} else if(x === PARAM_USERID) {
					userId = obj[x];
				}
				else if(x === PARAM_USEREMAIL ) {
					userEmail = obj[x];
				}
				else if(x === PARAM_USERCITY) {
					userCity = obj[x];
				}
				else if(x === PARAM_USERSTATE) {
					userState = obj[x];
				}
				else if(x === PARAM_USERZIP) {
					userZip = obj[x];
				}
				else if(x === PARAM_NEWSLETTERNAME ) {
					newsletterName = obj[x];
				}
				else if(x === PARAM_SUBSCRIBEDFLAG) {
					subscribedFlag = obj[x];
				}
				else if(x === PARAM_STOREID) {
					storeId = obj[x];
				}
				else if(x === PARAM_USERCOUNTRY) {
					userCountry = obj[x];
				}
				else if(x === PARAM_AGE) {
					
					var temp = obj[x];
					if(temp === "0" || temp === ""){
						age = "null"
					}else{
						age = temp;
					}
					
				}
				else if(x === PARAM_GENDER ) {
					var temp = obj[x];
					if(temp === ""){
						gender = "null"
					}else{
						gender = temp;
					}
								
				}
				else if(x === PARAM_MARITALSTATUS) {
					var temp = obj[x];
					if(temp === ""){
						maritalStatus = "null"
					}else{
						maritalStatus = temp;
					}
					
				}
				else if(x === PARAM_NUMCHILDREN) {
					
					var temp = obj[x];
					if(temp === "0" || temp === ""){
						numChildren = "null"
					}else{
						numChildren = temp;
					}
					
					
				}
				else if(x === PARAM_NUMINHOUSEHOLD) {
					var temp = obj[x];
					if(temp === "0" || temp === ""){
						numInHousehold = "null"
					}else{
						numInHousehold = temp;
					}
					
					
				}			
				else if(x === PARAM_COMPANYNAME) {
					var temp = obj[x];
					if(temp === ""){
						companyName = "null"
					}else{
						companyName = temp;
					}
					
				}
				else if(x === PARAM_HOBBIES) {
					var temp = obj[x];
					if(temp === ""){
						hobbies = "null"
					}else{
						hobbies = temp;
					}
					
				}
				else if(x === PARAM_INCOME ) {
					var temp = obj[x];
					if(temp === "0" || temp === ""){
						income = "null"
					}else{
						income = temp;
					}

					
				}
				else if (x === PARAM_ATTRIBS) {
					var temp = obj[x];
					if(temp === "0" || temp === ""){
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
						if(x === PARAM_EXTRA_PARAM) {
							extraParams = obj[x];
						}
					}
				}
			}

			/** put known variables at the beginning**/
			
			var attribString = "";
			// Form the string for explore attributes if using hosted libraries or if we are using DDX
			if (this._useHostedCMLib || useDDX) {
				if (age == null || age === "null") {
					age = "";
				}			
				if (gender == null || gender === "null") {
					gender = "";
				}
				if (maritalStatus == null || maritalStatus === "null") {
					maritalStatus = "";
				}
				if (numChildren == null || numChildren === "null") {
					numChildren = "";
				}
				if (numInHousehold == null || numInHousehold === "null") {
					numInHousehold = "";
				}
				if (companyName == null || companyName === "null") {
					companyName = "";
				}
				if (hobbies == null || hobbies === "null") {
					hobbies = "";
				}
				if (income == null || income === "null") {
					income = "";
				}
				attribString = age + "-_-" + gender + "-_-" + maritalStatus + "-_-" + numChildren + "-_-" + numInHousehold + "-_-" + companyName + "-_-" + hobbies + "-_-" + income;
				if (attribs !== null && attribs !== "null") {
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
				if (userId == null || userId === "null" || userId === "'null'") { userId = '' };
				if (userEmail == null || userEmail === "null" || userEmail === "'null'") { userEmail = '' };
				if (attribString == null || attribString === "null" || attribString === "'null'") { attribString = '' };
				if (userCity == null || userCity === "null" || userCity === "'null'") { userCity = '' };
				if (userState == null || userState === "null" || userState === "'null'") { userState = '' };
				if (userZip == null || userZip === "null" || userZip === "'null'") { userZip = '' };
				if (userCountry == null || userCountry === "null" || userCountry === "'null'") { userCountry = '' };
				
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
			if (debug && obj !== null) {
				if (!useDDX) {
					var toLog = "cmCreateRegistrationTag(";
					if (userId !== null && userId !== "" && userId !== "null") {
						toLog += "\"" + userId + "\", ";
					} else {
						toLog += "null, ";
					}
					if (userEmail !== null && userEmail !== "" && userEmail !== "null") {
						toLog += "\"" + userEmail + "\", ";
					} else {
						toLog += "null, ";
					}	
					if (userCity !== null && userCity !== "" && userCity !== "null") {
						toLog += "\"" + userCity + "\", ";
					} else {
						toLog += "null, ";
					}	
					if (userState !== null && userState !== "" && userState !== "null") {
						toLog += "\"" + userState + "\", ";
					} else {
						toLog += "null, ";
					}
					if (userZip !== null && userZip !== "" && userZip !== "null") {
						toLog += "\"" + userZip + "\", ";
					} else {
						toLog += "null, ";
					}	
				
					if (!this._useHostedCMLib) {
						if (newsletterName !== null && newsletterName !== "" && newsletterName !== "null") {
							toLog += "\"" + newsletterName + "\", ";
						} else {
							toLog += "null, ";
						}
						if (subscribedFlag !== null && subscribedFlag !== "" && subscribedFlag !== "null") {
							toLog += "\"" + subscribedFlag + "\", ";
						} else {
							toLog += "null, ";
						}
						if (storeId !== null && storeId !== "" && storeId !== "null") {
							toLog += "\"" + storeId + "\", ";
						} else {
							toLog += "null, ";
						}	
					}
					if (userCountry !== null && userCountry !== "" && userCountry !== "null") {
						toLog += "\"" + userCountry + "\", ";
					} else {
						toLog += "null, ";
					}
					
					if (this._useHostedCMLib) {
						toLog += "\"" + attribString + "\"";
					} else {
						if (age !== null && age !== "" && age !== "null") {
							toLog += "\"" + age + "\", ";
						} else {
							toLog += "null, ";
						}	
						
						if (gender !== null && gender !== "" && gender !== "null") {
							toLog += "\"" + gender + "\", ";
						} else {
							toLog += "null, ";
						}
						if (maritalStatus !== null && maritalStatus !== "" && maritalStatus !== "null") {
							toLog += "\"" + maritalStatus + "\", ";
						} else {
							toLog += "null, ";
						}	
						if (numChildren !== null && numChildren !== "" && numChildren !== "null") {
							toLog += "\"" + numChildren + "\", ";
						} else {
							toLog += "null, ";
						}	
						if (numInHousehold !== null && numInHousehold !== "" && numInHousehold !== "null") {
							toLog += "\"" + numInHousehold + "\", ";
						} else {
							toLog += "null, ";
						}
						if (companyName !== null && companyName !== "" && companyName !== "null") {
							toLog += "\"" + companyName + "\", ";
						} else {
							toLog += "null, ";
						}				
						if (hobbies !== null && hobbies !== "" && hobbies !== "null") {
							toLog += "\"" + hobbies + "\", ";
						} else {
							toLog += "null, ";
						}				
						if (income !== null && income !== "" && income !== "null") {
							toLog += "\"" + income + "\"";
						} else {
							toLog += "null";
						}				
					}
					if (extraParams !== null) {
						toLog += ", " + extraParams;
					}
					toLog += ");";
				} else {
					var toLog = "digitalData = { ";
					if (digitalData.pageInstanceID !== null && digitalData.pageInstanceID !== "") {
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
				if((nvp.length === 2) && (nvp[0] === this.PARAM_STORE_ID)) {
					return nvp[1];
				}
			}
			return null;
		}
	});
}
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

/* global $, window */

var arrayUtils = arrayUtils || {

    /**
     * Given an array and a comparison function, performs stable sort on the given array.
     * The comparison function must return 0 (and not just any falsy value) if the elements 
     * are equal for this function to work as expected. The given array and its elements are 
     * not modified. Returns a new array. This function was written since the built-in 
     * JavaScript [].sort is not guaranteed to be stable.
     */
    stableSort: function (arr, cmp) {
        // Create a new array that also has the index of each element
        var newArr = arr.map(function (e, i) {
            return {
                element: e,
                index: i
            };
        });

        // Uses the JavaScript built-in sort, but if two elements are equal, compare
        // by their index
        return newArr.sort(function (a, b) {
            var cmpResult = cmp(a.element, b.element);
            if (cmpResult === 0) {
                return a.index - b.index;
            } else {
                return cmpResult;
            }
        }).map(function(e) {
            return e.element;
        });
    },
    
    /**
    * Returns true if the given array holds a transitive property defined by the given predicate. 
    * For instance, to check if an array is sorted, it suffices to check whether the sorted property
    * holds for each consecutive elements. If an array has zero or one element, this function 
    * vacuously returns true.
    *
    * @param arr an array
    * @param predicate a function that takes two arguments and trues if the two arguments satisfy some
    * relationship and false otherwise. 
    */
    verifyTransitiveProperty: function(arr, predicate) {
        var i;
        for (i = 0; i < arr.length - 1; i++) {
            if (!predicate(arr[i], arr[i+1])) {
                return false;
            }
        }
        return true;
    },
    
    /**
    * Returns true if the given array is empty.
    */
    isEmpty: function(arr) {
        return arr.length === 0;
    },
    
    /**
    * Returns the last element in an array. Returns undefined if the array is empty.
    */
    last: function(arr) {
        if (this.isEmpty(arr)) {
            return undefined;
        }
        return arr[arr.length - 1];
    },
    
    /**
    * Given an array returns a new array where the elements of the given array are divided into
    * subarrays. Each subarray contains up to the given count.  
    *
    * Example:
    * arrTo2D([1,2,3,4,5,6,7,8,9], 3) -> [[1,2,3],[4,5,6],[7,8,9]]
    * arrTo2D([1,2,3,4,5,6,7,8,9,10], 3) -> [[1,2,3],[4,5,6],[7,8,9],[10]]
    */
    arrTo2D: function(arr, count) {
        if (typeof count === 'undefined') {
            throw "The number of columns to divide the array into is undefined";
        }
        var newArr = [];
        while(arr.length) {
            newArr.push(arr.splice(0,count));
        }
        return newArr;
    }
}//-----------------------------------------------------------------
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

/* An dictionary of commonly used key codes, listed numerically by key code */
var KeyCodes = KeyCodes || {
    TAB: 9,
    /* Carriage return, or enter key */
    RETURN: 13,
    SHIFT: 16,
    SPACE: 32,
    ESCAPE: 27,
	LEFT_ARROW: 37,
    UP_ARROW: 38,
	RIGHT_ARROW: 39,	
    DOWN_ARROW: 40
};//-----------------------------------------------------------------
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

/* global jQuery, $, console */

// Adds publish/subscribe functionality to jQuery using callbacks
// Source: https://api.jquery.com/jQuery.Callbacks/

/*
// Publisher
wcTopic.publish( "mailArrived", "hello world!" );
wcTopic.publish( "event1", {"key1":"value1", "key2":"value2"});

// Subscribe
wcTopic.subscribe( "mailArrived", fn1 );
wcTopic.subscribe( ["event1", "event2"], function test(returnData) {
    if (returnData) {
        alert("data: " + returnData["key1"]);
    }
});
wcTopic.subscribe({"event1":"event1", "event2":"event2"}, fn1);

*/

wcTopic = {
    _topics: {},

    _getIdArray: function(ids) {
        var idArray = new Array();
        if ($.type(ids) === "array" || $.type(ids) === "object") {
            for (var key in ids) {
                idArray.push(ids[key]);
            }
        } else if ($.type(ids) === "string"){
            idArray.push(ids);
        } else {
            console.error("jQuery.Topic - ids has an unsupported type: " + $.type(ids));
        }
        return idArray;
    },

    _processIds: function(ids) {
        var idArray = this._getIdArray(ids);
        for (var key in idArray) {
            var id = idArray[key];
            if (!this._topics[id]) {
                // declare new topic
                this._topics[id] = $.Topic(id);
            }
        }
        return idArray;
    },

    /**
     * @param ids Event ids (type can be string for single ID, or array of ids in string, or object containing ids in string)
     * @param fcn The function to invoke
     */
    subscribe: function(ids, fcn) {
        var idArray = this._processIds(ids);
        for (var key in idArray) {
            this._topics[idArray[key]].subscribe(fcn);
        }
    },

    /**
     * @param ids Event ids (type can be string for single ID, or array of ids in string, or object containing ids in string)
     * @param obj The data to pass back to the callback list
     */
    publish: function(ids, obj) {
        var idArray = this._processIds(ids),
            args;
        for (var key in idArray) {
            // Grab all but the first argument
            args = Array.prototype.slice.call(arguments, 1);
            this._topics[idArray[key]].publish.apply(null, args);
        }
    },

    subscribeOnce: function(ids, fcn, context) {
        var idArray = this._processIds(ids);
        for (var key in idArray) {
            this._topics[idArray[key]].subscribeOnce(fcn, context);
        }
    }
}

jQuery.Topic = function (id) {
    var callbacks = jQuery.Callbacks("unique");

    var topic = {
        id: id,
        publish: callbacks.fire,
        subscribe: callbacks.add,
        /**
        * Same as subscribe except the given function or array of functions
        * only execute once (and then the function is removed from this callback).
        */
        subscribeOnce: function (fcns, context) {
            if ($.isFunction(fcns)) {
                var newFcn = function () {
                    fcns.apply(context || this, arguments);
                    callbacks.remove(newFcn);
                };
                callbacks.add(newFcn);
            } else {
                fcns.forEach(function (a_fcn) {
                    if ($.isFunction(a_fcn)) {
                        var newFcn = function () {
                            a_fcn.apply(context || this, arguments);
                            callbacks.remove(newFcn);
                        };
                        callbacks.add(newFcn);
                    } else {
                        console.err(a_fcn + " is not a function");
                    }
                });
            }
        },
        unsubscribe: callbacks.remove
    };

    return topic;
};//-----------------------------------------------------------------
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

/* global $, window */

var Utils = Utils || {
    /*
     * Returns a function that can only be executed once. 
     */
    once: function(fn, context) {
        var result;

        return function() {
            if (fn) {
                result = fn.apply(context || this, arguments);
                fn = null;
            }

            return result;
        };
    },

    /*
     * Stops an event (same as Dojo's event.stop(e)).
     */
    stopEvent: function(event) {
        event.preventDefault();
        event.stopPropagation();
    },

    /**
     * Returns the text direction (one of rtl or ltr) of the given element.
     */
    getTextDirection: function(element) {
        var result = null;
        if (window.getComputedStyle) {
            result = window.getComputedStyle(element, null).direction;
        } else if (element.currentStyle) {
            result = element.currentStyle.direction;
        }

        return result;
    },

    /**
     * Returns true if the browser is Opera, false otherwise.
     */
    isOpera: function() {
        return (navigator.userAgent.match(/Opera|OPR\//) ? true : false);
    },
    /**
     * Detect ios devices
     * return true if ios devies
     */
    has_ios: function() {
        return navigator.userAgent.match(/(iPod|iPhone|iPad)/)

    },

    /**
     * Returns true if the browser is Chrome, false otherwise.
     */
    isChrome: function() {
        return /chrom(e|ium)/.test(navigator.userAgent.toLowerCase());
    },

    /**
     * Detect touch devices
     * return true for touch devies
     */
    hasTouch: function() {
        return (('ontouchstart' in window) || (navigator.MaxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0));
    },
    /**
     * Detect IE
     * returns the version of IE or undefined, if browser is not Internet Explorer
     */
    get_IE_version: function() {
        var ua = window.navigator.userAgent,
            msie = ua.indexOf('MSIE ');
        if (msie > 0) {
            // IE 10 or older => return version number
            return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
        }

        var trident = ua.indexOf('Trident/');
        if (trident > 0) {
            // IE 11 => return version number
            var rv = ua.indexOf('rv:');
            return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
        }

        var edge = ua.indexOf('Edge/');
        if (edge > 0) {
            // Edge (IE 12+) => return version number
            return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
        }

        // other browser
        return undefined;
    },

    /**
     * Returns the keys of a JavaScript object as an array. 
     */
    keys: function(obj) {
        var keys = [],
            k;
        for (k in obj) {
            if (obj.hasOwnProperty(k)) {
                keys.push(k);
            }
        }
        return keys;
    },

    /**
     * Iterate over the key-value pairs of the given object
     * in the order returned by the given comparator function.
     * 
     * Parameters:
     * obj - an object to iterate over
     * cmp - the comparator function. Accepts two objects (a, b) 
     *       and returns an integer greater than 0 if a > b, returns
     *       an integer less than 0 if a < b, returns 0 if a equals b.
     * fcn - the callback to execute for each key-value pair in the
     *       object. Shouldaccepts two arguments, a key and a
     *       value. Return true to break out of the loop early.
     */
    iterate_obj_in_order: function(obj, cmp, fcn) {
        var keys = this.keys(obj),
            len = keys.length,
            i, k;

        keys.sort(cmp);

        for (i = 0; i < len; i++) {
            k = keys[i];
            if (fcn(k, obj[k])) {
                break;
            }
        }
    },

    /*
     * Returns true if the given value is NOT null or undefined
     */
    varExists: function(val) {
        return val !== null && (typeof val !== 'undefined');
    },

    /**
     * Returns true if the given value is not null, undefined or empty (i.e. length === 0).
     * Only works on values that have a length property. 
     */
    existsAndNotEmpty: function(val) {
        return this.varExists(val) && val.length;
    },

    /*
     * Returns true if the given value is null or undefined
     TODO: remove this, since it's not following our JavaScript convention, use isNullOrUndefined instead
     */
    is_null_or_undefined: function(val) {
        return val === null || (typeof val === 'undefined');
    },

    /*
     * Returns true if the given value is null or undefined
     */
    isNullOrUndefined: function(val) {
        return val === null || (typeof val === 'undefined');
    },

    /*
     * Returns true if the given value is undefined.
     */
    isUndefined: function(val) {
        return typeof val === 'undefined';
    },

    /*
     * Returns true if the given value is undefined or empty (i.e. length === 0),
     * assumes the given value will have a length property if it's not undefined.
     */
    isUndefinedOrEmpty: function(val) {
        return (typeof val === 'undefined') || (val.length === 0);
    },

    /**
     * Returns true if the given value is an Object
     */
    isObject: function(val) {
        return (val !== null) && (typeof val === "object");
    },

    isString: function(val) {
        return typeof val === 'string';
    },

    /**
     * Converts a URI query into a JavaScript Object
     */
    queryToObject: function(query) {
        var json = '{"' + query.split("&").map(function(str) {
            // important, only replace the first occurrence, don't use a regex
            // to replace all occurence, because the value might have an '=' sign
            // (e.g. if it's a url)
            return str.replace("=", '":"');
        }).join('","') + '"}';

        return query ? JSON.parse(json,
            function(key, value) {
                return key === "" ? value : decodeURIComponent(value);
            }) : {};
    },

    /**
     * Updates the given URL with the given query parameter(s). Modifies the query parameter if it
     * already exists in the URL, otherwise adds the query parameters. 
     * 
     * @param uri the URL to modify
     * @param keys {string, Object} the name of the parameter (must also specify the val parameter) or
     * an Object where the property names are the parameter names and the property values are the 
     * parameter values.
     * @param val {string} the value of the parameter, if keys is an Object, val will be ignored.
     */
    updateQueryStringParameter: function(uri, keys, val) {
        var parameters = {};

        // Parameter checks
        if (this.isString(keys)) {
            parameters[keys] = val;
        } else if (this.isObject(keys)) {
            if (!this.isUndefined(val)) {
                console.warn("Value parameter passed, but will not be used: " + val);
            } else if ($.isEmptyObject(keys)) {
                console.warn("The given parameters are empty");
                return uri;
            }
            parameters = keys;
        } else {
            throw "Invalid key parameter, expected a String or an Object, got: " + keys;
        }

        $.each(parameters, function(key, value) {
            var re = new RegExp("([?|&])" + key + "=.*?(&|#|$)", "i");
            if (uri.match(re)) {
                uri = uri.replace(re, '$1' + key + "=" + value + '$2');
            } else {
                var hash = '';
                if (uri.indexOf('#') !== -1) {
                    hash = uri.replace(/.*#/, '#');
                    uri = uri.replace(/#.*/, '');
                }
                var separator = uri.indexOf('?') !== -1 ? "&" : "?";
                uri = uri + separator + key + "=" + value + hash;
            }
        });
        return uri;
    },

    /**
     * Returns a new Date object with the same date as the given date plus the given number of days.
     *
     * @param date {Date} a JavaScript Date object
     * @param days {integer} the number of days to add (if negative will subtract the given 
     * number of days)
     * @returns {Date} a new Date object
     */
    addDays: function(date, days) {
        var result = new Date(date);
        result.setDate(result.getDate() + days);
        return result;
    },

    /**
     * Returns a new Date object with the same date as the given date plus the given number of milliseconds.
     *
     * @param date {Date} a JavaScript Date object
     * @param milliseconds {integer} the milliseconds to add (if negative will subtract the given 
     * number of milliseconds)
     * @returns {Date} a new Date object
     */
    addMilliseconds: function(date, milliseconds) {
        return new Date(date.getTime() + milliseconds);
    },

    /* ----- USES JQUERY ----- */
    /*
     * Set the option of the given widget with data from the DOM if the option is currently
     * null or undefined. If the data from the DOM could not be found, then assign the 
     * given default value.
     * 
     * Parameters: 
     * widget - a jQuery widget
     * option_name - name of the option
     * data_name - name of the data in the DOM
     * default_val - the default value to assign if the data could not be found
     *               in the DOM.
     */
    set_option: function(widget, option_name, data_name, default_val) {
        if (this.is_null_or_undefined(widget.options[option_name])) {
            var data_val = $(widget.element).data(data_name);
            if (this.is_null_or_undefined(data_val)) {
                widget.option(option_name, default_val);
            } else {
                widget.option(option_name, data_val);
            }

        }
    },

    /**
     * Toggle the given hyperlink
     *
     * @param enable true if the hyperlink should be enabled (i.e. the browser will following the link
     * when the user clicks on it), false otherwise (i.e. browser will NOT follow the link when the user
     * clicks on it).
     */
    toggleHyperlink: function($link, enable) {
        if ($link.is("a")) {
            if (enable) {
                // Remove the click handler we added that prevents the default behaviour
                // from occurring
                $link.off("click.utils");
                // Restore the original onclick attribute
                var data = $link.data("utils.toggleHyperlink");
                $link.attr("onclick", data.onclick);
            } else {
                // Stop default href behaviour (note this does not stop other click
                // handlers attached to this link
                $link.on("click.utils", function(evt) {
                    evt.preventDefault();
                });
                // Remove the onclick attribute (evt.preventDefault does not appear to stop
                // browser from following the link). Store it in a data field so when we want
                // to re-enable it we add add the onclick attribute back
                $link.data("utils.toggleHyperlink", {
                    onclick: $link.attr("onclick")
                });
                $link.removeAttr("onclick");
            }

        } else {
            console.err("not a hyperlink: " + $link);
        }
    },

    /**
     * Returns the absolute position of the given element as well as it's 
     * width and height (same as Dojo's domGeometry.position)
     * 
     * @param element {string || jQuery Object || node}
     * Returns:
     * {
     *   x: x coordinate of the element in the document
     *   y: y coordinate of the element in the document
     *   width: width of the element
     *   height: height of the element
     * }
     */
    position: function(element) {
        var $e = $(element),
            offset = $e.offset();
        return {
            x: offset.left,
            y: offset.top,
            w: $e.width(),
            h: $e.height()
        };
    },

    /**
     * Returns true if the given String is empty or whitespace
     */
    isEmptyOrWhiteSpace: function(str) {
        return $.trim(str) === '';
    },

    /**
     * Returns true if the given value is a boolean
     */
    isBoolean: function(value) {
        return $.type(value) === "boolean";
    },

    /*
     * Given an array of jQuery selectors, returns a jQuery object
     * selecting all elements that match the given selectors. 
     */
    selectAll: function(selectors) {
        if (selectors.length > 0) {
            var elements = $(selectors[0]),
                i;
            for (i = 1; i < selectors.length; i++) {
                elements = elements.add(selectors[i]);
            }
            return elements;
        }
        // Return an empty jQuery object if we're given
        // an empty selector
        return $();
    },

    /* ----- JQUERY HELPERS ----- */
    /**
     * Returns true if the given element exists, false otherwise.
     *
     * @param selector {string} the jQuery selector of the element
     */
    elementExists: function(selector) {
        return $(selector).length > 0;
    },

    /**
     * Executes the given function on the jQuery object matched by the given
     * selector if the jQuery object exists. Does nothing otherwise. The return value
     * of this function will be the same as the given function (or undefined if the
     * function is not executed or does not return anything).
     *
     * @param selector {string} jQuery selector 
     * @param fcn {function($obj)} function that accepts a jQuery object as parameter
     * @param context {object} {optional} an optional context object to proxy onto the given
     * function
     */
    ifSelectorExists: function(selector, fcn, context) {
        var $obj = $(selector);
        if ($obj.length) {
            if (context) {
                return $.proxy(fcn, context)($obj);
            } else {
                return fcn($obj);
            }
        }
    },

    /**
     * Given an array of selectors, return the first jQuery object that exists (i.e. length > 0).
     */
    selectExistingElement: function(selectors) {
        return selectors.map(function(s) {
            return $(s);
        }).find(function($e) {
            return $e.length;
        });
    },

    /**
     * Replaces the given attribute
     *
     * @param $obj {jQuery object} the jQuery object to modify the attributes on
     * @param attrName {string} the name of the attribute 
     * @param transform {function} a function that takes the old attribute as argument
     * and returns the new attribute
     */
    replaceAttr: function($obj, attrName, transform) {
        $obj.attr(attrName, transform($obj.attr(attrName)));
    },

    /**
     * Scroll the dom element into view if it's not
     */
    scrollIntoView: function(node) {
        var nodeTop = $(node).offset().top;
        var docViewTop = $(window).scrollTop();
        if (nodeTop < docViewTop) {
            $(node)[0].scrollIntoView(true);
        } else if (nodeTop + $(node).height() > docViewTop + $(window).height()) {
            $(node)[0].scrollIntoView(false);
        }
    },

    /**
     * Binds the given event only once (unbinds all previous instances of this event).
     * 
     * @param $node {jQuery object} the jQuery object to bind the event to 
     * @param eventName {string} the name of the event (e.g. "click" or "keydown")
     * @param namespace {string} namespace for this event, must be unique, otherwise other 
     *                           events with the same namespace will be removed as well
     * @param childSelector {string} {optional} the child selector for this event
     * @param handler {function} the handler for this event
     */
    onOnce: function($node, eventName, namespace, childSelector, handler) {
        var fullEventName = eventName + "." + namespace;
        if (this.isString(childSelector)) {
            $node.off(fullEventName).on(fullEventName, childSelector, handler);
        } else {
            handler = childSelector;
            $node.off(fullEventName).on(fullEventName, handler);
        }

    },

    /**
     * Replaces {obj.attr} param in a string with string specified in an object
     * @param origString {string} original string with param to be replaced
     * @param targObject {object} contains required attributes for the string substitution
     * 
     * Example usage: substituteStringWithObj("<p>{address.city}, {address.postalCode}</p>", {"address": {"city": "toronto", "postalCode": "12345"}}) will return
     * "<p>toronto, 12345</p>"
     */
    substituteStringWithObj: function(origString, targObject) {
        return origString.replace(/{(\w+(\.*\w*)*)}/g, function(match, key) {
            if (typeof targObject !== 'undefined') {
                var subArgs = targObject;
                var subObject = key.substr(0, key.indexOf("."));
                key = key.substr(key.indexOf(".") + 1, key.length);
                while (subObject !== "") {
                    subArgs = subArgs[subObject];
                    subObject = key.substr(0, key.indexOf("."));
                    key = key.substr(key.indexOf(".") + 1, key.length);
                }
                if (key !== "") {
                    subArgs = subArgs[key];
                }

                return typeof subArgs !== 'undefined' ? subArgs : match;
            } else {
                return match;
            }
        });
    },

    /**
     * Replaces {i} param in a string with string specified in substituteMap
     * @param origString the original string that contains {i} to be substitute
     * @param substituteMap a map containing strings to substitute into original string
     * 
     * Example usage: substituteStringWithMap("hi {0}, this is {1}!", {0: "Aurora", 1: "jQuery"}) will return
     * "hi Aurora, this is jQuery!"
     */
    substituteStringWithMap: function(origString, substituteMap) {
        origString = origString.replace(/\{([0-9])\}/g, function(match, key) {
            return substituteMap[key];
        });
        return origString;
    },

    /**
     * Get Localization Messages from nls
     * example: Utils.getLocalizationMessage(message, {0: arg1, 1: arg2})
     */
    getLocalizationMessage: function(message, /* optional*/ params) {
        if (GlobalizeLoaded) {
            return Globalize.formatMessage(message, params);
        }
    },

    /**
     * Get localized currency display
     * example: Utils.formatCurrency("123.4", {
     *                  minimumFractionDigits: 2,
     *                  maximumFractionDigits: 2,
     *                  currency: "USD"
     *          })
     * 
     * @param amount {string}
     * @param options {object} may include currency, minimumFractionDigits, maximumFractionDigits, etc.
     */
    formatCurrency: function(amount, options) {
        amount = amount.replace(/[^0-9\.\,]/g, '');
        if (options) {
            var currency = options["currency"];
            var locale = options["locale"];
        }
        if (!currency) {
            currency = WCParamJS.commandContextCurrency;
        }
        if (GlobalizeLoaded) {
            if (locale) {
                amount = Globalize(locale).parseNumber(amount);
                return Globalize(locale).formatCurrency(amount, currency, options);
            } else {
                amount = Globalize.parseNumber(amount);
                return Globalize.formatCurrency(amount, currency, options);
            }
        }
    },

    /**
     * Parse numbers according to localized information
     * example: Utils.parseNumber("123.4")
     * 
     * @param amount {string}
     */
    parseNumber: function(amount) {
        amount = amount.replace(/[^0-9\.\,]/g, '');
        if (GlobalizeLoaded) {
            return Globalize.parseNumber(amount);
        }
    },

    /**
     * Format numbers according to localized information
     * example: Utils.formatNumber("123.4", {maximumFractionDigits: 2, minimumFractionDigits: 2})
     * 
     * @param amount {string}
     * @param options {object} may include minimumFractionDigits, maximumFractionDigits, etc.
     */
    formatNumber: function(amount, options) {
        amount = amount.replace(/[^0-9\.\,]/g, '');
        if (GlobalizeLoaded) {
            amount = Globalize.parseNumber(amount);
            return Globalize.formatNumber(amount, options);
        }
    },

    /**
     * Returns the locale.
     */
    getLocale: function() {
        return navigator.languages ? navigator.languages[0] : (navigator.language || navigator.userLanguage);
    },

    /**
     * Round the given value to the given number of decimals.
     */
    round: function(value, decimals) {
        return Number(Math.round(value + 'e' + decimals) + 'e-' + decimals);
    },

    /**
     * Converts any value to true/false depending on it's truthy value (e.g. undefined, 0, null 
     * returns false, 1, objects return true). 
     */
    toBoolean: function(value) {
        // First ! converts it to a boolean, second ! reverts the value back (i.e. false to true and
        // vice-versa)
        return !!value;
    },

    /**
     * Returns true if the given array contains the given value, false otherwise.
     */
    arrContains: function(arr, value) {
        return $.inArray(value, arr) !== -1;
    },

    /**
     * Returns true if the given string is not null or white space.
     */
    notNullOrWhiteSpace: function(str) {
        return str !== null && $.trim(str).length !== 0;
    },

    /**
     * Returns the name of the first property in the object that satisfies the given predicate.
     *
     * @param obj a JavaScript Object
     * @param predicate a function that takes two arguments: the property name and property value
     */
    findInObj: function(obj, predicate) {
        var target;
        $(obj).each(function(key, val) {
            if (predicate(key, val)) {
                target = key;
                return false; // breaks out of the each
            }
        });
        return target;
    },

    /**
     * Returns true if the two given elements belong to the same parent. 
     *
     * @param $e1 a jQuery Object representing zero or more elements
     * @param $e2 a jQuery Object representing zero or more elements
     */
    areSiblings: function($e1, $e2) {
        var isSibling = function(e1, e2) {
            return $(e1).siblings().is($(e2));
        };
        if (!arrayUtils.verifyTransitiveProperty($e1, isSibling) || !arrayUtils.verifyTransitiveProperty($e2, isSibling)) {
            return false;
        } else if (arrayUtils.isEmpty($e1) || arrayUtils.isEmpty($e2)) {
            return true;
        } else {
            return isSibling(arrayUtils.last($e1), $e2[0]);
        }
    },

    /**
     * Returns true if the given elements are the same parent element.
     *
     * @param jqObj a jQuery object representing elements
     */
    sameParent: function(jqObj) {},

    /**
     * Return a property from a dot-separated string, such as "A.B.C"
     *
     * @param name: {string} path to an property, in the form "A.B.C"
     */
    getObject: function(name) {
        if (name === "") return;

        var nameArray = name.split(".");
        var result = window[nameArray[0]];

        for (i = 1; i < nameArray.length; i++) {
            if (!result) break;
            result = result[nameArray[i]];
        }

        return result;
    },

    /**
     * Return a property from a dot-separated string, such as "A.B.C"
     *
     * @param name: {string} path to an property, in the form "A.B.C"
     */
    idExists: function() {
        if (arguments.length === 0) {
            console.warn("No arguments passed to idExists");
            return true;
        }
        for (var i = 0; i < arguments.length; i++) {
            if (!$(arguments[i].length)) {
                return false;
            }
        }
        return true;
    },

    /**
     * Call a function after the original function returns
     *
     * @param srcObj: {string} source object of the original function
     * @param oldFunc: {string} original function name
     * @param callback: {function} the function will be called afterwards
     */
    aop_after: function(srcObj, oldFunc, callback) {
        var old = $.proxy(srcObj[oldFunc], srcObj);
        srcObj[oldFunc] = function() {
            old.apply(this, arguments);
            return callback(arguments);
        }
    },

    /**
     * Replaces ${i} param in a string with string specified in substituteMap
     * param origString the original string that contains ${i} to be substitute
     * param substituteMap a map containing strings to substitute into original string
     * example usage: substituteString("hi ${0}, this is ${1}!", {0: "Aurora", 1: "jQuery"}) will return
     * "hi Aurora, this is jQuery!"
     */
    substituteString: function(origString, substituteMap) {
        origString = origString.replace(/\$\{([0-9])\}/g, function(match, key) {
            return subsMap[key];
        });
        return origString;
    }
};//-----------------------------------------------------------------
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


/**
 * @fileOverview This file provides the functions needed by a refresh area
 */

jQuery(document).ready(function($) {
    $.widget("wc.refreshWidget", {
        url: undefined,
        ariaMessage: undefined,
        ariaLiveId: undefined,

        // default options
        options: {
            formId: undefined,
            renderContextChangedHandler: null,
            postRefreshHandler: null
        },
        _create: function() {
            if (this.element.attr("refreshurl")) {
                this.url = this.element.attr("refreshurl");
            }
            if (!this.url) {
                console.warn("Warning: refreshurl is not defined for refresh area: " + this.element.attr("id"));
            }
            if (this.element.attr("wcType") !== "RefreshArea") {
                console.error("Error: wcType is not set to 'RefreshArea' for refresh area: " + this.element.attr("id"));
            }
            if (!this.element.attr("declareFunction")) {
                console.error("Error: declareFunction is not set for refresh area: " + this.element.attr("id"));
            }
            if (this.element.attr("ariaMessage")) {
                this.ariaMessage = this.element.attr("ariaMessage");
            }
            if (this.element.attr("ariaLiveId")) {
                this.ariaMessage = this.element.attr("ariaLiveId");
            }
        },
        updateUrl: function(newURL) {
            this.url = newURL;
        },
        updateFormId: function(newFormId) {
            this.options.formId = newFormId;
        },
        refresh: function(parameters) {
            var domNode = this.element;
            var widget = this;

            //Obtain refreshurl which is defined in controller
            if (!this.url && this.element.attr("refreshurl")) {
                this.url = this.element.attr("refreshurl");
            }

            var formNode = null;
            if (this.options.formId) {
                formNode = $("#" + this.options.formId);
            }

            if (parameters) {
                if (!parameters.requesttype) {
                    parameters.requesttype = 'ajax';
                }
            } else {
                parameters = {requesttype: 'ajax'};
            }

            if (!this.url) {
                console.error("refreshurl is not specified for refresh area: " + domNode.attr("id"));
                return;
            }

            //Remove all instances of "amp;" in the URL which was added on the JSP by c:out
            this.url = this.url.replace(/amp;/g, "");

            var mergedParameters = parameters;

            if(typeof wcCommonRequestParameters === "object"){
                mergedParameters = {};
                $.extend(mergedParameters, parameters);

                for(var parameterName in wcCommonRequestParameters){
                    if(!this._isParameterExcluded(this.url, parameterName)){
                        mergedParameters.parameterName = wcCommonRequestParameters.parameterName;
                    } else {
                        console.debug("parameter " + parameterName + " is excluded");
                    }
                }
            }

            // deal with javascript array problem - convert to proper key/value pairs required by jquery Ajax
            if ($.isArray(mergedParameters)) {
                var keyValuePairs = {};
                for (var paramKey in mergedParameters) {
                    if ($.isArray(mergedParameters[paramKey])) {
                        if (mergedParameters[paramKey].length > 0) {
                            keyValuePairs[paramKey] = mergedParameters[paramKey];
                        }
                    } else {
                        keyValuePairs[paramKey] = mergedParameters[paramKey];
                    }
                }
                mergedParameters = keyValuePairs;
                console.debug("mergedParameters after modifying = " + JSON.stringify(mergedParameters));
            }

            var failureHandler = function(data, status) {
                console.error("failed to refresh widget " + domNode.attr("id"));
                wcTopic.publish("ajaxRequestCompleted");
            }

            var successHandler = function(data, status) {
                function getIds(idType, controllerURL) {
                    var myId = "";
                            if (mergedParameters && mergedParameters[idType]) {
                                    myId = mergedParameters[idType];
                    }
                    if (myId === "" && formNode != null && formNode[idType]) {
                        myId = formNode[idType];
                        if (formNode[idType].value != null) {
                            myId = formNode[idType].value;
                        }
                    }
                    if (myId === "" && controllerURL) {
                        var temp = controllerURL;
                        if (temp.indexOf(idType) !== -1) {
                            temp = temp.substring(temp.indexOf(idType));
                            var tokens = temp.split("&");
                            var tokens2 = tokens[0].split("=");
                            myId = tokens2[1];
                        }
                    }
                    return myId;
                }
                function parseJsonCommentFiltered(str){
                    str = str.replace('\/\*', '');
                    str = str.replace('\*\/', '');
                    var json = eval('(' + str + ')');
                    return json;
                }

                // determine storeId, catalogId and langId to use in our redirect url
                var storeId = getIds("storeId", widget.url);
                var catalogId = getIds("catalogId", widget.url);
                var langId = getIds("langId", widget.url);
                var errorCodeBegin = data.indexOf('errorCode');

                function serverErrorHandler(errorCode) {
                    console.debug('error condition encountered - error code: ' + errorCode);
                    // error code: ERR_DIDNT_LOGON
                    // This error code is returned in the scenario where logon is required and user is not logged on
                    if (errorCode.indexOf('2550') !== -1) {
                        console.debug('error type: ERR_DIDNT_LOGON - the customer did not log on to the system.');
                        console.debug("redirecting to URL: AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1');
                        document.location.href = "AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                    }

                    // error code: ERR_SESSION_TIMEOUT
                    // This error code is returned in the scenario where user's logon session has timed out
                    else if (errorCode.indexOf('2510') !== -1) {
                        //redirect to a full page for sign in
                        console.debug('error type: ERR_SESSION_TIMEOUT - use session has timed out');
                        var serviceResponse = parseJsonCommentFiltered(data);
                        var timeoutURL = "Logoff?";
                        if (serviceResponse.exceptionData.isBecomeUser == 'true') {
                            timeoutURL = "RestoreOriginalUserSetInSession?URL=Logoff&";
                        }
                        if (serviceResponse.exceptionData.rememberMe == 'true'){
                            var myURL = timeoutURL + 'rememberMe=true&storeId=' + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                            console.debug('try to logoff, get URL='+myURL);
                            $.ajax({
                                type: "GET",
                                url: myURL,
                                data: mergedParameters,
                                success: function(data, status) {
                                  console.debug('User logged off. Reload current page to avoid data inconsistence...');
                                  document.location.reload();
                                },
                                error: function(data) {
                                    // failed to logoff, directly go to relogon form;
                                    // this should not happen, just in case.
                                    document.location.href = 'ReLogonFormView?rememberMe=true&storeId='+storeId;
                                }
                            });
                        }
                        else {
                            console.debug('redirecting to URL: ' + timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId);
                            document.location.href = timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId;
                        }
                    }

                    // error code: ERR_PROHIBITED_CHAR
                    // This error code is returned in the scenario where user has entered prohibited character(s) in the request
                    else if (errorCode.indexOf('2520') !== -1) {
                        console.debug('error type: ERR_PROHIBITED_CHAR - detected prohibited characters in request');
                        console.debug("redirecting to URL: ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                    }

                    // error code: ERR_CSRF
                    // This error code is returned in the scenario where a cross-site request forgery attempt was caught
                    else if (errorCodeString.indexOf('2540') !== -1) {
                        console.debug('error type: ERR_CSRF - cross site request forgery attempt was detected');
                        console.debug("redirecting to URL: CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                    }

                    // error code: _ERR_INVALID_COOKIE
                    // This error code is returned in the scenario where a cookie error occurs
                    else if (errorCodeString.indexOf('CMN1039E') !== -1) {
                        console.debug('error type: _ERR_INVALID_COOKIE - cookie error was detected');
                        console.debug("redirecting to URL: CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                    }
                }

                if (errorCodeBegin != -1) {
                    // error code returned, get error code and handle error condition
                    var errorCodeEnd = data.indexOf(',', errorCodeBegin);
                    var errorCodeString = data.substring(errorCodeBegin, errorCodeEnd);
                    serverErrorHandler(errorCodeString);
                } else {
                    // no error from get request, refresh area and call post refresh controller
                    domNode.html(data);
                    WCWidgetParser.parse(domNode);
                    if (widget.options.postRefreshHandler != null) {
                        widget.options.postRefreshHandler(widget.element);
                    }
                }
                wcTopic.publish("ajaxRequestCompleted");
                widget._updateLiveRegion();
            }

            var ajaxParams = {
                data: (formNode)? formNode.serialize()+"&"+$.param(mergedParameters) : mergedParameters,
                url: this.url,
                type: "POST",
                traditional: true,
                success: successHandler,
                error: failureHandler
            };

            $.ajax(ajaxParams);
        },

        renderContextChanged: function(refreshAreaDiv) {
            if (this.options.renderContextChangedHandler != null) {
                this.options.renderContextChangedHandler(refreshAreaDiv);
            }
        },

        _updateLiveRegion: function () {
            $("#" + this.ariaLiveId + "_ACCE_Label").css("display", "block");

            if (this.ariaMessage !== "" && this.ariaLiveId !== "") {
                var messageNode = document.createTextNode(this.ariaMessage);
                var liveRegionNode = document.getElementById(this.ariaLiveId);
                if (liveRegionNode) {
                    while (liveRegionNode.firstChild) {
                        liveRegionNode.removeChild(liveRegionNode.firstChild);
                    }
                    liveRegionNode.appendChild(messageNode);
                }
            }
        }

    });

}(jQuery));



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

wcRenderContext={
    contextArray: {},

    getRefreshAreaIds: function(id) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.getRefreshAreaIds: Common render context " + id + " is not defined");
            return;
        }
        return this.contextArray[id]["refreshAreaIds"];
    },

    getRenderContextProperties: function(id) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.getRenderContextProperties: Common render context " + id + " is not defined");
            return;
        }
        return this.contextArray[id]["contextProperties"];
    },

    addRefreshAreaId: function(id, refreshAreaId) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.addRefreshAreaId: Common render context " + id + " is not defined");
            return;
        }
        if (!Utils.arrContains(this.contextArray[id]["refreshAreaIds"], refreshAreaId)) {
            this.contextArray[id]["refreshAreaIds"].push(refreshAreaId);
        }        
    },

    declare: function(id, refreshAreaIds, initialProperties) {
        // create new context obj and add to contextArray
        if (this.checkIdDefined(id)) {
            console.error("Common render context with id =  " + id + " already exits.Please use a different id");
            return;
        } else if (!$.isArray(refreshAreaIds)) {
            console.error("refresh area ids should be an array, got: " + refreshAreaIds);
            return;
        }
        
        // if initial property is empty, create an empty object
        if (initialProperties === "") {
            initialProperties = {};
        }
        
        var context = {
            "id": id,
            "refreshAreaIds": refreshAreaIds,
            "contextProperties": initialProperties,
            // The current render context properties. This object is used to determine what properties have
            // actually changed since the last time a render context changed event was detected.
            "currentRCProperties": {}
        };
        this.contextArray[id] = context;
        this._syncRCProperties(id);
    },

    updateRenderContext: function(id, properties) {
        if (!this.checkIdDefined(id)) {
            console.error("wcRenderContext.updateRenderContext: Common render context " + id + " is not defined");
            return;
        }

        var curRenderContext = this.getRenderContextProperties(id);
        for (var name in properties) {
            var value = properties[name];
            if (value != curRenderContext[name]) {
                //contextChanged = true;

                if (Utils.isUndefined(value)) {
                    delete curRenderContext[name];
                } else {
                    curRenderContext[name] = value;
                }
            }
        }

        var curRefershAreas = this.getRefreshAreaIds(id);
        $.each(curRefershAreas, function(i, refreshDivId) {
            var refreshAreaDiv = $("#" + refreshDivId);
            refreshAreaDiv.refreshWidget("renderContextChanged", refreshAreaDiv);
        });
        
        wcTopic.publish(id + "/RenderContextChanged", {actionId: id + "/RenderContextChanged"});

        this._syncRCProperties(id);
    },

    testForChangedRC: function(id, propertyNames) {
        var change = false;
        for (var i = 0; i < propertyNames.length; i++) {
            var prop = propertyNames[i];
            if (this.contextArray[id]["currentRCProperties"][prop] != this.contextArray[id]["contextProperties"][prop]) {
                change = true;
                break;
            }
        }
        return change;
    },

    checkIdDefined: function(id) {
        return Utils.toBoolean(this.contextArray[id]);
    },

    _syncRCProperties: function(id) {        
        var rc = this.getRenderContextProperties(id),
            properties = $.extend({}, rc); // shallow copy
        this.contextArray[id]["currentRCProperties"] = properties;
    }
};



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


/**
 * @fileOverview This file provides the functions needed to declare and invoke a service in Commerce
 */

(function($) {
    $.wcServicePlugin = function(options) {
        var settings = $.extend({
            id: undefined,
            actionId: undefined,
            url: undefined,
            formId: undefined,
            successHandler: undefined,
            failureHandler: undefined
        }, options);

        var validateParameters = function(parameters) {
            return true;
        };

        var validateForm = function(formNode) {
            return true;
        }

        var successTest = function(serviceResponse) {
            return !serviceResponse.errorMessage && !serviceResponse.errorMessageKey;
        };

        var _isParameterExcluded = function(url, parameterName){
            try{
                if(typeof URLConfig === 'object'){
                    if (typeof URLConfig.excludedURLPatterns === 'object'){
                        for (var urlPatternName in URLConfig.excludedURLPatterns){
                            var exclusionConfig = URLConfig.excludedURLPatterns[urlPatternName];
                            var urlPattern = urlPatternName;
                            if(typeof exclusionConfig === 'object'){
                                if(exclusionConfig.urlPattern){
                                    urlPattern = exclusionConfig.urlPattern;
                                }
                                console.debug("URL pattern to match : " + urlPattern);
                                urlPattern = new RegExp(urlPattern);

                                if(url.match(urlPattern)){
                                    var excludedParametersArray = exclusionConfig.excludedParameters;
                                    for(var excludedParameter in excludedParametersArray){
                                        if(parametername == excludedParameter){
                                            return true;
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        console.debug("The parameter " + parameterName + " is not excluded");
                    }
                } else {
                    console.debug("No URLConfig defined.")
                }
            } catch (err){
                console.debug("An error occured while trying to exclude " + err);
            }
            return false;
        }

        var output = {
            'setFormId': function(formId) {
                settings.formId = formId;
            },
            'setActionId': function(actionId) {
                settings.actionId = actionId;
            },
            'setUrl': function(url) {
                settings.url = url;
            },
            'setParam': function(paramName, value) {
            	settings[paramName] = value;
            },
            'getParam': function(paramName) {
                return settings[paramName];
            },
            'invoke': function(parameters) {
                var valid = true;
                var formNode = null;
                if (settings.formId) {
                    formNode = $("#" + settings.formId);
                }

                if (formNode) {
                    valid = validateForm(formNode);
                }

                if (valid) {
                    valid = validateParameters(parameters);
                }

                function addAuthToken(parameters){
                    try{
                        if ($("#csrf_authToken").length){
                            parameters["authToken"] = $("#csrf_authToken").val();
                        } else {
                            console.debug("auth token is missing from the HTML DOM");
                        }
                        return true;
                    } catch (err){
                        console.debug("An error occured while trying to add authToken to request " + err);
                    }
                    return false;
                }


                if (parameters) {
                    if (!parameters.requesttype) {
                        parameters.requesttype = 'ajax';
                    }
                } else {
                    parameters = {};
                    parameters.requesttype = 'ajax';
                }

                addAuthToken(parameters);

                var mergedParameters = parameters;
                if(typeof wcCommonRequestParameters === 'object'){
                    mergedParameters = {};
                    $.extend(mergedParameters, parameters);

                    for(var parameterName in wcCommonRequestParameters){
                        if(!_isParameterExcluded(this.url, parameterName)){
                            mergedParameters.parameterName = wcCommonRequestParameters.parameterName;
                        } else {
                            console.debug("parameter " + parameterName + " is excluded");
                        }
                    }
                }

                // deal with javascript array problem - convert to proper key/value pairs required by jquery Ajax
                if ($.isArray(mergedParameters)) {
                    var keyValuePairs = {};
                    for (var paramKey in mergedParameters) {
                        if ($.isArray(mergedParameters[paramKey])) {
                            if (mergedParameters[paramKey].length > 0) {
                                keyValuePairs[paramKey] = mergedParameters[paramKey];
                            }
                        } else {
                            keyValuePairs[paramKey] = mergedParameters[paramKey];
                        }
                    }
                    mergedParameters = keyValuePairs;
                    console.debug("mergedParameters after modifying = " + JSON.stringify(mergedParameters));
                }

                var successHandler = function(serviceResponse, status) {
                    function getIds(idType, controllerURL) {
                        var myId = "";
                        if (mergedParameters && mergedParameters[idType]) {
                            myId = mergedParameters[idType];
                        }
                        if (myId == "" && formNode != null && formNode[idType]) {
                            myId = formNode[idType];
                            if (formNode[idType].value != null) {
                                myId = formNode[idType].value;
                            }
                        }
                        if (myId == "" && controllerURL) {
                            var temp = controllerURL;
                            if (temp.indexOf(idType) != -1) {
                                temp = temp.substring(temp.indexOf(idType));
                                var tokens = temp.split("&");
                                var tokens2 = tokens[0].split("=");
                                myId = tokens2[1];
                            }
                        }
                        return myId;
                    }

                    // determine storeId, catalogId and langId to use in our redirect url
                    var storeId = getIds("storeId", settings.url);
                    var catalogId = getIds("catalogId", settings.url);
                    var langId = getIds("langId", settings.url);

                    function serverErrorHandler(errorCode) {
                        // error code: ERR_USER_NOT_LOGGED_ON
                        // This error code is returned in the scenario where logon is required and user is not logged on
                        if (errorCode == '2500') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');

                            myURL = 'LogonForm?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                            console.debug('error type: ERR_USER_NOT_LOGGED_ON - only registered user can invoke the command');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                        }

                        // error code: ERR_DIDNT_LOGON
                        // This error code is returned in the scenario where logon is required and user is not logged on
                        else if (errorCode == '2550') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');
                            myURL = 'AjaxLogonForm?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                            console.debug('error type: ERR_DIDNT_LOGON - the customer did not log on to the system.');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                        }

                        // error code: ERR_PASSWORD_REREQUEST
                        // This error code is returned in the scenario where password is required to proceed
                        else if (errorCode == '2530') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');
                            myURL = 'PasswordReEnterErrorView?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                            console.debug('error type: ERR_PASSWORD_REREQUEST - password is required');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                        }

                        // error code: ERR_SESSION_TIMEOUT
                        // This error code is returned in the scenario where user's logon session has timed out
                        else if (errorCode == '2510') {
                            //redirect to a full page for sign in
                            console.debug('error type: ERR_SESSION_TIMEOUT - use session has timed out');
                            var timeoutURL = "Logoff?";
                            if (serviceResponse.exceptionData.isBecomeUser == 'true') {
                                timeoutURL = "RestoreOriginalUserSetInSession?URL=Logoff&";
                            }
                            if (serviceResponse.exceptionData.rememberMe == 'true'){
                                var myURL = timeoutURL + 'rememberMe=true&storeId=' + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                                console.debug('try to logoff, get URL='+myURL);

                                $.ajax({
                                    type: "GET",
                                    url: myURL,
                                    data: mergedParameters,
                                    success: function(data, status) {
                                      console.debug('User logged off. Reload current page to avoid data inconsistence...');
                                      document.location.reload();
                                    },
                                    error: function(data) {
                                        // failed to logoff, directly go to relogon form;
                                        // this should not happen, just in case.
                                        document.location.href = 'ReLogonFormView?rememberMe=true&storeId='+storeId;
                                    }
                                })
                            } else {
                                console.debug('redirecting to URL: ' + timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId);
                                document.location.href = timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId;
                            }
                        }

                        // error code: ERR_PROHIBITED_CHAR
                        // This error code is returned in the scenario where user has entered prohibited character(s) in the request
                        else if (errorCode == '2520') {
                            console.debug('error type: ERR_PROHIBITED_CHAR - detected prohibited characters in request');
                            console.debug("redirecting to URL: " + "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                        }

                        // error code: ERR_CSRF
                        // This error code is returned in the scenario where a cross-site request forgery attempt was caught
                        else if (errorCode == '2540') {
                            console.debug('error type: ERR_CSRF - cross site request forgery attempt was detected');
                            console.debug("redirecting to URL: " + "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                        }

                        // error code: _ERR_INVALID_COOKIE
                        // This error code is returned in the scenario where a cookie error occurs
                        else if (errorCode == 'CMN1039E') {
                            console.debug('error type: _ERR_INVALID_COOKIE - cookie error was detected');
                            console.debug("redirecting to URL: " + "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                        }

                        else if (settings.failureHandler) {
							console.debug('calling service.failureHandler');
							settings.failureHandler(serviceResponse, status);
                        }
                        wcTopic.publish("ajaxRequestCompleted");
                    }

                    // debugging statement
                    console.debug("response from ajax call:");
                    for (var prop in serviceResponse) {
                        console.debug("  " + prop + "=" + serviceResponse[prop]);
                    }

                    if (successTest(serviceResponse)) {
                        if (settings.successHandler) {
                            var reqData = $(this).attr('data');
                            reqData = reqData?JSON.parse('{"' + reqData.replace(/&/g, '","').replace(/=/g,'":"') + '"}',
                                function(key, value) { return key===""?value:decodeURIComponent(value) }):{}
                            settings.successHandler(serviceResponse, reqData);

                            console.debug("success: publishing modelChanged event")
                        }
						if (settings.actionId) {
							console.debug('triggering action: ' + settings.actionId);
							wcTopic.publish(settings.actionId, {actionId: settings.actionId, data:serviceResponse});
						}
                    }
					else {
                        // error returned from server
                        console.debug('error condition encountered - error code: ' + serviceResponse.errorCode);
                        serverErrorHandler(serviceResponse.errorCode);
                    }
                };

                // when the AJAX method returns failed status
                var failureHandler = function(serviceResponse, status) {
                    console.debug("Warning: communication error while making the service call"); // Communication error.
                    var message = serviceResponse.errorMessage;
                    if (message) {
                        alert(message);
                    }
                    else {
                        message = serviceResponse.errorMessageKey;
                        if (message) {
                            alert(message);
                        }
                        else {
                            alert("Service request error.");
                        }
                    }
                };

                console.debug("service formId = " + settings.formId);

                if (!valid) return;

                wcTopic.publish("ajaxRequestInitiated");

                var stripComment = function(str, startString, endString) {
                    // remove <startString> <endString> pair. e.g. <!-- and -->
                    var beginIndex = str.indexOf(startString);
                    var endIndex = -1;
                    var part1 = "";
                    var part2 = "";
                    if (beginIndex != -1) {
                        endIndex = str.indexOf(endString);
                    }
                    if (endIndex != -1) {
                        part1 = str.substr(0,beginIndex);
                        part2 = str.substr(endIndex + endString.length);
                        str = part1 + part2;
                    }
                    // removes comments recursively
                    if (str.indexOf(startString) != -1) {
                        str = stripComment(str, startString, endString);
                    }
                    return str;
                };

                var ajaxParams = {
                    url: settings.url,
                    type: "POST",
                    data: (formNode)? formNode.serialize()+"&"+$.param(mergedParameters,true) : mergedParameters,
                    traditional: true,
                    dataFilter: function (str) {
                        // remove /* */ pair
                        str = str.replace('\/\*', '');
                        str = str.replace('\*\/', '');

                        if (str.indexOf("<!--") != -1) {
                            str = stripComment(str, "<!--", "-->");
                        }

                        if (str.indexOf("<%--") != -1) {
                            str = stripComment(str, "<%--", "--%>");
                        }

                        var json = eval('(' + str + ')');
                        return json;
                    },
                    success: successHandler,
                    error: failureHandler
                };

                $.ajax(ajaxParams);
            }

        };

        return output;
    }
}(jQuery));


wcService={
    wcServices: {},

    getServiceById:function(serviceId) {
        return this.wcServices[serviceId];
    },

    declare: function(initProperties) {
        if (!initProperties.id) {
            return;
        }
        this.wcServices[initProperties.id] = $.wcServicePlugin(initProperties);
    },

    invoke: function(serviceId, parameters) {
        var service = this.getServiceById(serviceId);
        if (service) {
            service.invoke(parameters);
        }
        else {
            console.error("Attempt to invoke an unregistered service: " + serviceId);
        }
    }
}


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
/* global Utils, document, jQuery */

var WCWidgetParser;
(function ($) {
    WCWidgetParser = WCWidgetParser || {
        widgetDefinitions: {
            // jQuery UI Widgets
            dialog: {
                fcnName: "Dialog"
            },
            autocomplete: {
                fcnName: "autocomplete"
            },
            tabs: {
                fcnName: "tabs"
            },
            datepicker: {
                fcnName: "datepicker",
                defaultOptions: {
                    showOtherMonths: true,
                    changeYear: true,
                    dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
                    altFormat: "yy-mm-dd",
                    dateFormat: "mm/dd/yy"
                }
            },
            // Custom widgets
            "wc.WCDialog": {
                fcnName: "WCDialog"
            }, 
            "wc.Carousel": {
                fcnName: "Carousel"
            },
            "wc.Grid": {
                fcnName: "Grid"
            },
            "wc.tooltip": {
                fcnName: "wcToolTip"
            },
            "wc.Select": {
                fcnName: "Select"
            },
            "wc.ValidationTextbox": {
                fcnName: "ValidationTextbox"
            }
        },

        /*
        */
        _parse_widget: function ($element, widgetName, htmlOptions) {
            var entry = this.widgetDefinitions[widgetName];
            if (!entry) {
                console.error("Widget type: " + widgetName + " not registered");
                return;
            }
            
            var fcn_name = entry.fcnName,
                default_options = entry.default_options || {};
            htmlOptions = htmlOptions || {};
            
            if (Utils.isObject(htmlOptions) || $.isArray(htmlOptions)) {
                /*
                Grab options declared in the html (if any). Merge it with the passed in 
                default_options (if any). The options declared in the html takes higher precedence
                than the given default_options. I.e.
                If these options where declared in the html:
                {
                    abc: 123,
                    efg: 456
                }
                These were the default options:
                {
                    abc: 789,
                    hij: 567
                }
                Then this would be passed to widget constructor:
                {
                    abc: 123, // from options declared in the html, which overwrites the default options
                    efg: 456, // from options declared in the html
                    hij: 567 // from the default options
                }
                */
                var options = $.extend({}, default_options, htmlOptions);
                if ($element[fcn_name]) {
                    $element[fcn_name](options);
                } else {
                    console.error("Function: " + fcn_name + " does not exist");
                }
                
                
            } else {
                $element[fcn_name](default_options);
                console.error("The given html option is neither an Object nor an array (the default options will be used instead): " + htmlOptions);
            }
        },

        /*
         * Declare widget in html like so:
         * <div data-widget-type="declare_name" />
         *
         * @param context the DOM Node to parse under, can be undefined in which case the entire page is
         *                parsed
         */
        parse: function (context) {
            // An array of Objects, each Object has the following fields:
            // element: the jQuery element to parse
            // widgetName: the name of the widget (specified by the "widget-type" data field)
            // widgetOptions: the options passed to the widget, if any (specified by the "widget-options"
            //                data field)
            var widgetsToParse = [];
            $("[data-widget-type]", context).each($.proxy(function (i, element) {
                var $element = $(element),
                    widgetName = $element.data("widget-type"),
                    widgetOptions = $element.data("widget-options");

                if ($.isArray(widgetName)) { // Multiple widgets defined
                    if (Utils.varExists(widgetOptions) && !$.isArray(widgetOptions)) {
                        console.error("widgetName is an array but widgetOptions is not: " + widgetOptions);

                    } else if (widgetName.length !== widgetOptions.length) {
                        console.error("widgetName and widgetOptions have different lengths");

                    } else {
                        widgetName.forEach(function (name, i) {
                            widgetsToParse.push({
                                element: $element,
                                widgetName: name,
                                widgetOptions: widgetOptions[i]
                            });                          
                        });
                    }

                } else {
                    widgetsToParse.push({
                        element: $element,
                        widgetName: widgetName,
                        widgetOptions: widgetOptions
                    });                    
                }
            }, this));
            
            var sortByParseOrder = function(w1, w2) {
                if (w1.widgetOptions && w1.widgetOptions.parseOrder) {
                    if (w2.widgetOptions && w2.widgetOptions.parseOrder) {
                        return w1.widgetOptions.parseOrder - w2.widgetOptions.parseOrder;
                    } else {
                        // Only w1 has parseOrder specified
                        return -1; 
                    }
                } else if (w2.widgetOptions && w2.widgetOptions.parseOrder) {
                    // Only w2 has parseOrder specified
                    return 1;
                } else {                    
                    // Neither has parseOrder defined, stable sort will leave the elements
                    // in the order they appear in the original array
                    return 0; 
                }
            },
                sortByVisibility = function(w1, w2) {
                    if (w1.element.is(":visible")) {
                        if (w2.element.is(":visible")) {
                            // Both visible
                            return 0;
                        } else {
                            // Only w1 visible
                            return -1;
                        }
                    } else if (w2.element.is(":visible")) {
                        // Only w2 is visible
                        return 1;
                    } else {
                        // Both not visible
                        return 0;
                    }
                };
            
            
            // Sorts widgets by their parseOrder, the widget with the lower parseOrder will be
            // parsed first. If the parseOrder is unspecified, then just parse in the order in
            // which they appeared in the array (i.e. stable sort).
            widgetsToParse = arrayUtils.stableSort(widgetsToParse, function(w1, w2) {
                var result = sortByParseOrder(w1, w2);
                if (result === 0) {
                    result = sortByVisibility(w1, w2);
                }
                return result;
            });
            $.each(widgetsToParse, $.proxy(function(i, widgetToParse) {
                this._parse_widget(widgetToParse.element, widgetToParse.widgetName, widgetToParse.widgetOptions);
            }, this));
        },
        
        /** 
        * @param context the DOM Node to parse under, can be undefined in which case the entire page is
         *                parsed
         */
        parseRefreshArea: function(context) {
            $("[wcType='RefreshArea']", context).each(function (i, e) {
                var declareFunc = $(e).attr("declareFunction");
                
                // find out namepace, function name and params to the function call
                var nameSpace, functionName, argArray = null;
                
                if (declareFunc) {
                    var indexDot = declareFunc.indexOf(".");
                    if (indexDot > 0) {
                        nameSpace = declareFunc.substr(0, indexDot);
                    }
                    var indexFunc = declareFunc.indexOf("(");
                    if (indexFunc > 0) {
                        functionName = declareFunc.substr(indexDot+1, indexFunc-indexDot-1);
                        var argString = declareFunc.slice(indexFunc+1, declareFunc.length-1);
                        // trim single quote, double quote and spaces
                        argString = argString.replace(/"/g, "").replace(/'/g, "").replace(/ /g, "");
                        argArray = argString.split(",");
                    } else {
                        functionName = declareFunc.substr(indexDot+1);
                    }
                }
               
                if (functionName) {
                    if (nameSpace) {
                        if (Utils.isUndefined(window[nameSpace])) {
                            console.error("Namespace " + nameSpace + " is not defined");
                        } else if (Utils.isUndefined(window[nameSpace][functionName])) {
                            console.error("Function " + functionName + " is not defined under namespace " + nameSpace);
                        } else {
                            window[nameSpace][functionName](argArray);
                        }
                        
                    } else {
                        if (Utils.isUndefined(window[functionName])) {
                            console.error(functionName + " is not defined!");
                        } else if (!$.isFunction(window[functionName])) {
                            console.error(window[functionName] + " is not a function!");
                        } else {
                            window[functionName](argArray);                            
                        }                        
                    }
                }
            });
        }
    };

    $(document).ready(function () {
        WCWidgetParser.parse();
        WCWidgetParser.parseRefreshArea();
    });
}(jQuery));//-----------------------------------------------------------------
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

/*global jQuery, $, window, setTimeout, clearTimeout, Utils */

/*
 * Carousel (extends $.Widget)
 * Wraps around a third party plugin - Owl Carousel. Owl Carousel is just a jQuery plugin
 * so it's not written as a jQuery UI Widget, otherwise we would extend the Owl Carousel Widget.
 *
 */
(function () {

    /*
     * New options (in addition to ones inherited from $.Widget):
     *
     * OPTIONAL:
     * prevButton: {string}
     *             jQuery selector for the previous button, can have falsy
     *             value if there is no previous button.
     * nextButton: {string}
     *             jQuery selector for the next button, can have falsy value
     *             if there is no previous button.
     * paginationButtons: {string}
     *             jQuery selector for the previous button, can have falsy
     *             value if there are no pagination buttons.
     * overflowVisible: {boolean}
     *             true if content that overflows the container should be shown,
     *             false otherwise.
     * REQUIRED:
     * (None)
     */
    $.widget("wc.Carousel", $.Widget, {
        options: {
            prevButton: null,
            nextButton: null,
            paginationButtons: null,
            contentContainer: "div.content",
            overflowVisible: false,
            owlCarouselOptions: {
                autoHeight: false,
                autoWidth: true,
                pagination: false, // We're generating our own pagination control
                slideSpeed: 2000,
                //touchDrag: false, // Need to disable touch drag if we want this to work
                // with gridster
                //mouseDrag: false,
                afterMove: function (elem) {
                    if (this.options.paginationButtons) {
                        this.paginationButtons.removeClass("selected")
                        // Highlight the selected element after pagination move
                        .eq(this.owlCarousel.currentItem).attr("class", "selected");
                    }
                },
                afterUpdate: function() {
                    // Only hide/show next/prev buttons after update has finished
                    this._togglePrevNextButtons();
                }
            }
        },

        /**
        * Attach "this" to a function passed to the owlCarousel option
        */
        _proxyFunction: function(optionName) {
            if ($.isFunction(this.options.owlCarouselOptions[optionName])) {
                this.options.owlCarouselOptions[optionName] = $.proxy(this.options.owlCarouselOptions[optionName], this);
            }
        },

        _create: function () {
            this._super(this);

            // Stores a handle to the underlying Owl Carousel
            this.content = $(this.options.contentContainer, this.element);
            this._proxyFunction("afterMove");
            this._proxyFunction("afterUpdate");

            if (this.options.columnCountByWidth) {
                var columnCountByWidth = this.options.columnCountByWidth;
                if (Utils.isObject(columnCountByWidth)) {
                    var windowWidth = $(window).width(),
                        // Grab all the screen sizes and sort them
                        screenSizes = Object.keys(columnCountByWidth)
                                            .map(function(str) {
                                                return parseInt(str, 10);
                                            });
                    screenSizes.sort(function(a, b) { return a - b });
                    screenSizes = screenSizes.map(function(size) {
                        return [size, columnCountByWidth[size.toString()]];
                    });
                    this.options.owlCarouselOptions.itemsCustom = screenSizes;
                } else {
                    console.error("columnCountByWidth is not an object: " + this.options.columnCountByWidth);
                }
            }

            this.owlCarousel = this.content.owlCarousel(this.options.owlCarouselOptions).data('owlCarousel');
		    //RTC DEFECT#153115 the carousel disableTextSelect event handling result in invocation of event.stopPropagation()
			if ((this.owlCarousel.options.mouseDrag !== false || this.owlCarourel.options.touchDrag !== false)
				&& this.owlCarousel.disabledEvents && typeof this.owlCarousel.disabledEvents === "function")
			{
				this.owlCarousel.$elem.off("mousedown.disableTextSelect");
				this.owlCarousel.$elem.on("mousedown.disableTextSelect", function (e) {
					if (!$(e.target).is('input, textarea, select, option')){
						e.preventDefault();
					};
				});
			}

            if (this.options.overflowVisible) {
                $(".owl-wrapper-outer", this.element).addClass("overflow-visible");
            }

            $(window).resize($.proxy(function() {
                this.owlCarousel.reload();
                this._togglePrevNextButtons();
            }, this));



//            $(window).resize($.proxy(function () {
//                // Reposition the dialog after window resize, otherwise
//                // the dialog will stay in the same position
//                this.reposition();
//            }, this));

            this._add_event_handlers();
            this._togglePrevNextButtons();
        },

        /**
        * Show/hide custom pagination buttons depending on the number of items
        * being shown
        */
        _togglePrevNextButtons: function() {
            // Require pagination if the total number of items is greater than
            // the number of items being shown
            var requirePagination = (this.owlCarousel.itemsAmount > this.owlCarousel.options.items);

            if (requirePagination) {
                if (this.options.nextButton) {
                    this.$nextButton.show();
                }
                if (this.options.prevButton) {
                    this.$prevButton.show();
                }
            } else {
                if (this.options.nextButton) {
                    this.$nextButton.hide();
                }
                if (this.options.prevButton) {
                    this.$prevButton.hide();
                }
            }
        },

        _add_event_handlers: function () {
            var carousel = this.owlCarousel;

            this.element.on("resized.owl.carousel", function() {
                console.log("resized");
            });
            // Pagination Controls
            // Previous button
            if (this.options.prevButton) {
                this.$prevButton = $(this.options.prevButton, this.element);
                this.$prevButton.click(function (e) {
                    carousel.prev();
                    e.preventDefault();
                });
            }

            // Next button
            if (this.options.nextButton) {
                this.$nextButton = $(this.options.nextButton, this.element);
                this.$nextButton.click(function (e) {
                    carousel.next();
                    e.preventDefault();
                });
            }

            // Pagination buttons (either dots or numbers)
            // Highlight the first element on startup
            if (this.options.paginationButtons) {
                this.paginationButtons = $(this.options.paginationButtons, this.element);
                this.paginationButtons.first().attr("class", "selected");
                this.paginationButtons.each(function(i, button) {
                    $(button).click(function(e) {
                        carousel.goTo(i);
                        e.preventDefault();
                    });
                });
            }
        },

        _destroy: function () {
            this.owlCarousel.destroy();

            // remove the event handlers
            //this.element.off("mouseenter.wcToolTip");
            //this.element.off("mouseleave.wcToolTip");
        }

    });

}());//-----------------------------------------------------------------
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

/*global jQuery, Utils, window, document */

/* 
 * WCGrid (extends $.ui.dialog) 
 *
 */
(function ($) {

    /*
     * New options (in addition to ones inherited from $.Widget):
     * columnCount: the number of columns (can be empty if rowCount is specified)
     * rowCount: the number of rows (can be empty if columnCount is specified)
     * elementSelector: the elements in the grid
     * useColumnWrapper: true if column wrappers should be used, false otherwise
     * columnWrapperClass: the CSS class to add to the column wrapper divs
     */
    $.widget("wc.Grid", $.Widget, {
        
        options: {            
            columnCount: 1,
            rowCount: null,
            elementSelector: "div.grid-element",
            useColumnWrapper: false,
            columnWrapperClass: "grid-column-wrapper"
        },
        
        /**
        * Handlers to be called when options are changed. Key corresponds to the option name, 
        * value corresponds to the handler.
        */
        optionChangedHandlers: {
            columnCount: function() {
                this._columnCountUpdated();
            },
            columnCountByWidth: function() {
                this.resize();                
            },
            elementSelector: function() {
                this.$elements = undefined;
            }
        },
        
        /**
        * The CSS class to add to the column container depending on the number of
        * columns.
        * Example: a grid with 3 columns will receive have the class "ui-grid-b" added.
        */
        columnContainerClass: {
            "1": "ui-grid-solo",
            "2": "ui-grid-a",
            "3": "ui-grid-b",
            "4": "ui-grid-c",
            "5": "ui-grid-d",
            "6": "ui-grid-e",
            "7": "ui-grid-f",
            "8": "ui-grid-g",
            "9": "ui-grid-h"
        },
        
        /** The current column container class */
        currentColumnContainerClass: null,
        
        /**
        * The CSS class to add to a column depending on it's column index. 
        * Example: the 4th column will have the class "ui-class-d" added.
        */
        columnClass: {
            "1": "ui-block-a",
            "2": "ui-block-b",
            "3": "ui-block-c",
            "4": "ui-block-d",
            "5": "ui-block-e",
            "6": "ui-block-f",
            "7": "ui-block-g",
            "8": "ui-block-h",
            "9": "ui-block-i"
        },
        
        _setOption: function (key, value) {
            this._super(key, value);
            
            if (this.optionChangedHandlers[key]) {
                this.optionChangedHandlers[key].call(this);
            }
        },

        _getColumnContainerClass: function(columnCount) {
            var val = this.columnContainerClass[String(columnCount)];
            if (val) {
                return val;
            }
            throw "Unsupported, too many columns: " + columnCount;
        },
        
        _columnCountUpdated: function() {
            this.$elements = this.$elements || $(this.options.elementSelector, this.element)
            var $elements = this.$elements,
                $parent = $elements.parent(),
                columnCount = this.options.columnCount,
                rowCount = this.options.rowCount;
            
            if (columnCount) {
                if (columnCount === 0) {
                    throw "Column count must be greater than 0!"
                    
                } else if (rowCount) {
                    // Make sure the number of elements in this grid can fit into a grid 
                    // defined by columnCount and rowCount
                     if (rowCount === 0) {
                        throw "rowCount must be greater than 0!";
                     } else if ($elements.length > columnCount * rowCount) {
                        throw "The number of elements (" + $elements.length + ") cannot fit into a " + columnCount + " by " + rowCount + " grid";
                     } 
                } else {
                    // Only column count defined, calculate row count
                    rowCount = Math.ceil($elements.length / columnCount);
                }
            } else if (rowCount) {
                if (rowCount === 0) {
                    throw "rowCount must be greater than 0!";
                    
                } else {
                    // Only row count defined, calculate column count
                    columnCount = Math.ceil($elements.length / rowCount);
                }
            } else {
                // Should not get here since default value provided for at least
                // one of columnCount or rowCount, but might reach here if user
                // accidentially sets both columnCount and rowCount to a falsy value
                throw "Row count and column count not defined!";
            }

            if (this.options.useColumnWrapper && $parent.hasClass(this.options.columnWrapperClass)) {
                // Unwrap previous column wrappers if any
                $elements.unwrap();
                $parent = $elements.parent();                
            }
            if (this.currentColumnContainerClass) {
                $parent.removeClass(this.currentColumnContainerClass);
            }
            this.currentColumnContainerClass = this._getColumnContainerClass(columnCount);
            $parent.addClass(this.currentColumnContainerClass);
        
            var rows = arrayUtils.arrTo2D($.makeArray($elements), columnCount),
                c;
            for (c = 0; c < columnCount; c++) {
                var $cols = $(rows.filter(function(a_row) {
                                return a_row.length > c;
                            }).map(function(a_row) {
                                return a_row[c];
                            }));
                if (this.options.useColumnWrapper) {
                    $cols = $cols.detach();              
                    $wrapper = $("<div class=\"" + this.options.columnWrapperClass + " " + this.columnClass[c + 1] + "\"></div>");
                    $parent.append($wrapper);
                    $wrapper.append($cols);
                } else {
                    $cols.removeClass(this.allColumnClass)
                         .addClass(this.columnClass[c + 1]);
                }                
            }
        },
        
        _validateElements: function() {
            if (!Utils.areSiblings($(this.options.elementSelector, this.element), $([]))) {
                throw "Grid elements must all be under the same parent";
            }
        },
        
        _create: function () {
            this._super(this);
            
            /**
             * Grab all the CSS class as a space separated string. Passed to $.removeClass to help remove all
             * column class from an element. 
             */
            this.allColumnClass = $.map(this.columnClass, function(val, key) {return val;}).join(" ");

            this._validateElements();
            this.option("columnCount", this._calculateColumnBasedOnClientWidth());
                                    
            $(window).resize($.proxy(function () {
                this.resize();
            }, this));
        },

        /**
         * Calculates the number of columns based on the columnCountByWidth option and client width
         * (if no such option is provided, returns 1). E.g. if client width is: 1000 px and columnCountByWidth
         * is: {"300": 2, "500": 3: "800": 4} then this will return 4 since the screen width is
         * greater than 800.  
         */
        _calculateColumnBasedOnClientWidth: function() {
            var columnCount = 1,
                clientWidth = this.element.get(0).clientWidth;
            
            if (this.options.columnCountByWidth) {
                Utils.iterate_obj_in_order(this.options.columnCountByWidth, function(a, b) {
                    return parseInt(b) - parseInt(a);
                },
                function(width, colWidth) {
                    if (clientWidth >= parseInt(width)) {
						columnCount = colWidth;
                        return true; // breaks out of the loop
					}
                });
            }
            return columnCount;
        },
        
        /**
         * Recalculates the column width on window resize and rearrange the elements 
         * accordingly.
         */
        resize: function () {
            var columnCount = this._calculateColumnBasedOnClientWidth();
            if (columnCount !== this.options.columnCount) {
                this.option("columnCount", columnCount);
            }
        }

    });

}(jQuery));//-----------------------------------------------------------------
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

/*global jQuery, Utils, window, document */

/*
 * Select (extends $.ui.selectmenu)
 *
 * Options:
 * useValueAsLink: true if the value of the select menu items should be treated as a link (defaults to false). The onChange element will be ignored.
 */
(function ($) {
    $.widget("wc.Select", $.ui.selectmenu, {
        options: {
            wcMenuClass: "",
            useValueAsLink: false
        },

        _create: function() {
            this._super(this);

            if (this.options.useValueAsLink) {
                if (!Utils.isUndefined(this.element.attr("onChange"))) {
                    console.warn("onChange defined for select menu, but it will be ignored since useValueAsLink is set to true");
                }
                this.options.change = function() {
                    var url = $(this).val();
                    if(Utils.existsAndNotEmpty(url)) {
                        window.location = url;
                    } else {
                        console.error("the url is not defined");
                    }
                }
            } else if(this.element.attr("onChange") !== undefined) {
                //pick up the onChange parameters
    			var onChange = this.element.attr("onChange").replace(/javascript:/i, '')
	    		this.options.change = function(event, data) {
	    			eval(onChange);
	    		}
    		}
    	},

		_refreshMenu: function() {
			// Get index of the selected element (if any)
			var selectedOption = $(this.element).find("[selected='selected']");
			if (selectedOption.length && this.element[0].selectedIndex < 0) {
				$(this.element[0]).prop('selectedIndex', selectedOption.index());
			}
			this._super(this);
		},

    	open: function( event ) {
    		this._super(this);

    		// If this is not the first time the menu is being opened, reset focused and selected item
    		if ( this.menuItems ) {
    			this._removeClass( this.menu.find( ".ui-state-select" ), null, "ui-state-select" );
    			this._addClass( this._getSelectedItem().children(), null, "ui-state-select" );
    			this.menuInstance.focus( null, this._getSelectedItem() );
    		}
    	},

    	close: function( event ) {
    		this._super(this);

    		//re-identify the selected items
    		this._removeClass( this.menu.find( ".ui-state-select" ), null, "ui-state-select" );
    		this._addClass( this._getSelectedItem().children(), null, "ui-state-select" );
    	},

    	_drawButton: function() {
    		this._super(this);

    		//pass classes from select element to new select button
    		this.button.addClass(this.element.attr("class"));
    		this.button.addClass(this.element.attr("baseclass"));
    		this.button.attr("style", "");
    	},

    	_drawMenu: function() {
    		var that = this;

    		this._super(this);
    		this.menu.menu({
    			focus: function( event, ui ) {
    				var item = ui.item.data( "ui-selectmenu-item" );
    				if(item) {
    					that.menuItems.eq( item.index ).focus();
    				}
    			}
    		}).css("font-size", this.buttonItem.css("font-size"));

    		//the class to add to DropDown popup menu for css styling
			var wcMenuClass = this.options.wcMenuClass;
			if (wcMenuClass !== undefined && wcMenuClass !== null && wcMenuClass !== ''){
				this.menu.addClass(wcMenuClass);
			}
    	},

    	_position: function() {
    		this._super(this);
    		this.reposition(this.menuWrap, this.button);
    	},

    	//reposition the drop down menu if there's not enough space
    	reposition: function (menuWrap, button) {
    		//synchronize the z index of drop down menu and the button
    		this.menuWrap.css("z-index", 1000);

    		//reset menu height to auto
    		this.menu.css("height", "auto");
    		var menuHeight = menuWrap.height();
    		var disToTop = menuWrap.position().top - $(window).scrollTop();
    		var disToBottom = $(window).height() - disToTop;
    		if(disToTop > $(window).height()/2 && menuHeight > disToBottom) {
    			if(disToTop > menuHeight) {
    				//If there's enough space on top, align the menu to select button
    				this.menuWrap.css("top", menuWrap.position().top - menuHeight - button.outerHeight());
    			} else {
    				//Align the menu to window top
    				this.menuWrap.css("top", menuWrap.position().top - disToTop);
    				//adjust menu height accordingly
    				this.menu.css("height", disToTop - button.outerHeight());
    			}
    		} else if(menuHeight > disToBottom) {
    			//adjust menu height accordingly
    			this.menu.css("height", disToBottom);
    		}
        },

        _renderItem: function( ul, item ) {
        	this._super(ul, item);

        	//pick up the value and style attributes from options
        	ul.children().last().attr("value", item.value);
        	ul.children().children().last().attr("style", item.element[0].style.cssText);

    		return ul.children().last();
    	},

    	refresh_noResizeButton: function() {
    		this._refreshMenu();
			if($(this.element[0]).prop('selectedIndex') > -1) {
				this._setText( this.buttonItem, this._getSelectedItem().text() );
			}
    	}

    });

}(jQuery));//-----------------------------------------------------------------
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

/*global jQuery, $, window, setTimeout, clearTimeout, Utils */

/* 
 * ValidationTextbox
 * 
 * IMPORTANT: REQUIRES "custom.wcToolTip" to work
 *
 */
(function () {

    /*
     * New options (in addition to ones inherited from $.Widget):
     * 
     * OPTIONAL:
     * regExp: {string} a JavaScript regular expression String for the valid input
     * canBeEmpty: {boolean} {default: true} true if the textbox is allowed to be empty, false otherwise
     * trimBeforeValidation: {boolean} {default: true} true if the textbox value should be trimmed before
     *                       validation, false otherwise.
     * invalidMessage: {string} the message to display as tooltip if the input is invalid
     * submitButton: {string} a jQuery selector of the button that will submit the form that contains 
     *               this ValidationTextbox. Will disable the button if the contents of this ValidationTextbox
     *               is invalid. 
     * submitButtonDisabledClass: {string} {default: disable} the CSS class to add to the submit button
     *                           if it is disabled
     * errorClass: {string} {default: "error"} the CSS class to add to this ValidationTextbox if the 
     *             input is invalid
     * customValidateFunction: {function} Customized validate function, return error message
     * onValidInput: {function(string)} a function that gets called each time the user enters a valid input (if 
     *                          the user enters invalid input, this function is not called). The text in the textbox
     *                          is passed to the function.
     * REQUIRED: 
     * (None)
     */
    $.widget("wc.ValidationTextbox", $.Widget, {
        options: {
            canBeEmpty: true,
            trimBeforeValidation: true,
            errorClass: "error",
            submitButtonDisabledClass: "disabled",
            invalidMessage: null
        },

        _create: function () {
            this._super(this);

            if (this.options.regExp) {
                this.regExp = new RegExp(this.options.regExp);
            }
            
            this.element.addClass("wcValidationTextbox");
            
            if (this.options.submitButton) {
                this.submitButton = $(this.options.submitButton);
            }
            this.element.bind("input propertychange", $.proxy(function(evt) {
                // Validate the value in text box and create error message tooltip when necessary
                if (this.validationAndErrorHandler() && this.options.onValidInput) {
                    this.options.onValidInput($(this.element).prop("value"));
                }
            }, this));
        },
        
        /**
        * Toggle the submit button associated with this Validation Textbox
        *
        * @param enable true if the submit button should be enabled, false otherwise
        */
        toggleSubmitButton: function(enable) {
            if (this.options.submitButton && this.submitButton.length) {
                if (enable) {
                    this.submitButton.removeClass(this.options.submitButtonDisabledClass);
                } else {
                    this.submitButton.addClass(this.options.submitButtonDisabledClass);
                }
                if (this.submitButton.is("a")) {
                    Utils.toggleHyperlink(this.submitButton, enable);
                    
                } else if (this.submitButton.is("input")) {
                    this.submitButton.prop('disabled', !enable);
                    
                } else {
                    console.err("don't know how to disable: " + this.submitButton);
                }
                
            }
        },
        
        /**
        * Returns true if the given value matches format defined in regExp, false otherwise.
        */
        validateFormat: function(value) {
            if (Utils.isBoolean(this.options.canBeEmpty) && value === "") {
                return this.options.canBeEmpty;
            } else if (this.options.regExp && !this.regExp.test(value)){
                return false;
            }
            return true;
        },

        /**
        * Create error message tooltip and return false when the value in text box fails in format validation and 
        * customized validation check (if customValidateFunction is specified).
        * Remove tooltip and return true when the value is valid.
        */
        validationAndErrorHandler: function() {
            var $textbox = $(this.element),
                value = this.element.val();

            if (this.options.trimBeforeValidation) {
                value = $.trim(value);
            }

            var errorMessage = null;
            if (!this.validateFormat(value)) {
                errorMessage = this.options.invalidMessage;
            }
            if (errorMessage == null && this.options.customValidateFunction != null && this.options.customValidateFunction != undefined) {
                errorMessage = this.options.customValidateFunction();
            }

            if (errorMessage == null) {
                // Remove tooltip and return true when no error
                if ($textbox.hasClass(this.options.errorClass)) {
                    $textbox.removeClass(this.options.errorClass);
                    if (this.tooltip) {
                        this.tooltip.destroy();
                        this.tooltip = null;
                    }
                    this.toggleSubmitButton(true);
                }

                return true;
            } else if (this.tooltip && this.element.data("tooltip-content") && this.element.data("tooltip-content") != errorMessage) {
                // Change error message if necessary
                this.element.data("tooltip-content", errorMessage);
                this.tooltip.tooltip.find(".content").text(errorMessage);
                this.tooltip.show_popup();
            } else if (this.tooltip) {
                // Show error message tooltip if there's already one
                this.tooltip.show_popup();
            } else {
                // Create tooltip when error message is not null
                if (!$textbox.hasClass(this.options.errorClass)) {
                    $textbox.addClass(this.options.errorClass);
                    this.element.data("tooltip-content", errorMessage);
                    this.tooltip = this.element.wcToolTip().data("custom-wcToolTip");
                    this.tooltip.show_popup();
                    this.toggleSubmitButton(false);
                }
            }

            // Return false if there's error
            return false;
        }
    });

}());//-----------------------------------------------------------------
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

/*global jQuery, $, window, setTimeout, clearTimeout, Utils */

/*
 * WCDialog (extends $.ui.dialog)
 *
 */
(function () {

    /*
     * New options (in addition to ones inherited from $.ui.dialog):
     *
     * OPTIONAL:
     * show_title: {boolean}
     *             true if the title should be shown, false otherwise
     * close_button_selector: {string} {default: "a.closeButton"}
     *                        jQuery selector for the close button,
     *                        can have falsy value if there is no
     *                        close button.
     * primary_button_selector: {string}
     *                     jQuery selector for the ok button, can have falsy
     *                     value if there is no ok button.
     * close_on_primary_click: {boolean} {default: true}
     *                     true if the dialog should be closed when the primary 
     *                     button is clicked, false otherwise.
     * secondary_button_selector: {string}
     *                     jQuery selector for the cancel button,
     *                     can have falsy value if there is no
     *                     cancel button.
     * related_source: {string}
     *                 jQuery selector of an element to position the dropdown relative to
     * title: {string}
     *        title to display
     * in_iframe: {boolean}
     *            truthy value if this dialog is in an iframe, false otherwise
     *
     * REQUIRED:
     * (None)
     */
    $.widget("wc.WCDialog", $.ui.dialog, {
        options: {
            show_title: false,

            autoOpen: false,

            /*
             * Closes the dialog after the given timeout seconds
             */
            timeout: null,
            /*
             * Auto close the dialog when the mouse leaves the
             * dialog or the relatedSource (if it is specified)
             */
            autoClose: false,

            close_button_selector: "a.closeButton",

            /**
            * Close the dialog when the primary button is clicked
            */
            close_on_primary_click: true,
            
            /**
            * The selector of an element to position the dropdown relative to
            */
            relatedSource: null,

            modal: true,

            /*
            * Required otherwise a default width of 300px will be assigned
            */
            width: "auto"
            
            
        },

        _create: function () {
            this._super(this);

            if (!this.options.show_title) {
                this.element.siblings("div.ui-dialog-titlebar").hide();
            }

            // Add the data-widget-type attribute in case the element doesn't
            // already have it. Useful for finding all WCDialog widgets
            this.element.attr("data-widget-type", "wc.WCDialog");

            $(window).resize($.proxy(function () {
                // Reposition the dialog after window resize, otherwise
                // the dialog will stay in the same position
                this.reposition();
            }, this));

            this._add_event_handlers();
        },
        
        _add_event_handlers: function () {
            // Add click handler for all close buttons within the dialog
            if (this.options.close_button_selector) {
                this.close_button = $(this.options.close_button_selector, this.element)
                    .on("click.WCDialog", $.proxy(function () {
                        this.close();
                    }, this));
            }

            // Add click handler for all OK buttons within the dialog
            if (this.options.primary_button_selector) {
                this.primary_button = $(this.options.primary_button_selector, this.element)
                    .on("click.WCDialog", $.proxy(function () {
                        if (this.options.close_on_primary_click) {
                            this.close();
                        }                        
                    }, this));
            }

            // Add click handler for all cancel buttons within the dialog
            if (this.options.secondary_button_selector) {
                this.secondary_button = $(this.options.secondary_button_selector, this.element)
                    .on("click.WCDialog", $.proxy(function () {
                        this.close();
                    }, this));
            }

//            var obj = this.options.position;
//            obj.collision = "none";
//            this.option("position", obj);

//            this.element.on("wcdialogopen", $.proxy(function(){
//                 $('html, body').scrollTo(this.options.position.of);
//            }, this));

            if (this.options.timeout || this.options.autoClose) {
                var self = this,
                    timeoutObj,
                    clearAndDeleteTimer = function () {
                        if (timeoutObj) {
                            clearTimeout(timeoutObj);
                            timeoutObj = null;
                        }
                    },
                    startTimer = function () {
                        if (timeoutObj) {
                            // Resets the previous one if it exists
                            clearAndDeleteTimer();
                        }
                        timeoutObj = setTimeout(function () {
                            self.close();
                        }, self.options.timeout);
                    };

                if (this.option.timeout) {
                    this.element.on("wcdialogopen", startTimer);

                    this.element.on("wcdialogclose", clearAndDeleteTimer);

                    // Delete the timer when the mouse overs over the
                    // dialog, only reset it once the mouse leaves
                    this.element.on("mouseover", function (event) {
                        // Resets the timer count down if the mouse
                        // moves over the dialog
                        clearAndDeleteTimer();

                        // Start the timer again once the mouse leaves
                        self.element.on("mouseleave", startTimer);
                    });
                }

                if (this.options.autoClose) {
                    self.element.add($(self.options.relatedSource)).on("mouseleave", function (event) {
                        if (!$.contains(self.element.get(0), event.toElement) && !$.contains($(self.options.relatedSource).get(0), event.toElement)) {
                            self.close();
                        }
                    });
                }

            }

        },

        reposition: function () {
            // Find the dialog wrapper
            var wrapper = this.element.parent("div.ui-widget-content:first[role='dialog']");
            // For some reason in Store Preview mode, jQuery returns 0 when getting the
            // height of the dialog wrapper even though this.element.height() returns the correct
            // value. So we set the dialog wrapper's height manually so jQuery can retrieve it 
            // correctly.
            if (wrapper.height() === 0) {
                wrapper.height(this.element.height());
            }
            if (wrapper.width() === 0) {
                wrapper.width(this.element.width());
            }
            
            var pos = this.option("position");
            this.option("position", pos);
        },

        /** 
        * Bring this WCDialog on top of all other WCDialogs.
        *
        * @param elements <optional> a jQuery Object, HTML Node collection, or jQuery selector 
        *        representing the elements on the page that this WCDialog should be on top of.
        *        If not defined ".ui-dialog" will be used instead which will bring this WCDialog
        *        on top of all other WCDialogs.
        */
        bringToFront: function(elements) {
            // Find max z-index
            var maxZIndex = 0;
            elements = $(elements || ".ui-dialog");
            elements.each(function(i, e) {
                var zIndex = $(e).css("z-index");
                if ($.isNumeric(zIndex)) {
                    zIndex = parseInt(zIndex);
                    if (zIndex > maxZIndex) {
                        maxZIndex = zIndex;
                    }
                }
            });
            // This could overflow eventually, but very unlikely
            this.element.parent(".ui-dialog").css("z-index", parseInt(maxZIndex) + 1);
        },
        
        /*
         * Updates the content of the WCDialog with the content from
         * the given selector (note the selector will be detached
         * from it's current DOM location).
         *
         * Parameters:
         * selector - selector for the new content
         */
        update_content: function (selector) {
            var content = $(selector).detach();
            this.element.html(content.html());
            // Reset the position element after updating content
            this.reposition();
            this._add_event_handlers();
        }

    });

}());//-----------------------------------------------------------------
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

(function ($) {
    $.widget("custom.wcToolTip", {

        options: {
            /* 
            * The key the user can press to open the tooltip if the element the tooltip
            * is anchored on is in focus. Disable this feature by setting the value to null.
            */
            accessibilityKey: null            
        },
        
        _create: function () {
            var self = this;
            this.element.on("mouseenter.wcToolTip", function() {
                self.show_popup();
            });
            this.element.on("mouseleave.wcToolTip", function() {
                self.hide_popup();
            });
            if (this.options.accessibilityKey !== null) {
                this.element.on("keydown.wcToolTip", function(event) {
                    if (event.keyCode === self.options.accessibilityKey) {
                        self.show_popup();    
                    }
                });                    
            }
        },
        show_popup: function () {
            if (this.tooltip) {
                this.tooltip.show();

            } else {
                var header = $(this.element).data("tooltip-header"),
                    content = $(this.element).data("tooltip-content");
                if (content && header) {
                    this.tooltip = $("<div class='WCTooltip'><div class='container'><div class='connector'></div><div class='header'>" + header + "</div><div class='content' >" + content + "</div></div></div>");

                } else if (header) {
                    this.tooltip = $("<div class='WCTooltip'><div class='container' style='padding:8px;' ><div class='connector'></div>" + header + "</div></div>");
                    
                } else if (content) {
                    this.tooltip = $("<div class='WCTooltip'><div class='container'><div class='connector'></div><div class='content' >" + content + "</div></div></div>");
                    
                } else {
                    // both undefined
                    this.tooltip = $("");
                }
                this.element.after(this.tooltip);
            }
            this.tooltip.position({
                my: "center top",
                at: "center bottom",
                of: this.element,
                collision: "none"
            });


        },
        hide_popup: function () {
            if (this.tooltip) {
                this.tooltip.hide();
            }
        },
        _destroy: function () {
            if (this.tooltip) {
                this.tooltip.hide();
                this.tooltip.remove(); // remove from DOM
            }            
            // remove the event handlers
            this.element.off("mouseenter.wcToolTip");  
            this.element.off("mouseleave.wcToolTip");  
        }
    });
}(jQuery));
