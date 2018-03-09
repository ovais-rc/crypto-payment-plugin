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
// ContactsSelector.js contains the javascript functions to call out to WL.NativePage.show
// to launch the native device's address book app and populate the address form
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

var ContactsSelector = {

   /**
    * Populates the address form with the data returned from the WL.NativePage.show call
    * @param data       the contact data
    */
    processSelectedContact: function(data) {
        var METHODNAME = "ContactsSelector.processSelectedContact ";
        if (wlInitOptions.enableLogger) {
            WL.Logger.debug(METHODNAME + "ENTRY");
            WL.Logger.debug(data);
        }

        if (data !== null && data !== undefined) {
            var nickNameObject = document.getElementById("nickName")
            if (nickNameObject != undefined && nickNameObject != null) {
                nickNameObject.value = data.nickName;
            }
            document.getElementById("firstName").value = data.firstName;
            document.getElementById("lastName").value = data.lastName;
            document.getElementById("address1").value = data.street;
            document.getElementById("city").value = data.city;
            document.getElementById("state").value = data.state;
            document.getElementById("zipCode").value = data.postCode;
            document.getElementById("phone1").value = data.phone;
            document.getElementById("email1").value = data.email;
            var countrySelectObject = document.getElementById("country");
            var countryOptionIndex = findExistOptionIndex(countrySelectObject, data.country);
            if (countryOptionIndex !== -1) {
                countrySelectObject.options[countryOptionIndex].selected = true;
            }
        } else {
            if (wlInitOptions.enableLogger) {
                WL.Logger.debug(METHODNAME + "No data returned from Contacts");
            }
        }
        
        if (wlInitOptions.enableLogger) {
            WL.Logger.debug(METHODNAME + "EXIT");
        }
    },
    
    /**
     * Makes the call to the native ContactsSelector class and provides the 
     * callback function to process the returned data
     * @param className     the native classname to be called by Cordova
     */
    launch: function() {
        try {
            WL.NativePage.show(WCHybridAppProperties.getContactsSelectorClassName(), ContactsSelector.processSelectedContact);
        } catch (err) {
            if (wlInitOptions.enableLogger) {
                WL.Logger.debug("ContactsSelector.launch " + err.name + ": " + err.message);
            }
        }
    }
    
} 