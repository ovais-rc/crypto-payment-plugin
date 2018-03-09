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
Vector initiativesDeleted = new Vector();
Vector initiativesNotDeleted = new Vector();
boolean initiativeIdInvalid = false;

String initiativesDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_INITIATIVES_DELETED);
if (initiativesDeletedParameter != null)
 {
  StringTokenizer st = new StringTokenizer(initiativesDeletedParameter, ",");
  while (st.hasMoreTokens())
   {
    initiativesDeleted.addElement(st.nextToken());
   }
 }

String initiativesNotDeletedParameter = request.getParameter(CampaignConstants.PARAMETER_INITIATIVES_NOT_DELETED);
if (initiativesNotDeletedParameter != null)
 {
  StringTokenizer st = new StringTokenizer(initiativesNotDeletedParameter, ",");
  while (st.hasMoreTokens())
   {
    initiativesNotDeleted.addElement(st.nextToken());
   }
 }

String initiativeIdInvalidParameter = request.getParameter(CampaignConstants.PARAMETER_INITIATIVE_ID_INVALID);
if (initiativeIdInvalidParameter != null)
 {
  initiativeIdInvalid = CampaignUtil.toBoolean(initiativeIdInvalidParameter);
 }

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader%>
<title><%=campaignsRB.get(CampaignConstants.MSG_INITIATIVES_DELETED_DIALOG_TITLE)%></title>
<script language="JavaScript">

function initiativeList()
 {
  parent.location.replace("<%=CampaignConstants.URL_CAMPAIGN_INITIATIVES_VIEW%>");
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
boolean noInitiativesDeleted = true;
if (initiativesDeleted != null && initiativesDeleted.size() > 0)
 {
  noInitiativesDeleted = false;
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_INITIATIVES_DELETED)%>
</p><ul>
<%
  for (int i = 0; i < initiativesDeleted.size(); i++)
   {
%>
<li><%=initiativesDeleted.elementAt(i)%></li>
<%
   }
%>
</ul>
<%
 }
%>

<%
if (initiativesNotDeleted != null && initiativesNotDeleted.size() > 0)
 {
  noInitiativesDeleted = false;
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_INITIATIVES_NOT_DELETED)%>
</p><ul>
<%
  for (int i = 0; i < initiativesNotDeleted.size(); i++)
   {
%>
<li><%=initiativesNotDeleted.elementAt(i)%></li>
<%
   }
%>
</ul>
<%
 }
%>

<%
if (initiativeIdInvalid)
 {
  noInitiativesDeleted = false;
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_DELETE_INITIATIVE_ID_INVALID)%></p>
<%
 }
%>

<%
if (noInitiativesDeleted)
 {
%>
<p><%=campaignsRB.get(CampaignConstants.MSG_NO_INITIATIVES_DELETED)%></p>
<%
 }
%>

</body>

</html>
