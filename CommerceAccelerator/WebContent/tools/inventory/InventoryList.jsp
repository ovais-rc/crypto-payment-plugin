<!--   
// BR updated 20020118 - 1335
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp. 
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.FulfillmentCenterDataBean" %>
<%@ page import="com.ibm.commerce.inventory.objects.VendorAccessBean" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="itemList" scope="request" class="com.ibm.commerce.inventory.beans.InventorySearchResultListDataBean">
</jsp:useBean>
<%!
   public void processInventoryList(InventorySearchResultDataBean[] onhandList,InventorySearchResultDataBean[] expectedList, ArrayList result){
      for (int i = 0; i<onhandList.length; i++) {
         ArrayList inventoryData = new ArrayList();
         inventoryData.add(0,onhandList[i].getCatentryPartNumber());
         inventoryData.add(1,onhandList[i].getCatentryShortDescription());
         inventoryData.add(2,onhandList[i].getQuantity());
         inventoryData.add(3,"0");
         inventoryData.add(4,onhandList[i].getItemspcId());
         result.add(i,inventoryData);
      }
      boolean find = false;
      for (int i=0; i<expectedList.length; i++) {
         find = false;
         for (int j=0; j< result.size(); j++){
            if (expectedList[i].getItemspcId().equals(((ArrayList)result.get(j)).get(4))){
               ((ArrayList)result.get(j)).add(3,expectedList[i].getQuantity());
               find = true;
               break;
            }
         }
         if ( !find ){
              ArrayList inventoryData = new ArrayList();
              inventoryData.add(0,expectedList[i].getCatentryPartNumber());
              inventoryData.add(1,expectedList[i].getCatentryShortDescription());
              inventoryData.add(2,"0");
              inventoryData.add(3,expectedList[i].getQuantity());
              inventoryData.add(4,expectedList[i].getItemspcId());
              result.add(inventoryData);
         }
     }
   }
   public void processFFCInventoryList(InventoryFFCSearchResultDataBean[] onhandList,InventoryFFCSearchResultDataBean[] expectedList, ArrayList result){
      for (int i = 0; i<onhandList.length; i++) {
         ArrayList inventoryData = new ArrayList();
         inventoryData.add(0,onhandList[i].getCatentryPartNumber());
         inventoryData.add(1,getFFCName(onhandList[i].getFulfillmentCenterId()));
         inventoryData.add(2,onhandList[i].getCatentryShortDescription());
         inventoryData.add(3,onhandList[i].getQuantity());
         inventoryData.add(4,"0");
         inventoryData.add(5,onhandList[i].getItemspcId());
         result.add(i,inventoryData);
      }
      boolean find = false;
      for (int i=0; i<expectedList.length; i++) {
         find = false;
         for (int j=0; j< result.size(); j++){
            if (expectedList[i].getItemspcId().equals(((ArrayList)result.get(j)).get(5))&&getFFCName(expectedList[i].getFulfillmentCenterId()).equals(((ArrayList)result.get(j)).get(1))){
               ((ArrayList)result.get(j)).add(4,expectedList[i].getQuantity());
               find = true;
               break;
            }
         }
         if ( !find ){
              ArrayList inventoryData = new ArrayList();
              inventoryData.add(0,expectedList[i].getCatentryPartNumber());
              inventoryData.add(1,getFFCName(expectedList[i].getFulfillmentCenterId()));
              inventoryData.add(2,expectedList[i].getCatentryShortDescription());
              inventoryData.add(3,"0");
              inventoryData.add(4,expectedList[i].getQuantity());
              inventoryData.add(5,expectedList[i].getItemspcId());
              result.add(inventoryData);
         }
     }
   }
   public void processVendorInventoryList(InventoryVendorSearchResultDataBean[] onhandList,InventoryVendorSearchResultDataBean[] expectedList, ArrayList result){
      for (int i = 0; i<onhandList.length; i++) {
         ArrayList inventoryData = new ArrayList();
         inventoryData.add(0,onhandList[i].getCatentryPartNumber());
         inventoryData.add(1,getVendorName(onhandList[i].getVendorId()));
         inventoryData.add(2,onhandList[i].getCatentryShortDescription());
         inventoryData.add(3,onhandList[i].getQuantity());
         inventoryData.add(4,"0");
         inventoryData.add(5,onhandList[i].getItemspcId());
         result.add(i,inventoryData);
      }
      boolean find = false;
      for (int i=0; i<expectedList.length; i++) {
         find = false;
         for (int j=0; j< result.size(); j++){
            if (expectedList[i].getItemspcId().equals(((ArrayList)result.get(j)).get(5))&&getVendorName(expectedList[i].getVendorId()).equals(((ArrayList)result.get(j)).get(1))){
               ((ArrayList)result.get(j)).add(4,expectedList[i].getQuantity());
               find = true;
               break;
            }
         }
         if ( !find ){
              ArrayList inventoryData = new ArrayList();
              inventoryData.add(0,expectedList[i].getCatentryPartNumber());
              inventoryData.add(getVendorName(expectedList[i].getVendorId()));
              inventoryData.add(2,expectedList[i].getCatentryShortDescription());
              inventoryData.add(3,"0");
              inventoryData.add(4,expectedList[i].getQuantity());
              inventoryData.add(5,expectedList[i].getItemspcId());
              result.add(inventoryData);
         }
     }
   }
   
   public String getFFCName(String ffcId){
      String result="";
      FulfillmentCenterDataBean ffcBean = new FulfillmentCenterDataBean();
      ffcBean.setDataBeanKeyFulfillmentCenterId(ffcId);
      try {
          ffcBean.populate();
          result = ffcBean.getName();
      }catch(Exception e){
          result = "";
      }
      return result;
   }
   public String getVendorName(String vendorId){
      String result="";
      try {
          VendorAccessBean vendorBean = new VendorAccessBean();
          vendorBean.setInitKey_vendorId(vendorId);
          result = vendorBean.getVendorName();
      }catch(Exception e){
          e.printStackTrace();
          result = "";
      }
      return result;
   }
