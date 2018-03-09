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
