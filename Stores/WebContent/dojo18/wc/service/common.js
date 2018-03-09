//********************************************************************
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

dojo.provide("wc.service.common");
dojo.requireLocalization("wc", "common", null, "ROOT,en,en-us");

wc.service.services = {
    // summary: Map of all declared services.
    // description: The wc.service.services object stores all of the currently declared
    //		services. The service ID is the property name.
};

wc.service.getServiceById = function (id) {
    // summary: Get the declared service with the specified ID.
    // description: Get the service that was declared under the specified
    //		identifier. If the service was not declared then this function
    //		will return "undefined".
    // returns: The service with the specified ID.
    return wc.service.services[id];
};

wc.service.declare = function (initProperties) {
    // summary: Declare a new service with the specified ID.
    // description: This function declares a new service and initializes it
    //		with the specified initialization properties. The initialization properties
    //		are "mixed in" with the new service's properties.
    // returns: The new service.
    // initProperties: Object
    //		The initialization properties.
    var service = new wc.service.Service(initProperties);
    this.register(service);
    return service;
};

wc.service.register = function (service) {
    // summary: Register the specified service.
    // description: This function registers the specified service.
    // service: wc.service.Service
    //		The service to be registered.
    this.services[service.id] = service;
};

wc.service.invoke = function (serviceId, parameters) {
    // summary: Invokes the specified service.
    // description: This function finds the registerd service with the
    //		specified service ID and invokes the service using the specified
    //		parameters.
    // serviceId: String
    //		The service ID.
    // parameters: Object
    //		The service parameters.
    console.debug(" wc.service.invoke  : " + parameters);
    var service = this.getServiceById(serviceId);
    if (service) {
        service.invoke(parameters);
    }
    else {
        console.debug("Attempt to invoke an unregistered service: " + serviceId);
    }
};

