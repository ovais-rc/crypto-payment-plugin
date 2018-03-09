<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 

<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContext.getLocale();
Hashtable orderMgmtNLS=(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String orderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID);
String billingAddressId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_BILLADDR_ID);
String customerId = "";

OrderDataBean orderBean = new OrderDataBean ();
AddressDataBean address = null;

if ((orderId != null) && !(orderId.equals(""))) {
	orderBean.setSecurityCheck(false);
	orderBean.setOrderId(orderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
	customerId = orderBean.getMemberId();

	OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
	
	registerDataBean.setUserId(customerId);
	DataBeanManager.activate(registerDataBean, request);
	String addressId = registerDataBean.getAddressId();
	if (addressId != null && addressId.length() != 0) {
		address = new AddressDataBean();
		address.setAddressId(addressId);
		DataBeanManager.activate(address, request);
	}
	
	if (null == address && billingAddressId != null && !billingAddressId.equals(""))
	{
		// When the customer is a guest shopper, the address will be null
		// Therefore, need to get the billing address instead
		address = new AddressDataBean();
		address.setAddressId(billingAddressId);
		DataBeanManager.activate(address, request);
		orderBean.setAddressId(billingAddressId);
	}
	
}



String email = "";
if (address != null)
{
	email = address.getEmail1();
	if ((email == null) || (email.equals("")) )
	{
		email = address.getEmail2();
		if (email == null)
			email = "";
	} 
	
}	

%>

<HTML>
<HEAD>
  <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
  
<TITLE><%= UIUtil.toJavaScript(orderMgmtNLS.get("addCommentsTitle")) %></TITLE>
  <script src="/wcs/javascript/tools/common/Util.js"></script>
  <script src="/wcs/javascript/tools/common/Vector.js"></script>
  <script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<SCRIPT>
  var order = parent.get("order");
  var comment = order["comment"];
   
  // remove preCommand in XML when this page loaded
  var preCommand = parent.get("preCommand");
  if (defined(preCommand) && preCommand != "") {
	parent.remove("preCommand");
  }
  
  parent.remove("preCmdChain");
  
  if (!defined(comment)) {
     comment = new Object();
     comment.value = "";
     comment.sendEmail = "false";
     addEntry(order, "comment", comment);
  }
  comment.emailAddress = "<%= UIUtil.toJavaScript(email) %>";

  if ((order.billingAddressId == null) || (order.billingAddressId == "")) {
  	updateEntry(order, "billingAddressId", "<%=billingAddressId%>");
  }

  function isValidLength(fieldName, maxLen) {
     if (fieldName.value != "") {
        if (!isValidUTF8length(fieldName.value, maxLen)) {
           alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("inputFieldMax")) %>");
           fieldName.select();
           return false;
        }
     }
     return true;
  }

  
  function initializeState() {
    
    document.addComments.commentField.value = comment.value;
    var division = document.all.emailAddrDiv;
    
    if (comment.sendEmail == "true") {
       document.addComments.notifyShopper.checked = true;
       document.addComments.emailAddress.value = comment.emailAddress;
       division.style.display = "block";
       document.addComments.sendEmail.value = "true";
    } else {
       document.addComments.notifyShopper.checked = false;
       document.addComments.emailAddress.value = "";
       division.style.display = "none";
       document.addComments.sendEmail.value = "false";
    }
    
    
    checkForErrors();
    parent.setContentFrameLoaded(true);
  }

  //check for errors comming back from validation
  function checkForErrors() {
    if ( defined(parent.getErrorParams()) ) {
       errorCode = parent.getErrorParams();
       if (errorCode == "addCommentsMax") {
       	  alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("addCommentsMax")) %>");
	  document.addComments.commentField.select();
       } else if (errorCode == "sendCommentsMissingEMailAddr") {
	  alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("sendCommentsMissingEMailAddr")) %>");
       } else if (errorCode == "invalidBillingEmailMsg") {
	  alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidBillingEmailMsg")) %>");
	  document.addComments.emailAddress.focus();
       }	
    }
  }
  
  function toggleCheckBox() {
      	with (document.addComments) {
      		var emailChecked = document.addComments.notifyShopper.checked;
      		var division = document.all.emailAddrDiv;
      	  
      		if (emailChecked) {
      			document.addComments.sendEmail.value = "true";
		    	division.style.display = "block";
		    	document.addComments.emailAddress.value = comment.emailAddress;
		    	document.addComments.emailAddress.select();
		} else {
			document.addComments.sendEmail.value = "false";
		    	division.style.display = "none";
		}
	
	}
   }
    
  // used to save the data in the panel to the model in both Notebook and Wizard
  function savePanelData()
  {
    comment.value = document.addComments.commentField.value;
    comment.emailAddress = document.addComments.emailAddress.value;
    comment.sendEmail = document.addComments.sendEmail.value;
    updateEntry(order, "comment", comment);
    var authToken = parent.get("authToken");
    if (defined(authToken)) {
	parent.addURLParameter("authToken", authToken);
    }
        
  }

  
  function validateNoteBookPanel() {
  	return validatePanelData();
  
  }
  
  // used to validate panel in the Wizard
  function validatePanelData() {
  
    var inLocale = parent.get("locale");
    var order = parent.get("order");
    var comment = order["comment"];
    
    
    if (defined(comment)) {
       if (!isValidUTF8length(comment.value, 1024)) {
	  alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("addCommentsMax")) %>");
	  document.addComments.commentField.select();
	  return false;
        }
        
        var tmpEmailAddr = comment.emailAddress;
	  
	    
	if (!checkIfMissingMandatroyEMailAddr(tmpEmailAddr)) {
	    	return false;
	}	
	
	    
	if (!(checkEmailAddress(tmpEmailAddr)))
		return false;
	        
    
    }
    
   
    
    return true;  
  }
  
  function checkIfMissingMandatroyEMailAddr(tmpEmailAddr)
  {

	// If the user wants to send an email to customer but no email specified
	// return error
	
	if (document.addComments.notifyShopper.checked) {
	   	if (!(defined(tmpEmailAddr)) || (tmpEmailAddr == ""))
	    	{
	    	
	    		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("sendCommentsMissingEMailAddr")) %>");
	    		return false;
	    	}
	    	
	    	
    	}
  
  	return true;	  
  
  }
  
  function checkEmailAddress(tmpEmail)
  {
  	if ( (tmpEmail != "") && (find(tmpEmail, "@") == "false") ) {
  		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidEmailMsg")) %>");
        	document.addComments.emailAddress.focus();
        	return false;
        }
  
  	return true;
  }
