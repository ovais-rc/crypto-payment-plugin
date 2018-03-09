//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file contains all the global variables and JavaScript functions needed by the compare product page and the compare zone. 
 */

if(typeof(CompareProductJS) == "undefined" || CompareProductJS == null || !CompareProductJS) {
	
	/**
	 * @class The functions defined in the class are used for comparing products. 
	 *
	 * This CompareProductJS class defines all the variables and functions for the page that uses the comparison functionality in the store.
	 * The compare accepts a maximum of 4 products to compare.
	 * The compare product display page compares various products' attributes side-by-side.
	 *
	 */
	CompareProductJS = {
		/**
		 * Object to store langId, storeId and catalogId of the store.
		 */
		params: [],
		
		/**
		* The compareReturnName is a string to store the current name of the category from where the compare link was clicked
		*/
		compareReturnName: "",
		
		/**
		* The returnUrl is a string to store the url of the category from where the compare link was clicked
		*/
		returnUrl: "",
		
		/**
		 * The prefix of the cookie key that is used to store item Ids. 
		 */
		cookieKeyPrefix: "CompareItems_",
		
		/**
		 * The delimiter used to separate item Ids in the cookie.
		 */
		cookieDelimiter: ";",
		
		/**
		 * The maximum number of items allowed in the compare zone. 
		 */
		maxNumberProductsAllowedToCompare: 4,
		
		/**
		 * Sets the common parameters used in all service calls like langId, storeId and catalogId.
		 * @param {String} langId The language Id.
		 * @param {String} storeId The store Id.
		 * @param {String} catalogId The catalog Id.
		 * @param {String} compareReturnName The return page name
		 * @param {String} returnUrl The url of the return page to go back
		 */
		setCommonParameters:function(langId,storeId,catalogId, compareReturnName, returnUrl){
			this.params.langId = langId;
			this.params.storeId = storeId;
			this.params.catalogId = catalogId;
			this.compareReturnName = compareReturnName;
			this.returnUrl = decodeURIComponent(returnUrl);
		},

		/**
		 * Removes an item from the products compare page.
		 * @param {String} key The Id of the item to remove.
		 */
		remove: function(key){
			var cookieKey = this.cookieKeyPrefix + this.params.storeId;
			var cookieValue = getCookie(cookieKey);
			if(cookieValue != null){
				if(cookieValue.trim() == ""){
					setCookie(cookieKey, null, {expires: -1});
				}else{
					var cookieArray = cookieValue.split(this.cookieDelimiter);
					var newCookieValue = "";
					for(index in cookieArray){
						if(cookieArray[index] != key){
							if(newCookieValue === ""){
								newCookieValue = cookieArray[index];
							}else{
								newCookieValue = newCookieValue + this.cookieDelimiter + cookieArray[index]
							}
						}
					}
					setCookie(cookieKey, newCookieValue, {path:'/', domain:cookieDomain});
				}
				
				// Now remove this catentry from URL and re-submit it...
				//replace catentryId=[0-9;]*&? with the current set of catentryIds present in cookie...
				var cookieKey = this.cookieKeyPrefix + this.params.storeId;
				var cookieValue = getCookie(cookieKey);
				var tempURL = "";
				var tokens = document.URL.split('catentryId=');
				if (tokens.length == 2) {
					tempURL = tokens[0] + 'catentryId=' + cookieValue;
					var tokens2 = tokens[1].split('&');
					for (var i=0; i<tokens2.length; i++) {
						if (i > 0) {
							tempURL = tempURL + "&" + tokens[i];
						}
					}
				}
				var tempURL = tempURL.replace(/&&/, "&"); //we might end up with &&, when newCatentryIdsToCompare is empty..Handle this scenario...
				location.href = tempURL;
			}
		},

		/**
		 * Re-directs the browser to the CompareProductsDisplay page to compare products side-by-side.
		 */
		compareProducts:function(){
			var url = "CompareProductsDisplayView?storeId=" + this.params.storeId + "&catalogId=" + this.params.catalogId + "&langId=" + this.params.langId + "&compareReturnName=" + this.compareReturnName;
			
			var cookieKey = this.cookieKeyPrefix + this.params.storeId;
			var cookieValue = getCookie(cookieKey);
			if(cookieValue != null && cookieValue.trim() != ""){
				url = url + "&catentryId=" + cookieValue;
			}
			url = url + "&returnUrl=" + encodeURIComponent(this.returnUrl);
			location.href = getAbsoluteURL() + url;
		},
		
		/**
		* add2ShopCart Adds product to the shopping cart
		* @param {String} catEntryId The catalog entry Id.
		* @param {String} quantity The quantity.
		* @param {String} productId The product Id.
		**/
		add2ShopCart: function(catEntryId, quantity, productId){
			var shoppingParams = {
                storeId: WCParamJS.storeId,
                catalogId: WCParamJS.catalogId,
                langId: WCParamJS.langId,
                orderId: "."
            };
			// Remove calculations for performance
			// shoppingParams.calculationUsage = "-1,-2,-5,-6,-7";
			shoppingParams.calculateOrder="0";
			
			//Add the catalog entry to the cart.
			updateParamObject(shoppingParams,"catEntryId",catEntryId,false,-1);
			updateParamObject(shoppingParams,"quantity",quantity,false,-1);
			
			var shopCartService = "AddOrderItem";
			
			var skuAttributes = this.getSkuAttributes(catEntryId);
			if (skuAttributes == null) {
				skuAttributes = this.getSkuAttributes(productId);
			}
			
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			
			shoppingActionsJS.saveAddedProductInfo(quantity, productId, catEntryId, skuAttributes);
			wcService.invoke(shopCartService, shoppingParams);
		},
		
		/**
		 * Returns the SKU attributes from the skuAttributesJSON div.
		 * @param {String} catEntryId The catalog entry Id.
		 * @returns {Object} The object containing all of the attributes for the SKU.
		 **/
		getSkuAttributes : function(catEntryId)
		{
			var jsonDiv = null;
			var node = $("#SKUAttributesJSON_" + catEntryId);

			if (node && node != null && node != 'undefined') {
				jsonDiv = eval('('+ node.innerHTML +')');
			}
			
			if (jsonDiv != null && jsonDiv != 'undefined') {
				return jsonDiv;
			}
			
			return null;
		}
	}
}