<!--
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
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ras.ECMessageType" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.security.commands.ECSecurityConstants" %>
<%@include file="../common/common.jsp" %>
<%
// obtain the resource bundle for display
CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContext.getLocale();
Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", jLocale);

String exMsg = "";

try {


	exMsg = (String)userNLS.get("ERR_INVALID_LOGONID");

	ErrorDataBean errorBean = new ErrorDataBean ();
	com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);

	String exKey = errorBean.getMessageKey();
	String errcode = errorBean.getExceptionData().getString("ErrorCode", "");
	String orgCmd = errorBean.getOriginatingCommand();


	if (exKey == null) exKey = "";
	if (errcode == null) errcode = "";
	if (orgCmd == null) orgCmd = "";

	// use messages from userNLS for common error 
	if ( errcode.equals(ECSecurityConstants.ERR_INVALID_PASSWORD) ) {
		exMsg = (String)userNLS.get("ERR_INVALID_PASSWORD");
	}
	else if ( errcode.equals(ECSecurityConstants.ERR_MISSING_EMAIL) ) {
		exMsg = (String)userNLS.get("ERR_MISSING_EMAIL");
	}
	else if ( errcode.equals(ECSecurityConstants.ERR_MISSING_ADMINPASSWORD) ) {
		exMsg = (String)userNLS.get("ERR_MISSING_ADMINPASSWORD");
	}
	else if ( errcode.equals(ECSecurityConstants.ERR_INVALID_ADMINOPERATION) ) {
		exMsg = (String)userNLS.get("ERR_INVALID_ADMINOPERATION");
	}
	else if ( errcode.equals(ECSecurityConstants.ERR_INVALID_USERTYPE) ) {
		exMsg = (String)userNLS.get("ERR_INVALID_USERTYPE");
	}
	else if ( errcode.equals(ECSecurityConstants.ERR_INVALID_LOGONID) ) {
		exMsg = (String)userNLS.get("ERR_INVALID_LOGONID");		
	} 
	else {
		// If the message type in the ErrorDataBean is type USER then 
		// display the user message.  Otherwise, use the default
		// user message specified above.
		
		if ( errorBean.getECMessage().getType() == ECMessageType.USER ) {
			exMsg = errorBean.getMessage();
		}
		
		/*
		if (exKey.equals("_ERR_GENERIC")) {
			Object[] paramObj = errorBean.getMessageParam();
			exMsg = (String) paramObj[0];
		}
		
		if (errcode.length() > 0) {
			exMsg += "<br />(ErrorCode = " + errcode + ")"; 
		}
		*/
		
	}

} catch (Exception e) {
	e.printStackTrace();
}
%>

<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
   <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

   <title><%= userNLS.get("passwdNotReset") %></title>

   </head>

   <body class="content">
   	<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
   	<script type="text/javascript">
   		alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
    		top.mccbanner.loadbct();
   	
</script>

   </body>
</html>