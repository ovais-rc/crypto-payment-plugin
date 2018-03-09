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
 * Declares a new refresh controller for update member group select.
 */
function declareUserMemberGroupManagement_controller() {
	var myWidgetObj = $("#UserMemberGroupManagement");
	
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["RESTUserMbrGrpMgtMemberUpdate","UserRoleManagementUpdate"], function() {
		myWidgetObj.refreshWidget("refresh");
	});
	
	myWidgetObj.refreshWidget({
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			widgetCommonJS.removeSectionOverlay();
			cursor_clear();
			UserMemberGroupManagementJS.initializeData();
			//Initialize toggle events after page refresh
			widgetCommonJS.initializeEditSectionToggleEvent();
		}
	});
};
