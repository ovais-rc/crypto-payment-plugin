<!--==========================================================================
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
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*,
     com.ibm.commerce.command.CommandContext,
     com.ibm.commerce.server.ECConstants,
     com.ibm.commerce.tools.util.*" %>

<%
   Hashtable biNLS = null;
   Locale biLocale;
   {
   // obtain the common bi resource bundle for NLS properties
   CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   if (biCommandContext == null) {
     System.out.println("commandContext is null");
     return;
   }
   
   biLocale = biCommandContext.getLocale();
   biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);
   if (biNLS == null) out.println("!!!! BI resouces bundle is null");
   }
%>


