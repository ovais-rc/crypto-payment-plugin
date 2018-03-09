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
%><%@ page import="com.ibm.commerce.server.*" 
%><%@ page session="false" 
%><% response.setContentType("text/html;charset=UTF-8"); 
%><% response.setHeader("Pragma", "No-cache"); 
%><% response.setDateHeader("Expires", 0); 
%><% response.setHeader("Cache-Control", "no-cache"); 
%><%
try{

	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = commandContext.getLocale();
	StoreAccessBean storeAB = commandContext.getStore();

	JSPHelper jhelper = new JSPHelper(request);
	String orderId = jhelper.getParameter("orderId");

	ResourceBundle orderNotificationRB = ResourceBundle.getBundle("OrderNotification", jLocale );

	StoreEntityDescriptionAccessBean storeEntDescAB = storeAB.getDescription(new Integer(storeAB.getLanguageId()));
	
	StoreAddressDataBean storeAddressDB = new StoreAddressDataBean();
	storeAddressDB.setDataBeanKeyStoreAddressId(storeEntDescAB.getContactAddressId());
	com.ibm.commerce.beans.DataBeanManager.activate(storeAddressDB, request);
	
	
	StringBuffer someText = new StringBuffer();
	someText.append(orderNotificationRB.getString("separator"));
	someText.append(System.getProperty("line.separator"));
	someText.append(System.getProperty("line.separator"));
	String message = orderNotificationRB.getString("orderAuthorizedHeaderMsg");
	StringBuffer messageBuffer = new StringBuffer();
	int index = message.indexOf("%1");
	messageBuffer.append(message.substring(0,index));
	messageBuffer.append(orderId);
	messageBuffer.append(message.substring(index+2));
	message = messageBuffer.toString();
	index = message.indexOf("%2");
	messageBuffer = new StringBuffer();
	messageBuffer.append(message.substring(0,index));
	messageBuffer.append(storeEntDescAB.getDisplayName());
	messageBuffer.append(message.substring(index+2));
	someText.append(messageBuffer.toString());
	someText.append(System.getProperty("line.separator"));
	someText.append(orderNotificationRB.getString("separator"));
	someText.append(System.getProperty("line.separator"));
	someText.append(System.getProperty("line.separator"));
	out.println(someText.toString());
	
	someText = new StringBuffer();
	someText.append(orderNotificationRB.getString("orderAuthorizedContactStore"));
	someText.append(System.getProperty("line.separator"));
	someText.append(storeEntDescAB.getDisplayName());
	someText.append(System.getProperty("line.separator"));
	if (storeEntDescAB.getDescription() != null) {
		someText.append(storeEntDescAB.getDescription());
		someText.append(System.getProperty("line.separator"));
	}
	if (storeAddressDB.getEmail1() != null) {
		someText.append(orderNotificationRB.getString("orderAuthorizedEmail"));
		someText.append(" ");
		someText.append(storeAddressDB.getEmail1());
		someText.append(System.getProperty("line.separator"));
	}
	if (storeAddressDB.getPhone1() != null) {
		someText.append(orderNotificationRB.getString("orderAuthorizedPhone"));
		someText.append(" ");
		someText.append(storeAddressDB.getPhone1());
		someText.append(System.getProperty("line.separator"));
	}
	someText.append(orderNotificationRB.getString("separator"));
	someText.append(System.getProperty("line.separator"));
	someText.append(System.getProperty("line.separator"));
	out.println(someText.toString());
	

}catch (Exception e){
	out.println(e);
}
%>