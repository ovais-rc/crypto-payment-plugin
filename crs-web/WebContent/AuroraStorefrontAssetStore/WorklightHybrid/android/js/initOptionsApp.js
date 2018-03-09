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
//*---------------------------------------------------------------------//*

//Worklight Client initialization parameter array
var wlInitOptions = {
    //Application should not attempt to connect to Worklight Server on application start up
    connectOnStartup : false,
    //Should application produce logs
    enableLogger : true,
    //Should direct updates prompt the user or occur silently
    updateSilently: false
};

var initOptionsApp = (function() {

    return {
        /**
         * Called when Cordova runtime has initialized
         */
        onDeviceReady: function() {
            var METHODNAME = "initOptionsApp.onDeviceReady ";
            if (wlInitOptions.enableLogger) {
                WL.Logger.debug(METHODNAME + "ENTRY");
            }          
            //bind the hardware back button event listener
            document.addEventListener("backbutton", WCHybridAppJS.onBackKeyDown, false);
            if (wlInitOptions.enableLogger) {
                WL.Logger.debug(METHODNAME + "EXIT");
            }
        }
    };
    
})();

/**
 * Bind the Worklight Client initialization call to the page load event
 */
if (window.addEventListener) {
	window.addEventListener('load', function() {
	    // Worklight JavaScript init depends on <body> tag having ID of content
		document.getElementsByTagName("body")[0].setAttribute("id","content");
		WL.Client.init(wlInitOptions);
	}, false);
	window.addEventListener('unload', function() { WCHybridAppJS.updateHistory(); }, false);
} else if (window.attachEvent) {
	window.attachEvent('onload',  function() {
	    // Worklight JavaScript init depends on <body> tag having ID of content
		document.getElementsByTagName("body")[0].setAttribute("id","content");
		WL.Client.init(wlInitOptions);
	});
}

/**
 * Bind events to the Cordova deviceready event
 */
if (document.addEventListener) {
    document.addEventListener("deviceready", initOptionsApp.onDeviceReady, false);
}
