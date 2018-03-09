<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.CatalogEntryDataBean" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.InventoryDataBean" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.InventoryAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>
<%@ page import="com.ibm.commerce.tools.experimentation.search.CatalogEntrySearchListDataBean" %>
<%@ page import="com.ibm.commerce.tools.experimentation.ExperimentConstants" %>
<%@ page import="com.ibm.commerce.inventory.beans.ItemSearchResultDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="java.rmi.RemoteException" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="javax.naming.NamingException" %>
<%-- added by wangful for inventory sharing --%>
<%@ page import="com.ibm.commerce.common.helpers.StoreUtil" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.ShippingArrangementAccessBean" %>
<%-- wangful@cn.ibm.com end --%>

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="itemList" scope="request" class="com.ibm.commerce.inventory.beans.ItemSearchResultListDataBean">
</jsp:useBean>
<jsp:useBean id="catEntryDesc" scope="request" class="com.ibm.commerce.catalog.beans.CatalogEntryDescriptionDataBean">
</jsp:useBean>
<%
   Hashtable vendorPurchaseListNLS = null;
   ItemSearchResultDataBean items[] = null; 
   CatalogEntryDescriptionDataBean catEntryDescBean[] = null;
    CatalogEntryDataBean[] catEntryBeans = null;
   int numberOfitems = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed   );

   Integer store_id = cmdContext.getStoreId();
   StoreAccessBean storeAB = cmdContext.getStore();
   Long memeber = storeAB.getMemberIdInEntityType();
   String storeId = store_id.toString(); 		
   String ffcId = UIUtil.getFulfillmentCenterId(request);
   ffcId = UIUtil.toHTML(ffcId);
   String  searchForItemName  = request.getParameter("searchItemName");
   String  searchForSKU  = request.getParameter("searchSKU");
   Vector searchResultId = new Vector();
   Vector searchResultName = new Vector();
   searchForItemName  = searchForItemName.trim() ;
   searchForSKU  = searchForSKU.trim() ;
   
   String qtty = "0";
   String uom = "C62";
   String updateFlag = "0";
   
   
  
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
  
   

   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString();   
    String flags = "update";
   int inventorySystem = 0;
   
   inventorySystem = storeAB.getInventorySystem().intValue();
   
   //added by wangful for non-ATP inventory sharing
   if (inventorySystem == -2) {
           Integer[] relatedStores = StoreUtil.getStorePath(store_id, ECConstants.EC_STRELTYP_INVENTORY);
           ShippingArrangementAccessBean abFinder = new ShippingArrangementAccessBean();
           
       	   if (relatedStores != null && relatedStores.length > 0) {
       	   		for (int tmpIndex = 0; tmpIndex < relatedStores.length; tmpIndex ++) {
       	   		    if (relatedStores[tmpIndex].equals(store_id)) {
       	   		      continue;
       	   		    }
       	   			try{
       	   					Enumeration results = abFinder.findByStoreAndFulfillmentCenter(relatedStores[tmpIndex], new Integer(ffcId));
       	   					if (results.hasMoreElements()) {
       	   						updateFlag = "1";
	 							break;
       	   					}
  		    
   					}catch (Exception e)
        			{
          			 		//flags = "create?";
          			 		//inventory = null;
         			}
       	   		}
       	   }
   }
            	
   if(inventorySystem==-1){
  
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
   	itemList.setStoreentId(storeId); 

   		 
   	itemList.setLanguageId(strLangId); 
        itemList.setPartNumber(searchForSKU);
        itemList.setShortDescription(searchForItemName);
		 
        DataBeanManager.activate(itemList, request);
        items = itemList.getItemSearchResultList();

   		if (items != null){
		     numberOfitems = items.length;
		   }
   }else{
   	
   try {
                                        String maxNumberOfResultForProductSearch = "10";
   					CatalogEntrySearchListDataBean productSearchDB = new CatalogEntrySearchListDataBean();
   					if(searchForSKU!=null && !searchForSKU.equals("")){
						productSearchDB.setPartNumber(searchForSKU);
						productSearchDB.setPartNumberType(ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE);
					}
					if(searchForItemName!=null && !searchForItemName.equals("")){
						productSearchDB.setCatentryName(searchForItemName);
						productSearchDB.setCatentryNameType(ExperimentConstants.SEARCH_TYPE_LIKE_IGNORE_CASE);
					}
					productSearchDB.setMarkForDelete("0");
					productSearchDB.setStoreId(storeId);
					productSearchDB.setPublished("1");
					productSearchDB.setLanguageId(strLangId);
					productSearchDB.setIndexEnd("500");
					DataBeanManager.activate(productSearchDB, request);
					if (productSearchDB.getCatalogEntryList() != null && productSearchDB.getCatalogEntryList().length > 0) {
						for (int i=0; i<productSearchDB.getCatalogEntryList().length; i++) {
						    String type = null;
						    CatalogEntryAccessBean abCatentry = new CatalogEntryAccessBean();
						    abCatentry.setInitKey_catalogEntryReferenceNumber(productSearchDB.getCatalogEntryList()[i].getId().toString());
						    type = abCatentry.getType().trim();
						    if (type.equals("ProductBean") || type.equals("BundleBean")) {
						        continue;
						    }
							searchResultId.addElement(productSearchDB.getCatalogEntryList()[i].getId().toString());
							String catEntryName = productSearchDB.getCatalogEntryList()[i].getName();
							if (catEntryName == null) {
								catEntryName = "";
							}
							searchResultName.addElement(catEntryName.trim() 
								+ " (" + productSearchDB.getCatalogEntryList()[i].getPartNumber().trim() + ")");
						}
						numberOfitems = searchResultId.size();
					}
				
   
   Vector vecCatEntryDesc = new Vector(numberOfitems);
   Vector vecCatEntry = new Vector(numberOfitems);
			 for(int i=0;i<searchResultId.size();i++){
			                 String iCatEntry_id = (String)searchResultId.elementAt(i);
			 		 CatalogEntryDescriptionDataBean catDesc = new CatalogEntryDescriptionDataBean();
					 CatalogEntryDataBean catEntryBean = new CatalogEntryDataBean();
		
			 		catDesc.setDataBeanKeyCatalogEntryReferenceNumber(iCatEntry_id);
			 		catDesc.setDataBeanKeyLanguage_id(strLangId);
			 		catDesc.populate();
			 		vecCatEntryDesc.addElement(catDesc);
			 		
			 		catEntryBean.setCatalogEntryID(iCatEntry_id);
			 		catEntryBean.populate();
			 		vecCatEntry.addElement(catEntryBean);
			 }		
			 	//}
			 catEntryDescBean = new CatalogEntryDescriptionDataBean[vecCatEntryDesc.size()];
			 catEntryBeans = new CatalogEntryDataBean[vecCatEntryDesc.size()];
			 
			 vecCatEntryDesc.toArray(catEntryDescBean);
			 vecCatEntry.toArray(catEntryBeans);
			 numberOfitems = vecCatEntryDesc.size();
			 
			 
		 }catch (RemoteException e)
         {
           System.out.println("RemoteException thrown");
         }
         catch (NamingException e)
         {
           System.out.println("NamingException thrown");         
         }
         catch (javax.persistence.NoResultException e)
         {
           System.out.println("NoResultException thrown");
         }
        
          }
