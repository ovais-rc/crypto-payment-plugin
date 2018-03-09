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
<%@ page import="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ include file="../common/common.jsp" %>

<jsp:useBean id="vendorPOList" scope="request" class="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordListDataBean">
</jsp:useBean>

<%
   Hashtable vendorPurchaseListNLS = null;
   ExpectedInventoryRecordDataBean vendorPOs[] = null; 
   int numberOfvendorPOs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed   );

   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 
   vendorPOList.setStoreentId(storeId); 

   //Integer langId = cmdContext.getLanguageId();
   //String strLangId = langId.toString(); 
   //vendorPOList.setLanguageId(strLangId); 

   DataBeanManager.activate(vendorPOList, request);
   vendorPOs = vendorPOList.getExpectedInventoryRecordList();

   if (vendorPOs != null)
   {
     numberOfvendorPOs = vendorPOs.length;
   }

   StoreAccessBean sa = cmdContext.getStore();
   String StoreType = sa.getStoreType();
   if (StoreType == null) {
     StoreType = "";
   }


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/newbutton.js"></SCRIPT>
<%= fHeader%>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">

<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
var storeType = '<%=StoreType%>';

function getResultsize()
{
 return <%=numberOfvendorPOs%>; 
}

function newVendorPO()
{
  var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=inventory.VendorWizard";
      url += "&status=" + "new";
      url += "&raId=" ;
      url += "&formattedExpectedDate=";
      
  if (top.setContent){
    top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("vendorGeneralScreenTitleNew"))%>',
                       url,
                       true);

  } else {
    parent.location.replace(url);
  }
}

function changeVendorPO(rowId){

  if (rowId == null) {
    var rowNum = parent.getChecked();
    var tokens = rowNum[0].split(",");
    var raId = tokens[0];
  } else {
    var raId = rowId;
  }
    
  var url="/webapp/wcs/tools/servlet/NotebookView?XMLFile=inventory.VendorNotebookChange";
  url += "&status=" + "change";
  url += "&raId=" + raId;
  url += "&formattedExpectedDate=";

  if (top.setContent){
      top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("vendorChangeScreenTitleChange"))%>',
                    url,
                    true);
  } else {
    parent.location.replace(url);
  }

}    

function detailListPO() 
{
  var tokens = parent.getSelected().split(",");
  var raId = tokens[0];
  var vendorID =  tokens[1]; 
          
  var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.PODetailList&cmd=PurchaseOrderDetailListView";
      url += "&raId=" + raId;
      url += "&vendorId=" + vendorID;
        
  if (top.setContent) {
    top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("poDetailList"))%>',
                        url,
                        true);
  } else {
    parent.location.replace(url);
  }
}

function closeVendorPO() 
{
  var checked = parent.getChecked();

  if (checked.length > 0) {
    //Set up the close list
    var vendorPOList = "";
    var closeList = "";
    var EID = "";
    for (var i = 0; i< checked.length; i++) {
      var tokens = checked[i].split(",");
      var raId = tokens[0];
      EID = tokens[3];
      vendorPOList += "&raId=" + raId;
      if (closeList.length > 1) {
        closeList = trim(closeList) + ", " + EID;
      } else {
        closeList = EID;
      }
    }
    if (checked.length > 1) {
      var confirmClose = "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("closeConfirms")) %>";
    } else {
      var confirmClose = "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("closeConfirm")) %>";
    }


    if (parent.confirmDialog(confirmClose)) {//  +
          //"\n"+ "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("externalID2")) %>" + closeList))  {
      //close the vendor POs
      var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.VendorPurchase&cmd=VendorPurchaseView"%>";
      var url = "/webapp/wcs/tools/servlet/ExpectedInventoryRecordClose?"
                    + "size=" + checked.length
                    + vendorPOList
                    + "&URL=" + redirectURL;
      //alertDialog ("url=" + url);
      if (top.setContent) {
        top.showContent(url);
        top.refreshBCT();
      } else {
        parent.location.replace(url);
      }
    }
  }
} 

function validateChecked() 
{

}

