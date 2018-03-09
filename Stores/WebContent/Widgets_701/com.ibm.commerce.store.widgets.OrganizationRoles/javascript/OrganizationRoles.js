//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * Declares a new render context for the Organization Roles widget
 */
wc.render.declareContext("orgRolesContext",{'orgEntityId':null, "progressBarId":null},"");

/** 
 * Declares a new refresh controller for the Organization Roles widget
 */
wc.render.declareRefreshController({
       id: "orgRolesController",
       renderContext: wc.render.getContextById("orgRolesContext"),
       url: "",
	   baseURL:getAbsoluteURL()+'OrgRolesDisplayView',
       formId: ""
       
       ,modelChangedHandler: function(message, widget) {
		   var controller = this;
		   if(message.actionId == 'AjaxOrgRolesUpdate') {
				controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
				setCurrentId(controller.renderContext.properties["progressBarId"]);
				submitRequest();
				cursor_wait();
				widget.refresh(controller.renderContext.properties);
		   }
       }

	   ,renderContextChangedHandler: function(message, widget) {
		    var controller = this;
			controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
		    var renderContext = this.renderContext;
			if(renderContext.properties["refreshWidget"] != "false"){
				widget.setInnerHTML("");
		    	widget.refresh(renderContext.properties);
			}
       }       	   

       ,postRefreshHandler: function(widget) {
            console.debug("Post refresh handler of orgRolesController",widget);
			cursor_clear();
			widgetCommonJS.removeSectionOverlay();
       }
});

