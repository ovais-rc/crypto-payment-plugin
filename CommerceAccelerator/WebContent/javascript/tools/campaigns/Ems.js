//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
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

function loadSelectValue (select, value) {
	for (var i=0; i<select.length; i++) {
		if (select.options[i].value == value) {
			select.options[i].selected = true;
			return;
		}
	}
}

function getSelectValue (select) {
	return select.options[select.selectedIndex].value;
}

function isContainInvalidCharacter (checkString) {
	var invalidChars = "~!@#$%^&*+=;:<>?/|`"; // invalid chars
	invalidChars += "\t\"\\"; // escape sequences

	// if the string is empty it is not a valid name
	if (isEmpty(checkString)) {
		return false;
	}

	// look for presence of invalid characters
	// if one is found then return false, otherwise return true
	for (var i=0; i<checkString.length; i++) {
		if (invalidChars.indexOf(checkString.substring(i, i+1)) >= 0) {
			return false;
		}
	}

	return true;
}

function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
	if (submitErrorStatus == "emsExists") {
		put("emsExists", true);
		gotoPanel("emsPanel");
	}
	else {
		alertDialog(submitErrorMessage);
	}
}

function submitFinishHandler (submitFinishMessage) {
	if (submitFinishMessage != null && submitFinishMessage != "") {
		var warningMessage = window.NAVIGATION.requestProperties["warningMessage"];
		if (warningMessage != null && warningMessage != "") {
			alertDialog(warningMessage);
		}

		alertDialog(submitFinishMessage);
	}
	submitCancelHandler();
}

function submitCancelHandler () {
	if (top.goBack) {
		top.goBack();
	}
	else {
		window.location.replace("CampaignsEmsView?ActionXMLFile=campaigns.CampaignEmsList&cmd=CampaignEmsListView&orderby=name&selected=SELECTED&listsize=10&startindex=0&refnum=0");
	}
}