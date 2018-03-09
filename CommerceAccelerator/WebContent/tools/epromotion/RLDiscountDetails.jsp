<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002, 2016
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?xml version="1.0"?>
<%@page import="com.ibm.commerce.tools.epromotion.implementations.*" %>
<%@page import="com.ibm.commerce.tools.epromotion.util.XmlHelper" %>
<%@page import="com.ibm.commerce.tools.epromotion.util.EproUtil" %>
<%@page import="com.ibm.commerce.fulfillment.objects.ShippingModeAccessBean" %>
<%@page import="com.ibm.commerce.fulfillment.objects.ShippingModeDescriptionAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>
<%@page import="com.ibm.commerce.utils.TimestampHelper"%>
<%@page import="com.ibm.commerce.catalog.objects.CatalogGroupAccessBean"%>
<%@include file="epromotionCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>

<jsp:useBean id="rlDiscountDetails" scope="request" class="com.ibm.commerce.tools.epromotion.databeans.RLPromotionBean">
</jsp:useBean>
<%
	com.ibm.commerce.beans.DataBeanManager.activate(rlDiscountDetails, request);
	EproUtil util = new EproUtil();
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	String storeId = commandContext.getStoreId().toString();
	String langId = commandContext.getLanguageId().toString();
%>

<title><%=RLPromotionNLS.get("RLDiscountDetails_title")%></title>
<%=fPromoHeader%>
<!-- new html start here -->
<script>

function initializeState() 
{
	parent.setContentFrameLoaded(true);
}

function savePanelData() {}

</script>

<script>
function writeSchedule()
{
<%
 if(rlDiscountDetails.getRLPromotion().getDayInWeek().size() == 7)
 {
%>
 	document.write('<i><%= UIUtil.toJavaScript(RLPromotionNLS.get("allWeekdays").toString())%></i>');
<%
}
else
{
%>
	document.write('<i><%= UIUtil.toJavaScript(RLPromotionNLS.get("selectedWeekDays").toString())%></i>');
	document.write("<table>");
	
<%
	Vector diwVector = rlDiscountDetails.getRLPromotion().getDayInWeek();
	int i=0;
	while (i < diwVector.size()) 
	{
%>

		document.write("<tr>");
		document.write("<td><i><%= UIUtil.toJavaScript(RLPromotionNLS.get(diwVector.elementAt(i).toString().toLowerCase()).toString())%></i></td>");
		document.write("</tr>");

<%
		i++;
	}
%>
	document.write("</table>");
	document.write("<br>");
<%
}
%>
}

function writeDate() 
{
	<% if (EproUtil.timestampToString(rlDiscountDetails.getRLPromotion().getEndTimeStamp(), XmlHelper.EFFECTIVE_DATE_FORMAT).equalsIgnoreCase(XmlHelper.MAX_EFFECTIVE_DATE_VALUE))
	{%>
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("alwaysInEffect").toString())%>');
	<%}
	else
	{%>
		document.write("<br>");
		document.write("<table>");
		document.write("<tr>");
		document.write('<td><%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsStartDateLabel").toString())%></td>');
		document.write("<td><i><%=TimestampHelper.getDateFromTimestamp(rlDiscountDetails.getRLPromotion().getStartTimeStamp(), fLocale)%></td></i>");
		document.write("</tr>");
		document.write("<tr>");
		document.write('<td><%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsEndDateLabel").toString())%></td>');
		document.write("<td><i><%=TimestampHelper.getDateFromTimestamp(rlDiscountDetails.getRLPromotion().getEndTimeStamp(), fLocale)%></i></td>");
		document.write("</tr>");
		document.write("</table>");
		document.write("<br>");
	<%}%>
}

function writeTime() 
{
	<% if (EproUtil.timestampToString(rlDiscountDetails.getRLPromotion().getEndTimeStamp(), XmlHelper.EFFECTIVE_TIME_FORMAT).equalsIgnoreCase(XmlHelper.MAX_EFFECTIVE_TIME_VALUE))
	{%>
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rlDiscountAllTime").toString())%>');
	<%}
	else
	{%>
		document.write("<br>");
		document.write("<table>");
		document.write("<tr>");
		document.write('<td><%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsStartTimeLabel").toString())%></td>');
		document.write("<td><i><%=EproUtil.timestampToString(rlDiscountDetails.getRLPromotion().getStartTimeStamp(), XmlHelper.SCHEDULING_TIME_FORMAT, fLocale)%></i></td>");
		document.write("</tr>");
		document.write("<tr>");
		document.write('<td><%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsEndTimeLabel").toString())%></td>');
		document.write("<td><i><%=EproUtil.timestampToString(rlDiscountDetails.getRLPromotion().getEndTimeStamp(), XmlHelper.SCHEDULING_TIME_FORMAT, fLocale)%></i></td>");
		document.write("</tr>");
		document.write("</table>");
		document.write("<br>");
	<%}%>
}

function writeShopperGroups()
{
<% if(rlDiscountDetails.getRLPromotion().getValidForAllCustomers())
{%>
document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("allShopperGroups").toString())%>');
<%}
else
{%>
	document.write("<table>");

<%
	Vector mbrVector = rlDiscountDetails.getMemberGroupName();
	int i=0;
	while (i < mbrVector.size()) 
	{%>

		document.write("<tr>");
	  document.write("<td><i><%=mbrVector.elementAt(i)%></i></td>");
		document.write("</tr>");

		<%i++;
	}%>
	document.write("</table>");
	document.write("<br>");
<%}%>
}

