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
// 020723	    KNG		Initial Create
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.store.commands.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale 		= cmdContextLocale.getLocale();

Hashtable broadcastNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("store.BroadcastAdminNLS", jLocale);
JSPHelper jspHelper 	= new JSPHelper(request);
String sender		= jspHelper.getParameter("sender");
String openStores	= jspHelper.getParameter("openStores");
String closedStores	= jspHelper.getParameter("closedStores");
String suspendedStores	= jspHelper.getParameter("suspendedStores");
String recipient	= jspHelper.getParameter("recipient");
String subject		= jspHelper.getParameter("subject");
String messageContent	= jspHelper.getParameter("messageContent");
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>
<%
String exMsg = "";
ErrorDataBean errorBean = new ErrorDataBean(); 
try {
	DataBeanManager.activate (errorBean, request);

	String exKey = errorBean.getMessageKey();

	//If the message type in the ErrorDataBean is type SYSTEM then 
	//display the system message.  Otherwise the message is type USER
	//so display the user message.
	if ( errorBean.getECMessage().getType() == ECMessageType.SYSTEM ) {
		exMsg = errorBean.getSystemMessage();
	} else {
		exMsg = errorBean.getMessage();
	}
	
	if (exKey.equals("_ERR_GENERIC")) {
		String[] paramObj = (String[])errorBean.getMessageParam();
		exMsg = paramObj[0];
	}
} catch (Exception ex) {
	exMsg = "";
}
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script>
function initialize() {
	if ("<%= UIUtil.toJavaScript(exMsg) %>" != "") {
		alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
		var url = "/webapp/wcs/tools/servlet/DialogView?";
		URLParam = new Object();
		URLParam.XMLFile = "store.BroadcastAdmin";
		
		<%
		if (messageContent != null) {
		%>
			URLParam["<%= AdminBroadcastMessageCmd.EC_MESSAGE_CONTENT %>"] = "<%= UIUtil.toJavaScript(messageContent) %>";
		<%
		}
		if (recipient != null) {
		%>
			URLParam["<%= AdminBroadcastMessageCmd.EC_RECIPIENT %>"] = "<%= UIUtil.toJavaScript(recipient) %>";
		<%
		}
		if (sender != null) {
		%>
			URLParam["<%= AdminBroadcastMessageCmd.EC_SENDER %>"] = "<%= UIUtil.toJavaScript(sender) %>";
		<%
		}
		if (subject != null) {
		%>
			URLParam["<%= AdminBroadcastMessageCmd.EC_SUBJECT %>"] = "<%= UIUtil.toJavaScript(subject) %>";
		<%
		}
		if (openStores != null) {
		%>
			URLParam["openStores"] = "<%= openStores %>";
		<%
		}
		if (closedStores != null) {
		%>
			URLParam["closedStores"] = "<%= closedStores %>";
		<%
		}
		if (suspendedStores != null) {
		%>
			URLParam["suspendedStores"] = "<%= suspendedStores %>";
		<%
		}
		%>
		top.mccmain.submitForm(url,URLParam);
      		top.refreshBCT();
	} else {
		alertDialog("<%= UIUtil.toJavaScript(broadcastNLS.get("broadcastAdminSuccess")) %>");
		top.goBack();
	}
}

</script>
</head>

<body onload="initialize();" class="content">

</body>

</html>
