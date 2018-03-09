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
  com.ibm.commerce.tools.util.UIUtil,
  com.ibm.commerce.inventory.commands.*"
%><%
     JSPHelper jsphelper = new JSPHelper(request);
     String ManifestID = jsphelper.getParameter(InventoryConstants.MANIFEST_ID);
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
			<ResponseStatus status="OK" />
			<ManifestID><%=ManifestID%></ManifestID>
			<OrderNumber><%=OrderNumber%></OrderNumber>
			<OrderReleaseNum><%=OrderReleaseNum%></OrderReleaseNum>
			<PackageID><%=PackageID%></PackageID>
		</ShipmentConfirmation>
	</DataArea> 
</Response_WCS_CreateShipConfirm>