function writeSpecificData()
{
  <%  
  if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("OrderLevelPercentDiscount")) {    
    if (rlDiscountDetails.getRLPromotion() instanceof OrderLevelPercentDiscount) {
      OrderLevelPercentDiscount obj = (OrderLevelPercentDiscount) rlDiscountDetails.getRLPromotion();     
    %>
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(0, 1, values, ranges);
    document.write('</p>');
    <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("OrderLevelValueDiscount")) {
    if (rlDiscountDetails.getRLPromotion() instanceof OrderLevelFixedDiscount) {
      OrderLevelFixedDiscount obj = (OrderLevelFixedDiscount) rlDiscountDetails.getRLPromotion();     
    %>
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(0, 0, values, ranges);
    document.write('</p>');
    <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("OrderLevelFixedShippingDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof OrderLevelShippingDiscount) {
      OrderLevelShippingDiscount obj = (OrderLevelShippingDiscount) rlDiscountDetails.getRLPromotion();	 
    %>
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    var adjustmentType = 1;
    adjustmentType = <%= obj.getAdjustmentType()%>
    <%
	String shippingMode = obj.getShippingMode();
	String ShipModeDesc = null;	
	
	if(shippingMode.equals("null"))
	{
		ShipModeDesc = (String)RLPromotionNLS.get("DiscountAllShippingModes");
	}
	else
	{
		ShippingModeDescriptionAccessBean smdab = new ShippingModeDescriptionAccessBean();
		smdab.setInitKey_languageId(fLanguageId);
		smdab.setInitKey_shipModeId(shippingMode);
		ShipModeDesc = smdab.getDescription();
		if (ShipModeDesc == null || ShipModeDesc.length() == 0) {
		    // use ship mode code instead
		    ShippingModeAccessBean shipAB = new ShippingModeAccessBean();
		    shipAB.setInitKey_shippingModeId(shippingMode);
		    StringBuffer shipModeDescBuf = new StringBuffer();
		    shipModeDescBuf.append(shipAB.getCarrier());
		    shipModeDescBuf.append(" - ");
		    shipModeDescBuf.append(shipAB.getCode());
		    ShipModeDesc = shipModeDescBuf.toString();
		}
	}
    %>	
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountShippingMode").toString())%> <i>');
    document.write('<%=UIUtil.toJavaScript(ShipModeDesc)%>');
    document.write("</i></p>");

    writeFixedShipping(values, ranges, adjustmentType);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("OrderLevelFreeGift"))
  {
    if (rlDiscountDetails.getRLPromotion() instanceof OrderLevelFreeGift) {
	String skuString = "";
      OrderLevelFreeGift obj = (OrderLevelFreeGift) rlDiscountDetails.getRLPromotion();

   	if (obj != null)
	{
		String catentryid = obj.getFreeItemCatalogEntrySKU();
		if (catentryid != null) {
		  CatalogEntryAccessBean catBean = new CatalogEntryAccessBean();
		  catBean.setInitKey_catalogEntryReferenceNumber(catentryid);
		  skuString = catBean.getPartNumber();
		}
	}
    %>
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
     <%= UIUtil.toJS("sku",skuString)%>

    writeOrderLevelGWP(values, ranges, sku);
    document.write("</p>");

  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ItemLevelBuyXGetYFree")){
    if (rlDiscountDetails.getRLPromotion() instanceof ItemLevelBuyXGetYFree) {
      ItemLevelBuyXGetYFree obj = (ItemLevelBuyXGetYFree) rlDiscountDetails.getRLPromotion();
      java.util.Vector skuVect = new java.util.Vector();
      java.util.Vector packgVect = new java.util.Vector();
      java.util.Vector skuNameVect = new java.util.Vector();
      java.util.Vector packgNameVect = new java.util.Vector();
      String catEntType = null;	
		if (obj != null)
		{		
			java.util.Vector catentryVec = obj.getCatalogEntrySKUs();
			for(int i=0; i <catentryVec.size(); i++)
			{
				String catentryid = catentryVec.elementAt(i).toString();	 
								
				if( (util.getSKUType(catentryid).trim()).equals("ItemBean"))
				{    	
			  		skuVect.addElement(util.getSKU(catentryid));
			  		skuNameVect.addElement(util.getSKUName(langId, catentryid));
			  	}
			  	else
			  	{			  		
			  		packgVect.addElement(util.getSKU(catentryid));
			  		packgNameVect.addElement(util.getSKUName(langId, catentryid));
			  	}			  	
			}	      
		} // end of if obj!= null
	
	String skuGiftString = "";
	if (obj != null)
	{
		String catentryid = obj.getDiscountItemCatalogEntrySKU();
		if (catentryid != null) {
		    CatalogEntryAccessBean catBean = new CatalogEntryAccessBean();
		    catBean.setInitKey_catalogEntryReferenceNumber(catentryid);
		    skuGiftString = catBean.getPartNumber();
		}

	}
		if(skuVect.size() > 0)
		{
%>
		  document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLItemSKUDetails").toString())%><br>');
	      <%= UIUtil.toJS("itemSkus",skuVect)%>
	      <%= UIUtil.toJS("itemSkuNames",skuNameVect)%>
	  	  for (var i=0; i<itemSkus.length; i++) {
	         document.write("<i>"+ itemSkus[i]+"</i>");
	         document.write("&nbsp;(<i>"+ itemSkuNames[i]+"</i>)<br>");
	      }  
<%
		}
		if(packgVect.size() > 0)
		{
%>
		document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLPackageSKUDetails").toString())%><br> ');
	    <%= UIUtil.toJS("pkgSkus",packgVect)%>
	    <%= UIUtil.toJS("pkgSkuNames",packgNameVect)%>
	  	for (var i=0; i<pkgSkus.length; i++) {
	         document.write("<i>"+ pkgSkus[i]+"</i>");
	         document.write("&nbsp;(<i>"+ pkgSkuNames[i]+"</i>)<br>");
	    }  

<%	    }
	if(obj.getRequiredQuantity().equalsIgnoreCase("-1"))
	{ 
  
  %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree1").toString())%> '+'<%=obj.getMaximumDiscountItemQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree2").toString())%> '+'<%= skuGiftString %>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree4").toString())%>.</i>');
      document.write("</p>");      
  <%
	}
	else
	{
  %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree1").toString())%> '+'<%=obj.getMaximumDiscountItemQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree2").toString())%> '+'<%= skuGiftString %>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree3").toString())%> '+'<%=obj.getRequiredQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("byItem").toString())%>.</i>');
      document.write("</p>");      
  <%
	}
    }
  }
  else if (rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ProductLevelBuyXGetYFree")){
    if(rlDiscountDetails.getRLPromotion() instanceof ProductLevelBuyXGetYFree) {
      ProductLevelBuyXGetYFree obj = (ProductLevelBuyXGetYFree) rlDiscountDetails.getRLPromotion();
      String skuString = "";
      String skuName = "";
      Vector skuList = new Vector();
      Vector skuNameList = new Vector();
      String skuGiftString = "";
      
      	if (obj != null)
		{
			Vector catEntries = obj.getCatalogEntryIDs();
			skuList = new Vector();
			for(int i=0; i < catEntries.size(); i++)
			{
				String catentryid = catEntries.elementAt(i).toString();	 
				skuString = util.getSKU(catentryid);
				skuName = util.getSKUName(langId, catentryid);
			  	skuList.addElement(skuString);
			  	skuNameList.addElement(skuName);
			}	  
					
			String catid = obj.getDiscountProductSKU();
			if (catid != null) {
			    skuGiftString = util.getSKU(catid);
			}	
			    
		}
	
  %>      
     
  	   document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLProdSKUDetails").toString())%> ' + '<br>');
  <%= UIUtil.toJS("prodSkus",skuList)%>
  <%= UIUtil.toJS("prodSkuNames",skuNameList)%>
  	  for (var i=0; i<prodSkus.length; i++) {
         document.write("<i>"+ prodSkus[i]+"</i>");
         document.write("&nbsp(<i>"+ prodSkuNames[i]+"</i>)<br>");
      }  
      document.write("</p>");      
  <%

	if(obj.getRequiredQuantity().equalsIgnoreCase("-1"))
	{   
  %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree1").toString())%> '+'<%=obj.getMaximumDiscountItemQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree2").toString())%> '+'<%=skuGiftString %>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree4").toString())%>.</i>');
      document.write("</p>");      
  <%
	}
	else
	{
  %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree1").toString())%> '+'<%=obj.getMaximumDiscountItemQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree2").toString())%> '+'<%=skuGiftString %>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree3").toString())%> '+'<%=obj.getRequiredQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("byItem").toString())%>.</i>');
      document.write("</p>");      
  <%
	}
    }	
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ItemLevelSameItemPercentDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ItemLevelSameItemPercentDiscount) {
      	ItemLevelSameItemPercentDiscount obj = (ItemLevelSameItemPercentDiscount) rlDiscountDetails.getRLPromotion();
     	java.util.Vector skuVect = new java.util.Vector();
     	java.util.Vector packgVect = new java.util.Vector();
     	java.util.Vector skuNameVect = new java.util.Vector();
        java.util.Vector packgNameVect = new java.util.Vector();
     	String catEntType = null;	
			if (obj != null)
			{		
				java.util.Vector catentryVec = obj.getCatalogEntrySKUs();
				for(int i=0; i <catentryVec.size(); i++)
				{
					String catentryid = catentryVec.elementAt(i).toString();	 
							
					if( (util.getSKUType(catentryid).trim()).equals("ItemBean"))
					{    	
				  		skuVect.addElement(util.getSKU(catentryid));
				  		skuNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}
				  	else
				  	{
				  		packgVect.addElement(util.getSKU(catentryid));
				  		packgNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}			  	
				}	      
			} // end of if obj!= null
			if(skuVect.size() > 0)
			{
%>
			  document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLItemSKUDetails").toString())%><br>');
		      <%= UIUtil.toJS("itemSkus",skuVect)%>
		      <%= UIUtil.toJS("itemSkuNames",skuNameVect)%>
		  	  for (var i=0; i<itemSkus.length; i++) {
		         document.write("<i>"+ itemSkus[i]+"</i>");
		         document.write("&nbsp;(<i>"+ itemSkuNames[i]+"</i>)<br>");
		      }  
<%
			}
			if(packgVect.size() > 0)
			{
%>
			document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLPackageSKUDetails").toString())%><br> ');
		    <%= UIUtil.toJS("pkgSkus",packgVect)%>
		    <%= UIUtil.toJS("pkgSkuNames",packgNameVect)%>
		  	for (var i=0; i<pkgSkus.length; i++) {
		         document.write("<i>"+ pkgSkus[i]+"</i>");
		         document.write("&nbsp;(<i>"+ pkgSkuNames[i]+"</i>)<br>");
		    }  

<%	    	}

      if (obj.getValue().equalsIgnoreCase("100")) {
      // 100% means buy X get one free  
          String details = RLPromotionNLS.get("RLDiscountDetailsBuyXGetAdditionalFree_itemlvl").toString();
	      details = EproUtil.replaceSubstring(details, "{0}", obj.getMaximumDiscountItemQuantity(), 0);
	      details = EproUtil.replaceSubstring(details, "{1}", obj.getRequiredQuantity(), 0);      
    %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(details)%></i>');
      document.write("</p>");      
  <%
      }
	  else
	  {
	      String details = RLPromotionNLS.get("RLDiscountDetailsBuyXGetAddtionalAtDiscount_itemlvl").toString();
	      details = EproUtil.replaceSubstring(details, "{0}", obj.getMaximumDiscountItemQuantity(), 0);
	      details = EproUtil.replaceSubstring(details, "{1}", obj.getValue(), 0);
	      details = EproUtil.replaceSubstring(details, "{2}", obj.getRequiredQuantity(), 0);
    %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(details)%></i>');
      document.write("</p>");      
  <%
	  }
	
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ItemLevelPercentDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ItemLevelPercentDiscount) {
      	ItemLevelPercentDiscount obj = (ItemLevelPercentDiscount) rlDiscountDetails.getRLPromotion();    
   		java.util.Vector skuVect = new java.util.Vector();
     	java.util.Vector packgVect = new java.util.Vector();
     	java.util.Vector skuNameVect = new java.util.Vector();
        java.util.Vector packgNameVect = new java.util.Vector();
     	String catEntType = null;	
			if (obj != null)
			{		
				java.util.Vector catentryVec = obj.getCatalogEntrySKUs();
				for(int i=0; i <catentryVec.size(); i++)
				{
					String catentryid = catentryVec.elementAt(i).toString();	 
							
					if( (util.getSKUType(catentryid).trim()).equals("ItemBean"))
					{    	
				  		skuVect.addElement(util.getSKU(catentryid));
				  		skuNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}
				  	else
				  	{
				  		packgVect.addElement(util.getSKU(catentryid));
				  		packgNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}			  	
				}	      
			} // end of if obj!= null  
		    if(skuVect.size() > 0)
			{
%>
			   document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLItemSKUDetails").toString())%><br>');
		       <%= UIUtil.toJS("itemSkus",skuVect)%>
		       <%= UIUtil.toJS("itemSkuNames",skuNameVect)%>
		  	   for (var i=0; i<itemSkus.length; i++) {
		           document.write("<i>"+ itemSkus[i]+"</i>");
		           document.write("&nbsp;(<i>"+ itemSkuNames[i]+"</i>)<br>");
		       }  
<%
			}
			if(packgVect.size() > 0)
			{
%>
				document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLPackageSKUDetails").toString())%><br> ');
			    <%= UIUtil.toJS("pkgSkus",packgVect)%>
			    <%= UIUtil.toJS("pkgSkuNames",packgNameVect)%>
			  	for (var i=0; i<pkgSkus.length; i++) {
			         document.write("<i>"+ pkgSkus[i]+"</i>");
			         document.write("&nbsp;(<i>"+ pkgSkuNames[i]+"</i>)<br>");
			    }  

<%	    	}	
   %>
    document.write("</p>");
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(1, 1, values, ranges);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ProductLevelSameItemPercentDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ProductLevelSameItemPercentDiscount) {
     	ProductLevelSameItemPercentDiscount obj = (ProductLevelSameItemPercentDiscount) rlDiscountDetails.getRLPromotion();
      	java.util.Vector skuList = new java.util.Vector();
      	java.util.Vector skuNameList = new java.util.Vector();
        String skuString = "";
        String skuName = "";
            if (obj != null)
			{	
				Vector catEntries = obj.getCatalogEntryIDs();
				for(int i=0; i<catEntries.size(); i++)
				{
					String catentryid = catEntries.elementAt(i).toString();
					skuString = util.getSKU(catentryid);
					skuName = util.getSKUName(langId, catentryid);
			  		skuList.addElement(skuString);
			  		skuNameList.addElement(skuName);
				}		    		
		    }  
    %>
       <%= UIUtil.toJS("sku",skuString)%>
       
      document.write('<p>');
      document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLProdSKUDetails").toString())%> ');
  		  document.write('<br>');	
	      <%= UIUtil.toJS("prodSkus",skuList)%>
	      <%= UIUtil.toJS("prodNames",skuNameList)%>
  	 
	  	  for (var i=0; i<prodSkus.length; i++) {
	  	  	 document.write("<i>"+ prodSkus[i]+"</i>");
	         document.write("&nbsp(<i>"+ prodNames[i]+"</i>)<br>");
	      }  
      document.write("</p>");      
       
  <%

      if (obj.getValue().equalsIgnoreCase("100")) {
      // 100% means buy X get one free   
          String details = RLPromotionNLS.get("RLDiscountDetailsBuyXGetAdditionalFree_prolvl").toString();
	      details = EproUtil.replaceSubstring(details, "{0}", obj.getMaximumDiscountItemQuantity(), 0);
	      details = EproUtil.replaceSubstring(details, "{1}", obj.getRequiredQuantity(), 0);     
    %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(details)%></i>');
      document.write("</p>");      
  <%
      }
	else
	{
	      String details = RLPromotionNLS.get("RLDiscountDetailsBuyXGetAddtionalAtDiscount_prolvl").toString();
	      details = EproUtil.replaceSubstring(details, "{0}", obj.getMaximumDiscountItemQuantity(), 0);
	      details = EproUtil.replaceSubstring(details, "{1}", obj.getValue(), 0);
	      details = EproUtil.replaceSubstring(details, "{2}", obj.getRequiredQuantity(), 0);
    %>
      document.write('<p>');
      document.write('<i><%=UIUtil.toJavaScript(details)%></i>');
      document.write("</p>");      
  <%
	}	
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ProductLevelPercentDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ProductLevelPercentDiscount) {
      	ProductLevelPercentDiscount obj = null;      	
     		obj =  (ProductLevelPercentDiscount) rlDiscountDetails.getRLPromotion();      
			String skuString = "";
			String skuName = "";
			if (obj != null)
			{
	%>
			document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLProdSKUDetails").toString())%> ');
			document.write("<br>");
			
	<%			Vector catEntries = obj.getCatalogEntryIDs();
				for(int i=0; i<catEntries.size(); i++)
				{
				String catentryid = catEntries.elementAt(i).toString();	          	
			  	skuString = util.getSKU(catentryid);
			  	skuName = util.getSKUName(langId, catentryid);
		
    %>
    <%= UIUtil.toJS("sku",skuString)%>    
    document.write('<i><%=UIUtil.toJavaScript(skuString ).toString() %></i>');
    document.write('&nbsp;(<i><%= UIUtil.toJavaScript(skuName ).toString()%></i>)');    
    document.write("<br>");
  <%
  				} //for
  %>  
  document.write("</p>");
  <%
    	    } //  if obj!=null
    %>
    
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(2, 1, values, ranges);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ItemLevelPerItemValueDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ItemLevelPerItemValueDiscount) {
      ItemLevelPerItemValueDiscount obj = (ItemLevelPerItemValueDiscount) rlDiscountDetails.getRLPromotion();  
      java.util.Vector skuVect = new java.util.Vector();
      java.util.Vector packgVect = new java.util.Vector();
      java.util.Vector skuNameVect = new java.util.Vector();
      java.util.Vector packgNameVect = new java.util.Vector();
      String catEntType = null;	
			if (obj != null)
			{		
				java.util.Vector catentryVec = obj.getCatalogEntrySKUs();
				for(int i=0; i <catentryVec.size(); i++)
				{
					String catentryid = catentryVec.elementAt(i).toString();	 
							
					if( (util.getSKUType(catentryid).trim()).equals("ItemBean"))
					{    	
				  		skuVect.addElement(util.getSKU(catentryid));
				  		skuNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}
				  	else
				  	{
				  		packgVect.addElement(util.getSKU(catentryid));
				  		packgNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}			  	
				}	      
			} // end of if obj!= null  
		    if(skuVect.size() > 0)
			{
%>
			   document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLItemSKUDetails").toString())%><br>');
		       <%= UIUtil.toJS("itemSkus",skuVect)%>
		       <%= UIUtil.toJS("itemSkuNames",skuNameVect)%>
		  	   for (var i=0; i<itemSkus.length; i++) {
		           document.write("<i>"+ itemSkus[i]+"</i>");
		           document.write("&nbsp;(<i>"+ itemSkuNames[i]+"</i>)<br>");
		       }  
<%
			}
			if(packgVect.size() > 0)
			{
%>
				document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLPackageSKUDetails").toString())%><br> ');
			    <%= UIUtil.toJS("pkgSkus",packgVect)%>
			    <%= UIUtil.toJS("pkgSkuNames",packgNameVect)%>
			  	for (var i=0; i<pkgSkus.length; i++) {
			         document.write("<i>"+ pkgSkus[i]+"</i>");
			         document.write("&nbsp;(<i>"+ pkgSkuNames[i]+"</i>)<br>");
			    }  

<%	    	}	
	
  %>
    document.write("</p>");
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(1, 2, values, ranges);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ProductLevelPerItemValueDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ProductLevelPerItemValueDiscount) {
      ProductLevelPerItemValueDiscount obj = (ProductLevelPerItemValueDiscount) rlDiscountDetails.getRLPromotion();     
	  String skuString = "";
	  String skuName = "";
        	java.util.Vector skuList = new java.util.Vector();
        	java.util.Vector skuNameList = new java.util.Vector();
            if (obj != null)
			{	
				Vector catEntries = obj.getCatalogEntryIDs();
				for(int i=0; i<catEntries.size(); i++)
				{
					String catentryid = catEntries.elementAt(i).toString();
					skuString = util.getSKU(catentryid);
					skuName = util.getSKUName(langId, catentryid);
			  		skuList.addElement(skuString);
			  		skuNameList.addElement(skuName);
				}		    		
		    }  
  %>
  	document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLProdSKUDetails").toString())%> ');
    document.write('<br>');	
	 <%= UIUtil.toJS("prodSkus",skuList)%>
	 <%= UIUtil.toJS("prodSkuNames",skuNameList)%>
	  for (var i=0; i<prodSkus.length; i++) {
	     document.write("<i>"+ prodSkus[i]+"</i>");
	      document.write("&nbsp(<i>"+ prodSkuNames[i]+"</i>)<br>");
	  }  
    document.write("</p>");
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(2, 2, values, ranges);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ItemLevelValueDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ItemLevelValueDiscount) {
      ItemLevelValueDiscount obj = (ItemLevelValueDiscount) rlDiscountDetails.getRLPromotion(); 
      java.util.Vector skuVect = new java.util.Vector();
      java.util.Vector packgVect = new java.util.Vector();
      java.util.Vector skuNameVect = new java.util.Vector();
      java.util.Vector packgNameVect = new java.util.Vector();
      String catEntType = null;	
			if (obj != null)
			{		
				java.util.Vector catentryVec = obj.getCatalogEntrySKUs();
				for(int i=0; i <catentryVec.size(); i++)
				{
					String catentryid = catentryVec.elementAt(i).toString();	 
							
					if( (util.getSKUType(catentryid).trim()).equals("ItemBean"))
					{    	
				  		skuVect.addElement(util.getSKU(catentryid));
				  		skuNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}
				  	else
				  	{
				  		packgVect.addElement(util.getSKU(catentryid));
				  		packgNameVect.addElement(util.getSKUName(langId, catentryid));
				  	}			  	
				}	      
			} // end of if obj!= null  
		    if(skuVect.size() > 0)
			{
%>
			   document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLItemSKUDetails").toString())%><br>');
		       <%= UIUtil.toJS("itemSkus",skuVect)%>
		       <%= UIUtil.toJS("itemSkuNames",skuNameVect)%>
		  	   for (var i=0; i<itemSkus.length; i++) {
		           document.write("<i>"+ itemSkus[i]+"</i>");
		           document.write("&nbsp;(<i>"+ itemSkuNames[i]+"</i>)<br>");
		       }  
<%
			}
			if(packgVect.size() > 0)
			{
%>
				document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLPackageSKUDetails").toString())%><br> ');
			    <%= UIUtil.toJS("pkgSkus",packgVect)%>
			    <%= UIUtil.toJS("pkgSkuNames",packgNameVect)%>
			  	for (var i=0; i<pkgSkus.length; i++) {
			         document.write("<i>"+ pkgSkus[i]+"</i>");
			         document.write("&nbsp;(<i>"+ pkgSkuNames[i]+"</i>)<br>");
			    }  

<%	    	}	
	
   %>
    document.write("</p>");
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(1, 0, values, ranges);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("ProductLevelValueDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof ProductLevelValueDiscount) {
    	ProductLevelValueDiscount obj = (ProductLevelValueDiscount) rlDiscountDetails.getRLPromotion();      
	
		String skuString = "";
		String skuName = "";
		    java.util.Vector skuList = new java.util.Vector();
		     java.util.Vector skuNameList = new java.util.Vector();
		    if (obj != null)
			{	
				Vector catEntries = obj.getCatalogEntryIDs();
				for(int i=0; i<catEntries.size(); i++)
				{
					String catentryid = catEntries.elementAt(i).toString();
					skuString = util.getSKU(catentryid);
					skuName = util.getSKUName(langId, catentryid);
				  	skuList.addElement(skuString);
				  	skuNameList.addElement(skuName);
				}		    		
			} 
	%>
	document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLProdSKUDetails").toString())%> ');
    document.write('<br>');	
	<%= UIUtil.toJS("prodSkus",skuList)%>
	<%= UIUtil.toJS("prodSkuNames",skuNameList)%>
	  for (var i=0; i<prodSkus.length; i++) {
	     document.write("<i>"+ prodSkus[i]+"</i>");
	     document.write("&nbsp(<i>"+ prodSkuNames[i]+"</i>)<br>");
	  }  

    document.write("</p>");
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(2, 0, values, ranges);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("CategoryLevelPercentDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof CategoryLevelPercentDiscount) {
    	CategoryLevelPercentDiscount obj = null;      	
     	obj =  (CategoryLevelPercentDiscount) rlDiscountDetails.getRLPromotion();   
     	String cgryString = "";
     	String cgryName = "";
		if (obj != null)
		{
	%>
			document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLCategoryDetails").toString())%> ');
			document.write("<br>");
     <%		Vector cgryEntries = obj.getCatgpIdentifiers();
     		
     		for(int i=0; i<cgryEntries.size(); i++)
			{
				cgryString = cgryEntries.elementAt(i).toString();				
				cgryName = util.getCategoryName(storeId, langId, cgryString);		
				
	 %>
	 			
	  			document.write('<i><%=UIUtil.toJavaScript(cgryString ).toString()%></i>');
	  			document.write('&nbsp;(<i><%= UIUtil.toJavaScript(cgryName ).toString()%></i>)');
			    document.write("<br>");
  <%
  			} // end of for
  %>  
 			document.write("</p>");
  <%
    	} //  if obj!=null
  %> 
  	document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(3, 1, values, ranges);
    document.write("</p>");
  <%
    }
  } 
 else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("CategoryLevelValueDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof CategoryLevelValueDiscount) {
    	CategoryLevelValueDiscount obj = (CategoryLevelValueDiscount) rlDiscountDetails.getRLPromotion();      
	
		String cgryString = "";
		String cgryName = "";
	    if (obj != null)
		{	
	%>
		    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLCategoryDetails").toString())%> ');
            document.write('<br>');	
    <%
			Vector cgryEntries = obj.getCatgpIdentifiers();
			for(int i=0; i<cgryEntries.size(); i++)
			{
				cgryString = cgryEntries.elementAt(i).toString();		
				cgryName = util.getCategoryName(storeId, langId, cgryString);
	 %>
	  			document.write('<i><%=UIUtil.toJavaScript(cgryString ).toString()%></i>');
	  			document.write('&nbsp;(<i><%= UIUtil.toJavaScript(cgryName ).toString()%></i>)');
			    document.write("<br>");
  <%
  			} // end of for
		} 
	%>
    document.write("</p>");
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(3, 0, values, ranges);
    document.write("</p>");
  <%
    }
  }
   else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("CategoryLevelPerItemValueDiscount")){
     if (rlDiscountDetails.getRLPromotion() instanceof CategoryLevelPerItemValueDiscount) {
      CategoryLevelPerItemValueDiscount obj = (CategoryLevelPerItemValueDiscount) rlDiscountDetails.getRLPromotion();     
	   String cgryString ="";
	   String cgryName ="";     	
        if (obj != null)
		{	
			Vector cgryEntries = obj.getCatgpIdentifiers();		      
    %>
	  		document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLCategoryDetails").toString())%> ');
	    	document.write('<br>');	
		 	<%= UIUtil.toJS("categories",cgryEntries)%>
		<% 	for (int i=0; i<cgryEntries.size(); i++) {
			 cgryString = cgryEntries.elementAt(i).toString();
		  	 cgryName = util.getCategoryName(storeId, langId, cgryString);
		 %>
		     document.write('<i><%=UIUtil.toJavaScript(cgryString ).toString()%></i>');
		     document.write('&nbsp;(<i><%= UIUtil.toJavaScript(cgryName ).toString()%></i>)');
			 document.write("<br>");
		<%
		    } 
		%> 
    <%
    	}  
    %>
    document.write("</p>");
    document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsRangesLabel").toString())%>');
    <%= UIUtil.toJS("values",obj.getValues())%>
    <%= UIUtil.toJS("ranges",obj.getRanges())%>
    writeRangeTable(3, 2, values, ranges);
    document.write("</p>");
  <%
    }
  }
  else if(rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("CategoryLevelSameItemPercentDiscount")){
    if (rlDiscountDetails.getRLPromotion() instanceof CategoryLevelSameItemPercentDiscount) {
     	CategoryLevelSameItemPercentDiscount obj = (CategoryLevelSameItemPercentDiscount) rlDiscountDetails.getRLPromotion();
      	String cgryString ="";
	    String cgryName ="";  
        if (obj != null)
		{	
			Vector cgryEntries = obj.getCatgpIdentifiers();			
	  
    %>       
       
	      document.write('<p>');
	      document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLCategoryDetails").toString())%> ');
     	  document.write('<br>');	
	      <%= UIUtil.toJS("categories",cgryEntries)%>
	  <%  for (int i=0; i<cgryEntries.size(); i++) {
			 cgryString = cgryEntries.elementAt(i).toString();
		  	 cgryName = util.getCategoryName(storeId, langId, cgryString);
	  %>     
	  		 document.write('<i><%=UIUtil.toJavaScript(cgryString ).toString()%></i>');
		   	 document.write('&nbsp;(<i><%= UIUtil.toJavaScript(cgryName ).toString()%></i>)');
			 document.write("<br>");
		<%
		    } 
		%> 
    	  document.write("</p>");             
  <%

      if (obj.getValue().equalsIgnoreCase("100")) {
      // 100% means buy X get one free    
          String details = RLPromotionNLS.get("RLDiscountDetailsBuyXGetAdditionalFree_catlvl").toString();
	      details = EproUtil.replaceSubstring(details, "{0}", obj.getMaximumDiscountItemQuantity(), 0);
	      details = EproUtil.replaceSubstring(details, "{1}", obj.getRequiredQuantity(), 0);  
    %>
	      document.write('<p>');
	      document.write('<i><%=UIUtil.toJavaScript(details)%></i>');
	      document.write("</p>");      
  <%
      }
	else
	{
	      String details = RLPromotionNLS.get("RLDiscountDetailsBuyXGetAddtionalAtDiscount_catlvl").toString();
	      details = EproUtil.replaceSubstring(details, "{0}", obj.getMaximumDiscountItemQuantity(), 0);
	      details = EproUtil.replaceSubstring(details, "{1}", obj.getValue(), 0);
	      details = EproUtil.replaceSubstring(details, "{2}", obj.getRequiredQuantity(), 0);
    %>
	      document.write('<p>');
	      document.write('<i><%=UIUtil.toJavaScript(details)%></i>');
	      document.write("</p>");      
  <%
	}	
    } // end of if(obj)
   }
  } 
   else if (rlDiscountDetails.getRLPromotionType().equalsIgnoreCase("CategoryLevelBuyXGetYFree")){
    if(rlDiscountDetails.getRLPromotion() instanceof CategoryLevelBuyXGetYFree) {
      	CategoryLevelBuyXGetYFree obj = (CategoryLevelBuyXGetYFree) rlDiscountDetails.getRLPromotion();
     	Vector cgryEntries = null;
     	String skuGiftString = "";
     	String cgryString ="";
	    String cgryName ="";  
      	if (obj != null)
		{
			cgryEntries = obj.getCatgpIdentifiers();			
			String catid = obj.getDiscountProductSKU();
			if (catid != null) {
			    skuGiftString = util.getSKU(catid);
			}	
  %>       
  
  	  		document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLCategoryDetails").toString())%> ' + '<br>');
  			<%= UIUtil.toJS("categories", cgryEntries)%>
  		<%  for (int i=0; i<cgryEntries.size(); i++) {
			 cgryString = cgryEntries.elementAt(i).toString();
		  	 cgryName = util.getCategoryName(storeId, langId, cgryString);
	  %>     
	  		 document.write('<i><%=UIUtil.toJavaScript(cgryString ).toString()%></i>');
		     document.write('&nbsp;(<i><%= UIUtil.toJavaScript(cgryName ).toString()%></i>)');  
			 document.write("<br>");
		<%
		    } 
		%> 
  
      		document.write("</p>");      
  <%

			if(obj.getRequiredQuantity().equalsIgnoreCase("-1"))
			{   
  %>
		      document.write('<p>');
		      document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree1").toString())%> '+'<%=obj.getMaximumDiscountItemQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree2").toString())%> '+'<%=skuGiftString %>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree4").toString())%>.</i>');
		      document.write("</p>");      
  <%
			}
			else
			{
  %>
		      document.write('<p>');
		      document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree1").toString())%> '+'<%=obj.getMaximumDiscountItemQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree2").toString())%> '+'<%=skuGiftString %>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsBuyXGetYFree3").toString())%> '+'<%=obj.getRequiredQuantity()%>'+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("byCategory").toString())%>.</i>');
		      document.write("</p>");      
  <%
			}
		} // end of if (obj != null)
    }	
  }

  %>
}

