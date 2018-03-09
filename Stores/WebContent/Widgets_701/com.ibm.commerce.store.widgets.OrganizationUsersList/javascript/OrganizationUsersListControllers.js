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
 * Declares a new render context for creating a new list.
 */
wc.render.declareContext("OrganizationUsersListTable_Context",{"beginIndex":"0", "userFirstName":"", "userLastName":"", "userLogonId":"", "userRoleId":"", "userAccountStatus":"", "orgEntityId":"", "OrgEntityName":""},"");

/**
 * Declares a new refresh controller for creating a new List.
 */
wc.render.declareRefreshController({
	id: "OrganizationUsersListTable_controller",
	renderContext: wc.render.getContextById("OrganizationUsersListTable_Context"),
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
		widget.setInnerHTML("");
		widget.refresh(renderContext.properties);		
       }
	 
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {
		var renderContext = this.renderContext;
		if (message.actionId =='OrganizationUsersListAdminUpdateMember') {
			widget.refresh(renderContext.properties);
		}
	}
	
	/** 
	 * Clears the progress bar
	 * 
	 * @param {object} widget The registered refresh area
	 */
	,postRefreshHandler: function(widget) {
		OrganizationUsersListJS.restoreToolbarStatus();
		cursor_clear();			 
	}
});