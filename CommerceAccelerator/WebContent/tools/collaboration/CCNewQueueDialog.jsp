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
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdcontext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdcontext.getLocale();
	Hashtable liveHelpNLS = (Hashtable)ResourceDirectory.lookup("livehelp.liveHelpNLS", locale);
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

<title><%=(String)liveHelpNLS.get("newCCQueueDialogTitle")%></title>

<script language="JavaScript"
	src="<%=sWebPath%>javascript/tools/common/Util.js"></script>

<script language="JavaScript">
var bChanged=false;

/**
 * loads page data
 */
function loadPanelData()
 {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
 }

/**
 * validates input data
 */
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

/**
 * sets focus on queue name text field
 */
function setDefaultFocus()
{
	CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.focus();
}

/**
 * returns confirmation message
 * @param FinishMessage Message key returned from WCS command
 */
function getFinishMsg(FinishMessage)
{
  return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get("newCCQueueFinishConfirmation")) %>"
}

/**
 * returns error messages
 * @param Message message key returned from WCS command
 */
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

/**
 * returns OK confirmation message
 */
function getOKConfirmationMsg()
{
  return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get("newCCQueueOKConfirmation")) %>"
}

/**
 * returns Cancel confirmation message
 */
function getCancelConfirmationMsg()
{
 	var sReturn="<%= UIUtil.toJavaScript((String)liveHelpNLS.get("newCCQueueCancelConfirmation")) %>";
 	if (bChanged==false) {
 		sReturn= "";
	}
 	return sReturn; 
}

/**
 * returns queue description string
 */
function getDescription()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DESC%>.value;
}

/**
 * returns queue name string
 */
function getQueueName()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>.value;
}

/**
 * returns queue display name string
 */
function getQueueDisplayName()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>.value;
}

/**
 * trims input string
 */
function trim(sInput) {
   var sReturn = sInput;
   var ch = sReturn.substring(0, 1);
   while (ch == " ") 
   { 
      sReturn = sReturn.substring(1, sReturn.length);
      ch = sReturn.substring(0, 1);
   }
   ch = sReturn.substring(sReturn.length-1, sReturn.length);
   while (ch == " ") 
   { 
      sReturn = sReturn.substring(0, sReturn.length-1);
      ch = sReturn.substring(sReturn.length-1, sReturn.length);
   }
   return sReturn; 
}

/**
 * sets value changed flag
 */
function valueChanged() {
	bChanged=true;
}

</script>

</head>

<body onload="loadPanelData();" class="content">

<h1><%=UIUtil.toHTML((String)liveHelpNLS.get("newCCQueueDialogLabel"))%></h1>

<p><%=(String)liveHelpNLS.get("newCCQueueDialogInstruction1")%></p>

<form name="CCQueueForm" id="WC_CCNewQueueDialog_Form_1">
<p></p>
<table border="0" id="WC_CCNewQueueDialog_Table_1">
	<tbody>
		<tr>
			<td id="WC_CCNewQueueDialog_TableCell_1">
				<label for="WC_CCNewQueueDialog_FormInput_1"><%=UIUtil.toHTML((String) liveHelpNLS.get("newCCQueueDialogNewQueueNameInput")) %></label>
			</td>
			<td id="WC_CCNewQueueDialog_TableCell_2">
				<input id="WC_CCNewQueueDialog_FormInput_1" name="<%=ECLivehelpConstants.EC_CC_QUEUE_NAME%>" type="text" size="20" maxlength="50" onchange="valueChanged()" />
			</td>
		</tr>
		<tr>
			<td id="WC_CCNewQueueDialog_TableCell_3">
				<label for="WC_CCNewQueueDialog_FormInput_2"><%=UIUtil.toHTML((String) liveHelpNLS.get("newCCQueueDialogNewQueueDisplayNameInput")) %></label>
			</td>
			<td id="WC_CCNewQueueDialog_TableCell_4">
				<input id="WC_CCNewQueueDialog_FormInput_2" name="<%=ECLivehelpConstants.EC_CC_QUEUE_DISPLAY_NAME%>" type="text" size="20" maxlength="50" onchange="valueChanged()" />
			</td>
		</tr>
		<tr>
			<td id="WC_CCNewQueueDialog_TableCell_5">
				<label for="WC_CCNewQueueDialog_FormInput_3"><%=UIUtil.toHTML((String) liveHelpNLS.get("newCCQueueDialogNewQueueDescriptionInput")) %></label>
			</td>
			<td id="WC_CCNewQueueDialog_TableCell_6">
				<input id="WC_CCNewQueueDialog_FormInput_3" name="<%=ECLivehelpConstants.EC_CC_QUEUE_DESC%>" type="text" size="30" maxlength="254" onchange="valueChanged()" />
			</td>
		</tr>
	</tbody>
</table>

<p></p>
</form>
</body>
</html>
