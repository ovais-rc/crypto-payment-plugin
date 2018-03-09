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
};//-----------------------------------------------------------------
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
}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by approval comment widget
 */

	ApprovalCommentJS = {
			
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
		
		/**
		* These variables define approve or reject status in the APRVSTATUS table. 1 for approved or 2 for rejected.
		*/
		cApproveStatus: 1,
		cRejectStatus: 2,
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters: function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
		
		/**
		* Approves a approval record
		*/
		approveRecord: function(aprvstatus_id) {
			if(MessageHelper.utf8StringByteLength($('#approvalForm_comments').val()) > 254){ 
				MessageHelper.formErrorHandleClient($('#approvalForm_comments')[0], MessageHelper.messages["APP_COMMENT_ERR_TOO_LONG"]); 
				return false;
			}
			
			service = wcService.getServiceById('AjaxApproveRequest');
			var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                aprv_act: this.cApproveStatus,
                approvalStatusId: aprvstatus_id,
                viewtask: "BuyerApprovalDetailView"
            };
			if ($("#approvalForm_comments").length) {
				params.comments = $("#approvalForm_comments").val();
			}

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxApproveRequest',params);		
		},

		/**
		* Rejects a approval record
		*/
		rejectRecord: function(aprvstatus_id) {
			if(MessageHelper.utf8StringByteLength($('#approvalForm_comments').val()) > 254){ 
				MessageHelper.formErrorHandleClient($('#approvalForm_comments')[0], MessageHelper.messages["APP_COMMENT_ERR_TOO_LONG"]); 
				return false;
			}
			
			service = wcService.getServiceById('AjaxRejectRequest');
			var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                aprv_act: this.cRejectStatus,
                approvalStatusId: aprvstatus_id,
                viewtask: "BuyerApprovalDetailView"
            };
			if ($("#approvalForm_comments").length) {
				params.comments = $("#approvalForm_comments").val();
			}

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxRejectRequest',params);		
		}

	}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by buyer approval widget
 */
	BuyerApprovalListJS = {
			
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
		
		/**
		* These variables define approve or reject status in the APRVSTATUS table. 1 for approved or 2 for rejected.
		*/
		cApproveStatus: 1,
		cRejectStatus: 2,
		
		/**
		* These variables refers to Ids of startSubmitDate and endSubmitDate element in BuyerApprovalList_ToolBar_UI.jspf.
		*/
		formStartDateId: "",
		formEndDateId: "",
		
		/**
		 * Search tool bar Id
		 */
		toolbarId: "",
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters: function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
		
		/**
		 * Sets the common parameters for the current page. 
		 *
		 * @param {String} formStartDateId The ID of the startDate element.
		 * @param {String} formEndDateId The ID of the endDate element.
		 * @param {String} toolbarId The ID of the tool bar element.
		 */
		setToolbarCommonParameters: function(formStartDateId,formEndDateId, toolbarId){
			this.formStartDateId = formStartDateId;
			this.formEndDateId = formEndDateId;
			this.toolbarId = toolbarId;
		},
		
		/**
		* Approves a buyer record
		* @param {Long} aprvstatus_id The id of the request to be approved
		*/
		approveBuyer: function(aprvstatus_id) {
			service = wcService.getServiceById('AjaxApproveBuyerRequest');

			var params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.aprv_act = this.cApproveStatus;
			params.approvalStatusId = aprvstatus_id;
			params.viewtask = "BuyerApprovalView";

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxApproveBuyerRequest',params);		
		},

		/**
		* Rejects a buyer record
		* @param {Long} aprvstatus_id The id of the request to be approved
		*/
		rejectBuyer: function(aprvstatus_id) {
			service = wcService.getServiceById('AjaxRejectBuyerRequest');

			var params = {};
			params.storeId = this.storeId;
			params.catalogId = this.catalogId;
			params.langId = this.langId;
			params.aprv_act = this.cRejectStatus;
			params.approvalStatusId = aprvstatus_id;
			params.viewtask = "BuyerApprovalView";

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxRejectBuyerRequest',params);
		},
		
		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = parseInt(pageNumber);
			pageSize = parseInt(pageSize);
			this.saveToolbarStatus();
			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();

			wcRenderContext.updateRenderContext('BuyerApprovalTable_Context', {"beginIndex": beginIndex});
			MessageHelper.hideAndClearMessage();
		},
		
		/**
		 * Clear the context search term value set by search form
		 */
		reset:function(){
			this.updateContext({"beginIndex":"0", "approvalId": "", "firstName": "", "lastName":"","startDate":"","endDate":""});
		},
		
		/**
		 * Search for buyer approval requests use the search terms specified in the toolbar search form.
		 * 
		 * @param (String) formId	The id of toolbar search form element.
		 */
		doSearch:function(formId){
			var form = $("#" + formId)[0];
			var startDateValue = "";
			var endDateValue = "";
			var startDateWidgetValue = $("#" + this.formStartDateId + "_datepicker").datepicker("getDate");
			if (Utils.varExists(startDateWidgetValue)){
				startDateValue = startDateWidgetValue.toISOString().replace(/\.\d\d\dZ/, '+0000');
			}
			var endDateWidgetValue = $("#" + this.formEndDateId + "_datepicker").datepicker("getDate");
			if (Utils.varExists(endDateWidgetValue)){
				//add one day to the picked endDate.We pick a date the value for the date object
				//is yyyy-MM-dd 00:00:00(beginning of a day, we need it to be end of the a day)
				endDateWidgetValue = Utils.addDays(endDateWidgetValue, 1);
				//deduct one millisecond from the added date
				endDateWidgetValue = Utils.addMilliseconds(endDateWidgetValue, -1);
				endDateValue = endDateWidgetValue.toISOString().replace(/\.\d\d\dZ/, '+0000');
			}
			this.updateContext({
				"beginIndex":"0",
				"approvalId": form.approvalId.value.replace(/^\s+|\s+$/g, ''),
				"firstName":form.submitterFirstName.value.replace(/^\s+|\s+$/g, ''),
				"lastName":form.submitterLastName.value.replace(/^\s+|\s+$/g, ''),
				"startDate":startDateValue,
				"endDate":endDateValue
			});
		},
		
		/**
		 * Filter the buyer Approval list by status
		 * 
		 * @param (String) status The id of toolbar search form element.
		 */
		doFilter:function(status){
			this.updateContext({"beginIndex":"0", "approvalStatus": status});
		},
		
		/**
		 * Update the BuyerApprovalTable_Context context with given context object.
		 * 
		 * @param (Object)context The context object to update
		 */
		updateContext:function(context){
			this.saveToolbarStatus();
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcRenderContext.updateRenderContext("BuyerApprovalTable_Context", context);
			MessageHelper.hideAndClearMessage();
		},
		
		/**
		 * Save the toolbar aria-expanded attribute value
		 */
		saveToolbarStatus:function(){
			Utils.ifSelectorExists("#" + this.toolbarId, function($toolbar) {
				this.toolbarExpanded = $toolbar.attr("aria-expanded");
			}, this);
		},
		
		/**
		 * Restore the toolbar aria-expanded attribute, called by post-refresh handler
		 */
		restoreToolbarStatus:function(){
			if (Utils.varExists(this.toolbarExpanded)){
				$("#" + this.toolbarId).attr("aria-expanded", this.toolbarExpanded);
			}
		}
	}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos
wcRenderContext.declare("searchBasedNavigation_context", ["searchBasedNavigation_content_widget"], { "contentBeginIndex": "0", "productBeginIndex": "0", "beginIndex": "0", "orderBy": "", "facetId": "", "pageView": "", "resultType": "both", "orderByContent": "", "searchTerm": "", "facet": "", "facetLimit": "", "minPrice": "", "maxPrice": "", "pageSize": "" });

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Products).
var searchBasedNavigation_controller_initProperties = {

    renderContextChangedHandler: function(refreshAreaDiv) {
        var rcProperties = wcRenderContext.getRenderContextProperties("searchBasedNavigation_context");
        var resultType = rcProperties["resultType"];
        rcProperties["pgl_widgetId"] = refreshAreaDiv.attr("pglwidgetid");
        if (["products", "both"].indexOf(resultType) > -1) {
            rcProperties["beginIndex"] = rcProperties["productBeginIndex"];
            refreshAreaDiv.refreshWidget("refresh", rcProperties);
        }

    },
    postRefreshHandler: function(widget) {
        // Handle the new facet counts, and update the values in the left navigation.  First parse the script, and then call the update function.        
        var rcProperties = wcRenderContext.getRenderContextProperties("searchBasedNavigation_context"),
            objectId = widget.attr("objectid"),
            facetCounts = byId("#facetCounts" + objectId);

        if (facetCounts != null) {
            var scripts = facetCounts.getElementsByTagName("script");
            var j = scripts.length;
            for (var i = 0; i < j; i++) {
                var newScript = document.createElement('script');
                newScript.type = "text/javascript";
                newScript.text = scripts[i].text;
                facetCounts.appendChild(newScript);
            }
            SearchBasedNavigationDisplayJS.resetFacetCounts();

            //uncomment this if you want tohide zero facet values and the facet itself
            //SearchBasedNavigationDisplayJS.removeZeroFacetValues();
            SearchBasedNavigationDisplayJS.validatePriceInput();
        }
        updateFacetCounts();
        SearchBasedNavigationDisplayJS.cleanUpAddedFacets();

        SearchBasedNavigationDisplayJS.removeEmptyFacet();
        var pairs = location.hash.substring(1).split(SearchBasedNavigationDisplayJS.contextValueSeparator);
        for (var k = 0; k < pairs.length; k++) {
            var pair = pairs[k].split(":");
            if (pair[0] == "facet") {
                var ids = pair[1].split(",");
                for (var i = 0; i < ids.length; i++) {
                    var e = byId(ids[i]);
                    if (e) {
                        e.checked = true;
                        if (e.title != "MORE") {
                            SearchBasedNavigationDisplayJS.appendFilterFacet(ids[i]);
                        }
                    }
                }
            }
        }


        var resultType = rcProperties["resultType"];
        if (["products", "both"].indexOf(resultType) > -1) {
            var currentIdValue = currentId;
            cursor_clear();
            SearchBasedNavigationDisplayJS.initControlsOnPage(objectId, rcProperties);
            shoppingActionsJS.updateSwatchListView();
            shoppingActionsJS.checkForCompare();
            var gridViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_grid_categoryResults";
            var listViewLinkId = "WC_SearchBasedNavigationResults_pagination_link_list_categoryResults";
            var selectedFacet = $("#filter_" + currentIdValue + " > a")[0];
            var deSelectedFacet = $("li[id^='facet_" + currentIdValue + "']" + " .facetbutton")[0];

            if (selectedFacet != null && selectedFacet != 'undefined') {
                selectedFacet.focus();
            } else if (deSelectedFacet != null && deSelectedFacet != 'undefined') {
                deSelectedFacet.focus();
            } else if (currentIdValue == "orderBy") {
                $("#orderBy" + objectId).focus();
            } else {
                if ((currentIdValue == gridViewLinkId || currentIdValue != listViewLinkId) && byId(listViewLinkId)) {
                    byId(listViewLinkId).focus();
                }
                if ((currentIdValue == listViewLinkId || currentIdValue != gridViewLinkId) && byId(gridViewLinkId)) {
                    byId(gridViewLinkId).focus();
                }
            }
        }
        var pagesList = document.getElementById("pages_list_id");
        if (pagesList != null && !isAndroid() && !isIOS()) {
            $(pagesList).addClass("desktop");
        }
	
	/* APPLEPAY BEGIN */
	if (typeof(showApplePayButtons) == "function") {
		showApplePayButtons();
	}
	/* APPLEPAY END */
        wcTopic.publish("CMPageRefreshEvent");
    }
};

// Declare context and refresh controller which are used in pagination controls of SearchBasedNavigationDisplay to display content results (Articles and videos).
var declareSearchBasedNavigationContentController = function() {
    var widgetObj = $("#searchBasedNavigation_content_widget"),
        rcProperties = wcRenderContext.getRenderContextProperties("searchBasedNavigation_context");

    widgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            var resultType = rcProperties["resultType"];
            if (["content", "both"].indexOf(resultType) > -1) {
                rcProperties["beginIndex"] = rcProperties["contentBeginIndex"];
                widgetObj.refreshWidget("refresh", rcProperties);
            }
        },
        postRefreshHandler: function() {
            var resultType = rcProperties["resultType"];
            if (["content", "both"].indexOf(resultType) > -1) {
                var currentIdValue = currentId;
                cursor_clear();
                SearchBasedNavigationDisplayJS.initControlsOnPage(widgetObj.objectId, rcProperties);
                //shoppingActionsJS.initCompare();
                if (currentIdValue == "orderByContent") {
                    byId("orderByContent").focus();
                }
            }
            wcTopic.publish("CMPageRefreshEvent");
        }
    });

};

if (typeof(SearchBasedNavigationDisplayJS) == "undefined" || SearchBasedNavigationDisplayJS == null || !SearchBasedNavigationDisplayJS) {

    SearchBasedNavigationDisplayJS = {

        /**
         * This variable is an array to contain all of the facet ID's generated from the initial search query.  This array will be the master list when applying facet filters.
         */
        contextValueSeparator: "&",
        contextKeySeparator: ":",
        widgetId: "",
        facetIdsArray: [],
        facetIdsParentArray: [],
        uniqueParentArray: [],
        selectedFacetLimitsArray: [],
        facetFromRest: [],

        init: function(widgetSuffix, searchResultUrl, widgetProperties) {
            $('#searchBasedNavigation_widget' + widgetSuffix).refreshWidget("updateUrl", matchUrlProtocol(searchResultUrl));
            var widgetInitProperties = {};
            $.extend(widgetInitProperties, WCParamJS, widgetProperties);
            this.initControlsOnPage(widgetSuffix, widgetInitProperties);
            this.updateContextProperties("searchBasedNavigation_context", widgetInitProperties);

            //			var currentContextProperties = wcRenderContext.getRenderContextProperties('searchBasedNavigation_context').properties;
        },

        initConstants: function(removeCaption, moreMsg, lessMsg, currencySymbol) {
            this.removeCaption = removeCaption;
            this.moreMsg = moreMsg;
            this.lessMsg = lessMsg;
            this.currencySymbol = currencySymbol;
        },

        initControlsOnPage: function(widgetSuffix, properties) {
            //Set state of sort by select box..
            $("#orderBy" + widgetSuffix).val(properties['orderBy']);

            $("#orderByContent").val(properties['orderByContent']);
        },

        initContentUrl: function(contentUrl) {
            $("#searchBasedNavigation_content_widget").refreshWidget("updateUrl", contentUrl);
        },

        findContainer: function(el) {
            //console.debug(el);
            while (el.parentNode) {
                el = el.parentNode;
                if (el.className == 'optionContainer') {
                    return el;
                }
            }
            return null;
        },

        resetFacetCounts: function() {
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var facetValue = byId("facet_count" + this.facetIdsArray[i]);
                var facetAcceValue = byId(this.facetIdsArray[i] + "_ACCE_Label_Count");
                if (facetValue != null) {
                    facetValue.innerHTML = 0;
                }
                if (facetAcceValue != null) {
                    facetAcceValue.innerHTML = 0;
                }
            }
        },

        removeEmptyFacet: function() {
            var widget = this.widgetId;
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var facetId = "facet_" + this.facetIdsArray[i];
                var facetValue = byId("facet_count" + this.facetIdsArray[i]);

                if (facetValue.innerHTML == '0') {
                    $("#" + facetId + widget).css("display", 'none');
                } else if (facetValue.innerHTML != '0') {
                    $("#" + facetId + widget).css("display", 'block');
                }
            }
        },

        removeZeroFacetValues: function() {
            var uniqueId = this.uniqueParentArray;
            var widget = this.widgetId;
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var facetId = "facet_" + this.facetIdsArray[i];
                var parentId = this.facetIdsParentArray[i];
                var facetValue = byId("facet_count" + this.facetIdsArray[i]);

                if (facetValue.innerHTML == '0') {
                    $("#" + facetId + widget).css("display", 'none');
                } else if (facetValue.innerHTML != '0') {
                    $("#" + facetId + widget).css("display", 'block');
                    uniqueId[parentId] = uniqueId[parentId] + 1;
                }
            }
            for (var key in uniqueId) {
                if (uniqueId[key] == 0) {
                    document.getElementById(key).style.display = 'none';
                    uniqueId[key] = 0; //reset the count
                } else if (uniqueId[key] != 0) {
                    document.getElementById(key).style.display = 'block';
                    uniqueId[key] = 0; //reset the count
                }
            }

        },
        updateFacetCount: function(id, count, value, label, image, contextPath, group, multiFacet) {
            var facetValue = byId("facet_count" + id);
            var widget = this.widgetId;
            if (facetValue != null) {
                var checkbox = byId(id);
                var facetAcceValue = byId(id + "_ACCE_Label_Count");
                if (count > 0) {
                    // Reenable the facet link
                    checkbox.disabled = false;
                    if (facetValue != null) {
                        facetValue.innerHTML = count;
                    }
                    if (facetAcceValue != null) {
                        facetAcceValue.innerHTML = count;
                    }
                }
            } else if (count > 0) {
                // there is no limit to the number of facets shown, and the user has exposed the show all link
                if (byId("facet_" + id) == null) {
                    // this facet does not exist in the list.  Insert it.
                    var divContainer = $("[id^='section_list_" + group + "']")[0];
                    var grouping = $(" > ul.facetSelect", divContainer)[0];
                    if (grouping) {
                        this.facetIdsArray.push(id);
                        var newFacet = document.createElement("li");
                        newFacet.setAttribute("onclick", "SearchBasedNavigationDisplayJS.triggerCheckBox(this)");
                        var newCheckBox = document.createElement("div");
                        var newCheckMark = document.createElement("div");
                        var facetClass = "";
                        var section = "";
                        if (!multiFacet) {
                            if (image !== "") {
                                facetClass = "singleFacet";
                            }
                            // specify which facet group to collapse when multifacets are not enabled.
                            section = group;
                        }
                        if (image !== "") {
                            facetClass = "singleFacet left";
                        }
                        if (image === "") {
                            $(newCheckBox).attr("class", "checkBox");
                            $(newCheckMark).attr("class", "checkmarkMulti");
                        }
                        $(newFacet).attr("id", "facet_" + id + widget);
                        $(newFacet).attr("class", facetClass);
                        newFacet.setAttribute("data-additionalvalues", "More")
                        var facetLabel = "<label for='" + id + "'>";
                        if (image !== "") {
                            facetLabel = facetLabel + "<span class='swatch'><span class='outline'><span id='facetLabel_" + id + "'><img src='" + image + "' title='" + label + "' alt='" + label + "'/></span> <div class='facetCountContainer'>(<span id='facet_count" + id + "'>" + count + "</span>)</div>";
                        } else {
                            facetLabel = facetLabel + "<span class='outline'><span id='facetLabel_" + id + "'>" + label + "</span> (<span id='facet_count" + id + "'>" + count + "</span>)</span>";
                        }
                        facetLabel = facetLabel + "<span class='spanacce' id='" + id + "_ACCE_Label'>" + label + " (" + count + ")</span></label>";
                        newFacet.innerHTML = "<input type='checkbox' aria-labelledby='" + id + "_ACCE_Label' id='" + id + "' value='" + value + "' onclick='javascript: SearchBasedNavigationDisplayJS.setEnabledShowMoreLinks(this, \"morelink_" + group + "\");SearchBasedNavigationDisplayJS.toggleSearchFilter(this, \"" + id + "\");'/>" + facetLabel;

                        var clearFloat = $(" > div.clear_float", grouping)[0];
                        if (clearFloat != undefined) {
                            grouping.removeChild(clearFloat);
                        }
                        grouping.appendChild(newFacet);
                        if (image === "") {
                            newFacet.appendChild(newCheckBox);
                            newCheckBox.appendChild(newCheckMark);
                        }
                    }
                }
            }
        },

        triggerCheckBox: function(elem) {
            var inputBox = elem.children[0];
            inputBox.click();
        },

        cleanUpAddedFacets: function() {
            for (var i = 0; i < this.facetIdsArray.length; i++) {
                var removeFacet = true;
                for (var j = 0; j < this.facetFromRest.length; j++) {
                    if (this.facetIdsArray[i] == this.facetFromRest[j]) {
                        removeFacet = false;
                        break;
                    }
                }
                if (removeFacet) {
                    var elem = byId("facet_" + this.facetIdsArray[i]);
                    if (elem != null) {
                        elem.parentNode.removeChild(elem);
                    }
                }
            }
        },

        setEnabledShowMoreLinks: function(element, section_id) {
            if (element.checked) {
                this.selectedFacetLimitsArray.push(section_id + "|" + element.id + "|" + element.value);
                this.removeShowMoreFromFacetLimitArray(section_id);
            } else {
                var index = this.selectedFacetLimitsArray.indexOf(section_id + "|" + element.id + "|" + element.value);
                if (index > -1) {
                    this.selectedFacetLimitsArray.splice(index, 1);
                }
            }
        },



        isValidNumber: function(n) {
            var valueToParse = n;
            valueToParse = valueToParse.replace(/^\s+|\s+$/g, "");
            valueToParse = valueToParse.replace(/\xa0/g, '');
            var valueToParse = valueToParse;

            if (Utils.getLocale() === 'ar-eg') {
                valueToParse = valueToParse.replace(',', '');
                var parsedAmountValue = Utils.round(valueToParse, 2);
            } else {
                var parsedAmountValue = Utils.round(valueToParse, 2);
            }
            return !isNaN(parsedAmountValue);
        },
        convertToInternalValue: function(val) {
            var valueToParse = val;
            valueToParse = valueToParse.replace(/^\s+|\s+$/g, "");
            valueToParse = valueToParse.replace(/\xa0/g, '');
            var valueToParse = valueToParse;

            if (Utils.getLocale() === 'ar-eg') {
                valueToParse = valueToParse.replace(',', '');
                var parsedAmountValue = Utils.round(valueToParse, 2);
            } else {
                var parsedAmountValue = Utils.round(valueToParse, 2);
            }
            return parsedAmountValue;
        },

        onGoButtonPress: function() {
            var low = $("#low_price_input").val(),
                high = $("#high_price_input").val();
            window.location.href = Utils.updateQueryStringParameter(window.location.href, {
                minPrice: low,
                maxPrice: high
            });
        },

        onPriceInput: function(event) {
            var enterPressed = (event.keyCode === KeyCodes.RETURN),
                inputValid = this.validatePriceInput(enterPressed);
            if (inputValid && enterPressed) {
                this.onGoButtonPress();
            } else {
                this.toggleGoButton(inputValid);
            }
        },

        toggleGoButton: function(enable) {
            var go = $("#price_range_go");
            if (go.length) {
                if (enable) {
                    go.attr("class", "go_button");
                    go.prop("disabled", false);
                } else {
                    go.attr("class", "go_button_disabled");
                    go.prop("disabled", true);
                }
            }
        },

        validatePriceInput: function(showErrorMsg) {
            if ($("#low_price_input").length && $("#high_price_input").length) {
                var low = $("#low_price_input").val();
                var high = $("#high_price_input").val();
                if (!this.isValidNumber(low)) {
                    if (showErrorMsg) {
                        MessageHelper.formErrorHandleClient("low_price_input", Utils.getLocalizationMessage('ERROR_FACET_PRICE_INVALID'));
                    }
                    return false;
                } else if (!this.isValidNumber(high)) {
                    if (showErrorMsg) {
                        MessageHelper.formErrorHandleClient("high_price_input", Utils.getLocalizationMessage('ERROR_FACET_PRICE_INVALID'));
                    }
                    return false;
                } else if (parseFloat(high) < parseFloat(low)) {
                    if (showErrorMsg) {
                        MessageHelper.formErrorHandleClient("high_price_input", Utils.getLocalizationMessage('ERROR_FACET_PRICE_INVALID'));
                    }
                    return false;
                } else {
                    return true;
                }
            }
            return false;
        },

        toggleShowMore: function(index, show) {
            var list = byId('more_' + index);
            var morelink = byId('morelink_' + index);
            if (list != null) {
                if (show) {
                    morelink.style.display = "none";
                    list.style.display = "inline-block";
                } else {
                    morelink.style.display = "inline-block";
                    list.style.display = "none";
                }
            }
        },

        toggleSearchFilterOnKeyDown: function(event, element, id) {
            if (event.keyCode === KeyCodes.RETURN) {
                //element.checked = !element.checked;
                this.toggleSearchFilter(element, id);
            }
        },

        toggleSearchFilter: function(element, id) {
            if (element.checked) {
                this.appendFilterFacet(id);
            } else {
                this.removeFilterFacet(id);
            }

            /*

            			if(section !== "") {
            				byId('section_' + section).style.display = "none";
            			}
            */
            this.doSearchFilter();
        },

        appendFilterPriceRange: function(currencySymbol) {

            var el = byId("price_range_input");
            var section = this.findContainer(el);
            if (section) {
                byId(section.id).style.display = "none";
            }
            /*
			byId("clear_all_filter").style.display = "block";
            
			var facetFilterList = byId("facetFilterList");
			// create facet filter list if it's not exist
			if (facetFilterList == null) {
				facetFilterList = document.createElement("ul");
				$(facetFilterList).attr("id", "facetFilterList");
				$(facetFilterList).attr("class", "facetSelectedCont");
				var facetFilterListWrapper = byId("facetFilterListWrapper");
				facetFilterListWrapper.appendChild(facetFilterList);
			}

			var filter = byId("pricefilter");
			if(filter == null) {
				filter = document.createElement("li");
				$(filter).attr("id", "pricefilter");
				$(filter).attr("class", "facetSelected");
				facetFilterList.appendChild(filter);
			}
			var label = currencySymbol + byId("low_price_input").value + " - " + currencySymbol + $("#high_price_input").val();
			filter.innerHTML = "<a role='button' href='#' onclick='wcTopic.publish(\"Facet_Remove\"); return false;'>" + "<div class='filter_option'><div class='close'></div><span>" + label + "</span><div class='clear_float'></div></div></a>";

			byId("clear_all_filter").style.display = "block";
            */
            if (this.validatePriceInput()) {
                // Promote the values from the input boxes to the internal inputs for use in the request.
                byId("low_price_value").value = this.convertToInternalValue(byId("low_price_input").value);
                byId("high_price_value").value = this.convertToInternalValue(byId("high_price_input").value);
            }

        },

        removeFilterPriceRange: function() {
            console.error("should not be calling this");
            /*
			if($("#low_price_value").length && $("#high_price_value").length) {
				byId("low_price_value").value = "";
				byId("high_price_value").value = "";
			}
			var facetFilterList = byId("facetFilterList");
			var filter = byId("pricefilter");
			if(filter != null) {
				facetFilterList.removeChild(filter);
			}

			if(facetFilterList.childNodes.length == 0) {
				byId("clear_all_filter").style.display = "none";
				byId("facetFilterListWrapper").innerHTML = "";
			}

			var el = byId("price_range_input");
			var section = this.findContainer(el);
			if(section) {
				byId(section.id).style.display = "block";
			}

			this.doSearchFilter(); */
        },

        appendFilterFacet: function(id) {
            var facetFilterList = byId("facetFilterList");
            // create facet filter list if it's not exist
            if (facetFilterList == null) {
                facetFilterList = document.createElement("ul");
                $(facetFilterList).attr("id", "facetFilterList");
                $(facetFilterList).attr("class", "facetSelectedCont");
                var facetFilterListWrapper = byId("facetFilterListWrapper");
                facetFilterListWrapper.appendChild(facetFilterList);
            }

            var filter = byId("filter_" + id);
            // do not add it again if the user clicks repeatedly
            if (filter == null) {
                filter = document.createElement("li");
                $(filter).attr("id", "filter_" + id);
                $(filter).attr("class", "facetSelected");
                var label = byId("facetLabel_" + id).innerHTML;
                var acceRemoveLabel = "<span class='spanacce' id='ACCE_Label_Remove'>" + MessageHelper.messages['REMOVE'] + "</span>";

                filter.innerHTML = "<a role='button' href='#' onclick='javascript:setCurrentId(\"" + id + "\");wcTopic.publish(\"Facet_Remove\", \"" + id + "\"); return false;'>" + "<div class='filter_option'><div class='close'></div><span>" + label + "</span>" + acceRemoveLabel + "<div class='clear_float'></div></div></a>";

                facetFilterList.appendChild(filter);
            }

            $("#facetLabel_" + id).parent().attr("class", "outline facetSelectedHighlight");

            var el = byId(id);
            var section = this.findContainer(el);
            if (section) {
                byId(section.id).style.display = "none";
            }
            byId("clear_all_filter").style.display = "block";

        },

        removeFilterFacet: function(id) {
            var facetFilterList = byId("facetFilterList");
            var filter = byId("filter_" + id);
            if (filter != null) {
                var value = byId(id).value;
                var section_id = value.split("%3A%22")[0];
                var index = this.selectedFacetLimitsArray.indexOf("morelink_" + section_id + "|" + id + "|" + value);

                if (index == -1) {
                    value = value.replace(/%3A/g, ":");
                    value = value.replace(/%22/g, '"');
                    index = this.selectedFacetLimitsArray.indexOf("morelink_" + section_id + "|" + id + "|" + value);
                }

                if (index > -1) {
                    this.selectedFacetLimitsArray.splice(index, 1);
                }
                facetFilterList.removeChild(filter);
                //byId(id).checked = false;
            }

            if (facetFilterList != null && facetFilterList.childNodes.length == 0) {
                byId("clear_all_filter").style.display = "none";
                byId("facetFilterListWrapper").innerHTML = "";
            }

            $("#facetLabel_" + id).parent().attr("class", "outline");

            var el = byId(id);
            var section = this.findContainer(el);
            if (section) {
                byId(section.id).style.display = "block";
            }
            this.doSearchFilter();
        },

        getEnabledProductFacets: function() {
            var facetForm = document.forms['productsFacets'] != null ? document.forms['productsFacets'] : document.forms['productsFacetsHorizontal'];
            var elementArray = facetForm.elements;

            var facetArray = [];
            var facetIds = [];
            if (_searchBasedNavigationFacetContext != 'undefined') {
                for (var i = 0; i < _searchBasedNavigationFacetContext.length; i++) {
                    facetArray.push(_searchBasedNavigationFacetContext[i]);
                    //facetIds.push();
                }
            }
            var facetLimits = [];
            for (var i = 0; i < elementArray.length; i++) {
                var element = elementArray[i];
                if (element.type != null && element.type.toUpperCase() == "CHECKBOX") {
                    if (element.title == "MORE") {
                        // scan for "See More" facet enablement.
                        if (element.checked) {
                            facetLimits.push(element.value);
                        }
                    } else {
                        // disable the checkbox while the search is being performed to prevent double clicks
                        //element.disabled = true;
                        if (element.checked) {
                            facetArray.push(element.value);
                            facetIds.push(element.id);
                        }
                    }
                }
            }
            // disable the price range button also
            if ($("#price_range_go").length) {
                byId("price_range_go").disabled = true;
            }

            var results = [];
            results.push(facetArray);
            results.push(facetLimits);
            results.push(facetIds);
            return results;
        },

        /**
         * @param clickedFacet the facet that was clicked
         */
        onFacetClick: function(clickedFacet) {
            console.error("deprecated: should not call this function");
            /*
			var minPrice = "",
                maxPrice = "";

			if(Utils.idExists("low_price_value", "high_price_value")) {
				minPrice = $("#low_price_value").val();
				maxPrice = $("#high_price_value").val();
			}
			if(minPrice === '' && maxPrice === '')
			{
				minPrice = window.initialMinPrice;
				maxPrice = window.initialMaxPrice;
			}
			
            var facetArray = this.getEnabledProductFacets(),
                $clickedFacet = $(clickedFacet),
                url = $clickedFacet.attr('href')
            url = Utils.updateQueryStringParameter(url, {
                "productBeginIndex": "0", 
                "facet": [$("input[type='checkbox']", $clickedFacet.parent()).val()], 
                "facetLimit": [], 
                "facetId": [$clickedFacet.data("for")], 
                "resultType":"products", 
                "minPrice": minPrice, 
                "maxPrice": maxPrice
            });
            $clickedFacet.attr('href', url)
            console.log(url);*/
            /*
			wcRenderContext.updateRenderContext('searchBasedNavigation_context', );
			*/

        },

        addShowMoreToFacetLimitArray: function(id) {
            // only add if no child facet is selected (i.e. no child is found in selectedFacetLimitsArray
            var childExist = false;
            for (var i = 0; i < this.selectedFacetLimitsArray; i++) {
                if (this.selectedFacetLimitsArray[i].indexOf(id) !== -1) {
                    childExist = true;
                    break;
                }
            }
            if (!childExist) {
                var index = id.indexOf(":");
                if (index != -1) {
                    id = id.substr(0, index);
                }
                this.selectedFacetLimitsArray.push("morelink_" + id);
            }
        },

        removeShowMoreFromFacetLimitArray: function(id) {
            var cIndex = id.indexOf(":");
            if (cIndex != -1) {
                id = id.substr(0, cIndex);
            }
            if (id.indexOf("morelink_") === -1) {
                id = "morelink_" + id;
            }
            var index = this.selectedFacetLimitsArray.indexOf(id);
            if (index != -1) {
                this.selectedFacetLimitsArray.splice(index, 1);
            }
        },

        toggleShowMore: function(element, id) {
            var label = byId("showMoreLabel_" + id);
            var divContainer = $("[id^='section_list_" + id + "']")[0];
            var grouping = $(" > ul.facetSelect > li[data-additionalvalues]", divContainer);
            if (element.checked) {
                this.addShowMoreToFacetLimitArray(element.value);
                label.innerHTML = this.lessMsg;
                var group = $(" > ul.facetSelect", divContainer)[0];
                var clearFloat = $(" > div.clear_float", group)[0];
                if (clearFloat != undefined) {
                    group.removeChild(clearFloat);
                }
                grouping.css("display", "");
            } else {
                this.removeShowMoreFromFacetLimitArray(element.value);
                grouping.css("display", "none");
                label.innerHTML = this.moreMsg;
            }
            this.doSearchFilter();
        },


        clearAllFacets: function(execute) {
            console.error("deprecated: do not call this function");
            /*
			byId("clear_all_filter").style.display = "none";
			byId("facetFilterListWrapper").innerHTML = "";
			if($("#low_price_value").length && $("#high_price_value").length) {
				byId("low_price_value").value = "";
				byId("high_price_value").value = "";
			}

			var facetForm = document.forms['productsFacets'] != null ? document.forms['productsFacets'] : document.forms['productsFacetsHorizontal'];
			var elementArray = facetForm.elements;
			for (var i=0; i < elementArray.length; i++) {
				var element = elementArray[i];
				if(element.type != null && element.type.toUpperCase() == "CHECKBOX" && element.checked && element.title != "MORE") {
					//element.checked = false;
				}
			}

			var elems = document.getElementsByTagName("*");
			for (var i=0; i < elems.length; i++) {
				// Reset all hidden facet sections (single selection facets are hidden after one facet is selected from that facet grouping)
				// and clear all selected facet highlights.
				var element = elems[i];
				if (element.id != null) {
					if (element.id.indexOf("section_") == 0 && !(element.id.indexOf("section_list") == 0)) {
						element.style.display = "block";
					}
					if (element.id.indexOf("facetLabel_") == 0) {
						$(element).parent().attr("class", "outline");
					}
				}
			}

			if(execute) {
				this.doSearchFilter();
				this.selectedFacetLimitsArray = [];
			}*/
        },

        updateContextProperties: function(contextId, properties) {
            //Set the properties in context object..
            for (key in properties) {
                wcRenderContext.getRenderContextProperties(contextId)[key] = properties[key];
            }
        },

        toggleView: function(data) {

            console.error("deprecated: do not call this function");
            /*
			var pageView = data["pageView"];
			setCurrentId(data["linkId"]);
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			//console.debug("pageView = "+pageView+" controller = +searchBasedNavigation_controller");
			wcRenderContext.updateRenderContext('searchBasedNavigation_context', {"pageView": pageView,"resultType":"products", "enableSKUListView":data.enableSKUListView});
			MessageHelper.hideAndClearMessage();*/
        },

        toggleExpand: function(id) {
            var icon = byId("icon_" + id);
            var section_list = byId("section_list_" + id);
            if (icon.className == "arrow") {
                icon.className = "arrow arrow_collapsed";
                $(section_list).attr("aria-expanded", "false");
                section_list.style.display = "none";
            } else {
                icon.className = "arrow";
                $(section_list).attr("aria-expanded", "true");
                section_list.style.display = "block";
            }
        },

        sortResults: function(orderBy) {
            console.error("should not be calling this");
        },

        swatchImageClicked: function(id) {
            // This is a workaround for IE's bug for non-clickable label images.
            var e = byId(id);
            if (!e.checked) {
                e.click();
            }
        },

        clone: function(masterObj) {
            console.error("should not be calling this");
        }
    };
}
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

/**
 *  Video display widget
 */	

window.onload=function() {   
	var video = document.getElementById("videoScreen");
	if (video) {
		if(video.canPlayType && (video.canPlayType('video/mp4') || video.canPlayType('video/ogg'))) {
			
			function startVideo() {
				this.removeEventListener('play', startVideo, false);
				document.getElementById('promotionTitle').style.display = 'none';
			}
			
			function endVideo() {
				this.removeEventListener('ended', endVideo, false);
				document.getElementById('videoScreen').style.display = 'none';
				document.getElementById('videoFinished').style.display = 'block';
			}
			
			if (!video.addEventListener) {
				video.attachEvent('play', startVideo, false);
				video.attachEvent('ended', endVideo, false);
			}
			else {
				video.addEventListener('play', startVideo, false);
				video.addEventListener('ended', endVideo, false);
			}
		}
		else {
			document.getElementById('promotionTitle').style.display = 'none';
		}
	}
}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

var FindByCSRUtilities = function(){


    this.showHide = function(nodeId, hiddenClassName, activeClassName){
        $('#'+nodeId).toggleClass(hiddenClassName);
        $('#'+nodeId).toggleClass(activeClassName);
    };

    this.changeDropDownArrow = function(nodeId, arrowClass){
        $('#'+nodeId).toggleClass(arrowClass);
    };


    this.toggleSelection = function(nodeCSS,nodeId,parentNode,cssClassName){
        // Get list of all active nodes with cssClass = nodeCSS under parentNode.
        var activeNodes = $('.'+cssClassName, "#"+parentNode);

        // Toggle the css class for the node with id = nodeId
        $('#'+nodeId,  "#"+parentNode).toggleClass(cssClassName);

        // Remove the css class for all the active nodes.
        activeNodes.removeClass(cssClassName);
    };

    this.handleErrorScenario = function(){
        var errorMessageObj = $("#errorMessageFindOrders");
        var errorSectionObj = $("#errorMessage_sectionFindOrders");
        if(errorMessageObj.length){
            var errorMessage = errorMessageObj.val();

            if(errorMessage != null && errorMessage != undefined && errorSectionObj != null){
                 $(errorSectionObj).css('display', 'block');
                 $(errorSectionObj).css('color', '#CA4200');
                 // TODO - set focus to error div..for accessibility...
                 $(errorSectionObj).text(errorMessage);
            }
        } else {

             $(errorSectionObj).css('display', 'none');
        }
    };

    this.cancelEvent =  function(e) {
        if (e.stopPropagation) {
            e.stopPropagation();
        }
        if (e.preventDefault) {
            e.preventDefault();
        }
        e.cancelBubble = true;
        e.cancel = true;
        e.returnValue = false;
    };

    this.closeActionButtons = function(nodeCSS,parentNode,cssClassName,hiddenClassName,activeClassName){
        $('.'+nodeCSS, "#"+parentNode).removeClass(cssClassName);
    };

    this.resetActionButtonStyle = function(nodeCSS,parentNode,hiddenClassName,activeClassName){
        $('.'+nodeCSS, "#"+parentNode).addClass(hiddenClassName);
        $('.'+nodeCSS, "#"+parentNode).removeClass(activeClassName);
    };

    this.toggleCSSClass = function(nodeCSS,nodeId,parentNode,hiddenClassName,activeClassName){
        // Get the list of current nodes
        var activeNodes = $('.'+activeClassName, "#"+parentNode);

        // For the clicked node, toggle the CSS Class. If hidden then display / If displayed then hide.
        $('#'+nodeId, "#"+parentNode).toggleClass(hiddenClassName);
        $('#'+nodeId, "#"+parentNode).toggleClass(activeClassName);

        // For all activeNodes, remove the activeCSS and add the hiddenCSS
        activeNodes.removeClass(activeClassName);
        activeNodes.addClass(hiddenClassName);
    };


    this.setUserInSession = function(userId, selectedUser,landingURL){

        var renderContext = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContextCSR');
        if(selectedUser != '' && selectedUser != null) {
            renderContext["selectedUser"] = escapeXml(selectedUser, true);
        }
        if(landingURL != '' && landingURL != null){
            renderContext["landingURL"] = landingURL;
        }

    // If we are setting a forUser in session here, it has to be CSR role. Save this info in context.
        // Once user is successfully set, we will set this info in cookie.
        renderContext["WC_OnBehalf_Role_"] = "CSR";

        var params = [];
        params.runAsUserId = userId;
        params.storeId = WCParamJS.storeId;
        wcService.invoke("AjaxRunAsUserSetInSessionCSR", params);
    };

    this.onUserSetInSession = function(){
        var renderContext = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContextCSR');
        var selectedUser = renderContext["selectedUser"];
        if(selectedUser != '' && selectedUser != null){
            //write the cookie.
            setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, escapeXml(selectedUser, true), {path:'/', domain:cookieDomain});
        }
        var onBehalfRole = renderContext["WC_OnBehalf_Role_"];
        if(onBehalfRole != '' && onBehalfRole != null){
            //write the cookie.
            setCookie("WC_OnBehalf_Role_"+WCParamJS.storeId, onBehalfRole, {path:'/', domain:cookieDomain});
        }
    };



    this.enableDisableUserAccount = function(userId, status,logonId){

        //Save it in context
        var context = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContextCSR");
        context["userId"] = userId;

        // If userStatus is already available in context, then use it.
        // This means, the status is updated by making an Ajax call after the page is loaded and status is updated.
        var updatedStatus = context[userId+"_updatedStatus"];
        if(updatedStatus != null){
            if(updatedStatus == '0'){
                status = '1';
            } else {
                status = '0';
            }
        }
        context[userId+"_userStatus"] = status;
        // Invoke service
        wcService.invoke("AjaxRESTUserRegistrationAdminUpdateStatusCSR", {'userId' : userId, 'userStatus':status, 'logonId' : logonId});
    };

    this.onEnableDisableUserStatusAccount = function(serviceResponse){
        var message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_ENABLE_SUCCESS");
        if(serviceResponse.userStatus == '0'){
            message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_DISABLE_SUCCESS");
        }
        MessageHelper.displayStatusMessage(message);
        onBehalfUtilitiesJS.updateUIAndRenderContext(serviceResponse,"UserRegistrationAdminUpdateStatusContextCSR");
    };



};


$(document).ready(function() {
    findbyCSRJS = new FindByCSRUtilities();

});


/**
 * Declares a new render context for find orders  result list - To display orders based on search criteria.
 */
wcRenderContext.declare("findOrdersSearchResultsContextCSR",[],{'isPaginatedResults':'false'});


//Declare context and service for updating the status of user.
wcRenderContext.declare("UserRegistrationAdminUpdateStatusContextCSR",[],{});
wcService.declare({
    id: "AjaxRESTUserRegistrationAdminUpdateStatusCSR",
    actionId: "AjaxRESTUserRegistrationAdminUpdateStatusCSR",
    url: getAbsoluteURL() +  "AjaxRESTUserRegistrationAdminUpdate",
    formId: ""

     /**
      *  This method refreshes the panel
      *  @param (object) serviceResponse The service response object, which is the
      *  JSON object returned by the service invocation.
      */
    ,successHandler: function(serviceResponse) {
        findbyCSRJS.onEnableDisableUserStatusAccount(serviceResponse);
        cursor_clear();
    }

    /**
    * display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        } else {
            if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        }
    }

});


// Service to start on-behalf user session.
wcService.declare({
    id: "AjaxRunAsUserSetInSessionCSR",
    actionId: "AjaxRunAsUserSetInSessionCSR",
    url: getAbsoluteURL() + "AjaxRunAsUserSetInSession",
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        //Use this CSR_SUCCESS_ACCOUNT_ACCESS
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_CUSTOMER_ACCOUNT_ACCESS"));

        findbyCSRJS.onUserSetInSession();
        setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display shoppers cart details...
        var landingURL = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContextCSR')["landingURL"];
        window.location.href = landingURL; // if landingURL is null, it reloads same page. so don't check for != ''
    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
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


//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

var FindOrders = function(){

    this.searchListData = {
                            "progressBarId":"FindOrdersList_form_botton_1", "formId":"FindOrders_searchForm",
                            "searchButtonId":"FindOrdersList_form_botton_1", "clearButtonId":"FindOrdersList_form_botton_2",
                             "searchOptionLabel" : "searchOptionLabel"
                          },


     /**
        Setup events for Search and Clear Results button in Find Orders Page
    */
    this.setUpEvents = function(){

        var scope = this;
        var target = document.getElementById(this.searchListData.searchButtonId);
        if(target != null) {
            $(target).on("click",function(event){
                scope.doSearch();
            });
        }

        target = $("#" +this.searchListData.clearButtonId);
        if(target != null) {
            $(target).on("click",function(event){
                scope.clearFilter();
            });
        }

    };


    this.clearFilter = function(){

        this.clearSearchResults();

        // Remove search criteria..
        $('#FindOrders_searchForm input[id ^= "findOrders_"]').each(function(i, inputElement){
            inputElement.value = null;
        });

        //Remove search criteria from select menu
        $('#FindOrders_searchForm select[id ^= "findOrders_"]').each(function(j, inputElement){
            var jqueryObject = $('#' + inputElement.id);
            if(jqueryObject.length){
                jqueryObject.val('');
                jqueryObject.Select("refresh_noResizeButton");
            }

            if(inputElement.id === "findOrders_Form_Input_state") {
                $("#" + inputElement.id).replaceWith('<input type="text" id="findOrders_Form_Input_state" name="state" />');
            }
        });

        //Remove input in date pickers
        $('#datepickerFrom').val("");
        $('#datepickerTo').val("");
    };

    this.doSearch = function(){
        this.clearSearchResults();

        //Do we have any search criteria to search ?
        var doSearch = false;
        $('#'+this.searchListData.formId+' input[id ^= "findOrders_"]').each(function(i, inputElement){
                 var value = inputElement.value;
                 if(value != null && value != ''){
                     doSearch = true;
                 }
             });


        if(!doSearch){
            $('#'+this.searchListData.formId+' select[id ^= "findOrders_"]').each(function(j, inputElement){
                    var jqueryObject = $('#' + inputElement.id);
                    var value = jqueryObject.val();
                    if(value != '' ){
                        doSearch = true;
                    }
                 });
        }


        if(!doSearch) {
        	MessageHelper.formErrorHandleClient(this.searchListData.searchButtonId, Utils.getLocalizationMessage("CSR_NO_SEARCH_CRITERIA"));
            return false;
        }


        var renderContextProperties = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContext');
        renderContextProperties["searchInitialized"] = "true";

        setCurrentId(this.searchListData.progressBarId);
        if(!submitRequest()){
            return;
        }

        cursor_wait();
        var params = {};
        // code level formatting can be taken care or in js. Based on server REST need, include formatting here.
        //this.formatDate();
        $("#findOrdersRefreshArea").refreshWidget("updateFormId", this.searchListData.formId);
        wcRenderContext.updateRenderContext("findOrdersSearchResultsContext", params);

    };



    this.toggleOrderSummarySection = function(orderId){
        findbyCSRJS.showHide('orderDetailsExpandedContent_'+orderId, 'collapsed', 'expanded');
        findbyCSRJS.changeDropDownArrow('dropDownArrow_'+orderId,'expanded');
        return true;
    };

    this.handleActionDropDown = function(event,memberId){
        findbyCSRJS.cancelEvent(event);
        findbyCSRJS.toggleSelection('actionDropdown','actionDropdown_'+memberId, 'findOrdersSearchResults', 'active');
        findbyCSRJS.toggleCSSClass('actionButton','actionButton7_'+memberId,'findOrdersSearchResults','actionDropdownAnchorHide','actionDropdownAnchorDisplay');
        return false;
    }

    this.clearSearchResults = function(){
        // Remove search results
        if($("#findOrdesResultList_table").length){
            $("#findOrdesResultList_table").css("display","none");
        }
    };






    this.accessOrderDetails = function(userId, selectedUser, landingURL)
    {


        var renderContextProperties = wcRenderContext.getRenderContextProperties('findOrdersSearchResultsContext');
        // First need to set user in sesison before accessing orderDetails page...

        // in case of order details display, landing URL will be different. So set that here before calling setUserInSession command.
        // in case of guest orders, landingURL will be coming null and it will pass null as well..
        if(landingURL != '' && landingURL != null){
            renderContextProperties["landingURL"] = landingURL;
        }
        // currently landingUrl is registered customers account link...if it is guest user, landing url will be differnt..
        findbyCSRJS.setUserInSession(userId,selectedUser,landingURL);

    };


    this.lockUnlockOrder = function(orderId, isLocked, takeOverLock){

        //Save it in context
        var context = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext");
        context["orderId"] = orderId;
        var takeOverLockStatus = context[orderId+"_takeOverLock"];
        if(takeOverLockStatus != null){
            //if context has already  saved data then pick up from conetxt
            takeOverLock = takeOverLockStatus;
        }

        if(takeOverLock == 'true')
        {
            //take over lock first and then call unlock order
            wcService.invoke("AjaxRESTTakeOverlock", {'orderId' : orderId, 'filterOption' : "All", 'takeOverLock' : 'Y',  'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});

        }
        else
        {
            // this is required to set value in context back when CSR decides to unlock again..
            var lockStatus = context[orderId+"_isLocked"];
            if(lockStatus != null){
                //if context has already  saved data then pick up from conetxt
                    isLocked = lockStatus;
            }
            // Invoke service : if order is already locked, call unlock cart to unlock the same else lock it
            if(isLocked=='true')
            {
                //unlock order
                wcService.invoke("AjaxRESTOrderUnlock", {'orderId' : orderId, 'filterOption' : "All", 'isLocked':isLocked, 'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});

            }else
            {
                //lock order...
                wcService.invoke("AjaxRESTOrderLock", {'orderId' : orderId, 'filterOption' : "All", 'isLocked':isLocked, 'storeId': WCParamJS.storeId, 'langId':  WCParamJS.langId});

            }
        }


    };



    this.onlockUnlockOrder = function(serviceResponse){

        var message = Utils.getLocalizationMessage("SUCCESS_ORDER_LOCK");
        var lockStatusText = Utils.getLocalizationMessage('UNLOCK_CUSTOMER_ORDER_CSR');
        if(serviceResponse.isLocked[0] == 'true'){
            message = Utils.getLocalizationMessage("SUCCESS_ORDER_UNLOCK");
            lockStatusText = Utils.getLocalizationMessage('LOCK_CUSTOMER_ORDER_CSR');
        }
        MessageHelper.displayStatusMessage(message);

        var renderContext = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext"); //this should be orderlock related context
        var orderId = renderContext["orderId"];  // orderid
        var lockStatus = renderContext[orderId+"_isLocked"];

        // Update widget text...
        $("#orderLocked_"+orderId).html(lockStatusText);

        if($("#minishopcart_lock_"+orderId) != null){
            var node = $("#minishopcart_lock_"+orderId);
            if(renderContext[orderId+"_isLocked"] == "true")
            {
                 $(node).attr("class", "");
            }
            else
            {
                $(node).attr("class", "nodisplay");
            }
        }
    };

    this.displayCSROrderSummaryPage = function(orderId){
        document.location.href = "CSROrderSummaryView"+"?"+getCommonParametersQueryString()+"&orderId="+orderId;
    };
};


$(document).ready(function() {
    findOrdersJS = new FindOrders();
    findOrdersJS.setUpEvents();

});

function declareFindOrdersRefreshArea() {
    // ============================================
    // div: findOrdersRefreshArea refresh area
    // eclares a new refresh controller for the Find Orders List
    var myWidgetObj = $("#findOrdersRefreshArea");

    /**
     * Declares a new render context for find orders  result list - To display orders based on search criteria.
     */
    wcRenderContext.declare("findOrdersSearchResultsContext", ["findOrdersRefreshArea"], {'searchInitialized':'false', 'isPaginatedResults':'false'},"");

    var myRCProperties = wcRenderContext.getRenderContextProperties("findOrdersSearchResultsContext");
    var baseURL = getAbsoluteURL()+'FindOrdersResultListViewV2';

    var renderContextChangedHandler = function() {
        myWidgetObj.refreshWidget("updateUrl", baseURL +"?"+getCommonParametersQueryString());
        myWidgetObj.html("");
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    };

    var postRefreshHandler = function() {
        findbyCSRJS.handleErrorScenario();
        console.debug("Post refresh handler of findOrdersController");
        cursor_clear();
    }

    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});

};

//Declare context and service for updating the status of user.
wcRenderContext.declare("OrderLockUnlockContext",[],{});

wcService.declare({
        id: "AjaxRESTOrderLock",
        actionId: "AjaxRESTOrderLock",
        url:  getAbsoluteURL()+'AjaxRESTOrderLock',
        formId: ""


     /**
      *  This method refreshes the panel
      *  @param (object) serviceResponse The service response object, which is the
      *  JSON object returned by the service invocation.
      */
    ,successHandler: function(serviceResponse) {
        // set context of lock for this orderid as true... as it has been locked..

        var renderContext = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext"); //this should be orderlock related context
        var orderId = renderContext["orderId"];  // orderid
        renderContext[orderId+"_isLocked"] = "true";
        findOrdersJS.onlockUnlockOrder(serviceResponse);
        cursor_clear();
    }

    /**
    * display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        } else {
            if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        }
    }

});
wcService.declare({

    id: "AjaxRESTOrderUnlock",
    actionId: "AjaxRESTOrderUnlock",
    url:  getAbsoluteURL()+'AjaxRESTOrderUnlock',
    formId: ""


 /**
  *  This method refreshes the panel
  *  @param (object) serviceResponse The service response object, which is the
  *  JSON object returned by the service invocation.
  */
,successHandler: function(serviceResponse) {
    //var lockStatus = context.properties[orderId+"_isLocked"];
    // set context of lock for this orderid as false... as it has been unlocked..
    var renderContext = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext"); //this should be orderlock related context
    var orderId = renderContext["orderId"];  // orderid
    renderContext[orderId+"_isLocked"] = "false";

    findOrdersJS.onlockUnlockOrder(serviceResponse);
    cursor_clear();
}

/**
* display an error message.
* @param (object) serviceResponse The service response object, which is the
* JSON object returned by the service invocation.
*/
,failureHandler: function(serviceResponse) {
    if (serviceResponse.errorMessage) {
        MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
    } else {
        if (serviceResponse.errorMessageKey) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
        }
    }
}

});

wcService.declare({

    id: "AjaxRESTTakeOverlock",
    actionId: "AjaxRESTTakeOverlock",
    url:  getAbsoluteURL()+'/AjaxRESTTakeOverlock',
    formId: ""


 /**
  *  This method refreshes the panel
  *  @param (object) serviceResponse The service response object, which is the
  *  JSON object returned by the service invocation.
  */
,successHandler: function(serviceResponse) {
    //findOrdersJS.onlockUnlockOrder(serviceResponse);
    //after successfully taking over lock, it should call unlock
    var context = wcRenderContext.getRenderContextProperties("OrderLockUnlockContext");
    var orderId = context["orderId"];
    context[orderId+"_takeOverLock"] = "false";
    findOrdersJS.lockUnlockOrder(orderId, 'true', 'false');
    cursor_clear();
}

/**
* display an error message.
* @param (object) serviceResponse The service response object, which is the
* JSON object returned by the service invocation.
*/
,failureHandler: function(serviceResponse) {
    if (serviceResponse.errorMessage) {
        MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
    } else {
        if (serviceResponse.errorMessageKey) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
        }
    }
}

});
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


var OrderComments = function(){

    this.editIconId = "editIcon";
    this.widgetId = ''; //Id of the InlineEditBox widget
    this.mainDivId = 'orderComment'; // enclosing div which contains the InlineEditBox widget.
    this.maxCommentLength = 3000;
    this.commentsLoadStatus = new Object();

    /**
        Called after successfully loading the order comments with ajax call and
        displaying the InLineEdit widget (before displaying edit box/save/cancel buttons)
    */
    this.startUp = function(){

        //Comments are successfully loaded. Make a note of it.
        this.commentsLoadStatus[this.widgetId] = 1;
        //Update order comments section heading.
        var commentsPaginationInfo =$("#orderCommentHeading").val();
        if($("#orderCommentHeadingPaginationInfo").val() !== null){
            commentsPaginationInfo = commentsPaginationInfo +"&nbsp;"+$("#orderCommentHeadingPaginationInfo").val();
        }
        $("#orderCommentToggleLabel").html(commentsPaginationInfo);
    };

    /**
        Called after successfully saving new order comment with ajax call.
    */

    this.resetWidget = function(resetEditText){

        if($("#comment").val() != ''){
            $("#comment").val('');
        }

          // Update orderComments heading with new pagination info.
        var commentsPaginationInfo = $("#orderCommentHeading").val();
        if($("#orderCommentHeadingPaginationInfo").val() !== null){
            commentsPaginationInfo = commentsPaginationInfo +"&nbsp;"+$("#orderCommentHeadingPaginationInfo").val();
        }
        $("#orderCommentToggleLabel").html(commentsPaginationInfo);

        // Display addCommentWidget
         $("#commentWidget").remove();
         $('#addCommentWidget').show();
    }

    this.cancelEdit = function(){
        this.resetWidget();
    };

    this.showHide = function(nodeId, hiddenClassName, activeClassName){
        var node = $('#'+nodeId);
        node.toggleClass(hiddenClassName);
        node.toggleClass(activeClassName);
    };

    this.expandCollapseArea = function(){
        this.showHide('orderCommentContainer_plusImage_link', 'collapsed', 'displayInline');
        this.showHide('orderCommentContainer_minusImage_link', 'collapsed', 'displayInline');
        this.showHide('orderCommentContent', 'collapsed', 'expanded');

        if($("#orderCommentContainer_plusImage_link").hasClass('displayInline')){
            document.getElementById("orderCommentContainer_plusImage_link").focus();
        } else if($("#orderCommentContainer_minusImage_link").hasClass('displayInline')){
            document.getElementById("orderCommentContainer_minusImage_link").focus();
        }
    };

    this.loadComments = function(orderId,widgetId){
        if(this.commentsLoadStatus[widgetId] == 1){
            //Comments already loaded.
            return false;
        }

        // Fetch comments from server by making an Ajax call.
        this.widgetId = widgetId;
        wcRenderContext.updateRenderContext('orderCommentsContext', {"orderId": orderId});
    };

    this.saveComments = function(orderId, widgetId, mode){
        var orderComment = $.trim($("#comment").val());
        if(orderComment === null || orderComment.length === 0){
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('EMPTY_COMMENT'));
            this.resetWidget(false);
            return false;
        }

        if(!MessageHelper.isValidUTF8length(orderComment, this.maxCommentLength)){
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('COMMENT_LENGTH_OUT_OF_RANGE'));
            // Let the comment text be available to CSR. So that they can reduce the char count, instead of keying in again
            this.resetWidget(false);
            return false;
        }

        var params = [];
        params["mode"] = mode;
        params["orderComment"] = orderComment;
        params["orderId"] = orderId;
        cursor_wait();
        wcService.invoke("AjaxRESTAddOrderComment", params);
    };


    this.showHideorderCommentsSliderContent = function(){
        $( document ).ready(function() {
                $('#orderCommentsSlider_content').toggleClass('orderCommentsSlider_content_closed');
                $('#orderCommentsSlider_trigger').toggleClass('orderCommentsSlider_trigger_closed');
        });
    };
}
$(document).ready(function() {
    orderCommentsJS = new OrderComments();
});
    var declareOrderCommentListRefreshArea = function() {
        // ============================================
        // div: orderCommentListRefreshArea refresh area
        // Declares a new refresh controller for the fetching order level comments.
        
        /**
         * Declares a new render context for managing orderComments customers list - To display registered customers based on search criteria.
         */
        wcRenderContext.declare("orderCommentsContext", ["orderCommentListRefreshArea"], {});

        var myWidgetObj = $("#orderCommentListRefreshArea");
        var myRCProperties = wcRenderContext.getRenderContextProperties("orderCommentsContext");
        var baseURL = getAbsoluteURL()+'OrderCommentsListViewV2';

        var renderContextChangedHandler = function() {
            console.debug("renderContextChangedHandler of orderCommentListRefreshArea");
            myWidgetObj.refreshWidget("updateUrl", baseURL+"?"+getCommonParametersQueryString());
            myWidgetObj.attr("role", "region");
            myWidgetObj.attr("tabIndex", 0);
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        };

        wcTopic.subscribe("AjaxRESTAddOrderComment", function() {
            console.debug("modelChangedHandler of orderCommentListRefreshArea");
            myWidgetObj.refreshWidget("updateUrl", baseURL+"?"+getCommonParametersQueryString());
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        });
        
        var postRefreshHandler = function() {
             console.debug("Post refresh handler of orderCommentListRefreshArea");
             cursor_clear();
             orderCommentsJS.startUp();
        };
       
        // initialize widget
        myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
    };



// when user clicks on edit link and the InlineEditor is displayed.

$.fn.inlineEdit = function (replaceWith) {

    $(this).keypress(function (event) {

        if (event.keyCode == 13) { // Checks for the enter key
            $(this).click();
            event.preventDefault();
        }
    });

    $(this).click(function () {

        var self = $(this);
        self.hide();
        self.after(replaceWith);
        $("#comment").focus();
        $("#saveButton").addClass("button_primary saveButton");
        $("#cancelButton").addClass("button_secondary cancelButton");
        $("#comment").addClass("expandingTextArea");

    });
} 





// Service to add Order Level Comments
wcService.declare({
    id: "AjaxRESTAddOrderComment",
    actionId: "AjaxRESTAddOrderComment",
    url: getAbsoluteURL() + "AjaxRESTAddOrderComment"+"?"+getCommonParametersQueryString(),
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
        //After saving the comments, reset the widget to initial state.
        //Remove the saved comment from textArea.
        orderCommentsJS.resetWidget(true);
        cursor_clear();
    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
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


//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


var RegisteredCustomers = function(){


    this.searchListData = {
                            "progressBarId":"RegisteredCustomersList_form_botton_1", "formId":"RegisteredCustomersSearch_searchForm",
                            "searchButtonId":"RegisteredCustomersList_form_botton_1", "clearButtonId":"RegisteredCustomersList_form_botton_2"
                          },

    this.csrResetPasswordIds = {
                                "administratorPasswordId":"administratorPassword", "errorDivId":"csr_resetPassword_error", "errorMessageId":"csr_resetPassword_error_msg",
                                "parentNodeId":"csr_reset_password", "resetPasswordButtonId":"csr_resetPassword_button",
                                 "resetPasswordDropDownPanelId":"csr_resetPassword_dropdown_panel"
                               },

    this.csrPasswordEnabled = false,

    /**
        Setup events for Search and Clear Results button in Find Registered Customer Page
    */
    this.setUpEvents = function(){
        var scope = this;
        var target = $("#" +this.searchListData.searchButtonId);
        if(target != null) {
            $(target).on("click",function(event){
                scope.doSearch();
            });
        }

        target = $("#" +this.searchListData.clearButtonId);
        if(target != null) {
            $(target).on("click",function(event){
                scope.clearFilter();
            });
        }

    };

    /**
        Clear search results and search criteria.
    */
    this.clearFilter = function(){

        this.clearSearchResults();
        // Remove search criteria..

        $('#RegisteredCustomersSearch_searchForm input[id ^= "RegisteredCustomersSearch_"]').each(function(j, inputElement){
            inputElement.value = null;
        });

        // Remove search criteria in select menu
        $('#RegisteredCustomersSearch_searchForm select[id ^= "RegisteredCustomersSearch_"]').each(function(j, inputElement){
            var jqueryObject = $("#" + inputElement.id);
            if(jqueryObject != null){
                jqueryObject.val('');
                jqueryObject.Select("refresh_noResizeButton");
            }

            if(inputElement.id === "RegisteredCustomersSearch_Form_Input_state") {
                $("#" + inputElement.id).replaceWith('<input type="text" id="RegisteredCustomersSearch_Form_Input_state" name="state" />');
            }
        });
    };

    /**
        Search for registered customers.
    */
    this.doSearch = function(){
        this.clearSearchResults();

        //Do we have any search criteria to search ?
        var doSearch = false;
        $('#'+ this.searchListData.formId+' input[id ^= "RegisteredCustomersSearch_"]').each(function(i, inputElement){
                 var value = inputElement.value;
                 if(value != null && value != ''){
                     doSearch = true;
                 }
             });


        // Do we have some criteria in drop down boxes - State / Country ?
        if(!doSearch){
            $('#'+this.searchListData.formId+' select[id ^= "RegisteredCustomersSearch_"]').each(function(j, inputElement){
                    var jqueryObject = $('#' + inputElement.id);
                    var value = jqueryObject.val();
                    if(value != '' ){
                        doSearch = true;
                    }
                 });
        }


        if(!doSearch) {
        	MessageHelper.formErrorHandleClient(this.searchListData.searchButtonId, Utils.getLocalizationMessage("CSR_NO_SEARCH_CRITERIA"));
        	return false;
        }

        wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext')["searchInitializedForCustomers"] = "true";

        setCurrentId(this.searchListData.progressBarId);
        if(!submitRequest()){
            return;
        }

        cursor_wait();
        var params = {};
        $("#registeredCustomersRefreshArea").refreshWidget("updateFormId", this.searchListData.formId);
        wcRenderContext.updateRenderContext("registeredCustomersSearchResultsContext", params);
    };


    this.toggleMemberSummarySection = function(memberId){
        this.showHide('memberDetailsExpandedContent_'+memberId, 'collapsed', 'expanded');
        this.changeDropDownArrow('dropDownArrow_'+memberId,'expanded');
        return true;
    };


    this.handleActionDropDown = function(event,memberId, parentNode){
        this.cancelEvent(event);
        this.toggleSelection('actionDropdown','actionDropdown_'+memberId, parentNode, 'active');
        this.toggleCSSClass('actionButton','actionButton7_'+memberId,parentNode,'actionDropdownAnchorHide','actionDropdownAnchorDisplay');
        return false;
    }

    this.showHide = function(nodeId, hiddenClassName, activeClassName){
        $('#'+nodeId).toggleClass(hiddenClassName);
        $('#'+nodeId).toggleClass(activeClassName);
    };

    this.changeDropDownArrow = function(nodeId, arrowClass){
        $('#'+nodeId).toggleClass(arrowClass);
    };

    this.clearSearchResults = function(){
        // Remove search results
        if($("#registeredCustomersList_table") != null){
            $("#registeredCustomersList_table").css("display","none");
        }
    };

    this.toggleSelection = function(nodeCSS,nodeId,parentNode,cssClassName){
        // Get list of all active nodes with cssClass = nodeCSS under parentNode.
        var activeNodes = $('.'+cssClassName, "#"+parentNode);

        // Toggle the css class for the node with id = nodeId
        $('#'+nodeId, "#"+parentNode).toggleClass(cssClassName);

        // Remove the css class for all the active nodes.

        activeNodes.removeClass(cssClassName);
    };

    this.resetPasswordByAdminOnBehalfForBuyers = function(userId){
        wcService.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer", {'logonId':userId, 'URL':"test"});
    };

    this.resetPasswordByAdminOnBehalf = function(userId){
        if(this.csrPasswordEnabled) {
            //  Use this when CSR password is mandatory to reset customer password.
            var administratorPassword = $("#" +this.csrResetPasswordIds.administratorPasswordId).val();
            if(administratorPassword == null || administratorPassword == ''){
                var error = Utils.getLocalizationMessage('CSR_PASSWORD_EMPTY_MESSAGE');
                this.onResetPasswordByAdminError(error);
                return false;
            }
            wcService.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalf", {'administratorPassword': administratorPassword,'logonId':userId, 'URL':"test"});
        } else {
            wcService.invoke("AjaxRESTMemberPasswordResetByAdminOnBehalf", {'logonId':userId,'URL':"test"});
        }
    };

    this.resetPasswordByAdmin = function(userId,administratorPassword){
        wcService.invoke("AjaxRESTMemberPasswordResetByAdmin", {'administratorPassword' : administratorPassword, 'logonId':userId, 'URL':"test"});
    };

    this.handleCSRPasswordReset = function(event){
        this.cancelEvent(event);

        if(this.csrPasswordEnabled) {
            $("#" +this.csrResetPasswordIds.administratorPasswordId).val('');
        }
        // Change the styling of the ResetPassword button
        $('#'+this.csrResetPasswordIds.resetPasswordButtonId ,'#'+this.csrResetPasswordIds.parentNodeId).toggleClass('clicked');

        // Toggle the css class for the dropDown panel with id = nodeId
        $('#'+this.csrResetPasswordIds.resetPasswordDropDownPanelId, '#'+this.csrResetPasswordIds.parentNodeId).toggleClass('active');

        // Hide error div.
        $('#'+this.csrResetPasswordIds.errorDivId, '#'+this.csrResetPasswordIds.parentNodeId).addClass('hidden');

        return false;
    }

    this.hideErrorDiv = function(){
        // Hide error div.
        $('#'+this.csrResetPasswordIds.errorDivId, '#'+ this.csrResetPasswordIds.parentNodeId).addClass('hidden');
    }

    this.onResetPasswordByAdminError = function(errorMessage, errorResponse){
        $("#" +this.csrResetPasswordIds.errorMessageId).html(errorMessage);
        // Display error div.
        $('#'+ this.csrResetPasswordIds.errorDivId, '#'+this.csrResetPasswordIds.parentNodeId).removeClass('hidden');
        // focus to error div.
        $("#" +this.csrResetPasswordIds.errorMessageId).focus();
    }

    this.onResetPasswordByAdminSuccess = function(){
        // Change the styling of the ResetPassword button
        $('#'+this.csrResetPasswordIds.resetPasswordButtonId, '#'+ this.csrResetPasswordIds.parentNodeId).toggleClass('clicked');

        // Toggle the css class for the dropDown panel with id = nodeId
        $('#'+this.csrResetPasswordIds.resetPasswordDropDownPanelId, '#'+ this.csrResetPasswordIds.parentNodeId).toggleClass('active');
        return false;
    }

    this.handleErrorScenario = function(){
            var errorMessageObj = $("#errorMessage");
        var errorSectionObj = $("#errorMessage_section");
        if(errorMessageObj.length){
            var errorMessage = errorMessageObj[0].value;
            if(errorMessage != null && errorMessage.length != "" && errorSectionObj != null){
                 $('#errorMessage_section').css( 'display', 'block');
                 // TODO - set focus to error div..for accessibility...
                 $('#errorMessage_section').text(errorMessage);

            }
        } else {
            $('#errorMessage_section').css( 'display', 'none');
        }
    };

    this.cancelEvent =  function(e) {
        if (e.stopPropagation) {
            e.stopPropagation();
        }
        if (e.preventDefault) {
            e.preventDefault();
        }
        e.cancelBubble = true;
        e.cancel = true;
        e.returnValue = false;
    };

    this.closeActionButtons = function(nodeCSS,parentNode,cssClassName,hiddenClassName,activeClassName){
        $('.'+nodeCSS, "#"+ parentNode).removeClass(cssClassName);
    };

    this.resetActionButtonStyle = function(nodeCSS,parentNode,hiddenClassName,activeClassName){
        $('.'+nodeCSS, "#"+parentNode).addClass(hiddenClassName);
        $('.'+nodeCSS, "#"+parentNode).removeClass(activeClassName);
    };

    this.toggleCSSClass = function(nodeCSS,nodeId,parentNode,hiddenClassName,activeClassName){
        // Get the list of current nodes
        var activeNodes = $('.'+activeClassName, "#"+parentNode);

        // For the clicked node, toggle the CSS Class. If hidden then display / If displayed then hide.
        $('#'+nodeId,"#"+ parentNode).toggleClass(hiddenClassName);
        $('#'+nodeId,"#"+ parentNode).toggleClass(activeClassName);

        // For all activeNodes, remove the activeCSS and add the hiddenCSS
        activeNodes.removeClass(activeClassName);
        activeNodes.addClass(hiddenClassName);
    };

    this.createGuestUser = function(landingURL){
        var renderContext = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext');
        if((landingURL == null || landingURL == '') && !stringStartsWith(document.location.href, "https")){
            renderContext["landingURL"] = '';
        } else {
            // Reload home page
            landingURL = WCParamJS.homePageURL;
            renderContext["landingURL"] = landingURL;
        }

        var params = [];
        wcService.invoke("AjaxRESTCreateGuestUser", params);
    };

    this.createRegisteredUser = function(landingURL){
        if(landingURL != null) {
           wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext')["landingURL"] = landingURL;
        }

        var params = [];
        var form = $("#Register");
        if(form.guestUserId != null && form.guestUserId.value != null){
            // Guest user id exists. Use it while registering new user.
            params.userId = form.guestUserId.value;
        }
        // Do not set errorViewName, since we are making Ajax call. Handle the response back in same page.
        $(form.errorViewName).remove();
        wcService.invoke("AjaxRESTUserRegistrationAdminAdd", params);
    };

    this.setUserInSession = function(userId, selectedUser,landingURL){
        var renderContext = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext');
        if(selectedUser != '' && selectedUser != null) {
            renderContext["selectedUser"] = escapeXml(selectedUser, true);
        }
        if(landingURL != '' && landingURL != null){
            renderContext["landingURL"] = landingURL;
        }
        // If we are setting a forUser in session here, it has to be CSR role. Save this info in context.
        // Once user is successfully set, we will set this info in cookie.
        renderContext["WC_OnBehalf_Role_"] = "CSR";

        var params = [];
        params.runAsUserId = userId;
        params.storeId = WCParamJS.storeId;
        wcService.invoke("AjaxRunAsUserSetInSession", params);
    };

    this.onUserSetInSession = function(){
        var renderContext = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext');
        var selectedUser = renderContext["selectedUser"];
        if(selectedUser != '' && selectedUser != null){
            //write the cookie.
            setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, escapeXml(selectedUser, true), {path:'/', domain:cookieDomain});
        }
        var onBehalfRole = renderContext["WC_OnBehalf_Role_"];
        if(onBehalfRole != '' && onBehalfRole != null){
            //write the cookie.
            setCookie("WC_OnBehalf_Role_"+WCParamJS.storeId, onBehalfRole, {path:'/', domain:cookieDomain});
        }
    };


    this.enableDisableUserAccount = function(userId, status){
        //Save it in context
	var context = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContext");
        context["userId"] = userId;

        // If userStatus is already available in context, then use it.
        // This means, the status is updated by making an Ajax call after the page is loaded and status is updated.
	var updatedStatus = context[userId+"_updatedStatus"];
        if(updatedStatus != null){
            if(updatedStatus == '0'){
                status = '1';
            } else {
                status = '0';
            }
        }
	context[userId+"_userStatus"] = status;

        // Invoke service
        wcService.invoke("AjaxRESTUserRegistrationAdminUpdateStatus", {'userId' : userId, 'userStatus':status});
    };

    this.onEnableDisableUserStatusAccount = function(serviceResponse){
        var message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_ENABLE_SUCCESS");
        if(serviceResponse.userStatus == '0'){
            message = Utils.getLocalizationMessage("CUSTOMER_ACCOUNT_DISABLE_SUCCESS");
        }
        MessageHelper.displayStatusMessage(message);
        onBehalfUtilitiesJS.updateUIAndRenderContext(serviceResponse,"UserRegistrationAdminUpdateStatusContext");

    };

};

$(document).ready(function() {
    registeredCustomersJS = new RegisteredCustomers();
    registeredCustomersJS.setUpEvents();
});

    /**
     * Declares a new render context for registered customers list - To display registered customers based on search criteria.
     */
     if (!wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContext")) {
    wcRenderContext.declare("registeredCustomersSearchResultsContext", ["registeredCustomersRefreshArea"], {'searchInitializedForCustomers':'false', 'isPaginatedResults':'false'},"");
}
function declareRegisteredCustomersRefreshArea() {
    // ============================================
    // div: registeredCustomersRefreshArea refresh area
    // Declares a new refresh controller for the Registered Customers List
    var myWidgetObj = $("#registeredCustomersRefreshArea");

    var myRCProperties = wcRenderContext.getRenderContextProperties("registeredCustomersSearchResultsContext"),
    baseURL = getAbsoluteURL()+'RegisteredCustomersListViewV2',
    renderContextChangedHandler = function() {
	myWidgetObj.refreshWidget("updateUrl", baseURL +"?"+getCommonParametersQueryString());
        $("#registeredCustomersRefreshArea").html("");
        console.debug(myRCProperties);
        $("#registeredCustomersRefreshArea").refreshWidget("refresh", myRCProperties)
    },

    postRefreshHandler = function() {
        registeredCustomersJS.handleErrorScenario();
        console.debug("Post refresh handler of registeredCustomersController");
        cursor_clear();
    };

    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
}

// Declare context and service for updating the status of user.
 if (!wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContext")) {
wcRenderContext.declare("UserRegistrationAdminUpdateStatusContext", [], {});
}
wcService.declare({
    id: "AjaxRESTUserRegistrationAdminUpdateStatus",
    actionId: "AjaxRESTUserRegistrationAdminUpdateStatus",
    url: getAbsoluteURL() +  "AjaxRESTUserRegistrationAdminUpdate",
    formId: ""

     /**
      *  This method refreshes the panel
      *  @param (object) serviceResponse The service response object, which is the
      *  JSON object returned by the service invocation.
      */
    ,successHandler: function(serviceResponse) {
        registeredCustomersJS.onEnableDisableUserStatusAccount(serviceResponse);
        cursor_clear();
    }

    /**
    * display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        } else {
            if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        }
    }

});


// Service to start on-behalf user session.
wcService.declare({
    id: "AjaxRunAsUserSetInSession",
    actionId: "AjaxRunAsUserSetInSession",
    url: getAbsoluteURL() + "AjaxRunAsUserSetInSession",
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
		if(typeof callCenterIntegrationJS != 'undefined' && callCenterIntegrationJS != undefined && callCenterIntegrationJS != null){
			var params = {};
			params.status = "success";
			params.serviceResponse = serviceResponse;
			callCenterIntegrationJS.postActionMessage(params, "START_ON_BEHALF_SESSION_RESPONSE");	
		}
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_CUSTOMER_ACCOUNT_ACCESS"));
        registeredCustomersJS.onUserSetInSession();
        setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display shoppers cart details...
        var landingURL = wcRenderContext.getRenderContextProperties('registeredCustomersSearchResultsContext')["landingURL"];
        if(landingURL != "-1"){
			window.location.href = landingURL; // if landingURL is null, it reloads same page. so don't check for != ''
		}

    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
		if(typeof callCenterIntegrationJS != 'undefined' && callCenterIntegrationJS != undefined && callCenterIntegrationJS != null){
			var params = {};
			params.status = "error";
			params.serviceResponse = serviceResponse;
			callCenterIntegrationJS.postActionMessage(params, "START_ON_BEHALF_SESSION_RESPONSE");	
		}
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

// Service to Create Guest User and create on-behalf session
wcService.declare({
    id: "AjaxRESTCreateGuestUser",
    actionId: "AjaxRESTCreateGuestUser",
    url: getAbsoluteURL() + "AjaxRESTCreateGuestUser",
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_NEW_GUEST_USER_CREATION"));
        var guestUserName = Utils.getLocalizationMessage("GUEST");
        // Set this new guest user in session. Start on-behalf session for guest user.
        registeredCustomersJS.setUserInSession(serviceResponse.userId, guestUserName);
    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
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


//Declare context for user registration admin add
//wcRenderContext.declare("UserRegistrationAdminAddContext", [], {'administratorPassword':'', 'userId':''});

// Service to register new user and start on-behalf user session.
wcService.declare({
    id: "AjaxRESTUserRegistrationAdminAdd",
    actionId: "AjaxRESTUserRegistrationAdminAdd",
    url: getAbsoluteURL() + "AjaxRESTUserRegistrationAdminAdd",
    formId: "Register"

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {

        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("CSR_SUCCESS_NEW_REGISTERED_USER_CREATION"));
        registeredCustomersJS.setUserInSession(serviceResponse.userId, serviceResponse.firstName+ ' ' + serviceResponse.lastName);
        cursor_clear();
    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        } else {
            if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        }
        cursor_clear();
    }
});//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This file provides all the functions and variables to manage Global Login panel.
 */

/* global document, window, $, setCookie, getCookie, cookieDomain, WCParamJS, GlobalLoginJS, Utils, cursor_clear, cursor_wait, submitRequest, wc, processAndSubmitForm, invokeItemAdd, invokeOtherService, isOnPasswordUpdateForm, service */

/**
* Constant key in activePanel
*/
var KEY_ACTIVE = 'active',

    /**
    * Constant key in activePanel
    */
    KEY_SELECTED = 'selected';

GlobalLoginJS = {

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

    /**
     * This variable stores the ID of active panels. Its default value is empty.
     * @private
     */
    activePanel: {},

    widgetsLoadedOnPage: [],

    /**
     * This variable stores the ID of active panels. Its default value is empty.
     * @private
     */
    isPanelVisible: true,

    /**
     * True if mouse down event registered, false otherwise (prevents registering
     * event more than once).
     */
    mouseDownConnectHandle: null,
    /**
     * Sets the common parameters for the current page.
     * For example, the language ID, store ID, and catalog ID.
     *
     * @param {Integer} langId The ID of the language that the store currently uses.
     * @param {Integer} storeId The ID of the current store.
     * @param {Integer} catalogId The ID of the catalog.
     */
    setCommonParameters: function (langId, storeId, catalogId) {
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        cursor_clear();
    },

    hideGLPanel: function (isPanelVisible) {
        this.isPanelVisible = isPanelVisible;
    },

    registerWidget: function (widgetId) {
        this.widgetsLoadedOnPage.push(widgetId);
    },

    InitHTTPSecure: function (widgetId) {
        var href = document.location.href;
        var index = href.lastIndexOf("s", 4);

        if (index != -1) {
            // Open sign in panel if loaded with HTTPS.
            GlobalLoginJS.displayPanel(widgetId);

        } else {
			// Loaded with HTTP. Change it to HTTPS along with appropriate port.
			if (WCParamJS.urlPrefixForHTTP) {
				var newHref = href.substring(WCParamJS.urlPrefixForHTTP.length);
				index = newHref.indexOf("/");
				newHref = WCParamJS.urlPrefixForHTTPS + newHref.substring(index);
			} else {
				var newHref = href.substring(0,4) + "s" + (href.substring(4));
			}
            setCookie("WC_DisplaySignInPanel_" + WCParamJS.storeId, "true", {
                path: '/',
                domain: cookieDomain
            });
            window.location = newHref;
            return;
        }
    },

    
    displayPanel: function (widgetId) {
		var redirectToPageName = getCookie("WC_RedirectToPage_"+WCParamJS.storeId);
			
		if (redirectToPageName != undefined && redirectToPageName != null)
        	setCookie("WC_RedirectToPage_"+WCParamJS.storeId, null, {expires:-1,path:"/", domain:cookieDomain});

        //check if the sign in panel is loaded. if loaded, toggle the dropdown. Else, trigger a refresh.
        var widgetNode = $("#" + widgetId);
        if (widgetNode.length > 0) {
            var panelLoaded = widgetNode.attr("panel-loaded");
            if (panelLoaded) {
                this.togglePanel(widgetNode);
                // Change the URL to display after successfull logOn.
                if(redirectToPageName != null && typeof (redirectToPageName) != 'undefined'){
                    var globalLogInForm = document.getElementById(this.globalLogInWidgetID+"_GlobalLogon");
                    if(globalLogInForm != null && typeof(globalLogInForm) != 'undefined'){
                        globalLogInForm.URL.value = redirectToPageName;
                    }
                }
            } else if (typeof isOnPasswordUpdateForm === 'undefined' || isOnPasswordUpdateForm == false) {
                if (!submitRequest()) {
                    return;
                }
                cursor_wait();
                wcRenderContext.updateRenderContext("GlobalLogin_context",{"displayContract":"false", "widgetId" : widgetId, "redirectToPageName": redirectToPageName} );
            }
        }
	},



    togglePanel: function (widgetNode) {
        // toggle the current active global login panel.
        if (this.activePanel[KEY_ACTIVE] != null && this.activePanel[KEY_SELECTED] != null) {
            $("#" + this.activePanel[KEY_ACTIVE]).toggleClass("active");
            $("#" + this.activePanel[KEY_SELECTED]).toggleClass("selected");

            //if the current active panel is not the caller
            if (this.activePanel[KEY_ACTIVE] != widgetNode.attr("id")) {
                var toggleControl = widgetNode.attr("data-toggle-control");
                //toggle current widget
                widgetNode.toggleClass("active");
                toggleControl.toggleClass("selected");

                //set the current caller as active
                this.activePanel[KEY_ACTIVE] = widgetNode.attr("id");
                this.activePanel[KEY_SELECTED] = toggleControl;
            } else {
                delete this.activePanel.active;
                delete this.activePanel.selected;
                widgetNode.attr("panel-loaded", false);
                this.unregisterMouseDown();
            }
        } else {
            var toggleControl = widgetNode.attr("data-toggle-control");
            //no panel is active. toggle the current
            widgetNode.toggleClass("active");
            $("#" + toggleControl).toggleClass("selected");

            //set the current caller as active
            this.activePanel[KEY_ACTIVE] = widgetNode.attr("id");
            this.activePanel[KEY_SELECTED] = toggleControl;
            this.registerMouseDown();
        }
    },

    updateGlobalLoginSignInContent: function (widgetId) {
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        var redirectToPageName = getCookie("WC_RedirectToPage_" + WCParamJS.storeId);
        if (redirectToPageName != undefined && redirectToPageName != null) {
            setCookie("WC_RedirectToPage_" + WCParamJS.storeId, null, {
                expires: -1,
                path: '/',
                domain: cookieDomain
            });
        }
        wcRenderContext.updateRenderContext("GlobalLogin_context",{"displayContract":"false", "widgetId": widgetId, "redirectToPageName": redirectToPageName});
    },

    updateGlobalLoginUserDisplay: function (displayName) {
        $("#Header_GlobalLogin_signOutQuickLinkUser").html(displayName);
    },

    updateGlobalLoginContent: function (widgetId) {
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        wcRenderContext.updateRenderContext("GlobalLogin_context",{"displayContract":"true", "widgetId": widgetId});
    },

    updateOrganization: function (formName, widgetId) {
        var orgSetInSessionURL = widgetId + '_' + 'orgSetInSessionURL';
        var orgSetInSessionURLEle = document.getElementById(orgSetInSessionURL);
        if (orgSetInSessionURLEle != null) {
            var href = document.location.href;
            orgSetInSessionURLEle.value = href;
        }
        var form = document.forms[widgetId + '_' + formName];
        if (!submitRequest()) {
            return;
        }
        processAndSubmitForm(form);
    },

    prepareSubmit: function (widgetId) {
        var idPrefix = widgetId + "_";
        if (document.getElementById(idPrefix + "signInDropdown") != null && document.getElementById(idPrefix + "signInDropdown").className.indexOf("active") > -1) {
            document.getElementById(idPrefix + "inlinelogonErrorMessage_GL_logonPassword").setAttribute("class", "errorLabel");
            document.getElementById(idPrefix + "inlineLogonErrorMessage_GL_logonId").setAttribute("class", "errorLabel");
            var form_input_field = document.getElementById(idPrefix + "WC_AccountDisplay_FormInput_logonId_In_Logon_1");
            if (form_input_field != null) {
                if (this.isEmpty(form_input_field.value)) {
                    document.getElementById(idPrefix + "inlineLogonErrorMessage_GL_logonId").className = document.getElementById(idPrefix + "inlineLogonErrorMessage_GL_logonId").className + " active";
                    return false;
                }
            }
            var form_input_field = document.getElementById(idPrefix + "WC_AccountDisplay_FormInput_logonPassword_In_Logon_1");
            if (form_input_field != null) {
                if (this.isEmpty(form_input_field.value)) {
                    document.getElementById(idPrefix + "inlinelogonErrorMessage_GL_logonPassword").className = document.getElementById(idPrefix + "inlinelogonErrorMessage_GL_logonPassword").className + " active";
                    return false;
                }
            }
        }
        return true;
    },

    /**
     * Checks if a string is null or empty.
     * @param (string) str The string to check.
     * @return (boolean) Indicates whether the string is empty.
     */
    isEmpty: function (str) {
        var reWhiteSpace = new RegExp(/^\s+$/);
        if (str == null || str == '' || reWhiteSpace.test(str)) {
            return true;
        }
        return false;
    },

    /**
     * Updates the contract that is available to the current user.
     * @param {string} formName  The name of the form that contains the selected contracts.
     */
    updateContract: function (formName) {
        var form = document.forms[formName];

        /* For Handling multiple clicks. */
        if (!submitRequest()) {
            return;
        }

        form.submit();
    },

    deleteUserLogonIdCookie: function (contractURL) {
        var userLogonIdCookie = getCookie("WC_LogonUserId_" + WCParamJS.storeId);
        if (userLogonIdCookie != null) {
            setCookie("WC_LogonUserId_" + WCParamJS.storeId, null, {
                expires: -1,
                path: '/',
                domain: cookieDomain
            });
        }
    },

    changeRememberMeState: function (jspStoreImgDir, target) {
        var targetEle = document.getElementById(target);
        if (targetEle.className.indexOf("active") > -1) {
            targetEle.className = targetEle.className.replace('active', '');
            targetEle.setAttribute("aria-checked", "false");
            targetEle.setAttribute("src", jspStoreImgDir + "images/checkbox.png");
            document.getElementById(target.replace("_img", "")).setAttribute("value", "false");
        } else {
            targetEle.className = targetEle.className + " active";
            targetEle.setAttribute("src", jspStoreImgDir + "images/checkbox_checked.png");
            targetEle.setAttribute("aria-checked", "true");
            document.getElementById(target.replace("_img", "")).setAttribute("value", "true");
        }
    },

    deleteLoginCookies: function () {
        this.deleteUserLogonIdCookie();
        setCookie("WC_BuyOnBehalf_" + WCParamJS.storeId, null, {
            path: '/',
            expires: -1,
            domain: cookieDomain
        });
    },

    /**
     * Submit a global login sign in form
     * @param (object) widgetId The form widgetId id.
     */
    submitGLSignInForm: function (formId, widgetId) {
        service = wcService.getServiceById('globalLoginAjaxLogon');
        service.setFormId(formId);
        var params = {
            widgetId: widgetId
        };

        /*For Handling multiple clicks. */
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        wcService.invoke('globalLoginAjaxLogon', params);
    },

    /**
     * After successful login and setting a contract in session, we need to process the action that the shopper
     * was performing before signing in. It will do nothing if shopper was not trying to perform any actions.
     */
    processNextURL: function () {
        var myNextURL = getCookie("WC_nextURL_" + WCParamJS.storeId);
        if (myNextURL != undefined && myNextURL.length > 0) {
            myNextURL = myNextURL.replace(/&amp;/g, "&");
            if (myNextURL.indexOf('AjaxRESTOrderItemAdd') != -1) {
                invokeItemAdd(myNextURL);
            } else {
                invokeOtherService(myNextURL);
            }
        }
    },

    registerMouseDown: function () {
        if (!this.mouseDownConnectHandle) {
            $(document.documentElement).on("mousedown", $.proxy(this.handleMouseDown, this));
            this.mouseDownConnectHandle = true;
        }
    },

    unregisterMouseDown: function () {
        if (this.mouseDownConnectHandle) {
            $(document.documentElement).off("mousedown");
            this.mouseDownConnectHandle = false;
        }
    },

    handleMouseDown: function (evt) {
        if (this.activePanel[KEY_ACTIVE] != null && this.activePanel[KEY_SELECTED] != null) {
            Utils.ifSelectorExists("#" + this.activePanel[KEY_ACTIVE], function(widgetNode) {
                var toggleControl = $("#" + this.activePanel[KEY_SELECTED]);
                var node = evt.target;
                if (node != document.documentElement) {
                    var close = true;
                    while (node && node != document.documentElement) {
                        if (Utils.elementExists("#" + node.id + "_dropdown") && Utils.elementExists("#" + widgetNode.id + "_numEntitledContracts") != null && $("#" + widgetNode.id + "_numEntitledContracts").val() > 0) {
                            var nodePosition = Utils.position(node),
                                windowHeight = window.innerHeight,
                                newHeight;
                            if (windowHeight - nodePosition.y > nodePosition.y) {
                                newHeight = windowHeight - nodePosition.y;
                            } else {
                                newHeight = nodePosition.y;
                            }
                            var dropdownHeight = $("#" + node.id + "_dropdown").get(0).clientHeight;
                            if (dropdownHeight > newHeight) {
                                $("#" + node.id + "_dropdown").css("height", newHeight + "px");
                            }
                        }
                        if (widgetNode.is(node) || toggleControl.is(node) || $(node).hasClass("dijitPopup")) {
                            close = false;
                            break;
                        }
                        node = node.parentNode;
                    }
                    node = null;
                    if (node == null) {
                        widgetNode.children("div").each(function(i, e) {
                            var position = Utils.position(e);
                            if (evt.clientX >= position.x && evt.clientX < position.x + position.w &&
                                evt.clientY >= position.y && evt.clientY < position.y + position.h) {
                                close = false;
                                return false; // breaks
                            }
                        });
                        if (Utils.elementExists("#" + widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2_dropdown") &&
                            $("#" + widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2_dropdown").css("display") != "none" &&
                            Utils.elementExists("#" + widgetNode.id + "_numEntitledContracts") && $("#" + widgetNode.id + "_numEntitledContracts").val() > 0) {
                            var nodePosition = Utils.position("#" + widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2"),
                                windowHeight = window.innerHeight,
                                newHeight;
                            if (windowHeight - nodePosition.y > nodePosition.y) {
                                newHeight = windowHeight - nodePosition.y;
                            } else {
                                newHeight = nodePosition.y;
                            }
                            var dropDown = $("#" + widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2_dropdown"),
                                dropdownHeight = dropDown.get(0).clientHeight;
                            if (dropdownHeight > newHeight) {
                                dropDown.css("height", newHeight + "px");
                            }
                        }
                    }
                    if (close) {
                        this.togglePanel(widgetNode);
                    }
                }
            }, this);
        }
    }
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

$(document).ready(function () {
    window.setTimeout(function () {
        var href = document.location.href,
            index = href.lastIndexOf("s", 4),
            widgetId = 'Header_GlobalLogin';
        if (window.matchMedia && window.matchMedia("(max-width: 390px)").matches) {
            var widgetId = 'QuickLinks_GlobalLogin';
        }
        var idPrefix = widgetId + "_";

        //update the visible sign in link 		
        // TODO: test
        if ($("#" + idPrefix + "signInQuickLink").length) {
            if (index != -1) {
                var displaySignInPanel = getCookie("WC_DisplaySignInPanel_" + WCParamJS.storeId);
                if (displaySignInPanel != undefined && displaySignInPanel != null && displaySignInPanel.toString() == "true") {
                    GlobalLoginJS.updateGlobalLoginSignInContent(widgetId);
                    setCookie("WC_DisplaySignInPanel_" + WCParamJS.storeId, null, {
                        expires: -1,
                        path: '/',
                        domain: cookieDomain
                    });
                }
            }
        } else {
            var logonUserCookie = getCookie("WC_LogonUserId_" + WCParamJS.storeId);
            if (logonUserCookie != undefined && logonUserCookie != null && logonUserCookie != "") {
                var logonUserName = logonUserCookie.toString(),
                //update both the sign out links
                    widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                if (Utils.existsAndNotEmpty(widgetIds)) {
                    // TODO: test
                    widgetIds.forEach(function(registeredWidgetId) {
                        var idPrefix = registeredWidgetId + "_";

                        if ($("#" + idPrefix + "signOutQuickLink").length) {
                            var logonUserName = logonUserCookie.toString();
                            $("#" + idPrefix + "signOutQuickLinkUser").html(escapeXml(logonUserName, true));
	                        
                            if (Utils.varExists(GlobalLoginShopOnBehalfJS)) {
                                GlobalLoginShopOnBehalfJS.updateSignOutLink(registeredWidgetId);
                            }
                        }
                    });
                }
            }
            var displayContractPanel = getCookie("WC_DisplayContractPanel_" + WCParamJS.storeId);
            if ((displayContractPanel != undefined && displayContractPanel != null && displayContractPanel.toString() == "true") || (logonUserCookie == undefined && logonUserCookie == null)) {
                if (typeof isOnPasswordUpdateForm === 'undefined' || isOnPasswordUpdateForm == false) {
                    //Right after user logged in, perform Global Login Ajax call and display Global Login Contract panel.				
                    GlobalLoginJS.updateGlobalLoginContent(widgetId);
                } else if (isOnPasswordUpdateForm == true) {
                    GlobalLoginJS.updateGlobalLoginUserDisplay("...");
                }

            }
        }
    }, 100);
});//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

function declareSignInRefreshArea (thisRefreshAreaId) {
    // ============================================
    // common render context
    if (!wcRenderContext.checkIdDefined("GlobalLogin_context")) {
        wcRenderContext.declare("GlobalLogin_context", [thisRefreshAreaId], {"displayContract":"false"});
    } else {
        wcRenderContext.addRefreshAreaId("GlobalLogin_context", thisRefreshAreaId);
    }

    // render content changed handler
    var renderContextChangedHandler = function() {
        var renderContext = wcRenderContext.getRenderContextProperties("GlobalLogin_context");
        if(renderContext['widgetId'] == thisRefreshAreaId){
            $("#"+thisRefreshAreaId).refreshWidget("refresh",renderContext);
        }
    };

    // post refresh handler
    var postRefreshHandler = function() {
        cursor_clear();
        $("#" + thisRefreshAreaId).attr("panel-loaded", true);
        //Quick links
        if (window.matchMedia && window.matchMedia("(max-width: 390px)").matches) {
            $("#quickLinksButton").addClass("selected");
            $("#quickLinksMenu").addClass("active");
        }
        //toggle the panel
        GlobalLoginJS.displayPanel(thisRefreshAreaId);
        $("#" + thisRefreshAreaId + "_signInDropdown").focus();
    };

    // initialize widget
    $("#"+thisRefreshAreaId).refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});

}

function declareSignOutRefreshArea(thisRefreshAreaId) {
    if (!wcRenderContext.checkIdDefined("GlobalLogin_context")) {
        wcRenderContext.declare("GlobalLogin_context", [thisRefreshAreaId], {"displayContract":"false"});
    } else {
        wcRenderContext.addRefreshAreaId("GlobalLogin_context", thisRefreshAreaId);
    }

    var renderContextChangedHandler = function() {
        var renderContext = wcRenderContext.getRenderContextProperties("GlobalLogin_context");
        if(renderContext['widgetId'] == thisRefreshAreaId){
            $("#"+thisRefreshAreaId).refreshWidget("refresh",renderContext);
        }
    };

    wcTopic.subscribe("RunAsUserSetInSession", function(message) {
        if(message.actionId == 'RunAsUserSetInSession' ){
            if (Utils.varExists(GlobalLoginShopOnBehalfJS)) {
                GlobalLoginShopOnBehalfJS.updateSignOutLink(thisRefreshAreaId);
                GlobalLoginShopOnBehalfJS.initializePanels();
            }
        }
    });

    var postRefreshHandler = function() {
        cursor_clear();
        $("#" + thisRefreshAreaId).attr("panel-loaded", true);

        var idPrefix = thisRefreshAreaId + "_";

        //initialize the caller Id for filtering it from the search results
        if (Utils.varExists(GlobalLoginShopOnBehalfJS)) {
            Utils.ifSelectorExists("#" + idPrefix + "callerId", function(hiddenField) {
                GlobalLoginShopOnBehalfJS.setCallerId(hiddenField.val());
            });
        }

        var userDisplayNameField = $("#" + idPrefix + "userDisplayNameField");
        //get the user name from the display name field.
        if (userDisplayNameField !== null) {
            //clear the old cookie and write it afresh.
            var logonUserCookie = getCookie("WC_LogonUserId_" + WCParamJS.storeId);
            if (logonUserCookie != null) {
                setCookie("WC_LogonUserId_" + WCParamJS.storeId, null, {
                    expires: -1,
                    path: '/',
                    domain: cookieDomain
                });
            }
            setCookie("WC_LogonUserId_" + WCParamJS.storeId, userDisplayNameField.val(), {
                path: '/',
                domain: cookieDomain
            });

            var updateLogonUserCookie = getCookie("WC_LogonUserId_" + WCParamJS.storeId);
            if (updateLogonUserCookie !== 'undefined' && updateLogonUserCookie.length) {
                logonUserName = updateLogonUserCookie.toString();
            } else {
                logonUserName = userDisplayNameField.val();
            }
            var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
            if (Utils.existsAndNotEmpty(widgetIds)) {
                widgetIds.forEach(function(registeredWidgetId) {
                    idPrefix = registeredWidgetId + "_";
                    Utils.ifSelectorExists("#" + idPrefix + "signOutQuickLink", function(signOutLink) {
                        $("#" + idPrefix + "signOutQuickLinkUser").html(escapeXml(logonUserName, true));

                        if (Utils.varExists(GlobalLoginShopOnBehalfJS)) {
                            GlobalLoginShopOnBehalfJS.updateSignOutLink(registeredWidgetId);
                            GlobalLoginShopOnBehalfJS.initializePanels();
                        }
                    });
                });
            }
        }
		
		var displayContractPanel = getCookie("WC_DisplayContractPanel_" + WCParamJS.storeId);
		var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
		var tempIdPrefix = "";
        if (Utils.existsAndNotEmpty(widgetIds)) {
            widgetIds.forEach(function(registeredWidgetId) {
				tempIdPrefix = registeredWidgetId + "_";
				Utils.ifSelectorExists("#" + tempIdPrefix + "activeContractIdsArrayLength", function(activeContractsInput) {
					idPrefix = registeredWidgetId + "_";
                });
			});
			var activeContractIdsArrayLength = $("#" + idPrefix + "activeContractIdsArrayLength");
			if (activeContractIdsArrayLength != null && activeContractIdsArrayLength.value > 1 && (displayContractPanel == undefined || displayContractPanel == null)) {
				setCookie("WC_DisplayContractPanel_" + WCParamJS.storeId, "true", {
					path: '/',
					domain: cookieDomain
				});
				window.location = $("#" + idPrefix + "setFirstContractInSessionURLField").val();
				return;
			}
        }
		
        if (displayContractPanel != undefined && displayContractPanel != null && displayContractPanel.toString() == "true") {
            setCookie("WC_DisplayContractPanel_" + WCParamJS.storeId, null, {
                expires: -1,
                path: '/',
                domain: cookieDomain
            });
        }
        GlobalLoginJS.processNextURL();

        //Display the sign out drop down panel on quick link when view is below 390px.
        if (window.matchMedia("(max-width: 390px)").matches) {
            $("#quickLinksButton").addClass("selected");
            $("#quickLinksMenu").addClass("active");
        }
        GlobalLoginJS.displayPanel(thisRefreshAreaId);
        $("#" + thisRefreshAreaId + "_loggedInDropdown").focus();
    };

    // initialize widget
    $("#"+thisRefreshAreaId).refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});

}
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript is used by the Global Login widget to handle the services
 * @version 1.10
 */

/* global document, window, $, wc, Utils, WCParamJS, MessageHelper, cursor_clear, getAbsoluteURL */


/**
 * This service allows customer to sign in
 * @constructor
 */
wcService.declare({
    id: "globalLoginAjaxLogon",
    actionId: "globalLoginAjaxLogon",
    url: getAbsoluteURL() + "AjaxLogon",
    formId: "",

    /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    successHandler: function (serviceResponse) {
        cursor_clear();
        var errorMessage = "";
        if (serviceResponse.ErrorCode != null) {
            var errorCode = Number(serviceResponse.ErrorCode);
            switch (errorCode) {
            case 2000:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2000"];
                break;
            case 2010:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2010"];
                break;
            case 2020:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2020"];
                break;
            case 2030:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2030"];
                break;
            case 2110:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2110"];
                break;
            case 2300:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2300"];
                break;
            case 2340:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2340"];
                break;
            case 2400:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2400"];
                break;
            case 2410:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2410"];
                break;
            case 2420:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2420"];
                break;
            case 2430:
                document.location.href = "ResetPasswordForm?storeId=" + WCParamJS.storeId + "&catalogId=" + WCParamJS.catalogId + "&langId=" + WCParamJS.langId + "&errorCode=" + errorCode;
                break;
            case 2170:
                document.location.href = "ChangePassword?storeId=" + WCParamJS.storeId + "&catalogId=" + WCParamJS.catalogId + "&langId=" + WCParamJS.langId + "&errorCode=" + errorCode + "&logonId=" + serviceResponse.logonId;
                break;
            case 2570:
                errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2570"];
                    break;
                case 2440:
                    errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2440"];
                    break;
                case 2450:
                    errorMessage = MessageHelper.messages["GLOBALLOGIN_SIGN_IN_ERROR_2450"];
                    break;
            }
            if (document.getElementById(serviceResponse.widgetId + "_logonErrorMessage_GL") != null) {
                document.getElementById(serviceResponse.widgetId + "_logonErrorMessage_GL").innerHTML = errorMessage;
                document.getElementById(serviceResponse.widgetId + "_WC_AccountDisplay_FormInput_logonId_In_Logon_1").setAttribute("aria-invalid", "true");
                document.getElementById(serviceResponse.widgetId + "_WC_AccountDisplay_FormInput_logonId_In_Logon_1").setAttribute("aria-describedby", "logonErrorMessage_GL_alt");
                document.getElementById(serviceResponse.widgetId + "_WC_AccountDisplay_FormInput_logonPassword_In_Logon_1").setAttribute("aria-invalid", "true");
                document.getElementById(serviceResponse.widgetId + "_WC_AccountDisplay_FormInput_logonPassword_In_Logon_1").setAttribute("aria-describedby", "logonErrorMessage_GL_alt");
            }
        } else {

            var url = serviceResponse.URL[0].replace(/&amp;/g, '&'),
                languageId = serviceResponse.langId;
            if (languageId != null && document.getElementById('langSEO' + languageId) != null) { // Need to switch language.

                var browserURL = document.location.href,
                    currentLangSEO = '/' + $('#currentLanguageSEO').val() + '/';

                if (browserURL.indexOf(currentLangSEO) !== -1) {
                    // If it's SEO URL.
                    var preferLangSEO = '/' + $('#langSEO' + languageId).val() + '/';

                    var query = url.substring(url.indexOf('?') + 1, url.length),
                        parameters = Utils.queryToObject(query);
                    if (parameters["URL"] != null) {
                        var redirectURL = parameters["URL"],
                            query2 = redirectURL.substring(redirectURL.indexOf('?') + 1, redirectURL.length),
                            parameters2 = Utils.queryToObject(query2);
                        // No redirect URL
                        if (parameters2["URL"] != null) {
                            var finalRedirectURL = parameters2["URL"];
                            if (finalRedirectURL.indexOf(currentLangSEO) != -1) {
                                // Get the prefer language, and replace with prefer language.
                                finalRedirectURL = finalRedirectURL.replace(currentLangSEO, preferLangSEO);
                                parameters2["URL"] = finalRedirectURL;
                            }
                            query2 = $.param(parameters2);
                            redirectURL = redirectURL.substring(0, redirectURL.indexOf('?')) + '?' + query2;
                        } else {
                            //Current URL is the final redirect URL.
                            redirectURL = redirectURL.toString().replace(currentLangSEO, preferLangSEO);
                        }
                        parameters["URL"] = redirectURL;
                    }
                    query = $.param(parameters);
                    url = url.substring(0, url.indexOf('?')) + '?' + query;

                } else {
                    // Not SEO URL.
                    // Parse the parameter and check whether if have langId parameter.
                    if (url.contains('?')) {
                        var query = url.substring(url.indexOf('?') + 1, url.length),
                            parameters = Utils.queryToObject(query);
                        if (parameters["langId"] != null) {
                            parameters["langId"] = languageId;
                            var query2 = $.param(parameters);
                            url = url.substring(0, url.indexOf('?')) + '?' + query2;
                        } else {
                            url = url + "&langId=" + languageId;
                        }
                    } else {
                        url = url + "?langId=" + languageId;
                    }
                }
            }

            if (serviceResponse["MERGE_CART_FAILED_SHOPCART_THRESHOLD"] == "1") {
                setCookie("MERGE_CART_FAILED_SHOPCART_THRESHOLD", "1", {path: "/", domain: cookieDomain});
            }
            window.location = url;
        }
    },

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    failureHandler: function (serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        } else {
            if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        }
        cursor_clear();
    }
});//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/* global KeyCodes */
var SEARCH_CRITERIA_LAST_NAME = "lastName";

GlobalLoginShopOnBehalfJS = {

    //The topic to subscribe to
    USER_SEARCH_CRITERIA_TOPIC: "userSearchCriteriaChanged",

    firstNameSearchType: 3,

    lastNameSearchType: 3,

    updateTimer: null,

    //The timeout value
    timeOut: 1000,

    buyerSearchURL: "",

    loadedPanels: {},

    callerId: "",

    logoutURL: null,

    redirectURL: null,

    buyerData: [],

    /**
     *Sets the id of the Admin who is calling on behalf of buyer
     *@param callerId The id of the buyer admin   
     */
    setCallerId: function (callerId) {
        this.callerId = callerId;
    },

    /**
     *Sets the REST URL to be used for finding buyers
     *@param buyerSearchURL The REST URL   
     */
    setBuyerSearchURL: function (buyerSearchURL) {
        this.buyerSearchURL = buyerSearchURL;
    },

    /**
     *This method registers the panels loaded on the page.
     *@param shopOnBehalfPanelId The panel which shows the shopping on behalf options
     *@param shopForSelfPanelId the corresponding panel which shows the shop for self options.      
     */
    registerShopOnBehalfPanel: function (shopOnBehalfPanelId, shopForSelfPanelId) {
        this.loadedPanels[shopOnBehalfPanelId] = shopForSelfPanelId;
    },

    /**
     *This method checks if the current page is loaded in HTTPs.
     *@return true if the page was in HTTP; false, otherwise.   
     */
    isPageUsingHTTP: function () {
        var protocol = document.location.protocol;
        return (protocol == 'http:');
    },

    /**
     *This function reloads the page using HTTPS. Once the page is loaded, the shop on behalf
     *check box will be toggled.   
     */
    initHTTPSecure: function () {
        //reload the page with HTTPS and show the sign in panel
        var newHref = "https://" + document.location.host + document.location.pathname;
        if (Utils.existsAndNotEmpty(document.location.search)) {
            newHref = newHref + document.location.search;
        }
        //set these cookies to process the page once its reloaded.
        setCookie("WC_DisplayContractPanel_" + WCParamJS.storeId, true, {
            path: "/",
            domain: cookieDomain
        });
        setCookie("WC_ToogleOnBehalfPanel_" + WCParamJS.storeId, true, {
            path: "/",
            domain: cookieDomain
        });
        window.location.href = newHref;
        return;
    },

    /**
     *This method initializes the panels that have been registered.
     *It sets up the event listeners on these panels. This method is called
     *when the panels are loaded.              
     */
    initializePanels: function () {
        if (this.loadedPanels) {
            for (var shopOnBehalfPanelId in this.loadedPanels) {
                Utils.ifSelectorExists("#" + shopOnBehalfPanelId, function(shopOnBehalfPanel) {
                    this.initializePanel(shopOnBehalfPanelId, this.loadedPanels[shopOnBehalfPanelId]);
                }, this);
            }
        }

    },

    /**
     *This method initializes a panel. It setups the event listeners on the panel
     *@param shopOnBehalfPanelId The panel which shows the shopping on behalf options
     *@param shopForSelfPanelId the corresponding panel which shows the shop for self options.
     */
    initializePanel: function (shopOnBehalfPanelId, shopForSelfPanelId) {
        var isInitialized = $("#" + shopOnBehalfPanelId).attr("isEventsSetup");
        if (!isInitialized) {
            this.setUpEvents(shopOnBehalfPanelId);
            $("#" + shopOnBehalfPanelId).attr("isEventsSetup", true);

            //check the toggle button if the cookie has been set.
            var toogleOnBehalfPanel = getCookie("WC_ToogleOnBehalfPanel_" + WCParamJS.storeId);
            if (toogleOnBehalfPanel != null && toogleOnBehalfPanel) {
                this.toggleShopOnBehalfPanel(shopOnBehalfPanelId + "_shopOnBehalfCheckBox", shopForSelfPanelId, shopOnBehalfPanelId);

                //delete the cookie.
                setCookie("WC_ToogleOnBehalfPanel_" + WCParamJS.storeId, null, {
                    path: "/",
                    expires: -1
                });
            }
        }
        // TODO: test
        var callerId = "";
        Utils.ifSelectorExists("#" + shopOnBehalfPanelId + "_callerId", function(callerIdNode) {
            callerId = callerIdNode.html();
        });
        this.setCallerId(callerId);
    },

    /**
     * This method toggles the shop on behalf panel. If the page is loaded in HTTP,
     * this method reloads the page with HTTPs.
     *       
     * @param target The check box node
     * @param shopForSelfSectionId The ID of the panel which shows the shop for self options
     * @param shopOnBehalfOfSectionId The ID of the panel which shows the shop on behalf options          
     */
    toggleShopOnBehalfPanel: function (target, shopForSelfSectionId, shopOnBehalfOfSectionId) {
        if (this.isPageUsingHTTP()) {
            this.initHTTPSecure();
        } else {
            var $target = $("#" + target);
            if($target.length === 0) return;

            var targetSrc = $target.attr("src");
            if ($target.hasClass("uncheckedCheckBox")) {
                //shop on behalf is unchecked. Check it.
                $target.attr("src", targetSrc.replace("checkbox", "checkbox_checked"))
                    .removeClass("uncheckedCheckBox")
                    .addClass("checkedCheckBox");
                
                //show shop on behalf options.
                $("#" + shopForSelfSectionId).css('display', 'none');
                $("#" + shopOnBehalfOfSectionId).css('display', 'block');
            } else {
                //shop on behalf is checked. Uncheck it.
                $target.attr("src", targetSrc.replace("checkbox_checked", "checkbox"))
                    .removeClass("checkedCheckBox")
                    .addClass("uncheckedCheckBox");
                
                //show show for self options.
                $("#" + shopOnBehalfOfSectionId).css('display', 'none');
                $("#" + shopForSelfSectionId).css('display', 'block');
            }
        }
    },

    /**
     * Sets up events for the user search text box.
     * @param shopOnBehalfOfSectionId The shop on behalf panel Id
     */
    setUpEvents: function (shopOnBehalfOfSectionId) {
        var eventName = 'keyup',
            scope = this;
        $(document).ready(function () {
            var textBox = shopOnBehalfOfSectionId + "_buyerUserName",
                searchErrorLabel = shopOnBehalfOfSectionId + "_errorLabel";
            console.debug("Setting up  on " + eventName + " event for DOM element = " + textBox + ". ", "Topic = " + scope.USER_SEARCH_CRITERIA_TOPIC);
            Utils.ifSelectorExists("#" + textBox, function(textBoxObj) {
                wcTopic.subscribe(scope.USER_SEARCH_CRITERIA_TOPIC, function (data) {
                    //read the search input text and clear the timer.
                    data["buyerSearchInput"] = textBoxObj.val();
                    console.debug("Clearing previous timers and starting a new one. Search results will updated after " + scope.timeOut + " milliSeconds.", data);
                    clearTimeout(scope.updateTimer);
                    scope.updateTimer = setTimeout(function() {
                        scope.updateSearchResults(data);
                    }, scope.timeOut);
                });
                
                textBoxObj.on(eventName, function (event) {
                    //get the text box value and publish the data
                    var data = {
                        "buyerSearchInput": textBoxObj.val(),
                        "data-parent": textBoxObj.attr("data-parent"),
                        "originator": textBoxObj.attr("id"),
                        'searchErrorLabel': searchErrorLabel
                    };
                    console.debug("publishing ", data);
                    if (event.keyCode === KeyCodes.TAB) {
                        return;
                    } 
                    wcTopic.publish(scope.USER_SEARCH_CRITERIA_TOPIC, data);
                });
            });
        });
    },

    /**
     *This method processes the search criteria input by the user and triggers a search.
     *@param searchCriteria The raw search criteria input
     */
    updateSearchResults: function (searchCriteria) {
        console.debug("User input : ", searchCriteria.buyerSearchInput);
        //break down the search input into first name and last name.
        if (searchCriteria.buyerSearchInput !== 'undefined') {
            var searchInput = new String(searchCriteria.buyerSearchInput),
                lastName = searchInput;
            searchCriteria[SEARCH_CRITERIA_LAST_NAME] = lastName;

            this.performSearch(searchCriteria);
        }
    },

    /**
     *This method performs the buyer user search based on the search criteria specified.
     *@searchCriteria The search criteria   
     */
    performSearch: function (searchCriteria) {
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        var lastName = searchCriteria[SEARCH_CRITERIA_LAST_NAME];
        var previousLastName = renderContextProperties["previousLastName"];
        //search only when the previous first name or last name dont match the current
        if (lastName != previousLastName && lastName !== '') {
            //save the current search criteria as previous in the render context.
            renderContextProperties['previousLastName'] = lastName;

            $("#" + searchCriteria['originator'] + "Error").css("display", "none");
            
            setCurrentId(searchCriteria['originator']);

            //perform the search
            if (!submitRequest()) {
                return;
            }
            cursor_wait();

            //The REST service uses a GET.
            $.ajax({
                url: GlobalLoginShopOnBehalfJS.buyerSearchURL,
                dataType: "json",
                data: {
                    'lastName': lastName,
                    'lastNameSearchType': GlobalLoginShopOnBehalfJS.lastNameSearchType
                },
                headers: {
                    'Content-Type': 'text/plain; charset=utf-8'
                },
                context: this,
                success: function (response, textStatus, jqXHR) {
                    cursor_clear();
                    this.displaySearchResults(response, searchCriteria);
                },
                error: function(jqXHR, textStatus, err) {
                    cursor_clear();
                    err['errorCode'] = 'GENERICERR_MAINTEXT';
                    this.handleError(err, searchCriteria);
                }
            });
        } else {
            console.debug('input has not changed');
        }
    },

    /**
     *This method displays the user search results.
     *@param searchResults The result set 
     *@param searchCriteria The search criteria used for search.
     */
    displaySearchResults: function (searchResults, searchCriteria) {
        console.debug('Search results :', searchResults);
        var scope = this,
            $errorLabel = $("#" + searchCriteria.searchErrorLabel);
        //set up the buyer data for the search results drop down.
        var dropdownData = [],
            lastNameFirst = Utils.arrContains(['ja-jp', 'ko-kr', 'zh-cn', 'zh-tw'], Utils.getLocale());
        if (searchResults != null && Utils.existsAndNotEmpty(searchResults.userDataBeans)) {
            $errorLabel.removeClass("active");
            for (var i = 0; i < searchResults.userDataBeans.length; i++) {
                var userEntry = searchResults.userDataBeans[i];
                userEntry.displayName = "";

                var userFirstName = '',
                    userLastName = '';
                
                if (Utils.notNullOrWhiteSpace(userEntry.firstName)) {
                    userFirstName = lastNameFirst ? " " + userEntry.firstName : userEntry.firstName + " ";
                }
                
                if (Utils.notNullOrWhiteSpace(userEntry.lastName)) {
                    userLastName = userEntry.lastName;
                }
                userEntry.displayName = lastNameFirst ? userLastName + userFirstName : userFirstName + userLastName;
                
                userEntry.fullName = $.trim(userEntry.displayName);

                userEntry.displayName += " (" + userEntry.logonId + ")";
                
                userEntry.displayName = $.trim(userEntry.displayName);

                if(userEntry.userId !== scope.callerId) {
                    dropdownData.push(userEntry.displayName);
                }
            }
            this.buyerData = searchResults.userDataBeans;
        } else {
            $errorLabel.addClass('active');
        }

        //set the buyerData to the buyer user dropdown
        var $autocomplete = $("#" + searchCriteria['originator']);
        $autocomplete.autocomplete({
            "source": dropdownData,
            "select": function (event, ui) {
                        GlobalLoginShopOnBehalfJS.selectUser(event.target, ui.item.value);
                    }
        });
        $autocomplete.autocomplete("search", $autocomplete.val());
    },

    /**
     *This method displays the error when the search fails.
     *@param error Error data
     *@param searchCriteria The original search criteria      
     */
    handleError: function (error, nodeToDisplayError) {
        console.debug('An error occurred while searching for users ', error);
        var errorMessage = null;
        if (error.errorMessage != null) {
            errorMessage = error.errorMessage;
        } else if (error.errorMessageKey != null) {
            errorMessage = Utils.getLocalizationMessage(error.errorMessageKey);
        } else if (error.errorCode != null) {
            errorMessage = Utils.getLocalizationMessage(error.errorCode);
        }
        if (errorMessage == null || errorMessage === "") {
            errorMessage = Utils.getLocalizationMessage('GENERICERR_MAINTEXT');
        }
        // TODO: test
        $("#" + nodeToDisplayError).html(errorMessage)
            .css("display", "block");
    },

    /**
     *This method is invoked when the admin selects the user.
     *This method invokes the RunAsUserSetInSessionService and refreshes the panel to indicate the buyer
     *@param userDropDown The drop down node.
     *@param selectedUserName The selected user display name.
     */
    selectUser: function (userDropDown, selectedUserName) {
        var $searchUsersBox = $("#" + userDropDown.id);
        var selectedUser = $.grep(this.buyerData, function(e){ return e.displayName === selectedUserName; })[0];
        if (selectedUser != null && selectedUser.userId !== '-1') {
            var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
            renderContextProperties["selectedUser"] = selectedUser;
            renderContextProperties["shopOnBehalfPanelId"] = $searchUsersBox.attr('data-parent');
            renderContextProperties["shopForSelfPanelId"] = this.loadedPanels[$searchUsersBox.attr('data-parent')];

            setCurrentId(userDropDown.id);
            if (!submitRequest()) {
                return;
            }
            cursor_wait();
            var shopOnBehalfATForm = document.forms["shopOnBehalf_AuthTokenInfo"];
            var authToken = shopOnBehalfATForm.shopOnBehalf_AuthToken.value;
            wcService.invoke("RunAsUserSetInSessionService", {
                'runAsUserId': selectedUser.userId,
                'authToken': authToken
            });
        }
    },

    /**
     *This method is invoked when the RunAsUserSetInSessionService is successful.
     *It refreshes the panel
     */
    onUserSetInSession: function () {
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        var selectedUser = renderContextProperties["selectedUser"];

        //write the cookie.
        setCookie("WC_BuyOnBehalf_" + WCParamJS.storeId, escapeXml(selectedUser.fullName, true), {
            path: '/',
            domain: cookieDomain
        });
        var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
        if (widgetIds != null && widgetIds.length > 0) {
            for (var i = 0; i < widgetIds.length; i++) {
                this.updateSignOutLink(widgetIds[i]);
            }
        }
        setDeleteCartCookie();
        //instead of refreshing the panel, we refresh the page to my account page to update the my account links.
        setCookie("WC_DisplayContractPanel_" + WCParamJS.storeId, true, {
            path: "/",
            domain: cookieDomain
        });
        document.location.href = "AjaxLogonForm?storeId=" + WCParamJS.storeId + "&catalogId=" + WCParamJS.catalogId + "&langId=" + WCParamJS.langId + "&myAcctMain=1";
    },

    /**
     *This method is invoked when the user chooses an organization.
     *It invokes the OrganizationSetInSessionService service.
     *      
     *@param The organization drop down node
     */
    updateOrganization: function (organizationNode) {
        var organizationDropDown = $("#" + organizationNode.id)[0];
        var organizationSelected = organizationDropDown.value;
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        renderContextProperties["shopOnBehalfPanelId"] = organizationDropDown['data-parent'];
        renderContextProperties["shopForSelfPanelId"] = this.loadedPanels[organizationDropDown['data-parent']];

        setCurrentId(organizationNode.id);
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        wcService.invoke("OrganizationSetInSessionService", {
            'activeOrgId': organizationSelected
        });
    },

    /**
     *This method is invoked when the user chooses a contract.
     *It invokes the ContractSetInSessionService service.  
     *   
     *@param contractNode The contract drop down node.
     */
    updateContract: function (contractNode) {
        var contractDropDown = $("#" + contractNode.id)[0];
        var contractSelected = contractDropDown.value;
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        renderContextProperties["shopOnBehalfPanelId"] = contractDropDown['data-parent'];
        renderContextProperties["shopForSelfPanelId"] = this.loadedPanels[contractDropDown['data-parent']];

        setCurrentId(contractDropDown.id);
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        wcService.invoke("ContractSetInSessionService", {
            'contractId': contractSelected
        });
    },

    /**
     *This method clears the user set in session. It restores the session to that of the buyer admin and redirects the user to redirectURL
     */
    clearUserSetInSession: function (link, redirectURL) {
        if (link != null && link !== '') {
            setCurrentId(link.id);
        }
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        this.logoutURL = null;
        this.redirectURL = redirectURL;
        wcService.invoke("RestoreOriginalUserSetInSessionService");
    },

    /**
     * This method clears the user set in the session before logging off the buyer admin.
     */
    clearUserSetInSessionAndLogoff: function (logoutURL) {
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        this.logoutURL = logoutURL;
        this.redirectURL = null;
        wcService.invoke("RestoreOriginalUserSetInSessionService");
    },

    restoreCSRSessionAndRedirect: function (redirectURL) {
        GlobalLoginJS.deleteUserLogonIdCookie();
        GlobalLoginShopOnBehalfJS.deleteBuyerUserNameCookie();
        GlobalLoginShopOnBehalfJS.clearUserSetInSession('', redirectURL);
    },

    /**
     *This method is invoked when the for user session is successfully terminated.
     *This method reloads the current page.         
     */
    onRestoreUserSetInSession: function () {
        //clear the cookie
        setCookie("WC_BuyOnBehalf_" + WCParamJS.storeId, null, {
            path: '/',
            expires: -1,
            domain: cookieDomain
        });
        /* Page is getting reloaded.. Why to update the links now ?
				var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                if (widgetIds != null && widgetIds.length > 0){
                	for (var i = 0; i < widgetIds.length; i++) {
                		this.updateSignOutLink(widgetIds[i]);
                	}
                }*/
		setDeleteCartCookie();
		deleteOnBehalfRoleCookie();
		if (this.redirectURL == "-1"){
			// Stay on the same page.
			return;
		} else if (this.logoutURL == null && this.redirectURL == null) {
			//refresh the page, if it's not HTTPS
			if(!stringStartsWith(document.location.href, "https")){
				document.location.reload();
			} else {
				// Reload home page
				document.location.href =  WCParamJS.homePageURL;
			}

		} else if(this.redirectURL != null && this.redirectURL != "-1"){
			document.location.href = this.redirectURL;
		}
		else {
			logout(this.logoutURL);
        }
    },

    /**
     * This method updates the sign out link to display the buyer name.
     * This method is invoked once the buyer's session is established.
     */
    updateSignOutLink: function (widgetId) {
        var idPrefix = widgetId + "_";
        // TODO: test
        Utils.ifSelectorExists("#" + idPrefix + "signOutQuickLinkUser", function(signOutLink) {
            var logonUser = "",
                logonUserCookie = getCookie("WC_LogonUserId_" + WCParamJS.storeId);
            if (typeof logonUserCookie != 'undefined') {
                logonUser = logonUserCookie;
            }
            // TODO: test
            signOutLink.html(escapeXml(logonUser, true));
            var buyerUserName = "",
                buyOnBehalfCookie = getCookie("WC_BuyOnBehalf_" + WCParamJS.storeId);
            if (typeof buyOnBehalfCookie != 'undefined') {
                buyerUserName = escapeXml(buyOnBehalfCookie, true);
            }
            if (buyerUserName !== "") {
                // TODO: test
                signOutLink.append(" (" + buyerUserName + ")");
            }
        });
    },

    deleteBuyerUserNameCookie: function () {
        setCookie("WC_BuyOnBehalf_" + WCParamJS.storeId, null, {
            expires: -1,
            path: '/',
            domain: cookieDomain
        });
        var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
        if (widgetIds != null && widgetIds.length > 0) {
            for (var i = 0; i < widgetIds.length; i++) {
                this.updateSignOutLink(widgetIds[i]);
            }
        }
    },

    resetBuyerUserNameCookie: function (buyerUserName) {
        setCookie("WC_BuyOnBehalf_" + WCParamJS.storeId, escapeXml(buyerUserName, true), {
            path: '/',
            domain: cookieDomain
        });
        var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
        if (widgetIds != null && widgetIds.length > 0) {
            for (var i = 0; i < widgetIds.length; i++) {
                this.updateSignOutLink(widgetIds[i]);
            }
        }
    },

    resetDropdown: function (dropDownNode) {
        var $dropDown = $("#" + dropDownNode.id);
        if($dropDown.length) {
            $dropDown.val("");
        }
    },
    
    declareShopOnBehalfPanelRefreshArea: function(divId) {
        // ============================================
        // div: divId refresh area
        // 
        if(typeof divId === "object") {
            divId = divId[0];
        }
        
        var myWidgetObj = $("#"+divId);
        wcRenderContext.addRefreshAreaId("GlobalLoginShopOnBehalf_context", divId);
        var myRCProperties = wcRenderContext.getRenderContextProperties("GlobalLoginShopOnBehalf_context");
        
        /** 
         * Refreshes the Global Login panel.
         * This function is called when a render context event is detected. 
         */
        var renderContextChangedHandler = function () {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        };
        
        /** 
         * Clears the progress bar
         */
        var postRefreshHandler = function () {
            delete myRCProperties.selectedUser;
            delete myRCProperties.firstName;
            delete myRCProperties.lastName;
            delete myRCProperties.previousFirstName;
            delete myRCProperties.previousLastName;
            delete myRCProperties.showOnBehalfPanel;
            GlobalLoginShopOnBehalfJS.initializePanels();
            cursor_clear();
        }
         
        // initialize widget
        myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
    }

};

/**
 * Declares a new render context for initiating on behalf session
 */
wcRenderContext.declare("GlobalLoginShopOnBehalf_context", [], {'previousLastName': null, 'firstName': null, 'lastName': null});

/**
 *  Service declaration to invoke RunAsUserSetInSession command.
 *  @constructor
 */
wcService.declare({
    id: "RunAsUserSetInSessionService",
    actionId: "RunAsUserSetInSession",
    url: "AjaxRunAsUserSetInSession",
    formId: "",

    /**
     *  This method refreshes the panel 
     *  @param (object) serviceResponse The service response object, which is the
     *  JSON object returned by the service invocation.
     */
    successHandler: function (serviceResponse) {
        GlobalLoginShopOnBehalfJS.onUserSetInSession();
        cursor_clear();
    },

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    failureHandler: function (serviceResponse) {
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContextProperties["shopOnBehalfPanelId"] + "_ErrorField");
        cursor_clear();
    }

});

/**
 *  Service declaration to invoke OrganizationSetInSession command.
 *  @constructor
 */
wcService.declare({
    id: "OrganizationSetInSessionService",
    actionId: "OrganizationSetInSession",
    url: "AjaxOrganizationSetInSession",
    formId: "",

    /**
     *  @param (object) serviceResponse The service response object, which is the
     *  JSON object returned by the service invocation.
     */
    successHandler: function (serviceResponse) {
        console.debug("Organization set in session successfully");
        cursor_clear();
    }

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,
    failureHandler: function (serviceResponse) {
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContextProperties["shopOnBehalfPanelId"] + "_ErrorField");
        cursor_clear();
    }

});

/**
 *  Service declaration to invoke the ContractSetInSessionCmd
 *  @constructor
 */
wcService.declare({
    id: "ContractSetInSessionService",
    actionId: "ContractSetInSession",
    url: "AjaxContractSetInSession",
    formId: ""

    /**
     *  This method updates the order table with the 
     *  @param (object) serviceResponse The service response object, which is the
     *  JSON object returned by the service invocation.
     */
    ,
    successHandler: function (serviceResponse) {
        cursor_clear();
    }

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,
    failureHandler: function (serviceResponse) {
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContextProperties["shopOnBehalfPanelId"] + "_ErrorField");
        cursor_clear();
    }

});

/**
 *  Service declaration to invoke the ContractSetInSessionCmd
 *  @constructor
 */
wcService.declare({
    id: "RestoreOriginalUserSetInSessionService",
    actionId: "RestoreOriginalUserSetInSessionService",
    url: "AjaxRestoreOriginalUserSetInSession?" + getCommonParametersQueryString(),
    formId: "",

    /**
     *  This method updates the order table with the 
     *  @param (object) serviceResponse The service response object, which is the
     *  JSON object returned by the service invocation.
     */
    successHandler: function (serviceResponse) {
		if(typeof callCenterIntegrationJS != 'undefined' && callCenterIntegrationJS != undefined && callCenterIntegrationJS != null){
			var params = {};
			params.status = "success";
			params.serviceResponse = serviceResponse;
			callCenterIntegrationJS.postActionMessage(params,"TERMINATE_ON_BEHALF_SESSION_RESPONSE");
		}
        GlobalLoginShopOnBehalfJS.onRestoreUserSetInSession();
        cursor_clear();
    }

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,
    failureHandler: function (serviceResponse) {
		if(typeof callCenterIntegrationJS != 'undefined' && callCenterIntegrationJS != undefined && callCenterIntegrationJS != null){
			var params = {};
			params.status = "error";
			params.serviceResponse = serviceResponse;
			callCenterIntegrationJS.postActionMessage(params, "TERMINATE_ON_BEHALF_SESSION_RESPONSE");	
		}
        var renderContextProperties = wcRenderContext.getRenderContextProperties('GlobalLoginShopOnBehalf_context');
        GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContextProperties["shopOnBehalfPanelId"] + "_ErrorField");
        cursor_clear();
    }

});

//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2012, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides the render context used to display
 * the recommendations from Coremetrics Intelligent Offer. It also
 * contains the zone population function called with the results to
 * display.
 */

/** 
 * @class The IntelligentOfferJS class defines the render context used to display
 * the recommendations from Coremetrics Intelligent Offer.
 */
IntelligentOfferJS = {
	/* The common parameters used in service calls. */
	langId: "-1",
	storeId: "",
	catalogId: "",
	widgetsCurCount: 0,
	widgetsTotalCount: 0,
	
	/**
	 * This function initializes common parameters used in all service calls.
	 * @param {int} langId The language id to use.
	 * @param {int} storeId The store id to use.
	 * @param {int} catalogId The catalog id to use.
	 */
	setCommonParameters:function(langId,storeId,catalogId){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
	},

	/** 
	 * Declare the controller function for the Intelligent Offer Recommendations e-Marketing Spot refressh area.
	 * @param {array} contains wc site zone id and updateSwatch
	 */
	declareWC_IntelligentOfferESpot_controller: function(args) {
		var WC_zone = args[0];
		var updateSwatch = args[1];
		var contextId = "WC_IntelligentOfferESpot_context_ID_" + WC_zone;
		var containerId = "WC_IntelligentOfferESpot_container_ID_" + WC_zone;
		var myWidgetObj = $("#" + containerId);

		if (!wcRenderContext.checkIdDefined(contextId)) {
			wcRenderContext.declare(contextId, [], {partNumbers: "", zoneId: "", espotTitle: "", updateSwatch: updateSwatch});
		}
		wcRenderContext.addRefreshAreaId(contextId, containerId);
		var myRCProperties = wcRenderContext.getRenderContextProperties(contextId);
		
		// initialize widget
		myWidgetObj.refreshWidget({

			/** 
			 * Refreshes the Intelligent Offer Recommendations e-Marketing Spot area.
			 * This function is called when a render context changed event is detected. 
			 */
			renderContextChangedHandler: function() {
				myWidgetObj.refreshWidget("refresh", myRCProperties);
			},
			
			/** 
			 * Post handling for the Intelligent Offer Recommendations e-Marketing Spot area.
			 * This function is called after a successful refresh.
			 */
			postRefreshHandler: function() {
				cursor_clear();
				// updateSwatch should be set to true if swatches should be selected by default
				if(myRCProperties.updateSwatch === "true"){
					shoppingActionsJS.updateSwatchListView();
				}
				// need to process cm_cr tags
				cX("onload");
			}
		});
		this.widgetsTotalCount++;
	}
};

/**
 *  This function is the zone population function called by Coremetrics Intelligent Offer.
 *  It creates a comma separated list of the partnumbers to display, and then updates
 *  the refresh area that will display the recommendations.
 */
function io_rec_zp(a_product_ids,zone,symbolic,target_id,category,rec_attributes,target_attributes,target_header_txt) {
	if (symbolic !== '_NR_') {
		var n_recs = a_product_ids.length;
		var rec_part_numbers;
		for (var ii=0; ii < n_recs; ii++) {
			if (ii === 0) {
 				rec_part_numbers = a_product_ids[ii];
			} else {
				rec_part_numbers = rec_part_numbers + ',' + a_product_ids[ii];
			}
			
		}
		
		var zoneId = zone.replace(/\s+/g,'');
		wcRenderContext.updateRenderContext('WC_IntelligentOfferESpot_context_ID_' + zoneId, {'partNumbers':rec_part_numbers, 'zoneId': zoneId, 'espotTitle': target_header_txt});
	}
	else{
		var  rec_part_numbers;
		var zoneId = zone.replace(/\s+/g,'');
		target_header_txt = '';
		wcRenderContext.updateRenderContext('WC_IntelligentOfferESpot_context_ID_' + zoneId, {'partNumbers':rec_part_numbers, 'zoneId': zoneId, 'espotTitle': target_header_txt});
	}
};
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the My Account Navigation widget to control the refresh areas.
 * @version 1.2
 */

/**
 * Declares a new refresh controller for number of order approvals.
 */
var declareNumberOfOrderApprovalsController = function() {
    var myWidgetObj = $("#NumberOfOrderApprovals_Widget");
    
    /** 
	* Refreshes the number of order approvals display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	*/    	   
	wcTopic.subscribe(["AjaxApproveOrderRequest", "AjaxRejectOrderRequest", "AjaxApproveRequest", "AjaxRejectRequest"], function () {
	    myWidgetObj.refreshWidget("refresh");
	});
    
    myWidgetObj.refreshWidget({
        /** 
        * Refresh number of order approval display to keep it consistent with table
        * This function is called when a render context changed event is detected. 
        */
        renderContextChangedHandler: function() {
            // Do not refresh the count in Left Navigation bar, when the search criteria changes in the main table view.
            // Left Nav displays the count of orders to approve without any filter applied.
            //widget.refresh();
        },

        postRefreshHandler: function() {
            //cursor_clear();

        }
    });
};

/**
 * Declares a new refresh controller for number of buyer approvals.
 */
var declareNumberOfBuyerApprovalsController = function() {
    var myWidgetObj = $("#NumberOfBuyerApprovals_Widget");

    /** 
	* Refreshes the number of buyer approvals display if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	*/    	   
	wcTopic.subscribe(["AjaxApproveBuyerRequest", "AjaxRejectBuyerRequest", "AjaxApproveRequest", "AjaxRejectRequest"], function () {
		myWidgetObj.refreshWidget("refresh");
	});
    
    myWidgetObj.refreshWidget({
        /** 
        * Refresh number of buyer approval display to keep it consistent with table
        * This function is called when a render context changed event is detected. 
        */
        renderContextChangedHandler: function() {
            // Do not refresh the count in Left Navigation bar, when the search criteria changes in the main table view.
            // Left Nav displays the count of orders to approve without any filter applied.
        	//widget.refresh();
        },

        postRefreshHandler: function() {
            //cursor_clear();

        }
    });
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by order approval widget
 */

	OrderApprovalListJS = {
			
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
		
		/**
		* These variables define approve or reject status in the APRVSTATUS table. 1 for approved or 2 for rejected.
		*/
		cApproveStatus: 1,
		cRejectStatus: 2,
		
		/**
		* These variables refers to Ids of startSubmitDate and endSubmitDate element in OrderApprovalList_ToolBar_UI.jspf.
		*/
		formStartDateId: "",
		formEndDateId: "",
		
		/**
		 * Search tool bar Id
		 */
		toolbarId: "",
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters: function(langId,storeId,catalogId,requisitionListId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
		
		/**
		 * Sets the common parameters for the current page. 
		 *
		 * @param {String} formStartDateId The ID of the startDate element.
		 * @param {String} formEndDateId The ID of the endDate element.
		 * @param {String} toolbarId The ID of the tool bar element.
		 */
		setToolbarCommonParameters: function(formStartDateId,formEndDateId, toolbarId){
			this.formStartDateId = formStartDateId;
			this.formEndDateId = formEndDateId;
			this.toolbarId = toolbarId;
		},
		
		/**
		* Approves a order record
		* @param {Long} aprvstatus_id The id of the request to be approved
		*/
		approveOrder: function(aprvstatus_id) {
			service = wcService.getServiceById('AjaxApproveOrderRequest');

			var params = {
                storeId : this.storeId,
                catalogId : this.catalogId,
                langId : this.langId,
                aprv_act : this.cApproveStatus,
                approvalStatusId : aprvstatus_id,
                viewtask : "OrderApprovalView"
            };

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxApproveOrderRequest',params);		
		},

		/**
		* Rejects a order record
		* @param {Long} aprvstatus_id The id of the request to be approved
		*/
		rejectOrder: function(aprvstatus_id) {
			service = wcService.getServiceById('AjaxRejectOrderRequest');

			var params = {
			    storeId: this.storeId,
			    catalogId: this.catalogId,
			    langId: this.langId,
			    aprv_act: this.cRejectStatus,
			    approvalStatusId: aprvstatus_id,
			    viewtask: "OrderApprovalView"
			};

			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('AjaxRejectOrderRequest',params);
		},
		
		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = data[0]['pageNumber'],
                pageSize = data[0]['pageSize'];
			pageNumber = parseInt(pageNumber);
			pageSize = parseInt(pageSize);

			setCurrentId(data[0]["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();

			wcRenderContext.updateRenderContext('OrderApprovalTable_Context', {"beginIndex": beginIndex});
			MessageHelper.hideAndClearMessage();
		},
		
		
		/**
		 * Clear the context search term value set by search form
		 */
		reset:function(){
			this.updateContext({"beginIndex":"0", "orderId": "", "firstName": "", "lastName":"","startDate":"","endDate":""});
		},
		
		/**
		 * Search for buyer approval requests use the search terms specified in the toolbar search form.
		 * 
		 * @param (String) formId	The id of toolbar search form element.
		 */
		doSearch:function(formId){
			var form = $("#" + formId)[0],
                startDateValue = "",
                endDateValue = "",
                startDateWidgetValue = $("#" + this.formStartDateId + "_datepicker").datepicker("getDate");
			if (Utils.varExists(startDateWidgetValue)){
				startDateValue = startDateWidgetValue.toISOString().replace(/\.\d\d\dZ/, '+0000');
			}
			var endDateWidgetValue = $("#" + this.formEndDateId + "_datepicker").datepicker("getDate");
			if (Utils.varExists(endDateWidgetValue)){
				//add one day to the picked endDate.We pick a date the value for the date object
				//is yyyy-MM-dd 00:00:00(beginning of a day, we need it to be end of the a day)
				endDateWidgetValue = Utils.addDays(endDateWidgetValue, 1);
				//deduct one millisecond from the added date
				endDateWidgetValue = Utils.addMilliseconds(endDateWidgetValue, -1);
				endDateValue = endDateWidgetValue.toISOString().replace(/\.\d\d\dZ/, '+0000');
			}
			this.updateContext({
			    "beginIndex": "0",
			    "orderId": form.orderId.value.replace(/^\s+|\s+$/g, ''),
			    "firstName": form.submitterFirstName.value.replace(/^\s+|\s+$/g, ''),
			    "lastName": form.submitterLastName.value.replace(/^\s+|\s+$/g, ''),
			    "startDate": startDateValue,
			    "endDate": endDateValue
			});
		},
		
		/**
		 * Filter the buyer Approval list by status
		 * 
		 * @param (String) status The id of toolbar search form element.
		 */
		doFilter:function(status){
			this.updateContext({"beginIndex":"0", "approvalStatus": status});
		},
		
		/**
		 * Update the OrderApprovalTable_Context context with given context object.
		 * 
		 * @param (Object)context The context object to update
		 */
		updateContext:function(context){
			this.saveToolbarStatus();
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcRenderContext.updateRenderContext("OrderApprovalTable_Context", context);
			MessageHelper.hideAndClearMessage();
		},
		
		/**
		 * Save the toolbar aria-expanded attribute value
		 */
		saveToolbarStatus:function(){
            Utils.ifSelectorExists("#" + this.toolbarId, function($toolbar) {
                this.toolbarExpanded = $toolbar.attr("aria-expanded");
            }, this);
		},
		
		/**
		 * Restore the toolbar aria-expanded attribute, called by post-refresh handler
		 */
		restoreToolbarStatus:function(){
			if (Utils.varExists(this.toolbarExpanded)){
				$("#" + this.toolbarId).attr("aria-expanded", this.toolbarExpanded);
			}
		}
	}//-----------------------------------------------------------------
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

/** 
 * @fileOverview This file provides all the functions and variables to manage order lists and the items within.
 * This file is included in all pages with order list actions.
 */

/**
 * This class defines the functions and variables that customers can use to re-order processed orders.
 * @class The OrderListJS class defines the functions and variables that customers can use to manage their previous orders.
 */
OrderListJS = {
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

    /** This variable stores the ID of the newly created saved order. Its default value is empty. **/
    newOrderId : "",

    /** A boolean used to indicate if the current saved order was just deleted. Its default value is false. **/
    currentOrderDeleted : false,

    /** 
     * This array stores the quantities of each product in the order. Its default value is empty.
     * @private
     */
    quantityList: {},

    /** 
     * A boolean used to indicate if the current order list is saved order list. Its default value is false.
     * @private
     */
    savedOrder: false,

    /**
     * This variable stores the current dropdown dialog element.
     * @private
     */
    dropDownDlg: null,

    /**
     * This variable stores the expiry date of a subscription. For renewal, the start date is expiry date plus one day.
     */
    subscriptionDate: "",

    /**
     * This variable stores the orderId for subscription renewal
     */
    subscriptionOrderId: "",

    /**
     * This variable stores the orderItemId for subscription renewal
     */
    subscriptionOrderItemId: "",

    /**
     * Sets the common parameters for the current page. 
     * For example, the language ID, store ID, catalog ID, and whether it's saved order list.
     *
     * @param {Integer} langId The ID of the language that the store currently uses.
     * @param {Integer} storeId The ID of the current store.
     * @param {Integer} catalogId The ID of the catalog.
     * @param {Boolean} savedOrder The indicator of saved order list.
     */
    setCommonParameters:function(langId,storeId,catalogId,savedOrder){
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        this.savedOrder = savedOrder;
        cursor_clear();
    },

    /**
     * return a boolean value which indicates whether this is a saved order list
     */
    isSavedOrder: function () {
        return this.savedOrder;
    },

    /**
     * Initialize the URL of Saved Order List widget controller.
     *
     * @param {object} widgetUrl The controller's URL.
     */
    initOrderListUrl:function(widgetPrefix, widgetUrl){
        $("#" + widgetPrefix + "OrderListTable_Widget").refreshWidget("updateUrl", widgetUrl);
    },

    /**
     * set the subscriptionDate variable
     * @param {string} The expiry date of the subscription to be renewed.
     */
    setSubscriptionDate: function (value) {
        this.subscriptionDate = value;
    },

    /**
     * return a string which indicates the start date of the renewed subscription. The start date is one day plus the end date of that subscription.
     */
    getSubscriptionDate: function () {
        var year = parseInt(this.subscriptionDate.substring(0,4),10);
        var month = parseInt(this.subscriptionDate.substring(5,7),10);
        var date = parseInt(this.subscriptionDate.substring(8,10),10);

        if(month == 2){
            if((year % 4 == 0) && (year % 100 != 0) && (year % 400 == 0))
            {
                if(date != 29)
                {
                    date = date + 1;
                    if(date < 10)
                        date = "0" + date;
                    month = "02";
                }
                else
                {
                    date = "01";
                    month = "03";
                }
            }
            else
            {
                if(date != 28)
                {
                    date = date + 1;
                    if(date < 10)
                        date = "0" + date;
                    month = "02";
                }
                else
                {
                    date = "01";
                    month = "03";
                }
            }
        }
        else if(month == 12){
            if(date != 31)
            {
                date = date + 1;
                if(date < 10)
                    date = "0" + date;
                month = "12";
            }
            else
            {
                date = "01";
                month = "01";
                year = year + 1;
            }
        }
        else if(month == 4 || month == 6 || month == 9 || month == 11){
            if(date != 30)
            {
                date = date + 1;
                if(date < 10)
                    date = "0" + date;
            }
            else
            {
                date = "01";
                month = month + 1;
            }
            if(month < 10)
                month = "0" + month;
        }
        else{
            if(date != 31)
            {
                date = date + 1;
                if(date < 10)
                    date = "0" + date;
            }
            else
            {
                date = "01";
                month = month + 1;
            }
            if(month < 10)
                month = "0" + month;
        }

        var start = this.subscriptionDate.indexOf("T",0);
        var end = this.subscriptionDate.indexOf("Z",start);
        var appendString= this.subscriptionDate.substring(start+1,end);
        var newDateString = year+'-'+month+'-'+date+'T'+appendString+'Z';
        return(newDateString);
    },

    /**
     * This function sets the url for subscriptionrenew service and then it invokes the service to renew the subscription.
     * @param {string} SubscriptionCopyURL The url for the subscription copy service.
     */
    prepareSubscriptionRenew:function(SubscriptionCopyURL){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.getServiceById("SubscriptionRenew").setUrl(SubscriptionCopyURL);
        wcService.invoke("SubscriptionRenew");
    },

    /**
     * This function sets the url for ordercopy service and then it invokes the service to copy the old order.
     * @param {string} OrderCopyURL The url for the order copy service.
     */
    prepareOrderCopy:function(OrderCopyURL){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.getServiceById("OrderCopy").setUrl(OrderCopyURL);
        wcService.invoke("OrderCopy");
    },

    /**
     * This function sets the url for ssfs order copy service and then it invokes the service to copy the old order.
     * @param {string} SSFSOrderCopyUrl The url for the ssfs order copy service.
     */
    prepareSSFSOrderCopy:function(SSFSOrderCopyUrl){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.getServiceById("SSFSOrderCopy").setUrl(SSFSOrderCopyUrl);
        wcService.invoke("SSFSOrderCopy");
    },

    /**
     * get the last order record info in render context
     * @param {Integer} The current page number.
     * @param {string} The last order external id in current page.
     * @param {string} The last order record info in render context.
     * @param {boolean} value either true or false. True if it's for next page. False otherwise.
     */
    getLastRecordInfo: function (currentPage, lastExtOrderId, lastRecordInfoInContext, nextOrNot) {
        var lastRecordArray = lastRecordInfoInContext.split(";");
        var refinedRecordInfoIncontext;

        if(!nextOrNot){
            //previous page
            if(lastRecordInfoInContext != '' && lastRecordInfoInContext != undefined){
                if(lastRecordInfoInContext.lastIndexOf(";")>-1){
                    refinedRecordInfoIncontext = lastRecordInfoInContext.substring(0, lastRecordInfoInContext.lastIndexOf(";"));
                }else{
                    refinedRecordInfoIncontext = "";
                }
            }
        }else{
            //next page
            if(currentPage==1 || currentPage==''|| currentPage == undefined){
                //first page
                if(lastExtOrderId !='' && lastExtOrderId!=undefined){
                    refinedRecordInfoIncontext = lastExtOrderId;
                }else{
                    refinedRecordInfoIncontext = " ";
                }
            }else{
                if(lastRecordInfoInContext != '' && lastRecordInfoInContext != undefined){
                    if(lastExtOrderId !='' && lastExtOrderId!=undefined){
                        refinedRecordInfoIncontext = lastRecordInfoInContext.concat(";").concat(lastExtOrderId);
                    }else{
                        refinedRecordInfoIncontext = lastRecordInfoInContext.concat(";").concat(" ");
                    }
                }
            }
        }

        return refinedRecordInfoIncontext;
    },

    /**
     * Displays the actions list drop down panel.
     * @param {object} event The event to retrieve the input keyboard key.
     * @param {string} dialogId The id of the content pane containing the action popup details
     */
    showActionsPopup: function(event, dialogId){
        if(event == null || event.keyCode === KeyCodes.DOWN_ARROW){
            var dialog = $("#" + dialogId).data("wc-WCDialog");
            if(dialog) {
                this.dropDownDlg = dialog;
                this.dropDownDlg.open();
            }
        }
    },

    /**
     *This function displays the Recurring Order / Subscription action popup.
     *@param {String} action This variable can be either recurring_order or subscription.
     *@param {String} subscriptionId This variable gives the subscription id to be canceled.
     *@param {String} popupIndex the index of the action popup (required to close it later)
     *@param {String} message This variable gives the message regarding cancel notice period.
     */
    showPopup:function(action, subscriptionId, popupIndex, message){
        var popup = $("#Cancel_"+action+"_popup").data("wc-WCDialog");
        if (popup !=null) {
            closeAllDialogs(); //close other dialogs(quickinfo dialog, etc) before opening this.
            popup.element.attr("data-popupIndex", popupIndex);
            popup.open();
            document.getElementById("Cancel_yes_"+action).setAttribute("onclick", "OrderListJS.cancelRecurringOrder("+ subscriptionId + "," + popupIndex + ");");

            if(document.getElementById("cancel_notice_"+action) && document.getElementById(message)){
                $("#cancel_notice_"+action).html($("#" + message).val());
            }
        }else {
            console.debug("Cancel_subscription_popup"+" does not exist");
        }
    },

    /**
     * This function cancels a recurring order.
     * @param {String} subscriptionId The unique ID of the subscription to cancel.
     * @param {int} popupIndex the index of the action drop down
     */
    cancelRecurringOrder:function(subscriptionId, popupIndex){
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();

        var params = {
            subscriptionId: subscriptionId,
            URL: "",
            storeId: OrderListServicesDeclarationJS.storeId,
            catalogId: OrderListServicesDeclarationJS.catalogId,
            langId: OrderListServicesDeclarationJS.langId
        };
        wcService.invoke("AjaxCancelSubscription", params);
    },

    /**
     * Display order list for pagination
     */
    showResultsPage:function(data){
        var pageNumber = data['pageNumber'],
        pageSize = data['pageSize'];
        pageNumber = parseInt(pageNumber);
        pageSize = parseInt(pageSize);

        setCurrentId(data["linkId"]);

        if(!submitRequest()){
            return;
        }

        var beginIndex = pageSize * ( pageNumber - 1 );
        cursor_wait();
        wcRenderContext.updateRenderContext('OrderListTable_Context', {'beginIndex':beginIndex});
        MessageHelper.hideAndClearMessage();
    },

    /**
     * Creates an empty order.
     */
    createNewList:function() {
        var form_name = document.getElementById("OrderList_NewListForm_Name");
        if (form_name !=null && this.isEmpty(form_name.value)) {
            MessageHelper.formErrorHandleClient(form_name.id,MessageHelper.messages["LIST_TABLE_NAME_EMPTY"]); return false;
        }
        service = wcService.getServiceById('AjaxOrderCreate');
        
        var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            description: $(form_name).val()
        };
            
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke('AjaxOrderCreate',params);
    },
    
    /**
     * Deletes a saved order
     * This method is invoked by the <b>Delete</b> action.
     * @param (string) orderId The orderId of the saved order.
     */
    deleteOrder:function (orderId) {
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        };
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxSingleOrderCancel", params);
    },
    
    /**
     * Duplicates a saved order.
     * This method is invoked by the <b>Duplicate order</b> action.
     * @param (string) orderId The order from which the new saved order is created.
     * @param (string) orderDesc The name of the saved order.
     */
    duplicateOrder:function (orderId, orderDesc) {
        MessageHelper.hideAndClearMessage();
        
        var params = {
            storeId: this.storeId,
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            fromOrderId_1: orderId,
            toOrderId: "**",
            copyOrderItemId_1: "*",
            keepOrdItemValidContract: "1",
            URL: "TableDetailsDisplayURL"
        };
        if (orderDesc != null && orderDesc != 'undefined'){
            params["description"] = orderDesc;
        }
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke('AjaxSingleOrderCopy',params);
    },
    
    /**
    * Sets the selected saved order as the current order in the saved orders table.
    * This method is invoked by the <b>Set as Current Order</b> action. 
    **/
    setCurrentOrder : function (orderId) {
        if (orderId != null && orderId != 'undefined') {
            if(!submitRequest()){
                return;
            }
            var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                orderId: orderId,
                URL: ""
            };
            wcService.invoke("AjaxSetPendingOrder", params);
        }
    },
    
    /**
     * Updates the current order in the database to match the order in the shopping cart.
     * This method is called when the Saved Order list page loads, and when a saved order is added/deleted. 
     * @param (string) currentOrderId The orderId to set as the current order.
     */
    updateCurrentOrder : function(currentOrderId) {
        if (currentOrderId != null) {
            var params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                URL: "",
                orderId: currentOrderId
            };
            wcService.invoke("AjaxUpdatePendingOrder", params);
        }
    },
    
    /**
     * Returns the order ID of the first saved order in the table.
     * @returns {String} The order ID of the first saved order if not empty, otherwise, returns null.
     * 
     **/
    getFirstSavedOrderIdFromList : function() {
        var savedOrderLink = document.getElementById("WC_OrderList_Link_2_1");
        
        if (savedOrderLink && savedOrderLink != null && savedOrderLink != 'undefined' && savedOrderLink.innerHTML != null && savedOrderLink.innerHTML != 'undefined') {
            var savedOrderText = savedOrderLink.innerHTML,
            savedOrderId = savedOrderText.split(" ")[0];
            
            return savedOrderId;
        } else {
            return null;
        }
    },
    
    /**
     * Returns the current order ID from the currentOrderJSON div.
     * @returns {String} The order ID of the current order or null if the currentOrderJSON div cannot be found.
     * 
     **/
    getCurrentOrderId : function() {
        var jsonDIV = null;
        Utils.ifSelectorExists("#currentOrderJSON", function($node) {
            jsonDIV = JSON.parse($node.html());
        });
        if (jsonDIV != null && jsonDIV != 'undefined' && jsonDIV.currentOrderId != null && jsonDIV.currentOrderId != 'undefined') {
            return jsonDIV.currentOrderId;
        }
        else {
            return null;
        }
    },
    
    /**
     * Sets the newOrderId variable. This variable is only used to store the first saved order in the list.
     * @param newOrdId The order ID of the newly created saved order.
     */
    setNewOrderId : function(newOrdId) {
        this.newOrderId = newOrdId;
    },

    /**
     * Returns the ID of the new saved order. 
     * The newOrderId variable is set only when it is the first saved order in the list.
     * @returns {String} The ID of the newly created saved order.
     */
    getNewOrderId : function() {
        return this.newOrderId;
    },
    
    /**
     * Returns the currentOrderDeleted flag. 
     * @returns {boolean} true or false indicating whether the current saved order was deleted.
     * 
     */
    isCurrentOrderDeleted : function() {
        return this.currentOrderDeleted;
    },
    
    /**
     * Sets the currentOrderDeleted flag to true or false. 
     * This flag determines if the current saved order was deleted.
     * @param currOrderDeleted A boolean (true/false) indicating if the saved order was deleted.
     */
    setCurrentOrderDeleted : function(currOrderDeleted) {
        this.currentOrderDeleted = currOrderDeleted;
    },
    
    /**
    * Opens the saved order details view for the order.
    * This method is invoked by the <b>View Details</b> action.
    * @param (string) reqListURL The URL to the 
    **/
    viewDetails : function (reqListURL) {
        document.location.href = reqListURL;
    },
    
    /**
     * Checks if a string is null or empty.
     * @param (string) str The string to check.
     * @return (boolean) Indicates whether the string is empty.
     */
    isEmpty:function (str) {
        var reWhiteSpace = new RegExp(/^\s+$/);
        if (str == null || str =='' || reWhiteSpace.test(str) ) {
            return true;
        }
        return false;
    },
    
    /**
     * Remove the quantity of the SKU (e.g. when row is hidden)
     * @param (string) restUrl The rest url for getting order items
     * @param (string) params String with the params to be passed in
     */
    getOrderItems:function(restUrl, params){
        $.get(restUrl, params, function(order, textStatus, jqXHR) {
            OrderListJS.quantityList = {};
            if (order.orderItem == null) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('MYACCOUNT_SAVEDORDERLIST_EMPTY_ADD_TO_REQ_FAIL'));
                return;
            }
            for (var i = 0; i < order.orderItem.length; i++) {
                var orderId = order.orderId;

                if (!(orderId in OrderListJS.quantityList)) {
                    OrderListJS.quantityList[orderId] = {};
                }
                OrderListJS.quantityList[orderId][order.orderItem[i].productId] = order.orderItem[i].quantity;
            }

            if (typeof addReqListsJS != 'undefined') {
                addReqListsJS.toggleDropDownMenu(true,false);
            }
        });
    },
    
    /**
     *This method locks the order specified when the buyer administrator is browsing in an on behalf mode.
     */
    lockOrderOnBehalf: function(orderId){
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        };
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxRESTOrderLockOnBehalf", params);
    },
    
    /**
     * This method take over the lock on the order by other buyer administrator 
     * when the buyer administrator is browsing in an on behalf mode.
     */
    takeOverLockOrderOnBehalf: function(orderId, isCurrentOrder){
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            takeOverLock: "Y"
        };
        if (undefined !== isCurrentOrder && isCurrentOrder =='true'){
            setDeleteCartCookie();
            params["isCurrentOrder"] = 'true';
        } else {
            params["isCurrentOrder"] = 'false';
        }
        
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxRESTOrderLockTakeOverOnBehalf", params);
    },
        
    /**
     *This method unlocks the order specified when the buyer administrator is browsing in 
     *an on behalf mode.
     */
    unlockOrderOnBehalf: function(orderId){
        var params = {
            orderId: orderId,
            filterOption: "All",
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        };
        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.invoke("AjaxRESTOrderUnlockOnBehalf", params);
    }
}
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

/**
 * Declares a new render context for order list.
 */
wcRenderContext.declare("OrderListTable_Context", [], {beginIndex: "0"});

/**
 * Declares a new refresh controller for order list.
 */
var declareOrderDisplayRefreshArea = function(widgetPrefix) {
    var myWidgetObj = $("#" + widgetPrefix + "OrderListTable_Widget");
    wcRenderContext.addRefreshAreaId("OrderListTable_Context", widgetPrefix + "OrderListTable_Widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("OrderListTable_Context");
    
    /**
     * Displays the previous/next page of orders.
     * This function is called when a render context changed event is detected.
     */
    wcTopic.subscribe(["AjaxCancelSubscription", "AjaxOrderCreate", "AjaxSingleOrderCancel", "AjaxSingleOrderCopy", "AjaxSetPendingOrder", "AjaxRESTOrderUnlockOnBehalf", "AjaxRESTOrderLockOnBehalf", "AjaxRESTOrderLockTakeOverOnBehalf"], function () {
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    });
    
    var renderContextChangedHandler = function() {
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    }
    
    var postRefreshHandler = function() {
        cursor_clear();

        if(OrderListJS.isSavedOrder()) {
            // If the current saved order gets deleted, we trigger the "AjaxUpdatePendingOrder" 
             // to set the first saved order in the list as the current saved order.
             if (OrderListJS.getFirstSavedOrderIdFromList() != null && OrderListJS.isCurrentOrderDeleted() == true) {
                 OrderListJS.updateCurrentOrder(OrderListJS.getFirstSavedOrderIdFromList());
             }

             // If it's the only saved order in the list and the current saved order div is not currently set,
             // ensure that it's set as the current saved order.
             if (Utils.existsAndNotEmpty(OrderListJS.getNewOrderId())) {
                 var newOrderId = OrderListJS.getNewOrderId();
                 OrderListJS.updateCurrentOrder(newOrderId);
                 OrderListJS.setNewOrderId(null);
             }

             if (OrderListJS.isCurrentOrderDeleted() == true) {
                 OrderListJS.setCurrentOrderDeleted(false);
             }

             toggleMobileView();
        }
    }
    
    // initialize widget
    myWidgetObj.refreshWidget({renderContextChangedHandler: renderContextChangedHandler, postRefreshHandler: postRefreshHandler});
}//-----------------------------------------------------------------
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

/**
 * @fileOverview This javascript contains declarations of AJAX services used within
 * WebSphere Commerce.
 */

/**
 * @class This class stores common parameters needed to make the service call.
 */
OrderListServicesDeclarationJS = {
    /* The common parameters used in service calls */
    langId: "-1",
    storeId: "",
    catalogId: "",

    /**
     * This function initializes common parameters used in all service calls.
     * @param {int} langId The language id to use.
     * @param {int} storeId The store id to use.
     * @param {int} catalogId The catalog id to use.
     */
    setCommonParameters:function(langId,storeId,catalogId){
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
    }
}

/**
 *  This service enables customer to Reorder an already existing order.
 *  @constructor
 */
wcService.declare({
    id: "OrderCopy",
    actionId: "OrderCopy",
    url: "AjaxRESTOrderCopy",
    formId: ""

    /**
     *  Copies all the items from the existing order to the shopping cart and redirects to the shopping cart page.
     *  @param (object) serviceResponse The service response object, which is the
     *  JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        for (var prop in serviceResponse) {
            console.debug(prop + "=" + serviceResponse[prop]);
        }
        if (serviceResponse.newOrderItemsCount != null && serviceResponse.newOrderItemsCount <= 0){
            MessageHelper.displayErrorMessage(MessageHelper.messages["CANNOT_REORDER_ANY_MSG"]);
        }
        else {
            setDeleteCartCookie();

            var postRefreshHandlerParameters = [];
            var initialURL = "AjaxRESTOrderPrepare";
            var urlRequestParams = [];
            urlRequestParams["orderId"] = serviceResponse.orderId;
            urlRequestParams["storeId"] = OrderListServicesDeclarationJS.storeId;

            postRefreshHandlerParameters.push({"URL":"AjaxCheckoutDisplayView","requestType":"GET", "requestParams":{}}); 
            var service = getCustomServiceForURLChaining(initialURL,postRefreshHandlerParameters,null);
            wcService.invoke(service.getParam("id"), urlRequestParams);
        }
    }

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey === "_ERR_PROD_NOT_ORDERABLE") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
        } else if (serviceResponse.errorMessageKey === "_ERR_INVALID_ADDR") {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        }else {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            }
            else {
                    if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
            }
        }
        cursor_clear();
    }
}),

/**
 *  This service enables customer to Reorder an already existing order in external system.
 *  @constructor
 */
wcService.declare({
    id: "SSFSOrderCopy",
    actionId: "SSFSOrderCopy",
    url: "AjaxSSFSOrderCopy",
    formId: ""

        /**
         *  Copies all the items from the existing order to the shopping cart and redirects to the shopping cart page.
        *  @param (object) serviceResponse The service response object, which is the
        *  JSON object returned by the service invocation.
        */
    ,successHandler: function(serviceResponse) {
        for (var prop in serviceResponse) {
            console.debug(prop + "=" + serviceResponse[prop]);
        }

        setDeleteCartCookie();
        document.location.href=appendWcCommonRequestParameters("AjaxCheckoutDisplayView?langId="+OrderListServicesDeclarationJS.langId+"&storeId="+OrderListServicesDeclarationJS.storeId+"&catalogId="+OrderListServicesDeclarationJS.catalogId);
    }

    /**
    * display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey === "_ERR_PROD_NOT_ORDERABLE") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
        } else if (serviceResponse.errorMessageKey === "_ERR_INVALID_ADDR") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["INVALID_CONTRACT"]);
        }else {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            }
            else {
                    if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
            }
        }
        cursor_clear();
    }
}),

/**
 * This service cancels a subscription.
 * @constructor
 */
wcService.declare({
    id: "AjaxCancelSubscription",
    actionId: "AjaxCancelSubscription",
    url: "AjaxRESTRecurringOrSubscriptionCancel",
    formId: ""

    /**
     * Clear messages on the page.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        closeAllDialogs();
        if(serviceResponse.subscriptionType == "RecurringOrder"){
            if(serviceResponse.state == "PendingCancel"){
                MessageHelper.displayStatusMessage(MessageHelper.messages["SCHEDULE_ORDER_PENDING_CANCEL_MSG"]);
            }
            else{
                MessageHelper.displayStatusMessage(MessageHelper.messages["SCHEDULE_ORDER_CANCEL_MSG"]);
            }
        }
        else{
            if(serviceResponse.state == "PendingCancel"){
                MessageHelper.displayStatusMessage(MessageHelper.messages["SUBSCRIPTION_PENDING_CANCEL_MSG"]);
            }
            else{
                MessageHelper.displayStatusMessage(MessageHelper.messages["SUBSCRIPTION_CANCEL_MSG"]);
            }
        }
    }

    /**
     * Displays an error message on the page if the request failed.
     * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        } else {
            if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        }
        cursor_clear();
    }
}),

/**
 *  This service enables customer to Renew a subscription.
 *  @constructor
 */
wcService.declare({
    id: "SubscriptionRenew",
    actionId: "SubscriptionRenew",
    url: "AjaxRESTOrderCopy",
    formId: ""

    /**
     *  Copies all the items from the existing subscription to the shopping cart and calls service to update requested shipping date.
    *  @param (object) serviceResponse The service response object, which is the
    *  JSON object returned by the service invocation.
    */
    ,successHandler: function(serviceResponse) {
        for (var prop in serviceResponse) {
            console.debug(prop + "=" + serviceResponse[prop]);
        }

        var params = [];

        params.storeId      = OrderListServicesDeclarationJS.storeId;
        params.catalogId    = OrderListServicesDeclarationJS.catalogId;
        params.langId       = OrderListServicesDeclarationJS.langId;
        params.orderId      = serviceResponse.orderId;
        params.calculationUsage  = "-1,-2,-3,-4,-5,-6,-7";
        params.requestedShipDate = OrderListJS.getSubscriptionDate();

        OrderListJS.subscriptionOrderId = serviceResponse.orderId;
        OrderListJS.subscriptionOrderItemId = serviceResponse.orderItemId[0];

        wcService.invoke("SetRequestedShippingDate",params);
    }

    /**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey == "_ERR_PROD_NOT_ORDERABLE") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
        } else if (serviceResponse.errorMessageKey == "_ERR_INVALID_ADDR") {
            MessageHelper.displayErrorMessage(MessageHelper.messages["INVALID_CONTRACT"]);
        }else {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            }
            else {
                    if (serviceResponse.errorMessageKey) {
                    MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                    }
            }
        }
        cursor_clear();
    }

}),

/**
 *  This service sets the requested shipping date for a subscription renewal.
 *  @constructor
 */
wcService.declare({
    id: "SetRequestedShippingDate",
    actionId: "SetRequestedShippingDate",
    url: "AjaxRESTOrderShipInfoUpdate",
    formId: ""
/**
 * hides all the messages and the progress bar
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,successHandler: function(serviceResponse) {
        cursor_clear();
        document.location.href=appendWcCommonRequestParameters("RESTOrderPrepare?langId="+OrderListServicesDeclarationJS.langId+"&storeId="+OrderListServicesDeclarationJS.storeId+"&catalogId="+OrderListServicesDeclarationJS.catalogId+"&orderId="+serviceResponse.orderId+"&URL=AjaxCheckoutDisplayView?langId="+OrderListServicesDeclarationJS.langId+"&storeId="+OrderListServicesDeclarationJS.storeId+"&catalogId="+OrderListServicesDeclarationJS.catalogId);
    }

    /**
 * display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessageKey == "_ERR_ORDER_ITEM_FUTURE_SHIP_DATE_OVER_MAXOFFSET") {
            var params = [];

            params.storeId      = OrderListServicesDeclarationJS.storeId;
            params.catalogId    = OrderListServicesDeclarationJS.catalogId;
            params.langId       = OrderListServicesDeclarationJS.langId;
            params.orderId      = OrderListJS.subscriptionOrderId;
            params.orderItemId      = OrderListJS.subscriptionOrderItemId;
            params.calculationUsage  = "-1,-2,-3,-4,-5,-6,-7";
            wcService.invoke("RemoveSubscriptionItem",params);

            MessageHelper.displayStatusMessage(MessageHelper.messages["CANNOT_RENEW_NOW_MSG"]);
        }
        else{
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
    }

}),

/**
 * This service removes the subscription item from the shopping cart if renewal fails.
 * @constructor
 */
wcService.declare({
    id: "RemoveSubscriptionItem",
    actionId: "RemoveSubscriptionItem",
    url: "AjaxRESTOrderItemDelete",
    formId: ""

    /**
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        cursor_clear();
    }

        /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        }
        else {
                if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
                }
        }
        if(serviceResponse.errorCode){
            wcTopic.publish("OrderError",serviceResponse);
        }
        cursor_clear();
    }

})

/**
 * This service allows customer to create a new saved order
 * @constructor
 */
wcService.declare({
    id:"AjaxOrderCreate",
    actionId:"AjaxOrderCreate",
    url:"AjaxRESTOrderCreate",
    formId:""

     /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CREATE_SUCCESS"]);
        
        var firstSavedOrderId = OrderListJS.getFirstSavedOrderIdFromList();
        if (firstSavedOrderId == null) {
            OrderListJS.setNewOrderId(serviceResponse.outOrderId);
        }
    }
        
    /**
     * Display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
             if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CREATE_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        } 
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
}),

/**
 * This service deletes an existing saved order.
 * @constructor
 */
wcService.declare({
    id:"AjaxSingleOrderCancel",
    actionId:"AjaxSingleOrderCancel",
    url:"AjaxRESTOrderCancel",
    formId:""

     /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_DELETE_SUCCESS"]);

        //set the OrderListJS.currentOrderDeleted flag to true if the current order was deleted.
        var deletedOrderId = serviceResponse.orderId;
        var currentOrderId = OrderListJS.getCurrentOrderId();
        if (currentOrderId == deletedOrderId) {
            OrderListJS.setCurrentOrderDeleted(true);
        } 
    }
        
    /**
     * Display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
             if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_DELETE_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        } 
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
}),

/**
* This service allows customer to create a saved order from an existing order.
* @constructor
*/
wcService.declare({
    id:"AjaxSingleOrderCopy",
    actionId:"AjaxSingleOrderCopy",
    url:"AjaxRESTOrderCopy",
    formId:""

     /**
    * Hides all the messages and the progress bar.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,successHandler: function(serviceResponse) {
        var params = {
            storeId: OrderListJS.storeId,
            catalogId: OrderListJS.catalogId,
            langId: OrderListJS.langId,
            updatePrices: "1",
            orderId: serviceResponse.orderId,
            calculationUsageId: "-1"
        };
        wcService.invoke("AjaxSingleOrderCalculate", params);
        MessageHelper.hideAndClearMessage();
        cursor_clear();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_COPY_SUCCESS"]);
    }
        
    /**
    * Display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
    ,failureHandler: function(serviceResponse) {
        if (serviceResponse.errorMessage) {
             if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_COPY_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        }
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
}),

/**
 * Perform the order calculation operations to compute the contract prices for the order items in an order.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxSingleOrderCalculate",
    actionId: "AjaxSingleOrderCalculate",
    url: "AjaxRESTOrderCalculate",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CALCULATE_SUCCESS"]);
        cursor_clear();
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,failureHandler: function(serviceResponse) {
        
        if (serviceResponse.errorMessage) {
            if (serviceResponse.errorCode == "CMN0409E")
             {
                 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_CALCULATE_FAIL"]);
             }
             else
             {
                 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
             }
        } 
        else {
             if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
             }
        }
        cursor_clear();
    }
})

/**
 * Invokes the order unlock action.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxRESTOrderUnlockOnBehalf",
    actionId: "AjaxRESTOrderUnlockOnBehalf",
    url: "AjaxRESTOrderUnlockOnBehalf",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_UNLOCK_SUCCESS"]);
        cursor_clear();
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,failureHandler: function(serviceResponse) {
        
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
})

/**
 * Invokes the order unlock action.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxRESTOrderLockOnBehalf",
    actionId: "AjaxRESTOrderLockOnBehalf",
    url: "AjaxRESTOrderLockOnBehalf",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_LOCK_SUCCESS"]);
        cursor_clear();
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,failureHandler: function(serviceResponse) {
        
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
})

/**
 * Invokes the order lock take over action.
 * Perform the service or command call.
 */
wcService.declare({
    id: "AjaxRESTOrderLockTakeOverOnBehalf",
    actionId: "AjaxRESTOrderLockTakeOverOnBehalf",
    url: "AjaxRESTOrderLockTakeOverOnBehalf",
    formId: ""

 /**
 * Display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

    ,successHandler: function(serviceResponse) {
        MessageHelper.hideAndClearMessage();
        MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_ORDER_LOCK_SUCCESS"]);
        cursor_clear();
        if (serviceResponse['isCurrentOrder'] !== undefined && serviceResponse['isCurrentOrder'][0] == 'true'){
            document.location.reload();
            //refresh the page to update cart
        }
    }

 /**
 * Display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
    ,failureHandler: function(serviceResponse) {
        
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
})//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * Declares a new refresh controller for the Organization Summary widget
 */
var declareOrgSearchResultsController = function() {
	var myWidgetObj = $("#orgSearchResultsRefreshArea");
	
	wcRenderContext.declare("orgSearchResultsContext",["orgSearchResultsRefreshArea"],{"orgListDisplayType":"search","searchTerm":"", "startIndex":"0"});

	var myRCProperties = wcRenderContext.getRenderContextProperties("orgSearchResultsContext");
    
	var baseURL = getAbsoluteURL() + 'OrgListDisplayViewV2';
    
	myWidgetObj.refreshWidget({
    	renderContextChangedHandler: function() {
    		myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
    		myWidgetObj.html("");
    		console.debug(myRCProperties);
    		myWidgetObj.refreshWidget("refresh", myRCProperties);
       },

    	postRefreshHandler: function() {
    		cursor_clear();
    	}
	});
};

// onChange function for organization list select button
function OrganizationOnChange(id, displayName) {
	var data = {"newOrgId":id, "newOrgName":displayName};
	organizationListJS.updateSelectedOrgDetails(data);

	// Publish the event
	wcTopic.publish(organizationListJS.ORG_CHANGED_TOPIC,data);
}
$(document).ready(function() {

organizationListJS = {

	/** HashMap structure to manage parent - child organization relationship
	 *  Key - Parent Org Id
	 *  Value - List of child organizations under Parent Org Id.
	 *  Each object in the list contains complete details about the child organization like orgId, orgName, parentOrgId
	*/
	parentChildOrgDetails : new Object(),

	/**
	* HashMap structure.
	* Key - orgId
	* Value - orgName
	*/
	orgIdToNameMap: new Object(),

	/**
	* Array of top level parent orgIds
	*/
	parentOrgIdsArray : new Array(),

	// UniCode value for &nbps; 
	//HTML Select Option element will treat &nbps; as normal string when options element is created dynamically using script. So as a workaround use unicode format
	//indentation : "\xA0\xA0\xA0", 
	indentation : 27, // padding by 27 px for every child node

	/*
	* Topic name which gets published when the selection in organization drop down box changes.
	*/
	ORG_CHANGED_TOPIC : "organizationChanged",

	/*
	* Topic name to which this widget subscribes. Any widget can publish this topic to receive the current orgId selected in the drop down box.
	*/
	CURRENT_ORG_ID_REQUEST : "currentOrgIdRequest",

	/**
	* Topic name used to publish the current orgId.
	*/
	CURRENT_ORG_ID : "currentOrgId",

	/**
	* Current Organization selected
	*/
	CURRENT_DATA : {"newOrgId":"","newOrgName":""},
	
	/**
	* Set the indentation which can be used while displaying the tree structure
	*/
	setIndentation:function(indent){
		this.iindentation = indent;
	},

	orgSearchListData : {"searchInputFieldId":"orgNameInputField", "clearFilterButtonId":"clearFilter", "progressBarId":"searchOrgListButton", "searchParameterName":"orgName", "searchResultsDivId":"orgSearchResultsRefreshArea"},

	/**
	* This method converts the flat structure of organizaiton list into tree structure and displays the tree structure in the drop down box
	* flatStructure - List of organizations
	* selectBox - Id of the drop down box where the tree structure will be displayed
	*/
	createAndDisplayOrgTree:function(flatStructure,selectBox,selectedOrgEntityId){

		var parentOrgIdsSet = new Object();
		var seenParentOrgIds = new Object();

		//Keep track of id to Name mapping. Needed to get parentOrg Name. For Accessibility label.
		for(var i = 0; i < flatStructure.organizationDataBeans.length; i++){
			var orgDetails = flatStructure.organizationDataBeans[i];
			var orgId = orgDetails.organizationId;
			var orgName = orgDetails.displayName;
			this.orgIdToNameMap[orgId] = orgName; 
		}

		for(var i = 0; i < flatStructure.organizationDataBeans.length; i++){

			var orgDetails = flatStructure.organizationDataBeans[i];
			var orgId = orgDetails.organizationId;
			var parentOrgId = orgDetails.parentMemberId;
			var orgName = orgDetails.displayName;

			var childOrgList = this.parentChildOrgDetails[parentOrgId];
			if(childOrgList === undefined){
				childOrgList = new Array();
				this.parentChildOrgDetails[parentOrgId] = childOrgList;
			} 
			var child = new Object();
			child["orgId"] = orgId;
			child["parentOrgId"] = parentOrgId;
			child["orgName"] = orgName;
			child["parentOrgName"] = this.orgIdToNameMap[parentOrgId]; // This is for aria-label. To call out parent org Name.
			childOrgList[childOrgList.length] = child;

			// Identify the parentOrgIds
			if(!Object.prototype.hasOwnProperty.call(seenParentOrgIds, parentOrgId)){
				parentOrgIdsSet[parentOrgId] = "true";
			} 
			seenParentOrgIds[orgId] = "true";
			seenParentOrgIds[parentOrgId] = "true";
			if(Object.prototype.hasOwnProperty.call(parentOrgIdsSet, orgId)){
				delete parentOrgIdsSet[orgId];
			}
		}
		for(var i in parentOrgIdsSet){
			this.parentOrgIdsArray[this.parentOrgIdsArray.length] = i;
		}

		console.debug("Parent to Child Org Details = ", this.parentChildOrgDetails);
		console.debug("Top Level Parent Org Ids = ",this.parentOrgIdsArray);
		console.debug("Org Id to Name Map ", this.orgIdToNameMap);
		this.displayOrgTree(this.parentChildOrgDetails, this.parentOrgIdsArray, selectBox,selectedOrgEntityId);
	},

	/**
	* Displays organization structure in Tree form.
	* parentChildDetailsMap - Object containing parent to child org relationship.
	* parentIdsList - List of top level ( root ) OrgIds.
	* selectBox - id of the drop down box used to display the tree structure.
	*/
	displayOrgTree:function(parentChildDetailsMap, parentIdsList, selectBox,selectedOrgEntityId){
		var selectBoxObj = $("#" + selectBox);

		for(var i = 0; i < parentIdsList.length; i++){
			var childId = parentIdsList[i];
			this.buildOrgTreeRecursively(parentChildDetailsMap,childId, selectBoxObj, 8);
		}
		console.debug(selectBoxObj);
		// Set the selected orgEntityId in the selectBox object.
		$("#" + selectBox).Select("refresh");
	},

	/**
	* Recursively builds the tree structure mark-up.
	* parentChildDetailsMap - Object containing parent to child org relationship.
	* childId - Child Organization id
	* selectBoxObj - Drop down object where tree structure is built
	* indentation - Used to indent child orgs from parent orgs
	*/
	buildOrgTreeRecursively:function(parentChildDetailsMap,childId,parentNode,indentation){

		var childDetails = parentChildDetailsMap[childId];
		var scope = this;
		if(childDetails != null){
			for(var j = 0; j < childDetails.length; j++){
				var child = childDetails[j];
				var id1 = child['orgId'];
				var name = child['orgName'];
				var parentOrgName = child["parentOrgName"];
				var style = "padding-left:"+indentation+"px;";

				// Generate ARIA LABEL
				var ariaLevel = (indentation / this.indentation) + 1;
				//var tempString = storeNLS['ORG_TO_PARENT_ORG']; - 	// ORG_TO_PARENT_ORG : "${0} created under parent organization - ${1}",
				var stringPattern = "{0} - {1}";
				var tempString;
				if(parentOrgName != null){
					tempString = Utils.substituteStringWithMap(stringPattern, {
						0: name,
						1: parentOrgName
					});
				} else {
					// tempString = storeNLS['TOP_LEVEL_ORG']; - // TOP_LEVEL_ORG : "${0}. This is the top level organization"
					stringPattern = "{0}";
					tempString = Utils.substituteStringWithMap(stringPattern, {0: name});
				}
			
				var text = "<option aria-label = '"+ tempString +"' aria-level = '"+ariaLevel+"' style = '"+style+"'" +
						"value = '" + id1 + "'>"+name+"</option>";
				var option = {id:id1, label:text, displayName:name};
				parentNode.append(option.label);
				if(parentChildDetailsMap[id1] != null){
					this.buildOrgTreeRecursively(parentChildDetailsMap,id1, parentNode,indentation + this.indentation);
				} 
			}
		}
	},

	/**
	* For the given eventName and domNodeId, this function sets up the event with topicName = ORG_CHANGED_TOPIC
	* The data contains the orgId currently selected, with key set to "newOrgId"
	* 
	* This method also subscribes to CURRENT_ORG_ID_REQUEST topic and in response publishes CURRENT_ORG_ID with data object containing the current orgId.
	*/
	setUpEvents:function(eventName, selectBoxDivId){
		var scope = this;
		$(document).ready(function() {
			wcTopic.subscribe(scope.CURRENT_ORG_ID_REQUEST, function(data){
				console.debug("pulbish "+scope.CURRENT_ORG_ID, scope.CURRENT_DATA);
				// Add CURRENT_DATA to the data supplied by the publisher of this event.. and then publish a new event
				$.extend(data, scope.CURRENT_DATA);
				wcTopic.publish(scope.CURRENT_ORG_ID, data);
			});
		});
	},

	cancelEvent: function(e) {
		if (e.stopPropagation) {
			e.stopPropagation();
		}
		if (e.preventDefault) {
			e.preventDefault();
		}
		e.cancelBubble = true;
		e.cancel = true;
		e.returnValue = false;
	},

	updateSelectedOrgDetails:function(data,publishEvent){
		this.CURRENT_DATA["newOrgId"] = data["newOrgId"];
		this.CURRENT_DATA["newOrgName"] = data["newOrgName"];
		console.debug("Current Organization selected", this.CURRENT_DATA);
		if(publishEvent != 'undefined' && publishEvent == 'true'){
			wcTopic.publish(this.ORG_CHANGED_TOPIC,data);
		}
	},

	updateSelectedOrgName:function(elementId,name){
		$("#" + elementId).html(name);
		var scope = this;
		$(document).ready(function() {
			wcTopic.subscribe(scope.ORG_CHANGED_TOPIC, function(data){
				$("#" + elementId).html(data.newOrgName);
			});
		});
	},
	
	getCurrentData:function(){
		return this.CURRENT_DATA;
	},

	showResultsPage:function(data){

		var pageNumber = data['pageNumber'];
		var pageSize = data['pageSize'];
		pageNumber = parseInt(pageNumber);
		pageSize = parseInt(pageSize);
		var startIndex = (pageNumber - 1) * pageSize;

		setCurrentId(data["linkId"]);

		if(!submitRequest()){
			return;
		}

		console.debug(wcRenderContext.getRenderContextProperties('orgSearchResultsContext').properties);
		var beginIndex = pageSize * ( pageNumber - 1 );
		cursor_wait();

		wcRenderContext.updateRenderContext('orgSearchResultsContext', {"startIndex": startIndex});
		MessageHelper.hideAndClearMessage();
	},

	toggleSelection:function(nodeCSS,nodeId,parentNode,cssClassName){
		// Get list of all active nodes with cssClass = nodeCSS under parentNode.
		var activeNodes = $("#" + parentNode).find('.'+cssClassName);

		// Toggle the css class for the node with id = nodeId
		$("#" + parentNode).find('#'+nodeId).toggleClass(cssClassName);

		// Remove the css class for all the active nodes.
		activeNodes.removeClass(cssClassName);
	},

	closeActionButtons:function(nodeCSS,parentNode,cssClassName,hiddenClassName,activeClassName){
		$("#" + parentNode).find('.'+nodeCSS).removeClass(cssClassName);
	},

	resetActionButtonStyle:function(nodeCSS,parentNode,hiddenClassName,activeClassName){
		$("#" + parentNode).find('.'+nodeCSS).addClass(hiddenClassName);
		$("#" + parentNode).find('.'+nodeCSS).removeClass(activeClassName);
	},

	toggleCSSClass:function(nodeCSS,nodeId,parentNode,hiddenClassName,activeClassName){
		// Get the list of current nodes
		var activeNodes = $("#" + parentNode).find('.'+activeClassName); 

		// For the clicked node, toggle the CSS Class. If hidden then display / If displayed then hide.
		$("#"+parentNode).find('#'+nodeId).toggleClass(hiddenClassName);
		$("#"+parentNode).find('#'+nodeId).toggleClass(activeClassName);

		// For all activeNodes, remove the activeCSS and add the hiddenCSS
		activeNodes.removeClass(activeClassName);
		activeNodes.addClass(hiddenClassName);
	},

	doSearch:function(){
		searchTerm = $("#" + this.orgSearchListData.searchInputFieldId).val();
		if(searchTerm == 'undefined' || searchTerm.length == 0){
			searchTerm = "*";
		}
		setCurrentId(this.orgSearchListData.progressBarId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		var params = {};
		params[this.orgSearchListData.searchParameterName] = searchTerm;
		params["startIndex"] = "0"; // Reset start index..This is a new search..
		wcRenderContext.updateRenderContext("orgSearchResultsContext", params);	
		$("#" + this.orgSearchListData.clearFilterButtonId).css("display","block"); // Display clearFilter button
	},

	handleSearchInput:function(event,doSearch){
		var searchTerm = $("#" + this.orgSearchListData.searchInputFieldId).val();
		if(searchTerm != 'undefined' && searchTerm.length > 0){
			$("#" + this.orgSearchListData.clearFilterButtonId).css("display","block");
		} else {
			$("#" + this.orgSearchListData.clearFilterButtonId).css("display","none");
		}
		$("#" + this.orgSearchListData.searchResultsDivId).html(""); // Clear previous search results..
		if(doSearch == 'true' && event != null && event.keyCode == KeyCodes.ENTER){
			this.doSearch();
		}
		return false;
	}

};

});//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * Declares a new render context for the Organization Member Group widget
 */
wcRenderContext.declare("orgMemberGroupContext",["orgMemberGroupRefreshArea"],{'orgEntityId':null, 'progressBarId':null});

/** 
 * Declares a new refresh controller for the Organization Member Group widget
 */
function declareOrgMemberGroupController() {
	var myWidgetObj = $("#orgMemberGroupRefreshArea");

	var myRCProperties = wcRenderContext.getRenderContextProperties("orgMemberGroupContext");

	var baseURL = getAbsoluteURL() + 'OrgMemberGroupDisplayViewV2';
	
	wcTopic.subscribe(["AjaxApprovalGroupUpdate"], function() {
		myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
		setCurrentId(myRCProperties["progressBarId"]);
		submitRequest();
		cursor_wait();
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {},
		
		postRefreshHandler: function() {
			cursor_clear();
			widgetCommonJS.removeSectionOverlay();
       }
	});
};

organizationMemberApprovalGroupJS = {

	widgetShortName: "OrgMemberApprovalGroupWidget", // My Name
	
	/**
	*/
	updateMemberApprovalGroup:function(orgEntityId, approvalGroupCheckBoxName, checkBoxCSSClassName){

		var service = wcService.getServiceById('AjaxApprovalGroupUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wcService.declare({
				id: "AjaxApprovalGroupUpdate",
				actionId: "AjaxApprovalGroupUpdate",
				url: getAbsoluteURL() + "AjaxRESTApprovalGroupUpdate",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("APPROVAL_MEMBER_GROUP_UPDATED"));
				}
				
				/**
				 * Displays an error message on the page if the request failed.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
				 */
				,failureHandler: function(serviceResponse) {
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
		}

		var checkBox = $('#' + approvalGroupCheckBoxName).find('.'+checkBoxCSSClassName);
		var segmentId = "";
		for(var i = 0; i < checkBox.length; i++){
			if(segmentId == ""){
				segmentId = checkBox[i].getAttribute("data-memberGroupId");
			} else {
				segmentId = segmentId +","+checkBox[i].getAttribute("data-memberGroupId");
			}
		}

		var params = [];
		params.orgEntityId = orgEntityId;
		params.segmentId = segmentId;
		params.storeId = WCParamJS.storeId;
		params.authToken =  $("#authToken").val();
		params.URL = "URL";
		
		setCurrentId(approvalGroupCheckBoxName+"Icon");
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		var context = wcRenderContext.getRenderContextProperties("orgMemberGroupContext");
		context["orgEntityId"] = orgEntityId;
		context["progressBarId"] = approvalGroupCheckBoxName+"Icon"
		wcService.invoke("AjaxApprovalGroupUpdate", params);
	},
	
	preSelectAssignedMemberGroup:function(selectedGroupIds){
		var assignedGroups = $("#" + selectedGroupIds).val();
		var assignedGroupIds = assignedGroups.split(",");
		if(assignedGroupIds.length > 0){
			var checkBox = $('#memberGroupEdit').find('.arrowForDojoQuery');
			for(var i = 0; i < checkBox.length; i++){
				var roleId = checkBox[i].getAttribute("data-memberGroupId");
				
				for(var j = 0; j < assignedGroupIds.length; j++){
					if(assignedGroupIds[j] == roleId){
						$(checkBox[i]).addClass("arrow");
						$(checkBox[i]).attr("aria-checked","true");
						break;
					} else {
						$(checkBox[i]).removeClass("arrow");
						$(checkBox[i]).attr("aria-checked","false");
					}
				}
			}
		}
	}
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * Declares a new render context for the Organization Roles widget
 */
wcRenderContext.declare("orgRolesContext",["orgRolesRefreshArea"],{'orgEntityId':null, "progressBarId":null});

/** 
 * Declares a new refresh controller for the Organization Roles widget
 */
function declareOrgRolesController() {
	var myWidgetObj = $("#orgRolesRefreshArea");
	
	var baseURL = getAbsoluteURL() + 'OrgRolesDisplayViewV2';
	
	var myRCProperties = wcRenderContext.getRenderContextProperties("orgRolesContext");
	
	wcTopic.subscribe(["AjaxOrgRolesUpdate"], function() {
		myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
		setCurrentId(myRCProperties["progressBarId"]);
		submitRequest();
		cursor_wait();
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
			myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
			if(myRCProperties["refreshWidget"] != "false"){
				myWidgetObj.html("");
				myWidgetObj.refreshWidget("refresh", myRCProperties);
			}
		},

		postRefreshHandler: function() {
			cursor_clear();
			widgetCommonJS.removeSectionOverlay();
		}
	});
};

organizationRolesJS = {

	widgetShortName: "OrgRolesWidget", // My Name
	initialSelectedRolesList: [],

	getOrgRolesUpdateService:function(actionId,postSuccessHandler,postRefreshHandlerParameters){
		
		var service = wcService.getServiceById('AjaxOrgRolesUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wcService.declare({
				id: "AjaxOrgRolesUpdate",
				actionId: "AjaxOrgRolesUpdate",
				url: getAbsoluteURL() + "AjaxRESTOrganizationRoleAssign",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					if(this.postRefreshHandlerParameters == null || (this.postRefreshHandlerParameters != null && this.postRefreshHandlerParameters.showSuccessMessage != 'false')){
						MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORG_ROLES_UPDATED"));
					}
					if(this.postSuccessHandler != null){
						cursor_clear();
						this.postSuccessHandler(serviceResponse,this.postRefreshHandlerParameters);
					}
				}
				
				/**
				 * Displays an error message on the page if the request failed.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
				 */
				,failureHandler: function(serviceResponse) {
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
			service = wcService.getServiceById('AjaxOrgRolesUpdate');
		}
		if(actionId != null && actionId != 'undefined'){
			service.setActionId(actionId);
		}
		if(postSuccessHandler != null && postSuccessHandler != 'undefined'){
			service.setParam("postSuccessHandler", postSuccessHandler);
		} else {
			service.setParam("postSuccessHandler", null);
		}
		if(postRefreshHandlerParameters != null && postRefreshHandlerParameters != 'undefined'){
			service.setParam("postRefreshHandlerParameters", postRefreshHandlerParameters);
		} else {
			service.setParam("postRefreshHandlerParameters", null);
		}
		return service;
	},

	unassignRolesForOrg:function(serviceResponse,jsonObject){
		organizationRolesJS.updateOrganizationRoles(jsonObject.orgEntityId, jsonObject.approvalGroupCheckBoxName,jsonObject.checkBoxCSSClassName,jsonObject.action);
	},

	/**
	*/
	updateOrganizationRoles:function(orgEntityId, approvalGroupCheckBoxName, checkBoxCSSClassName,action){
		var scope = this;
		// Array of checked checkBoxes.
		var checkBoxes = $("#" + approvalGroupCheckBoxName).find('.'+checkBoxCSSClassName);
		var unAssignRoles = false;
		var assignRoles = false;
		var unAssignRoleIds = [];
		var assignRoleIds = [];
		var context = wcRenderContext.getRenderContextProperties("orgRolesContext");
		var params = [];
		params.memberId = orgEntityId;
		params.authToken = $("#authToken").val();
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";
		
		checkBoxes.each($.proxy(function(i, entry){
			var roleId = entry.getAttribute("data-orgRolesId");
			if(this.initialSelectedRolesList.indexOf(roleId) == -1){
				// Initial list doesn't contain this roleId. It is selected now. Update at server side.
				assignRoleIds[assignRoleIds.length] = roleId;
			}	
		},scope));

		// Loop through initial selected roles list and see if it's still checked..
		$(scope.initialSelectedRolesList).each($.proxy(function(i, entry){
			var stillChecked = false;
			for(var i = 0; i < checkBoxes.length; i++){
				var selectedRoleId = checkBoxes[i].getAttribute("data-orgRolesId");
				if(selectedRoleId == entry){
					stillChecked = true;
					break;
				}
			}
			if(!stillChecked){
				unAssignRoleIds[unAssignRoleIds.length] = entry;
			}
		},scope));


		if(assignRoleIds.length > 0){
			assignRoles = true; // Need to assign some additional roles.
		}

		if(unAssignRoleIds.length > 0){
			unAssignRoles = true; // Need to un-assign some roles.
		}

		// After the service invoke, in the SuccessHandler call this postOrgRolesAssignHandler function with postRefreshHandlerParameters
		var postOrgRolesAssignHandler = null;
		var postRefreshHandlerParameters = null;


		if((action == 'undefined' || action == null || action == "assignRole") && assignRoles){
			// Start with assignRoles. Chain this service call with unAssignRoles call, if needed
			params.action = "assignRole";
			console.debug("assignRoleIds", assignRoleIds);
			for(var i = 0; i < assignRoleIds.length; i++){
				params["roleId"+i] = assignRoleIds[i];
			}

			if(unAssignRoles){
				postOrgRolesAssignHandler = scope.unassignRolesForOrg;
				context["refreshWidget"]  = "false"; // Do not refresh Roles widget immeditely. Wait for unAssign action to complete
				postRefreshHandlerParameters = {"orgEntityId":orgEntityId,"approvalGroupCheckBoxName":approvalGroupCheckBoxName,"checkBoxCSSClassName":checkBoxCSSClassName,"action":"unassignRole"};
				postRefreshHandlerParameters.showSuccessMessage = "false"; // Do not show success message till unAssign action is also done.
			}
		} else {
			action = "unassignRole"; //Nothing to assign.. Move the chain to unassignRole;
		}
		
		if(action == "unassignRole" && unAssignRoles){
			params.action ="unassignRole";
			console.debug("unAssignRoleIds", unAssignRoleIds);
			for(var i = 0; i < unAssignRoleIds.length; i++){
				params["roleId"+i] = unAssignRoleIds[i];
			}

			context["refreshWidget"]  = "true"; // Refresh widget
		}

		if(assignRoles || unAssignRoles){
			setCurrentId(approvalGroupCheckBoxName+"Icon");
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			context["orgEntityId"] = orgEntityId;
			context["progressBarId"] = approvalGroupCheckBoxName+"Icon";
			var service = this.getOrgRolesUpdateService('AjaxOrgRolesUpdate', postOrgRolesAssignHandler, postRefreshHandlerParameters);
			wcService.invoke(service.getParam("id"), params);
		} else {
			MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORG_ROLES_UPDATE_NO_CHNAGE"));
		}
	},

	preSelectAssignedRoles:function(selectedRoleIds){
		this.initialSelectedRolesList = [];
		var assignedRoles = $("#" + selectedRoleIds).val();
		var assignedRoleIds = assignedRoles.split(",");
		if(assignedRoleIds.length > 0){
			var checkBox = $('#orgRolesEdit').find('.arrowForDojoQuery');
			for(var i = 0; i < checkBox.length; i++){
				var roleId = checkBox[i].getAttribute("data-orgRolesId");
				
				for(var j = 0; j < assignedRoleIds.length; j++){
					if(assignedRoleIds[j] == roleId){
						$(checkBox[i]).addClass("arrow");
						$(checkBox[i]).attr("aria-checked","true");
						this.initialSelectedRolesList[this.initialSelectedRolesList.length] = roleId;
						break;
					} else {
						$(checkBox[i]).removeClass("arrow");
						$(checkBox[i]).attr("aria-checked","false");
					}
				}
			}
		}
		console.debug("List of roleIds == "+this.initialSelectedRolesList);
	},

	/**
	* Subscribe to 'organizationChanged' topic and respond to it by updating the roles available for the selected newOrgId
	*/
	subscribeToOrgChangeEvent:function(currentOrgEntityId){
		var topicName = "organizationChanged";
		var renderContext = wcRenderContext.getRenderContextProperties("orgRolesContext");
		renderContext["orgEntityId"] = currentOrgEntityId;
		$(document).ready(function() {
			wcTopic.subscribe("organizationChanged", function(data){
				var renderContext = wcRenderContext.getRenderContextProperties("orgRolesContext");
				if(renderContext["orgEntityId"] != data.newOrgId){
					// Only update if currentOrgId has changed in the drop down box...
					setCurrentId("orgRolesUpdateProgressBar");
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wcRenderContext.updateRenderContext("orgRolesContext", {'orgEntityId' : data.newOrgId, 'roleDisplayType':'create', "progressBarId":'orgRolesUpdateProgressBar'});	
				}
			});
		});
	}
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * Declares a new render context for the Organization Summary widget - To display basic summary of organziation
 */
wcRenderContext.declare("orgSummaryDisplayContext",["orgSummary","orgSummaryAddressRefreshArea","orgSummaryContactInfoRefreshArea"],{
	'orgEntityId':null, 
	'orgSummaryType':null,
	'progressBarId':null, 
	'widgetrefreshtype':null
});

/** 
 * Declares a new refresh controller for the Organization Summary widget
 */
var declareOrgSummaryController = function (divId) {
	var myWidgetObj = $("#" + divId);
	
	var myRCProperties = wcRenderContext.getRenderContextProperties("orgSummaryDisplayContext");

	var baseURL = getAbsoluteURL() + 'OrgSummaryDisplayViewV2';
	
	wcTopic.subscribe(["AjaxOrgSummaryUpdate"], function() {
		myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
		//properties of widget should be always in lower case. widgetRefreshType doesn't work.
		if(myRCProperties['widgetrefreshtype'] == myWidgetObj.attr("widgetrefreshtype")){
			setCurrentId(myRCProperties["progressBarId"]);
			submitRequest();
			cursor_wait();
			myWidgetObj.refreshWidget("refresh", myRCProperties);
		}
	});

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
			myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
			myWidgetObj.html("");
			myWidgetObj.refreshWidget("refresh", myRCProperties);
		},

		postRefreshHandler: function() {
			cursor_clear();
			widgetCommonJS.removeSectionOverlay();
		}
	});
};


organizationSummaryJS = {

	widgetShortName: "OrgSummaryWidget", // My Name
	mandatoryFields : "",
	OrganizationCreateEditViewName:"OrganizationCreateEditView",

	//infoJsonData :{'parameterNameUsedByCommand':'fieldNameInUI'}

	orgInfoJsonData : {"orgEntityName":"orgName"},
	orgValidationData : [ {"fieldName":"orgName", "type":"any", "maxLength":"128", "required":"true", "errorMessageKey":"ERROR_OrgName"}],

	contactInfoJsonData : {"email1":"email1", "phone1":"phone1", "fax1":"fax1"},
	contactValidationData : [
								{"fieldName":"email1", "type":"email", "maxLength":"256", "required":"true", "errorMessageKey":"ERROR_Email"},
								{"fieldName":"phone1", "type":"phone", "maxLength":"32", "required":"false", "errorMessageKey":"ERROR_Phone"},
								{"fieldName":"fax1", "type":"any", "maxLength":"32", "required":"false", "errorMessageKey":"ERROR_Fax"}
							],

	addressInfoJsonData : {"address1":"address1", "city":"city", "state":"state", "country":"country", "zipCode":"zipCode"},
	addressValidationData : [
									{"fieldName":"address1", "type":"any", "maxLength":"50", "required":"nls", "errorMessageKey":"ERROR_Address"},
									{"fieldName":"city", "type":"any", "maxLength":"128", "required":"nls", "errorMessageKey":"ERROR_City"},
									{"fieldName":"state", "type":"any", "maxLength":"128", "required":"nls", "errorMessageKey":"ERROR_State"},
									{"fieldName":"country", "type":"any", "maxLength":"128", "required":"nls", "errorMessageKey":"ERROR_Country"},
									{"fieldName":"zipCode", "type":"any", "maxLength":"40", "required":"nls", "errorMessageKey":"ERROR_ZipCode"}
								],

	summaryInfoJsonData:  {'description':'orgDescription','businessCategory':'orgBusinessCategory'},
	summaryValidationData: [
								{"fieldName":"orgDescription", "type":"any", "maxLength":"512", "required":"false", "errorMessageKey":"ERROR_OrganizationDescription"},
								{"fieldName":"orgBusinessCategory", "type":"any", "maxLength":"128", "required":"false", "errorMessageKey":"ERROR_BusinessCategory"}
							],

	/**
	* Subscribe to 'organizationChanged' topic and respond to it by updating the organization summary for the newOrgId
	*/
	subscribeToOrgChangeEvent:function(currentOrgEntityId){
		var topicName = "organizationChanged";

		var renderContext = wcRenderContext.getRenderContextProperties("orgSummaryDisplayContext");
		renderContext["orgEntityId"] = currentOrgEntityId;

		$(document).ready(function() {
			wcTopic.subscribe("organizationChanged", function(data){
				var renderContext = wcRenderContext.getRenderContextProperties("orgSummaryDisplayContext");
				if(renderContext["orgEntityId"] != data.newOrgId){
					setCurrentId("orgSummaryInfoProgressBar");
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wcRenderContext.updateRenderContext("orgSummaryDisplayContext", {'orgEntityId' : data.newOrgId, 'orgSummaryType':null, "progressBarId":null});	
				}
			});

		});
	},


	/**
	* Publishes 'currentOrgIdRequest' topic.
	* Organization List widget will respond to this event and publishes the "currentOrgId" topic along with the orgId.
	* Responds to "currentOrgId" topic event by refreshing the organization summary data for the newOrgId
	*/
	publishOrgIdRequest:function(){
		var topicName = "currentOrgIdRequest";
		var scope = this;
		$(document).ready(function() {
			wcTopic.subscribe("currentOrgId", function(data){
				if(data.requestor === scope.widgetShortName){
					// The original request was from me. So respond to this event.
					wcRenderContext.updateRenderContext("orgSummaryDisplayContext", {'orgEntityId' : data.newOrgId, 'orgSummaryType':null, "progressBarId":null});	
				}
			});
			// Set the requestor to my widgetShortName. 
			// Respond to follow-up events, only if the event published was in response to my request. 
			// The requestor attribute in the data helps to check this.
			var data = {"requestor":scope.widgetShortName};
			wcTopic.publish(topicName, data);
		});
	},

	redirectToCreateEditPage:function(orgEntityCreateEditViewName, actionType){
		if(actionType == 'E'){
			// Publish an event and get back the current organizaiton ID
			var topicName = "currentOrgIdRequest";
			var scope = this;
			$(document).ready(function() {	
				wcTopic.subscribe("currentOrgId", function(data){
					if(data.requestor == "CreateEditAction"){
						// The original request was from me. So respond to this event.
						document.location.href = orgEntityCreateEditViewName+"&orgEntityId="+data.newOrgId;
					}
				});
				// Set the requestor == CreateEditAction. 
				// Respond to follow-up events, only if the event published was in response to my request. 
				// The requestor attribute in the data helps to check this.
				var data = {"requestor":"CreateEditAction"};
				wcTopic.publish(topicName, data);
			});

		} else if(actionType == 'C'){
			// Publish an event and get back the current organizaiton ID
			var topicName = "currentOrgIdRequest";
			var scope = this;
			$(document).ready(function() {
				wcTopic.subscribe("currentOrgId", function(data){
					if(data.requestor == "CreateEditAction"){
						// The original request was from me. So respond to this event.
						var url = orgEntityCreateEditViewName;
						if(data != null && data.newOrgId != null){
							url = url + "&parentOrgEntityId="+data.newOrgId;
						}
						if(data != null && data.newOrgName != null){
							url = url + "&parentOrgEntityName="+data.newOrgName;
						}
						document.location.href = url;
					}
				});
				// Set the requestor == CreateEditAction. 
				// Respond to follow-up events, only if the event published was in response to my request. 
				// The requestor attribute in the data helps to check this.
				var data = {"requestor":"CreateEditAction"};
				wcTopic.publish(topicName, data);
			});
		}

	},

	postOrgCreation:function(serviceResponse,progressBarId){
		console.debug("serviceResponse after org creation ", serviceResponse);
		console.debug(progressBarId);
		console.debug("Start updating roles for "+serviceResponse.orgEntityId);

		var checkBox = $('#orgRolesEdit').find('.arrow');
		if(checkBox.length == 0){
			MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORG_ROLES_UPDATE_NO_CHNAGE"));
			this.postRolesCreation(serviceResponse);
			return false;
		}

		var params = [];
		params.memberId = serviceResponse.orgEntityId;
		params.authToken = $("#authToken").val();
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";
		params.action = "assignRole";

		for(var i = 0; i < checkBox.length; i++){
			var roleId = checkBox[i].getAttribute("data-orgRolesId");
			params["roleId"+i] = roleId;
		}
		
		setCurrentId(progressBarId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		var rolesService = organizationRolesJS.getOrgRolesUpdateService('AjaxOrgRolesUpdateDuringOrgCreate', this.postRolesCreation, serviceResponse);
		wcService.invoke(rolesService.getParam("id"), params);

	},

	postRolesCreation:function(serviceResponse, jsonObject){
		var orgEntityId = null;
		if(jsonObject != null && jsonObject != 'undefined' && jsonObject.orgEntityId != null){
			orgEntityId = jsonObject.orgEntityId;
		} else if(serviceResponse != null && serviceResponse != 'undefined' && serviceResponse.orgEntityId != null){
			orgEntityId = serviceResponse.orgEntityId;
		}
		document.location.href = organizationSummaryJS.OrganizationCreateEditViewName+"?"+getCommonParametersQueryString()+"&orgEntityId="+orgEntityId;
	},

	invokeOrgEntityCreateService:function(params,progressBarId){
		
		var service = wcService.getServiceById('AjaxOrgEntityAdd');
		var scope = this;

		if(service == null || service == undefined){
			/**
			 */
			wcService.declare({
				id: "AjaxOrgEntityAdd",
				actionId: "AjaxOrgEntityAdd",
				url: getAbsoluteURL() + "AjaxRESTOrganizationRegistration",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORG_ENTITY_CREATED_UPDATING_ROLES"));
					scope.postOrgCreation(serviceResponse,progressBarId);
				}
				
				/**
				 * Displays an error message on the page if the request failed.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
				 */
				,failureHandler: function(serviceResponse) {
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
		}
		
		setCurrentId(progressBarId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";
		wcService.invoke("AjaxOrgEntityAdd", params);
	},

	invokeOrgEntityUpdateService:function(orgEntityId, params,jsonData,editSectionId){
		
		var service = wcService.getServiceById('AjaxOrgSummaryUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wcService.declare({
				id: "AjaxOrgSummaryUpdate",
				actionId: "AjaxOrgSummaryUpdate",
				url: getAbsoluteURL() + "AjaxRESTOrganizationUpdate",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORG_SUMMARY_UPDATED"));
				}
				
				/**
				 * Displays an error message on the page if the request failed.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
				 */
				,failureHandler: function(serviceResponse) {
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
		}
		
		setCurrentId(editSectionId+'Icon');
		if(!submitRequest()){
			return;
		}
		cursor_wait();

		for(i in jsonData){
			var node = $("#" + jsonData[i])[0];
			if(node == null || node == 'undefined'){
				node = $("[name="+jsonData[i]+"]")[0];
			}
			console.debug(" node for", jsonData[i], node);
			params[i] = node.value;
		}

		params.orgEntityId = orgEntityId;
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";

		wcService.invoke("AjaxOrgSummaryUpdate", params);
	},

	updateOrgSummaryDisplayContext:function(orgEntityId, refreshType, progressBarId){
		var context = wcRenderContext.getRenderContextProperties("orgSummaryDisplayContext");
		context["orgEntityId"] = orgEntityId;
		context["orgSummaryType"] = 'edit';
		context["progressBarId"] = progressBarId;

		// Reset all
		context["orgSummaryBasicEdit"] = 'false';
		context["orgSummaryAddressEdit"] = 'false';
		context["orgSummaryContactInfoEdit"] = 'false';
		context["widgetrefreshtype"] = refreshType;

		if(refreshType == 'basic'){
			context["orgSummaryBasicEdit"] = 'true';
		} else 	if(refreshType == 'address'){
			context["orgSummaryAddressEdit"] = 'true';
		} else 	if(refreshType == 'contactInfo'){
			context["orgSummaryContactInfoEdit"] = 'true';
		}
	},

	updateOrganizationSummary:function(orgEntityId, editSectionId){
		if(!this.validateData(this.summaryValidationData)) {
			return;
		} else {
			// Close Edit Section and display readOnly section.
			widgetCommonJS.toggleReadEditSection(editSectionId, 'read')
		}
		var params = [];
		this.updateOrgSummaryDisplayContext(orgEntityId,"basic",editSectionId+"Icon");
		this.invokeOrgEntityUpdateService(orgEntityId,params,this.summaryInfoJsonData,editSectionId);
	},

	updateOrganizationAddress:function(orgEntityId, editSectionId){
		
		if(!this.validateData(this.addressValidationData)){
			return;
		} else {
			// Close Edit Section and display readOnly section.
			widgetCommonJS.toggleReadEditSection(editSectionId, 'read')
		}

		var params = [];
		this.updateOrgSummaryDisplayContext(orgEntityId,"address",editSectionId+"Icon");
		this.invokeOrgEntityUpdateService(orgEntityId,params,this.addressInfoJsonData,editSectionId);
	},

	updateOrganizationContactInfo:function(orgEntityId, editSectionId){
		if(!this.validateData(this.contactValidationData)) {
			return;
		} else {
			// Close Edit Section and display readOnly section.
			widgetCommonJS.toggleReadEditSection(editSectionId, 'read')
		}
		var params = [];
		this.updateOrgSummaryDisplayContext(orgEntityId,"contactInfo", editSectionId+"Icon");
		this.invokeOrgEntityUpdateService(orgEntityId,params,this.contactInfoJsonData,editSectionId);

	},

	updateParameterValues:function(params,jsonData){
		for(i in jsonData){
			var node = $("#" + jsonData[i])[0];
			if(node == null || node == 'undefined'){
				node = $("[name="+jsonData[i]+"]")[0];
			} 
			if(node != null){
				console.debug("for ", i, "value is ",node.value);
				params[i] = node.value;
			} else {
				console.debug("For ",  i, "value is null");
			}
		}
	},
	createOrgEntity:function(progressBarId){

		if(!this.validateData(this.orgValidationData)) return false;
		var parentMemberId = organizationListJS.getCurrentData()['newOrgId'];
		if(parentMemberId == null || parentMemberId == 'undefined' || parentMemberId.length == 0 ){
			if($("#orgNameInputField")[0] != 'undefined' && $("#orgNameInputField")[0] != null){
				MessageHelper.formErrorHandleClient("orgNameInputField", Utils.getLocalizationMessage("ERROR_ParentOrgNameEmpty"));
				return false;
			}
		}
		//if(!this.validateData(this.summaryValidationData)) return false;
		if(!this.validateData(this.addressValidationData)) return false;
		if(!this.validateData(this.contactValidationData)) return false;

		var params = [];
		this.updateParameterValues(params,this.orgInfoJsonData);
		this.updateParameterValues(params,this.summaryInfoJsonData);
		this.updateParameterValues(params,this.addressInfoJsonData);
		this.updateParameterValues(params,this.contactInfoJsonData);

		params['parentMemberId'] = parentMemberId
		params['orgEntityType'] = 'O'; // Always create organization type. OrganizationalUnit type is not supported.
		params['addToRegisteredCustomersGroup'] = 'true'; // Make this new organization as part of RegisteredCustomers member group owned by the stores owning organization.
		this.invokeOrgEntityCreateService(params,progressBarId);
	},

	setMandatoryFields:function(fields){
		this.mandatoryFields = fields;
	},

	validateData:function(validationData){
		reWhiteSpace = new RegExp(/^\s+$/);
		for(var i = 0; i < validationData.length; i++){
			//console.debug("The validation data at ",i, "is ", validationData[i]);
			var data = validationData[i];
			var fieldName = data["fieldName"];
			var fieldType = data["fieldType"];
			var node = $("[name="+fieldName+"]")[0];
			var required = data["required"];
			var dataType = data["type"];
			var maxLength = data["maxLength"];
			var errorMessageKey = data["errorMessageKey"];


			if(node != null && node != 'undefined'){
				var value = node.value;
				console.debug("value == ",value, "for fieldName ",fieldName);
				console.debug("Requried == ",required);
				console.debug("set of mandatory fields == ",this.mandtoryFields);
				console.debug("Requried by NLS rule == ",this.mandatoryFields.indexOf(fieldName));
				// IsMandatory validation
				if(required == 'true' || (required == "nls" && this.mandatoryFields.indexOf(fieldName) != "-1")){
					if(value == "" || reWhiteSpace.test(value)){
						console.debug("empty .. show error message for ",node.id);
						if(node.tagName == "SELECT" || node.tagName == "select") {
							// for jquery select menu
							MessageHelper.formErrorHandleClient(node.id + "-button", Utils.getLocalizationMessage(errorMessageKey+"Empty"));
						} else {
							MessageHelper.formErrorHandleClient(node.id, Utils.getLocalizationMessage(errorMessageKey+"Empty"));
						}
						return false;
					}
				} 

				// MaxLength validation
				if(maxLength != "-1"){
					console.debug("max length == ",maxLength);
					if(!MessageHelper.isValidUTF8length(value, data["maxLength"])){ 
						MessageHelper.formErrorHandleClient(node.id, Utils.getLocalizationMessage(errorMessageKey+"TooLong"));
						return false;
					}
				}

				// Data Type validation
				if(dataType == "email"){
					if(!MessageHelper.isValidEmail(value)){
						MessageHelper.formErrorHandleClient(node.id, Utils.getLocalizationMessage("ERROR_INVALIDEMAILFORMAT"));
						return false;
					}
				} else if(dataType == "phone"){
					if(!MessageHelper.IsValidPhone(value)){
						MessageHelper.formErrorHandleClient(node.id, Utils.getLocalizationMessage("ERROR_INVALIDPHONE"));
						return false;
					}
				} else if(dataType == "numeric"){
					if(!MessageHelper.IsNumeric(value)){
						MessageHelper.formErrorHandleClient(node.id, Utils.getLocalizationMessage("ERROR_INVALID_NUMERIC"));
						return false;
					}
				}
			}
		}
		return true;
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
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage member info.
 * This file is included in all pages with organization users list actions.
 */

/**
 * This service allows admin to update member info
 * @constructor
 */
wcService.declare({
	id:"OrganizationUserInfoAdminUpdateMember",
	url:"AjaxRESTUserRegistrationAdminUpdate"

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSERINFO_UPDATE_SUCCESS"]);
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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


/**
 * This service allows admin to add/create new member
 * Upon successfully creating user, the successHandler will call 
 * UserRoleManagementJS.assignRole function
 * @constructor
 */
wcService.declare({
	id:"chainedAjaxUserRegistrationAdminAdd",
	url:"AjaxRESTUserRegistrationAdminAdd",
	formId:"Register"

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		if (typeof(UserRoleManagementJS) != 'undefined' && !UserRoleManagementJS.isEmptySelectedRoles()){
			UserRoleManagementJS.chainedAssignRole(serviceResponse.userId);
		}
		else {
			document.location.href = OrganizationUserInfoJS.getChainedServiceRediretUrl();
			cursor_clear();		
			MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSER_CREATE_SUCCESS"]);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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


 	
	/**
	 * This class defines the functions and variables that customers can use to create, update, and view user.
	 * @class The OrganizationUserInfoJS class defines the functions and variables that can be used to manage Organization users 
	 */
	OrganizationUserInfoJS ={		
		
		widgetShortName: "OrgUserUserInfoWidget",
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
		
		/** 
		 * This variable stores the redirect url for chained create user service upon success.
		 * 
		 */
		chainedServiceRedirectUrl: "",	
		
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters:function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
			cursor_clear();
		},	
		
		/**
		 * Initialize the URL of Buyer List widget controller. 	 
		 *
		 * @param {object} userDetailsUrl The userDetails controller's URL.
		 * @param {object} userAddressUrl The userAddress controller's URL.
		 */
		initOrganizationUserInfoControllerUrls:function(userDetailsUrl,userAddressUrl){
			$("#OrganizationUserInfo_userDetail_Widget").attr("refreshurl", userDetailsUrl);
			$("#OrganizationUserInfo_userAddress_Widget").attr("refreshurl", userAddressUrl);
		},
		
		/**
		 * Initialize the Parent org info that the buyer to be created under. Will be used for constructing url return
		 * to "Organizations and buyers" page with pre-selected org. 
		 *
		 * @param {object} parentOrgName The parent Organization name.
		 * @param {object} parentOrgId The parentOrganization ID.
		 */
		initializeParentOrgInfo:function(parentOrgName, parentOrgId){
			this._parentOrgEntityName = parentOrgName;
			this._parentOrgEntityId = parentOrgId;
		},
		
		/**
		 * Update member user account status to 'Enabled' or 'Disalbed', status 0 means disabled, status 1 means enabled.
		 * 
		 * @param formId The id of the form to update
		 */
		saveUserInfoChange:function(form){
			if (! this.validateAndPrepareUserInfo(form)) return;
			wcService.getServiceById('OrganizationUserInfoAdminUpdateMember').setFormId(form.id);
			wcService.getServiceById('OrganizationUserInfoAdminUpdateMember').setActionId("OrganizationUserInfoAdminUpdateMember_" + form.id);
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('OrganizationUserInfoAdminUpdateMember');
		},
		
		/**
		 * This function validate and prepare the update form for submit, the form is used to update user info.
		 * @param {string} form The name of the form containing personal information of the customer.
		 */
		validateAndPrepareUserInfo:function(form){
			if (form.name != 'UserAddress') {
				if(typeof(form.logonPassword_old) != 'undefined' && typeof(form.logonPasswordVerify_old) != 'undefined'){
					if(form.logonPassword_old.name == "logonPassword") {
						form.logonPassword_old.name = "logonPassword_old";
						form.logonPasswordVerify_old.name = "logonPasswordVerify_old";
					}
					/*check whether the values in password and verify password fields match, if so, update the password. */ 
					if (form.logonPassword_old.value.length != 0)
					{
						if(form.logonPassword_old.value!= form.logonPasswordVerify_old.value)
						{
							MessageHelper.formErrorHandleClient(form.logonPasswordVerify_old.id,MessageHelper.messages["PWDREENTER_DO_NOT_MATCH"]);
							return false; 
						}
						form.logonPassword_old.name = "logonPassword";
						form.logonPasswordVerify_old.name = "logonPasswordVerify";
					}
				}
			}
			
			/** Uses the common validation function defined in AddressHelper class for validating first name, 
			 *  last name, street address, city, country/region, state/province, ZIP/postal code, e-mail address and phone number. 
			 */

			if(!AddressHelper.validateAddressForm(form)){
				return false;
			}
			
			/* Checks whether the customer has registered for promotional e-mails. */
			if(form.sendMeEmail && form.sendMeEmail.checked ){
			    if (form.receiveEmail) form.receiveEmail.value = true;
			}
			else {
				if (form.receiveEmail) form.receiveEmail.value = false;
			}
			
			if(form.sendMeSMSNotification && form.sendMeSMSNotification.checked){
				if (form.receiveSMSNotification) form.receiveSMSNotification.value = true;
			}
			else {
				if (form.receiveSMSNotification) form.receiveSMSNotification.value = false;
			}

			if(form.sendMeSMSPreference && form.sendMeSMSPreference.checked){
				if (form.receiveSMS)form.receiveSMS.value = true;
			}
			else {
				if (form.receiveSMS) form.receiveSMS.value = false;
			}

			if(form.mobileDeviceEnabled != null && form.mobileDeviceEnabled.value == "true"){
				if(!MyAccountDisplay.validateMobileDevice(form)){
					return false;
				}
			}
			if(form.birthdayEnabled != null && form.birthdayEnabled.value == "true"){
				if(!MyAccountDisplay.validateBirthday(form)){
					return false;
				}
			}
			return true;
		},

		/**
		* Publishes 'currentOrgIdRequest' topic.
		* Organization List widget will respond to this event and publishes the "currentOrgId" topic along with the orgId.
		* Responds to "currentOrgId" topic event by refreshing the organization summary data for the newOrgId
		*/
		publishOrgIdRequest:function(){
			var topicName = "currentOrgIdRequest";
			var scope = this;
			
			wcTopic.subscribe("currentOrgId", function(data){
				if(data.requestor === scope.widgetShortName){
					// The original request was from me. So respond to this event.
					var parentMemberIdInput = $("#WC_OrganizationUserInfo_userDetails_Form_Input_parentMemberId");
					parentMemberIdInput.attr("value",data.newOrgId);
					scope._parentOrgEntityName = data.newOrgName;
					scope._parentOrgEntityId = data.newOrgId;
				}
				// Set the requestor to my widgetShortName. 
				// Respond to follow-up events, only if the event published was in response to my request. 
				// The requestor attribute in the data helps to check this.
				var data = {"requestor":scope.widgetShortName};
				wcTopic.publish(topicName, data);
			});
		},
		
		/**
		* Subscribe to 'organizationChanged' topic.
		* Organization User Info widget will respond to this topic event by updating the parentMemberId to newOrgId
		*/
		subscribeToOrgChange:function() {
			var topicName = "organizationChanged";
			var scope = this;
			wcTopic.subscribe(topicName, function(data){
				//console.debug("organizationChanged received");
				var parentMemberIdInput = $("#WC_OrganizationUserInfo_userDetails_Form_Input_parentMemberId");
				parentMemberIdInput.attr("value",data.newOrgId);
				scope._parentOrgEntityName = data.newOrgName;
				scope._parentOrgEntityId = data.newOrgId;
			});
		},
		 	
	 	resetFormValue: function(target){
	 		$(target).find("form").each(function(index, form){
				$(form)[0].reset();
				$(form).find("select.wcSelect").each(function(index, select){
					$(select).Select("refresh_noResizeButton");
				})
			});
	 	},
	 	
	 	subscribeToToggleCancel: function(){
	 		var topicName = "sectionToggleCancelPressed";
	 		var scope = this;
	 		wcTopic.subscribe(topicName, function(data){
	 			if (data.target === 'WC_OrganizationUserInfo_userDetails_pageSection' || data.target === 'WC_OrganizationUserInfo_userAddress_pageSection'){
	 				scope.resetFormValue(document.getElementById(data.target));
	 			}
	 		});
	 	},
	 	
	 	/**
	 	 * The function is called from add/create buyer page submit button, in 'chainedAjaxUserRegistrationAdminAdd' successHandler
	 	 * will call role assignment and member group widget's service.
	 	 * @param form the user details and address form to submit
	 	 * @url the url for the store page that will be displayed upon submit success.
	 	 */
	 	chainedServicePrepareSubmit: function(form, url) {
			var random = Math.random();
			var randomPassword = random.toString(36).slice(-7); // Get last 7 chars. Will add one numeric char to make it 8 char long...
			var randomInt = Math.floor((random * 9) + 1);
			randomPassword += randomInt; //Password should contain at least one numeric character...
			if($("#logonPassword")[0] == null || $("#logonPassword")[0] == undefined){
				$(form).append( $('<input>', {
					type: "hidden",
					value: randomPassword,
					name: "logonPassword",
					id: "logonPassword",
				}));
			}
			if($("#logonPasswordVerify")[0] == null || $("#logonPasswordVerify")[0] == undefined){
				$(form).append( $('<input>', {
					type: "hidden",
					value: randomPassword,
					name: "logonPasswordVerify",
					id: "logonPasswordVerify"
				}));
			}
			if($("#passwordExpired")[0] == null || $("#passwordExpired")[0] == undefined){
				$(form).append( $('<input>', {
					type: "hidden",
					value: "1",
					name: "passwordExpired",
					id: "passwordExpired"
				}));
			}

	 		if (!LogonForm.validatePrepareForm(form)){
	 			return;
	 		}
	 		this.chainedServiceRedirectUrl = url;
	 		wcService.getServiceById('chainedAjaxUserRegistrationAdminAdd').setFormId(form.id);
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('chainedAjaxUserRegistrationAdminAdd');
	 	},
	 	
	 	/**
	 	 * Return URL with pre-selected Organization info.
	 	 */
	 	getChainedServiceRediretUrl: function(){
	 		var url = this.chainedServiceRedirectUrl;
	 		if (url != '' && this._parentOrgEntityId !== undefined && this._parentOrgEntityId !== null){
	 			url = url + '&orgEntityId='+ this._parentOrgEntityId + '&orgEntityName='+ this._parentOrgEntityName;
	 		}
	 		return url;
	 	}
	 	
	};
 	
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/**
 * Declares a new refresh controller for read only user details section.
 */
function declareOrganizationUserInfo_userDetail_controller() {
	var myWidgetObj = $("#OrganizationUserInfo_userDetail_Widget");
	 
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["OrganizationUserInfoAdminUpdateMember_UserDetails","AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer"], function() {
		myWidgetObj.refreshWidget("refresh");
	});
	
	myWidgetObj.refreshWidget({
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			widgetCommonJS.removeSectionOverlay();
			cursor_clear();
			//Initialize toggle events after page refresh
			widgetCommonJS.initializeEditSectionToggleEvent();
		}
	});
};

/**
 * Declares a new refresh controller for read only user address section.
 */
function declareOrganizationUserInfo_userAddress_controller() {
	var myWidgetObj = $("#OrganizationUserInfo_userAddress_Widget");
	
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["OrganizationUserInfoAdminUpdateMember_UserAddress"], function() {
		myWidgetObj.refreshWidget("refresh");
	});
	
	myWidgetObj.refreshWidget({
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			widgetCommonJS.removeSectionOverlay();
			cursor_clear();
			//Initialize toggle events after page refresh
			widgetCommonJS.initializeEditSectionToggleEvent();
		}
	});
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage buyers list and the items within.
 * This file is included in all pages with organization users list actions.
 */

/**
 * This service allows customer to create a new requisition list
 * @constructor
 */
wcService.declare({
	id:"OrganizationUsersListAdminUpdateMember",
	actionId:"OrganizationUsersListAdminUpdateMember",
	url:"AjaxRESTUserRegistrationAdminUpdate",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSERSLIST_UPDATE_USERSTATUS_SUCCESS"]);
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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

/**
 * This class defines the functions and variables that customers can use to create, update, and view their buyers list.
 * @class The OrganizationUsersListJS class defines the functions and variables that customers can use to manage their buyers list, 
 */
OrganizationUsersListJS ={		
	
	widgetShortName: "OrgUsersListWidget",
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
	
	viewUserURL: "",
	
	addUserURL: "",
	
	/**
	 * Sets the common parameters for the current page. 
	 * For example, the language ID, store ID, and catalog ID.
	 *
	 * @param {Integer} langId The ID of the language that the store currently uses.
	 * @param {Integer} storeId The ID of the current store.
	 * @param {Integer} catalogId The ID of the catalog.
	 * @param {Integer} authToken The authToken for current user to perform operation on server.
	 * @param {String} viewUserURL The URL for viewing and editing user.
	 * @param {String} addUserURL The URL for adding a user.
	 */
	setCommonParameters:function(langId,storeId,catalogId,authToken,viewUserURL,addUserURL){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		this.authToken = authToken;
		this.viewUserURL = viewUserURL;
		this.addUserURL = addUserURL;
		cursor_clear();
	},	
	
	/**
	 * Initialize the URL of Buyer List widget controller. 	 
	 *
	 * @param {object} widgetUrl The controller's URL.
	 */
	initOrganizationUsersListUrl:function(widgetUrl){
		$("#OrganizationUsersListTable_Widget").attr("refreshurl", widgetUrl);
	},
	
	/**
	 * Initial context with Organization info.
	 */
	initContextOrgEntity:function(orgEntityId, orgEntityName){
		wcRenderContext.getRenderContextProperties("OrganizationUsersListTable_Context").orgEntityId = orgEntityId;
		wcRenderContext.getRenderContextProperties("OrganizationUsersListTable_Context").orgEntityName = orgEntityName;
	},
	
	/**
	 * Search for Organization users use the search terms specified in the toolbar search form.
	 * 
	 * @param formId	The id of toolbar search form element.
	 */
	doSearch:function(formId){
		var form = $("#" + formId);
		this.updateContext({"beginIndex":"0", "userFirstName":form[0].userFirstName.value, "userLastName":form[0].userLastName.value, "userLogonId":form[0].userLogonId.value, "userRoleId":form[0].userRoleId.value, "userAccountStatus":form[0].userAccountStatus.value});
	},
	
	/**
	 * Clear the context search term value set by search form
	 */
	reset:function(){
		this.updateContext({"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":""});
	},
	
	/**
	 * Save the toolbar aria-expanded attribute value
	 */
	saveToolbarStatus:function(){
		var toolbar = $("#OrganizationUsersList_toolbar");
		if (toolbar !== undefined && toolbar !== null){
			this.toolbarExpanded = toolbar.attr("aria-expanded");
		}
	},
	
	/**
	 * Restore the toolbar aria-expanded attribute, called by post refresh handler
	 */
	restoreToolbarStatus:function(){
		if (this.toolbarExpanded !== undefined && this.toolbarExpanded !== null){
			$("#OrganizationUsersList_toolbar").attr("aria-expanded", this.toolbarExpanded);
		}
	},
	
	/**
	 * Update the OrganizationUsersListTable context with given context object.
	 * 
	 * @param context The context object to update
	 */
	updateContext:function(context){
		this.saveToolbarStatus();
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcRenderContext.updateRenderContext("OrganizationUsersListTable_Context", context);
	},
	
	/**
	 * Update member user account status to 'Enabled' or 'Disalbed', status 0 means disabled, status 1 means enabled.
	 * 
	 * @param memberId The is of the member to be enable or disable
	 * @param status The '0' or '1' status
	 */
	updateMemberStatus:function(memberId, status){
		var params = {};
		params.URL = "StoreView"; //old command still check the presence of the 'URL' parameter
		params.storeId = this.storeId;
		params.langId = this.langId;
		params.userId = memberId;
		params.userStatus = status;
		params.authToken = this.authToken;
		this.saveToolbarStatus();
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke('OrganizationUsersListAdminUpdateMember',params);
	},
	
	/**
	 * Redirect to add user detail page.
	 */
	addUser:function(){
		var orgEntityId = wcRenderContext.getRenderContextProperties("OrganizationUsersListTable_Context")['orgEntityId'];
		var orgName = wcRenderContext.getRenderContextProperties("OrganizationUsersListTable_Context")['orgEntityName'];
		//if (parentMemberId == "") parentMemberId = "7000000000000000801"; 
		var URL = this.addUserURL + "&orgEntityId=" + orgEntityId + "&orgEntityName=" + orgName;
		setPageLocation(URL);
	},
	
	/**
	 * Redirect to view user details page.
	 * 
	 * @param memberId The ID of the user
	 */
	viewDetails:function(memberId){
		var URL = this.viewUserURL + "&memberId=" + memberId;
		setPageLocation(URL);
		return false;
	},
	
	/**
	 * Update context to show page according specific number.
	 * 
	 * @param data The data for updating context.
	 */
	showPage:function(data){
		var pageNumber = data['pageNumber'];
		var pageSize = data['pageSize'];
		pageNumber = parseInt(pageNumber);
		pageSize = parseInt(pageSize);
		var beginIndex = pageSize * ( pageNumber - 1 );
		setCurrentId(data["linkId"]);
		//client has no way to change pageSize, so default pageSize defined in EnvironmentSetup.jspf will be used
		this.updateContext({"beginIndex":beginIndex});
	},
	
	/**
	* Publishes 'currentOrgIdRequest' topic.
	* Organization List widget will respond to this event and publishes the "currentOrgId" topic along with the orgId.
	* Responds to "currentOrgId" topic event by refreshing the organization summary data for the newOrgId
	*/
	publishOrgIdRequest:function(){
		var topicName = "currentOrgIdRequest";
		var scope = this;
		$(document).ready(function() {
			wcTopic.subscribe("currentOrgId", function(data){
				if(data.requestor === scope.widgetShortName){
					// The original request was from me. So respond to this event.
					scope.toolbarExpanded = "false";
					if (data.newOrgId.replace(/^\s+|\s+$/g, '') == ''){
						return;
					}
					if(!submitRequest()){
						return;
					}			
					cursor_wait();
					wcRenderContext.updateRenderContext("OrganizationUsersListTable_Context", {"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":"","orgEntityId" : data.newOrgId, "orgEntityName": data.newOrgName});
				}
			});
			// Set the requestor to my widgetShortName. 
			// Respond to follow-up events, only if the event published was in response to my request. 
			// The requestor attribute in the data helps to check this.
			var data = {"requestor":scope.widgetShortName};
			wcTopic.publish(topicName, data);
		});
	},
	
	/**
	* Subscribe to 'organizationChanged' topic.
	* Organization Users List widget will respond to this topic event by refreshing the organization user list data for the newOrgId
	*/
	subscribeToOrgChange:function(data) {
		var topicName = "organizationChanged";
		var scope = this;
		$(document).ready(function() {
			wcTopic.subscribe(topicName, function(data){
				//console.debug("organizationChanged received");
				var renderContext = wcRenderContext.getRenderContextProperties("OrganizationUsersListTable_Context");
				if(renderContext["orgEntityId"] != data.newOrgId){
					scope.toolbarExpanded = "false";
					submitRequest();
					cursor_wait();
					wcRenderContext.updateRenderContext("OrganizationUsersListTable_Context", {"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":"","orgEntityId" : data.newOrgId, "orgEntityName": data.newOrgName});
				}
			});
		});
	}
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/**
 * Declares a new render context for creating a new list.
 */
wcRenderContext.declare("OrganizationUsersListTable_Context",["OrganizationUsersListTable_Widget"],{"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":"", "orgEntityId":"", "OrgEntityName":""},"");

/**
 * Declares a new refresh controller for creating a new List.
 */
function declareOrganizationUsersListTable_controller() {
	var myWidgetObj = $("#OrganizationUsersListTable_Widget");
	
	var myRCProperties = wcRenderContext.getRenderContextProperties("OrganizationUsersListTable_Context");
	
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["OrganizationUsersListAdminUpdateMember"], function() {
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	myWidgetObj.refreshWidget({
		/** 
		 * Refreshes the list table display if an item is updated.
		 * This function is called when a render context event is detected. 
		 */	
		renderContextChangedHandler: function() {
			myWidgetObj.html("");
			myWidgetObj.refreshWidget("refresh", myRCProperties);
		},
	
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			OrganizationUsersListJS.restoreToolbarStatus();
			cursor_clear();			 
		}
	});
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

function AddToRequisitionListsJS(storeId, catalogId, langId, dropDownMenuId, selectListMenuId, createListMenuId, listTypeMenuId, listNameFieldId, listTypeFieldId, addResultMenuId, buttonStyle, jsObjectName) {

    this.storeId = storeId;
    this.catalogId = catalogId;
    this.langId = langId;
    this.dropDownMenuId = dropDownMenuId;
    this.selectListMenuId = selectListMenuId;
    this.createListMenuId = createListMenuId;
    this.listTypeMenuId = listTypeMenuId;
    this.listNameFieldId = listNameFieldId;
    this.listTypeFieldId = listTypeFieldId;
    this.addResultMenuId = addResultMenuId;
    this.buttonStyle = buttonStyle;

    this.jsObjectName = jsObjectName;

    this.dropDownVisible = false;

    this.dropDownInFocus = false;

    this.pageName = "";
    this.params = {};

    var eventName = "";

    this.dropDownMenuId = "";
    this.createListMenuId = "";
    this.addResultMenuId = "";
    this.addSingleSKU = false;
    this.addBundle = false;
    this.addPDK = false;
    var product_id = 0;

    var quantity = 1; // One item to add to list by default
    var catEntryId = 0;

    var catEntryResolved = false;
	
	this.addDK = false;
	var configurationXML = "";
	

    /**
     * Re-initializes variables when product is successfully added to a list
     */
    this._initialize = function () {
        this.someRadioButtonChecked = false;
        this.createListDetailsMenuOpen = false;
        this.listTypeMenuOpen = false;
        this.dropDownOpen = false;
        this.addSingleSKU = false;
        this.addBundle = false;
        this.params.status = 'Y'; // Default to private list
    };

    /**
     * Setter for topic.subscribe callback
     */
    this.setQuantity = function (newQuantity) {
        if (newQuantity != '') {
            quantity = newQuantity;
        }
    };
    /**
     * Getter for topic.subscribe callback
     */
    this.getQuantity = function () {
        return quantity;
    };
    /**
     * Setter for topic.subscribe callback
     */
    this.setCatEntryId = function (newCatEntryId, newProductId) {
        if (newCatEntryId != null) {
            catEntryResolved = true;
            catEntryId = newCatEntryId;
            product_id = newProductId;
        } else {
            catEntryResolved = false;
        }

    };
    /**
     * Getter for topic.subscribe callback
     */
    this.getCatEntryId = function () {
        return catEntryId;
    };

    /**
     * Sets product ID to be added to cart
     */
    this.setProductId = function (newProductId) {
        product_id = newProductId;
    };

    /**
     * sets whether a PDK is being added to the list
     */
    this.setAddPDK = function (addpdk) {
        this.addPDK = addpdk;
    };

	/**
	 * sets whether a DK is being added to the requisition list
	 */
	this.setAddDK = function(adddk) {
		this.addDK = adddk;
	};

	/**
	 * sets the configuration xml of the DK
	 */
	this.setConfigurationXML = function(configXML) {
		this.configurationXML = configXML;
	};
	
	/**
	 * Converts xml accepted form to < >
	 * @param {String} str, String to be converted
	 * @return {String} converted string
	 */
	this.unEscapeXml =  function(str){
		return str.replace(/&lt;/gm, "<").replace(/&gt;/gm, ">").replace(/&#034;/gm,"\"");
	};
	
	
    /**
     * Hides the dropdown
     * @param dropDownId - dropdown node
     */
    this._hideDropDownMenu = function (dropDownId) {
        Utils.ifSelectorExists("#" + dropDownId, function (dropDown) {
            dropDown.css("display", "none");
            $('#grayOut').css("display", "none");
            $('#grayOutPopup').css("display", "none");

            this.dropDownVisible = false;
            this.dropDownInFocus = false;
            this.dropDownOpen = false;
        }, this);

        if (document.removeEventListener) {
            document.removeEventListener("keydown", this.trapTabKey, true);
        }
    };

    /**
     * Shows the dropdown
     * @param dropDownId - dropdown node id
     * @param resolveCatentry - if true, then catentry must be resolved before showing drop down menu
     */
    this._showDropDownMenu = function (dropDownId, resolveCatentry) {
        if (resolveCatentry && !catEntryResolved) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_RESOLVED_SKU'));
            return;
        }

        Utils.ifSelectorExists("#" + dropDownId, function (dropDown) {
            dropDown.css("display", "block");
            var radioButtons = $('.radioButton', dropDown);
            if (radioButtons.length) {
                radioButtons[0].focus();
            }
            $('#grayOut').css("display", "block");
            $('#grayOutPopup').css("display", "block");

            this.dropDownVisible = true;
            this.dropDownInFocus = true;
            this.dropDownOpen = true;
            MessageHelper.hideAndClearMessage();
        }, this);

        if (document.addEventListener) {
            document.addEventListener("keydown", this.trapTabKey, true);
        }
    };

    /**
     * Hides the list of requisition lists
     */
    this._hideSelectList = function () {
        $("#" + this.selectListMenuId).css("display", "none");
    };

    /**
     * Shows the list of requisition lists
     */
    this._showSelectList = function () {
        $("#" + this.selectListMenuId).css("display", "block");
    };

    /**
     * Traps the tab key when in the popup
     * @event the key event
     */
    this.trapTabKey = function (event) {
        if (event.keyCode === KeyCodes.TAB) {
            var popup = $('.requisitionListContent.popup').toArray().find(function (a_popup) {
                return a_popup.offsetHeight !== 0;
            });

            if (popup) {
                var visibleFocusableItems = $('[tabindex$=\"0\"]', popup).toArray().filter(function (a_item) {
                    return a_item.offsetHeight !== 0; // visible
                });
                var focusedItem = document.activeElement;
                var numberOfFocusableItems = visibleFocusableItems.length;
                var focusedItemIndex = visibleFocusableItems.indexOf(focusedItem);

                if (event.shiftKey) {
                    //back tab - if focused on first item and user presses back-tab, go to the last focusable item
                    if (focusedItemIndex == 0) {
                        event.preventDefault();
                        visibleFocusableItems[numberOfFocusableItems - 1].focus();
                    }
                } else {
                    //forward tab - if focused on the last item and user presses tab, go to the first focusable item
                    if (focusedItemIndex == numberOfFocusableItems - 1) {
                        event.preventDefault();
                        visibleFocusableItems[0].focus();
                    }
                }
            }
        }
    };

    /**
     * Toggle showing the requisition list drop down
     * @param showSelectList - optionally choose whether the list of requisition lists should be affected by the toggle
     * @param resolveCatentry - optionally choose whether or not catentry needs to be resolved (defaults to true)
     * @param multipleSKUs - optionally choose whether or not we are adding multiple SKUs (e.g. from SKU list widget)
     * @param singleSkuId - optional single skuId being passed in from SKU list widget
     * @param addBundle - optionally choose whether or not we are adding a bundle
     */
    this.toggleDropDownMenu = function (showSelectList, resolveCatentry, multipleSKUs, singleSkuId, addBundle) {
        if (resolveCatentry == null) {
            resolveCatentry = true;
        }

        // Check to make sure quantity fields are populated when adding bundle
        if (addBundle) {
            for (var productId in shoppingActionsJS.productList) {
                var productDetails = shoppingActionsJS.productList[productId];
                var quantity = parseInt(productDetails.quantity);
                if (quantity == 0) {
                    continue;
                }
                if (productDetails.id == 0) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                    return;
                }
                if (isNaN(quantity) || quantity < 0) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                    return;
                }
            }
            this.addBundle = true;
        }

        // Check to make sure quantity fields are populated if adding multiple SKUs
        if (multipleSKUs) {
            if (product_id in SKUListJS.quantityList) {
                var length = 0;
                for (var skuId in SKUListJS.quantityList[product_id]) {
                    var quantity = SKUListJS.quantityList[product_id][skuId];
                    if (!isPositiveInteger(quantity)) {
                        MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                        return;
                    }
                    length++;
                }
                if (length == 0) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                    return;
                }
            } else {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                return;
            }
        }

        // Check to make sure quantity field is populated when adding single SKU from SKU List widget
        if (singleSkuId) {
            var quantity = $("#" + singleSkuId + "_Mobile_Quantity_Input").val();
            if (!isPositiveInteger(quantity)) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }

            this.setQuantity(quantity);
            this.addSingleSKU = true;
        }

        if (this.dropDownOpen == false) {
            this._showDropDownMenu(dropDownMenuId, resolveCatentry);
        } else {
            this._hideDropDownMenu(dropDownMenuId);
        }
        if (showSelectList == false) {
            this._hideSelectList();
        } else {
            this._showSelectList();
        }
    };

    /**
     * Check a radio button
     * @param nodeToCheck - the radio button to check
     * @param listId - list's ID
     * @param radiovalue - list's name
     */
    this.checkRadioButton = function (nodeToCheck, listId, radioValue) {
        if (nodeToCheck) {
            $(".checked", "#" + dropDownMenuId).css("display", "none");
            $(".checked", nodeToCheck).css("display", "block");
            $(".radioButton", "#" + dropDownMenuId).attr("aria-checked", "false");
            $(nodeToCheck).attr("aria-checked", "true");
            if (radioValue !== undefined) {
                this.params.name = radioValue.replace(/&#039;/gm, "'");
            }
            this.params.requisitionListId = listId;
            this.someRadioButtonChecked = true;
        }
    };

    /**
     * Toggle showing the create list menu
     * @param state - state of the menu.  True = shown, false = hidden
     */
    this.toggleCreateListDetailsMenu = function (state) {
        // Only toggle the menu when the requested state is different from the current state
        if (this.createListDetailsMenuOpen == true && state == false) {
            $("#" + createListMenuId).css("display", "none");
            this.createListDetailsMenuOpen = false;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        } else if (this.createListDetailsMenuOpen == false && state == true) {
            $("#" + createListMenuId).css("display", "block");
            this.createListDetailsMenuOpen = true;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        }
    };

    /**
     * Handles a keyboard event on the list type menu
     */
    this.handleKeyEventListTypeMenu = function (event) {
        switch (event.keyCode) {
            case KeyCodes.UP_ARROW:
                event.preventDefault();
                if (this.params.status == 'Z') {
                    this.setListType('Y');
                }
                break;
            case KeyCodes.DOWN_ARROW:
                event.preventDefault();
                if (this.params.status == 'Y') {
                    this.setListType('Z');
                }
                break;
        }
    };

    /**
     * Toggle showing the list type menu when creating a new list
     */
    this.toggleListTypeMenu = function () {
        if (this.listTypeMenuOpen == true) {
            $("#" + listTypeMenuId).css("display", "none");
            this.listTypeMenuOpen = false;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        } else {
            $("#" + listTypeMenuId).css("display", "block");
            this.listTypeMenuOpen = true;
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        }
    };

    /**
     * Set the type of list for the newly created list
     * @param listTypeToSet - 'Y' for private, 'Z' for shared/public
     */
    this.setListType = function (listTypeToSet) {
        if (this.params.status != listTypeToSet) {
            $("#" + listTypeFieldId + this.params.status).css("display", "none");
            this.params.status = listTypeToSet;
            $("#" + listTypeFieldId + this.params.status).css("display", "block");
            $("#" + this.pageName + "scrollContainer").scrollTop($("#" + this.pageName + "scrollContainer")[0].scrollHeight);
        }
    };


    /**
     * addSkus2RequisitionListAjax This function is used to add one or more SKUs to a requisition list using an AJAX call.
     **/
    this.addSkus2RequisitionListAjax = function () {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                productId: product_id,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                addBundle: this.addBundle,
                addMultipleSKUs: 'true'
            };

            if (this.addSingleSKU) {
                var quantity = $("#" + catEntryId + "_Mobile_Quantity_Input").val();
                if (!isPositiveInteger(quantity)) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                    return;
                }

                params["catEntryId_1"] = catEntryId;
                params["quantity_1"] = quantity;
            } else if (this.addBundle) {
                var i = 1;
                for (var prodId in shoppingActionsJS.productList) {
                    var productDetails = shoppingActionsJS.productList[prodId];
                    var quantity = parseInt(productDetails.quantity);
                    if (quantity == 0) {
                        continue;
                    }
                    if (productDetails.id == 0) {
                        MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                        return;
                    }
                    if (isNaN(quantity) || quantity < 0) {
                        MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                        return;
                    }

                    params["catEntryId_" + i] = productDetails.id;
                    params["quantity_" + i] = quantity;
                    params["productId_" + i++] = prodId;
                }
            } else {
                //Get all of the SKUs and their quantities and pass in as parameters (e.g. catEntryId_1, quantity_1, catEntryId_2, quantity_2)
                if (product_id in SKUListJS.quantityList) {
                    var i = 1;
                    for (var skuId in SKUListJS.quantityList[product_id]) {
                        var quantity = SKUListJS.quantityList[product_id][skuId];
                        if (!isPositiveInteger(quantity)) {
                            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                            return;
                        }
                        params["catEntryId_" + i] = skuId;
                        params["quantity_" + i++] = quantity;
                    }
                }
            }


            if (params.catEntryId_1 == null || params.quantity_1 == null) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                return;
            }

            //For Handling multiple clicks
            if (!submitRequest()) {
                return;
            }
            cursor_wait();

            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
            wcService.invoke('addCatalogEntriesToCreateRequisitionList', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * addOrderToRequisitionList This function is used to add an order to a requisition list.
     * @param {String} orderId the order Id being added to cart 	
     **/
    this.addOrderToRequisitionList = function () {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                productId: product_id,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                addSavedOrder: 'true'
            };

            //Get all of the catEntryIds and their quantities and pass in as parameters (e.g. catEntryId_1, quantity_1, catEntryId_2, quantity_2)
            if (OrderListJS.quantityList != {}) {
                var i = 1;
                for (var orderId in OrderListJS.quantityList) {
                    for (var catEntryId in OrderListJS.quantityList[orderId]) {
                        var quantity = OrderListJS.quantityList[orderId][catEntryId];

                        params["catEntryId_" + i] = catEntryId;
                        params["quantity_" + i] = quantity;
                        i++;
                    }
                }
            }

            if (params.catEntryId_1 == null || params.quantity_1 == null) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('MYACCOUNT_SAVEDORDERLIST_EMPTY_ADD_TO_REQ_FAIL'));
                return;
            }

            //For Handling multiple clicks
            if (!submitRequest()) {
                return;
            }
            cursor_wait();

            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
            wcService.invoke('addOrderToCreateRequisitionList', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * Add the product to a specific or new list
     */
    this.addToList = function () {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                catEntryId: catEntryId,
                productId: product_id,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                quantity: quantity
            };
            if (quantity < 1) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
            if (!submitRequest()) {
                return;
            }
            cursor_wait();
            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
            if (this.addPDK) {
                wcService.getServiceById("addToCreateRequisitionList").setUrl(getAbsoluteURL() + "AjaxRESTRequisitionListConfigurationAdd");
            }
            wcService.invoke('addToCreateRequisitionList', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * Add the product to a specific or new list
     */
    this.moveToList = function (requisitionOrderItemId) {
        if (this.someRadioButtonChecked == true) {
            params = {
                storeId: this.storeId,
                catalogId: this.catalogId,
                langId: this.langId,
                catEntryId: catEntryId,
                productId: product_id,
                pageName: this.pageName,
                buttonStyle: this.buttonStyle,
                name: this.params.name,
                status: this.params.status,
                requisitionListId: this.params.requisitionListId,
                requisitionOrderItemId: requisitionOrderItemId,
                quantity: quantity
            };
            if (quantity < 1) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
            if (!submitRequest()) {
                return;
            }
            cursor_wait();
            if (this.createListDetailsMenuOpen) {
                params.name = $("#" + this.listNameFieldId).val().replace(/^\s+|\s+$/g, '');
                if (params.name == "") {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_EMPTY_SL_NAME'));
                    return;
                }
            }
			if (this.addPDK || this.addDK) {
				if (this.addDK){
					params.configurationXML = this.unEscapeXml( this.configurationXML);
				}
				wcService.getServiceById("addToCreateRequisitionListAndDeleteFromCart").setUrl(getAbsoluteURL() + "AjaxRESTRequisitionListConfigurationAdd");
			}
            wcService.invoke('addToCreateRequisitionListAndDeleteFromCart', params);
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_SL_LIST_NOT_CHOSEN'));
            return;
        }
    };

    /**
     * Hide and reset widget after successfully adding an item to a list
     */
    this.continueShopping = function () {
        Utils.ifSelectorExists("#" + addResultMenuId, function ($addResultMenu) {
            $addResultMenu.css("display", "none");
            this.toggleDropDownMenu(true);
            this._initialize();

            if (document.removeEventListener) {
                document.removeEventListener("keydown", this.trapTabKey, true);
            }

            $("#" + this.pageName + "addToShoppingListBtn").focus();
        }, this);
    };

    /**
     * Service declaration to add a catalog entry to a requisition list.  List is created if it does not exist.
     */
    wcService.declare({
        id: "addToCreateRequisitionList",
        actionId: "addToCreateRequisitionList",
        url: getAbsoluteURL() + "AjaxRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            var productName = "";
            // Get the product or SKU name
            if ($("#ProductInfoName_" + serviceResponse.productId).length) {
                productName = $("#" + "ProductInfoName_" + serviceResponse.productId).val();
            } else if ($("#ProductInfoName_" + catEntryId).length) {
                productName = $("#" + "ProductInfoName_" + catEntryId).val();
            }

            var productThumbnail = "";
            // Get the product's image or SKU image
            if ($("#ProductInfoImage_" + serviceResponse.productId).length) {
                productThumbnail = $("#" + "ProductInfoImage_" + serviceResponse.productId).val();
            } else if ($("#ProductInfoImage_" + catEntryId).length) {
                productThumbnail = $("#" + "ProductInfoImage_" + catEntryId).val();
            }

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "productName": productName,
                "productThumbnail": productThumbnail,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName,
                "productId": serviceResponse.productId
            });

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight !== 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                }, this);
            }, 100);
        },

        failureHandler: function (serviceResponse) {
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

    /**
     * Service declaration to add a catalog entry to a requisition list.  List is created if it does not exist.
     */
    wcService.declare({
        id: "addToCreateRequisitionListAndDeleteFromCart",
        actionId: "addToCreateRequisitionListAndDeleteFromCart",
        url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            var productName = "";
            // Get the product or SKU name
            if ($("#catalogEntry_name_" + serviceResponse.requisitionOrderItemId).length) {
                productName = $("#" + "catalogEntry_name_" + serviceResponse.requisitionOrderItemId).html();
            }

            var productThumbnail = "";
            // Get the product's image or SKU image
            if ($("#catalogEntry_img_" + serviceResponse.requisitionOrderItemId).length) {
                productThumbnail = document.getElementById("catalogEntry_img_" + serviceResponse.requisitionOrderItemId).childNodes[1].src;
            }

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "productName": productName,
                "productThumbnail": productThumbnail,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName
            });

            CheckoutHelperJS.deleteFromCart(serviceResponse.requisitionOrderItemId);

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight != 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                });
            }, 100);

            // Remove the grayOut.  User does not have chance to cancel gray out themselves when catentry is deleted from the cart 
            $("#grayOut").css("display", "none");
            $("#grayOutPopup").css("display", "none");
        },

        failureHandler: function (serviceResponse) {
            if (serviceResponse.errorMessage) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
            } else if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
            cursor_clear();
        }
    });

    /**
     * Service declaration to add multiple catalog entries to a requisition list.  List is created if it does not exist.
     */
    wcService.declare({
        id: "addCatalogEntriesToCreateRequisitionList",
        actionId: "addCatalogEntriesToCreateRequisitionList",
        url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            var productName = [];
            var productThumbnail = [];
            var productSKU = [];

            // Get the SKU name and thumbnail urls
            for (var i = 1;
                ("catEntryId_" + i) in serviceResponse; i++) {
                var catEntryId = serviceResponse["catEntryId_" + i];
                var productId = serviceResponse["productId_" + i]; //Used when adding bundle

                var catEntryName = Utils.selectExistingElement(["#item_name_" + catEntryId, "#ProductInfoName_" + productId]);
                if (catEntryName) {
                    productName.push(catEntryName.val());
                    Utils.ifSelectorExists("#item_sku_" + catEntryId, function (catEntrySKU) {
                        productSKU.push("(" + catEntrySKU.val() + ")");
                    });
                }

                var catEntryThumbnail = Utils.selectExistingElement(["#item_thumbnail_" + catEntryId, "#ProductInfoImage_" + catEntryId]);
                if (catEntryThumbnail) {
                    productThumbnail.push(catEntryThumbnail.val());
                } else { //Get the thumbnail image from the JSON in the HTML in the bundle case
                    Utils.ifSelectorExists("#entitledItem_" + productId, function (element) {
                        var entitledItemJSON = JSON.parse(element.html());
                        for (var j in entitledItemJSON) {
                            var entitledItem = entitledItemJSON[j];
                            if (entitledItem.catentry_id == catEntryId) {
                                if (entitledItem.ItemThumbnailImage != null) {
                                    productThumbnail.push(entitledItem.ItemThumbnailImage);
                                    break;
                                }
                            }
                        }
                    });
                }
            }

            var type = "";
            if (serviceResponse.addBundle) {
                type = 'bundle';
            }

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "productName": productName,
                "productThumbnail": productThumbnail,
                "productSKU": productSKU,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName,
                "productId": serviceResponse.productId,
                "addMultipleSKUs": serviceResponse.addMultipleSKUs,
                "numberOfSKUs": i - 1,
                "type": type
            });

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight !== 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                }, this);
            }, 100);

            wcTopic.publish('SKUsAddedToReqList');
        },

        failureHandler: function (serviceResponse) {
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

    /**
     * Service declaration to add saved order to a requisition list.  List is created if it does not exist.
     */
    wcService.declare({
        id: "addOrderToCreateRequisitionList",
        actionId: "addOrderToCreateRequisitionList",
        url: getAbsoluteURL() + "AjaxRESTRequisitionListUpdateItem",
        formId: "",

        successHandler: function (serviceResponse) {
            MessageHelper.hideAndClearMessage();
            cursor_clear();

            // Refresh the widget's refresh area and show item was added to a list
            wcRenderContext.updateRenderContext("requisitionLists_content_context", {
                "showSuccess": "true",
                "listName": serviceResponse.name,
                "storeId": serviceResponse.storeId,
                "buttonStyle": serviceResponse.buttonStyle,
                "parentPage": serviceResponse.pageName,
                "productID": serviceResponse.productId,
                "addSavedOrder": serviceResponse.addSavedOrder,
                "orderId": serviceResponse.orderId
            });

            // Keep polling until the continue shopping button is visible after AJAX update, then focus on it
            var poll = window.setInterval($.proxy(function () {
                Utils.ifSelectorExists("#" + serviceResponse.pageName + "requisitionListsContShopButton", function ($contShopButton) {
                    if ($contShopButton.get(0).offsetHeight != 0) {
                        window.clearInterval(poll);
                        $contShopButton.focus();
                        if (document.addEventListener) {
                            document.addEventListener("keydown", this.trapTabKey, true);
                        }
                    }
                }, this);
            }, this), 100);
        },

        failureHandler: function (serviceResponse) {
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

    if (jsObjectName != 'AddToRequisitionListJS') {
        this.pageName = jsObjectName.replace('AddToRequisitionListsJS', '');
    };
    this._initialize();
}

/**
* Declares a new refresh controller
for Add To Requisition List display.*/
var declareRequsitionListsContentController = function (widgetPrefix) {
    if (!wcRenderContext.checkIdDefined("requisitionLists_content_context")) {
        wcRenderContext.declare("requisitionLists_content_context", [], {
            "showSuccess": "false"
        });
    }
    var myWidgetObj = $("#" + widgetPrefix + "requisitionlists_content_widget");
    wcRenderContext.addRefreshAreaId("requisitionLists_content_context", widgetPrefix + "requisitionlists_content_widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("requisitionLists_content_context");


    /**
     * Declares a new render context for the Requisition List display.
     */
    var renderContextChangedHandler = function () {
            var widgetId = myRCProperties["parentPage"] + "requisitionlists_content_widget";
            if (widgetId === myWidgetObj.attr("id")) {
                // Only refresh the widget associated with parentPage
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            };

        },



        postRefreshHandler = function () {
            MessageHelper.hideAndClearMessage();
            cursor_clear();
        }
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: renderContextChangedHandler,
        postRefreshHandler: postRefreshHandler
    });
};
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2015 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------



/** 
 * @fileOverview This javascript provides the variables and methods to manipulate the product images, and for switching 
 * the tabs used on the product pages.
 * @version 1.5
 */
			
			/** This variable stores the identifier of the image currently used for a product */
			var currentAngleImgId="productAngleProdLi0";

			function changeThumbNail(angleImgId,imgsrc){
					if (currentAngleImgId != "") {
						if(document.getElementById(currentAngleImgId) != null){
							document.getElementById(currentAngleImgId).className ='';
						}
					}
					currentAngleImgId = angleImgId;
					document.getElementById(angleImgId).className ='selected';
					document.getElementById("productMainImage").src = imgsrc;
			}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * Function to create javascript object InventoryStatusJS
 *
 * @param {Object} storeParams params specific to a store
 * @param {Object} catEntryParams params specific to base Item
 * @param {Array} physicalStores inventory details specific to physical store
 * 
 **/
function InventoryStatusJS(storeParams, catEntryParams, physicalStores, productId) {
    this.storeParams = storeParams;
    this.catEntryParams = catEntryParams;
    this.physicalStores = physicalStores;
    this.productId = productId;
    this.isFetchInventoryStatus = false;
    this.itemId = -1;

    /**
     * Setter for itemId
     * 
     * @param Integer catEntryId
     * @param Integer productId
     */
    this.setCatEntry = function (catEntryId, productId) {
        // if it is ItemBean, no need to set the attributes, since it is not required to resolve SKU
        if (this.catEntryParams.type != "ItemBean") {

            // hiding the availability section
            $("#InventoryStatus_Availability_Section_" + this.productId).css("display", "none");

            // showing the show availability link
            $("#InventoryStatus_ShowLink_Section_" + this.productId).css("display", "block");

            // If we are able to resolve the sku, then show the inventory status 
            if (catEntryId != -1) {
                this.itemId = catEntryId;
                this.checkAvailability(this.isFetchInventoryStatus);
                this.isFetchInventoryStatus = false;
            }
        }
    };

    /**
     * Restores the Inventory Availability section to the initial state if no SKU is resolved
     * 
     * @param Integer catEntryId
     * @param Integer productId
     */
    this.restoreDefaultState = function (catEntryId, productId) {
        if (catEntryId == null) {
            // hiding the availability section
            $("#InventoryStatus_Availability_Section_" + this.productId).css("display", "none");

            // showing the show availability link
            $("#InventoryStatus_ShowLink_Section_" + this.productId).css("display", "block");
        }
    };

    /**
     * After resolving the SKU for a product, checks the inventory status online 
     * and in the stores selected by the user 
     */
    this.checkAvailability = function (allowParallelCall) {
        MessageHelper.hideAndClearMessage();

        var params = this.setCommonParams();
        if (-1 == this.itemId) {
            MessageHelper.displayErrorMessage(storeNLS['ERR_RESOLVING_SKU']);
            return;
        }
        params.itemId = this.itemId;

        // hiding the show availability link
        $("#InventoryStatus_ShowLink_Section_" + this.productId).css("display", "none");

        setCurrentId('progressbar_' + this.productId);
        // if the call is during the page load, allow parallel calls, since there may be other ajax calls in progress
        if (!allowParallelCall) {
            // For Handling multiple clicks.
            if (!submitRequest()) {
                return;
            }
        }

        cursor_wait();
        wcService.invoke("getInventoryStatus_" + this.productId, params);
    };

    /**
     * Populate the contents of the inventory details section in the product display page with the JSON returned 
     * from the server. This is the callback function that is called after the AJAX call to get the inventory 
     * details successfully returns to the client.
     * 
     * @param {object} serviceRepsonse The JSON response from the service.
     * @param {object} ioArgs The arguments from the service call.
     */
    this.populateInvDetails = function (serviceResponse, ioArgs) {
        if (serviceResponse.onlineInventory) {
            // setting the online inventory status
            $("#InventoryStatus_OnlineStatus_Img_" + this.productId).replaceWith("<img id='InventoryStatus_OnlineStatus_Img_" + this.productId + "' src='" + imageDirectoryPath + styleDirectoryPath + serviceResponse.onlineInventory.image + "' alt='' border='0' />");
            $("#InventoryStatus_OnlineStatus_" + this.productId).text(serviceResponse.onlineInventory.status);

            // removing the in store section if present
            $("#InventoryStatus_InStore_Section_" + this.productId).detach();

            // check if the physical store section is present
            if ($("#InventoryStatus_InStore_Heading_" + this.productId).length) {
                // adding the empty store section
                $("#InventoryStatus_InStore_Heading_" + this.productId).after("<div id='InventoryStatus_InStore_Section_" + this.productId + "' class='sublist'>");

                this.physicalStores = serviceResponse.inStoreInventory.stores;
                // adding the store inventory details as child elements in the store section
                for (idx = 0; idx < serviceResponse.inStoreInventory.stores.length; idx++) {
                    var store = serviceResponse.inStoreInventory.stores[idx];

                    // adding the store name
                    $("#InventoryStatus_InStore_Section_" + this.productId).append("<a id='WC_InventoryStatus_Link_" + this.productId + "_store_" + (idx + 1) + "' href='javascript:InventoryStatusJS_" + this.productId + ".fetchStoreDetails(" + store.id + ");' class='store_name'>" + store.name + "</a>");
                    // adding clear div
                    $("#InventoryStatus_InStore_Section_" + this.productId).append("<div class='clear_float'></div>");
                    // adding the image status of store name
                    $("#InventoryStatus_InStore_Section_" + this.productId).append("<span> <img src='" + imageDirectoryPath + styleDirectoryPath + store.image + "' alt='" + store.altText + "' /> </span>");
                    // adding the text status of store name
                    $("#InventoryStatus_InStore_Section_" + this.productId).append("<span class='text'>" + store.statusText + "</span>");
                    // adding clear div
                    $("#InventoryStatus_InStore_Section_" + this.productId).append("<div class='clear_float'></div>");
                    // adding spacer
                    $("#InventoryStatus_InStore_Section_" + this.productId).append("<div class='item_spacer_10px'></div>");
                }
                // add select store link
                $("#InventoryStatus_SelectStoreLink_" + this.productId).text(serviceResponse.inStoreInventory.checkStoreText);
            }

            // showing the availability section
            $("#InventoryStatus_Availability_Section_" + this.productId).css("display", "block");
        } else {
            MessageHelper.displayErrorMessage(storeNLS["INV_STATUS_RETRIEVAL_ERROR"]);
        }
        cursor_clear();
    };

    /**
     * This resolves the product SKUs to a single item by comparing the attributes selected by the user
     * 
     * @return {Integer} uniqueId, of the selected SKU.
     * 					 -1, if no match found
     */
    this.resolveSKU = function () {
        for (idx = 0; idx < this.catEntryParams.skus.length; idx++) {
            var matches = 0;
            var attributeCount = 0;
            for (attribute in this.catEntryParams.skus[idx].attributes) {
                attributeCount++;
                if (this.catEntryParams.attributes && this.catEntryParams.skus[idx].attributes[attribute] == this.catEntryParams.attributes[attribute]) {
                    matches++;
                } else {
                    break;
                }
            }
            if (matches == attributeCount) {
                return this.catEntryParams.skus[idx].id;
            }
        }
        return -1;
    };

    /**
     * Sets the store specific values such as storeId, catalogId and langId
     * to the params object and returns it
     * 
     * @return {Object} params with store specific values
     */
    this.setCommonParams = function () {
        var params = new Object();
        params.storeId = this.storeParams.storeId;
        params.catalogId = this.storeParams.catalogId;
        params.langId = this.storeParams.langId;
        return params;
    };

    /**
     * Show Store details popup after fetching the required details
     */
    this.fetchStoreDetails = function (storeId) {
        MessageHelper.hideAndClearMessage();

        var params = new Object();
        params.physicalStoreId = storeId;

        // For Handling multiple clicks.
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        wcService.invoke("getPhysicalStoreDetails_" + this.productId, params);
    };

    /**
     * Populate the contents of the store details section in the product display page with the JSON returned 
     * from the server. This is the callback function that is called after the AJAX call to get the inventory 
     * details successfully returns to the client.
     * 
     * @param {object} serviceRepsonse The JSON response from the service.
     * @param {object} ioArgs The arguments from the service call.
     */
    this.populateStoreDetails = function (serviceResponse, ioArgs) {
        var store = serviceResponse;

        // set unescaped working hours
        store.hours = this.unEscapeXml(serviceResponse.hours);

        // set inventory status
        var storeInventory = this.fetchInventoryStatus(ioArgs.physicalStoreId);

        // set store availability details
        store.imageTag = "<img src='" + imageDirectoryPath + styleDirectoryPath + storeInventory.image + "' alt='" + storeInventory.altText + "'/>";
        store.statusText = storeInventory.statusText;

        if (storeInventory.status == 'Available') {
            store.availabilityDetails = "(" + storeInventory.availableQuantity + ")"; // adding the available quantity
        } else if (storeInventory.status == 'Backorderable') {
            store.availabilityDetails = "(" + storeInventory.availableDate + ")"; // adding the available date
        } else {
            store.availabilityDetails = "";
        }
        var storeDetails = $("#Store_Details_Template_" + this.productId).html();
        $("#Store_Details_" + this.productId).html(Utils.substituteStringWithObj(storeDetails, store));

        // Display store details
        var popup = $("#InventoryStatus_Store_Details_" + this.productId).data("wc-WCDialog");
        if (popup) {
            closeAllDialogs(); //close other dialogs(quickinfo dialog, etc) before opening this. 				
            popup.open();
        } else {
            console.debug("InventoryStatus_Store_Details_" + this.productId + " does not exist");
        }
        cursor_clear();
    };

    /**
     * 
     */
    this.fetchInventoryStatus = function (storeId) {
        for (idx = 0; idx < this.physicalStores.length; idx++) {
            if (this.physicalStores[idx].id == storeId) {
                return this.physicalStores[idx];
            }
        }
        return {};
    };

    /**
     * Converts xml accepted form to < >
     * 
     * @param {String} str, String to be converted
     * 
     * @return {String} converted string
     */
    this.unEscapeXml = function (str) {
        var str = str.replace(/&lt;/gm, "<").replace(/&gt;/gm, ">");
        return str;
    };

    this.loadStoreLocator = function (storeLocatorUrl, bundleId) {
        var catalogEntryId = bundleId;
        if (null == catalogEntryId || '' == catalogEntryId) {
            catalogEntryId = this.itemId;
            if (-1 == catalogEntryId) {
                catalogEntryId = productId;
            }
        }
        loadLink(storeLocatorUrl + "&productId=" + catalogEntryId);
    }
}
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

if (typeof (MerchandisingAssociationJS) == "undefined" || MerchandisingAssociationJS == null || !MerchandisingAssociationJS) {

    MerchandisingAssociationJS = {
        storeParams: {},
        baseItemParams: {},
        merchandisingAssociations: [],
        associationIndex: 0,

        /**
         * Method to set values
         *
         * @param {Object} storeParams params specific to a store
         * @param {Object} baseItemParams params specific to base Item
         * @param {Array} merchandisingAssociations items associated with the base item
         * 
         **/
        setValues: function (storeParams, baseItemParams, merchandisingAssociations) {
            this.storeParams = storeParams;
            this.baseItemParams = baseItemParams;
            this.baseItemParams.quantity = 1;
            this.merchandisingAssociations = merchandisingAssociations;
        },

        /**
         * Setter for baseItemQuantity
         * 
         * @param Integer baseItemQuantity
         */
        setBaseItemQuantity: function (baseItemQuantity) {
            var baseItemQuantity = $.parseJSON(baseItemQuantity);
            // If the quantity is an object with multiple quantities
            if (baseItemQuantity.length) {
                for (idx = 0; idx < baseItemQuantity.length; idx++) {
                    for (idx2 = 0; idx2 < MerchandisingAssociationJS.baseItemParams.components.length; idx2++) {
                        if (MerchandisingAssociationJS.baseItemParams.components[idx2].skus) {
                            for (idx3 = 0; idx3 < MerchandisingAssociationJS.baseItemParams.components[idx2].skus.length; idx3++) {
                                if (MerchandisingAssociationJS.baseItemParams.components[idx2].skus[idx3].id == baseItemQuantity[idx].id) {
                                    MerchandisingAssociationJS.baseItemParams.components[idx2].id = baseItemQuantity[idx].id;
                                    break;
                                }
                            }
                        }
                        if (MerchandisingAssociationJS.baseItemParams.components[idx2].id == baseItemQuantity[idx].id) {
                            MerchandisingAssociationJS.baseItemParams.components[idx2].quantity = baseItemQuantity[idx].quantity;
                            break;
                        }
                    }
                }
                // If the quantity is a single value
            } else {
                MerchandisingAssociationJS.baseItemParams.quantity = baseItemQuantity;
            }
        },

        /**
         * Setter for baseItemAttributes
         * 
         * @param Integer baseItemQuantity
         */
        setBaseItemAttributes: function (baseItemAttributes) {
            this.baseItemParams.attributes = $.parseJSON(baseItemAttributes);
        },

        /**
         * Setter for baseItemAttributes. Retrieve product attributes from catentry object. 
         * 
         * @param Integer baseItemQuantity
         */
        setBaseItemAttributesFromProduct: function (catEntryId, productId) {
            var selectedAttributes = productDisplayJS.selectedAttributesList["entitledItem_" + productId];
            MerchandisingAssociationJS.setBaseItemAttributes(JSON.stringify(selectedAttributes));
        },

        /**
         * changeItem scrolls the associated catEntries up and down
         *
         * @param {int} direction +1, scrolls up and -1, scrolls down
         *
         **/
        changeItem: function (direction) {
            if ((this.associationIndex + direction) >= 0 && (this.associationIndex + direction) < this.merchandisingAssociations.length) {
                this.associationIndex = this.associationIndex + direction;
                // sets the associated item name
                $("#association_item_name").html(this.merchandisingAssociations[this.associationIndex].name);
                if (document.getElementById("ProductInfoName_" + this.merchandisingAssociations[this.associationIndex - direction].productId) != null) {
                    document.getElementById("ProductInfoName_" + this.merchandisingAssociations[this.associationIndex - direction].productId).value = this.merchandisingAssociations[this.associationIndex].name;
                    document.getElementById("ProductInfoName_" + this.merchandisingAssociations[this.associationIndex - direction].productId).id = "ProductInfoName_" + this.merchandisingAssociations[this.associationIndex].productId;
                }
                // sets the associated thumbnail image of the item
                $("#association_thumbnail").attr('src', this.merchandisingAssociations[this.associationIndex].thumbnail);
                if ($("#ProductInfoImage_" + this.merchandisingAssociations[this.associationIndex - direction].productId).length) {
                    document.getElementById("ProductInfoImage_" + this.merchandisingAssociations[this.associationIndex - direction].productId).value = this.merchandisingAssociations[this.associationIndex].thumbnail;
                    document.getElementById("ProductInfoImage_" + this.merchandisingAssociations[this.associationIndex - direction].productId).id = "ProductInfoImage_" + this.merchandisingAssociations[this.associationIndex].productId;
                }
                // sets the associated item name to alt text
                $("#association_thumbnail").attr("alt", this.merchandisingAssociations[this.associationIndex].name);
                // sets the total offered price
                $("#combined_total").html(this.merchandisingAssociations[this.associationIndex].offeredCombinedPrice);
                if ($("#ProductInfoPrice_" + this.merchandisingAssociations[this.associationIndex - direction].productId).length) {
                    document.getElementById("ProductInfoPrice_" + this.merchandisingAssociations[this.associationIndex - direction].productId).value = this.merchandisingAssociations[this.associationIndex].skuOfferPrice;
                    document.getElementById("ProductInfoPrice_" + this.merchandisingAssociations[this.associationIndex - direction].productId).id = "ProductInfoPrice_" + this.merchandisingAssociations[this.associationIndex].productId;
                }
                // sets the total list price
                $("#list_total").html(this.merchandisingAssociations[this.associationIndex].listedCombinedPrice);
                if ($("#association_url ").attr('ontouchend') == (undefined)) {
                    // sets the product url href
                    $("#association_url").attr("href", this.merchandisingAssociations[this.associationIndex].url);
                }
                // sets the product url title
                $("#association_url").attr("title", this.merchandisingAssociations[this.associationIndex].shortDesc);
                if ($("#association_url").attr('ontouchend') !== (undefined)) {
                    currentPopup = "";
                    $("association_url").attr("ontouchend", "handlePopup('" + this.merchandisingAssociations[this.associationIndex].url + "','merchandisingAssociation_QuickInfoDiv" + this.merchandisingAssociations[this.associationIndex].id + "')");
                }
                // sets the href for quick info
                $("#merchandisingAssociation_QuickInfo").attr("href", "javascript:QuickInfoJS.showDetails(" + this.merchandisingAssociations[this.associationIndex].id + ");");
                if (0 == this.associationIndex) {
                    // changing the up arrow to disabled style
                    $("#up_arrow").removeClass("up_active");
                    $("#down_arrow").addClass("down_active");
                    $("#down_arrow").focus();
                } else if ((this.merchandisingAssociations.length - 1) == this.associationIndex) {
                    // changing the down arrow to disabled style
                    $("#down_arrow").removeClass("down_active");
                    $("#up_arrow").addClass("up_active");
                    $("#up_arrow").focus();
                } else {
                    // changing the arrows to enabled style
                    $("#up_arrow").addClass("up_active");
                    $("#down_arrow").addClass("down_active");
                }
            }
        },

        setCommonParams: function () {
            var params = new Object();
            params.storeId = this.storeParams.storeId;
            params.catalogId = this.storeParams.catalogId;
            params.langId = this.storeParams.langId;
            params.orderId = ".";
            // Remove calculations for performance
            // params.calculationUsage = "-1,-2,-5,-6,-7";
            params.calculateOrder = "0";
            params.inventoryValidation = "true";
            return params;
        },

        validate: function () {
            if (this.baseItemParams.type == 'BundleBean') {
                for (idx = 0; idx < this.baseItemParams.components.length; idx++) {
                    if (!isPositiveInteger(this.baseItemParams.components[idx].quantity)) {
                        MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                        return;
                    }
                }
            } else if (this.baseItemParams.type == 'ProductBean' &&
                (null == this.baseItemParams.attributes || "undefined" == this.baseItemParams.attributes)) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                return;
            } else if (!isPositiveInteger(this.baseItemParams.quantity)) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
        },

        /**
         * addBoth2ShopCart Adds both base product and the associated product to the shopping cart
         *
         *
         **/
        addBoth2ShopCart: function (catEntryID_baseItem, catEntryID_MA, catEntryID_MA_quantity, associationIndex) {
            this.associationIndex = associationIndex;
            this.validate();
            if (!isPositiveInteger(catEntryID_MA_quantity)) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
            var params = this.setCommonParams();

            shoppingActionsJS.productAddedList = new Object();
            //Add the parent product to the cart.
            if (["ItemBean", "ProducteBean", "DynamicKitBean"].indexOf(this.baseItemParams.type) > -1) {
                updateParamObject(params, "catEntryId", this.baseItemParams.id, false, -1);
                updateParamObject(params, "quantity", this.baseItemParams.quantity, false, -1);
                if (this.baseItemParams.type == 'DynamicKitBean') {
                    updateParamObject(params, "catalogEntryType", "dynamicKit", -1);
                }
                if (this.baseItemParams.type == 'ItemBean') {
                    shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.quantity), this.baseItemParams.productId, this.baseItemParams.id, this.baseItemParams.attributes);
                } else {
                    shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.quantity), this.baseItemParams.productId, this.baseItemParams.id, shoppingActionsJS.selectedAttributesList['entitledItem_' + this.baseItemParams.id]);
                }
            } else if (this.baseItemParams.type == 'BundleBean') {
                // Add items in the bundle
                for (idx = 0; idx < this.baseItemParams.components.length; idx++) {
                    updateParamObject(params, "catEntryId", this.baseItemParams.components[idx].id, false, -1);
                    updateParamObject(params, "quantity", this.baseItemParams.components[idx].quantity, false, -1);

                    if (this.baseItemParams.components[idx].productId != undefined) {
                        var selectedAttrList = new Object();
                        for (attr in shoppingActionsJS.selectedProducts[this.baseItemParams.components[idx].productId]) {
                            selectedAttrList[attr] = shoppingActionsJS.selectedProducts[this.baseItemParams.components[idx].productId][attr];
                        }
                        shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.components[idx].quantity), this.baseItemParams.components[idx].productId, this.baseItemParams.components[idx].id, selectedAttrList);
                    } else {
                        shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.components[idx].quantity), this.baseItemParams.components[idx].id, this.baseItemParams.components[idx].id, shoppingActionsJS.selectedProducts[this.baseItemParams.components[idx].id]);
                    }
                }
            } else {
                // Resolve ProductBean to an ItemBean based on the attributes in the main page
                var sku = this.resolveSKU();
                if (-1 == sku) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                    return;
                } else {
                    updateParamObject(params, "catEntryId", sku, false, -1);
                    updateParamObject(params, "quantity", this.baseItemParams.quantity, false, -1);
                    shoppingActionsJS.saveAddedProductInfo(Math.abs(this.baseItemParams.quantity), this.baseItemParams.id, sku, this.baseItemParams.attributes);
                }
            }
            if (["ItemBean", "PackageBean", "DynamicKitBean"].indexOf(this.merchandisingAssociations[this.associationIndex].type) > -1) {
                updateParamObject(params, "catEntryId", this.merchandisingAssociations[this.associationIndex].id, false, -1);
                updateParamObject(params, "quantity", catEntryID_MA_quantity, false, -1);
                if (this.merchandisingAssociations[this.associationIndex].productId != undefined) {
                    shoppingActionsJS.saveAddedProductInfo(Math.abs(catEntryID_MA_quantity), this.merchandisingAssociations[this.associationIndex].productId, this.merchandisingAssociations[this.associationIndex].id, shoppingActionsJS.selectedAttributesList['entitledItem_' + this.merchandisingAssociations[this.associationIndex].id]);
                } else {
                    shoppingActionsJS.saveAddedProductInfo(Math.abs(catEntryID_MA_quantity), this.merchandisingAssociations[this.associationIndex].id, this.merchandisingAssociations[this.associationIndex].id, shoppingActionsJS.selectedAttributesList['entitledItem_' + this.merchandisingAssociations[this.associationIndex].id]);
                }
                this.addItems2ShopCart(params);
            } else if (this.merchandisingAssociations[this.associationIndex].type == 'BundleBean') {
                // Add items in the bundle
                for (idx = 0; idx < this.merchandisingAssociations[this.associationIndex].components.length; idx++) {
                    updateParamObject(params, "catEntryId", this.merchandisingAssociations[this.associationIndex].components[idx].id, false, -1);
                    updateParamObject(params, "quantity", catEntryID_MA_quantity, false, -1);
                    shoppingActionsJS.saveAddedProductInfo(Math.abs(catEntryID_MA_quantity), this.merchandisingAssociations[this.associationIndex].components[idx].id, this.merchandisingAssociations[this.associationIndex].components[idx].id, shoppingActionsJS.selectedProducts[this.merchandisingAssociations[this.associationIndex].components[idx].id]);
                }
                this.addItems2ShopCart(params);
            } else {
                // Resolve ProductBean to an ItemBean based on the attributes selected
                var entitledItemJSON = null;
                if ($("#" + catEntryID_MA).length) {
                    //the json object for entitled items are already in the HTML. 
                    entitledItemJSON = eval('(' + $("#" + catEntryID_MA).html() + ')');
                } else {
                    //if $("#" + entitledItemId) is null, that means there's no <div> in the HTML that contains the JSON object. 
                    //in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
                    entitledItemJSON = shoppingActionsJS.getEntitledItemJsonObject();
                }
                shoppingActionsJS.setEntitledItems(entitledItemJSON);
                var catEntryID_MA_SKU = shoppingActionsJS.getCatalogEntryId(catEntryID_MA);
                if (null == catEntryID_MA_SKU) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
                    return;
                } else {
                    updateParamObject(params, "catEntryId", catEntryID_MA_SKU, false, -1);
                    updateParamObject(params, "quantity", catEntryID_MA_quantity, false, -1);
                    shoppingActionsJS.saveAddedProductInfo(catEntryID_MA_quantity, catEntryID_MA.split("_")[1], catEntryID_MA_SKU, shoppingActionsJS.selectedAttributesList['entitledItem_' + this.merchandisingAssociations[this.associationIndex].id]);
                    this.addItems2ShopCart(params);
                }
            }
        },

        resolveSKU: function () {
            for (idx = 0; idx < this.baseItemParams.skus.length; idx++) {
                var matches = 0;
                var attributeCount = 0;
                for (attribute in this.baseItemParams.skus[idx].attributes) {
                    attributeCount++;
                    if (this.baseItemParams.attributes && this.baseItemParams.skus[idx].attributes[attribute] == this.baseItemParams.attributes[attribute]) {
                        matches++;
                    } else {
                        break;
                    }
                }
                if (matches == attributeCount) {
                    return this.baseItemParams.skus[idx].id;
                }
            }
            return -1;
        },

        /**
         * AddItem2ShopCartAjax This function is used to add a single or multiple items to the shopping cart using an ajax call.
         *
         * @param {Object} params, parameters that needs to be passed during service invocation.
         *
         **/
        addItems2ShopCart: function (params) {
            var shopCartService = "AddOrderItem";
            if (params['catalogEntryType'] == 'dynamicKit') {
                shopCartService = "AddPreConfigurationToCart";
            }
            //For Handling multiple clicks
            if (!submitRequest()) {
                return;
            }
            cursor_wait();
            wcService.invoke(shopCartService, params);
        },

        /**
         * This function is used to subscribe events that indicate quantity change and attribute changes.
         *
         * @param {Object} params, parameters that needs to be passed during service invocation.
         *
         **/
        subscribeToEvents: function (baseCatalogEntryId) {
            wcTopic.subscribe("Quantity_Changed", MerchandisingAssociationJS, MerchandisingAssociationJS.setBaseItemQuantity);
            wcTopic.subscribe("DefiningAttributes_Resolved_" + baseCatalogEntryId, MerchandisingAssociationJS.setBaseItemAttributesFromProduct);
        }
    }

}
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// Declare refresh controller which are used in pagination controls of SearchBasedNavigationDisplay -- both products and articles+videos

// Search for this "prodRecommendationRefresh_controller" it is never defined in any refresh areas, maybe no longer in use?
/*
wc.render.declareRefreshController({
    id: "prodRecommendationRefresh_controller",
    renderContext: wcRenderContext.getRenderContextProperties("searchBasedNavigation_context"),
    url: "",
    formId: ""

    ,renderContextChangedHandler: function(message, widget) {
        var controller = this;
        var renderContext = this.renderContext;
        var resultType = renderContext.properties["resultType"];
        if (["products", "both"].indexOf(resultType) > -1){
            widget.refresh(renderContext.properties);
            console.log("espot refreshing");
        }
    }

    ,postRefreshHandler: function(widget) {
        var controller = this;
        var renderContext = this.renderContext;
        cursor_clear();

        var refreshUrl = controller.url;
        var emsName = "";
        var indexOfEMSName = refreshUrl.indexOf("emsName=", 0);
        if(indexOfEMSName >= 0){
            emsName = refreshUrl.substring(indexOfEMSName+8);
            if (emsName.indexOf("&") >= 0) {
                emsName = emsName.substring(0, emsName.indexOf("&"));
                emsName = "script_" + emsName;
            }
        }

        if (emsName !== "") {
            var espot = $('.genericESpot', $("#" + emsName).parent()).first();
            if (espot.length) {
                espot.addClass('emptyESpot');
            }
        }
        wcTopic.publish("CMPageRefreshEvent");
    }
}); */
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by SKU List widget
 */

SKUListJS = {

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

    /** 
     * If set to true, then the SKU compare box will be shown. Its default value is true.
     * @private
     */
    disableProductCompare: "",

    /** 
     * This array stores the products which quantities have been updated (and can be added to the cart). Its default value is empty.
     * @private
     */
    quantityList: {},

    /**
     * This variable stores the mousedown event $.proxy handle.
     */
    mouseOverConnectHandle: false,

    /**
     * Sets the common parameters for the current page. 
     * For example, the language ID, store ID, and catalog ID.
     *
     * @param {Integer} langId The ID of the language that the store currently uses.
     * @param {Integer} storeId The ID of the current store.
     * @param {Integer} catalogId The ID of the catalog.
     * @param {Integer} disableProductCompare If set to true, will disable product compare.
     */
    setCommonParameters: function (langId, storeId, catalogId, disableProductCompare) {
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        this.disableProductCompare = disableProductCompare;
    },

    /**
     * Updates the quantities of the SKU if the quantities are changed.
     * @param (string) qty The quantity value to update to.
     * @param (string) productId The ID of the product.
     * @param (string) itemId The ID of the item.
     */
    updateItemQuantity: function (qty, productId, itemId) {
        if (!(productId in this.quantityList)) {
            this.quantityList[productId] = {};
        }

        if (qty.replace(/^\s+|\s+$/g, '') == '') {
            this.removeItemQuantity(productId, itemId);
            $('#invalidQuantity_' + productId + '_' + itemId).css('display', 'none');
            return;
        }

        if (!isPositiveInteger(qty)) {
            $('#invalidQuantity_' + productId + '_' + itemId).css('display', 'block');
        } else {
            $('#invalidQuantity_' + productId + '_' + itemId).css('display', 'none');
        }

        this.quantityList[productId][itemId] = qty;
    },

    /**
     * Validate item quantity.
     * @param (string) qty The quantity value to update to.
     * @param (string) skuId The ID of the sku.
     */
    validateQuantity: function (qty, skuId) {
        if (qty.replace(/^\s+|\s+$/g, '') != '' && !isPositiveInteger(qty)) {
            $('#invalidQuantity_' + skuId).css('display', 'block');
        } else {
            $('#invalidQuantity_' + skuId).css('display', 'none');
        }
    },

    /**
     * Remove the quantity of the SKU (e.g. when row is hidden)
     * @param (string) productId The ID of the product.
     * @param (string) itemId The ID of the item.
     */
    removeItemQuantity: function (productId, itemId) {
        if (productId in this.quantityList) {
            delete this.quantityList[productId][itemId];
        }
    },

    /**
     * Remove all quantities currently inputed, e.g. after successfully added to shopping cart or req list 
     */
    removeAllQuantities: function () {
        var quantityFields = $(".productDetailTable .Quantity .input_field");

        for (var i = 0; i < quantityFields.length; i++) {
            quantityFields[i].val("");
            quantityFields[i].change();
        }
    },

    /**
     * Checks if the string is an integer.
     * @param (string) str The string to check.
     * @return (boolean) Indicates whether the string is a number.
     */
    isNumber: function (str) {
        if ((str * 0) == 0) return true;
        else return false;
    },

    /**
     * Checks if a string is null or empty.
     * @param (string) str The string to check.
     * @return (boolean) Indicates whether the string is empty.
     */
    isEmpty: function (str) {
        var reWhiteSpace = new RegExp(/^\s+$/);
        if (str == null || str === '' || reWhiteSpace.test(str)) {
            return true;
        }
        return false;
    },

    /**
     * Redirects to the store locator after appending the current URL
     * @param storeLocatorUrl The store locator URL
     */
    selectStore: function (storeLocatorUrl) {
        setPageLocation(storeLocatorUrl + "&fromUrl=" + encodeURIComponent(document.URL));
    },

    /**
     * Checks the online inventory status in the stores selected by the user
     * @param productId The product ID
     * @param type The product type 
     */
    checkOnlineAvailability: function (productId) {
        var params = {
            productId: productId,
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId
        };

        var url = appendWcCommonRequestParameters("GetOnlineInventoryStatusByIDViewV2");
        cursor_wait();

        $.ajax({
            url: url,
            dataType: "json",
            data: params,
            success:
            /**
             * Populate the contents of the online store inventory details section with the JSON returned 
             * from the server. This is the callback function that is called after the AJAX call to get the online
             * inventory details successfully returns to the client.
             * 
             * @param {object} serviceResponse The JSON response from $.ajax.
             * @param {string} status The status of $.ajax call.
             */

                function (serviceResponse, status) {
                if (serviceResponse.onlineInventory) {
					for (var item in serviceResponse.onlineInventory) {
						var onlineInventoryElement = document.getElementById("WC_Sku_List_TableContent_"+item+"_OnlineAvailability");
						var mobileInventoryElement = document.getElementById("WC_Sku_List_MbileContent_"+item+"_OnlineAvailability");
						
						if (onlineInventoryElement != null) {
							onlineInventoryElement.innerHTML = "<span> <img src='" + imageDirectoryPath + styleDirectoryPath + serviceResponse.onlineInventory[item].image 
									+ "' alt='" + serviceResponse.onlineInventory[item].altText + "' /> </span>"
									+ "<span>" + serviceResponse.onlineInventory[item].status + "</span>";
						}
						if (mobileInventoryElement != null) {
							mobileInventoryElement.innerHTML = "<span> <img src='" + imageDirectoryPath + styleDirectoryPath + serviceResponse.onlineInventory[item].image 
									+ "' alt='" + serviceResponse.onlineInventory[item].altText + "' /> </span>"
									+ "<span>" + serviceResponse.onlineInventory[item].status + "</span>";
						}
					}
                } else {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("INV_STATUS_RETRIEVAL_ERROR"));
                }
                cursor_clear();
            },
            error: function (jqXHR, textStatus, err) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("INV_STATUS_RETRIEVAL_ERROR"));
                cursor_clear();
            }
        });
    },
    /**
     * Populate the select stores/check stores link depending on whether or not
     * a physical store has been selected
     */
    populateStoreLinks: function () {
        var cookieValue = getCookie("WC_physicalStores");

        if (cookieValue != null) {
            $(".check_stores.link").removeClass("nodisplay");
        } else {
            $(".select_stores.link").removeClass("nodisplay");
        }
    },

    /**
     * Checks the inventory status in the stores selected by the user
     * @param productId The product ID
     * @param itemId The item ID 
     */
    checkAvailability: function (productId, itemId) {
        var params = {
            productId: productId,
            itemId: itemId
        };

        // For Handling multiple clicks.
        if (!submitRequest()) {
            return;
        }

        var url = appendWcCommonRequestParameters("GetInventoryStatusByIDViewV2");
        cursor_wait();

        $.ajax({
            url: url,
            dataType: "json",
            data: params,
            method: "post",
            success:

            /**
             * Populate the contents of the in store inventory details section with the JSON returned 
             * from the server. This is the callback function that is called after the AJAX call to get the inventory 
             * details successfully returns to the client.
             * 
             * @param {object} serviceResponse The JSON response from $.ajax.
             * @param {string} status The status of $.ajax call.
             */

                function (serviceResponse, status) {
                if (serviceResponse.inStoreInventory) {
                    // Removing the in store section if present
                    $("#WC_InStore_Inventory_Section_" + params.itemId).detach();
                    $("#WC_InStore_Mobile_Inventory_Section_" + params.itemId).detach();


                    // Adding the empty store section
                    $("#WC_Check_Stores_Link_" + params.itemId).before("<div id='WC_InStore_Inventory_Section_" + params.itemId + "' class='sublist'>");
                    $("#WC_Check_Stores_Link_Mobile_" + params.itemId).before("<div id='WC_InStore_Mobile_Inventory_Section_" + params.itemId + "' class='sublist'>");

                    SKUListJS.physicalStores = serviceResponse.inStoreInventory.stores;

                    // Adding the store inventory details as child elements in the store section
                    for (i = 0; i < serviceResponse.inStoreInventory.stores.length; i++) {
                        var store = serviceResponse.inStoreInventory.stores[i];

                        // Adding the store name
                        $("#WC_InStore_Inventory_Section_" + params.itemId).append("<a id='WC_InStore_Inventory_Link_" + params.itemId + "_store_" + (i + 1) + "' href='#' onclick=\"SKUListJS.fetchStoreDetails('" + store.id + "', '" + params.productId + "');\" class='store_name'>" + store.name + "&nbsp;</a>");
                        $("#WC_InStore_Mobile_Inventory_Section_" + params.itemId).append("<a id='WC_InStore_Mobile_Inventory_Link_" + params.itemId + "_store_" + (i + 1) + "' href='#' onclick=\"SKUListJS.fetchStoreDetails('" + store.id + "', '" + params.productId + "');\" class='store_name'>" + store.name + "&nbsp;</a>");
                        // Adding clear div
                        $("#WC_InStore_Inventory_Section_" + params.itemId).append("<div class='clear_float'></div>");
                        $("#WC_InStore_Mobile_Inventory_Section_" + params.itemId).append("<div class='clear_float'></div>");
                        // Adding the image status of store name
                        $("#WC_InStore_Inventory_Section_" + params.itemId).append("<span> <img src='" + imageDirectoryPath + styleDirectoryPath + store.image + "' alt='" + store.altText + "' /> </span>");
                        $("#WC_InStore_Mobile_Inventory_Section_" + params.itemId).append("<span> <img src='" + imageDirectoryPath + styleDirectoryPath + store.image + "' alt='" + store.altText + "' /> </span>");
                        // Adding the text status of store name
                        $("#WC_InStore_Inventory_Section_" + params.itemId).append("<span class='text'>" + store.statusText + "</span>");
                        $("#WC_InStore_Mobile_Inventory_Section_" + params.itemId).append("<span class='text'>" + store.statusText + "</span>");
                        // Adding spacer
                        $("#WC_InStore_Inventory_Section_" + params.itemId).append("<div class='item_spacer_10px'></div>");
                        $("#WC_InStore_Mobile_Inventory_Section_" + params.itemId).append("<div class='item_spacer_10px'></div>");
                    }

                    // Change the link from Check Stores to Change Stores
                    $("#WC_Check_Stores_Link_" + params.itemId).addClass("nodisplay");
                    $("#WC_Change_Stores_Link_" + params.itemId).removeClass("nodisplay");
                    $("#WC_Check_Stores_Link_Mobile_" + params.itemId).addClass("nodisplay");
                    $("#WC_Change_Stores_Link_Mobile_" + params.itemId).removeClass("nodisplay");
                } else {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("INV_STATUS_RETRIEVAL_ERROR"));
                }
                cursor_clear();
            },
            error: function (jqXHR, textStatus, error) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("INV_STATUS_RETRIEVAL_ERROR"));
                cursor_clear();
            }
        });
    },
    /**
     * Show physical store details popup after fetching the required details
     * @param storeId The ID of the physical store
     * @param productId The ID of the product
     */
    fetchStoreDetails: function (storeId, productId) {
        MessageHelper.hideAndClearMessage();

        var params = {
            physicalStoreId: storeId,
            productId: productId
        };

        var url = appendWcCommonRequestParameters("GetStoreDetailsByIDViewV2");

        // For Handling multiple clicks.
        if (!submitRequest()) {
            return;
        }
        cursor_wait();
        $.ajax({
            url: url,
            dataType: "json",
            data: params,
            method: "post",
            success:
            /**
             * Populate the contents of the store details section in the product display page with the JSON returned 
             * from the server. This is the callback function that is called after the AJAX call to get the inventory 
             * details successfully returns to the client.
             * 
             * @param {object} serviceResponse The JSON response from $.ajax.
             * @param {string} status The status of $.ajax call.
             */
                function (serviceResponse, status) {
                var store = serviceResponse;

                // Get unescaped working hours
                store.hours = SKUListJS.unEscapeXml(serviceResponse.hours);

                // Get inventory status
                var storeInventory = SKUListJS.fetchInventoryStatus(params.physicalStoreId);

                // Get store availability details
                store.imageTag = "<img src='" + imageDirectoryPath + styleDirectoryPath + storeInventory.image + "' alt='" + storeInventory.altText + "'/>";
                store.statusText = storeInventory.statusText;

                if (storeInventory.status == 'Available') {
                    store.availabilityDetails = "(" + storeInventory.availableQuantity + ")"; // Adding the available quantity
                } else if (storeInventory.status == 'Backorderable') {
                    store.availabilityDetails = "(" + storeInventory.availableDate + ")"; // Adding the available date
                } else {
                    store.availabilityDetails = "";
                }

                var storeDetails = $("#Store_Details_Template_" + params.productId).html();
                $("#Store_Details_" + params.productId).html(Utils.substituteStringWithObj(storeDetails, store));

                // Display store details
                var popup = $("#InventoryStatus_Store_Details_" + params.productId).data("wc-WCDialog");
                if (popup) {
                    closeAllDialogs(); // Close other dialogs(quickinfo dialog, etc) before opening this. 				
                    popup.open();
                } else {
                    console.debug("InventoryStatus_Store_Details_" + params.productId + " does not exist");
                }
                cursor_clear();
            },
            error: function (jqXHR, textStatus, error) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("INV_STATUS_RETRIEVAL_ERROR"));
                cursor_clear();
            }
        });
    },


    /**
     * Returns the inventory status object for the physical store specified
     * @param storeId The storeId of the physical store
     * @return the inventory status object for the store
     */
    fetchInventoryStatus: function (storeId) {
        for (i = 0; i < this.physicalStores.length; i++) {
            if (this.physicalStores[i].id == storeId) {
                return this.physicalStores[i];
            }
        }
        return {};
    },

    /**
     * Converts xml accepted form to < >
     * @param {String} str, String to be converted
     * @return {String} converted string
     */
    unEscapeXml: function (str) {
        return str.replace(/&lt;/gm, "<").replace(/&gt;/gm, ">");
    },

    /**
     * Show SKU list table (e.g. when button is clicked)
     * @param productId the ID of the product
     **/
    showTable: function (productId, top_category, parent_category_rn, categoryId, widgetPrefix) {
        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
        var skuListWidget = $("#WC_Sku_List_Table_" + productId);
        if (skuListWidget) {
            cursor_wait();
            skuListWidget.refreshWidget("refresh", {
                "catalogId": this.catalogId,
                "storeId": this.storeId,
                "productId": productId,
                "disableProductCompare": this.disableProductCompare,
                "jspStoreImgDir": imageDirectoryPath,
                "top_category": top_category,
                "parent_category_rn": parent_category_rn,
                "categoryId": categoryId,
                "widgetPrefix": widgetPrefix
            });
        }

        var ie_version = Utils.get_IE_version();
        if (ie_version < 9) {
            $("#lastShowSKUList").val(productId);
            this.mouseOverConnectHandle = $("#WC_Sku_List_Table_Hide_Button_" + productId).on("mouseover", $.proxy(this.handleMouseOver, this));
        }
    },

    handleMouseOver: function () {
        var productId = $("#lastShowSKUList").val();
        var node = $("#product_name_" + productId);
        var productInfoHeight = 0;
        while (node != null && node.tagName != "LI") {
            node = node.parentNode;
            if (node.className == "product_info") {
                productInfoHeight = node.offsetHeight;
            }
        }
        if (productInfoHeight > 280) {
            $(node).css("height", productInfoHeight + 40 + "px");
        }
        SKUListJS.arrangeProductDetailTables();
    },

    /**
     * Show the display of SKU list table and change the button to hide
     * @param widget the refresh area widget
     **/
    showTableView: function (productId) {
        var Widget = $("#WC_Sku_List_Table_" + productId);
        $(Widget).removeClass("nodisplay");
        $('#WC_Sku_List_Table_Full_' + productId).addClass('expanded');
        $('#WC_Sku_List_Table_Expand_Area_' + productId).addClass('hide');
        $('#WC_Sku_List_Table_Show_Button_' + productId).addClass('nodisplay');
        $('#WC_Sku_List_Table_Hide_Button_' + productId).removeClass('nodisplay');
        $("#WC_Sku_List_Table_Hide_Button_" + productId).focus();
    },

    /**
     * Hide the display of SKU list table and change the button to show
     * @param widget the refresh area widget
     **/
    hideTableView: function (productId) {
        $('#WC_Sku_List_Table_' + productId).addClass('nodisplay');
        $('#WC_Sku_List_Table_Expand_Area_' + productId).removeClass('hide');
        $('#WC_Sku_List_Table_Hide_Button_' + productId).addClass('nodisplay');
        $('#WC_Sku_List_Table_Show_Button_' + productId).removeClass('nodisplay');
        $("#WC_Sku_List_Table_Show_Button_" + productId).focus();
        if (!this.mouseOverConnectHandle) {
            $(document.documentElement).off("mouseover");
            this.mouseOverConnectHandle = false;
        }
    },

    /**
     * Toggle expanded content to show or hide (e.g. when button is clicked)
     * @param productId the ID of the product
     * @param row The row on which the expanded content is contained
     * @param skuId The SKU id of the sku which the row contains
     **/
    toggleExpandedContent: function (productId, row, skuId) {
        $('#WC_Sku_List_ExpandedContent_' + productId + '_' + row).toggleClass('nodisplay');
        $('#WC_Sku_List_Mobile_ExpandedContent_' + productId + '_' + row).toggleClass('nodisplay');
        $('#WC_Sku_List_Row_Header_Mobile_' + skuId).toggleClass('expanded');
        $('#WC_Sku_List_Title_Mobile_' + productId + '_' + row).toggleClass('expanded');
        $('#DropDownArrow_' + productId + '_' + row).toggleClass('expanded');
        $('#DropDownArrow_Mobile_' + productId + '_' + row).toggleClass('expanded');
        $('#DropDownButton_' + productId + '_' + row).toggleClass('expanded');
        $('#DropDownButton_Mobile_' + productId + '_' + row).toggleClass('expanded');

        if ($('#DropDownButton_' + productId + '_' + row).attr('aria-expanded') == 'false') {
            $('#DropDownButton_' + productId + '_' + row, 'aria-expanded').attr('true');
        } else {
            $('#DropDownButton_' + productId + '_' + row, 'aria-expanded').attr('false');
        }

        if ($('#DropDownButton_Mobile_' + productId + '_' + row, 'aria-expanded') == 'false') {
            $('#DropDownButton_Mobile_' + productId + '_' + row, 'aria-expanded').attr('true');
        } else {
            $('#DropDownButton_Mobile_' + productId + '_' + row, 'aria-expanded').attr('false');
        }
    },

    /**
     * Arranges the columns in all SKU list tables on the page. 
     */
    arrangeProductDetailTables: function () {
        var listTables = $(".productDetailTable");

        // For each product detail table, get the productId from the element's ID
        for (var i = 0; i < listTables.length; i++) {
            var productId = listTables[i].id.replace("WC_Sku_List_Table_", "");
            this.arrangeProductDetailTable(productId);
        }
    },

    /**
     * Arranges the columns in the SKU list table. If there is not enough space to show all attributes,
     * some columns will be pushed into the hidden expandable content area.
     * @param productId the productId
     */
    arrangeProductDetailTable: function (productId) {
        // This is the font being used in the column headers for the SKU List widget
        var HEADER_FONT = "bold 12px sans-serif"

        /* This is the minumum pixel width a column can be. Once the width of the columns has 
        gone below this amount, then a column will be removed and pushed into expandable hidden row */
        var MIN_COL_WIDTH = 90;

        // This is the maximum pixel width a column can be. 
        var MAX_COL_WIDTH = 250;

        var container = $("#WC_Sku_List_Table_" + productId).parent();
        var listTable = $("#WC_Sku_List_Table_Full_" + productId);
        var mobileTable = $("#WC_Sku_List_Table_Mobile_" + productId);

        // Check if table is already expanded and visible
        if ((listTable == null || listTable.offsetHeight == 0) && (mobileTable == null || mobileTable.offsetHeight == 0)) {
            return;
        }

        // Show the mobile view when the width of the container is 540 px or less
        if ($(container).width() <= 540) {
            $(listTable).css("display", "none");
            $(mobileTable).css("display", "block");
        } else {
            $(listTable).css("display", "block");
            $(mobileTable).css("display", "none");
        }

        var rowWidth = $(".row", listTable).first().width();

        // Get the set of anchored and unanchored columns
        var anchoredHeaders = $(".columnHeader.anchored", listTable);
        var anchoredCells = $(".gridCell.anchored", listTable);
        var unanchoredHeaders = $(".columnHeader.unanchored", listTable);
        var unanchoredCells = $(".gridCell.unanchored", listTable);

        // The remaining width of the table will be used for unanchored headers (10 pixel buffer, so that headers don't wrap) 
        var unanchoredWidth = rowWidth - 10;
        for (var i = 0; i < anchoredHeaders.length; i++) {
            unanchoredWidth -= $(anchoredHeaders[i]).width();
        }

        // Get the total number of columns in the SKU list table
        var unanchoredColumnWidth = MAX_COL_WIDTH;
        var numOfColumnsToMove = 0;

        // Find the number of unanchored columns that can be shown 
        if (unanchoredWidth / unanchoredHeaders.length < MIN_COL_WIDTH) {
            numOfColumnsToMove = Math.ceil(unanchoredHeaders.length - (unanchoredWidth / MIN_COL_WIDTH));
            if (numOfColumnsToMove > unanchoredHeaders.length) {
                numOfColumnsToMove = unanchoredHeaders.length;
            }
        }

        // After finding out the number of columns needed to be moved, calculate the width of each unanchored column
        var numOfRemainingColumns = unanchoredHeaders.length - numOfColumnsToMove;
        if (numOfRemainingColumns > 0) {
            unanchoredColumnWidth = unanchoredWidth / numOfRemainingColumns;
            if (unanchoredColumnWidth > MAX_COL_WIDTH) {
                unanchoredColumnWidth = MAX_COL_WIDTH;
            }
        } else {
            unanchoredColumnWidth = 0;
        }

        var headersToMove = [];
        var recalculateWidths = false;
        var padding = 20;

        // Bring the compare header to the front of the list, so it will get moved last
        if ($(".columnHeader.unanchored [data-filter=\"Compare\"]", listTable).length != 0) {
            unanchoredHeaders.unshift(unanchoredHeaders.pop());
        }

        // Check if any columns have a string that is too long to display in the currently calculated widths, and move those first
        for (var i = 0; i < unanchoredHeaders.length; i++) {
            if (i >= unanchoredHeaders.length - numOfColumnsToMove) {
                headersToMove.push(unanchoredHeaders[i]);
            } else {
                var attrNode = unanchoredHeaders[i].firstElementChild || unanchoredHeaders[i].firstChild //For IE8
                var attributeName = attrNode.innerHTML.replace(/^\s+|\s+$/g, '');

                if (this.hasLongWord(attributeName, unanchoredColumnWidth - padding, HEADER_FONT)) {
                    headersToMove.push(unanchoredHeaders[i]);
                    numOfColumnsToMove--;
                    recalculateWidths = true;
                }
            }
        }

        // If needed, recalculate the new unanchored column widths after moving a column that had a string that was too long
        if (recalculateWidths) {
            numOfRemainingColumns = unanchoredHeaders.length - headersToMove.length;
            if (numOfRemainingColumns > 0) {
                unanchoredColumnWidth = unanchoredWidth / numOfRemainingColumns;
                if (unanchoredColumnWidth > MAX_COL_WIDTH) {
                    unanchoredColumnWidth = MAX_COL_WIDTH;
                }
            } else {
                unanchoredColumnWidth = 0;
            }
        }

        // Show all columns initially
        $(unanchoredHeaders).css('display', 'block');
        $(unanchoredCells).css('display', 'block');

        // Set the percentage width of each unanchored column
        $(".columnHeader.unanchored, .gridCell.unanchored", listTable).css('width', unanchoredColumnWidth + 'px');

        // Hide all expanded content initially		
        $(".expandedCol", listTable).css('display', 'none');

        // If all columns can be displayed, then hide the expanded content area and the drop down button
        if (headersToMove.length == 0) {
            $(".expandedContent", listTable).addClass('nodisplay');
            $(".expandButton", listTable).css('display', 'none');
            $(".dropDownArrow", listTable).removeClass('expanded');
        }

        // Hide the amount of columns that need to be moved
        for (var i = 0; i < headersToMove.length; i++) {
            $(".expandButton", listTable).css('display', 'block');

            if ($(unanchoredHeaders).index(headersToMove[i]) !== -1) {
                // Get the CSS classname for the column that will be moved to the expanded columns
                var className = $(headersToMove[i]).attr("data-filter");

                // Hide the main column for this CSS class
                var columnToHide = $(".columnHeader.unanchored[data-filter=\"" + className + "\"], .gridCell.unanchored[data-filter=\"" + className + "\"]", listTable);
                $(columnToHide).css('display', 'none');

                // Show the attribute in the expanded content section
                var expandedColumnsToShow = $(".expandedCol[data-filter=\"" + className + "\"]", listTable);
                $(expandedColumnsToShow).css('display', 'block');

                // Set the right border of the cells in the table depending on row width to display the table lines 
                // properly according to the number of columns.
                if (typeof (expandedColumnsToShow[0]) != 'undefined') {
                    var expandedColWidth = $(expandedColumnsToShow[0]).width();
                    var expandedContentPadding = 40;
                    var numOfExpandedColumns = Math.floor((rowWidth - expandedContentPadding) / expandedColWidth);
                    if (numOfExpandedColumns > 1 && headersToMove.length > 1) {
                        if (i % numOfExpandedColumns == numOfExpandedColumns - 1) {
                            $(expandedColumnsToShow).css('borderRight', 'none');
                        } else {
                            $(expandedColumnsToShow).css('borderRight', '1px solid #ccc');
                        }
                    } else {
                        $(expandedColumnsToShow).css('borderRight', 'none');
                    }
                }
            }
        }
    },

    /**
     * Checks if any words in a string is longer than maxWidth
     * @param text The text string
     * @param maxWidth The max width for any word
     * @param font The font of the string
     */
    hasLongWord: function (text, maxWidth, font) {
        // Create a dummy canvas (render invisible with css)
        var c = document.createElement('canvas');

        if (!c.getContext) {
            return false;
        }

        var ctx = c.getContext('2d');
        // Set the context.font to the font that you are using
        ctx.font = font;

        if (ctx.measureText(text).width < maxWidth) {
            return false;
        }

        var words = text.split(' ');

        for (var w in words) {
            var word = words[w];
            var measure = ctx.measureText(word).width;

            if (measure > maxWidth) {
                return true;
            }
        }

        return false;
    },

    /**
     * Filters the SKU list so that only those with selected attributes are shown
     * @param skuId the ID of the item
     * @param productId the ID of the product
     */
    filterSkusByAttribute: function (skuId, productId) {
        var listTable = $("#WC_Sku_List_Table_" + productId);
        var selectedAttributes = productDisplayJS.selectedAttributesList;
        var productKey = "entitledItem_" + productId;

        if (productKey in selectedAttributes) {
            // Display all rows initially
            $(".row.entry, .mobileHeader", listTable).removeClass('nodisplay');

            for (var attribute in selectedAttributes[productKey]) {
                // The value of the selected attribute
                var selectedAttrValue = selectedAttributes[productKey][attribute].replace(/^\s+|\s+$/g, '');

                if (selectedAttrValue !== "") {
                    // The CSS class of the attribute has no spaces or 's or "s
                    var attrClass = attribute.replace(/ /g, "").replace(/'/g, "").replace(/"/g, "");

                    // Get all cells from the column matching the selected attribute 
                    //var attrCells = $(".gridCell." + attrClass, listTable);
                    var attrCells = $("div[data-filter='" + attrClass + "'].gridCell", listTable);

                    for (var i = 0; i < attrCells.length; i++) {
                        // If the selected attribute is not the same as the value inside a matching cell 
                        // found in the SKU list table, then remove the entire row and remove the quantities
                        var attrTextNode = attrCells[i].firstElementChild || attrCells[i].firstChild //For IE8 
                        if (selectedAttrValue != attrTextNode.innerHTML.replace(/^\s+|\s+$/g, '')) {
                            $(attrCells[i].parentNode).addClass('nodisplay');

                            // Get the SKU ID of the row that we want to remove and remove the row in mobile view as well
                            skuId = attrCells[i].parentNode.id.split("WC_Sku_List_Row_Content_")[1];
                            $("#WC_Sku_List_Row_Header_Mobile_" + skuId).addClass('nodisplay');

                            var quantityInput = $(".input_field", attrCells[i].parentNode).first();
                            quantityInput.val("");
                            quantityInput.change();
                        }
                    }
                }
            }
        }
    },

    /**
     * addSku2ShopCartAjax This function is used to add one SKU to the shopping cart using an AJAX call (from mobile view).
     * @param {String} productId the product Id being added to cart
     * @param {String} skuId the SKU Id being added to cart 	
     * @param {Object} customParams - Any additional parameters that needs to be passed during service invocation.
     **/
    addSku2ShopCartAjax: function (productId, skuId, customParams) {
        if (browseOnly) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_ADD2CART_BROWSE_ONLY'));
            return;
        }

        var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            orderId: "."
        };
        // Remove calculations for performance
        // params.calculationUsage = "-1,-2,-5,-6,-7";
        params.inventoryValidation = "true";
        params.calculateOrder = "0";
        var ajaxShopCartService = "AddOrderItem";

        shoppingActionsJS.productAddedList = {};

        var quantity = $("#" + skuId + "_Mobile_Quantity_Input").val();
        if (!isPositiveInteger(quantity)) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
            return;
        }

        params["catEntryId"] = skuId;
        params["quantity"] = quantity;

        shoppingActionsJS.saveAddedProductInfo(quantity, productId, skuId, null);

        //Pass any other customParams set by other add on features
        if (customParams != null && customParams != 'undefined') {
            for (i in customParams) {
                params[i] = customParams[i];
            }
            if (customParams['catalogEntryType'] == 'dynamicKit') {
                ajaxShopCartService = "AddPreConfigurationToCart";
            }
        }

        var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
        if (contractIdElements != null && contractIdElements != "undefined") {
            for (i = 0; i < contractIdElements.length; i++) {
                if (contractIdElements[i].checked) {
                    params.contractId = contractIdElements[i].value;
                    break;
                }
            }
        }

        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
        cursor_wait();

        wcService.invoke(ajaxShopCartService, params);
        if (typeof productDisplayJS != 'undefined') {
            productDisplayJS.baseItemAddedToCart = true;
        }

        if ($("#headerShopCartLink") && $("#headerShopCartLink").css('display') !== "none") {
            $("#headerShopCart").focus();
        } else if ($("#headerShopCart1")) {
            $("#headerShopCart1").focus();
        }
    },

    /**
     * addSkus2ShopCartAjax This function is used to add one or more SKUs to the shopping cart using an AJAX call.
     * @param {String} productId the product Id being added to cart 	
     * @param {Object} customParams - Any additional parameters that needs to be passed during service invocation.
     **/
    addSkus2ShopCartAjax: function (productId, customParams) {
        if (browseOnly) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_ADD2CART_BROWSE_ONLY'));
            return;

        }
        var params = {storeId: this.storeId,
catalogId: this.catalogId,
langId: this.langId,
orderId: "."};
        // Remove calculations for performance
        // params.calculationUsage = "-1,-2,-5,-6,-7";
        params.inventoryValidation = "true";
        params.calculateOrder = "0";
        params.addedFromSKUList = "true";
        var ajaxShopCartService = "AddOrderItem";

        shoppingActionsJS.productAddedList = {};

        //Get all of the SKUs and their quantities and pass in as parameters (e.g. catEntryId_1, quantity_1)
        if (productId in this.quantityList) {
            var i = 1;
            for (var skuId in this.quantityList[productId]) {
                var quantity = this.quantityList[productId][skuId];
                if (!isPositiveInteger(quantity)) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
                    return;
                }
                params["catEntryId_" + i] = skuId;
                params["quantity_" + i] = quantity;
                i++;

                shoppingActionsJS.saveAddedProductInfo(quantity, productId, skuId, null, true);
            }
        }

        if (params.catEntryId_1 == null || params.quantity_1 == null) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUTS_ERROR'));
            return;
        }

        //Pass any other customParams set by other add on features
        if (customParams != null && customParams != 'undefined') {
            for (i in customParams) {
                params[i] = customParams[i];
            }
            if (customParams['catalogEntryType'] == 'dynamicKit') {
                ajaxShopCartService = "AddPreConfigurationToCart";
            }
        }

        var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
        if (contractIdElements != null && contractIdElements != "undefined") {
            for (i = 0; i < contractIdElements.length; i++) {
                if (contractIdElements[i].checked) {
                    params.contractId = contractIdElements[i].value;
                    break;
                }
            }
        }

        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
        cursor_wait();

        wcService.invoke(ajaxShopCartService, params);
        if (typeof productDisplayJS != 'undefined') {
            productDisplayJS.baseItemAddedToCart = true;
        }

        if ($("#headerShopCartLink") && $("#headerShopCartLink").css('display') !== "none") {
            $("#headerShopCart").focus();
        } else if ($("#headerShopCart1")) {
            $("#headerShopCart1").focus();
        }
    }
}

//Declare refresh function
var declareSKUListTable_WidgetRefreshArea = function (productId) {
    if(typeof productId == "object" || typeof productId == "array") {
        productId = productId[0];
    }
    var myWidgetObj = $("#WC_Sku_List_Table_" + productId);

    var postRefreshHandler = function () {
        SKUListJS.showTableView(productId);
        SKUListJS.arrangeProductDetailTable(productId);
        SKUListJS.checkOnlineAvailability(productId);
        SKUListJS.populateStoreLinks();
        cursor_clear();
    };
    // initialize widget with properties
    myWidgetObj.refreshWidget({
        postRefreshHandler: postRefreshHandler
    });
}
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript provides all the functions needed for the B2B store logon and registration.
 * @version 1.9
 */

B2BLogonForm ={
    prepareSubmitOrgReg:function (form){
      /////////////////////////////////////////////////////////////////////////////
      // This javascript function is for 'Submit' button in the organization registration page.
      /////////////////////////////////////////////////////////////////////////////
      reWhiteSpace = new RegExp(/^\s+$/);
      if (form.org_orgEntityName !=null && (reWhiteSpace.test(form.org_orgEntityName.value) || form.org_orgEntityName.value=="")) {
         MessageHelper.formErrorHandleClient(form.org_orgEntityName.id,MessageHelper.messages["ERROR_OrgNameEmpty"]); return;
      }
      if(!AddressHelper.validateAddressForm(form,'org_')){
          return;
      }

      if (form.usr_logonId !=null && (reWhiteSpace.test(form.usr_logonId.value) || form.usr_logonId.value=="")){
         MessageHelper.formErrorHandleClient(form.usr_logonId.id,MessageHelper.messages["ERROR_LogonIdEmpty"]); return;
      }
      if (form.usr_logonPassword !=null && (reWhiteSpace.test(form.usr_logonPassword.value) || form.usr_logonPassword.value=="")){
         MessageHelper.formErrorHandleClient(form.usr_logonPassword.id,MessageHelper.messages["ERROR_PasswordEmpty"]); return;
      }else if  (form.usr_logonPasswordVerify !=null && (reWhiteSpace.test(form.usr_logonPasswordVerify.value) || form.usr_logonPasswordVerify.value=="")) {
         MessageHelper.formErrorHandleClient(form.usr_logonPasswordVerify.id,MessageHelper.messages["ERROR_PasswordEmpty"]); return;
      }else if (form.usr_logonPasswordVerify !=null && form.usr_logonPasswordVerify.value!= form.usr_logonPassword.value) {
         MessageHelper.formErrorHandleClient(form.usr_logonPasswordVerify.id,MessageHelper.messages["PWDREENTER_DO_NOT_MATCH"]); return;
      }
      if(!AddressHelper.validateAddressForm(form,'usr_')){
         return;
      }

      if (form.usr_email1 !=null && (reWhiteSpace.test(form.usr_email1.value) || form.usr_email1.value=="")){
         MessageHelper.formErrorHandleClient(form.usr_email1.id,MessageHelper.messages["ERROR_EmailEmpty"]); return;
      }else if(!MessageHelper.isValidEmail(form.usr_email1.value)){
         MessageHelper.formErrorHandleClient(form.usr_email1.id,MessageHelper.messages["WISHLIST_INVALIDEMAILFORMAT"]);return ;
      }
      if (!MessageHelper.IsValidPhone(form.usr_phone1.value)) {
         MessageHelper.formErrorHandleClient(form.usr_phone1.id,MessageHelper.messages["ERROR_INVALIDPHONE"]);
         return ;
      }

      if(form.mobileDeviceEnabled != null && form.mobileDeviceEnabled.value == "true"){
         if(!MyAccountDisplay.validateMobileDevice(form)){
            return;
         }
      }
      if(form.birthdayEnabled != null && form.birthdayEnabled.value == "true"){
         if(!MyAccountDisplay.validateBirthday(form)){
            return;
         }
      }
      this.setSMSCheckBoxes(form);

      form.submit();
   },

    constructParentOrgDN: function (ancestorOrgs) {
      var parentOrgDN = ancestorOrgs;
      while(true) {
         var n = parentOrgDN.indexOf("/");
         if(n == -1) {
            break;
         }
         parentOrgDN = parentOrgDN.substring(0, n) + "," + orgPrefix + parentOrgDN.substring(n + 1, parentOrgDN.length);
      }
      parentOrgDN = orgPrefix + parentOrgDN;
      return parentOrgDN;
   },

   setParentMemberValue: function (){
      document.Register.parentMember.value = this.constructParentOrgDN(document.Register.ancestorOrgs.value);
   },

   fillAdminAddress: function(form, jspStoreImgDir, checkbox){
        if ($('#'+checkbox).hasClass("active")){
            $('#'+checkbox).removeClass("active");
            $('#'+checkbox).attr("aria-checked", "false");
            $('#'+checkbox).attr("src", jspStoreImgDir + "images/checkbox.png");
        } else {
            $('#'+checkbox).addClass("active");
            $('#'+checkbox).attr("src", jspStoreImgDir + "images/checkbox_checked.png");
            $('#'+checkbox).attr("aria-checked", "true");

            form.usr_address1.value = this.getFieldValue(form.org_address1);
            form.usr_address2.value = this.getFieldValue(form.org_address2);
            form.usr_zipCode.value = this.getFieldValue(form.org_zipCode);

            var $orgCountry = $('#WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_org_country_1');
            var $usrCountry = $('#WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_usr_country_1');

            $usrCountry.val($orgCountry.val());
            $usrCountry.Select("refresh");

            //see AddressHelper.loadAddressFormStatesUI
            AddressHelper.loadAddressFormStatesUI(form.name,'usr_','usr_stateDiv','WC_OrganizationRegistrationAddForm_AddressEntryForm_FormInput_usr_state_1',false,this.getFieldValue(form.org_state));
            form.usr_city.value = this.getFieldValue(form.org_city);
        }
   },

   getFieldValue: function (field){
      //returns the field value iff the the field value is not null or empty.
      return (field==null || field=='')?'':field.value;
   },

   setSMSCheckBoxes: function (form) {
       /*
        * In AddressForm.jsp, setSMSCheckBoxes and sendMeSMSPreference are used as the name of the checkboxes.
        * But for the command BuyerRegistrationAdd to save the data, the name of the checkboxes must be
        * converted to receiveSMSNotification and receiveSMSPreference
        * */
       if (form.sendMeSMSNotification != null) {
           var sendMeSMSNotification = $("#"+ form.sendMeSMSNotification.id);
           if (sendMeSMSNotification != null && sendMeSMSNotification.checked) {
               form.receiveSMSNotification.value = true;
           } else {
               form.receiveSMSNotification.value = false;
           }
       } else {
           form.receiveSMSNotification.value = false;
       }


       if (form.sendMeSMSPreference != null) {
           var sendMeSMSPreference =  $("#"+ form.sendMeSMSPreference.id);
           if (sendMeSMSPreference != null && sendMeSMSPreference.checked) {
               form.receiveSMS.value = true;
           } else {
               form.receiveSMS.value = false;
           }
       } else {
           form.receiveSMS.value = false;
       }
   },

   changeFormAction: function () {
        if (document.getElementById('Register').action.indexOf('UserRegistrationAdd') != -1) {
            document.getElementById('Register').action = 'BuyerRegistrationAdd';
        } else {
            document.getElementById('Register').action = 'UserRegistrationAdd';
        }

        var tempURL = document.Register.URL.value;
        document.Register.URL.value = document.Register.URLOrg.value;
        document.Register.URLOrg.value = tempURL;
    },

    toggleOrgRegistration: function () {
        $('#WC_UserRegistrationAddForm_DivForm_1').toggleClass('nodisplay');
        this.toggleInputs($('#WC_UserRegistrationAddForm_DivForm_1'));
        $('#WC_OrganizationRegistration_DivForm_1').toggleClass('nodisplay');
        $('#WC_OrganizationRegistration_DivForm_2').toggleClass('nodisplay');
        this.disableOrgInputs();
        $('#WC_UserRegistrationAddForm_Buttons_1').toggleClass('nodisplay');
        $('#WC_OrganizationRegistration_Buttons_1').toggleClass('nodisplay');
        this.changeFormAction();
    },

    toggleInputs: function (form) {
                if ($('input, select', form).attr('disabled')) {
                        $('input, select', form).removeAttr('disabled');
                } else {
                        $('input, select', form).attr('disabled', 'disabled');
                }

    },

    disableOrgInputs: function () {
        this.toggleInputs($('#WC_OrganizationRegistration_DivForm_1'));
        this.toggleInputs($('#WC_OrganizationRegistration_DivForm_2'));
    },

    checkRegisterOrg: function (checked) {
        if (checked) {
            this.switchRegistration();
        }
    },

    submitForm: function (form) {
        //check to make sure Buyer Organization is set.
        var reWhiteSpace = new RegExp(/^\s+$/);
        if (form.ancestorOrgs !=null && reWhiteSpace.test(form.ancestorOrgs.value) || form.ancestorOrgs.value=="") {
            MessageHelper.formErrorHandleClient(form.ancestorOrgs.id,MessageHelper.messages["ERROR_OrgNameEmpty"]); return;
        }

        //set the value of buyer organization
        B2BLogonForm.setParentMemberValue(form);

        //set the SMS values
        B2BLogonForm.setSMSCheckBoxes(form);

        //now submit the form
        LogonForm.prepareSubmit(form);
        return false;
    },

    switchRegistration: function (id) {
        $('#registration_arrow').toggleClass('right');
        $('#individual_link').toggleClass('nodisplay');
        $('#individual_image_on').toggleClass('nodisplay');
        $('#organization_link').toggleClass('nodisplay');
        $('#organization_image_on').toggleClass('nodisplay');
        $('#organizationDescription').toggleClass('nodisplay');
        $('#individualDescription').toggleClass('nodisplay');

        if (id == 'individual_link') {
            $('#organization_link').focus();
        } else {
            $('#individual_link').focus();
        }
        this.toggleOrgRegistration();
    },
}
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by requisition list detail widget
 */

	ReqListInfoJS = {
			
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

		/**			
		* This variable keeps track of the requisition list type. The choice can be private ('Y') or shared ('Z')
		*/
		status: "",

		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 */
		setCommonParameters: function(langId,storeId,catalogId,status){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
			this.status = status;
		},

		/**
		* Sets the status of the requisition list and update the dropdown to display the current status.
		*
		* @param {String} status The status to set for the requisition list
		* @param {String} statusDisplay The text to show for the requisition list type dropdown (private or shared)
		* @param {String} selectDropdown id of the HTML div that represents the dropdown
		*/		
		setListStatus: function(status, statusDisplay, selectDropdown) {
			this.status = status;
			$("#reqListInfo_curStatus").html(statusDisplay);
			this.toggleSelectDropdown(selectDropdown);
		},
		
		/**
		 * Updates the name or type or both of a requisition list.
		 * @param (object) formName The form that contains the new requisition list data.
		 */
		updateReqList: function(formName) {
			MessageHelper.hideAndClearMessage();
			var form = document.forms[formName];
			if (form.reqListInfo_name!=null && this.isEmpty(form.reqListInfo_name.value)) {
				MessageHelper.formErrorHandleClient(form.reqListInfo_name.id,MessageHelper.messages["ERROR_REQUISITION_LIST_NAME_EMPTY"]); return;
			}

			form.reqListInfo_name.value = trim(form.reqListInfo_name.value);
			form.reqListInfo_type.value = this.status;
			
			//Need to give the service declaration the form with all info about all req list info
			service = wcService.getServiceById("requisitionListUpdate");
			service.setFormId(formName);
			
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			
			//This only updates the name and type for req list since another command updates items separately
			//After successful name/type update, success handler will trigger quantity update service call		
			wcService.invoke('requisitionListUpdate');
		},

		/**
		* Toggles the edit area of requisition list info section
		*/
		toggleEditInfo: function() {
			if ($("#requisitionListCurrentInfo").css('display') === ('none')) {
				$("#toolbarButton1").addClass("button_primary");
				$("#requisitionListCurrentInfo").css('display', 'block');
				$("#editRequisitionListInfo").css('display', 'none');
			} else {
				$("#toolbarButton1").addClass("button_secondary");
				$("#requisitionListCurrentInfo").css('display', 'none');				
				$("#editRequisitionListInfo").css('display', 'block');	
			}
		},

		/**
		* Toggles the requisition list type dropdown
		* @param {String} selectDropdown id of the HTML div that represents the dropdown
		*/		
		toggleSelectDropdown: function(selectDropdown) {
			if ($("#"+selectDropdown).css('display') === 'none') {
				$("#"+selectDropdown).css('display', 'block');
			}	else {
				$("#"+selectDropdown).css('display', 'none');
			}
		},

		/**
		 * Checks if a string is null or empty.
		 * @param (string) str The string to check.
		 * @return (boolean) Indicates whether the string is empty.
		 */
		isEmpty: function(str) {
			var reWhiteSpace = new RegExp(/^\s+$/);
			if (str == null || str =='' || reWhiteSpace.test(str) ) {
				return true;
			}
			return false;
		},

	}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by requisition list items widget
 */

	ReqListItemsJS = {
			
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
		
		/**
		* This variable stores the ID of the requisition list. Its default value is empty.
		*/
		requisitionListId: "",

		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 * @param {Integer} requisitionListId The ID of the requisition list.
		 */
		setCommonParameters: function(langId,storeId,catalogId,requisitionListId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
			this.requisitionListId = requisitionListId;
		},

		/**
		 * Adds an item to the requisition list.
		 * @param (object) formName The form that contains the items to add to the requisition list.
		 */
		addItemToReqList:function(formName){
			MessageHelper.hideAndClearMessage();
			var form = document.forms[formName];
			if (form.skuAdd!=null && this.isEmpty(form.skuAdd.value.replace(/^\s+|\s+$/g, ''))) {
				MessageHelper.formErrorHandleClient(form.skuAdd.id,MessageHelper.messages["ERROR_REQUISITION_LIST_SKU_EMPTY"]); return;
			}else if (form.quantityAdd!=null && this.isEmpty(form.quantityAdd.value.replace(/^\s+|\s+$/g, ''))) {
				form.quantityAdd.value = "1";
			}else if (!this.isNumber(form.quantityAdd.value.replace(/^\s+|\s+$/g, '')) || form.quantityAdd.value.replace(/^\s+|\s+$/g, '') <= 0) {
				MessageHelper.formErrorHandleClient(form.quantityAdd.id,MessageHelper.messages["ERROR_REQUISITION_LIST_QUANTITY_ONE_OR_MORE"]); return;
			}
			
			var params = {
			requisitionListId: form.requisitionListId.value,
			partNumber: form.skuAdd.value.replace(/^\s+|\s+$/g, ''),
			quantity: form.quantityAdd.value.replace(/^\s+|\s+$/g, ''),
			operation: "addItem",
			storeId: this.storeId,
			catalogId: this.catalogId,
			langId: this.langId			
			};
			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('requisitionListAddItem',params);
		},
	
		/**
		 * Updates the quantities of each item in the requisition list, if the quantities are changed.
		 * This function is automatically called by the sucessHandler of requisitionListUpdate.
		 * @see RequisitionList.updateReqList()
		 * @see MyAccountServiceDeclaration.js requisitionListUpdate declaration
		 * @param (string) requisitionListId The ID of the requisition list to update.
		 */
		updateItemQuantity:function (qtyDiv, orderItemId, row) {
		
			var params={
			requisitionListId: this.requisitionListId,
			quantity: $(qtyDiv).val(),
			orderItemId: orderItemId,
			storeId: this.storeId,
			catalogId: this.catalogId,
			langId: this.langId,
			operation: "updateQty",
			row: row
			};
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			wcService.invoke('requisitionListUpdateItem',params);
		},

		/**
		* Shows the "quantity updated" message next to quantity input
		* @param {Integer} row The row number of the quantity input in the table
		*/		
		showUpdatedMessage: function(row) {
			$('#reqItem_msg_qty_updated_'+row).css('display','block');
			$('#table_r'+row+'_input2').css('border','1px solid #006ecc');
			setTimeout("ReqListItemsJS.hideUpdatedMessage("+row+")", 5000);
		},

		/**
		* Hides the "quantity updated" message next to quantity input
		* @param {Integer} row The row number of the quantity input in the table
		*/		
		hideUpdatedMessage: function(row) {
			$('#reqItem_msg_qty_updated_'+row).css('display','none');
			$('#table_r'+row+'_input2').css('border','1px solid #b7b7b7');
		},
		
		/**
		 * Deletes an item from the requisition list for the Ajax flow.
		 * @param (string) orderItemId The item to delete from the requisition list.
		 */
		deleteItemFromReqList:function (orderItemId) {
			var params = {
			requisitionListId: this.requisitionListId,
			orderItemId: orderItemId,
			quantity: "0",
			storeId: this.storeId,
			catalogId: this.catalogId,
			langId: this.langId,	
			operation: "deleteItem"
			};
			/*For Handling multiple clicks. */
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcService.invoke('requisitionListDeleteItem',params);
		},

		/**
		 * Adds all of the order items from the current requisition list to the current order.
		 * Checks whether the current requisition list contains items.
		 */
		addListToOrder:function () {
			var form = document.forms["RequisitionListAddToCartForm"];
			var formElements = form.elements;
			var params = {};

			for(var i = 0; i < formElements.length; i++) {
				if (formElements[i].name.indexOf("quantity") == -1 && formElements[i].name.indexOf("ProductInfo") == -1) {
					// ingore all hidden "quantity" and "ProductInfo" inputs - do not add to params
					params[formElements[i].name] = formElements[i].value;
				}
			}
									
			MessageHelper.hideAndClearMessage();
	
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			} 
			
			cursor_wait();
			service = wcService.getServiceById('requisitionListAjaxPlaceOrder');
			service.formId = form;
			wcService.invoke('requisitionListAjaxPlaceOrder', params);
		},			

		/**
		 * Adds selected item from the current requisition list to the current order.
		 * @param (String) catEntryId catentry id of the item to be added to the current order
		 * @param (String) partNumber part number of the item to be added to the current order
		 * @param (String) row row number of the item in the requisition list
		 */
		addItemToOrder:function (catEntryId,partNumber,row) {
			var form = document.forms["RequisitionListAddToCartForm"];
			var formElements = form.elements;
			var params = {};
			
			for(var i = 0; i < formElements.length; i++) {
				if (formElements[i].name.indexOf("quantity") != -1) {
					if(formElements[i].name.indexOf("quantity_"+row) != -1) {
						// just add quantity of the specified row to params
						params["quantity"] = formElements[i].value;
					}
				} else if (formElements[i].name.indexOf("ProductInfo") == -1) {
					// ingore all hidden "ProductInfo" inputs - do not add to params
					params[formElements[i].name] = formElements[i].value;
				}
			}
			params["partNumber"] = partNumber;
			params["inventoryValidation"] = true;
			params["orderId"] = ".";
			
			// used by mini shopcart
			var selectedAttrList = new Object();
			shoppingActionsJS.saveAddedProductInfo(params["quantity"], catEntryId, catEntryId, selectedAttrList);
			
			MessageHelper.hideAndClearMessage();
	
			//For Handling multiple clicks
			if(!submitRequest()){
				return;
			} 
			
			cursor_wait();
			wcService.invoke('ReqListAddOrderItem',params);
			
			// close action dropdown
			hideMenu($('#RequisitionListItems_actionButton'+row));
			hideMenu($('#RequisitionListItems_actionDropdown'+row));
		},	
			
		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = Number(pageNumber);
			pageSize = Number(pageSize);

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();

			wcRenderContext.updateRenderContext('RequisitionListItemTable_Context', {"beginIndex": beginIndex, "requisitionListId":this.requisitionListId});
			MessageHelper.hideAndClearMessage();
		},
		
		/**
		 * Checks if the string is an integer.
		 * @param (string) str The string to check.
		 * @return (boolean) Indicates whether the string is a number.
		 */
		isNumber:function (str) {
			if ((str*0)==0) return true;
			else return false;
		},		
		
		/**
		 * Checks if a string is null or empty.
		 * @param (string) str The string to check.
		 * @return (boolean) Indicates whether the string is empty.
		 */
		isEmpty: function(str) {
			var reWhiteSpace = new RegExp(/^\s+$/);
			if (str == null || str =='' || reWhiteSpace.test(str) ) {
				return true;
			}
			return false;
		},

	}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage requisition lists and the items within.
 * This file is included in all pages with requisition list actions.
 */


/**
 * This class defines the functions and variables that customers can use to create, update, and view their requisition lists.
 * @class The RequisitionListJS class defines the functions and variables that customers can use to manage their requisition lists, 
 */
RequisitionListJS ={		
		
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
	
	/**
	 * Sets the common parameters for the current page. 
	 * For example, the language ID, store ID, and catalog ID.
	 *
	 * @param {Integer} langId The ID of the language that the store currently uses.
	 * @param {Integer} storeId The ID of the current store.
	 * @param {Integer} catalogId The ID of the catalog.
	 */
	setCommonParameters:function(langId,storeId,catalogId){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		cursor_clear();
	},	
	
	/**
	 * Initialize the URL of Requisition List widget controller. 	 
	 *
	 * @param {object} widgetUrl The controller's URL.
	 */
	initRequisitionListUrl:function(widgetUrl){
		$("#RequisitionListTable_Widget").refreshWidget("updateUrl", widgetUrl);
	},
		
	/**
	 * Creates an empty requisition list.
	 * @param (object) formName The form which contains the name and type of the requisition list.
	 * @param (object) widgetName The widget name.
	 */
	createNewList:function() {			
		var form_name = document.getElementById("RequisitionList_NewListForm_Name");
		if (form_name !=null && this.isEmpty(form_name.value)) {
			MessageHelper.formErrorHandleClient(form_name.id,MessageHelper.messages["LIST_TABLE_NAME_EMPTY"]); return;
		}				
		service = wcService.getServiceById('requisitionListCreate');
		service.setFormId("newListDropdown");
		var params = {
		editable: "true",
		storeId: this.storeId,
		catalogId: this.catalogId,
		langId: this.langId
		};
			
		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke('requisitionListCreate',params);		
	},
	/**
	 * Deletes a requisition list
	 * @param (string) requisitionListId The identifier of the selected requisition list.
	 */
	deleteList:function (requisitionListId) {
		var params = {
		requisitionListId: requisitionListId,
		filterOption: "All",
		storeId: this.storeId,
		catalogId: this.catalogId,
		langId: this.langId		
		};
		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke('AjaxRequisitionListDelete',params);
	},
	
	/**
	 * Create a duplicated requisition list.
	 * @param (object) name The name of the new requisition.
	 * @param (object) status The status of the new requisition.
	 * @param (string) orderId The order to create the requisition list from.
	 */
	duplicateReqList:function (name,status,orderId) {
		MessageHelper.hideAndClearMessage();
						
		var params = {
		editable: "true",
		storeId: this.storeId,
		catalogId: this.catalogId,
		langId: this.langId,
		orderId: orderId,	
		name: name,
		status: status
		};
			
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		wcService.invoke('requisitionListCopy',params);		
	},		
	
	/**
	 * This function sets the url for AjaxRequisitionListSubmit service and then it invokes the service to copy the old order.
	 * @param {string} AddToCartURL The url for the order copy service.
	 */
	addReqListToCart:function(AddToCartURL){

		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}   		
		cursor_wait();
		
		wcService.getServiceById("addRequisitionListToCart").setUrl(AddToCartURL);
		wcService.invoke("addRequisitionListToCart");
	},
	
	/**
	 * Checks if a string is null or empty.
	 * @param (string) str The string to check.
	 * @return (boolean) Indicates whether the string is empty.
	 */
	isEmpty:function (str) {
		var reWhiteSpace = new RegExp(/^\s+$/);
		if (str == null || str =='' || reWhiteSpace.test(str) ) {
			return true;
		}
		return false;
	},
	
	/**
	 * Uploads a new requisition list file for processing.
	 * @param (object) formObj A reference to a form element containing the new requisition list CSV to upload.
	 * @param (object) inputObject A reference to an input element to show an error message against.
	 */		
	submitAndUploadReqList:function(formObj, inputObject) {
		MessageHelper.hideAndClearMessage();
		
		if (formObj.UpLoadedFile.value=='') {
			if (inputObject) {
				MessageHelper.formErrorHandleClient(inputObject.id,MessageHelper.messages["ERROR_REQUISITION_UPLOAD_FILENAME_EMPTY"]); 
			}
			return;
		}
		formObj.submit();
	},

	/**
	 * Show requisition list results based on page number
	 * @param (object) data The object contains page number, page size, linkId
	 */
	showResultsPageNumberForRequisitionList:function(data){
		var pageNumber = data['pageNumber'];
		var pageSize = data['pageSize'];
		pageNumber = Number(pageNumber);
		pageSize = Number(pageSize);
		
		setCurrentId(data["linkId"]);
		if(!submitRequest()){
			return;
		}
		
		var beginIndex = pageSize * (pageNumber -1);
		cursor_wait();
		wcRenderContext.updateRenderContext("RequisitionListTable_Context", {"beginIndex":beginIndex , "orderBy":""},"");
	}
}

/** 
 * Add a click event listener to the <i>uploadButton</i> on the requisition list page 
 * only if the browser is not IE.
*/ 
$( document ).ready(function() { 
    var ie_version = Utils.get_IE_version();
    if (!ie_version ) {
		var RequisitionListWidgetDom = $('#RequisitionListTable_Widget');
		if (RequisitionListWidgetDom) {		
				$(RequisitionListWidgetDom).on("click", "#uploadButton", function(e){
				$('#UpLoadedFile').click();
				if (e.preventDefault) {
					e.preventDefault();
				}				
			});
		}
	};
});
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/**
 * Declares a new render context for creating a new list.
 */


/**
 * Declares a new refresh controller for creating a new List.
 */
function declareRequisitionListTableRefreshArea() {
    var myWidgetObj = $("#RequisitionListTable_Widget");
    wcRenderContext.declare("RequisitionListTable_Context", ["RequisitionListTable_Widget"], {
        "beginIndex": "0",
        "orderBy": ""
    }, "");




    var myRCProperties = wcRenderContext.getRenderContextProperties("RequisitionListTable_Context");


    var renderContextChangedHandler = function () {
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    };
	   
    wcTopic.subscribe(['requisitionListCreate', 'AjaxRequisitionListDelete', 'requisitionListCopy'], function () {
        myWidgetObj.refreshWidget("refresh", myRCProperties);

    });

	/** 
     * Clears the progress bar*/

     var postRefreshHandler = function() {
		 cursor_clear();
		 
		 toggleMobileView();
	}
        // initialize widget
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: renderContextChangedHandler,
        postRefreshHandler: postRefreshHandler
});
};
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * @fileOverview This javascript is used by the Requisition List pages to handle the services for
 * creating/deleting/updating requisition lists and adding/removing/updating items from a requisition list.
 * @version 1.10
 */


/**
 * This service allows customer to create a new requisition list
 * @constructor
 */
wcService.declare({
	id:"requisitionListCreate",
	actionId:"requisitionListCreate",
	url:"AjaxRESTRequisitionListCreate",
	formId:""

	 /**
	 * Hides all the messages and the progress bar.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_REQUISITIONLIST_CREATE_SUCCESS"]);
	}

	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,failureHandler: function(serviceResponse) {

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
}),
/**
 * This service deletes an existing requisition list.
 * @constructor
 */
wcService.declare({
	id:"AjaxRequisitionListDelete",
	actionId:"AjaxRequisitionListDelete",
	url:"AjaxRESTRequisitionListDelete",
	formId:""

	 /**
	 * Hides all the messages and the progress bar.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_REQUISITIONLIST_DELETE_SUCCESS"]);
	}

	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,failureHandler: function(serviceResponse) {

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
}),

/**
* This service allows customer to add a requisition list to shopping cart.
* @constructor
*/
wcService.declare({
	id: "addRequisitionListToCart",
	actionId: "addRequisitionListToCart",
	url: "AjaxRESTRequisitionListSubmit",
	formId: ""

	 /**
	  *  Copies all the items from the existing order to the shopping cart.
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		for (var prop in serviceResponse) {
			console.debug(prop + "=" + serviceResponse[prop]);
		}
		setDeleteCartCookie();
		cursor_clear();
		document.location.href="RESTOrderCalculate?calculationUsage=-1,-2,-3,-4,-5,-6,-7&updatePrices=1&doConfigurationValidation=Y&errorViewName=AjaxOrderItemDisplayView&orderId=.&langId="+serviceResponse.langId+"&storeId="+serviceResponse.storeId+"&catalogId="+serviceResponse.catalogId+"&URL=AjaxCheckoutDisplayView";
	}
	/**
	 * display an error message.
	 * @param (object) serviceResponse The service response object, which is the
	 * JSON object returned by the service invocation.
	 */
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessageKey == "_ERR_PROD_NOT_ORDERABLE") {
			MessageHelper.displayErrorMessage(MessageHelper.messages["PRODUCT_NOT_BUYABLE"]);
		} else if (serviceResponse.errorMessageKey == "_ERR_INVALID_ADDR") {
			MessageHelper.displayErrorMessage(MessageHelper.messages["INVALID_CONTRACT"]);
		}else {
			if (serviceResponse.errorMessage) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
		}
		cursor_clear();
	}
}),

/**
* This service allows customer to create a requisition list from an existing requisition list.
* @constructor
*/
wcService.declare({
	id:"requisitionListCopy",
	actionId:"requisitionListCopy",
	url:"AjaxRESTRequisitionListCopy",
	formId:""

	 /**
	* Hides all the messages and the progress bar.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_REQUISITIONLIST_CREATE_SUCCESS"]);
	}

	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			var errorMsg = serviceResponse.errorMessage;
			//If the errorMessage param is the generic error message
			//Display the systemMessage instead
			if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
				} else {
					//If systemMessage is empty, then just display the generic error message
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
			} else {
				//If errorMessage is not generic, display errorMessage
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		}
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}
})
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by saved order detail widget
 */

	SavedOrderInfoJS = {

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

			/** 
			 * This variable stores the order ID of the saved order. Its default value is empty.
			 */
			orderId : "",
			
			/**
			 * Sets the common parameters for the current page. 
			 * For example, the language ID, store ID, and catalog ID.
			 *
			 * @param {Integer} langId The ID of the language that the store currently uses.
			 * @param {Integer} storeId The ID of the current store.
			 * @param {Integer} catalogId The ID of the catalog.
			 */
			setCommonParameters:function(langId,storeId,catalogId){
				this.langId = langId;
				this.storeId = storeId;
				this.catalogId = catalogId;
			},
	
			/**
			 * Updates the name/description of a saved order.
			 * @param (object) formName The form that contains the saved order name.
			 * 
			 */
			updateDescription: function(formName) {
				MessageHelper.hideAndClearMessage();
				var form = document.forms[formName];
				
				form.savedOrderInfo_name.value = trim(form.savedOrderInfo_name.value);
				form.oldSavedOrderInfo_name.value = trim(form.oldSavedOrderInfo_name.value);
				
				var desc = form.savedOrderInfo_name;
				var oldDesc = form.oldSavedOrderInfo_name;

				// Check to see if the order description has really changed by comparing it to the original value.
				if (desc != oldDesc) {
					//Need to give the service declaration the form with all info about saved order name info
					service = wcService.getServiceById("savedOrderUpdateDescription");
					service.setFormId(formName);
					
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					
					//This updates the name/description of the saved order		
					wcService.invoke('savedOrderUpdateDescription');
				}

			},

			/**
			* Toggles the edit area of saved order info section
			*/
			toggleEditInfo:function() {
				if ($("#savedOrderCurrentInfo").css("display") === "none") {
					$("#savedOrderCurrentInfo").css("display", "block");
					$("#editSavedOrderInfo").css("display", "none");
				} else {
					$("#savedOrderCurrentInfo").css("display", "none");				
					$("#editSavedOrderInfo").css("display", "block");	
				}
			},
			
			/**
			 * Checks if a string is null or empty.
			 * @param (string) str The string to check.
			 * @return (boolean) Indicates whether the string is empty.
			 */
			isEmpty: function(str) {
				var reWhiteSpace = new RegExp(/^\s+$/);
				if (str == null || str =='' || reWhiteSpace.test(str) ) {
					return true;
				}
				return false;
			},
      
                        /**
                         *This method toggles the lock set on the order. It submits the 'savedOrderToggleLockForm' form declared.
                         *Based on the action defined in the form, the order is either locked or unlocked.                         
                         */                                                       
                        toggleOrderLock: function(){
                                document.forms['savedOrderToggleLockForm'].URL.value = document.location.href;
                                document.forms['savedOrderToggleLockForm'].submit();
                                return true;
                        }
	}
  
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by saved order detail widget
 */

	SavedOrderItemsJS = {

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

			/** 
			 * This variable stores the order ID of the saved order. Its default value is empty.
			 */
			orderId : "",
			
			/**
			 * This variable stores the current order ID. Its default value is empty.
			 */
			currentOrderId : "",
			
			/** The currently selected row. **/
			currentRow : "",
			
			/** The URL of the shopping cart used to forward the page when an order is converted to the current order. **/
			shoppingCartURL : "",
			
			/**
			 * Sets the common parameters for the current page. 
			 * For example, the language ID, store ID, and catalog ID.
			 *
			 * @param {Integer} langId The ID of the language that the store currently uses.
			 * @param {Integer} storeId The ID of the current store.
			 * @param {Integer} catalogId The ID of the catalog.
			 * @param {Integer} orderId The ID of the saved order.
			 */
			setCommonParameters:function(langId,storeId,catalogId,orderId){
				this.langId = langId;
				this.storeId = storeId;
				this.catalogId = catalogId;
				this.orderId = orderId;
			},

			/**
			 * Returns the current row.
			 * @returns {String} The current row number.
			 **/
			getCurrentRow:function() {
				return this.currentRow;
			},
			
			/**
			 * Resets the current row variable.
			 **/
			resetCurrentRow:function() {
				this.currentRow = "";
			},
			
			/**
			 * Sets the URL of the current shopping cart view.
			 *
			 * @param shoppingCartURL The URL of the shopping cart view.
			 */
			setCurrentShoppingCartURL : function(shoppingCartURL)
			{
				this.shoppingCartURL = shoppingCartURL;
			},
			
			/**
			 * Returns the URL of the shopping cart view.
			 * @returns {String} The URL of the shopping cart view.
			 **/
			getCurrentShoppingCartURL:function() {
				return this.shoppingCartURL;
			},
			
			/**
			 * Initialize the URL of Saved Order Items widget controller. 	 
			 *
			 * @param {object} widgetUrl The controller's URL.
			 */
			initSavedOrderItemsUrl:function(widgetUrl){
				$("#SavedOrderItemTable_Widget").attr("refreshurl", widgetUrl);
			},

			/**
			 * This function validates the SKU input values and their corresponding quantities 
			 * before sending the request to the server to add the SKUs to the saved order.
			 * An error message would be displayed if the inputs are invalid and the requested will be stopped.
			 * @param (object) formName The form that contains the items to add to the requisition list.
			 */
			addItemToSavedOrder:function(formName){
				MessageHelper.hideAndClearMessage();
				var form = document.forms[formName];
				if (form.skuAdd != null && this.isEmpty(form.skuAdd.value)) {
					MessageHelper.formErrorHandleClient(form.skuAdd.id,MessageHelper.messages["SAVED_ORDER_EMPTY_SKU"]); return;
				}else if (form.quantityAdd != null && this.isEmpty(form.quantityAdd.value)) {
					form.quantityAdd.value = "1";
				}else if (isNaN(form.quantityAdd.value) || form.quantityAdd.value <= 0) {
					MessageHelper.formErrorHandleClient(form.quantityAdd.id,MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]); return;
				}
				
				var params = {
					orderId: form.orderId.value,
					partNumber: form.skuAdd.value,
					quantity: form.quantityAdd.value,
					calculationUsage : form.calculationUsage.value,
					calculateOrder: "1",
					storeId : this.storeId,
					catalogId : this.catalogId,
					langId : this.langId
				};
				
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wcService.invoke('AjaxAddSavedOrderItem',params);
			},

			/**
			 * Adds item to the current order
			 * @param {Integer} partNumber The partNumber of the item to add to the current order.
			 * @param (string) row The row number of the quantity input in the table.
			 * @param (string) catEntryId The catentry ID of the item
			 */
			addItemToCurrentOrder:function(partNumber, row, catEntryId){
				var params = {
					storeId: this.storeId,
					catalogId: this.catalogId,
					langId: this.langId,
					calculationUsage: "-1,-2,-3,-4,-5,-6,-7",
					calculateOrder: "0",
					mergeToCurrentPendingOrder: "Y",
					URL: "",
					partNumber: partNumber,
					inventoryValidation: true,
					orderId: ".",
					quantity: $("#orderItem_input_" + row).val()
				};
				
				// used by mini shopcart
				var selectedAttrList = new Object();
				shoppingActionsJS.saveAddedProductInfo(params["quantity"], catEntryId, catEntryId, selectedAttrList);
				
				MessageHelper.hideAndClearMessage();
				
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wcService.invoke('AddOrderItem',params);
				// close action dropdown
				hideMenu($('#actionButton' + row)[0]);
				hideMenu($('#actionDropdown' + row)[0]);
			},

			/**
			 * This function deletes an order item from a saved order.
			 * @param {Integer} orderItemId The ID of the order item to delete.
			 */
			deleteItem:function(orderItemId){ 
				var params = {
					orderItemId: orderItemId,
					storeId : this.storeId,
					catalogId : this.catalogId,
					langId : this.langId,
					orderId : Utils.existsAndNotEmpty(this.orderId) ? this.orderId : ".",
					calculationUsage : "-1,-2,-3,-4,-5,-6,-7",
					check: "*n"
				};
				
				//For handling multiple clicks
				if(!submitRequest()){
					return;
				}
				
				cursor_wait();
				wcService.invoke("AjaxSavedOrderDeleteItem", params);
				
			},
			
			/**
			 * Updates the quantities of each item in the saved order, if the quantities are changed.
			 * @param (string) qty The quantity value to update to.
			 * @param (string) orderItemId The ID of the saved order to update.
			 * @param (string) row The row number of the quantity input in the table.
			 */
			updateItemQuantity:function (qty, orderItemId, row) {
				if(isNaN(qty)){
					$("#orderItem_input_"+row).val($("#oldOrderItem_input_"+row).val());
					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]);
					return;
				} else {
					var params = {
						orderId : Utils.existsAndNotEmpty(this.orderId) ? this.orderId : ".",
						quantity: qty,
						orderItemId: orderItemId,
						storeId : this.storeId,
						catalogId : this.catalogId,
						langId : this.langId,
						calculationUsage : "-1,-2,-3,-4,-5,-6,-7",
						check: "*n",
						calculateOrder: "1"
					};
					
					this.currentRow = row;
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wcService.invoke('AjaxSavedOrderUpdateItem',params);
				}
				
			},
			
			/**
			 * Sets the selected saved order as the current order when the <b>Set as Current Order and Checkout</b> button is clicked.
			 * This method updates the current order in the database to match the order in the shopping cart.
			 *
			 * @param orderId The ID of the saved order.
			 * **/
			setCurrentOrderAndCheckout : function(orderId) {
				if (Utils.isNullOrUndefined(this.orderId)) {
					this.orderId = orderId;
				}
				
				var params = {
					storeId : this.storeId,
					catalogId : this.catalogId,
					langId : this.langId,
					URL : "AjaxOrderItemDisplayView",
					orderId : this.orderId,
					nextAction: true
				};
				
				//For handling multiple clicks
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wcService.invoke("AjaxUpdatePendingOrder", params);
			},
			
			/**
			 * Display saved order items for pagination
             * TODO: check if this is unused, it appears to be ...
			 */
			showResultsPage:function(data){
				var pageNumber = data['pageNumber'];
				var pageSize = data['pageSize'];
				pageNumber = parseInt(pageNumber);
				pageSize = parseInt(pageSize);
		
				setCurrentId(data["linkId"]);
		
				if(!submitRequest()){
					return;
				}
		
				console.debug(wcRenderContext.getRenderContextProperties("SavedOrderItemTable_Context"));
				var beginIndex = pageSize * ( pageNumber - 1 );
				cursor_wait();
				wcRenderContext.updateRenderContext('SavedOrderItemTable_Context', {'beginIndex':beginIndex});
				MessageHelper.hideAndClearMessage();
			},

			/**
			* Shows the "quantity updated" message next to quantity input
			* This function is automatically called by the successHandler of AjaxUpdateOrderItem.
			*/
			showUpdatedMessage: function() {
				$("#orderItem_msg_qty_updated_"+this.currentRow).css("display", "block");
				$("#orderItem_input_"+this.currentRow).css("border", "1px solid #006ecc");
				setTimeout("SavedOrderItemsJS.hideUpdatedMessage("+this.currentRow+")", 3000);
			},

			/**
			* Hides the "quantity updated" message next to quantity input
			* @param {Integer} row The row number of the quantity input in the table
			*/		
			hideUpdatedMessage: function(row) {
				$("#orderItem_msg_qty_updated_"+row).css("display", "none");
				$("#orderItem_input_"+row).css("border", "1px solid #b7b7b7");
			},
						
			/**
			 * Checks if a string is null or empty.
			 * @param (string) str The string to check.
			 * @return (boolean) Indicates whether the string is empty.
			 */
			isEmpty: function(str) {
				var reWhiteSpace = new RegExp(/^\s+$/);
				if (str == null || str =='' || reWhiteSpace.test(str) ) {
					return true;
				}
				return false;
			}
	}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage member group within.
 * This file is included in all pages with organization users member group actions.
 */

/**
 * This service allow administrator to update roles of member
 * @constructor
 */
wcService.declare({
	id:"RESTUserMbrGrpMgtMemberUpdate",
	actionId:"RESTUserMbrGrpMgtMemberUpdate",
	url:"RESTupdateMemberUser",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["USERMEMBERGROUPMANAGEMENT_UPDATE_SUCCESS"]);
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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

/**
 * This class defines the functions and variables that customers can use to create, update, and view their buyers list.
 * @class The UserMemberGroupManagementJS class defines the functions and variables that customers can use to manage their buyers list, 
 */
UserMemberGroupManagementJS = {		
	
	/**
	 * the widget name
	 * @private
	 */
	widgetShortName: "UserMemberGroupManagement",
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
	
	/**
	 * The member group form Id.
	 * @private
	 */
	formId: "",
	
	/**
	 * The element Id for inclusion member group select dropdown widget.
	 * @private
	 */
	includeGrpDropdownId: "",
	
	/**
	 * The element id for exclusion member group select dropdown widget.
	 * @private
	 */
	excludeGrpDropdownId: "",
	
	/**
	 * The array of assigned include member group IDs.
	 * @private
	 */
	assignedIncGroups: new Array(),
	
	/**
	 * The array of assigned exclude member group IDs.
	 * @private
	 */
	assignedExcGroups: new Array(),
			
	/**
	 * Sets the common parameters for the current page. 
	 * For example, the language ID, store ID, and catalog ID.
	 * 
	 * @param {Integer} langId The ID of the language that the store currently uses.
	 * @param {Integer} storeId The ID of the current store.
	 * @param {Integer} catalogId The ID of the catalog.
	 * @param {String} formId The ID of the member group form.
	 * @param {String} includeGrpDropdownId The ID of the inclusive member group select option dropdown.
	 * @param {String} excludeGrpDropdownId The ID of the exclusive member group select option dropdown.
	 */
	setCommonParameters: function(langId,storeId,catalogId, formId, includeGrpDropdownId, excludeGrpDropdownId){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		this.formId = formId;
		this.includeGrpDropdownId = includeGrpDropdownId;
		this.excludeGrpDropdownId = excludeGrpDropdownId;
		cursor_clear();
	},
	
	/**
	 * Initialize assignedIncGroups and assignedExcGroups array on page load and after refresh.
	 */
	initializeData: function(){
		var form = document.getElementById(this.formId);
		var _this = this;
		if (form !== undefined && form !== null){
			
			_this.assignedExcGroups = [];
			_this.assignedIncGroups = [];

			$(form).find("input[name='addAsExplicitInclusionToMemberGroupId']").each( $.proxy(function(i, incGrp) {
				_this.assignedIncGroups.push($(incGrp).val().replace(/^\s+|\s+$/g, ''));
			}, _this));

			$(form).find("input[name='addAsExplicitExclusionToMemberGroupId']").each( $.proxy(function(i, excGrp) {
				_this.assignedExcGroups.push($(excGrp).val().replace(/^\s+|\s+$/g, ''));
			}, _this));

		}
	},
	
	/**
	 * Initialize the URL for controller 'declareUserMemberGroupManagement_controller'. 	 
	 *
	 * @param {object} widgetUrl The URL for declareUserMemberGroupManagement_controller.
	 */
	initializeControllerUrl:function(widgetUrl){
		$('#UserMemberGroupManagement').attr("refreshurl", widgetUrl);
	},
	
	/**
	 * Subscribe to press cancel button event
	 */
	subscribeToToggleCancel: function(){
		var topicName = "sectionToggleCancelPressed";
 		var scope = this;

		wcTopic.subscribe( topicName, function(data) {
			if (data.target === 'WC_UserMemberGroupManagement_pageSection'){
				scope.doCancel();
			}
		});
	},
	
	/**
	 * Handle select a include group from include group select dropdown
	 * @param (Integer) grpId The ID of the member group to select
	 */
	selectIncGrp: function(grpId){
		var _this = this;
		if (grpId != ''){
			//create the corresponding input
			var formNode = $("#" + _this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitInclusionToMemberGroupId' value='" + grpId + "'/>");
			//disable corresponding entry in select dropdown
			var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
			includeGrpDropdown.val("");
			includeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", true);
			includeGrpDropdown.Select("refresh");

			var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
			excludeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", true);
			excludeGrpDropdown.Select("refresh");
			
			$(".includeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "false");
		}
	},
	
	/**
	 * Handle click on a cross icon of a member group in Include member group section
	 * @param (Integer) grpId The ID of the member group to de-select
	 */
	deselectIncGrp: function(grpId){
		var _this = this;

		var formNode = $("#" + _this.formId);
		//remove the corresponding input
		$("#"+_this.formId+" input[value='"+grpId+"']").each(function(){
			this.parentNode.removeChild(this);
		});
		
		//update the select dropdown
		var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
		includeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		includeGrpDropdown.Select("refresh");
		
		var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
		excludeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		excludeGrpDropdown.Select("refresh");

		$(".includeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "true");
	},
	
	/**
	 * Handle select a excluding group from exclude group select dropdown
	 * @param (Integer) grpId The ID of the member group to select 
	 */
	selectExcGrp: function(grpId){
		var _this = this;
		if (grpId != ''){
			//create the corresponding input
			var formNode = $("#" + _this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitExclusionToMemberGroupId' value='" + grpId + "'/>");
			//disable corresponding entry in select dropdown
			var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
			includeGrpDropdown.find("[value='"+grpId+"']").attr("disabled", true);
			includeGrpDropdown.Select("refresh");
			
			var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
			excludeGrpDropdown.val("");
			excludeGrpDropdown.find("[value='"+grpId+"']").attr("disabled", true);
			excludeGrpDropdown.Select("refresh");

			$(".excludeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "false");
		}
	},
	
	/**
	 * Handle click on a cross icon of a member group in Exclude member group section
	 * @param (Integer) grpId The ID of the member group to de-select
	 */
	deselectExcGrp: function(grpId){
		var _this = this;

		var formNode = $("#" + _this.formId);
		//remove the corresponding input
		formNode.children("input[value='"+grpId+"']").each(function(){
			this.parentNode.removeChild(this);
		});
		
		var includeGrpDropdown = $("#" + _this.includeGrpDropdownId);
		includeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		includeGrpDropdown.Select("refresh");
		
		var excludeGrpDropdown = $("#" + _this.excludeGrpDropdownId);
		excludeGrpDropdown.find("[value='" + grpId + "']").attr("disabled", false);
		excludeGrpDropdown.Select("refresh");
		
		$(".excludeMbrGrp .entryField[data-grpId='"+grpId+"']").attr("aria-hidden", "true");
	},
	
	/**
	 * Handle cancel call back when click on 'cancel' button
	 */
	doCancel: function(){
		var scope = this;
			
		// set disable to "false" for all options
		var includeGrpDropdown = $("#" + scope.includeGrpDropdownId);
		var excludeGrpDropdown = $("#" + scope.excludeGrpDropdownId);
		includeGrpDropdown.find("option").each(function(){
			$(this).attr("disabled", false);
		});
		excludeGrpDropdown.find("option").each(function(){
			$(this).attr("disabled", false);
		});
		
		var formNode = $("#" + scope.formId);
		formNode.find("input[name='addAsExplicitInclusionToMemberGroupId']").each(function(i, incGrp) {
			incGrp.parentNode.removeChild(incGrp);
		});
		formNode.find("input[name='addAsExplicitExclusionToMemberGroupId']").each(function(i, excGrp) {
			excGrp.parentNode.removeChild(excGrp);
		});
		
		//set disabled to true for select groups
		$(scope.assignedIncGroups).each( $.proxy(function(index, incGrp){
			includeGrpDropdown.find("[value='" + incGrp + "']").attr("disabled", true);
			excludeGrpDropdown.find("[value='" + incGrp + "']").attr("disabled", true);
			var formNode = $("#" + this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitInclusionToMemberGroupId' value='" + incGrp + "'/>");
		}, scope));
		
		$(scope.assignedExcGroups).each( $.proxy(function(index, excGrp){
			includeGrpDropdown.find("[value='" + excGrp + "']").attr("disabled", true);
			excludeGrpDropdown.find("[value='" + excGrp + "']").attr("disabled", true);
			var formNode = $("#" + this.formId);
			formNode.append("<input type='hidden' name='addAsExplicitExclusionToMemberGroupId' value='" + excGrp + "'/>");
		}, scope));
		
		$(".includeMbrGrp .entryField").each( $.proxy(function(index, entry){
			var grpId = $(entry).attr("data-grpId");
			if (this.assignedIncGroups.indexOf(grpId) < 0 ){
				$(entry).attr("aria-hidden", "true");
			}
			else {
				$(entry).attr("aria-hidden", "false");
			}
		}, scope));
		$(".excludeMbrGrp .entryField").each( $.proxy(function(index, entry){
			var grpId = $(entry).attr("data-grpId");
			if (this.assignedExcGroups.indexOf(grpId) < 0 ){
				$(entry).attr("aria-hidden", "true");
			}
			else {
				$(entry).attr("aria-hidden", "false");
			}
		}, scope));
		
		includeGrpDropdown.Select("refresh");
		excludeGrpDropdown.Select("refresh");
	},
	
	/**
	 * Save changes when press "Save" button
	 */
	saveChange: function(){
		
		var params = {};
		params.removeFromMemberGroupId =  this.assignedExcGroups.concat(this.assignedIncGroups);
		wcService.getServiceById('RESTUserMbrGrpMgtMemberUpdate').setFormId(this.formId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		wcService.invoke('RESTUserMbrGrpMgtMemberUpdate', params);
	}
};
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------



/**
 * Declares a new refresh controller for update member group select.
 */
function declareUserMemberGroupManagement_controller() {
	var myWidgetObj = $("#UserMemberGroupManagement");
	
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["RESTUserMbrGrpMgtMemberUpdate","UserRoleManagementUpdate"], function() {
		myWidgetObj.refreshWidget("refresh");
	});
	
	myWidgetObj.refreshWidget({
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			widgetCommonJS.removeSectionOverlay();
			cursor_clear();
			UserMemberGroupManagementJS.initializeData();
			//Initialize toggle events after page refresh
			widgetCommonJS.initializeEditSectionToggleEvent();
		}
	});
};
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage user roles within.
 * This file is included in all pages with organization users role assignment actions.
 */
/* global KeyCodes */

/**
 * This service allow administrator to assign roles of member
 * @constructor
 */
wcService.declare({
	id:"UserRoleManagementAssign",
	actionId:"UserRoleManagementAssign",
	url:"AjaxRESTMemberRoleAssign",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		if (UserRoleManagementJS.paramsToUnAssign !== undefined && UserRoleManagementJS.paramsToUnAssign !== null){
			wcService.invoke('UserRoleManagementUnassign',UserRoleManagementJS.paramsToUnAssign);
		}
		else {
			MessageHelper.hideAndClearMessage();
			UserRoleManagementJS.updateAssignedRolesMap();
			UserRoleManagementJS.updateReadOnlySummary();
			widgetCommonJS.toggleEditSection(document.getElementById('WC_UserRoleManagement_pageSection'));
			cursor_clear();
			MessageHelper.displayStatusMessage(MessageHelper.messages["USERROLEMANAGEMENT_UPDATE_SUCCESS"]);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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

/**
 * This service allow administrator to un assign roles of member
 * @constructor
 */
wcService.declare({
	id:"UserRoleManagementUnassign",
	actionId:"UserRoleManagementUnassign",
	url:"AjaxRESTMemberRoleUnassign",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		if (UserRoleManagementJS.removingAdminRole){
			cursor_clear();
			MessageHelper.displayStatusMessage(MessageHelper.messages["USERROLEMANAGEMENT_UPDATE_SUCCESS"]);
			document.location.href = UserRoleManagementJS.myAccountURL;
		}
		else {
			UserRoleManagementJS.updateAssignedRolesMap();
			UserRoleManagementJS.updateReadOnlySummary();
			widgetCommonJS.toggleEditSection(document.getElementById('WC_UserRoleManagement_pageSection'));
			cursor_clear();
			UserRoleManagementJS.paramsToUnAssign = null;
			MessageHelper.displayStatusMessage(MessageHelper.messages["USERROLEMANAGEMENT_UPDATE_SUCCESS"]);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_UNASSIGN_FAIL"] + serviceResponse.errorMessage);
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				 MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_UNASSIGN_FAIL"] + serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
});

/**
 * This service allow administrator to update roles of member
 * @constructor
 */
wcService.declare({
	id:"ChainedUserRoleManagementAssign",
	actionId:"ChainedUserRoleManagementAssign",
	url:"AjaxRESTMemberRoleAssign",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		
		document.location.href = OrganizationUserInfoJS.getChainedServiceRediretUrl();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSER_CREATE_SUCCESS"]);
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_CHAINCREATE_FAIL"] + serviceResponse.errorMessage);
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_CHAINCREATE_FAIL"] + serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
});
  	
/**
 * This class defines the functions and variables that customers can use to create, update, and view their buyers list.
 * @class The OrganizationUsersListJS class defines the functions and variables that customers can use to manage their buyers list, 
 */
UserRoleManagementJS = {		
	
	/**
	 * the widget name
	 * @private
	 */
	widgetShortName: "UserRoleManagement",
	
	/**
	 * the name of Buyer Administrator Role
	 * @private
	 */
	buyerAdmin: "Buyer Administrator",
	
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
	
	/** 
	 * This variable stores the ID of member.
	 * @private
	 */
	memberId: "",
	
	/** 
	 * This variable stores the ID of the buyer admin.
	 * @private
	 */
	adminId: "",
	
	/**
	 * The id of selected Org.
	 * @private
	 */
	selectedOrg: "",
	
	/**
	 * The map contains Organization IDs and corresponding name, 
	 * at least one of the roles in the Organization is assigned to member.
	 * The key is Organization ID, value is name of a Organization.
	 */
	assignedOrgNameMap: new Object(),
	
	/**
	 * The map contains role IDs and corresponding name for roles that are
	 * currently assigned to the member.
	 * The key is Role ID, value is an array contains name of a Role and 
	 * frequence of the name appears in assigned roles. [name, freqence]
	 */
	assignedRoleNameMap: new Object(),
	
	/**
	 * The map contains Organization IDs and corresponding name, 
	 * at least one of the roles in the Organization is selected for the member.
	 * The map is initialized to assignedOrgNameMap
	 * on page load, and is updated correspondingly upon selection change
	 * The key is Organization ID, value is name of a Organization.
	 */
	selectedOrgNameMap: new Object(),
	
	/**
	 * The map contains Organization IDs and corresponding name, 
	 * for the Organizaiton currently displayed in the table.
	 * The map is initialized to assignedOrgNameMap
	 * on page load, and is updated correspondingly upon selection change
	 * The key is Organization ID, value is name of a Organization.
	 */
	currentOrgNameMap: new Object(),
	
	/**
	 * The map contains role IDs and corresponding name for roles that are
	 * currently selected for the member. The map is initialized to assignedRoleNameMap
	 * on page load, and is updated correspondingly upon selection change
	 * The key is Role ID, value is an array contains name of a Role and 
	 * frequence of the name appears in select roles. [name, freqence]
	 * the name will be removed from map is frequence equals 0
	 */
	selectedRoleNameMap: new Object(),
	
	/**
	 * The map contains role IDs and corresponding name for roles that are
	 * currently show in role selector column for a selected Organization
	 * The key is Role ID, value is name of a Role.
	 */
	selectedOrgRoleNameMap: new Object(),
	
	/**
	 * The map stores the all but hidden roles that the user has, roles in this map can be unassigned by current Admin. 
	 * The key of the map is Organization ID, the value is an array of role IDs
	 */
	assignedRolesMap: new Object(),
	
	/**
	 * The map stores the all roles that are selected by Admin for the user. 
	 * The key of the map is Organization ID, the value is an array of role IDs
	 */
	selectedRolesMap: new Object(),
	
	/**
	 * The display pattern of Org and Role for Selection summary column 
	 * The pattern is loaded from corresponding resource bundle define in widgetText
	 */
	orgDisplayPattern: "",
	
	/**
	 * The display pattern of Role for Selection summary column 
	 * The pattern is loaded from corresponding resource bundle define in widgetText
	 */
	roleDisplayPattern: "",
	
	/**
	 * The Checkbox column children html template
	 * The template is defined in UI jspf file
	 */
	roleCheckboxTemplate: "",
	
	/**
	 * The selection summary column children html template
	 * The template is defined in UI jspf file
	 */
	selectionSummaryTemplate: "",
	
	/**
	 * The read only summary view html template
	 * The template is defined in UI jspf file
	 */
	summaryViewTemplate: "",
	
	/**
	 * The prepared params for unAssign service command
	 */
	paramsToUnAssign: null,
	
	/**
	 * Indicates if we are removing admin role for the buyer him/herself, default value is false
	 */
	removingAdminRole: false,
	
	/**
	 * The URL to my account page.
	 */
	myAccountURL: "",
	
	/**
	 * Sets the common parameters for the current page. 
	 * For example, the language ID, store ID, and catalog ID.
	 *
	 * @param {Integer} langId The ID of the language that the store currently uses.
	 * @param {Integer} storeId The ID of the current store.
	 * @param {Integer} catalogId The ID of the catalog.
	 * @param {Integer} memberId The ID of the member.
	 * @param {Integer} authToken The authToken for current user to perform operation on server.
	 * @param (String) myAccountURL The url for MyAcount page
	 */
	setCommonParameters: function(langId,storeId,catalogId, memberId, adminId, authToken, myAccountURL){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;
		this.memberId = memberId;
		this.adminId = adminId;
		this.authToken = authToken;
		this.myAccountURL = myAccountURL;
		cursor_clear();
	},
	
	/**
	 * Initialize the URL of Role Assignment widget controller. 	 
	 *
	 * @param {object} roleSelectorUrl The roleSelector checkbox region controller's URL.
	 * @param {object} orgListUrl The  controller's URL for roleSelector region, which refreshes after org list change.
	 */
	initUserRoleManagementControllerUrl:function(roleSelectorUrl, orgListUrl){
		$('#UserRoleManagement_RoleSelector').attr("refreshurl", roleSelectorUrl);
		$('#UserRoleManagement_OrgList').attr("refreshurl", orgListUrl);
	},
	
	/**
	 * Handle press cancel button
	 */
	subscribeToToggleCancel: function(){
		var topicName = "sectionToggleCancelPressed";
		var scope = this;
		wcTopic.subscribe( topicName , $.proxy( function(data){
			if (data.target === 'WC_UserRoleManagement_pageSection'){
				this.selectedRolesMap = JSON.parse(JSON.stringify(this.assignedRolesMap));
				this.selectedRoleNameMap = JSON.parse(JSON.stringify(this.assignedRoleNameMap));
				this.selectedOrgNameMap = JSON.parse(JSON.stringify(this.assignedOrgNameMap));
				this.updateSelectionSummary();
				this.removingAdminRole = false;
				if (this.selectedOrg != ""){
					this.updateSelectorCheckbox(this.selectedOrg);
				}
			}
		}, this));
	},
	
	/**
	 * Upon success service response, copy the selectedRolesMap to assignedRolesMap
	 */
	updateAssignedRolesMap: function(){
		this.assignedRolesMap = JSON.parse(JSON.stringify(this.selectedRolesMap));
		this.assignedRoleNameMap = JSON.parse(JSON.stringify(this.selectedRoleNameMap));
		this.assignedOrgNameMap = JSON.parse(JSON.stringify(this.selectedOrgNameMap));
	},
	
	/**
	 * orgDisplayPattern, roleDisplayPattern
	 */
	loadDisplayPattern: function(orgPattern, rolePattern){
		this.roleDisplayPattern = rolePattern;
		this.orgDisplayPattern = orgPattern;
	},
	
	/**
	 * Read only Summary view template
	 */
	loadSummaryViewTemplate: function(orgPattern, rolePattern){
		this.summaryViewTemplate = $("#WC_UserRoleManagement_read_template").html().replace(/^\s+|\s+$/g, '');
	},
	
	/**
	 * Update currentOrgNameMap after Org list refresh
	 */
	updateCurrentOrgNameMap: function(){
		var incurrentOrgNameMap = JSON.parse($("#currentOrgNameMap").html());
		if (incurrentOrgNameMap !== undefined && incurrentOrgNameMap !== null){
			this.currentOrgNameMap = JSON.parse(JSON.stringify(incurrentOrgNameMap));
		}
	},
	
	/**
	 * assignedOrgNameMap, assignedRoleNameMap,selectedOrgNameMap, 
	 * selectedRoleNameMap, 
	 * currentOrgNameMap, 
	 * userHiddenRolesMap, assignedRolesMap, selectedRolesMap
	 * summaryViewTemplate, selectionSummary column template
	 */
	initializeDataForView: function(){
		var inassignedOrgNameMap = JSON.parse($("#assignedOrgNameMap").html());
		var inassignedRoleNameMap = JSON.parse($("#assignedRoleNameMap").html());
		var incurrentOrgNameMap = JSON.parse($("#currentOrgNameMap").html());
		if (inassignedOrgNameMap !== undefined && inassignedOrgNameMap !== null){
			this.assignedOrgNameMap = JSON.parse(JSON.stringify(inassignedOrgNameMap));
			this.selectedOrgNameMap = JSON.parse(JSON.stringify(inassignedOrgNameMap));
		}
		if (inassignedRoleNameMap !== undefined && inassignedRoleNameMap !== null){
			this.assignedRoleNameMap = JSON.parse(JSON.stringify(inassignedRoleNameMap));
			this.selectedRoleNameMap = JSON.parse(JSON.stringify(inassignedRoleNameMap));
		}
		if (incurrentOrgNameMap !== undefined && incurrentOrgNameMap !== null){
			this.currentOrgNameMap = JSON.parse(JSON.stringify(incurrentOrgNameMap));
		}
		var inSelectedOrgRoleNameMap = JSON.parse($("#selectedOrgRoleNameMap").html());
		if (inSelectedOrgRoleNameMap !== undefined && inSelectedOrgRoleNameMap !== null){
			this.selectedOrgRoleNameMap = JSON.parse(JSON.stringify(inSelectedOrgRoleNameMap));
		}
		this.selectionSummaryTemplate = $("#WC_UserRoleManagement_edit_additionalRoles_selectionSummary_panel_template").html().replace(/^\s+|\s+$/g, '');
		
		//for edit buyer
		this.assignedRolesMap = JSON.parse($("#userRoles").html());
		this.selectedRolesMap = JSON.parse($("#userRoles").html());
		
		var templateDom = $("#WC_UserRoleManagement_read_template");
		if (templateDom[0] !== undefined && templateDom[0] !== null){
			this.summaryViewTemplate = templateDom.html().replace(/^\s+|\s+$/g, '');
		}
	},
	
	/**
	 * Set role Name map in Selected Org after selecting a Org.
	 */
	setSelectedOrgRoleNameMap: function(){
		
		var inSelectedOrgRoleNameMap = JSON.parse($("#selectedOrgRoleNameMap").html());
		if (inSelectedOrgRoleNameMap !== undefined && inSelectedOrgRoleNameMap !== null){
			this.selectedOrgRoleNameMap = JSON.parse(JSON.stringify(inSelectedOrgRoleNameMap));
		}
	},
	
	/**
	 * Helper function to set userRoles and userHiddenRoles map
	 */
	setUserRolesMap:function(inArray, targetMap){
		if (inArray !== undefined && inArray !== null){
			for (var i=0; i < inArray.length; i++ ){
				var key = inArray[i][1]; //org id
				var value = inArray[i][0]; //role id
				if(Object.prototype.hasOwnProperty.call(targetMap, key)){
					if ( targetMap[key].indexOf(value)=== -1){
						targetMap[key].push(value);
					}
				}
				else{
					targetMap[key] = [value];
				}
			}
		}
	},
	
	/**
	 * Handle click on Role selector checkbox.
	 */
	toggleRoleCheckbox: function(role){
		var org = this.selectedOrg;
		this.updateSelectedRole(org, role);
		this.updateSelectorCheckbox();
		this.updateSelectionSummary();
	},
	
	/**
	 * Update selected roles and corresponding role name map
	 */
	updateSelectedRole: function(org, role){
		if (Object.prototype.hasOwnProperty.call(this.selectedRolesMap,org)){
			// has role in this org
			var index = this.selectedRolesMap[org].indexOf(role);
			if (index > -1){//exists , so remove it
				this.selectedRolesMap[org].splice(index, 1);
				if (this.selectedRolesMap[org].length == 0){//remove empty org
					delete this.selectedRolesMap[org];
					delete this.selectedOrgNameMap[org];
				}
				if (this.selectedRoleNameMap[role][1] == 1){
					delete this.selectedRoleNameMap[role];
				}
				else {
					this.selectedRoleNameMap[role][1] = this.selectedRoleNameMap[role][1] - 1;
				}
			}
			else {//does have the role, add to selected map
				this.selectedRolesMap[org].push(role);
				
				if (!Object.prototype.hasOwnProperty.call(this.selectedRoleNameMap,role)){
					this.selectedRoleNameMap[role] = [this.selectedOrgRoleNameMap[role].displayName, 1];
				}
				else{
					this.selectedRoleNameMap[role][1] = this.selectedRoleNameMap[role][1] + 1;
				}
			}
		}
		else{
			// no role was assigned from this org, create a new array for this org.
			this.selectedRolesMap[org] = [role];
			this.selectedOrgNameMap[org] = this.currentOrgNameMap[org];
			if (!Object.prototype.hasOwnProperty.call(this.selectedRoleNameMap,role)){
				this.selectedRoleNameMap[role] = [this.selectedOrgRoleNameMap[role].displayName, 1];
			}
			else{
				this.selectedRoleNameMap[role][1] = this.selectedRoleNameMap[role][1] + 1;
			}
		}
		
	}, 
	
	/**
	 * Select an Organization
	 */
	selectOrg: function(orgId){
		if (this.selectedOrg == orgId) {
			return;
		}

		$('#WC_UserRoleManagement_edit_additionalRoles_organizations div[data-orgid]').each(function(index, node){
			if (node.getAttribute('data-orgid') == orgId ){
				$(node).addClass("highlight");
				Utils.scrollIntoView(node);
			}
			else {
				$(node).removeClass("highlight");
			}
		});
		//normal select case
		if (Object.prototype.hasOwnProperty.call(this.currentOrgNameMap,orgId)){
			this.selectedOrg = orgId;
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcRenderContext.updateRenderContext("UserRoleManagement_RoleSelector_Context", {"orgId": orgId});
		}
		//select from summary column where the Org is not in current page, switch to search;
		else{
			this.selectedOrg = "";
			var orgNameSearch = this.selectedOrgNameMap[orgId];
			var searchInputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
			var searchInput = document.getElementById(searchInputFieldId);
			searchInput.value = orgNameSearch;
			this.showClearFilter();
			this.updateOrgListContext(orgNameSearch, orgId, "5");// "5" is exact match search type.
		}
	},
	
	/**
	 * Update view of selector check box area, check or uncheck, highlight or not etc.
	 */
	updateSelectorCheckbox: function(){
		var panelParent = $("#WC_UserRoleManagement_edit_additionalRoles_roleSelector_panel");
		panelParent.removeClass("highlight");
		var foundCheckbox = false;
		panelParent.find(".checkBoxer").each($.proxy( function(index, aCheckbox){
			var role = aCheckbox.getAttribute("data-userRoleId");
			var org = this.selectedOrg;
			foundCheckbox = true;
			if (Object.prototype.hasOwnProperty.call(this.selectedRolesMap,org) && this.selectedRolesMap[org].indexOf(role)!== -1){
				aCheckbox.setAttribute("aria-checked", "true");
			}
			else{
				aCheckbox.setAttribute("aria-checked", "false");
			}
		}, this));
		if(foundCheckbox){
			panelParent.addClass("highlight");
		}
	},
	
	/**
	 * Update view of selection summary column.
	 */
	updateSelectionSummary: function(){
		var panelParent = $("#WC_UserRoleManagement_edit_additionalRoles_selectionSummary_panel");
		panelParent.empty();
		var selectedSummary = null;
		for ( var key in this.selectedRolesMap){
			//key is Org Id
			var displayString = "";
			var orgName = this.selectedOrgNameMap[key];
			var roleName = "";
			var roleArray = this.selectedRolesMap[key];
			$(roleArray).each( $.proxy( function(index, role){
				var rn = this.selectedRoleNameMap[role][0];
				if (roleName.length === 0){
					roleName = rn;
				}
				else {
					roleName = Utils.substituteStringWithMap(this.roleDisplayPattern, {0: roleName, 1: rn});
				}
			}, this));
			if (roleName.length > 0){
				displayString = Utils.substituteStringWithMap(this.orgDisplayPattern, {0: this.selectedOrgNameMap[key], 1: roleName});
			}
			if (displayString.length > 0){
				var aSummary = $(Utils.substituteStringWithMap(this.selectionSummaryTemplate, {0: displayString}));
				if (key == this.selectedOrg){
					aSummary.addClass("highlight");
					selectedSummary = aSummary;
				}
				aSummary.find("a").each($.proxy( function(index, a){
					var k = key; //orgId, variable in forEach scope only
					if ($(a).hasClass("icon")){
						if (k == this.selectedOrg){
							$(a).removeClass("nodisplay");
							$(a).on("click", $.proxy( function(e){
								$(this.selectedRolesMap[k]).each( $.proxy( function(index, r){
									if (this.selectedRoleNameMap[r][1] == 1){
										delete this.selectedRoleNameMap[r];
									}
									else {
										this.selectedRoleNameMap[r][1] = this.selectedRoleNameMap[r][1] -1;
									}
								}, this));
								delete this.selectedRolesMap[k];
								delete this.selectedOrgNameMap[k];
								this.updateSelectorCheckbox();
								this.updateSelectionSummary();
								e.preventDefault();
								e.stopPropagation();
							}, this));
						}
					}
					else if ($(a).hasClass("roleName")){
						$(a).on("click", $.proxy( function(e){
							this.selectOrg(k);
							e.preventDefault();
							e.stopPropagation();
						}, this));
					}
				}, this));
				panelParent.append(aSummary);
			}
		}
		if (selectedSummary != null ){
			Utils.scrollIntoView(selectedSummary);
		}
	},
	
	/**
	 * Update view of Read only summary according to assigned role map.
	 */
	updateReadOnlySummary: function(){
		
		var sectionParent = $("#WC_UserRoleManagement_read");
		if (sectionParent !== undefined && sectionParent !== null){

			sectionParent.empty();
			
			for ( var key in this.assignedRolesMap){
				//key is Org Id
				var displayString = "";
				var orgName = this.assignedOrgNameMap[key];
				var roleArray = this.assignedRolesMap[key];
				$(roleArray).each( $.proxy( function(i, role){
					var invisibleString = "<span style='visibility: hidden'>&nbsp;</span>";
					var roleName = this.assignedRoleNameMap[role][0];
					
					if ( i == 0){
						var nodeChild = $(Utils.substituteStringWithMap(this.summaryViewTemplate, {0: orgName, 1: roleName}));
					}
					else {
						var nodeChild = $(Utils.substituteStringWithMap(this.summaryViewTemplate, {0: invisibleString, 1:roleName}));
					}

					sectionParent.append(nodeChild);
					
				}, this));
			}
		}
	},
	
	updateView: function(){
		var searchInputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
		this.updateReadOnlySummary();
		if(this.currentOrgNameMap.first !== undefined && this.currentOrgNameMap.first !== null ){
			this.selectedOrg = this.currentOrgNameMap.first;
		}
		$("#" + searchInputFieldId).on("keydown", $.proxy( function(e){
			var charOrCode = e.charCode || e.keyCode;
			if (charOrCode == KeyCodes.ENTER){
				this.doSearch();
			}
		}, this));
		this.updateOrganizationPanel();
		this.updateSelectionSummary();
		this.updateSelectorCheckbox();
		
		$('#WC_UserRoleManagement').on("keydown", ".roleSelector .checkField .checkBoxer", $.proxy( function(e){
			var charOrCode = e.charCode || e.keyCode;
			if (charOrCode == KeyCodes.SPACE || charOrCode == KeyCodes.ENTER){
				
				var checkbox = $( $(e.target).parents(".checkField")[0] ).find(".checkBoxer")[0];
				var role = checkbox.getAttribute("data-userRoleId");
				var ariaChecked = checkbox.getAttribute("aria-checked");
				if (this.adminId == this.memberId && ariaChecked == "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
					wcTopic.subscribeOnce( "adminRoleRemoveConfirmed" , $.proxy( function(data){
						if (data.action == "YES"){
							this.toggleRoleCheckbox(role);
							this.removingAdminRole = true;
						}
					}, this), this);	
					MessageHelper.showConfirmationDialog("adminRoleRemoveConfirmed",
							Utils.substituteStringWithMap(MessageHelper.messages['USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE'], {0: this.selectedOrgRoleNameMap[role].displayName}));
				}else {
					this.toggleRoleCheckbox(role);
					if (this.adminId == this.memberId &&  ariaChecked != "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
						this.removingAdminRole = false;
					}
				}
				e.preventDefault();
				e.stopPropagation();
			}
		}, this));
		$('#WC_UserRoleManagement').on("click", ".roleSelector .checkField .checkBoxer", $.proxy( function(e){
			var checkbox = $( $(e.target).parents(".checkField")[0] ).find(".checkBoxer")[0];
			var role = checkbox.getAttribute("data-userRoleId");
			var ariaChecked = checkbox.getAttribute("aria-checked");
			if (this.adminId == this.memberId && ariaChecked == "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
				wcTopic.subscribeOnce( "adminRoleRemoveConfirmed" , $.proxy( function(data){
					if (data.action == "YES"){
						this.toggleRoleCheckbox(role);
						this.removingAdminRole = true;
					}
				}, this), this);
				MessageHelper.showConfirmationDialog("adminRoleRemoveConfirmed",
						Utils.substituteStringWithMap(MessageHelper.messages['USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE'], {0: this.selectedOrgRoleNameMap[role].displayName}));
			}else {
				this.toggleRoleCheckbox(role);
				if (this.adminId == this.memberId && ariaChecked != "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
					this.removingAdminRole = false;
				}
			}
			e.preventDefault();
			e.stopPropagation();
		}, this));
	},
	
	/**
	 * handle Seach button press
	 */
	doSearch: function(){
		var inputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
		var input = document.getElementById(inputFieldId);
		var orgNameSearch = input.value;
		if (orgNameSearch.replace(/^\s+|\s+$/g, '') != ""){
			this.selectedOrg = "";
			this.showClearFilter();
			this.updateOrgListContext(orgNameSearch, "");
		}
	},
	
	/**
	 * Update context to show page according specific number.
	 * 
	 * @param data The data for updating context.
	 */
	showPage:function(data){
		var pageNumber = data['pageNumber'];
		var pageSize = data['pageSize'];
			pageNumber = parseInt(pageNumber);
			pageSize = parseInt(pageSize);
		var beginIndex = pageSize * ( pageNumber - 1 );

		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcRenderContext.updateRenderContext("UserRoleManagement_OrgList_Context", {"selectOrgId":"", "beginIndex" : beginIndex});
	},
	
	/**
	 * clear the search when press clear filter button
	 */
	clearSearch: function(){
		var inputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
		var input = document.getElementById(inputFieldId);
		input.value='';
		this.selectedOrg = "";
		this.hideClearFilter();
		this.updateOrgListContext('', '');
	},
	
	updateOrgListContext: function(orgNameSearch, selectOrgIdTokeep, searchType){
		if (searchType === undefined || searchType === null){
			searchType = "4"; //ignore case, containing
		}
		var beginIndex = "0";
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcRenderContext.updateRenderContext("UserRoleManagement_OrgList_Context", {"orgNameSearch": orgNameSearch, "selectOrgId":selectOrgIdTokeep, "searchType": searchType, "beginIndex" : beginIndex});
	},
	
	/**
	 * Update to show clear filter button
	 */
	showClearFilter: function(){
		var filterButtonId = 'WC_UserRoleManagement_edit_clearFilter';
		var filterButton = $("#" + filterButtonId);
		filterButton.attr("aria-hidden", "false");
	},
	
	/**
	 * Update to hide clear filter button
	 */
	hideClearFilter: function(){
		var filterButtonId = 'WC_UserRoleManagement_edit_clearFilter';
		var filterButton = $("#" + filterButtonId);
		filterButton.attr("aria-hidden", "true");			
	},
	
	/**
	 * Update the Organizations panel after refresh, pre-select Organization
	 */
	updateOrganizationPanel: function() {
		$('#WC_UserRoleManagement_edit_additionalRoles_organizations div[data-orgid]').each($.proxy( function(index, node){
			if (node.getAttribute('data-orgid') == this.selectedOrg ){
				$(node).addClass("highlight");
				Utils.scrollIntoView(node);
			}
			else {
				$(node).removeClass("highlight");
			}
		}, this));
	},
	
	/**
	 * Save the assigned and unassigned roles to server
	 */
	saveChange: function(){
		
		var params = {};
		
		this.prepareSelectedRoleParam(params);
		
		if (params['paramsToUnAssign'] !== undefined && params['paramsToUnAssign'] !== null) {
			this.paramsToUnAssign = JSON.parse(JSON.stringify(params['paramsToUnAssign']));
		}
		
		if (params['paramsToAssign'] !== undefined && params['paramsToAssign'] !== null) {
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			wcService.invoke('UserRoleManagementAssign',params['paramsToAssign']);
		}
		else if (params['paramsToUnAssign'] !== undefined && params['paramsToUnAssign'] !== null) {
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			wcService.invoke('UserRoleManagementUnassign',params['paramsToUnAssign']);
		} else {
			return;
		}
		
	},

	/**
	 * The function is called by successHandler of service chainedAjaxUserRegistrationAdminAdd
	 * to assign additional roles to the member just created.
	 * @param memberId the id of the member the role to assign
	 */
	chainedAssignRole: function(memberId){
		this.memberId = memberId;
		var params = {};
		this.prepareSelectedRoleParam(params);
		// the caller (userInfo widget service successHandler) will check if any role is selected for 
		// the member, so it is guaranteed that the params['paramsToAssign'] is not null or undefined.
		wcService.invoke('ChainedUserRoleManagementAssign',params['paramsToAssign']);
	},
	
	/**
	 * Function to test if the selectedRolesMap is empty.
	 * @return (Boolean) true if this selectedRolesMap is empty, false otherwise 
	 */
	isEmptySelectedRoles: function() {
		for (var k in this.selectedRolesMap){
			return false;
		}
		return true;
	},
	
	/**
	 * Helper function for saveChange
	 */
	prepareSelectedRoleParam: function(params){
		var paramsToAssign = {};
		var paramsToUnAssign = {};
		var n1 = 0;
		var n2 = 0;
		for ( var key in this.selectedRolesMap){
			var roles = this.selectedRolesMap[key];
			for ( var i = 0; i < roles.length; i++){
				if (undefined == this.assignedRolesMap[key] || null == this.assignedRolesMap[key] 
					|| this.assignedRolesMap[key].indexOf(roles[i]) === -1 ){
					n1 = n1 + 1;
					paramsToAssign['orgEntityId' + n1] = key;
					paramsToAssign['roleId' + n1] = roles[i];
				}
			}
		}
		
		for ( var key in this.assignedRolesMap){
			var roles = this.assignedRolesMap[key];
			for ( var i = 0; i < roles.length; i++){
				if (undefined === this.selectedRolesMap[key] || null === this.selectedRolesMap[key] 
					|| this.selectedRolesMap[key].indexOf(roles[i]) === -1 ){
					n2 = n2 + 1;
					paramsToUnAssign['orgEntityId' + n2] = key;
					paramsToUnAssign['roleId' + n2] = roles[i];
				}
			}
		}
		 
		if (n1 > 0 ){
			paramsToAssign.URL = "StoreView";//old command still check the presence of the 'URL' parameter
			paramsToAssign.storeId = this.storeId;
			paramsToAssign.langId = this.langId;
			paramsToAssign.memberId = this.memberId;
			paramsToAssign.authToken = this.authToken;
			params.paramsToAssign = paramsToAssign;
		}
		if (n2 > 0){
			paramsToUnAssign.URL = "StoreView";
			paramsToUnAssign.storeId = this.storeId;
			paramsToUnAssign.langId = this.langId;
			paramsToUnAssign.memberId = this.memberId;
			paramsToUnAssign.authToken = this.authToken;
			params.paramsToUnAssign = paramsToUnAssign;
		}
	}
	
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * Declares a new render context for role assignment role selector check box area.
 */
wcRenderContext.declare("UserRoleManagement_RoleSelector_Context",["UserRoleManagement_RoleSelector"],{"orgId":""});
/**
 * searchType: 
 * 		4 containing, ignore case
 * 		5 match case, exact match
 * 	
 */
wcRenderContext.declare("UserRoleManagement_OrgList_Context",["UserRoleManagement_OrgList"],{"beginIndex":"0", "orgNameSearch":"", "selectOrgId":"", "searchType":"4"});


/**
 * Declares a new refresh controller for update role selector check box.
 */
function declareUserRoleManagement_RoleSelector_controller() {
	var myWidgetObj = $("#UserRoleManagement_RoleSelector");

	var myRCProperties = wcRenderContext.getRenderContextProperties("UserRoleManagement_RoleSelector_Context");
	
	myWidgetObj.refreshWidget({
		/** 
		 * Refreshes the list table display if an item is updated.
		 * This function is called when a render context event is detected. 
		 */    	   
		renderContextChangedHandler: function() {					
			myWidgetObj.refreshWidget("refresh", myRCProperties);
	    },
		
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			UserRoleManagementJS.setSelectedOrgRoleNameMap();
			UserRoleManagementJS.updateSelectorCheckbox();
			UserRoleManagementJS.updateSelectionSummary();
			cursor_clear();			 
		}
	});
};

/**
 * Declares a new refresh controller for update organization list in .
 */
function declareUserRoleManagement_OrgList_controller() {
	var myWidgetObj = $("#UserRoleManagement_OrgList");
	
	var myRCProperties = wcRenderContext.getRenderContextProperties("UserRoleManagement_OrgList_Context");
	
	myWidgetObj.refreshWidget({
		/** 
		 * Refreshes the list table display if an item is updated.
		 * This function is called when a render context event is detected. 
		 */    	   
		renderContextChangedHandler: function() {
			myWidgetObj.refreshWidget("refresh", myRCProperties);
	    },
		
		/** 
		 * Clears the progress bar
		 * 
		 * @param {object} widget The registered refresh area
		 */
		postRefreshHandler: function(widget) {
	
			UserRoleManagementJS.updateCurrentOrgNameMap();
			UserRoleManagementJS.setSelectedOrgRoleNameMap();
			
			if (myRCProperties.selectOrgId != ''){
				//select the org preselected by user in selection summary column
				UserRoleManagementJS.selectedOrg = myRCProperties.selectOrgId;
			}else if (UserRoleManagementJS.currentOrgNameMap.first !== undefined && UserRoleManagementJS.currentOrgNameMap.first !== null){
				//select the first org in the list shown
				UserRoleManagementJS.selectedOrg = UserRoleManagementJS.currentOrgNameMap.first;
			}else {
				UserRoleManagementJS.selectedOrg = "";
			}
			UserRoleManagementJS.updateSelectorCheckbox();
			UserRoleManagementJS.updateSelectionSummary();
			UserRoleManagementJS.updateOrganizationPanel();
			cursor_clear();
		}
	});
};
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


/** 
 * @fileOverview This file contains all the global variables and JavaScript functions needed for wish list page in My Account section.
 * This JavaScript file defines all the functions used  by the AccountWishDisplay.jsp file.
 * @version 1.0
 */

/* Declare the namespace if it does not already exist. */
if (WishListDetailJS == null || typeof(WishListDetailJS) != "object") {
	/**
	 * @class This WishListDetailJS class defines all the variables and functions for the wish list page of My account section.
	 * The wish list page displays all the wish list item of an user and provides functions like remove from the wish list, add to cart, etc.
	 *
	 */
	var WishListDetailJS = {	
		/* Global variables used in the CompareProductDisplay page. */
			
		/** The contextChanged is a boolean flag indicating whether the context was changed and if there is a need to refresh the wish list result. */
		contextChanged:false, 

		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = parseInt(data['pageNumber']) - 1,
				pageSize = parseInt(data['pageSize']),
				beginIndex = pageSize * pageNumber;

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			cursor_wait();

			if($("#WishlistDisplay_Widget").length){
				wcRenderContext.updateRenderContext("WishlistDisplay_Context", {startIndex: beginIndex, currentPage: pageNumber});
			}

			if($("#SharedWishlistDisplay_Widget").length) {	
				wcRenderContext.updateRenderContext("SharedWishlistDisplay_Context", {startIndex: beginIndex, currentPage: pageNumber});
			}
			MessageHelper.hideAndClearMessage();
		},

		/**
		 * Updates the ContentURL and does not cause an Ajax refresh. 
		 * 
		 * @param {string} contentURL  the value of the controller URL.
		 */
		updateContentURL: function(contentURL) {
			if($("#WishlistDisplay_Widget").length){
				$("#WishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);
			}

			if($("#SharedWishlistDisplay_Widget").length) {
				$("#SharedWishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);
			}
		},

		/**
		* Updates the ContentURL and causes an Ajax refresh. 
		* 
		* @param {string} contentURL  the value of the controller URL.
		*/
		loadContentURL:function(contentURL){
			/* Handles multiple clicks */
			if(!submitRequest()){
				return;
			}   	
			cursor_wait();
			if($("#WishlistDisplay_Widget").length){
				$("#WishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);
				wcRenderContext.updateRenderContext("WishlistDisplay_Context");
			}

			if($("#SharedWishlistDisplay_Widget").length) {
				$("#SharedWishlistDisplay_Widget").refreshWidget("updateUrl", contentURL);		
				wcRenderContext.updateRenderContext("SharedWishlistDisplay_Context");
			}
		}
	};
}
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

/** 
 * @fileOverview This file contains all the global variables and JavaScript functions needed for wish list email widget used in My Account section.
 * This JavaScript file defines all the functions used by the WishListEmail.jsp file.
 * @version 1.0
 */

/* Declare the namespace if it does not already exist. */
if (WishListEmailJS == null || typeof(WishListEmailJS) != "object") {
	/**
	 * @class This WishListEmailJS class defines all the variables and functions for the wish list email widget used in the My account section.
	 *
	 */
	var WishListEmailJS = {
		/**
		* This function is used to clear some of the fields in the email form in wish list page after InterestItemListMessage is invoked.
		* @param {string} formId  the id of the email form in WishList page.
		*/	
		clearWishListEmailForm:function(formId){
			var form = document.getElementById(formId);
			form.recipient.value = "";
			form.sender_name.value = "";
			form.sender_email.value = "";
			form.wishlist_message.value="";
		}
	}
}




//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the Approval List pages to control the refresh areas.
 * @version 1.2
 */
var declareOrderApprovalListRefreshArea = function() {
    var myWidgetObj = $("#OrderApprovalTable_Widget");

    wcRenderContext.declare("OrderApprovalTable_Context", ["OrderApprovalTable_Widget"], {"beginIndex":"0", "orderId": "", "firstName": "", "lastName":"","startDate":"","endDate":"","approvalStatus":"0"});

    wcTopic.subscribe(["AjaxApproveOrderRequest","AjaxRejectOrderRequest"], function() {
        myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("OrderApprovalTable_Context"));
    });

    myWidgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("OrderApprovalTable_Context"));
        }, 
        postRefreshHandler: function() {
            OrderApprovalListJS.restoreToolbarStatus();
            cursor_clear();
        }
    });
}        
 
/**
 * Declares a new refresh controller for buyer approval.
 */
var declareBuyerApprovalTableRefreshArea = function() {
	var myWidgetObj = $("#BuyerApprovalTable_Widget");
    
    /**
     * Declares a new render context for buyer approval list table
     */
	wcRenderContext.declare("BuyerApprovalTable_Context", ["BuyerApprovalTable_Widget"], {
        "beginIndex": "0",
        "approvalId": "",
        "firstName": "",
        "lastName": "",
        "startDate": "",
        "endDate": "",
        "approvalStatus": "0"
	});
  	
	wcTopic.subscribe(["AjaxApproveBuyerRequest","AjaxRejectBuyerRequest"], function() {
		myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("BuyerApprovalTable_Context"));
	});
    
	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function () {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("BuyerApprovalTable_Context"));
        },

        postRefreshHandler: function() {
        	BuyerApprovalListJS.restoreToolbarStatus();
            cursor_clear();
        }
	});
}

/**
 * Declares a new refresh controller for buyer approval comment.
 */
var declareApprovalCommentController = function() {    
    var myWidgetObj = $("#ApprovalComment_Widget");
    
    /**
     * Declares a new render context for approval comments widget
     */
    wcRenderContext.declare("ApprovalComment_Context", ["ApprovalComment_Widget"], {
       "approvalStatus": "all"
    });
    
    /** 
	* Refreshes the approval comment widget if a request is approved/rejected.
	* This function is called when a modelChanged event is detected. 
	* 
	* @param {string} message The model changed event message
	* @param {object} widget The registered refresh area
	*/    
    wcTopic.subscribe(["AjaxApproveRequest","AjaxRejectRequest"], function() {
		myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("ApprovalComment_Context"));
	});
    
    myWidgetObj.refreshWidget({
        /** 
        * This function is called when a render context changed event is detected. 
        * 
        * @param {string} message The render context changed event message
        * @param {object} widget The registered refresh area
        */
        renderContextChangedHandler: function () {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("ApprovalComment_Context"));
        }
    });
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the Approval List Pages to handle the services for 
 * approving/rejecting a buyer/order approval record.
 * @version 1.10
 */

/**
 * This service allows approvers and admins to approve a order request
 * @constructor
 */
wcService.declare({
	id:"AjaxApproveOrderRequest",
	actionId:"AjaxApproveOrderRequest",
	url:"AjaxRESTHandleApproval",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["APPROVAL_APPROVE_SUCCESS"]);
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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
}),

/**
 * This service allows approvers and admins to approve a order request
 * @constructor
 */
wcService.declare({
	id:"AjaxRejectOrderRequest",
	actionId:"AjaxRejectOrderRequest",
	url:"AjaxRESTHandleApproval",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["APPROVAL_REJECT_SUCCESS"]);
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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
}),

/**
 * This service allows approvers and admins to approve a buyer request
 * @constructor
 */
wcService.declare({
	id:"AjaxApproveBuyerRequest",
	actionId:"AjaxApproveBuyerRequest",
	url:"AjaxRESTHandleApproval",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["APPROVAL_APPROVE_SUCCESS"]);
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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
}),

/**
 * This service allows approvers and admins to approve a buyer request
 * @constructor
 */
wcService.declare({
	id:"AjaxRejectBuyerRequest",
	actionId:"AjaxRejectBuyerRequest",
	url:"AjaxRESTHandleApproval",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["APPROVAL_REJECT_SUCCESS"]);
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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
}),

/**
 * This service allows approvers and admins to approve a request
 * @constructor
 */
wcService.declare({
	id:"AjaxApproveRequest",
	actionId:"AjaxApproveRequest",
	url:"AjaxRESTHandleApproval",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["APPROVAL_APPROVE_SUCCESS"]);
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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
}),

/**
 * This service allows approvers and admins to approve a request
 * @constructor
 */
wcService.declare({
	id:"AjaxRejectRequest",
	actionId:"AjaxRejectRequest",
	url:"AjaxRESTHandleApproval",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["APPROVAL_REJECT_SUCCESS"]);
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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
})

	

//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2017 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

productDisplayJS = {

    /** The language ID currently in use **/
    langId: "-1",

    /** The store ID currently in use **/
    storeId: "",

    /** The catalog ID currently in use **;/
    catalogId: "",

    /** Holds the current user type such as guest or registered user. Allowed values are 'G' for guest and 'R' for registered.**/
    userType: "",

    /** A boolean used in a variety of the add to cart methods to tell whether or not the base item was added to the cart. **/
    baseItemAddedToCart: false,

    /** An array of entitled items which is used in various methods throughout ShoppingActions.js **/
    entitledItems: [],

    /** a JSON object that holds attributes of an entitled item **/
    entitledItemJsonObject: null,

    /** A map of attribute name value pairs for the currently selected attribute values **/
    selectedAttributesList: {},

    /** A map of currently selected attribute values for a catalog entry **/
    selectedAttributeValues: {},

    /** A map of HTML element ids associated with an attribute name **/
    registeredAttributeIds: {},

    /** A variable used to form the url dynamically for the more info link in the Quickinfo popup */
    moreInfoUrl: "",

    /**
     * A boolean used to to determine is it from a Qick info popup or not. 
     **/
    isPopup: false,

    /**
     * A boolean used to to determine whether or not to display the price range when the catEntry is selected. 
     **/
    displayPriceRange: true,

    /**
     * This array holds the json object returned from the service, holding the price information of the catEntry.
     **/
    itemPriceJsonOject: [],

    /** 
     * stores all name and value of all swatches 
     * this is a 2 dimension array and each record i contains the following information:
     * allSwatchesArray[i][0] - attribute name of the swatch
     * allSwatchesArray[i][1] - attribute value of the swatch
     * allSwatchesArray[i][2] - image1 of swatch (image to use for enabled state)
     * allSwatchesArray[i][3] - image2 of swatch (image to use for disabled state)
     * allSwatchesArray[i][4] - onclick action of the swatch when enabled
     **/
    allSwatchesArrayList: {},

    /**
     * stores all name and id of all dropdowns 
     **/
    allDropdownsList: {},

    /**
     * Holds the ID of the image used for swatch
     **/
    skuImageId: "",

    /**
     * The prefix of the cookie key that is used to store item IDs. 
     */
    cookieKeyPrefix: "CompareItems_",

    /**
     * The delimiter used to separate item IDs in the cookie.
     */
    cookieDelimiter: ";",

    /**
     * The maximum number of items allowed in the compare zone. 
     */
    maxNumberProductsAllowedToCompare: 4,

    /**
     * The minimum number of items allowed in the compare zone. 
     */
    minNumberProductsAllowedToCompare: 2,

    /**
     * Id of the base catalog entry. 
     */
    baseCatalogEntryId: 0,

    /**
     * An map which holds the attributes of a set of products
     */
    selectedProducts: {},

    /**
     * An array to keep the quantity of the products in a list (bundle)
     */
    productList: {},

    /**
     * stores the currency symbol
     */
    currencySymbol: "",

    /**
     * stores the compare return page name
     */
    compareReturnName: "",
    /**
     * stores the search term
     */
    searchTerm: "",

    search01: "'",

    search02: '"',

    replaceStr01: /\\\'/g,

    replaceStr02: /\\\"/g,

    ampersandChar: /&/g,

    ampersandEntityName: "&amp;",

    singleSKUProductWithoutDefiningAttribute: false,

    replaceStr001: "&#039;",
    replaceStr002: "&#034;",

    setCommonParameters: function (langId, storeId, catalogId, userType, currencySymbol) {
        productDisplayJS.langId = langId;
        productDisplayJS.storeId = storeId;
        productDisplayJS.catalogId = catalogId;
        productDisplayJS.userType = userType;
        productDisplayJS.currencySymbol = currencySymbol;
    },

    setEntitledItems: function (entitledItemArray) {
        productDisplayJS.entitledItems = entitledItemArray;
    },

    getCatalogEntryId: function (entitledItemId) {
        var attributeArray = [];
        var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];
        for (attribute in selectedAttributes) {
            attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
        }
        // there are no selected attribute and no entitled item, this must be a single sku item without defining attribute
        if (selectedAttributes == null && this.entitledItems == null) {
            return entitledItemId.substring(entitledItemId.indexOf("_") + 1);
        }
        return productDisplayJS.resolveSKU(attributeArray);
    },

    /**
     * getCatalogEntryIdforProduct Returns the catalog entry ID for a catalog entry that has the same attribute values as a specified product's selected attributes as passed in via the selectedAttributes parameter.
     *
     * @param {String[]} selectedAttributes The array of selected attributes upon which to resolve the SKU.
     *
     * @return {String} catalog entry ID of the SKU.
     *
     **/
    getCatalogEntryIdforProduct: function (selectedAttributes) {
        var attributeArray = [];
        for (attribute in selectedAttributes) {
            attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
        }
        return productDisplayJS.resolveSKU(attributeArray);
    },

    /**
     * retrieves the entitledItemJsonObject
     */
    getEntitledItemJsonObject: function () {
        return productDisplayJS.entitledItemJsonObject;
    },

    /**
     * resolveSKU Resolves a SKU using an array of defining attributes.
     *
     * @param {String[]} attributeArray An array of defining attributes upon which to resolve a SKU.
     *
     * @return {String} catentry_id The catalog entry ID of the SKU.
     *
     **/
    resolveSKU: function (attributeArray) {
        console.debug("Resolving SKU >> " + attributeArray + ">>" + this.entitledItems);
        var catentry_id = "";
        var attributeArrayCount = attributeArray.length;

        // if there is only one item, no need to check the attributes to resolve the sku
        if (this.entitledItems.length == 1) {
            return this.entitledItems[0].catentry_id;
        }
        for (x in this.entitledItems) {
            var catentry_id = this.entitledItems[x].catentry_id;
            var Attributes = this.entitledItems[x].Attributes;
            var attributeCount = 0;
            for (index in Attributes) {
                attributeCount++;
            }

            // Handle special case where a catalog entry has one sku with no attributes
            if (attributeArrayCount == 0 && attributeCount == 0) {
                return catentry_id;
            }
            if (attributeCount != 0 && attributeArrayCount >= attributeCount) {
                var matchedAttributeCount = 0;

                for (attributeName in attributeArray) {
                    var attributeValue = attributeArray[attributeName];
                    if (attributeValue in Attributes) {
                        matchedAttributeCount++;
                    }
                }

                if (attributeCount == matchedAttributeCount) {
                    console.debug("CatEntryId:" + catentry_id + " for Attribute: " + attributeArray);
                    this.disableBuyButtonforUnbuyable(x);
                    return catentry_id;
                }
            }
        }
        return null;
    },

    /**
     * disables add2cart button in case where the buyable flag is set to false
     */
    disableBuyButtonforUnbuyable: function (entitledItemIndex) {
        var buyableFlag = this.entitledItems[entitledItemIndex].buyable;
        //disable the add to cart button
        var btn = document.getElementById("add2CartBtn");
        if (buyableFlag != null && btn != null) {
            if (buyableFlag == 'false') {
                btn.className += " add2CartButtonDisabled";
            } else {
                btn.className = btn.className.replace(" add2CartButtonDisabled", "");
            }
        }
    },

    /**
     * registerAttributeIds Register the ids of HTML attributes that are associated with the specified attribute.
     *
     * @param {String} attributeName The name of the attribute.
     * @param {String} entitledItemId The element id where the json object of the sku is stored
     * @param {Object} ids Map of named HTML element ids
     *
     **/
    registerAttributeIds: function (attributeName, entitledItemId, ids) {
        var attributeIds = productDisplayJS.registeredAttributeIds[entitledItemId];
        if (attributeIds == null) {
            attributeIds = {};
            productDisplayJS.registeredAttributeIds[entitledItemId] = attributeIds;
        }

        attributeIds[productDisplayJS.removeQuotes(attributeName)] = ids;
    },

    /**
     * getAttributeIds Get the map of ids of HTML attributes that are associated with the specified attribute.
     *
     * @param {String} attributeName The name of the attribute.
     * @param {String} entitledItemId The element id where the json object of the sku is stored
     *
     * @return {Object} ids Map of named HTML element ids
     *
     **/
    getAttributeIds: function (attributeName, entitledItemId) {
        var ids = null;
        var attributeIds = productDisplayJS.registeredAttributeIds[entitledItemId];
        if (attributeIds != null) {
            ids = attributeIds[productDisplayJS.removeQuotes(attributeName)];
        }
        return ids;
    },

    /**
     * setSelectedAttribute Sets the selected attribute value for a particular attribute not in reference to any catalog entry.
     *					   One place this function is used is on CachedProductOnlyDisplay.jsp where there is a drop down box of attributes.
     *					   When an attribute is selected from that drop down this method is called to update the selected value for that attribute.
     *
     * @param {String} selectedAttributeName The name of the attribute.
     * @param {String} selectedAttributeValue The value of the selected attribute.
     * @param {String} entitledItemId The element id where the json object of the sku is stored
     * @param {String} skuImageId This is optional. The element id of the product image - image element id is different in product page and category list view. Product page need not pass it because it is set separately
     * @param {String} imageField This is optional. The json field from which image should be picked. Pass value if a different size image need to be picked
     * @param {String} selectedAttributeDisplayValue This is optional. The attribute display value formatted with UOM
     *
     **/
    setSelectedAttribute: function (selectedAttributeName, selectedAttributeValue, entitledItemId, skuImageId, imageField, selectedAttributeDisplayValue) {
        var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];
        if (selectedAttributes == null) {
            selectedAttributes = {};
        }
        selectedAttributeValue = selectedAttributeValue.replace(productDisplayJS.replaceStr001, productDisplayJS.search01);
        selectedAttributeValue = selectedAttributeValue.replace(productDisplayJS.replaceStr002, productDisplayJS.search02);
        selectedAttributeValue = selectedAttributeValue.replace(productDisplayJS.replaceStr01, productDisplayJS.search01);
        selectedAttributeValue = selectedAttributeValue.replace(productDisplayJS.replaceStr02, productDisplayJS.search02);
        selectedAttributeValue = selectedAttributeValue.replace(productDisplayJS.ampersandChar, productDisplayJS.ampersandEntityName);
        selectedAttributes[selectedAttributeName] = selectedAttributeValue;
        productDisplayJS.moreInfoUrl = productDisplayJS.moreInfoUrl + '&' + selectedAttributeName + '=' + selectedAttributeValue;
        productDisplayJS.selectedAttributesList[entitledItemId] = selectedAttributes;
        if (skuImageId != undefined) {
            productDisplayJS.setSKUImageId(skuImageId);
        }
        var entitledItemJSON;
        if ($("#" + entitledItemId).length && !productDisplayJS.isPopup) {
            //the json object for entitled items are already in the HTML. 
            entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
        } else {
            //if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
            //in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
            entitledItemJSON = productDisplayJS.getEntitledItemJsonObject();
        }
        productDisplayJS.setEntitledItems(entitledItemJSON);
        var attributeIds = productDisplayJS.getAttributeIds(selectedAttributeName, entitledItemId);
        if (attributeIds != null) {
            var usedFilterValue = $("#" + attributeIds.usedFilterValueId);
            if (usedFilterValue != null) {
                if (selectedAttributeDisplayValue) {
                    $(usedFilterValue).html(selectedAttributeDisplayValue);
                } else {
                    $(usedFilterValue).html(selectedAttributeValue);
                }
            }
            if (selectedAttributeValue === "") {
                $("#" + attributeIds.usedFilterId).removeClass("visible");
                var hideCurrentUsedFilters = true;
                var dropdownList = this.allDropdownsList[entitledItemId];
                for (var i in dropdownList) {
                    if (selectedAttributes[dropdownList[i].name] !== "") {
                        hideCurrentUsedFilters = false;
                        break;
                    }
                }
                if (hideCurrentUsedFilters) {
                    $("#currentUsedFilters_" + entitledItemId).addClass("hidden");
                }
            } else {
                $("#" + attributeIds.usedFilterId).addClass("visible");
                $("#currentUsedFilters_" + entitledItemId).removeClass("hidden");
                var selectedAttributeNameId = selectedAttributeName.replace(productDisplayJS.search01, "\\\'").replace(productDisplayJS.search02, '\\\"');
                $("[id='attr_" + entitledItemId + '_' + selectedAttributeNameId + "']").addClass("hidden");
            }

            productDisplayJS.makeDropdownSelection(selectedAttributeName, selectedAttributeValue, entitledItemId);
        }
    },

    /**
     * resetSelectedAttribute Resets the the selected attribute value for the specified attribute.
     *
     * @param {String} attributeName The name of the attribute.
     * @param {String} entitledItemId The element id where the json object of the sku is stored
     * @param {String} productUrl The url of the parent product
     *
     **/
    resetSelectedAttribute: function (attributeName, entitledItemId) {
        var attributeName = attributeName.replace(productDisplayJS.search01, "\\\'").replace(productDisplayJS.search02, '\\\"');
        $("[id='attr_" + entitledItemId + '_' + attributeName + "']").removeClass("hidden");

        var attributeIds = productDisplayJS.getAttributeIds(attributeName, entitledItemId);
        if (attributeIds != null) {
            var selectWidget = $(attributeIds.selectAttributeValueId);
            if (selectWidget.length) {
                selectWidget.val("");
                selectWidget.Select("refresh");
            }
        }

        var dropdownList = this.allDropdownsList[entitledItemId];
        var remainingSelectedAttributes = {};

        for (var i = 0; i < dropdownList.length; i++) {
            if (dropdownList[i].name.replace(/\\'/g, "'") == attributeName.replace(/\\'/g, "'")) {
                $(dropdownList[i].node).removeClass("hidden");
                $(dropdownList[i].node).val('');
                $(dropdownList[i].node).Select("refresh");
                $(dropdownList[i].node).change();
            } else {
                for (var j = 0; j < dropdownList[i].options.length; j++) {
                    if (dropdownList[i].options[j].selected === true) {
                        remainingSelectedAttributes[dropdownList[i].name] = dropdownList[i].options[j].value;
                    }
                }
            }
        }

        var urlWithoutParams = document.location.href.split('?')[0];
        var params = "?";

        var productUrl = "";
        if ($("#ProductDisplayURL").length) {
            productUrl = $("#ProductDisplayURL").html();
        }

        var displaySKUContextData = false;
        if ($("#displaySKUContextData").length) {
            displaySKUContextData = eval('(' + $("#displaySKUContextData").html() + ')');
        }

        if (displaySKUContextData && urlWithoutParams !== productUrl) {
            for (attr in remainingSelectedAttributes) {
                if (remainingSelectedAttributes.hasOwnProperty(attr)) {
                    params += attr + '=' + remainingSelectedAttributes[attr] + '&';
                }
            }

            params = params.slice(0, -1);
            params = params.replace("\\\'", "'").replace('\\\"', '"');
            document.location.replace(productUrl + params);
        }
    },

    /**
     * setSelectedAttributeName Set the selected attribute name and make the drop-down associated with the attribute visible.
     *
     * @param {String} attributeName The name of the attribute.
     * @param {String} entitledItemId The element id where the json object of the sku is stored
     *
     **/
    setSelectedAttributeName: function (attributeName, entitledItemId) {
        var oldSelectedAttributeValuesId = productDisplayJS.selectedAttributeValues[entitledItemId];
        if (oldSelectedAttributeValuesId != null && oldSelectedAttributeValuesId !== "") {
            $("#" + oldSelectedAttributeValuesId).addClass("mobileHidden");
        }
        var selectedAttributeValuesId = null;
        var attributeIds = productDisplayJS.getAttributeIds(attributeName, entitledItemId);
        if (attributeIds != null) {
            selectedAttributeValuesId = attributeIds.attributeValuesId;
        }
        if (selectedAttributeValuesId != null && selectedAttributeValuesId !== "") {
            $("#" + selectedAttributeValuesId).removeClass("mobileHidden");
        }
        productDisplayJS.selectedAttributeValues[entitledItemId] = selectedAttributeValuesId;
    },

    /**
     * Add2ShopCartAjax This function is used to add a catalog entry to the shopping cart using an AJAX call. This will resolve the catentryId using entitledItemId and adds the item to the cart.
     *				This function will resolve the SKU based on the entitledItemId passed in and call {@link productDisplayJS.AddItem2ShopCartAjax}.
     * @param {String} entitledItemId A DIV containing a JSON object which holds information about a catalog entry. You can reference CachedProductOnlyDisplay.jsp to see how that div is constructed.
     * @param {int} quantity The quantity of the item to add to the cart.
     * @param {String} isPopup If the value is true, then this implies that the function was called from a quick info pop-up. 	
     * @param {Object} customParams - Any additional parameters that needs to be passed during service invocation.
     *
     **/
    Add2ShopCartAjax: function (entitledItemId, quantity, isPopup, customParams) {
        var dialog = $('#quick_cart_container').data("wc-WCDialog");
        if (dialog) {
            dialog.close();
        }
        if (browseOnly) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_ADD2CART_BROWSE_ONLY'));
            return;
        }
        var entitledItemJSON;

        if ($("#" + entitledItemId).length) {
            //the json object for entitled items are already in the HTML. 
            entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
        } else {
            //if $("#" + entitledItemId).length is 0, that means there's no <div> in the HTML that contains the JSON object. 
            //in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
            entitledItemJSON = this.getEntitledItemJsonObject();
        }

        productDisplayJS.setEntitledItems(entitledItemJSON);
        var catalogEntryId = productDisplayJS.getCatalogEntryId(entitledItemId);

        if (catalogEntryId != null) {
            var productId = entitledItemId.substring(entitledItemId.indexOf("_") + 1);
            productDisplayJS.AddItem2ShopCartAjax(catalogEntryId, quantity, customParams, productId);
            productDisplayJS.baseItemAddedToCart = true;

        } else if (isPopup == true) {
            $('#second_level_category_popup').css("zIndex", '1');
            MessageHelper.formErrorHandleClient('addToCartLinkAjax', Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
        } else {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
            productDisplayJS.baseItemAddedToCart = false;
        }
    },

    AddItem2ShopCartAjax: function (catEntryIdentifier, quantity, customParams, productId) {
        if (browseOnly) {
            MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERROR_ADD2CART_BROWSE_ONLY'));
            return;
        }
        var params = {
            storeId: this.storeId,
            catalogId: this.catalogId,
            langId: this.langId,
            orderId: "."
        };
        // Remove calculations for performance
        // params.calculationUsage = "-1,-2,-5,-6,-7";
        params.inventoryValidation = "true";
        params.calculateOrder = "0";
        var ajaxShopCartService = "AddOrderItem";

        shoppingActionsJS.productAddedList = {};
        if (Array.isArray(catEntryIdentifier) && Array.isArray(quantity)) {
            for (var i = 0; i < catEntryIdentifier.length; i++) {
                if (!isPositiveInteger(quantity[i])) {
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                    return;
                }
                params["catEntryId_" + (i + 1)] = catEntryIdentifier[i];
                params["quantity_" + (i + 1)] = quantity[i];
            }
        } else {
            if (!isPositiveInteger(quantity)) {
                MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
                return;
            }
            params.catEntryId = catEntryIdentifier;
            params.quantity = quantity;

            var selectedAttrList = {};
            for (attr in productDisplayJS.selectedAttributesList['entitledItem_' + productId]) {
                selectedAttrList[attr] = productDisplayJS.selectedAttributesList['entitledItem_' + productId][attr];
            }

            if (productId == undefined) {
                shoppingActionsJS.saveAddedProductInfo(quantity, catEntryIdentifier, catEntryIdentifier, selectedAttrList);
            } else {
                shoppingActionsJS.saveAddedProductInfo(quantity, productId, catEntryIdentifier, selectedAttrList);
            }
        }

        //Pass any other customParams set by other add on features
        if (customParams != null && customParams != 'undefined') {
            for (i in customParams) {
                params[i] = customParams[i];
            }
            if (customParams['catalogEntryType'] == 'dynamicKit') {
                ajaxShopCartService = "AddPreConfigurationToCart";
            }
        }

        var contractIdElements = document.getElementsByName('contractSelectForm_contractId');
        if (contractIdElements != null && contractIdElements != "undefined") {
            for (i = 0; i < contractIdElements.length; i++) {
                if (contractIdElements[i].checked) {
                    params.contractId = contractIdElements[i].value;
                    break;
                }
            }
        }

        //For Handling multiple clicks
        if (!submitRequest()) {
            return;
        }
		
		cursor_wait();
		var addToCartEventConsumed = false;

		if(typeof callCenterIntegrationJS != 'undefined' && callCenterIntegrationJS != undefined && callCenterIntegrationJS != null){
			var catEntry = productDisplayJS.itemPriceJsonOject[params.catEntryId].catalogEntry;
			var partNumber = catEntry.catalogEntryIdentifier.externalIdentifier.partNumber;
			var wccParams = {};
			wccParams["partNumber"] = partNumber;
			addToCartEventConsumed = callCenterIntegrationJS.consumeAddToCartEvent(params,wccParams);
		}

		if(!addToCartEventConsumed) {
			wcService.invoke(ajaxShopCartService, params);
		}
        productDisplayJS.baseItemAddedToCart = true;

        if (document.getElementById("headerShopCartLink") && document.getElementById("headerShopCartLink").style.display != "none") {
            $("#headerShopCart").focus();
        } else {
            $("#headerShopCart1").focus();
        }
    },

    /* SwatchCode start */

    /**
     * Sets the ID of the image to use for swatch.
     * @param {String} skuImageId The ID of the full image element.
     **/
    setSKUImageId: function (skuImageId) {
        productDisplayJS.skuImageId = skuImageId;
    },

    /**
     * getImageForSKU Returns the full image of the catalog entry with the selected attributes as specified in the {@link productDisplayJS.selectedAttributes} value.
     *					This method uses resolveImageForSKU to find the SKU image with the selected attributes values.
     *
     * @param {String} imageField, the field name from which the image should be picked
     * @return {String} path to the SKU image.
     * 
     *
     **/
    getImageForSKU: function (entitledItemId, imageField) {
        var attributeArray = [];
        var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];
        for (attribute in selectedAttributes) {
            attributeArray.push(attribute + "_|_" + selectedAttributes[attribute]);
        }
        return productDisplayJS.resolveImageForSKU(attributeArray, imageField);
    },

    /**
     * resolveImageForSKU Resolves image of a SKU using an array of defining attributes.
     *
     * @param {String[]} attributeArray An array of defining attributes upon which to resolve a SKU.
     * @param {String} imageField, the field name from which the image should be picked
     *
     * @return {String} imagePath The location of SKU image.
     *
     **/
    resolveImageForSKU: function (attributeArray, imageField) {
        console.debug("Resolving SKU >> " + attributeArray + ">>" + this.entitledItems);
        var imagePath = "";
        var attributeArrayCount = attributeArray.length;

        for (x in this.entitledItems) {
            if (null != imageField) {
                var imagePath = this.entitledItems[x][imageField];
            } else {
                var imagePath = this.entitledItems[x].ItemImage467;
            }

            var Attributes = this.entitledItems[x].Attributes;
            var attributeCount = 0;
            for (index in Attributes) {
                attributeCount++;
            }

            // Handle special case where a catalog entry has one sku with no attributes
            if (attributeArrayCount == 0 && attributeCount == 0) {
                return imagePath;
            }
            if (attributeCount != 0 && attributeArrayCount >= attributeCount) {
                var matchedAttributeCount = 0;

                for (attributeName in attributeArray) {
                    var attributeValue = attributeArray[attributeName];
                    if (attributeValue in Attributes) {
                        matchedAttributeCount++;
                    }
                }

                if (attributeCount == matchedAttributeCount) {
                    console.debug("ItemImage:" + imagePath + " for Attribute: " + attributeArray);
                    var imageArray = [];
                    imageArray.push(imagePath);
                    imageArray.push(this.entitledItems[x].ItemThumbnailImage);
                    if (this.entitledItems[x].ItemAngleThumbnail != null && this.entitledItems[x].ItemAngleThumbnail != undefined) {
                        imageArray.push(this.entitledItems[x].ItemAngleThumbnail);
                        imageArray.push(this.entitledItems[x].ItemAngleFullImage);
                        imageArray.push(this.entitledItems[x].ItemAngleThumbnailShortDesc);
                    }
                    return imageArray;
                }
            }
        }
        return null;
    },


    /**
     * changeViewImages Updates the angle views of the SKU.
     *
     * @param {String[]} itemAngleThumbnail An array of SKU view thumbnails.
     * @param {String[]} itemAngleFullImage An array of SKU view full images.
     * @param {String[]} itemAngleThumbnailShortDesc An array of short description for the SKU view thumbnails.
     **/
    changeViewImages: function (itemAngleThumbnail, itemAngleFullImage, itemAngleThumbnailShortDesc) {
        var imageCount = 0;
        for (x in itemAngleThumbnail) {
            var prodAngleCount = imageCount;
            imageCount++;

            var thumbnailWidgets = $("ul[id^='ProductAngleImagesAreaList']");
            if ($(thumbnailWidgets).length) {
                for (var i = 0; i < thumbnailWidgets.length; i++) {
                    if (null != thumbnailWidgets[i]) {
                        var angleThumbnail = document.createElement("li");
                        var angleThumbnailLink = document.createElement("a");
                        var angleThumbnailImg = document.createElement("img");

                        angleThumbnail.id = "productAngleLi" + prodAngleCount;

                        angleThumbnailLink.href = "JavaScript:changeThumbNail('productAngleLi" + prodAngleCount + "','" + itemAngleFullImage[x] + "');";
                        angleThumbnailLink.id = "WC_CachedProductOnlyDisplay_links_1_" + imageCount;
                        if (itemAngleThumbnailShortDesc != 'undefined' && itemAngleThumbnailShortDesc != null) {
                            angleThumbnailLink.title = itemAngleThumbnailShortDesc[x];
                        }

                        angleThumbnailImg.src = itemAngleThumbnail[x];
                        angleThumbnailImg.id = "WC_CachedProductOnlyDisplay_images_1_" + imageCount;
                        if (itemAngleThumbnailShortDesc != 'undefined' && itemAngleThumbnailShortDesc != null) {
                            angleThumbnailImg.alt = itemAngleThumbnailShortDesc[x];
                        }

                        if (prodAngleCount == 0) {
                            $(thumbnailWidgets[i]).empty();
                        }

                        angleThumbnailLink.appendChild(angleThumbnailImg);
                        angleThumbnail.appendChild(angleThumbnailLink);
                        thumbnailWidgets[i].appendChild(angleThumbnail);
                    }
                }
            }
        }

        var displayImageArea = "";
        if (imageCount > 0) {
            displayImageArea = 'block';
        } else {
            displayImageArea = 'none';
        }
        var angleImageArea = $("div[id^='ProductAngleImagesArea']");
        if (angleImageArea.length) {
            for (var i = 0; i < angleImageArea.length; i++) {
                if (null != angleImageArea[i]) {
                    $(angleImageArea[i]).css("display", displayImageArea);
                }
            }
        }
    },

    /**
     * Updates the swatches selections on list view.
     * Sets up the swatches array and sku images, then selects a default swatch value.
     **/
    updateSwatchListView: function () {
        var swatchArray = $("a[id^='swatch_array_']");
        for (var i = 0; i < swatchArray.length; i++) {
            var swatchArrayElement = $(swatchArray[i]);
            eval($(swatchArrayElement).attr("href"));
        }

        var swatchSkuImage = $("a[id^='swatch_setSkuImage_']");
        for (var i = 0; i < swatchSkuImage.length; i++) {
            var swatchSkuImageElement = $(swatchSkuImage[i]);
            eval(swatchSkuImageElement.attr("href"));
        }

        var swatchDefault = $("a[id^='swatch_selectDefault_']");
        for (var i = 0; i < swatchDefault.length; i++) {
            var swatchDefaultElement = swatchDefault[i];
            eval(swatchDefaultElement.attr("href"));
        }
    },

    /**
     * Handles the case when a swatch is selected. Set the border of the selected swatch.
     * @param {String} selectedAttributeName The name of the selected swatch attribute.
     * @param {String} selectedAttributeValue The value of the selected swatch attribute.
     * @param {String} entitledItemId The ID of the SKU
     * @param {String} doNotDisable The name of the swatch attribute that should never be disabled.
     * @param {String} imageField, the field name from which the image should be picked
     * @return boolean Whether the swatch is available for selection
     **/
    selectSwatch: function (selectedAttributeName, selectedAttributeValue, entitledItemId, doNotDisable, selectedAttributeDisplayValue, skuImageId, imageField) {
        if ($("#swatch_" + entitledItemId + "_" + selectedAttributeValue).hasClass("color_swatch_disabled")) {
            return;
        }
        var selectedAttributes = this.selectedAttributesList[entitledItemId];
        for (attribute in selectedAttributes) {
            if (attribute == selectedAttributeName) {
                // case when the selected swatch is already selected with a value, if the value is different than
                // what's being selected, reset other swatches and deselect the previous value and update selection
                if (selectedAttributes[attribute] != selectedAttributeValue) {
                    // deselect previous value and update swatch selection
                    var swatchElement = document.getElementById("swatch_" + entitledItemId + "_" + selectedAttributes[attribute]);
                    swatchElement.className = "color_swatch";
                    swatchElement.src = swatchElement.src.replace("_disabled.png", "_enabled.png");

                    //change the title text of the swatch link
                    document.getElementById("swatch_link_" + entitledItemId + "_" + selectedAttributes[attribute]).title = swatchElement.alt;
                }
            }
            $("#swatch_link_" + entitledItemId + "_" + selectedAttributes[attribute]).attr("aria-checked", "false");
        }
        this.makeSwatchSelection(selectedAttributeName, selectedAttributeValue, entitledItemId, doNotDisable, selectedAttributeDisplayValue, skuImageId, imageField);
    },

    /**
     * Make swatch selection - add to selectedAttribute, select image, and update other swatches and SKU image based on current selection.
     * @param {String} swatchAttrName The name of the selected swatch attribute.
     * @param {String} swatchAttrValue The value of the selected swatch attribute.
     * @param {String} entitledItemId The ID of the SKU.
     * @param {String} doNotDisable The name of the swatch attribute that should never be disabled.	
     * @param {String} skuImageId This is optional. The element id of the product image - image element id is different in product page and category list view. Product page need not pass it because it is set separately
     * @param {String} imageField This is optional. The json field from which image should be picked. Pass value if a different size image need to be picked
     **/
    makeSwatchSelection: function (swatchAttrName, swatchAttrValue, entitledItemId, doNotDisable, selectedAttributeDisplayValue, skuImageId, imageField) {
        productDisplayJS.setSelectedAttribute(swatchAttrName, swatchAttrValue, entitledItemId, skuImageId, imageField);
        document.getElementById("swatch_" + entitledItemId + "_" + swatchAttrValue).className = "color_swatch_selected";
        $("#swatch_link_" + entitledItemId + "_" + swatchAttrValue).attr("aria-checked", "true");
        document.getElementById("swatch_selection_label_" + entitledItemId + "_" + swatchAttrName).className = "header color_swatch_label";
        if ($("#swatch_selection_" + entitledItemId + "_" + swatchAttrName).css("display") == "none") {
            document.getElementById("swatch_selection_" + entitledItemId + "_" + swatchAttrName).style.display = "inline";
        }
        if (selectedAttributeDisplayValue != null) {
            $("#swatch_selection_" + entitledItemId + "_" + swatchAttrName).html(selectedAttributeDisplayValue);
        } else {
            $("#swatch_selection_" + entitledItemId + "_" + swatchAttrName).html(swatchAttrValue);
        }
        productDisplayJS.updateSwatchImages(swatchAttrName, entitledItemId, doNotDisable, imageField);
    },

    /**
     * Make dropdown selection.
     * @param {String} selectedAttrName The name of the selected dropdown attribute.
     * @param {String} selectedAttrValue The value of the selected dropdown attribute.
     * @param {String} entitledItemId The ID of the SKU.
     **/
    makeDropdownSelection: function (selectedAttrName, selectedAttrValue, entitledItemId) {
        //Add indexOf function to arrays for IE8
        if (!Array.prototype.indexOf) {
            Array.prototype.indexOf = function (obj, start) {
                for (var i = (start || 0), j = this.length; i < j; i++) {
                    if (this[i] === obj) {
                        return i;
                    }
                }
                return -1;
            };
        }

        var dropdownsToUpdate = [];
        var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];
        var selectedAttrValues = selectedAttributes[selectedAttrName];
        var dropdownList = productDisplayJS.allDropdownsList[entitledItemId];

        // finds out which dropdowns needs to be updated, add to dropdownsToUpdate array
        for (var i = 0; i < dropdownList.length; i++) {
            if (productDisplayJS.removeQuotes(dropdownList[i].name) != productDisplayJS.removeQuotes(selectedAttrName)) {
                dropdownsToUpdate.push(dropdownList[i]);
            }
        }

        //Finds out which attributes are entitled and add them to list of enabled
        var attributesToEnable = {};
        for (var x in productDisplayJS.entitledItems) {
            var Attributes = productDisplayJS.entitledItems[x].Attributes;

            // Turn Attributes into object
            var attrList = {};
            for (var y in Attributes) {
                var index = y.indexOf("_|_");
                var entitledDropdownName = y.substring(0, index);
                var entitledDropdownValue = y.substring(index + 3);

                attrList[entitledDropdownName] = entitledDropdownValue;
            }

            for (var attrName in attrList) {
                //the current entitled item has the selected attribute value
                if (productDisplayJS.removeQuotes(attrName) == productDisplayJS.removeQuotes(selectedAttrName) && (attrList[attrName] == selectedAttrValue || selectedAttrValue === '')) {
                    //go through the other attributes that are available to the selected attribute
                    for (var attrName2 in attrList) {
                        var attrName2NQ = productDisplayJS.removeQuotes(attrName2);
                        //only check the non-selected attribute
                        if (productDisplayJS.removeQuotes(attrName) != attrName2NQ) {
                            // Find all entitled items that match the current list of selected attributes other than attrName2
                            var matchSelectedAttributes = true;
                            for (var selected in selectedAttributes) {
                                if (productDisplayJS.removeQuotes(selected) != attrName2NQ) {
                                    if (selectedAttributes[selected] && selectedAttributes[selected] !== attrList[selected]) {
                                        matchSelectedAttributes = false;
                                    }
                                }
                            }

                            // Find all enabled values for the unselected attributes
                            if (matchSelectedAttributes && attrList[attrName2]) {
                                if (!attributesToEnable[attrName2NQ]) {
                                    attributesToEnable[attrName2NQ] = [];
                                }
                                if (attributesToEnable[attrName2NQ].indexOf(attrList[attrName2].replace(/^\s+|\s+$/g, '')) == -1) {
                                    attributesToEnable[attrName2NQ].push(attrList[attrName2].replace(/^\s+|\s+$/g, ''));
                                }
                            }
                        }
                    }
                }
            }
        }

        //Flag all attributes that should be enabled as enabled
        for (var i in dropdownsToUpdate) {
            var attrValues = attributesToEnable[productDisplayJS.removeQuotes(dropdownsToUpdate[i].name)];
            if (attrValues) {
                for (var j = 0; j < dropdownsToUpdate[i].options.length; j++) {
                    var dropdownToUpdateOption = dropdownsToUpdate[i].options[j];
                    if (attrValues.indexOf(dropdownToUpdateOption.value.replace(/^\s+|\s+$/g, '')) != -1 || dropdownToUpdateOption.value === '') {
                        dropdownToUpdateOption.enabled = true;
                    }
                }
            }
        }

        //Set all dropdown options that are enabled to disabled = false, others to disabled = true
        for (var i in dropdownsToUpdate) {
            if (dropdownsToUpdate[i].options) {
                for (var j = 0; j < dropdownsToUpdate[i].options.length; j++) {
                    var dropdownToUpdateOption = dropdownsToUpdate[i].options[j];

                    if (dropdownToUpdateOption.enabled) {
                        dropdownToUpdateOption.disabled = false;
                    } else {
                        dropdownToUpdateOption.disabled = true;
                    }

                    delete dropdownToUpdateOption.enabled;
                }

                var dropdown = $(dropdownsToUpdate[i].node);
                dropdown.Select("refresh");
            }
        }
    },

    /**
     * Constructs record and add to this.allSwatchesArray.
     * @param {String} swatchName The name of the swatch attribute.
     * @param {String} swatchValue The value of the swatch attribute.	
     * @param {String} swatchImg1 The path to the swatch image.
	* @param {String} swatchImg2 The path to the swatch image representing disabled state.
     **/
	addToAllSwatchsArray: function(swatchName, swatchValue, swatchImg1, entitledItemId, swatchDisplayValue, swatchImg2) {
        var swatchList = this.allSwatchesArrayList[entitledItemId];
        if (swatchList == null) {
            swatchList = [];;
        }
        if (!this.existInAllSwatchsArray(swatchName, swatchValue, swatchList)) {
            var swatchRecord = [];
            swatchRecord[0] = swatchName;
            swatchRecord[1] = swatchValue;
            swatchRecord[2] = swatchImg1;
            swatchRecord[3] = swatchImg2;
            swatchRecord[4] = document.getElementById("swatch_link_" + entitledItemId + "_" + swatchValue).onclick;
            swatchRecord[5] = null;
            swatchRecord[6] = swatchDisplayValue;
            swatchList.push(swatchRecord);
            this.allSwatchesArrayList[entitledItemId] = swatchList;
        }
    },

    /**
     * Constructs record and add to this.allDropdownsArray.
     * @param {String} attributeName The name of the dropdown attribute.
     * @param {String} dropdownId The id of the dropdown.	
     **/
    addToAllDropdownsArray: function (attributeName, dropdownId, entitledItemId) {
        var dropdownList = this.allDropdownsList[entitledItemId];
        if (dropdownList == null) {
            dropdownList = [];
        }

        var dropdownNode = productDisplayJS.findDropdownById(dropdownId);

        if (!this.existInAllDropdownsArray(attributeName, dropdownId, dropdownList)) {
            dropdownList.push({
                name: attributeName,
                id: dropdownId,
                node: dropdownNode,
                options: $(dropdownNode).find("option"),
            });
            this.allDropdownsList[entitledItemId] = dropdownList;
        }
    },

    /**
     * Checks if a swatch is already exist in this.allSwatchesArray.
     * @param {String} swatchName The name of the swatch attribute.
     * @param {String} swatchValue The value of the swatch attribute.		
     * @return boolean Value indicating whether or not the specified swatch name and value exists in the allSwatchesArray.
     */
    existInAllSwatchsArray: function (swatchName, swatchValue, swatchList) {
        for (var i = 0; i < swatchList.length; i++) {
            var attrName = swatchList[i][0];
            var attrValue = swatchList[i][1];
            if (attrName == swatchName && attrValue == swatchValue) {
                return true;
            }
        }
        return false;
    },

    /**
     * Checks if a dropdown already exists in this.allDropdownsArray.
     * @param {String} dropdownName The name of the dropdown.
     * @param {String} dropdownId The id of the dropdown.		
     * @return boolean Value indicating whether or not the specified dropdown name and value exists in the allDropdownsArray.
     */
    existInAllDropdownsArray: function (dropdownName, dropdownId, dropdownsList) {
        for (var i = 0; i < dropdownsList.length; i++) {
            if (dropdownsList[i].name == dropdownName && dropdownsList[i].id == dropdownId) {
                return true;
            }
        }
        return false;
    },

    /**
     * Check the entitledItems array and pre-select the first entitled SKU as the default swatch selection.
     * @param {String} entitledItemId The ID of the SKU.
     * @param {String} doNotDisable The name of the swatch attribute that should never be disabled.		
     **/
    makeDefaultSwatchSelection: function (entitledItemId, doNotDisable) {
        if (this.entitledItems.length == 0) {
            if ($("#" + entitledItemId).length) {
                entitledItemJSON = eval('(' + $("#" + entitledItemId).html() + ')');
            }
            productDisplayJS.setEntitledItems(entitledItemJSON);
        }

        // need to make selection for every single swatch
        for (x in this.entitledItems) {
            var Attributes = this.entitledItems[x].Attributes;
            for (y in Attributes) {
                var index = y.indexOf("_|_");
                var swatchName = y.substring(0, index);
                var swatchValue = y.substring(index + 3);
                this.makeSwatchSelection(swatchName, swatchValue, entitledItemId, doNotDisable, null, imageField);
            }
            break;
        }
    },

    /**
     * Update swatch images - this is called after selection of a swatch is made, and this function checks for
     * entitlement and disable swatches that are not available
     * @param {String} selectedAttrName The attribute that is selected
     * @param {String} entitledItemId The ID of the SKU.
     * @param {String} doNotDisable The name of the swatch attribute that should never be disabled.	
     **/
    updateSwatchImages: function (selectedAttrName, entitledItemId, doNotDisable, imageField) {
        var swatchToUpdate = [];
        var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];
        var selectedAttrValue = selectedAttributes[selectedAttrName];
        var swatchList = productDisplayJS.allSwatchesArrayList[entitledItemId];

        // finds out which swatch needs to be updated, add to swatchToUpdate array
        for (var i = 0; i < swatchList.length; i++) {
            var attrName = swatchList[i][0];
            var attrValue = swatchList[i][1];
            var attrImg1 = swatchList[i][2];
            var attrImg2 = swatchList[i][3];
            var attrOnclick = swatchList[i][4];
            var attrDisplayValue = swatchList[i][6];

            if (attrName != doNotDisable && attrName != selectedAttrName) {
                var swatchRecord = [];
                swatchRecord[0] = attrName;
                swatchRecord[1] = attrValue;
                swatchRecord[2] = attrImg1;
                swatchRecord[3] = attrImg2;
                swatchRecord[4] = attrOnclick;
                swatchRecord[5] = false;
                swatchRecord[6] = attrDisplayValue;
                swatchToUpdate.push(swatchRecord);
            }
        }

        // finds out which swatch is entitled, if it is, image should be set to enabled
        // go through entitledItems array and find out swatches that are entitled 
        for (x in productDisplayJS.entitledItems) {
            var Attributes = productDisplayJS.entitledItems[x].Attributes;

            for (y in Attributes) {
                var index = y.indexOf("_|_");
                var entitledSwatchName = y.substring(0, index);
                var entitledSwatchValue = y.substring(index + 3);

                //the current entitled item has the selected attribute value
                if (entitledSwatchName == selectedAttrName && entitledSwatchValue == selectedAttrValue) {
                    //go through the other attributes that are available to the selected attribute
                    //exclude the one that is selected
                    for (z in Attributes) {
                        var index2 = z.indexOf("_|_");
                        var entitledSwatchName2 = z.substring(0, index2);
                        var entitledSwatchValue2 = z.substring(index2 + 3);

                        if (y != z) { //only check the attributes that are not the one selected
                            for (i in swatchToUpdate) {
                                var swatchToUpdateName = swatchToUpdate[i][0];
                                var swatchToUpdateValue = swatchToUpdate[i][1];

                                if (entitledSwatchName2 == swatchToUpdateName && entitledSwatchValue2 == swatchToUpdateValue) {
                                    swatchToUpdate[i][5] = true;
                                }
                            }
                        }
                    }
                }
            }
        }

        // Now go through swatchToUpdate array, and update swatch images
        var disabledAttributes = [];
        for (i in swatchToUpdate) {
            var swatchToUpdateName = swatchToUpdate[i][0];
            var swatchToUpdateValue = swatchToUpdate[i][1];
            var swatchToUpdateImg1 = swatchToUpdate[i][2];
            var swatchToUpdateImg2 = swatchToUpdate[i][3];
            var swatchToUpdateOnclick = swatchToUpdate[i][4];
            var swatchToUpdateEnabled = swatchToUpdate[i][5];

            if (swatchToUpdateEnabled) {
                if (document.getElementById("swatch_" + entitledItemId + "_" + swatchToUpdateValue).className != "color_swatch_selected") {
                    var swatchElement = document.getElementById("swatch_" + entitledItemId + "_" + swatchToUpdateValue);
                    swatchElement.className = "color_swatch";
                    if (swatchToUpdateImg1 != "" && swatchToUpdateImg2 != "") {
                    	swatchElement.src = swatchToUpdateImg1;
                    }
                    else {
                    	swatchElement.src = swatchElement.src.replace("_disabled.png","_enabled.png");
                    }

                    //change the title text of the swatch link
                    document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).title = swatchElement.alt;
                }
                $("#swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).attr("aria-disabled", "false");
                document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).onclick = swatchToUpdateOnclick;
            } else {
                if (swatchToUpdateName != doNotDisable) {
                    var swatchElement = document.getElementById("swatch_" + entitledItemId + "_" + swatchToUpdateValue);
                    var swatchLinkElement = document.getElementById("swatch_link_" + entitledItemId + "_" + swatchToUpdateValue);
                    swatchElement.className = "color_swatch_disabled";
                    swatchLinkElement.onclick = null;
                    if (swatchToUpdateImg1 != "" && swatchToUpdateImg2 != "") {
                    	swatchElement.src = swatchToUpdateImg2;
                    }
                    else {
                    	swatchElement.src = swatchElement.src.replace("_enabled.png","_disabled.png");
                    }

                    //change the title text of the swatch link
                    var titleText = Utils.getLocalizationMessage("INV_ATTR_UNAVAILABLE", [swatchElement.alt]);


                    $("#swatch_link_" + entitledItemId + "_" + swatchToUpdateValue).attr("aria-disabled", "true");

                    //The previously selected attribute is now unavailable for the new selection
                    //Need to switch the selection to an available value
                    if (selectedAttributes[swatchToUpdateName] == swatchToUpdateValue) {
                        disabledAttributes.push(swatchToUpdate[i]);
                    }
                }
            }
        }

        //If there were any previously selected attributes that are now unavailable
        //Find another available value for that attribute and update other attributes according to the new selection
        for (i in disabledAttributes) {
            var disabledAttributeName = disabledAttributes[i][0];
            var disabledAttributeValue = disabledAttributes[i][1];

            for (i in swatchToUpdate) {
                var swatchToUpdateName = swatchToUpdate[i][0];
                var swatchToUpdateValue = swatchToUpdate[i][1];
                var swatchToUpdateDisplayValue = swatchToUpdate[i][6];
                var swatchToUpdateEnabled = swatchToUpdate[i][5];

                if (swatchToUpdateName == disabledAttributeName && swatchToUpdateValue != disabledAttributeValue && swatchToUpdateEnabled) {
                    productDisplayJS.makeSwatchSelection(swatchToUpdateName, swatchToUpdateValue, entitledItemId, doNotDisable, swatchToUpdateDisplayValue, imageField);
                    break;
                }
            }
        }
    },
    /* SwatchCode end */

    /** 
     * Displays price of the attribute selected with the catalog entry id.
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    displayPrice: function (catEntryId, productId) {
        var catEntry = productDisplayJS.itemPriceJsonOject[catEntryId].catalogEntry;

        var tempString;
        var popup = productDisplayJS.isPopup;

        if (popup == true) {
            $("#productPrice").html(catEntry.offerPrice);
        }

        if (popup == false) {
            var innerHTML = "";

            if (!catEntry.listPriced || catEntry.listPrice <= catEntry.offerPrice) {
                innerHTML = "<span id='offerPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' class='price'>" + catEntry.offerPrice + "</span>";
            } else {
                innerHTML = "<span id='listPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' class='old_price'>" + catEntry.listPrice + "</span>" +
                    "<span id='offerPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' class='price'>" + catEntry.offerPrice + "</span>";
            }
            if (document.getElementById('price_display_' + productId)) {
                document.getElementById('price_display_' + productId).innerHTML = innerHTML + "<input type='hidden' id='ProductInfoPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' value='" + catEntry.offerPrice.replace(/"/g, "&#034;").replace(/'/g, "&#039;") + "'/>";
            } else if (document.getElementById('price_display_' + catEntryId)) {
                document.getElementById('price_display_' + catEntryId).innerHTML = innerHTML + "<input type='hidden' id='ProductInfoPrice_" + catEntry.catalogEntryIdentifier.uniqueID + "' value='" + catEntry.offerPrice.replace(/"/g, "&#034;").replace(/'/g, "&#039;") + "'/>";
            }

            innerHTML = "";
            if (productDisplayJS.displayPriceRange == true) {
                for (var i in catEntry.priceRange) {
                    if (catEntry.priceRange[i].endingNumberOfUnits == catEntry.priceRange[i].startingNumberOfUnits) {
                        tempString = Utils.getLocalizationMessage('PQ_PRICE_X', {
                            0: catEntry.priceRange[i].startingNumberOfUnits
                        });
                        innerHTML = innerHTML + "<p>" + tempString;
                    } else if (catEntry.priceRange[i].endingNumberOfUnits != 'null') {
                        tempString = Utils.getLocalizationMessage('PQ_PRICE_X_TO_Y', {
                            0: catEntry.priceRange[i].startingNumberOfUnits,
                            1: catEntry.priceRange[i].endingNumberOfUnits
                        });
                        innerHTML = innerHTML + "<p>" + tempString;
                    } else {
                        tempString = Utils.getLocalizationMessage('PQ_PRICE_X_OR_MORE', {
                            0: catEntry.priceRange[i].startingNumberOfUnits
                        });
                        innerHTML = innerHTML + "<p>" + tempString;
                    }
                    innerHTML = innerHTML + " <span class='price'>" + catEntry.priceRange[i].localizedPrice + "</span></p>";
                }
            }
            // Append productId so that element is unique in bundle page, where there can be multiple components
            if (document.getElementById('price_display_' + productId) && innerHTML !== '') {
                $("#price_display_" + productId).html($('#price_display_' + productId).html() + '<div class="item_spacer_3px"></div><div id="priceRange_' + productId + '" class="quantity_discount">' + Utils.getLocalizationMessage('PQ_PURCHASE') + innerHTML + '</div>');
            }
        }
    },

    /** 
     * Updates the product name in the NameAndPrice widget. 
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    updateProductName: function (catEntryId, productId) {
        var catEntry = productDisplayJS.itemPriceJsonOject[catEntryId].catalogEntry;

        if (productDisplayJS.isPopup == true) {
            $("#productName").html(catEntry.description[0].name);
        } else {
            if ($(".top > div[id^='PageHeading_']") != null) {
                $(".top > div[id^='PageHeading_']").each(function (i, node) {
                    if (node.childNodes != null && node.childNodes.length == 3) {
                        node.childNodes[1].innerHTML = catEntry.description[0].name;
                    }
                });
            }

            var productInfoWidgets = $("input[id^='ProductInfoName_" + productId + "']");
            if (productInfoWidgets != null) {
                for (var i = 0; i < productInfoWidgets.length; i++) {
                    if (productInfoWidgets[i] != null) {
                        $(productInfoWidgets[i]).val(catEntry.description[0].name);
                    }
                }
            }
        }
    },

    /** 
     * Updates the product part number in the NameAndPrice widget. 
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    updateProductPartNumber: function (catEntryId, productId) {
        var catEntry = productDisplayJS.itemPriceJsonOject[catEntryId].catalogEntry;

        if (productDisplayJS.isPopup == true) {
            $("#productSKUValue").html(catEntry.catalogEntryIdentifier.externalIdentifier.partNumber);
        } else {
            var partnumWidgets = $("span[id^='product_SKU_" + productId + "']");
            if (partnumWidgets != null) {
                for (var i = 0; i < partnumWidgets.length; i++) {
                    if ($(partnumWidgets[i])) {
                        $(partnumWidgets[i]).html(Utils.getLocalizationMessage('SKU') + " " + catEntry.catalogEntryIdentifier.externalIdentifier.partNumber);
                    }
                }
            }
        }
    },

    /** 
     * Updates the product short description in the ShortDescription widget. 
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    updateProductShortDescription: function (catEntryId, productId) {
        var catEntry = productDisplayJS.itemPriceJsonOject[catEntryId].catalogEntry;

        var shortDescWidgets = $("p[id^='product_shortdescription_" + productId + "']");
        if (shortDescWidgets != null) {
            for (var i = 0; i < shortDescWidgets.length; i++) {
                if (shortDescWidgets[i]) {
                    shortDescWidgets[i].innerHTML = catEntry.description[0].shortDescription;
                }
            }
        }
    },

    /** 
     * Updates the product long description in the LongDescription widget. 
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    updateProductLongDescription: function (catEntryId, productId) {
        var catEntry = productDisplayJS.itemPriceJsonOject[catEntryId].catalogEntry;

        var longDescWidgets = $("p[id^='product_longdescription_" + productId + "']");
        if (longDescWidgets != null) {
            for (var i = 0; i < longDescWidgets.length; i++) {
                if (longDescWidgets[i]) {
                    longDescWidgets[i].innerHTML = catEntry.description[0].longDescription;
                }
            }
        }
    },

    /** 
     * Updates the product discounts in the Discounts widget. 
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    updateProductDiscount: function (catEntryId, productId) {
        var catEntry = productDisplayJS.itemPriceJsonOject[catEntryId].catalogEntry;

        var newHtml = '';
        if (typeof catEntry.discounts != 'undefined') {
            for (var i = 0; i < catEntry.discounts.length; i++) {
                if (i > 0) {
                    newHtml += '<div class="clear_float"></div><div class="item_spacer_2px"></div>';
                }
                /* catEntry.discounts[i].description comes from short description associated with the promotion.
                 * If it is blank or missing, the link text is blank, thus is not clickable or displayed.
                 */
                newHtml += '<a class="promotion" href="' + catEntry.discounts[i].url + '">' + catEntry.discounts[i].description + '</a>';
            }
        }

        var discountWidgets = $("div[id^='Discounts_']");
        if (discountWidgets != null) {
            for (var i = 0; i < discountWidgets.length; i++) {
                if (discountWidgets[i]) {
                    discountWidgets[i].innerHTML = newHtml;
                }
            }
        }
    },

    /** 
     * Updates the product full image and angle images in the FullImage widget. 
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    updateProductImage: function (catEntryId, productId) {
        var newFullImage = null;
        var newAngleThumbnail = null;
        var newAngleFullImage = null;
        var newAngleThumbnailShortDesc = null;

        var skuFullImageFromService = null;
        var catEntry = null;
        if (productDisplayJS.itemPriceJsonOject[catEntryId] != null) {
            catEntry = productDisplayJS.itemPriceJsonOject[catEntryId].catalogEntry;
        }
        if (catEntry != null) {
            skuFullImageFromService = catEntry.description[0].fullImage;
        }

        var entitledItemId = "entitledItem_" + productId;
        var imageArr = productDisplayJS.getImageForSKU(entitledItemId);
        if (imageArr != null) {
            newAngleThumbnail = imageArr[2];
            newAngleFullImage = imageArr[3];
            newAngleThumbnailShortDesc = imageArr[4];
        }

        if (catEntryId != null) {
            newFullImage = imageArr[0];
            if (skuFullImageFromService != null && skuFullImageFromService !== "") {
                newFullImage = skuFullImageFromService;
            }
        } else if (productId != null && productDisplayJS.singleSKUProductWithoutDefiningAttribute) {
            newFullImage = productDisplayJS.entitledItems[0].ItemImage467;
            if (skuFullImageFromService != null && skuFullImageFromService !== "") {
                newFullImage = skuFullImageFromService;
            }
            newAngleThumbnail = productDisplayJS.entitledItems[0].ItemAngleThumbnail;
            newAngleFullImage = productDisplayJS.entitledItems[0].ItemAngleFullImage;
            newAngleThumbnailShortDesc = productDisplayJS.entitledItems[0].ItemAngleThumbnailShortDesc;
        } else {
            var imageFound = false;
            var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];
            for (x in productDisplayJS.entitledItems) {
                var Attributes = productDisplayJS.entitledItems[x].Attributes;

                for (attribute in selectedAttributes) {
                    var matchingAttributeFound = false;
                    if (selectedAttributes[attribute] !== '') {
                        for (y in Attributes) {
                            var index = y.indexOf("_|_");
                            var entitledSwatchName = y.substring(0, index);
                            var entitledSwatchValue = y.substring(index + 3);

                            if (entitledSwatchName == attribute && entitledSwatchValue == selectedAttributes[attribute]) {
                                matchingAttributeFound = true;
                                break;
                            }
                        }

                        // No matching attributes found, so this is not the correct SKU
                        if (!matchingAttributeFound) {
                            imageFound = false;
                            break;
                        }
                        imageFound = true;
                    }
                }

                // imageFound will only be true if all attributes have been matched (so the first correct SKU)
                if (imageFound) {
                    newFullImage = productDisplayJS.entitledItems[x].ItemImage467;
                    newAngleThumbnail = productDisplayJS.entitledItems[x].ItemAngleThumbnail;
                    newAngleFullImage = productDisplayJS.entitledItems[x].ItemAngleFullImage;
                    newAngleThumbnailShortDesc = productDisplayJS.entitledItems[x].ItemAngleThumbnailShortDesc;
                    break;
                }
            }
        }

        var imgWidgets = $("img[id^='" + productDisplayJS.skuImageId + "']");
        for (var i = 0; i < imgWidgets.length; i++) {
            if (imgWidgets[i] != null && newFullImage != null) {
                imgWidgets[i].src = newFullImage;
            }
        }

        var productImgWidgets = $("input[id^='ProductInfoImage_" + productId + "']");
        for (var i = 0; i < productImgWidgets.length; i++) {
            if (productImgWidgets[i] != null && newFullImage != null) {
                productImgWidgets[i].value = newFullImage;
            }
        }

        var prodAngleImageArea = $("div[id^='ProductAngleProdImagesArea']");
        var skuAngleImageArea = $("div[id^='ProductAngleImagesArea']");

        if (newAngleThumbnail != null && newAngleFullImage != null) {
            if (prodAngleImageArea.length) {
                for (var i = 0; i < prodAngleImageArea.length; i++) {
                    if (null != prodAngleImageArea[i]) {
                        $(prodAngleImageArea[i]).css("display", 'none');
                    }
                }
            }
            productDisplayJS.changeViewImages(newAngleThumbnail, newAngleFullImage, newAngleThumbnailShortDesc);
        } else {
            var prodDisplayClass = 'block';
            var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];
            for (attribute in selectedAttributes) {
                if (null != selectedAttributes[attribute] && '' != selectedAttributes[attribute]) {
                    prodDisplayClass = 'none';
                }
            }

            if (prodAngleImageArea.length) {
                for (var i = 0; i < prodAngleImageArea.length; i++) {
                    if (prodAngleImageArea[i].length) {
                        $(prodAngleImageArea[i]).css("display", prodDisplayClass);
                    }
                }
            }

            if (skuAngleImageArea != null) {
                for (var i = 0; i < skuAngleImageArea.length; i++) {
                    if (skuAngleImageArea[i].length) {
                        $(skuAngleImageArea[i]).css("display", 'none');
                    }
                }
            }
        }
    },

    /** 
     * To notify the change in attribute to other components that is subscribed to 'DefiningAttributes_Changed' or 'DefiningAttributes_Resolved' event.
     * 
     * @param {string} productId The identifier of the product.
     * @param {string} entitledItemId The identifier of the entitled item.
     * @param {boolean} isPopup If the value is true, then this implies that the function was called from a quick info pop-up.
     * @param {boolean} displayPriceRange A boolean used to to determine whether or not to display the price range when the catEntry is selected. 	
     */
    notifyAttributeChange: function (productId, entitledItemId, isPopup, displayPriceRange) {
        productDisplayJS.baseCatalogEntryId = productId;
        var selectedAttributes = productDisplayJS.selectedAttributesList[entitledItemId];

        productDisplayJS.displayPriceRange = displayPriceRange;
        productDisplayJS.isPopup = isPopup;

        var catalogEntryId = null;
        if (productDisplayJS.selectedProducts[productId]) {
            catalogEntryId = productDisplayJS.getCatalogEntryIdforProduct(productDisplayJS.selectedProducts[productId]);
        } else {
            catalogEntryId = productDisplayJS.getCatalogEntryId(entitledItemId);
        }

        if (catalogEntryId != null) {
            wcTopic.publish('DefiningAttributes_Resolved_' + productId, catalogEntryId, productId);

            //check if the json object is already present for the catEntry.
            var catEntry = productDisplayJS.itemPriceJsonOject[catalogEntryId];

            if (catEntry != null && catEntry != undefined) {
                productDisplayJS.publishAttributeResolvedEvent(catalogEntryId, productId);
            }
            //if json object is not present, call the service to get the details.
            else {
                var parameters = {
                    storeId: productDisplayJS.storeId,
                    langId: productDisplayJS.langId,
                    catalogId: productDisplayJS.catalogId,
                    catalogEntryId: catalogEntryId,
                    productId: productId
                };

                //Declare a service for retrieving catalog entry detailed information for an item...
                wcService.declare({
                    id: "getCatalogEntryDetails",
                    actionId: "getCatalogEntryDetails",
                    url: getAbsoluteURL() + appendWcCommonRequestParameters("GetCatalogEntryDetailsByIDView"),
                    formId: ""

                    ,
                    successHandler: function (serviceResponse, ioArgs) {
                        productDisplayJS.publishAttributeResolvedEventServiceResponse(serviceResponse, ioArgs);
                    }

                    ,
                    failureHandler: function (serviceResponse, ioArgs) {
                        console.debug("productDisplayJS.notifyAttributeChange: Unexpected error occurred during an xhrPost request.");
                    }

                });
                wcService.invoke("getCatalogEntryDetails", parameters);
            }
        } else {
            wcTopic.publish('DefiningAttributes_Changed', catalogEntryId, productId);
            wcTopic.publish('DefiningAttributes_Changed_' + productId, catalogEntryId, productId);
            console.debug("Publishing event 'DefiningAttributes_Changed' with params: catEntryId=" + catalogEntryId + ", productId=" + productId);
        }
    },

    /** 
     * Publishes the 'DefiningAttributes_Resolved' event using the JSON object returned from the server.
     * 
     * @param {object} serviceRepsonse The JSON response from the service.
     * @param {object} ioArgs The arguments from the service call.
     */
    publishAttributeResolvedEventServiceResponse: function (serviceResponse, ioArgs) {
        var productId = ioArgs.productId;
        //stores the json object, so that the service is not called when same catEntry is selected.
        productDisplayJS.itemPriceJsonOject[serviceResponse.catalogEntry.catalogEntryIdentifier.uniqueID] = serviceResponse;

        productDisplayJS.publishAttributeResolvedEvent(serviceResponse.catalogEntry.catalogEntryIdentifier.uniqueID, productId);
    },

    /** 
     * Publishes the 'DefiningAttributes_Resolved' event with the necessary parameters. 
     * 
     * @param {string} catEntryId The identifier of the sku.
     * @param {string} productId The identifier of the product.
     */
    publishAttributeResolvedEvent: function (catEntryId, productId) {
        if (!productDisplayJS.isPopup) {
            if (this.entitledItems) {
                for (x in this.entitledItems) {
                    var sku = this.entitledItems[x];
                    if (sku.catentry_id === catEntryId) {
                        if (sku.displaySKUContextData === 'true') {
                            if (document.location.href !== sku.seo_url) {
                                document.location.replace(sku.seo_url);
                            } else {
                                wcTopic.publish('DefiningAttributes_Resolved', catEntryId, productId);
                                console.debug("Publishing event 'DefiningAttributes_Resolved' with params: catEntryId=" + catEntryId + ", productId=" + productId);
                            }
                        } else {
                            wcTopic.publish('DefiningAttributes_Resolved', catEntryId, productId);
                            console.debug("Publishing event 'DefiningAttributes_Resolved' with params: catEntryId=" + catEntryId + ", productId=" + productId);
                        }
                    }
                }
            } else {
                console.debug("Publishing event 'DefiningAttributes_Resolved' with params: catEntryId=" + catEntryId + ", productId=" + productId);
                wcTopic.publish('DefiningAttributes_Resolved', catEntryId, productId);
            }
        }
    },

    /**
     * To notify the change in quantity to other components that is subscribed to ShopperActions_Changed event.
     */
    notifyQuantityChange: function (quantity) {
        wcTopic.publish('ShopperActions_Changed', quantity);
        console.debug("Publishing event 'ShopperActions_Changed' with params: quantity=" + quantity);
    },

    /**
     * To display attachment page.
     */
    showAttachmentPage: function (data) {
        var pageNumber = data['pageNumber'];
        var pageSize = data['pageSize'];
        pageNumber = Number(pageNumber);
        pageSize = Number(pageSize);

        setCurrentId(data["linkId"]);

        if (!submitRequest()) {
            return;
        }

        var beginIndex = pageSize * (pageNumber - 1);
        cursor_wait();
        wcRenderContext.updateRenderContext('AttachmentPagination_Context', {
            'beginIndex': beginIndex
        });
        MessageHelper.hideAndClearMessage();
    },

    /**
     * Register mouse down event 
     */
    registerMouseDown: function (node) {
        $(node).on("mousedown",
            function () {
                productDisplayJS.calculateScrollingHeight(node);
            }
        );
    },

    /**
     * Calculate scrolling height.
     */
    calculateScrollingHeight: function (node) {
        var selectedNode = productDisplayJS.findDropdownById(node);
        var nodePosition = null;
        if (selectedNode) {
            nodePosition = Utils.position(selectedNode);
        } else {
            return;
        }
        var windowHeight = window.innerHeight;
        if (windowHeight - nodePosition.y > nodePosition.y) {
            var newHeight = windowHeight - nodePosition.y;
        } else {
            var newHeight = nodePosition.y;
        }
        if ($("#" + node + "_dropdown").length) {
            if (windowHeight - nodePosition.y > nodePosition.y) {
                var newHeight = windowHeight - nodePosition.y;
            } else {
                var newHeight = nodePosition.y;
            }
            var dropdownHeight = $("#" + node + "_dropdown").clientHeight;
            if (dropdownHeight > newHeight) {
                $("#" + node + "_dropdown").css("height", newHeight + "px");
            }
        } else {
            //			$("#" + node + "_dropdown").css("height", windowHeight + "px");
        }
    },

    findDropdownById: function (node) {
        var newNode = productDisplayJS.removeQuotes(node);
        var nodes = $('[id^=attrValue_]');
        var foundNode = null;

        $(nodes).each(function (key, domNode) {
            var id = productDisplayJS.removeQuotes(domNode.id);
            if (newNode === id) {
                foundNode = domNode;
            }
        });

        return foundNode;
    },

    removeQuotes: function (str) {
        if (str) {
            return str.replace(/&#039;/g, '').replace(/\\'/g, '').replace(/'/g, '');
        } else {
            return str;
        }
    }
}
$(document).ready(function () {
    var ie_version = Utils.get_IE_version();
    if (ie_version < 9) {
        $(document).on("click", ".compare_target > input[type=\"checkbox\"]", function (event) {
            this.blur();
            this.focus();
        });
    }
});
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the AjaxRecommendation pages to control the refresh areas.
 * @version 1.0
 */

//Declare refresh controller function used by the Ajax recommendation refresh area
var declareAjaxRecommendationRefresh_controller = function(emsName) {
    var myWidgetObj = $("#AjaxRecommendation_Widget_" + emsName);

    wcRenderContext.declare("AjaxRecommendationRefresh_Context_" + emsName, ["AjaxRecommendation_Widget_" + emsName], {});
    var myRCProperties = wcRenderContext.getRenderContextProperties("AjaxRecommendationRefresh_Context_" + emsName);
    
    // initialize widget
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },

        /**
         * Clears the progress bar after a successful refresh.
         */
        postRefreshHandler: function() {
            cursor_clear();
            wcTopic.publish("CMPageRefreshEvent");
        }
    });
};//-----------------------------------------------------------------
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

//
// Simple AJAX framework - START
//

// Make a simple AJAX call
// args: JSON - {requestType, requestUrl, requestParameters, async}
// Returns: JSON - {status : success, data} or {status : error, args, error};
function simpleAjax(args) {
	var out = null;
	this.xhr = new XMLHttpRequest();
	var requestURL = args.requestUrl;
	if (args.requestType === 'GET') {
		requestURL = requestURL + args.requestParameters;
	}
	this.xhr.open(args.requestType, requestURL, args.async);
	this.xhr.onreadystatechange = function() {
		if (this.readyState === this.DONE) {
			if (this.status === 200) {
				var jsonText = this.responseText.replace(/(\/\*|\*\/)/g, '');
				var resp = JSON.parse(jsonText);
				var responseError = responseHasErrorCode(resp);
				if (responseError != null) {
					out = handleError(responseError, args);
				} else {
					out = {"status" : STATUS_SUCCESS, "data" : resp};
				}
			} else {
				out = handleError(createError(null, null, MessageHelper.messages["ajaxError"] + this.status));
			}
		}
	}
	if (args.requestType === 'GET') {
		this.xhr.send();
	} else {
		this.xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
		this.xhr.send(args.requestParameters);
	}
	return out;
}
function responseHasErrorCode(resp) {
	if (resp.errorMessageKey) {
		return createError(resp.errorCode, resp.errorMessageKey, resp.errorMessage);
	}
	else {
		return null;
	}
}
function handleError(error, args) {
	return {"status" : STATUS_ERROR, "args" : args, "error" : error};
}
function createError(errorCode, errorMessageKey, errorMessage) {
	return {"errorCode" : errorCode, "errorMessageKey" : errorMessageKey, "errorMessage" : errorMessage};
}
//
// Simple AJAX framework - END
//

//
// Global ApplePay MerchantIdentifier - START
//
function getMerchantIdentifier() {
	if (sessionStorage.getItem('merchantIdentifier') == null || sessionStorage.getItem('merchantIdentifier') === "") {
		var result = simpleAjax({
			requestType: 'GET',
			requestUrl: getAbsoluteURL() + 'GetApplePayMerchantInfoV2?',
			requestParameters: getCommonParameters(),
			async: false
		});
		if (result.status === STATUS_SUCCESS) {
			sessionStorage.setItem('merchantIdentifier', result.data.merchantIdentifier);
		}
		else {
			displayError("getMerchantIdentifier", result.error);
		};
	}
	return sessionStorage.getItem('merchantIdentifier');
}
//
// Global ApplePay MerchantIdentifier - END
//

//
// Global WC authToken - START
//
var authToken = null;
function initAuthToken() {
	if (authToken == null || authToken === "") {
		var currentURL = document.URL;
		var currentProtocol = "";
		if (currentURL.indexOf("://") != -1) {
			currentProtocol = currentURL.substring(0, currentURL.indexOf("://"));
		}
		if (currentProtocol == 'https') {
			authToken = document.getElementById("csrf_authToken");
			if (authToken) {
				return authToken = encodeURIComponent(authToken.value);
			}
			else {
				var result = simpleAjax({
					requestType: 'GET',
					requestUrl: getAbsoluteURL() + 'GetCSRFAuthTokenV2?',
					requestParameters: getCommonParameters(),
					async: false
				});
				if (result.status === STATUS_SUCCESS) {
					return authToken = encodeURIComponent(result.data.authToken);
				}
				else {
					displayError("initAuthToken", result.error);
					return null;
				};
			}
		}
		// Apple Pay isn't allowed on non-https, so this should not happen
		return null;
	} else {
		return authToken;
	}
}
function getAuthTokenUrlParameter() {
	initAuthToken();
	if (authToken) {
		return '&authToken=' + authToken;
	}
	else {
		// Missing authToken error probably already handled
		return null;
	}
}
//
// Global WC authToken - END
//

//
// Global order ID - START
//
var currentOrderId = "";
function getOrderIdUrlParameter(orderId) {
	var id;
	if (this.isEmpty(orderId)) {
		if (this.isEmpty(currentOrderId)) {
			displayError("getOrderIdUrlParameter", handleError(createError(null, null, MessageHelper.messages["ajaxError"] + this.status)));
		}
		else {
			id = currentOrderId;
		}
	}
	else {
		id = orderId;
	}
	return "&orderId=" + id;
}
//
// Global order ID - END
//

//
// Global BOPIS parameters - START
//
var mobileBOPISShipModeId = "";
var mobileBOPISStoreId = "";
function setMobileBOPISShipMode(inMobileShipModeId) {
	mobileBOPISShipModeId = inMobileShipModeId;
}
function setMobileBOPISStore(inMobileStoreId) {
	mobileBOPISStoreId = inMobileStoreId;
}

function getBOPISParameters() {
	var urlParamStr = "";
	if (isBOPISCheckout() && document.getElementById("shipmodeForm") && PhysicalStoreCookieJS) {
		var shipModeIdBOPIS = "";
		var physicalStoreLocationId = "";
		shipModeIdBOPIS = document.getElementById("shipmodeForm").BOPIS_shipmode_id.value;
		physicalStoreLocationId = document.getElementById("physicalStoreForm").BOPIS_physicalstore_id.value;
		urlParamStr = '&shipModeId='+shipModeIdBOPIS+'&physicalStoreId='+physicalStoreLocationId;
	} else if (mobileBOPISShipModeId != '') {
		urlParamStr = '&shipModeId='+mobileBOPISShipModeId+'&physicalStoreId='+mobileBOPISStoreId;
	}
	return urlParamStr;
}
//
// Global BOPIS parameters - END
//

function getCommonParameters() {
	//  Always call this first for URL parameters
	return 'storeId='+WCParamJS.storeId+'&catalogId='+WCParamJS.catalogId+'&langId='+WCParamJS.langId+'&requesttype=ajax';
}


var isReturnDefaults = "false";
function setIsReturnDefaults(inReturnDefaults) {
	isReturnDefaults = inReturnDefaults;
}
function getIsReturnDefaults() {
	return isReturnDefaults;
}
function getIsReturnDefaultsParameter() {
	var urlParamStr = "";
	urlParamStr = '&returnDefaults='+isReturnDefaults;
	return urlParamStr;
}

function getDefaultShippingParameter() {
	return '&shipModeId='+defaultShipModeId+"&addressId="+defaultAddressId;
}

function IsShipModeValid() {
	return shipModeValid;
}

function getUnboundPIIdParameter() {
	var unboundPIParamStr = "";
	if (unboundPIId !== "") {
		unboundPIParamStr = "&unboundPIId=" + unboundPIId;
	}
	return unboundPIParamStr;
}

//
// Apple Pay button and payment sheet rendering - START
//
var paymentRequest = null;
var shipModeValid = false;
var defaultShipModeId = "";
var defaultAddressId = "";
var unboundPIId = "";
document.addEventListener("DOMContentLoaded", function()  {
	if (window.ApplePaySession) {
		if (getMerchantIdentifier() != null) {
			var promise = ApplePaySession.canMakePaymentsWithActiveCard(getMerchantIdentifier());
			promise.then(function(canMakePayments) {
				if (showDebug) {
					console.log("call back method called..." + canMakePayments);
				}
				if (canMakePayments) {
					showApplePayButtons();
				}
			}, function(reject) {
				console.log("canMakePaymentsWithActiveCard promise rejected");
			});
		}
	}
});

function toggleApplePayButtonInMiniCart() {
	// Show Apple Pay button when there is an order in the mini shop cart, otherwise, hide it
	var d = document.getElementById("applePayButtonDiv_minishopcart");
	if (d !== null) {
		if (document.querySelector("#currentOrderId") && document.querySelector("#currentOrderQuantity")
			&& !this.isEmpty(document.querySelector("#currentOrderId").value)
			&& !this.isEmpty(document.querySelector("#currentOrderQuantity").value)
			&& document.querySelector("#currentOrderQuantity").value !== "0") {
				d.classList.add("visible");
		}
		else {
			d.classList.remove("visible");
		}
	}
}

function showApplePayButtons() {
	if (window.ApplePaySession) {
		var x = document.getElementsByClassName("apple-pay-button");
		var i;
		for (i = 0; i < x.length; i++) {
			x[i].classList.add("visible");
		}

		if (!this.isEmpty(document.getElementById("applePayButtonDiv_minishopcart"))) {
			// Deal with the Apple Pay button in the mini shop cart as a special case
			toggleApplePayButtonInMiniCart();
		}
	}
}

function applePayButtonClicked(entitledItemJSONId, quantity, catentryId, pageType, baseItemElement, ma_index) {
	if (typeof CSRWCParamJS !== 'undefined' && CSRWCParamJS.env_shopOnBehalfSessionEstablished === 'true') {
		// WC V8+ CSR enabled and currently either buyer admin or CSR.  Stop CSR/buyer admin here.
		displayError("applePayButtonClicked", handleError(createError(null, null, MessageHelper.messages["csrNotSupported"])));
	}
	else {
		// Normal flow
		if (((entitledItemJSONId && quantity && parseInt(quantity) > 0) || (catentryId) || pageType) ) {
			// Paying for a specific product, based on Add2ShopCartAjax()
			var catalogEntriesArray = new Object();
			if (catentryId) {
				//package or item
				catalogEntryId = catentryId;
				var oneCatEntry = [catentryId, quantity];
				catalogEntriesArray[catentryId] = oneCatEntry;
			} else {
				if (pageType === "plp") {
					//PLP - single product
					var entitledItemJSON = eval(document.getElementById(entitledItemJSONId).innerHTML);
					shoppingActionsJS.setEntitledItems(entitledItemJSON);
					var oneCatEntry = [shoppingActionsJS.getCatalogEntryId(entitledItemJSONId), quantity];
					catalogEntriesArray[shoppingActionsJS.getCatalogEntryId(entitledItemJSONId)] = oneCatEntry;
				} 
				else if (pageType === "bundle") {
					//bundle - N products
					for(productId in shoppingActionsJS.productList){
						var productDetails = shoppingActionsJS.productList[productId];
						var quantityForProduct = Utils.parseNumber(productDetails.quantity);
						if (quantityForProduct == 0) {
							continue;
						}
						if(productDetails.id == 0){
							MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
							return;
						}
						if(isNaN(quantityForProduct) || quantityForProduct < 0){
							MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
							return;
						}
						var oneCatEntry = [productDetails.id, quantityForProduct];
						catalogEntriesArray[productDetails.id] = oneCatEntry;
					}
				}
				else if (pageType === "ma") {
					//merchandising association - deal with the associated product and a product page one
					//validation of associated product
					MerchandisingAssociationJS.associationIndex = ma_index;
					MerchandisingAssociationJS.validate();
					if(!isPositiveInteger(quantity)){
						MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('QUANTITY_INPUT_ERROR'));
						return;
					}
					
					//Add the product page one to the cart.
					if(MerchandisingAssociationJS.baseItemParams.type == 'ItemBean'
						|| MerchandisingAssociationJS.baseItemParams.type == 'PackageBean'
						|| MerchandisingAssociationJS.baseItemParams.type == 'DynamicKitBean'){
						var oneCatEntry = [MerchandisingAssociationJS.baseItemParams.id, Math.abs(MerchandisingAssociationJS.baseItemParams.quantity)];
						catalogEntriesArray[MerchandisingAssociationJS.baseItemParams.id] = oneCatEntry;
					} else if(MerchandisingAssociationJS.baseItemParams.type=='BundleBean'){
						// Add items in the bundle
						for(idx=0;idx<MerchandisingAssociationJS.baseItemParams.components.length;idx++){
							var oneCatEntry = [MerchandisingAssociationJS.baseItemParams.components[idx].id, MerchandisingAssociationJS.baseItemParams.components[idx].quantity];
							catalogEntriesArray[MerchandisingAssociationJS.baseItemParams.components[idx].id] = oneCatEntry;
						}
					} else {
						// Resolve ProductBean to an ItemBean based on the attributes in the main page
						var sku = MerchandisingAssociationJS.resolveSKU();
						if(-1 == sku){
							MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
							return;
						} else {
							var oneCatEntry = [sku, Math.abs(MerchandisingAssociationJS.baseItemParams.quantity)];
							catalogEntriesArray[sku] = oneCatEntry;
						}
					}
					
					//Add the associated product to the cart.
					if (MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='ItemBean'
						|| MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='PackageBean'
						|| MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='DynamicKitBean'){
						var oneCatEntry = [MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].id, quantity];
						catalogEntriesArray[MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].id] = oneCatEntry;	
					} else if(MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].type=='BundleBean'){
						// Add items in the bundle
						for(idx=0;idx<MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].components.length;idx++){
							var oneCatEntry = [MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].components[idx].id, MerchandisingAssociationJS.baseItemParams.components[idx].quantity];
							catalogEntriesArray[MerchandisingAssociationJS.merchandisingAssociations[MerchandisingAssociationJS.associationIndex].components[idx].id] = oneCatEntry;
						}
					} else {
						// Resolve ProductBean to an ItemBean based on the attributes selected
						var entitledItemJSON = null;
						if ($("#" + entitledItemJSONId).length) {
							//the json object for entitled items are already in the HTML. 
							entitledItemJSON = eval('(' + $("#" + entitledItemJSONId).html() + ')');
						} else {
							//if $("#" + entitledItemJSONId) is null, that means there's no <div> in the HTML that contains the JSON object. 
							//in this case, it must have been set in catalogentryThumbnailDisplay.js when the quick info
							entitledItemJSON = shoppingActionsJS.getEntitledItemJsonObject();
						}
						shoppingActionsJS.setEntitledItems(entitledItemJSON);
						var catEntryID_MA_SKU = shoppingActionsJS.getCatalogEntryId(entitledItemJSONId);
						if(null == catEntryID_MA_SKU){
							MessageHelper.displayErrorMessage(Utils.getLocalizationMessage('ERR_RESOLVING_SKU'));
							return;
						} else {
							var oneCatEntry = [catEntryID_MA_SKU, quantity];
							catalogEntriesArray[catEntryID_MA_SKU] = oneCatEntry;
						}
					}
					// end ma
				}
				else {
					//Product or Item - single product
					var entitledItemJSON = eval(document.getElementById(entitledItemJSONId).innerHTML);
					productDisplayJS.setEntitledItems(entitledItemJSON);
					var oneCatEntry = [productDisplayJS.getCatalogEntryId(entitledItemJSONId), quantity];
					catalogEntriesArray[productDisplayJS.getCatalogEntryId(entitledItemJSONId)] = oneCatEntry;
				}
			}
			if (catalogEntriesArray) {
				var catEntryParametersToAdd = '';
				var counter = 0;
				for(i in catalogEntriesArray){
					counter++;
					catEntryParametersToAdd = catEntryParametersToAdd + '&catEntryId_' + counter + '=' + catalogEntriesArray[i][0] + '&quantity_' + counter + '=' + catalogEntriesArray[i][1];
				}
				var addToOrder = simpleAjax({
					requestType: 'POST',
					requestUrl: getAbsoluteURL() + 'AjaxRESTOrderItemAdd?',
					requestParameters: getCommonParameters() + '&inventoryValidation=true&calculateOrder=0' +
						getOrderIdUrlParameter("**") + catEntryParametersToAdd + 
						'&attributeName_ord=isPDP&attributeValue_ord=1',
					async: false
				});
				if (addToOrder.status === STATUS_SUCCESS) {
					currentOrderId = addToOrder.data.orderId;
					
					if (supportPaymentTypePromotions) {
						addUnboundPI();
					}
					prepareOrder().then(function(success) {
						retrieveWCOrderInformation().then(function(success) {
							if (IsShipModeValid()) {
								renderPaymentSheet();
							}
							else {
								updateShipMode().then(function(success) {
									retrieveWCOrderInformation().then(function(success) {
										renderPaymentSheet();
									})
									.catch(function(err) {
										displayError("DirectProductBuy: fail retrieve order information 2", err)
									});
								})
								.catch(function(err) {
									displayError("DirectProductBuy: fail update shipping", err)
								});
							}
						})
						.catch(function(err) {
							displayError("DirectProductBuy: fail retrieve order information", err)
						});
					})
					.catch(function(err) {
						displayError("DirectProductBuy: fail prepare order", err)
					});
				}
				else {
					displayError("DirectProductBuy: no catentry id 2", addToOrder, MessageHelper.messages["badCatentryId"]);
				}
			}
			else {
				displayError("DirectProductBuy: no catentry id", handleError(createError(null, null, MessageHelper.messages["badCatentryId"])));
			}
		}
		else {
			// Paying for whatever is in the shopping cart
			currentOrderId = ".";
			if (isBOPISCheckout()) {
				// BOPIS flow
				openStoreLocatorPopup();
			}
			else {
				// Shipping flow
				if (supportPaymentTypePromotions) {
					addUnboundPI();
				}
				setIsReturnDefaults("true");
				retrieveWCOrderInformation().then(function(success) {
					setIsReturnDefaults("false");
					updateShipMode().then(function(success) {
						prepareOrder().then(function(success) {
							retrieveWCOrderInformation().then(function(success) {
								renderPaymentSheet();
							})
							.catch(function(err) {
								displayError("fail LAST retrieve order information", err);
							});
						})
						.catch(function(err) {
							displayError("fail prepare order", err);
						});
					})
					.catch(function(err) {
						displayError("fail update shipping information", err);
					});
				})
				.catch(function(err) {
					setIsReturnDefaults("false");
					displayError("fail retrieve order information", err);
				});
			}
		}
	}
}

function mobileBOPISFlow(bopisShipMode, bopisStoreId) {
	// Paying for whatever is in the mobile shopping cart
	currentOrderId = ".";
	setMobileBOPISShipMode(bopisShipMode);
	setMobileBOPISStore(bopisStoreId);
	updateOrderForBOPIS().then(function(success) {
		prepareOrder().then(function(success) {
			retrieveWCOrderInformation().then(function(success) {
				renderPaymentSheet();
			})
			.catch(function(err) {
				displayError("mobileBOPIS: fail retrieve order information", err);
			});
		})
		.catch(function(err) {
			displayError("mobileBOPIS: fail prepare order", err);
		});
	})
	.catch(function(err) {
		displayError("mobileBOPIS: fail update shipping for BOPIS", err);
	});
}

function startApplePayBOPISFlow() {
	if (validateBOPISParameters()) {
		if (supportPaymentTypePromotions) {
			addUnboundPI();
		}
		updateOrderForBOPIS().then(function(success) {
			prepareOrder().then(function(success) {
				retrieveWCOrderInformation().then(function(success) {
					renderPaymentSheet();
				})
				.catch(function(err) {
					displayError("BOPIS: fail retrieve order information", err);
				});
			})
			.catch(function(err) {
				displayError("BOPIS: fail prepare order", err);
			});
		})
		.catch(function(err) {
			displayError("BOPIS: fail update shipping", err);
		});
	}
	else {
		displayError("BOPIS not valid", handleError(createError(null, null, MessageHelper.messages["noStoreSelected"])));
	}
}

function renderPaymentSheet() {
	if (showDebug) {
		console.log("In renderPaymentSheet");
	}
	var session = new ApplePaySession(1, paymentRequest);
	session.begin();

	session.onvalidatemerchant = function (event) {
		if (showDebug) {
			console.log('onvalidatemerchant called...url is ' + event.validationURL);
		}
		performMerchantValidation(event.validationURL)
			.then(function(merchantSession) {
				if (showDebug) {
					//console.log(merchantSession.merchantSession);
				}
				session.completeMerchantValidation(JSON.parse(merchantSession.merchantSession));
			}, function(error) {
				displayError("performMerchantValidation", error);
				abortSession(error);
		   });
	}

	session.onshippingcontactselected = function (event) {
		if (showDebug) {
			console.log('onshippingcontactselected called');
		}
		saveShippingContact(event.shippingContact)
			.then(prepareOrder)
			.then(retrieveWCOrderInformation)
			.then(function() {
				if (!shipModeValid) {
					updateShipMode()
						.then(prepareOrder)
						.then(retrieveWCOrderInformation)
						.then(function() {
							session.completeShippingContactSelection(ApplePaySession.STATUS_SUCCESS, paymentRequest.shippingMethods, paymentRequest.total, paymentRequest.lineItems);
						})
						.catch(function(err) {
							displayError("updateShipModeAndOrder", err);
							session.completeShippingContactSelection(ApplePaySession.STATUS_INVALID_SHIPPING_POSTAL_ADDRESS);
						});
				}
				else {
					session.completeShippingContactSelection(ApplePaySession.STATUS_SUCCESS, paymentRequest.shippingMethods, paymentRequest.total, paymentRequest.lineItems);
				}
			})
			.catch(function(err) {
				displayError("saveShippingContact", err);
				session.completeShippingContactSelection(ApplePaySession.STATUS_INVALID_SHIPPING_POSTAL_ADDRESS);
			});
	}

	session.onshippingmethodselected = function (event) {
		if (showDebug) {
			console.log('onshippingmethodselected called');
			console.log(event.shippingMethod);
		}
		saveShippingMethod(event.shippingMethod)
			.then(prepareOrder)
			.then(retrieveWCOrderInformation)
			.then(function() {
				session.completeShippingMethodSelection(ApplePaySession.STATUS_SUCCESS, paymentRequest.total, paymentRequest.lineItems);
			})
			.catch(function(err) {
				displayError("saveShippingMethod", err);
				abortSession(err);
				session.completeShippingMethodSelection(ApplePaySession.STATUS_FAILURE);
			});
	}

	session.onpaymentmethodselected = function(event) {
		if (showDebug) {
			console.log('onpaymentmethodselected called');
			console.log(event.paymentMethod);
		}
		session.completePaymentMethodSelection(paymentRequest.total, paymentRequest.lineItems);
	}

	session.onpaymentauthorized = function(event) {
		if (showDebug) {
			console.log('onpaymentauthorized called');
			console.log(event.payment);
		}
		sendPaymentToken(event.payment)
			.then(function (success) {
				currentOrderId = success.orderId;
				if (showDebug) {
					console.log("currentOrderId=" + currentOrderId);
				}
				if (!this.isEmpty(currentOrderId)) {
					session.completePayment(ApplePaySession.STATUS_SUCCESS);
					setDeleteCartCookie();
					showConfirmation();
				} else {
					cancelApplePayOrder();
					session.completePayment(ApplePaySession.STATUS_FAILURE);
					displayError("sendPaymentToken", handleError(createError(null, null, MessageHelper.messages["failureSendPayment"])));
				}
			}, function(error) {
				if (error.errorMessageKey === "INVALID_SHIPPING_CONTACT") {
					session.completePayment(ApplePaySession.STATUS_INVALID_SHIPPING_CONTACT);
				}
				else if (error.errorMessageKey === "INVALID_BILLING_CONTACT") {
					session.completePayment(ApplePaySession.STATUS_INVALID_BILLING_POSTAL_ADDRESS);
				}
				else {
					session.completePayment(ApplePaySession.STATUS_FAILURE);
				}
				cancelApplePayOrder();
				displayError("sendPaymentToken", error);
			});
	}

	session.oncancel = function (event) {
		cancelApplePayOrder()
			.then(function(success) {
				if (showDebug) {
					console.log('Order cancel success');
				}
			})
			.catch(function(error) {
				displayError(CANCEL_METHOD, error);
			});
	}
}
//
// Apple Pay button and payment sheet rendering - END
//


//
// Apple Pay callback method implementations - START
//
function performMerchantValidation(appleServerURL) {
	return new Promise(function(resolve, reject) {
		var merchantValidate = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayMerchantValidation?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + '&paymentSystem=ApplePaySystem&paymentConfigGroup=default&validationURL='+appleServerURL,
			async: false
		});
		if (merchantValidate.status === STATUS_SUCCESS) {
			resolve(merchantValidate.data);
		}
		else {
			reject(merchantValidate);
		}
	});
}

function getContactAddressParameters(contact) {
	var address = '&city=' + encodeURIComponent(contact.locality) +
	'&state=' + encodeURIComponent(contact.administrativeArea) +
	'&country=' + encodeURIComponent(contact.country) +
	'&zipCode=' + encodeURIComponent(contact.postalCode) ;

	return address;
}

function getShippingAndBillingContactParameters(payment) {
	var address='' ;
	if (!this.isEmpty(payment.shippingContact)) {
		if (!this.isEmpty(payment.shippingContact.givenName)) {
			address += '&firstName_s=' + encodeURIComponent(payment.shippingContact.givenName);
		}
		if (!this.isEmpty(payment.shippingContact.familyName)) {
			address += '&lastName_s=' + encodeURIComponent(payment.shippingContact.familyName);
		}
		if (!this.isEmpty(payment.shippingContact.locality)) {
			address += '&city_s=' + encodeURIComponent(payment.shippingContact.locality);
		}
		if (!this.isEmpty(payment.shippingContact.postalCode)) {
			address += '&zipCode_s=' + encodeURIComponent(payment.shippingContact.postalCode);
		}
		if (!this.isEmpty(payment.shippingContact.addressLines) && !this.isEmpty(payment.shippingContact.addressLines[0])) {
			address += '&address1_s=' + encodeURIComponent(payment.shippingContact.addressLines[0]);
		}
		if (!this.isEmpty(payment.shippingContact.addressLines) && !this.isEmpty(payment.shippingContact.addressLines[1])) {
			address += '&address2_s=' + encodeURIComponent(payment.shippingContact.addressLines[1]);
		}
		if (!this.isEmpty(payment.shippingContact.phoneNumber)) {
			address += '&phone1_s=' + encodeURIComponent(payment.shippingContact.phoneNumber);
		}
		if (!this.isEmpty(payment.shippingContact.administrativeArea)) {
			address += '&state_s=' + encodeURIComponent(payment.shippingContact.administrativeArea);
		}
		if (!this.isEmpty(payment.shippingContact.country)) {
			address += '&country_s=' + encodeURIComponent(payment.shippingContact.country);
		}
		if (!this.isEmpty(payment.shippingContact.emailAddress)) {
			address += '&email1_s=' + encodeURIComponent(payment.shippingContact.emailAddress);
		}
	}
	if (!this.isEmpty(payment.billingContact)) {
		if (!this.isEmpty(payment.billingContact.givenName)) {
			address += '&firstName_b=' + encodeURIComponent(payment.billingContact.givenName);
		}
		if (!this.isEmpty(payment.billingContact.familyName)) {
			address += '&lastName_b=' + encodeURIComponent(payment.billingContact.familyName);
		}
		if (!this.isEmpty(payment.billingContact.locality)) {
			address += '&city_b=' + encodeURIComponent(payment.billingContact.locality);
		}
		if (!this.isEmpty(payment.billingContact.postalCode)) {
			address += '&zipCode_b=' + encodeURIComponent(payment.billingContact.postalCode);
		}
		if (!this.isEmpty(payment.billingContact.addressLines) && !this.isEmpty(payment.billingContact.addressLines[0])) {
			address += '&address1_b=' + encodeURIComponent(payment.billingContact.addressLines[0]);
		}
		if (!this.isEmpty(payment.billingContact.addressLines) && !this.isEmpty(payment.billingContact.addressLines[1])) {
			address += '&address2_b=' + encodeURIComponent(payment.billingContact.addressLines[1]);
		}
		if (!this.isEmpty(payment.billingContact.phoneNumber)) {
			address += '&phone1_b=' + encodeURIComponent(payment.billingContact.phoneNumber);
		}
		if (!this.isEmpty(payment.billingContact.administrativeArea)) {
			address += '&state_b=' + encodeURIComponent(payment.billingContact.administrativeArea);
		}
		if (!this.isEmpty(payment.billingContact.country)) {
			address += '&country_b=' + encodeURIComponent(payment.billingContact.country);
		}
		if (!this.isEmpty(payment.billingContact.emailAddress)) {
			address += '&email1_b=' + encodeURIComponent(payment.billingContact.emailAddress);
		}
	}

	return address;
}

function getPaymentTokenParameters(token){
	var paymentToken = '&applepay_paymentData_data=' + encodeURIComponent(token.paymentData.data)
		+ '&applepay_paymentData_header_publicKeyHash=' + encodeURIComponent(token.paymentData.header.publicKeyHash)
		+ '&applepay_paymentData_header_ephemeralPublicKey=' + encodeURIComponent(token.paymentData.header.ephemeralPublicKey)
		+ '&applepay_paymentData_header_transactionId=' + encodeURIComponent(token.paymentData.header.transactionId)
		+ '&applepay_paymentData_signature=' + encodeURIComponent(token.paymentData.signature)
		+ '&applepay_paymentData_version=' + encodeURIComponent(token.paymentData.version)
		+ '&applepay_paymentMethod_displayName=' + encodeURIComponent(token.paymentMethod.displayName)
		+ '&applepay_paymentMethod_network=' + encodeURIComponent(token.paymentMethod.network)
		+ '&applepay_paymentMethod_type=' + encodeURIComponent(token.paymentMethod.type)
		+ '&applepay_paymentMethod_paymentPass=' + encodeURIComponent(token.paymentMethod.paymentPass)
		+ '&applepay_transactionIdentifier=' + encodeURIComponent(token.transactionIdentifier);

	return paymentToken;
}

function saveShippingContact(shippingContact) {
	return new Promise(function(resolve, reject) {
		if (!validateInitialShippingContact(shippingContact)) {
			// Stop if contact information needed for shipping costs are not present
			reject(handleError(createError(null, "INVALID_SHIPPING_CONTACT", MessageHelper.messages["invalidShippingContact"])));
			return;
		}
		else {
			if (showDebug) {
				console.log("Update shipping Contact: " + JSON.stringify(shippingContact));
			}
			var saveResult = simpleAjax({
				requestType: 'POST',
				requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate',
				requestParameters: getCommonParameters() + getContactAddressParameters(shippingContact) + getAuthTokenUrlParameter() + getOrderIdUrlParameter(),
				async: false
			});
			if (saveResult.status === STATUS_SUCCESS) {
				resolve();
			}
			else {
				reject(saveResult);
			}
		}
	});
}

function saveShippingMethod(shippingMethod) {
	return new Promise(function(resolve, reject) {
		if (showDebug) {
			console.log("New Shipping Method: " + shippingMethod.identifier);
		}
		var saveResult = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate',
			requestParameters: getCommonParameters() + '&shipModeId=' + shippingMethod.identifier + getAuthTokenUrlParameter() + getOrderIdUrlParameter(),
			async: false
		});
		if (saveResult.status === STATUS_SUCCESS) {
			resolve();
		}
		else {
			reject(saveResult);
		}
	});
}

function validateInitialShippingContact(sc) {
	// Validate basic shipping contact for shipping costs
	if (this.isEmpty(sc)) {
		return false;
	}
	else {
		if (this.isEmpty(sc.locality)) {
			return false;
		}
		if (this.isEmpty(sc.postalCode)) {
			return false;
		}
		if (this.isEmpty(sc.administrativeArea)) {
			return false;
		}
		if (this.isEmpty(sc.country)) {
			return false;
		}
	}
	return true;
}
function validateFinalShippingContact(sc) {
	// Validate full contact for address book
	if (!validateInitialShippingContact) {
		return false;
	}
	else {
		if (this.isEmpty(sc.familyName)) {
			return false;
		}
		if (this.isEmpty(sc.addressLines) || this.isEmpty(sc.addressLines[0])) {
			return false;
		}
		if (this.isEmpty(sc.emailAddress)) {
			return false;
		}
	}
	return true;
}

function validateBillingContact(bc) {
	// Validate full billing contact
	if (this.isEmpty(bc)) {
		return false;
	}
	else {
		if (this.isEmpty(bc.familyName)) {
			return false;
		}
		if (this.isEmpty(bc.locality)) {
			return false;
		}
		if (this.isEmpty(bc.postalCode)) {
			return false;
		}
		if (this.isEmpty(bc.addressLines || this.isEmpty(bc.addressLines[0]))) {
			return false;
		}
		if (this.isEmpty(bc.administrativeArea)) {
			return false;
		}
		if (this.isEmpty(bc.country)) {
			return false;
		}
	}
	return true;
}

function sendPaymentToken(payment) {
	return new Promise(function(resolve, reject) {
		if (showDebug) {
			console.log("Sending payment token...");
		}
		if (!isBOPISCheckout()) {
			if (!validateFinalShippingContact(payment.shippingContact)) {
				reject(handleError(createError(null, "INVALID_SHIPPING_CONTACT", MessageHelper.messages["invalidShippingContact"])));
				return;
			}
		}
		if (!validateBillingContact(payment.billingContact)) {
			reject(handleError(createError(null, "INVALID_BILLING_CONTACT", MessageHelper.messages["invalidBillingContact"])));
			return;
		} else {
			var applePayOrderProcess = simpleAjax({
				requestType: 'POST',
				requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderProcess?',
				requestParameters: getCommonParameters() + '&notifyMerchant=1&notifyShopper=1&notifyOrderSubmitted=1' + getOrderIdUrlParameter(".") + 
					getAuthTokenUrlParameter() + getPaymentTokenParameters(payment.token) + getShippingAndBillingContactParameters(payment) + getUnboundPIIdParameter(),
				async: false
			});
			if (applePayOrderProcess.status === STATUS_SUCCESS) {
				resolve(applePayOrderProcess.data);
			}
			else {
				reject(applePayOrderProcess);
			}
		}
	});
}

function cancelApplePayOrder() {
	return new Promise(function(resolve, reject) {
		if (showDebug) {
			console.log("Cancelling order...");
		}
		var cancelOrder = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderCancel?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter("."),
			async: false
		});
		if (cancelOrder.status === STATUS_SUCCESS) {
			resolve(cancelOrder.data);
		}
		else {
			reject(cancelOrder);
		}
	});
}
//
// Apple Pay callback method implementations - END
//


//
// Global WC reusable task methods - START
//
var STATUS_SUCCESS = "success";
var STATUS_ERROR = "error";
var showDebug = false; // NOTE Set to false to turn off debug
var CANCEL_METHOD = "cancelApplePayOrder";

function isEmpty(v) {
	if (typeof v === "object") {
		if (Array.isArray(v)) {
			return !(v.length > 0);
		}
		else {
			return false;
		}
	}
	return !(typeof v === "string" && v.length > 0);
}

function isBOPISCheckout() {
	return this.getShippingSelection() === "pickUp";
}
function getShippingSelection() {
	var result = "shopOnline";
	if (document.BOPIS_FORM != undefined){
		for (var i=0; i < document.BOPIS_FORM.shipType.length; i++) {
			if (document.BOPIS_FORM.shipType[i].checked) {
				if (showDebug) {
					console.log("Selected checkout option - " + document.BOPIS_FORM.shipType[i].value);
				}
				result = document.BOPIS_FORM.shipType[i].value;
			}
		}
	} else if (mobileBOPISShipModeId != "" && mobileBOPISStoreId != "") {
		result = "pickUp";
	}
	return result;
}
function validateBOPISParameters() {
	var shipModeIdBOPIS = "";
	var physicalStoreLocationId = "";
	var orderItemId = "";
	if (document.getElementById("shipmodeForm") && PhysicalStoreCookieJS) {
		shipModeIdBOPIS = document.getElementById("shipmodeForm").BOPIS_shipmode_id.value;
		if (PhysicalStoreCookieJS.getStoreIdsFromCookie().indexOf(",") == -1) {
			physicalStoreLocationId = PhysicalStoreCookieJS.getStoreIdsFromCookie();
		}
		orderItemId = document.getElementById("OrderFirstItemId").value;
		return !this.isEmpty(shipModeIdBOPIS) && !this.isEmpty(physicalStoreLocationId) && !this.isEmpty(orderItemId);
	}
}

function updateOrderForBOPIS() {
	return new Promise(function(resolve, reject) {
		var updateBOPIS = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter() + getBOPISParameters(),
			async: false
		});
		if (updateBOPIS.status === STATUS_SUCCESS) {
			currentOrderId = updateBOPIS.data.orderId;
			resolve(updateBOPIS);
		}
		else {
			reject(updateBOPIS);
		}
	});
}

function updateShipMode() {
	if (showDebug) {
		console.log("In updateShipMode");
	}
	return new Promise(function(resolve, reject) {
		var updateShipModeId = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxApplePayOrderUpdate?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter() + getDefaultShippingParameter(),
			async: false
		});
		if (updateShipModeId.status === STATUS_SUCCESS) {
			currentOrderId = updateShipModeId.data.orderId;
			resolve(updateShipModeId);
		}
		else {
			reject(updateShipModeId);
		}
	});
}

function addUnboundPI() {
	if (showDebug) {
		console.log("In addUnboundPI");
	}
	return new Promise(function(resolve, reject) {
		var addUnboundPICall = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxRESTOrderPIAdd?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter() + '&payMethodId=ApplePay&unbound=true',
			async: false
		});
		if (addUnboundPICall.status === STATUS_SUCCESS) {
			unboundPIId = addUnboundPICall.data.paymentInstruction[0].piId;
			resolve(addUnboundPICall);
		}
		else {
			reject(addUnboundPICall);
		}
	});
}

function prepareOrder() {
	if (showDebug) {
		console.log("In prepareOrder");
	}
	return new Promise(function(resolve, reject) {
		var applePayPrepare = simpleAjax({
			requestType: 'POST',
			requestUrl: getAbsoluteURL() + 'AjaxRESTOrderPrepare?',
			requestParameters: getCommonParameters() + getAuthTokenUrlParameter() + getOrderIdUrlParameter(),
			async: false
		});
		if (applePayPrepare.status === STATUS_SUCCESS) {
			if (showDebug) {
				console.log("Successful order prepare - " + applePayPrepare.data.orderId);
			}
			currentOrderId = applePayPrepare.data.orderId;
			resolve(applePayPrepare);
		}
		else {
			reject(applePayPrepare);
		}
	});
}
function retrieveWCOrderInformation() {
	if (showDebug) {
		console.log("In retrieveWCOrderInformation");
	}
	var urlParameters = "";
	if (getIsReturnDefaults() === "true") {
		urlParameters = getCommonParameters() + getBOPISParameters() + getIsReturnDefaultsParameter();
	} else {
		urlParameters = getCommonParameters() + getOrderIdUrlParameter() + getBOPISParameters() + getIsReturnDefaultsParameter();
	}
	return new Promise(function(resolve, reject) {
		var wcOrderInfo = simpleAjax({
			requestType: 'GET',
			requestUrl: getAbsoluteURL() + 'GetOrderInfoForApplePayV2?',
			requestParameters: urlParameters,
			async: false
		});
		if (wcOrderInfo.status === STATUS_SUCCESS) {
			if (wcOrderInfo.data.defaultShipModeId) {
				shipModeValid = false;
				defaultShipModeId = wcOrderInfo.data.defaultShipModeId;
				defaultAddressId = wcOrderInfo.data.defaultAddressId;
			} else {
				shipModeValid = true;
				paymentRequest = wcOrderInfo.data;
			}
			if (showDebug) {
				console.log("shipModeValid - " + shipModeValid);
			}
			resolve(wcOrderInfo);
		}
		else {
			reject(wcOrderInfo);
		}
	});
}

function showConfirmation() {
	if (showDebug) {
		console.log("In showConfirmation");
	}
	document.location.href = appendWcCommonRequestParameters("OrderShippingBillingConfirmationView?" + getCommonParameters() + getOrderIdUrlParameter());
}
function displayError(location, error, customMessage) {
	console.log("Error in " + location);
	console.log(JSON.stringify(error.error));
	if (typeof error.args !== 'undefined') {
		if (showDebug) {
			console.log(JSON.stringify(error.args));
		}
	}
	MessageHelper.displayErrorMessage(customMessage ? customMessage : error.error.errorMessage);

}
function abortSession(e) {
	var promise = cancelApplePayOrder();
	promise.then(function(success) {
		if (showDebug) {
			console.log('Order cancel success');
		}
	}, function(error) {
		displayError(CANCEL_METHOD, error);
	});
	session.abort();
}
//
// Global WC reusable task methods - END
//
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

OnBehalfUtilities = function(){

	this.startCustomerService = function(node){
		var URL = node.getAttribute("data-customer-service-url");
		var buyOnBehalfName = getCookie("WC_BuyOnBehalf_"+WCParamJS.storeId);
		if(CSRWCParamJS.env_shopOnBehalfSessionEstablished === "true" && CSRWCParamJS.env_shopOnBehalfEnabled_CSR === "true"){
			//onbehalf session established by CSR. Show warning dialog before terminating it.
			wcTopic.subscribeOnce("onBehalfSessionTerminate", function(data){
				if (data.action === "YES"){
					document.location.href = URL;
				}
				if(data.action === "NO"){
				}
			});
			MessageHelper.showConfirmationDialog("onBehalfSessionTerminate",
						Utils.getLocalizationMessage('CSR_SESSION_TERMINATE_WARNING_MESSAGE', {0: escapeXml(buyOnBehalfName, true)}));
		} else {
			// Customer session is not yet started. Redirect to landing page.
			document.location.href = URL;
		}
	};

	this.updateUIAndRenderContext = function(response, masterContextName){
		
		//masterContextName - Name of the renderContext which was used to update user Status.
		// userStatus can be updated in FindOrders section or FindRegisteredCustomers section.
		// masterContext will contain the updated data.

		var userId1, userId2, updatedStatusOrder, updatedStatusUser = null;
		var contextExist = wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContext");
		if (contextExist) {
			userId1 = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContext")["userId"];
			updatedStatusUser = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContext")[userId1+"_userStatus"];
		}
		
		contextExist = wcRenderContext.checkIdDefined("UserRegistrationAdminUpdateStatusContextCSR");
		if(contextExist) {
			userId2 = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContextCSR")["userId"];
			updatedStatusOrder = wcRenderContext.getRenderContextProperties("UserRegistrationAdminUpdateStatusContextCSR")[userId2+"_userStatus"];
		}

		var updatedStatus = null;
		var userId = null;
		if(masterContextName === "UserRegistrationAdminUpdateStatusContext"){
			updatedStatus = updatedStatusUser;
			userId = userId1;
		} else if(masterContextName === "UserRegistrationAdminUpdateStatusContextCSR") {
			updatedStatus = updatedStatusOrder;
			userId = userId2;
		}

		// Save it in context for future use.
		if(typeof(renderContextUser) !== 'undefined'){
			renderContextUser.properties[userId+"_updatedStatus"] = updatedStatus; 
		}
		if(typeof(renderContextOrder) !== 'undefined'){
			renderContextOrder.properties[userId+"_updatedStatus"] = updatedStatus; 
		}

		
		var userStatusText = Utils.getLocalizationMessage('DISABLE_CUSTOMER_ACCOUNT');
		if(updatedStatus === '0'){
			userStatusText = Utils.getLocalizationMessage('ENABLE_CUSTOMER_ACCOUNT');
		}
		// Update widget text...
		var toggleUserStatusControl = $("div[data-toggle-userStatus = 'userStatus_" + userId + "']");
		toggleUserStatusControl.forEach(function(node, index, arr){
			node.innerHTML = userStatusText;
		});
	};


	this.cancelOrder = function(orderId, reloadURL, onBehalf, authToken){
		//TODO - do we need forced cancel. ?
		wcRenderContext.getRenderContextProperties("onBehalfCommonContext")['cancelReloadURL'] = reloadURL;

		var service = wcService.getServiceById('AjaxCancelOrderAdministrator');
		if(onBehalf != null && onBehalf === 'true'){
			service.setUrl(getAbsoluteURL() +  "AjaxRESTCSROrderCancelOnbehalf");
		} else {
			service.setUrl(getAbsoluteURL() +  "AjaxRESTCSROrderCancelAsAdmin");
		}
		
		var params = [];
		params.orderId = orderId;
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;
		params["forcedCancel"] = "true";
		
		wcService.invoke("AjaxCancelOrderAdministrator", params);
	
	};

	this.unLockOrder = function(orderId, forceUnlock){
		if(forceUnlock != null && forceUnlock !== "" && forceUnlock === 'true'){
			// The order is locked by someone.. Need to first take over the lock and then unlock.
			this.takeOverLock(orderId, 'true');
			var removeHandler = wcTopic.subscribe("orderTakeOverSuccess", function(data){
				removeHandler.remove();
				// Now unlock the order.
				onBehalfUtilitiesJS.unLockOrder(orderId, "false");
			});

			return;
		}
		var service = this.getLockUnLockCartService('AjaxRESTOrderLockUnlockOnBehalf', getAbsoluteURL()+'AjaxRESTOrderUnlockOnBehalf', 'SUCCESS_ORDER_UNLOCK');
		var params = [];
		params["orderId"] = orderId;
		params["filterOption"] = "All";
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;	

		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke(service.getParam("id"), params);
	};

	this.lockOrder = function(orderId){
		var service = this.getLockUnLockCartService('AjaxRESTOrderLockUnlockOnBehalf', getAbsoluteURL()+'AjaxRESTOrderLockOnBehalf', 'SUCCESS_ORDER_LOCK');
		var params = [];
		params["orderId"] = orderId;
		params["filterOption"] = "All";
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;	

		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke(service.getParam("id"), params);
	};


	this.takeOverLock = function(orderId,publishTopic){
		var service = this.getLockUnLockCartService('AjaxRESTOrderLockUnlockOnBehalf', getAbsoluteURL()+'AjaxRESTOrderLockTakeOverOnBehalf',
				'SUCCESS_ORDER_TAKE_OVER', publishTopic);
		var params = [];
		params["orderId"] = orderId;
		params["filterOption"] = "All";
		params["takeOverLock"] = "Y"
		params["storeId"] = WCParamJS.storeId;
		params["catalogId"] = WCParamJS.catalogId;
		params["langId"] = WCParamJS.langId;	

		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcService.invoke(service.getParam("id"), params);
	};

	this.getLockUnLockCartService = function(actionId,url,messageKey,publishTopic){

		var service = wcService.getServiceById('AjaxRESTOrderLockUnlockOnBehalf');

		if(service == null || service === undefined){

			wcService.declare({
				id: "AjaxRESTOrderLockUnlockOnBehalf",
				actionId: "AjaxRESTOrderLockUnlockOnBehalf",
				url: "",
				formId: "",
				successMessageKey:"",
				publishTopic:""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					cursor_clear();
					if(service.getParam("publishTopic") === 'true'){
						wcTopic.publish("orderTakeOverSuccess", serviceResponse);
						return;
					}
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(Utils.getLocalizationMessage(service.getParam("successMessageKey")));
					setDeleteCartCookie(); // Mini Cart cookie should be refreshed to display updated cart lock status....
					if($('#quick_cart_container').length) {
						$('#quick_cart_container').hide();
					}
				}
				
				/**
				 * Displays an error message on the page if the request failed.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
				 */
				,failureHandler: function(serviceResponse) {
					if (serviceResponse.errorMessage) {
						MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
					} else {
						if (serviceResponse.errorMessageKey) {
							MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
						}
					}
				}
			});
			service = wcService.getServiceById('AjaxRESTOrderLockUnlockOnBehalf');
		}
		if(actionId != null && actionId !== 'undefined'){
			service.setActionId(actionId);
		}
		if(messageKey != null && messageKey !== 'undefined'){
			service.setParam("successMessageKey", messageKey);
		}
		if(publishTopic != null && publishTopic !== 'undefined'){
			service.setParam("publishTopic", publishTopic);
		} else {
			service.setParam("publishTopic", null);
		}
		if(url != null && url !== 'undefined'){
			service.setUrl(url);
		} else {
			service.setUrl(null);
		}
		return service;
	};
};


$(document).ready(function() {
	onBehalfUtilitiesJS = new OnBehalfUtilities();
});

wcRenderContext.declare("onBehalfCommonContext", [], {});
wcRenderContext.declare("orderLockStatusContext", ["orderLockStatusRefreshArea"], {});

var declareOrderLockStatusRefreshArea = function(){
	// ============================================
	// div: orderLockStatusRefreshArea refresh area
	// Declares a new refresh controller for the fetching order Lock status.
	var myWidgetObj = $("#orderLockStatusRefreshArea");
	myWidgetObj.refreshWidget("updateUrl", getAbsoluteURL() + "OrderLockStatusView?" + getCommonParametersQueryString());
	var myRCProperties = wcRenderContext.getRenderContextProperties("orderLockStatusContext");

	// model change
	wcTopic.subscribe("AjaxRESTOrderLockUnlockOnBehalf", function() {
		console.debug("modelChangedHandler of orderLockStatusController");
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	var postRefreshHandler = function () {
		console.debug("Post refresh handler of orderLockStatus");
		cursor_clear();
	};

	// initialize widget
	myWidgetObj.refreshWidget({postRefreshHandler: postRefreshHandler});
};

wcService.declare({
	id: "AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer",
	actionId: "AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer",
	url: getAbsoluteURL() +  "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("RESET_PASSWORD_SUCCESS"));
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		 var errorMessage = Utils.getLocalizationMessage(serviceResponse.errorMessageKey);
		 if(errorMessage == null){
			if (serviceResponse.errorMessage) {
				errorMessage = serviceResponse.errorMessage;
			} else if (serviceResponse.errorMessageKey) {
				errorMessage = serviceResponse.errorMessageKey;
			}
		 }
		MessageHelper.displayErrorMessage(errorMessage);
	}

});

wcService.declare({
	id: "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	actionId: "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	url: getAbsoluteURL() +  "AjaxRESTMemberPasswordResetByAdminOnBehalf",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("RESET_PASSWORD_SUCCESS"));
		if(typeof(registeredCustomersJS) !== 'undefined'){
			registeredCustomersJS.onResetPasswordByAdminSuccess();
		}
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		var errorMessage = "";
		if(typeof(registeredCustomersJS) !== 'undefined'){
			 errorMessage = Utils.getLocalizationMessage(serviceResponse.errorMessageKey);
			 if(errorMessage == null){
				if (serviceResponse.errorMessage) {
					errorMessage = serviceResponse.errorMessage;
				} else if (serviceResponse.errorMessageKey) {
					errorMessage = serviceResponse.errorMessageKey;
				}
			 }
			registeredCustomersJS.onResetPasswordByAdminError(errorMessage,serviceResponse);
		}
	}

});

wcService.declare({
	id: "AjaxRESTMemberPasswordResetByAdmin",
	actionId: "AjaxRESTMemberPasswordResetByAdmin",
	url: getAbsoluteURL() +  "AjaxRESTMemberPasswordResetByAdmin",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("RESET_PASSWORD_SUCCESS"));
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("ERROR_RESET_PASSWORD_ACCESS_ACCOUNT_TO_RESET"));
	}

});

wcService.declare({
	id: "AjaxCancelOrderAdministrator",
	actionId: "AjaxCancelOrderAdministrator",
	url: getAbsoluteURL() +  "AjaxRESTCSROrderCancelAsAdmin"+"?"+getCommonParametersQueryString()+"&forcedCancel=true",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORDER_CANCEL_SUCCESS"));
        var reloadURL = wcRenderContext.getRenderContextProperties("onBehalfCommonContext")['cancelReloadURL'];
		if(reloadURL !== '' && typeof(reloadURL) !== 'undefined'){
			document.location.href = reloadURL;
		} else {
			window.location.reload(1);
		}
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} else {
			if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			}
		}
	}

});
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


widgetCommonJS = {
    toggleDisplay: function(divId){
        if ($("#"+divId).css("display") === "none") {
            $("#"+divId).css("display", "block");
        } else {
            $("#"+divId).css("display", "none");
        }
    },

    toggleCustomCheckBox: function(cssClassForQuery,cssClassToToggle,node){
        $('.'+cssClassForQuery, node).toggleClass(cssClassToToggle);
        if(node.getAttribute("aria-checked") == 'true'){
            node.setAttribute("aria-checked","false");
        } else {
            node.setAttribute("aria-checked","true");
        }
    },

    toggleCustomCheckBoxKeyPress: function(cssClassForQuery,cssClassToToggle,node,event){
        var charOrCode = event.charCode || event.keyCode;
        console.debug(charOrCode);
        if (charOrCode == KeyCodes.SPACE) { 
            widgetCommonJS.toggleCustomCheckBox(cssClassForQuery,cssClassToToggle,node);
        }
    },

    toggleReadEditSection:function(editSectionId,showSection){
        var overlay = $("#overlay");
        var editSectionMain = $("#"+editSectionId+"Main");

        if(showSection == 'edit'){
            $('#'+editSectionId).css('display', 'block');
            $("#"+editSectionId+'Icon').css('display', 'none');
            $("#"+editSectionId+'Read').css('display','none');

            if (overlay){
                $(overlay).removeClass("nodisplay");
            }
            $(editSectionMain).addClass("editView lightedSection");
        } else if(showSection == 'read'){
            $('#'+editSectionId).css('display', 'none');
            $('#'+editSectionId+'Icon').css('display', 'inline-block');
            $("#"+editSectionId+'Read').css('display','block');

            if (overlay){
                $(overlay).addClass("nodisplay");
            }
            $(editSectionMain).removeClass("lightedSection editView");
        }
    },
    focusDiv: function(divId){
        $("#"+divId).addClass("dottedBorder");
    },

    blurDiv: function(divId){
        $("#"+divId).removeClass("dottedBorder");
    },
    
    toggleEditSection: function(target){
        $(target).toggleClass("readOnly editView");
        
        var editField = $(target).find(".editField");
        var readField = $(target).find(".readField");
        var overlay = $("#overlay");
        if ($(target).hasClass("readOnly")){
            $(editField).attr("aria-hidden", "true");
            $(readField).removeAttr("aria-hidden");
            $(target).removeClass("lightedSection")
            if (overlay){
                overlay.addClass("nodisplay");
            }
        }else {
            $(readField).attr("aria-hidden", "true");
            $(editField).removeAttr("aria-hidden");
            $(target).addClass("lightedSection")
            if (overlay){
                overlay.removeClass("nodisplay");
            }
        }
    },
    
    //can be invoked by postRefreshHandler upon update
    removeSectionOverlay: function(){
        var overlay = $("#overlay");
        if (overlay){
            $(overlay).addClass("nodisplay");
        }
    },
    
    redirect:function(url, queryParams){
        if(queryParams != null && queryParams != 'undefined'){
            if(url.indexOf('?') > -1){
                url = url +"&"+queryParams;
            } else {
                url = url +"?"+queryParams;
            }
        }
        document.location.href = url;
    },
    
    initializeEditSectionToggleEvent: function (){
        //toggle edit and readonly sections, see organization user info widget
    	Utils.onOnce($(".pageSection .pageSectionTitle .editIcon[data-section-toggle]"), "click", "EditSection", function(e){
            var target = this.getAttribute("data-section-toggle");
            widgetCommonJS.toggleEditSection(document.getElementById(target));
            Utils.stopEvent(e);
        });
        //cancle button
    	Utils.onOnce($(".pageSection .editField .button_footer_line a[data-section-toggle]"), "click", "EditSection", function(e){
            var target = this.getAttribute("data-section-toggle");
            widgetCommonJS.toggleEditSection(document.getElementById(target));
            var data = {"target": target};
            wcTopic.publish("sectionToggleCancelPressed", data);
            Utils.stopEvent(e);
        });
    }
};
	
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


if (typeof (AutoSKUSuggestJS) == "undefined" || AutoSKUSuggestJS == null || !AutoSKUSuggestJS) {

    AutoSKUSuggestJS = {

        /**
         * This variable controls the timer handler before triggering the autoSuggest.  If the user types fast, intermittent requests will be cancelled.
         * The value is initialized to -1.
         */
        autoSuggestSKUTimer: -1,

        /**
         * This variable controls the delay of the timer in milliseconds between the keystrokes before firing the search request.
         * The value is initialized to 400.
         */
        autoSuggestSKUKeystrokeDelay: 400,

        /**
         * This variable indicates whether or not the user is hovering over the autoSuggest results popup display.
         * The value is initialized to false.
         */
        skuAutoSuggestHover: false,

        /**
         * This variable stores the old search term used in the auto suggest search box
         * The value is initialized to empty string.
         */
        skuAutoSuggestPreviousTerm: "",

        /**
         * This variable stores the index of the selected auto suggestion item when using up/down arrow keys.
         * The value is initialized to -1.
         */
        autoSelectOption: -1,

        /**
         * This variable stores the index offset of the first previous history term
         * The value is initialized to -1.
         */
        historyIndex: -1,

        /**
         * This variable controls when to trigger the auto suggest box.  The number of characters greater than this threshold will trigger the auto suggest functionality.
         * The static/cached auto suggest will be performed if this threshold is exceeded.
         * The value is initialized to 0.
         */
        AUTOSUGGEST_THRESHOLD: 0,

        /**
         * This variable controls when to trigger the dynamic auto suggest.  The number of characters greater than this threshold will trigger the request for keyword search.
         * The static/cached auto suggest will be be displayed if the characters exceed the above config parameter, but exceeding this threshold will additionally perform the dynamic search to add to the results in the static/cached results.
         * This value should be greater or equal than the AUTOSUGGEST_THRESHOLD, as the dynamic autosuggest is secondary to the static/cached auto suggest.
         * The value is initialized to 0.
         */
        DYNAMIC_AUTOSUGGEST_THRESHOLD: 0,

        /**
         * URL to retrieve auto suggest keywords
         */
        SearchAutoSuggestServletURL: "",

        /**
         * Timeout variable for suggestions dropdown list
         */
        searchSuggestionHoverTimeout: "",

        /**
         * Suffix for the SKU type ahead id
         */
        suffix: "",

        /**
         * SKU type ahead input field id
         */
        inputField: "",

        /**
         * SKU type ahead add button
         */
        addButton: "",

        /**
         * SKU type ahead add button text
         */
        addButtonText: "",

        /**
         * SKU type ahead add button CSS
         */
        addButtonDisableCss: "",

        /**
         * SKU type ahead add button text CSS
         */
        addButtonTextDisableCss: "",

        init: function (inputField) {
        	if(inputField != "" && $("#" + inputField).length) {
        		$("#" + inputField).on("focus", $.proxy(AutoSKUSuggestJS._onFocus, AutoSKUSuggestJS));
        		$("#" + inputField).on("blur", $.proxy(AutoSKUSuggestJS._onBlur, AutoSKUSuggestJS));
        		$("#" + inputField).on("keyup", $.proxy(AutoSKUSuggestJS._onKeyUp, AutoSKUSuggestJS));
        	}
        },

        setAddButton: function (addButton, addButtonText, addButtonDisableCss, addButtonTextDisableCss) {
            this.addButton = addButton;
            this.addButtonText = addButtonText;
            this.addButtonDisableCss = addButtonDisableCss;
            this.addButtonTextDisableCss = addButtonTextDisableCss;
        },

        showSKUSearchComponent: function () {
            var srcElement = document.getElementById("autoSuggestBySKU_Result_div" + this.suffix);
            if (srcElement != null) {
                srcElement.style.display = 'block';
            }
        },

        setAutoSuggestURL: function (url) {
            this.SearchAutoSuggestServletURL = getAbsoluteURL() + url;
        },

        _onFocus: function (evt) {
            var target = evt.target || evt.srcElement;
            this.inputField = target.id;
            this.suffix = "_" + target.id;
            var inputFieldElement = document.getElementById(this.inputField);
            if (inputFieldElement != null && !this.isEmpty(inputFieldElement.value)) {
                this.showSKUSearchComponent();
            }
        },

        _onBlur: function (evt) {
            var target = evt.target || evt.srcElement;
            this.inputField = target.id;
            this.suffix = "_" + target.id;
            clearTimeout(this.searchSuggestionHoverTimeout);
            this.searchSuggestionHoverTimeout = setTimeout("AutoSKUSuggestJS.showSKUAutoSuggest(false)", 200);
        },

        _onKeyUp: function (evt) {
            var target = evt.target || evt.srcElement;
            this.inputField = target.id;
            this.suffix = "_" + target.id;
            var srcElement = document.getElementById("autoSuggestBySKU_Result_div" + this.suffix);
            srcElement.style.display = 'block';
            this.doSKUAutoSuggest(evt, this.SearchAutoSuggestServletURL, document.getElementById(this.inputField).value);
        },

        doDynamicSKUAutoSuggest: function (url, searchTerm) {
            // if pending autosuggest triggered, cancel it.
            if (this.skuAutoSuggestSKUTimer != -1) {
                clearTimeout(this.skuAutoSuggestSKUTimer);
                this.skuAutoSuggestSKUTimer = -1;
            };

            // call the auto suggest
            this.skuAutoSuggestSKUTimer = setTimeout(function () {
                $("#autoSuggestBySKU_Result_div" + AutoSKUSuggestJS.suffix).refreshWidget("updateUrl", url + "&term=" + encodeURIComponent(searchTerm) + "&suffix=" + encodeURIComponent(AutoSKUSuggestJS.suffix));
                console.debug("update autosuggest " + url);
                wcRenderContext.updateRenderContext("AutoSuggestSKU_Context", {});
                this.skuAutoSuggestSKUTimer = -1;
            }, this.skuAutoSuggestSKUKeystrokeDelay);
        },

        showSKUAutoSuggest: function (display) {
            var autoSuggest_Result_div = document.getElementById("autoSuggestBySKU_Result_div" + this.suffix);
            if (autoSuggest_Result_div != null && autoSuggest_Result_div != 'undefined') {
                if (display) {
                    autoSuggest_Result_div.style.display = "block";
                } else {
                    autoSuggest_Result_div.style.display = "none";
                }
            }
        },

        showSKUAutoSuggestIfResults: function () {
            // if no results, hide the autosuggest box
            var scrElement = document.getElementById("skuAddSearch" + this.suffix);
            if (scrElement == null) {
                if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null && !$("#" + this.addButton).hasClass("formButtonDisabled") && !$("#" + this.addButtonText).hasClass("formButtonGreyOut")) {
                    $("#" + this.addButton).addClass("formButtonDisabled");
                    $("#" + this.addButtonText).addClass("formButtonGreyOut");
                }
            } else {
                if (document.getElementById("enableAddButton" + this.suffix) != null && document.getElementById("enableAddButton" + this.suffix).value == "false") {
                    if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null && !$("#" + this.addButton).hasClass("formButtonDisabled") && !$("#" + this.addButtonText).hasClass("formButtonGreyOut")) {
                        $("#" + this.addButton).addClass("formButtonDisabled");
                        $("#" + this.addButtonText).addClass("formButtonGreyOut");
                    }
                } else if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null && $("#" + this.addButton).hasClass("formButtonDisabled") && $("#" + this.addButtonText).hasClass("formButtonGreyOut")) {
                    $("#" + this.addButton).removeClass("formButtonDisabled");
                    $("#" + this.addButtonText).removeClass("formButtonGreyOut");
                }
            }
            if (scrElement != null && scrElement.style.display == 'block') {
                if (document.getElementById(this.inputField).value.length <= this.AUTOSUGGEST_THRESHOLD) {
                    this.showSKUAutoSuggest(false);
                } else {
                    this.showSKUAutoSuggest(true);
                }
            }
        },

        selectAutoSuggest: function (term) {
            var scrElement = document.getElementById("skuAddSearch" + this.suffix);
            if (scrElement != null && scrElement.style.display == 'block') {
                var searchBox = document.getElementById(this.inputField);
            }
            searchBox.value = term;
            searchBox.focus();
            this.skuAutoSuggestPreviousTerm = term;
            if (document.getElementById(this.addButton) != null && document.getElementById(this.addButtonText) != null && $("#" + this.addButton).hasClass("formButtonDisabled") && $("#" + this.addButtonText).hasClass("formButtonGreyOut")) {
                $("#" + this.addButton).removeClass("formButtonDisabled");
                $("#" + this.addButtonText).removeClass("formButtonGreyOut");
            }
            this.showSKUAutoSuggest(false);
        },

        highLightSelection: function (state, index) {
            var selection = document.getElementById("skuAutoSelectOption_" + index + this.suffix);
            if (selection != null && selection != 'undefined') {
                if (state) {
                    selection.className = "autoSuggestSelected";
                    var scrElement = document.getElementById("skuAddSearch" + this.suffix);
                    if (scrElement != null && scrElement.style.display == 'block') {
                        var searchBox = document.getElementById(this.inputField);
                    }
                    searchBox.setAttribute("aria-activedescendant", "suggestionSKU_" + index);
                    var totalDynamicResults = document.getElementById("dynamicAutoSuggestSKUTotalResults" + this.suffix);
                    if ((totalDynamicResults != null && totalDynamicResults != 'undefined' && index < totalDynamicResults.value) || (index >= this.historyIndex)) {
                        searchBox.value = selection.title;
                        this.skuAutoSuggestPreviousTerm = selection.title;
                    }
                } else {
                    selection.className = "skuSearchItem";
                }
                return true;
            } else {
                return false;
            }
        },

        resetSKUAutoSuggestKeyword: function () {
            var originalKeyedSearchTerm = document.getElementById("autoSuggestSKUOriginalTerm" + this.suffix);
            if (originalKeyedSearchTerm != null && originalKeyedSearchTerm != 'undefined') {
                var scrElement = document.getElementById("skuAddSearch" + this.suffix);
                if (scrElement != null && scrElement.style.display == 'block') {
                    var searchBox = document.getElementById(this.inputField);
                }
                searchBox.value = originalKeyedSearchTerm.value;
                this.skuAutoSuggestPreviousTerm = originalKeyedSearchTerm.value;
            }
        },


        clearSKUAutoSuggestResults: function () {
            this.showSKUAutoSuggest(false);
        },

        doSKUAutoSuggest: function (event, url, searchTerm) {
            if (searchTerm.length <= this.AUTOSUGGEST_THRESHOLD) {
                this.showSKUAutoSuggest(false);
            }

            if (event.keyCode === KeyCodes.TAB) {
                this.showSKUAutoSuggest(false);
                return;
            }

            if (event.keyCode === KeyCodes.ESCAPE) {
                this.showSKUAutoSuggest(false);
                return;
            }

            if (event.keyCode === KeyCodes.RETURN) {
                var searchBox = document.getElementById(this.inputField);
                if (searchBox != null) {
                    AutoSKUSuggestJS.selectAutoSuggest(searchBox.value);
                }
                return;
            }

            if (event.keyCode === KeyCodes.UP_ARROW) {
                if (this.highLightSelection(true, this.autoSelectOption - 1)) {
                    this.highLightSelection(false, this.autoSelectOption);
                    if (this.autoSelectOption == this.historyIndex) {
                        this.resetSKUAutoSuggestKeyword();
                    }
                    this.autoSelectOption--;
                }
                return;
            }

            if (event.keyCode === KeyCodes.DOWN_ARROW) {
                if (this.highLightSelection(true, this.autoSelectOption + 1)) {
                    this.highLightSelection(false, this.autoSelectOption);
                    this.autoSelectOption++;
                }
                return;
            }

            if (searchTerm.length > this.AUTOSUGGEST_THRESHOLD && searchTerm == this.skuAutoSuggestPreviousTerm) {
                return;
            } else {
                this.skuAutoSuggestPreviousTerm = searchTerm;
            }

            if (searchTerm.length <= this.AUTOSUGGEST_THRESHOLD) {
                return;
            };

            // cancel the dynamic search if one is pending
            if (this.skuAutoSuggestSKUTimer != -1) {
                clearTimeout(this.skuAutoSuggestSKUTimer);
                this.skuAutoSuggestSKUTimer = -1;
            }

            if (searchTerm != "") {
                this.autoSelectOption = -1;
                if (searchTerm.length > this.DYNAMIC_AUTOSUGGEST_THRESHOLD) {
                    this.doDynamicSKUAutoSuggest(url, searchTerm);
                } else {
                    // clear the dynamic results
                    document.getElementById("autoSuggestBySKU_Result_div" + this.suffix).innerHTML = "";
                }
            } else {
                this.clearSKUAutoSuggestResults();
            }
        },

        /**
         * Checks if a string is null or empty.
         * @param (string) str The string to check.
         * @return (boolean) Indicates whether the string is empty.
         */
        isEmpty: function (str) {
            var reWhiteSpace = new RegExp(/^\s+$/);
            if (str == null || str == '' || reWhiteSpace.test(str)) {
                return true;
            }
            return false;
        },


        /**
         * Declares a new render context for the AutoSuggest display.
         */


        autoSKUSuggest_controller_initProperties: function (suffix) {
            if (!wcRenderContext.checkIdDefined("AutoSuggestSKU_Context")) {
                wcRenderContext.declare("AutoSuggestSKU_Context", [], "");
            }
            var myWidgetObj = $("#autoSuggestBySKU_Result_div" + suffix);
            wcRenderContext.addRefreshAreaId("AutoSuggestSKU_Context", "autoSuggestBySKU_Result_div" + suffix);
            var myRCProperties = wcRenderContext.getRenderContextProperties("AutoSuggestSKU_Context");
            
            /**
             * Displays the keyword suggestions from the search index
             * This function is called when a render context changed event is detected.
             */
            var renderContextChangedHandler = function () {
                if (myWidgetObj.attr('id') == "autoSuggestBySKU_Result_div" + AutoSKUSuggestJS.suffix) {
                    myWidgetObj.refreshWidget("refresh", myRCProperties);
                }
            },

            /**
             * Display the results.
             */
            postRefreshHandler = function () {
                AutoSKUSuggestJS.showSKUAutoSuggestIfResults();
            }
            
            myWidgetObj.refreshWidget({
                renderContextChangedHandler: renderContextChangedHandler,
                postRefreshHandler: postRefreshHandler
            });
        }
    }
};
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------
/* global document, window, jQuery, KeyCodes, Utils, handleMouseDown, showMenu, hideMenu, 
toggleMenu, toggleExpand, eventActionsInitialization, toggleExpandedContent, toggleMobileView */

(function ($) {
    var activeMenuNode = null;
    var toggleControlNode = null;
    var NAMESPACE = "MyAccountList"; // Namespace to use for all event handlers in this file

    var registerMouseDown = function () {
        Utils.onOnce($(document.documentElement), "mousedown", NAMESPACE, handleMouseDown);
    };

    var unregisterMouseDown = function () {
        $(document.documentElement).off("mousedown." + NAMESPACE);
    };

    showMenu = function (target) {

        //Ensure All menus are closed on list table
        $("div.listTable a[table-parent='listTable']").each(function (i, node) {
            hideMenu(node);
        });

        $("div.listTable div[table-parent='listTable']").each(function (i, node) {
            hideMenu(node);
        });

        $("div.listTable form[table-parent='listTable']").each(function (i, node) {
            hideMenu(node);
        });

        $(target).addClass("active");
	activeMenuNode = target;
        var toggleControl = $("div.listTable a[table-toggle='" + target.id + "']");
        toggleControl.addClass("clicked");
        toggleControlNode = toggleControl[0];
        registerMouseDown();
    };

    hideMenu = function (target) {
        $(target).removeClass("active");
        $("div.listTable a[table-toggle='" + target.id + "']").removeClass("clicked");
        unregisterMouseDown();
        activeMenuNode = null;
        toggleControlNode = null;
    };

    handleMouseDown = function (evt) {
        if (activeMenuNode !== null) {
            var node = evt.target;
            if (node != document.documentElement) {
                var close = true;
                while (node && node != document.documentElement) {
                    if (node == activeMenuNode || node == toggleControlNode || $(node).hasClass("dijitPopup")) {
                        close = false;
                        break;
                    }
                    node = node.parentNode;
                }
                if (node === null) {
                    $("div", activeMenuNode).each(function (i, child) {
                        var position = Utils.position(child);
						if (evt.clientX >= position.left && evt.clientX < position.left + position.width() &&
							evt.clientY >= position.top && evt.clientY < position.top + position.height()) {
                            close = false;
                            return false; // breaks
                        }
                    });
                }
                if (close) {
                    hideMenu(activeMenuNode);
                }
            }
        }
    };

    toggleMenu = function (target) {
        if ($(target).hasClass("active")) {
            hideMenu(target);
        } else {
            showMenu(target);
        }
    };

    toggleExpand = function (target) {
        $("div.listTable div[row-expand]").each(function (i, node) {
            var resetNodeId = $(node).attr("row-expand");
            var resetNodeElement = document.getElementById(resetNodeId);
            if (resetNodeElement != target) {
                Utils.replaceAttr($(resetNodeElement), "src", function (oldSrc) {
                    return oldSrc.replace("sort_arrow_DN.png", "sort_arrow_OFF.png")
                        .replace("sort_arrow_UP.png", "sort_arrow_OFF.png");
                });
                $(resetNodeElement).removeClass("active");
            }
        });
        var $target = $(target);
        if ($target.hasClass("active")) {
            $target.removeClass("active");
            Utils.replaceAttr($target, "src", function (oldSrc) {
                return oldSrc.replace("sort_arrow_OFF.png", "sort_arrow_UP.png")
                    .replace("sort_arrow_DN.png", "sort_arrow_UP.png");
            });
        } else {
            $target.addClass("active");
            Utils.replaceAttr($target, "src", function (oldSrc) {
                return oldSrc.replace("sort_arrow_OFF.png", "sort_arrow_DN.png")
                    .replace("sort_arrow_UP.png", "sort_arrow_DN.png");
            });
        }
    };

    eventActionsInitialization = function () {
        Utils.onOnce($(document), "click", NAMESPACE, "div.listTable div[row-expand]", function (e) {
            var target = $(this).attr("row-expand");
            toggleExpand(document.getElementById(target));
            Utils.stopEvent(e);
        });

        Utils.onOnce($(document), "click", NAMESPACE, "div.listTable a[table-toggle]", function (e) {
            var target = $(this).attr("table-toggle");
            toggleMenu(document.getElementById(target));
            Utils.stopEvent(e);
        });

        Utils.onOnce($(document), "keydown", NAMESPACE, "div.listTable a[table-toggle]", function (e) {
            if (e.keyCode === KeyCodes.TAB || (e.keyCode === KeyCodes.TAB && e.shiftKey)) {
                var target = $(this).attr("table-toggle");
                if (target !== "newListDropdown" && target !== 'uploadListDropdown') {
                    hideMenu(document.getElementById(target));
                }
            } else if (e.keyCode === KeyCodes.RETURN) {
                var target = $(this).attr("table-toggle");
                toggleMenu(document.getElementById(target));
                Utils.stopEvent(e);
            } else if (e.keyCode === KeyCodes.DOWN_ARROW) {
                var target = $(this).attr("table-toggle");
                toggleMenu(document.getElementById(target));
                var targetElem = document.getElementById(target);
                var targetMenuItem = $('[role*="menuitem"]', targetElem)[0];
                if (targetMenuItem !== null) {
                    targetMenuItem.focus();
                }
                Utils.stopEvent(e);
            }
        });
    };

    /**
     * Toggle mobile view or full view depending on size of the table's container (if < 600, show mobile)
     **/
    toggleMobileView = function () {
        var containerWidth;
        $(".listTable").each(function (i, table) {
            if($(table).parent().parent().width() > 0) {
                containerWidth = $(table).parent().parent().width();
            }
        });
        
        if (containerWidth < 600) {
            $(".fullView").css("display", "none");
            $(".listTableMobile").css("display", "block");
        } else {
            $(".fullView").each(function (i, node) {
                var $node = $(node);
                if (!$node.hasClass("nodisplay")) {
                    $node.css("display", "block");
                }
            });

            $(".listTableMobile").css("display", "none");
        }
    };

    /**
     * Toggle expanded content to show or hide (e.g. when button is clicked)
     * @param widgetName the name of the widget
     * @param row The row on which the expanded content is contained
     **/
    toggleExpandedContent = function (widgetName, row) {
        $('#WC_' + widgetName + '_Mobile_ExpandedContent_' + row).toggleClass('nodisplay');
        $('#WC_' + widgetName + '_Mobile_TableContent_ExpandButton_' + row).toggleClass('nodisplay');
        $('#WC_' + widgetName + '_Mobile_TableContent_CollapseButton_' + row).toggleClass('nodisplay');
    };

    eventActionsInitialization();

    window.setTimeout(function () {

        // the code is shared by ItemTable_UI.jspf, the query for cancel button and newListButton
        // could be empty, use forEach to handle this case.
        $("#newListButton").each(function (i, newListButton) {
            $(newListButton).on("keydown", function (e) {
                if (e.keyCode === KeyCodes.RETURN) {
                    var target = $(this).attr("table-toggle");
                    toggleMenu(document.getElementById(target));
                    var targetElem = document.getElementById(target);
                    $('[class*="input_field"]', targetElem).first().focus();
                    Utils.stopEvent(e);
                }
            });
        });

        $("form.toolbarDropdown > .createTableList > .button_secondary").each(function (i, cancelButton) {
            $(cancelButton).on("keydown", function (e) {
                if (e.keyCode === KeyCodes.TAB || (e.keyCode === KeyCodes.TAB && e.shiftKey)) {
                    var targetId = $(this).attr("id");
                    var newTargetId = targetId.replace("_NewListForm_Cancel", "_NewListForm_Name");
                    $("#" + newTargetId).focus();
                    Utils.stopEvent(e);
                } else if (e.keyCode === KeyCodes.RETURN) {
                    var target = $(this).attr("table-toggle");
                    hideMenu(document.getElementById(target));
                    $("#newListButton").focus();
                    Utils.stopEvent(e);
                }
            });
        });

        $(".actionDropdown").each(function (i, actionMenu) {
            var actionMenuItems = $('[role*="menuitem"]', actionMenu);
            actionMenuItems.each(function (j, actionMenuItem) {
                $(actionMenuItem).on("keydown", function (e) {
                    if (e.keyCode === KeyCodes.TAB) {
                        hideMenu(document.getElementById(actionMenu.getAttribute("id")));
                    } else if (e.keyCode === KeyCodes.UP_ARROW) {
                        actionMenuItems[j === 0 ? actionMenuItems.length - 1 : j - 1].focus();
                        Utils.stopEvent(e);
                    } else if (e.keyCode === KeyCodes.DOWN_ARROW) {
                        actionMenuItems[(j + 1) % actionMenuItems.length].focus();
                        Utils.stopEvent(e);
                    }
                });
            });
        });
    }, 100);
})(jQuery);
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 *@fileOverview This javascript file defines all the javascript functions used by OrderDetail_ItemTable widget
 */

	OrderDetailJS = {
			
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
		
		/**
		* indicates whether the OrderDetail_ItemTable widget is not loaded, expanded or collapsed
		* possible values: "notLoaded", "expanded" or "collapsed"
		*/
		itemTableShown: "notLoaded",

		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 * @param {Integer} orderId The ID of the order.
		 */
		setCommonParameters: function(langId,storeId,catalogId){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
		},
	
		/**
		* By default the order item detail table isn't shown. This function will refresh the area so the table will
		* show.
		*/
		expandCollapseArea:function(){
			if (this.itemTableShown == "notLoaded") {
				/*For Handling multiple clicks. */
				if(!submitRequest()){
					return;
				}	
				cursor_wait();
				wcRenderContext.updateRenderContext('OrderDetailItemTable_Context', {"beginIndex": 0});
				this.itemTableShown = "expanded";
			} else if (this.itemTableShown == "expanded") {
				$("#orderSummaryContainer_plusImage").css("display", "inline");
				$("#orderSummaryContainer_plusImage_link").attr('tabindex', '0');

				$("#orderSummaryContainer_minusImage").css("display", "none");
				$("#orderSummaryContainer_minusImage_link").attr('tabindex', '-1');
				
				$("#OrderDetail_ItemTable_table").css("display", "none");
				this.itemTableShown = "collapsed";
			} else if (this.itemTableShown == "collapsed") {
				$("#orderSummaryContainer_plusImage").css("display", "none");
				$("#orderSummaryContainer_plusImage_link").attr('tabindex', '-1');
				
				$("#orderSummaryContainer_minusImage").css("display", "inline");
				$("#orderSummaryContainer_minusImage_link").attr('tabindex', '0');
				
				$("#OrderDetail_ItemTable_table").css("display", "block");
				this.itemTableShown = "expanded";
			}
		},
		
		/**
		* This function is called when user selects a different page from the current page
		* @param (Object) data The object that contains data used by pagination control 
		*/
		showResultsPage:function(data){
			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			pageNumber = parseInt(pageNumber);
			pageSize = parseInt(pageSize);

			setCurrentId(data["linkId"]);

			if(!submitRequest()){
				return;
			}

			var beginIndex = pageSize * ( pageNumber - 1 );
			cursor_wait();

			wcRenderContext.updateRenderContext('OrderDetailItemTable_Context', {"beginIndex": beginIndex});
			MessageHelper.hideAndClearMessage();
		},
	}//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the Approval List pages to control the refresh areas.
 * @version 1.2
 */

/**
 * Declares a new refresh controller for order approval.
 */
var declareOrderDetailItemTableController = function() {
    var myWidgetObj = $("#OrderDetailItemTable_Widget");
    
    /**
     * Declares a new render context for order approval list table
     */
    wcRenderContext.declare("OrderDetailItemTable_Context", ["OrderDetailItemTable_Widget"], {
        "beginIndex": "0"
    });
    
    myWidgetObj.refreshWidget({
        /** 
        * Displays the previous/next page of order items in order approval details page
        * This function is called when a render context changed event is detected. 
        * 
        * @param {string} message The render context changed event message
        * @param {object} widget The registered refresh area
        */
        renderContextChangedHandler: function () {
            myWidgetObj.refreshWidget("refresh", wcRenderContext.getRenderContextProperties("OrderDetailItemTable_Context"));
        },

        /** 
         * Clears the progress bar
         * 
         * @param {object} widget The registered refresh area
         */
        postRefreshHandler: function(widget) {
            cursor_clear();
            $("#orderSummaryContainer_minusImage_link").focus();
        }
    });
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript defines all the render contexts needed for the Requisition List pages.
 * @version 1.2
 */


/**
 * Declares a new render context for requisition list item table
 */
wcRenderContext.declare("RequisitionListItemTable_Context",["RequisitionListItemTable_Widget"],{"beginIndex":"0","requisitionListId":""},"");//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the Requisition List pages to control the refresh areas.
 * @version 1.2
 */

if (typeof (RequistionListControllerDeclarationJS) == "undefined" || RequistionListControllerDeclarationJS == null || !RequistionListControllerDeclarationJS) {

    RequistionListControllerDeclarationJS = {
        suffix: "",
        /**
         * Declares a new refresh controller for creating a new Requisition List.
         */
        declareRequisitionListItemTableRefreshArea: function () {
            var myWidgetObj = $("#RequisitionListItemTable_Widget"),


                myRCProperties = wcRenderContext.getRenderContextProperties("RequisitionListItemTable_Context");



            wcTopic.subscribe(["requisitionListAddItem", "requisitionListDeleteItem"], function (returnAction) {
                myRCProperties["requisitionListId"] = returnAction.data.requisitionListId[0];
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            });


            var renderContextChangedHandler = function () {
                myWidgetObj.refreshWidget("refresh", myRCProperties);
            };

            /** 
             * Clears the progress bar
             * 
             * @param {object} widget The registered refresh area
             */
            var postRefreshHandler = function () {
                cursor_clear();
                //After adding/deleting/updating an item
                AutoSKUSuggestJS.autoSKUSuggest_controller_initProperties(RequistionListControllerDeclarationJS.suffix);
            };
            // initialize widget
            myWidgetObj.refreshWidget({
                renderContextChangedHandler: renderContextChangedHandler,
                postRefreshHandler: postRefreshHandler
            });
        }
    }
};
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the Requisition List pages to handle the services for 
 * adding/removing/updating items from a requisition list.
 * @version 1.10
 */


/**
 * This service allows customer to update an existing requisition list
 * @constructor
 */
wcService.declare({
	id:"requisitionListUpdate",
	actionId:"requisitionListUpdate",
	url:"AjaxRESTRequisitionListUpdate",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		requestSubmitted = false;
		document.location.href="RequisitionListDetailView?storeId="+serviceResponse.storeId+"&langId="+serviceResponse.langId+"&catalogId="+serviceResponse.catalogId+"&requisitionListId="+serviceResponse.requisitionListId+"&createdBy="+serviceResponse.createdBy;				
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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
}),

/**
 * This service allows customer to create add/update an item to an existing requisition list
 * @constructor
 */
wcService.declare({
	id:"requisitionListAddItem",
	actionId:"requisitionListAddItem",
	url:"AjaxRESTRequisitionListItemUpdate",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		
		if(serviceResponse.operation == "addItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ADD_SUCCESS"]);
		} else if (serviceResponse.operation == "deleteItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ITEM_DELETE_SUCCESS"]);
		} else if (serviceResponse.operation == "updateQty") {
			ReqListItemsJS.showUpdatedMessage(serviceResponse.row);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			var errorMsg = serviceResponse.errorMessage;
			//If the errorMessage param is the generic error message
			//Display the systemMessage instead
			if (errorMsg.search("CMN1009E") !=-1 ) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
			}else if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					if (serviceResponse.errorMessageKey!=null) {
						var msgKey = serviceResponse.errorMessageKey;
						if (msgKey == '_ERR_GETTING_SKU' || msgKey =='_ERR_PROD_NOT_EXISTING') {
							MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
						}else {
							MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
						}
					}else{					
						MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
					}
				} else {
					//If systemMessage is empty, then just display the generic error message
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
			} else {
				//If errorMessage is not generic, display errorMessage
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
}),

/**
 * This service allows customer to create update an item in an existing requisition list
 * @constructor
 */
wcService.declare({
	id:"requisitionListUpdateItem",
	actionId:"requisitionListUpdateItem",
	url:"AjaxRESTRequisitionListUpdateItem",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		if(serviceResponse.operation == "addItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ADD_SUCCESS"]);
		} else if (serviceResponse.operation == "deleteItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ITEM_DELETE_SUCCESS"]);
		} else if (serviceResponse.operation == "updateQty") {
			ReqListItemsJS.showUpdatedMessage(serviceResponse.row);
		}
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			var errorMsg = serviceResponse.errorMessage;
			//If the errorMessage param is the generic error message
			//Display the systemMessage instead
			if (errorMsg.search("CMN1009E") !=-1 ) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
			}else if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					if (serviceResponse.errorMessageKey!=null) {
						var msgKey = serviceResponse.errorMessageKey;
						if (msgKey == '_ERR_GETTING_SKU' || msgKey =='_ERR_PROD_NOT_EXISTING') {
							MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
						}else {
							MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
						}
					}else{					
						MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
					}
				} else {
					//If systemMessage is empty, then just display the generic error message
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
			} else {
				//If errorMessage is not generic, display errorMessage
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	},			
}),

/**
 * This service allows customer to delete an item to an existing requisition list
 * @constructor
 */
wcService.declare({
	id:"requisitionListDeleteItem",
	actionId:"requisitionListDeleteItem",
	url:"AjaxRESTRequisitionListItemDelete",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		if (serviceResponse.operation == "deleteItem"){
			MessageHelper.displayStatusMessage(MessageHelper.messages["REQUISITIONLIST_ITEM_DELETE_SUCCESS"]);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			var errorMsg = serviceResponse.errorMessage;
			//If the errorMessage param is the generic error message
			//Display the systemMessage instead
			if (errorMsg.search("CMN1009E") !=-1 ) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
			}else if(errorMsg.search("CMN3101E") != -1){
				//If systemMessage is not empty, display systemMessage
				if(serviceResponse.systemMessage){
					if (serviceResponse.errorMessageKey!=null) {
						var msgKey = serviceResponse.errorMessageKey;
						if (msgKey == '_ERR_GETTING_SKU' || msgKey =='_ERR_PROD_NOT_EXISTING') {
							MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_REQUISITION_LIST_INVALID_SKU"]);
						}else {
							MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
						}
					}else{					
						MessageHelper.displayErrorMessage(serviceResponse.systemMessage);
					}
				} else {
					//If systemMessage is empty, then just display the generic error message
					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
				}
			} else {
				//If errorMessage is not generic, display errorMessage
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
}),

/**
 * this services allows users to submit a requisition list for order processing.
 */
wcService.declare({
	id:"requisitionListAjaxPlaceOrder",
	actionId:"AjaxAddOrderItem",
	url:"AjaxRESTRequisitionListSubmit",
	formId:""

	 /**
    * Hides all the messages and the progress bar, and redirect to the shopping cart page 
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		document.location.href="RESTOrderCalculate?calculationUsage=-1,-2,-3,-4,-5,-6,-7&updatePrices=1&doConfigurationValidation=Y&errorViewName=AjaxOrderItemDisplayView&orderId=.&langId="+serviceResponse.langId+"&storeId="+serviceResponse.storeId+"&catalogId="+serviceResponse.catalogId+"&URL=AjaxOrderItemDisplayView";
	}	
	/**
    * display an error message.
    * @param (object) serviceResponse The service response object, which is the
    * JSON object returned by the service invocation.
    */
	,failureHandler: function(serviceResponse) {
		 if (serviceResponse.errorMessage) {
		 	if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
		 		MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_CONTRACT_EXPIRED_GOTO_ORDER"]);
		 	} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
 					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_RETRIEVE_PRICE"]);
			} else {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		 } else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
}), 

/**
* Add an item to a shopping cart in Ajax mode. A message is displayed after the service call.
* The URL "AjaxRESTOrderAddPreConfigurationToCart" is a superset of the URL
* "AjaxRESTOrderItemAdd", allowing dynamic kit partnumbers to be entered into the quick order form.
*/
wcService.declare({
		id: "ReqListAddOrderItem",
		actionId: "AddOrderItem",
		url: "AjaxRESTOrderAddPreConfigurationToCart",
		formId: ""
		
		/**
		* display a success message
		* @param (object) serviceResponse The service response object, which is the
		* JSON object returned by the service invocation
		*/
		,successHandler: function(serviceResponse) {
			MessageHelper.hideAndClearMessage();
			cursor_clear();
			// MessageHelper.displayStatusMessage(MessageHelper.messages["ADDED_TO_ORDER"]);
		}
		
		/**
		* display an error message
		* @param (object) serviceResponse The service response object, which is the
		* JSON object returned by the service invocation
		*/
		,failureHandler: function(serviceResponse) {

			if (serviceResponse.errorMessage) {
			 	if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
			 		MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_CONTRACT_EXPIRED_GOTO_ORDER"]);
			 	} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
 					MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_RETRIEVE_PRICE"]);
 				} else {
 					MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
 				}
			} 
			else {
				 if (serviceResponse.errorMessageKey) {
					MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
				 }
			}
			cursor_clear();
		}

	})//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


/** 
 * @fileOverview This javascript is used by the Saved Order pages to control the refresh areas.
 * @version 1.1
 */

/**
 * List of all the services that result in changes to a saved order
 * @static
 */
var savedorder_updated = [
    'AjaxSavedOrderDeleteItem',
    'savedOrderUpdateDescription',
    'AjaxSavedOrderUpdateItem',
    'AjaxAddOrderItem'
];

/**
 * Declares a new render context for saved order details page item table.
 */
wcRenderContext.declare("SavedOrderItemTable_Context", ["SavedOrderItemTable_Widget"], {
    "beginIndex": "0"
});

/**
 * Declares a new refresh controller for the Saved Order Items table display.
 */
var declareSavedOrderItemTableController = function() {
    var myWidgetObj = $("#SavedOrderItemTable_Widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("SavedOrderItemTable_Context");
    
    // model change
    wcTopic.subscribe(["AjaxSavedOrderDeleteItem", "AjaxSavedOrderUpdateItem", "AjaxAddOrderItem"], function(returnAction){
        myRCProperties["orderId"] = returnAction.data.orderId;
        myWidgetObj.refreshWidget("refresh", myRCProperties);
    });
    
    myWidgetObj.refreshWidget({
        renderContextChangedHandler: function() {
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },
        postRefreshHandler: function() {
            cursor_clear();
            if (Utils.existsAndNotEmpty(SavedOrderItemsJS.getCurrentRow())) {
                 SavedOrderItemsJS.showUpdatedMessage();
            }
            SavedOrderItemsJS.resetCurrentRow();
        }
    });
};

/**
 * Declares a new render context for saved order details page information area.
 */
wcRenderContext.declare("SavedOrderInfo_Context", ["SavedOrderInfo_Widget"], {});

/**
 * Declares a new refresh controller for the Saved Order Info display.
 */
var declareSavedOrderInfoController = function() {
    var widgetObj = $("#SavedOrderInfo_Widget");
    var myRCProperties = wcRenderContext.getRenderContextProperties("SavedOrderInfo_Context");
    
    /** 
     * Refreshes the saved order info display if name is updated
     * or an update/delete in the saved order items table occurs.
     * This function is called when a modelChanged event is detected. 
     */
    wcTopic.subscribe(savedorder_updated, function(returnAction) {
        // update actionId
        myRCProperties["orderId"] = returnAction.data.orderId;
        widgetObj.refreshWidget("refresh", myRCProperties);
    });
    
    widgetObj.refreshWidget({
        /** 
         * Refreshes the saved order info display if the name of the saved order is changed 
         * or an update/delete in the saved order items table occurs.
         * This function is called when a render context event is detected. 
         */
         renderContextChangedHandler: function () {
            widgetObj.refreshWidget("refresh", myRCProperties);
         },

        /** 
         * Clears the progress bar
         */
        postRefreshHandler: function() {
             cursor_clear();
        }
    });
};//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This javascript is used by the Saved order details pages to handle the services for 
 * updating saved order info and adding/removing/updating items from a saved order.
 * @version 
 */

/**
 * This service allows customer to update an existing saved order info
 * @constructor
 */
wcService.declare({
	id:"savedOrderUpdateDescription",
	actionId:"savedOrderUpdateDescription",
	url: getAbsoluteURL() + "AjaxRESTOrderCopy",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["SAVEDORDERINFO_UPDATE_SUCCESS"]);		
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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


/**
 * This service removes an item from a saved order.
 * @constructor
 */
wcService.declare({
	id:"AjaxSavedOrderDeleteItem",
	actionId:"AjaxSavedOrderDeleteItem",
	url: getAbsoluteURL() + "AjaxRESTOrderItemDelete",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["SAVEDORDERITEM_DELETE_SUCCESS"]);		
	}
	
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

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

/**
 * Updates an order item in the saved order. 
 * A message is displayed after the service call.  
 * An error message will be displayed otherwise.
 * @constructor
*/
wcService.declare({
	id: "AjaxSavedOrderUpdateItem",
	actionId: "AjaxSavedOrderUpdateItem",
	url: getAbsoluteURL() + "AjaxRESTOrderItemUpdate",
	formId: ""
	
	/**
     * Hides all messages and the progress bar
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
	}

    /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			if (serviceResponse.errorCode == "CMN1654E") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_QUANTITY_ONE_OR_MORE"]);
			} else {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}
});

/**
* This service adds an item to a saved order. A message is displayed after the service call.
* The URL "AjaxRESTOrderAddPreConfigurationToCart" is a superset of the URL
* "AjaxRESTOrderItemAdd", allowing dynamic kit partnumbers to be added to the saved order.
* @constructor
*/
wcService.declare({
	id: "AjaxAddSavedOrderItem",
	actionId: "AjaxAddOrderItem",
	url: getAbsoluteURL() + "AjaxRESTOrderAddPreConfigurationToCart",
	formId: ""
	
	/**
     * Hides all messages and the progress bar
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		MessageHelper.displayStatusMessage(MessageHelper.messages["SAVEDORDERITEM_ADD_SUCCESS"]);
		cursor_clear();
	}

    /**
     * display an error message
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_CONTRACT_EXPIRED"]);
			} else if (serviceResponse.errorMessageKey == "_ERR_RETRIEVE_PRICE") {
				MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_RETRIEVE_PRICE"]);
			} else {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			}
		}  
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}
});

/**
 * Set the current order to be that of a saved order.
 * Perform the service or command call.
 */
wcService.declare({
	id: "AjaxSetPendingOrder",
	actionId: "AjaxSetPendingOrder",
	url: "AjaxRESTSetPendingOrder",
	formId: ""

 /**
 * display a success message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		cursor_clear();
		MessageHelper.displayStatusMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_SET_AS_CURRENT_SUCCESS"]);
	}
 /**
 * display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
	,failureHandler: function(serviceResponse) {
		if (serviceResponse.errorMessage) {
			 if (["CMN0409E", "CMN1024E"].indexOf(serviceResponse.errorCode) > -1)
			 {
				 MessageHelper.displayErrorMessage(MessageHelper.messages["MYACCOUNT_SAVEDORDERLIST_SET_AS_CURRENT_FAIL"]);
			 }
			 else
			 {
				 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			 }
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}
});

/**
 * Updates the currently selected saved order setting it to the current shopping cart.
 * The main function of this service is to keep the cpendorder database table in line with the current shopping cart.
 * Perform the service or command call.
 * @constructor
 */
wcService.declare({
	id: "AjaxUpdatePendingOrder",
	actionId: "AjaxUpdatePendingOrder",
	url: getAbsoluteURL() + "AjaxRESTSetPendingOrder",
	formId: ""

 /**
 * There is nothing to do in the event of a success of this service since it is executed in the background.
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */

	,successHandler: function(serviceResponse) {
		
		if (serviceResponse.nextAction != 'undefined' && serviceResponse.nextAction != null && serviceResponse.nextAction)
		{
			document.location.href = SavedOrderItemsJS.getCurrentShoppingCartURL();
		}
		
		cursor_clear();
	}
 /**
 * display an error message
 * @param (object) serviceResponse The service response object, which is the
 * JSON object returned by the service invocation
 */
	,failureHandler: function(serviceResponse) {
		
		if (serviceResponse.errorMessage) {
			if (serviceResponse.errorCode == "CMN0409E")
			 {
				 MessageHelper.displayErrorMessage(MessageHelper.messages["ERROR_SAVED_ORDER_NOT_SET_CURRENT"]);
			 }
			 else
			 {
				 MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
			 }
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}

});
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

};//-----------------------------------------------------------------
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

/**
 * @fileOverview This file contains functions that are used to manage the cookies that are used by the Store Locator
 * feature.
 *
 * @version 1.0
 *
 */
 
/**
 * The functions defined in the class are used for managing the physical store IDs and the store locator user 
 * inputs.  Both information is stored in the cookie.
 *
 * @class This PhysicalStoreCookieJS class defines all the variables and functions to add / update / delete physical
 * store IDs and store locator user inputs.
 *
 */
PhysicalStoreCookieJS = {
	/* the store array is used to store physical store IDs to the cookie */
	storeArray: null,
	
	/* the maximum number of physical store IDs to be saved */
	arrayMaxSize: 5,
	
	/**
	 * This function retrieves the physical store IDs from the cookie.  These physical stores IDs are saved
	 * in the store array.  If no physical store IDs is found in the cookie, an empty store array is created.
	 *
	 * @returns {Array} The store array that contains all physical store IDs saved in the cookie.
	 *
	 */
	getStoreIdsFromCookie:function() {
        var cookieValue = getCookie("WC_physicalStores");
		this.storeArray = new Array;
	
		if (cookieValue != null) {
			var subValue = "";
			var remainingString = cookieValue;
			var length = cookieValue.length;
			var end = remainingString.indexOf(",");
			
			/* more than 1 entry */
			if (end > 0) {
				while (end >=0) {
					subValue = remainingString.substring(0, end);
					this.addToStoreArray(subValue);
					remainingString = remainingString.substring(end+1,length);
					length = remainingString.length;
					end = remainingString.indexOf(",")
				}
				
				subValue = remainingString;
				this.addToStoreArray(subValue);
			}
			/* 0 to 1 entry */
			else {
				/* 1 entry */
				if (length > 0) {
					this.addToStoreArray(remainingString);
				}
			}
		}
		return this.storeArray;
	},
	
	/**
	 * This function checks whether adding one more physical store ID to the cookie will exceed the maximum
	 * number of stores allowed to be saved limit.  The function is default to return false; otherwise, true is
	 * returned. 
	 *
	 * @returns {boolean} The flag to indicate check result.
	 *
	 */
	isAddOneStoreIdExceedMax:function() {
		var exceedMax = false;
		
		if ((this.getNumStores() + 1) > this.arrayMaxSize) {
			exceedMax = true;
		}
		
		return exceedMax;
	},
	
	/**
	 * This function saves all the physical store IDs in the store array to the cookie.  It loops through the store 
	 * array and saves all physical store IDs into the cookie.  It also ensures the cookie do not expire after the 
	 * session closes.  
	 *
	 */
	setStoreIdsToCookie:function() {
		var newCookieValue = "";
		
		for (i=0; i<this.storeArray.length; i++) {
			newCookieValue = newCookieValue + this.storeArray[i];
			if (i < (this.storeArray.length-1)) {
				newCookieValue = newCookieValue + ",";
			}
		}
		
		if (newCookieValue.length == 0) {
			/* delete the cookie then */
			setCookie("WC_physicalStores", null, {path: "/", expires: -1, domain: cookieDomain});
		}
		else {
			/* add or update the cookie */
			setCookie("WC_physicalStores", newCookieValue, {path: "/", domain: cookieDomain});
		}
	},
	
	/**
	 * This function adds the store ID to the store array.  It ensures that the store array does contain the 
	 * information from the cookie and the store ID to be added does not exist in the store array.
	 *
	 * @param {String} record The physical store ID to be added. 
	 *
	 */
	addToStoreArray:function(record) {
		if (this.storeArray == null) {
			this.getStoreIdsFromCookie();
		}
		
		for (i=0; i<this.storeArray.length; i++) {
			if (this.storeArray[i] == record) {
				return;
			}
		}
		
		/* do not add the new record if the array has reached the max size */
		if (this.storeArray.length < this.arrayMaxSize) {
			this.storeArray.push(record);
		}
	},
	
	/**
	 * This function adds the store ID to the cookie by calling the following 2 functions:
	 *       addToStoreArray()
	 *       setStoreIdsToCookie()
	 *
	 * @param {String} record The physical store ID to be added. 
	 *
	 */
	addToCookie:function(record) {
		this.addToStoreArray(record);
		this.setStoreIdsToCookie();
	},
	
	/**
	 * This function removes the store ID from the store array.  It ensures that the store array does contain the
	 * information from the cookie and the store ID to be removed does exist in the store array.
	 *
	 * @param {String} record The physical store ID to be removed. 
	 *
	 */
	removeFromStoreArray:function(record) {
		if (this.storeArray == null) {
			this.getStoreIdsFromCookie();
		}
		
		var recordIndex = -1;
		
		for (i=0; i<this.storeArray.length; i++) {
			if (this.storeArray[i] == record) {
				recordIndex = i;
				i = this.storeArray.length;
			}
		}
				
		this.storeArray.splice(recordIndex, 1);
	},
	
	/**
	 * This function removes the store ID from the cookie by calling the following 2 functions:
	 *       removeFromStoreArray()
	 *       setStoreIdsToCookie()
	 *
	 * @param {String} record The physical store ID to be removed. 
	 *
	 */
	removeFromCookie:function(record) {
		this.removeFromStoreArray(record);
		this.setStoreIdsToCookie();
	},
	
	/**
	 * This function empties the store array.
	 *
	 */
	clearStoreArray:function() {
		this.storeArray = new Array;
	},
	
	/**
	 * This function updates the cookie with the empty store array.
	 *
	 */
	clearCookie:function() {
		this.clearStoreArray();
		this.setStoreIdsToCookie();
	},
	
	/**
	 * This function returns the number of physical stores saved in the cookie.  It ensures the store array contains 
	 * the information retrieved from the cookie before getting the number of stores.
	 *
	 * @returns {int} The number of physical stores saved.
	 *
	 */
	getNumStores:function() {
		if (this.storeArray == null) {	
			this.getStoreIdsFromCookie();
		}
		
		return this.storeArray.length;
	},
	
	/**
	 * This function retrieves the pick up store ID from the cookie.  If no pick up store ID is found in the cookie, 
	 * null is returned.
	 *
	 * @returns {String} The pick up store IDs.
	 *
	 */
	getPickUpStoreIdFromCookie:function() {
        var pickUpStoreId = getCookie("WC_pickUpStore");
		return pickUpStoreId;
	},

	/**
	 * This function adds or updates the pick up store ID to the cookie.
	 *
	 * @param {String} value The new pick up store ID. 
	 *
	 * @returns {element} .
	 *
	 */
	setPickUpStoreIdToCookie:function(value) {
		var newPickUpStoreId = value;
		if (newPickUpStoreId != null && newPickUpStoreId != "undefined" && newPickUpStoreId != "") {
			var currentPickUpStoreId = this.getPickUpStoreIdFromCookie();
			if (newPickUpStoreId != currentPickUpStoreId) {
				setCookie("WC_pickUpStore", null, {path: "/", expires: -1, domain: cookieDomain});
				setCookie("WC_pickUpStore", newPickUpStoreId, {path: "/", domain: cookieDomain});
			}
		}
	},

	/**
	 * This function clears the pick up store ID from the cookie when the parameter matches the current pick up 
	 * store ID in the cookie.
	 *
	 * @param {String} value The pick up store ID for comparison. 
	 *
	 */
	clearPickUpStoreIdFromCookie:function(value) {
		var newPickUpStoreId = value;
		if (newPickUpStoreId != null && newPickUpStoreId != "undefined" && newPickUpStoreId != "") {
			var currentPickUpStoreId = this.getPickUpStoreIdFromCookie();
			if (newPickUpStoreId == currentPickUpStoreId) {
				setCookie("WC_pickUpStore", null, {path: "/", expires: -1, domain: cookieDomain});
			}
		}
	},
	
	/**
	 * This generic function retrieves the value from the cookie based on the cookie key.  It is used to store 
	 * "country: WC_stCntry", "province: WC_stProv", "city: WC_stCity" and "search performed flag: WC_stFind".  If no 
	 * value is found in the cookie for the cookie key, null is returned.
	 *
	 * @param {String} cookieKey The key of the cookie. 
	 *
	 * @returns {String} The value obtained from the cookie.
	 *
	 */
	getValueFromCookie:function(cookieKey) {
        var cookieValue = getCookie(cookieKey);
		return cookieValue;
	},

	/**
	 * This function adds or updates the value to the cookie using the key provided.  It is used to store 
	 * "country: WC_stCntry", "province: WC_stProv", "city: WC_stCity" and "search performed flag: WC_stFind".
	 *
	 * @param {String} cookieKey The key of the cookie. 
	 * @param {String} cookieValue The new value of the cookie. 
	 *
	 */
	setValueToCookie:function(cookieKey, cookieValue) {
		var newValue = cookieValue;
		if (newValue != null && newValue != "undefined" && newValue != "") {
			var currentValue = this.getValueFromCookie(cookieKey);
			if (newValue != currentValue) {
				setCookie(cookieKey, null, {path: "/", expires: -1, domain: cookieDomain});
				setCookie(cookieKey, newValue, {path: "/", domain: cookieDomain});
			}
		}
	},

	/**
	 * This function clears the value referred by a key from the cookie.
	 *
	 * @param {String} cookieKey The key of the cookie. 
	 *
	 */
	clearValueFromCookie:function(cookieKey) {
		var currentValue = this.getValueFromCookie(cookieKey);
		if (currentValue != null && currentValue != "undefined") {
			setCookie(cookieKey, null, {path: "/", expires: -1, domain: cookieDomain});
		}
	}

}
//<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp.  2016
//* All Rights Reserved
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
//--%>

/**
 * @fileOverview This file contains functions that are used by Store Locator.
 *
 * @version 1.0
 *
 */


/**
 * The functions defined in the class are used for the Store Locator feature.
 *
 * @class This storeLocatorJS class defines all the functions to be used on pages that contain the Store Locator feature.
 *
 */
storeLocatorJS = {

    /**
     * This function initializes the state/province selection drop down list by extracting the selected value
     * of the country selection.  Nothing is done when no selected country is found.
     *
     */
    initProvinceSelections: function () {
        var countrySelectedIndex = $("#selectCountry").prop("selectedIndex");
        if (countrySelectedIndex > -1) {
            var indexToUse = countrySelectedIndex;
            var indexFromSavedId = storeLocatorJS.getSavedCountrySelectionIndex();

            if (indexFromSavedId != null && indexFromSavedId != countrySelectedIndex) {
                indexToUse = indexFromSavedId;
                $("#selectCountry")[0].options[indexToUse].selected = true;
            }
            wcRenderContext.updateRenderContext('provinceSelectionsAreaContext', {
                'countryId': $("#selectCountry")[0].options[indexToUse].value
            });
        }
    },

    /**
     * This function refreshes the city selection drop down list by extracting the selected value of the
     * state/province selection.  Nothing is done when no selected state/province is found.
     *
     */
    refreshCities: function () {
        var stateSelectedIndex = $("#selectState").prop("selectedIndex");
        if (stateSelectedIndex > -1) {
            var indexToUse = stateSelectedIndex;
            var indexFromSavedId = storeLocatorJS.getSavedProvinceSelectionIndex();
            if (indexFromSavedId != null && indexFromSavedId != stateSelectedIndex) {
                indexToUse = indexFromSavedId;
                $("#selectState")[0].options[indexToUse].selected = true;
            }
            wcRenderContext.updateRenderContext('citySelectionsAreaContext', {
                'provinceId': $("#selectState")[0].options[indexToUse].value
            });
        }
    },

    /**
     * This function refreshes the store location search results by extracting the selected value of the city
     * selection.  Nothing is done when no selected city is found.  Store location search results are refreshed
     * automatically once when a search intend (i.e. Find button is pressed) was done before.
     *
     * @param {String} fromPage Parameter value passed by the calling page.
     *
     */
    refreshSearchResults: function (fromPage) {
        var citySelectedIndex = $("#selectCity").selectedIndex;
        if (citySelectedIndex > -1) {
            var indexToUse = citySelectedIndex;
            var indexFromSavedId = storeLocatorJS.getSavedCitySelectionIndex();
            if (indexFromSavedId != null && indexFromSavedId != citySelectedIndex) {
                indexToUse = indexFromSavedId;
                $("#selectCountry")[0].options[indexToUse].value("selectCity").options[indexToUse].selected = true;
            }

            var performFindFlag = PhysicalStoreCookieJS.getValueFromCookie("WC_stFind");
            if (performFindFlag != null) {
                wcRenderContext.updateRenderContext('storeLocatorResultsAreaContext', {
                    'cityId': document.getElementById("selectCountry").options[indexToUse].value("selectCity").options[indexToUse].value,
                    'fromPage': fromPage
                });
            }
        }
    },

    /**
     * This function adds the user selected physical store to the cookie when the maximum number of physical
     * stores has not reached; otherwise, a message is displayed.
     *
     * @param {String} physicalStoreId The physical store Unique ID to be added.
     * @param {String} optionIndex The index of the physical store to be added.
     *
     * @returns {boolean} A flag to indicate whether the add is performed.
     *
     */
    addPhysicalStore: function (physicalStoreId, optionIndex) {
        if (PhysicalStoreCookieJS.isAddOneStoreIdExceedMax() == true) {
            if (document.getElementById("addPhysicalStoreToCookieButton" + optionIndex) != null) {
                MessageHelper.formErrorHandleClient("addPhysicalStoreToCookieButton" + optionIndex, MessageHelper.messages["EXCEED_PHYSICAL_STORE_SIZE"]);
                return false;
            } else {
                MessageHelper.displayErrorMessage(MessageHelper.messages["EXCEED_PHYSICAL_STORE_SIZE"]);
                return false;
            }
        }

        if (!submitRequest()) {
            return;
        }
        cursor_wait();

        PhysicalStoreCookieJS.addToCookie(physicalStoreId);
        storeLocatorJS.showRemoveOption(physicalStoreId);
        return true;
    },

    /**
     * This function removes the user selected physical store from the cookie.
     *
     * @param {String} physicalStoreId The physical store Unique ID to be removed.
     *
     */
    removePhysicalStore: function (physicalStoreId) {
        PhysicalStoreCookieJS.removeFromCookie(physicalStoreId);
        PhysicalStoreCookieJS.clearPickUpStoreIdFromCookie(physicalStoreId);
        storeLocatorJS.showAddOption(physicalStoreId);
    },

    /**
     * This function shows the disabled "add physical store" option and hides the "add physical store" option
     * of the physical store.
     *
     * @param {String} physicalStoreId The physical store Unique ID.
     *
     */
    showRemoveOption: function (physicalStoreId) {
        var addDisabledDiv = $("#addPhysicalStoreToCookieDisabled" + physicalStoreId);
        var addDiv = $("#addPhysicalStoreToCookie" + physicalStoreId);

        if (addDisabledDiv != null && addDisabledDiv != "undefined") {
            $(addDisabledDiv).css("display", "block");
        }

        if (addDiv != null && addDiv != "undefined") {
            $(addDiv).css("display", "none");
        }
    },

    /**
     * This function shows the "add physical store" option and hides the disabled "add physical store" option
     * of the physical store.
     *
     * @param {String} physicalStoreId The physical store Unique ID.
     *
     */
    showAddOption: function (physicalStoreId) {
        var addDisabledDiv = $("#addPhysicalStoreToCookieDisabled" + physicalStoreId);
        var addDiv = $("#addPhysicalStoreToCookie" + physicalStoreId);

        if (addDisabledDiv != null && addDisabledDiv != "undefined") {
            $(addDisabledDiv).css("display", "none");
        }

        if (addDiv != null && addDiv != "undefined") {
            $(addDiv).css("display", "block");
        }
    },

    /**
     * This function manages the cookie values when OK button is pressed from city search.
     *
     */
    manageCookieFromCity: function () {
        PhysicalStoreCookieJS.setValueToCookie('WC_stFind', 1);
    },

    /**
     * This function refreshes the result area when a city is selected.  It refreshes the physical store
     * information.
     *
     * @param form The form that contains the "city" selections.
     * @param {String} fromPage The fromPage parameter value passed by the calling page.
     *
     */
    refreshResultsFromCity: function (form, fromPage) {
        if (form.selectCity.selectedIndex < 0) {
            MessageHelper.formErrorHandleClient(form.selectCity.id, MessageHelper.messages["MISSING_CITY"]);
            return;
        }

        /* manage cookie values */
        storeLocatorJS.manageCookieFromCity();

        /* refresh the result area */
        wcRenderContext.updateRenderContext('storeLocatorResultsAreaContext', {
            'cityId': form.selectCity.options[form.selectCity.selectedIndex].value,
            'fromPage': fromPage,
            'geoCodeLatitude': '',
            'geoCodeLongitude': '',
            'errorMsgKey': ''
        });
    },

    /**
     * This function refreshes the result area when the geolocation feature is used.  It refreshes the
     * physical store information.
     *
     * @param {String} geoCodeLatitude The user's latitude coordinate.
     * @param {String} geoCodeLongitude The user's longitude coordinate.
     *
     */
    refreshResultsFromNearest: function (geoCodeLatitude, geoCodeLongitude) {
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stCntry");
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stProv");
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stCity");
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stFind");

        /* refresh the result area */
        wcRenderContext.updateRenderContext('storeLocatorResultsAreaContext', {
            'geoCodeLatitude': geoCodeLatitude,
            'geoCodeLongitude': geoCodeLongitude,
            'errorMsgKey': ''
        });
    },

    /**
     * This function refreshes the result area when the geolocation feature is used.  It refreshes the
     * physical store information.
     *
     * @param {String} errorMsgKey The resource key for the error message.
     *
     */
    refreshResultsWithLocationError: function (errorMsgKey) {
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stFind");

        /* refresh the result area */
        wcRenderContext.updateRenderContext('storeLocatorResultsAreaContext', {
            'errorMsgKey': errorMsgKey
        });
    },

    /**
     * This function refreshes the store list area.
     *
     * @param {String} fromPage The fromPage parameter value passed by the calling page.
     *
     */
    refreshStoreList: function (fromPage) {
        /* refresh the store list area */
        wcRenderContext.updateRenderContext('selectedStoreListAreaContext', {
            'fromPage': fromPage
        });
    },

    removeFromStoreList: function (fromPage, tableRowId) {
        var numStores = PhysicalStoreCookieJS.getNumStores();
        if (numStores == 0) {
            // Refresh to remove complete table and display status message
            this.refreshStoreList(fromPage);
        } else {
            // Just remove store from the table.
            var tableRow = document.getElementById(tableRowId);
            tableRow.remove();
        }
    },

    /**
     * This function hides the store list area.
     *
     */
    hideStoreList: function () {
        var storeListDiv = $("#selectedStoreListArea");
        var showListHeaderDiv = $("#showStoreListHeader");
        var hideListHeaderDiv = $("#hideStoreListHeader");

        if (storeListDiv != null && storeListDiv != "undefined") {
            $(storeListDiv).css("display", "none");
        }
        if (showListHeaderDiv != null && showListHeaderDiv != "undefined") {
            $(showListHeaderDiv).css("display", "block");
        }
        if (hideListHeaderDiv != null && hideListHeaderDiv != "undefined") {
            $(hideListHeaderDiv).css("display", "none");
        }
    },

    /**
     * This function shows the store list area.
     *
     */
    showStoreList: function () {
        var storeListDiv = $("#selectedStoreListArea");
        var showListHeaderDiv = $("#showStoreListHeader");
        var hideListHeaderDiv = $("#hideStoreListHeader");

        if (storeListDiv != null && storeListDiv != "undefined") {
            $(storeListDiv).css("display", "block");
        }
        if (showListHeaderDiv != null && showListHeaderDiv != "undefined") {
            $(showListHeaderDiv).css("display", "none");
        }
        if (hideListHeaderDiv != null && hideListHeaderDiv != "undefined") {
            $(hideListHeaderDiv).css("display", "block");
        }
    },

    /**
     * This function is called after the counry selection list is changed.
     *
     * @param {String} countryId The unique ID of the selected country.
     *
     */
    changeCountrySelection: function (countryId) {
        PhysicalStoreCookieJS.setValueToCookie("WC_stCntry", countryId);
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stProv");
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stCity");
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stFind");

        wcRenderContext.updateRenderContext("provinceSelectionsAreaContext", {
            "countryId": countryId
        });
    },

    /**
     * This function is called after the province selection list is changed.
     *
     * @param {String} provinceId The unique ID of the selected province.
     *
     */
    changeProvinceSelection: function (provinceId) {
        PhysicalStoreCookieJS.setValueToCookie("WC_stProv", provinceId);
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stCity");
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stFind");

        wcRenderContext.updateRenderContext("citySelectionsAreaContext", {
            "provinceId": provinceId
        });
    },

    /**
     * This function is called after the city selection list is changed.
     *
     * @param {String} cityId The unique ID of the selected city.
     *
     */
    changeCitySelection: function (cityId) {
        PhysicalStoreCookieJS.setValueToCookie("WC_stCity", cityId);
        PhysicalStoreCookieJS.clearValueFromCookie("WC_stFind");
    },

    /**
     * This function retrieves the index of the country selection list which has a value matches the one saved in
     * the cookie.  Null is returned when cookie does not contain any saved country ID.
     *
     * @returns {int} The index of the country selection list which has a value matches the one saved in the
     * cookie.
     *
     */
    getSavedCountrySelectionIndex: function () {
        var index = null;
        var savedCountryId = PhysicalStoreCookieJS.getValueFromCookie("WC_stCntry");
        if (savedCountryId != null) {
            /* search for matching ID */
            var selectedCountryList = $("#selectCountry");
            if (selectedCountryList != null && selectedCountryList != "undefined") {
                var listSize = selectedCountryList.length;
                for (i = 0; i < listSize; i++) {
                    if (savedCountryId == selectedCountryList[0].options[i].value) {
                        index = i;
                        i = listSize;
                    }
                }
            }
        }

        return index;
    },

    /**
     * This function retrieves the index of the province selection list which has a value matches the one saved in
     * the cookie.  Null is returned when cookie does not contain any saved province ID.
     *
     * @returns {int} The index of the province selection list which has a value matches the one saved in the
     * cookie.
     *
     */
    getSavedProvinceSelectionIndex: function () {
        var index = null;
        var savedProvinceId = PhysicalStoreCookieJS.getValueFromCookie("WC_stProv");
        if (savedProvinceId != null) {
            /* search for matching ID */
            var selectedProvinceList = $("#selectState");
            if (selectedProvinceList != null && selectedProvinceList != "undefined") {
                var listSize = selectedProvinceList.length;
                for (i = 0; i < listSize; i++) {
                    if (savedProvinceId == selectedProvinceList[0].options[i].value) {
                        index = i;
                        i = listSize;
                    }
                }
            }
        }

        return index;
    },

    /**
     * This function retrieves the index of the city selection list which has a value matches the one saved in
     * the cookie.  Null is returned when cookie does not contain any saved city ID.
     *
     * @returns {int} The index of the city selection list which has a value matches the one saved in the
     * cookie.
     *
     */
    getSavedCitySelectionIndex: function () {
        var index = null;
        var savedCityId = PhysicalStoreCookieJS.getValueFromCookie("WC_stCity");
        if (savedCityId != null) {
            /* search for matching ID */
            var selectedCityList = $("#selectCity");
            if (selectedCityList != null && selectedCityList != "undefined") {
                var listSize = selectedCityList[0].options.length;
                for (i = 0; i < listSize; i++) {
                    if (savedCityId == selectedCityList[0].options[i].value) {
                        index = i;
                        i = listSize;
                    }
                }
            }
        }

        return index;
    }

}
//<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp.  2016
//* All Rights Reserved
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
//--%>

/**
 * @fileOverview This file declares the contexts of the store locator.
 *
 * @version 1.0
 *
 */


/**
 * The functions defined in the class are used to initialize the common parameters of the contexts and set the 
 * properties of a specific context.
 *
 * @class This StoreLocatorContextsJS class defines all the variables and functions for manipuating the contexts
 * of the store locator.
 *
 */
StoreLocatorContextsJS = {
    /* common paramater declarations */
    langId: "-1",
    storeId: "",
    catalogId: "",
    orderId: "",
    fromPage: "StoreLocator",

    /**
     * This function initializes the common parameters. 
     *
     * @param {String} langId The language ID. 
     * @param {String} storeId The store ID.
     * @param {String} catalogId The catalog ID.
     * @param {String} orderId The order ID.
     * @param {String} fromPage The constants indicates what the calling page is.
     *
     */
    setCommonParameters: function (langId, storeId, catalogId, orderId, fromPage) {
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        this.orderId = orderId;
        this.fromPage = fromPage;
    },

    /**
     * This function sets a property of a context. 
     *
     * @param {String} contextId The context identifier. 
     * @param {String} property The property name.
     * @param {String} value The property value.
     *
     */
    setContextProperty: function (contextId, property, value) {
        wcRenderContext.getRenderContextProperties(contextId)[property] = value;
    }

}


/* context declaration for "provinceSelectionsAreaContext" */
wcRenderContext.declare("provinceSelectionsAreaContext", ["provinceSelectionsArea"], ""),

    /* context declaration for "citySelectionsAreaContext" */
    wcRenderContext.declare("citySelectionsAreaContext", ["citySelectionsArea"], ""),

    /* context declaration for "storeLocatorResultsAreaContext" */
    wcRenderContext.declare("storeLocatorResultsAreaContext", ["storeLocatorResultsArea"], ""),

    /* context declaration for "selectedStoreListAreaContext" */
    wcRenderContext.declare("selectedStoreListAreaContext", ["selectedStoreListArea"], "")
//<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp.  2016
//* All Rights Reserved
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
//--%>

/**
 * @fileOverview This file declares the controllers of the store locator.
 *
 * @version 1.0
 *
 */

/**
 * The functions defined in the class are used to initialize the common parameters of the controllers and set the 
 * URL of a specific controller.
 *
 * @class This StoreLocatorContextsJS class defines all the variables and functions for manipuating the controllers
 * of the store locator.
 *
 */
StoreLocatorControllersDeclarationJS = {
    /* common paramater declarations */
    langId: "-1",
    storeId: "",
    catalogId: "",
    orderId: "",
    fromPage: "StoreLocator",

    /**
     * This function initializes the common parameters. 
     *
     * @param {String} langId The language ID. 
     * @param {String} storeId The store ID.
     * @param {String} catalogId The catalog ID.
     * @param {String} orderId The order ID.
     * @param {String} fromPage The constants indicates what the calling page is.
     *
     */
    setCommonParameters: function (langId, storeId, catalogId, orderId, fromPage) {
        this.langId = langId;
        this.storeId = storeId;
        this.catalogId = catalogId;
        this.orderId = orderId;
        this.fromPage = fromPage;
    }


}


/* refresh controller declaration for "provinceSelectionsController" */
var provinceSelectionsRefreshArea = function () {

    var myWidgetObj = $("#provinceSelectionsArea"),
        myRCProperties = wcRenderContext.getRenderContextProperties("provinceSelectionsAreaContext");

    myWidgetObj.refreshWidget({
        formId: "",


        renderContextChangedHandler: function () {

            cursor_wait();
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },

        postRefreshHandler: function () {

            storeLocatorJS.refreshCities();
            cursor_clear();
        }
    });
}

/* refresh controller declaration for "citySelectionsController" */
var citySelectionsRefreshController = function () {

    var myWidgetObj = $("#citySelectionsArea"),
        myRCProperties = wcRenderContext.getRenderContextProperties("citySelectionsAreaContext");

    myWidgetObj.refreshWidget({
        formId: "",


        renderContextChangedHandler: function () {

            cursor_wait();
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },


        postRefreshHandler: function (widget) {

            storeLocatorJS.refreshSearchResults(StoreLocatorControllersDeclarationJS.fromPage);
            cursor_clear();
        }

    });
}


/* refresh controller declaration for "storeLocatorResultsController" */
var storeLocatorResultsRefreshController = function () {

    var myWidgetObj = $("#storeLocatorResultsArea"),
        myRCProperties = wcRenderContext.getRenderContextProperties("storeLocatorResultsAreaContext");

    myWidgetObj.refreshWidget({
        formId: "",



        renderContextChangedHandler: function () {
            cursor_wait();
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },

        postRefreshHandler: function () {

            var bopisTable = $("#bopis_table");
            if (bopisTable != null && bopisTable != "undefined") {
                bopisTable.focus();
            }
            var noStoreMsg = $("#no_store_message");
            if (noStoreMsg != null && noStoreMsg != "undefined") {
                noStoreMsg.focus();
            }

            cursor_clear();
        }

    });
}

/* refresh controller declaration for "selectedStoreListController" */
var selectedStoreListRefreshController = function () {

    var myWidgetObj = $("#selectedStoreListArea"),
        myRCProperties = wcRenderContext.getRenderContextProperties("selectedStoreListAreaContext");

    myWidgetObj.refreshWidget({
        formId: "",


        renderContextChangedHandler: function () {

            cursor_wait();
            myWidgetObj.refreshWidget("refresh", myRCProperties);
        },

        postRefreshHandler: function () {

            var bopisTable = $("#bopis_table");
            if (bopisTable != null && bopisTable != "undefined") {
                bopisTable.focus();
            }

            cursor_clear();
        }

    })
}
