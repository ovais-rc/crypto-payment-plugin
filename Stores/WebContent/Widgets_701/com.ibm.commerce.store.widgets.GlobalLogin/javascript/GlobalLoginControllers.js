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
 * Declares a new render context.
 */
wc.render.declareContext("GlobalLogin_context",{"displayContract":"false"},"");

/**
 * Declares a new refresh controller.
 */
wc.render.declareRefreshController({
       id: "GlobalLogin_SignIn_controller",
       renderContext: wc.render.getContextById("GlobalLogin_context"),
       url: "",
       formId: ""

   	/** 
   	 * Refreshes the Global Login panel.
   	 * This function is called when a render context event is detected. 
   	 * 
   	 * @param {string} message The render context changed event message
   	 * @param {object} widget The registered refresh area
   	 */    	   
        ,renderContextChangedHandler: function(message, widget) {
        	var controller = this;
        	var renderContext = this.renderContext;						
        	if(renderContext.properties['widgetId'] == widget.id){
                        widget.refresh(renderContext.properties);
                }		
        }

	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {
           cursor_clear();	
           var domAttr = require("dojo/dom-attr");
           domAttr.set(widget.id, "panel-loaded", true);
           var currentURL = document.location.href;
	   var idPrefix = widget.id + "_";			
           //Quick links
           if (window.matchMedia && window.matchMedia("(max-width: 390px)").matches) {						
        	document.getElementById("quickLinksButton").className = document.getElementById("quickLinksButton").className + " selected";
        		document.getElementById("quickLinksMenu").className = document.getElementById("quickLinksMenu").className + " active";	
        	}
            //toggle the panel
            GlobalLoginJS.displayPanel(dojo.byId(widget.id));      
	     dojo.byId(widget.id + "_signInDropdown").focus();	     
        }				       
});

/**
 * Declares a new refresh controller.
 */
wc.render.declareRefreshController({
       id: "GlobalLogin_controller",
       renderContext: wc.render.getContextById("GlobalLogin_context"),
       url: "",
       formId: ""

   	/** 
   	 * Refreshes the Global Login panel.
   	 * This function is called when a render context event is detected. 
   	 * 
   	 * @param {string} message The render context changed event message
   	 * @param {object} widget The registered refresh area
   	 */    	   
        ,renderContextChangedHandler: function(message, widget) {
        	var controller = this;
        	var renderContext = this.renderContext;						
                if(renderContext.properties['widgetId'] == widget.id){
                        widget.refresh(renderContext.properties);
                }	
        }

	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {
		cursor_clear();	
		var domAttr = require("dojo/dom-attr");
                domAttr.set(widget.id, "panel-loaded", true);
        
                var idPrefix = widget.id + "_";

		//initialize the caller Id for filtering it from the search results
		if(dojo.exists("GlobalLoginShopOnBehalfJS")){
			var hiddenField = dojo.byId(idPrefix + "callerId");
			if(hiddenField != null){
				GlobalLoginShopOnBehalfJS.setCallerId(hiddenField.value);
			}
		}

                var userDisplayNameField = dojo.byId(idPrefix + "userDisplayNameField");
                //get the user name from the display name field.		
                if (userDisplayNameField != null){
                        //clear the old cookie and write it afresh.
                        var logonUserCookie = getCookie("WC_LogonUserId_"+WCParamJS.storeId);
                        if (logonUserCookie != null){
                        	setCookie("WC_LogonUserId_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});
                        }
                        setCookie("WC_LogonUserId_"+WCParamJS.storeId, userDisplayNameField.value , {path:'/', domain:cookieDomain});
        
                        var updateLogonUserCookie = getCookie("WC_LogonUserId_"+WCParamJS.storeId);		
                        if (updateLogonUserCookie != undefined || updateLogonUserCookie != ""){
                        	logonUserName = updateLogonUserCookie.toString();				 
                        	var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                        	if (widgetIds != null && widgetIds.length > 0){
                        		for (var i = 0; i < widgetIds.length; i++){
                        			var registeredWidgetId = widgetIds[i];
                        			idPrefix = registeredWidgetId + "_";
                        			var signOutLink = dojo.byId(idPrefix + "signOutQuickLink");
                        			if (signOutLink != null){							
                        				dojo.byId(idPrefix + "signOutQuickLinkUser").innerHTML =  escapeXml(logonUserName, true);
                        			
                        				if (dojo.exists("GlobalLoginShopOnBehalfJS")){
                        					GlobalLoginShopOnBehalfJS.updateSignOutLink(registeredWidgetId);
                        					GlobalLoginShopOnBehalfJS.initializePanels();
                        				}	
                        			}
                        		}
                        	}
                        }else{
                        	var widgetIds = GlobalLoginJS.widgetsLoadedOnPage;
                        	if (widgetIds != null && widgetIds.length > 0){
                        		for (var i = 0; i < widgetIds.length; i++){
                        			var registeredWidgetId = widgetIds[i];
                        			idPrefix = registeredWidgetId + "_";
                        			var signOutLink = dojo.byId(idPrefix + "signOutQuickLink");
                        			if (signOutLink != null){							
                        				dojo.byId(idPrefix + "signOutQuickLinkUser").innerHTML =  escapeXml(userDisplayNameField.value, true);
                        					
                        				if (dojo.exists("GlobalLoginShopOnBehalfJS")){
                        				   GlobalLoginShopOnBehalfJS.updateSignOutLink(registeredWidgetId);
                        				   GlobalLoginShopOnBehalfJS.initializePanels();
                        				}
                    				}
                        		}
                        	}	
                        }
                }
        
                var activeContractIdsArrayLength = dojo.byId(idPrefix + "activeContractIdsArrayLength"); 
				var displayContractPanel = getCookie("WC_DisplayContractPanel_"+WCParamJS.storeId);			
                if (activeContractIdsArrayLength != null && activeContractIdsArrayLength.value > 1 && (displayContractPanel == undefined || displayContractPanel == null)){				
                	setCookie("WC_DisplayContractPanel_"+WCParamJS.storeId, "true" , {path:'/', domain:cookieDomain});											
	                window.location = dojo.byId(idPrefix + "setFirstContractInSessionURLField").value;
					return;
                }
				                
                if(displayContractPanel != undefined && displayContractPanel != null && displayContractPanel.toString() == "true"){
                	setCookie("WC_DisplayContractPanel_"+WCParamJS.storeId, null, {expires:-1,path:'/', domain:cookieDomain});	
                }
				GlobalLoginJS.processNextURL();
        
                //Display the sign out drop down panel on quick link when view is below 390px. 
                if (window.matchMedia("(max-width: 390px)").matches) {										
                        document.getElementById("quickLinksButton").className  = document.getElementById("quickLinksButton").className + " selected";
                        document.getElementById("quickLinksMenu").className  = document.getElementById("quickLinksMenu").className + " active";
                }
                GlobalLoginJS.displayPanel(widget.id);					
		  dojo.byId(widget.id + "_loggedInDropdown").focus();				
	},
    
        /**
         *This method updates the sign out link when there is a change in the User set in session.
         */         
        modelChangedHandler : function(message, widget){
            if(message.actionId == 'RunAsUserSetInSession' ){
                if(dojo.exists("GlobalLoginShopOnBehalfJS")){
                    GlobalLoginShopOnBehalfJS.updateSignOutLink(widget.id);
                    GlobalLoginShopOnBehalfJS.initializePanels();
                } 
            }
        }
});
