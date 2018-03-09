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
<!DOCTYPE Response_WCS_CreateShipConfirm SYSTEM 
'Response_WCS_CreateShipConfirm_10.dtd'>
<Response_WCS_CreateShipConfirm version="1.0">
<%@page import="java.util.*,
  com.ibm.commerce.server.JSPHelper,
  com.ibm.commerce.beans.*,
  com.ibm.commerce.inventory.commands.*"
%><%
     JSPHelper jsphelper = new JSPHelper(request);
     String OrderNumber = jsphelper.getParameter(InventoryConstants.ORDERS_ID);
     String OrderReleaseNum = jsphelper.getParameter(InventoryConstants.ORDRELEASE_NUM);
     String PackageID = jsphelper.getParameter(InventoryConstants.PACKAGE_ID);
%>
	<ControlArea>
		<Verb value="Response"> </Verb>
		<Noun value="CreateShipConfirm"> </Noun>
	</ControlArea>
	<DataArea>
		<ShipmentConfirmation>
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
			<OrderNumber><%=OrderNumber%></OrderNumber>
			<OrderReleaseNum><%=OrderReleaseNum%></OrderReleaseNum>
			<PackageID><%=PackageID%></PackageID>
		</ShipmentConfirmation>
	</DataArea> 
</Response_WCS_CreateShipConfirm>