</SCRIPT>
</HEAD>

<BODY onLoad="initializeState(); document.addComments.commentField.focus();" class="content">

<TITLE><%= UIUtil.toHTML((String) orderMgmtNLS.get("addCommentsTitle")) %></TITLE>

<FORM NAME='addComments' METHOD='POST'>
  <h1><%= UIUtil.toHTML((String) orderMgmtNLS.get("addCommentsTab")) %></h1>
 
 <!-- Support For Customers,Shopping Under Multiple Accounts -->
   <%request.setAttribute("resourceBundle", orderAddProducts);%> 
<jsp:include page="ActiveOrganization.jsp"
	flush="true" /> 
	<br />
<SCRIPT>
 var editOrderInfo = parent.get("editOrderInfo");
 var backupOrder = order.backupOrder;
 if (defined(editOrderInfo) && editOrderInfo == "true")
	document.writeln('<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("addCommentsInstructionsForEdit")) %>');
 else if (defined(backupOrder)) {
	var backupOrderId = backupOrder.id;
	if (defined(backupOrderId) && backupOrderId != "")
		document.writeln('<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("addCommentsInstructionsForEdit")) %>');
 } else 
	document.writeln('<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("addCommentsInstructionsForNew")) %>');
</SCRIPT>
  <TABLE BORDER='0'>
    <TR>
      <TD COLSPAN=4>
        <P><BR><label for="commentFd"><%= UIUtil.toHTML((String) orderMgmtNLS.get("addCommentsPleaseEnterComment")) %></label><BR>
      </TD>
    </TR>
    
    <TR>
      <TD COLSPAN=4>
        <TEXTAREA id="commentFd" NAME='commentField' VALUE='' rows=5 cols=60 WRAP=on></TEXTAREA>
      </TD>
    </TR>
    <TR>
      <TD COLSPAN=4>
        <BR>
        <LABEL>
        <INPUT TYPE=checkbox
               NAME='notifyShopper'
               VALUE='yes'
               onClick='toggleCheckBox();'><%= UIUtil.toHTML((String)orderMgmtNLS.get("addCommentsSendToShopper")) %></LABEL><BR>
      </TD>
    </TR>
    </TABLE>
    <DIV id="emailAddrDiv" style="display: none">
	    <P>
	    <label for="email1"><%= UIUtil.toHTML((String)orderMgmtNLS.get("email")) %></label><BR>
	    <input type="text" id="email1" name="emailAddress"  size=58 maxlength=256 onfocus='toggleCheckBox();' onChange="isValidLength(document.addComments.emailAddress, 256); checkEmailAddress(document.addComments.emailAddress.value);">
    </DIV>
	
 
  <INPUT TYPE='hidden' NAME='sendEmail' VALUE='false'>
</FORM>
</BODY>

</HTML>



