<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2003, 2016
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
// 020815	    KNG		Make changes from code review
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.store.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.devtools.*" %>
<%@include file="../common/common.jsp" %>
<%@page import="com.ibm.commerce.tools.devtools.publish.StorePublishConfig" %>
<%@page import="com.ibm.commerce.tools.devtools.DevToolsConfiguration" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer storeId	= cmdContextLocale.getStoreId();

Hashtable opencloseNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("store.opencloseNLS", jLocale);

JSPHelper URLParameters	= new JSPHelper(request);
String actionPerformed	= URLParameters.getParameter("actionPerformed");

//Need to use StoreAccessBean because have to read value from the database. The cached copy
//in the StoreRegistry has some delay, thus causing the page to load incorrectly.
//Access control is not an issue here.
StoreAccessBean storeAB = new StoreAccessBean();
storeAB.setInitKey_storeEntityId(storeId.toString());

Integer storeState = storeAB.getStatusInEntityType();
boolean isSuspended = false;
boolean isOpen = false;

if (storeState.intValue() == StoreConstants.STATUS_SUSPEND.intValue()) {
	isSuspended = true;
}
if (storeState.intValue() == StoreConstants.STATUS_OPEN.intValue()) {
	isOpen = true;
}

//get store display name
String StoresWebPath = "";
String displayName = null;
try {
	WebModuleConfig webApp = (WebModuleConfig) com.ibm.commerce.server.WebApp.retrieveObject("Stores");
	if (webApp != null) {
		StoresWebPath = webApp.getContextPath();
	}
	StoresWebPath = StoresWebPath +"/servlet";
	StoreEntityDescriptionAccessBean storeDescAB = storeAB.getDescription(cmdContextLocale.getLanguageId());
	if (storeDescAB != null) {
		displayName = storeDescAB.getDisplayName();
	}
	if (displayName == null) {
		displayName = "";
	}
} catch (Exception ex) {
	displayName = storeAB.getIdentifier();
}


String host = request.getServerName();
//String StoresWebPath = ConfigProperties.singleton().getValue("WebServer/StoresWebPath");


//--------------------------------------------------------------------
// This code is to check if the current Hub store has a directory and 
// thus should be allowed to launch store. 
//--------------------------------------------------------------------
boolean hasIndexFile = true;
if (storeAB.getStoreType().equals("HCP")) {

//These lines commented for LI 966 changes.

//	String storesDocRoot = DevToolsConfiguration.getConfigurationVariable("StoresDocRoot");
//	String storesWebPath = DevToolsConfiguration.getConfigurationVariable("StoresWebPath");
//	String storesWebModule = (new File(storesDocRoot, storesWebPath)).getPath();

	String storesWebModule = StorePublishConfig.getInstance().getProperty(DevToolsConfiguration.STORES_WEB_PATH);
	String storeDirFullPath = storesWebModule + File.separator + storeAB.getDirectory();	
	
	// compute the include directory
	File indexFile = new File(storeDirFullPath, "index.jsp");
	
	if (!indexFile.exists()) {
		hasIndexFile = false;
	}
}
//-----
// END 
//-----
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


<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css"> 

<TITLE><%= UIUtil.toHTML((String)opencloseNLS.get("opencloseTitle")) %></TITLE>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<SCRIPT>
function initialize() {    
	if ("<%= hasIndexFile %>" == "false") {
		for (var i=0; i<parent.NAVIGATION.document.DialogForm.elements.length; i++) {
			if (parent.NAVIGATION.document.DialogForm.elements[i].name == "opencloseLaunchStoreButton") { 
	        		parent.NAVIGATION.document.DialogForm.elements[i].disabled = true;
	        	}
	        }
	}

	parent.setContentFrameLoaded(true);
	
	if ("<%= UIUtil.toJavaScript(exMsg) %>" != "")
		alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
	
	<%
	if ( (exMsg.equals("")) && (actionPerformed != null) && (!actionPerformed.equals("")) ) {
	%>
		alertDialog("<%= UIUtil.toJavaScript((String)opencloseNLS.get("opencloseSuccess")) %>");
	<%
	}
	%>
}

function submitForm(inAction) {
	document.opencloseForm.action = inAction;
	<% if (isOpen) { %>
		var continueClosing = confirmDialog("<%= UIUtil.toJavaScript((String)opencloseNLS.get("opencloseClosingWarning")) %>");
		if (continueClosing) {
			parent.setContentFrameLoaded(false);
			document.opencloseForm.submit();
		}
	<% } else { %>
		parent.setContentFrameLoaded(false);
		document.opencloseForm.submit();
	<% } %>
}

function launchStore() {
	var url = "http://<%=host%>/<%=StoresWebPath.substring(1,StoresWebPath.length())%>/";
	url += "StoreView?<%= ECConstants.EC_STORE_ID %>=<%= storeId.toString() %>&<%= ECConstants.EC_LANGUAGE_ID %>=<%= cmdContextLocale.getLanguageId().toString() %>";
	
	window.open(url, '<%= storeId.toString() %>');
}

function cancelAction() {
	top.goBack();
}
</SCRIPT>
</HEAD>

<BODY onload="initialize();" class="content">
  <H1><%= UIUtil.toHTML((String)opencloseNLS.get("opencloseTitle")) %></H1>
  <i><H1><%= UIUtil.toHTML(displayName) %></H1></i>

  	<%
  	if (isOpen) {
		// is open, so can close
		%>
		<P><%= opencloseNLS.get("opencloseDescriptionOpen") %>
		<BR><BR>

		<table border=0 cellpadding=0 cellspacing=0>
		<tr>
		<td valign="bottom" align="left">
		<button type="button" name="StoreClose" id="form" onClick="submitForm(this.name)"><%= UIUtil.toHTML((String)opencloseNLS.get("opencloseCloseStoreButton")) %></button>
		</td>
		</tr>
		</table>
	<%
  	} else if (!isSuspended && !isOpen) {
		// is closed, so can open
		%>
		<P><%= opencloseNLS.get("opencloseDescriptionClose") %>
		<BR><BR>

		<table border=0 cellpadding=0 cellspacing=0>
		<tr>
		<td valign="bottom" align="left">
		<button type="button" name="StoreOpen" id="form" onClick="submitForm(this.name)"><%= UIUtil.toHTML((String)opencloseNLS.get("opencloseOpenStoreButton")) %></button>
		</td>
		</tr>
		</table>
	<%
  	} else {
  	%>
		<P><%= opencloseNLS.get("opencloseDescriptionSuspended") %>
		<BR><BR>
		
		<table border=0 cellpadding=0 cellspacing=0>
		<tr>
		<td valign="bottom" align="left">
		<button type="button" name="StoreOpen" id="form" onClick="submitForm(this.name)" disabled ><%= UIUtil.toHTML((String)opencloseNLS.get("opencloseOpenStoreButton")) %></button>
		</td>
		</tr>
		</table>
	<%
	}
	%>

    <form name="opencloseForm"
          method="post"
          action="">
	<input type="hidden" name="targetStoreId" value="<%= storeId.toString() %>">
	<input type="hidden" name="<%= ECConstants.EC_ERROR_VIEWNAME %>" value="StoreOpenCloseView">
	<input type="hidden" name="<%= ECConstants.EC_URL %>" value="StoreOpenCloseView?actionPerformed=y">
    </form>
</BODY>

</HTML>
