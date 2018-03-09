//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
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

function replaceField (source, pattern, replacement) {
	var returnString = source;
	index1 = source.indexOf(pattern);
	index2 = index1 + pattern.length;
	if (index1 >= 0) {
		returnString = source.substring(0, index1) + replacement + source.substring(index2);
	}
	return returnString;
}

function validateAllPanels () {
	var o = get("experiment");

	if (!wc_validateNonEmpty(o.experimentName)) {
		put("experimentNameRequired", true);
		gotoPanel("experimentNotebookGeneralPanel");
		return false;
	}

	if (!wc_validateUTF8length(o.experimentName, 64)) {
		put("experimentNameTooLong", true);
		gotoPanel("experimentNotebookGeneralPanel");
		return false;
	}

	if (!wc_validateUTF8length(o.description, 254)) {
		put("experimentDescriptionTooLong", true);
		gotoPanel("experimentNotebookGeneralPanel");
		return false;
	}

	if (!wc_validateDate(o.startYear, o.startMonth, o.startDay)) {
		put("experimentStartDateInvalid", true);
		gotoPanel("experimentNotebookGeneralPanel");
		return false;
	}

	if (!wc_validateTime(o.startTime)) {
		put("experimentStartTimeInvalid", true);
		gotoPanel("experimentNotebookGeneralPanel");
		return false;
	}

	if (o.endYear != "" || o.endMonth != "" || o.endDay != "" || o.endTime != "") {
		if (!wc_validateDate(o.endYear, o.endMonth, o.endDay)) {
			put("experimentEndDateInvalid", true);
			gotoPanel("experimentNotebookGeneralPanel");
			return false;
		}

		if (!wc_validateTime(o.endTime)) {
			put("experimentEndTimeInvalid", true);
			gotoPanel("experimentNotebookGeneralPanel");
			return false;
		}

		if (!validateStartEndDateTime(o.startYear, o.startMonth, o.startDay, o.endYear, o.endMonth, o.endDay, o.startTime, o.endTime)) {
			put("experimentStartDateAfterEndDate", true);
			gotoPanel("experimentNotebookGeneralPanel");
			return false;
		}
	}

	if (o.expireCount != "") {
		if (!wc_validateInt(o.expireCount)) {
			put("experimentExpireCountInvalid", true);
			gotoPanel("experimentNotebookGeneralPanel");
			return false;
		}
	}

	if (!o.experimentRuleDefinition) {
		if (o.ruleXml == "") {
			put("experimentStoreElementRequired", true);
			gotoPanel("experimentNotebookDefinitionPanel");
			return false;
		}
	}
	else {
		var ruleDefinition = o.experimentRuleDefinition;
		var totalRatio = 0;

		if (!wc_validateNonEmpty(ruleDefinition.storeElementObjectId)) {
			put("experimentStoreElementRequired", true);
			gotoPanel("experimentNotebookDefinitionPanel");
			return false;
		}

		if (!wc_validateNonEmpty(ruleDefinition.controlElementObjectId)) {
			put("experimentControlElementRequired", true);
			gotoPanel("experimentNotebookDefinitionPanel");
			return false;
		}

		if (!wc_validateInt(ruleDefinition.controlElementRatio)) {
			put("experimentControlRatioInvalid", true);
			gotoPanel("experimentNotebookDefinitionPanel");
			return false;
		}
		else {
			totalRatio += parseInt(ruleDefinition.controlElementRatio);
		}

		for (var i=0; i<ruleDefinition.testElements.testElement.length; i++) {
			if (ruleDefinition.testElements.type == ruleDefinition.testElements.testElement[i].testElementType) {
				if (!wc_validateInt(ruleDefinition.testElements.testElement[i].testElementRatio)) {
					put("experimentTestRatioInvalid", true);
					gotoPanel("experimentNotebookDefinitionPanel");
					return false;
				}
				else {
					totalRatio += parseInt(ruleDefinition.testElements.testElement[i].testElementRatio);
				}
			}
		}

		if (totalRatio.toString() != get("displayFrequencyTotalSize", "100")) {
			put("experimentRatioOutOfRange", true);
			gotoPanel("experimentNotebookDefinitionPanel");
			return false;
		}
	}
}

function preSubmitHandler () {
	var o = get("experiment");
	if (o.experimentRuleDefinition) {
		// remove all obsolete test elements in the rule definition object
		var ruleDefinition = o.experimentRuleDefinition;
		var finalTestElementData = new Array();
		var currentIndex = 0;
		for (var i=0; i<ruleDefinition.testElements.testElement.length; i++) {
			if (ruleDefinition.testElements.type == ruleDefinition.testElements.testElement[i].testElementType) {
				finalTestElementData[currentIndex] = ruleDefinition.testElements.testElement[i];
				currentIndex++;
			}
		}
		ruleDefinition.testElements.testElement = finalTestElementData;
	}
}

function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
	if (submitErrorStatus == "experimentExists") {
		put("experimentExists", true);
		gotoPanel("experimentNotebookGeneralPanel");
	}
	else {
		alertDialog(submitErrorMessage);
	}
}

function submitFinishHandler (submitFinishMessage) {
	if (submitFinishMessage != null && submitFinishMessage != "") {
		alertDialog(submitFinishMessage);
	}
	submitCancelHandler();
}

function submitCancelHandler () {
	top.goBack();
}
