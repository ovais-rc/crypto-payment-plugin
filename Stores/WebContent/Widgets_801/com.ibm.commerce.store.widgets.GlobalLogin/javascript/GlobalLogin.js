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
};