organizationRolesJS = {

	widgetShortName: "OrgRolesWidget", // My Name
	initialSelectedRolesList: [],

	getOrgRolesUpdateService:function(actionId,postSuccessHandler,postRefreshHandlerParameters){
		
		var service = wc.service.getServiceById('AjaxOrgRolesUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wc.service.declare({
				id: "AjaxOrgRolesUpdate",
				actionId: "AjaxOrgRolesUpdate",
				url: getAbsoluteURL() + "AjaxRESTOrganizationRoleAssign",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					if(this.postRefreshHandlerParameters == null || (this.postRefreshHandlerParameters != null && this.postRefreshHandlerParameters.showSuccessMessage != 'false')){
						MessageHelper.displayStatusMessage(storeNLS["ORG_ROLES_UPDATED"]);
					}
					if(this.postSuccessHandler != null){
						cursor_clear();
						this.postSuccessHandler(serviceResponse,this.postRefreshHandlerParameters);
					}
				}
				
				/**
				 * Displays an error message on the page if the request failed.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation.
				 */
				,failureHandler: function(serviceResponse) {
					if (serviceResponse.errorMessage) {
						MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
					} else {
						if (serviceResponse.errorMessageKey) {
							MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
						}
					}
					cursor_clear();
				}
			});
			service = wc.service.getServiceById('AjaxOrgRolesUpdate');
		}
		if(actionId != null && actionId != 'undefined'){
			service.actionId = actionId;
		}
		if(postSuccessHandler != null && postSuccessHandler != 'undefined'){
			service.postSuccessHandler = postSuccessHandler;
		} else {
			service.postSuccessHandler = null;
		}
		if(postRefreshHandlerParameters != null && postRefreshHandlerParameters != 'undefined'){
			service.postRefreshHandlerParameters = postRefreshHandlerParameters;
		} else {
			service.postRefreshHandlerParameters = null;
		}
		return service;
	},

	unassignRolesForOrg:function(serviceResponse,jsonObject){
		organizationRolesJS.updateOrganizationRoles(jsonObject.orgEntityId, jsonObject.approvalGroupCheckBoxName,jsonObject.checkBoxCSSClassName,jsonObject.action);
	},

	/**
	*/
	updateOrganizationRoles:function(orgEntityId, approvalGroupCheckBoxName, checkBoxCSSClassName,action){
		var scope = this;
		// Array of checked checkBoxes.
		var checkBoxes = dojo.query('.'+checkBoxCSSClassName,approvalGroupCheckBoxName);
		var unAssignRoles = false;
		var assignRoles = false;
		var unAssignRoleIds = [];
		var assignRoleIds = [];
		var context = wc.render.getContextById("orgRolesContext");
		var params = [];
		params.memberId = orgEntityId;
		params.authToken = dojo.byId("authToken").value;
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";
		
		require(["dojo/_base/array"], function(arrayUtil){
			  arrayUtil.forEach(checkBoxes, function(entry, i){
					var roleId = entry.getAttribute("data-orgRolesId");
					if(arrayUtil.indexOf(this.initialSelectedRolesList,roleId) == -1){
						// Initial list doesn't contain this roleId. It is selected now. Update at server side.
						assignRoleIds[assignRoleIds.length] = roleId;
					}	
			  },scope);
			});

			// Loop through initial selected roles list and see if it's still checked..
			require(["dojo/_base/array"], function(arrayUtil){
			  arrayUtil.forEach(scope.initialSelectedRolesList, function(entry, i){
					var stillChecked = false;
					for(var i = 0; i < checkBoxes.length; i++){
						var selectedRoleId = checkBoxes[i].getAttribute("data-orgRolesId");
						if(selectedRoleId == entry){
							stillChecked = true;
							break;
						}
					}
					if(!stillChecked){
						unAssignRoleIds[unAssignRoleIds.length] = entry;
					}
			  },scope);
			});


		if(assignRoleIds.length > 0){
			assignRoles = true; // Need to assign some additional roles.
		}

		if(unAssignRoleIds.length > 0){
			unAssignRoles = true; // Need to un-assign some roles.
		}

		// After the service invoke, in the SuccessHandler call this postOrgRolesAssignHandler function with postRefreshHandlerParameters
		var postOrgRolesAssignHandler = null;
		var postRefreshHandlerParameters = null;


		if((action == 'undefined' || action == null || action == "assignRole") && assignRoles){
			// Start with assignRoles. Chain this service call with unAssignRoles call, if needed
			params.action = "assignRole";
			console.debug("assignRoleIds", assignRoleIds);
			for(var i = 0; i < assignRoleIds.length; i++){
				params["roleId"+i] = assignRoleIds[i];
			}

			if(unAssignRoles){
				postOrgRolesAssignHandler = scope.unassignRolesForOrg;
				context.properties["refreshWidget"]  = "false"; // Do not refresh Roles widget immeditely. Wait for unAssign action to complete
				postRefreshHandlerParameters = {"orgEntityId":orgEntityId,"approvalGroupCheckBoxName":approvalGroupCheckBoxName,"checkBoxCSSClassName":checkBoxCSSClassName,"action":"unassignRole"};
				postRefreshHandlerParameters.showSuccessMessage = "false"; // Do not show success message till unAssign action is also done.
			}
		} else {
			action = "unassignRole"; //Nothing to assign.. Move the chain to unassignRole;
		}
		
		if(action == "unassignRole" && unAssignRoles){
			params.action ="unassignRole";
			console.debug("unAssignRoleIds", unAssignRoleIds);
			for(var i = 0; i < unAssignRoleIds.length; i++){
				params["roleId"+i] = unAssignRoleIds[i];
			}

			context.properties["refreshWidget"]  = "true"; // Refresh widget
		}

		if(assignRoles || unAssignRoles){
			setCurrentId(approvalGroupCheckBoxName+"Icon");
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			context.properties["orgEntityId"] = orgEntityId;
			context.properties["progressBarId"] = approvalGroupCheckBoxName+"Icon";
			var service = this.getOrgRolesUpdateService('AjaxOrgRolesUpdate', postOrgRolesAssignHandler, postRefreshHandlerParameters);
			wc.service.invoke(service.id, params);
		} else {
			MessageHelper.displayStatusMessage(storeNLS["ORG_ROLES_UPDATE_NO_CHNAGE"]);
		}
	},

	preSelectAssignedRoles:function(selectedRoleIds){
		this.initialSelectedRolesList = [];
		var assignedRoles = dojo.byId(selectedRoleIds).value;
		var assignedRoleIds = assignedRoles.split(",");
		if(assignedRoleIds.length > 0){
			var checkBox = dojo.query('.arrowForDojoQuery','orgRolesEdit');
			for(var i = 0; i < checkBox.length; i++){
				var roleId = checkBox[i].getAttribute("data-orgRolesId");
				for(var j = 0; j < assignedRoleIds.length; j++){
					if(assignedRoleIds[j] == roleId){
						dojo.addClass(checkBox[i],"arrow");
						checkBox[i].setAttribute("aria-checked","true");
						this.initialSelectedRolesList[this.initialSelectedRolesList.length] = roleId;
						break;
					}
				}
			}
		}
		console.debug("List of roleIds == "+this.initialSelectedRolesList);
	},

	/**
	* Subscribe to 'organizationChanged' topic and respond to it by updating the roles available for the selected newOrgId
	*/
	subscribeToOrgChangeEvent:function(currentOrgEntityId){
		var topicName = "organizationChanged";
		var renderContext = wc.render.getContextById("orgRolesContext");
		renderContext.properties["orgEntityId"] = currentOrgEntityId;
		require(["dojo/on","dojo/topic","dojo/dom-construct","dojo/dom","dojo/domReady!"], function(on,topic,domConstruct,dom){
			topic.subscribe("organizationChanged", function(data){
				var renderContext = wc.render.getContextById("orgRolesContext");
				if(renderContext.properties["orgEntityId"] != data.newOrgId){
					// Only update if currentOrgId has changed in the drop down box...
					setCurrentId("orgRolesUpdateProgressBar");
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wc.render.updateContext("orgRolesContext", {'orgEntityId' : data.newOrgId, 'roleDisplayType':'create', "progressBarId":'orgRolesUpdateProgressBar'});	
				}
			});
		});
	}
};