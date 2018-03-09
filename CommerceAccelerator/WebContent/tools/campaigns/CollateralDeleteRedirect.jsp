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
	Vector collateralDeleted = null;
	Vector collateralNotDeleted = null;
	Boolean collateralIdInvalid = null;

	TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		collateralDeleted = (Vector) requestProperties.get(CampaignConstants.PARAMETER_COLLATERAL_DELETED, null);
		collateralNotDeleted = (Vector) requestProperties.get(CampaignConstants.PARAMETER_COLLATERAL_NOT_DELETED, null);
		collateralIdInvalid = (Boolean) requestProperties.get(CampaignConstants.PARAMETER_COLLATERAL_ID_INVALID, Boolean.FALSE);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<script language="JavaScript">
<%
	String url = null;
	if (collateralNotDeleted.size() == 0 && !collateralIdInvalid.booleanValue()) {
		url = CampaignConstants.URL_COLLATERAL_VIEW;
	}
	else {
		url = CampaignConstants.URL_COLLATERAL_DELETED_DIALOG_VIEW;
		if (collateralDeleted.size() > 0) {
			url += "&" + CampaignConstants.PARAMETER_COLLATERAL_DELETED + "=" + collateralDeleted.elementAt(0);
			for (int i=1; i<collateralDeleted.size(); i++) {
				url += ",";
				url += collateralDeleted.elementAt(i);
			}
		}
		if (collateralNotDeleted.size() > 0) {
			url += "&" + CampaignConstants.PARAMETER_COLLATERAL_NOT_DELETED + "=" + collateralNotDeleted.elementAt(0);
			for (int i=1; i<collateralNotDeleted.size(); i++) {
				url += ",";
				url += collateralNotDeleted.elementAt(i);
			}
		}
		url += "&" + CampaignConstants.PARAMETER_COLLATERAL_ID_INVALID + "=" + collateralIdInvalid;
	}
%>
window.location.replace("<%= url %>");
</script>
</head>

<body class="content">

</body>

</html>