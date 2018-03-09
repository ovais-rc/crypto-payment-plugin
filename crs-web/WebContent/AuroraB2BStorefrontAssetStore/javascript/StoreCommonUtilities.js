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

wcTopic.subscribe("ajaxRequestInitiated", incrementNumAjaxRequest);
wcTopic.subscribe("ajaxRequestCompleted", decrementNumAjaxRequest);
wcTopic.subscribe("ajaxRequestCompleted", initializeInactivityWarning);

/**
 * @fileOverview This file provides the common functions which are specific to the Aurora store.
 * This JavaScript file is used by StoreCommonUtilities.jspf.
 */

// Handle Order error.
wcTopic.subscribe("OrderError", function (errorObj){
    if(errorObj.errorCode == 'CMN4512I'){
        //CMN4512I is OrderLocked error. So refresh miniCart.
        setDeleteCartCookie();
        //Since cart cookie is deleted, we don't need to pass currency/lang. It will be fetched from server
        loadMiniCart(null,null);
    }
});

/** This variable indicates whether the dropdown is shown or not. */
var showDropdown = false;

/** This variable stores the current dropdown dialog element. */
var dropDownDlg = null;

/** This variable stores the current product added dropdown dialog element. */
var productAddedDropDownDlg = null;

/** This variable is used to store the width of the mini shopping cart on page load. It is used when shopper's browser is IE6. */
var originalMiniCartWidth = 0;

/** This variable indicates whether the browser used is Internet Explorer or not. */
var isIE = (document.all) ? true : false;

/** Initializes the variable to false. **/
    var correctBrowser = false;

/**
 * This variable indicates whether a request has been submitted or not.
 * The value is initialized to true and resets to false on full page load.
 */
var requestSubmitted = true;

/**
 * This variable stores the id of the element (ex: button/link) which the user clicked.
 * This id is set when the user clicks an element which triggers an Ajax request.
 */
var currentId = "";

/**
 * This variable keeps track of the number of active ajax requests currently running on the page
 * The value is initialized to 0.
 */
var numAjaxRequests = 0,

widgetsList = [];

/**
 * Variable to save whether a tab or shift-tab was pressed
 */
var tabPressed = false;

/** This variable is used to keep track of the quick info/compare touch events */
var currentPopup = '';

/** This variable indicates whether Android is used or not */
var android = null;

/** This variable indicates whether iOS is used or not */
var ios = null;

/**
 * This variable contains the cookie domain for current store cookies.
 * Modify the cookie domain once here and it will be applied everywhere else for the particular store.
 */
var cookieDomain = "";

/** Base Text Direction Preference */
var _BTD_PREFS = "WC_Base_Text_Direction",

detectedLocale = Utils.getLocale();

/**
 * Initialize the client side inactivity warning dialog, this function is called at every page load and at
 * every the time when ajax request completed.  Be default, 30 seconds before the session timeout, a dialog
 * will popup and display a warning to let the user to extend the time.  The timing of when the dialog
 * will be displayed can be modified with "inactivityWarningDialogBuffer" variable in CommonJSToInclude.jspf
 */
function initializeInactivityWarning() {

    // only set timer if user is not guest, in a full-auth session, and is able to retrieve inactivityTimeout from server
    if (storeUserType != "G" && inactivityTimeout != 0 && document.cookie.indexOf("WC_USERACTIVITY_") > 0) {
        // Reset the inactivity timer dialog
        if (inactivityTimeoutTracker != null) {
            clearTimeout(inactivityTimeoutTracker);
        }

        // setup the inactivity timout tracker
        inactivityTimeoutTracker = setTimeout(showInactivityWarningDialog, inactivityTimeout - inactivityWarningDialogBuffer);
    }
}

/**
 * Show the inactivity warning dialog, the dialog will be closed in 20 seconds.  The timing of when the dialog
 * will be closed can be modified with "inactivityWarningDialogDisplayTimer" variable in CommonJSToInclude.jspf
 */
function showInactivityWarningDialog() {
    $("#inactivityWarningPopup").data("wc-WCDialog").open();
    if (dialogTimeoutTracker != null) {
        clearTimeout(dialogTimeoutTracker);
    }
    dialogTimeoutTracker = setTimeout(hideInactivityWarningDialog, inactivityWarningDialogDisplayTimer);
}

/**
 * Hide the inactivity warning dialog
 */
function hideInactivityWarningDialog() {
    $("#inactivityWarningPopup").hide();
}

/**
 * Send a Ping request to server to reset the inactivity timer.  The client side timer to display the inactivity warning
 * dialog will also be reset.
 */
function resetServerInactivity() {
    $.post({
        url: getAbsoluteURL() + "Ping",
        //handleAs: "json-comment-filtered",
        success: function(data, textStatus, jqXHR) {
            if (data.success) {
                initializeInactivityWarning();
            } else {
                console.error("Ping service failed");
            }
        },
        error: function(jqXHR, textStatus, error) {
            console.error("Ping service failed");
        }
    });
}

/**
 * DOM Shorthand
 */
function byId(r){
    return document.getElementById(r);
}

/**
 * Sends back focus to the first focusable element on tabbing from the last focusable element.
 */
function focusSetter(){
    if($("#MiniCartFocusReceiver1").length)
        $("#MiniCartFocusReceiver1").focus();
    else
        $("#MiniCartFocusReceiver2").focus();
}

/**
 * Sends back focus to the last focusable element on reverse tabbing from the first focusable element.
 *
 * @param {object} event The event triggered from user actions
 */
function determineFocus(event) {
        if(event.shiftKey && event.keyCode === KeyCodes.TAB)
        {
            if(event.srcElement)
            {
                if(event.srcElement.id=="MiniCartFocusReceiver1")
                {
                    $("#WC_MiniShopCartDisplay_link_5").focus();
                    Utils.stopEvent(event);
                }
                else if(event.srcElement.id=="MiniCartFocusReceiver2")
                {
                    $("#MiniCartFocusReceiver2").focus();
                    Utils.stopEvent(event);
                }
            }
            else
            {
                if(event.target.id=="MiniCartFocusReceiver1")
                {
                    $("#WC_MiniShopCartDisplay_link_5").focus();
                    Utils.stopEvent(event);
                }
                else if(event.target.id=="MiniCartFocusReceiver2")
                {
                    $("#MiniCartFocusReceiver2").focus();
                    Utils.stopEvent(event);
                }
            }
        }
}

/**
 * Destroys the existing dialogs with outdated data.
 * @param {string} contentId The identifier of the dialog to destroy. If undefined, the default is 'quick_cart_container'.
 */
function destroyDialog(contentId){
    if(contentId == undefined){
        contentId = 'quick_cart_container';
    }
    //If data has changed, then we should destroy the quick_cart_container dialog and recreate it with latest data
    var dialog = $("#" + contentId).data("wc-WCDialog");
    if (dialog) {
        dialog.destroy();
    }

    if(contentId != undefined && contentId == 'quick_cart_container'){
         dropDownDlg = null;
    } else {
        productAddedDropDownDlg = null;
    }
}

/**
 * Loads the specified URL.
 *
 * @param {string} url The URL of the page to be loaded.
 */
function loadLink(url){
    document.location.href=url;
}

/**
 * Clears the Search term string displayed in Simple Search field.
 */
function clearSearchField() {
    searchText = $("#SimpleSearchForm_SearchTerm").val()
    if(searchText == $("#searchTextHolder").html()){
        $("#SimpleSearchForm_SearchTerm").val("");
    }
    else{
        document.getElementById("SimpleSearchForm_SearchTerm").select();
        showAutoSuggestIfResults();
        autoSuggestHover = false;
    }
}

