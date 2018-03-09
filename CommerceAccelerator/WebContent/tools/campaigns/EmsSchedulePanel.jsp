<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.utils.TimestampHelper" %>

<%@ include file="common.jsp" %>

<%	java.sql.Timestamp currentTime = new java.sql.Timestamp(new java.util.Date().getTime()); %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Ems.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
//
// Retrieve the schedule list data from the model, and initialize critical variables in this page.
//
var emsDataBean = parent.parent.parent.get("<%= CampaignConstants.ELEMENT_EMS %>", null);
var scheduleListData = emsDataBean.<%= CampaignConstants.ELEMENT_EMS_INITIATIVE_SCHEDULE %>;
var numberOfSchedules = scheduleListData.length;

//
// After action is completed, initiativeResult object is expected to be returned from the previous panel.
// Go through each entry in the object to determine which initiatives should be added to the schedule
// list.
//
var initiativeResult = top.getData("initiativeResult", null);
var isChangeInitiative = top.getData("isChangeInitiative", false);
var isAdd = true;
if (initiativeResult != null) {
	// go through each entry in the result array
	for (var i=0; i<initiativeResult.length; i++) {
		var thisResult = initiativeResult[i];

		if (isChangeInitiative) {
			// if previous action is to change an initiative, update the initiative name
			for (var j=0; j<numberOfSchedules; j++) {
				if (scheduleListData[j].initiativeId == thisResult.initiativeId) {
					scheduleListData[j].initiativeName = initiativeResult[i].initiativeName;
				}
			}
			isAdd = false;
		}
		else {
			// go through each entry in the initiative list
			for (var j=0; j<numberOfSchedules; j++) {
				var thisSchedule = scheduleListData[j];
				// check if there is any duplicate entry ... there are 3 cases:
				// 1. duplicate found and action flag is deleteAction, then set flag to updateAction and reset all attributes
				// 2. duplicate found and action flag is destroyAction, then set flag to createAction and reset all attributes
				// 3. else, then add it to the schedule list with action flag sets to createAction
				if (thisSchedule.initiativeId == thisResult.initiativeId) {
					if (thisSchedule.actionFlag == "<%= CampaignConstants.ACTION_FLAG_DELETE %>") {
						thisSchedule.actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
						thisSchedule.endDate = "";
						thisSchedule.endDay = "";
						thisSchedule.endMonth = "";
						thisSchedule.endTime = "";
						thisSchedule.endYear = "";
						thisSchedule.priority = "";
						thisSchedule.startDate = "";
						thisSchedule.startDay = "<%= TimestampHelper.getDayFromTimestamp(currentTime) %>";
						thisSchedule.startMonth = "<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>";
						thisSchedule.startTime = "<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>";
						thisSchedule.startYear = "<%= TimestampHelper.getYearFromTimestamp(currentTime) %>";
						isAdd = false;
					}
					else if (thisSchedule.actionFlag == "<%= CampaignConstants.ACTION_FLAG_DESTROY %>") {
						thisSchedule.actionFlag = "<%= CampaignConstants.ACTION_FLAG_CREATE %>";
						thisSchedule.endDate = "";
						thisSchedule.endDay = "";
						thisSchedule.endMonth = "";
						thisSchedule.endTime = "";
						thisSchedule.endYear = "";
						thisSchedule.priority = "";
						thisSchedule.startDate = "";
						thisSchedule.startDay = "<%= TimestampHelper.getDayFromTimestamp(currentTime) %>";
						thisSchedule.startMonth = "<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>";
						thisSchedule.startTime = "<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>";
						thisSchedule.startYear = "<%= TimestampHelper.getYearFromTimestamp(currentTime) %>";
						isAdd = false;
					}
					break;
				}
			}
		}

		// if this schedule is supposed to be added to the list, create the new object
		// else action should have been taken, move on to the next entry in the result
		if (isAdd) {
			if (!scheduleListData) {
				scheduleListData = new Array();
			}
			scheduleListData[numberOfSchedules] = new Object;
			scheduleListData[numberOfSchedules].actionFlag = "<%= CampaignConstants.ACTION_FLAG_CREATE %>";
			scheduleListData[numberOfSchedules].endDate = "";
			scheduleListData[numberOfSchedules].endDay = "";
			scheduleListData[numberOfSchedules].endMonth = "";
			scheduleListData[numberOfSchedules].endTime = "";
			scheduleListData[numberOfSchedules].endYear = "";
			scheduleListData[numberOfSchedules].id = "";
			scheduleListData[numberOfSchedules].initiativeId = initiativeResult[i].initiativeId;
			scheduleListData[numberOfSchedules].initiativeName = initiativeResult[i].initiativeName;
			scheduleListData[numberOfSchedules].initiativeStoreId = initiativeResult[i].initiativeStoreId;
			scheduleListData[numberOfSchedules].initiativeStatus = initiativeResult[i].initiativeStatus;
			scheduleListData[numberOfSchedules].priority = "";
			scheduleListData[numberOfSchedules].startDate = "";
			scheduleListData[numberOfSchedules].startDay = "<%= TimestampHelper.getDayFromTimestamp(currentTime) %>";
			scheduleListData[numberOfSchedules].startMonth = "<%= TimestampHelper.getMonthFromTimestamp(currentTime) %>";
			scheduleListData[numberOfSchedules].startTime = "<%= TimestampHelper.getTimeFromTimestamp(currentTime) %>";
			scheduleListData[numberOfSchedules].startYear = "<%= TimestampHelper.getYearFromTimestamp(currentTime) %>";
			scheduleListData[numberOfSchedules].storeId = "";
			numberOfSchedules++;
		}
		else {
			isAdd = true;
		}
	}
	top.saveData(null, "initiativeResult");
	top.saveData(null, "isChangeInitiative");
}

