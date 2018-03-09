//-----------------------------------------------------------------
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

GlobalLoginShopOnBehalfJS = {
	
	//The topic to subscribe to
	USER_SEARCH_CRITERIA_TOPIC : "userSearchCriteriaChanged",

        firstNameSearchType: 3,
        
        lastNameSearchType: 3,
        
        updateTimer: null,
        
        //The timeout value
        timeOut: 1000,
        
        buyerSearchURL: "",
        
        loadedPanels : {},
        
        callerId : "",
        
        logoutURL : null,
		
		redirectURL : null,
        
        /**
         *Sets the id of the Admin who is calling on behalf of buyer
         *@param callerId The id of the buyer admin   
         */     	
         setCallerId: function(callerId){
         	this.callerId = callerId;
         },
         
        /**
        *Sets the REST URL to be used for finding buyers
        *@param buyerSearchURL The REST URL   
        */     	
        setBuyerSearchURL: function(buyerSearchURL){
        	this.buyerSearchURL = buyerSearchURL;
        },
        
        /**
        *Sets the URL for the on behalf controller
        *@param controllerURL The controller URL to refresh the panel.   
        */     
        setControllerURL: function(controllerURL){
                wc.render.getRefreshControllerById("GlobalLoginShopOnBehalf_controller").url = controllerURL;
        },
  
        /**
        *This method registers the panels loaded on the page.
        *@param shopOnBehalfPanelId The panel which shows the shopping on behalf options
        *@param shopForSelfPanelId the corresponding panel which shows the shop for self options.      
        */     
        registerShopOnBehalfPanel: function(shopOnBehalfPanelId, shopForSelfPanelId){
                this.loadedPanels[shopOnBehalfPanelId] = shopForSelfPanelId;
        },
	
	/**
        *This method checks if the current page is loaded in HTTPs.
        *@return true if the page was in HTTP; false, otherwise.   
        */     
        isPageUsingHTTP: function(){
                var protocol = document.location.protocol;
                return (protocol == 'http:');
        },
  
        /**
        *This function reloads the page using HTTPS. Once the page is loaded, the shop on behalf
        *check box will be toggled.   
        */     
        initHTTPSecure:function(){
                //reload the page with HTTPS and show the sign in panel
                var newHref = "https://" + document.location.host + document.location.pathname;
                if(document.location.search != null && document.location.search != ''){
                        newHref = newHref + document.location.search;
                }
                //set these cookies to process the page once its reloaded.
                setCookie("WC_DisplayContractPanel_"+WCParamJS.storeId, true, {path: "/", domain: cookieDomain});
                setCookie("WC_ToogleOnBehalfPanel_"+WCParamJS.storeId, true, {path: "/", domain: cookieDomain});
        	window.location.href = newHref;
        	return;     
        },
  
        /**
        *This method initializes the panels that have been registered.
        *It sets up the event listeners on these panels. This method is called
        *when the panels are loaded.              
        */  
        initializePanels : function(){
                if(this.loadedPanels != null){
                        for(var shopOnBehalfPanelId in this.loadedPanels){
                                var shopOnBehalfPanel = dojo.byId(shopOnBehalfPanelId);
                                if(shopOnBehalfPanel != null){
                                this.initializePanel(shopOnBehalfPanelId, this.loadedPanels[shopOnBehalfPanelId]); 
                                }
                        }
                }
        
        },
  
        /**
        *This method initializes a panel. It setups the event listeners on the panel
        *@param shopOnBehalfPanelId The panel which shows the shopping on behalf options
        *@param shopForSelfPanelId the corresponding panel which shows the shop for self options.
        */   
        initializePanel : function(shopOnBehalfPanelId, shopForSelfPanelId){
                var domAttr = require("dojo/dom-attr");
                var isInitialized = domAttr.get(shopOnBehalfPanelId, "isEventsSetup");
                if(isInitialized == null || !isInitialized){
                        this.setUpEvents(shopOnBehalfPanelId);
                        domAttr.set(shopOnBehalfPanelId, "isEventsSetup", true);
                        
                        //check the toggle button if the cookie has been set.
                        var toogleOnBehalfPanel = getCookie("WC_ToogleOnBehalfPanel_"+WCParamJS.storeId);
                        if(toogleOnBehalfPanel != null && toogleOnBehalfPanel){
                                this.toggleShopOnBehalfPanel(shopOnBehalfPanelId + "_shopOnBehalfCheckBox", shopForSelfPanelId, shopOnBehalfPanelId);
                
                                //delete the cookie.
                                setCookie("WC_ToogleOnBehalfPanel_"+WCParamJS.storeId, null, {path: "/", expires : -1}); 
                        }
                }
                var callerId = "";
                var callerIdNode = dojo.byId(shopOnBehalfPanelId + "_callerId");
                if (callerIdNode != null) {
                	callerId = callerIdNode.innerHTML;
                }
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
        toggleShopOnBehalfPanel:function(target, shopForSelfSectionId, shopOnBehalfOfSectionId){
        	if(this.isPageUsingHTTP()){
                       this.initHTTPSecure();
                } else {
                        var scope = this;
                        require(["dojo/dom-attr", "dojo/dom-style"], function(domAttr, domStyle){
                                var currentState = domAttr.get(target, "src");
                                if(currentState.indexOf("checked") == -1){
                                        //shop on behalf is unchecked. Check it.
                                        domAttr.set(target, "src", currentState.replace("checkbox", "checkbox_checked"));
                                        
                                        //show shop on behalf options.
                                        domStyle.set(shopForSelfSectionId, 'display', 'none');
                                        domStyle.set(shopOnBehalfOfSectionId, 'display', 'block');
                                } else {
                                        //shop on behalf is checked. Uncheck it.
                                        domAttr.set(target, "src", currentState.replace("checkbox_checked", "checkbox"));
                                        
                                        //show show for self options.
                                        domStyle.set(shopOnBehalfOfSectionId, 'display', 'none');
                                        domStyle.set(shopForSelfSectionId, 'display', 'block');
                                }        
                        });
                }
        },
	
        /**
        * Sets up events for the user search text box.
        * @param shopOnBehalfOfSectionId The shop on behalf panel Id
        */
        setUpEvents:function(shopOnBehalfOfSectionId){
                var eventName = 'keyup';
                var scope = this;
                require(["dojo/on","dojo/topic","dojo/dom-construct","dojo/dom","dojo/domReady!", "dojo/dom-attr", "dojo/dom-style"], function(on,topic,domConstruct,dom, domReady,domAttr, domStyle){
                        var textBox = shopOnBehalfOfSectionId + "_buyerUserName";
                        var searchErrorLabel = shopOnBehalfOfSectionId + "_errorLabel";
                        console.debug("Setting up " + " on " + eventName + " event for DOM element = " + textBox + ". ", "Topic = "+ scope.USER_SEARCH_CRITERIA_TOPIC);
                        var textBoxObj = dojo.byId(textBox);
                        if(textBoxObj != null){
                                on(textBoxObj,eventName, function(event){
                                        //get the text box value and publish the data
                                        var data = {"buyerSearchInput": textBoxObj.value, "data-parent" : domAttr.get(textBoxObj, "data-parent"), "originator" : textBoxObj.id, 'searchErrorLabel': searchErrorLabel};
                                        console.debug("publishing ",data);
                                        if(event.keyCode == dojo.keys.TAB){
                                                return;
                                        }
                                        topic.publish(scope.USER_SEARCH_CRITERIA_TOPIC, data);
                                });
                                        
                                topic.subscribe(scope.USER_SEARCH_CRITERIA_TOPIC, function(data){
                                        //read the search input text and clear the timer.
                                        data["buyerSearchInput"] = textBoxObj.value;
                                        console.debug("Clearing previous timers and starting a new one. Search results will updated after " + scope.timeOut + " milliSeconds." ,data);
                                        clearTimeout(scope.updateTimer);
                                        scope.updateTimer = setTimeout(dojo.hitch(scope,"updateSearchResults",data),scope.timeOut);
                                });
                        }
                });
        },

        /**
        *This method processes the search criteria input by the user and triggers a search.
        *@param searchCriteria The raw search criteria input
        */        
        updateSearchResults:function(searchCriteria){
                console.debug("User input : ",searchCriteria.buyerSearchInput);
                //break down the search input into first name and last name.
                if(searchCriteria.buyerSearchInput !== 'undefined'){
                        var searchInput = new String(searchCriteria.buyerSearchInput);
                        var lastName = searchInput;
                        searchCriteria["lastName"] = lastName;
                        
                        this.performSearch(searchCriteria);
                }
        },
	
        /**
        *This method performs the buyer user search based on the search criteria specified.
        *@searchCriteria The search criteria   
        */     
        performSearch: function(searchCriteria){
                var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
                var lastName = searchCriteria["lastName"];
                var previousLastName = renderContext.properties["previousLastName"];
                //search only when the previous first name or last name dont match the current
                if(lastName != previousLastName && lastName != ''){
                        //save the current search criteria as previous in the render context.
                        renderContext.properties['previousLastName'] = lastName;
                        
                        var domStyle = require("dojo/dom-style");
                        domStyle.set(searchCriteria['originator']+"Error", "display", "none");
                        
                        setCurrentId(searchCriteria['originator']);
                        
                        //perform the search
                        if(!submitRequest()){
                                return;
                        }
                        cursor_wait();	
                        
                        //The REST service uses a GET.
                        require(["dojo/request/xhr"], function(xhr){
                                xhr(GlobalLoginShopOnBehalfJS.buyerSearchURL, {
                                handleAs: "json",
                                method: "GET",
                                query: {
                                'lastName' : lastName,
                                'lastNameSearchType' : GlobalLoginShopOnBehalfJS.lastNameSearchType
                                },
                                headers : {'Content-Type': 'text/plain; charset=utf-8' }
                                }).then(function(response){
                                        cursor_clear();
                                        GlobalLoginShopOnBehalfJS.displaySearchResults(response, searchCriteria);
                                }, function(err){
                                        cursor_clear();
                                        err['errorCode'] = 'GENERICERR_MAINTEXT';
                                        GlobalLoginShopOnBehalfJS.handleError(err, searchCriteria);
                                });
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
        displaySearchResults: function(searchResults, searchCriteria){
                console.debug('Search results :', searchResults);
                var scope = this;
                var errorLabel = document.getElementById(searchCriteria.searchErrorLabel);
                //set up the memory store for the search results drop down.
                require(["dojo/store/Memory"], function(Memory){
                        //create the store data
                        var storeData = [];
                        var lastNameFirst = false;
                        require(["dojo/_base/config"], function(config){
                        	if (config.locale == 'ja-jp' || config.locale =='ko-kr' || config.locale == 'zh-cn' || config.locale == 'zh-tw'){
                    			lastNameFirst = true;
                    		}
                        });
                        var lang = require("dojo/_base/lang");
                        var domClass = require("dojo/dom-class");
                        if(searchResults != null && searchResults.userDataBeans != null && searchResults.userDataBeans.length > 0){
                        	domClass.remove(errorLabel, 'active');
                        	for(var i = 0; i < searchResults.userDataBeans.length; i++){
                        		var userEntry = searchResults.userDataBeans[i];
                        		userEntry.displayName = "";
                        		
                        		var userFirstName = '';
                        		var userLastName = '';
                                if(userEntry.firstName != null && lang.trim(userEntry.firstName) != ""){
                                	userFirstName = lastNameFirst ? " " + userEntry.firstName : userEntry.firstName + " ";
                                }
                                if(userEntry.lastName != null && lang.trim(userEntry.lastName) != ""){
                                	userLastName = userEntry.lastName;
                                }
                                userEntry.displayName = lastNameFirst ? userLastName + userFirstName : userFirstName + userLastName;
                                userEntry.fullName = lang.trim(userEntry.displayName);
                                
                                userEntry.displayName += " (" + userEntry.logonId + ")";
                                userEntry.displayName = lang.trim(userEntry.displayName);
                        	}
                        	storeData = searchResults.userDataBeans;
                        } else {
                        	domClass.add(errorLabel, 'active');
                        }
                        var store = new Memory({idProperty: "userId", data: storeData});
                        store.remove(scope.callerId);
                       
                        //set the store to the buyer user dropdown
                        var buyerUserNameInputBoxId = searchCriteria['originator'];
                        var searchInputBox = dijit.byId(buyerUserNameInputBoxId);
                        searchInputBox.searchAttr = "displayName";
                        searchInputBox.store = store;
                        searchInputBox.toggleDropDown();
                });
        },
	
        /**
        *This method displays the error when the search fails.
        *@param error Error data
        *@param searchCriteria The original search criteria      
        */     
        handleError: function(error, nodeToDisplayError){
                console.debug('An error occurred while searching for users ', error);
                var errorMessage = null;
                if(error.errorMessage != null){
                        errorMessage = error.errorMessage;  
                } else if (error.errorMessageKey != null){
                        errorMessage = storeNLS[error.errorMessageKey];
                } else if (error.errorCode != null){
                        errorMessage = storeNLS[error.errorCode];
                }
                if(errorMessage == null || errorMessage == ""){
                        errorMessage = storeNLS['GENERICERR_MAINTEXT'];
                }
                dojo.byId(nodeToDisplayError).innerHTML = errorMessage;
                var domStyle = require('dojo/dom-style');
                domStyle.set(nodeToDisplayError, "display", "block");
        },
	
  /**
   *This method is invoked when the admin selects the user.
   *This method invokes the RunAsUserSetInSessionService and refreshes the panel to indicate the buyer
   *@param userDropDown The drop down node.   
   */        
	selectUser: function(userDropDown){
		var searchUsersBox = dijit.byId(userDropDown.id);
		var selectedUser = searchUsersBox.item;
		if(selectedUser != null && selectedUser.userId != '-1'){
      var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
      renderContext.properties["selectedUser"] = selectedUser;
      renderContext.properties["shopOnBehalfPanelId"] = userDropDown['data-parent'];
      renderContext.properties["shopForSelfPanelId"] = this.loadedPanels[userDropDown['data-parent']];
      
      setCurrentId(userDropDown.id);
      if(!submitRequest()){
				return;
			}
			cursor_wait();
			var shopOnBehalfATForm = document.forms["shopOnBehalf_AuthTokenInfo"];
			var authToken = shopOnBehalfATForm.shopOnBehalf_AuthToken.value;
			wc.service.invoke("RunAsUserSetInSessionService", {'runAsUserId' : selectedUser.userId, 'authToken': authToken});
		}
	},
  
        /**
        *This method is invoked when the RunAsUserSetInSessionService is successful.
        *It refreshes the panel
        */        
        onUserSetInSession: function(){
                var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
                var selectedUser = renderContext.properties["selectedUser"];
                
                //write the cookie.
                setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, escapeXml(selectedUser.fullName, true), {path:'/', domain:cookieDomain});
                var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                if (widgetIds != null && widgetIds.length > 0){
                	for (var i = 0; i < widgetIds.length; i++) {
                		this.updateSignOutLink(widgetIds[i]);
                	}
                }
                setDeleteCartCookie();
                //instead of refreshing the panel, we refresh the page to my account page to update the my account links.
                //wc.render.updateContext("GlobalLoginShopOnBehalf_context", {'showOnBehalfPanel' : false});
                setCookie("WC_DisplayContractPanel_"+WCParamJS.storeId, true, {path: "/", domain: cookieDomain});
                document.location.href = "AjaxLogonForm?storeId="
					+ WCParamJS.storeId + "&catalogId=" + WCParamJS.catalogId
					+ "&langId=" + WCParamJS.langId + "&myAcctMain=1";
        },
	
        /**
        *This method is invoked when the user chooses an organization.
        *It invokes the OrganizationSetInSessionService service.
        *      
        *@param The organization drop down node
        */        
        updateOrganization : function(organizationNode){
                var organizationDropDown = dijit.byId(organizationNode.id);
                var organizationSelected = organizationDropDown.value;
                var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
                renderContext.properties["shopOnBehalfPanelId"] = organizationDropDown['data-parent'];
                renderContext.properties["shopForSelfPanelId"] = this.loadedPanels[organizationDropDown['data-parent']];
                
                setCurrentId(organizationNode.id);
                if(!submitRequest()){
                        return;
                }
                cursor_wait();
                wc.service.invoke("OrganizationSetInSessionService", {'activeOrgId' : organizationSelected});
        },
	
        /**
        *This method is invoked when the user chooses a contract.
        *It invokes the ContractSetInSessionService service.  
        *   
        *@param contractNode The contract drop down node.
        */         
        updateContract : function(contractNode){
                var contractDropDown = dijit.byId(contractNode.id);
                var contractSelected = contractDropDown.value;
                var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
                renderContext.properties["shopOnBehalfPanelId"] = contractDropDown['data-parent'];
                renderContext.properties["shopForSelfPanelId"] = this.loadedPanels[contractDropDown['data-parent']];
                
                setCurrentId(contractDropDown.id);
                if(!submitRequest()){
                        return;
                }
                cursor_wait();
                wc.service.invoke("ContractSetInSessionService", {'contractId' : contractSelected});
        },
  
        /**
        *This method clears the user set in session. It restores the session to that of the buyer admin and redirects the user to redirectURL
        */        
        clearUserSetInSession: function(link, redirectURL){
				if(link != null && link != ''){
	                setCurrentId(link.id);
				}
                if(!submitRequest()){
                        return;
                }
                cursor_wait();
				this.logoutURL = null;
				this.redirectURL = redirectURL;
                wc.service.invoke("RestoreOriginalUserSetInSessionService");
        },
        
        /**
         * This method clears the user set in the session before logging off the buyer admin.
         */
        clearUserSetInSessionAndLogoff: function(logoutURL) {
        	if (!submitRequest()) {
        		return;
        	}
        	cursor_wait();
        	this.logoutURL = logoutURL;
			this.redirectURL = null;
        	wc.service.invoke("RestoreOriginalUserSetInSessionService");
        },

		restoreCSRSessionAndRedirect:function(redirectURL){
			GlobalLoginJS.deleteUserLogonIdCookie(); 
			GlobalLoginShopOnBehalfJS.deleteBuyerUserNameCookie(); 
			GlobalLoginShopOnBehalfJS.clearUserSetInSession('',redirectURL);
		},

        /**
         *This method is invoked when the for user session is successfully terminated.
         *This method reloads the current page.         
         */           
        onRestoreUserSetInSession: function(){
                //clear the cookie
        		setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, null, {path: '/', expires: -1, domain:cookieDomain});
                /* Page is getting reloaded.. Why to update the links now ?
				var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                if (widgetIds != null && widgetIds.length > 0){
                	for (var i = 0; i < widgetIds.length; i++) {
                		this.updateSignOutLink(widgetIds[i]);
                	}
                }*/
                setDeleteCartCookie();
				deleteOnBehalfRoleCookie();
                if (this.logoutURL == null && this.redirectURL == null) {
                	//refresh the page, if it's not HTTPS
					if(!stringStartsWith(document.location.href, "https")){
						document.location.reload();
					} else {
						// Reload home page
						document.location.href =  WCParamJS.homePageURL;
					}

                } else if(this.redirectURL != null){
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
	updateSignOutLink: function(widgetId){
		var idPrefix = widgetId + "_";
		var signOutLink = dojo.byId(idPrefix + "signOutQuickLinkUser");
		if (signOutLink != null) {
			var logonUser = "";
			var logonUserCookie = getCookie("WC_LogonUserId_"+WCParamJS.storeId);
			if (typeof logonUserCookie != 'undefined'){
				logonUser = logonUserCookie;
			}
			signOutLink.innerHTML = escapeXml(logonUser, true);
			var buyerUserName = "";
			var buyOnBehalfCookie = getCookie("WC_BuyOnBehalf_"+WCParamJS.storeId);
			if (typeof buyOnBehalfCookie != 'undefined'){
				buyerUserName = escapeXml(buyOnBehalfCookie, true);
			}
			if (buyerUserName != "") {
				signOutLink.innerHTML += " (" + buyerUserName + ")";
			}
		}
	},
  
        deleteBuyerUserNameCookie: function(){
        		setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, null, {expires: -1, path: '/', domain:cookieDomain});
                var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                if (widgetIds != null && widgetIds.length > 0){
                	for (var i = 0; i < widgetIds.length; i++) {
                		this.updateSignOutLink(widgetIds[i]);
                	}
                }
        },

		resetBuyerUserNameCookie:function(buyerUserName){
			setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, escapeXml(buyerUserName, true), {path:'/', domain:cookieDomain});
			var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                if (widgetIds != null && widgetIds.length > 0){
                	for (var i = 0; i < widgetIds.length; i++) {
                		this.updateSignOutLink(widgetIds[i]);
                	}
             }
		},
        
        resetDropdown: function(dropDownNode){
                var dropDown = dijit.byId(dropDownNode.id);
                dropDown.reset();
        }
}

/**
 * Declares a new render context for initiating on behalf session
 */
wc.render.declareContext("GlobalLoginShopOnBehalf_context",{'previousLastName' : null, 'firstName':null, 'lastName' : null},"");

/**
 *  Service declaration to invoke RunAsUserSetInSession command.
 *  @constructor
 */
wc.service.declare({
	id: "RunAsUserSetInSessionService",
	actionId: "RunAsUserSetInSession",
	url: "AjaxRunAsUserSetInSession",
	formId: ""

	 /**
	  *  This method refreshes the panel 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		GlobalLoginShopOnBehalfJS.onUserSetInSession();
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
		GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContext.properties["shopOnBehalfPanelId"] + "_ErrorField");
                cursor_clear();
	}

});

/**
 *  Service declaration to invoke OrganizationSetInSession command.
 *  @constructor
 */
wc.service.declare({
	id: "OrganizationSetInSessionService",
	actionId: "OrganizationSetInSession",
	url: "AjaxOrganizationSetInSession",
	formId: ""

	 /**
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		console.debug("Organization set in session successfully");
                cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
                var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
		GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContext.properties["shopOnBehalfPanelId"] + "_ErrorField");
		cursor_clear();
	}

});

/**
 *  Service declaration to invoke the ContractSetInSessionCmd
 *  @constructor
 */
wc.service.declare({
	id: "ContractSetInSessionService",
	actionId: "ContractSetInSession",
	url: "AjaxContractSetInSession",
	formId: ""

	 /**
	  *  This method updates the order table with the 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
		GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContext.properties["shopOnBehalfPanelId"] + "_ErrorField");
		cursor_clear();
	}

});

/**
 *  Service declaration to invoke the ContractSetInSessionCmd
 *  @constructor
 */
wc.service.declare({
	id: "RestoreOriginalUserSetInSessionService",
	actionId: "RestoreOriginalUserSetInSessionService",
	url: "AjaxRestoreOriginalUserSetInSession"+"?"+getCommonParametersQueryString(),
	formId: ""

	 /**
	  *  This method updates the order table with the 
	  *  @param (object) serviceResponse The service response object, which is the
	  *  JSON object returned by the service invocation.
	  */
	,successHandler: function(serviceResponse) {
		GlobalLoginShopOnBehalfJS.onRestoreUserSetInSession();
                cursor_clear();
	}
	
	/**
	* display an error message.
	* @param (object) serviceResponse The service response object, which is the
	* JSON object returned by the service invocation.
	*/
	,failureHandler: function(serviceResponse) {
		var renderContext = wc.render.getContextById('GlobalLoginShopOnBehalf_context');
		GlobalLoginShopOnBehalfJS.handleError(serviceResponse, renderContext.properties["shopOnBehalfPanelId"] + "_ErrorField");
		cursor_clear();
	}

});

wc.render.declareRefreshController(
  {
    id: "GlobalLoginShopOnBehalf_controller",
    renderContext: wc.render.getContextById("GlobalLoginShopOnBehalf_context"),
    url: '',
    formId: ""

   	/** 
   	 * Refreshes the Global Login panel.
   	 * This function is called when a render context event is detected. 
   	 * 
   	 * @param {string} message The render context changed event message
   	 * @param {object} widget The registered refresh area
   	 */    	   
        ,renderContextChangedHandler: function(message, widget) {
        	var controller = this;
        	var renderContext = this.renderContext;						
        	widget.refresh(renderContext.properties);		
        }

        /** 
         * Clears the progress bar
         * 
         * @param {object} widget The registered refresh area
         */
        ,postRefreshHandler: function(widget) {
                var renderContext = this.renderContext;
        	delete renderContext.properties.selectedUser;
                delete renderContext.properties.firstName;
                delete renderContext.properties.lastName;
                delete renderContext.properties.previousFirstName;
                delete renderContext.properties.previousLastName;
                delete renderContext.properties.showOnBehalfPanel;
                GlobalLoginShopOnBehalfJS.initializePanels();   
                cursor_clear();			 
        }
    
  }
);