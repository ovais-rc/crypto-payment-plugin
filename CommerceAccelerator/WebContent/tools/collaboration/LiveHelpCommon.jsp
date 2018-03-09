<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003
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
--%>

<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.ibm.commerce.ras.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.order.utils.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%
   
   // Get commandcontext, locale, and processing option
   CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale aLocale = commandContext.getLocale();
   Hashtable liveHelpNLS = (Hashtable)ResourceDirectory.lookup("livehelp.liveHelpNLS", aLocale);
   String fLanguageId= commandContext.getLanguageId().toString();

   
    String fLiveHelpHeader = "<meta http-equiv='expires' content='-1' /> "
 		 				   + "<link rel='stylesheet' href='" + UIUtil.getCSSFile(aLocale) + "' type='text/css' />";
   
    String sWebPath=UIUtil.getWebPrefix(request);
    String sWebAppPath=UIUtil.getWebappPath(request);

%>

