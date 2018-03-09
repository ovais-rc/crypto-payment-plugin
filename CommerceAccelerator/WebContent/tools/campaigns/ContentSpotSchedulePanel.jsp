<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
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
<title><%= campaignsRB.get("contentScheduleListTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Ems.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/DateUtil.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
//
// Retrieve the schedule list data from the model, and initialize critical variables in this page.
//
var scheduleListData = parent.parent.contentSpotDataBean.initiativeSchedule;
var numberOfSchedules = scheduleListData.length;

//
// After action is completed, collateralResult object is expected to be returned from the previous panel.
// Go through each entry in the object to determine which contents should be added to the schedule
// list.
//
var collateralResult = null;
var isChangeCollateral = false;
var isAdd = true;

if (top.getData("collateralResult")) {
	collateralResult = top.getData("collateralResult");
}
if (top.getData("isChangeCollateral")) {
	isChangeCollateral = top.getData("isChangeCollateral");
}

if (collateralResult != null) {
	// if only one result got returned, put it into a new array
	if (!collateralResult.length) {
		var tempCollateralResult = collateralResult;
		collateralResult = new Array();
		collateralResult[0] = tempCollateralResult;
	}

	// go through each entry in the result array
	for (var i=0; i<collateralResult.length; i++) {
		var thisResult = collateralResult[i];

		if (isChangeCollateral) {
			// if previous action is to change a content, update the content name
			for (var j=0; j<numberOfSchedules; j++) {
				if (scheduleListData[j].collateralId == thisResult.collateralId) {
					scheduleListData[j].collateralName = collateralResult[i].collateralName;
				}
			}
			isAdd = false;
		}
		else {
			// go through each entry in the content list
			for (var j=0; j<numberOfSchedules; j++) {
				var thisSchedule = scheduleListData[j];
				// check if there is any duplicate entry ... there are 3 cases:
				// 1. duplicate found and action flag is deleteAction, then set flag to updateAction and reset all attributes
				// 2. duplicate found and action flag is destroyAction, then set flag to createAction and reset all attributes
				// 3. else, then add it to the schedule list with action flag sets to createAction
				if (thisSchedule.collateralId == thisResult.collateralId) {
					if (thisSchedule.actionFlag == "deleteAction") {
						thisSchedule.actionFlag = "updateAction";
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
					else if (thisSchedule.actionFlag == "destroyAction") {
						thisSchedule.actionFlag = "createAction";
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
			scheduleListData[numberOfSchedules].actionFlag = "createAction";
			scheduleListData[numberOfSchedules].endDate = "";
			scheduleListData[numberOfSchedules].endDay = "";
			scheduleListData[numberOfSchedules].endMonth = "";
			scheduleListData[numberOfSchedules].endTime = "";
			scheduleListData[numberOfSchedules].endYear = "";
			scheduleListData[numberOfSchedules].id = "";
			scheduleListData[numberOfSchedules].collateralId = collateralResult[i].collateralId;
			scheduleListData[numberOfSchedules].collateralName = collateralResult[i].collateralName;
			scheduleListData[numberOfSchedules].collateralStoreId = collateralResult[i].collateralStoreId;
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
	top.saveData(null, "collateralResult");
	top.saveData(null, "isChangeCollateral");
}

//
// Persists the schedule list data to the model.
//
parent.parent.contentSpotDataBean.initiativeSchedule = scheduleListData;

function loadPanelData () {
	// load the button frame
	parent.loadFrames();

	// make sure the e-marketing spot name field gets the initial focus when the page loads
	if ((parent.parent.document.contentSpotForm != undefined) && (parent.parent.document.contentSpotForm.emsName != null)) {
		if (!parent.parent.document.contentSpotForm.emsName.disabled) {
			parent.parent.document.contentSpotForm.emsName.focus();
		}
	}

	parent.parent.setReadyFlag("schedulePanel");
}

function savePanelData () {
	parent.parent.contentSpotDataBean.initiativeSchedule = scheduleListData;
}

function updateActionFlag (rowIndex) {
	if (scheduleListData[rowIndex].actionFlag == "noAction") {
		scheduleListData[rowIndex].actionFlag = "updateAction";
	}
}

function updateStartDate (rowIndex) {
	updateActionFlag(rowIndex);

	// set default time if it has not been set
	if ((trim(document.all("startYear_" + rowIndex).value) != "") &&
		(trim(document.all("startMonth_" + rowIndex).value) != "") &&
		(trim(document.all("startDay_" + rowIndex).value) != "") &&
		(trim(document.all("startTime_" + rowIndex).value) == "")) {
		document.all("startTime_" + rowIndex).value = "12:00";
	}

	scheduleListData[rowIndex].startYear = document.all("startYear_" + rowIndex).value;
	scheduleListData[rowIndex].startMonth = document.all("startMonth_" + rowIndex).value;
	scheduleListData[rowIndex].startDay = document.all("startDay_" + rowIndex).value;
	scheduleListData[rowIndex].startTime = document.all("startTime_" + rowIndex).value;
	savePanelData();
}

function updateEndDate (rowIndex) {
	updateActionFlag(rowIndex);

	// set default time if it has not been set
	if ((trim(document.all("endYear_" + rowIndex).value) != "") &&
		(trim(document.all("endMonth_" + rowIndex).value) != "") &&
		(trim(document.all("endDay_" + rowIndex).value) != "") &&
		(trim(document.all("endTime_" + rowIndex).value) == "")) {
		document.all("endTime_" + rowIndex).value = "12:00";
	}

	scheduleListData[rowIndex].endYear = document.all("endYear_" + rowIndex).value;
	scheduleListData[rowIndex].endMonth = document.all("endMonth_" + rowIndex).value;
	scheduleListData[rowIndex].endDay = document.all("endDay_" + rowIndex).value;
	scheduleListData[rowIndex].endTime = document.all("endTime_" + rowIndex).value;
	savePanelData();
}

function setupStartDate (rowIndex) {
	window.yearField = document.all("startYear_" + rowIndex);
	window.monthField = document.all("startMonth_" + rowIndex);
	window.dayField = document.all("startDay_" + rowIndex);
}

function setupEndDate (rowIndex) {
	window.yearField = document.all("endYear_" + rowIndex);
	window.monthField = document.all("endMonth_" + rowIndex);
	window.dayField = document.all("endDay_" + rowIndex);
}

function newCollateral () {
	parent.parent.persistPanelData();

	var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=campaigns.CollateralUniversalDialog&fromPanel=ems&emsName=" + parent.parent.contentSpotDataBean.emsName;
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("createCollateral")) %>", url, true);
}

function changeCollateral () {
	parent.parent.persistPanelData();

	var rowIndex = -1;

	if (arguments.length > 0) {
		rowIndex = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			if (scheduleListData[checked[0]].collateralStoreId == "<%= campaignCommandContext.getStoreId() %>") {
				rowIndex = checked[0];
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeModified")) %>");
			}
		}
	}

	if (rowIndex != -1) {
		top.saveData(true, "isChangeCollateral");
		var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=campaigns.CollateralUniversalDialog&collateralId=" + scheduleListData[rowIndex].collateralId + "&fromPanel=ems&emsName=" + parent.parent.contentSpotDataBean.emsName;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("updateCollateral")) %>", url, true);
	}
}

function addCollateral () {
	parent.parent.persistPanelData();

	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CollateralSelectionDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralSelectionPanelTitle")) %>", url, true);
}

function moveUpCollateral () {
	var checkedSchedule = parent.getChecked();
	if (checkedSchedule.length > 0) {
		for (var i=0; i<checkedSchedule.length; i++) {
			if (checkedSchedule[i] > 0) {
				var tempObject = scheduleListData[checkedSchedule[i]];
				scheduleListData[checkedSchedule[i]] = scheduleListData[checkedSchedule[i]-1];
				scheduleListData[checkedSchedule[i]-1] = tempObject;
				updateActionFlag(checkedSchedule[i]);
				updateActionFlag(checkedSchedule[i]-1);
			}
		}
	}
	savePanelData();
	parent.location.reload();
}

function moveDownCollateral () {
	var checkedSchedule = parent.getChecked();
	if (checkedSchedule.length > 0) {
		for (var i=checkedSchedule.length-1; i>=0; i--) {
			if (checkedSchedule[i] < scheduleListData.length-1) {
				var tempObject = scheduleListData[parseInt(checkedSchedule[i])];
				scheduleListData[parseInt(checkedSchedule[i])] = scheduleListData[parseInt(checkedSchedule[i])+1];
				scheduleListData[parseInt(checkedSchedule[i])+1] = tempObject;
				updateActionFlag(parseInt(checkedSchedule[i]));
				updateActionFlag(parseInt(checkedSchedule[i])+1);
			}
		}
	}
	savePanelData();
	parent.location.reload();
}

function summaryCollateral () {
	parent.parent.persistPanelData();

	var checked = parent.getChecked();
	if (checked.length > 0) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignsCollateralPreviewDialog&collateralId=" + scheduleListData[checked[0]].collateralId + "&collateralStoreId=" + scheduleListData[checked[0]].collateralStoreId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("collateralPreviewDialogTitle")) %>", url, true);
	}
}

