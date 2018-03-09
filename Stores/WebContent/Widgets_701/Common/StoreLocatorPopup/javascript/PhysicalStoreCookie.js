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
 * @fileOverview This file contains functions that are used to manage the cookies that are used by the Store Locator
 * feature.
 *
 * @version 1.0
 *
 */
 
/* Import dojo classes */
dojo.require("dojo.cookie");


/**
 * The functions defined in the class are used for managing the physical store IDs and the store locator user 
 * inputs.  Both information is stored in the cookie.
 *
 * @class This PhysicalStoreCookieJS class defines all the variables and functions to add / update / delete physical
 * store IDs and store locator user inputs.
 *
 */
PhysicalStoreCookieJS = {
	/* the store array is used to store physical store IDs to the cookie */
	storeArray: null,
	
	/* the maximum number of physical store IDs to be saved */
	arrayMaxSize: 5,
	
	/**
	 * This function retrieves the physical store IDs from the cookie.  These physical stores IDs are saved
	 * in the store array.  If no physical store IDs is found in the cookie, an empty store array is created.
	 *
	 * @returns {Array} The store array that contains all physical store IDs saved in the cookie.
	 *
	 */
	getStoreIdsFromCookie:function() {
		var cookieValue = dojo.cookie("WC_physicalStores");
		this.storeArray = new Array;
	
		if (cookieValue != null) {
			var subValue = "";
			var remainingString = cookieValue;
			var length = cookieValue.length;
			var end = remainingString.indexOf(",");
			
			/* more than 1 entry */
			if (end > 0) {
				while (end >=0) {
					subValue = remainingString.substring(0, end);
					this.addToStoreArray(subValue);
					remainingString = remainingString.substring(end+1,length);
					length = remainingString.length;
					end = remainingString.indexOf(",")
				}
				
				subValue = remainingString;
				this.addToStoreArray(subValue);
			}
			/* 0 to 1 entry */
			else {
				/* 1 entry */
				if (length > 0) {
					this.addToStoreArray(remainingString);
				}
			}
		}
		return this.storeArray;
	},
	
	/**
	 * This function checks whether adding one more physical store ID to the cookie will exceed the maximum
	 * number of stores allowed to be saved limit.  The function is default to return false; otherwise, true is
	 * returned. 
	 *
	 * @returns {boolean} The flag to indicate check result.
	 *
	 */
	isAddOneStoreIdExceedMax:function() {
		var exceedMax = false;
		
		if ((this.getNumStores() + 1) > this.arrayMaxSize) {
			exceedMax = true;
		}
		
		return exceedMax;
	},
	
	/**
	 * This function saves all the physical store IDs in the store array to the cookie.  It loops through the store 
	 * array and saves all physical store IDs into the cookie.  It also ensures the cookie do not expire after the 
	 * session closes.  
	 *
	 */
	setStoreIdsToCookie:function() {
		var newCookieValue = "";
		
		for (i=0; i<this.storeArray.length; i++) {
			newCookieValue = newCookieValue + this.storeArray[i];
			if (i < (this.storeArray.length-1)) {
				newCookieValue = newCookieValue + ",";
			}
		}
		
		if (newCookieValue.length == 0) {
			/* delete the cookie then */
			setCookie("WC_physicalStores", null, {path: "/", expires: -1, domain: cookieDomain});
		}
		else {
			/* add or update the cookie */
			setCookie("WC_physicalStores", newCookieValue, {path: "/", domain: cookieDomain});
		}
	},
	
	/**
	 * This function adds the store ID to the store array.  It ensures that the store array does contain the 
	 * information from the cookie and the store ID to be added does not exist in the store array.
	 *
	 * @param {String} record The physical store ID to be added. 
	 *
	 */
	addToStoreArray:function(record) {
		if (this.storeArray == null) {
			this.getStoreIdsFromCookie();
		}
		
		for (i=0; i<this.storeArray.length; i++) {
			if (this.storeArray[i] == record) {
				return;
			}
		}
		
		/* do not add the new record if the array has reached the max size */
		if (this.storeArray.length < this.arrayMaxSize) {
			this.storeArray.push(record);
		}
	},
	
	/**
	 * This function adds the store ID to the cookie by calling the following 2 functions:
	 *       addToStoreArray()
	 *       setStoreIdsToCookie()
	 *
	 * @param {String} record The physical store ID to be added. 
	 *
	 */
	addToCookie:function(record) {
		this.addToStoreArray(record);
		this.setStoreIdsToCookie();
	},
	
	/**
	 * This function removes the store ID from the store array.  It ensures that the store array does contain the
	 * information from the cookie and the store ID to be removed does exist in the store array.
	 *
	 * @param {String} record The physical store ID to be removed. 
	 *
	 */
	removeFromStoreArray:function(record) {
		if (this.storeArray == null) {
			this.getStoreIdsFromCookie();
		}
		
		var recordIndex = -1;
		
		for (i=0; i<this.storeArray.length; i++) {
			if (this.storeArray[i] == record) {
				recordIndex = i;
				i = this.storeArray.length;
			}
		}
				
		this.storeArray.splice(recordIndex, 1);
	},
	
	/**
	 * This function removes the store ID from the cookie by calling the following 2 functions:
	 *       removeFromStoreArray()
	 *       setStoreIdsToCookie()
	 *
	 * @param {String} record The physical store ID to be removed. 
	 *
	 */
	removeFromCookie:function(record) {
		this.removeFromStoreArray(record);
		this.setStoreIdsToCookie();
	},
	
	/**
	 * This function empties the store array.
	 *
	 */
	clearStoreArray:function() {
		this.storeArray = new Array;
	},
	
	/**
	 * This function updates the cookie with the empty store array.
	 *
	 */
	clearCookie:function() {
		this.clearStoreArray();
		this.setStoreIdsToCookie();
	},
	
	/**
	 * This function returns the number of physical stores saved in the cookie.  It ensures the store array contains 
	 * the information retrieved from the cookie before getting the number of stores.
	 *
	 * @returns {int} The number of physical stores saved.
	 *
	 */
	getNumStores:function() {
		if (this.storeArray == null) {	
			this.getStoreIdsFromCookie();
		}
		
		return this.storeArray.length;
	},
	
	/**
	 * This function retrieves the pick up store ID from the cookie.  If no pick up store ID is found in the cookie, 
	 * null is returned.
	 *
	 * @returns {String} The pick up store IDs.
	 *
	 */
	getPickUpStoreIdFromCookie:function() {
		var pickUpStoreId = dojo.cookie("WC_pickUpStore");
		return pickUpStoreId;
	},

	/**
	 * This function adds or updates the pick up store ID to the cookie.
	 *
	 * @param {String} value The new pick up store ID. 
	 *
	 * @returns {element} .
	 *
	 */
	setPickUpStoreIdToCookie:function(value) {
		var newPickUpStoreId = value;
		if (newPickUpStoreId != null && newPickUpStoreId != "undefined" && newPickUpStoreId != "") {
			var currentPickUpStoreId = this.getPickUpStoreIdFromCookie();
			if (newPickUpStoreId != currentPickUpStoreId) {
				setCookie("WC_pickUpStore", null, {path: "/", expires: -1, domain: cookieDomain});
				setCookie("WC_pickUpStore", newPickUpStoreId, {path: "/", domain: cookieDomain});
			}
		}
	},

	/**
	 * This function clears the pick up store ID from the cookie when the parameter matches the current pick up 
	 * store ID in the cookie.
	 *
	 * @param {String} value The pick up store ID for comparison. 
	 *
	 */
	clearPickUpStoreIdFromCookie:function(value) {
		var newPickUpStoreId = value;
		if (newPickUpStoreId != null && newPickUpStoreId != "undefined" && newPickUpStoreId != "") {
			var currentPickUpStoreId = this.getPickUpStoreIdFromCookie();
			if (newPickUpStoreId == currentPickUpStoreId) {
				setCookie("WC_pickUpStore", null, {path: "/", expires: -1, domain: cookieDomain});
			}
		}
	},
	
	/**
	 * This generic function retrieves the value from the cookie based on the cookie key.  It is used to store 
	 * "country: WC_stCntry", "province: WC_stProv", "city: WC_stCity" and "search performed flag: WC_stFind".  If no 
	 * value is found in the cookie for the cookie key, null is returned.
	 *
	 * @param {String} cookieKey The key of the cookie. 
	 *
	 * @returns {String} The value obtained from the cookie.
	 *
	 */
	getValueFromCookie:function(cookieKey) {
		var cookieValue = dojo.cookie(cookieKey);
		return cookieValue;
	},

	/**
	 * This function adds or updates the value to the cookie using the key provided.  It is used to store 
	 * "country: WC_stCntry", "province: WC_stProv", "city: WC_stCity" and "search performed flag: WC_stFind".
	 *
	 * @param {String} cookieKey The key of the cookie. 
	 * @param {String} cookieValue The new value of the cookie. 
	 *
	 */
	setValueToCookie:function(cookieKey, cookieValue) {
		var newValue = cookieValue;
		if (newValue != null && newValue != "undefined" && newValue != "") {
			var currentValue = this.getValueFromCookie(cookieKey);
			if (newValue != currentValue) {
				setCookie(cookieKey, null, {path: "/", expires: -1, domain: cookieDomain});
				setCookie(cookieKey, newValue, {path: "/", domain: cookieDomain});
			}
		}
	},

	/**
	 * This function clears the value referred by a key from the cookie.
	 *
	 * @param {String} cookieKey The key of the cookie. 
	 *
	 */
	clearValueFromCookie:function(cookieKey) {
		var currentValue = this.getValueFromCookie(cookieKey);
		if (currentValue != null && currentValue != "undefined") {
			setCookie(cookieKey, null, {path: "/", expires: -1, domain: cookieDomain});
		}
	}

}
