<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.datatype.TypedProperty,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.util.ResourceDirectory,
	java.util.Hashtable,
	java.util.Vector" %>

<%@ include file="common.jsp" %>

<%
	Vector initiativesDisabled = new Vector();
	Vector initiativesNotDisabled = new Vector();
	boolean initiativeIdInvalid = false;

	String initiativesDisabledParameter = request.getParameter(CampaignConstants.PARAMETER_INITIATIVES_DISABLED);
	if (initiativesDisabledParameter != null) {
		StringTokenizer st = new StringTokenizer(initiativesDisabledParameter, ",");
		while (st.hasMoreTokens()) {
			initiativesDisabled.addElement(st.nextToken());
		}
	}

	String initiativesNotDisabledParameter = request.getParameter(CampaignConstants.PARAMETER_INITIATIVES_NOT_DISABLED);
	if (initiativesNotDisabledParameter != null) {
		StringTokenizer st = new StringTokenizer(initiativesNotDisabledParameter, ",");
		while (st.hasMoreTokens()) {
			initiativesNotDisabled.addElement(st.nextToken());
		}
	}

	String initiativeIdInvalidParameter = request.getParameter(CampaignConstants.PARAMETER_INITIATIVE_ID_INVALID);
	if (initiativeIdInvalidParameter != null) {
		initiativeIdInvalid = CampaignUtil.toBoolean(initiativeIdInvalidParameter);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVES_DISABLED_DIALOG_TITLE) %></title>

<script language="JavaScript">
<!---- hide script from old browsers
function initiativeList () {
	parent.location.replace("<%= CampaignConstants.URL_CAMPAIGN_INITIATIVES_VIEW %>");
}

function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content">

<br/>

<%
	boolean noInitiativesDisabled = true;
	if (initiativesDisabled != null && initiativesDisabled.size() > 0) {
		noInitiativesDisabled = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVES_DISABLED) %>
</p><ul>
<%		for (int i=0; i<initiativesDisabled.size(); i++) { %>
<li><%= initiativesDisabled.elementAt(i) %></li>
<%		} %>
</ul>
<%	} %>

<%
	if (initiativesNotDisabled != null && initiativesNotDisabled.size() > 0) {
		noInitiativesDisabled = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVES_NOT_DISABLED) %>
</p><ul>
<%		for (int i=0; i<initiativesNotDisabled.size(); i++) { %>
<li><%= initiativesNotDisabled.elementAt(i) %></li>
<%		} %>
</ul>
<%	} %>

<%
	if (initiativeIdInvalid) {
		noInitiativesDisabled = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_DISABLE_INITIATIVE_ID_INVALID) %></p>
<%	} %>

<%	if (noInitiativesDisabled) { %>
<p><%= campaignsRB.get(CampaignConstants.MSG_NO_INITIATIVES_DISABLED) %></p>
<%	} %>

</body>

</html>