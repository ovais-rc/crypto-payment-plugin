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
});