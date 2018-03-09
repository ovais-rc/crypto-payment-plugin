//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

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
	if (NAVIGATION.requestProperties.completeMessage) {
		alertDialog(NAVIGATION.requestProperties.completeMessage);
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