function deleteVendorPO() 
{
  var qtyReceived = null;
 
  var checked = parent.getChecked();
  var size = checked.length;

  if (checked.length > 0) {
    // Set up the delete list
    var vendorPOList = "";
    var invalidEID = "";
    var validEID = "";
    var EID = "";
    var x = -1;
    for(var i=0; i< checked.length; i++){
      var tokens = checked[i].split(",");
 
      var raId = tokens[0];
      qtyReceived = tokens[2];
      EID = tokens[3];
      //alertDialog(qtyReceived);
      if (qtyReceived == "no")  {
        vendorPOList += "&raId=" + raId;
        if (validEID.length > 1) {
          validEID = trim(validEID) + ", " + EID;
        } else {
          validEID = EID;
        }
      } else  {
        size = size - 1;
        if (invalidEID.length > 1) {
          invalidEID = trim(invalidEID) + ", " + EID;
        } else {
          invalidEID = EID;
        }
      }
    }
    if (invalidEID.length > 0) {
      alertDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("cannotDelete1")) %>");// + 
      //"\n"+ "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("externalID2")) %>" + invalidEID);
    }
    //alertDialog(vendorPOList);
    if (size > 1) {
      var confirmDelete = "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("deleteRows")) %>";
    } else {
      var confirmDelete = "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("deleteRow")) %>";
    }
    if (size > 0) {
      if (parent.confirmDialog(confirmDelete)){// +
        //  "\n"+ "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("externalID2")) %>" + validEID)) {
        // delete the vendor POs
        var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.VendorPurchase&cmd=VendorPurchaseView"%>";
 
        var url = "/webapp/wcs/tools/servlet/ExpectedInventoryRecordDelete?"
                      + "size=" + size
                      + vendorPOList
                      + "&URL=" + redirectURL;
        //alertDialog ("url=" + url);
        if (top.setContent) {
          top.showContent(url);
          top.refreshBCT();
        }else {
          parent.location.replace(url);
        }
      }
    }
  }
} 

function openReports()
{
 if (storeType == 'B2C' || storeType == 'RHS' || storeType == 'MHS') {
   var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2C_ExpectedInventoryRecordReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.exptdInvRptscontextList";
 } else {
   var url="/webapp/wcs/tools/servlet/ShowContextList?context=B2B_ExpectedInventoryRecordReports&contextConfigXML=reporting.OperationalReportsContext&ActionXMLFile=bi.exptdInvRptscontextList";
 }

  if (top.setContent){
    top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("reportsButton"))%>',
                            url,
                            true);
  }else{
    parent.location.replace(url);
  }
}


  
function onLoad()
{
  parent.loadFrames()
}

function getRefNum() 
{
  //alertDialog(getRef);   
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
          int totalsize = numberOfvendorPOs;
          int totalpage = totalsize/listSize;
	
%>



<%=comm.addControlPanel("inventory.VendorPurchase", totalpage, totalsize, localeUsed )%>

<FORM NAME="vendorPOForm">

<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("vendorPurchaseTableSum")) %>

<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>

<%-- //BR 13MAR2001 These next few rows get the header name from the vendorPurchaseNLS file --%>
<%--//"VendorName should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("vendorPurchaseVendorName"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("externalID"), null, false  )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("vendorPurchaseOrderDateColumn"), null, false )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all the member groups -->
<%
    ExpectedInventoryRecordDataBean vendorPO;
  
    if (endIndex > numberOfvendorPOs){
      endIndex = numberOfvendorPOs;
     }
    for (int i=startIndex; i<endIndex ; i++){
      vendorPO = vendorPOs[i];
      String purchaseOrderNumber = vendorPO.getVendorId();
      if (purchaseOrderNumber == null){
        purchaseOrderNumber = "";
      }
      String orderDate = vendorPO.getOrderDate();
      String formattedOrderDate = null;
      if (orderDate == null){
         formattedOrderDate = "";
      }else{
         Timestamp tmp_orderDate = Timestamp.valueOf(orderDate);
         formattedOrderDate = TimestampHelper.getDateFromTimestamp(tmp_orderDate, localeUsed );
      }
      
      String qtyReceived = "";
      if (vendorPO.isQtyReceived()) {
        qtyReceived = "no";
      } else {
        qtyReceived = "yes";
      }
      
      String externalId = vendorPO.getExternalId();
      if (externalId == null){
        externalId = "";
      }
%>
<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(vendorPO.getExpectedInventoryRecordId() + "," + vendorPO.getVendorId() + "," + qtyReceived + "," + "+vendorPO.getExternalId()+", "none" ) %>

<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getVendorName()), "javascript:changeVendorPO('"+vendorPO.getExpectedInventoryRecordId()+"');" ) %> 
<%= comm.addDlistColumn( UIUtil.toHTML(externalId) , "none" ) %> 

<%= comm.addDlistColumn( formattedOrderDate, "none" ) %> 

<%= comm.endDlistRow() %>

<%

  if(rowselect==1) {
    rowselect = 2;
  } else {
    rowselect = 1;
  }
   
%>

<%
}
%>
<%= comm.endDlistTable() %>

<%
   if ( numberOfvendorPOs == 0 ){
%>
<SCRIPT>
   document.writeln('<P>');
   document.writeln(' <%= UIUtil.toJavaScript(vendorPurchaseListNLS.get("vendorPurchaseNoRows")) %> ' );
</SCRIPT>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">

  parent.afterLoads();
  parent.setResultssize(getResultsize());

</SCRIPT>

</BODY>
</HTML>
