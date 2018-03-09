//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2014, 2016 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/** 
 * @fileOverview This file provides all the functions and variables to manage user roles within.
 * This file is included in all pages with organization users role assignment actions.
 */
/* global KeyCodes */

/**
 * This service allow administrator to assign roles of member
 * @constructor
 */
wcService.declare({
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
			wcService.invoke('UserRoleManagementUnassign',UserRoleManagementJS.paramsToUnAssign);
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
wcService.declare({
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
wcService.declare({
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
		$('#UserRoleManagement_RoleSelector').attr("refreshurl", roleSelectorUrl);
		$('#UserRoleManagement_OrgList').attr("refreshurl", orgListUrl);
	},
	
	/**
	 * Handle press cancel button
	 */
	subscribeToToggleCancel: function(){
		var topicName = "sectionToggleCancelPressed";
		var scope = this;
		wcTopic.subscribe( topicName , $.proxy( function(data){
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
		}, this));
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
	 * Read only Summary view template
	 */
	loadSummaryViewTemplate: function(orgPattern, rolePattern){
		this.summaryViewTemplate = $("#WC_UserRoleManagement_read_template").html().replace(/^\s+|\s+$/g, '');
	},
	
	/**
	 * Update currentOrgNameMap after Org list refresh
	 */
	updateCurrentOrgNameMap: function(){
		var incurrentOrgNameMap = JSON.parse($("#currentOrgNameMap").html());
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
		var inassignedOrgNameMap = JSON.parse($("#assignedOrgNameMap").html());
		var inassignedRoleNameMap = JSON.parse($("#assignedRoleNameMap").html());
		var incurrentOrgNameMap = JSON.parse($("#currentOrgNameMap").html());
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
		var inSelectedOrgRoleNameMap = JSON.parse($("#selectedOrgRoleNameMap").html());
		if (inSelectedOrgRoleNameMap !== undefined && inSelectedOrgRoleNameMap !== null){
			this.selectedOrgRoleNameMap = JSON.parse(JSON.stringify(inSelectedOrgRoleNameMap));
		}
		this.selectionSummaryTemplate = $("#WC_UserRoleManagement_edit_additionalRoles_selectionSummary_panel_template").html().replace(/^\s+|\s+$/g, '');
		
		//for edit buyer
		this.assignedRolesMap = JSON.parse($("#userRoles").html());
		this.selectedRolesMap = JSON.parse($("#userRoles").html());
		
		var templateDom = $("#WC_UserRoleManagement_read_template");
		if (templateDom[0] !== undefined && templateDom[0] !== null){
			this.summaryViewTemplate = templateDom.html().replace(/^\s+|\s+$/g, '');
		}
	},
	
	/**
	 * Set role Name map in Selected Org after selecting a Org.
	 */
	setSelectedOrgRoleNameMap: function(){
		
		var inSelectedOrgRoleNameMap = JSON.parse($("#selectedOrgRoleNameMap").html());
		if (inSelectedOrgRoleNameMap !== undefined && inSelectedOrgRoleNameMap !== null){
			this.selectedOrgRoleNameMap = JSON.parse(JSON.stringify(inSelectedOrgRoleNameMap));
		}
	},
	
	/**
	 * Helper function to set userRoles and userHiddenRoles map
	 */
	setUserRolesMap:function(inArray, targetMap){
		if (inArray !== undefined && inArray !== null){
			for (var i=0; i < inArray.length; i++ ){
				var key = inArray[i][1]; //org id
				var value = inArray[i][0]; //role id
				if(Object.prototype.hasOwnProperty.call(targetMap, key)){
					if ( targetMap[key].indexOf(value)=== -1){
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
			var index = this.selectedRolesMap[org].indexOf(role);
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

		$('#WC_UserRoleManagement_edit_additionalRoles_organizations div[data-orgid]').each(function(index, node){
			if (node.getAttribute('data-orgid') == orgId ){
				$(node).addClass("highlight");
				Utils.scrollIntoView(node);
			}
			else {
				$(node).removeClass("highlight");
			}
		});
		//normal select case
		if (Object.prototype.hasOwnProperty.call(this.currentOrgNameMap,orgId)){
			this.selectedOrg = orgId;
			if(!submitRequest()){
				return;
			}			
			cursor_wait();
			wcRenderContext.updateRenderContext("UserRoleManagement_RoleSelector_Context", {"orgId": orgId});
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
		var panelParent = $("#WC_UserRoleManagement_edit_additionalRoles_roleSelector_panel");
		panelParent.removeClass("highlight");
		var foundCheckbox = false;
		panelParent.find(".checkBoxer").each($.proxy( function(index, aCheckbox){
			var role = aCheckbox.getAttribute("data-userRoleId");
			var org = this.selectedOrg;
			foundCheckbox = true;
			if (Object.prototype.hasOwnProperty.call(this.selectedRolesMap,org) && this.selectedRolesMap[org].indexOf(role)!== -1){
				aCheckbox.setAttribute("aria-checked", "true");
			}
			else{
				aCheckbox.setAttribute("aria-checked", "false");
			}
		}, this));
		if(foundCheckbox){
			panelParent.addClass("highlight");
		}
	},
	
	/**
	 * Update view of selection summary column.
	 */
	updateSelectionSummary: function(){
		var panelParent = $("#WC_UserRoleManagement_edit_additionalRoles_selectionSummary_panel");
		panelParent.empty();
		var selectedSummary = null;
		for ( var key in this.selectedRolesMap){
			//key is Org Id
			var displayString = "";
			var orgName = this.selectedOrgNameMap[key];
			var roleName = "";
			var roleArray = this.selectedRolesMap[key];
			$(roleArray).each( $.proxy( function(index, role){
				var rn = this.selectedRoleNameMap[role][0];
				if (roleName.length === 0){
					roleName = rn;
				}
				else {
					roleName = Utils.substituteStringWithMap(this.roleDisplayPattern, {0: roleName, 1: rn});
				}
			}, this));
			if (roleName.length > 0){
				displayString = Utils.substituteStringWithMap(this.orgDisplayPattern, {0: this.selectedOrgNameMap[key], 1: roleName});
			}
			if (displayString.length > 0){
				var aSummary = $(Utils.substituteStringWithMap(this.selectionSummaryTemplate, {0: displayString}));
				if (key == this.selectedOrg){
					aSummary.addClass("highlight");
					selectedSummary = aSummary;
				}
				aSummary.find("a").each($.proxy( function(index, a){
					var k = key; //orgId, variable in forEach scope only
					if ($(a).hasClass("icon")){
						if (k == this.selectedOrg){
							$(a).removeClass("nodisplay");
							$(a).on("click", $.proxy( function(e){
								$(this.selectedRolesMap[k]).each( $.proxy( function(index, r){
									if (this.selectedRoleNameMap[r][1] == 1){
										delete this.selectedRoleNameMap[r];
									}
									else {
										this.selectedRoleNameMap[r][1] = this.selectedRoleNameMap[r][1] -1;
									}
								}, this));
								delete this.selectedRolesMap[k];
								delete this.selectedOrgNameMap[k];
								this.updateSelectorCheckbox();
								this.updateSelectionSummary();
								e.preventDefault();
								e.stopPropagation();
							}, this));
						}
					}
					else if ($(a).hasClass("roleName")){
						$(a).on("click", $.proxy( function(e){
							this.selectOrg(k);
							e.preventDefault();
							e.stopPropagation();
						}, this));
					}
				}, this));
				panelParent.append(aSummary);
			}
		}
		if (selectedSummary != null ){
			Utils.scrollIntoView(selectedSummary);
		}
	},
	
	/**
	 * Update view of Read only summary according to assigned role map.
	 */
	updateReadOnlySummary: function(){
		
		var sectionParent = $("#WC_UserRoleManagement_read");
		if (sectionParent !== undefined && sectionParent !== null){

			sectionParent.empty();
			
			for ( var key in this.assignedRolesMap){
				//key is Org Id
				var displayString = "";
				var orgName = this.assignedOrgNameMap[key];
				var roleArray = this.assignedRolesMap[key];
				$(roleArray).each( $.proxy( function(i, role){
					var invisibleString = "<span style='visibility: hidden'>&nbsp;</span>";
					var roleName = this.assignedRoleNameMap[role][0];
					
					if ( i == 0){
						var nodeChild = $(Utils.substituteStringWithMap(this.summaryViewTemplate, {0: orgName, 1: roleName}));
					}
					else {
						var nodeChild = $(Utils.substituteStringWithMap(this.summaryViewTemplate, {0: invisibleString, 1:roleName}));
					}

					sectionParent.append(nodeChild);
					
				}, this));
			}
		}
	},
	
	updateView: function(){
		var searchInputFieldId = 'WC_UserRoleManagement_edit_additionalRoles_searchInput';
		this.updateReadOnlySummary();
		if(this.currentOrgNameMap.first !== undefined && this.currentOrgNameMap.first !== null ){
			this.selectedOrg = this.currentOrgNameMap.first;
		}
		$("#" + searchInputFieldId).on("keydown", $.proxy( function(e){
			var charOrCode = e.charCode || e.keyCode;
			if (charOrCode == KeyCodes.ENTER){
				this.doSearch();
			}
		}, this));
		this.updateOrganizationPanel();
		this.updateSelectionSummary();
		this.updateSelectorCheckbox();
		
		$('#WC_UserRoleManagement').on("keydown", ".roleSelector .checkField .checkBoxer", $.proxy( function(e){
			var charOrCode = e.charCode || e.keyCode;
			if (charOrCode == KeyCodes.SPACE || charOrCode == KeyCodes.ENTER){
				
				var checkbox = $( $(e.target).parents(".checkField")[0] ).find(".checkBoxer")[0];
				var role = checkbox.getAttribute("data-userRoleId");
				var ariaChecked = checkbox.getAttribute("aria-checked");
				if (this.adminId == this.memberId && ariaChecked == "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
					wcTopic.subscribeOnce( "adminRoleRemoveConfirmed" , $.proxy( function(data){
						if (data.action == "YES"){
							this.toggleRoleCheckbox(role);
							this.removingAdminRole = true;
						}
					}, this), this);	
					MessageHelper.showConfirmationDialog("adminRoleRemoveConfirmed",
							Utils.substituteStringWithMap(MessageHelper.messages['USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE'], {0: this.selectedOrgRoleNameMap[role].displayName}));
				}else {
					this.toggleRoleCheckbox(role);
					if (this.adminId == this.memberId &&  ariaChecked != "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
						this.removingAdminRole = false;
					}
				}
				e.preventDefault();
				e.stopPropagation();
			}
		}, this));
		$('#WC_UserRoleManagement').on("click", ".roleSelector .checkField .checkBoxer", $.proxy( function(e){
			var checkbox = $( $(e.target).parents(".checkField")[0] ).find(".checkBoxer")[0];
			var role = checkbox.getAttribute("data-userRoleId");
			var ariaChecked = checkbox.getAttribute("aria-checked");
			if (this.adminId == this.memberId && ariaChecked == "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
				wcTopic.subscribeOnce( "adminRoleRemoveConfirmed" , $.proxy( function(data){
					if (data.action == "YES"){
						this.toggleRoleCheckbox(role);
						this.removingAdminRole = true;
					}
				}, this), this);
				MessageHelper.showConfirmationDialog("adminRoleRemoveConfirmed",
						Utils.substituteStringWithMap(MessageHelper.messages['USERROLEMANAGEMENT_CONFIRMATIONDIALOGMESSAGE'], {0: this.selectedOrgRoleNameMap[role].displayName}));
			}else {
				this.toggleRoleCheckbox(role);
				if (this.adminId == this.memberId && ariaChecked != "true" && this.selectedOrgRoleNameMap[role].name == this.buyerAdmin){
					this.removingAdminRole = false;
				}
			}
			e.preventDefault();
			e.stopPropagation();
		}, this));
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
			pageNumber = parseInt(pageNumber);
			pageSize = parseInt(pageSize);
		var beginIndex = pageSize * ( pageNumber - 1 );

		if(!submitRequest()){
			return;
		}			
		cursor_wait();
		wcRenderContext.updateRenderContext("UserRoleManagement_OrgList_Context", {"selectOrgId":"", "beginIndex" : beginIndex});
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
		wcRenderContext.updateRenderContext("UserRoleManagement_OrgList_Context", {"orgNameSearch": orgNameSearch, "selectOrgId":selectOrgIdTokeep, "searchType": searchType, "beginIndex" : beginIndex});
	},
	
	/**
	 * Update to show clear filter button
	 */
	showClearFilter: function(){
		var filterButtonId = 'WC_UserRoleManagement_edit_clearFilter';
		var filterButton = $("#" + filterButtonId);
		filterButton.attr("aria-hidden", "false");
	},
	
	/**
	 * Update to hide clear filter button
	 */
	hideClearFilter: function(){
		var filterButtonId = 'WC_UserRoleManagement_edit_clearFilter';
		var filterButton = $("#" + filterButtonId);
		filterButton.attr("aria-hidden", "true");			
	},
	
	/**
	 * Update the Organizations panel after refresh, pre-select Organization
	 */
	updateOrganizationPanel: function() {
		$('#WC_UserRoleManagement_edit_additionalRoles_organizations div[data-orgid]').each($.proxy( function(index, node){
			if (node.getAttribute('data-orgid') == this.selectedOrg ){
				$(node).addClass("highlight");
				Utils.scrollIntoView(node);
			}
			else {
				$(node).removeClass("highlight");
			}
		}, this));
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
			wcService.invoke('UserRoleManagementAssign',params['paramsToAssign']);
		}
		else if (params['paramsToUnAssign'] !== undefined && params['paramsToUnAssign'] !== null) {
			if(!submitRequest()){
				return;
			}
			cursor_wait();
			wcService.invoke('UserRoleManagementUnassign',params['paramsToUnAssign']);
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
		wcService.invoke('ChainedUserRoleManagementAssign',params['paramsToAssign']);
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
		var paramsToAssign = {};
		var paramsToUnAssign = {};
		var n1 = 0;
		var n2 = 0;
		for ( var key in this.selectedRolesMap){
			var roles = this.selectedRolesMap[key];
			for ( var i = 0; i < roles.length; i++){
				if (undefined == this.assignedRolesMap[key] || null == this.assignedRolesMap[key] 
					|| this.assignedRolesMap[key].indexOf(roles[i]) === -1 ){
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
					|| this.selectedRolesMap[key].indexOf(roles[i]) === -1 ){
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