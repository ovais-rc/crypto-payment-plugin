<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2001
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%><%@ page import="javax.servlet.*,
java.util.*,
com.ibm.commerce.datatype.*,
com.ibm.commerce.server.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.messaging.util.*,
com.ibm.commerce.order.beans.*,
com.ibm.commerce.order.objects.*,
com.ibm.commerce.inventory.beans.*,
com.ibm.commerce.inventory.commands.*,
com.ibm.commerce.inventory.objects.*,
com.ibm.commerce.server.JSPHelper,
com.ibm.commerce.tools.util.UIUtil,
com.ibm.commerce.inventory.commands.*,
com.ibm.commerce.fulfillment.commands.*"%><%!

public Vector ConvertToVectorOfTypedProperty(String s)
{
	int startidx = s.indexOf('[');
	int endidx = s.lastIndexOf(']');
	String arr = s.substring(startidx+1, endidx);
	StringTokenizer stkn = new StringTokenizer(arr, ",");
	Vector vec = new Vector();

	int n = stkn.countTokens();
	
	String parmVal=null;
	String parmName=null;
	
	for (int i = 0; i < n; i++)
	{
		TypedProperty h = new TypedProperty();
		String hstr = stkn.nextToken();

		StringTokenizer htkn = new StringTokenizer(hstr, "\n");
		int m = htkn.countTokens();

		for (int k = 0; k < m; k++)
		{
			String tmp = htkn.nextToken();
			int l = tmp.indexOf("=");
			if (l > 0)
			{
				StringTokenizer ttkn = new StringTokenizer(tmp.substring(0, l));
				parmName = ttkn.nextToken();			
				ttkn = new StringTokenizer(tmp.substring(l + 1));
				parmVal = null;
		  
				while (ttkn.hasMoreElements()) {
					if (parmVal != null) {
						parmVal = parmVal.concat(" ");
						parmVal = parmVal.concat(ttkn.nextToken());
					} else
					parmVal = ttkn.nextToken();
				}
				if (parmVal == null)
				{
					parmVal = "";
				}
			  	h.put(parmName, parmVal);
			}
		}	

	  	vec.addElement(h);
	 }
   return vec;				
}    
%><%
   try {

	JSPHelper jsphelper = new JSPHelper(request);
	String istrProductInventoryInfoVector = jsphelper.getParameter("ProductInventoryInfoVector");
	Vector productInventoryInfoVector = ConvertToVectorOfTypedProperty(istrProductInventoryInfoVector);
	TypedProperty productInventoryInfo = new TypedProperty();
	String partNumber = null;
	Integer quantity = null;
	String reqDate = null;
	Integer storeId = null;
	Integer ffmcId = null;
	Long wcOrderId = null;
	Long wcOrderItemId = null;

	String tabString = "     ";

   
        // Generate Inventory Request Message Header Information
        out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        out.println("<!DOCTYPE Request_WCS_BE_ProductInventory SYSTEM \"Request_WCS_BE_ProductInventory_10.dtd\">");
        out.println("<Request_WCS_BE_ProductInventory version=\"1.0\">");
        out.println(tabString + "<ControlArea>");
        out.println(tabString + tabString + "<Verb value=\"Request\"> </Verb>");
        out.println(tabString + tabString + "<Noun value=\"WCS_BE_ProductInventory\"> </Noun>");
        out.println(tabString + "</ControlArea>");
        out.println(tabString + "<DataArea>");

        for (int i=0; i<productInventoryInfoVector.size(); i++){
	        productInventoryInfo = (TypedProperty) productInventoryInfoVector.get(i);
			
			out.println(tabString + tabString + "<ProductInventoryInfo>"); 
		
	        wcOrderId = productInventoryInfo.getLong("orderId",-1);
	        if (wcOrderId.longValue() != -1) {
	                out.println(tabString + tabString + tabString + "<WCOrderId>"+ wcOrderId.toString() + "</WCOrderId>");
	        }

	        wcOrderItemId = productInventoryInfo.getLong("orderItemId",-1);
	        if (wcOrderItemId.longValue() != -1) {
	                out.println(tabString + tabString + tabString + "<WCOrderItemId>"+ wcOrderItemId.toString() + "</WCOrderItemId>");
	        }
		

	        partNumber = productInventoryInfo.getString("partNumber", null);
	        if (partNumber != null) {
	                out.println(tabString + tabString + tabString + "<ProductSKU>"+ partNumber + "</ProductSKU>");
	        }

	        quantity = productInventoryInfo.getInteger("quantity",-1);
	        if (quantity.intValue() != -1) {
	                out.println(tabString + tabString + tabString + "<RequestedQuantity>"+ quantity.toString() + "</RequestedQuantity>");
	        }
	                

	        reqDate = productInventoryInfo.getString("reqDate",null);
	        if (reqDate != null) {
	                out.println(tabString + tabString + tabString + "<RequestedDate>"+ quantity.toString() + "</RequestedDate>");
	        }
	                 

	        storeId = productInventoryInfo.getInteger("storeId",-1);
	        if (storeId.intValue() != -1) {
	                out.println(tabString + tabString + tabString + "<StoreID>"+ storeId.toString() + "</StoreID>");
	        }

	        ffmcId = productInventoryInfo.getInteger("fulfillmentCenterId",-1);
	        if (ffmcId.intValue() != -1) {
	                out.println(tabString + tabString + tabString + "<FulfillmentCenterID>"+ ffmcId.toString() + "</FulfillmentCenterID>");
	        }

	        out.println(tabString + tabString + "</ProductInventoryInfo>");
        }
        out.println(tabString + "</DataArea>");
        out.println("</Request_WCS_BE_ProductInventory>");
   } catch (Exception e) {
        out.println("Exception => " + e);
   };
%>
