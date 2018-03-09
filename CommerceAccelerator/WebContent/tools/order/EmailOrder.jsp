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
// 020723	    KNG		Initial Create
//
// 020815	    KNG		Make changes from code review
////////////////////////////////////////////////////////////////////////////////
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.messaging.databeans.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.optools.user.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@include file="../common/common.jsp" %>

<%!
public Hashtable getMessageTypeProfileInfo(Integer storeId, String msgTypeId, String transportId, CommandContext cmdContext, HttpServletRequest request) {
	Hashtable profileProperties = new Hashtable();
	String profileId = null;
	
	try {
		ProfileDataBean profileDB = new ProfileDataBean();
		profileDB.setStore_ID(storeId);
		DataBeanManager.activate(profileDB, request);
	
		for (int i=0; i<profileDB.getSize(); i++) {
			if (profileDB.getMsgType_ID(i).equals(msgTypeId) && profileDB.getTransport_ID(i).equals(transportId)) {
				profileId = profileDB.getProfile_ID(i);
				break;
			}
		}
	
		if (profileId != null) {
			CISEditAttDataBean cisAttributes = new CISEditAttDataBean();
			cisAttributes.setCommandContext(cmdContext);
			cisAttributes.setRequestProperties(new TypedProperty());
			cisAttributes.setProfile_ID(new Integer(profileId));
			cisAttributes.setStore_ID(storeId);
			cisAttributes.setTransport_ID(new Integer(transportId));
			DataBeanManager.activate(cisAttributes, request);
		
			for (int j=0; j<cisAttributes.numberOfElements(); j++) {
				if (cisAttributes.getName(j).equals("recipient") ||
				    cisAttributes.getName(j).equals("subject") ||
			 	    cisAttributes.getName(j).equals("sender") ||
			 	    cisAttributes.getName(j).equals("CC") ||
			 	    cisAttributes.getName(j).equals("BCC")) {
					profileProperties.put(cisAttributes.getName(j), cisAttributes.getValue(j));
				}
			}
		}
	
	} catch (Exception ex) {
		return profileProperties;
	}
	
	return profileProperties;
}


