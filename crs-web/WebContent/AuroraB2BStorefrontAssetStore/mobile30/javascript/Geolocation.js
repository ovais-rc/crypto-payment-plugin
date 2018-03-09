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
// Geolocation.js contains the JavaScript functions to call HTML5 Geolocation API
// to return the current device location coordinates
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

var GeolocationJS = {

    targetForm: null,

    setTargetForm: function(form) {
        this.targetForm = form;
    },

    /**
     * Get the current coordinates
     * @param position      geolocation position returned by the device
     */
    showPosition: function(position) {
        if (position !== undefined && position != null) {
            GeolocationJS.targetForm.geoCodeLatitude.value = position.coords.latitude;
            GeolocationJS.targetForm.geoCodeLongitude.value = position.coords.longitude;
            GeolocationJS.targetForm.submit();
        }
    },
    
    /**
     * Handle the error returned from geolocation call
     * @param error     the error returned by the device
     */
    locationError: function(error) {
        var currPage = window.location.href;
        switch (error.code) {
            case error.PERMISSION_DENIED:
                window.location.href = currPage + "&errorMsgKey=LBS_ERROR_PERMISSION_DENIED";
                break;
            case error.POSITION_UNAVAILABLE:
                window.location.href = currPage + "&errorMsgKey=LBS_ERROR_NO_USER_CURRENT_LOC";
                break;
            case error.TIMEOUT:
                window.location.href = currPage + "&errorMsgKey=LBS_ERROR_TIMEOUT";
                break;
            default:
                break;
        }
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