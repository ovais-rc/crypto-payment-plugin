//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------

var maxCurrencyValue = 99999999999999.99

function isArray (object) {
	if (typeof(object[0]) == "undefined") {
		return false;
	}
	return true;
}

function disableItem (item, disable) {
	item.disabled = disable;
}

function disableGroup (group, disable) {
	if (isArray(group)) {
		for (var i=0; i<group.length; i++) {
			disableItem(group[i], disable);
		}
	}
	else {
		disableItem(group, disable);
	}
}

function showDivision (division, show) {
	if (show) {
		division.style.display = "block";
	}
	else {
		division.style.display = "none";
	}
}

function loadRadioValue (radio, value) {
	for (var i=0; i<radio.length; i++) {
		if (radio[i].value == value) {
			radio[i].checked = true;
			return;
		}
	}
}

function getRadioValue (radio) {
	for (var i=0; i<radio.length; i++) {
		if (radio[i].checked) {
			return radio[i].value;
		}
	}
	return "";
}

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

function loadCheckBoxValues (checkBoxes, values) {
	if (isArray(checkBoxes)) {
		for (var i=0; i<checkBoxes.length; i++) {
			checkBoxes[i].checked = false;
		}
		for (var i=0; i<values.length; i++) {
			for (var j=0; j<checkBoxes.length; j++) {
				if (checkBoxes[j].value == values[i]) {
					checkBoxes[j].checked = true;
				}
			}
		}
	}
	else {
		if (checkBoxes.value == values[0]) {
			checkBoxes.checked = true;
		}
		else {
			checkBoxes.checked = false;
		}
	}
}

function getCheckBoxValues (checkBoxes) {
	var values = new Array();

	if (isArray(checkBoxes)) {
		var i = 0;
		for (var j=0; j<checkBoxes.length; j++) {
			if (checkBoxes[j].checked) {
				values[i] = checkBoxes[j].value;
				i++;
			}
		}
	}
	else {
		if (checkBoxes.checked) {
			values[0] = checkBoxes.value;
		}
	}
	return values;
}

function loadStringValues (select, values) {
	for (var i=0; i<values.length; i++) {
		select.options[i] = new Option(values[i]);
	}
}

function getStringValues (select) {
	var values = new Array();
	for (var i=0; i<select.length; i++) {
		values[i] = select.options[i].text;
	}
	return values;
}

function getIntValue (entryField) {
	return entryField.value;
}

function scrollToAttribute (checkBox) {
	if (checkBox.checked) {
		scrollTo(0, checkBox.offsetTop);
	}
}

function addStringToSelect (select, entryField) {
	var string = entryField.value;
	if (string != null && string.length > 0) {
		var i;
		for (i=0; i<select.length; i++) {
			if (select.options[i].text == string) {
				entryField.value = "";
				return;
			}
		}
		select.options[select.length] = new Option(string);
		entryField.value = "";
	}
}

function shadowSelect (select, entryField) {
	if (select.selectedIndex != -1) {
		var option = select.options[select.selectedIndex];
		entryField.value = option.text;
	}
}

function deleteStringFromSelect (select, entryField) {
	var i;
	for (i=select.selectedIndex; (i != -1 && select.options[i] != null); i++) {
		if (select.options[i].selected) {
			select.options[i] = null;
			i--;
		}
	}
	entryField.value = "";
}

function loadCurrentDate (dayField,monthField,yearField) {
	loadValue(dayFiel, getCurrentDay());
	loadValue(monthField, getCurrentMonth());
	loadValue(yearField, getCurrentYear());
}

