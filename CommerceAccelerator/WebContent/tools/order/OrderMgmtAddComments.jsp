<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
Hashtable orderLabels=(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderLabels", jLocale);

String[] selectedOrders = Util.tokenize(request.getParameter("selectedOrders"), ",");
String email = "";


// Only get the default email address where there is only one order selected
if (selectedOrders.length == 1)
{

	String orderId = selectedOrders[0];
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
			
		
		if (null == address)
		{
			// When the customer is a guest shopper, there is no registered address
			// Therefore, need to get the billing address of the order instead
			String billingAddressId = orderBean.getAddressId();
			if ((null != billingAddressId) && !(billingAddressId.equals("")))
			{
				address = new AddressDataBean();
				address.setAddressId(billingAddressId);
				DataBeanManager.activate(address, request);
			}	
			
		}
		
	
	}



	
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

}

%>

<html>
<head>
  <title><%= orderLabels.get("addCommentsTitle") %></title>
  <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
  
  <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
  <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
  <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
  <script type="text/javascript">
  <!-- <![CDATA[
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
    document.addComments.notifyShopper.checked = false;
    document.addComments.emailAddress.blur();
    parent.setContentFrameLoaded(true);
  }

  
  // used to determine and save the state of the checkbox
  function toggleCheckBox()
  {
  
      	with (document.addComments) {
         		var emailChecked = document.addComments.notifyShopper.checked;
         		var division = document.all.emailAddrDiv;
         	  
         		if (emailChecked) {
         			document.addComments.sendEmail.value = "true";
   		    	division.style.display = "block";
   		    	document.addComments.emailAddress.value = "<%=email%>";
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
    	parent.put("selectedOrders", document.addComments.selectedOrders.value);
        parent.put("sendEmail", document.addComments.sendEmail.value);
        parent.put("commentField", document.addComments.commentField.value);
        parent.put("emailAddress", document.addComments.emailAddress.value);
        parent.put("noResourceBundleMsg", "<%= UIUtil.toJavaScript((String)orderLabels.get("noResourceBundleMsg")) %>");
	return true;
  }

  // used to validate panel in the Wizard
  function validatePanelData() {
  
    var comment = document.addComments.commentField.value;
    
    if (trim(comment) == "") {
    	alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("commentsMustAdd")) %>");
    	return false;
    }
    
    if (defined(comment)) {
    
       if (!isValidUTF8length(comment, 1024)) {
	  alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("inputFieldMax")) %>");
	  document.addComments.commentField.select();
	  return false;
        }
        
        var tmpEmailAddr = document.addComments.emailAddress.value;
	  
	    
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
  		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidBillingEmailMsg")) %>");
        	document.addComments.emailAddress.focus();
        	return false;
        }
  
  	return true;
  }
//[[>-->
</script>
</head>

<body onload="initializeState(); document.addComments.commentField.focus();" class="content">

<form name="addComments">
  <h1><%= orderLabels.get("addCommentsTitle") %></h1>
  <p><br /><%= orderLabels.get("addCommentsInstructions") %><br /><br /></p>
  <table border="0">
    <tr>
        <td colspan="5">
            <label for="commentsFd"><%= orderLabels.get("addCommentsCommentFieldTitle") %></label>
        </td>
    </tr>
    <tr>
      <td colspan="5">
        <textarea id="commentsFd" name="commentField" rows="5" cols="60"></textarea>
      </td>
    </tr>
    <tr>
      <td colspan="5">
        <br />
        <input type="checkbox"
               name="notifyShopper"
               id="sendToShopper"
               value="yes"
               onclick="toggleCheckBox();" />
               <label for="sendToShopper"><%= orderMgmtNLS.get("addCommentsSendToShopper") %></label><br />
      </td>
    </tr>
    </table>
     <div id="emailAddrDiv" style="display: none">
		<p>
    	<label for="email1"><%= UIUtil.toHTML((String)orderMgmtNLS.get("email")) %></label><br />
    	<input type="text" id="email1" name="emailAddress"  size="58" maxlength="256" onfocus="toggleCheckBox();" onchange="isValidLength(document.addComments.emailAddress, 256); checkEmailAddress(document.addComments.emailAddress.value);" />
   		</p>
   	</div>
  <input type="hidden" name="sendEmail" value="false" />
  <input type="hidden" name="selectedOrders" value='<%= UIUtil.toHTML(request.getParameter("selectedOrders")) %>' />
</form>
</body>
</html>



