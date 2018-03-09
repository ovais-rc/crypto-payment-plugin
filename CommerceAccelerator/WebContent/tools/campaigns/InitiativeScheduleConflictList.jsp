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
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeScheduleDataBean,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeScheduleListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	java.sql.Timestamp,
	java.text.DateFormat" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String scheduleListId = request.getParameter("scheduleListId");
	String emsId = request.getParameter("emsId");
	String emsName = request.getParameter("emsName");
	String initiativeId = request.getParameter("initiativeId");
	String initiativeName = request.getParameter("initiativeName");
	String priority = request.getParameter("priority");
	String startYear = request.getParameter("startYear");
	String startMonth = request.getParameter("startMonth");
	String startDay = request.getParameter("startDay");
	String startTime = request.getParameter("startTime");
	String endYear = request.getParameter("endYear");
	String endMonth = request.getParameter("endMonth");
	String endDay = request.getParameter("endDay");
	String endTime = request.getParameter("endTime");

	CampaignInitiativeScheduleListDataBean initiativeScheduleList = new CampaignInitiativeScheduleListDataBean();
	DataBeanManager.activate(initiativeScheduleList, request);
	CampaignInitiativeScheduleDataBean initiativeSchedules[] = initiativeScheduleList.getCampaignInitiativeScheduleList();

	int numberOfInitiativeSchedules = 0;
	if (initiativeSchedules != null) {
		numberOfInitiativeSchedules = initiativeSchedules.length;
	}

	// check if the current initiative exists in the array or not
	boolean thisInitiativeFound = false;
	if ((initiativeId != null) && (!initiativeId.equals(""))) {
		for (int i=0; i<numberOfInitiativeSchedules; i++) {
			if (initiativeSchedules[i].getInitiativeId().toString().equals(initiativeId)) {
				thisInitiativeFound = true;
				break;
			}
		}
	}

	// if the current initiative does not exist in the array, add one more item to the list
	if (!thisInitiativeFound) {
		numberOfInitiativeSchedules++;
	}

	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, jLocale);
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Initiative.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var allConflictsResult = top.getData("allConflictsResult", 1);
if (allConflictsResult == null) {
	allConflictsResult = new Array();
}
var resultSize = allConflictsResult.length;

function performFinish () {
	var priorityResult = new Object();
	priorityResult.scheduleListId = "<%= UIUtil.toJavaScript(scheduleListId) %>";
	priorityResult.priority = getSelectValue(document.initiativeConflictForm.<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>);

	top.sendBackData(allConflictsResult, "allConflictsResult");
	top.sendBackData(priorityResult, "priorityResult");
	top.goBack();
}

function performCancel () {
	top.goBack();
}

function loadPriority () {
	for (var i=0; i<allConflictsResult.length; i++) {
		for (var j=0; document.initiativeConflictForm.length; j++) {
			var name = document.initiativeConflictForm.elements[j].name;
			if (name == "<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>_" + allConflictsResult[i].scheduleId) {
				loadSelectValue(document.initiativeConflictForm.elements[j], allConflictsResult[i].schedulePriority);
				break;
			}
		}
	}
}

