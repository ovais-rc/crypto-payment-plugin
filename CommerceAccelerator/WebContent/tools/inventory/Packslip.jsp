<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
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
//* ES 7/25/01 - beans integrated and working
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.inventory.beans.PackslipDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.PackslipDetailDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.PackslipOrderItemDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.OrderReleaseDataBean" %>

<%@ include file="../common/common.jsp" %>

<%!
// Process the nested Kit, only for AOP
public int processNestedKit(PackslipItemComponentDataBean aPackslipItemComponentDataBean, String skuPrefix, int rowselect,javax.servlet.jsp.JspWriter out){
   try{
   int numberOfPackslipItemComponents = 0; 
   PackslipItemComponentDataBean[] packslipItemComponentList = aPackslipItemComponentDataBean.getPackslipItemComponentList();
   if (packslipItemComponentList != null){
      	numberOfPackslipItemComponents = packslipItemComponentList.length;
   	 	PackslipItemComponentDataBean packslipItemComponent;
        for (int j=0; j<numberOfPackslipItemComponents ; j++){
        	packslipItemComponent = packslipItemComponentList[j];
       		String component_SKU = packslipItemComponent.getSKU();
	        String compSKU_display	= skuPrefix + component_SKU;
       		String component_productName = packslipItemComponent.getProductName();
       		String component_productDescription = packslipItemComponent.getProductDescription();
       		String component_quantity = packslipItemComponent.getQuantity();
       		String none = "";
            		
		    out.println(comm.startDlistRow(rowselect)); 

			out.println(comm.addDlistColumn(compSKU_display, "none" )); 
			out.println(comm.addDlistColumn(component_quantity, "none" )); 
		    out.println(comm.addDlistColumn(component_productName, "none" )); 
			out.println(comm.addDlistColumn(component_productDescription, "none" )); 
			out.println(comm.addDlistColumn(none, "none" )); 
			out.println(comm.addDlistColumn(none, "none" )); 
			out.println(comm.addDlistColumn(none, "none" )); 
     		
     		out.println(comm.endDlistRow()); 
     		
            if(rowselect==1){
            	rowselect = 2;
   	        }else{
     		    rowselect = 1;
   	        }
            rowselect = processNestedKit(packslipItemComponent, skuPrefix + "...",rowselect,out);

       }//end for
	}//end if
	}catch(Exception e){
	    e.printStackTrace();
	}
	return 	rowselect;
}
%>

<%
   Hashtable FulfillmentNLS = null;
   int numberOfPackslipItems = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();
   Integer storeId = cmdContext.getStoreId();
   StoreDataBean  storeBean = new StoreDataBean();
   storeBean.setStoreId(storeId.toString());
   com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);
