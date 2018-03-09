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
Vector calcCodesDeleted = null;
Vector calcCodesNotDeleted = null;
Boolean calcCodeIdInvalid = null;

TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
if (requestProperties != null)
 {
  calcCodesDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_CALCCODES_DELETED, null);
  calcCodesNotDeleted = (Vector) requestProperties.get(ShippingConstants.PARAMETER_CALCCODES_NOT_DELETED, null);
  calcCodeIdInvalid = (Boolean) requestProperties.get(ShippingConstants.PARAMETER_CALCCODE_ID_INVALID, Boolean.FALSE);
 }
%>

<html>
<head>
<%= fHeader%>
<script language="JavaScript">

<%
String url = null;
if (calcCodesNotDeleted.size() == 0 && !calcCodeIdInvalid.booleanValue())
 {
  url = ShippingConstants.URL_CALCCODE_LIST_VIEW;
 }
else
 {
  url = ShippingConstants.URL_CALCCODE_DELETED_DIALOG_VIEW;
  if (calcCodesDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_CALCCODES_DELETED + "=" + calcCodesDeleted.elementAt(0);
    for (int i = 1; i < calcCodesDeleted.size(); i++)
     {
      url += ",";
      url += calcCodesDeleted.elementAt(i);
     }
   }
  if (calcCodesNotDeleted.size() > 0)
   {
    url += "&" + ShippingConstants.PARAMETER_CALCCODES_NOT_DELETED + "=" + calcCodesNotDeleted.elementAt(0);
    for (int i = 1; i < calcCodesNotDeleted.size(); i++)
     {
      url += ",";
      url += calcCodesNotDeleted.elementAt(i);
     }
   }
  url += "&" + ShippingConstants.PARAMETER_CALCCODE_ID_INVALID + "=" + calcCodeIdInvalid;
 }
%>
window.location.replace("<%=url%>");

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body class="content">

</body>

</html>
