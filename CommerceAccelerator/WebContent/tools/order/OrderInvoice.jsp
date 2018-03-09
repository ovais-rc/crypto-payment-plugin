<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002, 2006
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.utils.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.payment.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%

   	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
   	Integer langId		= cmdContextLocale.getLanguageId();
   	Integer storeId 	= cmdContextLocale.getStoreId();
   	String currency		= cmdContextLocale.getCurrency();
   	Hashtable orderInvoice 	= (Hashtable)ResourceDirectory.lookup("order.orderInvoice", jLocale);	

	JSPHelper jspHelper 	= new JSPHelper(request);
	String orderId		= jspHelper.getParameter("orderId");

	InvoiceDataBean[] invoiceBean = null;
	InvoiceDetailDataBean[] invoiceDetailBean = null;
	
	if ((orderId != null) && !(orderId.equals(""))) {
	   try {		
		InvoiceListDataBean iListBean = new InvoiceListDataBean();
		iListBean.setDataBeanKeyOrdersId(orderId);
		com.ibm.commerce.beans.DataBeanManager.activate(iListBean, request);
		invoiceBean  = iListBean.getInvoiceList();
		invoiceDetailBean = new InvoiceDetailDataBean[invoiceBean.length];
		
	   } catch (Exception ex) {
	   	invoiceBean = new InvoiceDataBean[0];
	   	invoiceDetailBean = new InvoiceDetailDataBean[0];
	   }
	}	
	
	Hashtable addrFormats = (Hashtable)ResourceDirectory.lookup("order.addressFormats");
	Hashtable localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats."+ jLocale.toString());		

	if (localeAddrFormat == null) {
		localeAddrFormat = (Hashtable)XMLUtil.get(addrFormats, "addressFormats.default");
	}

%>

