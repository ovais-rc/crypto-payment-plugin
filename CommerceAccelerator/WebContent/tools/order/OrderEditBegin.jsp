<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.command.CommandFactory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ordermanagement.commands.AdvancedOrderEditBeginCmd" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.utils.OrderConstants" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContext.getLocale();
Hashtable orderLabels = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale);

JSPHelper jspHelper = new JSPHelper(request);
String XMLFile = jspHelper.getParameter("XMLFile");
String orderId = jspHelper.getParameter("orderId");
Integer storeId = cmdContext.getStoreId();
String takeOverLock = jspHelper.getParameter("takeOverLock");
boolean orderIsLocked = false;
String orderLockExceptionMessage = "";
String msgKey = "";

	try {
		//orderEditBegin...
	    // TypedProperty property = cmdContext.getRequestProperties();
		// cancelOrderApprovalFlow(orderId, cmdContext, property);

		AdvancedOrderEditBeginCmd orderEditCmd =
			(AdvancedOrderEditBeginCmd) CommandFactory.createCommand(
				AdvancedOrderEditBeginCmd.NAME,
				storeId);
		//cancelOrderApprovalFlow(orderId, cmdContext, property);//TODO: CDC add to ORderEdit.
		if (orderEditCmd != null) {
			orderEditCmd.setRequestProperties(
				cmdContext.getRequestProperties());
			orderEditCmd.setCommandContext(cmdContext);
			orderEditCmd.setOrderId(orderId);
			orderEditCmd.setAccCheck(false);
			orderEditCmd.setTakeOverLock(takeOverLock);
			orderEditCmd.execute();
		}
		//end orderEditBegin
	} catch (ECApplicationException ex) {
		msgKey = ex.getMessageKey();
		orderLockExceptionMessage = ex.getMessage();
	}

%>

<html>
<head>

<script type="text/javascript">
<!-- <![CDATA[

function initialize() {
	var orderLockExceptionMessage = "<%=UIUtil.toJavaScript(orderLockExceptionMessage)%>";
	var msgKey = "<%=msgKey%>";
	if (msgKey != "" ) {
		if (msgKey == "_ERR_ORDER_IS_LOCKED") {
			if (top.confirmDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("editStateWarning"))%>")) {
				top.showContent("/webapp/wcs/tools/servlet/OrderEditBeginView?XMLFile=<%=XMLFile%>&orderId=<%=orderId%>&takeOverLock=Y");
			} else {
				top.goBack();
			}
		} else {
			
			if (msgKey == "_ERR_ORDER_WRONG_STATUS") {
				<% 
				OrderDataBean orderDB = new OrderDataBean();
				orderDB.setOrderId(orderId);
				com.ibm.commerce.beans.DataBeanManager.activate(orderDB, request);
				String orderStatus = orderDB.getStatus();
				
				if(OrderConstants.ORDER_RELEASED.equals(orderStatus)
					|| OrderConstants.ORDER_SHIPPED.equals(orderStatus)
					|| OrderConstants.ORDER_DEPOSITED.equals(orderStatus)
					|| OrderConstants.ORDER_CANCELLED.equals(orderStatus))
				{
				%>
					orderLockExceptionMessage = "<%=UIUtil.toJavaScript((String) orderLabels.get("invalidOrderStatusForEdit"))%>";
				<%	
				}
				%>
			}
			top.alertDialog(orderLockExceptionMessage);
			top.goBack();
		}
	} else {
		top.showContent("/webapp/wcs/tools/servlet/NotebookView?XMLFile=<%=XMLFile%>&orderId=<%=orderId%>");
	}
}

//[[>-->
</script>
</head>

<body onload="initialize();" class="content">

</body>

</html>
