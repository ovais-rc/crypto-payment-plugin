<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>
<%@page import = "java.util.*,
			com.ibm.commerce.beans.*,
			com.ibm.commerce.command.CommandContext,
			com.ibm.commerce.tools.catalog.beans.*,
			com.ibm.commerce.tools.catalog.util.*,
			com.ibm.commerce.catalog.objects.*,
			com.ibm.commerce.common.objects.StoreAccessBean,
			com.ibm.commerce.tools.util.*"
%>
<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable productResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", jLocale);

%>


<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">

<TITLE><%=UIUtil.toHTML((String)productResource.get("Category"))%></TITLE>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
</HEAD>

<BODY class="content">
<H1><%=UIUtil.toHTML((String)productResource.get("Category"))%></H1>


</BODY>
</HTML>
