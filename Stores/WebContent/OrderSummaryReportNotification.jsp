<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.
 *     2006
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 *-------------------------------------------------------------------
 */
--%> 

<%--
//*---------------------------------------------------------------------
//* The sample contained herein is provided to you "AS IS".
//*
//* It is furnished by IBM as a simple example and has not been  
//* thoroughly tested
//* under all conditions.  IBM, therefore, cannot guarantee its 
//* reliability, serviceability or functionality.  
//*
//* This sample may include the names of individuals, companies, brands 
//* and products in order to illustrate concepts as completely as 
//* possible.  All of these names
//* are fictitious and any similarity to the names and addresses used by 
//* actual persons 
//* or business enterprises is entirely coincidental.
//*---------------------------------------------------------------------
//*
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 020723           KNG              Initial Create
//
// 020815           KNG              Make changes from code review
////////////////////////////////////////////////////////////////////////////////
--%><%@ page language="java" 
%><%@ page import="java.io.*" 
%><%@ page import="java.sql.*" 
%><%@ page import="java.util.*" 
%><%@ page import="com.ibm.commerce.beans.*" 
%><%@ page import="com.ibm.commerce.command.*" 
%><%@ page import="com.ibm.commerce.common.beans.*" 
%><%@ page import="com.ibm.commerce.common.objects.*" 
%><%@ page import="com.ibm.commerce.datatype.*" 
%><%@ page import="com.ibm.commerce.payment.utils.*" 
%><%@ page import="com.ibm.commerce.server.*" 
%><%@ page import="com.ibm.commerce.tools.optools.order.beans.*" 
%><%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" 
%><%@ page import="com.ibm.commerce.tools.optools.common.helpers.*" 
%><%@ page import="com.ibm.commerce.tools.util.*" 
%><%@ page import="com.ibm.commerce.utils.*" 
%><%@ page session="false" 
%><% response.setContentType("text/html;charset=UTF-8"); 
%><% response.setHeader("Pragma", "No-cache"); 
%><% response.setDateHeader("Expires", 0); 
%><% response.setHeader("Cache-Control", "no-cache"); 
%><%!
private static final int HEADING_SIDE = 35;
private static final int NUMBER_SIDE = 43;
private static final String ENCODING = "UTF-8";
%><%
StoreAccessBean aStoreAB = null;
OrderSearchAccessBean orderSearch = new OrderSearchAccessBean();
StoreEntityDescriptionAccessBean aStoreEntDescAB = null;
CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);

try {
	aStoreAB = cmdContext.getStore();
	aStoreEntDescAB	= aStoreAB.getDescription(new Integer(aStoreAB.getLanguageId()));
} catch (Exception ex) {
	out.println(ex);
}	

JSPHelper jspHelper 	= new JSPHelper(request);
String startDate	= jspHelper.getParameter("StartDate");
String endDate		= jspHelper.getParameter("EndDate");

DynamicListData resultList = orderSearch.findOrdersForStoreAdvanced(new Long(aStoreAB.getStoreEntityId()), "orderId", null, null, null, null, "all", null, new Integer("0"), new Integer("10000"), Timestamp.valueOf(startDate), Timestamp.valueOf(endDate), null, null, null, null, null, null, null, null, null, null, null, null, null, null);
Vector orderIds = resultList.getSubset();
int totalOrders = resultList.getTotalSize().intValue();

ResourceBundle orderNotificationRB = ResourceBundle.getBundle("OrderNotification", cmdContext.getLocale() );
out.println( orderNotificationRB.getString("OrderSummaryReportTitle") );
out.println("");
out.println( orderNotificationRB.getString("OrderSummaryReportDescription") );
out.print( orderNotificationRB.getString("OrderSummaryReportStore") );
out.print(" ");
out.println( aStoreEntDescAB.getDisplayName() );
out.print( orderNotificationRB.getString("OrderSummaryReportDate") );
out.print(" ");
out.println( TimestampHelper.getDateFromTimestamp(Timestamp.valueOf(startDate), cmdContext.getLocale()) );
out.print( orderNotificationRB.getString("OrderSummaryReportTotalOrders") );
out.print(" ");
out.println( totalOrders );
out.println("");
out.println( orderNotificationRB.getString("shortDelimeter") );
out.println("");

if (totalOrders == 0) {
	out.println( orderNotificationRB.getString("OrderSummaryReportNoOrders") );
} else {
	for (int i = 0; i < totalOrders; i++)
	{
		OrderSummaryDataBean orderSummaryDB = new OrderSummaryDataBean();
		orderSummaryDB.setOrderId(orderIds.elementAt(i).toString());
		DataBeanManager.activate(orderSummaryDB, request);

		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportOrderNumberColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getOrderId(), NUMBER_SIDE, ENCODING) );
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportStatusColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderNotificationRB.getString(orderSummaryDB.getOrderStatus()), NUMBER_SIDE, ENCODING) );		
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportCurrencyColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getOrderCurrency(), NUMBER_SIDE, ENCODING) );
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportProductTotalColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getFormattedTotalProductPrice(), NUMBER_SIDE, ENCODING) );
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportShippingTotalColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getFormattedTotalShippingCharges(), NUMBER_SIDE, ENCODING) );
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportShippingTaxColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getFormattedTotalShippingTax(), NUMBER_SIDE, ENCODING) );
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportTaxColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getFormattedTotalTax(), NUMBER_SIDE, ENCODING) );		
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportAdjustmentsColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getOrderLevelMinusAdjustment(), NUMBER_SIDE, ENCODING) );
		out.print( TextAlignHelper.leftAlign(orderNotificationRB.getString("OrderSummaryReportTotalColumnTitle"), HEADING_SIDE, ENCODING) );
		out.println( TextAlignHelper.rightAlign(orderSummaryDB.getOrderGrandTotal(), NUMBER_SIDE, ENCODING) );
		out.println(orderNotificationRB.getString("shortDelimeter"));
		out.println("");
	}
}
%>
