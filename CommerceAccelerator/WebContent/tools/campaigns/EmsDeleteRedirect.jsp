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
	import="com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.datatype.TypedProperty,
	java.util.Vector" %>

<%@ include file="common.jsp" %>

<%
	Vector emsDeleted = null;
	Vector emsNotDeleted = null;
	Boolean emsIdInvalid = null;

	TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		emsDeleted = (Vector) requestProperties.get(CampaignConstants.PARAMETER_EMS_DELETED, null);
		emsNotDeleted = (Vector) requestProperties.get(CampaignConstants.PARAMETER_EMS_NOT_DELETED, null);
		emsIdInvalid = (Boolean) requestProperties.get(CampaignConstants.PARAMETER_EMS_ID_INVALID, Boolean.FALSE);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<script language="JavaScript">
<%
	String url = null;
	if (emsNotDeleted.size() == 0 && !emsIdInvalid.booleanValue()) {
		url = CampaignConstants.URL_EMS_VIEW;
	}
	else {
		url = CampaignConstants.URL_EMS_DELETED_DIALOG_VIEW;
		if (emsDeleted.size() > 0) {
			url += "&" + CampaignConstants.PARAMETER_EMS_DELETED + "=" + emsDeleted.elementAt(0);
			for (int i=1; i<emsDeleted.size(); i++) {
				url += ",";
				url += emsDeleted.elementAt(i);
			}
		}
		if (emsNotDeleted.size() > 0) {
			url += "&" + CampaignConstants.PARAMETER_EMS_NOT_DELETED + "=" + emsNotDeleted.elementAt(0);
			for (int i=1; i<emsNotDeleted.size(); i++) {
				url += ",";
				url += emsNotDeleted.elementAt(i);
			}
		}
		url += "&" + CampaignConstants.PARAMETER_EMS_ID_INVALID + "=" + emsIdInvalid;
	}
%>
window.location.replace("<%= url %>");
</script>
</head>

<body class="content">

</body>

</html>