/**
 * Displays the Search term string in Simple Search field.
 */
function fillSearchField() {
    if ($("#SimpleSearchForm_SearchTerm").val()== "") {
        document.getElementById("SimpleSearchForm_SearchTerm").className = "search_input gray_color";
        $("#SimpleSearchForm_SearchTerm").val($("#searchTextHolder").html());
    }
    // hide the search box results
    if(!autoSuggestHover) {
        showAutoSuggest(false);
    }
}

/**
 * Displays the top dropdown menu, including the category dropdowns and the mini shopping cart.
 */
function showDropDownMenu(){
    $("#header_menu_dropdown").css("display", "block");
    $("#outerCartContainer").css("display", "block");
}

/**
 * Displays the progress bar dialog to indicate a request is currently running.
 * There are certain cases where displaying the progress bar causes problems in Opera,
 * the optional parameter "checkForOpera" is passed to specifically check if the browser used is Opera,
 * if so, do not display the progress bar in these cases.
 *
 * @param {boolean} checkForOpera Indicates whether to check if the browser is Opera or not.
 */
function cursor_wait(checkForOpera) {
    var showPopup = true;

    //Since dijit does not support Opera
    //Some progress bar dialog will be blocked in Opera to avoid error
    if(checkForOpera == true){
        if(Utils.isOpera()){
            showPopup = false;
        }
    }

    //For all other browsers and pages that work with Opera
    //Display the progress bar dialog
    if(showPopup){
        //Delay the progress bar from showing up
        setTimeout('showProgressBar()',500);
    }
}

/**
 * Helper method for cursor_wait() to display the progress bar pop-up.
 * Displays progress bar, next to the element if the element id was specified in currentId,
 * or defaults to the center of the page if currentId is empty.
 * Progress bar will only be displayed if the submitted request has not been completed.
 * This method is only called implicitly by the cursor_wait() method, which is triggered before a request is submitted.
 */
function showProgressBar(){
    //After the delay, if the request is still not finished
    //Then continue and show the progress bar
    //Otherwise, do not execute the following code
    if(!requestSubmitted){
        return;
    }

    displayProgressBar();

}


/**
 * Helper method for showProgressBar() to display the progress bar pop-up.
 * It can also be forced to show the progress bar directly in special cases.
 * The function also displays the progress bar next to the element if the element id was specified in currentId,
 * or defaults to the center of the page if currentId is empty.
 * This method can be called implicitly by the cursor_wait() method or explicitly by itself.
 */
function displayProgressBar() {
    var dialog = $('#progress_bar_dialog').data("wc-WCDialog");

    //Make sure the dialog is created
    if (dialog) {

        var progressBar = $('#progress_bar');
        progressBar.css("display", "block");

        //Check whether or not an element ID is provided
        //If yes, point the progress bar to this element
        //Otherwise, show the progress bar in a dialog
        if (this.currentId !== "") {
            dialog.option("position", {
                my: "left top",
                at: "right top",
                of: $("#" + this.currentId)
            });
        } else {
            //dialog.containerNode.innerHTML === "";
            progressBar.css("left", '');
            progressBar.css("top", '');
            dialog.element.html(progressBar);
            //dialog.containerNode.appendChild(progressBar);

        }
        dialog.open();
        //Make sure the progress bar dialog goes away after 30 minutes
        //and does not hang if server calls does not return
        //Assuming the longest server calls return before 30 minutes
        setTimeout("cursor_clear()", 1800000);
    }
}

/**
 * Stores the id of the element (ex: button/link) that triggered the current submitted request.
 * Store the new element id only when no request is currently running.
 *
 * @param {string} id The id of element triggering the submitted request.
 */
function setCurrentId(id){
    //If there is no request already submitted, update the id
    if(!requestSubmitted && this.currentId === ""){
        this.currentId = id;
    }
}

/**
 * This function trims the spaces from the pased in word.
 * Delete all pre and trailing spaces around the word.
 *
 * @param {string} inword The word to trim.
 */
function trim(inword)
{
    word = inword.toString();
    var i = 0,
    j = word.length-1;
    while(word.charAt(i) == " ") i++;
    while(word.charAt(j) == " ") j=j-1;
    if (i > j) {
        return word.substring(i,i);
    } else {
        return word.substring(i,j+1);
    }
}

/**
 * Hides the progress bar dialog when the submitted request has completed.
 * Set the visibility of the progress bar dialog to hide from the page.
 */
function cursor_clear() {
    //Reset the flag
    requestSubmitted = false;

    wcTopic.publish("requestSubmittedChanged", requestSubmitted);
    //Hide the progress bar dialog
    var dialog = $('#progress_bar_dialog').data("wc-WCDialog"),
    progressBar = document.getElementById('progress_bar');
    if(dialog != null){
        if(progressBar != null){
            $(progressBar).css("display", 'none');
        }
        dialog.close();
        this.currentId="";
    }
}

