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
<%@page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@page import="com.ibm.commerce.common.objects.StoreEntityAccessBean" %>
<%@page import="com.ibm.commerce.registry.StoreRegistry" %>
<%@page import="com.ibm.commerce.tools.util.*" %>

<%
   // obtain the common campaign resource bundle for NLS properties
   CommandContext contractCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   if (contractCommandContext == null) {
     out.println("CommandContext is null");
     return;
   }

   String fLanguageId= contractCommandContext.getLanguageId().toString();
   Integer fStoreId= contractCommandContext.getStoreId();
   Locale fLocale = contractCommandContext.getLocale();
   Long fMemberId = contractCommandContext.getUserId();   

   String fStoreMemberId = null;
   String fStoreIdentity = null;
   StoreAccessBean abStore = StoreRegistry.singleton().find(fStoreId);
   if (abStore != null) {
   	fStoreMemberId = abStore.getMemberId();
	fStoreIdentity = abStore.getIdentifier();   
   } else {
	StoreEntityAccessBean abStoreEnt = new StoreEntityAccessBean();
	abStoreEnt.setInitKey_storeEntityId(fStoreId.toString());
   	fStoreMemberId = abStoreEnt.getMemberId();
	fStoreIdentity = abStoreEnt.getIdentifier();  
   }	      

   Hashtable contractsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("contract.contractRB",
                                                                                           fLocale);
   if (contractsRB == null) {
	out.println("Contracts resources bundle is null");
   }

   // Find out if this is a new or an update
   boolean foundContractId = false;
   boolean foundAccountId = false;
   boolean editingAccount = false;
   String contractId = null;
   String accountId = null;
   try {
     contractId = contractCommandContext.getRequestProperties().getString("contractId");
     if (contractId != null && contractId.length() > 0) {
	  foundContractId = true;
     }
   } catch (Exception e) {
   }
   try {
     accountId = contractCommandContext.getRequestProperties().getString("accountId");
     if (accountId != null && accountId.length() > 0) {
	  foundAccountId = true;
     }
   } catch (Exception e) {
   }
   try {
     editingAccount = contractCommandContext.getRequestProperties().getBoolean("accountEdit");
   } catch (Exception e) {
   }


%>


