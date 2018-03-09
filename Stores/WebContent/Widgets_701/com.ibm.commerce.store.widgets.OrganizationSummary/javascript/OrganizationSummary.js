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
 * Declares a new render context for the Organization Summary widget - To display basic summary of organziation
 */
wc.render.declareContext("orgSummaryDisplayContext",{'orgEntityId':null, 'orgSummaryType':null,'progressBarId':null, 'widgetrefreshtype':null},"");


/** 
 * Declares a new refresh controller for the Organization Summary widget
 */
wc.render.declareRefreshController({
       id: "orgSummaryController",
       renderContext: wc.render.getContextById("orgSummaryDisplayContext"),
       url: "",
	   baseURL:getAbsoluteURL()+'OrgSummaryDisplayView',
       formId: ""
       
       ,modelChangedHandler: function(message, widget) {
		   var controller = this;
		   if(message.actionId == 'AjaxOrgSummaryUpdate') {
				controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
				// 3 Refresh Area ( Summary, Address, ContactInfo ) are associated with this controller. So only refresh the relevant section based on refreshType parameter.
				console.debug("Widget", widget);
				console.debug(widget.widgetrefreshtype, "widget.widgetrefreshtype");
				//properties of widget should be always in lower case. widgetRefreshType doesn't work.
				if(controller.renderContext.properties['widgetrefreshtype'] == widget.widgetrefreshtype){
					setCurrentId(controller.renderContext.properties["progressBarId"]);
					submitRequest();
					cursor_wait();
					widget.refresh(controller.renderContext.properties);
				}

		   }
       }

	   ,renderContextChangedHandler: function(message, widget) {
		    var controller = this;
			controller.url = controller.baseURL +"?"+getCommonParametersQueryString();
		    var renderContext = this.renderContext;
			widget.setInnerHTML("");
	    	widget.refresh(renderContext.properties);
       }       	   

       ,postRefreshHandler: function(widget) {
             console.debug("Post refresh handler of orgSummaryController",widget);
			 cursor_clear();
			widgetCommonJS.removeSectionOverlay();
       }
});


