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
 * Declares a new render context for role assignment role selector check box area.
 */
wcRenderContext.declare("UserRoleManagement_RoleSelector_Context",["UserRoleManagement_RoleSelector"],{"orgId":""});
/**
 * searchType: 
 * 		4 containing, ignore case
 * 		5 match case, exact match
 * 	
 */
wcRenderContext.declare("UserRoleManagement_OrgList_Context",["UserRoleManagement_OrgList"],{"beginIndex":"0", "orgNameSearch":"", "selectOrgId":"", "searchType":"4"});


/**
 * Declares a new refresh controller for update role selector check box.
 */
function declareUserRoleManagement_RoleSelector_controller() {
	var myWidgetObj = $("#UserRoleManagement_RoleSelector");

	var myRCProperties = wcRenderContext.getRenderContextProperties("UserRoleManagement_RoleSelector_Context");
	
	myWidgetObj.refreshWidget({
		/** 
		 * Refreshes the list table display if an item is updated.
		 * This function is called when a render context event is detected. 
		 */    	   
		renderContextChangedHandler: function() {					
			myWidgetObj.refreshWidget("refresh", myRCProperties);
	    },
		
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			UserRoleManagementJS.setSelectedOrgRoleNameMap();
			UserRoleManagementJS.updateSelectorCheckbox();
			UserRoleManagementJS.updateSelectionSummary();
			cursor_clear();			 
		}
	});
};

/**
 * Declares a new refresh controller for update organization list in .
 */
function declareUserRoleManagement_OrgList_controller() {
	var myWidgetObj = $("#UserRoleManagement_OrgList");
	
	var myRCProperties = wcRenderContext.getRenderContextProperties("UserRoleManagement_OrgList_Context");
	
	myWidgetObj.refreshWidget({
		/** 
		 * Refreshes the list table display if an item is updated.
		 * This function is called when a render context event is detected. 
		 */    	   
		renderContextChangedHandler: function() {
			myWidgetObj.refreshWidget("refresh", myRCProperties);
	    },
		
		/** 
		 * Clears the progress bar
		 * 
		 * @param {object} widget The registered refresh area
		 */
		postRefreshHandler: function(widget) {
	
			UserRoleManagementJS.updateCurrentOrgNameMap();
			UserRoleManagementJS.setSelectedOrgRoleNameMap();
			
			if (myRCProperties.selectOrgId != ''){
				//select the org preselected by user in selection summary column
				UserRoleManagementJS.selectedOrg = myRCProperties.selectOrgId;
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
};
