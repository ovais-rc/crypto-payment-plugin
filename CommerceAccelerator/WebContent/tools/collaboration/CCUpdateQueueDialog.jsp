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

<%@ page language="java" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.beans.CCQueueDataBean" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.ibm.commerce.collaboration.livehelp.commands.ECLivehelpConstants" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@page import="java.sql.*" %>
<%@page import="com.ibm.commerce.ras.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdcontext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	JSPHelper jhelper = new JSPHelper(request);
	String storeId = cmdcontext.getStoreId().toString(); 
	String queueId =jhelper.getParameter(ECLivehelpConstants.EC_CC_QUEUE_ID);
	String languageId =cmdcontext.getLanguageId().toString(); 
	Locale locale = cmdcontext.getLocale();
	String queueName =""; 
	String queueDisplayName =""; 
	String queueDesc="";
	Hashtable liveHelpNLS = (Hashtable)ResourceDirectory.lookup("livehelp.liveHelpNLS", locale);
	CCQueueDataBean qDB=new CCQueueDataBean();
	qDB.setQueueId(queueId);
	DataBeanManager.activate(qDB, request);
	String sWebPath=UIUtil.getWebPrefix(request);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%= fHeader %>
<style type='text/css'>
.selectWidth {
	width: 400px;
}
</style>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>"
	type="text/css" />
<title><%=(String)liveHelpNLS.get("changeCCQueueDialogTitle")%></title>

<script language="JavaScript"
	src="<%=sWebPath%>javascript/tools/common/Util.js"></script>

<script language="JavaScript">

var bChanged=false;

function loadPanelData()
 {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
 }

function validatePanelData()
{
	if (!CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.value) {
		alertDialog("<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_QUEUENAME))%>");
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.select();
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.focus();
		return false;
	}
	
	if (trim(CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.value) =="") {
		alertDialog("<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_QUEUENAME))%>");
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.select();
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.focus();
		return false;
	}
	//check if the name is valid UTF-8 length
	if ( !isValidUTF8length(CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.value, 50)) {
		alertDialog("<%= UIUtil.toJavaScript((String)liveHelpNLS.get("stringTooLong"))%>");
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.select();
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.focus();
		return false;
	}
	//check if the display name is valid UTF-8 length
	if ( !isValidUTF8length(CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>.value, 50)) {
		alertDialog("<%= UIUtil.toJavaScript((String)liveHelpNLS.get("stringTooLong"))%>");
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>.select();
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>.focus();
		return false;
	}
	//check if the description is valid UTF-8 length
	if ( !isValidUTF8length(CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DESC%>.value, 254)) {
		alertDialog("<%= UIUtil.toJavaScript((String)liveHelpNLS.get("stringTooLong"))%>");
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DESC%>.select();
		CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DESC%>.focus();
		return false;
	}
	return true;
}

function getOKConfirmationMsg()
{
  return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get("changeCCQueueOKConfirmation")) %>"
}

function getCancelConfirmationMsg()
{
 	var sReturn="<%= UIUtil.toJavaScript((String)liveHelpNLS.get("changeCCQueueCancelConfirmation")) %>";
 	if (bChanged==false) {
 		sReturn= "";
	}
 	return sReturn;  
}

function getQueueDescription()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DESC%>.value;
}

function getQueueName()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.value;
}

function getQueueDisplayName()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>.value;
}

function getQueueId()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_ID%>.value;
}

function valueChanged() {
	bChanged=true;
}