<%-- This is the role to determin which discount level it could be --%>
<%-- leveltype : orderlevel = 0 itemlevel =1 productlevel =2 --%>
<%-- discounttype: valueDiscount =0 precentDiscount =1 valueDiscountPerItem =2 --%>
function writeRangeTable(leveltype, discounttype, values, ranges)
{
	var increValue= 1; 
	var rangeToArray = new Array();
	var rangeFromArray = new Array();
	var dValueArray = new Array();
	var classId = "list_row1";

	
	if (leveltype == 0)
	{
		var ninfo = parent.getNumericInfo("<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>");
        increValue = 1 / Math.pow(10,ninfo["minFrac"]);
	}
	
	var x = values.length-1;
	while (x >=0) 
	{
		rangeFromArray[x] = ranges[x];
		dValueArray[x]= values[x];
		x--;
	}

	var numRanges = values.length;
	if(numRanges>1)
	{
		for(var i=0; i<numRanges-1;i++)
		{
				rangeToArray[i]=eval(parseFloat(rangeFromArray[i+1]) - parseFloat(increValue)); 
		}
	}

	document.write('<table cellpadding="1" cellspacing="0" border="0" bgcolor="#6D6D7C"><tr><td>');
	document.write('<table class="list" border="0" cellpadding="0" cellspacing="0">');
	document.write("<tr class=\"list_roles\">");
	if(leveltype == 0)
	{
		document.write('<th id="t1" class="list_header">' + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("discountRangeFrom").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>'); 
	}
	else
	{
		document.write('<th id="t1" class="list_header">' + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodPromoRangeFrom").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>'); 	
	}
		

	if(leveltype == 0)
	{
		document.write("<%=rlDiscountDetails.getRLPromotion().getCurrency()%>");
	}
	else if(leveltype == 1)
	{
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("byItem").toString())%>');
	}
	else if(leveltype == 2)
	{
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("byProduct").toString())%>');
	}
	else if(leveltype == 3)
	{
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("byCategory").toString())%>');
	}

	document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
	
	if(leveltype == 0)
	{
		document.write("<th id=\"t2\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("discountRangeTo").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>'); 
	}
	else
	{
		document.write("<th id=\"t2\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("prodPromoRangeTo").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>'); 	
	}	

	if(leveltype == 0)
	{
		document.write("<%=rlDiscountDetails.getRLPromotion().getCurrency()%>");
	}
	else if(leveltype == 1)
	{
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("byItem").toString())%>');
	}
	else if(leveltype == 2)
	{
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("byProduct").toString())%>');
	}
	else if(leveltype == 3)
	{
		document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("byCategory").toString())%>');
	}


	document.write('<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");

	if (leveltype == 0)
	{
		if (discounttype ==1)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscPercentOffTotal").toString())%>' + "</th>");
		}
		else
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscAmountOffTotal").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>' + "<%=rlDiscountDetails.getRLPromotion().getCurrency()%>" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
		}
	}
	else if (leveltype == 1)
	{
		if (discounttype ==1)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscPercentOffPerItem").toString())%>' + "</th>");
		}
		else if (discounttype ==2)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscAmountOffPerItem").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>' + "<%=rlDiscountDetails.getRLPromotion().getCurrency()%>" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
		}
		else  if (discounttype ==0)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscAmtOffQualItems").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>' + "<%=rlDiscountDetails.getRLPromotion().getCurrency()%>" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
		}
	}
	else if (leveltype == 2)
	{
		if (discounttype ==1)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscPercentOffPerProduct").toString())%>' + "</th>");
		}
		else if (discounttype ==2)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscAmountOffPerProduct").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>' + "<%=rlDiscountDetails.getRLPromotion().getCurrency()%>" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
		}
		else  if (discounttype ==0)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscAmtOffQualProducts").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>' + "<%=rlDiscountDetails.getRLPromotion().getCurrency()%>" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
		}
	}
	else if (leveltype == 3)
	{
		if (discounttype ==1)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLCgryPercentOffPerProduct").toString())%>' + "</th>");
		}
		else if (discounttype ==2)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLCgryAmountOffPerProduct").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>' + "<%=rlDiscountDetails.getRLPromotion().getCurrency()%>" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
		}
		else  if (discounttype ==0)
		{
			document.write("<th id=\"t3\" class=\"list_header\">" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("RLCgryAmtOffQualProducts").toString())%>' + "  " + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("open_bracket_symbol").toString())%>' + "<%=rlDiscountDetails.getRLPromotion().getCurrency()%>" + '<%= UIUtil.toJavaScript(RLPromotionNLS.get("close_bracket_symbol").toString())%>' + "</th>");
		}
	}
	
	document.write("</tr>");



	i=0;
	while (i < numRanges) 
	{
			document.write('<tr class='+classId+'>');
			
			
			if(leveltype == 0)
			{
				document.write("<td headers=\"t1\" class=\"list_info1\"><i>" + parent.numberToCurrency(rangeFromArray[i],"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") + "</i></td>");
			}
			else
			{
				document.write("<td headers=\"t1\" class=\"list_info1\"><i>" + parent.numberToStr(rangeFromArray[i],"<%=fLanguageId%>",0) + "</i></td>");
			}

			if (rangeToArray[i] != null)
			{
				if(leveltype == 0)
				{
					document.write("<td headers=\"t2\" class=\"list_info1\"><i>" + parent.numberToCurrency(rangeToArray[i],"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") + "</i></td>");
				}
				else
				{
					document.write("<td headers=\"t2\" class=\"list_info1\"><i>" + parent.numberToStr(rangeToArray[i],"<%=fLanguageId%>",0) + "</i></td>");
				}
			}
			else
			{
				document.write("<td headers=\"t2\" class=\"list_info1\"><i><%= UIUtil.toJavaScript(RLPromotionNLS.get("andUp").toString())%></i></td>");
			
			}
			
			if (discounttype ==1)
			{
				document.write("<td headers=\"t3\" class=\"list_info1\"><i>" + parent.numberToStr(dValueArray[i],"<%=fLanguageId%>",0) + "</i></td>");
			}
			else
			{
				document.write("<td headers=\"t3\" class=\"list_info1\"><i>" + parent.numberToCurrency(dValueArray[i],"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") + "</i></td>");
			}
			
			document.write("</tr>");
			i++;
			if (classId == "list_row1")
			{
				classId = "list_row2";
			}
			else
			{
				classId = "list_row1";
			}
	}
	document.write("</td></tr></table>");
	document.write("</table>");
}

