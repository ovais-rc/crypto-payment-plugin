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

AddressBookDetailJS = {

    /**
     * This function updates an address in the address book.
     * This function takes a form containing the address information and invokes 'updateAddressBook' service. 
     * After the address is updated, this function will refresh the address
     * display area using the given URL.
     * @param {string} formName The name of the form containing the address information.
     * @param {string} editSectionId The div ID of the edit section.
     */
    updateAddress: function(formName, editSectionId){

        var form = document.forms[formName];

        for (var i = 0; i < form.sbAddress.length; i++) {
            if (form.sbAddress[i].checked) {
                form.addressType.value = form.sbAddress[i].value;
            }
        }

        if(form.addressType.value == "") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["AB_SELECT_ADDRTYPE"]);
            return;
        }
        /* Validate the form input fields. */
        if (this.validateAddressForm(form)) {
            console.debug("creating with form id = "+formName);

            wcService.declare({
                id: "updateAddressBook",
                actionId: "updateAddressBook",
                url: "AjaxRESTPersonChangeServiceAddressAdd",
                formId: formName,
                successHandler: function(serviceResponse) {
                    MessageHelper.displayStatusMessage(MessageHelper.messages["AB_UPDATE_SUCCESS"]);
                    cursor_clear();
                },
                failureHandler: function(serviceResponse) {
                    if (serviceResponse.errorMessage) {
                        MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
                    }
                    else {
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
            wcService.invoke("updateAddressBook");

            // Close Edit Section and display readOnly section.
            widgetCommonJS.toggleReadEditSection(editSectionId, 'read');
        }
    },

    validateAddressForm: function(form,prefix){
        reWhiteSpace = new RegExp(/^\s+$/);
        if(prefix == null){prefix = ""};
        if(prefix){this.setStateDivName(prefix + "stateDiv")};
        if(form != null){
            var fields="";
            if(form["UserDetailsForm_FieldsOrderByLocale"] != null && form["UserDetailsForm_FieldsOrderByLocale"].value != null && form["UserDetailsForm_FieldsOrderByLocale"].value != ""){
                fields = form["UserDetailsForm_FieldsOrderByLocale"].value.split(",");
            }
            else if(form["UserAddressForm_FieldsOrderByLocale"] != null && form["UserAddressForm_FieldsOrderByLocale"].value != null && form["UserAddressForm_FieldsOrderByLocale"].value != ""){
                fields = form["UserAddressForm_FieldsOrderByLocale"].value.split(",");
            }
            else if(form[prefix + "AddressForm_FieldsOrderByLocale"] != null && form[prefix + "AddressForm_FieldsOrderByLocale"].value != null && form[prefix + "AddressForm_FieldsOrderByLocale"].value != ""){
                fields = form[prefix + "AddressForm_FieldsOrderByLocale"].value.split(",");
            }
            else if(form["AddressForm_FieldsOrderByLocale"] != null && form["AddressForm_FieldsOrderByLocale"].value != null && form["AddressForm_FieldsOrderByLocale"].value != ""){
                fields = form["AddressForm_FieldsOrderByLocale"].value.split(",");
            }
            else if(document.getElementById("AddressForm_FieldsOrderByLocale").value!= null && document.getElementById("AddressForm_FieldsOrderByLocale").value!= ""){
                fields=document.getElementById("AddressForm_FieldsOrderByLocale").value.split(",");
            }
            var nickName = prefix + "nickName";
            var lastName = prefix + "lastName";
            var firstName = prefix + "firstName";
            var middleName = prefix + "middleName";
            var address1 = prefix + "address1";
            var address2 = prefix + "address2";
            var city = prefix + "city";
            var state = prefix + "state";
            var country = prefix + "country";
            var zipCode = prefix + "zipCode";
            var email1 = prefix + "email1";
            var phone1 = prefix + "phone1";

            for(var i=0; i<fields.length; i++){
                var field = fields[i];
                if(field == "NICK_NAME" || field == "nick_name"){
                    form[nickName].value = trim(form[nickName].value);
                    if(field == "NICK_NAME" && (form[nickName].value == "" || reWhiteSpace.test(form[nickName].value))){
                        MessageHelper.formErrorHandleClient(form[nickName].id, MessageHelper.messages["ERROR_RecipientEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[nickName].value, 254)){ 
                        MessageHelper.formErrorHandleClient(form.nickName.id, MessageHelper.messages["ERROR_RecipientTooLong"]); 
                        return false;
                    }
                }else if(field == "LAST_NAME" || field == "last_name"){
                    form[lastName].value = trim(form[lastName].value);
                    if(field == "LAST_NAME" && (form[lastName].value == "" || reWhiteSpace.test(form[lastName].value))){ 
                        MessageHelper.formErrorHandleClient(form[lastName].id, MessageHelper.messages["ERROR_LastNameEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[lastName].value, 128)){ 
                        MessageHelper.formErrorHandleClient(form[lastName].id, MessageHelper.messages["ERROR_LastNameTooLong"]);
                        return false;
                    }
                }else if(field == "FIRST_NAME" || field == "first_name"){
                    form[firstName].value = trim(form[firstName].value);
                    if(field == "FIRST_NAME" && (form[firstName].value == "" || reWhiteSpace.test(form[firstName].value))){ 
                        MessageHelper.formErrorHandleClient(form[firstName].id, MessageHelper.messages["ERROR_FirstNameEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[firstName].value, 128)){ 
                        MessageHelper.formErrorHandleClient(form[firstName].id, MessageHelper.messages["ERROR_FirstNameTooLong"]); 
                        return false;
                    }
                }else if(field == "MIDDLE_NAME" || field == "middle_name"){
                    form[middleName].value = trim(form[middleName].value);
                    if(field == "MIDDLE_NAME" && (form[middleName].value == "" || reWhiteSpace.test(form[middleName].value))){ 
                        MessageHelper.formErrorHandleClient(form[middleName].id, MessageHelper.messages["ERROR_MiddleNameEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[middleName].value, 128)){ 
                        MessageHelper.formErrorHandleClient(form[middleName].id, MessageHelper.messages["ERROR_MiddleNameTooLong"]); 
                        return false;
                    }
                }else if(field == "use_org_address" || field == 'new_line'|| field == "PASSWORD" || field == "PASSWORD_VERIFY"){
                }else if(field == "ADDRESS" || field == "address"){
                    form[address1].value = trim(form[address1].value);
                    form[address2].value = trim(form[address2].value);
                    if(field == "ADDRESS" && ((form[address1].value == "" || reWhiteSpace.test(form[address1].value)) && (form[address2].value=="" || reWhiteSpace.test(form[address2].value)))){ 
                        MessageHelper.formErrorHandleClient(form[address1].id, MessageHelper.messages["ERROR_AddressEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[address1].value, 100)){ 
                        MessageHelper.formErrorHandleClient(form[address1].id, MessageHelper.messages["ERROR_AddressTooLong"]); 
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[address2].value, 50)){ 
                        MessageHelper.formErrorHandleClient(form[address2].id, MessageHelper.messages["ERROR_AddressTooLong"]);
                        return false;
                    }
                }else if(field == "CITY" || field == "city"){
                    form[city].value = trim(form[city].value);
                    if(field == "CITY" && (form[city].value == "" || reWhiteSpace.test(form[city].value))){ 
                        MessageHelper.formErrorHandleClient(form[city].id, MessageHelper.messages["ERROR_CityEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[city].value, 128)){
                        MessageHelper.formErrorHandleClient(form[city].id, MessageHelper.messages["ERROR_CityTooLong"]);
                        return false;
                    }
                }else if(field == "STATE/PROVINCE" || field == "state/province"){
                    var state = form[state];
                    if(state == null || state == ""){
                        state = document.getElementById(this.stateDivName).firstChild;
                    }
                    state.value = trim(state.value);
                    if(field == "STATE/PROVINCE" && (state.value == null || state.value == "" || reWhiteSpace.test(state.value))){
                        if(state.tagName == "SELECT" || state.tagName == "select") {
                            MessageHelper.formErrorHandleClient(state.id + "-button", MessageHelper.messages["ERROR_StateEmpty"]);
                        } else {
                            MessageHelper.formErrorHandleClient(state.id, MessageHelper.messages["ERROR_StateEmpty"]);
                        }
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(state.value, 128)){
                        if(state.tagName == "SELECT" || state.tagName == "select") {
                            MessageHelper.formErrorHandleClient(state.id + "-button", MessageHelper.messages["ERROR_StateTooLong"]);
                        } else {
                            MessageHelper.formErrorHandleClient(state.id, MessageHelper.messages["ERROR_StateTooLong"]);
                        }
                        return false;
                    }
                }else if(field == "COUNTRY/REGION" || field == "country/region"){
                    console.log(form[country].value);
                    form[country].value = trim(form[country].value);
                    if(field == "COUNTRY/REGION" && (form[country].value == "" || reWhiteSpace.test(form[country].value))){ 
                        MessageHelper.formErrorHandleClient(form[country].id + "-button", MessageHelper.messages["ERROR_CountryEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[country].value, 128)){ 
                        MessageHelper.formErrorHandleClient(form[country].id + "-button", MessageHelper.messages["ERROR_CountryTooLong"]);
                        return false;
                    }
                }else if(field == "ZIP" || field == "zip"){
                    form[zipCode].value = trim(form[zipCode].value);
                    //check zip code for validation
                    if(field == "ZIP" && (form[zipCode].value=="" || reWhiteSpace.test(form[zipCode].value))){ 
                        MessageHelper.formErrorHandleClient(form[zipCode].id, MessageHelper.messages["ERROR_ZipCodeEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[zipCode].value, 40)){ 
                        MessageHelper.formErrorHandleClient(form[zipCode].id, MessageHelper.messages["ERROR_ZipCodeTooLong"]);
                        return false;
                    }
                }else if(field == "EMAIL1" || field == "email1"){
                    form[email1].value = trim(form[email1].value);
                    if(field == "EMAIL1" && (form[email1].value == "" || reWhiteSpace.test(form[email1].value))){
                        MessageHelper.formErrorHandleClient(form[email1].id, MessageHelper.messages["ERROR_EmailEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[email1].value, 256)){ 
                        MessageHelper.formErrorHandleClient(form[email1].id, MessageHelper.messages["ERROR_EmailTooLong"]);
                        return false;
                    }
                    if(!MessageHelper.isValidEmail(form[email1].value)){
                        MessageHelper.formErrorHandleClient(form[email1].id, MessageHelper.messages["ERROR_INVALIDEMAILFORMAT"]);
                        return false;
                    }
                }else if(field == "PHONE1" || field == "phone1"){
                    form[phone1].value = trim(form[phone1].value);
                    if(field == "PHONE1" && (form[phone1].value == "" || reWhiteSpace.test(form[phone1].value))){
                        MessageHelper.formErrorHandleClient(form[phone1].id, MessageHelper.messages["ERROR_PhonenumberEmpty"]);
                        return false;
                    }
                    if(!MessageHelper.isValidUTF8length(form[phone1].value, 32)){ 
                        MessageHelper.formErrorHandleClient(form[phone1].id, MessageHelper.messages["ERROR_PhoneTooLong"]);
                        return false;
                    }
                    if(!MessageHelper.IsValidPhone(form[phone1].value)){
                        MessageHelper.formErrorHandleClient(form[phone1].id, MessageHelper.messages["ERROR_INVALIDPHONE"]);
                        return false;
                    }
                }else{
                    console.debug("error: mandatory field name " + mandatoryField + " is not recognized.");
                    return false;
                }
            }
            if (form[address1] && form[address1].value == "" && form[address2].value != "") {

            form[address1].value = form[address2].value;
            form[address2].value = "";
            }
            return true;
        }
        return false;
    },

    resetFormValue: function(target_name){
        var target = $("#" + target_name);
        target.find("form").each(function(index, form){
            $(form)[0].reset();
            $(form).find("select.wcSelect").each(function(index, select){
                $(select).Select("refresh_noResizeButton");
            })
        });
    }
};

var declareAccountaddressDetailRefreshArea = function() {
    // ============================================
    // div: addressDetailRefreshArea refresh area
    var myWidgetObj = $("#addressDetailRefreshArea");

    // common render context
    if (!wcRenderContext.checkIdDefined("myAcctAddressDetailContext")) {
        wcRenderContext.declare("myAcctAddressDetailContext", ["addressDetailRefreshArea"], {addressId: "0", type: "0"});
    }
    
    var myRCProperties = wcRenderContext.getRenderContextProperties("myAcctAddressDetailContext");

    // render content changed handler
    var renderContextChangedHandler = function() {
        if (wcRenderContext.testForChangedRC("myAcctAddressDetailContext", ["addressId"]) && myRCProperties["addressId"] != "0") {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        }
    };

    // post refresh handler
    var postRefreshHandler = function() {
        myRCProperties["addressId"] = "0";
        myRCProperties["type"] = "0";
    };

    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
};