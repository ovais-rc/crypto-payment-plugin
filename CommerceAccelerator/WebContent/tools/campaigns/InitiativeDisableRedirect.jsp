<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
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
	com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="common.jsp" %>

<%
	Vector initiativesDisabled = null;
	Vector initiativesNotDisabled = null;
	Boolean initiativeIdInvalid = null;
	String viewType = null;
	String campaignId = null;

	TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		initiativesDisabled = (Vector) requestProperties.get(CampaignConstants.PARAMETER_INITIATIVES_DISABLED, null);
		initiativesNotDisabled = (Vector) requestProperties.get(CampaignConstants.PARAMETER_INITIATIVES_NOT_DISABLED, null);
		initiativeIdInvalid = (Boolean) requestProperties.get(CampaignConstants.PARAMETER_INITIATIVE_ID_INVALID, Boolean.FALSE);
		viewType = (String) requestProperties.get(CampaignConstants.PARAMETER_VIEW_TYPE, "");
		campaignId = (String) requestProperties.get(CampaignConstants.PARAMETER_CAMPAIGN_ID, "");
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<script language="JavaScript">
<!-- hide script from old browsers
<%
	String url = null;
	if (initiativesNotDisabled.size() == 0 && !initiativeIdInvalid.booleanValue()) {
		url = CampaignConstants.URL_CAMPAIGN_INITIATIVES_VIEW + "&viewType=" + viewType + "&campaignId=" + campaignId;
	}
	else {
		url = CampaignConstants.URL_CAMPAIGN_INITIATIVES_DISABLED_DIALOG_VIEW;
		if (initiativesDisabled.size() > 0) {
			url += "&" + CampaignConstants.PARAMETER_INITIATIVES_DISABLED + "=" + initiativesDisabled.elementAt(0);
			for (int i=1; i<initiativesDisabled.size(); i++) {
				url += ",";
				url += initiativesDisabled.elementAt(i);
			}
		}
		if (initiativesNotDisabled.size() > 0) {
			url += "&" + CampaignConstants.PARAMETER_INITIATIVES_NOT_DISABLED + "=" + initiativesNotDisabled.elementAt(0);
			for (int i=1; i<initiativesNotDisabled.size(); i++) {
				url += ",";
				url += initiativesNotDisabled.elementAt(i);
			}
		}
		url += "&" + CampaignConstants.PARAMETER_INITIATIVE_ID_INVALID + "=" + initiativeIdInvalid;
	}
%>
window.location.replace("<%= url %>");
//-->
</script>
</head>

<body class="content">
</body>

</html>