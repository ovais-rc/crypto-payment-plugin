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

function selectContactFromAddressBook() {
    if (wlInitOptions.enableLogger) {
        WL.Logger.debug("DeviceEnhancement.selectContactFromAddressBook ENTRY");
    }
    ContactsSelector.launch();
    if (wlInitOptions.enableLogger) {
        WL.Logger.debug("DeviceEnhancement.selectContactFromAddressBook EXIT");
    }
}

function findExistOptionIndex(selectObject, value) {
    for (var i = 0; i < selectObject.options.length; i++) {
        // trim right
        var trimmedOptionValue = selectObject.options[i].innerHTML.replace(/(\s*$)/g, "");
        if (trimmedOptionValue == value) {
            return i;
        }
    }
    return -1;
}
