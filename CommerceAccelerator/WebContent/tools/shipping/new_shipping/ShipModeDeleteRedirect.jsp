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
Vector shipModesDeleted = null;
Vector shipModesNotDeleted = null;
Boolean shipModeIdInvalid = null;

TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
if (requestProperties != null)
 {
  shipModesDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_SHIPMODES_DELETED, null);
  shipModesNotDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_SHIPMODES_NOT_DELETED, null);
  shipModeIdInvalid = (Boolean) requestProperties.get(ShippingConstants.PARAMETER_SHIPMODE_ID_INVALID, Boolean.FALSE);
 }
%>

<html>
<head>
<%= fHeader%>
<script language="JavaScript">

<%
String url = null;
if (shipModesNotDeleted.size() == 0 && !shipModeIdInvalid.booleanValue())
 {
  url = ShippingConstants.URL_SHIPMODE_LIST_VIEW;
 }
else
 {
  url = ShippingConstants.URL_SHIPMODE_DELETED_DIALOG_VIEW;
  if (shipModesDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_SHIPMODES_DELETED + "=" + shipModesDeleted.elementAt(0);
    for (int i = 1; i < shipModesDeleted.size(); i++)
     {
      url += ",";
      url += shipModesDeleted.elementAt(i);
     }
   }
  if (shipModesNotDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_SHIPMODES_NOT_DELETED + "=" + shipModesNotDeleted.elementAt(0);
    for (int i = 1; i < shipModesNotDeleted.size(); i++)
     {
      url += ",";
      url += shipModesNotDeleted.elementAt(i);
     }
   }
  url += "&" + ShippingConstants.PARAMETER_SHIPMODE_ID_INVALID + "=" + shipModeIdInvalid;
 }
%>
window.location.replace("<%=url%>");

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body class="content">

</body>

</html>
