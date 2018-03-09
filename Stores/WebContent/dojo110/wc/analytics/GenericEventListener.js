// wrapped by build app
define("wc/analytics/GenericEventListener", ["dijit","dojo","dojox"], function(dijit,dojo,dojox){
/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["wc.analytics.GenericEventListener"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["wc.analytics.GenericEventListener"] = true;
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2011 All Rights Reserved.
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
* @class This class is the base object from which various analtyic vendor implementations should extend from.
*
**/
dojo.provide("wc.analytics.GenericEventListener");


dojo.declare("wc.analytics.GenericEventListener", null, {

	_loaded: false,
	
	_useHostedCMLib: false,
/**
 * initializer Event listener initialization method an Empty placeholder method
 */
	initializer: function () {
		
	},

	/**
	 *  This method sets up the listener to listen for the supported
	 *	    event types (dojo topics). Currently, they are "/wc/analytics/pageview",
	 *      "/wc/analytics/productview", "/wc/analytics/cartview", "/wc/analytics/addcart" and "/wc/analytics/element".
	 *		For each event type, a corresponding handler method is defined. This method
	 *		should be called by its creator before generating events.
	 */	
	load: function() {
		load(false);
	},
	
/**
 *  This method sets up the listener to listen for the supported
 *	    event types (dojo topics). Currently, they are "/wc/analytics/pageview",
 *      "/wc/analytics/productview", "/wc/analytics/cartview", "/wc/analytics/addcart" and "/wc/analytics/element".
 *		For each event type, a corresponding handler method is defined. This method
 *		should be called by its creator before generating events.
 */
	load: function(useHostedLib) {
		if(this._loaded == false) {
			dojo.subscribe("/wc/analytics/pageview", this, this.handlePageView);
			dojo.subscribe("/wc/analytics/productview", this, this.handleProductView);
			dojo.subscribe("/wc/analytics/cartview", this, this.handleCartView);
			dojo.subscribe("/wc/analytics/addcart", this, this.handleAddCart);
			dojo.subscribe("/wc/analytics/element", this, this.handleElement);
			dojo.subscribe("/wc/analytics/registration", this, this.handleRegistration);
			dojo.subscribe("/wc/analytics/conversionevent", this, this.handleConversionEvent);

			this._loaded = true;
			
			if (useHostedLib == true) {
				this._useHostedCMLib = true;
				
			}
		}
	},
/**
 *  Handler for PageView events.This is the method called when a PageView event is triggered via
 *		          the "/wc/analytics/pageview" topic. This is an empty placeholder that should be
 *		          extended by the implementation.
 *@param{Object} obj JSON object containing field names as expected by the specific implementation
 */
	handlePageView: function(obj) {
		
	},
/**
 *  Handler for ProductView events .This is the method called when a ProductView event is triggered via the "/wc/analytics/productview" topic. This is an empty placeholder that should be
 *		             extended by the implementation.
 *@param{Object} obj JSON object containing field names as expected by the specific implementation
 */
	handleProductView: function(obj) {
		
	},
/**
 *  Handler for CartView events.This is the method called when a CartView event is triggered via
 *		          the "/wc/analytics/cartview" topic. This is an empty placeholder that should be
 *		          extended by the implementation.
 *@param{Object} obj JSON object with a single 'cart' array of objects that contain field names for each item
 *		             as defined by the specific implementation.
 */
	handleCartView: function(obj) {
		
	},
/**
 *  Handler for AddCart events.This is the method called when an AddCart event is triggered via
 *		          the "/wc/analytics/addcart" topic. This is an empty placeholder that should be
 *		          extended by the implementation.
 *@param{Object} obj JSON object with a single 'cart' array of objects that contain field names for each item
 *		             as defined by the specific implementation.
 */
	handleAddCart: function(obj) {
		
	},
/**
 *  Handler for Element events . This is the method called when an Element event is triggered via the "/wc/analytics/element" topic. This is an empty placeholder that should be
 *               extended by the implementation.
 * @param{Object} obj JSON object containing field names as expected by the specific implementation              
 */
	handleElement: function(obj) {
		
	},
/**
 *  Handler for Registation events. This is the method called when an Registration event is triggered via
 *    the "/wc/analytics/registration" topic. This is an empty placeholder that should be
 *    extended by the implementation.
 * @param{Object} obj  JSON object containing field names as expected by the specific implementation
 */
	handleRegistration: function(obj) {
		
	},	
	
	/**
	 *  Handler for non e-Commerce conversion events. This is the method called when the topic "/wc/analytics/conversionevent" 
	 *  is published. This is an empty place holder that should be extended by the implementation.
	 * @param{Object} obj  JSON object containing field names as expected by the specific implementation
	 */	
	handleConversionEvent: function(obj) {
		
	}
});

}

});
