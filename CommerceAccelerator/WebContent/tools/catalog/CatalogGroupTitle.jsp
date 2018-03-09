<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<html>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.CategoryUpdate" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ include file="../common/common.jsp" %>

<head>
      <%
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        String ownerId = cmdContext.getStore().getOwner().toString();
        Locale jLocale = cmdContext.getLocale();
	    Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CategoryNLS", cmdContext.getLocale());

      %>
      
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("catalogGroupTitle_header"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
	}


</SCRIPT>

</head>
<BODY CLASS="content" SCROLL=NO ONLOAD=onLoad()>

<H1 style="padding-left:7px;"><%=UIUtil.toHTML((String)rbCategory.get("catalogGroupTitle_header")) %></H1>

</BODY>

</html>
