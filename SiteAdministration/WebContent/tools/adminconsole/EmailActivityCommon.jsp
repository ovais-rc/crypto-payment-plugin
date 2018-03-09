<!-- ========================================================================
/*
 *-------------------------------------------------------------------
 * IBM Confidential
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2002, 2003
 *     All rights reserved.
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has been
 * deposited with the US Copyright Office.
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

	Hashtable emailActivityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.EmailActivityNLS", emailActivityCommandContext.getLocale());
	if (emailActivityNLS == null) {
		System.out.println("Email Activity resouces bundle is null");
	}

	Locale jLocale = emailActivityCommandContext.getLocale();
	String jHeader = "<meta http-equiv='Cache-Control' content='no-cache'>" + "<link rel='stylesheet' href='" + UIUtil.getCSSFile(jLocale) + "'>";		
%>
<%=jHeader %>