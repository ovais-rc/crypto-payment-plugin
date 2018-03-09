<!--
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
//*--------------------------------------------------------------------->

<%@include file="../common/common.jsp" %>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="java.util.Locale" %>

<%
	CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = commandContext.getLocale();
	ResourceBundleProperties serviceNLS = (ResourceBundleProperties)ResourceDirectory.lookup("devtools.userNLS2", locale);		
%>

<script>
	top.setContent("<%= serviceNLS.getJSProperty("SARListTitle")%>", "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=devtools.sarList&cmd=SarListView", false);
</script>
