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

//*---------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been
//* thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its
//* reliability, serviceability or functionality.
//*
//* This sample may include the names of individuals, companies, brands
//* and products in order to illustrate concepts as completely as
//* possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by
//* actual persons
//* or business enterprises is entirely coincidental.
//*---------------------------------------------------------------------

/**
 * Common Worklight initialization call
 */
function wlCommonInit() {
	var METHODNAME = "WCHybridAppJS.wlCommonInit ";
	if (wlInitOptions.enableLogger) {
		WL.Logger.debug(METHODNAME + "ENTRY");
	}
	langId = window.sessionStorage.getItem('langId');
	if (wlInitOptions.enableLogger) {
		WL.Logger.debug(METHODNAME + "langId(" + typeof langId + "): " + langId);
	}
	if (langId != null && langId != 'undefined' && (typeof langId) == 'string') {
		langId = parseInt(langId, 10);
	}
	if (wlInitOptions.enableLogger) {
		WL.Logger.debug(METHODNAME + "langId(" + typeof langId + "): " + langId);
	}
	MessagesJS.setLanguage(langId);
	if (wlInitOptions.enableLogger) {
		WL.Logger.debug(METHODNAME + "EXIT");
	}
}

/**
 * Android environment specific Worklight initialization call
 * Setup the tab bar and options menu
 */
function wlEnvInit() {
	var METHODNAME = "WCHybridAppJS.wlEnvInit ";
	if (wlInitOptions.enableLogger) {
		WL.Logger.debug(METHODNAME + "ENTRY");
	}
	wlCommonInit();

	var clientEnv = WL.Client.getEnvironment();
	if (wlInitOptions.enableLogger) {
		WL.Logger.debug(METHODNAME, clientEnv + " environment initializing started");
	}

	//Workaround for Android 4.1.1+ embedded WebView bug where JavaScript
	//onClick handlers are called twice. Capture subsequent click events
	//and if the timing is too short, prevent them from being propagated.
	//See http://code.google.com/p/android/issues/detail?id=38808
	var deviceVersion = device.version;
	if (deviceVersion != null) {
		var deviceVersionSplit = deviceVersion.split(".");
		if ((deviceVersionSplit.length >= 2 && (deviceVersionSplit[0] == "4" && parseInt(deviceVersionSplit[1]) > 1))
				|| (deviceVersionSplit.length == 3 && (deviceVersionSplit[0] == "4" && deviceVersionSplit[1] == "1" && parseInt(deviceVersionSplit[2]) >= 1))) {
			if (window.addEventListener) {
				window.addEventListener("click", function(e) {
					var current = new Date().getTime();
					var delta = current - window.lastClickTime;
					if (delta < 350) { //stop event if less than threshold value, otherwise allow
						e.preventDefault();
						e.stopPropagation();
					}
					window.lastClickTime = current;
				});
			}
		}
	}

	WCHybridAppJS.createOptionsMenu();

	if (wlInitOptions.enableLogger) {
		WL.Logger.debug(METHODNAME, clientEnv + " environment initialization completed");
		WL.Logger.debug(METHODNAME + "EXIT");
	}
}

/**
 * WCHybridAppJS contains Android specific functions
 */