<html>
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
<title><%= orderInvoice.get("invoiceTitle") %></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript" type="text/javascript">
	<!-- <![CDATA[
      var langId = "<%= langId %>";
      var locale = "<%= jLocale %>";


//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//  GUI functions
//---------------------------------------------------------------------
function nlvFormatAddress(address1, address2, address3, city, region, country, postalCode) {
	
	var newLine = "";
	<%
		for (int i = 2; i < localeAddrFormat.size(); i++) {
		String addressLine = (String)XMLUtil.get(localeAddrFormat,"line"+ i +".elements");
		String[] addressFields = Util.tokenize(addressLine, ","); 
		for (int j = 0; j < addressFields.length; j++) {
	%>
		if ("<%=addressFields[j]%>" == "space")
			newLine += " ";
		if ("<%=addressFields[j]%>" == "comma") 
			newLine += ",";
		if ("<%=addressFields[j]%>" == "address1" && address1 != "")
			newLine += address1;
		if ("<%=addressFields[j]%>" == "address2" && address2 != "")
			newLine += address2;
		if ("<%=addressFields[j]%>" == "address3" && address3 != "")
			newLine += "";
		if ("<%=addressFields[j]%>" == "city" && city != "")
			newLine += city;
		if ("<%=addressFields[j]%>" == "region" && region != "")
			newLine += region;
		if ("<%=addressFields[j]%>" == "country" && country != "")
			newLine += country;
		if ("<%=addressFields[j]%>" == "postalCode" && postalCode != "")
			newLine += postalCode;
		<% } %>
		newLine += "<BR>";
	<% 
		} 
	%>
		newLine += "<BR>";
		return newLine;
}

function nlvCustomerName(title, firstName, middleName, lastName) {
	var newLine = "";
	<%
		String addressLine = (String)XMLUtil.get(localeAddrFormat,"line1.elements");
		String[] addressFields = Util.tokenize(addressLine, ","); 
		for (int j = 0; j < addressFields.length; j++) {
	%>
		if ("<%=addressFields[j]%>" == "firstName")
			newLine += firstName;
		if ("<%=addressFields[j]%>" == "lastName")
			newLine += lastName;
		if ("<%=addressFields[j]%>" == "space")
			newLine += " ";
		if ("<%=addressFields[j]%>" == "title")
			newLine += title;
		if ("<%=addressFields[j]%>" == "comma")
			newLine += ",";
		if ("<%=addressFields[j]%>" == "middleName")
			newLine += middleName;
		<% } %>
		return newLine;
}

function debugAlert(msg) {
//	alert("DEBUG: " + msg);
}
//[[>-->
</script>
</head>

<body class="content" onload="parent.setContentFrameLoaded(true);">        
	<h1><a name="top"><%=orderInvoice.get("orderInvoicesTitle")%></a></h1>
	<% if (invoiceBean.length > 0) 
		invoiceDetailBean[0] = invoiceBean[0].parseInvoiceXml();

	   if (invoiceBean.length > 1) {  %>
		<%=UIUtil.toJavaScript((String)orderInvoice.get("invoiceLinkInstr"))%>
		<ol>
		<% for (int i=0; i<invoiceBean.length; i++) { 
			invoiceDetailBean[i] = invoiceBean[i].parseInvoiceXml();%>
			<li><a href="#<%=invoiceDetailBean[i].getInvoiceNumber()%>"><script>document.write("<%=UIUtil.toJavaScript((String)orderInvoice.get("invoiceLink"))%>".replace(/%1/, "<%=invoiceDetailBean[i].getInvoiceNumber()%>"));</script></a></li>
		<% } %>
		</ol>
		<br /><hr />
	<% } %>
	
	<% for (int j=0; j<invoiceBean.length; j++) { %>
      	<a name="<%=invoiceDetailBean[j].getInvoiceNumber()%>" />

      	<!-- invoice info -->
      	<table>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoiceNumber") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i><%= UIUtil.toHTML(invoiceDetailBean[j].getInvoiceNumber()) %></i></td>
		</tr>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoiceStoreName") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i><%= UIUtil.toHTML(invoiceDetailBean[j].getSellerName()) %></i></td>
		</tr>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoiceOrderNumber") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i><%= UIUtil.toHTML(invoiceDetailBean[j].getOrderNumber()) %></i></td>
		</tr>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoiceReleaseNumber") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i><%= UIUtil.toHTML(invoiceDetailBean[j].getReleaseNumber()) %></i></td>
		</tr>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoicePONumber") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i><%= UIUtil.toHTML(invoiceDetailBean[j].getCustomerPONumber()) %></i></td>
		</tr>
		<% 
		int orderYear	= new Integer (invoiceDetailBean[j].getYearOfOrderDate()).intValue();
		int orderMonth	= new Integer (invoiceDetailBean[j].getMonthOfOrderDate()).intValue();
		int orderDay 	= new Integer (invoiceDetailBean[j].getDayOfOrderDate()).intValue();
		
		Calendar orderCalendar = Calendar.getInstance();
		orderCalendar.set( orderYear, orderMonth, orderDay );
		java.util.Date orderDate = orderCalendar.getTime();
		long orderDateMillis 	= orderDate.getTime();
		Timestamp orderTimestamp = new Timestamp( orderDateMillis );
		String orderDateString = TimestampHelper.getDateFromTimestamp( orderTimestamp, jLocale );
		%>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoiceOrderDate") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i><%= orderDateString %></i></td>
		</tr>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoiceCustomerName") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i>
			<script type="text/javascript">
			<!-- <![CDATA[
				document.write(nlvCustomerName("<%= UIUtil.toJavaScript(invoiceDetailBean[j].getBuyerPersonTitle()) %>", 
							       "<%= UIUtil.toJavaScript(invoiceDetailBean[j].getBuyerFirstName()) %>",
							       "<%= UIUtil.toJavaScript(invoiceDetailBean[j].getBuyerMiddleName()) %>",
							       "<%= UIUtil.toJavaScript(invoiceDetailBean[j].getBuyerLastName()) %>"));
			//[[>-->
			</script>
			</i></td>
		</tr>
		<tr>
			<td align="left" valign="top"><%= orderInvoice.get("viewInvoiceShippingAddress") %><%= orderInvoice.get("viewInvoiceLabelTextSeparator") %></td>
			<td><i>
			<script type="text/javascript">
			<!-- <![CDATA[
				document.write(nlvFormatAddress("<%= UIUtil.toJavaScript(invoiceDetailBean[j].getShipToAddressLine1()) %>", 
								"<%= UIUtil.toJavaScript(invoiceDetailBean[j].getShipToAddressLine2())%>", 
								"<%= UIUtil.toJavaScript(invoiceDetailBean[j].getShipToAddressLine3())%>", 
								"<%= UIUtil.toJavaScript(invoiceDetailBean[j].getShipToCity())%>", 
								"<%= UIUtil.toJavaScript(invoiceDetailBean[j].getShipToStateOrProvince())%>", 
								"<%= UIUtil.toJavaScript(invoiceDetailBean[j].getShipToCountry())%>", 
								"<%= UIUtil.toJavaScript(invoiceDetailBean[j].getShipToZipCode())%>"));
			//[[>-->
			</script>
			</i></td>
		</tr>
		
	</table>	

	<!-- Product Info -->     	
	<table class="list" width="95%" cellpadding="2" cellspacing="1" summary="<%= orderInvoice.get("orderItemInfo") %>">
		<tr class="list_roles" align="center"> 
			<td class="list_header" id="iNu"><%= orderInvoice.get("itemNumber") %></td>
			<td class="list_header" id="iDe"><%= orderInvoice.get("itemDescription") %></td>
			<td class="list_header" id="iQu"><%= orderInvoice.get("itemQuantity") %></td>
			<td class="list_header" id="iPr"><%= orderInvoice.get("itemPrice") %></td>
			<td class="list_header" id="iTo"><%= orderInvoice.get("itemTotal") %></td>
		</tr>
	<%
		String classId="list_row2";

		int numberOfInvoiceItems = 0;
		InvoiceItemDataBean[] invoiceItemList = invoiceDetailBean[j].getInvoiceItemList();
		if (invoiceItemList != null) {
			numberOfInvoiceItems = invoiceItemList.length;
		}
		
		InvoiceItemDataBean invoiceItem = null;
		for (int i=0; i<numberOfInvoiceItems ; i++) { %>
		<tr class="<%= UIUtil.toHTML(classId) %>">
			<td class="list_info1" align="left">
				<%= UIUtil.toHTML(invoiceItemList[i].getSKU()) %>
			</td>
			<td class="list_info1" align="left">
				<%= UIUtil.toHTML(invoiceItemList[i].getDescription()) %>
			</td>
			<td class="list_info1" align="left">
				<%= UIUtil.toHTML(invoiceItemList[i].getQuantity()) %>
			</td>
			<td class="list_info1" align="right">
				<%= UIUtil.toHTML(invoiceItemList[i].getUnitPrice()) %>
			</td>
			<td class="list_info1" align="right">
				<%= UIUtil.toHTML(invoiceItemList[i].getPrice()) %>
			</td>	
		</tr>
	<%
			if (classId.equals("list_row2")) classId="list_row1";
			else classId="list_row2";
		}
	%>
	
	</table>
	<br />
	
	<!-- total -->
	<table width="95%">
		<tr>
	          <td colspan="6" align="right">
		    <table cellpadding="0" cellspacing="0" border="0">      
			<tr>
			       	<td></td>
				<td></td>
				<td colspan="2" align="right" nowrap="nowrap"><%= orderInvoice.get("totalTax") %></td>
				<td align="right" width="130">
				<%= UIUtil.toHTML(invoiceDetailBean[j].getTax()) %>
				</td>
			</tr>
	              	<tr>
		        	<td></td>
				<td></td>
				<td colspan="2" align="right" nowrap="nowrap"><%= orderInvoice.get("shippingCharge") %></td>
				<td align="right" width="130">
				<%= UIUtil.toHTML(invoiceDetailBean[j].getTotalShipping()) %>
				</td>
			</tr>
			<tr>
			       	<td></td>
				<td></td>
				<td colspan="2" align="right" nowrap="nowrap"><%= orderInvoice.get("shippingTax") %></td>
				<td align="right" width="130">
				<%= UIUtil.toHTML(invoiceDetailBean[j].getTotalShippingTax()) %>
				</td>
			</tr>
			<tr>
			       	<td></td>
				<td></td>
				<td colspan="2" align="right" nowrap="nowrap"><%= orderInvoice.get("adjustment") %></td>
				<td align="right" width="130">
				<%= UIUtil.toHTML(invoiceDetailBean[j].getTotalAdjustments()) %>
				</td>
			</tr>
	              	<tr>
		        	<td></td>
				<td></td>
				<td colspan="2" align="right" nowrap="nowrap"><%= orderInvoice.get("grandTotal") %> &nbsp;[<%= invoiceDetailBean[j].getCurrency() %>]</td>
				<td align="right" width="130">
				<%= UIUtil.toHTML(invoiceDetailBean[j].getTotalAmount()) %>
				</td>
			</tr>       
	            </table>
	          </td>
        	</tr>
	</table>

	<% if (invoiceBean.length > 1) { %>
		<br />
		<a href="#TOP"><%=orderInvoice.get("go2TopLink")%></a>
		<hr />
	<% } %>
	
	<% } //for each invoice
	
	if (invoiceBean.length == 0) { %>
	

<table cellspacing="0" cellpadding="3" border="0">
<tr>
	<td colspan="7">
		<%=orderInvoice.get("noInvoicesToList")%>
	</td>
</tr>
</table>	
	<%}%>

</body>
</html>

