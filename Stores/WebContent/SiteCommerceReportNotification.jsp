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
private static final int HEADING_SIDE = 55;
private static final int NUMBER_SIDE = 25;
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
	System.out.println("site commerce: default currency Id = " + currency);
}

if (aStoreAB.getLanguageId() != null) {
	languageId = aStoreAB.getLanguageId();
	System.out.println("site commerce: default language Id = " + languageId);
}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Generate the reporting data bean
///////////////////////////////////////////////////////////////////////////////////////////////////////
TypedProperty newRequestProperties = (TypedProperty)request.getAttribute("RequestProperties");
newRequestProperties.put("keyList", "StartDate,EndDate,LanguageID,Currency,reportName,reportXML");
newRequestProperties.put("LanguageID", languageId);
newRequestProperties.put("Currency", currency);
newRequestProperties.put("reportName", "SiteOverviewReport");
newRequestProperties.put("reportXML", "reporting.SiteOverviewReport");
request.setAttribute("RequestProperties", newRequestProperties);

ReportDataBean reportDB1 = new ReportDataBean();
DataBeanManager.activate(reportDB1, request);
Vector columnAttributesRDB1 = ReportDisplayHelper.getReportColumnAttributes(reportDB1);
Hashtable currentColumnAttributesRDB1 = null;

newRequestProperties = (TypedProperty)request.getAttribute("RequestProperties");
newRequestProperties.put("keyList", "StartDate,EndDate,LanguageID,Currency,reportName,reportXML");
newRequestProperties.put("LanguageID", languageId);
newRequestProperties.put("Currency", currency);
newRequestProperties.put("reportName", "RegionAllStoresReport");
newRequestProperties.put("reportXML", "reporting.RegionAllStoresReport");
request.setAttribute("RequestProperties", newRequestProperties);

ReportDataBean reportDB2 = new ReportDataBean();
DataBeanManager.activate(reportDB2, request);
Vector columnAttributesRDB2 = ReportDisplayHelper.getReportColumnAttributes(reportDB2);
Hashtable currentColumnAttributesRDB2 = null;

ResourceBundle orderNotificationRB = ResourceBundle.getBundle("OrderNotification", cmdContext.getLocale() );
ResourceBundle reportsResourceBundle = ResourceBundle.getBundle("com/ibm/commerce/tools/reporting/properties/Reports", cmdContext.getLocale() );
Hashtable reportsRB = (Hashtable)ResourceDirectory.lookup("reporting.reportStrings", cmdContext.getLocale());

JSPHelper jspHelper 	= new JSPHelper(request);
String format = jspHelper.getParameter("format");

