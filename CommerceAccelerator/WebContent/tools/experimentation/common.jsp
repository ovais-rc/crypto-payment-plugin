<!-- ==================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.ibm.commerce.command.CommandContext,
	com.ibm.commerce.server.ECConstants,
	com.ibm.commerce.tools.util.*,
	java.util.*" %>

<%	response.setContentType("text/html;charset=UTF-8"); %>

<%
	// obtain the common experimentation resource bundle for NLS properties
	CommandContext experimentCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	if (experimentCommandContext == null) {
		System.out.println("commandContext is null");
		return;
	}

	Hashtable experimentRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("experiment.experimentRB", experimentCommandContext.getLocale());
	if (experimentRB == null) {
		System.out.println("Experimentation resouces bundle is null");
	}

	String fHeader = "<META HTTP-EQUIV='Cache-Control' CONTENT='no-cache'>" + "<LINK rel='stylesheet' href='" + UIUtil.getCSSFile(experimentCommandContext.getLocale()) + "'>";
	String fExperimentNS = "experiment.";
%>
