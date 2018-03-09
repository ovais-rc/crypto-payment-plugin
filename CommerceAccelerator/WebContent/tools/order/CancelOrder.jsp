


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.edp.beans.EDPReleasesDataBean" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>

<%
   	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
   	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
	Hashtable orderMgmtNLS	= (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);

    Integer storeId = cmdContextLocale.getStoreId();
    StoreDataBean  storeBean = new StoreDataBean();
    storeBean.setStoreId(storeId.toString());
    com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);

	String orderId = request.getParameter("selectedOrders");

	OrderDataBean orderBean = new OrderDataBean ();
	AddressDataBean address = null;
	boolean paymentReleaseExisting = false;
	if ((orderId != null) && !(orderId.equals(""))) {
		orderBean.setSecurityCheck(false);
		try {
			orderBean.setOrderId(orderId);
			DataBeanManager.activate(orderBean, request);
		} catch (Exception ex) {
			ex.printStackTrace();			
			orderBean = null;
		}
		
		EDPReleasesDataBean edpReleases = new EDPReleasesDataBean();
		edpReleases.setOrderId(new Long(orderId));
		com.ibm.commerce.beans.DataBeanManager.activate(edpReleases, request);
		if(edpReleases.getReleases().size()>0){
			paymentReleaseExisting = true;
		}
		
	}

	if (null != orderBean) {
		String customerId = orderBean.getMemberId();
		String billingAddressId = orderBean.getAddressId();

		OptoolsRegisterDataBean registerDataBean = new OptoolsRegisterDataBean();
		String addressId = null;
		
		if (customerId != null && customerId.length() != 0) {
			try {
				registerDataBean.setUserId(customerId);
				DataBeanManager.activate(registerDataBean, request);
				addressId = registerDataBean.getAddressId();
		
				if (addressId != null && addressId.length() != 0) {
					address = new AddressDataBean();
					address.setAddressId(addressId);
					DataBeanManager.activate(address, request);
				}
		
			} catch (Exception ex) {
				address = null;	
				
		
			}
		} else
			address = null;
		
		
		if (null == address) {
			// When the customer is a guest shopper, the address will be null
			// Therefore, need to get the billing address instead
			if (billingAddressId != null && billingAddressId.length() != 0) {
				address = new AddressDataBean();
				address.setAddressId(billingAddressId);
			
				try {
					DataBeanManager.activate(address, request);
				} catch (Exception ex) {
					address = null;
			
				}
			}	
		}
	
	}



String email = "";
if (address != null)
{
	email = address.getEmail1();
	if ((email == null) || (email.equals("")) )
	{
		email = address.getEmail2();
		if (email == null) {
			email = "";
		}
	} 
	
}	
	
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>

<html>
<head>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<title><%= UIUtil.toJavaScript(orderLabels.get("changeStatusCancelTitle")) %></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[
	var paymentReleaseExisting =<%=paymentReleaseExisting%>;

function savePanelData() {

	parent.put("selectedOrders", document.CancelOrders.selectedOrders.value);
	parent.put("newComment", document.CancelOrders.commentField.value);
	parent.put("changeStatusDatabaseErrorMsg", "<%= UIUtil.toJavaScript((String)orderLabels.get("changeStatusDatabaseError")) %>");
    parent.put("noResourceBundleMsg", "<%= UIUtil.toJavaScript((String)orderLabels.get("noResourceBundleMsg")) %>");
    parent.put("URL", "DialogNavigation");
    parent.put("email", document.CancelOrders.emailAddress.value);
    parent.put("sendEmail", document.CancelOrders.sendEmail.value);
	parent.put("notifyShopper", document.CancelOrders.notifyShopper.value);
	parent.put("notifyMerchant", document.CancelOrders.notifyMerchant.value);
	parent.put("forcedCancel", document.CancelOrders.forcedCancel.checked);
}

function validatePanelData() {
	
	if ( !isValidComment() ) 
       		return false;
    	
    	return true;	
}



/******************************
* validate the comment field to ensure that a comment is entered
*******************************/
function isValidComment() {
	var comment = parent.get("newComment");
	
	if (comment.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)orderLabels.get("changeStatusPleaseEnterComment")) %>");
      		return false;
	} else {
		if (!isValidUTF8length(document.CancelOrders.commentField.value, 1024)) {
      			alertDialog("<%= UIUtil.toJavaScript((String)orderLabels.get("inputFieldMax")) %>");
      			document.CancelOrders.commentField.select();
      			return false;
      		}
      		
      		var tmpEmailAddr = document.CancelOrders.emailAddress.value;
			  
			    
		if (!checkIfMissingMandatoryEMailAddr(tmpEmailAddr)) {
		    	return false;
		}	
			
			    
		if (!(checkEmailAddress(tmpEmailAddr)))
			return false;
    	}
    	if(!document.CancelOrders.forcedCancel.checked && paymentReleaseExisting){
    		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("forcedCancelInstruction")) %>");  
    		return false;
    	}
    	
    	return true;
}

 function checkIfMissingMandatoryEMailAddr(tmpEmailAddr)
  {

	// If the user wants to send an email to customer but no email specified
	// return error
	
	if (document.CancelOrders.notifyShopperBox.checked) {
	   	if (!(defined(tmpEmailAddr)) || (tmpEmailAddr == ""))
	    	{
	    	
	    		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("sendCommentsMissingEMailAddr")) %>");
	    		return false;
	    	}
	    	
	    	
    	}
  
  	return true;	  
  
  }


