//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function validateAllPanels () {

	var o1 = get("shipModeBean");

	if (!o1.carrier) {
		put("providerNameRequired", true);
		gotoPanel("shipModePanel");
		return false;
	}
	if (!o1.code) {
		put("serviceNameRequired", true);
		gotoPanel("shipModePanel");
		return false;
	}

	if (!isValidUTF8length(o1.carrier,30)) {
		put("providerNameTooLong", true);
		gotoPanel("shipModePanel");
		return false;
	}

	if (!isValidUTF8length(o1.code,30)) {
		put("serviceNameTooLong", true);
		gotoPanel("shipModePanel");
		return false;
	}

	if (!isValidUTF8length(o1.field1,254)) {
		put("displayNameTooLong", true);
		gotoPanel("shipModePanel");
		return false;
	}


	if (!isValidUTF8length(o1.field2,254)) {
		put("addDescriptionTooLong", true);
		gotoPanel("shipModePanel");
		return false;
	}
	
	if (!isValidUTF8length(o1.description,254)) {
		put("descriptionTooLong", true);
		gotoPanel("shipModePanel");
		return false;
	}
	
		if (!isValidUTF8length(o1.trackInquiryType,8)) {
		put("trackInquiryTypeTooLong", true);
		gotoPanel("shipModeTrackingPanel");
		return false;
	}

	if (!isValidUTF8length(o1.trackName,64)) {
		put("trackNameTooLong", true);
		gotoPanel("shipModeTrackingPanel");
		return false;
	}

	if (!isValidUTF8length(o1.trackSocksHost,64)) {
		put("trackSocksHostTooLong", true);
		gotoPanel("shipModeTrackingPanel");
		return false;
	}


	if (!isValidPositiveInteger(o1.trackSocksPort)) {
		put("trackSocksPortNotInteger", true);
		gotoPanel("shipModeTrackingPanel");
		return false;
	}
	
	if (!isValidUTF8length(o1.trackURL,64)) {
		put("trackURLTooLong", true);
		gotoPanel("shipModeTrackingPanel");
		return false;
	}
	
	if (!isValidUTF8length(o1.trackIcon,64)) {
		put("trackIconTooLong", true);
		gotoPanel("shipModeTrackingPanel");
		return false;
	}
	
	

	return true;
}

function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
	if (submitErrorStatus == "shipModeExists") {
		put("shipModeExists", true);
		gotoPanel("shipModePanel");
	}
	else if (submitErrorStatus == "shipModeChanged") {
		put("shipModeChanged", true);
		gotoPanel("shipModePanel");
	}
	else {
		alertDialog(submitErrorMessage);
	}
}

function submitFinishHandler (submitFinishMessage) {
	if (submitFinishMessage != null && submitFinishMessage != "")
		alertDialog(submitFinishMessage);
	submitCancelHandler();
}

function submitCancelHandler () {
   if (top.goBack) {
		top.goBack();
	}
	else {
		window.location.replace("ShipModesView?ActionXMLFile=shipping.ShipModesList&cmd=ShipModesListView&orderby=name&selected=SELECTED&listsize=20&startindex=0&refnum=0");
	}

}