function writeFixedShipping(values, ranges, adjustmentType)
{
  var shippingcost = values;
  var minimumPurchase = ranges;
  if (shippingcost == 0) {
    document.write('<%=UIUtil.toJavaScript(RLPromotionNLS.get("freeShipping").toString())%>');
  } else {
    if (adjustmentType == 0) {
      document.write('<%=UIUtil.toJavaScript(RLPromotionNLS.get("shippingCostsPerOrder").toString())%> ' + "<i>" + parent.numberToCurrency(shippingcost,"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") + " <%=rlDiscountDetails.getRLPromotion().getCurrency()%>"+ "</i>");    
    } else if (adjustmentType == 1){
      document.write('<%=UIUtil.toJavaScript(RLPromotionNLS.get("shippingCostsAllItems").toString())%> ' + "<i>" + parent.numberToCurrency(shippingcost,"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") + " <%=rlDiscountDetails.getRLPromotion().getCurrency()%>"+ "</i>");    
    } else if (adjustmentType == 2){
      document.write('<%=UIUtil.toJavaScript(RLPromotionNLS.get("shippingCostsPerItem").toString())%> ' + "<i>" + parent.numberToCurrency(shippingcost,"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") + " <%=rlDiscountDetails.getRLPromotion().getCurrency()%>"+ "</i>");    
    }
  }
  document.write("<br>" + '<%=UIUtil.toJavaScript(RLPromotionNLS.get("minQualTitle").toString())%>'+": ");
  if (minimumPurchase == 0) {
    document.write(" <i>" + '<%=UIUtil.toJavaScript(RLPromotionNLS.get("None").toString())%>' + "</i>");
  } else {
    document.write(" <i>" + parent.numberToCurrency(minimumPurchase,"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") + " <%=rlDiscountDetails.getRLPromotion().getCurrency()%>"+"</i>");
  }

}