//   String complexOrder = "";
//   try {
//     complexOrder = storeBean.getComplexOrderStatus();
//   }catch(Exception e){
//   }

   Integer langId = cmdContext.getLanguageId();
   String sLang = langId.toString();
   String sLocale = sLang.trim();

   // obtain the resource bundle for display
   FulfillmentNLS = (Hashtable)ResourceDirectory.lookup("inventory.FulfillmentNLS", localeUsed   );

   String orderNum = request.getParameter("orderNumber");
   String releaseNum = request.getParameter("releaseNumber");
 
   String pageTitle = UIUtil.toHTML((String)FulfillmentNLS.get("Packslip")); 

   OrderReleaseDataBean orderRelease = new OrderReleaseDataBean(); 

   orderRelease.setDataBeanKeyOrdersId(orderNum); 
   orderRelease.setDataBeanKeyOrderReleaseNum(releaseNum); 

   DataBeanManager.activate(orderRelease, request);

   PackslipDetailDataBean packslipDetail = orderRelease.parsePackSlipXml();

   String storeName = "";
   String fulfillmentCenter = "";
   String pickbatchNumber = "";
   String address1 = "";
   String address2 = "";
   String address3 = "";
   String city = "";
   String state = "";
   String zip = "";
   String country = "";
   String address = "";
   String customerNumber = "";
   String firstName = "";
   String lastName = "";
   String middleName = "";
   String orderDate = "";
   String shipmode = "";
   String invoice = "";
   String formattedDate = null;
   String showName = "";
   String showAddress = "";
   String showAddress1 = "";
   String showAddress2 = "";
   String comma = ", ";
   String space = " ";
   
   // TH-713-538...
   String shipInstructions = "";
   String shipCarrAccntNum = "";
   // ...End
   
   String adjustmentTotalCharge="";
   String taxTotalCharge="";
   String shippingChargeTotal="";
   //String originalShippingChargeTotal="";
   //String shippingAdjustmentTotal="";
   String productTotal="";
   String shippingTaxTotal="";
   String totalCharge="";
   String isExpedited="";
   String expediteNLV = "";
   PackslipOrderItemDataBean[] packslipItemList = null;

   if (packslipDetail != null)
   {  
      	storeName = packslipDetail.getStoreName();
	if (storeName == null)
	{ storeName = "";}

      	fulfillmentCenter = packslipDetail.getFulfillmentCenter();
	if (fulfillmentCenter == null)
	{ fulfillmentCenter = "";}

      	pickbatchNumber = packslipDetail.getPickbatchNumber();
	if (pickbatchNumber == null)
	{ pickbatchNumber = "";}

	invoice = packslipDetail.getInvoiceMethod();
	if (invoice == null)
	{ invoice = "";}

	address1 = packslipDetail.getAddress1();
  	if (address1 == null) 
	{ address1 = "";} else {
		address1 = address1 + " ";}

	address2 = packslipDetail.getAddress2();
  	if (address2 == null) 
	{ address2 = "";} else {
		address2 = address2 + " ";}

	address3 = packslipDetail.getAddress3();
  	if (address3 == null) 
	{ address3 = "";} else {
		address3 = address3 + " ";}

	city = packslipDetail.getCity();
  	if (city == null) 
	{ city = "";} else {
		city = city + " ";}

	state = packslipDetail.getState();
  	if (state == null) 
	{ state = "";} else {
		state = state + " ";}

	zip = packslipDetail.getZip();
  	if (zip == null) 
	{ zip = "";} else {
		zip = zip + " ";}

	country = packslipDetail.getCountry();
  	if (country == null) 
	{ country = "";} else {
		country = country + " ";}

	customerNumber = packslipDetail.getCustomerNumber();

	firstName = packslipDetail.getFirstName();
  	if (firstName == null) 
	{ firstName = "";} 

	lastName = packslipDetail.getLastName();
  	if (lastName == null) 
	{ lastName = "";} 

	middleName = packslipDetail.getMiddleName();
  	if (middleName == null) 
	{ middleName = "";} else {
		middleName = middleName + " ";}
		
    adjustmentTotalCharge = packslipDetail.getAdjustmentTotalCharge();
    if (adjustmentTotalCharge == null){
        adjustmentTotalCharge="";}
   
    taxTotalCharge = packslipDetail.getTaxTotalCharge();
    if (taxTotalCharge == null){
        taxTotalCharge="";}
   
    shippingChargeTotal = packslipDetail.getShippingChargeTotal();
    if (shippingChargeTotal == null){
        shippingChargeTotal="";}
    //originalShippingChargeTotal = packslipDetail.getOriginalShippingChargeTotal();
    //if (originalShippingChargeTotal == null){
    //    originalShippingChargeTotal="";}
    //shippingAdjustmentTotal = packslipDetail.getShippingAdjustmentTotal();
    //if (shippingAdjustmentTotal == null){
    //    shippingAdjustmentTotal="";}
   
    productTotal = packslipDetail.getProductTotalCharge();
    if (productTotal == null){
        productTotal="";}
   
    shippingTaxTotal = packslipDetail.getShippingTaxTotal();
    if (shippingTaxTotal == null){
        shippingTaxTotal="";}
   
    totalCharge = packslipDetail.getTotalCharge();
    if (totalCharge == null){
        totalCharge="";}
    

	orderDate = packslipDetail.getOrderDate();
	shipmode = packslipDetail.getShippingProvider();
	
	shipInstructions = packslipDetail.getShippingInstructions();
	if (shipInstructions == null)  {
		shipInstructions = "";
	}
	
	shipCarrAccntNum = packslipDetail.getShippingCarrierAccntNum();
	if (shipCarrAccntNum == null)  {
		shipCarrAccntNum = "";
	}

    
  	if (orderDate == null){
     formattedDate = "";
  	}else{
     Timestamp tmp_createdDate = Timestamp.valueOf(orderDate);
     formattedDate = TimestampHelper.getDateFromTimestamp(tmp_createdDate, localeUsed );
	}

  	packslipItemList = packslipDetail.getPackslipOrderItemList();
  	if (packslipItemList != null)
  	{	
     numberOfPackslipItems = packslipItemList.length;
  	}

	if (sLocale.equals("-3")) {
		showName = firstName + middleName + lastName;
		showAddress = address1 + address2 + address3;
		showAddress1 = zip + city;
		showAddress2 = state + country;

	} else if (sLocale.equals("-6")) {
		showName = firstName + middleName + lastName;
		showAddress = address1 + address2 + address3;
		showAddress1 = zip + city;
		showAddress2 = state + country;

	} else if (sLocale.equals("-5")) {
		showName = firstName + space + middleName + lastName;
		showAddress = address1 + address2 + address3;
		showAddress1 = zip + city;
		showAddress2 = state + country;

	} else if (sLocale.equals("-2")) {
		showName = firstName + space + middleName + lastName;
		showAddress = address1 + address2 + address3;
		showAddress1 = zip + city;
		showAddress2 = state + country;

	} else if (sLocale.equals("-4")) {
		showName = firstName + space + middleName + lastName;
		showAddress = address1 + address2 + address3;
		showAddress1 = zip + city;
		showAddress2 = state + country;

	} else if (sLocale.equals("-7")) {
		showName = lastName + firstName;
		showAddress = country;
		showAddress1 = state + city;
		showAddress2 = address1 + address2 + address3 + zip;

	} else if (sLocale.equals("-10")) {
		showName = lastName + firstName;
		showAddress = country + zip;
		showAddress1 = state + city;
		showAddress2 = address1 + address2 + address3;

	} else if (sLocale.equals("-9")) {
		showName = lastName + firstName;
		showAddress = zip + country;
		showAddress1 = state + city;
		showAddress2 = address1 + address2 + address3;

	} else if (sLocale.equals("-8")) {
		showName = lastName + firstName;
		showAddress = country + state;
		showAddress1 = zip + city;
		showAddress2 = address1 + address2 + address3;

	} else {
		showName = firstName + space + middleName + lastName;
		showAddress = address1 + address2 + address3;
		showAddress1 = city + state;
		showAddress2 = zip + country;
	}
	
    }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>