function updatePriority (scheduleId, scheduleEmsId, priorityObj) {
	var entryFound = false;
	for (var i=0; i<allConflictsResult.length; i++) {
		if (scheduleId == allConflictsResult[i].scheduleId) {
			allConflictsResult[i].schedulePriority = priorityObj.options[priorityObj.options.selectedIndex].value;
			entryFound = true;
			break;
		}
	}
	if (!entryFound) {
		allConflictsResult[resultSize] = new Object();
		allConflictsResult[resultSize].scheduleId = scheduleId;
		allConflictsResult[resultSize].scheduleEmsId = scheduleEmsId;
		allConflictsResult[resultSize].schedulePriority = priorityObj.options[priorityObj.options.selectedIndex].value;
		resultSize++;
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

function onLoad () {
	loadPriority();

	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<body onload="onLoad()" class="content_list">

<form name="initiativeConflictForm" id="initiativeConflictForm">

<%
	Timestamp startDate = null;
	Timestamp endDate = null;
	if (!startYear.equals("") && !startMonth.equals("") && !startDay.equals("") && !startTime.equals("")) {
		try {
			startDate = com.ibm.commerce.utils.TimestampHelper.parseDateTime(startYear, startMonth, startDay, startTime);
		}
		catch (Exception e) {
		}
	}
	if (!endYear.equals("") && !endMonth.equals("") && !endDay.equals("") && !endTime.equals("")) {
		try {
			endDate = com.ibm.commerce.utils.TimestampHelper.parseDateTime(endYear, endMonth, endDay, endTime);
		}
		catch (Exception e) {
		}
	}
%>

<p/><div id="scroll_title" class="scroll_title"><%= campaignsRB.get("initiativeScheduleConflictListTitle") %></div>

<p/><%= campaignsRB.get("initiativeScheduleConflictPanelEmsPrompt") %> <i><%=UIUtil.toHTML( emsName )%></i>

<p/><nobr>
<%	if (startDate != null) { %>
<%= campaignsRB.get("initiativeScheduleConflictPanelStartDatePrompt") %> <i><%= dateFormat.format(startDate) %></i>
&nbsp;&nbsp;&nbsp;
<%	} if (endDate != null) { %>
<%= campaignsRB.get("initiativeScheduleConflictPanelEndDatePrompt") %> <i><%= dateFormat.format(endDate) %></i>
<%	} %>
</nobr>

<p/>
<%= comm.startDlistTable((String)campaignsRB.get("initiativeScheduleListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_INITIATIVE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_START_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_END_DATE_COLUMN), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_PRIORITY_COLUMN), null, false) %>
<%= comm.endDlistRow() %>

<script language="JavaScript">
<!-- hide script from old browsers
// table row definition for the current row
document.writeln('<tr class="list_row1" onmouseover="this.className=\'list_row3\';" onmouseout="if (this.className == \'list_row3\') {this.className=\'list_row1\';}">');
//-->
</script>

<%= comm.addDlistColumn("<b>" + UIUtil.toHTML(initiativeName) + "</b>", "none") %>
<%	if (startDate != null) { %>
<%= comm.addDlistColumn("<b>" + dateFormat.format(startDate) + "</b>", "none") %>
<%	} else { %>
<%= comm.addDlistColumn("", "none") %>
<%	} if (endDate != null) { %>
<%= comm.addDlistColumn("<b>" + dateFormat.format(endDate) + "</b>", "none") %>
<%	} else { %>
<%= comm.addDlistColumn("", "none") %>
<%	} %>

<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<td class="list_info1">');
document.writeln('<select name="<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>" id="<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>" onClick="this.parentElement.parentElement.className=\'list_row1\';">');
document.writeln('<option value=""><%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSelectPriority")) %></option>');
document.writeln('<option value="<%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>">' + finderChangeSpecialText("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleHighestPriority")) %>", "<%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>") + '</option>');
<%	for (int i=CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM+1; i<=CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM; i++) { %>
if ("<%=UIUtil.toJavaScript( priority )%>" == "<%= i %>" ) {
	document.writeln('<option value="<%= i %>" selected><%= i %></option>');
}
else {
	document.writeln('<option value="<%= i %>"><%= i %></option>');
}
<%	} %>
document.writeln('</select>');
document.writeln('</td>');

// table row definition for the current row
document.writeln('</tr>');
//-->
</script>

<%
	int rowselect = 2;
	CampaignInitiativeScheduleDataBean initiativeSchedule;
	for (int i=0; i<initiativeSchedules.length; i++) {
		initiativeSchedule = initiativeSchedules[i];

		// if the current initiative matches this one in the current iteration, skip it
		if ((initiativeId != null) && (!initiativeId.equals(""))) {
			if (initiativeSchedule.getInitiativeId().toString().equals(initiativeId)) {
				continue;
			}
		}

		// if this schedule is not editable, then disable the priority drop-down list
		String disableFlag = "";
		if ((initiativeSchedule.getStoreId() != null) && (!initiativeSchedule.getStoreId().equals(campaignCommandContext.getStoreId()))) {
			disableFlag = "disabled";
		}

		// make sure that the current schedule priority is not out of range
		Integer thisPriority = initiativeSchedule.getPriority();
		boolean thisPriorityHasChanged = false;
		if (thisPriority != null) {
			if (thisPriority.intValue() > CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM) {
				thisPriority = new Integer(CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM);
				thisPriorityHasChanged = true;
			}
			else if (thisPriority.intValue() < CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM) {
				thisPriority = new Integer(CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM);
				thisPriorityHasChanged = true;
			}
		}
%>

<script language="JavaScript">
<!-- hide script from old browsers
// table row definition for the current row
document.writeln('<tr class="list_row<%= rowselect %>" onmouseover="this.className=\'list_row3\';" onmouseout="if (this.className == \'list_row3\') {this.className=\'list_row<%= rowselect %>\';}">');
//-->
</script>

<%= comm.addDlistColumn(UIUtil.toHTML(initiativeSchedule.getInitiativeName()), "none") %>
<%= comm.addDlistColumn(dateFormat.format(initiativeSchedule.getStartDate()), "none") %>
<%		if (initiativeSchedule.getEndDate().compareTo(CampaignConstants.TIMESTAMP_END_OF_TIME) >= 0) { %>
<%= comm.addDlistColumn((String)campaignsRB.get(CampaignConstants.MSG_NEVER), "none") %>
<%		} else { %>
<%= comm.addDlistColumn(dateFormat.format(initiativeSchedule.getEndDate()), "none") %>
<%		} %>

<script language="JavaScript">
<!-- hide script from old browsers
//
// if the current schedule is not found in allConflictsResult, and the original priority
// from the data bean is out of range, then add this schedule to allConflictsResult
//
var thisEntryFound = false;
for (var i=0; i<allConflictsResult.length; i++) {
	if (allConflictsResult[i].scheduleId == <%= initiativeSchedule.getId() %>) {
		thisEntryFound = true;
		break;
	}
}
<%		if (thisPriorityHasChanged) { %>
if (!thisEntryFound) {
	allConflictsResult[resultSize] = new Object();
	allConflictsResult[resultSize].scheduleId = <%= initiativeSchedule.getId() %>;
	allConflictsResult[resultSize].scheduleEmsId = <%= initiativeSchedule.getEMarketingSpotId() %>;
	allConflictsResult[resultSize].schedulePriority = <%= thisPriority %>;
	resultSize++;
}
<%		} %>

document.writeln('<td class="list_info1">');
document.writeln('<select name="<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>_<%= initiativeSchedule.getId() %>" id="<%= CampaignConstants.ELEMENT_SCHEDULE_PRIORITY %>_<%= initiativeSchedule.getId() %>" onClick="this.parentElement.parentElement.className=\'list_row<%= rowselect %>\';" onChange="updatePriority(<%= initiativeSchedule.getId() %>, <%= initiativeSchedule.getEMarketingSpotId() %>, this);" <%= disableFlag %>>');
document.writeln('<option value=""><%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSelectPriority")) %></option>');
document.writeln('<option value="<%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>">' + finderChangeSpecialText("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleHighestPriority")) %>", "<%= CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM %>") + '</option>');
<%
		// if the current priority is found, select this option
		for (int j=CampaignConstants.SCHEDULE_PRIORITY_RANGE_MINIMUM+1; j<=CampaignConstants.SCHEDULE_PRIORITY_RANGE_MAXIMUM; j++) {
			String selectedFlag = "";
			if (thisPriority != null) {
				if (j == thisPriority.intValue()) {
					selectedFlag = " selected";
				}
			}
%>
document.writeln('<option value="<%= j %>"<%= selectedFlag %>><%= j %></option>');
<%		} %>
document.writeln('</select>');
document.writeln('</td>');

// table row definition for the current row
document.writeln('</tr>');
//-->
</script>
<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>

<%	if (numberOfInitiativeSchedules == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SCHEDULE_LIST_EMPTY) %>
<%	} %>

</form>

</body>

</html>
