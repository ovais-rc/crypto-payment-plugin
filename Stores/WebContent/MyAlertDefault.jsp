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

<%@ page language="java" %><%@ page import="java.util.*,
javax.servlet.*,
com.ibm.commerce.server.*,
com.ibm.commerce.datatype.*" %><%

	response.setContentType("text/html;charset=UTF-8");
	
	StringBuffer msgSB = null;
	String msg = null;

	//XML tags
	String HEADER = "<?xml version=\"1.0\"?>";
	String ALERTMESSAGE = "<alertmessage>";
	String CONTROLSECTION = "<controlsection>";
	String DATASECTION = "<datasection>";
	String END_ALERTMESSAGE = "</alertmessage>";
	String END_CONTROLSECTION = "</controlsection>";
	String END_DATASECTION =  "</datasection>";

	//Attribute tags
	String CREATION = "<creation>";
	String END_CREATION = "</creation>";
	String CREATION_YEAR = "<create_year>";
	String CREATION_MONTH = "<create_month>";
	String CREATION_DAY = "<create_day>";
	String CREATION_HOUR = "<create_hour>";
	String CREATION_MINUTE = "<create_minute>";
	String END_CREATION_YEAR = "</create_year>";
	String END_CREATION_MONTH = "</create_month>";
	String END_CREATION_DAY = "</create_day>";
	String END_CREATION_HOUR = "</create_hour>";
	String END_CREATION_MINUTE = "</create_minute>";
	String CREATION_TIMESTAMP = "<create_timestamp>";
	String END_CREATION_TIMESTAMP = "</create_timestamp>";

	String EXPIRY = "<expiry>";
	String END_EXPIRY = "</expiry>";
	String EXPIRY_YEAR = "<expire_year>";
	String EXPIRY_MONTH = "<expire_month>";
	String EXPIRY_DAY = "<expire_day>";
	String END_EXPIRY_YEAR = "</expire_year>";
	String END_EXPIRY_MONTH = "</expire_month>";
	String END_EXPIRY_DAY = "</expire_day>";
	String DEFAULT_MESSAGE = "<default_message>";
	String END_DEFAULT_MESSAGE = "</default_message>";

	try {
	
		java.util.Calendar msgExpiryDate = (Calendar) request.getAttribute("ExpiryDate");
			
		Calendar cal = Calendar.getInstance();

		if (msgExpiryDate == null) {
			msgExpiryDate = Calendar.getInstance();
			msgExpiryDate.clear();
			msgExpiryDate.set(cal.YEAR,cal.MONTH + 1,cal.DAY_OF_MONTH);
		}
		

		Date aDate = cal.getTime();
		long msTimestamp = aDate.getTime();
		Long lTimestamp = new Long(msTimestamp);
		String sTimestamp = lTimestamp.toString();

		int year = cal.YEAR;
		int month = cal.MONTH;
		int day = cal.DAY_OF_MONTH;
		int hour = cal.HOUR_OF_DAY;
		int minute = cal.MINUTE;
		int expYear = msgExpiryDate.YEAR;
		int expMonth = msgExpiryDate.MONTH;
		int expDay = msgExpiryDate.DAY_OF_MONTH;

		msgSB =new StringBuffer()                       
				.append( HEADER)
				.append( ALERTMESSAGE)
				.append( CONTROLSECTION)
				.append( CREATION)
				.append( CREATION_YEAR)
				.append( year)
				.append( END_CREATION_YEAR)
				.append( CREATION_MONTH)
				.append( month)
				.append( END_CREATION_MONTH)
				.append( CREATION_DAY)
				.append( day)
				.append( END_CREATION_DAY)
				.append( CREATION_HOUR)
				.append( hour)
				.append( END_CREATION_HOUR)
				.append( CREATION_MINUTE)
				.append( minute)
				.append( END_CREATION_MINUTE)
				.append( CREATION_TIMESTAMP)
				.append( sTimestamp)
				.append( END_CREATION_TIMESTAMP)
				.append( END_CREATION)
				.append( EXPIRY)
				.append( EXPIRY_YEAR)
				.append( expYear)
				.append( END_EXPIRY_YEAR)
				.append( EXPIRY_MONTH)
				.append( expMonth)
				.append( END_EXPIRY_MONTH)
				.append( EXPIRY_DAY)
				.append( expDay)
				.append( END_EXPIRY_DAY)
				.append( END_EXPIRY)
				.append( END_CONTROLSECTION)
				.append( DATASECTION)
				.append( DEFAULT_MESSAGE);
			out.println(msgSB.toString());
		}
		catch (Exception exp) {
			System.out.println("Exception in MyAlertDefault.jsp" + exp.getMessage());
		}

   		JSPHelper JSPHelp = new JSPHelper(request);
   		String jspFile = JSPHelp.getParameter("jspFiledocname");
%><jsp:include page="<%=jspFile%>" flush="true"/><%

		try {
			msgSB = new StringBuffer().append( END_DEFAULT_MESSAGE)
				.append( END_DATASECTION)
				.append( END_ALERTMESSAGE);
		        msg = msgSB.toString();
			out.println(msg);
		}
		catch (Exception exp) {
			System.out.println("Exception in MyAlertDefault.jsp" + exp.getMessage());
		}
%>