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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.ibm.commerce.tools.shipping.*" %>
<%@page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@page import="java.util.*" %>

<%@include file="ShippingCommon.jsp" %>

<%
Vector calcRulesDeleted = null;
Vector calcRulesNotDeleted = null;
Boolean calcRuleIdInvalid = null;
String calcCodeId = "";

TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
if (requestProperties != null)
 {
  calcCodeId = (String) requestProperties.get(ShippingConstants.PARAMETER_CALCCODE_ID, null);
  calcRulesDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_CALCRULES_DELETED, null);
  calcRulesNotDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_CALCRULES_NOT_DELETED, null);
  calcRuleIdInvalid = (Boolean) requestProperties.get(ShippingConstants.PARAMETER_CALCRULE_ID_INVALID, Boolean.FALSE);
 }
%>

<html>
<head>
<%= fHeader%>
<script language="JavaScript">

<%
String url = null;
if (calcRulesNotDeleted.size() == 0 && !calcRuleIdInvalid.booleanValue())
 {
    url = ShippingConstants.URL_CALCCODE_CALCRULES_LIST_VIEW  + "&" + ShippingConstants.PARAMETER_CALCCODE_ID + "=" + calcCodeId;
 }
else
 {
  url = ShippingConstants.URL_CALCRULE_DELETED_DIALOG_VIEW;
  if (calcRulesDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_CALCRULES_DELETED + "=" + calcRulesDeleted.elementAt(0);
    for (int i = 1; i < calcRulesDeleted.size(); i++)
     {
      url += ",";
      url += calcRulesDeleted.elementAt(i);
     }
   }
  if (calcRulesNotDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_CALCCODES_NOT_DELETED + "=" + calcRulesNotDeleted.elementAt(0);
    for (int i = 1; i < calcRulesNotDeleted.size(); i++)
     {
      url += ",";
      url += calcRulesNotDeleted.elementAt(i);
     }
   }
  url += "&" + ShippingConstants.PARAMETER_CALCCODE_ID_INVALID + "=" + calcRuleIdInvalid;
 }
%>
window.location.replace("<%=url%>");

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body class="content">

</body>

</html>
