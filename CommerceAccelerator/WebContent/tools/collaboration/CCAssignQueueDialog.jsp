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
	JSPHelper jhelper = new JSPHelper(request);
	String storeId = cmdcontext.getStoreId().toString(); 
	String queueId =jhelper.getParameter(ECLivehelpConstants.EC_CC_QUEUE_ID);
	String languageId =cmdcontext.getLanguageId().toString(); 
	Locale locale = cmdcontext.getLocale();
	Hashtable liveHelpNLS = (Hashtable)ResourceDirectory.lookup("livehelp.liveHelpNLS", locale);
	CCQueueDataBean qDB=new CCQueueDataBean();
	qDB.setQueueId(queueId);
	DataBeanManager.activate(qDB, request);
	Vector vAssignedCSRs=new Vector();
	Vector vAllCSRs=new Vector();
	String allCSR="";
	String queueDesc="";
	String queueDisplayName="";
	String sWebPath=UIUtil.getWebPrefix(request);
        String CSRId="";
       String CSRLogon="";
	
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

<title><%=(String)liveHelpNLS.get("assignCCQueueDialogTitle")%></title>

<script language="JavaScript"
	src="<%=sWebPath%>javascript/tools/common/Util.js"></script>
<script language="JavaScript"
	src="<%=sWebPath%>javascript/tools/common/SwapList.js"></script>

<script language="JavaScript">
 
 var bChanged=false;
 var origAllCSR="";
 
/**
 * hides CSR list on the page
 */
function hideCSRList()
{
	document.all["CSRList"].style.display = "none";
}

/**
 * displays CSR list on the page
 */
function showCSRList()
{
	document.all["CSRList"].style.display = "block";
}

/**
 * load page data.
 */
function loadPanelData()
 {
     if (CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR%>[0].checked)
 		hideCSRList();
 	else
 		showCSRList(); 
 		   
	origAllCSR=getAllCSR();
	
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
     
 }

/**
 * validate input data
 */
function validatePanelData()
{
  	var bReturn=false;
	bReturn=true;
	return bReturn;
}

/**
 * returns OK confirmation message
 */
function getOKConfirmationMsg()
{
  return "<%= UIUtil.toJavaScript((String)liveHelpNLS.get("assignCCQueueOKConfirmation")) %>"
}

/**
 * returns Cancel confirmation message
 */
function getCancelConfirmationMsg()
{
  
   	var sReturn="<%= UIUtil.toJavaScript((String)liveHelpNLS.get("assignCCQueueCancelConfirmation")) %>";
 	if (bChanged==false && getAllCSR() ==origAllCSR) {
 		sReturn= "";
	}
 	return sReturn;  
}

/**
 * returns error messages
 * @param Message message key returned by WCS command
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
 * returns AssignedCSR string
 */
function getAssignedCSRs()
{
 	var sAssignedCSR="";
 	if (getAllCSR() == "<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_DISALLOWED%>") {
  		for(var i =0; i< CCQueueForm.AssignedList.length; i++) {
 				sAssignedCSR=sAssignedCSR  + CCQueueForm.AssignedList[i].value + ',';
 		}
 	}
   return sAssignedCSR;
}

/**
 * returns AllCSR option value
 */
function getAllCSR()
{
	if (CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR%>[0].checked)
  		return "<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_ALLOWED%>";
	else
  		return "<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_DISALLOWED%>";
}

/**
 * returns queue Id
 */
function getQueueId()
{
  return CCQueueForm.<%=ECLivehelpConstants.EC_CC_QUEUE_ID%>.value;
}

/**
 * removes selected CSR from assigned list
 */
function removeFromList()
{
	bChanged=true;
	move(document.CCQueueForm.AssignedList, document.CCQueueForm.AllList);
   	updateSloshBuckets(document.CCQueueForm.AssignedList, document.CCQueueForm.removeButton, document.CCQueueForm.AllList, document.CCQueueForm.addButton);
}

