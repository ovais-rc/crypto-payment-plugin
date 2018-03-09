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
 * @fileOverview This file provides the functions needed by a refresh area
 */

jQuery(document).ready(function($) {
    $.widget("wc.refreshWidget", {
        url: undefined,
        ariaMessage: undefined,
        ariaLiveId: undefined,

        // default options
        options: {
            formId: undefined,
            renderContextChangedHandler: null,
            postRefreshHandler: null
        },
        _create: function() {
            if (this.element.attr("refreshurl")) {
                this.url = this.element.attr("refreshurl");
            }
            if (!this.url) {
                console.warn("Warning: refreshurl is not defined for refresh area: " + this.element.attr("id"));
            }
            if (this.element.attr("wcType") !== "RefreshArea") {
                console.error("Error: wcType is not set to 'RefreshArea' for refresh area: " + this.element.attr("id"));
            }
            if (!this.element.attr("declareFunction")) {
                console.error("Error: declareFunction is not set for refresh area: " + this.element.attr("id"));
            }
            if (this.element.attr("ariaMessage")) {
                this.ariaMessage = this.element.attr("ariaMessage");
            }
            if (this.element.attr("ariaLiveId")) {
                this.ariaMessage = this.element.attr("ariaLiveId");
            }
        },
        updateUrl: function(newURL) {
            this.url = newURL;
        },
        updateFormId: function(newFormId) {
            this.options.formId = newFormId;
        },
        refresh: function(parameters) {
            var domNode = this.element;
            var widget = this;

            //Obtain refreshurl which is defined in controller
            if (!this.url && this.element.attr("refreshurl")) {
                this.url = this.element.attr("refreshurl");
            }

            var formNode = null;
            if (this.options.formId) {
                formNode = $("#" + this.options.formId);
            }

            if (parameters) {
                if (!parameters.requesttype) {
                    parameters.requesttype = 'ajax';
                }
            } else {
                parameters = {requesttype: 'ajax'};
            }

            if (!this.url) {
                console.error("refreshurl is not specified for refresh area: " + domNode.attr("id"));
                return;
            }

            //Remove all instances of "amp;" in the URL which was added on the JSP by c:out
            this.url = this.url.replace(/amp;/g, "");

            var mergedParameters = parameters;

            if(typeof wcCommonRequestParameters === "object"){
                mergedParameters = {};
                $.extend(mergedParameters, parameters);

                for(var parameterName in wcCommonRequestParameters){
                    if(!this._isParameterExcluded(this.url, parameterName)){
                        mergedParameters.parameterName = wcCommonRequestParameters.parameterName;
                    } else {
                        console.debug("parameter " + parameterName + " is excluded");
                    }
                }
            }

            // deal with javascript array problem - convert to proper key/value pairs required by jquery Ajax
            if ($.isArray(mergedParameters)) {
                var keyValuePairs = {};
                for (var paramKey in mergedParameters) {
                    if ($.isArray(mergedParameters[paramKey])) {
                        if (mergedParameters[paramKey].length > 0) {
                            keyValuePairs[paramKey] = mergedParameters[paramKey];
                        }
                    } else {
                        keyValuePairs[paramKey] = mergedParameters[paramKey];
                    }
                }
                mergedParameters = keyValuePairs;
                console.debug("mergedParameters after modifying = " + JSON.stringify(mergedParameters));
            }

            var failureHandler = function(data, status) {
                console.error("failed to refresh widget " + domNode.attr("id"));
                wcTopic.publish("ajaxRequestCompleted");
            }

            var successHandler = function(data, status) {
                function getIds(idType, controllerURL) {
                    var myId = "";
                            if (mergedParameters && mergedParameters[idType]) {
                                    myId = mergedParameters[idType];
                    }
                    if (myId === "" && formNode != null && formNode[idType]) {
                        myId = formNode[idType];
                        if (formNode[idType].value != null) {
                            myId = formNode[idType].value;
                        }
                    }
                    if (myId === "" && controllerURL) {
                        var temp = controllerURL;
                        if (temp.indexOf(idType) !== -1) {
                            temp = temp.substring(temp.indexOf(idType));
                            var tokens = temp.split("&");
                            var tokens2 = tokens[0].split("=");
                            myId = tokens2[1];
                        }
                    }
                    return myId;
                }
                function parseJsonCommentFiltered(str){
                    str = str.replace('\/\*', '');
                    str = str.replace('\*\/', '');
                    var json = eval('(' + str + ')');
                    return json;
                }

                // determine storeId, catalogId and langId to use in our redirect url
                var storeId = getIds("storeId", widget.url);
                var catalogId = getIds("catalogId", widget.url);
                var langId = getIds("langId", widget.url);
                var errorCodeBegin = data.indexOf('errorCode');

                function serverErrorHandler(errorCode) {
                    console.debug('error condition encountered - error code: ' + errorCode);
                    // error code: ERR_DIDNT_LOGON
                    // This error code is returned in the scenario where logon is required and user is not logged on
                    if (errorCode.indexOf('2550') !== -1) {
                        console.debug('error type: ERR_DIDNT_LOGON - the customer did not log on to the system.');
                        console.debug("redirecting to URL: AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1');
                        document.location.href = "AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                    }

                    // error code: ERR_SESSION_TIMEOUT
                    // This error code is returned in the scenario where user's logon session has timed out
                    else if (errorCode.indexOf('2510') !== -1) {
                        //redirect to a full page for sign in
                        console.debug('error type: ERR_SESSION_TIMEOUT - use session has timed out');
                        var serviceResponse = parseJsonCommentFiltered(data);
                        var timeoutURL = "Logoff?";
                        if (serviceResponse.exceptionData.isBecomeUser == 'true') {
                            timeoutURL = "RestoreOriginalUserSetInSession?URL=Logoff&";
                        }
                        if (serviceResponse.exceptionData.rememberMe == 'true'){
                            var myURL = timeoutURL + 'rememberMe=true&storeId=' + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                            console.debug('try to logoff, get URL='+myURL);
                            $.ajax({
                                type: "GET",
                                url: myURL,
                                data: mergedParameters,
                                success: function(data, status) {
                                  console.debug('User logged off. Reload current page to avoid data inconsistence...');
                                  document.location.reload();
                                },
                                error: function(data) {
                                    // failed to logoff, directly go to relogon form;
                                    // this should not happen, just in case.
                                    document.location.href = 'ReLogonFormView?rememberMe=true&storeId='+storeId;
                                }
                            });
                        }
                        else {
                            console.debug('redirecting to URL: ' + timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId);
                            document.location.href = timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId;
                        }
                    }

                    // error code: ERR_PROHIBITED_CHAR
                    // This error code is returned in the scenario where user has entered prohibited character(s) in the request
                    else if (errorCode.indexOf('2520') !== -1) {
                        console.debug('error type: ERR_PROHIBITED_CHAR - detected prohibited characters in request');
                        console.debug("redirecting to URL: ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                    }

                    // error code: ERR_CSRF
                    // This error code is returned in the scenario where a cross-site request forgery attempt was caught
                    else if (errorCodeString.indexOf('2540') !== -1) {
                        console.debug('error type: ERR_CSRF - cross site request forgery attempt was detected');
                        console.debug("redirecting to URL: CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                    }

                    // error code: _ERR_INVALID_COOKIE
                    // This error code is returned in the scenario where a cookie error occurs
                    else if (errorCodeString.indexOf('CMN1039E') !== -1) {
                        console.debug('error type: _ERR_INVALID_COOKIE - cookie error was detected');
                        console.debug("redirecting to URL: CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                    }
                }

                if (errorCodeBegin != -1) {
                    // error code returned, get error code and handle error condition
                    var errorCodeEnd = data.indexOf(',', errorCodeBegin);
                    var errorCodeString = data.substring(errorCodeBegin, errorCodeEnd);
                    serverErrorHandler(errorCodeString);
                } else {
                    // no error from get request, refresh area and call post refresh controller
                    domNode.html(data);
                    WCWidgetParser.parse(domNode);
                    if (widget.options.postRefreshHandler != null) {
                        widget.options.postRefreshHandler(widget.element);
                    }
                }
                wcTopic.publish("ajaxRequestCompleted");
                widget._updateLiveRegion();
            }

            var ajaxParams = {
                data: (formNode)? formNode.serialize()+"&"+$.param(mergedParameters) : mergedParameters,
                url: this.url,
                type: "POST",
                traditional: true,
                success: successHandler,
                error: failureHandler
            };

            $.ajax(ajaxParams);
        },

        renderContextChanged: function(refreshAreaDiv) {
            if (this.options.renderContextChangedHandler != null) {
                this.options.renderContextChangedHandler(refreshAreaDiv);
            }
        },

        _updateLiveRegion: function () {
            $("#" + this.ariaLiveId + "_ACCE_Label").css("display", "block");

            if (this.ariaMessage !== "" && this.ariaLiveId !== "") {
                var messageNode = document.createTextNode(this.ariaMessage);
                var liveRegionNode = document.getElementById(this.ariaLiveId);
                if (liveRegionNode) {
                    while (liveRegionNode.firstChild) {
                        liveRegionNode.removeChild(liveRegionNode.firstChild);
                    }
                    liveRegionNode.appendChild(messageNode);
                }
            }
        }

    });

}(jQuery));



