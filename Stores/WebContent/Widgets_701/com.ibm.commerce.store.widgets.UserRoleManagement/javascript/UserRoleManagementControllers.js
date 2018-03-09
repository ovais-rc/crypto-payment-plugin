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
 * Declares a new render context for role assignment role selector check box area.
 */
wc.render.declareContext("UserRoleManagement_RoleSelector_Context",{"orgId":""},"");
/**
 * searchType: 
 * 		4 containing, ignore case
 * 		5 match case, exact match
 * 	
 */
wc.render.declareContext("UserRoleManagement_OrgList_Context",{"beginIndex":"0", "orgNameSearch":"", "selectOrgId":"", "searchType":"4"},"");


/**
 * Declares a new refresh controller for update role selector check box.
 */
wc.render.declareRefreshController({
	id: "UserRoleManagement_RoleSelector_controller",
	renderContext: wc.render.getContextById("UserRoleManagement_RoleSelector_Context"),
	url: "",
	formId: ""
	
	/** 
	 * Refreshes the list table display if an item is updated.
	 * This function is called when a render context event is detected. 
	 * 
	 * @param {string} message The render context changed event message
	 * @param {object} widget The registered refresh area
	 */    	   
	,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;						
		widget.refresh(renderContext.properties);		
    }
	
	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {
		UserRoleManagementJS.setSelectedOrgRoleNameMap();
		UserRoleManagementJS.updateSelectorCheckbox();
		UserRoleManagementJS.updateSelectionSummary();
		cursor_clear();			 
	}
});

/**
 * Declares a new refresh controller for update organization list in .
 */
wc.render.declareRefreshController({
	id: "UserRoleManagement_OrgList_controller",
	renderContext: wc.render.getContextById("UserRoleManagement_OrgList_Context"),
	url: "",
	formId: ""
	
	/** 
	 * Refreshes the list table display if an item is updated.
	 * This function is called when a render context event is detected. 
	 * 
	 * @param {string} message The render context changed event message
	 * @param {object} widget The registered refresh area
	 */    	   
	,renderContextChangedHandler: function(message, widget) {
		var controller = this;
		var renderContext = this.renderContext;	
		widget.refresh(renderContext.properties);		
    }
	
	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {

		UserRoleManagementJS.updateCurrentOrgNameMap();
		UserRoleManagementJS.setSelectedOrgRoleNameMap();
		
		var context = wc.render.getContextById("UserRoleManagement_OrgList_Context");
		if (context.properties.selectOrgId != ''){
			//select the org preselected by user in selection summary column
			UserRoleManagementJS.selectedOrg = context.properties.selectOrgId;
		}else if (UserRoleManagementJS.currentOrgNameMap.first !== undefined && UserRoleManagementJS.currentOrgNameMap.first !== null){
			//select the first org in the list shown
			UserRoleManagementJS.selectedOrg = UserRoleManagementJS.currentOrgNameMap.first;
		}else {
			UserRoleManagementJS.selectedOrg = "";
		}
		UserRoleManagementJS.updateSelectorCheckbox();
		UserRoleManagementJS.updateSelectionSummary();
		UserRoleManagementJS.updateOrganizationPanel();
		cursor_clear();
	}
});
