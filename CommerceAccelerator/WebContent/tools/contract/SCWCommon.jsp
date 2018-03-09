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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.common.beans.StoreEntityDataBean" %>
<%@page import="com.ibm.commerce.tools.util.*" %>

<%
   // obtain the common store creation wizard resource bundle for NLS properties
   CommandContext cc = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   if (cc == null) {
     out.println("CommandContext is null");
     return;
   }

   String lang_id= cc.getLanguageId().toString();
   Locale locale = cc.getLocale();   

   Hashtable resourceBundle = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.contractRB", locale);
   if (resourceBundle == null) {
	out.println("Contracts resources bundle is null");
   }

   Hashtable fixedResourceBundle = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.storeCreationWizardRB", locale);  
   if (fixedResourceBundle == null) {
	out.println("The untranslatable store creation wizard resources bundle is null");
   }

   Hashtable logonResource = (Hashtable) ResourceDirectory.lookup("common.logonNLS", locale);
   if (logonResource == null) {
	out.println("Common Logon resources bundle is null");
   }
%>