function writeOrderLevelGWP(values, ranges, sku)
{
  var freebieQuantity = values;
  var minimumPurchase = ranges;
  var catalogSKU = sku;

 if(minimumPurchase != 0)
 {
  document.write('<p>');
  document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsOrderLevelFreeGift1").toString())%> '+freebieQuantity+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsOrderLevelFreeGift2").toString())%> '+ catalogSKU +' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsOrderLevelFreeGift3").toString())%> '+ parent.numberToCurrency(minimumPurchase,"<%=rlDiscountDetails.getRLPromotion().getCurrency()%>","<%=fLanguageId%>") +' <%=rlDiscountDetails.getRLPromotion().getCurrency()%>.</i>');
  document.write("</p>");
 }
 else
 {
  document.write('<p>');
  document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsOrderLevelFreeGift1").toString())%> '+freebieQuantity+' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsOrderLevelFreeGift2").toString())%> '+ catalogSKU +' <%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsOrderLevelFreeGift4").toString())%>.</i>');
  document.write("</p>");
 }
}

function writePriority()
{
	var priority = <%= rlDiscountDetails.getRLPromotion().getPriority() %>;
	if( priority == 300)
	{
		document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("highest").toString())%></i>');
	}
		else if( priority == 250)
	{
		document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("high").toString())%></i>');
	}
	else if( priority == 200)
	{
		document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("moderate").toString())%></i>');
	}
	else if( priority == 150)
	{
		document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("low").toString())%></i>');
	}
	else if( priority == 100)
	{
		document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("lowest").toString())%></i>');
	}
}

