//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

//*---------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been  
//* thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its 
//* reliability, serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands 
//* and products in order to illustrate concepts as completely as 
//* possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by 
//* actual persons 
//* or business enterprises is entirely coincidental.
//*---------------------------------------------------------------------

// Define WL namespace.
var WL = WL ? WL : {};

/**
 * WLClient configuration variables.
 * Values are injected by the deployer that packs the gadget.
 */
WL.StaticAppProps = {
   "APP_DISPLAY_NAME": "Aurora WLHybrid",
   "APP_SERVICES_URL": "\/apps\/services\/",
   "APP_VERSION": "1.16",
   "ENVIRONMENT": "android",
   "LOGIN_DISPLAY_TYPE": "embedded",
   "WORKLIGHT_PLATFORM_VERSION": "6.0.0",
   "WORKLIGHT_ROOT_URL": "\/apps\/services\/api\/WCHybrid\/android\/"
};

/**
 * App level properties
 */
var WCHybridAppProperties = (function() {
    var pluginPath = "com.ibm.commerce.worklight.android.plugins."; //plugin package for android
    var androidPackagePath = "com.ibm.commerce.worklight.android"; //package path for android
    var contactsSelectorPackagePath = androidPackagePath + ".contacts";
    var displayMapPackagePath = androidPackagePath + ".maps";
    var barcodeScanPackagePath = androidPackagePath + ".barcode";
    var nativeSearchPackagePath = androidPackagePath + ".search";
    var deviceTypePrefix = "";
    return {
        getContactsSelectorClassName: function() {
            return contactsSelectorPackagePath + ".ContactsSelectorActivity";
        },
        getDisplayMapClassName: function() {
            return displayMapPackagePath + ".StoreMapActivity";
        },
        getBarcodeScanClassName: function() {
            return barcodeScanPackagePath + ".BarcodeScanActivity";
        },
        getNativeSearchClassName: function() {
            return nativeSearchPackagePath + ".SearchSuggestionsActivity";
        },
        getDeviceTypePrefix: function() {
            return deviceTypePrefix;
        }
    };
})();
