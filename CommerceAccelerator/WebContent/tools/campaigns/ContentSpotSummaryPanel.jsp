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
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeScheduleDataBean,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeScheduleListDataBean,
	java.text.DateFormat" %>

<%@ include file="common.jsp" %>

<%
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, campaignCommandContext.getLocale());

	CampaignInitiativeScheduleListDataBean contentScheduleList = new CampaignInitiativeScheduleListDataBean();
	CampaignInitiativeScheduleDataBean contentSchedules[] = null;
	int numberOfContentSchedules = 0;
	DataBeanManager.activate(contentScheduleList, request);
	contentSchedules = contentScheduleList.getCampaignInitiativeScheduleList();
	if (contentSchedules != null) {
		numberOfContentSchedules = contentSchedules.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("contentSpotSummaryDialogTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
////////////////////////////////////////////////////////////////////////////////////
// This method is used to get all the data of this content spot to display on
// the page.
////////////////////////////////////////////////////////////////////////////////////
function loadContentSpot () {
	var contentSpot = parent.get("ems", null);

	if (contentSpot != null) {
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotSummaryNamePrompt")) %>", contentSpot.emsName);
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotSummaryDescriptionPrompt")) %>", convertFromTextToHTML(contentSpot.description));
		displayScheduledContents("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotSummaryScheduledContentsPrompt")) %>");
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
// This method is used to display all the content(s) scheduled to this content spot
// and the start date and end date of the schedule given the field title and its
// value.
////////////////////////////////////////////////////////////////////////////////////
function displayScheduledContents (columnName) {
	document.writeln('<p>');

	document.writeln('<table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
<%	if (numberOfContentSchedules == 0) { %>
	document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotSummaryScheduledContentsNone")) %>' + '</i></td>');
<%	} %>
	document.writeln('	</tr>');
	document.writeln('</table><br/>');

<%	if (numberOfContentSchedules > 0) { %>
	startDlistTable('<%= UIUtil.toJavaScript((String)campaignsRB.get("contentScheduleListSummary")) %>');
	startDlistRowHeading();
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("contentScheduleListOrderColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("contentScheduleListContentColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("contentScheduleListStartDateColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("contentScheduleListEndDateColumn")) %>', true, 'null', null, false);
<%
		int rowselect = 1;
		CampaignInitiativeScheduleDataBean contentSchedule;
		for (int i=0; i<numberOfContentSchedules; i++) {
			contentSchedule = contentSchedules[i];
%>
	startDlistRow(<%= rowselect %>);
	addDlistColumn('<%= UIUtil.toJavaScript(contentSchedule.getPriority().toString()) %>', 'none', 'font-size: 10pt;');
	addDlistColumn('<%= UIUtil.toJavaScript(contentSchedule.getCollateralName()) %>', 'none', 'font-size: 10pt;');
	addDlistColumn('<%= UIUtil.toJavaScript(dateFormat.format(contentSchedule.getStartDate())) %>', 'none', 'font-size: 10pt;');
<%			if (contentSchedule.getEndDate().compareTo(CampaignConstants.TIMESTAMP_END_OF_TIME) >= 0) { %>
	addDlistColumn('<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_NEVER)) %>', 'none', 'font-size: 10pt;');
<%			} else { %>
	addDlistColumn('<%= UIUtil.toJavaScript(dateFormat.format(contentSchedule.getEndDate())) %>', 'none', 'font-size: 10pt;');
<%
			}
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

<h1><%= campaignsRB.get("contentSpotSummaryDialogTitle") %></h1>

<script language="JavaScript">
<!-- hide script from old browsers
loadContentSpot();
//-->
</script>

</body>

</html>