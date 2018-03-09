//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2013, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/**
 * Declares a new render context for the Organization Roles widget
 */
wcRenderContext.declare("orgRolesContext",["orgRolesRefreshArea"],{'orgEntityId':null, "progressBarId":null});

/** 
 * Declares a new refresh controller for the Organization Roles widget
 */
function declareOrgRolesController() {
	var myWidgetObj = $("#orgRolesRefreshArea");
	
	var baseURL = getAbsoluteURL() + 'OrgRolesDisplayViewV2';
	
	var myRCProperties = wcRenderContext.getRenderContextProperties("orgRolesContext");
	
	wcTopic.subscribe(["AjaxOrgRolesUpdate"], function() {
		myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
		setCurrentId(myRCProperties["progressBarId"]);
		submitRequest();
		cursor_wait();
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {
			myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
			if(myRCProperties["refreshWidget"] != "false"){
				myWidgetObj.html("");
				myWidgetObj.refreshWidget("refresh", myRCProperties);
			}
		},

		postRefreshHandler: function() {
			cursor_clear();
			widgetCommonJS.removeSectionOverlay();
		}
	});
};

organizationRolesJS = {

	widgetShortName: "OrgRolesWidget", // My Name
	initialSelectedRolesList: [],

	getOrgRolesUpdateService:function(actionId,postSuccessHandler,postRefreshHandlerParameters){
		
		var service = wcService.getServiceById('AjaxOrgRolesUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wcService.declare({
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
						MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORG_ROLES_UPDATED"));
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
			service = wcService.getServiceById('AjaxOrgRolesUpdate');
		}
		if(actionId != null && actionId != 'undefined'){
			service.setActionId(actionId);
		}
		if(postSuccessHandler != null && postSuccessHandler != 'undefined'){
			service.setParam("postSuccessHandler", postSuccessHandler);
		} else {
			service.setParam("postSuccessHandler", null);
		}
		if(postRefreshHandlerParameters != null && postRefreshHandlerParameters != 'undefined'){
			service.setParam("postRefreshHandlerParameters", postRefreshHandlerParameters);
		} else {
			service.setParam("postRefreshHandlerParameters", null);
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
		var checkBoxes = $("#" + approvalGroupCheckBoxName).find('.'+checkBoxCSSClassName);
		var unAssignRoles = false;
		var assignRoles = false;
		var unAssignRoleIds = [];
		var assignRoleIds = [];
		var context = wcRenderContext.getRenderContextProperties("orgRolesContext");
		var params = [];
		params.memberId = orgEntityId;
		params.authToken = $("#authToken").val();
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";
		
		checkBoxes.each($.proxy(function(i, entry){
			var roleId = entry.getAttribute("data-orgRolesId");
			if(this.initialSelectedRolesList.indexOf(roleId) == -1){
				// Initial list doesn't contain this roleId. It is selected now. Update at server side.
				assignRoleIds[assignRoleIds.length] = roleId;
			}	
		},scope));

		// Loop through initial selected roles list and see if it's still checked..
		$(scope.initialSelectedRolesList).each($.proxy(function(i, entry){
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
		},scope));


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
				context["refreshWidget"]  = "false"; // Do not refresh Roles widget immeditely. Wait for unAssign action to complete
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

			context["refreshWidget"]  = "true"; // Refresh widget
		}

		if(assignRoles || unAssignRoles){
			setCurrentId(approvalGroupCheckBoxName+"Icon");
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			context["orgEntityId"] = orgEntityId;
			context["progressBarId"] = approvalGroupCheckBoxName+"Icon";
			var service = this.getOrgRolesUpdateService('AjaxOrgRolesUpdate', postOrgRolesAssignHandler, postRefreshHandlerParameters);
			wcService.invoke(service.getParam("id"), params);
		} else {
			MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("ORG_ROLES_UPDATE_NO_CHNAGE"));
		}
	},

	preSelectAssignedRoles:function(selectedRoleIds){
		this.initialSelectedRolesList = [];
		var assignedRoles = $("#" + selectedRoleIds).val();
		var assignedRoleIds = assignedRoles.split(",");
		if(assignedRoleIds.length > 0){
			var checkBox = $('#orgRolesEdit').find('.arrowForDojoQuery');
			for(var i = 0; i < checkBox.length; i++){
				var roleId = checkBox[i].getAttribute("data-orgRolesId");
				
				for(var j = 0; j < assignedRoleIds.length; j++){
					if(assignedRoleIds[j] == roleId){
						$(checkBox[i]).addClass("arrow");
						$(checkBox[i]).attr("aria-checked","true");
						this.initialSelectedRolesList[this.initialSelectedRolesList.length] = roleId;
						break;
					} else {
						$(checkBox[i]).removeClass("arrow");
						$(checkBox[i]).attr("aria-checked","false");
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
		var renderContext = wcRenderContext.getRenderContextProperties("orgRolesContext");
		renderContext["orgEntityId"] = currentOrgEntityId;
		$(document).ready(function() {
			wcTopic.subscribe("organizationChanged", function(data){
				var renderContext = wcRenderContext.getRenderContextProperties("orgRolesContext");
				if(renderContext["orgEntityId"] != data.newOrgId){
					// Only update if currentOrgId has changed in the drop down box...
					setCurrentId("orgRolesUpdateProgressBar");
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wcRenderContext.updateRenderContext("orgRolesContext", {'orgEntityId' : data.newOrgId, 'roleDisplayType':'create', "progressBarId":'orgRolesUpdateProgressBar'});	
				}
			});
		});
	}
};