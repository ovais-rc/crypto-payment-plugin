<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>
<!--
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
-->

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%!
public String getPayAddressId(String payTCId, String customerId, HttpServletRequest request) {
	
	String payNickName = "";
	String payMemberId = "";
	String payAddressId = "";
	
	try {
		if (payTCId != null && !payTCId.equals("")) {
			PaymentTCDataBean payTC = new PaymentTCDataBean();
			payTC.setInitKey_referenceNumber(payTCId);
			DataBeanManager.activate(payTC, request);
			payNickName = payTC.getNickName();
			payMemberId = payTC.getMemberId();
		}
		
		if (payNickName != null && !payNickName.equals("") && payMemberId != null && !payMemberId.equals("") ) {
			AddressAccessBean payAddress = new AddressAccessBean();
			payAddress = payAddress.findByNickname(payNickName, new Long(payMemberId));
			if (payAddress != null)
				payAddressId = payAddress.getAddressId();
		}
	} catch (Exception ex) {}
	
	return payAddressId;
}

%>
<%
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContextLocale.getLocale();
	Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
	
	JSPHelper jspHelp = new JSPHelper(request);
	String customerId = jspHelp.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);
	String firstOrderId = jspHelp.getParameter("1stOrderId");
	String secondOrderId = jspHelp.getParameter("2ndOrderId");
	

	//
	// Check if orders actually have order items.
	//
	OrderDataBean orderBean = new OrderDataBean ();
	OrderDataBean orderBean2 = new OrderDataBean ();
	OrderItemDataBean[] afirstOrderItems = null;
	OrderItemDataBean[] asecondOrderItems = null;
	boolean firstOrderExist = false;
	boolean secondOrderExist = false;

	if ((firstOrderId != null) && !(firstOrderId.equals(""))) {
		orderBean.setOrderId(firstOrderId);
		com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
		afirstOrderItems = orderBean.getOrderItemDataBeans();
		if (afirstOrderItems.length != 0)
			firstOrderExist = true;
	}

	if ((secondOrderId != null) && !(secondOrderId.equals(""))) {
		orderBean2.setOrderId(secondOrderId);
		com.ibm.commerce.beans.DataBeanManager.activate(orderBean2, request);
		asecondOrderItems = orderBean2.getOrderItemDataBeans();
		if (asecondOrderItems.length != 0)
			secondOrderExist = true;
	}

	
	String firstPaymentTCId = jspHelp.getParameter("1stPaymentTCId");
	String secondPaymentTCId = jspHelp.getParameter("2ndPaymentTCId");
	String firstBillingAddressId = jspHelp.getParameter("1stBillingAddressId");
	String secondBillingAddressId = jspHelp.getParameter("2ndBillingAddressId");
	String displayForOrder = jspHelp.getParameter("displayBillingAddressForOrder");
	
	String firstPayAddressId = getPayAddressId(firstPaymentTCId, customerId, request);
	String secondPayAddressId = getPayAddressId(secondPaymentTCId, customerId, request);
		
%>
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript">
	<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------

function onLoad() {
	 loadPanelData();
	 <% if (displayForOrder == null || displayForOrder.length() == 0) { %>
         	parent.setContentFrameLoaded(true);
         <% } else {%>
         	parent.parent.setContentFrameLoaded(true);
         <% }%>
}

function loadPanelData() {
	// remove preCommand in XML when this page loaded
	<% if (displayForOrder == null || displayForOrder.length() == 0) { %>
		var preCommand = parent.get("preCommand");
		if (defined(preCommand) && preCommand != "") {
				parent.put("preCommand", "");
		}
	<% } %>
	
}

