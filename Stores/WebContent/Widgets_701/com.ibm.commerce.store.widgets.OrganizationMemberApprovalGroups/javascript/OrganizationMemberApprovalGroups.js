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


dojo.require("wc.service.common");
dojo.require("wc.render.common");
dojo.require("wc.widget.Tooltip");


/**
 * Declares a new render context for the Organization Member Group widget
 */
wc.render.declareContext("orgMemberGroupContext",{'orgEntityId':null, 'progressBarId':null},"");

/** 
 * Declares a new refresh controller for the Organization Member Group widget
 */
wc.render.declareRefreshController({
       id: "orgMemberGroupController",
       renderContext: wc.render.getContextById("orgMemberGroupContext"),
       url: "",
	   baseURL:getAbsoluteURL()+'OrgMemberGroupDisplayView',
       formId: ""
       
       ,modelChangedHandler: function(message, widget) {
		   var controller = this;
		   if(message.actionId == 'AjaxApprovalGroupUpdate') {
				controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
				setCurrentId(controller.renderContext.properties["progressBarId"]);
				submitRequest();
				cursor_wait();
				widget.refresh(controller.renderContext.properties);
		   }
       }

	   ,renderContextChangedHandler: function(message, widget) {
			console.debug("orgMemberGroupController doesn't support Render context Changed events", widget);
       }       	   

       ,postRefreshHandler: function(widget) {
            console.debug("Post refresh handler of orgMemberGroupController",widget);
			cursor_clear();
			widgetCommonJS.removeSectionOverlay();
       }
});

organizationMemberApprovalGroupJS = {

	widgetShortName: "OrgMemberApprovalGroupWidget", // My Name
	
	/**
	*/
	updateMemberApprovalGroup:function(orgEntityId, approvalGroupCheckBoxName, checkBoxCSSClassName){

		var service = wc.service.getServiceById('AjaxApprovalGroupUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wc.service.declare({
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
					MessageHelper.displayStatusMessage(storeNLS["APPROVAL_MEMBER_GROUP_UPDATED"]);
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

		var checkBox = dojo.query('.'+checkBoxCSSClassName,approvalGroupCheckBoxName);
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
		params.authToken =  dojo.byId("authToken").value;
		params.URL = "URL";
		
		setCurrentId(approvalGroupCheckBoxName+"Icon");
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		var context = wc.render.getContextById("orgMemberGroupContext");
		context.properties["orgEntityId"] = orgEntityId;
		context.properties["progressBarId"] = approvalGroupCheckBoxName+"Icon"
		wc.service.invoke("AjaxApprovalGroupUpdate", params);
	}
};