function escapeXml (str, fullConversion){
    if(fullConversion){
        str = str.replace(/&(?!(quot;|#34;|#034;|#x27;|#39;|#039;))/gm, "&amp;").replace(/</gm, "&lt;").replace(/>/gm, "&gt;");
    }
    str = str.replace(/"/gm, "&#034;").replace(/'/gm, "&#039;");
    return str;
}
/**
 * Checks whether a request can be submitted or not.
 * A new request may only be submitted when no request is currently running.
 * If a request is already running, then the new request will be rejected.
 *
 * @return {boolean} Indicates whether the new request was submitted (true) or rejected (false).
 */
function submitRequest() {
    if(!requestSubmitted) {
        requestSubmitted  = true;
        wcTopic.publish("requestSubmittedChanged", requestSubmitted);
        return true;
    }
    return false;
}

function resetRequest() {
    requestSubmitted = false;
    wcTopic.publish("requestSubmittedChanged", requestSubmitted);
}

/**
 * Set the current page to a new URL.
 * Takes a new URL as input and set the current page to it, executing the command in the URL.
 * Used for Non-ajax calls that requires multiple clicks handling.
 *
 * @param {string} newPageLink The URL of the new page to redirect to.
 */
function setPageLocation(newPageLink) {
    //For Handling multiple clicks
    if(!submitRequest()){
        return;
    }

    document.location.href = newPageLink;
}

/**
 * Submits the form parameter.
 * Requires a form element to be passed in and submits form with its inputs.
 * Used for Non-ajax calls that requires multiple clicks handling.
 *
 * @param {element} form The form to be submitted.
 */
function submitSpecifiedForm(form) {
    if(!submitRequest()){
        return;
    }
    console.debug("form.action == "+form.action);
    processAndSubmitForm(form);
}

/**
 * get location information of a given url
 * @param href
 * @returns url
 */
function getLocation(href) {
    var urlHref = href;
    if (!urlHref.match(/^[a-zA-Z]+:\/\//))
    {
        urlHref = 'http://' + urlHref;
    }
     var urlLocation = document.createElement("a");
     urlLocation.href = urlHref;

     return urlLocation;
}

/**
 * If the return URL belongs to a different domain from the current host,
 * return a blank page while go back button is clicked
 * @param url
 * @returns {String}
 */
function getReturnUrl(url) {
    var returnUrl;
    var urlLocation = this.getLocation(decodeURIComponent(url));
    if (urlLocation.hostname === location.hostname)
         returnUrl = url;
    else returnUrl = 'about:blank';
    location.href = returnUrl;
}

/**
 * solve issues in case cache is turned on, sometimes url is cached with
 * http or https portocol while accessed from an https or http protocol later on.
 * In this case we will match the protocol for ajax calls consistent with document.location.href
 * protocol
 * @param url
 * @returns {URL}
 */
function matchUrlProtocol(url){
	if(!stringStartsWith(url, "http")){
		//If it is relative URL, just return it.
		return url;
	}
    var href = document.location.href,
    index = href.lastIndexOf("s", 4),
    newUrl = url,
    urlIndex = newUrl.lastIndexOf("s", 4);
    if (index != -1 && urlIndex == -1){
         newUrl=newUrl.substring(0,4) + "s" + (newUrl.substring(4));
    }
    else if(index == -1 && urlIndex != -1)
    {
        newUrl = newUrl.substring(0,4) + (newUrl.substring(5));
    }
    return newUrl;
}

 /**
  * This function is used to hide an element with the specified id.
  * @param {string} elementId The id of the element to be hidden.
  */

  function hideElementById(elementId){
        $("#" + elementId).css("display", "none");
 }

/**
  * This function is used to display an element with the specified id.
  * @param {string} elementId The id of the element to be displayed.
  */

   function showElementById(elementId){
       $("#" + elementId).css("display", "block");
}

/**
  * This function is used to hide the background image of an element.
  * @param {DomNode} element The node whose background image is to be hidden.
  */
    function hideBackgroundImage(element){
        $(element).css("backgroundImage", 'none');
}

/**
  * This function is used to display the background image of a product onhover.
  * @param {DomNode} element The node for which the product hover background image is to be displayed.
  */

     function showBackgroundImage(element){
        $(element).css("backgroundImage", 'url('+getImageDirectoryPath()+getStyleDirectoryPath()+'product_hover_background.png)');
}
    /**
    * checkIE8Browser checks to see if the browser is IE 8 or less. It then sets correctBrowser to true if it is.
    *
    **/

    function checkIE8Browser() {
       if( Utils.get_IE_version() && Utils.get_IE_version() <= 8 ){
            correctBrowser = true;
       }
   }

    /**
    * ApprovalToolLink provides the appropriate URL if the browser is correct, otherwise displays a message.
    *
    * @param {String} idTag Used to identify the id tag in the jsp that is calling it.
    * @param {String} approvalToolLinkURL This is a URL which is passed from the calling jsp.
    *
    **/

    function ApprovalToolLink(idTag, approvalToolLinkURL) {

        //checks if the browser is IE 8 or less.
        checkIE8Browser();

        if (correctBrowser) {
          RFQwindow=window.open(approvalToolLinkURL);
        }
        else {
          MessageHelper.formErrorHandleClient(idTag,MessageHelper.messages["ERROR_INCORRECT_BROWSER"]); return;
        }
    }


/**
 * Updates view (image/detailed) and starting index of pagination of product display in SetCurrencyPreferenceForm when currency is changed from the drop-down menu.
 * These are later passed as url parameters.
 */

function updateViewAndBeginIndexForCurrencyChange(){
    if($("#fastFinderResultControls").length && document.getElementById('fastFinderResultControls')!='')
    {
        if(document.SetCurrencyPreferenceForm.pageView!=null){
            document.SetCurrencyPreferenceForm.pageView.value = document.FastFinderForm.pageView.value;
        }
        if(document.SetCurrencyPreferenceForm.beginIndex!=null){
            document.SetCurrencyPreferenceForm.beginIndex.value = document.FastFinderForm.beginIndex.value;
        }
    }
    else if($("#CategoryDisplay_Widget").length && document.getElementById('CategoryDisplay_Widget')!='')
    {
        if(wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['pageView'] !== '' && document.SetCurrencyPreferenceForm.pageView!=null){
            document.SetCurrencyPreferenceForm.pageView.value = wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['pageView'];
        }
        if(wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['beginIndex'] !== '' && document.SetCurrencyPreferenceForm.beginIndex!=null){
            document.SetCurrencyPreferenceForm.beginIndex.value = wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['beginIndex'];
        }
    }
    else if($("#Search_Result_Summary").length && document.getElementById('Search_Result_Summary')!='')
    {
        if(wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsView'] !== '' && document.SetCurrencyPreferenceForm.pageView!=null){
            document.SetCurrencyPreferenceForm.pageView.value = wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsView'];
        }
        if(wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsPageNum'] !== '' && document.SetCurrencyPreferenceForm.beginIndex!=null){
            document.SetCurrencyPreferenceForm.beginIndex.value=wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsPageNum']
        }
    }
    else if($("#Search_Result_Summary2").length && document.getElementById('Search_Result_Summary2')!='')
    {
        if(wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsView'] !== '' && document.SetCurrencyPreferenceForm.pageView!=null){
            document.SetCurrencyPreferenceForm.pageView.value = wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsView'];
        }
        if(wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsPageNum'] !== '' && document.SetCurrencyPreferenceForm.beginIndex!=null){
            document.SetCurrencyPreferenceForm.beginIndex.value=wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsPageNum']
        }
    }

    //allow coshopper to change currency. Only used for coshopping
    try {
        if (window.top._ceaCollabDialog!=undefined || window.top._ceaCollabDialog!=null) {
            $('#SetCurrencyPreferenceForm')[0].URL.value=
                    $('#SetCurrencyPreferenceForm')[0].URL.value + "&coshopChangeCurrency=" +
                    $('#currencySelection').find(":selected").text();
        }
    }catch(err) {
        console.log(err);
    }
}


/**
 * Updates view (image/detailed) and starting index of pagination of product display in LanguageSelectionForm when language is changed from the drop-down menu.
 * These are later passed as url parameters.
 */

function updateViewAndBeginIndexForLanguageChange(){
    if($("#fastFinderResultControls").length && document.getElementById('fastFinderResultControls')!='')
    {
        if(document.LanguageSelectionForm.pageView!= null){
            document.LanguageSelectionForm.pageView.value = document.FastFinderForm.pageView.value;
        }
        if(document.LanguageSelectionForm.beginIndex!= null){
            document.LanguageSelectionForm.beginIndex.value = document.FastFinderForm.beginIndex.value;
        }
    }
    else if($("#CategoryDisplay_Widget").length && document.getElementById('CategoryDisplay_Widget')!='')
    {
        if(wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['pageView'] !== '' && document.LanguageSelectionForm.pageView!= null){
            document.LanguageSelectionForm.pageView.value = wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['pageView'];
        }
        if(wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['beginIndex'] !== '' && document.LanguageSelectionForm.beginIndex!= null){
            document.LanguageSelectionForm.beginIndex.value = wcRenderContext.getRenderContextProperties('CategoryDisplay_Context').properties['beginIndex'];
        }
    }
    else if($("#Search_Result_Summary").length && document.getElementById('Search_Result_Summary')!='')
    {
        if(wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsView'] !== '' && document.LanguageSelectionForm.pageView!= null){
            document.LanguageSelectionForm.pageView.value = wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsView'];
        }
        if(wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsPageNum'] !== '' && document.LanguageSelectionForm.beginIndex!= null){
            document.LanguageSelectionForm.beginIndex.value = wcRenderContext.getRenderContextProperties('catalogSearchResultDisplay_Context').properties['searchResultsPageNum'];
        }
    }
    else if($("#Search_Result_Summary2").length && document.getElementById('Search_Result_Summary2')!='')
    {
        if(wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsView'] !== '' && document.LanguageSelectionForm.pageView!= null){
            document.LanguageSelectionForm.pageView.value = wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsView'];
        }
        if(wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsPageNum'] !== '' && document.LanguageSelectionForm.beginIndex!= null){
            document.LanguageSelectionForm.beginIndex.value = wcRenderContext.getRenderContextProperties('contentSearchResultDisplay_Context').properties['searchResultsPageNum'];
        }
    }

    //appending landId to the URL. Only used for coshopping
    try {
        if (window.top._ceaCollabDialog!=undefined || window.top._ceaCollabDialog!=null) {
            $('#LanguageSelectionForm').attr("action",  $("#LanguageSelectionForm").attr("action") + "&langId=" +
                $('#languageSelection').find(":selected").text());
        }
    }catch(err) {
        console.log(err);
    }
}

/**
 * Displays the header links in two lines.
 */
function showHeaderLinksInTwoLines(){
    if($("#header_links").length){
        if($("#header_links").width() > 750){
            $("#header_links1").css("display", "block");
            $("#headerHomeLink").css("display", "none");
            $("#headerShopCartLink").css("display", "none");
        }
        $("#header_links").css("visibility", "visible");
    }
}

/**
  * Displays the header links in one line.
  */
 function showLinksInOneLine(){
    $("#header_links").css("visibility", "visible");
 }

/**
 * Validates if the input value is a non-negative integer using regular expression.
 *
 * @param {String} value The value to validate.
 *
 * @return {Boolean} Indicates if the given value is a non-negative integer.
 */
function isNonNegativeInteger(value){
    var regExpTester = new RegExp(/^\d*$/);
    return (value != null && value !== "" && regExpTester.test(value));
}

/**
* Validates if the input value is a positive integer.
*
* @param {String} value The value to validate.
*
* @return {Boolean} Indicates if the given value is a positive integer.
*/
function isPositiveInteger(value){
    return (isNonNegativeInteger(value) && value != 0);
}

/**
 * This function closes all dialogs on the page.
 */
function closeAllDialogs(){
    $("[data-widget-type='wc.WCDialog']").each(function (i, e) {
        $(e).hide();
    });
}

/**
 * This function store a error key in the cookie. The error key will be used to retrieve error messages.
 * @param {String} errorKey  The key used to retrieve error/warning messages.
 */
function setWarningMessageCookie(errorKey) {
    setCookie("signon_warning_cookie",errorKey, {path: "/", domain: cookieDomain});
}
/**
* This function removes a cookie
* @param {String} name the name of the cookie to be removed.
*/
function removeCookie(name) {
    setCookie(name, null, {expires: -1});
}
/**
* This function gets a cookie
* @param {String} c the name of the cookie to be get.
*/
function getCookie(c) {
    var cookies = document.cookie.split(";");
    for (var i = 0; i < cookies.length; i++) {
        var index = cookies[i].indexOf("="),
        name = cookies[i].substr(0,index);
        name = name.replace(/^\s+|\s+$/g,"");
        if (name == c) {
            return decodeURIComponent(cookies[i].substr(index + 1));
        }
    }
}

function deleteOnBehalfRoleCookie(){
    var deleteOnBhealfRoleCookieVal = getCookie("WC_OnBehalf_Role_"+WCParamJS.storeId);

    if(deleteOnBhealfRoleCookieVal != null){
        setCookie("WC_OnBehalf_Role_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
    }
}

/**
* This function gets a cookie by name which starts with the provided string
* @param {String} c the partial name (starts with) of the cookie to be get.
*/
function getCookieName_BeginningWith(c) {
    var cookies = document.cookie.split(";");
    for (var i = 0; i < cookies.length; i++) {
        var index = cookies[i].indexOf("="),
        name = cookies[i].substr(0,index);
        name = name.replace(/^\s+|\s+$/g,"");
        if (stringStartsWith(name,c)) {
            return name;
        }
    }
}

/**
* This function checks to see if the string start with the specified set of characters
* @param {String} basestr the string
* @param {String} c the substring to check for
*/
function stringStartsWith(basestr, str) {
    return str.length > 0 && basestr.substring( 0, str.length ) === str
}

/**
 * checks if the store is in preview mode
 * @param {String} contextPathUsed The context path being used by the Store.
 * @param {String} criteria criteria used to check if contextPathUsed is the preview context.
 */
function isStorePreview(contextPathUsed,criteria) {
    return contextPathUsed.indexOf(criteria) > -1;
}

/**
 * checks hides the ESpot info popup window
 * @param {String} The id of the popup dialog
 * @param {String} The browser event
 */
function hideESpotInfoPopup(id,event) {
    if(event!=null && event.type=="keypress" && event.keyCode !== KeyCodes.ESCAPE) {
        return;
    }
    else {
        var quickInfo = $("#" + id);
        if(quickInfo.length) {
            quickInfo.data("wc-WCDialog").close();
        }
    }
}

/**
 * checks shows the ESpot info popup window
 * @param {String} The id of the popup dialog
 * @param {String} The browser event
 */
function showESpotInfoPopup(id, event) {
    if (event != null && event.type == "keypress" && event.keyCode !== KeyCodes.RETURN) {
        return;
    } else {
        if (!parent.checkPopupAllowed()) {
            return;
        }
        var quickInfo = $("#" + id).data("wc-WCDialog");
        if (quickInfo) {
            // Bring this Dialog on top of other dialogs
	        quickInfo.bringToFront(); 
            // Bring this Dialog on top of eSpot overlay button
            quickInfo.bringToFront($(".ESpotInfo"));
            quickInfo.open();    
            quickInfo.reposition();
        }
    }
}

/**
* This function increments the numAjaxRequests counter by 1.
*/
function incrementNumAjaxRequest(){
    if(numAjaxRequests != 'undefined'){
        numAjaxRequests++;
    }
}

/**
* This function decrements the numAjaxRequests counter by 1.
*/
function decrementNumAjaxRequest(){
    if(numAjaxRequests != 'undefined'){
        if(numAjaxRequests != 0){
            numAjaxRequests--;
        }
    }
}

/**
* updateParamObject This function updates the given params object with a key to value pair mapping.
*                   If the toArray value is true, It creates an Array for duplicate entries otherwise it overwrites the old value.
*                   This is useful while making a service call which accepts a few parameters of type array.
*                   This function is used to prepare a a map of parameters which can be passed to XMLHttpRequests.
*                   The keys in this parameter map will be the name of the parameter to send and the value is the corresponding value for each parameter key.
* @param {Object} params The parameters object to add name value pairs to.
* @param {String} key The new key to add.
* @param {String} value The new value to add to the specified key.
* @param {Boolean} toArray Set to true to turn duplicate keys into an array, or false to override previous values for a specified key.
* @param {int} index The index in an array of values for a specified key in which to place a new value.
*
* @return {Object} params A parameters object holding name value pairs.
*
**/
function updateParamObject(params, key, value, toArray, index){

    if(params == null) {
        params = [];
    }
    if(params[key] != null && toArray) {
        if($.isArray(params[key])) {
            //3rd time onwards
            if(index != null && index !== "") {
                //overwrite the old value at specified index
                params[key][index] = value;
            } else {
                params[key].push(value);
            }
        } else {
            //2nd time
            var tmpValue = params[key];
            params[key] = [];
            params[key].push(tmpValue);
            params[key].push(value);
        }
   } else {
       //1st time
       if(index != null && index !== "" && index != -1) {
           //overwrite the old value at specified index
           params[key+"_"+index] = value;
       } else if(index == -1) {
           var i = 1;
           while(params[key + "_" + i] != null) {
               i++;
           }
           params[key + "_" + i] = value;
       } else {
           params[key] = value;
       }
   }
   return params;
 }

/**
 * Show the html element
 *
 * @param {string} id The id of the section to show.
 */
function showSection (id){
    $("#" + id).css("visibility", "visible");
}

/**
 * Hides the html element.
 *
 * @param {string} id The id of the section to hide.
 */
function hideSection (id){
    $("#" + id).css("visibility", "");
}

/**
 * hides the section if the user clicks shift+tab.
 *
 * @param {string} id The id of the div area to hide.
 * @param {event} event The keystroke event entered by the user.
 */
function shiftTabHideSection (id, event){
    if (event.shiftKey && (event.keyCode === KeyCodes.TAB)){
        hideSection(id);
    }
}

/**
 * hides the section if the user clicks tab.
 *
 * @param {string} id The id of the div area to hide.
 * @param {event} event The keystroke event entered by the user.
 */
function tabHideSection (id, event, nextId){
    if (!event.shiftKey && (event.keyCode === KeyCodes.TAB)){
        if(null != nextId){
            $("#" + nextId).focus();
        }
        hideSection(id);
        Utils.stopEvent(event);
    }
}

/**
 * Saves whether the shift and tab keys were pressed or not.  Ignores tab.
 * @param {event} event The event that happened by pressing a key
 */
function saveShiftTabPress(event) {
    if (event.shiftKey == true && event.keyCode === KeyCodes.TAB) {
        tabPressed = true;
    }
}

/**
 * Saves whether the tab key was pressed or not.  Ignores SHIFT-tab.
 * @param {event} event The event that happened by pressing a key
 */
function saveTabPress(event) {
    if (event.shiftKey == false && event.keyCode === KeyCodes.TAB) {
        tabPressed = true;
    }
}
/**
 * Sets the focus to the given form element if a tab or shift-tab was pressed.  Workaround to tabbing from a country dropdown
 * to a dynamic state element that becomes a dropdown when it was a textbox and vice versa.  Defect was Firefox specific.
 * @param {String} formElementId The form element id to set the focus to
 */
function setFocus(formElementId) {
    if (tabPressed) {
        tabPressed = false;
        document.getElementById(formElementId).focus();
    }
}

/**
 * Increase the height of a container due to the addition of a message
 * @param ${String} The id of the container whose height will be increased
 * @param ${Integer} Number of pixels to increase height by
 */
function increaseHeight(containerId, increase) {
    var temp = document.getElementById(containerId).offsetHeight;
    $("#" + containerId).css("height", (temp + increase) + 'px');
}

/**
 * Reload the current page.
 * @param ${forcedUrl} The url which sends user to the expected page.
 */
function redirectToSignOn(forcedUrl) {
	var widgetId = 'Header_GlobalLogin'; // This widgetId is defined in Header_UI.jspf / GlobalLoginActions.js / UserTimeoutView.jsp
	setCookie("WC_RedirectToPage_"+WCParamJS.storeId, forcedUrl, {path:'/', domain:cookieDomain});			
	GlobalLoginJS.InitHTTPSecure(widgetId);
}

/**
 * Keeps track of the current quick info/compare touch event in tablets
 * @param ${String} link The link of the product detail page
 * @param ${String} newPopup The id of the new product quick info/compare touched
 */
function handlePopup(link,newPopup) {
    if (currentPopup == newPopup){
        document.location.href = link;
    } else {
        currentPopup = newPopup;
    }
}

/**
 * Check to see if the device in use is running the android OS
 * @return {boolean} Indicates whether the device is running android
 */
function isAndroid() {
    if(android == null){
        if(navigator != null){
            if(navigator.userAgent != null){
                var ua = navigator.userAgent.toLowerCase();
                android = ua.indexOf("android") > -1;
            }
        }
    }
    return android;
}

/**
 * Check to see if the device in use is running iOS
 * @return {boolean} Indicates whether the device is running iOS
 */
function isIOS() {
    if(ios == null){
        if(navigator != null){
            if(navigator.userAgent != null){
                var ua = navigator.userAgent.toLowerCase();
                ios = (ua.indexOf("ipad") > -1) || (ua.indexOf("iphone") > -1) || (ua.indexOf("ipod") > -1);
            }
        }
    }
    return ios;
}


/**
* This function highlight all marketing spots and catalog objects in preview mode, overwriting the implementation in site level (StorePreviewerHeader.jsp)
*/
function outlineSpots(){
    $(document.body).addClass('editMode');
    $(".carousel > .content").css("zIndex", 'auto');
    $(".ESpotInfo").css("display", "block" );
    $(".searchScore").css("display", "block" );
    $(".editManagedContent").css("display", "block" );
    $(".genericESpot,.product,.searchResultSpot,.productDetail,.categorySpot").each(function (i, currEl) {
        if ($(currEl).hasClass("emptyESpot")) {
            var elementWidth = $('.ESpotInfo', currEl)[0].offsetWidth + 4,
                elementHeight = $('.ESpotInfo', currEl)[0].offsetHeight + 4;
            $(currEl).attr("_width", $(currEl).css('width'));
            $(currEl).attr("_height", $(currEl).css('height'));
            $(currEl).css({
                'width': +elementWidth + 'px',
                'height': elementHeight + 'px'
            });

        }
        if ($(".borderCaption").length) {
            $(currEl).prepend("<div class='borderCaption'></div>");
        } else {
            $(".borderCaption", currEl).css({
                'display': 'block'
            });
        }
        if (currEl.addEventListener) {
            currEl.addEventListener('mouseover', function (evt) {
                if (!window.parent.frames[0].isSpotsShown()) {
                    return;
                }
                $(".caption").css("display", "none"
                );
                $(".caption", this).first().css({
                    display: "block"
                });
                evt.stopPropagation();
            }, false);
            currEl.addEventListener('mouseout', function (evt) {
                if (!window.parent.frames[0].isSpotsShown()) {
                    return;
                }
                $(".caption", this).css({
                    display: "none"
                });
                evt.stopPropagation();
            }, false);
        } else if (currEl.attachEvent) {
            currEl.onmouseover = (
                (function (currEl) {
                    return (function () {
                        if (!window.parent.frames[0].isSpotsShown()) {
                            return;
                        }
                        $(".caption").css("display", "none");
                        $(".caption", currEl).first().css({
                            display: "block"
                        });
                        window.event.cancelBubble = true;
                    });
                })(currEl)
            );
            currEl.onmouseleave = (
                (function (currEl) {
                    return (function () {
                        if (!window.parent.frames[0].isSpotsShown()) {
                            return;
                        }
                        $(".caption", currEl).css({
                            display: "none"
                        });
                        window.event.cancelBubble = true;

                    });
                })(currEl)
            );
        }
    });
}

/**
* This function un-highlight all marketing spots and catalog objects in preview mode, overwriting the implementation in site level (StorePreviewerHeader.jsp)
*/
function hideSpots(){
    $(document.body).removeClass("editMode");
    $(".carousel > .content").css("zIndex", '');
    $(".ESpotInfo").css("display", "none");
    $(".caption").css("display", "none");
    $(".searchScore").css("display", "none");
    $(".editManagedContent").css("display", "none");
    $(".borderCaption").css("display", "none");
    $(".emptyESpot").each(function (i, e) {
        $(e).css({
            'width': $(e).attr("_width") + 'px'
        });
        $(e).css({
            'height': $(e).attr("_height") + 'px'
        });
    });

}

/**
* This function resets the mini cart cookie values, then continues to log off the shopper.
*/
function logout(url){
    setDeleteCartCookie();
    document.location.href = url;
}

/**
 * This function submits the Language and Currency selection form.
 * @param formName The name of the Language and Currency selection form.
 */
function switchLanguageCurrency(formName) {
    //to get the browser current url
    var browserURL = document.location.href,
    currentLangSEO = '/'+$("#currentLanguageSEO").val()+'/';

    // get rid of anything after pound sign(#) in the URL if it is a SearchDisplay request.
    // search processes the query parameters and cannot handle a redirect URL with pound sign(#)
    if ((browserURL.indexOf('SearchDisplay') !== -1 || browserURL.indexOf('CategoryDisplay') !== -1) && browserURL.indexOf('#') !== -1) {
        var poundTokens = browserURL.split('#');
        browserURL = poundTokens[0];
    }

    //set the form URL to the updated URL with the new language keyword
    //for example: replace /en/ with the new keyword
    var modifiedFormURL = browserURL;
    if (browserURL.indexOf(currentLangSEO) !== -1) {
        if (document.getElementById('langSEO'+document.getElementById('languageSelection').options[document.getElementById('languageSelection').selectedIndex].value)) {
            var newLangSEO = '/'+document.getElementById('langSEO'+document.getElementById('languageSelection').options[document.getElementById('languageSelection').selectedIndex].value).value+'/';
            modifiedFormURL = browserURL.replace(currentLangSEO,newLangSEO);
        }
    }
    //replace langId with the newly selected langId
    if (modifiedFormURL.indexOf('&') !== -1) {
        var tokens = modifiedFormURL.split('&');
        modifiedFormURL = "";
        for (var i=0; i<tokens.length; i++) {
            if (tokens[i].indexOf('langId=') === -1) {
                if (modifiedFormURL === '') {
                    modifiedFormURL = tokens[i];
                } else {
                    modifiedFormURL = modifiedFormURL + "&" + tokens[i];
                }
            } else if (tokens[i].indexOf('langId=') > 0) {
                if (i==0) {
                    //langId is the first token next to ?
                    modifiedFormURL = tokens[0].substring(0,tokens[0].indexOf('langId='));
                } else {
                    modifiedFormURL = modifiedFormURL + "&";
                }
                modifiedFormURL = modifiedFormURL + "langId=" + document.getElementById('languageSelection').options[document.getElementById('languageSelection').selectedIndex].value;
            }
        }
    }
    modifiedFormURL = switchLanguageCurrencyFilter(modifiedFormURL);
    document.forms[formName].URL.value = modifiedFormURL;
    document.forms[formName].languageSelectionHidden.value = document.getElementById('languageSelection').options[document.getElementById('languageSelection').selectedIndex].value;

    //hide pop up and submit the form
    $('#widget_language_and_currency_popup').data("wc-WCDialog").close();
    //delete buyOnBehalfOf cookie if exists
    //if (typeof(GlobalLoginShopOnBehalfJS) != 'undefined' && GlobalLoginShopOnBehalfJS != null ){
    //  GlobalLoginShopOnBehalfJS.deleteBuyerUserNameCookie();
    //}
    if (typeof changeStoreViewLanguage == 'function') {
        changeStoreViewLanguage(document.forms[formName].languageSelectionHidden.value);
    }
    document.getElementById(formName).submit();
}

/**
 * This function checks replaces url in a exclusion list with string from the replacement list
 * @param url The url to process
*/
function switchLanguageCurrencyFilter(url) {
    var filterList = [];

    // Add any new exclude and replace view name in filterList
    // exclude UserRegistrationAdd in URL and replace with UserRegistrationForm?new=Y
    var paramList = [{"key": "registerNew", "value": "Y"}];
    filterList.push({"exclude": "UserRegistrationAdd", "replace": "UserRegistrationForm", "param": paramList});

    for (var i=0; i<filterList.length; i++) {
        if (url.indexOf(filterList[i].exclude) > 0) {
            url = url.replace(filterList[i].exclude, filterList[i].replace);
            if (filterList[i].param != undefined) {
                var urlParamList = filterList[i].param;
                for (var j=0; j<urlParamList.length; j++) {
                    url = appendToURL(url, urlParamList[j].key, urlParamList[j].value, false);
                }
            }
            break;
        }
    }
    return url;
}

/**
 * This function check the <code>url</code> <code>paramterName</code> pair against the URLConfig exclusion list.
 * @param url The url to send request.
 * @param parameterName The name of the parameter to be sent with request.
 * @returns {Boolean} True if the parameter and url is not in an exclusion list, false otherwise.
 */
function isParameterExcluded(url, parameterName){
    try{
    if(typeof URLConfig === 'object'){
        if (typeof URLConfig.excludedURLPatterns === 'object'){
            for ( var urlPatternName in URLConfig.excludedURLPatterns){
                var exclusionConfig = URLConfig.excludedURLPatterns[urlPatternName],
                urlPattern = urlPatternName;
                if(typeof exclusionConfig === 'object'){
                    if(exclusionConfig.urlPattern){
                        urlPattern = exclusionConfig.urlPattern;
                    }
                    console.debug("URL pattern to match : " + urlPattern);
                    urlPattern = new RegExp(urlPattern);

                    if(url.match(urlPattern)){
                        var excludedParametersArray = exclusionConfig.excludedParameters;
                        for(var excludedParameter in excludedParametersArray){
                            if(parametername == excludedParameter){
                                return true;
                            }
                        }
                    }
                }
            }
        } else {
            console.debug("The parameter " + parameterName + " is not excluded");
        }
    } else {
        console.debug("No URLConfig defined.")
    }
    } catch (err){
        console.debug("An error occured while trying to exclude " + err);
    }
return false;
}

/**
 *  The utility function to append name value pair to a URL
 *  @param allowMultipleValues (boolean) Indicates whether a parameterName can have multiple values or not, default value is <code>false</code>.
 *  @returns url The updated url.
 */
function appendToURL(url, parameterName, value, allowMultipleValues){
    allowMultipleValues = (null == allowMultipleValues) ? false : allowMultipleValues;
    var paramPattern = new RegExp(parameterName + "=[^&]+"),
    newParamString = parameterName + "=" + value;
    if ( url.indexOf(newParamString) !== -1 ) {
        //console.debug("parameter value pair " + newParamString + " is already indcluded.");
    } else if (!paramPattern.test(url) || allowMultipleValues){
        if (url.indexOf('?') === -1 ){
            url = url + '?';
        }else{
            url = url + '&';
        }
        url = url + newParamString;
    } else {
        // replace it if the old one does not match with the one in wcCommonRequestParameters, possible caching case?
        url = url.replace(paramPattern, newParamString);
        //console.debug("replace " + url.match(paramPattern) + " with " + newParamString);
    }
    return url;
}


/**
 * The function append parameters, such as <code>forUserId</code>, in <code>wcCommonRequestParameters</code>
 * as URL parameters to the give URL.
 * @param allowMultipleValues (boolean) Indicates whether a parameterName can have multiple values or not, default value is <code>false</code>
 * @returns url The updated url.
 */
function appendWcCommonRequestParameters(url, allowMultipleValues){
    allowMultipleValues = (null == allowMultipleValues) ? false : allowMultipleValues;
    if(typeof wcCommonRequestParameters === 'object'){
        for(var parameterName in wcCommonRequestParameters){
            if(!isParameterExcluded(url, parameterName)){
                url = appendToURL(url, parameterName, wcCommonRequestParameters[parameterName], allowMultipleValues);
            }
            //else {
            //console.debug("parameter " + parameterName + " is excluded.");
            //}
        }
    }
    return url;
}

/**
 *  Update the form the <code>wcCommonRequestParameters</code>.
 *  @param form The form to update.
 */
function updateFormWithWcCommonRequestParameters(form, allowMultipleValues) {
    allowMultipleValues = (null == allowMultipleValues) ? false : allowMultipleValues;
    if(typeof wcCommonRequestParameters === 'object'){
        for(var parameterName in wcCommonRequestParameters){
            if(form.action !== undefined && null !== form.action && !isParameterExcluded(form.action, parameterName) ){
                var exist = false;
                $("input[name=" + "'" + parameterName + "']", form).each(function(i, param){
                    if (param.value == wcCommonRequestParameters[parameterName]){
                        exist = true;
                        //console.debug("parameter " + parameter + " with same value alreday exist.")
                    } else if (!allowMultipleValues) {
                        form.removeChild(param);
                    }
                });
                if (!exist ) {
                    if (form.method == 'get') {
                        //the parameter in the URL for form get is not read, need to use hidden input.
                        $("<input></input>", {name: parameterName, type:'hidden', value: wcCommonRequestParameters[parameterName]}).appendTo(form);
                    } else {
                        //post action url probably already has this parameter, use 'appendToURL' to handle duplication
                        form.action = appendToURL(form.action, parameterName, wcCommonRequestParameters[parameterName], allowMultipleValues);
                    }
                }
            }
        }
    }
}

function addAuthToken(form){
    try{
        if($("#csrf_authToken").length){
            $("<input></input>", {name: "authToken", type:'hidden', value: $("#csrf_authToken").val()}).appendTo(form);
        } else {
            console.debug("auth token is missing from the HTML DOM");
        }
        return true;
    } catch (err){
        console.debug("An error occured while trying to add authToken to the form..." + err);
    }
    return false;
}

/**
 *  Process the form update and submit. All forms' submission are recommended to be done this function.
 *  @param form The form to submit.
 */
function processAndSubmitForm (form) {
    updateFormWithWcCommonRequestParameters(form);
    addAuthToken(form);
    form.submit();
}


function getCommonParametersQueryString(){
    return "storeId="+WCParamJS.storeId+"&langId="+WCParamJS.langId+"&catalogId="+WCParamJS.catalogId;
}

/**
 *  Handle service requests after user login for these scenarios:
 *  - timeout while trying to execute an Ajax request
 *  - need authentication while trying to execute an Ajax request
 *
 *  The nextUrl is a parameter returned from wc dojo framework when an error has occured when excuting an AJAX action.
 *  It specifies the next Ajax action to be performed after the user has logged on
 **/

    /**
    * This function checks to see if the passed in URL contains a parameter named 'finalView'. If it does, it will construct a new URL
    * using value from 'finalView' paramter as the view name
    * @param {String} myURL The URL to check if it contains finalView param
    */
    function getFinalViewURL(myURL) {
        var finalViewBeginIndex = myURL.indexOf('finalView');

        // check if finalView parameter is passed in the URL
        if (finalViewBeginIndex != -1){

            // index after parameter 'finalView', when it is -1, that means final view is the last paramter in the URL
            var finalViewEndIndex = myURL.indexOf('&', finalViewBeginIndex);
            if (finalViewEndIndex == -1) {
                var finalViewName = myURL.substring(finalViewBeginIndex + 10);
            } else {
                var finalViewName = myURL.substring(finalViewBeginIndex + 10, finalViewEndIndex);
            }
            var originalActionEndIndex = myURL.indexOf('?');

            // firstPartURL is everything after the '?' sign and before finalView parameter
            var firstPartURL = myURL.substring(originalActionEndIndex + 1, finalViewBeginIndex);
            // secondPartURL is everything after finalView parameter
            if (finalViewEndIndex == -1) {
                var secondPartURL = "";
            } else {
                var secondPartURL = myURL.substring(finalViewEndIndex);
            }

            // to make things simple, remove all leading and trailing '&' for firstPartURL and secondPartURL
            if (firstPartURL.charAt(firstPartURL.length - 1) == '&') {
                firstPartURL = firstPartURL.substring(0, firstPartURL.length-1);
            }
            if (firstPartURL.charAt(0) == '&') {
                firstPartURL = firstPartURL.substring(1);
            }
            if (secondPartURL.charAt(secondPartURL.length - 1) == '&') {
                secondPartURL = secondPartURL.substring(0, secondPartURL.length-1);
            }
            if (secondPartURL.charAt(0) == '&') {
                secondPartURL = secondPartURL.substring(1);
            }

            var finalURL = "";
            if (firstPartURL !== "") {
                finalURL = finalViewName + '?' + firstPartURL;
                if (secondPartURL !== "") {
                    finalURL = finalURL + '&' + secondPartURL;
                }
            } else {
                finalURL = finalViewName + '?' + secondPartURL;
            }
            return finalURL;
        } else {
            return "";
        }
    }

    wcService.declare({
        id: "MyAcctAjaxAddOrderItem",
        actionId: "AjaxAddOrderItem",
        url: "",
        formId: ""
        ,successHandler: function(serviceResponse) {
            MessageHelper.hideAndClearMessage();
            MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("SHOPCART_ADDED"));
            setCookie("WC_nextURL_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
            cursor_clear();
        }
        ,failureHandler: function(serviceResponse) {
            if (serviceResponse.errorMessage) {
                if(serviceResponse.errorMessageKey == "_ERR_NO_ELIGIBLE_TRADING"){
                    MessageHelper.displayErrorMessage(Utils.getLocalizationMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER"));
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

    wcService.declare({
        id: "MyAcctGenericService",
        actionId: "",
        url: "",
        formId: ""
        ,successHandler: function(serviceResponse) {
            setCookie("WC_nextURL_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
            MessageHelper.hideAndClearMessage();
            finalViewURL = getFinalViewURL(this.url);
            if (finalViewURL !== "") {
                document.location.href = finalViewURL;
            } else {
                MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("MYACCOUNT_ACTION_PERFORMED"));
                cursor_clear();
            }
        }
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

    function invokeItemAdd(inUrl) {
        wcService.getServiceById("MyAcctAjaxAddOrderItem").url=inUrl;
        var addToCartParams = [];
        // PasswordRequestAuthenticated is required by PasswordRequestCmdImpl - to indicate password is already entered by user. As we are in the my
        // account page, password is already entered and accepted.
        addToCartParams.PasswordRequestAuthenticated = 'TRUE';

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        setCookie("WC_nextURL_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
        wcService.invoke("MyAcctAjaxAddOrderItem", addToCartParams);
    }
    function invokeOtherService(inUrl) {
        wcService.getServiceById("MyAcctGenericService").url=inUrl;
        var params = {PasswordRequestAuthenticated: 'TRUE'};

        /*For Handling multiple clicks. */
        if(!submitRequest()){
            return;
        }
        cursor_wait();
        setCookie("WC_nextURL_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
        wcService.invoke("MyAcctGenericService", params);
    }

    /**
     * In order to handle the case that IE handles cookie domain differently from other browsers,
     * Use this centerlized function to handle cookie value assignment and ingore domain prop for cookie
     * creation when domain name is an empty string.
     */
    function setCookie(cookieName, cookieVal, props) {
        var createCookie = function(name, value, props){
            if (!props) {
                props = {};
            }

            var exp = props.expires;
            if (exp) {
                if(typeof exp == "number"){
                    var d = new Date();
                    d.setTime(d.getTime() + exp*24*60*60*1000);
                    exp = d;
                }
                if (exp.toUTCString){
                    props.expires = exp.toUTCString();
                } else {
                    props.expires = exp;
                }
            }

            value = encodeURIComponent(value);
            var propString = name + "=" + value;
            for(var name in props){
                propString += "; " + name;
                var propValue = props[name];
                if(propValue !== true){
                    propString += "=" + propValue;
                }
            }
            document.cookie = propString;
        };

        if (!props) {
            createCookie(cookieName, cookieVal);
        } else {
            var cookieProps = props;
            for (var propName in cookieProps) {
                if (!cookieProps[propName]) {
                    delete cookieProps[propName];
                }
            }
            createCookie(cookieName, cookieVal, cookieProps);
        }
    }

    function getBaseTextDir() {
        // summary:
        //      returns the value of the "baseTextDirection" preference.
        var btd = getCookie(_BTD_PREFS);
        if (!btd){
            return "";
        }
        return btd;
    }

    function setBaseTextDir(btd) {
        // summary:
        //      Sets the value of the baseTextDirection" preferences.
        var oldItem = getCookie(_BTD_PREFS);
        if (oldItem != btd){
            setCookie(_BTD_PREFS, btd.toLowerCase());
        }
    }

    function isRTLValue(stringValue) {
        for (var ch in stringValue) {
            if (isBidiChar(stringValue.charCodeAt(ch)))
                return true;
            else if(isLatinChar(stringValue.charCodeAt(ch)))
                return false;
        }
        return false;
    }

    function isBidiChar(c)  {
        if (c >= 0x05d0 && c <= 0x05ff)
            return true;
        else if (c >= 0x0600 && c <= 0x065f)
            return true;
        else if (c >= 0x066a && c <= 0x06ef)
            return true;
        else if (c >= 0x06fa && c <= 0x07ff)
            return true;
        else if (c >= 0xfb1d && c <= 0xfdff)
            return true;
        else if (c >= 0xfe70 && c <= 0xfefc)
            return true;
        else
            return false;
    }

    function isLatinChar(c){
        if((c > 64 && c < 91)||(c > 96 && c < 123))
            return true;
        else
            return false;
    }

    function resolveBaseTextDir(value, txtDir) {
        if (txtDir == "auto") {
            if (isRTLValue(value)) {
                return "rtl";
            } else {
                return "ltr";
            }
        }
        else {
            return txtDir;
        }
    }

    function handleTextDirection(requiredElement) {
        var txtDir = getBaseTextDir();
        if (requiredElement != null && txtDir !== "") {
            if (["INPUT", "TEXTAREA"].indexOf(requiredElement.tagName) > -1) {
                $(requiredElement).css("direction", resolveBaseTextDir(requiredElement.value, txtDir));
            }
        }
    }

    function enforceTextDirectionOnPage() {
        var txtDir = getBaseTextDir();
        if (txtDir !== "") {
            $(".bidiAware").each(function(i, element) {
                element.dir = $(element).css("direction", resolveBaseTextDir(element.value || element.text || element.outerText || element.innerHTML, txtDir));
            });
        }
    }

    /**
    * Common failure handler function which can be used with most of the
    * service definitions.
    * This function displays errorMessage present in serviceResponse object.
    * If errorMessage is null, then it displays errorMessageKey.
    */
    function commonServiceFailureHandler(serviceResponse) {
        if (serviceResponse.errorMessage) {
            MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
        } else {
            if (serviceResponse.errorMessageKey) {
                MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
            }
        }
        cursor_clear();
    }

    function isChrome(){
        return /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
    }

    function isSafari(){
        return /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);
    }

    /**
    * Success handler function used with services which does URL chaining.
    * This function retrieves the next URL in the URLChain and invokes ajax service
    * with appropriate input parameters specified for the URL.
    * If the next URL is specified with requestType = 'GET', then it just
    * redirects the page to nextURL without invoking any further service
    */
    function successHandlerForURLChainingService(serviceResponse){
        console.debug("Success Handler of AjaxCustomServiceForURLChaining", serviceResponse);
        if(this.postRefreshHandlerParameters != null && this.postRefreshHandlerParameters !== ''){
            var nextServiceURL = "";
            // Retrieve the first element from the array...
            nextServiceURLObject = this.postRefreshHandlerParameters.splice(0,1)[0];
            console.debug("nextServiceURLObject ",nextServiceURLObject);

            var params = [];
            if(nextServiceURLObject != null && typeof(nextServiceURLObject) != 'undefined'){
                var nextServiceURL = nextServiceURLObject["URL"],
                requestType = nextServiceURLObject["requestType"],
                requestParams = nextServiceURLObject["requestParams"];
                console.debug("nextServiceURL ", nextServiceURL);
                console.debug("requestType ", requestType);
                console.debug("requestParams ", requestParams);
            }
            if(nextServiceURL !== "") {
                if(requestType == "GET"){
                    if(nextServiceURL.indexOf("?") === -1){
                        nextServiceURL = nextServiceURL + "?" + getCommonParametersQueryString();
                    }
                    for(var key in requestParams){
                        nextServiceURL = nextServiceURL+"&"+ key +"=" + requestParams[key];
                    }
                    document.location.href = nextServiceURL;
                } else {
                    var service = getCustomServiceForURLChaining(nextServiceURL, this.postRefreshHandlerParameters);
                    wcService.invoke(service.getParam("id"), requestParams);
                }
            } else {
                console.debug("End of URL chaining with AjaxCustomServiceForURLChaining service");
                //TODO.. should we show generic success message here ???
            }
        }
    }

    /**
    * This is a common service which can be used to chain 'N' number of service calls.
    *
    * Input parameters to this function are:
    * @url -> The URL for this service definition.
    * @postRefreshHandlerParameters -> JSON object specifying the chained service URLS along with input parameters for each of the service URLs.
    * @formId -> Form that needs to be submitted with the initial service invocation.
    * @return -> wc.service object.
    *
    * Example code:
    *
    * // Define the initial URL
    * initialURL = 'AjaxPersonChangeServiceAddressAdd';
    *
    * // Form to be submitted along with initial request.
    * formId = "addressForm"
    *
    * // Define subsequent set of chained requests
    * var postRefreshHandlerParameters = {};
    * postRefreshHandlerParameters.push({"URL":"AjaxRESTOrderPIDelete", "requestParams":{"piId":"12345"}});
    * postRefreshHandlerParameters.push({"URL":"AjaxRESTOrderItemUpdate", "requestParams":{calculationUsage:"-1,-2,-3,-4,-5,-6,-7", calculateOrder:"1", orderItemId="10001"}});
    * postRefreshHandlerParameters.push({"URL":"DOMOrderShippingBillingView","requestType":"GET", "requestParams":{"payInStore":1}});
    *
    * // Get the service definition.
    * var service = getCustomServiceForURLChaining(initialURL,postRefreshHandlerParameters,formId);
    *
    * // Invoke the service.
    * wcService.invoke(service.id, null);
    *
    * With above sample code, the request chain will be:
    * Request 1: POST : AjaxPersonChangeServiceAddressAdd?<addressForm parameters>
    * Request 2: POST : AjaxRESTOrderPIDelete?piId=12345
    * Request 3: POST : AjaxRESTOrderItemUpdate?calculationUsage=-1,-2,-3,-4,-5,-6,-7&calculateOrder=1&orderItemId=10001
    * Request 4: GET  : DOMOrderShippingBillingView?payInStore=1
    */
    function getCustomServiceForURLChaining(url, postRefreshHandlerParameters,formId){
        var service = wcService.getServiceById('AjaxCustomServiceForURLChaining');

        if(service == null || service == undefined){
            console.debug("Start creating AjaxCustomServiceForURLChaining");
            wcService.declare({
                id: "AjaxCustomServiceForURLChaining",
                actionId: "AjaxCustomServiceForURLChaining",
                url: "",
                formId: "",
                successHandler: successHandlerForURLChainingService,
                failureHandler: commonServiceFailureHandler
            });
            service = wcService.getServiceById('AjaxCustomServiceForURLChaining');
        }

        if(url != null && url != 'undefined'){
            if (!stringStartsWith("url", "http")) {
                service.setUrl(getAbsoluteURL() + url);
            } else {
                service.setUrl(url);
            }
        }
        if(postRefreshHandlerParameters != null && postRefreshHandlerParameters != 'undefined'){
            service.setParam("postRefreshHandlerParameters", postRefreshHandlerParameters);
        } else {
            service.setParam("postRefreshHandlerParameters", null);
        }
        if(formId != null && formId != 'undefined'){
            service.setFormId(formId);
        } else {
            service.setFormId(null);
        }
        console.debug("Return AjaxCustomServiceForURLChaining", service);
        return service;
    }