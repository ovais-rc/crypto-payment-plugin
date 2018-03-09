<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.catalog.beans.ProductDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.CategoryDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@include file="../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable ProductFindNLS = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	Hashtable AttributeNLS = (Hashtable) ResourceDirectory.lookup("catalog.AttributeNLS", cmdContext.getLocale());
	Hashtable ItemNLS = (Hashtable) ResourceDirectory.lookup("catalog.ItemNLS", cmdContext.getLocale());
	Hashtable CategoryNLS = (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", cmdContext.getLocale());

%>

<HTML>

<HEAD>
	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

	<SCRIPT>
		function onLoad()
		{
			top.goBack();
		}
	</SCRIPT>
</HEAD>

<BODY ONLOAD=onLoad()>
	<%@include file="MsgDisplay.jspf" %>
</BODY>

</HTML>

