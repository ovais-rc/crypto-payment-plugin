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
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="ShippingCommon.jsp" %>

<% CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT); %>
<html>
<head>
<%= fHeader %>
<title><%= shippingRB.get(ShippingConstants.MSG_SHIPMENU_TITLE) %></title>
<meta name="GENERATOR" content="IBM WebSphere Studio">
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
</head>

<SCRIPT LANGUAGE="JavaScript">
function changeZones() {
	var url = "ZonesView?ActionXMLFile=shipping.ZonesList&cmd=ZonesListView";
	top.setContent("<%=UIUtil.toJavaScript((String)shippingRB.get("ZonesList")) %>", url, true);
}

function changeModes() {
	var url = "ShipModesView?ActionXMLFile=shipping.ShipModesList&cmd=ShipModesListView";
	top.setContent("<%=UIUtil.toJavaScript((String)shippingRB.get("shipModesListTitle")) %>", url, true);
}

function changeCodes() {
	var url = "CalcCodesView?ActionXMLFile=shipping.CalcCodesList&cmd=CalcCodesListView";
	top.setContent("<%=UIUtil.toJavaScript((String)shippingRB.get("calcCodesListTitle")) %>", url, true);
}
</SCRIPT>

<body class="entry" BGCOLOR="FFFFFF">
<table BORDER="0" >

    <tr>
    <td class="entry_text" VALIGN="TOP" width="20"></td>
    <td class="h1"><%= UIUtil.toHTML((String)shippingRB.get("shipping")) %></td>
    </tr>

    <tr>
    <td class="entry_text" VALIGN="TOP" width="20"></td>
    <td class="entry_text"><%= UIUtil.toHTML((String)shippingRB.get("shippingDesc")) %></td>
    </tr>
</TABLE>
<TABLE BORDER="0">
     
      <tr><td><br></td></tr>
      <tr>
      <td class="entry_text" VALIGN="TOP" width="20"></td>
      <td valign="TOP" nowrap><a href="javascript:changeZones()"><%= shippingRB.get(ShippingConstants.MSG_ZONES_MENU) %></a>:</td>
      <td class="entry_text" VALIGN="TOP" width="10"></td>
      <td><%= shippingRB.get("paragraph1") %></td>
      </tr>
      <tr><td><br></td></tr>
      <tr>
      <td class="entry_text" VALIGN="TOP" width="20"></td>
      <td valign="TOP" nowrap><a href="javascript:changeModes()"><%= shippingRB.get(ShippingConstants.MSG_MODES_MENU) %></a>:</td>
      <td class="entry_text" VALIGN="TOP" width="10"></td>
      <td><%= shippingRB.get("paragraph2") %></td>
      </tr>
      <tr><td><br></td></tr>
      <tr>
      <td class="entry_text" VALIGN="TOP" width="20"></td>
      <td valign="TOP" nowrap><a href="javascript:changeCodes()"><%= shippingRB.get(ShippingConstants.MSG_CATEGORY_MENU) %></a>:</td>
      <td class="entry_text" VALIGN="TOP" width="10"></td>
      <td><%= shippingRB.get("paragraph3") %></td>
      </tr>
  
</table>
</body>
</html>