//
// Persists the schedule list data to the model.
//
emsDataBean.<%= CampaignConstants.ELEMENT_EMS_INITIATIVE_SCHEDULE %> = scheduleListData;

function loadPanelData () {
	// load the button frame
	parent.loadFrames();

	// make sure the e-marketing spot name field gets the initial focus when the page loads
	if ((parent.parent.document.emsForm != undefined) && (parent.parent.document.emsForm.<%= CampaignConstants.ELEMENT_EMS_NAME %> != null)) {
		if (!parent.parent.document.emsForm.<%= CampaignConstants.ELEMENT_EMS_NAME %>.disabled) {
			parent.parent.document.emsForm.<%= CampaignConstants.ELEMENT_EMS_NAME %>.focus();
		}
	}

	// loop through each entry to update fields
	for (var i=0; i<numberOfSchedules; i++) {
		if ((scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
			var thisSchedule = scheduleListData[i];

			// populate schedule priority
			var thisSchedulePriority = thisSchedule.priority;
			if (!isNaN(parseInt(thisSchedulePriority))) {
				if (thisSchedulePriority > <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM %>) {
					thisSchedulePriority = <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM %>;
				}
				else if (thisSchedulePriority < <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>) {
					thisSchedulePriority = <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>;
				}

				loadSelectValue(document.all("<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>_" + i), thisSchedulePriority);

				// if this schedule priority has been updated, do the same to the model and update action flag
				if (thisSchedulePriority != thisSchedule.priority) {
					updatePriority(i);
				}
			}
		}
	}

	parent.parent.setReadyFlag("schedulePanel");
}

function savePanelData () {
	emsDataBean.<%= CampaignConstants.ELEMENT_EMS_INITIATIVE_SCHEDULE %> = scheduleListData;
}

function updateActionFlag (rowIndex) {
	if (scheduleListData[rowIndex].actionFlag == "<%= CampaignConstants.ACTION_FLAG_NO_ACTION %>") {
		scheduleListData[rowIndex].actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
	}
}

function updatePriority (rowIndex) {
	updateActionFlag(rowIndex);
	scheduleListData[rowIndex].priority = getSelectValue(document.all("<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>_" + rowIndex));
	savePanelData();
}

function updateStartDate (rowIndex) {
	updateActionFlag(rowIndex);

	// set default time if it has not been set
	if ((trim(document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + rowIndex).value) != "") &&
		(trim(document.all("<%= CampaignConstants.ELEMENT_START_MONTH %>_" + rowIndex).value) != "") &&
		(trim(document.all("<%= CampaignConstants.ELEMENT_START_DAY %>_" + rowIndex).value) != "") &&
		(trim(document.all("<%= CampaignConstants.ELEMENT_START_TIME %>_" + rowIndex).value) == "")) {
		document.all("<%= CampaignConstants.ELEMENT_START_TIME %>_" + rowIndex).value = "12:00";
	}

	scheduleListData[rowIndex].startYear = document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + rowIndex).value;
	scheduleListData[rowIndex].startMonth = document.all("<%= CampaignConstants.ELEMENT_START_MONTH %>_" + rowIndex).value;
	scheduleListData[rowIndex].startDay = document.all("<%= CampaignConstants.ELEMENT_START_DAY %>_" + rowIndex).value;
	scheduleListData[rowIndex].startTime = document.all("<%= CampaignConstants.ELEMENT_START_TIME %>_" + rowIndex).value;
	savePanelData();
}

