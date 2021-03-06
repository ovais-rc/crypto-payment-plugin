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
 * Declares a new refresh controller for read only user details section.
 */
function declareOrganizationUserInfo_userDetail_controller() {
	var myWidgetObj = $("#OrganizationUserInfo_userDetail_Widget");
	 
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["OrganizationUserInfoAdminUpdateMember_UserDetails","AjaxRESTMemberPasswordResetByAdminOnBehalfForBuyer"], function() {
		myWidgetObj.refreshWidget("refresh");
	});
	
	myWidgetObj.refreshWidget({
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			widgetCommonJS.removeSectionOverlay();
			cursor_clear();
			//Initialize toggle events after page refresh
			widgetCommonJS.initializeEditSectionToggleEvent();
		}
	});
};

/**
 * Declares a new refresh controller for read only user address section.
 */
function declareOrganizationUserInfo_userAddress_controller() {
	var myWidgetObj = $("#OrganizationUserInfo_userAddress_Widget");
	
	/** 
	 * Refreshes the organization users list display if a list item is updated
	 * This function is called when a modelChanged event is detected. 
	 */
	wcTopic.subscribe(["OrganizationUserInfoAdminUpdateMember_UserAddress"], function() {
		myWidgetObj.refreshWidget("refresh");
	});
	
	myWidgetObj.refreshWidget({
		/** 
		 * Clears the progress bar
		 */
		postRefreshHandler: function() {
			widgetCommonJS.removeSectionOverlay();
			cursor_clear();
			//Initialize toggle events after page refresh
			widgetCommonJS.initializeEditSectionToggleEvent();
		}
	});
};