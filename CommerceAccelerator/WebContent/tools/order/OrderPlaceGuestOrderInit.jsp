<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
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
//*-------------------------------------------------------------------
-->

<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@include file="../common/common.jsp" %>



<%
	CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
	Integer langId = cmdContext.getLanguageId();
	Locale jLocale = cmdContext.getLocale();
	Integer storeId = cmdContext.getStoreId();
	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
	
	CSRGuestCustomerAddCmd newCustomer = (CSRGuestCustomerAddCmd) CommandFactory.createCommand(CSRGuestCustomerAddCmd.NAME, storeId);
	newCustomer.setCommandContext(cmdContext);
	newCustomer.setLangId(langId);
	newCustomer.execute();
	String customerId = newCustomer.getCustomerId();

%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript">
<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------
function getRedirectURL() {
	return "/webapp/wcs/tools/servlet/WizardView?XMLFile=order.createOrderB2C&locale=en_US&customerId="+"<%=customerId%>";
}

function executeNextPage() {
	top.setContent("<%=orderLabels.get("newGuest")%>",getRedirectURL(),false);
}
//[[>-->
</script>
</head>
<body class="content" onload="executeNextPage();">
</body>
</html>



