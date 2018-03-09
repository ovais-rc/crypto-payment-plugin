//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage user roles within.
 * This file is included in all pages with organization users role assignment actions.
 */

dojo.require("wc.service.common");
dojo.require("wc.render.common");
dojo.require("wc.widget.Tooltip");

/**
 * This service allow administrator to assign roles of member
 * @constructor
 */
wc.service.declare({
	id:"UserRoleManagementAssign",
	actionId:"UserRoleManagementAssign",
	url:"AjaxRESTMemberRoleAssign",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		if (UserRoleManagementJS.paramsToUnAssign !== undefined && UserRoleManagementJS.paramsToUnAssign !== null){
			wc.service.invoke('UserRoleManagementUnassign',UserRoleManagementJS.paramsToUnAssign);
		}
		else {
			MessageHelper.hideAndClearMessage();
			UserRoleManagementJS.updateAssignedRolesMap();
			UserRoleManagementJS.updateReadOnlySummary();
			widgetCommonJS.toggleEditSection(document.getElementById('WC_UserRoleManagement_pageSection'));
			cursor_clear();
			MessageHelper.displayStatusMessage(MessageHelper.messages["USERROLEMANAGEMENT_UPDATE_SUCCESS"]);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(serviceResponse.errorMessage);
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
});

/**
 * This service allow administrator to un assign roles of member
 * @constructor
 */
wc.service.declare({
	id:"UserRoleManagementUnassign",
	actionId:"UserRoleManagementUnassign",
	url:"AjaxRESTMemberRoleUnassign",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		if (UserRoleManagementJS.removingAdminRole){
			cursor_clear();
			MessageHelper.displayStatusMessage(MessageHelper.messages["USERROLEMANAGEMENT_UPDATE_SUCCESS"]);
			document.location.href = UserRoleManagementJS.myAccountURL;
		}
		else {
			UserRoleManagementJS.updateAssignedRolesMap();
			UserRoleManagementJS.updateReadOnlySummary();
			widgetCommonJS.toggleEditSection(document.getElementById('WC_UserRoleManagement_pageSection'));
			cursor_clear();
			UserRoleManagementJS.paramsToUnAssign = null;
			MessageHelper.displayStatusMessage(MessageHelper.messages["USERROLEMANAGEMENT_UPDATE_SUCCESS"]);
		}
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_UNASSIGN_FAIL"] + serviceResponse.errorMessage);
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				 MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_UNASSIGN_FAIL"] + serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
});

/**
 * This service allow administrator to update roles of member
 * @constructor
 */
wc.service.declare({
	id:"ChainedUserRoleManagementAssign",
	actionId:"ChainedUserRoleManagementAssign",
	url:"AjaxRESTMemberRoleAssign",
	formId:""

	 /**
     * Hides all the messages and the progress bar.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,successHandler: function(serviceResponse) {
		MessageHelper.hideAndClearMessage();
		
		document.location.href = OrganizationUserInfoJS.getChainedServiceRediretUrl();
		cursor_clear();		
		MessageHelper.displayStatusMessage(MessageHelper.messages["ORGANIZATIONUSER_CREATE_SUCCESS"]);
	}
		
	/**
     * display an error message.
     * @param (object) serviceResponse The service response object, which is the
     * JSON object returned by the service invocation.
     */
	,failureHandler: function(serviceResponse) {

		if (serviceResponse.errorMessage) {
			MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_CHAINCREATE_FAIL"] + serviceResponse.errorMessage);
		} 
		else {
			 if (serviceResponse.errorMessageKey) {
				MessageHelper.displayErrorMessage(MessageHelper.messages["USERROLEMANAGEMENT_CHAINCREATE_FAIL"] + serviceResponse.errorMessageKey);
			 }
		}
		cursor_clear();
	}			
});

require([				
  		"dojo/on",
  		"dojo/query",
  		"dojo/topic",
  		"dojo/_base/lang",
  		"dojo/dom-construct",
  		"dojo/dom",
  		"dojo/dom-class",
  		"dojo/_base/event",
  		"dojo/json",
		"dojo/window",
		"dojo/keys",
		"dojo/_base/array",
  		"dojo/NodeList-traverse"
  	], function(on, query, topic, lang, domConstruct, dom, domClass, event, JSON, dojoWindow, keys, array) {
  	
	/**
	 * This class defines the functions and variables that customers can use to create, update, and view their buyers list.
	 * @class The OrganizationUsersListJS class defines the functions and variables that customers can use to manage their buyers list, 
	 */
	UserRoleManagementJS = {		
		
		/**
		 * the widget name
		 * @private
		 */
		widgetShortName: "UserRoleManagement",
		
		/**
		 * the name of Buyer Administrator Role
		 * @private
		 */
		buyerAdmin: "Buyer Administrator",
		
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
		 * This variable stores the ID of member.
		 * @private
		 */
		memberId: "",
		
		/** 
		 * This variable stores the ID of the buyer admin.
		 * @private
		 */
		adminId: "",
		
		/**
		 * The id of selected Org.
		 * @private
		 */
		selectedOrg: "",
		
		/**
		 * The map contains Organization IDs and corresponding name, 
		 * at least one of the roles in the Organization is assigned to member.
		 * The key is Organization ID, value is name of a Organization.
		 */
		assignedOrgNameMap: new Object(),
		
		/**
		 * The map contains role IDs and corresponding name for roles that are
		 * currently assigned to the member.
		 * The key is Role ID, value is an array contains name of a Role and 
		 * frequence of the name appears in assigned roles. [name, freqence]
		 */
		assignedRoleNameMap: new Object(),
		
		/**
		 * The map contains Organization IDs and corresponding name, 
		 * at least one of the roles in the Organization is selected for the member.
		 * The map is initialized to assignedOrgNameMap
		 * on page load, and is updated correspondingly upon selection change
		 * The key is Organization ID, value is name of a Organization.
		 */
		selectedOrgNameMap: new Object(),
		
		/**
		 * The map contains Organization IDs and corresponding name, 
		 * for the Organizaiton currently displayed in the table.
		 * The map is initialized to assignedOrgNameMap
		 * on page load, and is updated correspondingly upon selection change
		 * The key is Organization ID, value is name of a Organization.
		 */
		currentOrgNameMap: new Object(),
		
		/**
		 * The map contains role IDs and corresponding name for roles that are
		 * currently selected for the member. The map is initialized to assignedRoleNameMap
		 * on page load, and is updated correspondingly upon selection change
		 * The key is Role ID, value is an array contains name of a Role and 
		 * frequence of the name appears in select roles. [name, freqence]
		 * the name will be removed from map is frequence equals 0
		 */
		selectedRoleNameMap: new Object(),
		
		/**
		 * The map contains role IDs and corresponding name for roles that are
		 * currently show in role selector column for a selected Organization
		 * The key is Role ID, value is name of a Role.
		 */
		selectedOrgRoleNameMap: new Object(),
		
		/**
		 * The map stores the all but hidden roles that the user has, roles in this map can be unassigned by current Admin. 
		 * The key of the map is Organization ID, the value is an array of role IDs
		 */
		assignedRolesMap: new Object(),
		
		/**
		 * The map stores the all roles that are selected by Admin for the user. 
		 * The key of the map is Organization ID, the value is an array of role IDs
		 */
		selectedRolesMap: new Object(),
		
		/**
		 * The display pattern of Org and Role for Selection summary column 
		 * The pattern is loaded from corresponding resource bundle define in widgetText
		 */
		orgDisplayPattern: "",
		
		/**
		 * The display pattern of Role for Selection summary column 
		 * The pattern is loaded from corresponding resource bundle define in widgetText
		 */
		roleDisplayPattern: "",
		
		/**
		 * The Checkbox column children html template
		 * The template is defined in UI jspf file
		 */
		roleCheckboxTemplate: "",
		
		/**
		 * The selection summary column children html template
		 * The template is defined in UI jspf file
		 */
		selectionSummaryTemplate: "",
		
		/**
		 * The read only summary view html template
		 * The template is defined in UI jspf file
		 */
		summaryViewTemplate: "",
		
		/**
		 * The prepared params for unAssign service command
		 */
		paramsToUnAssign: null,
		
		/**
		 * Indicates if we are removing admin role for the buyer him/herself, default value is false
		 */
		removingAdminRole: false,
		
		/**
		 * The URL to my account page.
		 */
		myAccountURL: "",
		
		/**
		 * Sets the common parameters for the current page. 
		 * For example, the language ID, store ID, and catalog ID.
		 *
		 * @param {Integer} langId The ID of the language that the store currently uses.
		 * @param {Integer} storeId The ID of the current store.
		 * @param {Integer} catalogId The ID of the catalog.
		 * @param {Integer} memberId The ID of the member.
		 * @param {Integer} authToken The authToken for current user to perform operation on server.
		 * @param (String) myAccountURL The url for MyAcount page
		 */
		setCommonParameters: function(langId,storeId,catalogId, memberId, adminId, authToken, myAccountURL){
			this.langId = langId;
			this.storeId = storeId;
			this.catalogId = catalogId;
			this.memberId = memberId;
			this.adminId = adminId;
			this.authToken = authToken;
			this.myAccountURL = myAccountURL;
			cursor_clear();
		},
		
		/**
		 * Initialize the URL of Role Assignment widget controller. 	 
		 *
		 * @param {object} roleSelectorUrl The roleSelector checkbox region controller's URL.
		 * @param {object} orgListUrl The  controller's URL for roleSelector region, which refreshes after org list change.
		 */
		initUserRoleManagementControllerUrl:function(roleSelectorUrl, orgListUrl){
			wc.render.getRefreshControllerById('UserRoleManagement_RoleSelector_controller').url = roleSelectorUrl;
			wc.render.getRefreshControllerById('UserRoleManagement_OrgList_controller').url = orgListUrl;
		},
		
		/**
		 * Handle press cancel button
		 */
		subscribeToToggleCancel: function(){
			var topicName = "sectionToggleCancelPressed";
	 		var scope = this;
	 		topic.subscribe(topicName, lang.hitch(this, function(data){
	 			if (data.target === 'WC_UserRoleManagement_pageSection'){
	 				this.selectedRolesMap = JSON.parse(JSON.stringify(this.assignedRolesMap));
					this.selectedRoleNameMap = JSON.parse(JSON.stringify(this.assignedRoleNameMap));
					this.selectedOrgNameMap = JSON.parse(JSON.stringify(this.assignedOrgNameMap));
	 				this.updateSelectionSummary();
	 				this.removingAdminRole = false;
	 				if (this.selectedOrg != ""){
	 					this.updateSelectorCheckbox(this.selectedOrg);
	 				}
	 			}
	 		}));
		},
		
		/**
		 * Upon success service response, copy the selectedRolesMap to assignedRolesMap
		 */
		updateAssignedRolesMap: function(){
			this.assignedRolesMap = JSON.parse(JSON.stringify(this.selectedRolesMap));
			this.assignedRoleNameMap = JSON.parse(JSON.stringify(this.selectedRoleNameMap));
			this.assignedOrgNameMap = JSON.parse(JSON.stringify(this.selectedOrgNameMap));
		},
		
		/**
		 * orgDisplayPattern, roleDisplayPattern
		 */
		loadDisplayPattern: function(orgPattern, rolePattern){
			this.roleDisplayPattern = rolePattern;
			this.orgDisplayPattern = orgPattern;
		},
		
		/**
		 * Read only Summary view tempalte
		 */
		loadSummaryViewTemplate: function(orgPattern, rolePattern){
			this.summaryViewTemplate = dom.byId("WC_UserRoleManagement_read_template").innerHTML.replace(/^\s+|\s+$/g, '');
		},
		
		/**
		 * Update currentOrgNameMap after Org list refresh
		 */
		updateCurrentOrgNameMap: function(){
			var incurrentOrgNameMap = JSON.parse(dom.byId("currentOrgNameMap").innerHTML);
			if (incurrentOrgNameMap !== undefined && incurrentOrgNameMap !== null){
				this.currentOrgNameMap = JSON.parse(JSON.stringify(incurrentOrgNameMap));
			}
		},
		
		/**
		 * assignedOrgNameMap, assignedRoleNameMap,selectedOrgNameMap, 
		 * selectedRoleNameMap, 
		 * currentOrgNameMap, 
		 * userHiddenRolesMap, assignedRolesMap, selectedRolesMap
		 * summaryViewTemplate, selectionSummary column template
		 */
		initializeDataForView: function(){
			var inassignedOrgNameMap = JSON.parse(dom.byId("assignedOrgNameMap").innerHTML);
			var inassignedRoleNameMap = JSON.parse(dom.byId("assignedRoleNameMap").innerHTML);
			var incurrentOrgNameMap = JSON.parse(dom.byId("currentOrgNameMap").innerHTML);
			if (inassignedOrgNameMap !== undefined && inassignedOrgNameMap !== null){
				this.assignedOrgNameMap = JSON.parse(JSON.stringify(inassignedOrgNameMap));
				this.selectedOrgNameMap = JSON.parse(JSON.stringify(inassignedOrgNameMap));
			}
			if (inassignedRoleNameMap !== undefined && inassignedRoleNameMap !== null){
				this.assignedRoleNameMap = JSON.parse(JSON.stringify(inassignedRoleNameMap));
				this.selectedRoleNameMap = JSON.parse(JSON.stringify(inassignedRoleNameMap));
			}
			if (incurrentOrgNameMap !== undefined && incurrentOrgNameMap !== null){
				this.currentOrgNameMap = JSON.parse(JSON.stringify(incurrentOrgNameMap));
			}
			var inSelectedOrgRoleNameMap = JSON.parse(dom.byId("selectedOrgRoleNameMap").innerHTML);
			if (inSelectedOrgRoleNameMap !== undefined && inSelectedOrgRoleNameMap !== null){
				this.selectedOrgRoleNameMap = JSON.parse(JSON.stringify(inSelectedOrgRoleNameMap));
			}
			this.selectionSummaryTemplate = dom.byId("WC_UserRoleManagement_edit_additionalRoles_selectionSummary_panel_template").innerHTML.replace(/^\s+|\s+$/g, '');
			
			//for edit buyer
			this.assignedRolesMap = JSON.parse(dom.byId("userRoles").innerHTML);
			this.selectedRolesMap = JSON.parse(dom.byId("userRoles").innerHTML);
			
			var templateDom = dom.byId("WC_UserRoleManagement_read_template");
			if (templateDom !== undefined && templateDom !== null){
				this.summaryViewTemplate = templateDom.innerHTML.replace(/^\s+|\s+$/g, '');
			}
		},
		
		/**
		 * Set role Name map in Selected Org after selecting a Org.
		 */
		setSelectedOrgRoleNameMap: function(){
			
			var inSelectedOrgRoleNameMap = JSON.parse(dom.byId("selectedOrgRoleNameMap").innerHTML);
			if (inSelectedOrgRoleNameMap !== undefined && inSelectedOrgRoleNameMap !== null){
				this.selectedOrgRoleNameMap = JSON.parse(JSON.stringify(inSelectedOrgRoleNameMap));
			}
		},
		
		/**
		 * Helper function to set userRoles and userHiddenRoles map
		 */
		setUserRolesMap:function(inArray, targetMap){
			if (inArray !== undefined && inArray !== null){
				var array = require("dojo/_base/array");
				for (var i=0; i < inArray.length; i++ ){
					var key = inArray[i][1]; //org id
					var value = inArray[i][0]; //role id
					if(Object.prototype.hasOwnProperty.call(targetMap, key)){
						if ( array.indexOf(targetMap[key], value)=== -1){
							targetMap[key].push(value);
						}
					}
					else{
						targetMap[key] = [value];
					}
				}
			}
		},
		
		/**
		 * Handle click on Role selector checkbox.
		 */
		toggleRoleCheckbox: function(role){
			var org = this.selectedOrg;
			this.updateSelectedRole(org, role);
			this.updateSelectorCheckbox();
			this.updateSelectionSummary();
		},
		
		/**
		 * Update selected roles and corresponding role name map
		 */
		updateSelectedRole: function(org, role){
			if (Object.prototype.hasOwnProperty.call(this.selectedRolesMap,org)){
				// has role in this org
				var array = require("dojo/_base/array");
				var index = array.indexOf(this.selectedRolesMap[org], role);
				if (index > -1){//exists , so remove it
					this.selectedRolesMap[org].splice(index, 1);
					if (this.selectedRolesMap[org].length == 0){//remove empty org
						delete this.selectedRolesMap[org];
						delete this.selectedOrgNameMap[org];
					}
					if (this.selectedRoleNameMap[role][1] == 1){
						delete this.selectedRoleNameMap[role];
					}
					else {
						this.selectedRoleNameMap[role][1] = this.selectedRoleNameMap[role][1] - 1;
					}
				}
				else {//does have the role, add to selected map
					this.selectedRolesMap[org].push(role);
					
					if (!Object.prototype.hasOwnProperty.call(this.selectedRoleNameMap,role)){
						this.selectedRoleNameMap[role] = [this.selectedOrgRoleNameMap[role].displayName, 1];
					}
					else{
						this.selectedRoleNameMap[role][1] = this.selectedRoleNameMap[role][1] + 1;
					}
				}
			}
			else{
				// no role was assigned from this org, create a new array for this org.
				this.selectedRolesMap[org] = [role];
				this.selectedOrgNameMap[org] = this.currentOrgNameMap[org];
				if (!Object.prototype.hasOwnProperty.call(this.selectedRoleNameMap,role)){
					this.selectedRoleNameMap[role] = [this.selectedOrgRoleNameMap[role].displayName, 1];
				}
				else{
					this.selectedRoleNameMap[role][1] = this.selectedRoleNameMap[role][1] + 1;
				}
			}
			
		}, 
		
		/**
		 * Select an Organization
		 */
		selectOrg: function(orgId){
			if (this.selectedOrg == orgId) {
				return;
			}
			query("div[data-orgid]", 'WC_UserRoleManagement_edit_additionalRoles_organizations').forEach(function(node){
				if (node.getAttribute('data-orgid') == orgId ){
					domClass.add(node, "highlight");
					dojoWindow.scrollIntoView(node);
				}
				else {
					domClass.remove(node, "highlight");
				}
			});
			//normal select case
			if (Object.prototype.hasOwnProperty.call(this.currentOrgNameMap,orgId)){
				this.selectedOrg = orgId;
				if(!submitRequest()){
					return;
				}			
				cursor_wait();
				wc.render.updateContext("UserRoleManagement_RoleSelector_Context", {"orgId": orgId});
			}
			//select from summary column where the Org is not in current page, switch to search;
			else{
				this.selectedOrg = "";
				var orgNameSearch = this.selectedOrgNameMap[orgId];
				var searchInputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
				var searchInput = document.getElementById(searchInputFieldId);
				searchInput.value = orgNameSearch;
				this.showClearFilter();
				this.updateOrgListContext(orgNameSearch, orgId, "5");// "5" is exact match search type.
			}
		},
		
		/**
		 * Update view of selector check box area, check or uncheck, highlight or not etc.
		 */
		updateSelectorCheckbox: function(){
			var array = require("dojo/_base/array");
			var panelParent = dom.byId("WC_UserRoleManagement_edit_additionalRoles_roleSelector_panel");
			domClass.remove(panelParent, "highlight");
			var foundCheckbox = false;
			query(".checkBoxer", panelParent).forEach(lang.hitch(this, function(aCheckbox){
				var role = aCheckbox.getAttribute("data-userRoleId");
				var org = this.selectedOrg;
				foundCheckbox = true;
				if (Object.prototype.hasOwnProperty.call(this.selectedRolesMap,org) && array.indexOf(this.selectedRolesMap[org], role)!== -1){
					aCheckbox.setAttribute("aria-checked", "true");
				}
				else{
					aCheckbox.setAttribute("aria-checked", "false");
				}
			}));
			if(foundCheckbox){
				domClass.add(panelParent, "highlight");
			}
		},
		
		/**
		 * Update view of selection summary column.
		 */
		updateSelectionSummary: function(){
			var panelParent = dom.byId("WC_UserRoleManagement_edit_additionalRoles_selectionSummary_panel");
			while (panelParent.firstChild) {
				panelParent.removeChild(panelParent.firstChild);
			}
			var selectedSummary = null;
			for ( var key in this.selectedRolesMap){
				//key is Org Id
				var displayString = "";
				var orgName = this.selectedOrgNameMap[key];
				var roleName = "";
				var roleArray = this.selectedRolesMap[key];
				array.forEach(roleArray, lang.hitch(this, function(role){
					var rn = this.selectedRoleNameMap[role][0];
					if (roleName.length === 0){
						roleName = rn;
					}
					else {
						roleName = lang.replace(this.roleDisplayPattern, [roleName, rn]);
					}
				}));
				if (roleName.length > 0){
					displayString = lang.replace(this.orgDisplayPattern, [this.selectedOrgNameMap[key], roleName]);
				}
				if (displayString.length > 0){
					var aSummary = domConstruct.toDom(lang.replace(this.selectionSummaryTemplate, [displayString]));
					if (key == this.selectedOrg){
						domClass.add(aSummary, "highlight");
						selectedSummary = aSummary;
					}
					query("a", aSummary).forEach(lang.hitch(this, function(a){
						var k = key; //orgId, variable in forEach scope only
						if (domClass.contains(a,"icon")){
							if (k == this.selectedOrg){
								domClass.remove(a, "nodisplay");
								on(a, "click", lang.hitch(this, function(e){
									array.forEach(this.selectedRolesMap[k], lang.hitch(this, function(r){
										if (this.selectedRoleNameMap[r][1] == 1){
											delete this.selectedRoleNameMap[r];
										}
										else {
											this.selectedRoleNameMap[r][1] = this.selectedRoleNameMap[r][1] -1;
										}
									}));
									delete this.selectedRolesMap[k];
									delete this.selectedOrgNameMap[k];
									this.updateSelectorCheckbox();
									this.updateSelectionSummary();
									event.stop(e);
								}));
							}
						}
						else if (domClass.contains(a,"roleName")){
							on(a, "click", lang.hitch(this, function(e){
								this.selectOrg(k);
								event.stop(e);
							}));
						}
					}));
					domConstruct.place(aSummary, panelParent);
				}
			}
			if (selectedSummary != null ){
				dojoWindow.scrollIntoView(selectedSummary);
			}
		},
		
		/**
		 * Update view of Read only summary according to assigned role map.
		 */
		updateReadOnlySummary: function(){
			
			var sectionParent = dom.byId("WC_UserRoleManagement_read");
			if (sectionParent !== undefined && sectionParent !== null){
				while (sectionParent.firstChild) {
					sectionParent.removeChild(sectionParent.firstChild);
				}
				for ( var key in this.assignedRolesMap){
					//key is Org Id
					var displayString = "";
					var orgName = this.assignedOrgNameMap[key];
					var roleArray = this.assignedRolesMap[key];
					array.forEach(roleArray, lang.hitch(this, function(role, i){
						var invisibleString = "<span style='visibility: hidden'>&nbsp;</span>";
						var roleName = this.assignedRoleNameMap[role][0];
						
						if ( i == 0){
							var nodeChild = domConstruct.toDom(lang.replace(this.summaryViewTemplate, [orgName, roleName]));
						}
						else {
							var nodeChild = domConstruct.toDom(lang.replace(this.summaryViewTemplate, [invisibleString, roleName]));
						}
						
						sectionParent.appendChild(nodeChild);
						
					}));
				}
			}
		},
		
		updateView: function(){
			var searchInputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
			this.updateReadOnlySummary();
			if(this.currentOrgNameMap.first !== undefined && this.currentOrgNameMap.first !== null ){
				this.selectedOrg = this.currentOrgNameMap.first;
			}
			on(dom.byId(searchInputFieldId), "keydown", lang.hitch(this, function(e){
				var charOrCode = e.charCode || e.keyCode;
				if (charOrCode == keys.ENTER){
					this.doSearch();
				}
			}));
			this.updateOrganizationPanel();
			this.updateSelectionSummary();
			this.updateSelectorCheckbox();
			//checkboxerEventInitialize;
			on(dom.byId('WC_UserRoleManagement'), ".roleSelector .checkField .checkBoxer:keydown", lang.hitch(this, function(e){
				var charOrCode = e.charCode || e.keyCode;
				if (charOrCode == keys.SPACE || charOrCode == keys.ENTER){
					var checkbox = query(".checkBoxer", query(e.target).parents(".checkField")[0])[0];
					var role = checkbox.getAttribute("data-userRoleId");
					var ariaChecked = checkbox.getAttribute("aria-checked");
					if (this.adminId == this.memberId && ariaChecked == "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
						var removeRoleHandler = topic.subscribe("adminRoleRemoveConfirmed", lang.hitch(this, function(data){
							removeRoleHandler.remove();
							if (data.action == "YES"){
								this.toggleRoleCheckbox(role);
								this.removingAdminRole = true;
							}
						}));
						MessageHelper.showConfirmationDialog("adminRoleRemoveConfirmed",
								lang.replace(MessageHelper.messages['USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE'], [this.selectedOrgRoleNameMap[role].displayName]));
					}else {
						this.toggleRoleCheckbox(role);
						if (this.adminId == this.memberId &&  ariaChecked != "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
							this.removingAdminRole = false;
						}
					}
					event.stop(e);
				}
			}));
			on(dom.byId('WC_UserRoleManagement'), ".roleSelector .checkField .checkBoxer:click", lang.hitch(this, function(e){
				var checkbox = query(".checkBoxer", query(e.target).parents(".checkField")[0])[0];
				var role = checkbox.getAttribute("data-userRoleId");
				var ariaChecked = checkbox.getAttribute("aria-checked");
				if (this.adminId == this.memberId && ariaChecked == "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
					var removeRoleHandler = topic.subscribe("adminRoleRemoveConfirmed", lang.hitch(this, function(data){
						removeRoleHandler.remove();
						if (data.action == "YES"){
							this.toggleRoleCheckbox(role);
							this.removingAdminRole = true;
						}
					}));
					MessageHelper.showConfirmationDialog("adminRoleRemoveConfirmed",
							lang.replace(MessageHelper.messages['USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE'], [this.selectedOrgRoleNameMap[role].displayName]));
				}else {
					this.toggleRoleCheckbox(role);
					if (this.adminId == this.memberId && ariaChecked != "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
						this.removingAdminRole = false;
					}
				}
				event.stop(e);
			}));
		},
		
		/**
		 * handle Seach button press
		 */
		doSearch: function(){
			var inputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
			var input = document.getElementById(inputFieldId);
			var orgNameSearch = input.value;
			if (orgNameSearch.replace(/^\s+|\s+$/g, '') != ""){
				this.selectedOrg = "";
				this.showClearFilter();
				this.updateOrgListContext(orgNameSearch, "");
			}
		},
		
		/**
		 * Update context to show page according specific number.
		 * 
		 * @param data The data for updating context.
		 */
		showPage:function(data){
			var pageNumber = data['pageNumber'];
			var pageSize = data['pageSize'];
			require(["dojo/number"], function(number){
				pageNumber = number.parse(pageNumber);
				pageSize = number.parse(pageSize);
			});
			var beginIndex = pageSize * ( pageNumber - 1 );

			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.render.updateContext("UserRoleManagement_OrgList_Context", {"selectOrgId":"", "beginIndex" : beginIndex});
		},
		
		/**
		 * clear the search when press clear filter button
		 */
		clearSearch: function(){
			var inputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
			var input = document.getElementById(inputFieldId);
			input.value='';
			this.selectedOrg = "";
			this.hideClearFilter();
			this.updateOrgListContext('', '');
		},
		
		updateOrgListContext: function(orgNameSearch, selectOrgIdTokeep, searchType){
			if (searchType === undefined || searchType === null){
				searchType = "4"; //ignore case, containing
			}
			var beginIndex = "0";
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wc.render.updateContext("UserRoleManagement_OrgList_Context", {"orgNameSearch": orgNameSearch, "selectOrgId":selectOrgIdTokeep, "searchType": searchType, "beginIndex" : beginIndex});
		},
		
		/**
		 * Update to show clear filter button
		 */
		showClearFilter: function(){
			var filterButtonId = 'WC_UserRoleManagement_edit_clearFilter';
			var filterButton = dom.byId(filterButtonId);
			filterButton.setAttribute("aria-hidden", "false");
		},
		
		/**
		 * Update to hide clear filter button
		 */
		hideClearFilter: function(){
			var filterButtonId = 'WC_UserRoleManagement_edit_clearFilter';
			var filterButton = dom.byId(filterButtonId);
			filterButton.setAttribute("aria-hidden", "true");			
		},
		
		/**
		 * Update the Organizations panel after refresh, pre-select Organization
		 */
		updateOrganizationPanel: function() {
			query("div[data-orgid]", 'WC_UserRoleManagement_edit_additionalRoles_organizations').forEach(lang.hitch(this, function(node){
				if (node.getAttribute('data-orgid') == this.selectedOrg ){
					domClass.add(node, "highlight");
					dojoWindow.scrollIntoView(node);
				}
				else {
					domClass.remove(node, "highlight");
				}
			}));
		},
		
		/**
		 * Save the assigned and unassigned roles to server
		 */
		saveChange: function(){
			
			var params = {};
			
			this.prepareSelectedRoleParam(params);
			
			if (params['paramsToUnAssign'] !== undefined && params['paramsToUnAssign'] !== null) {
				this.paramsToUnAssign = JSON.parse(JSON.stringify(params['paramsToUnAssign']));
			}
			
			if (params['paramsToAssign'] !== undefined && params['paramsToAssign'] !== null) {
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wc.service.invoke('UserRoleManagementAssign',params['paramsToAssign']);
			}
			else if (params['paramsToUnAssign'] !== undefined && params['paramsToUnAssign'] !== null) {
				if(!submitRequest()){
					return;
				}
				cursor_wait();
				wc.service.invoke('UserRoleManagementUnassign',params['paramsToUnAssign']);
			} else {
				return;
			}
			
		},

		/**
		 * The function is called by successHandler of service chainedAjaxUserRegistrationAdminAdd
		 * to assign additional roles to the member just created.
		 * @param memberId the id of the member the role to assign
		 */
		chainedAssignRole: function(memberId){
			this.memberId = memberId;
			var params = {};
			this.prepareSelectedRoleParam(params);
			// the caller (userInfo widget service successHandler) will check if any role is selected for 
			// the member, so it is guaranteed that the params['paramsToAssign'] is not null or undefined.
			wc.service.invoke('ChainedUserRoleManagementAssign',params['paramsToAssign']);
		},
		
		/**
		 * Function to test if the selectedRolesMap is empty.
		 * @return (Boolean) true if this selectedRolesMap is empty, false otherwise 
		 */
		isEmptySelectedRoles: function() {
			for (var k in this.selectedRolesMap){
				return false;
			}
			return true;
		},
		
		/**
		 * Helper function for saveChange
		 */
		prepareSelectedRoleParam: function(params){
			var array = require("dojo/_base/array");
			var paramsToAssign = {};
			var paramsToUnAssign = {};
			var n1 = 0;
			var n2 = 0;
			for ( var key in this.selectedRolesMap){
				var roles = this.selectedRolesMap[key];
				for ( var i = 0; i < roles.length; i++){
					if (undefined == this.assignedRolesMap[key] || null == this.assignedRolesMap[key] 
						|| array.indexOf(this.assignedRolesMap[key],roles[i]) === -1 ){
						n1 = n1 + 1;
						paramsToAssign['orgEntityId' + n1] = key;
						paramsToAssign['roleId' + n1] = roles[i];
					}
				}
			}
			
			for ( var key in this.assignedRolesMap){
				var roles = this.assignedRolesMap[key];
				for ( var i = 0; i < roles.length; i++){
					if (undefined === this.selectedRolesMap[key] || null === this.selectedRolesMap[key] 
						|| array.indexOf(this.selectedRolesMap[key],roles[i]) === -1 ){
						n2 = n2 + 1;
						paramsToUnAssign['orgEntityId' + n2] = key;
						paramsToUnAssign['roleId' + n2] = roles[i];
					}
				}
			}
			 
			if (n1 > 0 ){
				paramsToAssign.URL = "StoreView";//old command still check the presence of the 'URL' parameter
				paramsToAssign.storeId = this.storeId;
				paramsToAssign.langId = this.langId;
				paramsToAssign.memberId = this.memberId;
				paramsToAssign.authToken = this.authToken;
				params.paramsToAssign = paramsToAssign;
			}
			if (n2 > 0){
				paramsToUnAssign.URL = "StoreView";
				paramsToUnAssign.storeId = this.storeId;
				paramsToUnAssign.langId = this.langId;
				paramsToUnAssign.memberId = this.memberId;
				paramsToUnAssign.authToken = this.authToken;
				params.paramsToUnAssign = paramsToUnAssign;
			}
		}
		
	};
});