dojo.declare("wc.service.Service", null, {
    // summary: Service class.
    // description: This class provides support for invoking a service. A service is a server URL
    //		that performs a server object create, update, delete or other server processing. When
    //		the service completes successfully, a model changed event will be sent to any subscribed
    //		listeners.
    // id: String
    //		The unique ID of this service.
    // actionId: String
    // 		An identifier for the action performed by this service. This value will be used in the
    //		construction of the topic name for the model changed event. The model changed event name will be
    //		of the form "modelChanged/actionId".
    // url: String
    //		The URL for this service.
    // formId: String
    //		The ID of the form element that will be posted to the URL. A service does not necessarily have
    //		to be associated with a form element.
    constructor: function (initProperties) {
        // summary: Service initializer.
        // description: Initializes the new refresh controller.
        // initProperties: Object
        //		Initialization properties. The properties are mixed in with the new refresh controller's
        //		properties.
        dojo.mixin(this, initProperties);
    },

    id: undefined,
    actionId: undefined,
    url: undefined,
    formId: undefined,

    validateParameters: function (parameters) {
        // summary: Validate that the service parameters are correct.
        // description: This function examines the service parameters to determine if the service
        //		is ready to be invoked. The function will be called from the invoke function before
        //		the service is invoked. The default implementation of this function returns "true".
        //		This function may be replaced by passing in a new version with the initProperties object
        //		when the service is constructed.
        // returns: "true" if the parameters are valid
        // parameters: Object
        //		The parameters Object that was passed to the invoke function.
        return true;
    },

    validateForm: function (formNode) {
        // summary: Validate that the form values are correct.
        // description: This function examines the specified form element to determine if the service
        //		is ready to be invoked. The function will be called from the invoke function before
        //		the service is invoked. The default implementation of this function returns "true".
        //		This function may be replaced by passing in a new version with the initProperties object
        //		when the service is constructed.
        // returns: "true" if the form values are valid
        // parameters: Element
        //		The form element that has the id specified by the "formId" property.
        return true;
    },

    successTest: function (serviceResponse) {
        // summary: Test for a successful service invocation.
        // description: This function examines the specified service response object to determine
        //		if the service was successful or not. The function will be called after the response
        //		was received from the service. The default implementation will return true if there
        //		is no "errorMessage" property in the service response object. This function may be
        //		replaced by passing in a new version with the initProperties object when the service
        //		is constructed.
        // returns: "true" if the service request is successful
        // serviceResponse: Object
        //		The service response object. This object is the JSON Object returned by the service
        //		invocation.
        return !serviceResponse.errorMessage && !serviceResponse.errorMessageKey;
    },

    successHandler: function (serviceResponse, ioArgs) {
        // summary: Perform processing after a successful service invocation.
        // description: This function will be called after a successful service invocation to allow
        //		for any post service processing. The default implementation does nothing. This function
        //		may be replaced by passing in a new version with the initProperties Object when the
        //		service is constructed.
        // serviceResponse: Object
        //		The service response object. This object is the JSON Object returned by the service
        //		invocation.
    },

    failureHandler: function (serviceResponse, ioArgs) {
        // summary: Perform processing after a failed service invocation.
        // description: This function will be called after a failed service invocation to handle
        //		any error processing. The default implementation alerts the user with the error
        //		message found in the service response object. This function may be replaced by passing
        //		in a new version with the initProperties Object when the service is constructed.
        // serviceResponse: Object
        //		The service response object. This object is the JSON Object returned by the service
        //		invocation.
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
    },

    invoke: function (parameters) {
        // summary: Invoke the service.
        // description: This function will asynchronously invoke the configured service URL with
        //		the specified parameters. If this service was configured with a form ID, then the
        //		form values will be posted to the URL. When the service completes successfully,
        //		a "modelChanged" event will be published to any listeners. If the "actionId" property
        //		has been configured, then an event with the topic name "modelChanged/actionId" will also
        //		be published.
		
		function isParameterExcluded(url, parameterName){
    		try{
	    		if(typeof URLConfig === 'object'){
					if (typeof URLConfig.excludedURLPatterns === 'object'){
						for ( var urlPatternName in URLConfig.excludedURLPatterns){
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
		
    	function addAuthToken(url,parameters){
    		try{
				if(dojo.byId("csrf_authToken") != null){
					parameters["authToken"] = dojo.byId("csrf_authToken").value;
				} else {
					console.debug("auth token is missing from the HTML DOM");
				}
				return true;
    		} catch (err){
				console.debug("An error occured while trying to add authToken to request " + err);
			}
			return false;
    	}
		
        var valid = true;

        var formNode = null;
        if (this.formId) {
            formNode = document.getElementById(this.formId);
        }

        if (formNode) {
            valid = this.validateForm(formNode);
        }
        if (valid) {
            valid = this.validateParameters(parameters);
        }
        if (parameters) {
            if (!parameters.requesttype) {
                parameters.requesttype = 'ajax';
            }
        } else {
            parameters = [];
            parameters.requesttype = 'ajax';
        }
		addAuthToken(this.url,parameters);
		
	    var mergedParameters = parameters;
		if(typeof wcCommonRequestParameters === 'object'){
			console.debug("Common parameters = " + dojo.toJson(wcCommonRequestParameters));
			mergedParameters = {};
			dojo.mixin(mergedParameters, parameters);
			
			for(var parameterName in wcCommonRequestParameters){
				if(!isParameterExcluded(this.url, parameterName)){
					mergedParameters[parameterName] = wcCommonRequestParameters[parameterName];
				} else {
					console.debug("parameter " + parameterName + " is excluded");
				}
			}
			console.debug("After merging = " + dojo.toJson(mergedParameters));
		}

        console.debug("service formId = " + this.formId);
        if (valid) {
            dojo.publish("ajaxRequestInitiated");
            dojo.xhrPost({
                url: this.url,
                handleAs: "json-comment-filtered",
                form: formNode,
		                content: mergedParameters,
                service: this,
                load: function(serviceResponse, ioArgs) {
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

                    var service = ioArgs.args.service;
                    serviceResponse.serviceId = service.id;
                    serviceResponse.actionId = service.actionId;
                    console.debug("Service response action id : " + serviceResponse.actionId);
                    for (var prop in serviceResponse) {
                        console.debug("  " + prop + "=" + serviceResponse[prop]);
                    }
                    if (service.successTest(serviceResponse)) {
                        service.successHandler(serviceResponse, ioArgs);

                        console.debug("success: publishing modelChanged event")
                        dojo.publish("modelChanged", [serviceResponse]);

                        if (service.actionId) {
                            console.debug("success: publishing modelChanged/" + service.actionId + " event");
                            dojo.publish("modelChanged/" + service.actionId, [serviceResponse]);
                        }
                    }
                    else {
                        // determine storeId, catalogId and langId to use in our redirect url
                        var storeId = getIds("storeId", this.url);
                        var catalogId = getIds("catalogId", this.url);
                        var langId = getIds("langId", this.url);

                        console.debug('error condition encountered - error code: ' + serviceResponse.errorCode);

                        // error code: ERR_USER_NOT_LOGGED_ON
                        // This error code is returned in the scenario where logon is required and user is not logged on
                        if (serviceResponse.errorCode == '2500') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');

                            myURL = 'LogonForm?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                            console.debug('error type: ERR_USER_NOT_LOGGED_ON - only registered user can invoke the command');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                            // error code: ERR_DIDNT_LOGON
                            // This error code is returned in the scenario where logon is required and user is not logged on
                        } else if (serviceResponse.errorCode == '2550') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');
                            myURL = 'AjaxLogonForm?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                            console.debug('error type: ERR_DIDNT_LOGON - the customer did not log on to the system.');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;
                            // error code: ERR_PASSWORD_REREQUEST
                            // This error code is returned in the scenario where password is required to proceed
                        } else if (serviceResponse.errorCode == '2530') {
                            var myURL = serviceResponse.originatingCommand;
                            myURL = myURL.replace('?', '%3F');
                            myURL = myURL.replace(/&amp;/g, '%26');
                            myURL = myURL.replace(/&/g, '%26');
                            myURL = myURL.replace(/=/g, '%3D');
                            myURL = 'PasswordReEnterErrorView?nextUrl=' + myURL + "&storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                            console.debug('error type: ERR_PASSWORD_REREQUEST - password is required');
                            console.debug('redirecting to URL: ' + myURL);
                            document.location.href = myURL;

                            // error code: ERR_SESSION_TIMEOUT
                            // This error code is returned in the scenario where user's logon session has timed out
                        } else if (serviceResponse.errorCode == '2510') {
                            //redirect to a full page for sign in
                            console.debug('error type: ERR_SESSION_TIMEOUT - use session has timed out');
							var timeoutURL = "Logoff?";
							if (serviceResponse.exceptionData.isBecomeUser == 'true') {
								timeoutURL = "RestoreOriginalUserSetInSession?URL=Logoff&";
							}
							if (serviceResponse.exceptionData.rememberMe == 'true'){
								var myURL = timeoutURL + 'rememberMe=true&storeId=' + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
								console.debug('try to logoff, get URL='+myURL);
								dojo.xhrGet({
									url: myURL,				
									handleAs: "text",
									content: mergedParameters,
									service: this,
									load: function(serviceResponse, ioArgs) {
									  console.debug('User logged off. Reload current page to avoid data inconsistence...');
									  document.location.reload();
									},
									error: function(errObj,ioArgs) {
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

                            // error code: ERR_PROHIBITED_CHAR
                            // This error code is returned in the scenario where user has entered prohibited character(s) in the request
                        } else if (serviceResponse.errorCode == '2520') {
                            console.debug('error type: ERR_PROHIBITED_CHAR - detected prohibited characters in request');
                            console.debug("redirecting to URL: " + "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;

                            // error code: ERR_CSRF
                            // This error code is returned in the scenario where a cross-site request forgery attempt was caught
                        } else if (serviceResponse.errorCode == '2540') {
                            console.debug('error type: ERR_CSRF - cross site request forgery attempt was detected');
                            console.debug("redirecting to URL: " + "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;

                            // error code: _ERR_INVALID_COOKIE
                            // This error code is returned in the scenario where a cookie error occurs
                        } else if (serviceResponse.errorCode == 'CMN1039E') {
                            console.debug('error type: _ERR_INVALID_COOKIE - cookie error was detected');
                            console.debug("redirecting to URL: " + "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                            document.location.href = "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;

                        } else {
                            console.debug('calling service.failureHandler');
                            service.failureHandler(serviceResponse, ioArgs);
                        }
                    }
                    dojo.publish("ajaxRequestCompleted");
                },
                error: function(errObj, ioArgs) {
                    var messages = dojo.i18n.getLocalization("wc", "common");
                    console.debug("Warning: communication error while making the service call"); // Communication error.
                    dojo.publish("ajaxRequestCompleted");
                }
            });
        }
    }
});