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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 		= cmdContextLocale.getLocale();
      	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
%>

<HTML>
   <HEAD>
   <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
   <TITLE></TITLE>
   
   </HEAD>

   <BODY class="content">
   	
   	<SCRIPT>
		var wizardModel = top.getModel(0);
		var memberId = wizardModel.customerId;
		top.setContent("<%= UIUtil.toJavaScript((String)returnsNLS.get("addProductTitle")) %>","/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnItemSearchDialog&memberId="+memberId, true);
   	</SCRIPT>
      	
   </BODY>
</HTML>
