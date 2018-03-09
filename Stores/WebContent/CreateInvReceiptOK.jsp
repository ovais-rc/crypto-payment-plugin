<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Response_WCS_CreateInvReceipt SYSTEM 'Response_WCS_CreateInvReceipt_10.dtd'>
<Response_WCS_CreateInvReceipt version="1.0">
<%@page import="java.util.*,
  com.ibm.commerce.server.JSPHelper,
  com.ibm.commerce.tools.util.UIUtil,
  com.ibm.commerce.inventory.commands.*"
%><%
     JSPHelper jsphelper = new JSPHelper(request);
     String ReceiptID = jsphelper.getParameter(InventoryConstants.RECEIPT_ID);
     String ItemOwnerID = jsphelper.getParameter(InventoryConstants.MEMBER_ID);
     String ProductSKU = jsphelper.getParameter(InventoryConstants.PARTNUMBER);
     String StoreID = jsphelper.getParameter(InventoryConstants.STORE_ID);
     String FulfillmentCenterID = jsphelper.getParameter(InventoryConstants.FFMCENTER_ID);
     String VendorID = jsphelper.getParameter(InventoryConstants.VENDOR_ID);
     String QTYReceived = jsphelper.getParameter(InventoryConstants.QTYRECEIVED);
     String ReceiptDate = jsphelper.getParameter(InventoryConstants.RECEIPTDATE);
%>
	<ControlArea>
		<Verb value="Response"> </Verb>
		<Noun value="CreateInvReceipt"> </Noun>
	</ControlArea>
	<DataArea>
		<InventoryReceipt>
			<ResponseStatus status="OK" />
			<ReceiptID><%=ReceiptID%></ReceiptID>
			<ItemOwnerID><%=ItemOwnerID%></ItemOwnerID>
			<ProductSKU><%=ProductSKU%></ProductSKU>
			<StoreID><%=StoreID%></StoreID>
			<FulfillmentCenterID><%=FulfillmentCenterID%></FulfillmentCenterID>
			<VendorID><%=VendorID%></VendorID>
			<QTYReceived><%=QTYReceived%></QTYReceived>
			<ReceiptDate><%=ReceiptDate%></ReceiptDate>
		</InventoryReceipt>
	</DataArea> 
</Response_WCS_CreateInvReceipt>
