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
<!DOCTYPE Response_WCS_UpdateInvReceipt SYSTEM 'Response_WCS_UpdateInvReceipt_10.dtd'>
<Response_WCS_UpdateInvReceipt version="1.0">
<%@ page buffer="32kb" autoFlush="true" %><%@page import="java.util.*,
  com.ibm.commerce.server.JSPHelper,
  com.ibm.commerce.beans.*,
  com.ibm.commerce.inventory.commands.*"
%><%
     JSPHelper jsphelper = new JSPHelper(request);
     String ItemOwnerID = jsphelper.getParameter(InventoryConstants.MEMBER_ID);
     String ProductSKU = jsphelper.getParameter(InventoryConstants.PARTNUMBER);
     String StoreID = jsphelper.getParameter(InventoryConstants.STORE_ID);
     String FulfillmentCenterID = jsphelper.getParameter(InventoryConstants.FFMCENTER_ID);
     String QTYAdjusted = jsphelper.getParameter(InventoryConstants.QUANTITY);
     String InvAdjCodeID = jsphelper.getParameter(InventoryConstants.INVADJCODE_ID);
%>
	<ControlArea>
		<Verb value="Response"> </Verb>
		<Noun value="UpdateInvReceipt"> </Noun>
	</ControlArea>
	<DataArea>
		<InventoryReceipt>
<%
   out.print("		<ResponseStatus status=\"ERROR\" code=\"");

   try
   {
	ErrorDataBean errorBean = new ErrorDataBean (); 
	com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);

        out.println(errorBean.getMessageKey() + "\" >");
        out.println("		ExceptionData: " + errorBean.getExceptionData());
        out.println("		" + errorBean.getMessage() );

   }catch (Exception e) {
        out.println("Unexpected_Error\" >");
   }
   
   out.println("		</ResponseStatus>");
%>
			<ItemOwnerID><%=ItemOwnerID%></ItemOwnerID>
			<ProductSKU><%=ProductSKU%></ProductSKU>
			<StoreID><%=StoreID%></StoreID>
			<FulfillmentCenterID><%=FulfillmentCenterID%></FulfillmentCenterID>
			<QTYAdjusted><%=QTYAdjusted%></QTYAdjusted>
			<InvAdjCodeID><%=InvAdjCodeID%></InvAdjCodeID>
		</InventoryReceipt>
	</DataArea> 
</Response_WCS_UpdateInvReceipt>