public String getCustomerEmailAddress(String orderId, HttpServletRequest request) throws Exception {
	OrderDataBean orderBean = new OrderDataBean ();
	AddressDataBean address = null;

	if ((orderId != null) && !(orderId.equals(""))) {
		orderBean.setSecurityCheck(false);
		try {
			orderBean.setOrderId(orderId);
			DataBeanManager.activate(orderBean, request);
		} catch (Exception ex) {
			ex.printStackTrace();			
			orderBean = null;
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
		} else {
			address = null;
		}
		
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
	return email;
}
%>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer storeId = cmdContextLocale.getStoreId();

Hashtable orderNotifyNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderNotifyNLS", jLocale);

com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String orderId = URLParameters.getParameter("orderId");

//messageTypeId 126 -> OrderReceived
//messageTypeId 128 -> MerchantOrderNotify
Hashtable shopperMsgProperties = getMessageTypeProfileInfo(storeId, "126", "1", cmdContextLocale, request);
Hashtable adminMsgProperties = getMessageTypeProfileInfo(storeId, "128", "1", cmdContextLocale, request);

String shopperRecipient = (String)shopperMsgProperties.get("recipient");
if (shopperRecipient == null || shopperRecipient.equals("")) {
	shopperRecipient = getCustomerEmailAddress(orderId, request);
}

String shopperCC = (String)shopperMsgProperties.get("cc");
if (shopperCC == null) {
	shopperCC = "";
}

String shopperBCC = (String)shopperMsgProperties.get("bcc");
if (shopperBCC == null) {
	shopperBCC = "";
}

String shopperSender = (String)shopperMsgProperties.get("sender");
if (shopperSender == null) {
	shopperSender = "";
}

String shopperSubject = (String)shopperMsgProperties.get("subject");
if (shopperSubject == null) {
	shopperSubject = "";
}

String adminRecipient = (String)adminMsgProperties.get("recipient");
if (adminRecipient == null) {
	adminRecipient = "";
}

String adminCC = (String)adminMsgProperties.get("cc");
if (adminCC == null) {
	adminCC = "";
}

String adminBCC = (String)adminMsgProperties.get("bcc");
if (adminBCC == null) {
	adminBCC = "";
}

String adminSender = (String)adminMsgProperties.get("sender");
if (adminSender == null) {
	adminSender = "";
}

String adminSubject = (String)adminMsgProperties.get("subject");
if (adminSubject == null) {
	adminSubject = "";
}

%>

<html>
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 

<title><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyTitle")) %></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript">
<!-- <![CDATA[
function initialize() {
	parent.setContentFrameLoaded(true);
}

function retrieveProfileInfo(value) {
	if (value == "OrderReceived") {
		document.orderNotifyForm.recipient.value = "<%= shopperRecipient %>";
		document.orderNotifyForm.CC.value = "<%= shopperCC %>";
		document.orderNotifyForm.BCC.value = "<%= shopperBCC %>";
		document.orderNotifyForm.subject.value = "<%= shopperSubject %>";
		document.orderNotifyForm.sender.value = "<%= shopperSender %>";
	} else if (value == "MerchantOrderNotify") {
		document.orderNotifyForm.recipient.value = "<%= adminRecipient %>";
		document.orderNotifyForm.CC.value = "<%= adminCC %>";
		document.orderNotifyForm.BCC.value = "<%= adminBCC %>";
		document.orderNotifyForm.subject.value = "<%= adminSubject %>";
		document.orderNotifyForm.sender.value = "<%= adminSender %>";	
	}
}

function savePanelData() {
	var messageType;
	
	if (document.orderNotifyForm.messageType[0].checked)
		messageType = document.orderNotifyForm.messageType[0].value;
	else if (document.orderNotifyForm.messageType[1].checked)
		messageType = document.orderNotifyForm.messageType[1].value;

	parent.put("orderId", document.orderNotifyForm.orderId.value);
	parent.put("messageType", messageType);
	parent.put("recipient", document.orderNotifyForm.recipient.value);
	parent.put("CC", document.orderNotifyForm.CC.value);
	parent.put("BCC", document.orderNotifyForm.BCC.value);
    	parent.put("subject", document.orderNotifyForm.subject.value);
    	parent.put("sender", document.orderNotifyForm.sender.value);
    	parent.put("URL", "DialogNavigation");
}

function validatePanelData() {
	if (document.orderNotifyForm.recipient.value == "") {
		alertDialog("<%= UIUtil.toJavaScript((String)orderNotifyNLS.get("orderNotifyNoRecipient")) %>");
		return false;
	}
	
	return true;
}
//]]> -->
</script>
</head>

<body onload="initialize();" class="content">
  <h1><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyTitle")) %></h1>
  <p><%= (String)orderNotifyNLS.get("orderNotifyDescription") %></p>
  
  <form name="orderNotifyForm">
  <input type="hidden" name="orderId" value="<%= orderId %>" />
  <table border="0" cellpadding="5" cellspacing="5">
  <tr>
    <td valign="bottom" align="left">
    <input type="radio" id="notify1" name="messageType" value="OrderReceived" checked ="checked"onclick="retrieveProfileInfo(this.value)" /><label for="notify1"><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyShopper")) %></label>
    </td>
  </tr>
  <tr>
    <td valign="bottom" align="left">
    <input type="radio" id="notify2" name="messageType" value="MerchantOrderNotify" onclick="retrieveProfileInfo(this.value)" /><label for="notify2"><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyAdmin")) %></label>
    </td>
  </tr>
  </table>
  <table border="0" cellpadding="5" cellspacing="5">
      <tr>
        <td colspan="2">
         <p></p>
         <br />
         <br />
         <p><u><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyParameters")) %></u></p>
        </td>
      </tr>
      <tr>
        <td valign="bottom" align="left">
        <label for="shopperRecipient"><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyRecipient")) %></label>
        </td>
        <td valign="bottom" align="left">
        <input type="text" id="shopperRecipient" name="recipient" value="<%= shopperRecipient %>" size="64" maxlength="254" />
        </td>
      </tr>
      <tr>
        <td valign="bottom" align="left">
        <label for="orderNotifyCC"><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyCC")) %></label>
        </td>
        <td valign="bottom" align="left">
        <input type="text" id="orderNotifyCC" name="CC" value="<%= shopperCC %>" size="64" maxlength="254" />
        </td>
      </tr>
	  <tr>
        <td valign="bottom" align="left">
        <label for="orderNotifyBCC"><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifyBCC")) %></label>
        </td>
        <td valign="bottom" align="left">
        <input type="text" id="orderNotifyBCC" name="BCC" value="<%= shopperBCC %>" size="64" maxlength="254" />
        </td>
      </tr>
      <tr>
        <td valign="bottom" align="left">
        <label for="orderNotifySender"><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifySender")) %></label>
        </td>
        <td valign="bottom" align="left">
        <input type="text" id="orderNotifySender" name="sender" value="<%= shopperSender %>" size="64" maxlength="254" />
        </td>
      </tr>
      <tr>
        <td valign="bottom" align="left">
        <label for="orderNotifySubject"><%= UIUtil.toHTML((String)orderNotifyNLS.get("orderNotifySubject")) %></label>
        </td>
        <td valign="bottom" align="left">
        <input type="text" id="orderNotifySubject" name="subject" value="<%= shopperSubject %>" size="64" maxlength="254" />
        </td>
      </tr>  
    </table>
  </form>
</body>
</html>
