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
 * Declares a new render context for the Organization Member Group widget
 */
wcRenderContext.declare("orgMemberGroupContext",["orgMemberGroupRefreshArea"],{'orgEntityId':null, 'progressBarId':null});

/** 
 * Declares a new refresh controller for the Organization Member Group widget
 */
function declareOrgMemberGroupController() {
	var myWidgetObj = $("#orgMemberGroupRefreshArea");

	var myRCProperties = wcRenderContext.getRenderContextProperties("orgMemberGroupContext");

	var baseURL = getAbsoluteURL() + 'OrgMemberGroupDisplayViewV2';
	
	wcTopic.subscribe(["AjaxApprovalGroupUpdate"], function() {
		myWidgetObj.refreshWidget("updateUrl", baseURL + "?" + getCommonParametersQueryString());
		setCurrentId(myRCProperties["progressBarId"]);
		submitRequest();
		cursor_wait();
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	myWidgetObj.refreshWidget({
		renderContextChangedHandler: function() {},
		
		postRefreshHandler: function() {
			cursor_clear();
			widgetCommonJS.removeSectionOverlay();
       }
	});
};

organizationMemberApprovalGroupJS = {

	widgetShortName: "OrgMemberApprovalGroupWidget", // My Name
	
	/**
	*/
	updateMemberApprovalGroup:function(orgEntityId, approvalGroupCheckBoxName, checkBoxCSSClassName){

		var service = wcService.getServiceById('AjaxApprovalGroupUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wcService.declare({
				id: "AjaxApprovalGroupUpdate",
				actionId: "AjaxApprovalGroupUpdate",
				url: getAbsoluteURL() + "AjaxRESTApprovalGroupUpdate",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(Utils.getLocalizationMessage("APPROVAL_MEMBER_GROUP_UPDATED"));
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
		}

		var checkBox = $('#' + approvalGroupCheckBoxName).find('.'+checkBoxCSSClassName);
		var segmentId = "";
		for(var i = 0; i < checkBox.length; i++){
			if(segmentId == ""){
				segmentId = checkBox[i].getAttribute("data-memberGroupId");
			} else {
				segmentId = segmentId +","+checkBox[i].getAttribute("data-memberGroupId");
			}
		}

		var params = [];
		params.orgEntityId = orgEntityId;
		params.segmentId = segmentId;
		params.storeId = WCParamJS.storeId;
		params.authToken =  $("#authToken").val();
		params.URL = "URL";
		
		setCurrentId(approvalGroupCheckBoxName+"Icon");
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		var context = wcRenderContext.getRenderContextProperties("orgMemberGroupContext");
		context["orgEntityId"] = orgEntityId;
		context["progressBarId"] = approvalGroupCheckBoxName+"Icon"
		wcService.invoke("AjaxApprovalGroupUpdate", params);
	},
	
	preSelectAssignedMemberGroup:function(selectedGroupIds){
		var assignedGroups = $("#" + selectedGroupIds).val();
		var assignedGroupIds = assignedGroups.split(",");
		if(assignedGroupIds.length > 0){
			var checkBox = $('#memberGroupEdit').find('.arrowForDojoQuery');
			for(var i = 0; i < checkBox.length; i++){
				var roleId = checkBox[i].getAttribute("data-memberGroupId");
				
				for(var j = 0; j < assignedGroupIds.length; j++){
					if(assignedGroupIds[j] == roleId){
						$(checkBox[i]).addClass("arrow");
						$(checkBox[i]).attr("aria-checked","true");
						break;
					} else {
						$(checkBox[i]).removeClass("arrow");
						$(checkBox[i]).attr("aria-checked","false");
					}
				}
			}
		}
	}
};