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
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
	
String customerId = "";
JSPHelper jspHelper = new JSPHelper(request);
customerId = jspHelper.getParameter(ECOptoolsConstants.EC_OPTOOL_CUSTOMER_ID);
String billingAddressId = jspHelper.getParameter(ECConstants.EC_ADDR_RN);
%>
<!-- Get the resource bundle with all the NLS strings and the Selected Order Reference Numbers -->

<html>
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript">
<!-- <![CDATA[
function initialize() {    
	parent.setContentFrameLoaded(true);
  	
	var x = top.getModel(1);
	if (!defined(x.order) || (x.order == null)) 
		x.order = new Object();
	
	x.order.customerId = "<%=customerId%>";
	x.order.billingAddressId = "<%=billingAddressId%>";
	
	top.goBack();
}
//[[>-->
</script>
</head>

<body onload="initialize();" class="content">

</body>

</html>
