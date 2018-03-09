<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.ibm.commerce.tools.shipping.*" %>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.common.beans.StoreEntityDataBean" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.price.utils.CurrencyManager" %>
<% response.setContentType("text/html;charset=UTF-8"); %>  
 
<%
   // obtain the common campaign resource bundle for NLS properties
   CommandContext shippingCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   if (shippingCommandContext == null) {
     out.println("CommandContext is null");
     return;
   }

   String fLanguageId = shippingCommandContext.getLanguageId().toString();
   Integer fStoreId = shippingCommandContext.getStoreId();
   Locale fLocale = shippingCommandContext.getLocale();
   Long fMemberId = shippingCommandContext.getUserId();   
   
   Hashtable shippingRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("shipping.shippingRB",
                                                                                      fLocale);
   if (shippingRB == null) {
	out.println("Shipping resources bundle is null");
   }
   
   String fHeader = "<meta http-equiv='Cache-Control' content='no-cache'>" + "<link rel='stylesheet' href='" + UIUtil.getCSSFile(shippingCommandContext.getLocale()) + "'>";
   String fshippingNS = "shipping.";
   

%>

<html>
<head>

<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>
</html>
