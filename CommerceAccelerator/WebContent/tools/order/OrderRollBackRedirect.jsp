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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" import="java.util.*,
	                         com.ibm.commerce.server.*,
	                         com.ibm.commerce.beans.*,
	         		 com.ibm.commerce.catalog.beans.*,
	         		 com.ibm.commerce.catalog.objects.*,
	         		 com.ibm.commerce.fulfillment.objects.*,
	         		 com.ibm.commerce.order.beans.*,
	         		 com.ibm.commerce.exception.ECException,
	         		 com.ibm.commerce.order.objects.*,
	         		 com.ibm.commerce.common.objects.*, 
				 com.ibm.commerce.order.utils.*,
				 com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
TypedProperty requestProperty = (TypedProperty) request.getAttribute(ECConstants.EC_REQUESTPROPERTIES);
Locale jLocale = cmdContext.getLocale();
Hashtable orderMgmtNLS=(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);

%>
<html>
   <head>
   <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 

   <title><%= orderMgmtNLS.get("orderRollBackHandlingTitle") %></title>
   
   </head>

   <body class="content">
    <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
    
   	<script language="javascript" type="text/javascript">
	  <!-- <![CDATA[
   	
	var responseMsg;
 	<%
   	   
   	   String returnedMessage = "";
   	   try {
   	   	returnedMessage = (String) requestProperty.getString(ECOptoolsConstants.EC_OPTOOL_CANCEL_ACTION_FINISH_MESSAGE);
   	   } catch (Exception ex) {
   	   
   	   }
   	 if(returnedMessage ==null || returnedMessage.equals("")){ 
   	 	returnedMessage =(String) requestProperty.getString(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_FINISH_MESSAGE);
   	 }
   	 if(returnedMessage ==null || returnedMessage.equals("")){
   		returnedMessage =(String) requestProperty.getString(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
   	 }
	 if ((null != returnedMessage) && (!returnedMessage.equals("")) ) {
   	 %>
		responseMsg = "<%= UIUtil.toJavaScript(returnedMessage) %>";  	      
	       	alertDialog(responseMsg);
   	      					
	
 
     	<% } %>

	if (top.mccbanner)
		top.mccbanner.waitForCancel = false;
	
   	top.goBack();   
   //[[>-->
   </script>
   </body>
</html>