%>
<%
   Hashtable vendorPurchaseListNLS = null;
   ItemSearchResultDataBean items[] = null; 
   int numberOfitems = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();
   String storeId = cmdContext.getStoreId().toString();

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed   );

   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString(); 
   itemList.setLanguageId(strLangId); 
   itemList.setStoreId(storeId);
   
   //result list
   InventoryFFCSearchResultDataBean[] ffcOnHandList = null;
   InventoryFFCSearchResultDataBean[] ffcExpectedList = null;
   
   InventorySearchResultDataBean[] onHandList = null;
   InventorySearchResultDataBean[] expectedList = null;
   
   InventoryVendorSearchResultDataBean[] vendorOnHandList = null;
   InventoryVendorSearchResultDataBean[] vendorExpectedList = null;

    
   String  searchForItemName  = request.getParameter("searchItemName");
   String  searchForSKU  = request.getParameter("searchSKU");
   String  groupBy = request.getParameter("groupBy");
   
   searchForItemName  = searchForItemName.trim() ;
   searchForSKU  = searchForSKU.trim() ;
   ArrayList resultList = new ArrayList();
   
   int n = searchForSKU.length() ;
   if (n < 1){
     searchForSKU = null ;
   }else if (searchForSKU == ""){
	  searchForSKU = null  ;
   }
  
   n = searchForItemName.length() ;
   if (n < 1){
     searchForItemName= null ;
   }else if (searchForItemName == ""){
     searchForItemName = null  ;
   }
  
   if (searchForItemName == null){
     if (searchForSKU != null){
       searchForSKU = searchForSKU + "%";
     } else {
       searchForSKU = "" ;
     }
     searchForItemName = "" ;
   }else {
     searchForItemName = "%" + searchForItemName + "%";
     if (searchForSKU != null){
       searchForSKU = searchForSKU + "%";
     } else{
       searchForSKU = "" ;
     }
   }

   itemList.setCatentryPartNumber(searchForSKU);
   itemList.setCatentryName(searchForItemName);
		 
   DataBeanManager.activate(itemList, request);
   
   if (groupBy.equals("none")) {
      onHandList = itemList.getOnHandInventorySearchResultList();
      expectedList = itemList.getExpectedInventorySearchResultList();
      processInventoryList(onHandList,expectedList, resultList);
   } else if (groupBy.equals("ffc")) {
      ffcOnHandList = itemList.getOnHandFFCInventorySearchResultList();
      ffcExpectedList = itemList.getExpectedFFCInventorySearchResultList();
      processFFCInventoryList(ffcOnHandList,ffcExpectedList,resultList );
   } else if (groupBy.equals("vendor")) {
      vendorOnHandList = itemList.getOnHandVendorInventorySearchResultList();
      vendorExpectedList = itemList.getExpectedVendorInventorySearchResultList();
      processVendorInventoryList(vendorOnHandList,vendorExpectedList, resultList);
   }
   numberOfitems = resultList.size();
      
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css"><SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<TITLE></TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

  function getResultsize(){
    return <%=numberOfitems%>; 
  }


  function onLoad(){
    parent.loadFrames()
    if (parent.parent.setContentFrameLoaded) {
      parent.parent.setContentFrameLoaded(true);
    }
    //getSearchCriteria();
  }

// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS=content>
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfitems;
          int totalpage = totalsize/listSize;
     	
%>

<%=comm.addControlPanel("inventory.InventoryList", totalpage, totalsize, localeUsed )%>
<FORM NAME="itemSearchResults">
				
<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("itemSearchResultTableSum")) %>
<%= comm.startDlistRowHeading() %>

<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("sku"), null, false )%>
<% if (groupBy.equals("ffc")) { %>
   <%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("fulfillmentCenter"), null, false )%>
<% } else if (groupBy.equals("vendor")) { %>
   <%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("vendor"), null, false )%>
<% } %>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("description"), null, false )%>

<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("onHandInventory"), null, false )%>

<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("expectedInventory"), null, false )%>

<%= comm.endDlistRow() %>


<%
    if (endIndex > numberOfitems){
      endIndex = numberOfitems;
    }
    for (int i=startIndex; i<endIndex ; i++){
       ArrayList inventoryData = (ArrayList)resultList.get(i);
%>

<% if (groupBy.equals("none")) { %>

<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistColumn( (String)inventoryData.get(0), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(1), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(2), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(3), "none" ) %> 

<%= comm.endDlistRow() %>
<% } else if (groupBy.equals("ffc")) { %>

<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistColumn( (String)inventoryData.get(0), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(1), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(2), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(3), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(4), "none" ) %> 

<%= comm.endDlistRow() %>

<% } else if (groupBy.equals("vendor")) { %>

<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistColumn( (String)inventoryData.get(0), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(1), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(2), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(3), "none" ) %> 

<%= comm.addDlistColumn( (String)inventoryData.get(4), "none" ) %> 

<%= comm.endDlistRow() %>

<% } %>
<%
  if(rowselect==1){
    rowselect = 2;
  }else{
    rowselect = 1;
  }
%>


<%
}
%>
<%= comm.endDlistTable() %>

<%
   if ( numberOfitems == 0 ){
%>
    <br>

    <%=vendorPurchaseListNLS.get("searchCriteriaNotMet")%>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  // -->
</SCRIPT>

</BODY>
</HTML>
