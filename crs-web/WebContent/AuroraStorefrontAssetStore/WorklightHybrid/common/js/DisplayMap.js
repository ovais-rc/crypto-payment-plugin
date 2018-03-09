//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// DisplayMap.js contains the JavaScript functions to call out to WL.NativePage.show
// to launch the native map and insert a map marker at the target coordinates
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

var DisplayMapJS = {

	/**
	 * Build the native page parameter and pass to the launch function
	 * @param {String} centerLatitude The map center latitude
	 * @param {String} centerLongitude The map center longitude
	 * @param {String} geoNodeId The Geonode ID
	 * @param {String} storeName The physical store name
	 * @param {String} latitude The user's latitude
	 * @param {String} longitude The user's longitude
	 * @param {String} city The physical store city
	 * @param {String} address1 The physical store address
	 * @param {String} address2 The physical store extended address info2
	 * @param {String} address3 The physical store extended address info3
	 */
	invokeNativeMap: function(centerLatitude,centerLongitude,geoNodeId,storeName,latitude,longitude,city,state,address1,address2,address3) {
		if (wlInitOptions.enableLogger) {
			WL.Logger.debug("DisplayMapJS.invokeNativeMap ENTRY");
		}
		//WL.NativePage.show requires a flat JSON string parameter for iOS
		var localInfo = {
			mapCenterLatitude: centerLatitude,
			mapCenterLongitude: centerLongitude,
			storeGeoNodeId: geoNodeId,
			storeName: storeName,
			storeLatitude: latitude,
			storeLongitude: longitude,
			storeCity: city,
			storeState: state,
			storeAddress1: address1,
			storeAddress2: address2,
			storeAddress3: address3
		};
		DisplayMapJS.launch(localInfo);
		if (wlInitOptions.enableLogger) {
			WL.Logger.debug("DisplayMapJS.invokeNativeMap EXIT");
		}
	},

	/**
	 * Requires a callback function for return from the native map page
	 * @param data       JSON object
	 */
	returnFromMap: function(data) {
		if (wlInitOptions.enableLogger) {
			WL.Logger.debug("DisplayMapJS.returnFromMap Returned from native map call");
		}
	},

	/**
	 * Makes the call to the native map class and provides the callback function to process the returned data
	 * Example JSON object:
	 *      {
	 *          mapCenterLatitude: centerLatitude,
	 *          mapCenterLongitude: centerLongitude,
	 *          storeGeoNodeId: geoNodeId,
	 *          storeLatitude: latitude,
	 *          storeLongitude: longitude,
	 *          storeCity: city,
	 *          storeState: state,
	 *          storeAddress1: address1,
	 *          storeAddress2: address2,
	 *          storeAddress3: address3
	 *      };
	 *
	 * @param parameters     parameters in JSON array format
	 */
	launch: function(parameters) {
		try {
			WL.NativePage.show(WCHybridAppProperties.getDisplayMapClassName(), DisplayMapJS.returnFromMap, parameters);
		} catch (err) {
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug("DisplayMapJS.launch " + err.name + ": " + err.message);
			}
		}
	}

}