/**
 * adds selected CSR into assigned list
 */
function addToList()
{
	bChanged=true;
	move(document.CCQueueForm.AllList, document.CCQueueForm.AssignedList);
	updateSloshBuckets(document.CCQueueForm.AllList, document.CCQueueForm.addButton, document.CCQueueForm.AssignedList, document.CCQueueForm.removeButton);
}

</script>

</head>

<body onload="loadPanelData()" class="content">

<h1><%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueDialogLabel"))%></h1>
<% if (qDB.findCCQueue()) {
		qDB.refreshDisplayInformation(languageId);
		queueDesc=qDB.getQueueDescription();
		queueDisplayName=qDB.getQueueDisplayName();
		if (queueDesc==null) {queueDesc="";}
		allCSR=qDB.getAllCSRs();
		vAssignedCSRs=qDB.getAssignedCSRInformation();
		vAllCSRs=qDB.getStoreCSRInformation();
        if (vAllCSRs==null) {vAllCSRs=new Vector();}
        if (vAssignedCSRs==null) {vAssignedCSRs=new Vector();}
 		for (int nIdx=0; nIdx<vAssignedCSRs.size();nIdx++) {
 		      Hashtable hsAS= (Hashtable) vAssignedCSRs.get(nIdx);
 		      String tmpID= (String) hsAS.get(ECLivehelpConstants.EC_CC_CSR_KEY_CSRID);
 		       for (int nIdx2=0; nIdx2<vAllCSRs.size();nIdx2++) {
			      Hashtable hsA= (Hashtable) vAllCSRs.get(nIdx2);
			      String tmpID2= (String) hsA.get(ECLivehelpConstants.EC_CC_CSR_KEY_CSRID);
 		             if ( tmpID.equals(tmpID2)) {
 		             		vAllCSRs.removeElementAt(nIdx2--);
 		             }
 		       }
		}
 %>

<p><%=(String)liveHelpNLS.get("assignCCQueueDialogInstruction")%></p>

<form name="CCQueueForm" id="WC_CCAssignQueueDialog_Form_1">

<p>
<%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueDialogQueueIdInput"))%>: <%=queueId%><br />
<%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueDialogQueueName"))%>: <%=queueDisplayName%><br />
<%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueDialogQueueDescription"))%>: <%=queueDesc%><br />
<input name="<%=ECLivehelpConstants.EC_CC_QUEUE_ID%>" type="hidden"	value="<%=queueId%>" /> <br />
<br />
<% if (allCSR!=null && allCSR.equals(ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_ALLOWED)) { %>
<input name="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR%>" id="WC_CCAssignQueueDialog_FormInput_1"
	type="radio" value="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_ALLOWED%>" onclick="javascript:hideCSRList();" checked="checked" /> 
	<label for="WC_CCAssignQueueDialog_FormInput_1"> <%= liveHelpNLS.get("assignCCQueueDialogQueueAllCSREnabledInput") %> </label><br />
<input name="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR%>" id="WC_CCAssignQueueDialog_FormInput_2" type="radio" value="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_DISALLOWED%>" onclick="javascript:showCSRList();" /> 
	<label for="WC_CCAssignQueueDialog_FormInput_2"> <%= liveHelpNLS.get("assignCCQueueDialogQueueAllCSRDisabledInput") %> </label><br />
<% } else { %> 
<input name="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR%>" id="WC_CCAssignQueueDialog_FormInput_1" type="radio" value="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_ALLOWED%>"	onclick="javascript:hideCSRList();" /> 
	<label for="WC_CCAssignQueueDialog_FormInput_1"> <%= liveHelpNLS.get("assignCCQueueDialogQueueAllCSREnabledInput") %> </label><br />
<input name="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR%>" id="WC_CCAssignQueueDialog_FormInput_2" type="radio" value="<%=ECLivehelpConstants.EC_CC_QUEUE_ALLCSR_DISALLOWED%>"	onclick="javascript:showCSRList();" checked="checked" /> 
	<label for="WC_CCAssignQueueDialog_FormInput_2"> <%= liveHelpNLS.get("assignCCQueueDialogQueueAllCSRDisabledInput") %> </label><br />
<% } %> 
<br />

</p>
<div id="CSRList" style="display: none">
<blockquote>

<table style="margin-top: 30pt; margin-left: 5pt" id="WC_CCAssignQueueDialog_Table_1" >
	<tbody>
		<tr>
			<td valign="bottom" class="selectWidth" id="WC_CCAssignQueueDialog_TableCell_1" >
				<label for="WC_CCAssignQueueDialog_FormInput_3"> <%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueDialogQueueAssignedCSRInput"))%></label>
			</td>
			<td width="130px" align="center" id="WC_CCAssignQueueDialog_TableCell_2">
			</td>
			<td valign="bottom" class="selectWidth" id="WC_CCAssignQueueDialog_TableCell_3">
				<label for="WC_CCAssignQueueDialog_FormInput_4"> <%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueDialogQueueAvailableCSRInput")) %></label>
			</td>
		</tr>
		<tr>
			<td valign="bottom" class="selectWidth" id="WC_CCAssignQueueDialog_TableCell_4">
				<select name="AssignedList"	id="WC_CCAssignQueueDialog_FormInput_3" class='selectWidth' size='5' multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.CCQueueForm.removeButton, document.CCQueueForm.AllList, document.CCQueueForm.addButton);">
					<% 
	               	  for (int nIdx=0; nIdx<vAssignedCSRs.size();nIdx++) {
	 		      		Hashtable htCSRInfo= (Hashtable) vAssignedCSRs.get(nIdx);
	 		      		CSRId= (String) htCSRInfo.get(ECLivehelpConstants.EC_CC_CSR_KEY_CSRID);
	 		      		CSRLogon=(String) htCSRInfo.get(ECLivehelpConstants.EC_CC_CSR_KEY_LOGONID);
	               	%>
					<option value="<%=CSRId%>"><%=CSRLogon%><% } %></option>
				</select>
			</td>
			<td width="130px" align="center" id="WC_CCAssignQueueDialog_TableCell_5">
				<button type="button" name="addButton" class="disabled"	style="width: 120px" onclick="addToList();"><%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueAddButton")) %></button><br />
				<button type="button" name="removeButton" class="disabled" style="width: 120px" onclick="removeFromList();"><%=UIUtil.toHTML((String)liveHelpNLS.get("assignCCQueueRemoveButton"))%></button><br />
			</td>
			<td valign="bottom" class="selectWidth" id="WC_CCAssignQueueDialog_TableCell_6">
				<select name="AllList" id="WC_CCAssignQueueDialog_FormInput_4" class='selectWidth' size='5' multiple="multiple" onchange="javascript:updateSloshBuckets(this, document.CCQueueForm.addButton, document.CCQueueForm.AssignedList, document.CCQueueForm.removeButton);">
					<% 
	               	  for (int nIdx=0; nIdx<vAllCSRs.size();nIdx++) {
			 		      Hashtable htCSRInfo= (Hashtable) vAllCSRs.get(nIdx);
			 		      CSRId= (String) htCSRInfo.get(ECLivehelpConstants.EC_CC_CSR_KEY_CSRID);
			 		      CSRLogon=(String) htCSRInfo.get(ECLivehelpConstants.EC_CC_CSR_KEY_LOGONID);
	               	%>
					<option value="<%=CSRId%>"><%=CSRLogon%><% } %></option>
				</select>
			</td>
		</tr>
	</tbody>
</table>
<br />
<br />
</blockquote>
</div>
<p></p>
</form>
<% } else { %>
<p><%=(String)liveHelpNLS.get("assignCCQueueDialogNoQueueMsg")%></p>
<% } %>
</body>
</html>
