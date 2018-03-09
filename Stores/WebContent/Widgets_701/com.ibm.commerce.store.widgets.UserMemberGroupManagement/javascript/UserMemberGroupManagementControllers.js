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
 * Declares a new refresh controller for update member group select.
 */
wc.render.declareRefreshController({
	id: "UserMemberGroupManagement_controller"
	
	
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {
		if (message.actionId =='RESTUserMbrGrpMgtMemberUpdate' || message.actionId == 'UserRoleManagementUpdate') {
			widget.refresh();
		}
	}
	
	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {
		widgetCommonJS.removeSectionOverlay();
		cursor_clear();
		UserMemberGroupManagementJS.initializeData();
	}
});