/******************************
* preset the comment field
*******************************/
function setComment() {
	document.CancelOrders.commentField.value = "<%= UIUtil.toJavaScript((String)orderLabels.get("changeStatusCancelMsg")) %>";
}

function initializeState() {
	parent.setContentFrameLoaded(true);
}

// used to determine and save the state of the checkbox
function toggleCheckBox() {
  
       	with (document.CancelOrders) {
        		var emailChecked = document.CancelOrders.notifyShopperBox.checked;
        		var division = document.all.emailAddrDiv;
        	  
        		if (emailChecked) {
        			document.CancelOrders.sendEmail.value = "true";
  		    	division.style.display = "block";
  		    	document.CancelOrders.emailAddress.value = "<%=email%>";
  		    	document.CancelOrders.emailAddress.select();
  		} else {
  			document.CancelOrders.sendEmail.value = "false";
  		    	division.style.display = "none";
  		}
  	
	}
  
}

function checkEmailAddress(tmpEmail) {
  	if ( (tmpEmail != "") && (find(tmpEmail, "@") == "false") ) {
  		alertDialog("<%= UIUtil.toJavaScript((String)orderMgmtNLS.get("invalidEmailMsg")) %>");
        	document.CancelOrders.emailAddress.focus();
        	return false;
        }
  
  	return true;
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
//[[>-->
</script>
</head>


<body class="content" onload="setComment(); initializeState();">
<h1><%= orderLabels.get("changeStatusCancelTitle") %></h1>

<form name="CancelOrders">
	<input type="hidden" name="newState" value="X" />
   	<%= orderLabels.get("orderCancelInstructions") %><br /><br />
	<%= orderMgmtNLS.get("orderNumber") %><i><%=UIUtil.toHTML(orderId)%></i><br/><br/>
	<label for="commentsField"><%= orderLabels.get("changeStatusCommentFieldTitle") %></label><br /><br />
	<textarea name="commentField" rows="7" cols="60" id="commentsField"></textarea> <!-- removed a wrap="on" -->
	<input type="hidden" name="selectedOrders" value="<%=UIUtil.toHTML((String) request.getParameter("selectedOrders")) %>" />
	<input type="hidden" name="sendEmail" value="false" /><br /><br />
	<label for="forcedCancel"><%= orderMgmtNLS.get("forcedCancelInstruction")%></label><br /><br />
	<input type="checkbox" name="forcedCancel" value="yes" id="forcedCancel"/><label for="forcedCancel"><%= orderMgmtNLS.get("forcedCancel") %></label><br/><br/>
	<input type="checkbox" name="notifyShopperBox" value="yes" onclick="toggleCheckBox();" id="notifyShopperBox"/><label for="notifyShopperBox"><%= orderMgmtNLS.get("addCommentsSendToShopper") %></label><br />
    <div id="emailAddrDiv" style="display: none">
    <p>
    <label for="emailAddress"><%= UIUtil.toHTML((String)orderMgmtNLS.get("email")) %></label><br />
    <input type="text" id="emailAddress" name="emailAddress"  size="58" maxlength="256" onfocus='toggleCheckBox();' onchange="isValidLength(document.CancelOrders.emailAddress, 256); checkEmailAddress(document.CancelOrders.emailAddress.value);" />
	</p>
	</div>      
    <input type="hidden" name="notifyMerchant" value="1" />
    <input type="hidden" name="notifyShopper" value="1" />
</form>
</body>
</html>



