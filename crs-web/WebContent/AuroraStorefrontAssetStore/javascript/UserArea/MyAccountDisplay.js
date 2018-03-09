//-----------------------------------------------------------------
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
 * @fileOverview This javascript is used by jsp's related to 'Personal Information','My Orders' and 'My Coupons'.
 * @version 1.0
 */

/**
 * The functions defined in this class are used for enabling 'My Account' related customer operations.
 *
 * @class This MyAccountDisplay class defines all the variables and functions for 'My Account' page history tracking.
 *  Another function enables customers to update their current personal information.
 *  Another function enables the customer to create a new order by duplicating a previous order.Another function is
 *  used to remove a coupon from the coupon wallet.
 */
MyAccountDisplay={

    /*Flag which indicates if a context change happened. */
    contextChanged:false,

    /*Flag which indicates whether refresh is caused by browser back or forward event. */
    isHistory:false,

    /* This indicates the current link highlighted in the leftSideBar. */
    currentSelection:"",

    /**
     * This variable stores the identifier of the tab currently being displayed.
     * The default value is "PreviouslyProcessed".
     */
    currentTabId: "PreviouslyProcessed",

    /**
     * This variable keeps track of whether the preferred language is updated
     */
    isPreferredLanguageUpdated: false,

    /**
     * This variable stores the current dropdown dialog element.
     * @private
     */
    dropDownDlg: null,

    /**
     * This variable stores the identifier of the tab currently being displayed in the recurring order details page.
     * The default value is "recurring_order_details".
     */
    currentOrderTabId: "recurring_order_details",

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
     * set the isPreferredLanguageUpdated variable
     * @param {boolean} value either true or false. True if preferred language is updated. False otherwise.
     */
    setPreferredLanguageUpdated: function (value) {
        this.isPreferredLanguageUpdated = value;
    },

    /**
     * return a boolean value which indicates whether preferred lanaguage is changed.
     */
    getPreferredLanguageUpdated: function () {
        return this.isPreferredLanguageUpdated;
    },

    /**
     * set the subscriptionDate variable
     * @param {string} The expiry date of the subscription to be renewed.
     */
    setSubscriptionDate: function (value) {
        this.subscriptionDate = value;
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
     * update the last order record info for current page in render context
     * @param {string} The context id.
     * @param {Integer} The begin index for next page or previous page.
     * @param {Integer} The page size.
     * @param {boolean} value either true or false. True if it's for quote. False otherwise.
     * @param {Integer} The current page number.
     * @param {string} The last order external id in current page.
     * @param {string} The last order record info in render context.
     * @param {boolean} value either true or false. True if it's for next page. False otherwise.
     * @param {integer} The record set total.
     */
    updateRenderContextForPagination:function(contextId, beginIndex, pageSize, isQuote, currentPage, lastExtOrderId, lastRecordInfoInContext, nextOrNot, recordSetTotal){
        var currentBeginIndex;
        var lastRecordInfo = this.getLastRecordInfo(currentPage, lastExtOrderId, lastRecordInfoInContext, nextOrNot);
        if(!nextOrNot){
            currentBeginIndex = parseInt(beginIndex) - parseInt(pageSize);

        }else{
            currentBeginIndex = parseInt(beginIndex) + parseInt(pageSize);
        }
        wcRenderContext.updateRenderContext(contextId,{'beginIndex':currentBeginIndex,'pageSize':pageSize,'isQuote':isQuote,'lastExternalOrderIds':lastRecordInfo,'recordSetTotal':recordSetTotal});
    },

    escapeXML: function(value) {
        //don't use jazz.util.html.escape(value). This function doesn't encode character "
        if (!value) {
            return ProcessAuthoringConstants.EMPTY;
        }
        return value.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\"/g, "&quot;").replace(/\'/g, "&#039;"); //$NON-NLS-1$ //$NON-NLS-2$  //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
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
     * Hides the tab with the specified identifier.
     * This function unhides the 'off' tab,
     * and hides the 'on' tab by setting the style.display attribute respectively.
     *
     * @param {string} id The identifier of the HTML element representing the tab to hide.
     */
    setOff:function(id){
        document.getElementById(id+"_On").style.display = "none";
        document.getElementById(id+"_Off").style.display = "inline";
        document.getElementById(id).style.display = "none";
    },

    /**
     * Displays the tab with the specified identifier.
     * This function unhides the 'on' tab,
     * and hides the 'off' tab by setting the style.display attribute respectively.
     *
     * @param {string} id The identifier of the HTML element representing the tab to display.
     */
    setOn:function(id){
        document.getElementById(id+"_On").style.display = "inline";
        document.getElementById(id+"_Off").style.display = "none";
        document.getElementById(id).style.display = "block";
    },

    /**
     * Switches a tab selection to the tab specified by 'tabId' parameter.
     * Turns off the currently selected tab and hides it's content.
     * Also, this function turns on the tab indicated by the 'tabId' and displays it's contents.
     *
     * @param {string} tabId The HTML element identifier to turn 'on'.
     */
    selectTab:function(tabId){
        this.currentSelection='trackOrderStatus';
        this.setOff(this.currentTabId);
        this.setOn(tabId);
        this.currentTabId = tabId;
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
     * This function sets the url for subscriptionrenew service and then it invokes the service to renew the subscription.
     * @param {string} SubscriptionCopyURL The url for the subscription copy service.
     */
    prepareSubscriptionRenew:function(SubscriptionCopyURL){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        wcService.getServiceById("SubscriptionRenew").url = SubscriptionCopyURL;
        wcService.invoke("SubscriptionRenew");
    },


    /**
     * This function sets the parameters for the AjaxScheduledOrderCancel service and invokes the service to cancel the order.
     * @param {Integer} orderId The Id of the order to cancel.
     */
    cancelScheduledOrder:function(orderId){

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        var params = [];
        params["orderId"] = orderId;
        params["URL"] = "";
        params["storeId"] = MyAccountServicesDeclarationJS.storeId;
        params["catalogId"] = MyAccountServicesDeclarationJS.catalogId;
        params["langId"] = MyAccountServicesDeclarationJS.langId;
        wcService.invoke("AjaxScheduledOrderCancel", params);
    },

    /**
     *  This function will highlight the selection in MyAccount left sidebar. When the user clicks on any of the links in left sidebar,
     *  the link is made bold indicating that it is selected.
     *  @param {string} url This is the url of the link that is selected in the left sidebar.
     */
    changeSelection: function(url){
        var start = url.indexOf("currentSelection",0);
        if(start != '-1'){
            var end = url.indexOf("Slct",start);
            var id= url.substring(start+17,end);
        }
        /*The previously highlighted link is deselected. */
        if(this.currentSelection){
            document.getElementById(this.currentSelection).setAttribute("class","");
            document.getElementById(this.currentSelection).setAttribute("className","");/*For IE */
        }
        document.getElementById('MyAccountBreadcrumbLink').style.display = "none";
        if(document.getElementById("RecurringOrderBreadcrumb")){
            document.getElementById("RecurringOrderBreadcrumb").style.display = "none";
            document.getElementById("RecurringOrderBreadcrumb1").style.display = "none";
        }
        if(document.getElementById("SubscriptionBreadcrumb")){
            document.getElementById("SubscriptionBreadcrumb").style.display = "none";
            document.getElementById("SubscriptionBreadcrumb1").style.display = "none";
        }
        if(document.getElementById("OrderHistoryBreadcrumb")){
            document.getElementById("OrderHistoryBreadcrumb").style.display = "none";
            document.getElementById("OrderHistoryBreadcrumb1").style.display = "none";
        }
        if(id){
            if(id == "trackOrderStatus"){
                document.getElementById("OrderHistoryBreadcrumb1").style.display = "inline";
            }
            else if(id == "OrderDetail"){
                document.getElementById("OrderHistoryBreadcrumb").style.display = "inline";
                var start1 = url.indexOf("breadCrumb",0);
                if(start1 != '-1'){
                    var end1 = url.indexOf("Brcmb", start1);
                    var id1 = url.substring(start1+11, end1);
                }
                id1 = id1.replace(/%[0-9]*B/g," ");
                document.getElementById("OrderHistoryDetailBreadcrumbLink").innerHTML = id1.replace(/\+/g, " ");
            }
            else if(id == "trackRecurringOrderStatus"){
                document.getElementById("RecurringOrderBreadcrumb1").style.display = "inline";
            }
            else if(id == "RecurringOrderDetail"){
                document.getElementById("RecurringOrderBreadcrumb").style.display = "inline";
                var start1 = url.indexOf("breadCrumb",0);
                if(start1 != '-1'){
                    var end1 = url.indexOf("Brcmb", start1);
                    var id1 = url.substring(start1+11, end1);
                }
                id1 = id1.replace(/%[0-9]*B/g," ");
                document.getElementById("RecurringOrderDetailBreadcrumbLink").innerHTML = id1.replace(/\+/g, " ");
            }
            else if(id == "trackSubscriptionStatus"){
                document.getElementById("SubscriptionBreadcrumb1").style.display = "inline";
            }
            else if(id == "SubscriptionDetail"){
                document.getElementById("SubscriptionBreadcrumb").style.display = "inline";
                var start1 = url.indexOf("breadCrumb",0);
                if(start1 != '-1'){
                    var end1 = url.indexOf("Brcmb", start1);
                    var id1 = url.substring(start1+11, end1);
                }
                id1 = id1.replace(/%[0-9]*B/g," ");
                document.getElementById("SubscriptionDetailBreadcrumbLink").innerHTML = id1.replace(/\+/g, " ");
            }
            /* The newly selected link is highlighted. */
            else if(document.getElementById(id)){
                document.getElementById('MyAccountBreadcrumbLink').style.display = "inline";
                document.getElementById(id).setAttribute("class","strong");
                document.getElementById(id).setAttribute("className","strong");/* For IE */
                this.currentSelection = id;
            }
        }
        else{
            document.getElementById('MyAccountBreadcrumbLink').style.display = "inline";
        }
    },

    /**
     * This function enables customers to update their current personal information. The user can also
     * update their password through this function.
     * @param {string} form The name of the form containing personal information of the customer.
     * @param {string} logonPassword The value of the 'password' field.
     * @param {string} logonPasswordVerify The value of the 'verify password' field.
     */
    prepareSubmit:function(form,logonPassword,logonPasswordVerify){

        /** Uses the common validation function defined in AddressHelper class for validating first name,
         *  last name, street address, city, country/region, state/province, ZIP/postal code, e-mail address and phone number.
         */

        if(!AddressHelper.validateAddressForm(form)){
            return;
        }

        /* Checks whether the customer has registered for promotional e-mails. */
        if(form.sendMeEmail && form.sendMeEmail.checked){
            form.receiveEmail.value = true;
        }
        else {
            form.receiveEmail.value = false;
        }

        if(form.sendMeSMSNotification && form.sendMeSMSNotification.checked){
            form.receiveSMSNotification.value = true;
        }
        else {
            form.receiveSMSNotification.value = false;
        }

        if(form.sendMeSMSPreference && form.sendMeSMSPreference.checked){
            form.receiveSMS.value = true;
        }
        else {
            form.receiveSMS.value = false;
        }

        if(form.mobileDeviceEnabled != null && form.mobileDeviceEnabled.value == "true"){
            if(!this.validateMobileDevice(form)){
                return;
            }
        }
        if(form.birthdayEnabled != null && form.birthdayEnabled.value == "true"){
            if(!this.validateBirthday(form)){
                return;
            }
        }

        /* For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }

        processAndSubmitForm(form);
        if(CSRWCParamJS.env_shopOnBehalfSessionEstablished != "true"){
            // Update shopperName only if they are updating it for themself.
            // If CSR is updating onBehalf of shopper, then no need to update the logonUserId.
            // LogonUserId will be of CSR in that case and it doesn't match with shopper name read from personal information form.
            var shopperName = getCookie("WC_LogonUserId_"+WCParamJS.storeId);
            if (trim(shopperName) != (form.firstName.value + " " + form.lastName.value)){
                setCookie("WC_LogonUserId_"+WCParamJS.storeId, form.firstName.value + " " + form.lastName.value , {path:'/', domain:cookieDomain});
            }
        }
    },

    /**
     *  This function opens up the passed in url in a new browser window.
     *  @param {string} URL The url to be invoked from the new window.
     */
    popupWindow:function(URL) {

        window.open(URL, "mywindow", "status=1,scrollbars=1,resizable=1");
    },

   /**
    * This function removes a coupon. If a customer has a that has not been applied to an order
    * then this function can be used to remove that coupon from the customer's coupon wallet.
    * @param {string} formName The name of the form that contains the table which holds the coupon to be deleted.
    * @param {string} returnView The view to return to after the request has been processed.
    * @param {string} couponId The unique ID of the coupon. This is set in the form to be sent to the service.
    */

    deleteCoupon:function(formName,couponId)
    {

        var form = document.forms[formName];

        form.couponId.value = couponId;
        form.taskType.value= "D";

        /* For Handling multiple clicks. */
        if(!submitRequest()){
             return;
        }
        var service = wcService.getServiceById('AjaxRESTWalletCouponsDelete');
        service.setFormId(formName);
        //CommonContextsJS.setContextProperty("CouponDisplay_Context","returnView",returnView);
        cursor_wait();
        wcService.invoke('AjaxRESTWalletCouponsDelete');
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
        // Destroy the action drop down associated with this recurring order/subscription
        $("[data-widget-type='wc.WCDialog'][data-popupIndex='" + popupIndex + "']").data("wc-WCDialog").destroy();

        var params = {
            subscriptionId: subscriptionId,
            URL: "",
            storeId: MyAccountServicesDeclarationJS.storeId,
            catalogId: MyAccountServicesDeclarationJS.catalogId,
            langId: MyAccountServicesDeclarationJS.langId
        };
        wcService.invoke("AjaxCancelSubscription", params);
    },

    /**
     * Updates the list of contracts that are available to the current user.
     * @param {string} formName  The name of the form that contains the table of selected contracts.
      * @param {string} currentContracts  The IDs of the active contracts that are in the current trading agreement.
      * @param {string} errorMessage  An error message ID which displays the error message thrown by the server
      * and is to be displayed if the optional parameter is passed in.
     */
    updateContract:function(formName, currentContracts, errorMessage){
        var form = document.forms[formName];
        var selected = false;

        /* For Handling multiple clicks. */
        if(!submitRequest()){ return; }

        if(form.contractId.length != undefined){
            for(var i = 0; i < form.contractId.length; i++){
                if(form.contractId[i].checked){
                    selected = true;
                    break;
                }
            }
            if(!selected){
                var current = currentContracts.split(";");
                for(var t = 0; t < current.length; t++){
                    document.getElementById("WC_B2BMyAccountParticipantRole_checkbox_"+current[t]).checked = true;
                }
                MessageHelper.displayErrorMessage(errorMessage);
                resetRequest();
            }
        }else if(form.contractId.checked){
            selected = true;
        }else{
            document.getElementById("WC_B2BMyAccountParticipantRole_checkbox_"+form.contractId.value).checked = true;
            MessageHelper.displayErrorMessage(errorMessage);
            resetRequest();
        }

        if(selected){
            processAndSubmitForm(form);
        }
    },

    /**
     * Changes the organization that is used by the current user.
     * @param {string} formName  The name of the form that contains the table with the selected organization.
     */
    updateOrganization:function(formName){
        var form = document.forms[formName];
        /* For Handling multiple clicks. */
        if(!submitRequest()){ return; }
        processAndSubmitForm(form);
    },

    /**
     * This function forms history state object for history tracking.
     * @param {string} workAreaModeValue A value to uniquely identify a context, which is among the following:
     * myAccountMain, personalInformation, addressBook, checkoutProfile, wishList,trackOrderStatus, mycoupons ,bookmarkedPage
     * @param {string} elementId The id of the widget.
     * @param {string} changeUrl url to update the context of the refresh area.
     */
    HistoryTracker:function(workAreaModeValue, elementId, changeUrl){

        this.workAreaModeValue = workAreaModeValue;
        this.elementId = elementId;
        this.changeUrl =  changeUrl;

    },

    /**
     * This function validates the customer's input for birthday, i.e. whether the year/month/date combination is correct.
     * @param {string} form The name of the form containing personal information of the customer.
     *
     * @return {boolean} This indicates whether the birthday entered is valid or not.
     */

    validateBirthday: function(form){
        if(form.birth_year != null && form.birth_month != null && form.birth_date != null){
            if(form.birth_year.value != 0 || form.birth_month.value != 0 || form.birth_date.value != 0){
                /* if any of the year/month/date fields contains non-empty inforamtion, validate. */
                if(form.birth_month.value == 0){
                    MessageHelper.formErrorHandleClient(form.birth_month.id + "-button", MessageHelper.messages["ERROR_SpecifyMonth"]);
                    return false;
                }
                if(form.birth_date.value == 0){
                    MessageHelper.formErrorHandleClient(form.birth_date.id + "-button", MessageHelper.messages["ERROR_SpecifyDate"]);
                    return false;
                }

                /* set the number of days in Feburary for validation. */
                var febDays = 29;
                if(form.birth_year.value != 0 && ((form.birth_year.value % 4) != 0)){
                    febDays = 28;
                }

                var months = ["4","6","9","11"]; /* these months only have 30 days in total. */
                var monthFound = false;
                for(var i=0; i<months.length; i++){
                    if(months[i] == form.birth_month.value){
                        monthFound = true;
                        break;
                    }
                }
                if(monthFound && (form.birth_date.value > 30)){
                    /* if month entered is April/June/Sept/Nov, check if the date is larger than 30 */
                    MessageHelper.formErrorHandleClient(form.birth_date.id + "-button", MessageHelper.messages["ERROR_InvalidDate1"]);
                    return false;
                }

                if((form.birth_month.value == 2) && (form.birth_date.value > febDays)){
                    /* in the case if the month entered is Feburary, validate the date against febDays. */
                    MessageHelper.formErrorHandleClient(form.birth_date.id + "-button", MessageHelper.messages["ERROR_InvalidDate1"]);
                    return false;
                }
                if(form.curr_year != null && form.curr_month != null && form.curr_date != null){
                    var birth_year = parseInt(form.birth_year.value);
                    var birth_month = parseInt(form.birth_month.value);
                    var birth_date = parseInt(form.birth_date.value);

                    var curr_year = parseInt(form.curr_year.value);
                    var curr_month = parseInt(form.curr_month.value);
                    var curr_date = parseInt(form.curr_date.value);

                    if(birth_year > curr_year){
                        /* if birth year entered is in the future. */
                        MessageHelper.formErrorHandleClient(form.birth_year.id + "-button", MessageHelper.messages["ERROR_InvalidDate2"]);
                        return false;
                    }else if((birth_year == curr_year) && (birth_month > curr_month)){
                        /* if birth year entered is the same as the current year, then check the month entered. */
                        MessageHelper.formErrorHandleClient(form.birth_month.id + "-button", MessageHelper.messages["ERROR_InvalidDate2"]);
                        return false;
                    }else if((birth_year == curr_year) && (birth_month == curr_month) && (birth_date > curr_date)){
                        /* if birth year and month entered are the same as the current year and month, then check the date entered. */
                        MessageHelper.formErrorHandleClient(form.birth_date.id + "-button", MessageHelper.messages["ERROR_InvalidDate2"]);
                        return false;
                    }else{
                        /* the date of birth provided is valid, now verify if the user is under age. */
                        if(form.dateOfBirthTemp != null){
                            if(form.birth_month.value != 0 && form.birth_date.value != 0){
                                var final_birth_year = birth_year;
                                var final_birth_month = birth_month;
                                var final_birth_date = birth_date;
                                if(birth_year == 0){
                                    /* If the user does not specify the year in his/her date of birth, set the year to 1896. */
                                    final_birth_year = 1896;
                                }
                                if(birth_month < 10){
                                    final_birth_month = '0' + birth_month;
                                }
                                if(birth_date < 10){
                                    final_birth_date = '0' + birth_date;
                                }
                                form.dateOfBirthTemp.value = final_birth_year + '-' + final_birth_month + '-' + final_birth_date;
                                document.getElementById(form.dateOfBirthTemp.id).name = 'dateOfBirth';
                            }else{
                                form.dateOfBirthTemp.value = null;
                            }
                        }
                    }
                }
                return true;
            }else{
                if(form.dateOfBirthTemp != null){
                    form.dateOfBirthTemp.value = "";
                    if(document.getElementById(form.dateOfBirthTemp.id) != null){
                        document.getElementById(form.dateOfBirthTemp.id).name = 'dateOfBirth';
                    }
                }
                return true;
            }
        }
        return true;
    },

    /**
     *  This function validates the Mobile phone number provided by the customer.
     *  The Mobile Phone number option is not a required input by default, but if the customer has entered something,
     *  this method will be called to validate the mobile phone information entered by the customer.
     *  @param {string} form The name of the registration form containing the customer's mobile phone number.
     *  @return {boolean} returns true if the mobile number entered is valid, else returns false.
     */

    validateMobileDevice: function(form){
        if(form.mobilePhone1 != null && form.mobilePhone1!="" ){
            if(!MessageHelper.isValidUTF8length(form.mobilePhone1.value, 32)){
                MessageHelper.formErrorHandleClient(form.mobilePhone1.id, MessageHelper.messages["ERROR_PhoneTooLong"]);
                return false;
            }

            if(!MessageHelper.IsValidPhone(form.mobilePhone1.value)){
                MessageHelper.formErrorHandleClient(form.mobilePhone1.id, MessageHelper.messages["ERROR_INVALIDPHONE"]);
                return false;
            }
        }
        return true;
    },

    /**
     * Displays the actions list drop down panel.
     * @param {object} event The event to retrieve the input keyboard key.
     * @param {string} dialogId The id of the content pane containing the action popup details
     */
    showActionsPopup: function(event, dialogId){
        if(event == null || event.keyCode == KeyCodes.DOWN_ARROW){
            var dialog = $("#" + dialogId).data("wc-WCDialog");
            if(dialog) {
                this.dropDownDlg = dialog;
                this.dropDownDlg.open();
            }
        }

    },

    /**
     *This function displays the Recurring Order / Subscription action popup.
     *@param {String} action This variable can be either reccuring_order or subscription.
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
            document.getElementById("Cancel_yes_"+action).setAttribute("onclick", "MyAccountDisplay.cancelRecurringOrder("+ subscriptionId + "," + popupIndex + ");");

            if(document.getElementById("cancel_notice_"+action) && document.getElementById(message)){
                $("#cancel_notice_"+action).html($("#" + message).val());
            }
        }else {
            console.debug("Cancel_subscription_popup"+" does not exist");
        }
    },

    /**
     * Switches a tab selection to the tab specified by 'tabId' parameter.
     * Turns off the currently selected tab and hides it's content.
     * Also, this function turns on the tab indicated by the 'tabId' and displays it's contents.
     *
     * @param {string} tabId The HTML element identifier to turn 'on'.
     */
    selectRecurringOrderTab:function(tabId){

        this.setOff(this.currentOrderTabId);
        this.setOn(tabId);
        this.currentOrderTabId = tabId;
    }
}
