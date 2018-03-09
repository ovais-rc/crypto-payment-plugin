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
%><%@ page import="java.util.*" 
%><%@ page import="com.ibm.commerce.beans.*" 
%><%@ page import="com.ibm.commerce.command.*" 
%><%@ page import="com.ibm.commerce.common.beans.*" 
%><%@ page import="com.ibm.commerce.common.objects.*" 
%><%@ page import="com.ibm.commerce.datatype.*" 
%><%@ page import="com.ibm.commerce.payment.utils.*" 
%><%@ page import="com.ibm.commerce.server.*" 
%><%@ page import="com.ibm.commerce.store.util.*" 
%><%@ page import="com.ibm.commerce.tools.reporting.reports.*" 
%><%@ page import="com.ibm.commerce.tools.util.*" 
%><%@ page session="false" 
%><% response.setContentType("text/html;charset=UTF-8"); 
%><% response.setHeader("Pragma", "No-cache"); 
%><% response.setDateHeader("Expires", 0); 
%><% response.setHeader("Cache-Control", "no-cache"); 
%><%!
private static final int HEADING_SIDE = 80;
private static final int NUMBER_SIDE = 30;
private static final String ENCODING = "UTF-8";
%><%
StoreAccessBean aStoreAB = null;
StoreEntityDescriptionAccessBean aStoreEntDescAB = null;
CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
String currency = "USD";
String languageId = "-1";

try {
	aStoreAB = cmdContext.getStore();
	aStoreEntDescAB	= aStoreAB.getDescription(new Integer(aStoreAB.getLanguageId()));
} catch (Exception ex) {
	out.println(ex);
}

if (aStoreAB.getDefaultCurrency() != null) {
	currency = aStoreAB.getDefaultCurrency();
	System.out.println("default currency Id = " + currency);
}

if (aStoreAB.getLanguageId() != null) {
	languageId = aStoreAB.getLanguageId();
	System.out.println("default language Id = " + languageId);
}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Generate the reporting data bean
///////////////////////////////////////////////////////////////////////////////////////////////////////
TypedProperty newRequestProperties = (TypedProperty)request.getAttribute("RequestProperties");
newRequestProperties.put("keyList", "StartDate,EndDate,LanguageID,Currency,reportName,reportXML");
newRequestProperties.put("LanguageID", languageId);
newRequestProperties.put("Currency", currency);
newRequestProperties.put("reportName", "StorefrontUsageResellerReport");
newRequestProperties.put("reportXML", "reporting.StorefrontUsageResellerReport");
request.setAttribute("RequestProperties", newRequestProperties);

ReportDataBean reportDB1 = new ReportDataBean();
DataBeanManager.activate(reportDB1, request);
Vector columnAttributesRDB1 = ReportDisplayHelper.getReportColumnAttributes(reportDB1);
Hashtable currentColumnAttributesRDB1 = null;

ResourceBundle orderNotificationRB = ResourceBundle.getBundle("OrderNotification", cmdContext.getLocale() );
ResourceBundle reportsResourceBundle = ResourceBundle.getBundle("com/ibm/commerce/tools/reporting/properties/Reports", cmdContext.getLocale() );
Hashtable reportsRB = (Hashtable)ResourceDirectory.lookup("reporting.reportStrings", cmdContext.getLocale());

out.println( reportsResourceBundle.getString("StorefrontUsageResellerReportOutputViewTitle") );

out.print( orderNotificationRB.getString("OrderSummaryReportStore") );
out.print(" ");
out.println( aStoreEntDescAB.getDisplayName() );
out.print( orderNotificationRB.getString("OrderSummaryReportStartDate") );
out.print(" ");
out.println( ReportDisplayHelper.getFormattedDate(ReportDisplayHelper.getEnvAttribute(reportDB1, "StartDate"), cmdContext.getLocale()) );
out.print( orderNotificationRB.getString("OrderSummaryReportEndDate") );
out.print(" ");
out.println( ReportDisplayHelper.getFormattedDate(ReportDisplayHelper.getEnvAttribute(reportDB1, "EndDate"), cmdContext.getLocale()) );
out.println("");
out.println( reportsResourceBundle.getString("StorefrontUsageResellerReportDescription") );
out.println( orderNotificationRB.getString("delimeter") );

if ( reportDB1.getErrorCode() == 0)
{			
	if ( reportDB1.getNumberOfRows() != 0)
	{
		for (int i = 0; i < reportDB1.getNumberOfColumns(); i++)
		{
			currentColumnAttributesRDB1 = (Hashtable) columnAttributesRDB1.elementAt(i);
			out.print( TextAlignHelper.leftAlign(ReportDisplayHelper.getColumnName(reportsResourceBundle, currentColumnAttributesRDB1), HEADING_SIDE, ENCODING) );
			out.println( TextAlignHelper.rightAlign(ReportDisplayHelper.retrieveColumnEntryString(0, currentColumnAttributesRDB1, reportsRB, reportDB1, aStoreAB, cmdContext.getLanguageId(), cmdContext.getLocale(), cmdContext.getCurrency()), NUMBER_SIDE, ENCODING) );
		}
	} else {
		//empty report
		out.println( orderNotificationRB.getString("OrderSummaryReportNoOrders") );
	}
}
%>