function getErrorMsg(Message)
{
     if (Message == "<%=ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_STOREID%>") {
     	return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_STOREID))%>";
     	}
     else if (Message == "<%=ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_LANGUAGEID%>") {
     	return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_LANGUAGEID))%>";
     	}
     else if (Message == "<%=ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_QUEUEID%>") {
     	return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_QUEUEID))%>";
     	}
     else if (Message == "<%=ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_QUEUENAME%>") {
     	CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.focus();
     	return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_MISSING_QUEUENAME))%>";
     	}
     else if (Message == "<%=ECLivehelpConstants.EC_CC_MSG_KEY_BAD_QUEUEID%>") {
     	return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_BAD_QUEUEID))%>";
     	}
     else if (Message == "<%=ECLivehelpConstants.EC_CC_MSG_KEY_QUEUE_DISPLAYNAME_DUPLICATE%>") {
     	CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>.focus();
     	return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_QUEUE_DISPLAYNAME_DUPLICATE))%>";
     	}
     else if (Message == "<%=ECLivehelpConstants.EC_CC_MSG_KEY_QUEUE_NAME_DUPLICATE%>") {
     	CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.focus();
     	return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get(ECLivehelpConstants.EC_CC_MSG_KEY_QUEUE_NAME_DUPLICATE))%>";
     	}
     else {
     	return Message;
     	}
}

function setDefaultFocus()
{
	CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.focus();
}

</script>

</head>

<body onload="loadPanelData()" class="content">

<h1><%=UIUtil.toHTML((String) liveHelpNLS.get("changeCCQueueDialogLabel")) %></h1>
<% if (qDB.findCCQueue()) {
		queueName=qDB.getQueueName();
		qDB.refreshDisplayInformation(languageId);
		queueDesc=qDB.getQueueDescription();
		queueDisplayName=qDB.getQueueDisplayName();
		if (queueDesc==null) {queueDesc="";}
		if ((queueDesc.equals("") && queueDisplayName.equals(queueName))) {
			queueDisplayName="";
		 	}
 %>

<p><%=(String)liveHelpNLS.get("changeCCQueueDialogInstruction")%></p>

<form name="CCQueueForm" id="WC_CCUpdateQueueDialog_Form_1">
<input	id="WC_CCUpdateQueueDialog_FormInput_1" name="<%=ECLivehelpConstants.EC_CC_QUEUE_ID%>" type="hidden" value="<%=queueId%>" /> <br />
<table border="0">
	<tbody>
		<tr>
			<td><label for="WC_CCUpdateQueueDialog_FormInput_1"><%=UIUtil.toHTML((String) liveHelpNLS.get("changeCCQueueDialogQueueIdInput"))%></label>
			</td>
			<td><%=queueId%></td>
		</tr>
		<tr>
			<td>
				<label for="WC_CCUpdateQueueDialog_FormInput_2"><%=UIUtil.toHTML((String) liveHelpNLS.get("changeCCQueueDialogQueueNameInput"))%></label>
			</td>
			<td>
				<input id="WC_CCUpdateQueueDialog_FormInput_2" name="<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>" type="text" value="<%=UIUtil.toHTML(queueName)%>" size="20" maxlength="50" onchange="valueChanged()" />
			</td>
		</tr>
		<tr>
			<td>
				<label for="WC_CCUpdateQueueDialog_FormInput_3"><%=UIUtil.toHTML((String) liveHelpNLS.get("changeCCQueueDialogQueueDisplayNameInput"))%></label>
			</td>
			<td>
				<input id="WC_CCUpdateQueueDialog_FormInput_3" name="<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>" type="text" value="<%=UIUtil.toHTML(queueDisplayName)%>" size="20" maxlength="50" onchange="valueChanged()" />
			</td>
		</tr>
		<tr>
			<td>
				<label for="WC_CCUpdateQueueDialog_FormInput_4"><%=UIUtil.toHTML((String) liveHelpNLS.get("changeCCQueueDialogQueueDescriptionInput"))%></label>
			</td>
			<td>
				<input id="WC_CCUpdateQueueDialog_FormInput_4" name="<%=ECLivehelpConstants.EC_CC_QUEUE_DESC%>" type="text"	value="<%=UIUtil.toHTML(queueDesc)%>" size="30" maxlength="254"	onchange="valueChanged()" />
			</td>
		</tr>
	</tbody>
</table>
<p><br />


</p>
</form>
<% } else { %>
<p><%=(String) liveHelpNLS.get("changeCCQueueDialogNoQueueMsg")%></p>
<% } %>
</body>
</html>
