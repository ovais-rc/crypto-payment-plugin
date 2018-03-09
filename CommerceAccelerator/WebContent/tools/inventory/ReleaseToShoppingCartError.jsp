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
//
// 020813	    KNG		Make changes from code review and
//				UCD design exploration sessions
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %> 
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();

Hashtable releaseOrderItemsNLS 	= (Hashtable)ResourceDirectory.lookup("inventory.releaseOrderItemsNLS", jLocale);

com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String orderIds = URLParameters.getParameter("orderIds");
String orderItemIds = URLParameters.getParameter("orderItemIds");
String ffmcIds = URLParameters.getParameter("ffmcIds");
String FFMStores = URLParameters.getParameter("FFMStores");
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
	exMsg = (String)releaseOrderItemsNLS.get("ReleaseToShoppingCartGeneralError");
}
%>

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css"> 
<script src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT>
function initialize() {
	if ("<%= UIUtil.toJavaScript(exMsg) %>" != "") {
		alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
	}
	
	var URLParam = new Object();
	URLParam.orderItemIds = "<%= orderItemIds %>";
	URLParam.ffmcIds = "<%= ffmcIds %>";
	URLParam.FFMStores = "<%= FFMStores %>";
	URLParam.orderIds = "<%= orderIds %>";
	
	top.mccmain.submitForm("/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.releaseToShoppingCart", URLParam);
      	top.refreshBCT();	
}

</SCRIPT>
</HEAD>

<BODY onload="initialize();" class="content">

</BODY>

</HTML>