function validateAllPanels () {
	var o = get("segmentDetails");

	if (!o.segmentName) {
		put("segmentNameRequired", true);
		gotoPanel("segmentNotebookGeneralPanel");
		return false;
	}

	if (!self.isValidUTF8length(o.segmentName, 254)) {
		put("segmentNameTooLong", true);
		gotoPanel("segmentNotebookGeneralPanel");
		return false;
	}

	if (!self.isValidUTF8length(o.description, 512)) {
		put("segmentDescriptionTooLong", true);
		gotoPanel("segmentNotebookGeneralPanel");
		return false;
	}

	if ((o.registrationDateOp == "withinTheLast" || o.registrationDateOp == "notWithinTheLast") && (String(o.registrationDateDays) != String(parseInt(o.registrationDateDays)) || o.registrationDateDays < 0 || o.registrationDateDays == "")) {
		put("invalidRegistrationDateDays", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if ((o.registrationDateOp == "before" || o.registrationDateOp == "after") && !validDate(o.registrationDateYear, o.registrationDateMonth, o.registrationDateDay)) {
		put("invalidRegistrationDateDate", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if (o.registrationDateOp == "range" && !validDate(o.registrationDateYear1, o.registrationDateMonth1, o.registrationDateDay1)) {
		put("invalidRegistrationDateDate1", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if (o.registrationDateOp == "range" && !validDate(o.registrationDateYear2, o.registrationDateMonth2, o.registrationDateDay2)) {
		put("invalidRegistrationDateDate2", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if (o.registrationDateOp == "range" && !validateStartEndDateTime(o.registrationDateYear1, o.registrationDateMonth1, o.registrationDateDay1, o.registrationDateYear2, o.registrationDateMonth2, o.registrationDateDay2, null, null)) {
		put("invalidRangeRegistrationDateDate", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if ((o.registrationChangeDateOp == "withinTheLast" || o.registrationChangeDateOp == "notWithinTheLast") && (String(o.registrationChangeDateDays) != String(parseInt(o.registrationChangeDateDays)) || o.registrationChangeDateDays == "" || o.registrationChangeDateDays < 0)) {
		put("invalidRegistrationChangeDateDays", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if ((o.registrationChangeDateOp == "before" || o.registrationChangeDateOp == "after") && !validDate(o.registrationChangeDateYear, o.registrationChangeDateMonth, o.registrationChangeDateDay)) {
		put("invalidRegistrationChangeDateDate", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if (o.registrationChangeDateOp == "range" && !validDate(o.registrationChangeDateYear1, o.registrationChangeDateMonth1, o.registrationChangeDateDay1)) {
		put("invalidRegistrationChangeDateDate1", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if (o.registrationChangeDateOp == "range" && !validDate(o.registrationChangeDateYear2, o.registrationChangeDateMonth2, o.registrationChangeDateDay2)) {
		put("invalidRegistrationChangeDateDate2", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if (o.registrationChangeDateOp == "range" && !validateStartEndDateTime(o.registrationChangeDateYear1, o.registrationChangeDateMonth1, o.registrationChangeDateDay1, o.registrationChangeDateYear2, o.registrationChangeDateMonth2, o.registrationChangeDateDay2, null, null)) {
		put("invalidRangeRegistrationChangeDateDate", true);
		gotoPanel("segmentNotebookRegistrationPanel");
		return false;
	}

	if (o.childrenOp == "range" && parseInt(o.childrenValue1) > parseInt(o.childrenValue2)) {
		put("invalidRangeChildrenValue", true);
		gotoPanel("segmentNotebookDemographicsPanel");
		return false;
	}

	if (o.householdOp == "range" && parseInt(o.householdValue1) > parseInt(o.householdValue2)) {
		put("invalidRangeHouseholdValue", true);
		gotoPanel("segmentNotebookDemographicsPanel");
		return false;
	}

	if ((o.amountSpentOp == "greaterThan" || o.amountSpentOp == "lessThan") && (o.amountSpentValue == "" || isNaN(o.amountSpentValue) || o.amountSpentValue < 0 || o.amountSpentValue > maxCurrencyValue)) {
		put("invalidAmountSpentValue", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.amountSpentOp == "range" && (o.amountSpentValue1 == "" || isNaN(o.amountSpentValue1) || o.amountSpentValue1 < 0 || o.amountSpentValue1 > maxCurrencyValue)) {
		put("invalidAmountSpentValue1", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.amountSpentOp == "range" && (o.amountSpentValue2 == "" || isNaN(o.amountSpentValue2) || o.amountSpentValue2 < 0 || o.amountSpentValue2 > maxCurrencyValue)) {
		put("invalidAmountSpentValue2", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.amountSpentOp == "range" && parseInt(o.amountSpentValue1) > parseInt(o.amountSpentValue2)) {
		put("invalidRangeAmountSpentValue", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if ((o.ordersOp == "equalTo" || o.ordersOp == "greaterThanOrEqualTo" || o.ordersOp == "lessThanOrEqualTo") && (o.ordersValue == "" || String(o.ordersValue) != String(parseInt(o.ordersValue)) || o.ordersValue < 0)) {
		put("invalidOrdersValue", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.ordersOp == "range" && (o.ordersValue1 == "" || String(o.ordersValue1) != String(parseInt(o.ordersValue1)) || o.ordersValue1 < 0)) {
		put("invalidOrdersValue1", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.ordersOp == "range" && (o.ordersValue2 == "" || String(o.ordersValue2) != String(parseInt(o.ordersValue2)) || o.ordersValue2 < 0)) {
		put("invalidOrdersValue2", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.ordersOp == "range" && parseInt(o.ordersValue1) > parseInt(o.ordersValue2)) {
		put("invalidRangeOrdersValue", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if ((o.lastPurchaseDateOp == "withinTheLast" || o.lastPurchaseDateOp == "notWithinTheLast") && (o.lastPurchaseDateDays == "" || String(o.lastPurchaseDateDays) != String(parseInt(o.lastPurchaseDateDays)) || o.lastPurchaseDateDays < 0)) {
		put("invalidLastPurchaseDateDays", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if ((o.lastPurchaseDateOp == "before" || o.lastPurchaseDateOp == "after") && !validDate(o.lastPurchaseDateYear, o.lastPurchaseDateMonth, o.lastPurchaseDateDay)) {
		put("invalidLastPurchaseDateDate", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.lastPurchaseDateOp == "range" && !validDate(o.lastPurchaseDateYear1, o.lastPurchaseDateMonth1, o.lastPurchaseDateDay1)) {
		put("invalidLastPurchaseDateDate1", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.lastPurchaseDateOp == "range" && !validDate(o.lastPurchaseDateYear2, o.lastPurchaseDateMonth2, o.lastPurchaseDateDay2)) {
		put("invalidLastPurchaseDateDate2", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.lastPurchaseDateOp == "range" && !validateStartEndDateTime(o.lastPurchaseDateYear1, o.lastPurchaseDateMonth1, o.lastPurchaseDateDay1, o.lastPurchaseDateYear2, o.lastPurchaseDateMonth2, o.lastPurchaseDateDay2, null, null)) {
		put("invalidRangeLastPurchaseDateDate", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if ((o.lastVisitDateOp == "withinTheLast" || o.lastVisitDateOp == "notWithinTheLast") && (o.lastVisitDateDays == "" || String(o.lastVisitDateDays) != String(parseInt(o.lastVisitDateDays)) || o.lastVisitDateDays < 0)) {
		put("invalidLastVisitDateDays", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if ((o.lastVisitDateOp == "before" || o.lastVisitDateOp == "after") && !validDate(o.lastVisitDateYear, o.lastVisitDateMonth, o.lastVisitDateDay)) {
		put("invalidLastVisitDateDate", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.lastVisitDateOp == "range" && !validDate(o.lastVisitDateYear1, o.lastVisitDateMonth1, o.lastVisitDateDay1)) {
		put("invalidLastVisitDateDate1", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.lastVisitDateOp == "range" && !validDate(o.lastVisitDateYear2, o.lastVisitDateMonth2, o.lastVisitDateDay2)) {
		put("invalidLastVisitDateDate2", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if (o.lastVisitDateOp == "range" && !validateStartEndDateTime(o.lastVisitDateYear1, o.lastVisitDateMonth1, o.lastVisitDateDay1, o.lastVisitDateYear2, o.lastVisitDateMonth2, o.lastVisitDateDay2, null, null)) {
		put("invalidRangeLastVisitDateDate", true);
		gotoPanel("segmentNotebookPurchasePanel");
		return false;
	}

	if ((o.accountCreditOp == "greaterThan" || o.accountCreditOp == "lessThan") && (o.accountCreditValue == "" || isNaN(o.accountCreditValue) || o.accountCreditValue < 0 || o.accountCreditValue > 100)) {
		put("invalidAccountCreditValue", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	if (o.accountCreditOp == "range" && (o.accountCreditValue1 == "" || isNaN(o.accountCreditValue1) || o.accountCreditValue1 < 0 || o.accountCreditValue1 > 100)) {
		put("invalidAccountCreditValue1", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	if (o.accountCreditOp == "range" && (o.accountCreditValue2 == "" || isNaN(o.accountCreditValue2) || o.accountCreditValue2 < 0 || o.accountCreditValue2 > 100)) {
		put("invalidAccountCreditValue2", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	if (o.accountCreditOp == "range" && parseInt(o.accountCreditValue1) > parseInt(o.accountCreditValue2)) {
		put("invalidRangeAccountCreditValue", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	if ((o.accountAmountSpentOp == "greaterThan" || o.accountAmountSpentOp == "lessThan") && (o.accountAmountSpentValue == "" || isNaN(o.accountAmountSpentValue) || o.accountAmountSpentValue < 0 || o.accountAmountSpentValue > maxCurrencyValue)) {
		put("invalidAccountAmountSpentValue", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	if (o.accountAmountSpentOp == "range" && (o.accountAmountSpentValue1 == "" || isNaN(o.accountAmountSpentValue1) || o.accountAmountSpentValue1 < 0 || o.accountAmountSpentValue1 > maxCurrencyValue)) {
		put("invalidAccountAmountSpentValue1", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	if (o.accountAmountSpentOp == "range" && (o.accountAmountSpentValue2 == "" || isNaN(o.accountAmountSpentValue2) || o.accountAmountSpentValue2 < 0 || o.accountAmountSpentValue2 > maxCurrencyValue)) {
		put("invalidAccountAmountSpentValue2", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	if (o.accountAmountSpentOp == "range" && parseInt(o.accountAmountSpentValue1) > parseInt(o.accountAmountSpentValue2)) {
		put("invalidRangeAccountAmountSpentValue", true);
		gotoPanel("segmentNotebookAccountPanel");
		return false;
	}

	return true;
}

function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
	if (submitErrorStatus == "segmentExists") {
		put("segmentExists", true);
		gotoPanel("segmentNotebookGeneralPanel");
	}
	else if (submitErrorStatus == "segmentChanged") {
		put("segmentChanged", true);
		gotoPanel("segmentNotebookGeneralPanel");
	}
	else if (submitErrorStatus == "nameNotAvailable") {
		put("nameNotAvailable", true);
		gotoPanel("segmentNotebookGeneralPanel");
	}
	else {
		alertDialog(submitErrorMessage);
		top.goBack();
	}
}

function submitFinishHandler (submitFinishMessage) {
	if (submitFinishMessage != null && submitFinishMessage != "") {
		var segmentResult = new Array();
		segmentResult[0] = new Object();
		segmentResult[0].segmentId = window.NAVIGATION.requestProperties["segmentId"];
		segmentResult[0].segmentName = window.NAVIGATION.requestProperties["segmentName"];
		segmentResult[0].segmentStoreId = window.NAVIGATION.requestProperties["segmentStoreId"];
		top.sendBackData(segmentResult, "segmentResult");

		var completeMessage = window.NAVIGATION.requestProperties["completeMessage"];
		if (completeMessage != null && completeMessage != "") {
			alertDialog(completeMessage);
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
		window.location.replace("SegmentsView?orderby=name&ActionXMLFile=segmentation.SegmentList&cmd=SegmentListView&selected=&amp;listsize=20&amp;startindex=0&amp;refnum=0");
	}
}

//* 
//* convert the  IncldueCustomerList and ExcludeCustomerList to array which only contain the memberId and then save to segmentDetails.
//*
function preSubmitHandler () {
	var o = get("segmentDetails");

	var iList = get("IncludeCustomerList");
	if (iList) {
		var idList = new Array();
		for (var i=0; i<iList.length; i++) {
			idList[i] = iList[i].memberId;
		}
		o.includeMembers = idList;
	}

	var eList = get("ExcludeCustomerList");
	if (eList) {
		var idList = new Array();
		for(var i=0; i<eList.length; i++) {
			idList[i] = eList[i].memberId;
		}
		o.excludeMembers = idList;
	}
}