if (format.equals("0")) {
	//text format
	out.println( orderNotificationRB.getString("SiteCommerceReportTitle") );

	out.print( orderNotificationRB.getString("SiteCommerceReportStartDate") );
	out.print(" ");
	out.println( ReportDisplayHelper.getFormattedDate(ReportDisplayHelper.getEnvAttribute(reportDB1, "StartDate"), cmdContext.getLocale()) );
	out.print( orderNotificationRB.getString("SiteCommerceReportEndDate") );
	out.print(" ");
	out.println( ReportDisplayHelper.getFormattedDate(ReportDisplayHelper.getEnvAttribute(reportDB1, "EndDate"), cmdContext.getLocale()) );
	out.println("");
	out.println( orderNotificationRB.getString("SiteCommerceReportDescription") );
	out.println( orderNotificationRB.getString("shortDelimeter") );
	
	out.println( orderNotificationRB.getString("SiteCommerceReportOverview") );
	
	if ( reportDB1.getErrorCode() == 0)
	{			
		if ( reportDB1.getNumberOfRows() != 0)
		{
			for (int j = 0; j < reportDB1.getNumberOfRows(); j++)
			{
				for (int i = 0; i < reportDB1.getNumberOfColumns(); i++)
				{
					currentColumnAttributesRDB1 = (Hashtable) columnAttributesRDB1.elementAt(i);
					out.print( TextAlignHelper.leftAlign(ReportDisplayHelper.getColumnName(reportsResourceBundle, currentColumnAttributesRDB1), HEADING_SIDE, ENCODING) );
					out.println( TextAlignHelper.rightAlign(ReportDisplayHelper.retrieveColumnEntryString(j, currentColumnAttributesRDB1, reportsRB, reportDB1, aStoreAB, cmdContext.getLanguageId(), cmdContext.getLocale(), cmdContext.getCurrency()), NUMBER_SIDE, ENCODING) );
				}
				out.println(" ");
			}
		} else {
			//empty report
			out.println( orderNotificationRB.getString("OrderSummaryReportNoOrders") );
		}
	}

	out.println( orderNotificationRB.getString("shortDelimeter") );
	out.println(" ");
	out.println( orderNotificationRB.getString("SiteCommerceReportRegions") );
	out.println(" ");
	if ( reportDB2.getErrorCode() == 0)
	{			
		if ( reportDB2.getNumberOfRows() != 0)
		{
			for (int j = 0; j < reportDB2.getNumberOfRows(); j++)
			{
				for (int i = 0; i < reportDB2.getNumberOfColumns(); i++)
				{
					currentColumnAttributesRDB2 = (Hashtable) columnAttributesRDB2.elementAt(i);
					out.print( TextAlignHelper.leftAlign(ReportDisplayHelper.getColumnName(reportsResourceBundle, currentColumnAttributesRDB2), HEADING_SIDE, ENCODING) );
					out.println( TextAlignHelper.rightAlign(ReportDisplayHelper.retrieveColumnEntryString(j, currentColumnAttributesRDB2, reportsRB, reportDB2, aStoreAB, cmdContext.getLanguageId(), cmdContext.getLocale(), cmdContext.getCurrency()), NUMBER_SIDE, ENCODING) );
				}
				out.println(" ");
			}
		} else {
			//empty report
			out.println( orderNotificationRB.getString("OrderSummaryReportNoOrders") );
		}
	}
} else {
	//comma separated format
	out.println( orderNotificationRB.getString("SiteCommerceReportTitle") );
	
	out.print( aStoreEntDescAB.getDisplayName() );
	out.print( "," );
	out.print( " " );
	out.print( "," );
	out.print( " " );
	out.print( "," );
	out.print( " " );
	out.print( "," );
	out.print( ReportDisplayHelper.getFormattedDate(ReportDisplayHelper.getEnvAttribute(reportDB1, "StartDate"), cmdContext.getLocale()) );
	out.print(" - ");
	out.println( ReportDisplayHelper.getFormattedDate(ReportDisplayHelper.getEnvAttribute(reportDB1, "EndDate"), cmdContext.getLocale()) );
	out.println("");

	out.print( "," );	
	out.println( orderNotificationRB.getString("SiteCommerceReportOverview") );
	
	if ( reportDB1.getErrorCode() == 0)
	{			
		if ( reportDB1.getNumberOfRows() != 0)
		{
			for (int j = 0; j < reportDB1.getNumberOfRows(); j++)
			{
				if (reportDB1.getNumberOfColumns() > 1) {
					out.print( "," );
					out.print( "," );
					currentColumnAttributesRDB1 = (Hashtable) columnAttributesRDB1.elementAt(0);
					out.println( ReportDisplayHelper.retrieveColumnEntryString(j, currentColumnAttributesRDB1, reportsRB, reportDB1, aStoreAB, cmdContext.getLanguageId(), cmdContext.getLocale(), cmdContext.getCurrency()) );
				}
				for (int i = 1; i < reportDB1.getNumberOfColumns(); i++)
				{
					out.print( "," );
					out.print( "," );
					out.print( "," );
					currentColumnAttributesRDB1 = (Hashtable) columnAttributesRDB1.elementAt(i);
					out.print( ReportDisplayHelper.getColumnName(reportsResourceBundle, currentColumnAttributesRDB1) );
					out.print( "," );
					out.println( ReportDisplayHelper.retrieveColumnEntryString(j, currentColumnAttributesRDB1, reportsRB, reportDB1, aStoreAB, cmdContext.getLanguageId(), cmdContext.getLocale(), cmdContext.getCurrency()) );
				}
				out.println(" ");
			}
		} else {
			//empty report
			out.print( "," );
			out.print( "," );
			out.println( orderNotificationRB.getString("OrderSummaryReportNoOrders") );
		}
	}

	out.println(" ");
	out.print( "," );	
	out.println( orderNotificationRB.getString("SiteCommerceReportRegions") );

	if ( reportDB2.getErrorCode() == 0)
	{			
		if ( reportDB2.getNumberOfRows() != 0)
		{
			for (int j = 0; j < reportDB2.getNumberOfRows(); j++)
			{
				if (reportDB2.getNumberOfColumns() > 1) {
					out.print( "," );
					out.print( "," );
					currentColumnAttributesRDB2 = (Hashtable) columnAttributesRDB2.elementAt(0);
					out.println( ReportDisplayHelper.retrieveColumnEntryString(j, currentColumnAttributesRDB2, reportsRB, reportDB2, aStoreAB, cmdContext.getLanguageId(), cmdContext.getLocale(), cmdContext.getCurrency()) );
				}
				for (int i = 1; i < reportDB2.getNumberOfColumns(); i++)
				{
					out.print( "," );
					out.print( "," );
					out.print( "," );
					currentColumnAttributesRDB2 = (Hashtable) columnAttributesRDB2.elementAt(i);
					out.print( ReportDisplayHelper.getColumnName(reportsResourceBundle, currentColumnAttributesRDB2) );
					out.print( "," );
					out.println( ReportDisplayHelper.retrieveColumnEntryString(j, currentColumnAttributesRDB2, reportsRB, reportDB2, aStoreAB, cmdContext.getLanguageId(), cmdContext.getLocale(), cmdContext.getCurrency()) );
				}
				out.println(" ");
			}
		} else {
			//empty report
			out.print( "," );
			out.print( "," );
			out.println( orderNotificationRB.getString("OrderSummaryReportNoOrders") );
		}
	}
}
%>
