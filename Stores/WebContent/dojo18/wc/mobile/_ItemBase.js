//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2011 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

dojo.provide("wc.mobile._ItemBase");

dojo.require("dojox.mobile.ProgressIndicator");
dojo.require("dojox.mobile.TransitionEvent");

dojo.declare("wc.mobile._ItemBase", null, {
	
	findCurrentView: function() {
		
		if(this.moveTo) {
			var moveToView = dijit.byId(this.moveTo);
			if(moveToView && moveToView.getShowingView) {
				return moveToView.getShowingView();
			}
		}
		
		if(this.urlTarget) {
			var urlTargetNode = dojo.byId(this.urlTarget);
			if(urlTargetNode) {
				for(var i = 0; i < urlTargetNode.childNodes.length; i++) {
					var widget = (urlTargetNode.childNodes[i].nodeType == 1 ? dijit.byNode(urlTargetNode.childNodes[i]) : null);
					if(widget && widget instanceof dojox.mobile.View && widget.getShowingView) {
						return widget.getShowingView();
					}
				}
			}
		}
		
		if(dojox.mobile.currentView) {
			return dojox.mobile.currentView;
		}
		
		var widget = this;
		while(true) {
			widget = widget.getParent();
			if(!widget) {
				return null;
			}
			if(widget instanceof dojox.mobile.View) {
				break;
			}
		}
		return widget;
		
	},
	
	startTransition: function(event) {
		
		event.preventDefault();
		event.stopPropagation();
		
		if(!this.moveTo && this.url && dojox.mobile._viewMap && dojox.mobile._viewMap[this.url]) {
			this.moveTo = dojox.mobile._viewMap[this.url];
		}
		
		var currentView = this.findCurrentView();
		var moveToView = (this.moveTo ? dijit.byId(this.moveTo) : null);
		
		if (moveToView && this.cached == 'false') {
			moveToView.destroyRecursive();
			moveToView = null;
		}
		
		if(moveToView) {
			if(moveToView != currentView) {
				currentView.performTransition(this.moveTo, this.transitionDir, this.transition);
			}
		}
		else if(this.url) {
			
			this.url = this.url + ((this.url.indexOf("?") == -1) ? "?" : "&") + "requesttype=ajax";
			
			if(this.sync) {
				this.dataLoaded(dojo._getText(this.url));
			}
			else {
				var progressIndicator = dojox.mobile.ProgressIndicator.getInstance();
				document.body.appendChild(progressIndicator.domNode);
				progressIndicator.start();
				dojo.xhrGet({
					url: this.url,
					load: dojo.hitch(this, this.dataLoaded)
				})
			}
		}
		
	},
	
	getIds: function(idType, controllerURL) {
		var myId = "";
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
	},
	
	dataLoaded: function(data) {
		
		var errorCodeBegin = data.indexOf('errorCode');
		if (errorCodeBegin != -1) {
			// get error code   
			var errorCodeEnd = data.indexOf(',', errorCodeBegin);
			var errorCodeString = data.substring(errorCodeBegin, errorCodeEnd);
			
			// determine storeId, catalogId and langId to use in our redirect url
			var storeId = this.getIds("storeId", this.url);
			var catalogId = this.getIds("catalogId", this.url);
			var langId = this.getIds("langId", this.url);
			
			console.debug('error condition encountered - error code: ' + errorCodeString);
			// error code: ERR_DIDNT_LOGON
			// This error code is returned in the scenario where logon is required and user is not logged on
			if (errorCodeString.indexOf('2550') != -1) {
				console.debug('error type: ERR_DIDNT_LOGON - the customer did not log on to the system.');
				console.debug("redirecting to URL: " + "AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId);	
				document.location.href = "AjaxLogonForm?storeId=" + storeId + "&catalogId=" + catalogId + "&langId=" + langId;
				
			// error code: ERR_SESSION_TIMEOUT
			// This error code is returned in the scenario where user's logon session has timed out
			} else if (errorCodeString.indexOf('2510') != -1) {
				//redirect to a full page for sign in
				console.debug('error type: ERR_SESSION_TIMEOUT - use session has timed out');
				console.debug('redirecting to URL: ' + 'Logoff?URL=ReLogonFormView&storeId='+storeId);	
				document.location.href = 'Logoff?URL=ReLogonFormView&storeId='+storeId;

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
			var progressIndicator = dojox.mobile.ProgressIndicator.getInstance();
			progressIndicator.stop();
			
			this.moveTo = this._parse(data);
			if(!dojox.mobile._viewMap) {
				dojox.mobile._viewMap = {};
			}
			dojox.mobile._viewMap[this.url] = this.moveTo;
			
			if(this.moveTo) {
				var currentView = this.findCurrentView();
				if(currentView) {
					currentView.performTransition(this.moveTo, this.transitionDir, this.transition);
				}
			}
		}
		
	},
	
	_parse: function(data) {
		
		var currentView = this.findCurrentView();
		var urlTargetNode = (currentView ? currentView.domNode.parentNode : dojo.byId(this.urlTarget));
		if(!urlTargetNode) {
			return null;
		}
		
		var tempDiv = document.createElement("div");
		tempDiv.style.visibility = "hidden";
		tempDiv.innerHTML = data;
		
		urlTargetNode.appendChild(tempDiv);
		
		var scripts = dojo.query("script", tempDiv);
		
		var view = null;
		
		var widgets = dojo.parser.parse(tempDiv);
		dojo.forEach(widgets, function(widget) {
			if(widget && !widget._started && widget.startup) {
				widget.startup();
			}
			if(widget instanceof dojox.mobile.View) {
				view = widget;
			}
		});
		
		urlTargetNode.removeChild(tempDiv);
		while(tempDiv.childNodes.length > 0) {
			urlTargetNode.appendChild(tempDiv.childNodes[0]);
		}
		
		scripts.forEach(function(node) {
			var script = document.createElement("script");
			script.attributes = node.attributes;
			script.textContent = node.textContent;
			node.parentNode.replaceChild(script, node);
		});
		
		if(view) {
			view._visible = true;
			view.domNode.style.display = "none";
			view.domNode.style.visibility = "visible";
			return (dojo.hash ? "#" + view.id : view.id);
		}
		
	}
	
});
