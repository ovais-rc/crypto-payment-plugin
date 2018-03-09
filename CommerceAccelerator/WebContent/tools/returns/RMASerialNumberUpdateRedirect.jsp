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
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
   
   // obtain the resource bundle for display
   CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale jLocale = cmdContextLocale.getLocale();
   Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
   
   JSPHelper jspHelper = new JSPHelper(request);
   String redirect = jspHelper.getParameter("redirect");
   String rmaItemId = jspHelper.getParameter("rmaItemId");
%>

<HTML>
<HEAD>
<SCRIPT>
function initialize() {    
    if (<%=redirect == null%>) {
	    top.goBack();
    }else{
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.rmaSerialNumberEdit&";
	url += 'rmaItemId=' + <%=rmaItemId%>;
    	top.setContent("<%= UIUtil.toHTML((String)returnsNLS.get("editSNsPanel")) %>",url, true);
    } 
}

</SCRIPT>
</HEAD>

<BODY class="content" onload="initialize();">

</BODY>

</HTML>
