<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
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
//
--%>
<%@ page import="java.util.*"%>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.common.objects.*"%>
<%@ page import="com.ibm.commerce.server.*"%>
<%@ page session="false" %>
<% response.setContentType("text/html;charset=UTF-8"); %>
<% response.setHeader("Pragma", "No-cache"); %>
<% response.setDateHeader("Expires", 0); %>
<% response.setHeader("Cache-Control", "no-cache"); %>
            <%try {
				JSPHelper jhelper = new JSPHelper(request);
				String orderId = jhelper.getParameter("orderId");
				CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
				Locale jLocale = commandContext.getLocale();
				ResourceBundle orderNotificationRB = ResourceBundle.getBundle("OrderNotification",jLocale );
			    StoreAccessBean storeAB = commandContext.getStore();
			    StoreEntityDescriptionAccessBean storeEntDescAB = storeAB.getDescription(new Integer(storeAB.getLanguageId()));
			    String storeName = storeEntDescAB.getDisplayName();
			    
			    StringBuffer someText = new StringBuffer();
			    String message = orderNotificationRB.getString("OrderSMSHeader");
				int index = message.indexOf("%1");
				  
			    someText.append(message.substring(0,index));
			    someText.append(orderId);			    
			    someText.append(message.substring(index+2));
			    someText.append(" ");
			    out.println(someText.toString());
			      
			    someText = new StringBuffer();
			    message = orderNotificationRB.getString("OrderSMSBody");
			    index = message.indexOf("%1");
			      
			    someText.append(message.substring(0,index));
			    someText.append(storeName);			    
			    someText.append(message.substring(index+2));
			    someText.append(" ");
			    out.println(someText.toString());
			      
			    out.println(orderNotificationRB.getString("OrderReceivedSMS"));				    
			 
			} catch (Exception e) {
				out.println(e);
			}

		%>
