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
//*

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

// accepts date in YYYY-MM-DD format and validates it if is within
// the year range of 1900 to 9999
// Returns true if date is a valid date
//         false otherwise
function validDate (inYear,inMonth,inDay) {
	if (inDay.length > 0 && inDay.charAt(0) == "0") {
		inDay = inDay.substring(1, inDay.length);
	}

	if (inMonth.length > 0 && inMonth.charAt(0) == "0") {
		inMonth = inMonth.substring(1, inMonth.length);
	}

	if (inYear.length == 4 && (inMonth.length == 1 || inMonth.length == 2) && (inDay.length == 1 || inDay.length == 2)) {
		var day = parseInt(inDay);
		var month = parseInt(inMonth);
		var year = parseInt(inYear);
		var dayString = day.toString();
		var monthString = month.toString();
		var yearString = year.toString();

		if ((year != NaN && yearString.length == 4 && year >= 1900 && year <= 9999 ) && (month != NaN && month >= 1 && month <= 12 && (monthString.length == inMonth.length)) && (day != NaN && (inDay.length == dayString.length))) {
			var daysMonth = getDaysInMonth(month, year);

			if (day >= 1 && day <= daysMonth) {
				return true;
			}
		}
		else {
			return false;
		}
	}
	return false;
}

// check to see if year is a leap year
function isLeapYear (Year) {
	if (((Year % 4) == 0) && ((Year % 100) != 0) || ((Year % 400) == 0)) {
		return (true);
	}
	else {
		return (false);
	}
}

// get number of days in month
function getDaysInMonth (month, year) {
	var days;

	if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
		days = 31;
	}
	else if (month == 4 || month == 6 || month == 9 || month == 11) {
		days = 30;
	}
	else if (month == 2) {
		if (isLeapYear(year)) {
			days = 29;
		}
		else {
			days = 28;
		}
	}
	return (days);
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

function showDivision (division, show) {
	if (show) {
		division.style.display = "block";
	}
	else {
		division.style.display = "none";
	}
}

function loadRadioIndex (radio, index) {
	radio[index].checked = true;
	return;
}

function getRadioIndex (radio) {
	for (var i=0; i<radio.length; i++) {
		if (radio[i].checked) {
			return i;
		}
	}
	return -1;
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

function loadSelectValues (select, displayTexts, values) {
	for (var i=0; i<values.length; i++) {
		select.options[i] = new Option(displayTexts[i], values[i], false, false);
	}
}

function getSelectValues (select) {
	var values = new Array();
	for (var i=0; i<select.options.length; i++) {
		values[i] = select.options[i].value;
	}
	return values;
}

function getSelectTexts (select) {
	var values = new Array();
	for (var i=0; i<select.options.length; i++) {
		values[i] = select.options[i].innerText;
	}
	return values;
}

function loadValue (entryField, value) {
	if (value != top.undefined) {
		entryField.value = value;
	}
}

function loadCheckBoxValues (checkBoxes, values) {
	for (var i=0; i<values.length; i++) {
		for (var j=0; j<checkBoxes.length; j++) {
			if (checkBoxes[j].value == values[i]) {
				checkBoxes[j].checked = true;
			}
		}
	}
}

function getCheckBoxValues (checkBoxes) {
	var values = new Array();
	var i = 0;
	for (var j=0; j<checkBoxes.length; j++) {
		if (checkBoxes[j].checked) {
			values[i] = checkBoxes[j].value;
			i++;
		}
	}
	return values;
}

function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
	if (submitErrorStatus == "initiativeExists") {
		put("initiativeExists", true);
		gotoPanel("initiativePanel");
	}
	else if (submitErrorStatus == "initiativeChanged") {
		put("initiativeChanged", true);
		gotoPanel("initiativePanel");
	}
	else {
		alertDialog(submitErrorMessage);
	}
}

function savepreview () {
	var initiativeResult = new Array();
	initiativeResult[0] = new Object();
	initiativeResult[0].initiativeId = window.NAVIGATION.requestProperties["initiativeId"];
	initiativeResult[0].initiativeName = window.NAVIGATION.requestProperties["initiativeName"];
	initiativeResult[0].initiativeDesc = window.NAVIGATION.requestProperties["initiativeDesc"];
	initiativeResult[0].initiativeContentType = window.NAVIGATION.requestProperties["initiativeContentType"];
	initiativeResult[0].initiativeStoreId = window.NAVIGATION.requestProperties["initiativeStoreId"];
	initiativeResult[0].initiativeStatus = window.NAVIGATION.requestProperties["initiativeStatus"];
	top.sendBackData(initiativeResult, "initiativeResult");

	var warningMessage = window.NAVIGATION.requestProperties["warningMessage"];
	if (warningMessage != null && warningMessage != "") {
		alertDialog(warningMessage);
	}

	var url = top.getWebappPath()+"DialogView?XMLFile=preview.PreviewDialog";
	top.setContent("Preview", url, true);
}

function submitFinishHandler (submitFinishMessage) {
	if (submitFinishMessage != null && submitFinishMessage != "") {
		var initiativeResult = new Array();
		initiativeResult[0] = new Object();
		initiativeResult[0].initiativeId = window.NAVIGATION.requestProperties["initiativeId"];
		initiativeResult[0].initiativeName = window.NAVIGATION.requestProperties["initiativeName"];
		initiativeResult[0].initiativeDesc = window.NAVIGATION.requestProperties["initiativeDesc"];
		initiativeResult[0].initiativeContentType = window.NAVIGATION.requestProperties["initiativeContentType"];
		initiativeResult[0].initiativeStoreId = window.NAVIGATION.requestProperties["initiativeStoreId"];
		initiativeResult[0].initiativeStatus = window.NAVIGATION.requestProperties["initiativeStatus"];
		top.sendBackData(initiativeResult, "initiativeResult");

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
		window.location.replace("CampaignInitiativesView?ActionXMLFile=campaigns.InitiativeList&cmd=CampaignInitiativeListView&orderby=name&selected=SELECTED&listsize=20&startindex=0&refnum=0");
	}
}