<H1><%=pageTitle%></H1>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

    function onLoad()
    {
      //parent.loadFrames();

      if (parent.parent.setContentFrameLoaded) {
          parent.parent.setContentFrameLoaded(true);
      }

    }


// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfPackslipItems;
          int totalpage = totalsize/listSize;
	
%>


<FORM NAME="Packslip">

<P>
<TABLE>
   <TR>
        <TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("StoreName")) %></b>  <%=storeName%></TD>
	<TD> <b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PickBatchID")) %></b> <%=pickbatchNumber%> </TD>
   </TR>
   <TR>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("FFCName")) %></b> <%=fulfillmentCenter%> </TD>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSOrderNumber")) %></b> <%=UIUtil.toHTML(orderNum)%> </TD>
    </TR>
   <TR>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSOrderDate")) %></b>  <%=formattedDate%> </TD>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSReleaseNumber")) %></b>  <%=UIUtil.toHTML(releaseNum)%></TD>
    </TR>
   <TR>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSShippingProvider")) %></b>  <%=shipmode%> </TD>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSCustomerNumber")) %></b>  <%=customerNumber%> </TD>
   </TR>
   <TR>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSShippingAddress")) %></b> <%=showName%> </TD>
	<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSInvoice")) %></b>  <%=invoice%> </TD>
    </TR>
</TABLE>
<TABLE>
   <TR>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD> <%=showAddress%> </TD>
    </TR>
   <TR>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD> <%=showAddress1%> </TD>
    </TR>
   <TR>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD>&nbsp;</TD>
	<TD> <%=showAddress2%> </TD>
    </TR>

</TABLE>

<TABLE>
	<TR>
		<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSShippingInstructions")) %></b>  <%=shipInstructions%> </TD>
   	</TR>
	<TR>   
		<TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSShipCarrAccntNum")) %></b>  <%=shipCarrAccntNum%> </TD>
   	</TR>

</TABLE>


 <BR/>
 <BR/>
 <BR/>
 <TABLE>  
   <TR>
    <TD><b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSCharges")) %></b>  </TD>
    <TD><b></b> </TD>
   </TR>
   <TR>
    <TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSAdjustmentTotalCharge")) %></TD>
    <TD align="right"><%=adjustmentTotalCharge%></TD>
   </TR>	
   <TR>	
	<TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSTaxTotalCharge")) %></TD>
	<TD align="right"><%=taxTotalCharge%></TD>
   </TR>
   <TR>
	<TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSShippingChargeTotal")) %></TD>
	<TD align="right"><%=shippingChargeTotal%></TD>
   </TR>
   <TR>
	<TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSShippingTaxTotal")) %></TD>
	<TD align="right"><%=shippingTaxTotal%></TD>
   </TR>
   <TR>
    <TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSProductTotal")) %></TD>
	<TD align="right"><%=productTotal%></TD>
   </TR>
   <TR>
    <TD><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSTotalCharge")) %></TD>
	<TD align="right"><%=totalCharge%></TD>
   </TR>
</TABLE> 

<BR>

<%=comm.startDlistTable((String)FulfillmentNLS.get("PackslipList")) %>

