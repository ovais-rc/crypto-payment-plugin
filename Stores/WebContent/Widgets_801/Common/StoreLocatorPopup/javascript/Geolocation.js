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

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Geolocation.js contains the JavaScript functions to call HTML5 Geolocation API
// to return the current device location coordinates
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

var GeolocationJS = {

    /**
     * Get the current coordinates
     * @param position      geolocation position returned by the device
     */
    showPosition: function(position) {
        if (position !== undefined && position != null) {
            storeLocatorJS.refreshResultsFromNearest(position.coords.latitude,position.coords.longitude);
        }
    },
    
    /**
     * Handle the error returned from geolocation call
     * @param error     the error returned by the device
     */
    locationError: function(error) {
        var errorMsgKey;
        switch (error.code) {
            case error.PERMISSION_DENIED:
                errorMsgKey = "LBS_ERROR_PERMISSION_DENIED";
                break;
            case error.POSITION_UNAVAILABLE:
                errorMsgKey = "LBS_ERROR_NO_USER_CURRENT_LOC";
                break;
            case error.TIMEOUT:
                errorMsgKey = "LBS_ERROR_TIMEOUT";
                break;
            default:
                break;
        }
        storeLocatorJS.refreshResultsWithLocationError(errorMsgKey);
    },
    
    /**
     * Call the HTML5 geolocation API with callback function
     */
    launch: function() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(GeolocationJS.showPosition,GeolocationJS.locationError,{timeout:10000,enableHighAccuracy:true}); 
        }
    }

};