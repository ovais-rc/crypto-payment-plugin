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
	Vector collateralDeleted = new Vector();
	Vector collateralNotDeleted = new Vector();
	boolean collateralIdInvalid = false;

	String collateralDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_COLLATERAL_DELETED);
	if (collateralDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(collateralDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			collateralDeleted.addElement(st.nextToken());
		}
	}

	String collateralNotDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_COLLATERAL_NOT_DELETED);
	if (collateralNotDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(collateralNotDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			collateralNotDeleted.addElement(st.nextToken());
		}
	}

	String collateralIdInvalidParameter = request.getParameter(CampaignConstants.PARAMETER_COLLATERAL_ID_INVALID);
	if (collateralIdInvalidParameter != null) {
		collateralIdInvalid = CampaignUtil.toBoolean(collateralIdInvalidParameter);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_COLLATERAL_DELETED_DIALOG_TITLE) %></title>

<script language="JavaScript">
function collateralList () {
	parent.location.replace("<%= CampaignConstants.URL_COLLATERAL_VIEW %>");
}

function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
</script>
</head>

<body onload="loadPanelData()" class="content">

<br/>
<%
	boolean noCollateralDeleted = true;
	if (collateralDeleted != null && collateralDeleted.size() > 0) {
		noCollateralDeleted = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_COLLATERAL_DELETED) %>
</p><ul>
<%		for (int i=0; i<collateralDeleted.size(); i++) { %>
<li><%= collateralDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%
	}
	if (collateralNotDeleted != null && collateralNotDeleted.size() > 0) {
		noCollateralDeleted = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_COLLATERAL_NOT_DELETED) %>
</p><ul>
<%		for (int i=0; i<collateralNotDeleted.size(); i++) { %>
<li><%= collateralNotDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%
	}
	if (collateralIdInvalid) {
		noCollateralDeleted = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_DELETE_COLLATERAL_ID_INVALID) %></p>
<%
	}
	if (noCollateralDeleted) {
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_NO_COLLATERAL_DELETED) %></p>
<%	} %>

</body>

</html>