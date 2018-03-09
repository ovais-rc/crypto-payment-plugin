//********************************************************************
//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide("wc.render.RefreshController");

dojo.requireLocalization("wc", "common", null, "ROOT,en,en-us");
dojo.require("dojo.parser");

wc.render.refreshControllers = {
    // summary: Map of all declared refresh controllers.
    // description: The wc.render.refreshControllers object stores all of the currently declared
    //		refresh controllers. The refresh controller ID is the property name.
};

wc.render.getRefreshControllerById = function (id) {
    // summary: Get the declared refresh controller with the specified ID.
    // description: Get the refresh controller that was declared under the specified
    //		identifier. If the refresh controller was not declared then this function
    //		will return "undefined".
    // returns: The refresh controller with the specified ID.
    return wc.render.refreshControllers[id];
};

wc.render.declareRefreshController = function (initProperties) {
    // summary: Declare a new refresh controller with the specified ID.
    // description: This function declares a new refresh controller and initializes it
    //		with the specified initialization properties. The initialization properties
    //		are "mixed in" with the new refresh controller's properties.
    // returns: The new refresh controller.
    // initProperties: Object
    //		The initialization properties.
    var refreshController = new wc.render.RefreshController(initProperties);
    this.refreshControllers[initProperties.id] = refreshController;
    return refreshController;
};