function writeInCombination()
{
	var groupName = '<%= rlDiscountDetails.getRLPromotion().getGroupName() %>';
	var exclusive = <%= rlDiscountDetails.getRLPromotion().getExclusive() %>;
	document.write('<p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsInCombination").toString())%> ');	
	if(groupName == '<%= RLConstants.RLPROMOTION_PRODUCT_GROUP %>')
	{
			if(exclusive == 0)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("combineWithAnyPromotion").toString())%></i>');
			}	
			else if(exclusive == 1)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("exclusiveSelectedGroup").toString())%></i>');
			}
			else if(exclusive == 2)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("exclusiveAllGroups").toString())%></i>');
			}			
	}
	else if(groupName == '<%= RLConstants.RLPROMOTION_ORDER_GROUP %>')
	{
			if(exclusive == 0)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("combineWithAnyPromotion").toString())%></i>');
			}	
			else if(exclusive == 1)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("exclusiveSelectedGroup").toString())%></i>');
			}
			else if(exclusive == 3)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("cannotCombineWithProdPromo").toString())%></i>');
			}
	}
	else if(groupName == '<%= RLConstants.RLPROMOTION_SHIPPING_GROUP %>')
	{
			if(exclusive == 0)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("combineWithAnyPromotion").toString())%></i>');
			}	
			else if(exclusive == 1)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("exclusiveSelectedGroup").toString())%></i>');
			}
			else if(exclusive == 3)
			{
				document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("cannotCombineWithProdPromo").toString())%></i>');
			}
	}
}