function updateEndDate (rowIndex) {
	updateActionFlag(rowIndex);

	// set default time if it has not been set
	if ((trim(document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + rowIndex).value) != "") &&
		(trim(document.all("<%= CampaignConstants.ELEMENT_END_MONTH %>_" + rowIndex).value) != "") &&
		(trim(document.all("<%= CampaignConstants.ELEMENT_END_DAY %>_" + rowIndex).value) != "") &&
		(trim(document.all("<%= CampaignConstants.ELEMENT_END_TIME %>_" + rowIndex).value) == "")) {
		document.all("<%= CampaignConstants.ELEMENT_END_TIME %>_" + rowIndex).value = "12:00";
	}

	scheduleListData[rowIndex].endYear = document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + rowIndex).value;
	scheduleListData[rowIndex].endMonth = document.all("<%= CampaignConstants.ELEMENT_END_MONTH %>_" + rowIndex).value;
	scheduleListData[rowIndex].endDay = document.all("<%= CampaignConstants.ELEMENT_END_DAY %>_" + rowIndex).value;
	scheduleListData[rowIndex].endTime = document.all("<%= CampaignConstants.ELEMENT_END_TIME %>_" + rowIndex).value;
	savePanelData();
}

function setupStartDate (rowIndex) {
	window.yearField = document.all("<%= CampaignConstants.ELEMENT_START_YEAR %>_" + rowIndex);
	window.monthField = document.all("<%= CampaignConstants.ELEMENT_START_MONTH %>_" + rowIndex);
	window.dayField = document.all("<%= CampaignConstants.ELEMENT_START_DAY %>_" + rowIndex);
}

function setupEndDate (rowIndex) {
	window.yearField = document.all("<%= CampaignConstants.ELEMENT_END_YEAR %>_" + rowIndex);
	window.monthField = document.all("<%= CampaignConstants.ELEMENT_END_MONTH %>_" + rowIndex);
	window.dayField = document.all("<%= CampaignConstants.ELEMENT_END_DAY %>_" + rowIndex);
}

function newInitiative () {
	parent.parent.persistPanelData();

	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&fromPanel=ems&emsName=" + escapeURLSpecialChar(emsDataBean.emsName);
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_INITIATIVE)) %>", url, true);
}

function changeInitiative () {
	parent.parent.persistPanelData();

	var rowIndex = -1;

	if (arguments.length > 0) {
		rowIndex = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			if (scheduleListData[checked[0]].initiativeStoreId == "<%= campaignCommandContext.getStoreId() %>") {
				rowIndex = checked[0];
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeModified")) %>");
			}
		}
	}

	if (rowIndex != -1) {
		top.saveData(true, "isChangeInitiative");
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + scheduleListData[rowIndex].initiativeId + "&fromPanel=ems&emsName=" + escapeURLSpecialChar(emsDataBean.emsName);
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_UPDATE_INITIATIVE)) %>", url, true);
	}
}

function addInitiative () {
	parent.parent.persistPanelData();

	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSelectionDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSelectionPanelTitle")) %>", url, true);
}

function summaryInitiative () {
	parent.parent.persistPanelData();

	var checked = parent.getChecked();
	if (checked.length > 0) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSummaryDialog&initiativeId=" + scheduleListData[checked[0]].initiativeId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SUMMARY_DIALOG_TITLE)) %>", url, true);
	}
}

