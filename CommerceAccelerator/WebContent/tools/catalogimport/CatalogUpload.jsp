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
// 020904	    KNG		Initial Create
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.beans.ErrorDataBean" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.ras.ECMessageType" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Locale" %>

<%@include file="../../tools/common/common.jsp" %>

<%
// obtain the resource bundle for display
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale 		= cmdContextLocale.getLocale();

Hashtable catalogImportNLS = (Hashtable)ResourceDirectory.lookup("catalogimport.catalogImportNLS", jLocale);

com.ibm.commerce.server.JSPHelper jHelper = new com.ibm.commerce.server.JSPHelper(request);
String success = jHelper.getParameter("success");
String message = null;
if (success != null && success.equals("y")) {
	message = (String)catalogImportNLS.get("catalogUploadSuccess");
}
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
	<TITLE><%= UIUtil.toHTML((String)catalogImportNLS.get("catalogImportListTitle")) %></TITLE>

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

	<script>
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState()
	{
		<%
		if (message != null) {
		%>
			alertDialog("<%= UIUtil.toJavaScript(message) %>");
			top.goBack();
		<%
		} else if (exMsg != null && !exMsg.equals("")) {
		%>
			alertDialog("<%= UIUtil.toJavaScript(exMsg) %>");
		<%
		}
		%>
		parent.setContentFrameLoaded(true);
	}


	function uploadFile()
	{
		if (document.uploadFileForm.filename.value=="") {
			alertDialog("<%= UIUtil.toJavaScript((String)catalogImportNLS.get("catalogUploadNoFilename")) %>");
			return;
		}

		top.showProgressIndicator(true);

		document.uploadFileForm.action = "CatalogFileUpload";
		document.uploadFileForm.submit();
	}


	</script>
</head>

<body class="content" onload="initializeState();">

<h1><%= (String)catalogImportNLS.get("catalogUploadTitle") %></h1>
<%= (String)catalogImportNLS.get("catalogUploadDescription") %>

<form enctype="multipart/form-data" method="post" name="uploadFileForm" action="">
<input type="hidden" name="errorURL" value="CatalogUploadView?success=n" />
<input type="hidden" name="errorViewName" value="CatalogUploadView" />
<input type="hidden" name="URL" value="CatalogUploadView?success=y" />

<table border="0">
<tr>
<td><label for="encoding"><%= (String)catalogImportNLS.get("catalogFileEncoding")%></label></td>
<td>&nbsp;</td>
<td><label for="filename"><%= (String)catalogImportNLS.get("catalogUploadFile")%></label></td>
</tr>
<tr>
<td>
<select name="encoding" id="encoding">
<option value="Cp1252">Windows Latin-1</option>
<option value="8859_1">ISO 8859-1</option>
<option value="8859_15">ISO 8859-15</option>
<option value="Big5">Big5</option>
<option value="GB2312">GB2312</option>
<option value="KSC5601">KS C 5601</option>
<option value="SJIS">Shift-JIS</option>
<option value="UTF8" selected>UTF-8</option>
<option value="UTF-16">UTF-16</option>
</select>
</td>
<td>&nbsp;</td>
<td><input type="file" name="filename" style="width: 300px;" id="filename"></td>
</tr>
<tr>
<td><input type="button" value='<%= (String)catalogImportNLS.get("catalogUploadButton")%>' id="nbp" onClick="uploadFile(); return false;" /></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</table>
</form>

</body>
</html>



