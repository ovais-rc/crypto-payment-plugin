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
	Vector emsDeleted = new Vector();
	Vector emsNotDeleted = new Vector();
	boolean emsIdInvalid = false;

	String emsDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_EMS_DELETED);
	if (emsDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(emsDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			emsDeleted.addElement(st.nextToken());
		}
	}

	String emsNotDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_EMS_NOT_DELETED);
	if (emsNotDeletedParameter != null) {
		StringTokenizer st = new StringTokenizer(emsNotDeletedParameter, ",");
		while (st.hasMoreTokens()) {
			emsNotDeleted.addElement(st.nextToken());
		}
	}

	String emsIdInvalidParameter = request.getParameter(CampaignConstants.PARAMETER_EMS_ID_INVALID);
	if (emsIdInvalidParameter != null) {
		emsIdInvalid = CampaignUtil.toBoolean(emsIdInvalidParameter);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_EMS_DELETED_DIALOG_TITLE) %></title>
<script language="JavaScript">
function emsList () {
	parent.location.replace("<%= CampaignConstants.URL_EMS_VIEW %>");
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
	boolean noEmsDeleted = true;
	if (emsDeleted != null && emsDeleted.size() > 0) {
		noEmsDeleted = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_EMS_DELETED) %>
</p><ul>
<%		for (int i=0; i<emsDeleted.size(); i++) { %>
<li><%= emsDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%
	}
	if (emsNotDeleted != null && emsNotDeleted.size() > 0) {
		noEmsDeleted = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_EMS_NOT_DELETED) %>
</p><ul>
<%		for (int i=0; i<emsNotDeleted.size(); i++) { %>
<li><%= emsNotDeleted.elementAt(i) %></li>
<%		} %>
</ul>
<%
	}
	if (emsIdInvalid) {
		noEmsDeleted = false;
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_DELETE_EMS_ID_INVALID) %></p>
<%
	}
	if (noEmsDeleted) {
%>
<p><%= campaignsRB.get(CampaignConstants.MSG_NO_EMS_DELETED) %></p>
<%	} %>

</body>

</html>