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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*,
	com.ibm.commerce.command.CommandContext,
	com.ibm.commerce.server.ECConstants,
	com.ibm.commerce.tools.util.*" %>

<%	response.setContentType("text/html;charset=UTF-8"); %>

<%
	// obtain the common campaign resource bundle for NLS properties
	CommandContext campaignCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	if (campaignCommandContext == null) {
		System.out.println("commandContext is null");
		return;
	}

	Hashtable campaignsRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("campaigns.campaignsRB", campaignCommandContext.getLocale());
	if (campaignsRB == null) {
		System.out.println("Campaigns resouces bundle is null");
	}

	String fHeader = "<META HTTP-EQUIV='Cache-Control' CONTENT='no-cache'>" + "<LINK rel='stylesheet' href='" + UIUtil.getCSSFile(campaignCommandContext.getLocale()) + "'>";
	String fCampaignsNS = "campaigns.";
%>
