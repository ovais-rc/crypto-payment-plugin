<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2004
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
	java.text.DateFormat" %>

<%@ include file="common.jsp" %>

<%
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, campaignCommandContext.getLocale());

	CampaignInitiativeScheduleListDataBean initiativeScheduleList = new CampaignInitiativeScheduleListDataBean();
	CampaignInitiativeScheduleDataBean initiativeSchedules[] = null;
	int numberOfInitiativeSchedules = 0;
	DataBeanManager.activate(initiativeScheduleList, request);
	initiativeSchedules = initiativeScheduleList.getCampaignInitiativeScheduleList();
	if (initiativeSchedules != null) {
		numberOfInitiativeSchedules = initiativeSchedules.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("emsSummaryDialogTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
////////////////////////////////////////////////////////////////////////////////////
// This method is used to get all the data of this e-marketing spot to display on
// the page.
////////////////////////////////////////////////////////////////////////////////////
function loadEms () {
	var ems = parent.get("<%= CampaignConstants.ELEMENT_EMS %>", null);

	if (ems != null) {
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsSummaryNamePrompt")) %>", ems.<%= CampaignConstants.ELEMENT_EMS_NAME %>);
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsSummaryDescriptionPrompt")) %>", convertFromTextToHTML(ems.<%= CampaignConstants.ELEMENT_DESCRIPTION %>));
		displaySupportedTypes("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsSummarySupportedTypesPrompt")) %>", ems.<%= CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES %>);
		displayScheduledInitiatives("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsSummaryScheduledInitiativesPrompt")) %>");
	}
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display a single row on the page given the field name and
// field value.
////////////////////////////////////////////////////////////////////////////////////
function displayRow (columnName, columnValue) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
	document.writeln('		<td><i>' + columnValue + '</i></td>');
	document.writeln('	</tr>');
	document.writeln('</table></p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the supported types selected in this e-marketing
// spot given the field title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displaySupportedTypes (columnName, columnValue) {
	var currentColumnValue = "";
	var columnValueLength = 0;
	if (columnValueLength != null) columnValueLength = columnValue.length;

	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');

	if (columnValueLength > 0) {
		currentColumnValue = columnValue.substring(0, 1);
		if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_PRODUCT %>") {
			document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 1)) %>' + '</i></td>');
		}
		else if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_ADVERTISEMENT %>") {
			document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 2)) %>' + '</i></td>');
		}
		else if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_CATEGORY %>") {
			document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 3)) %>' + '</i></td>');
		}
		else if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_PRODUCT_ASSOCIATION %>") {
			document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 4)) %>' + '</i></td>');
		}
	}

	document.writeln('	</tr>');

	if (columnValueLength > 1) {
		for (var i=1; i<columnValueLength; i++) {
			currentColumnValue = columnValue.substring(i, i+1);
			if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_PRODUCT %>") {
				document.writeln('	<tr>');
				document.writeln('		<td>&nbsp;</td>');
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 1)) %>' + '</i></td>');
				document.writeln('	</tr>');
			}
			else if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_ADVERTISEMENT %>") {
				document.writeln('	<tr>');
				document.writeln('		<td>&nbsp;</td>');
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 2)) %>' + '</i></td>');
				document.writeln('	</tr>');
			}
			else if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_CATEGORY %>") {
				document.writeln('	<tr>');
				document.writeln('		<td>&nbsp;</td>');
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 3)) %>' + '</i></td>');
				document.writeln('	</tr>');
			}
			else if (currentColumnValue == "<%= CampaignConstants.EMS_SUPPORTED_TYPE_PRODUCT_ASSOCIATION %>") {
				document.writeln('	<tr>');
				document.writeln('		<td>&nbsp;</td>');
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.ELEMENT_EMS_SUPPORTED_TYPES + 4)) %>' + '</i></td>');
				document.writeln('	</tr>');
			}
		}
	}

	document.writeln('</table></p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display all the initiative(s) scheduled to this
// e-marketing spot and the start date and end date of the schedule given the field
// title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displayScheduledInitiatives (columnName) {
	document.writeln('<p>');

	document.writeln('<table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
<%	if (numberOfInitiativeSchedules == 0) { %>
	document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("emsSummaryScheduledInitiativesNone")) %>' + '</i></td>');
<%	} %>
	document.writeln('	</tr>');
	document.writeln('</table><br/>');

<%	if (numberOfInitiativeSchedules > 0) { %>
	startDlistTable('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleListSummary")) %>');
	startDlistRowHeading();
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryInitiativeColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryStartDateColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryEndDateColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryPriorityColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryStatusColumn")) %>', true, 'null', null, false);
<%
		int rowselect = 1;
		CampaignInitiativeScheduleDataBean initiativeSchedule;
		for (int i=0; i<numberOfInitiativeSchedules; i++) {
			initiativeSchedule = initiativeSchedules[i];
%>
	startDlistRow(<%= rowselect %>);
	addDlistColumn('<%= UIUtil.toJavaScript(initiativeSchedule.getInitiativeName()) %>', 'none', 'font-size: 10pt;');
	addDlistColumn('<%= UIUtil.toJavaScript(dateFormat.format(initiativeSchedule.getStartDate())) %>', 'none', 'font-size: 10pt;');
<%			if (initiativeSchedule.getEndDate().compareTo(CampaignConstants.TIMESTAMP_END_OF_TIME) >= 0) { %>
	addDlistColumn('<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_NEVER)) %>', 'none', 'font-size: 10pt;');
<%			} else { %>
	addDlistColumn('<%= UIUtil.toJavaScript(dateFormat.format(initiativeSchedule.getEndDate())) %>', 'none', 'font-size: 10pt;');
<%			} %>
<%			if (initiativeSchedule.getPriority() == null) { %>
	addDlistColumn('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSelectPriority")) %>', 'none', 'font-size: 10pt;');
<%			} else { %>
	addDlistColumn('<%= UIUtil.toJavaScript(initiativeSchedule.getPriority().toString()) %>', 'none', 'font-size: 10pt;');
<%			} %>
	addDlistColumn('<%= UIUtil.toJavaScript((String)campaignsRB.get(initiativeSchedule.getInitiativeStatus())) %>', 'none', 'font-size: 10pt;');
<%
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		}
%>
	endDlistRow();
	endDlistTable();
<%	} %>

	document.writeln('</p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to load panel data and instantiate page properties.
////////////////////////////////////////////////////////////////////////////////////
function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<body class="content" onload="loadPanelData();">

<h1><%= campaignsRB.get("emsSummaryDialogTitle") %></h1>

<script language="JavaScript">
<!-- hide script from old browsers
loadEms();
//-->
</script>

</body>

</html>