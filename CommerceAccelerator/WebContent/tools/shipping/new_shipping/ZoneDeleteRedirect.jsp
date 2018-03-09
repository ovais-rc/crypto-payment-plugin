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
Vector zonesDeleted = null;
Vector zonesNotDeleted = null;
Boolean zoneIdInvalid = null;

TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
if (requestProperties != null)
 {
  zonesDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_ZONES_DELETED, null);
  zonesNotDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_ZONES_NOT_DELETED, null);
  zoneIdInvalid = (Boolean) requestProperties.get(ShippingConstants.PARAMETER_ZONE_ID_INVALID, Boolean.FALSE);
 }
%>

<html>
<head>
<%= fHeader%>
<script language="JavaScript">

<%
String url = null;
if (zonesNotDeleted.size() == 0 && !zoneIdInvalid.booleanValue())
 {
  url = ShippingConstants.URL_ZONE_LIST_VIEW;
 }
else
 {
  url = ShippingConstants.URL_ZONE_DELETED_DIALOG_VIEW;
  if (zonesDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_ZONES_DELETED + "=" + zonesDeleted.elementAt(0);
    for (int i = 1; i < zonesDeleted.size(); i++)
     {
      url += ",";
      url += zonesDeleted.elementAt(i);
     }
   }
  if (zonesNotDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_ZONES_NOT_DELETED + "=" + zonesNotDeleted.elementAt(0);
    for (int i = 1; i < zonesNotDeleted.size(); i++)
     {
      url += ",";
      url += zonesNotDeleted.elementAt(i);
     }
   }
  url += "&" + ShippingConstants.PARAMETER_ZONE_ID_INVALID + "=" + zoneIdInvalid;
 }
%>
window.location.replace("<%=url%>");

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body class="content">

</body>

</html>
