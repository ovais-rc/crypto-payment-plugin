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
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.ras.ECMessageType" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();

ErrorDataBean errorBean = new ErrorDataBean ();
com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);

String exKey = errorBean.getMessageKey();
String exMsg = "";
StringBuffer catEntrySKUs = null;
//If the message type in the ErrorDataBean is type SYSTEM then
//display the system message.  Otherwise the message is type USER
//so display the user message.
if ( errorBean.getECMessage().getType() == ECMessageType.SYSTEM )
	exMsg = errorBean.getSystemMessage();
else
	exMsg = errorBean.getMessage();

String orgCmd = errorBean.getOriginatingCommand();
if (exKey.equals("_ERR_GENERIC")) {
	String[] paramObj = (String[])errorBean.getMessageParam();
	exMsg = paramObj[0];
}
if (errorBean.getExceptionData() != null && errorBean.getExceptionData().get(OrderConstants.EC_NO_INVENTORY, null) != null){
    	catEntrySKUs= new StringBuffer();
		Vector vCatEntryIds= (Vector)errorBean.getExceptionData().get(OrderConstants.EC_NO_INVENTORY, null);
		Enumeration en = vCatEntryIds.elements();
		while (en != null && en.hasMoreElements()) {
			String catEntryId = (String) en.nextElement().toString();
			CatalogEntryAccessBean ceab = new CatalogEntryAccessBean();
			ceab.setInitKey_catalogEntryReferenceNumber(catEntryId);
			catEntrySKUs.append(" "+ ceab.getPartNumber() + " ");
			
			}
	}
	if (catEntrySKUs != null){
	exMsg += catEntrySKUs.toString();	
	}	
String forPaymentError = "false";
if(exKey != null && (exKey.indexOf("PAY") >= 0 || exKey.indexOf("PPC") >= 0 || exKey.indexOf("EDP") >= 0)){
  forPaymentError = "true";

}
%>

<html>
   <head>
   <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

   <title><%//= orderMgmtNLS.get("orderExceptionHandlingTitle") %></title>

   </head>

   <body class="content">
   	<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
   	<script type="text/javascript">
	<!-- <![CDATA[
   		function savePanelData() {

   		}

   		function validatePanelData() {

   		}

   		function validateNoteBookPanel() {

   		}

   		function saveEntries() {

   		}


   		alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");

   		if ("<%=exKey%>" == "_ERR_ORDER_IS_LOCKED" || "<%=exKey%>" == "_ERR_ORDER_IS_NOT_LOCKED") {
			top.goBack();
		} else if("<%=orgCmd%>" == "CSRCustomerAddressAddCmd" || "<%=orgCmd%>" == "CSRGuestCustomerAddCmd") {
   		   	parent.setContentFrameLoaded(true);
			parent.gotoPanel("newBillingAddressTitle");
		} else if ("<%=orgCmd%>" == "CSROrderItemAddressUpdateCmd") {
		   	parent.setContentFrameLoaded(true);
			parent.gotoPanel("newShippingAddressTitle");
		} else if ("<%=orgCmd%>" == "CSROrderItemAddCmd") {
			//Support For Customers,Shopping Under Multiple Accounts.
			top.goBack();
   			//parent.parent.setContentFrameLoaded(true);
   			//parent.parent.gotoPanel("addProductTitle");
		} else if ("<%=orgCmd%>" == "CSROrderItemUpdateCmd" || "<%=orgCmd%>" == "CSROrderItemDeleteCmd") {
   			parent.parent.setContentFrameLoaded(true);
   			parent.parent.gotoPanel("productsPageNavTabTitle");
		} else if ("<%=orgCmd%>" == "CSROrderItemSplitCmd") {
		   	parent.parent.setContentFrameLoaded(true);
			parent.parent.gotoPanel("allocateItemsPageNavTabTitle");
		} else if ("<%=orgCmd%>" == "CSROrderRollBackCmd") {
			top.goBack();
		} else if ("<%=orgCmd%>" == "CSROrderPrepareCmd") {
			if ("<%=exKey%>" == "_API_CANT_RESOLVE_FFMCENTER" || "<%=exKey%>" == "_ERR_RETRIEVE_PRICE") {
   				parent.setContentFrameLoaded(true);
				parent.gotoPanel("productsPageNavTabTitle");
			} else if ("<%=exKey%>" == "_ERR_CALCODE") {
			   	parent.setContentFrameLoaded(true);
				parent.gotoPanel("shippingPageNavTabTitle");
			} else {
				top.goBack();
			}
   		} else if ("<%=orgCmd%>" == "CSROrderAdjustmentUpdateCmd") {
   		   	parent.parent.setContentFrameLoaded(true);
	   		parent.parent.gotoPanel("AdjustmentPageNavTabTitle");
	   	}else if("<%=forPaymentError%>" == "true"){
	   		parent.parent.setContentFrameLoaded(true);
	   		parent.parent.gotoPanel("selectPaymentPageNavTabTitle");
	   	}
	//[[>-->
   	</script>
   </body>
</html>