function executeFirstPage() {
	var url;
	var firstPayAddressId = "<%=firstPayAddressId%>";
	if (firstPayAddressId != "") {
		url = "/webapp/wcs/tools/servlet/OrderBillingAddressInfoB2B?customerId="+"<%=customerId%>"+"&amp;billingAddressId="+firstPayAddressId+"&amp;displayForOrder="+"<%=displayForOrder%>";
	} else {
		<%if (displayForOrder == null || displayForOrder.length() == 0) { %>
			url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderBillingAddressPage&cmd=OrderBillingAddressPage&amp;customerId="+"<%=customerId%>"+"&amp;1stOrderId="+"<%=firstOrderId%>"+"&amp;1stBillingAddressId="+"<%=firstBillingAddressId%>";
		<% } else { %>
			url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderBillingAddressFramePage&cmd=OrderBillingAddressPage&amp;customerId="+"<%=customerId%>"+"&amp;1stOrderId="+"<%=firstOrderId%>"+"&amp;1stBillingAddressId="+"<%=firstBillingAddressId%>"+"&amp;displayForOrder="+"<%=displayForOrder%>";
		<% } %>
	}
	this.location.replace(url);
}

function executeSecondPage() {
	var url;
	var secondPayAddressId = "<%=secondPayAddressId%>";
	if (secondPayAddressId != "") {
		url = "/webapp/wcs/tools/servlet/OrderBillingAddressInfoB2B?customerId="+"<%=customerId%>"+"&amp;billingAddressId="+secondPayAddressId+"&amp;displayForOrder="+"<%=displayForOrder%>";
	} else {
		<%if (displayForOrder == null || displayForOrder.length() == 0) { %>
			url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderBillingAddressPage&cmd=OrderBillingAddressPage&amp;customerId="+"<%=customerId%>"+"&amp;2ndOrderId="+"<%=secondOrderId%>"+"&amp;2ndBillingAddressId="+"<%=secondBillingAddressId%>";
		<% } else { %>
			url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderBillingAddressFramePage&cmd=OrderBillingAddressPage&amp;customerId="+"<%=customerId%>"+"&amp;2ndOrderId="+"<%=secondOrderId%>"+"&amp;2ndBillingAddressId="+"<%=secondBillingAddressId%>"+"&amp;displayForOrder="+"<%=displayForOrder%>";
		<% } %>
	}
	this.location.replace(url);
}

function validatePanelData() {
	return true;
}

function savePanelData() {
	if (defined(this.orderBillingAddressPage))
		if (defined(this.orderBillingAddressPage.basefrm))
			this.orderBillingAddressPage.basefrm.savePanelData();
}
//[[>-->
</script>
</head>
<% if (firstOrderExist && secondOrderExist) {%>
	<frameset rows="10%, 10%, *">
		<frame name="orderBillingAddressTitle"
			title="<%= UIUtil.toHTML( (String)orderMgmtNLS.get("billingAddressPage")) %>"
			<% if (firstPayAddressId.length() != 0) { %>
				src="OrderBillingAddressTitle?displayInfo=yes"
			<% } else { %>
				src="OrderBillingAddressTitle?displayInfo=no"
			<% } %>
			
			frameborder="0"
			noresize="noresize"
			scrolling="no"
			marginwidth="15"
			marginheight="15" />
		<frame name="orderBillingAddressOrderSelection"
			src="OrderBillingAddressOrderSelection?customerId=<%=customerId%>&amp;1stOrderId=<%=firstOrderId%>&amp;2ndOrderId=<%=secondOrderId%>&amp;1stBillingAddressId=<%=firstBillingAddressId%>&amp;2ndBillingAddressId=<%=secondBillingAddressId%>&amp;1stPaymentTCId=<%=firstPaymentTCId%>&amp;2ndPaymentTCId=<%=secondPaymentTCId%>"
			title='<%= UIUtil.toHTML( (String)orderMgmtNLS.get("billingAddressPage")) %>'
			frameborder="0"
			noresize="noresize"
			scrolling="no"
			marginwidth="15"
			marginheight="15" />
		<frame name="orderBillingAddressPage"
			title='<%= UIUtil.toHTML( (String)orderMgmtNLS.get("billingAddressPage")) %>'
			frameborder="0" 
			noresize="noresize"
			scrolling="auto" 
			marginwidth="15" 
    		marginheight="0" />
    </frameset>
<% } else if (firstOrderExist) {
	out.write("<body class=\"content\" onload=\"executeFirstPage();\"></body>");
   } else {
	out.write("<body class=\"content\" onload=\"executeSecondPage();\"></body>");
}%>
  <script type="text/javascript">
	<!-- <![CDATA[
        // For IE
        if (document.all) {
          onLoad();
        }
        //[[>-->
   </script>
</html>


