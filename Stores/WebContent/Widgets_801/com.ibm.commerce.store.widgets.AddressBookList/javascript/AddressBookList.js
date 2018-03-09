//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2017 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

AddressBookListJS = {

    /** 
     * This variable stores the ID of the language that the store currently uses. Its default value is set to -1, which corresponds to United States English.
     * @private
     */
    langId: "-1",
    /** 
     * This variable stores the ID of the current store. Its default value is empty.
     * @private
     */
    storeId: "",
    /** 
     * This variable stores the ID of the catalog. Its default value is empty.
     * @private
     */
    catalogId: "",
    authToken: "",
    addAddressURL: "",
    addressBookURL: "",

    /**
     * Sets the common parameters for the current page. 
     * For example, the language ID, store ID, and catalog ID.
     *
     * @param {Integer} langId The ID of the language that the store currently uses.
     * @param {Integer} storeId The ID of the current store.
     * @param {Integer} catalogId The ID of the catalog.
     * @param {Integer} authToken The authToken for current user to perform operation on server.
     * @param {String} addAddressURL The URL for adding an address.
     * @param {String} addressBookURL The URL for address book view.
     */
    setCommonParameters:function(langId,storeId,catalogId,authToken,addAddressURL,addressBookURL){
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        this.authToken = authToken;
        this.addAddressURL = addAddressURL;
        this.addressBookURL = addressBookURL;
        cursor_clear();
    },

    /**
     * Redirect to add address page.
     */
    addAddress:function(){
        setPageLocation(this.addAddressURL);
    },

    /*
     * This function creates a new address in the address book.
     * This function takes a form containing the address information and invokes 'updateAddress' service.
     * After the address is created, this function will refresh the address display area using the given URL.
     * @param {string} formName The name of the form containing the address information. 
     */
    newUpdateAddressBook: function(formName){

        var form = document.forms[formName];

        for (var i=0; i<form.sbAddress.length; i++) {
            if (form.sbAddress[i].checked) {
                form.addressType.value=form.sbAddress[i].value;
            }
        }

        if(form.addressType.value == "") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["AB_SELECT_ADDRTYPE"]);
            return;
        }
        /*Validate the form input fields. */
        if (AddressBookDetailJS.validateAddressForm(form)) {
            console.debug("creating with form id = "+formName);
            wcService.declare({
                id: "updateAddress",
                actionId: "updateAddress",
                url: "AjaxPersonChangeServiceAddressAdd",
                formId: formName,
                successHandler: function(serviceResponse) {
                    cursor_clear();
                    widgetCommonJS.redirect(AddressBookListJS.addressBookURL);
                },
                failureHandler: function(serviceResponse) {
                    if (serviceResponse.errorMessage) {
                        MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
                    } else if (serviceResponse.errorMessageKey) {
                        MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
                    cursor_clear();
                }
            });

            /*For Handling multiple clicks. */
            if(!submitRequest()){
                return;
            }
            cursor_wait();

            wcService.invoke("updateAddress");
        }
    },

    /*
     * This function deletes an address from the addressbook.
     * This function deletes an address currently selected and refreshes the address display area using the specified url.
    * @param {string} selectionName The id of the address dropdown box.
     * @param {string} addressDeleteUrl The url used to delete the address.
     * @param {string} addressUrl The url used to refresh the address display area.
     */

    newDeleteAddress: function(selectionName,addressDeleteUrl,addressUrl){

        var addressBox = $("#" + selectionName);
        if(addressBox.val() == $("#" + selectionName + " option:nth-child(1)").val()) {
            MessageHelper.formErrorHandleClient(selectionName + "-button",MessageHelper.messages["ERROR_DEFAULTADDRESS"]);
            return;
        }
        if(addressBox.val() =='') {
            MessageHelper.formErrorHandleClient(selectionName + "-button",MessageHelper.messages["ERROR_SELECTADDRESS"]);
            return;
        }
        var params = [];
        params.storeId = this.storeId;
        params.catalogId = this.catalogId;
        params.addressId = addressBox.val();
        params.URL = addressUrl;
        params.nickName = $.trim($("#" + selectionName + "-button span:nth-child(2)").text());
        wcService.declare({
            id: "AddressDelete",
            actionId: "AddressDelete",
            url: addressDeleteUrl,
            successHandler: function(serviceResponse) {
                MessageHelper.displayStatusMessage(MessageHelper.messages["AB_DELETE_SUCCESS"]);
                cursor_clear();
            },
            failureHandler: function(serviceResponse) {
                if (serviceResponse.errorMessage) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
                } else {
                    if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
                }
                cursor_clear();
            }
        });

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AddressDelete",params);
    }
};

var declareAccountAddressBookRefreshArea = function() {
    // ============================================
    // div: addressBookListDiv refresh area
    var myWidgetObj = $("#addressBookListDiv");

    // common render context
    if (!wcRenderContext.checkIdDefined("myAcctAddressBookContext")) {
        wcRenderContext.declare("myAcctAddressBookContext", ["addressBookListDiv"], {addressId: "0", type: "0"});
    }
    var myRCProperties = wcRenderContext.getRenderContextProperties("myAcctAddressBookContext");

    // model change
    wcTopic.subscribe(["updateAddressBook", "AddressDelete"], function() {
        myWidgetObj.refreshWidget("refresh");
    });

    // render content changed handler
    var renderContextChangedHandler = function() {
        if (wcRenderContext.testForChangedRC("myAcctAddressBookContext", ["addressId"])) {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        }
    };

    var postRefreshHandler = function() {
        myRCProperties["addressId"] = "0";
        myRCProperties["type"] = "0";
        declareAccountaddressDetailRefreshArea();
        wcRenderContext.updateRenderContext('myAcctAddressDetailContext', {'addressId':"0", 'type':"0"});
    }
    
    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
}