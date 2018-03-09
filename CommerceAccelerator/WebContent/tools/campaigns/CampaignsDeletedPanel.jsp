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
import="com.ibm.commerce.datatype.TypedProperty,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.util.ResourceDirectory,
	java.util.Hashtable,
	java.util.Vector" %>

<%@include file="common.jsp" %>

<%
Vector campaignsDeleted = new Vector();
Vector campaignsNotDeleted = new Vector();
boolean campaignIdInvalid = false;

String campaignsDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_CAMPAIGNS_DELETED);
if (campaignsDeletedParameter != null)
 {
  StringTokenizer st = new StringTokenizer(campaignsDeletedParameter, ",");
  while (st.hasMoreTokens())
   {
    campaignsDeleted.addElement(st.nextToken());
   }
 }

String campaignsNotDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_CAMPAIGNS_NOT_DELETED);
if (campaignsNotDeletedParameter != null)
 {
  StringTokenizer st = new StringTokenizer(campaignsNotDeletedParameter, ",");
  while (st.hasMoreTokens())
   {
    campaignsNotDeleted.addElement(st.nextToken());
   }
 }

String campaignIdInvalidParameter = request.getParameter(CampaignConstants.PARAMETER_CAMPAIGN_ID_INVALID);
if (campaignIdInvalidParameter != null)
 {
  campaignIdInvalid = CampaignUtil.toBoolean(campaignIdInvalidParameter);
 }

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader%>
<title><%=campaignsRB.get(CampaignConstants.MSG_CAMPAIGNS_DELETED_DIALOG_TITLE)%></title>
<script language="JavaScript">

function campaignList()
 {
  parent.location.replace("<%=CampaignConstants.URL_CAMPAIGNS_VIEW%>");
 }

function loadPanelData()
 {
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }

</script>
</head>

<body onload="loadPanelData()" class="content">

<br/>

<%
boolean noCampaignsDeleted = true;
if (campaignsDeleted != null && campaignsDeleted.size() > 0)
 {
  noCampaignsDeleted = false;
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_CAMPAIGNS_DELETED)%>
</p><ul>
<%
  for (int i = 0; i < campaignsDeleted.size(); i++)
   {
%>
<li><%=campaignsDeleted.elementAt(i)%></li>
<%
   }
%>
</ul>
<%
 }
%>

<%
if (campaignsNotDeleted != null && campaignsNotDeleted.size() > 0)
 {
  noCampaignsDeleted = false;
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_CAMPAIGNS_NOT_DELETED)%>
</p><ul>
<%
  for (int i = 0; i < campaignsNotDeleted.size(); i++)
   {
%>
<li><%=campaignsNotDeleted.elementAt(i)%></li>
<%
   }
%>
</ul>
<%
 }
%>

<%
if (campaignIdInvalid)
 {
  noCampaignsDeleted = false;
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_DELETE_CAMPAIGN_ID_INVALID)%></p>
<%
 }
%>

<%
if (noCampaignsDeleted)
 {
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_NO_CAMPAIGNS_DELETED)%></p>
<%
 }
%>

</body>

</html>
