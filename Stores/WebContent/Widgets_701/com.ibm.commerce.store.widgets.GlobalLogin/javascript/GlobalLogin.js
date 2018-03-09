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

dojo.require("wc.service.common");
dojo.require("wc.render.common");

GlobalLoginJS ={
	
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
	* Widget id of the global login panel.
	*/
	globalLogInWidgetID :"Header_GlobalLogin",

	/**
	 * This variable stores the onmousedown event dojo.connect handle.
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
	setCommonParameters:function(langId,storeId,catalogId){
		this.langId = langId;
		this.storeId = storeId;
		this.catalogId = catalogId;		
		cursor_clear();
	},	
	
	hideGLPanel:function(isPanelVisible){
		this.isPanelVisible = isPanelVisible;
	},	

        registerWidget: function(widgetId){
                this.widgetsLoadedOnPage.push(widgetId);
        },
  		
	InitHTTPSecure:function(widgetId){	
		var href = document.location.href;
		var index = href.lastIndexOf("s", 4);
		
		if (index != -1){
			// Open sign in panel if loaded with HTTPS.
			GlobalLoginJS.displayPanel(widgetId);
			
		}else{
			// Loaded with HTTP			
			var newHref = href.substring(0,4) + "s" + (href.substring(4));
			setCookie("WC_DisplaySignInPanel_"+WCParamJS.storeId, "true" , {path:'/', domain:cookieDomain});
			// Reload main page with HTTPS. Then since WC_DisplaySignInPanel_ cookie is set, main page will make
			// an ajax call to load signIn panel and displays it.
			window.location = newHref;
			return;
		} 
	},
	
	displayPanel:function(widgetId){
		var redirectToPageName = getCookie("WC_RedirectToPage_"+WCParamJS.storeId);
		if (redirectToPageName != undefined && redirectToPageName != null){								
			setCookie("WC_RedirectToPage_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});	
		}

		//check if the sign in panel is loaded. if loaded, toggle the dropdown. Else, trigger a refresh. 
		var domAttr = require("dojo/dom-attr");
		var widgetNode = dojo.byId(widgetId);
		if(widgetNode != null){
			var panelLoaded = domAttr.get(widgetId, "panel-loaded");
			if(panelLoaded != null && panelLoaded){
				this.togglePanel(widgetNode);
				// Change the URL to display after successfull logOn.
				if(redirectToPageName != null && typeof (redirectToPageName) != 'undefined'){
					var globalLogInForm = document.getElementById(this.globalLogInWidgetID+"_GlobalLogon");
					if(globalLogInForm != null && typeof(globalLogInForm) != 'undefined'){
						globalLogInForm.URL.value = redirectToPageName;
					}
				}
			} else if (typeof isOnPasswordUpdateForm === 'undefined' || isOnPasswordUpdateForm == false) {
				if(!submitRequest()){
				   return;
				}
				cursor_wait();
				wc.render.updateContext("GlobalLogin_context",{"displayContract":"false", "widgetId" : widgetId, "redirectToPageName": redirectToPageName});
			}
		}
	},
  
	togglePanel: function (widgetNode){
		var domStyle = require("dojo/dom-style");
		var domClass = require("dojo/dom-class");
		var domAttr = require("dojo/dom-attr");
                	
		var toggleControl = domAttr.get(widgetNode, "data-toggle-control");
        	
		// toggle the current active global login panel.
		if (this.activePanel['active'] != null
				&& this.activePanel['selected'] != null){
			domClass.toggle(this.activePanel['active'], "active");
			domClass.toggle(this.activePanel['selected'], "selected");

			//if the current active panel is not the caller
			if(this.activePanel['active'] != widgetNode.id){
				//toggle current widget
				domClass.toggle(widgetNode, "active");
				domClass.toggle(toggleControl, "selected");
                
				//set the current caller as active
				this.activePanel['active'] = widgetNode.id;
				this.activePanel['selected'] = toggleControl;	
			} else {
				delete this.activePanel.active;
				delete this.activePanel.selected;
				domAttr.set(widgetNode.id, "panel-loaded", false);
				this.unregisterMouseDown();
			}	
		} else {
			//no panel is active. toggle the current
			domClass.toggle(widgetNode, "active");
			domClass.toggle(toggleControl, "selected");

			//set the current caller as active
			this.activePanel['active'] = widgetNode.id;
			this.activePanel['selected'] = toggleControl;	
			this.registerMouseDown();
		}
	},

	updateGlobalLoginSignInContent:function(widgetId){
		if(!submitRequest()){
			return;
		}			
		cursor_wait();	
		var redirectToPageName = getCookie("WC_RedirectToPage_"+WCParamJS.storeId);
		if (redirectToPageName != undefined && redirectToPageName != null){								
			setCookie("WC_RedirectToPage_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});	
		}	
		wc.render.updateContext("GlobalLogin_context",{"displayContract":"false", "widgetId": widgetId, "redirectToPageName": redirectToPageName});							
	},
	
	updateGlobalLoginUserDisplay: function(displayName){
		var dom = require("dojo/dom");
		var node = dom.byId("Header_GlobalLogin_signOutQuickLinkUser");
		node.innerHTML = displayName;
	},
	
	initGlobalLoginUrl:function(controllerId,widgetUrl){
		wc.render.getRefreshControllerById(controllerId).url = widgetUrl;
	},
	
	updateGlobalLoginContent:function(widgetId){
		if(!submitRequest()){
			return;
		}			
		cursor_wait();	
		wc.render.updateContext("GlobalLogin_context",{"displayContract":"true", "widgetId": widgetId});							
	},
	
	updateOrganization:function(formName, widgetId){	
		var orgSetInSessionURL = widgetId + '_' + 'orgSetInSessionURL';		
		var orgSetInSessionURLEle = document.getElementById(orgSetInSessionURL);
		if (orgSetInSessionURLEle != null){
			var href = document.location.href;		
			orgSetInSessionURLEle.value = href;					
		}
		var form = document.forms[widgetId + '_' + formName];
		if(!submitRequest()){ return; }
		processAndSubmitForm(form);
	},
	
	prepareSubmit:function(widgetId){
                var idPrefix = widgetId + "_";				
		if (document.getElementById(idPrefix + "signInDropdown") != null && document.getElementById(idPrefix + "signInDropdown").className.indexOf("active") > -1){
			document.getElementById(idPrefix + "inlinelogonErrorMessage_GL_logonPassword").setAttribute("class","errorLabel");
			document.getElementById(idPrefix + "inlineLogonErrorMessage_GL_logonId").setAttribute("class","errorLabel");	
			var form_input_field = document.getElementById(idPrefix + "WC_AccountDisplay_FormInput_logonId_In_Logon_1");			
			if (form_input_field !=null) {					
				if (this.isEmpty(form_input_field.value)){
					document.getElementById(idPrefix + "inlineLogonErrorMessage_GL_logonId").className  = document.getElementById(idPrefix + "inlineLogonErrorMessage_GL_logonId").className + " active";
					return false;
				}
			}
			var form_input_field = document.getElementById(idPrefix + "WC_AccountDisplay_FormInput_logonPassword_In_Logon_1");			
			if (form_input_field !=null) {				
				if (this.isEmpty(form_input_field.value)) {
					document.getElementById(idPrefix + "inlinelogonErrorMessage_GL_logonPassword").className  = document.getElementById(idPrefix + "inlinelogonErrorMessage_GL_logonPassword").className + " active";
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
	isEmpty:function (str) {
		var reWhiteSpace = new RegExp(/^\s+$/);
		if (str == null || str =='' || reWhiteSpace.test(str) ) {
			return true;
		}
		return false;
	},
	
	/**
	 * Updates the contract that is available to the current user.
	 * @param {string} formName  The name of the form that contains the selected contracts.	  
	 */
	updateContract:function(formName){	
		var form = document.forms[formName];
				
		/* For Handling multiple clicks. */
		if(!submitRequest()){ return; }
				
		form.submit();	
	},		
	
	deleteUserLogonIdCookie:function(contractURL){
		var userLogonIdCookie = getCookie("WC_LogonUserId_"+WCParamJS.storeId);
		if( userLogonIdCookie != null){
			setCookie("WC_LogonUserId_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
		}	
	},
	
	changeRememberMeState:function(jspStoreImgDir,target){
		var targetEle = document.getElementById(target);
		if(targetEle.className.indexOf("active") > -1){			
			targetEle.className  = targetEle.className.replace('active','');
			targetEle.setAttribute("aria-checked","false");
			targetEle.setAttribute("src",jspStoreImgDir + "images/checkbox.png");
			document.getElementById(target.replace("_img","")).setAttribute("value","false");
		}else{			
			targetEle.className  = targetEle.className + " active";
			targetEle.setAttribute("src",jspStoreImgDir + "images/checkbox_checked.png");
			targetEle.setAttribute("aria-checked","true");
			document.getElementById(target.replace("_img","")).setAttribute("value","true");
		}	
	},
  
        deleteLoginCookies: function(){
                this.deleteUserLogonIdCookie();
                setCookie("WC_BuyOnBehalf_"+WCParamJS.storeId, null, {path: '/', expires: -1, domain:cookieDomain});
	},
	
	/**
	 * Submit a global login sign in form
	 * @param (object) widgetId The form widgetId id.	 
	 */
	submitGLSignInForm:function(formId, widgetId) {				
		service = wc.service.getServiceById('globalLoginAjaxLogon');
		service.formId = formId;			
		var params = {};
		params["widgetId"] = widgetId;
		
		/*For Handling multiple clicks. */
		if(!submitRequest()){
			return;
		}			
		cursor_wait();				
		wc.service.invoke('globalLoginAjaxLogon', params);		
	},

	/**
	 * After successful login and setting a contract in session, we need to process the action that the shopper
	 * was performing before signing in. It will do nothing if shopper was not trying to perform any actions. 
	 */
	processNextURL:function() {
		var myNextURL = getCookie("WC_nextURL_"+WCParamJS.storeId);
		if(myNextURL != undefined && myNextURL.length > 0){
			myNextURL = myNextURL.replace(/&amp;/g, "&");
			if(myNextURL.indexOf('AjaxRESTOrderItemAdd') != -1){
				invokeItemAdd(myNextURL);
			} else {
				invokeOtherService(myNextURL);
			}
		}
	},

	registerMouseDown: function() {
		if (this.mouseDownConnectHandle == null) {
			this.mouseDownConnectHandle = dojo.connect(document.documentElement, "onmousedown", this, "handleMouseDown");
		}
	},
	
	unregisterMouseDown: function() {
		if (this.mouseDownConnectHandle != null) {
			dojo.disconnect(this.mouseDownConnectHandle);
			this.mouseDownConnectHandle = null;
		}
	},
	
	handleMouseDown: function(evt) {
		var domClass = require("dojo/dom-class");
		var domGeometry = require("dojo/dom-geometry");
		var query = require("dojo/query");
		if (this.activePanel["active"] != null && this.activePanel["selected"] != null) {
			var widgetNode = dojo.byId(this.activePanel["active"]);
			var toggleControl = dojo.byId(this.activePanel["selected"]);
			if (widgetNode) {
				var node = evt.target;
				if (node != document.documentElement) {
					var close = true;
					while (node && node != document.documentElement) {
						if (dojo.byId(node.id + "_dropdown") != null && dojo.byId(widgetNode.id + "_numEntitledContracts") != null && 
						    dojo.byId(widgetNode.id + "_numEntitledContracts").value > 0){
							var nodePosition = domGeometry.position(node);
							var windowHeight = window.innerHeight;
							if (windowHeight - nodePosition.y > nodePosition.y){
								var newHeight = windowHeight - nodePosition.y;
							}else{
								var newHeight = nodePosition.y;
							}
							var dropdownHeight = dojo.byId(node.id + "_dropdown").clientHeight;	
							if (dropdownHeight > newHeight){
								dojo.byId(node.id + "_dropdown").style.height = newHeight + "px"; 																		
							}							
						}
						if (node == widgetNode || node == toggleControl || domClass.contains(node, "dijitPopup")) {
							close = false;
							break;
						}
						node = node.parentNode;
					}
					if (node == null) {
						var children = query("div", widgetNode);
						for (var i = 0; i < children.length; i++) {
							var position = domGeometry.position(children[i]);
							if (evt.clientX >= position.x && evt.clientX < position.x + position.w &&
								evt.clientY >= position.y && evt.clientY < position.y + position.h) {								
								close = false;
								break;
							}
						}
						if (dojo.byId(widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2_dropdown") != null && 
							dojo.byId(widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2_dropdown").style.display != "none" &&
							dojo.byId(widgetNode.id + "_numEntitledContracts") != null && dojo.byId(widgetNode.id + "_numEntitledContracts").value > 0){
							var nodePosition = domGeometry.position(dojo.byId(widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2"));
							var windowHeight = window.innerHeight;
							if (windowHeight - nodePosition.y > nodePosition.y){
								var newHeight = windowHeight - nodePosition.y;
							}else{
								var newHeight = nodePosition.y;
							}
							var dropdownHeight = dojo.byId(widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2_dropdown").clientHeight;	
							if (dropdownHeight > newHeight){
								dojo.byId(widgetNode.id + "_WC_B2BMyAccountParticipantRole_select_2_dropdown").style.height = newHeight + "px"; 																		
							}							
						}
					}					
					if (close) {
						this.togglePanel(widgetNode);
					}
				}
			}
		}
	}
}