dojo.declare("wc.render.RefreshController", null, {
    // summary: Refresh controller class.
    // description: This class controls refresh area widgets. It listens to changes
    //		in the render context and changes to the model and decides if the registered
    //		refresh areas should be updated.
    // id: String
    //		The ID of the refresh area.
    // renderContext: wc.render.Context
    //		The render context object that is associated with this refresh controller.
    // url: String
    //		The URL that is called by the "refresh" function to retrieve the refreshed content
    //		for the refresh area widget.
    // mimetype: String
    //		The MIME type used with the refresh URL. The default value is "text/html". Use "text/json"
    //		to indicate that the refresh content is JSON.
    // renderContextChangedHandler: Function
    //		If defined, this function will be called when a render context changed event is detected. It
    //		will be called once for each refresh area widget registered to this refresh controller.
    //		The function signature is (message, widget) where "message" is the render context changed
    //		event message and widget is the refresah area widget.
    // modelChangedHandler: Function
    //		If defined, this function will be called when a "modelChanged" event is detected. It will be called
    //		once for each refresh area widget registered to this refresh controller. The function signature is
    //		(message, widget) where "message" is the model changed event message and widget is the refresh area
    //		widget.
    // postRefreshHandler: Function
    //		If defined, this function will be called after a successful refresh. The function signature is
    //		(widget) where "widget" is the refresh area widget that was just refreshed.
    // currentRCProperties: Object
    //		The current render context properties. This object is used to determine what properties have
    //		actually changed since the last time a render context changed event was detected.
    // widgets: Object
    //		The Map of registered refresh area widgets. The property names are the widget identifiers.
    constructor: function (initProperties) {
        // summary: Refresh controller initializer.
        // description: Initializes the new refresh controller.
        // initProperties: Object
        //		Initialization properties. The properties are mixed in with the new refresh controller's
        //		properties.

        dojo.mixin(this, initProperties);
        this.syncRCProperties();
        if (dojo.isFunction(this.renderContextChangedHandler)) {
            if (this.renderContext == null || this.renderContext == undefined) {
                console.debug("WARNING from RefreshController - renderContextChangedHandler function cannot be defined when renderContext is null or undefined. Controller id: " + this.id);
            } else {
                dojo.subscribe(this.renderContext.contextChangedEventName, this, "renderContextChanged");
            }
        }
        if (dojo.isFunction(this.modelChangedHandler)) {
            dojo.subscribe("modelChanged", this, "modelChanged");
        }
        this.widgets = {};
    },

    id: undefined,
    renderContext: undefined,
    url: undefined,
    mimetype: "text/html",
    renderContextChangedHandler: undefined,
    modelChangedHandler: undefined,
    postRefreshHandler: undefined,
    currentRCProperties: undefined,
    widgets: undefined,
    formId: undefined,

    addWidget: function(widget) {
        // summary: Register the specified refresh area widget.
        // description: This function registers the specified refresh area widget to this refresh controller.
        //		This function is normally called by the "initialize" function of "wc.widget.RefreshArea".
        // widget: wc.widget.RefreshArea
        //		The refresh area widget that is to be controlled by this refresh controller.
        if (this.widgets[widget.id]) {
            console.debug("RefreshController.addWidget: duplicate widget ID " + widget.id);
        }
        this.widgets[widget.id] = widget;
        console.debug("REFRESH CONTROLLER " + this.id + " ADDED THIS WIDGET..." + widget + " with id = " + widget.id);
    },

    removeWidget: function(widget) {
        // summary: Deregister the specified refresh area widget.
        // description: This function deregisters the specified refresh area widget from this refresh controller.
        //		This function is normally called by the "destroy" function of "wc.widget.RefreshArea".
        // widget: wc.widget.RefreshArea
        //		The refresh area widget that is no longer to be controlled by this refresh controller.

        if (typeof this.widgets == "undefined") {
            console.debug("this.widgets in RefreshController#removeWidget(widget) is not defined yet. No deletion is needed");
            return;
        }
        delete this.widgets[widget.id];
    },

    syncRCProperties: function() {
        // summary: Synchronize the local copy of the render context properties with the current
        //		render context properties.
        // description: This function will synchronize the local copy of the render context properties
        //		with the render context properties of the wc.render.Context object associated with this
        //		refresh controller.
        if (this.renderContext) {
            var properties = {};
            var rc = this.renderContext.properties
            for (var prop in rc) {
                properties[prop] = rc[prop];
            }
            this.currentRCProperties = properties;
        }
    },

    renderContextChanged: function(message) {
        // summary: Render context changed listener.
        // description: This function is called when a render context changed event occurs.
        //		It calls "renderContextChangedHandler" for each of the registered refresh area
        //		widgets and then it calls "syncRCProperties" to synchronize the local copy of the
        //		render context properties.
        // message: Object
        //		Render context changed event message.
        for (var widgetId in this.widgets) {
            console.debug("Call renderContext changed handler for the widget..." + this.widgets[widgetId]);
            this.renderContextChangedHandler(message, this.widgets[widgetId]);
        }
        this.syncRCProperties();
    },

    modelChanged: function(message) {
        // summary: Model changed listener.
        // description: This function is called when a model changed event occurs.
        //		It calls "modelChangedHandler" for each of the registered refresh area
        //		widgets.
        // message: Object
        //		Model changed event message.
        for (var widgetId in this.widgets) {
            this.modelChangedHandler(message, this.widgets[widgetId]);
        }
    },

    refreshHandler: function(widget, data) {
        // summary: Default refresh handler.
        // description: This function is after a refresh request has been sent and
        //		the refresh content has been retrieved from the server. The default
        //		implementation is to call "widget.setInnerHTML" and pass it the data
        //		retrieved from the server. This function implementation should be replace
        //		if this is not the desired refresh behaviour.
        // widget: wc.widget.RefreshArea
        //		The refresh area widget.
        // data: String
        //		The data returned from the server. For the default implementation, this
        //		value is expected to be the HTML String.
        widget.setInnerHTML(data);
    },

    refresh: function (widget, parameters) {
        // summary: Invoke an Ajax style request to refresh the specified widget.
        // description: This function invokes an Ajax style request to the refresh controller's
        //		refresh URL with the specified parameters. This function is normally called by
        //		the "refresh" function of "wc.widget.RefreshArea".
        // widget: wc.widget.RefreshArea
        //		The refresh area widget being refreshed.
        // parameters: Object
        //		The name/value pair parameters that are to be sent with this URL.

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
		
		var formNode = null;
		if(this.formId) {
			formNode = document.getElementById(this.formId);
		}
		
		if (parameters) {
			if (!parameters.requesttype) {
				parameters.requesttype = 'ajax';
			}
		} else {
			parameters = [];
			parameters.requesttype = 'ajax';
		}
		//Remove all instances of "amp;" in the URL which was added on the JSP by c:out
		this.url = this.url.replace(/amp;/g, "");

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
		
        dojo.publish("ajaxRequestInitiated");

        dojo.xhrPost({
            url: this.url,
            mimetype: this.mimetype,
            form: formNode,
	                content: mergedParameters,
            load: function(data) {
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
				function parseJsonCommentFiltered(str){ 
					str = str.replace('\/\*', '');
					str = str.replace('\*\/', '');
					var json = eval('(' + str + ')'); 
					return json; 
				} 

                // determine storeId, catalogId and langId to use in our redirect url
                var storeId = getIds("storeId", this.url);
                var catalogId = getIds("catalogId", this.url);
                var langId = getIds("langId", this.url);

                var errorCodeBegin = data.indexOf('errorCode');
                if (errorCodeBegin != -1) {
                    // get error code
                    var errorCodeEnd = data.indexOf(',', errorCodeBegin);
                    var errorCodeString = data.substring(errorCodeBegin, errorCodeEnd);

                    console.debug('error condition encountered - error code: ' + errorCodeString);
                    // error code: ERR_DIDNT_LOGON
                    // This error code is returned in the scenario where logon is required and user is not logged on
                    if (errorCodeString.indexOf('2550') != -1) {
                        console.debug('error type: ERR_DIDNT_LOGON - the customer did not log on to the system.');
                        console.debug("redirecting to URL: " + "AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1');
                        document.location.href = "AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId + '&myAcctMain=1';
                    }
                    // error code: ERR_SESSION_TIMEOUT
                    // This error code is returned in the scenario where user's logon session has timed out
                    else if (errorCodeString.indexOf('2510') != -1) {
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
                    } else if (errorCodeString.indexOf('2520') != -1) {
                        console.debug('error type: ERR_PROHIBITED_CHAR - detected prohibited characters in request');
                        console.debug("redirecting to URL: " + "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "ProhibitedCharacterErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;

                        // error code: ERR_CSRF
                        // This error code is returned in the scenario where a cross-site request forgery attempt was caught
                    } else if (errorCodeString.indexOf('2540') != -1) {
                        console.debug('error type: ERR_CSRF - cross site request forgery attempt was detected');
                        console.debug("redirecting to URL: " + "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "CrossSiteRequestForgeryErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;

                        // error code: _ERR_INVALID_COOKIE
                        // This error code is returned in the scenario where a cookie error occurs
                    } else if (errorCodeString.indexOf('CMN1039E') != -1) {
                        console.debug('error type: _ERR_INVALID_COOKIE - cookie error was detected');
                        console.debug("redirecting to URL: " + "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);
                        document.location.href = "CookieErrorView?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
                    }

                } else {
                    var controller = widget.controller;
                    console.debug("RefreshController.refresh - calling refreshHandler for " + widget);
                    controller.refreshHandler(widget, data);
                    if (controller.postRefreshHandler != null) {
                        console.debug("RefreshController.refresh - calling postRefreshHandler for " + widget);
                        controller.postRefreshHandler(widget);
                    }
                }
                dojo.publish("ajaxRequestCompleted");
                widget.updateLiveRegion();
            },
            error: function(error) {
                // handle error here - what do you do when a refresh doesn't happen?
                var messages = dojo.i18n.getLocalization("wc", "common");
                console.debug("Warning: communication error while updating the refresh area"); // Communication error.
                dojo.publish("ajaxRequestCompleted");
            }
        });
    },

    testForChangedRC: function(propertyNames) {
        // summary: Test for changes to the render context.
        // description: This function looks through the specified array of property names for
        //		a render context property that has changed since the last time a render context
        //		changed event was detected.
        // returns: true if any of the specified render context properties have changed
        // propertyNames: Array
        //		An array of property names to be tested.
        var change = false;
        for (var i = 0; i < propertyNames.length; i++) {
            var prop = propertyNames[i];
            if (this.currentRCProperties[prop] != this.renderContext.properties[prop]) {
                change = true;
                break;
            }
        }
        return change;
    }
});