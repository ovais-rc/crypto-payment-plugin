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
 * @fileOverview This file provides the functions needed to declare and invoke a service in Commerce
 */

(function($) {
    $.wcServicePlugin = function(options) {
        var settings = $.extend({
            id: undefined,
            actionId: undefined,
            url: undefined,
            formId: undefined,
            successHandler: undefined,
            failureHandler: undefined
        }, options);

        var validateParameters = function(parameters) {
            return true;
        };

        var validateForm = function(formNode) {
            return true;
        }

        var successTest = function(serviceResponse) {
            return !serviceResponse.errorMessage && !serviceResponse.errorMessageKey;
        };

        var _isParameterExcluded = function(url, parameterName){
            try{
                if(typeof URLConfig === 'object'){
                    if (typeof URLConfig.excludedURLPatterns === 'object'){
                        for (var urlPatternName in URLConfig.excludedURLPatterns){
                            var exclusionConfig = URLConfig.excludedURLPatterns[urlPatternName];
                            var urlPattern = urlPatternName;
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

        var output = {
            'setFormId': function(formId) {
                settings.formId = formId;
            },
            'setActionId': function(actionId) {
                settings.actionId = actionId;
            },
            'setUrl': function(url) {
                settings.url = url;
            },
            'setParam': function(paramName, value) {
            	settings[paramName] = value;
            },
            'getParam': function(paramName) {
                return settings[paramName];
            },
            'invoke': function(parameters) {
                var valid = true;
                var formNode = null;
                if (settings.formId) {
                    formNode = $("#" + settings.formId);
                }

                if (formNode) {
                    valid = validateForm(formNode);
                }

                if (valid) {
                    valid = validateParameters(parameters);
                }

                function addAuthToken(parameters){
                    try{
                        if ($("#csrf_authToken").length){
                            parameters["authToken"] = $("#csrf_authToken").val();
                        } else {
                            console.debug("auth token is missing from the HTML DOM");
                        }
                        return true;
                    } catch (err){
                        console.debug("An error occured while trying to add authToken to request " + err);
                    }
                    return false;
                }


                if (parameters) {
                    if (!parameters.requesttype) {
                        parameters.requesttype = 'ajax';
                    }
                } else {
                    parameters = {};
                    parameters.requesttype = 'ajax';
                }

                addAuthToken(parameters);

                var mergedParameters = parameters;
                if(typeof wcCommonRequestParameters === 'object'){
                    mergedParameters = {};
                    $.extend(mergedParameters, parameters);

                    for(var parameterName in wcCommonRequestParameters){
                        if(!_isParameterExcluded(this.url, parameterName)){
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

                var successHandler = function(serviceResponse, status) {
                    function getIds(idType, controllerURL) {
                        var myId = "";
                        if (mergedParameters && mergedParameters[idType]) {
                            myId = mergedParameters[idType];
                        }
                        if (myId == "" && formNode != null && formNode[idType]) {
                            myId = formNode[idType];
                            if (formNode[idType].value != null) {
                                myId = formNode[idType].value;
                            }
                        }
                        if (myId == "" && controllerURL) {
                            var temp = controllerURL;
                            if (temp.indexOf(idType) != -1) {
                                temp = temp.substring(temp.indexOf(idType));
                                var tokens = temp.split("&");
                                var tokens2 = tokens[0].split("=");
                                myId = tokens2[1];
                            }
                        }
                        return myId;
                    }

                    // determine storeId, catalogId and langId to use in our redirect url
                    var storeId = getIds("storeId", settings.url);
                    var catalogId = getIds("catalogId", settings.url);
                    var langId = getIds("langId", settings.url);

                    function serverErrorHandler(errorCode) {
                        // error code: ERR_USER_NOT_LOGGED_ON
                        // This error code is returned in the scenario where logon is required and user is not logged on
                        if (errorCode == '2500') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');

                            myURL = 'LogonForm?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                            console.debug('error type: ERR_USER_NOT_LOGGED_ON - only registered user can invoke the command');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                        }

                        // error code: ERR_DIDNT_LOGON
                        // This error code is returned in the scenario where logon is required and user is not logged on
                        else if (errorCode == '2550') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');
                            myURL = 'AjaxLogonForm?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                            console.debug('error type: ERR_DIDNT_LOGON - the customer did not log on to the system.');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                        }

                        // error code: ERR_PASSWORD_REREQUEST
                        // This error code is returned in the scenario where password is required to proceed
                        else if (errorCode == '2530') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');
                            myURL = 'PasswordReEnterErrorView?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                            console.debug('error type: ERR_PASSWORD_REREQUEST - password is required');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                        }

                        // error code: ERR_SESSION_TIMEOUT
                        // This error code is returned in the scenario where user's logon session has timed out
                        else if (errorCode == '2510') {
                            //redirect to a full page for sign in
                            console.debug('error type: ERR_SESSION_TIMEOUT - use session has timed out');
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
                                })
                            } else {
                                console.debug('redirecting to URL: ' + timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId);
                                document.location.href = timeoutURL + 'URL=ReLogonFormView&storeId=' + storeId;
                            }
                        }

                        // error code: ERR_PROHIBITED_CHAR
                        // This error code is returned in the scenario where user has entered prohibited character(s) in the request
                        else if (errorCode == '2520') {
                            console.debug('error type: ERR_PROHIBITED_CHAR - detected prohibited characters in request');
                            console.debug("redirecting to URL: " + "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                        }

                        // error code: ERR_CSRF
                        // This error code is returned in the scenario where a cross-site request forgery attempt was caught
                        else if (errorCode == '2540') {
                            console.debug('error type: ERR_CSRF - cross site request forgery attempt was detected');
                            console.debug("redirecting to URL: " + "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                        }

                        // error code: _ERR_INVALID_COOKIE
                        // This error code is returned in the scenario where a cookie error occurs
                        else if (errorCode == 'CMN1039E') {
                            console.debug('error type: _ERR_INVALID_COOKIE - cookie error was detected');
                            console.debug("redirecting to URL: " + "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                        }

                        else if (settings.failureHandler) {
							console.debug('calling service.failureHandler');
							settings.failureHandler(serviceResponse, status);
                        }
                        wcTopic.publish("ajaxRequestCompleted");
                    }

                    // debugging statement
                    console.debug("response from ajax call:");
                    for (var prop in serviceResponse) {
                        console.debug("  " + prop + "=" + serviceResponse[prop]);
                    }

                    if (successTest(serviceResponse)) {
                        if (settings.successHandler) {
                            var reqData = $(this).attr('data');
                            reqData = reqData?JSON.parse('{"' + reqData.replace(/&/g, '","').replace(/=/g,'":"') + '"}',
                                function(key, value) { return key===""?value:decodeURIComponent(value) }):{}
                            settings.successHandler(serviceResponse, reqData);

                            console.debug("success: publishing modelChanged event")
                        }
						if (settings.actionId) {
							console.debug('triggering action: ' + settings.actionId);
							wcTopic.publish(settings.actionId, {actionId: settings.actionId, data:serviceResponse});
						}
                    }
					else {
                        // error returned from server
                        console.debug('error condition encountered - error code: ' + serviceResponse.errorCode);
                        serverErrorHandler(serviceResponse.errorCode);
                    }
                };

                // when the AJAX method returns failed status
                var failureHandler = function(serviceResponse, status) {
                    console.debug("Warning: communication error while making the service call"); // Communication error.
                    var message = serviceResponse.errorMessage;
                    if (message) {
                        alert(message);
                    }
                    else {
                        message = serviceResponse.errorMessageKey;
                        if (message) {
                            alert(message);
                        }
                        else {
                            alert("Service request error.");
                        }
                    }
                };

                console.debug("service formId = " + settings.formId);

                if (!valid) return;

                wcTopic.publish("ajaxRequestInitiated");

                var stripComment = function(str, startString, endString) {
                    // remove <startString> <endString> pair. e.g. <!-- and -->
                    var beginIndex = str.indexOf(startString);
                    var endIndex = -1;
                    var part1 = "";
                    var part2 = "";
                    if (beginIndex != -1) {
                        endIndex = str.indexOf(endString);
                    }
                    if (endIndex != -1) {
                        part1 = str.substr(0,beginIndex);
                        part2 = str.substr(endIndex + endString.length);
                        str = part1 + part2;
                    }
                    // removes comments recursively
                    if (str.indexOf(startString) != -1) {
                        str = stripComment(str, startString, endString);
                    }
                    return str;
                };

                var ajaxParams = {
                    url: settings.url,
                    type: "POST",
                    data: (formNode)? formNode.serialize()+"&"+$.param(mergedParameters,true) : mergedParameters,
                    traditional: true,
                    dataFilter: function (str) {
                        // remove /* */ pair
                        str = str.replace('\/\*', '');
                        str = str.replace('\*\/', '');

                        if (str.indexOf("<!--") != -1) {
                            str = stripComment(str, "<!--", "-->");
                        }

                        if (str.indexOf("<%--") != -1) {
                            str = stripComment(str, "<%--", "--%>");
                        }

                        var json = eval('(' + str + ')');
                        return json;
                    },
                    success: successHandler,
                    error: failureHandler
                };

                $.ajax(ajaxParams);
            }

        };

        return output;
    }
}(jQuery));


wcService={
    wcServices: {},

    getServiceById:function(serviceId) {
        return this.wcServices[serviceId];
    },

    declare: function(initProperties) {
        if (!initProperties.id) {
            return;
        }
        this.wcServices[initProperties.id] = $.wcServicePlugin(initProperties);
    },

    invoke: function(serviceId, parameters) {
        var service = this.getServiceById(serviceId);
        if (service) {
            service.invoke(parameters);
        }
        else {
            console.error("Attempt to invoke an unregistered service: " + serviceId);
        }
    }
}