function writeCouponAndPromoCode()
{
	if(<%= rlDiscountDetails.getRLPromotion().getIsCoupon() %>)
	{
		document.write('<i><p><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsIsCoupon").toString())%></i></p>');
		document.write('<%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountDetailsCouponExpires").toString())%> ');
		document.write('<i><%=rlDiscountDetails.getRLPromotion().getCouponExpirationDays()%></i>');
	}
	else if(<%= rlDiscountDetails.getRLPromotion().getCodeRequired() %>)
	{
		document.write('<i><%=UIUtil.toJavaScript(RLPromotionNLS.get("RLDiscountPromotionCode").toString())%> ');
		document.write('<i><%=UIUtil.toJavaScript(UIUtil.toHTML(rlDiscountDetails.getRLPromotion().getPromotionCode()))%></i>');
	}
}
</script>
<!-- new javascript end here -->

<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body class="content" onload="initializeState()">
<form name="detailsDialogForm" id="detailsDialogForm">

<h1><%=RLPromotionNLS.get("RLDiscountDetailsDialog_title")%></h1>
<p><%=RLPromotionNLS.get("RLDiscountDetailsNameLabel")%>
<i><%=rlDiscountDetails.getRLPromotion().getName()%></i></p>


<%
if(rlDiscountDetails.getAdminDesc() != null && !rlDiscountDetails.getAdminDesc().equals(""))
{
%>
<p><%=RLPromotionNLS.get("RLDiscountDetailsDescLabel")%>
<i><%=UIUtil.toHTML(rlDiscountDetails.getAdminDesc())%></i></p>
<%
}
%>

