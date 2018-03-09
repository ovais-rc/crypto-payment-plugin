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

