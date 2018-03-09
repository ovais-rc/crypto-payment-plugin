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
 * Declares a new refresh controller for read only user details section.
 */
wc.render.declareRefreshController({
	id: "OrganizationUserInfo_userDetail_controller",
	url: "",
	formId: ""
	 
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {
		if (message.actionId =='OrganizationUserInfoAdminUpdateMember_UserDetails' || message.actionId == 'AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer') {
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
	}
});

/**
 * Declares a new refresh controller for read only user address section.
 */
wc.render.declareRefreshController({
	id: "OrganizationUserInfo_userAddress_controller",
	url: "",
	formId: ""
	 
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 * 
	 * @param {string} message The model changed event message
	 * @param {object} widget The registered refresh area
	 */
	,modelChangedHandler: function(message, widget) {

		if (message.actionId =='OrganizationUserInfoAdminUpdateMember_UserAddress') {
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
	}
});