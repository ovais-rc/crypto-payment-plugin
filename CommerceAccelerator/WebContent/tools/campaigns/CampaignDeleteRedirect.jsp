<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page language="java"
import="com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.datatype.TypedProperty,
	java.util.Vector" %>

<%@include file="common.jsp" %>

<%
Vector campaignsDeleted = null;
Vector campaignsNotDeleted = null;
Boolean campaignIdInvalid = null;

TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
if (requestProperties != null)
 {
  campaignsDeleted = (Vector) requestProperties.get(CampaignConstants.PARAMETER_CAMPAIGNS_DELETED, null);
  campaignsNotDeleted = (Vector) requestProperties.get(CampaignConstants.PARAMETER_CAMPAIGNS_NOT_DELETED, null);
  campaignIdInvalid = (Boolean) requestProperties.get(CampaignConstants.PARAMETER_CAMPAIGN_ID_INVALID, Boolean.FALSE);
 }
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader%>
<script language="JavaScript">

<%
String url = null;
if (campaignsNotDeleted.size() == 0 && !campaignIdInvalid.booleanValue())
 {
  url = CampaignConstants.URL_CAMPAIGNS_VIEW;
 }
else
 {
  url = CampaignConstants.URL_CAMPAIGNS_DELETED_DIALOG_VIEW;
  if (campaignsDeleted.size() > 0)
   {
    url += "&" + CampaignConstants.PARAMETER_CAMPAIGNS_DELETED + "=" + campaignsDeleted.elementAt(0);
    for (int i = 1; i < campaignsDeleted.size(); i++)
     {
      url += ",";
      url += campaignsDeleted.elementAt(i);
     }
   }
  if (campaignsNotDeleted.size() > 0)
   {
    url += "&" + CampaignConstants.PARAMETER_CAMPAIGNS_NOT_DELETED + "=" + campaignsNotDeleted.elementAt(0);
    for (int i = 1; i < campaignsNotDeleted.size(); i++)
     {
      url += ",";
      url += campaignsNotDeleted.elementAt(i);
     }
   }
  url += "&" + CampaignConstants.PARAMETER_CAMPAIGN_ID_INVALID + "=" + campaignIdInvalid;
 }
%>
window.location.replace("<%=url%>");

</script>
</head>

<body class="content">

</body>

</html>
