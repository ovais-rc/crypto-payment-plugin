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
Vector shipjrulesDeleted = null;
Vector shipjrulesNotDeleted = null;
Boolean shipjrulIdInvalid = null;

TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
if (requestProperties != null)
 {
  shipjrulesDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_SHPJRULES_DELETED, null);
  shipjrulesNotDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_SHPJRULES_NOT_DELETED, null);
  shipjrulIdInvalid = (Boolean) requestProperties.get(ShippingConstants.PARAMETER_SHPJRULE_ID_INVALID, Boolean.FALSE);
 }
%>

<html>
<head>
<%= fHeader%>
<script language="JavaScript">

<%
String url = null;
if (shipjrulesNotDeleted.size() == 0 && !shipjrulIdInvalid.booleanValue())
 {
  url = ShippingConstants.URL_SHPJRULES_LIST_VIEW;
 }
else
 {
  url = ShippingConstants.URL_SHPJRULE_DELETED_DIALOG_VIEW;
  if (shipjrulesDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_SHPJRULES_DELETED + "=" + shipjrulesDeleted.elementAt(0);
    for (int i = 1; i < shipjrulesDeleted.size(); i++)
     {
      url += ",";
      url += shipjrulesDeleted.elementAt(i);
     }
   }
  if (shipjrulesNotDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_SHPJRULES_NOT_DELETED + "=" + shipjrulesNotDeleted.elementAt(0);
    for (int i = 1; i < shipjrulesNotDeleted.size(); i++)
     {
      url += ",";
      url += shipjrulesNotDeleted.elementAt(i);
     }
   }
  url += "&" + ShippingConstants.PARAMETER_SHPJRULE_ID_INVALID + "=" + shipjrulIdInvalid;
 }
%>
window.location.replace("<%=url%>");

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body class="content">

</body>

</html>
