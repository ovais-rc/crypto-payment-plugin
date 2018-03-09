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
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 

<%@include file="../common/common.jsp" %>

<%

	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 		= cmdContextLocale.getLocale();
	Hashtable orderMgmtNLS 	= (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);


%>

<html>
   <head>
   <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
   <title></title>
   </head>
   <body class="content">
   <script type="text/javascript">
	<!-- <![CDATA[
   		var redirectView = "/webapp/wcs/tools/servlet/DialogView?XMLFile=order.orderProductSearchDialogB2C"; 
   		top.setContent("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("addProductsTrail")) %>", 
				redirectView, true);
   	//[[>-->
   	</script>  	
   </body>
</html>
