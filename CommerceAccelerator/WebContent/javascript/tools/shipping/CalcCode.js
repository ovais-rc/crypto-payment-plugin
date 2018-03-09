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

function loadValue (entryField, value) {
	if (value != top.undefined) {
		entryField.value = value;
	}
}

function validateAllPanels () {

	var o = get("calcCodeBean");

	if (!o.code) {
		put("calcCodeNameRequired", true);
		gotoPanel("calcCodeGeneralPanel");
		return false;
	}

	if (!isValidUTF8length(o.code,128)) {
		put("calcCodeNameTooLong", true);
		gotoPanel("calcCodeGeneralPanel");
		return false;
	}

	if (!isValidUTF8length(o.description,254)) {
		put("calcCodeDescriptionTooLong", true);
		gotoPanel("calcCodeGeneralPanel");
		return false;
	}

	return true;
}

function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
	if (submitErrorStatus == "calcCodeExist") {
		put("calcCodeExist", true);
		gotoPanel("calcCodeGeneralPanel");
	}
	else if (submitErrorStatus == "calcCodeChanged") {
		put("calcCodeChanged", true);
		gotoPanel("calcCodeGeneralPanel");
	}
	else {
		alertDialog(submitErrorMessage);
	}
}

function submitFinishHandler (submitFinishMessage) {
	if (submitFinishMessage != null && submitFinishMessage != "") {
		alertDialog(submitFinishMessage);
		top.put("createCalRule", true);
	}
	submitCancelHandler();
}

function submitCancelHandler () {
	if (top.goBack) {
		top.goBack();
	}
	else {
		window.location.replace("CalcCodesView?ActionXMLFile=shipping.CalcCodeList&cmd=CalcCodesListView&orderby=name&selected=SELECTED&listsize=20&startindex=0&refnum=0");
	}
}
