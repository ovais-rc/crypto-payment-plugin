<!-- ========================================================================
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2002, 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page import="java.util.*,
	com.ibm.commerce.command.CommandContext,
	com.ibm.commerce.server.ECConstants,
	com.ibm.commerce.tools.util.*" %>

<%	response.setContentType("text/html;charset=UTF-8"); %>

<%
	// obtain the common email activity resource bundle for NLS properties
	CommandContext emailActivityCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	if (emailActivityCommandContext == null) {
		System.out.println("Email Activity commandContext is null");
		return;
	}  
       
	Hashtable emailActivityRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("emailactivity.EmailActivityNLS", emailActivityCommandContext.getLocale());
	if (emailActivityRB == null) {
		System.out.println("Email Activity resouces bundle is null");
	}
	
        Locale jLocale = emailActivityCommandContext.getLocale();
	String jHeader = "<meta http-equiv='Cache-Control' content='no-cache'>" + "<link rel='stylesheet' href='" + UIUtil.getCSSFile(jLocale) + "'>";	
%>
<%=jHeader %>
