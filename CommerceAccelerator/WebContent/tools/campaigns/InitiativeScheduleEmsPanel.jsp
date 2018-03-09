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
var initiativeDataBean = parent.parent.parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);
var scheduleListData = initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_EMS_SCHEDULE %>;
var numberOfSchedules = scheduleListData.length;

//
// After action is completed, emsResult object is expected to be returned from the previous panel.
// Go through each entry in the object to determine which e-Marketing Spots should be added to the
// schedule list.
//
var emsResult = top.getData("emsResult", null);
var isAdd = true;
if (emsResult != null) {
	// go through each entry in the result array
	for (var i=0; i<emsResult.length; i++) {
		var thisResult = emsResult[i];
		// go through each entry in the e-Marketing Spot list
		for (var j=0; j<numberOfSchedules; j++) {
			var thisSchedule = scheduleListData[j];
			// check if there is any duplicate entry ... there are 3 cases:
			// 1. duplicate found and action flag is deleteAction, then set flag to updateAction and reset all attributes
			// 2. duplicate found and action flag is destroyAction, then set flag to createAction and reset all attributes
			// 3. else, then add it to the schedule list with action flag sets to createAction
			if (thisSchedule.emsId == thisResult.emsId) {
				if (thisSchedule.actionFlag == "<%= CampaignConstants.ACTION_FLAG_DELETE %>") {
					thisSchedule.actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
					thisSchedule.endDate = "";
					thisSchedule.endDay = "";
					thisSchedule.endMonth = "";
					thisSchedule.endTime = "";
					thisSchedule.endYear = "";
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

		// if this schedule is supposed to be added to the list, create the new object
		// else action should have been taken, move on to the next entry in the result
		if (isAdd) {
			if (!scheduleListData) {
				scheduleListData = new Array();
			}
			scheduleListData[numberOfSchedules] = new Object;
			scheduleListData[numberOfSchedules].actionFlag = "<%= CampaignConstants.ACTION_FLAG_CREATE %>";
			scheduleListData[numberOfSchedules].emsId = emsResult[i].emsId;
			scheduleListData[numberOfSchedules].emsName = emsResult[i].emsName;
			scheduleListData[numberOfSchedules].emsStoreId = emsResult[i].emsStoreId;
			scheduleListData[numberOfSchedules].endDate = "";
			scheduleListData[numberOfSchedules].endDay = "";
			scheduleListData[numberOfSchedules].endMonth = "";
			scheduleListData[numberOfSchedules].endTime = "";
			scheduleListData[numberOfSchedules].endYear = "";
			scheduleListData[numberOfSchedules].id = "";
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
	top.saveData(null, "emsResult");
}

//
// After the e-Marketing Spot has been prioritized, priorityResult object is expected to be returned
// from the previous panel.  Update the schedule list accordingly.
//
var priorityResult = top.getData("priorityResult", null);
if (priorityResult != null) {
	if (scheduleListData[priorityResult.scheduleListId].actionFlag == "<%= CampaignConstants.ACTION_FLAG_NO_ACTION %>") {
		scheduleListData[priorityResult.scheduleListId].actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
	}
	scheduleListData[priorityResult.scheduleListId].priority = priorityResult.priority;
	top.saveData(null, "priorityResult");
}

//
// Persists the schedule list data to the model.
//
initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_EMS_SCHEDULE %> = scheduleListData;

function loadPanelData () {
	// load the button frame and set base panel ready flag
	parent.loadFrames();
	parent.parent.setReadyFlag("schedulePanel");
}

function savePanelData () {
	initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_EMS_SCHEDULE %> = scheduleListData;
}

function updateActionFlag (rowIndex) {
	if (scheduleListData[rowIndex].actionFlag == "<%= CampaignConstants.ACTION_FLAG_NO_ACTION %>") {
		scheduleListData[rowIndex].actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
	}
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

function addEms () {
	parent.parent.persistPanelData();

	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.EmsSelectionDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsSelectionPanelTitle")) %>", url, true);
}

function prioritizeEms () {
	parent.parent.persistPanelData();

	var checkedSchedule = parent.getChecked();
	if (checkedSchedule.length > 0) {
		var url = "DialogView";
		var urlParam = new Object();
		urlParam.ActionXMLFile = "campaigns.InitiativeScheduleConflictList";
		urlParam.XMLFile = "campaigns.InitiativeScheduleConflictDialog";
		urlParam.cmd = "CampaignInitiativeScheduleConflictListView";
		urlParam.scheduleListId = checkedSchedule[0];
		urlParam.emsId = scheduleListData[checkedSchedule[0]].emsId;
		urlParam.emsName = scheduleListData[checkedSchedule[0]].emsName;
		urlParam.initiativeId = initiativeDataBean.id;
		urlParam.initiativeName = parent.parent.document.initiativeForm.<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>.value;
		urlParam.priority = scheduleListData[checkedSchedule[0]].priority;
		urlParam.startYear = scheduleListData[checkedSchedule[0]].startYear;
		urlParam.startMonth = scheduleListData[checkedSchedule[0]].startMonth;
		urlParam.startDay = scheduleListData[checkedSchedule[0]].startDay;
		urlParam.startTime = scheduleListData[checkedSchedule[0]].startTime;
		urlParam.endYear = scheduleListData[checkedSchedule[0]].endYear;
		urlParam.endMonth = scheduleListData[checkedSchedule[0]].endMonth;
		urlParam.endDay = scheduleListData[checkedSchedule[0]].endDay;
		urlParam.endTime = scheduleListData[checkedSchedule[0]].endTime;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleConflictPanelTitle")) %>", url, true, urlParam);
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
				initiativeDataBean.<%= CampaignConstants.ELEMENT_INITIATIVE_EMS_SCHEDULE %> = scheduleListData;
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

<body onload="loadPanelData()" class="content_list" style="margin-left: 0px">

<form name="initiativeEmsForm" id="initiativeEmsForm">

<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_EMS_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_START_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_END_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_PRIORITY_COLUMN), null, false) %>
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

		var thisPriority = scheduleListData[i].priority;
		if (!isNaN(parseInt(thisPriority))) {
			if (thisPriority > <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM %>) {
				thisPriority = <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM %>;
			}
			else if (thisPriority < <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>) {
				thisPriority = <%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>;
			}
		}
		else {
			thisPriority = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSelectPriority")) %>";
		}

		startDlistRow(rowselect);

		// check boxes column
		addDlistCheck(i);

		// e-Marketing Spot name column
		addDlistColumn(thisSchedule.emsName, "none");

		// schedule start date column
		document.writeln('<td class="list_info1">');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_START_YEAR %>_' + i + '" id="<%= CampaignConstants.ELEMENT_START_YEAR %>_' + i + '" value="' + thisSchedule.startYear + '" size="4" maxlength="4" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_START_MONTH %>_' + i + '" id="<%= CampaignConstants.ELEMENT_START_MONTH %>_' + i + '" value="' + thisSchedule.startMonth + '" size="2" maxlength="2" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('<input type="text" name="<%= CampaignConstants.ELEMENT_START_DAY %>_' + i + '" id="<%= CampaignConstants.ELEMENT_START_DAY %>_' + i + '" value="' + thisSchedule.startDay + '" size="2" maxlength="2" onPropertyChange="updateStartDate(' + i + ');" ' + disableFlag + '>');
		if (disableFlag == "") {
			document.writeln('<a href="javascript:setupStartDate(' + i + ');showCalendar(document.initiativeEmsForm.calImgSD' + i + ');adjustWindow();">');
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
			document.writeln('<a href="javascript:setupEndDate(' + i + ');showCalendar(document.initiativeEmsForm.calImgED' + i + ');adjustWindow();">');
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgED' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>"></a>');
		}
		else {
			document.writeln('<img src="/wcs/images/tools/calendar/calendar.gif" border="0" id="calImgED' + i + '" alt="<%= UIUtil.toJavaScript((String)campaignsRB.get("calendarTool")) %>">');
		}
		document.writeln('<input name="<%= CampaignConstants.ELEMENT_END_TIME %>_' + i + '" id="<%= CampaignConstants.ELEMENT_END_TIME %>_' + i + '" type="text" value="' + thisSchedule.endTime + '" size="5" maxlength="5" onChange="updateEndDate(' + i + ');" ' + disableFlag + '>');
		document.writeln('</td>');

		// schedule priority column
		addDlistColumn(thisPriority, "none");

		endDlistRow();

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
	document.writeln('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleConflictListEmpty")) %>');
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
//-->
</script>

</body>

</html>