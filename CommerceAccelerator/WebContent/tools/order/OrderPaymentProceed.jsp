<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.fulfillment.commands.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../../tools/common/common.jsp" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContext.getLocale();
Integer storeId = cmdContext.getStoreId();
Hashtable orderLabels = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);	

JSPHelper jspHelper 	= new JSPHelper(request);
String orderId		= jspHelper.getParameter("orderId");

// change order status to states B or C
String message = "";
try {
	String tokens[] = Util.tokenize(orderId, ",");
	
	for (int i=0; i<tokens.length; i++) {
		// determine the state to move the order to
		String finalState = "";
		OrderDataBean orderBean = new OrderDataBean();
		orderBean.setOrderId(tokens[i]);
		DataBeanManager.activate(orderBean, request);
		
		StoreDataBean storeBean = new StoreDataBean();
		storeBean.setStoreId(storeId.toString());
		DataBeanManager.activate(storeBean, request);
		
		if (com.ibm.commerce.fulfillment.commands.InventoryManagementHelper.IsBackorder(orderBean) && com.ibm.commerce.fulfillment.commands.InventoryManagementHelper.IsUsingATP(storeBean)) {
			finalState = "B";
		} else {
			finalState = "C";
		}	
		
		// change the state for the order
		Vector orderIdsVector = new Vector();
		orderIdsVector.addElement(tokens[i]);
	
		CSROrderStatusChangeCmd orderStatusChangeCmd = (CSROrderStatusChangeCmd) CommandFactory.createCommand(CSROrderStatusChangeCmd.NAME, storeId);
		orderStatusChangeCmd.setNewStatus(finalState);
		orderStatusChangeCmd.setOrderIds(orderIdsVector);
		orderStatusChangeCmd.setCommandContext(cmdContext);
		orderStatusChangeCmd.execute();
	}
	
	message = (String)orderLabels.get("orderPaymentProceedSuccess");
} catch (Exception ex) {
	message = (String)orderLabels.get("orderPaymentProceedFailed");
}
%>

<html>
<head> 
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<title><%= UIUtil.toHTML( (String)orderLabels.get("orderPaymentProceedTitle")) %></title>
</head>
<body class="content">

<h1><%= UIUtil.toHTML( (String)orderLabels.get("orderPaymentProceedTitle")) %></h1>

<p><br /><%= UIUtil.toHTML( (String)message) %><br /><br />

</p>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[

top.showProgressIndicator(false);

//[[>-->
</script>

</body>
</html>