<%= comm.startDlistRowHeading() %>

<%--//These next few rows get the header name from FulfillmentNLS file --%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSOrderItemId"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSComponentId"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSSKU"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSQuantity"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSProduct"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSDescription"), null, false  )%>
<% 
    String strExpedite = (String)FulfillmentNLS.get("PSExpedite");
    if (strExpedite.endsWith(":")) {
    	strExpedite = strExpedite.substring(0,strExpedite.length() - 1);
    }
%>
<%= comm.addDlistColumnHeading(strExpedite, null, false  )%>

<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSUnitPrice"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PSTotalPriceCurrency"), null, false  )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all pick batches -->
<%
    PackslipDataBean packslipBean;
  
     PackslipOrderItemDataBean packslipItem;
      for (int i=0; i<numberOfPackslipItems ; i++)
      {
         packslipItem = packslipItemList[i];
         String orderitemId = packslipItem.getOrderItemId();
         String SKU = packslipItem.getSKU();
         String productName = packslipItem.getProductName();
         String productDescription = packslipItem.getProductDescription();
         String quantity = packslipItem.getQuantity();
         String unitPrice = packslipItem.getUnitPrice();
	 	 String totalPrice = packslipItem.getTotalPrice();
	 	 String currT = packslipItem.getCurrency();
	 	 String curr = currT.trim();
         String priceCurr = totalPrice + "(" + curr + ")";
         isExpedited = packslipItem.getIsExpedited();
         if (isExpedited.equals("Y")){
         	expediteNLV = (String)FulfillmentNLS.get("PSExpeditY");
         }else{
         	expediteNLV = (String)FulfillmentNLS.get("PSExpeditN");
         }
%>

	<%=  comm.startDlistRow(rowselect) %>

    <%= comm.addDlistColumn(orderitemId, "none" ) %>
    <%= comm.addDlistColumn("", "none" ) %>
	<%= comm.addDlistColumn(SKU, "none" ) %>
	<%= comm.addDlistColumn(quantity, "none" ) %>
	<%= comm.addDlistColumn(productName, "none" ) %>
	<%= comm.addDlistColumn(productDescription, "none" ) %>
	<%= comm.addDlistColumn(expediteNLV, "none" ) %>

	<%= comm.addDlistColumn(unitPrice, "none" ) %> 
	<%= comm.addDlistColumn(priceCurr, "none" ) %>

	<%= comm.endDlistRow() %>

<%

	if(rowselect==1)
   	{
     		rowselect = 2;
   	}else{
     		rowselect = 1;
   	}

         int numberOfPackslipItemComponents = 0; 
   	     PackslipItemComponentDataBean[] packslipItemComponentList =  packslipItem.getPackslipItemComponentList();
         if (packslipItemComponentList != null){
         	numberOfPackslipItemComponents = packslipItemComponentList.length;

      	 	PackslipItemComponentDataBean packslipItemComponent;
         	for (int j=0; j<numberOfPackslipItemComponents ; j++)
         	{
            		packslipItemComponent = packslipItemComponentList[j];
                    
                    String component_Id = packslipItemComponent.getComponentId();
            		String component_SKU = packslipItemComponent.getSKU();
			        String compSKU_display	= component_SKU;
            		String component_productName = packslipItemComponent.getProductName();
            		String component_productDescription = packslipItemComponent.getProductDescription();
            		String component_quantity = packslipItemComponent.getQuantity();
            		String none = "";
            		
            		
%>
			<%=  comm.startDlistRow(rowselect) %>

            <%= comm.addDlistColumn("", "none" ) %>
            <%= comm.addDlistColumn(component_Id, "none" ) %>
			<%= comm.addDlistColumn(compSKU_display, "none" ) %>
			<%= comm.addDlistColumn(component_quantity, "none" ) %>
			<%= comm.addDlistColumn(component_productName, "none" ) %>
			<%= comm.addDlistColumn(component_productDescription, "none" ) %>
			<%= comm.addDlistColumn(none, "none" ) %> 
			<%= comm.addDlistColumn(none, "none" ) %>
			<%= comm.addDlistColumn(none, "none" ) %>

			<%= comm.endDlistRow() %>

<%
   if(rowselect==1){
        rowselect = 2;
   }else{
   		rowselect = 1;
   }

      rowselect = processNestedKit(packslipItemComponent,"",rowselect,out);

%>			

<%
		
		}//end of for

    	}//end of process itemcomplist
%>

<%
    }
%>
<%= comm.endDlistTable() %>

<%
   if ( numberOfPackslipItems == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)FulfillmentNLS.get("PSNoRows")) %>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  // -->
</SCRIPT>

</BODY>
</HTML>
