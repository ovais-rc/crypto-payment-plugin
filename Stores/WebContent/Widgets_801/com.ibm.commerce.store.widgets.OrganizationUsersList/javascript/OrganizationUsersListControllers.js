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
 * Declares a new render context for creating a new list.
 */
wcRenderContext.declare("OrganizationUsersListTable_Context",["OrganizationUsersListTable_Widget"],{"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":"", "orgEntityId":"", "OrgEntityName":""},"");

/**
 * Declares a new refresh controller for creating a new List.
 */
function declareOrganizationUsersListTable_controller() {
	var myWidgetObj = $("#OrganizationUsersListTable_Widget");
	
	var myRCProperties = wcRenderContext.getRenderContextProperties("OrganizationUsersListTable_Context");
	
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["OrganizationUsersListAdminUpdateMember"], function() {
		myWidgetObj.refreshWidget("refresh", myRCProperties);
	});

	myWidgetObj.refreshWidget({
		/** 
		 * Refreshes the list table display if an item is updated.
		 * This function is called when a render context event is detected. 
		 */	
		renderContextChangedHandler: function() {
			myWidgetObj.html("");
			myWidgetObj.refreshWidget("refresh", myRCProperties);
		},
	
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			OrganizationUsersListJS.restoreToolbarStatus();
			cursor_clear();			 
		}
	});
};