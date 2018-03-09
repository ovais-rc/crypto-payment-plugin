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
// 020925	    JH		Initial Create
//
// 020925	    KNG		Add display of description and current selection
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %> 
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.store.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer lang_id = cmdContextLocale.getLanguageId(); 

Hashtable storeCategoryNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("store.StoreCategoryNLS", jLocale);

JSPHelper URLParameters	= new JSPHelper(request);
String actionPerformed	= URLParameters.getParameter("actionPerformed");
String targetStoreId = URLParameters.getParameter("targetStoreId");

StoreDataBean storeDB = new StoreDataBean();
storeDB.setStoreId(targetStoreId.toString());
DataBeanManager.activate(storeDB, request);

Integer storeCategoryId = storeDB.getStoreCategoryIdInEntityType();

StoreCategoryAccessBean storeCategory = new StoreCategoryAccessBean();
Enumeration storeCategoryList = storeCategory.findAll();
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
	<title><%= UIUtil.toHTML((String)storeCategoryNLS.get("storeCategoryTitle")) %></title>

	<script src="/wcs/javascript/tools/common/Util.js"></script>
	<script>
	function initialize() {    
		parent.setContentFrameLoaded(true);
	
		if ("<%= UIUtil.toJavaScript(exMsg) %>" != "")
			alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
	
		<%
		if ( (exMsg.equals("")) && (actionPerformed != null) && (!actionPerformed.equals("")) ) {
		%>
			alertDialog("<%= UIUtil.toJavaScript((String)storeCategoryNLS.get("updateSuccess")) %>");
			top.goBack();
		<%
		}
		%>
	}

	function updateAction() {
		parent.setContentFrameLoaded(false);
		document.storeCategoryForm.submit();
	}

	function cancelAction() {
		top.goBack();
	}
	</script>
	<meta name="GENERATOR" content="IBM WebSphere Studio">
</head>

<body onload="initialize();" class="content">

  <h1><%= UIUtil.toHTML((String)storeCategoryNLS.get("storeCategoryTitle")) %></h1>

    <form name="storeCategoryForm"
          method="post"
          action="StoreCategoryUpdate">
	<input type="hidden" name="<%= StoreConstants.TARGETSTORE_ID %>" value="<%= targetStoreId.toString() %>">
	<input type="hidden" name="<%= ECConstants.EC_ERROR_VIEWNAME %>" value="StoreCategoryUpdateView?<%= StoreConstants.TARGETSTORE_ID %>=<%= targetStoreId.toString() %>">
	<input type="hidden" name="<%= ECConstants.EC_URL %>" value="StoreCategoryUpdateView?<%= StoreConstants.TARGETSTORE_ID %>=<%= targetStoreId.toString() %>&actionPerformed=y">
	<p><%= (String)storeCategoryNLS.get("storeCategoryDescription") %>
		
	<table>
	<tr>
	<td>&nbsp;</td>
	</tr>
	<tr>
	<td><label for="WCStoreCategoryUpdate_storeCategoryId"><%= UIUtil.toHTML((String)storeCategoryNLS.get("chooseNewCategory")) %></label>
	<select name="storeCategoryId" id="WCStoreCategoryUpdate_storeCategoryId">
	<%
	while (storeCategoryList.hasMoreElements())
	{
		String storeCategoryName = null;
		storeCategory = (StoreCategoryAccessBean) storeCategoryList.nextElement();
		try {
			storeCategoryName = storeCategory.getDescription(lang_id).getDisplayName();
		} catch (Exception ex) {
			storeCategoryName = storeCategory.getName();
		}
		storeCategoryName = storeCategoryName.trim();
		if (storeCategory.getStoreCategoryId().equals(storeCategoryId))
		{
		%>
			<option value="<%= storeCategory.getStoreCategoryId().toString() %>" selected ><%= storeCategoryName %></option>
		<%
		} else {
		%>
			<option value="<%=  storeCategory.getStoreCategoryId().toString() %>" ><%= storeCategoryName %></option>
		<%   
		}
	}
	%>
	</td>
	</tr>
    	</table>    	
    </form>
</body>

</html>
