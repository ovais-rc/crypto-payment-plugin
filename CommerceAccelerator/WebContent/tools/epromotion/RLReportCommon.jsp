<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<%@page
import="java.util.*,
     com.ibm.commerce.command.CommandContext,
     com.ibm.commerce.server.ECConstants,
     com.ibm.commerce.tools.util.*" %>
<% response.setContentType("text/html;charset=UTF-8"); %>

<%
   CommandContext reportsCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   if (reportsCommandContext == null) {
     System.out.println("commandContext is null");
     return;
   }

   Hashtable reportsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("reporting.reportStrings", reportsCommandContext.getLocale());
   if (reportsRB == null) 
   {
   		System.out.println("!!!! Reports resouces bundle is null");
	}

    Hashtable RLPromotionNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("RLPromotion.RLPromotionNLS",reportsCommandContext.getLocale());
   if (RLPromotionNLS == null) {
	 System.out.println("ePromotion resource bundle is null");
   }

   final String fHeader =
     "<meta http-equiv='Cache-Control' content='no-cache'>" +System.getProperty("line.separator")
	+ "   <meta http-equiv=expires content='fri,31 Dec 1990 10:00:00 GMT'>" + System.getProperty("line.separator")
 	+ "   <link rel=stylesheet href=" + UIUtil.getCSSFile(reportsCommandContext.getLocale()) + " type=\"text/css\">" 
 	+ "   <style type=\"text/css\">" +  System.getProperty("line.separator") 
 	+ " .selectWidth {width:300px;}" + System.getProperty("line.separator") + " </style>";
%>