var WCHybridAppJS = (function() {

	var sessionStore = window.sessionStorage;
	var previewModeUrlParameters = "?newPreviewSession=true&previewToken=";
	var historyStackPrefix = "historyStack_";
	var isBackKeyPressed = false;
	var shouldClearHistory = false;
	var optionsMenu = null;

	//list of tab index values
	var featuredIndex = 0;
	var departmentsIndex = 1;
	var storesIndex = 2;
	var cartIndex = 3;
	var myAccountIndex = 4;
	var wishListIndex = 5;
	var historyDisabled = 999; //use this value for base pages that do not require history

	return {

		/**
		 * Load the content for the tab
		 * @param targetUrl The base URL for the tab link
		 * @param tabIndex The tab index identifier
		 */
		loadTab: function(targetUrl, tabIndex, tabName) {
			var METHODNAME = "WCHybridAppJS.loadTab ";
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "ENTRY");
			}

			var historyKey = historyStackPrefix + tabIndex;
			//if the clicked tab is not the active tab, check if any history exists, and load it
			if (tabIndex != WCHybridAppJS.getCurrentTabIndex()) {
				//if tab has history, retrieve the history and pop the url for use
				var storedHistory = window.sessionStorage.getItem(historyKey);
				if (storedHistory !== null && typeof storedHistory !== "undefined") {
					var historyStack = JSON.parse(storedHistory);
					if (historyStack !== null && typeof historyStack !== "undefined" && historyStack.length > 0) {
						targetUrl = historyStack.pop();
						//update the history in storage
						window.sessionStorage.setItem(historyKey, JSON.stringify(historyStack));
					}
				}
			} else {
				//if the clicked tab is the currently active tab, clear the existing tab history since we are back at the top
				if (wlInitOptions.enableLogger) {
					WL.Logger.debug(METHODNAME, historyKey + " will be cleared on next updateHistory call");
				}
				shouldClearHistory = true;
			}

			//load the page
			window.location.href = targetUrl;

			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "EXIT");
			}
		},

		/**
		 * Updates the history stacks for each tab and persists the history using HTML session storage.
		 * Called during the window's unload event. If back button is pressed, onBackKeyPress is called
		 * prior to the unload event.
		 */
		updateHistory: function() {
			var METHODNAME = "WCHybridAppJS.updateHistory ";
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "ENTRY");
			}

			var historyStack;

			//find out which history stack to use
			var selectedTabIndex = WCHybridAppJS.getCurrentTabIndex();
			if (selectedTabIndex != null && typeof selectedTabIndex !== "undefined") {

				//check if history should be disabled
				if (selectedTabIndex != historyDisabled) {
					var historyKey = historyStackPrefix + selectedTabIndex;
					if (selectedTabIndex == cartIndex) { //if in the checkout flow
						historyStack = [window.sessionStorage.getItem("ShoppingCartURL")];
					} else { //get the history from session storage
						var storedHistory = window.sessionStorage.getItem(historyKey);
						if (storedHistory !== null && typeof storedHistory !== "undefined") { //an existing history stack exists so we can use it
							historyStack = JSON.parse(storedHistory);
						} else {
							historyStack = []; //create a new array
						}

						if (isBackKeyPressed == false) {
							if (historyStack !== null && typeof historyStack !== "undefined" && historyStack[historyStack.length-1] != window.location.href) {
								if (selectedTabIndex != cartIndex) { //do not append pages for checkout flow
									historyStack.push(window.location.href);
								}
							}
						} else {
							isBackKeyPressed = false;
						}

						//check if clear history is needed, flag can be used to override
						if (shouldClearHistory == true) {
							if (wlInitOptions.enableLogger) {
								WL.Logger.debug(METHODNAME + "Clearing " + historyKey);
							}
							historyStack = [];
							shouldClearHistory = false;
						}
					}
					//update the history in storage
					if (wlInitOptions.enableLogger) {
						WL.Logger.debug(METHODNAME + "Updated contents of " + historyKey);
						for (var i in historyStack) {
							if (historyStack.hasOwnProperty(i)) {
								WL.Logger.debug(METHODNAME + "URL[" + i + "]: " + historyStack[i]);
							}
						}
					}
					window.sessionStorage.setItem(historyKey, JSON.stringify(historyStack));
				} else {
					if (wlInitOptions.enableLogger) {
						WL.Logger.debug(METHODNAME + "History is not maintained for this tab. No updates.");
					}
				}
			} else {
				if (wlInitOptions.enableLogger) {
					WL.Logger.debug(METHODNAME + "Selected tab is null or undefined. No updates.");
				}
			}

			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "EXIT");
			}
		},

		/**
		 * Perform the actions when back button is pressed, either loading a page from history
		 * or displaying the exit confirmation dialog
		 */
		onBackKeyDown: function () {
			var METHODNAME = "WCHybridAppJS.onBackKeyDown ";
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "ENTRY");
			}

			//find out which history stack to use
			var selectedTabIndex = WCHybridAppJS.getCurrentTabIndex();
			var historyKey = historyStackPrefix + selectedTabIndex;
			var storedHistory = window.sessionStorage.getItem(historyKey);

			if (storedHistory !== null && typeof storedHistory !== "undefined") {
				var historyStack = JSON.parse(storedHistory);
				if (historyStack.length > 0) {
					isBackKeyPressed = true;
					var prevUrl = historyStack.pop();
					//change page if the previous URL does not match the current page
					if (window.location.href != prevUrl) {
						window.location.href = prevUrl;
					} else {
						if (wlInitOptions.enableLogger) {
							WL.Logger.debug(METHODNAME + "No change in URL, skipping reload. Updating " + historyKey);
						}
						//if history is cleared, display exit dialog
						if (historyStack.length == 0) {
							if (wlInitOptions.enableLogger) {
								WL.Logger.debug(METHODNAME + "Removed the final item in the history stack, display prompt");
							}
							WCHybridAppJS.displayExitDialog();
						}
					}

					if (wlInitOptions.enableLogger) {
						if (historyStack.length == 0) {
							WL.Logger.debug(METHODNAME + "History stack is empty");
						} else {
							WL.Logger.debug(METHODNAME + "Contents of history stack:");
							for (var i in historyStack) {
								if (historyStack.hasOwnProperty(i)) {
									WL.Logger.debug(METHODNAME + "URL[" + i + "]: " + historyStack[i]);
								}
							}
						}
					}

					//update the stored history
					window.sessionStorage.setItem(historyKey, JSON.stringify(historyStack));

				} else {
					if (wlInitOptions.enableLogger) {
						WL.Logger.debug(METHODNAME + "At the top of the history stack, display prompt");
					}
					WCHybridAppJS.displayExitDialog();
				}
			} else {
				if (wlInitOptions.enableLogger) {
					WL.Logger.debug(METHODNAME + "Current tab has no stored history");
				}
				WCHybridAppJS.displayExitDialog();
			}

			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "EXIT");
			}

		},

		/**
		 * Displays a native dialog prompting the user to exit or cancel.
		 * Exit closes the app with a call to WL.App.close
		 */
		displayExitDialog: function() {
			WL.SimpleDialog.show(
				Messages.confirm,
				Messages.exitApp,
				[
					{
						text:Messages.cancel,
						handler:function(){}
					},
					{
						text:Messages.OK,
						handler:function(){WL.App.close();}
					}
				]
			);
		},

		/**
		 * Creates the Android options menu
		 * @param optionsMenu   the WL.OptionsMenu object
		 */
		createOptionsMenu: function() {
			var METHODNAME = "WCHybridAppJS.createOptionsMenu ";
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "ENTRY");
			}

			optionsMenu = WL.OptionsMenu;
			optionsMenu.init({opacity:"0.5"});
			if (sessionStore.getItem('userType') == "G") {
				optionsMenu.addItem("signin", function(){ window.location.href = sessionStore.getItem('logOnURL'); }, Messages.signIn, {
					image: "ic_menu_sign_in_out",
					enabled: true
				});
			} else {
				optionsMenu.addItem("signout", function(){ window.location.href = decodeURIComponent(sessionStore.getItem('logOffURL')); }, Messages.signOut, {
					image: "ic_menu_sign_in_out",
					enabled: true
				});
			}
			optionsMenu.addItem("myaccount", function(){ WCHybridAppJS.launchMenuAction('menu_myaccount','AccountDispURL'); }, Messages.myAccount, {
				image: "ic_menu_my_account",
				enabled: true
			});
			optionsMenu.addItem("scan", function(){ BarcodeScanJS.launch(); }, Messages.scan, {
				image: "ic_menu_scan",
				enabled: true
			});
			if (window.sessionStorage.getItem('WishListDispURL') != null) {
				optionsMenu.addItem("wishlist", function(){ WCHybridAppJS.launchMenuAction('menu_wishlist','WishListDispURL'); }, Messages.shoppingList, {
					image: "ic_menu_shopping_list",
					enabled: true
				});
			}
			optionsMenu.addItem("privacypolicy", function(){ WCHybridAppJS.launchMenuAction('menu_privacypolicy','PrivacyViewURL'); }, Messages.privacyPolicy, {
				image: "ic_menu_privacy_policy",
				enabled: true
			});
			if (window.sessionStorage.getItem('StoreLocatorURL') != null) {
				optionsMenu.addItem("storelocator", function(){ WCHybridAppJS.launchMenuAction('menu_storelocator','StoreLocatorURL'); }, Messages.storeLocator, {
					image: "ic_menu_privacy_policy",
					enabled: true
				});
			}
			optionsMenu.addItem("contactus", function(){ WCHybridAppJS.launchMenuAction('menu_contactus','ContactUsViewURL'); }, Messages.contactUs, {
				image: "ic_menu_privacy_policy",
				enabled: true
			});
			optionsMenu.addItem("languagecurrency", function(){ shoppingActionsJS.showWCDialogPopup('widget_language_and_currency_popup'); }, Messages.languageCurrency, {
				image: "ic_menu_privacy_policy",
				enabled: true
			});

			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "EXIT");
			}
		},

		/**
		 * Assigns the selected tab name, retrieves the target URL based on
		 * the tab name from session storage and loads it
		 * @param tabName   tab ID
		 * @param targetUrl the URL to load
		 */
		launchMenuAction: function(tabName, targetUrl) {
			var METHODNAME = "WCHybridAppJS.launchMenuAction ";
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "ENTRY");
			}
			if (targetUrl !== null && targetUrl.length > 0) {
				if (tabName !== null) {
					sessionStorage.setItem('tabSelected',tabName);
				}
				window.location.href = sessionStorage.getItem(targetUrl);
			}
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "EXIT");
			}
		},

		/**
		 * Returns the tab index by analyzing the current page's URL. This function categorizes the
		 * different views and URLs into tabs groups that aid the Worklight app in navigation. The
		 * conditions in this function should be updated as Struts view names are added/changed or
		 * SEO/non-SEO URLs are added/changed, as appropriate.
		 * @return The int corresponding to the tab index, which represents a group of pages under a tab.
		 *         Returns null if there is no match.
		 */
		getCurrentTabIndex: function() {
			var METHODNAME = "WCHybridAppJS.getCurrentTabIndex ";
			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "ENTRY");
			}

			var selectedTab = "";
			var currUrl = window.location.href;
			var currPath = window.location.pathname;

			//check if the window.location.hash object contains only a single hash character
			//and remove it, otherwise the URL will not be evaluated correctly
			if (WCHybridAppJS.endsWith(currUrl, "#") == true) {
				currUrl = currUrl.substring(0,currUrl.length-1);
			}
			if (currUrl == sessionStore.getItem('ShoppingCartURL')
				|| currPath.indexOf('m30OrderItemDisplay') >= 0
				|| ((currPath.indexOf('m30Order') >= 0
						&& currPath.indexOf('m30OrderHistory') == -1)
					 && sessionStore.getItem('fromPage') != "MyAccount")
				|| window.location.search.indexOf('fromPage=ShoppingCart') >= 0
				|| sessionStore.getItem('fromPage') == "ShoppingCart") {
				selectedTab = cartIndex;
			} else if (currUrl == sessionStore.getItem('StoreLocatorURL')
				|| currPath.indexOf('m30Store') >= 0
				|| currPath.indexOf('m30SelectedStore') >= 0) {
				selectedTab = storesIndex;
			} else if (currUrl == sessionStore.getItem('HomePageURL')
				|| currPath.indexOf('m30Index') >= 0
				//|| currPath.indexOf('m30EFlyer') >= 0
				|| window.location.search.indexOf(previewModeUrlParameters) == 0) {
				selectedTab = featuredIndex;
			} else if (currUrl == sessionStore.getItem('WishListDispURL')
				|| currPath.indexOf('m30InterestList') >= 0) {
				selectedTab = wishListIndex;
			} else if (currUrl == sessionStore.getItem('AccountDispURL')
				|| currPath.indexOf('m30MyAccount') >= 0
				|| currPath.indexOf('m30MySubscriptionDisplay') >= 0
				|| currPath.indexOf('m30CouponsDisplay') >= 0
				|| currPath.indexOf('m30OrderHistory') >= 0
				|| currPath.indexOf('m30UserRegistrationUpdate') >= 0
				|| currPath.indexOf('InterestItemDisplay') >= 0
				|| window.location.search.indexOf('fromPage=MyAccount') >= 0
				|| sessionStore.getItem('fromPage') == "MyAccount") {
				selectedTab = myAccountIndex;
			} else if (currUrl == sessionStore.getItem('PrivacyViewURL')
				|| currUrl == sessionStore.getItem('CustomerServiceContactURL')
				|| currUrl == sessionStore.getItem('LanguageCurrencyDispURL')
				|| currPath.indexOf('ProductCompareResultView') >= 0
				|| currPath.indexOf("LogonForm") >= 0
				|| currPath.indexOf("CheckoutLogon") >= 0
				|| currPath.indexOf("UserRegistration") >= 0
				|| currPath.indexOf("LanguageCurrencyDisplay") >= 0) {
				//any pages that would not record history, such as static pages or
				//single-level sections would not require history to be maintained
				selectedTab = historyDisabled;
			} else {
				var tabSelected = sessionStore.getItem('tabSelected');
				if (currUrl == sessionStore.getItem('TopCategoriesDisplayURL')
					|| currPath.indexOf('CategoriesDisplayView') >= 0
					|| (tabSelected !== null && tabSelected.indexOf("menu_") == -1
						&& currPath.indexOf('ProductCompareResultView') == -1
						&& currPath.indexOf('m30Order') == -1)) {
					selectedTab = departmentsIndex;
				}
			}

			if (wlInitOptions.enableLogger) {
				WL.Logger.debug(METHODNAME + "selectedTab=" + selectedTab);
				WL.Logger.debug(METHODNAME + "EXIT");
			}
			return selectedTab;
		},

		/**
		 * Utility function to check if string ends with specified suffix
		 * @param str The target string to check
		 * @param suffix The suffix to check for
		 */
		endsWith: function(str, suffix) {
			return str.indexOf(suffix, str.length - suffix.length) !== -1;
		}

	};

})();