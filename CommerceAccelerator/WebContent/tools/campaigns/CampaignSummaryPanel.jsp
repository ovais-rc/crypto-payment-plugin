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
	import="com.ibm.commerce.tools.campaigns.CampaignConstants" %>

<%@ include file="common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("campaignSummaryDialogTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
////////////////////////////////////////////////////////////////////////////////////
// This method is used to get all the data of this campaign to display on the page.
////////////////////////////////////////////////////////////////////////////////////
function loadCampaign () {
	var campaign = parent.get("<%= CampaignConstants.ELEMENT_CAMPAIGN %>", null);

	if (campaign != null) {
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignSummaryNamePrompt")) %>", convertFromTextToHTML(campaign.<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>));
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignSummaryDescriptionPrompt")) %>", convertFromTextToHTML(campaign.<%= CampaignConstants.ELEMENT_DESCRIPTION %>));
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignSummarySponsorPrompt")) %>", convertFromTextToHTML(campaign.<%= CampaignConstants.ELEMENT_OWNER %>));
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignSummaryObjectivesPrompt")) %>", convertFromTextToHTML(campaign.<%= CampaignConstants.ELEMENT_OBJECTIVE %>));
		displayRows("<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignSummaryWebActivityPrompt")) %>", campaign.<%= CampaignConstants.ELEMENT_CAMPAIGN_INITIATIVE %>);
		displayRows("<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignSummaryEmailActivityPrompt")) %>", campaign.<%= CampaignConstants.ELEMENT_EMAIL_ACTIVITY %>);
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
// This method is used to display multiple rows on the page given the field name and
// field value.
////////////////////////////////////////////////////////////////////////////////////
function displayRows (columnName, columnValues) {
	document.writeln('<p><table border="0" cellspacing="1" cellpadding="1">');
	if (columnValues.length == 0) {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
		document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignSummarySelectedNone")) %>' + '</i></td>');
		document.writeln('	</tr>');
	}
	else {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
		document.writeln('		<td><i>' + columnValues[0].name + '</i></td>');
		document.writeln('	</tr>');
	}
	if (columnValues.length > 1) {
		for (var i=1; i<columnValues.length; i++) {
			document.writeln('	<tr>');
			document.writeln('		<td>&nbsp;</td>');
			document.writeln('		<td><i>' + columnValues[i].name + '</i></td>');
			document.writeln('	</tr>');
		}
	}
	document.writeln('</table></p>');
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

<h1><%= campaignsRB.get("campaignSummaryDialogTitle") %></h1>

<script language="JavaScript">
<!-- hide script from old browsers
loadCampaign();
//-->
</script>

</body>

</html>