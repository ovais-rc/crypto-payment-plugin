<!--********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------
*-->
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.store.commands.*" %>
<%@ page import="com.ibm.commerce.store.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
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

if (sender == null) {
	sender = "";
}
if ( (openStores == null) && (closedStores == null) && (suspendedStores == null) ) {
	openStores = "1";
	closedStores = "1";
	suspendedStores = "1";
} else if (openStores == null) {
	openStores = "0";
} else if (closedStores == null) {
	closedStores = "0";
} else if (suspendedStores == null) {
	suspendedStores = "0";
}
if (recipient == null) {
	recipient = "";
}
if (subject == null) {
	subject = "";
}
if (messageContent == null) {
	messageContent = "";
}

%>


<html>
  <head>  
    <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
    
    <title><%= UIUtil.toHTML(broadcastNLS.get("broadcastAdmin").toString()) %></title>   
    <script src="/wcs/javascript/tools/common/Util.js"></script>
    <script src="/wcs/javascript/tools/common/Vector.js"></script>


	<script>
	function initializeState() {
		parent.setContentFrameLoaded(true);
	}


	function initializeCheckBoxes() {
		if (document.sendForm.openStores.value == "1")
			document.sendForm.openStores.checked = true;
		if (document.sendForm.closedStores.value == "1")
			document.sendForm.closedStores.checked = true;
		if (document.sendForm.suspendedStores.value == "1")
			document.sendForm.suspendedStores.checked = true;
	}


	function toggleCheckBox(name) {
      		var isChecked = document.sendForm[name].checked;
      		
      		if (isChecked) {
      			document.sendForm[name].value = "1";
		} else {
			document.sendForm[name].value = "0";
		}
	}
	
	function validateLength(value, maxlength, errorMsg) {
		if (utf8StringByteLength(value) == maxlength) {
			if (confirmDialog(errorMsg)) {
				return true;
			} else {
				return false;
			}
		}
		return true;
	}
	
	function send() {
		validationOK = true;
		
		var lengthErrorMsg = "<%= UIUtil.toJavaScript(broadcastNLS.get("invalidLength")) %>";
		
		// make sure there is some kind of recipients
		if ( (document.sendForm.recipient.value == "") && 
				(document.sendForm.openStores.value == "0") &&
				(document.sendForm.closedStores.value == "0") &&
				(document.sendForm.suspendedStores.value == "0") ) {
			alertDialog("<%= UIUtil.toJavaScript(broadcastNLS.get("recipientsEmpty")) %>");
			validationOK = false;
		}
		
		if (document.sendForm.sender.value != "") {
			var senderError = lengthErrorMsg;
			if (!validateLength(document.sendForm.sender.value, 254, senderError.replace(/%1/, "<%= UIUtil.toJavaScript(broadcastNLS.get("sender")) %>"))) {
				validationOK = false;
			}
		}
		
		if (document.sendForm.subject.value != "") {
			var subjectError = lengthErrorMsg;
			if (!validateLength(document.sendForm.subject.value, 254, subjectError.replace(/%1/, "<%= UIUtil.toJavaScript(broadcastNLS.get("subject")) %>"))) {
				validationOK = false;
			}
		}
		
		// make sure messageContent is not blank
		if (document.sendForm.messageContent.value == "") {
			alertDialog("<%= UIUtil.toJavaScript(broadcastNLS.get("messageContentEmpty")) %>");
			validationOK = false;
		}
		
		if (validationOK) {
			URLParam = new Object();
			URLParam["<%= ECConstants.EC_URL %>"] = "BroadcastAdminRedirect?<%= AdminBroadcastMessageCmd.EC_MESSAGE_CONTENT %>=&<%= AdminBroadcastMessageCmd.EC_RECIPIENT %>=";
			URLParam["<%= ECConstants.EC_ERROR_VIEWNAME %>"] = "BroadcastAdminRedirect";
			URLParam["<%= AdminBroadcastMessageCmd.EC_HOSTING_MODE %>"] = "<%= AdminBroadcastMessageCmd.EC_TRUE %>";

			var url = "/webapp/wcs/tools/servlet/AdminBroadcastMessage?";
			URLParam["<%= AdminBroadcastMessageCmd.EC_MESSAGE_CONTENT %>"] = document.sendForm.messageContent.value;
			URLParam["<%= AdminBroadcastMessageCmd.EC_RECIPIENT %>"] = document.sendForm.recipient.value;
			URLParam["<%= AdminBroadcastMessageCmd.EC_SENDER %>"] = document.sendForm.sender.value;
			URLParam["<%= AdminBroadcastMessageCmd.EC_SUBJECT %>"] = document.sendForm.subject.value;
			
			counter = 1;
			if (document.sendForm.openStores.value == "1") {
				URLParam["<%= AdminBroadcastMessageCmd.EC_TARGET_STORE_STATE %>" + "_" + counter] = "<%= StoreConstants.STATUS_OPEN.toString() %>";
				counter++;
			}
			if (document.sendForm.closedStores.value == "1") {
				URLParam["<%= AdminBroadcastMessageCmd.EC_TARGET_STORE_STATE %>" + "_" + counter] = "<%= StoreConstants.STATUS_CLOSE.toString() %>";
				counter++;
			}
			if (document.sendForm.suspendedStores.value == "1") {
				URLParam["<%= AdminBroadcastMessageCmd.EC_TARGET_STORE_STATE %>" + "_" + counter] = "<%= StoreConstants.STATUS_SUSPEND.toString() %>";
				counter++;
			}
			
			//send data for easy retrieving
			URLParam["openStores"] = document.sendForm.openStores.value;
			URLParam["closedStores"] = document.sendForm.closedStores.value;
			URLParam["suspendedStores"] = document.sendForm.suspendedStores.value;
						
			parent.setContentFrameLoaded(false);
			top.mccmain.submitForm(url,URLParam);
      			top.refreshBCT();
			
			//document.sendForm.submit();
		}
	}
	</script>
	
  </head>

  <body class=content onload="initializeState();">
  <h1><%= UIUtil.toHTML((String)broadcastNLS.get("broadcastAdminTitle")) %></h1>
  <p><%= UIUtil.toHTML((String)broadcastNLS.get("broadcastDescription")) %>    

    <form name="sendForm"
          method="post" >

	<table border=0 cellpadding=0 cellspacing=0>
        <tr>
          <td valign="bottom" align="left">
            <label for="WCBroadcastAdmin_sender"><%= UIUtil.toHTML((String)broadcastNLS.get("sender")) %></label><br />
          </td>
	</tr>
	<tr>
          <td valign="bottom" align="left">
            <input type="text" name="sender" id="WCBroadcastAdmin_sender" size=50 maxlength=254 value="<%= sender %>"><br /><br />
          </td>
        </tr>
        
        <tr>
          <td valign="bottom" align="left">
            <%= UIUtil.toHTML((String)broadcastNLS.get("recipients")) %></label><br />
          </td>
	</tr>
	<tr>
	  <td valign="bottom" align="left">
            <input type="checkbox" name="openStores" id="WCBroadcastAdmin_openStores" value="<%= openStores %>" onClick="toggleCheckBox(this.name)"><label for="WCBroadcastAdmin_openStores"><%= UIUtil.toHTML((String)broadcastNLS.get("openStores")) %></label>
          </td>
	</tr>
        <tr>
          <td valign="bottom" align="left">
            <input type="checkbox" name="closedStores" id="WCBroadcastAdmin_closedStores" value="<%= closedStores %>" onClick="toggleCheckBox(this.name)"><label for="WCBroadcastAdmin_closedStores"><%= UIUtil.toHTML((String)broadcastNLS.get("closedStores")) %></label>
          </td>
	</tr>
        <tr>
          <td valign="bottom" align="left">
            <input type="checkbox" name="suspendedStores" id="WCBroadcastAdmin_suspendedStores" value="<%= suspendedStores %>" onClick="toggleCheckBox(this.name)"><label for="WCBroadcastAdmin_suspendedStores"><%= UIUtil.toHTML((String)broadcastNLS.get("suspendedStores")) %></label><BR><BR>
          </td>
	</tr>
	<script>
	initializeCheckBoxes();
	</script>
        <tr>
          <td valign="bottom" align="left">
            <label for="WCBroadcastAdmin_recipient"><%= UIUtil.toHTML((String)broadcastNLS.get("additionalRecipients")) %></label><br />
          </td>
	</tr>
	<tr>
          <td valign="bottom" align="left">
            <input type="text" name="recipient" id="WCBroadcastAdmin_recipient" size=50 maxlength=10000000000 value="<%= recipient %>"><br /><br />
          </td>
        </tr>
        
        <tr>
          <td valign="bottom" align="left">
            <label for="WCBroadcastAdmin_subject"><%= UIUtil.toHTML((String)broadcastNLS.get("subject")) %></label><br />
          </td>
	</tr>
	<tr>
          <td valign="bottom" align="left">
            <input type="text" name="subject" id="WCBroadcastAdmin_subject" size=50 maxlength=254 value="<%= subject %>"><br /><br />
          </td>
        </tr>
        
        <tr>
          <td valign="bottom" align="left">
            <label for="WCBroadcastAdmin_messageContent"><%= UIUtil.toHTML((String)broadcastNLS.get("messageContent")) %></label><br />
          </td>
	</tr>
	<tr>
          <td valign="bottom" align="left">
            <textarea name="messageContent" id="WCBroadcastAdmin_messageContent" rows=8 cols=100 WRAP=on><%= messageContent %></textarea>
          </td>
        </tr>
      </table>
    </form>
  </body>
</html>