function removeSchedule () {
	var checkedSchedule = parent.getChecked();
	var isRemovingSchedule = false;
	if (checkedSchedule.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_DELETE_CONFIRMATION)) %>")) {
			for (i=0; i<checkedSchedule.length; i++) {
				if ((scheduleListData[checkedSchedule[i]].storeId == "") || (scheduleListData[checkedSchedule[i]].storeId == "<%= campaignCommandContext.getStoreId() %>")) {
					if (scheduleListData[checkedSchedule[i]].actionFlag == "<%= CampaignConstants.ACTION_FLAG_CREATE %>") {
						scheduleListData[checkedSchedule[i]].actionFlag = "<%= CampaignConstants.ACTION_FLAG_DESTROY %>";
					}
					else {
						scheduleListData[checkedSchedule[i]].actionFlag = "<%= CampaignConstants.ACTION_FLAG_DELETE %>";
					}
					isRemovingSchedule = true;
				}
			}
			if (isRemovingSchedule) {
				emsDataBean.<%= CampaignConstants.ELEMENT_EMS_INITIATIVE_SCHEDULE %> = scheduleListData;
				parent.location.reload();
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeDeleted")) %>");
			}
		}
	}
}

function finderChangeSpecialText (rawDisplayText, textOne, textTwo, textThree, textFour) {
	var displayText = rawDisplayText.replace(/%1/, textOne);
	if (textTwo != null) {
		displayText = displayText.replace(/%2/, textTwo);
	}
	if (textThree != null) {
		displayText = displayText.replace(/%3/, textThree);
	}
	if (textFour != null) {
		displayText = displayText.replace(/%4/, textFour);
	}
	return displayText;
}

function escapeURLSpecialChar (originalStr) {
	var newStr = originalStr;

	// escape characters that are illegal in an URL
	for (var i=0; i<newStr.length; i++) {
		if (newStr.substring(i, i+1) == "%") {
			newStr = newStr.substring(0, i) + "%25" + newStr.substring(i+1, newStr.length);
		}
	}

	return newStr;
}

function adjustWindow () {
	var calFrame = document.getElementById("CalFrame");
	window.scrollTo(calFrame.offsetLeft, calFrame.offsetTop);
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content_list" style="margin-left: 0px; margin-top: 0px">

<form name="emsForm" id="emsForm">

<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_NAME_COLUMN), null, false, null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_START_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_END_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_PRIORITY_COLUMN), null, false, null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_STATUS_COLUMN), null, false, null, false) %>
<%= comm.endDlistRow() %>

<script language="JavaScript">
<!-- hide script from old browsers
var rowselect = 1;
var numberOfSchedulesInList = 0;

