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
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.ItemSearchResultDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="itemList" scope="request" class="com.ibm.commerce.inventory.beans.ItemSearchResultListDataBean">
</jsp:useBean>

<%
   Hashtable vendorPurchaseListNLS = null;
   ItemSearchResultDataBean items[] = null; 
   int numberOfitems = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed   );

   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 
   itemList.setStoreentId(storeId); 

   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString(); 
   itemList.setLanguageId(strLangId); 


   String  searchForItemName  = request.getParameter("searchItemName");
   String  searchForSKU  = request.getParameter("searchSKU");

   itemList.setPartNumber(searchForSKU);
   itemList.setShortDescription(searchForItemName);
		 
   DataBeanManager.activate(itemList, request);
   items = itemList.getItemSearchResultList();

   if (items != null){
     numberOfitems = items.length;
   }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

//var savedName;


function getResultsize(){
  return <%=numberOfitems%>; 
}

function passToDetail(){
  var continueToDetail = "true";
  var checked = parent.getChecked();
  var size = checked.length;
  //alertDialog(size);
  if ((size == "") || (size == 0)){
    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("noneSelected"))%>');
    continueToDetail = "false";
  }
  if (size > 1 ) {
    alertDialog('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("tooManySelected"))%>');
    continueToDetail = "false";
  } else {
    if (continueToDetail == "true" ){
	 //alertDialog(checked);
	 var tokens = checked[0].split(",");
         var searchResult = new Object();
         searchResult.itemspc_id = tokens[0];
         searchResult.sku = tokens[1];
         searchResult.shortDescription = tokens[2];
         searchResult.shortDescription = searchResult.sku + ' ' + searchResult.shortDescription
         searchResult.uom = tokens[3];	
         //alertDialog(tokens[3])
		
         parent.parent.put("itemSearchData", searchResult);
	 top.saveModel(parent.parent.model);
	 
         var status = top.getData("current");
         if (status == "change") {
           var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.VendorDetailDialogChange";
           url += "&status2=" + "changeAdd";
           url += "&status=" + status;
         } else {
           var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.VendorDetailDialog";
           url += "&status2=" + "newAdd";
           url += "&status=" + status;
         }
           //alertDialog(url);
           //top.saveModel(parent.parent.model);
           parent.parent.location.replace(url);
    }
  } 
}

function onLoad(){
  parent.loadFrames()
  if (parent.parent.setContentFrameLoaded) {
    parent.parent.setContentFrameLoaded(true);
  }
  //getSearchCriteria();
}

function saveDescription(){
  //this is a dummy function, may need in future
}

function getCheckedValue(value){
  for (var i=0; i<document.itemSearchResults.elements.length; i++){
    var e = document.itemSearchResults.elements[i];
    if (e.type == 'checkbox' && e.name == value){
      return e.value;
    }
  }
}
// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">
<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfitems;
          int totalpage = totalsize/listSize;
			 String tester = "1";
	
	
	
%>

<%=comm.addControlPanel("inventory.VendorPurchase", totalpage, totalsize, localeUsed )%>
<SCRIPT LANGUAGE="JavaScript">
  document.writeln('<P>');
  document.writeln('<%= UIUtil.toJavaScript(vendorPurchaseListNLS.get("itemSearchDirections")) %>');
  document.writeln('</P>');
</SCRIPT>

<FORM NAME="itemSearchResults">

				
<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("itemSearchResultTableSum")) %>

<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>

<%-- //BR 13MAR2001 These next few rows get the header name from the vendorPurchaseNLS file --%>
<%--//"VendorName should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("sku"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("itemName"), null, false  )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("description"), null, false )%>

<%= comm.endDlistRow() %>

<!-- Need to have a for loop to look for all the member groups -->
<%
  ItemSearchResultDataBean vendorPO;
  
  if (endIndex > numberOfitems){
    endIndex = numberOfitems;
  }
  for (int i=0; i < numberOfitems ; i++){
    vendorPO = items[i];
		  
    String partnumber = vendorPO.getPartNumber();
    if (partnumber == null){
      partnumber = "";
    }
    String shortDescription = vendorPO.getShortDescription();
    if (shortDescription == null){
      shortDescription = "";
    }
    
    
    String itemanme=vendorPO.getName();
    if(itemanme==null)
    {
	    itemanme="";
    }
    
    
    String unitOfMeasure = vendorPO.getQtyUnitDescription() ;//vendorPO.getShortDescription();
    if (unitOfMeasure == null){
      unitOfMeasure = "";
    }
 
    String longDescription = vendorPO.getLongDescription();
    if (longDescription == null){
      longDescription = "";
    }
    //String a = "parent.setChecked()\" value=\"" + vendorPO.getShortDescription() ;
%>

    <%=  comm.startDlistRow(rowselect) %>

    <%= comm.addDlistCheck(vendorPO.getItemSpcId() + "," + partnumber + "," + shortDescription + "," + unitOfMeasure, "none" ) %>

    <%= comm.addDlistColumn( UIUtil.toHTML(partnumber), "none" ) %> 

    <%= comm.addDlistColumn( UIUtil.toHTML(itemanme), "none" ) %> 

    <%= comm.addDlistColumn( UIUtil.toHTML(shortDescription), "none" ) %> 

    <%= comm.endDlistRow() %>

<%
    if(rowselect==1) {
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
<SCRIPT LANGUAGE="JavaScript">
  document.writeln('<P>');
  document.writeln('<%=UIUtil.toJavaScript(vendorPurchaseListNLS.get("noItems"))%>');
</SCRIPT>
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