%>

<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css"><SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<TITLE></TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  var fulfillmentID;
  fulfillmentID = "<%= ffcId%>";
  
  function adhoc(){
  
	  if (itemSearchResults.updateFlag.value == "1") {
	      alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("adhocWarning"))%>');
	      return;
	   }  
  
    var urlParams = new Object();
    var url;
    if (fulfillmentID == "null"){
      alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("noFFCAdhoc"))%>');
    }else{
      <%
      if(inventorySystem==-1){
 
      %>
       url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.AdHocReceiveInventoryDialog";
      var itemSpcId = getCheckedValue("itemSpcId"); 
      var unit =  getCheckedValue("unitOfMeasure") ;
      urlParams.itemSpcId=itemSpcId;
      urlParams.uOM=unit;
      
      <%
      }else{
     %>
      
      var catEntryId = getCheckedValue("catEntryId"); 
      var unit =  "" ;
      urlParams.catEntryId=catEntryId;
      urlParams.uOM=unit;
      var flags = getCheckedValue("flags");
     if(flags == "create"){
      	url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.InventoryCreateDialog";
      	
      }else if(flags =="update"){
        url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.InventoryAdjustmentNonATPDialog";
      }
     <%
      }
     %>
      if (top.setContent){
        top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("adhocInventory"))%>',
        url,
        true, urlParams);
      }else{
        parent.location.replace(url);
      }
    }
  }

  function adjust(){
  
   if (itemSearchResults.updateFlag.value == "1") {
      alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("adjustWarning"))%>');
      return;
   }

    if (fulfillmentID == "null"){
      alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("noFFCAdjustQ"))%>');
    }else{
      var url;
      var urlParams = new Object();
       <%
      if(inventorySystem==-1){
      
      %>
      url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.InventoryAdjustmentDialog" ;
      var itemSpcId = getCheckedValue("itemSpcId"); 
      var unit =  getCheckedValue("unitOfMeasure") ;
      urlParams.itemSpcId=itemSpcId;
      urlParams.uOM=unit;
      <% }else{
       %>
      
      var itemSpcId = getCheckedValue("catEntryId"); 
      var unit =  "" ;
      urlParams.catEntryId=itemSpcId;
      urlParams.uOM=unit;
      var flags = getCheckedValue("flags");
    if(flags == "create"){
      	url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.InventoryCreateDialog";
      	
      }else if(flags =="update"){
        url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.InventoryAdjustmentNonATPDialog";
      }
      <% }
       %> 
      if (top.setContent){
        parent.location.replace(url);
        top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("inventoryAdjustmentTitle"))%>',
                       url,
                       true, urlParams);
      }else{
        parent.location.replace(url);
      }
    }                 
  }

  function getResultsize(){
	    return <%=numberOfitems%>; 
  }

  function passToDetail(){
    var continueToDetail = "true";
    var rowNum = parent.getChecked();
    if(rowNum == ""){
      alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("noneSelected"))%>');
      continueToDetail = "false";
    }
    if (rowNum != ""){
      var rowString = rowNum.toString();
      for (i = 0 ; i <=rowString.length-1 ; i++){
        var letter = rowString.charAt(i);
        if (letter == ','){
          alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("tooManySelected"))%>');
          continueToDetail = "false";
        }
      }
      if (continueToDetail == "true" ){
        var name = getCheckedValue(rowNum) ;
        var searchResult = new Object();
        searchResult.itemspc_id = rowNum;
        searchResult.shortDescription = name;
        parent.parent.put("itemSearchData", searchResult);
        var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.VendorDetailDialog"
        top.saveModel(parent.parent.model);
        parent.parent.location.replace(url);
      }
    } 
  }

  function onLoad(){
 
    parent.loadFrames();
    if (parent.parent.setContentFrameLoaded) {
      parent.parent.setContentFrameLoaded(true);
    }
   
  }
  

  function getCheckedValue(value){
    var checkValues = parent.getChecked();
  
    var valueArray = checkValues[0].split(",");
    var itemSpc  = valueArray[0];
    var unitOfMeasure = valueArray[1];
    var shortDescription =  valueArray[2];

    if (value == "itemSpcId"){
      return valueArray[0];   
    }else if ( value == "unitOfMeasure" ){
      return unitOfMeasure ;    
    }else if (value == "shortDesc"){
      return shortDescription ;      
    }else if(value == "catEntryId"){
      return valueArray[0];
    }else if(value == "flags"){
      return valueArray[1];
    }
  }
// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad();" CLASS=content>
<%@include file="../common/NumberFormat.jsp" %>
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfitems;
          int totalpage = totalsize/listSize;
     	
%>

<%=comm.addControlPanel("inventory.ProductLookupList", totalpage, totalsize, localeUsed )%>
<FORM NAME="itemSearchResults">
				
<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("itemSearchResultTableSum")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>

<%-- //BR 13MAR2001 These next few rows get the header name from the vendorPurchaseNLS file --%>
<%--//" the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("sku"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("itemName"), null, false  )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("description"), null, false )%>

<% if(inventorySystem == -2) { %>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("quantity"), null, false) %>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("uom"), null, false) %>
<% } %>

<%= comm.endDlistRow() %>

<!-- Need to have a for loop to look for all the member groups -->
<%
if(inventorySystem==-1){
    ItemSearchResultDataBean vendorPO;
    if (endIndex > numberOfitems){
      endIndex = numberOfitems;
    }
    for (int i=startIndex; i<endIndex ; i++){
      vendorPO = items[i];
      String partnumber = vendorPO.getPartNumber();
      if (partnumber == null){
        partnumber = "";
      }
	
%>

<%=  comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(vendorPO.getItemSpcId() + "," +  vendorPO.getQtyUnitDescription()  + "," + vendorPO.getShortDescription(),  "none" ) %>
<%= comm.addDlistColumn( vendorPO.getPartNumber(), "none" ) %> 

<%= comm.addDlistColumn( vendorPO.getName(), "none" ) %> 

<%= comm.addDlistColumn( vendorPO.getShortDescription(), "none" ) %> 
<%= comm.endDlistRow() %>

<%
  if(rowselect==1){
    rowselect = 2;
  }else{
    rowselect = 1;
  }
%>

<%
}
}else{

    CatalogEntryDescriptionDataBean catDescAB;
    CatalogEntryDataBean catEntryDataBean;
    if (endIndex > numberOfitems){
      endIndex = numberOfitems;
    }
    
    InventoryAccessBean inventory = new InventoryAccessBean();
    for (int i=startIndex; i<endIndex ; i++){
      flags = "update";
      qtty = "0";
      uom = "C62";
      
      catDescAB = catEntryDescBean[i];
      catEntryDataBean = catEntryBeans[i];
  		try{
  		    inventory = inventory.findByCatalogEntryAndFulfillmentCenterAndStore(new Long(catEntryDataBean.getCatalogEntryID()),new Integer(ffcId),new Integer(storeId));
  		    //qttys[i] = inventory.getQuantity();
  		    //uoms[i] = inventory.getQuantityMeasure();
  		    qtty = inventory.getQuantity();
  		    uom = inventory.getQuantityMeasure();
   			
   		}catch (Exception e)
        {
           flags = "create";
         }
       if(inventory==null){
       	   flags = "create";
       }
       
       //added by wangful for inventory sharing
       if (flags.equals("create") && updateFlag.equals("1")) {
       	   Integer[] relatedStores = StoreUtil.getStorePath(store_id, ECConstants.EC_STRELTYP_INVENTORY);
       	   if (relatedStores != null && relatedStores.length > 0) {
       	   		for (int tmpIndex = 0; tmpIndex < relatedStores.length; tmpIndex ++) {
       	   			try{
  		    				inventory = inventory.findByCatalogEntryAndFulfillmentCenterAndStore(new Long(catEntryDataBean.getCatalogEntryID()),new Integer(ffcId),relatedStores[tmpIndex]);
  		    				qtty = inventory.getQuantity();
  		    				uom = inventory.getQuantityMeasure();
  		    				flags = "update";
	 						break;
   					}catch (Exception e)
        			{
         			}
       	   		}
       	   }
       	   
       }
     
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(catEntryDataBean.getCatalogEntryID()+ "," +  flags  + "," + catDescAB.getShortDescription(),  "none" ) %>
<%= comm.addDlistColumn( catEntryDataBean.getPartNumber(), "none" ) %> 
<%= comm.addDlistColumn( catDescAB.getName(), "none" ) %> 

<%= comm.addDlistColumn( catDescAB.getShortDescription(), "none" ) %> 

<% if(inventorySystem == -2) { %>
<script>
var qtty = numberToStr("<%=qtty%>","<%=langId%>", null); 
addDlistColumn(qtty, 'none', 'none');
</script>

<%=comm.addDlistColumn(uom, "none") %>

<%} %>

<%= comm.endDlistRow() %>

<%
  if(rowselect==1){
    rowselect = 2;
  }else{
    rowselect = 1;
  }
%>

<%
}
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

<input type="hidden" value="<%=updateFlag %>" name="updateFlag">

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  parent.setResultssize(getResultsize());
  // -->
</SCRIPT>

</BODY>
</HTML>