for (var i=0; i<numberOfSchedules; i++) {
	if ((scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (scheduleListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
		var thisSchedule = scheduleListData[i];

		var disableFlag = "";
		if ((thisSchedule.storeId != "") && (thisSchedule.storeId != "<%= campaignCommandContext.getStoreId() %>")) {
			disableFlag = "disabled";
		}

		// table row definition for the current row
		document.writeln('<tr class="list_row' + rowselect + '" onmouseover="this.className=\'list_row3\';" onmouseout="if (this.className == \'list_row3\') {this.className=\'list_row' + rowselect + '\';}">');

		// check boxes column
		addDlistCheck(i);

		// initiative name column
		if (thisSchedule.initiativeStoreId == "<%= campaignCommandContext.getStoreId() %>") {
			addDlistColumn(thisSchedule.initiativeName, "javascript:changeInitiative(" + i + ")");
		}
		else {
			addDlistColumn(thisSchedule.initiativeName, "none");
		}

		// schedule start date column
		document.writeln('<td class="list_info1">');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_START_YEAR %>_' + i + '" id="<%= CampaignConstants.ELEMENT_START_YEAR %>_' + i + '" value="' + thisSchedule.startYear + '" size="4" maxlength="4" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_START_MONTH %>_' + i + '" id="<%= CampaignConstants.ELEMENT_START_MONTH %>_' + i + '" value="' + thisSchedule.startMonth + '" size="2" maxlength="2" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_START_DAY %>_' + i + '" id="<%= CampaignConstants.ELEMENT_START_DAY %>_' + i + '" value="' + thisSchedule.startDay + '" size="2" maxlength="2" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		if (disableFlag == "") {
			document.writeln('<a href="javascript:setupStartDate(' + i + ');showCalendar(document.emsForm.calImgSD' + i + ');adjustWindow();">');
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgSD' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>"></a>');
		}
		else {
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgSD' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>">');
		}
		document.writeln('<input name="<%= CampaignConstants.ELEMENT_START_TIME %>_' + i + '" id="<%= CampaignConstants.ELEMENT_START_TIME %>_' + i + '" type="text" value="' + thisSchedule.startTime + '" size="5" maxlength="5" onChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('</td>');

		// schedule end date column
		document.writeln('<td class="list_info1">');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_END_YEAR %>_' + i + '" id="<%= CampaignConstants.ELEMENT_END_YEAR %>_' + i + '" value="' + thisSchedule.endYear + '" size="4" maxlength="4" onPropertyChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_END_MONTH %>_' + i + '" id="<%= CampaignConstants.ELEMENT_END_MONTH %>_' + i + '" value="' + thisSchedule.endMonth + '" size="2" maxlength="2" onPropertyChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_END_DAY %>_' + i + '" id="<%= CampaignConstants.ELEMENT_END_DAY %>_' + i + '" value="' + thisSchedule.endDay + '" size="2" maxlength="2" onPropertyChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		if (disableFlag == "") {
			document.writeln('<a href="javascript:setupEndDate(' + i + ');showCalendar(document.emsForm.calImgED' + i + ');adjustWindow();">');
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgED' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>"></a>');
		}
		else {
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgED' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>">');
		}
		document.writeln('<input name="<%= CampaignConstants.ELEMENT_END_TIME %>_' + i + '" id="<%= CampaignConstants.ELEMENT_END_TIME %>_' + i + '" type="text" value="' + thisSchedule.endTime + '" size="5" maxlength="5" onChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('</td>');

		// schedule priority column
		document.writeln('<td class="list_info1">');
		document.writeln('<select name="<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>_' + i + '" id="<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>_' + i + '" onClick="this.parentElement.parentElement.className=\'list_row' + rowselect + '\';" onChange="updatePriority(' + i + ');" ' + disableFlag + '>');
		document.writeln('<option value=""><%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSelectPriority")) %></option>');
		document.writeln('<option value="<%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>">' + finderChangeSpecialText("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleHighestPriority")) %>", "<%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>") + '</option>');
<%	for (int i=CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM+1; i<=CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM; i++) { %>
		document.writeln('<option value="<%= i %>"><%= i %></option>');
<%	} %>
		document.writeln('</select>');
		document.writeln('</td>');

		// initiative status column
		var statusTextValue = "";
		if (thisSchedule.initiativeStatus == "<%= CampaignConstants.INITIATIVE_STATUS_ACTIVE %>") {
			statusTextValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.INITIATIVE_STATUS_ACTIVE)) %>";
		}
		else if (thisSchedule.initiativeStatus == "<%= CampaignConstants.INITIATIVE_STATUS_INACTIVE %>") {
			statusTextValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.INITIATIVE_STATUS_INACTIVE)) %>";
		}
		addDlistColumn(statusTextValue, "none");

		// table row definition for the current row
		document.writeln('</tr>');

		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}

		numberOfSchedulesInList++;
	}
}
//-->
</script>

<%= comm.endDlistTable() %>

<script language="JavaScript">
<!-- hide script from old browsers
if (numberOfSchedulesInList == 0) {
	document.writeln('<br />');
	document.writeln('<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_EMPTY)) %>');
}
//-->
</script>

<script language="JavaScript" for="document" event="onclick()">
<!-- hide script from old browsers
document.all.CalFrame.style.display = "none";
//-->
</script>

<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<iframe id="CalFrame" title="' + top.calendarTitle + '" marginheight="0" marginwidth="0" frameborder="0" scrolling="no" src="Calendar" style="display: none; position: absolute; width: 198; height: 230"></iframe>');
//-->
</script>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(numberOfSchedulesInList);
parent.setButtonPos("0px", "-10px");
//-->
</script>

</body>

</html>