organizationSummaryJS = {

	widgetShortName: "OrgSummaryWidget", // My Name
	mandatoryFields : "",
	OrganizationCreateEditViewName:"OrganizationCreateEditView",

	//infoJsonData :{'parameterNameUsedByCommand':'fieldNameInUI'}

	orgInfoJsonData : {"orgEntityName":"orgName"},
	orgValidationData : [ {"fieldName":"orgName", "type":"any", "maxLength":"128", "required":"true", "errorMessageKey":"ERROR_OrgName"}],

	contactInfoJsonData : {"email1":"email1", "phone1":"phone1", "fax1":"fax1"},
	contactValidationData : [
								{"fieldName":"email1", "type":"email", "maxLength":"256", "required":"true", "errorMessageKey":"ERROR_Email"},
								{"fieldName":"phone1", "type":"phone", "maxLength":"32", "required":"false", "errorMessageKey":"ERROR_Phone"},
								{"fieldName":"fax1", "type":"any", "maxLength":"32", "required":"false", "errorMessageKey":"ERROR_Fax"}
							],

	addressInfoJsonData : {"address1":"address1", "city":"city", "state":"state", "country":"country", "zipCode":"zipCode"},
	addressValidationData : [
									{"fieldName":"address1", "type":"any", "maxLength":"50", "required":"nls", "errorMessageKey":"ERROR_Address"},
									{"fieldName":"city", "type":"any", "maxLength":"128", "required":"nls", "errorMessageKey":"ERROR_City"},
									{"fieldName":"state", "type":"any", "maxLength":"128", "required":"nls", "errorMessageKey":"ERROR_State"},
									{"fieldName":"country", "type":"any", "maxLength":"128", "required":"nls", "errorMessageKey":"ERROR_Country"},
									{"fieldName":"zipCode", "type":"any", "maxLength":"40", "required":"nls", "errorMessageKey":"ERROR_ZipCode"}
								],

	summaryInfoJsonData:  {'description':'orgDescription','businessCategory':'orgBusinessCategory'},
	summaryValidationData: [
								{"fieldName":"orgDescription", "type":"any", "maxLength":"512", "required":"false", "errorMessageKey":"ERROR_OrganizationDescription"},
								{"fieldName":"orgBusinessCategory", "type":"any", "maxLength":"128", "required":"false", "errorMessageKey":"ERROR_BusinessCategory"}
							],

	/**
	* Subscribe to 'organizationChanged' topic and respond to it by updating the organization summary for the newOrgId
	*/
	subscribeToOrgChangeEvent:function(currentOrgEntityId){
		var topicName = "organizationChanged";

		var renderContext = wc.render.getContextById("orgSummaryDisplayContext");
		renderContext.properties["orgEntityId"] = currentOrgEntityId;

		require(["dojo/on","dojo/topic","dojo/dom-construct","dojo/dom","dojo/domReady!"], function(on,topic,domConstruct,dom){
			topic.subscribe("organizationChanged", function(data){
				var renderContext = wc.render.getContextById("orgSummaryDisplayContext");
				if(renderContext.properties["orgEntityId"] != data.newOrgId){
					setCurrentId("orgSummaryInfoProgressBar");
					if(!submitRequest()){
						return;
					}
					cursor_wait();
					wc.render.updateContext("orgSummaryDisplayContext", {'orgEntityId' : data.newOrgId, 'orgSummaryType':null, "progressBarId":null});	
				}
			});

		});
	},


	/**
	* Publishes 'currentOrgIdRequest' topic.
	* Organization List widget will respond to this event and publishes the "currentOrgId" topic along with the orgId.
	* Responds to "currentOrgId" topic event by refreshing the organization summary data for the newOrgId
	*/
	publishOrgIdRequest:function(){
		var topicName = "currentOrgIdRequest";
		var scope = this;
		require(["dojo/on","dojo/topic","dojo/dom-construct","dojo/dom","dojo/domReady!"], function(on,topic,domConstruct,dom){
			topic.subscribe("currentOrgId", function(data){
				if(data.requestor === scope.widgetShortName){
					// The original request was from me. So respond to this event.
       	   	 		wc.render.updateContext("orgSummaryDisplayContext", {'orgEntityId' : data.newOrgId, 'orgSummaryType':null, "progressBarId":null});	
				}
			});
			// Set the requestor to my widgetShortName. 
			// Respond to follow-up events, only if the event published was in response to my request. 
			// The requestor attribute in the data helps to check this.
			var data = {"requestor":scope.widgetShortName};
			topic.publish(topicName, data);
		});
	},

	redirectToCreateEditPage:function(orgEntityCreateEditViewName, actionType){
		if(actionType == 'E'){
			// Publish an event and get back the current organizaiton ID
			var topicName = "currentOrgIdRequest";
			var scope = this;
			require(["dojo/on","dojo/topic","dojo/dom-construct","dojo/dom","dojo/domReady!"], function(on,topic,domConstruct,dom){
				topic.subscribe("currentOrgId", function(data){
					if(data.requestor == "CreateEditAction"){
						// The original request was from me. So respond to this event.
						document.location.href = orgEntityCreateEditViewName+"&orgEntityId="+data.newOrgId;
					}
				});
				// Set the requestor == CreateEditAction. 
				// Respond to follow-up events, only if the event published was in response to my request. 
				// The requestor attribute in the data helps to check this.
				var data = {"requestor":"CreateEditAction"};
				topic.publish(topicName, data);
			});

		} else if(actionType == 'C'){
			// Publish an event and get back the current organizaiton ID
			var topicName = "currentOrgIdRequest";
			var scope = this;
			require(["dojo/on","dojo/topic","dojo/dom-construct","dojo/dom","dojo/domReady!"], function(on,topic,domConstruct,dom){
				topic.subscribe("currentOrgId", function(data){
					if(data.requestor == "CreateEditAction"){
						// The original request was from me. So respond to this event.
						var url = orgEntityCreateEditViewName;
						if(data != null && data.newOrgId != null){
							url = url + "&parentOrgEntityId="+data.newOrgId;
						}
						if(data != null && data.newOrgName != null){
							url = url + "&parentOrgEntityName="+data.newOrgName;
						}
						document.location.href = url;
					}
				});
				// Set the requestor == CreateEditAction. 
				// Respond to follow-up events, only if the event published was in response to my request. 
				// The requestor attribute in the data helps to check this.
				var data = {"requestor":"CreateEditAction"};
				topic.publish(topicName, data);
			});
		}

	},

	postOrgCreation:function(serviceResponse,progressBarId){
		console.debug("serviceResponse after org creation ", serviceResponse);
		console.debug(progressBarId);
		console.debug("Start updating roles for "+serviceResponse.orgEntityId);

		var checkBox = dojo.query('.arrow','orgRolesEdit');
		if(checkBox.length == 0){
			MessageHelper.displayStatusMessage(storeNLS["ORG_ROLES_UPDATE_NO_CHNAGE"]);
			this.postRolesCreation(serviceResponse);
			return false;
		}

		var params = [];
		params.memberId = serviceResponse.orgEntityId;
		params.authToken = dojo.byId("authToken").value;
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";
		params.action = "assignRole";

		for(var i = 0; i < checkBox.length; i++){
			var roleId = checkBox[i].getAttribute("data-orgRolesId");
			params["roleId"+i] = roleId;
		}
		
		setCurrentId(progressBarId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		var rolesService = organizationRolesJS.getOrgRolesUpdateService('AjaxOrgRolesUpdateDuringOrgCreate', this.postRolesCreation, serviceResponse);
		wc.service.invoke(rolesService.id, params);

	},

	postRolesCreation:function(serviceResponse, jsonObject){
		var orgEntityId = null;
		if(jsonObject != null && jsonObject != 'undefined' && jsonObject.orgEntityId != null){
			orgEntityId = jsonObject.orgEntityId;
		} else if(serviceResponse != null && serviceResponse != 'undefined' && serviceResponse.orgEntityId != null){
			orgEntityId = serviceResponse.orgEntityId;
		}
		document.location.href = organizationSummaryJS.OrganizationCreateEditViewName+"?"+getCommonParametersQueryString()+"&orgEntityId="+orgEntityId;
	},

	invokeOrgEntityCreateService:function(params,progressBarId){
		
		var service = wc.service.getServiceById('AjaxOrgEntityAdd');
		var scope = this;

		if(service == null || service == undefined){
			/**
			 */
			wc.service.declare({
				id: "AjaxOrgEntityAdd",
				actionId: "AjaxOrgEntityAdd",
				url: getAbsoluteURL() + "AjaxRESTOrganizationRegistration",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(storeNLS["ORG_ENTITY_CREATED_UPDATING_ROLES"]);
					scope.postOrgCreation(serviceResponse,progressBarId);
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
		
		setCurrentId(progressBarId);
		if(!submitRequest()){
			return;
		}
		cursor_wait();
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";
		wc.service.invoke("AjaxOrgEntityAdd", params);
	},

	invokeOrgEntityUpdateService:function(orgEntityId, params,jsonData,editSectionId){
		
		var service = wc.service.getServiceById('AjaxOrgSummaryUpdate');

		if(service == null || service == undefined){
			/**
			 */
			wc.service.declare({
				id: "AjaxOrgSummaryUpdate",
				actionId: "AjaxOrgSummaryUpdate",
				url: getAbsoluteURL() + "AjaxRESTOrganizationUpdate",
				formId: ""
				
				/**
				 * Clear messages on the page.
				 * @param (object) serviceResponse The service response object, which is the JSON object returned by the service invocation
				 */
				,successHandler: function(serviceResponse) {
					MessageHelper.hideAndClearMessage();
					MessageHelper.displayStatusMessage(storeNLS["ORG_SUMMARY_UPDATED"]);
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
		
		setCurrentId(editSectionId+'Icon');
		if(!submitRequest()){
			return;
		}
		cursor_wait();

		for(i in jsonData){
			var node = dojo.byId(jsonData[i]);
			if(node == null || node == 'undefined'){
				node = dojo.query("[name="+jsonData[i]+"]")[0];
			}
			console.debug(" node for", jsonData[i], node);
			params[i] = node.value;
		}

		params.orgEntityId = orgEntityId;
		params.storeId = WCParamJS.storeId;
		params.URL = "PassThisToAvoidException";

		wc.service.invoke("AjaxOrgSummaryUpdate", params);
	},

	updateOrgSummaryDisplayContext:function(orgEntityId, refreshType, progressBarId){
		var context = wc.render.getContextById("orgSummaryDisplayContext");
		context.properties["orgEntityId"] = orgEntityId;
		context.properties["orgSummaryType"] = 'edit';
		context.properties["progressBarId"] = progressBarId;

		// Reset all
		context.properties["orgSummaryBasicEdit"] = 'false';
		context.properties["orgSummaryAddressEdit"] = 'false';
		context.properties["orgSummaryContactInfoEdit"] = 'false';
		context.properties["widgetrefreshtype"] = refreshType;

		if(refreshType == 'basic'){
			context.properties["orgSummaryBasicEdit"] = 'true';
		} else 	if(refreshType == 'address'){
			context.properties["orgSummaryAddressEdit"] = 'true';
		} else 	if(refreshType == 'contactInfo'){
			context.properties["orgSummaryContactInfoEdit"] = 'true';
		}
	},

	updateOrganizationSummary:function(orgEntityId, editSectionId){
		if(!this.validateData(this.summaryValidationData)) {
			return;
		} else {
			// Close Edit Section and display readOnly section.
			widgetCommonJS.toggleReadEditSection(editSectionId, 'read')
		}
		var params = [];
		this.updateOrgSummaryDisplayContext(orgEntityId,"basic",editSectionId+"Icon");
		this.invokeOrgEntityUpdateService(orgEntityId,params,this.summaryInfoJsonData,editSectionId);
	},

	updateOrganizationAddress:function(orgEntityId, editSectionId){
		
		if(!this.validateData(this.addressValidationData)){
			return;
		} else {
			// Close Edit Section and display readOnly section.
			widgetCommonJS.toggleReadEditSection(editSectionId, 'read')
		}

		var params = [];
		this.updateOrgSummaryDisplayContext(orgEntityId,"address",editSectionId+"Icon");
		this.invokeOrgEntityUpdateService(orgEntityId,params,this.addressInfoJsonData,editSectionId);
	},

	updateOrganizationContactInfo:function(orgEntityId, editSectionId){
		if(!this.validateData(this.contactValidationData)) {
			return;
		} else {
			// Close Edit Section and display readOnly section.
			widgetCommonJS.toggleReadEditSection(editSectionId, 'read')
		}
		var params = [];
		this.updateOrgSummaryDisplayContext(orgEntityId,"contactInfo", editSectionId+"Icon");
		this.invokeOrgEntityUpdateService(orgEntityId,params,this.contactInfoJsonData,editSectionId);

	},

	updateParameterValues:function(params,jsonData){
		for(i in jsonData){
			var node = dijit.byId(jsonData[i]);
			if(node == null || node == 'undefined'){
				node = dojo.byId(jsonData[i]);
			} 
			if(node == null || node == 'undefined'){
				node = dojo.query("[name="+jsonData[i]+"]")[0];
			} 
			if(node != null){
				console.debug("for ", i, "value is ",node.value);
				params[i] = node.value;
			} else {
				console.debug("For ",  i, "value is null");
			}
		}
	},
	createOrgEntity:function(progressBarId){

		if(!this.validateData(this.orgValidationData)) return false;
		var parentMemberId = organizationListJS.getCurrentData()['newOrgId'];
		if(parentMemberId == null || parentMemberId == 'undefined' || parentMemberId.length == 0 ){
			if(dojo.byId("orgNameInputField") != 'undefined' && dojo.byId("orgNameInputField" != null)){
				MessageHelper.formErrorHandleClient("orgNameInputField", storeNLS["ERROR_ParentOrgNameEmpty"]);
				return false;
			}
		}
		//if(!this.validateData(this.summaryValidationData)) return false;
		if(!this.validateData(this.addressValidationData)) return false;
		if(!this.validateData(this.contactValidationData)) return false;

		var params = [];
		this.updateParameterValues(params,this.orgInfoJsonData);
		this.updateParameterValues(params,this.summaryInfoJsonData);
		this.updateParameterValues(params,this.addressInfoJsonData);
		this.updateParameterValues(params,this.contactInfoJsonData);

		params['parentMemberId'] = parentMemberId
		params['orgEntityType'] = 'O'; // Always create organization type. OrganizationalUnit type is not supported.
		params['addToRegisteredCustomersGroup'] = 'true'; // Make this new organization as part of RegisteredCustomers member group owned by the stores owning organization.
		this.invokeOrgEntityCreateService(params,progressBarId);
	},

	setMandatoryFields:function(fields){
		this.mandatoryFields = fields;
	},

	validateData:function(validationData){
		reWhiteSpace = new RegExp(/^\s+$/);
		for(var i = 0; i < validationData.length; i++){
			//console.debug("The validation data at ",i, "is ", validationData[i]);
			var data = validationData[i];
			var fieldName = data["fieldName"];
			var fieldType = data["fieldType"];
			var node = dojo.query("[name="+fieldName+"]")[0];
			if(fieldType == "dijit"){
				node = dijit.byId(fieldName);
			}
			var required = data["required"];
			var dataType = data["type"];
			var maxLength = data["maxLength"];
			var errorMessageKey = data["errorMessageKey"];


			if(node != null && node != 'undefined'){
				var value = node.value;
				console.debug("value == ",value, "for fieldName ",fieldName);
				console.debug("Requried == ",required);
				console.debug("set of mandatory fields == ",this.mandtoryFields);
				console.debug("Requried by NLS rule == ",this.mandatoryFields.indexOf(fieldName));
				// IsMandatory validation
				if(required == 'true' || (required == "nls" && this.mandatoryFields.indexOf(fieldName) != "-1")){
					if(value == "" || reWhiteSpace.test(value)){
						console.debug("empty .. show error message for ",node.id);
						MessageHelper.formErrorHandleClient(node.id, storeNLS[errorMessageKey+"Empty"]);
						return false;
					}
				} 

				// MaxLength validation
				if(maxLength != "-1"){
					console.debug("max length == ",maxLength);
					if(!MessageHelper.isValidUTF8length(value, data["maxLength"])){ 
						MessageHelper.formErrorHandleClient(node.id, storeNLS[errorMessageKey+"TooLong"]);
						return false;
					}
				}

				// Data Type validation
				if(dataType == "email"){
					if(!MessageHelper.isValidEmail(value)){
						MessageHelper.formErrorHandleClient(node.id, storeNLS["ERROR_INVALIDEMAILFORMAT"]);
						return false;
					}
				} else if(dataType == "phone"){
					if(!MessageHelper.IsValidPhone(value)){
						MessageHelper.formErrorHandleClient(node.id, storeNLS["ERROR_INVALIDPHONE"]);
						return false;
					}
				} else if(dataType == "numeric"){
					if(!MessageHelper.IsNumeric(value)){
						MessageHelper.formErrorHandleClient(node.id, storeNLS["ERROR_INVALID_NUMERIC"]);
						return false;
					}
				}
			}
		}
		return true;
	}
};