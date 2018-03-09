<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<HTML>

<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	java.util.Locale jLocale = cmdContext.getLocale();
	
	Integer langId = cmdContext.getLanguageId();
	JSPHelper jspHelp = new JSPHelper(request);
	String customerId = jspHelp.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);
	
%>

<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

<SCRIPT type="text/javascript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></SCRIPT>
<SCRIPT type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></SCRIPT>
<SCRIPT type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT type="text/javascript">
<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------

var order = parent.get("order");
var preCommand = parent.get("preCommand");

if (!defined(order)) {
	order = new Object();
	parent.put("order", order);
}



function getCustomerId() {
	var customerId = "<%=UIUtil.toJavaScript(customerId)%>";
	if (customerId == "") {
		customerId = order["customerId"];
		if (!defined(customerId))
			customerId = "";
	}
	updateEntry(order, "customerId", customerId);
	return customerId;
}


// Only retrieve the first order id
function get1stOrderId() {
       var firstOrder = order["firstOrder"];
       if (!defined(firstOrder)) {
              return "";
       }
       var orderId = firstOrder["id"];
       if (!defined(orderId)) {
              return "";
       }
       return orderId;
}

// Only retrieve the second order id
function get2ndOrderId() {
       var secondOrder = order["secondOrder"];
       if (!defined(secondOrder)) {
              return "";
       }
       var orderId = secondOrder["id"];
       if (!defined(orderId)) {
              return "";
       }
       return orderId;
}

function getXML() {
	return parent.modelToXML("XML");
}


function getRedirectURL() {
	return "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderItemsPageB2C&cmd=OrderItemsPageB2C&firstOrderId="+get1stOrderId()+"&secondOrderId="+get2ndOrderId()+"&customerId="+getCustomerId();
}

function executeNextPage() {
	var order = parent.get("order");
	var authToken = parent.get("authToken");
	if (!defined(authToken)) {
		parent.put("authToken", document.formToSubmit.authToken.value);
	}
	
	if (!defined(order)) {
		alertDialog("Fatal error! Wizard data model is corrupted.");
	} else {
		if ( preCommand != null && preCommand != "") {
			document.formToSubmit.action=preCommand;
			document.formToSubmit.URL.value = getRedirectURL();
			document.formToSubmit.XML.value = getXML();
			document.formToSubmit.submit();
		} else {
			this.location.replace(getRedirectURL());
		}
	}
}
//[[-->
</SCRIPT>
</HEAD>
<BODY class="content" onload="executeNextPage();">
<FORM NAME="formToSubmit" ACTION="" method="post">
	<input type="hidden" name="authToken" value="${authToken}" id="WC_OrderPlaceOrderInitB2CForm_FormInput_authToken"/>
	<INPUT TYPE="hidden" NAME="URL" VALUE="">
	<INPUT TYPE="hidden" NAME="XML" VALUE="">
</FORM>
</BODY>
</HTML>



