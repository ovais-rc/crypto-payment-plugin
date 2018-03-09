<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%><%@ page import="javax.servlet.*,
java.util.*,
com.ibm.commerce.server.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.command.*,
com.ibm.commerce.order.beans.*,
com.ibm.commerce.order.objects.*,
com.ibm.commerce.inventory.beans.*,
com.ibm.commerce.inventory.commands.*,
com.ibm.commerce.inventory.objects.*" %><%
   
	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = commandContext.getLocale();

	JSPResourceBundle orderStatusTextRB = null;
	try
	{
		orderStatusTextRB = 
			new JSPResourceBundle(java.util.ResourceBundle.getBundle("orderstatustext", jLocale));
	}
	catch (java.util.MissingResourceException mre)
	{
		throw mre;
	}
	// Get the PickBatch Reference Number passed in by PickBatchCreate command.
	JSPHelper JSPHelp = new JSPHelper(request);
	String ordersId = JSPHelp.getParameter(InventoryConstants.ORDERS_ID);
	String orderReleaseNum = JSPHelp.getParameter(InventoryConstants.ORDRELEASE_NUM);
	
	ordersId = JSPHelp.htmlTextEncoder(ordersId);
	orderReleaseNum = JSPHelp.htmlTextEncoder(orderReleaseNum);	
	
	out.println(orderStatusTextRB.getString("ORSN_TITLE"));
	out.println(orderStatusTextRB.getString("ORSN_ORDID") + 
		orderStatusTextRB.getString("ORSN_COLON") + ordersId);
	out.println(orderStatusTextRB.getString("ORSN_ORD_REL_NUM") + 
		orderStatusTextRB.getString("ORSN_COLON") + orderReleaseNum);
%>