<%
if(rlDiscountDetails.getShopDesc() != null && !rlDiscountDetails.getShopDesc().equals(""))
{
%>
<p><%=RLPromotionNLS.get("RLDiscountDetailsShopperDescLabel")%>
<i><%=UIUtil.toHTML(rlDiscountDetails.getShopDesc())%></i></p>
<%
}
%>

<%
if(rlDiscountDetails.getShopLongDesc() != null && !rlDiscountDetails.getShopLongDesc().equals(""))
{
%>
<p><%=RLPromotionNLS.get("RLDiscountDetailsShopperLongDescLabel")%>
<i><%=UIUtil.toHTML(rlDiscountDetails.getShopLongDesc())%></i></p>
<%
}
%>
<%
if(rlDiscountDetails.getRLPromotion().getCurrency() != null)
{
%>
<p><%=RLPromotionNLS.get("RLDiscountDetailsCurrLabel")%>  
<i><%=rlDiscountDetails.getRLPromotion().getCurrency()%></i>
</p>
<%
}
%>

<p><%=RLPromotionNLS.get("RLDiscountDetailsPromotionGroup")%>  
<i><%=rlDiscountDetails.getRLPromotion().getGroupName()%></i>
</p>

<p><script language="JavaScript">
writeCouponAndPromoCode();

</script></p>

<p><%=RLPromotionNLS.get("RLDiscountDetailsRedemptionsInTotal")%> 
<%
if(rlDiscountDetails.getRLPromotion().getTotalLimit() == -1)
{
%> 
<i><%=RLPromotionNLS.get("unlimited")%></i>
<%
}
else
{
%>
<script language="JavaScript">
 document.write('<i>'+ parent.numberToStr(<%=rlDiscountDetails.getRLPromotion().getTotalLimit()%>,"<%=fLanguageId%>",0) + '</i> (<%=RLPromotionNLS.get("currentRedemption")%> <i>' + parent.numberToStr(<%=rlDiscountDetails.getActualRedemptionsForPromotion()%>,"<%=fLanguageId%>",0) + '</i>)');
 </script>   
<%
  if((rlDiscountDetails.getRLPromotion().getTotalLimit() <= rlDiscountDetails.getActualRedemptionsForPromotion()) && (rlDiscountDetails.getRLPromotion().getStatus()==0)) {
  %>
  <br/><%=RLPromotionNLS.get("maxRedemptionExceededInTotal")%>
  <%
  }
}
%>
</p>

<p><%=RLPromotionNLS.get("RLDiscountDetailsRedemptionsPerOrder")%>  
<%
if(rlDiscountDetails.getRLPromotion().getPerOrderLimit() == -1)
{
%> 
<i><%=RLPromotionNLS.get("unlimited")%></i>
<%
}
else
{
%>
<script language="JavaScript">
 document.write('<i>'+ parent.numberToStr(<%=rlDiscountDetails.getRLPromotion().getPerOrderLimit()%>,"<%=fLanguageId%>",0) + '</i>');
 </script>
<%
}
%>
</p>

<p><%=RLPromotionNLS.get("RLDiscountDetailsRedemptionsPerCustomer")%>  
<%
if(rlDiscountDetails.getRLPromotion().getPerShopperLimit() == -1)
{
%> 
<i><%=RLPromotionNLS.get("unlimited")%></i>
<%
}
else
{
%>
<script language="JavaScript">
 document.write('<i>' + parent.numberToStr(<%=rlDiscountDetails.getRLPromotion().getPerShopperLimit()%>,"<%=fLanguageId%>",0) + '</i>');
 </script>
<%
}
%>
</p>


<script language="JavaScript">
writeInCombination();

</script>

<p><%=RLPromotionNLS.get("RLDIscountDetailsPriorityLabel")%>  
<script language="JavaScript">
writePriority();

</script></p>

<%
if(!rlDiscountDetails.getRLPromotion().getIsCoupon())
{
%>

<p><%=RLPromotionNLS.get("RLDiscountDefinedShopperGroups")%>
<i><script language="JavaScript">
writeShopperGroups();

</script></i></p>

<%
}
%>

<p><%=RLPromotionNLS.get("RLDiscountDetailsSchedule")%>
<i><script language="JavaScript">
writeSchedule();

</script></i></p>

<p><%=RLPromotionNLS.get("RLDiscountDetailsDateRange")%>
<i><script language="JavaScript">
writeDate();

</script></i></p>

<p><%=RLPromotionNLS.get("RLDiscountDetailsTimeRange")%>
<i><script language="JavaScript">
writeTime();

</script></i></p>

<script language="JavaScript">
writeSpecificData();

</script>

</form>


</body>
</html>