function removeSchedule () {
	var checkedSchedule = parent.getChecked();
	var isRemovingSchedule = false;
	if (checkedSchedule.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentScheduleListDeleteConfirmation")) %>")) {
			for (var i=0; i<checkedSchedule.length; i++) {
				if ((scheduleListData[checkedSchedule[i]].storeId == "") || (scheduleListData[checkedSchedule[i]].storeId == "<%= campaignCommandContext.getStoreId() %>")) {
					if (scheduleListData[checkedSchedule[i]].actionFlag == "createAction") {
						scheduleListData[checkedSchedule[i]].actionFlag = "destroyAction";
					}
					else {
						scheduleListData[checkedSchedule[i]].actionFlag = "deleteAction";
					}
					isRemovingSchedule = true;
				}
			}
			if (isRemovingSchedule) {
				parent.parent.contentSpotDataBean.initiativeSchedule = scheduleListData;
				parent.location.reload();
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeDeleted")) %>");
			}
		}
	}
}

function adjustWindow () {
	var calFrame = document.getElementById("CalFrame");
	window.scrollTo(calFrame.offsetLeft, calFrame.offsetTop);
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content_list" style="margin-left: 0px; margin-top: 0px">

<form name="contentSpotForm" id="contentSpotForm">

<%= comm.startDlistTable((String)campaignsRB.get("contentScheduleListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentScheduleListOrderColumn"), null, false, null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentScheduleListContentColumn"), null, false, null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentScheduleListStartDateColumn"), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentScheduleListEndDateColumn"), null, false) %>
<%= comm.endDlistRow() %>

<script language="JavaScript">
<!-- hide script from old browsers
var rowselect = 1;
var numberOfSchedulesInList = 0;

for (var i=0; i<numberOfSchedules; i++) {
	if ((scheduleListData[i].actionFlag != "deleteAction") && (scheduleListData[i].actionFlag != "destroyAction")) {
		var thisSchedule = scheduleListData[i];

		var disableFlag = "";
		if ((thisSchedule.storeId != "") && (thisSchedule.storeId != "<%= campaignCommandContext.getStoreId() %>")) {
			disableFlag = "disabled";
		}

		// table row definition for the current row
		document.writeln('<tr class="list_row' + rowselect + '" onmouseover="this.className=\'list_row3\';" onmouseout="if (this.className == \'list_row3\') {this.className=\'list_row' + rowselect + '\';}">');

		// check boxes column
		addDlistCheck(i);

		// update content order value, and display the column
		if (thisSchedule.priority != numberOfSchedulesInList + 1) {
			thisSchedule.priority = numberOfSchedulesInList + 1;
			scheduleListData[i].priority = numberOfSchedulesInList + 1;
			updateActionFlag(i);
			savePanelData();
		}
		addDlistColumn(thisSchedule.priority, "none");

		// content name column
		if (thisSchedule.collateralStoreId == "<%= campaignCommandContext.getStoreId() %>") {
			addDlistColumn(thisSchedule.collateralName, "javascript:changeCollateral(" + i + ")");
		}
		else {
			addDlistColumn(thisSchedule.collateralName, "none");
		}

		// schedule start date column
		document.writeln('<td class="list_info1">');
		document.writeln('<input type="text" name="startYear_' + i + '" id="startYear_' + i + '" value="' + thisSchedule.startYear + '" size="4" maxlength="4" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="startMonth_' + i + '" id="startMonth_' + i + '" value="' + thisSchedule.startMonth + '" size="2" maxlength="2" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="startDay_' + i + '" id="startDay_' + i + '" value="' + thisSchedule.startDay + '" size="2" maxlength="2" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		if (disableFlag == "") {
			document.writeln('<a href="javascript:setupStartDate(' + i + ');showCalendar(document.contentSpotForm.calImgSD' + i + ');adjustWindow();">');
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgSD' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>"></a>');
		}
		else {
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgSD' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>">');
		}
		document.writeln('<input name="startTime_' + i + '" id="startTime_' + i + '" type="text" value="' + thisSchedule.startTime + '" size="5" maxlength="5" onChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('</td>');

		// schedule end date column
		document.writeln('<td class="list_info1">');
		document.writeln('<input type="text" name="endYear_' + i + '" id="endYear_' + i + '" value="' + thisSchedule.endYear + '" size="4" maxlength="4" onPropertyChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="endMonth_' + i + '" id="endMonth_' + i + '" value="' + thisSchedule.endMonth + '" size="2" maxlength="2" onPropertyChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="endDay_' + i + '" id="endDay_' + i + '" value="' + thisSchedule.endDay + '" size="2" maxlength="2" onPropertyChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		if (disableFlag == "") {
			document.writeln('<a href="javascript:setupEndDate(' + i + ');showCalendar(document.contentSpotForm.calImgED' + i + ');adjustWindow();">');
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgED' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>"></a>');
		}
		else {
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgED' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>">');
		}
		document.writeln('<input name="endTime_' + i + '" id="endTime_' + i + '" type="text" value="' + thisSchedule.endTime + '" size="5" maxlength="5" onChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('</td>');

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
	document.writeln('<%= UIUtil.toJavaScript((String)campaignsRB.get("contentScheduleListEmpty")) %>');
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