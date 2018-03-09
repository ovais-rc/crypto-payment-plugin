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
// BarcodeScan.js contains the javascript functions to call out to WL.NativePage.show
// to launch the barcode scanner to scan barcodes.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

var BarcodeScanJS = {
	
	/** search parameters **/
	searchBeginIndex:0,
	searchPageSize:0,
	searchResultCatEntryType:2,
	searchShowResultsPage:"true",
	searchSource:"Q",
	searchType:"SimpleSearch",
	searchViewMode:WCHybridAppProperties.getDeviceTypePrefix(),
	
	// barcode scanner library properties to be passed into WL.NativePage.show
	parameters: 
	{
		scanIntent: "com.google.zxing.client.android.SCAN",
		scanPackage: "com.google.zxing.client.android",
		scanResultFormatKey: "SCAN_RESULT_FORMAT",
		scanResultKey: "SCAN_RESULT",
		scanPackageURL: "http://zxing.appspot.com/scan"
	},
	
	/**
	* Actions to be taken after returning from the native map page
	* @param data       returned JSON array
	*/
	processBarcode: function(data) {
		var METHODNAME = "BarcodeScanJS.processBarcode ";
		if (wlInitOptions.enableLogger) {
			WL.Logger.debug(METHODNAME + "ENTRY");
		}
		if (data !== null && data !== undefined) {
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug("BarcodeScanJS.processBarcode", "data: " + data);
			}
			var format = data[BarcodeScanJS.parameters.scanResultFormatKey];
			var result = data[BarcodeScanJS.parameters.scanResultKey]
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "format: " + format);
				WL.Logger.debug(METHODNAME + "result: " + result);
			}
			if (format != null && format == "QR_CODE") {
				//if code does not start with http, assume it is a search term
				if (result.lastIndexOf("http", 0) === 0) {
					//validate URL and hostname
					var reg = new RegExp("(^|\s)((http:\/\/)?" + window.location.host + "(:\d+)?(\/\S*)?)","gi");
					if (reg.test(result)) {
						window.location.href = data[BarcodeScanJS.parameters.scanResultKey];
					} else {
						alert(Messages.ERR_EC_BARCODE_SCAN + " 1: " + result);
					}
				} else {
					//Open the search page to search the items.
					var searchURL = "SearchDisplay" 
						+ "?langId=" + window.sessionStorage.getItem('langId')
						+ "&storeId=" + window.sessionStorage.getItem('storeId')
						+ "&catalogId=" + window.sessionStorage.getItem('catalogId')
						+ "&beginIndex=" + BarcodeScanJS.searchBeginIndex
						+ "&resultCatEntryType=" + BarcodeScanJS.searchResultCatEntryType
						+ "&pageSize=" + BarcodeScanJS.searchPageSize
						+ "&pageView=" + window.sessionStorage.getItem('defaultPageView')
						+ "&showResultsPage=" + BarcodeScanJS.searchShowResultsPage
						+ "&searchSource=" + BarcodeScanJS.searchSource
						+ "&sType=" + BarcodeScanJS.searchType
						+ "&viewMode=" + BarcodeScanJS.searchViewMode
						+ "&searchTerm=";
					window.location.href = searchURL + result;
				}
			}
		} else {
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "No data returned from the barcode scanner.");
			}
		}
		if (wlInitOptions.enableLogger) {
			WL.Logger.debug(METHODNAME + "EXIT");
		}
	},

	/**
	 * Makes the call to the native map class and provides the callback function to process the returned data
	 * Example JSON object: 
	 *      {
	 *      scanIntent: "com.google.zxing.client.android.SCAN",
	 *      scanPackage: "com.google.zxing.client.android",
	 *      scanResultFormatKey: "SCAN_RESULT_FORMAT",
	 *      scanResultKey: "SCAN_RESULT",
	 *      scanPackageURL: "http://zxing.appspot.com/scan"
	 *      };
	 *
	 * @param parameters     parameters in JSON array format 
	 */
	launch: function() {
		try {
			WL.NativePage.show(WCHybridAppProperties.getBarcodeScanClassName(), BarcodeScanJS.processBarcode, BarcodeScanJS.parameters);
		} catch (err) {
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug("BarcodeScanJS.launch " + err.name + ": " + err.message);
			}
		}
	}
}
