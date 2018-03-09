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
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ include file="../common/common.jsp" %>
<%@ page import="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordDetailDataBean" %>

<%@ page import="java.sql.*" %>


<jsp:useBean id="vendorDetailList" scope="request" class="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordDetailListDataBean">
</jsp:useBean>


<%
   Hashtable vendorPurchaseListNLS = null;

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();
   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 

   //obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed  );
   
          
   String status = request.getParameter("status");

   
   int numberOfvendorPOs = 0; 
   ExpectedInventoryRecordDetailDataBean vendorPOs[] = null; 
   Integer langId = null;
   String strLangId = null;
   String strRaId = null;
   String status_O = "O";

   
   if ((status != null) && (status.equalsIgnoreCase("change")))  {
     langId = cmdContext.getLanguageId();
     strLangId = langId.toString(); 
     vendorDetailList.setLanguageId(strLangId);
   
     strRaId = request.getParameter("raId"); 
     vendorDetailList.setRaId(strRaId);
   
     //VendorPODetailDataBean vendorPOs[] = null; 
        
     DataBeanManager.activate(vendorDetailList, request);
     vendorPOs = vendorDetailList.getExpectedInventoryRecordDetailList();
     
     if (vendorPOs != null){
       numberOfvendorPOs = vendorPOs.length;
     }
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">

<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
//Declare variables to be used throughout the entire page
var numRows = 0 ;
var vendorDetailList;
var tempItemName = '';
var newlyRemovedDetailList = new Array();


var removedSize = 0;


//if (parent.parent.get("status") != "changing") {
  var status = "<%=UIUtil.toJavaScript(status)%>";
  //alert(status);
//}


if ((status == "change") && (parent.parent.get("vendorDetailList") == null)) {
  
  var vendorDetailList = new Array()
  <% 
  for (int i = 0; i < numberOfvendorPOs ; i++){
    out.println("vendorDetailList[" + i + "] = new Object()");
    //vendorDetailList[i].ffmIndex = document.dialog1.ffmId.value;
    
    String formattedName = vendorPOs[i].getDisplayName();
    formattedName = UIUtil.toHTML(UIUtil.toJavaScript(formattedName));
    out.println("vendorDetailList[" + i + "].ffmName = '" +  formattedName + "'");
    
    out.println("vendorDetailList[" + i + "].ffmcenterId = " + vendorPOs[i].getFfmCenterId());
     
    out.println("vendorDetailList[" + i + "].itemName = '" +  vendorPOs[i].getPartNumber() + " " + vendorPOs[i].getShortDescription() + "'");
    out.println("vendorDetailList[" + i + "].itemspcId = " +  vendorPOs[i].getItemSpcId());
    out.println("vendorDetailList[" + i + "].expectedDate = '" +  vendorPOs[i].getExpectedDate() + "'" );
    
    String expectedDate = vendorPOs[i].getExpectedDate();
    Timestamp t = Timestamp.valueOf(expectedDate);
    String expectedYear = TimestampHelper.getYearFromTimestamp(t);
    String expectedDay = TimestampHelper.getDayFromTimestamp(t);
    String expectedMonth = TimestampHelper.getMonthFromTimestamp(t);
    
    
    String formattedExpectedDate = TimestampHelper.getDateFromTimestamp(t, localeUsed );
    
    out.println("vendorDetailList[" + i + "].formattedExpectedDate = '" +  formattedExpectedDate + "'" );
    out.println("vendorDetailList[" + i + "].expectedYear = '" +  expectedYear + "'" );
    out.println("vendorDetailList[" + i + "].expectedMonth ='" +  expectedMonth + "'" );
    out.println("vendorDetailList[" + i + "].expectedDay = '" +  expectedDay + "'" );
    
    String formattedComment = vendorPOs[i].getRaDetailComment();
    formattedComment = UIUtil.toJavaScript(formattedComment); 		
    
    out.println("vendorDetailList[" + i + "].raDetailComment = '" + formattedComment + "'" );
    out.println("vendorDetailList[" + i + "].qtyOrdered = " +  vendorPOs[i].getQtyOrdered() );
    
    out.println("vendorDetailList[" + i + "].raDetailId = " +  vendorPOs[i].getRaDetailId() );
    
    out.println("vendorDetailList[" + i + "].status = '" + status_O + "'");
    
    out.println("vendorDetailList[" + i + "].sku = '" + vendorPOs[i].getPartNumber()+ "'" );
    
    out.println("vendorDetailList[" + i + "].uom = '" + vendorPOs[i].getQtyDescription()+ "'" );
    
    out.println("vendorDetailList[" + i + "].qtyReceived = " +  vendorPOs[i].getQtyReceived() );
    
    //out.println("parent.parent.put('vendorDetailList', vendorDetailList)");
  }
  %>
  
  parent.parent.put("vendorDetailList", vendorDetailList);
  
}

function resetControl()
{
   var totalitem = vendorDetailList.length;
   var list = <%=Integer.parseInt(request.getParameter("listsize"))%>;
   var real_pages = totalitem/list;
   var remainder = totalitem%list ;

   var pages = (remainder < totalitem/2 ) ? Math.round(real_pages) + 1 : Math.round(real_pages) ;
   if(document.all){
     document.all("numofitem").innerHTML=totalitem;
     document.all("totalpage").innerHTML=pages;
   }

}

function getResultsize()
{
  return numRows;
}


function newEntry()
{ 
   //alert(status);
   
   parent.parent.put("validateVendorDetailList", vendorDetailList);
   top.saveData('<%=UIUtil.toJavaScript(status)%>',"current");
   if (status == "change"){
     var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.AddItemSearchDialog";
     //var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.VendorDetailDialogChange";
     url += "&status2=" + "changeAdd";
     url += "&status=" + status;
     
   }else{ 
     var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.AddItemSearchDialog";
     //var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.VendorDetailDialog";
     url += "&status2=" + "newAdd";
     url += "&status=" + status;
   }
   top.saveModel(parent.parent.model);
   //alert(url);
   parent.parent.location.replace(url);
}

function changeEntry()
{

  parent.parent.put("validateVendorDetailList", vendorDetailList);

  var rowNum = parent.getChecked();
  
  if (vendorDetailList[rowNum].qtyReceived > 0) {
    alertDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("cannotChange")) %>" );
  } else {
    if (rowNum != null){
      var changeRow = new Object();
      changeRow = vendorDetailList[rowNum];
      parent.parent.put("changeRow", changeRow);
      if (status == "change"){
        var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.VendorDetailDialogChange";
        url += "&status2=" + "changeChange";
        url += "&status=" + status;
      }else{
        var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.VendorDetailDialog";
        url += "&status2=" + "newChange";
        url += "&status=" + status;
      }
      top.saveModel(parent.parent.model);
      parent.parent.location.replace(url);
    }
  }
}

function deleteEntry()
{
  var cannotRemoveList = vendorDetailList;
  var tempCannotRemoveList;
  var checkedEntries = parent.getChecked();

  if (cannotRemoveList[checkedEntries].qtyReceived > 0) {
    alertDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("cannotRemove")) %>" );
    checkedEntries = 0;
      
  }
  
  if (checkedEntries.length > 0) {	
   
    if (confirmDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("removeRows")) %>")) {
 
 	removedSize = parent.parent.get("removedSize");
 
        //alertDialog("removedSize=" + parent.parent.get("removedSize"));
	  
        newlyRemovedDetailList = parent.parent.get("removedRaItem");
        if (newlyRemovedDetailList == null) {
          newlyRemovedDetailList = new Array();
        }
        
        var thisAssignedList = vendorDetailList;
        if (thisAssignedList.length > 0) {
          var newAssignedList = new Array();
          // loop through all the entries...
          // if a choice is not marked for deletion, store it in the new array, 
          // otherwise skip.
          for (var i = 0; i < thisAssignedList.length; i++) {
            var doDelete = false;
              for (var j = 0; j < checkedEntries.length; j++) {
                if (checkedEntries[j] == i) {
                  // the entry checkbox "name" was found in the checked array,
                  // set delete flag 
                  ////////////////////////////check here if qtyReceived > 0
                  doDelete = true;
                  break;
                }
              }
              //if (thisAssignedList[i].qtyReceived > 0) {
              //  doDelete = false;
              //  alertDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("cannotRemove")) %>" );//+
              //  break;
                //tempCannotRemoveList = thisAssignedList[i].ffmName + " - " + thisAssignedList[i].sku + " - " + thisAssignedList[i].formattedExpectedDate;
                //if (cannotRemoveList.length > 1) {
		//  cannotRemoveList = cannotRemoveList + "\n" + tempCannotRemoveList;
		//} else {
		//  cannotRemoveList = tempCannotRemoveList
                //} 
              //}
              // if this entry is not to be deleted, copy it to the new array
              //alertDialog(doDelete + " "  +  thisAssignedList[i].status);   
              // if this entry is not to be deleted, copy it to the new array -- || (qtyReceived > 0 ))
              if (!doDelete) {
                newAssignedList[newAssignedList.length] = new Object();
                newAssignedList[newAssignedList.length-1].ffmIndex = 
                                                          thisAssignedList[i].ffmIndex;
                newAssignedList[newAssignedList.length-1].ffmName  = 
                                                          thisAssignedList[i].ffmName ;
                newAssignedList[newAssignedList.length-1].ffmcenterId  = 
                                                          thisAssignedList[i].ffmcenterId ;
                newAssignedList[newAssignedList.length-1].itemIndex  = 
                                                          thisAssignedList[i].itemIndex ;
                newAssignedList[newAssignedList.length-1].itemName  = 
                                                          thisAssignedList[i].itemName ;
                newAssignedList[newAssignedList.length-1].itemspcId   = 
                                                          thisAssignedList[i].itemspcId  ;
                newAssignedList[newAssignedList.length-1].expectedDate   = 
                                                          thisAssignedList[i].expectedDate  ;
                
                newAssignedList[newAssignedList.length-1].expectedYear   = 
                                                          thisAssignedList[i].expectedYear  ;
                newAssignedList[newAssignedList.length-1].expectedMonth   = 
                                                          thisAssignedList[i].expectedMonth  ;
                newAssignedList[newAssignedList.length-1].expectedDay   = 
                                                          thisAssignedList[i].expectedDay  ;
                
                newAssignedList[newAssignedList.length-1].raDetailComment   = 
                                                          thisAssignedList[i].raDetailComment  ;/////
                newAssignedList[newAssignedList.length-1].qtyOrdered   = 
                                                          thisAssignedList[i].qtyOrdered  ;
                
                newAssignedList[newAssignedList.length-1].raDetailId   = 
                                                          thisAssignedList[i].raDetailId  ;
                                                          
                newAssignedList[newAssignedList.length-1].status   = 
                                                          thisAssignedList[i].status  ;
                
                newAssignedList[newAssignedList.length-1].formattedExpectedDate   = 
                                                          thisAssignedList[i].formattedExpectedDate  ;
                
                newAssignedList[newAssignedList.length-1].sku   = 
                                                          thisAssignedList[i].sku  ;
                
                newAssignedList[newAssignedList.length-1].uom   = 
                                                          thisAssignedList[i].uom  ;
                                                          
                newAssignedList[newAssignedList.length-1].qtyReceived  = 
                                                          thisAssignedList[i].qtyReceived  ;
              } else {
                                 
                if (thisAssignedList[i].status != "N") { 
                
                  newlyRemovedDetailList[newlyRemovedDetailList.length] = new Object();
                  newlyRemovedDetailList[newlyRemovedDetailList.length-1].ffmIndex = 
                                                    thisAssignedList[i].ffmIndex;
                
                  newlyRemovedDetailList[newlyRemovedDetailList.length-1].ffmName  = 
                                                    thisAssignedList[i].ffmName ;
                  newlyRemovedDetailList[newlyRemovedDetailList.length-1].ffmcenterId  = 
                                                    thisAssignedList[i].ffmcenterId ;
                  newlyRemovedDetailList[newlyRemovedDetailList.length-1].itemIndex  = 
                                                    thisAssignedList[i].itemIndex ;
		  newlyRemovedDetailList[newlyRemovedDetailList.length-1].itemName  = 
                                                    thisAssignedList[i].itemName ;
		  newlyRemovedDetailList[newlyRemovedDetailList.length-1].itemspcId   = 
                                                    thisAssignedList[i].itemspcId  ;
		  newlyRemovedDetailList[newlyRemovedDetailList.length-1].expectedDate   = 
                                                    thisAssignedList[i].expectedDate  ;
                  
                  newlyRemovedDetailList[newlyRemovedDetailList.length-1].expectedYear   = 
		                                    thisAssignedList[i].expectedYear  ;
		  newlyRemovedDetailList[newlyRemovedDetailList.length-1].expectedMonth   = 
		                                    thisAssignedList[i].expectedMonth  ;
		  newlyRemovedDetailList[newlyRemovedDetailList.length-1].expectedDay   = 
                                                    thisAssignedList[i].expectedDay  ;

		  newlyRemovedDetailList[newlyRemovedDetailList.length-1].raDetailComment   = 
                                                    thisAssignedList[i].raDetailComment  ;
		  newlyRemovedDetailList[newlyRemovedDetailList.length-1].qtyOrdered   = 
                                                    thisAssignedList[i].qtyOrdered  ;
                                                    
                  newlyRemovedDetailList[newlyRemovedDetailList.length-1].raDetailId   = 
                                                          thisAssignedList[i].raDetailId;
                  
                  newlyRemovedDetailList[newlyRemovedDetailList.length-1].status   = 
                                                          thisAssignedList[i].status  ;
                  
                   newlyRemovedDetailList[newlyRemovedDetailList.length-1].formattedExpectedDate   = 
                                                          thisAssignedList[i].formattedExpectedDate  ;
                                                          
                   newlyRemovedDetailList[newlyRemovedDetailList.length-1].sku   = 
                                                          thisAssignedList[i].sku  ;
                                                          
                   newlyRemovedDetailList[newlyRemovedDetailList.length-1].uom   = 
                                                          thisAssignedList[i].uom  ;
                                                          
                   newlyRemovedDetailList[newlyRemovedDetailList.length-1].qtyReceived   = 
                                                          thisAssignedList[i].qtyReceived  ;
                                                          
                    removedSize++;
                  
  
                }
                
                //  parent.parent.put("removedSizeTemp", removedSize);
                
                
              }
              
            } 
            
          //}           

        //if (cannotRemoveList.length > 0) {
        //  alertDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("cannotRemove")) %>" );//+
        //         "\n" + cannotRemoveList);
        //}
        
        vendorDetailList = newAssignedList;
        parent.parent.put("vendorDetailList", vendorDetailList); 
        parent.parent.put("removedRaItem", newlyRemovedDetailList);
        parent.parent.put("removedSize", removedSize);
        
        // parent.parent.put("removedSizeTemp", removedSize);
        
        }

       
      if (top.setContent) {
        if (status == "change") {
          var url = "/webapp/wcs/tools/servlet/NotebookView?XMLFile=inventory.VendorNotebookChange&startingPage=vendorPurchaseOrderDetailListChange";
        } else {
          var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=inventory.VendorWizard&startingPage=vendorPurchaseOrderDetailList"
        }
        url += "&raId=" + "<%=UIUtil.toJavaScript(strRaId)%>";
        url += "&status=" + "<%=UIUtil.toJavaScript(status)%>";
        url += "&formattedExpectedDate=";

        parent.parent.put("vendorDetailList", vendorDetailList); 
	parent.parent.put("removedRaItem", newlyRemovedDetailList);
        parent.parent.put("removedSize", removedSize);
        top.saveModel(parent.parent.model);
        top.showContent(url); 
        top.refreshBCT(); 
        
      } else {
        top.saveModel(parent.parent.model);
        parent.parent.location.reload();
      } 
    }
      addRowNumbers();
  }
}

function addRowNumbers()
{
  for (var i = 0 ; i < vendorDetailList.length ; i++){
    vendorDetailList[i].rowNum = i;
  }
}

function onLoad()
{
  parent.loadFrames();
  if (parent.parent.setContentFrameLoaded) {
    parent.parent.setContentFrameLoaded(true);
  }
}

function initialize()
{
  var newlyAddedDetailList = new Array();
  var newlyChangedDetailList = new Array();
  var addedSize = 0;
  var changedSize = 0;
  
  var temp = parent.parent.get("tempVendorDetail");
  if (temp != null){
    parent.parent.remove("tempVendorDetail");
  }
  
  var validNumberRows = parent.parent.get("validNumberRows");
  if ( validNumberRows == "false"){
    parent.parent.put("validNumberRows", "null");
    alertDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("noRowsToSave")) %>");
  }
  
  
  //get rows that have been stored in parent 
  vendorDetailList = parent.parent.get("vendorDetailList") ;
    
  if (vendorDetailList == null){
    //no rows have been entered yet
    numRows = 0;
    vendorDetailList  = new Array();
  } else {
    //find out how many rows have been saved
    
    numRows = vendorDetailList.length;
  }

  //get the info that has been sent over from dialog
  var detail = parent.parent.get("vendorDetail");
  
  <%
     //format expected date from detail page
     String formattedExpectedDate = null;
     formattedExpectedDate = request.getParameter("formattedExpectedDate");
     if ((formattedExpectedDate != null) && (formattedExpectedDate.trim().length() > 0)) {
       Timestamp t = Timestamp.valueOf(formattedExpectedDate);    
       formattedExpectedDate = TimestampHelper.getDateFromTimestamp(t, localeUsed );
     }
  %>
  
  
   if (detail != null){
    parent.parent.remove("vendorDetail");
    //add this data to the array
    vendorDetailList[numRows] = detail;
    
     //set formatted date into the model  
     vendorDetailList[numRows].formattedExpectedDate = '<%= UIUtil.toJavaScript(formattedExpectedDate) %>';
     //end format date
     
    if (numRows == 0){
      //if this is the first row to be entered
      parent.parent.put("vendorDetailList", vendorDetailList);
      vendorDetailList = parent.parent.get("vendorDetailList") ;
    }
    numRows = numRows + 1;
  }

  var updatedRow =  parent.parent.get("changeRow");
  if (updatedRow != null){
    parent.parent.remove("changeRow");
    //add this data to the array
    vendorDetailList[updatedRow.rowNum] = updatedRow;
    
    //set formatted date into the model for changed rows
    vendorDetailList[updatedRow.rowNum].formattedExpectedDate = '<%= UIUtil.toJavaScript(formattedExpectedDate) %>';
    //end format date
    
  }
 
  addRowNumbers();
  
  for (var i=0; i<numRows; i++){
    if (vendorDetailList[i].status == "C"){
      newlyChangedDetailList[newlyChangedDetailList.length] = new Object();
      newlyChangedDetailList[newlyChangedDetailList.length - 1].ffmIndex =  vendorDetailList[i].ffmIndex;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].ffmName  = vendorDetailList[i].ffmName ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].ffmcenterId  = vendorDetailList[i].ffmcenterId ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].itemIndex  = vendorDetailList[i].itemIndex ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].itemName  = vendorDetailList[i].itemName ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].itemspcId = vendorDetailList[i].itemspcId  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].expectedDate   = vendorDetailList[i].expectedDate  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].expectedYear   = vendorDetailList[i].expectedYear  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].expectedMonth   = vendorDetailList[i].expectedMonth  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].expectedDay   = vendorDetailList[i].expectedDay  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].raDetailComment   = vendorDetailList[i].raDetailComment  ;/////
      newlyChangedDetailList[newlyChangedDetailList.length - 1].qtyOrdered   = vendorDetailList[i].qtyOrdered  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].raDetailId   = vendorDetailList[i].raDetailId  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].status   = vendorDetailList[i].status  ;
      
      newlyChangedDetailList[newlyChangedDetailList.length - 1].formattedExpectedDate   = vendorDetailList[i].formattedExpectedDate  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].sku   = vendorDetailList[i].sku  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].uom   = vendorDetailList[i].uom  ;
      newlyChangedDetailList[newlyChangedDetailList.length - 1].qtyReceived   = vendorDetailList[i].qtyReceived  ;
      
      changedSize++;
      //alertDialog("newlyChangedDetailList.length="+newlyChangedDetailList.length);
      //alertDialog("newlyChangedDetailList=" + newlyChangedDetailList[newlyChangedDetailList.length - 1].raDetailId);
    }
    //alert(vendorDetailList[i].status);
   if (vendorDetailList[i].status == "N"){
      newlyAddedDetailList[newlyAddedDetailList.length] = new Object();
      newlyAddedDetailList[newlyAddedDetailList.length - 1].ffmIndex =  vendorDetailList[i].ffmIndex;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].ffmName  = vendorDetailList[i].ffmName ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].ffmcenterId  = vendorDetailList[i].ffmcenterId ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].itemIndex  = vendorDetailList[i].itemIndex ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].itemName  = vendorDetailList[i].itemName ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].itemspcId = vendorDetailList[i].itemspcId  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].expectedDate   = vendorDetailList[i].expectedDate  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].expectedYear   = vendorDetailList[i].expectedYear  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].expectedMonth   = vendorDetailList[i].expectedMonth  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].expectedDay   = vendorDetailList[i].expectedDay  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].raDetailComment   = vendorDetailList[i].raDetailComment  ;/////
      newlyAddedDetailList[newlyAddedDetailList.length - 1].qtyOrdered   = vendorDetailList[i].qtyOrdered  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].raDetailId   = vendorDetailList[i].raDetailId  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].status   = vendorDetailList[i].status  ;
      
      newlyAddedDetailList[newlyAddedDetailList.length - 1].formattedExpectedDate   = vendorDetailList[i].formattedExpectedDate  ;
      newlyAddedDetailList[newlyAddedDetailList.length - 1].sku   = vendorDetailList[i].sku  ; 
      newlyAddedDetailList[newlyAddedDetailList.length - 1].uom   = vendorDetailList[i].uom  ; 
      newlyAddedDetailList[newlyAddedDetailList.length - 1].qtyReceived   = vendorDetailList[i].qtyReceived  ; 
      
      addedSize++;
      
      //alertDialog("newlyAddedDetailList=" + newlyAddedDetailList[newlyAddedDetailList.length - 1].raDetailId);
    }
  }
  
  var store = '<%=UIUtil.toJavaScript(storeId)%>' ;
  var vendor =  top.getData("vendorId");
  var odate =  top.getData("orderDate");// added
  parent.parent.put("orderDate", odate) ;// added
  parent.parent.put("storeId", store);
  parent.parent.put("vendorId", vendor) ;
                     
  parent.parent.put("addedRaItem", newlyAddedDetailList);
  parent.parent.put("addedSize", addedSize);
    
  
  var removedSizeTemp = parent.parent.get("removedSize");
  if (removedSizeTemp == null) {
     parent.parent.put("removedSize", removedSize);
  }
  
  parent.parent.put("changedRaItem", newlyChangedDetailList);
  parent.parent.put("changedSize", changedSize);

  
  
  
}

function validatePanelData()
{
  //called when using the Wizard
  if (numRows == 0){ 
    alertDialog("<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("noRowsToSave")) %>");
    return false;
  } else {
    return true;
  }
}



	  
// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
</HEAD>



<BODY onload="onLoad()" CLASS="content">
<SCRIPT LANGUAGE="JavaScript">
  initialize();
</SCRIPT>


<%
  int startIndex = Integer.parseInt(request.getParameter("startindex"));
  int listSize = Integer.parseInt(request.getParameter("listsize"));
  int endIndex = startIndex + listSize;
%>




<FORM NAME="VendorWizardDetail">

<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("vendorPurchaseTableSum")) %>
<%= comm.startDlistRowHeading() %>

<%= comm.addDlistCheckHeading() %>
<%-- //BR 13MAR2001 These next few rows get the header name from the vendorPurchaseNLS file --%>
<%-- //"VendorName should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("detailListItem"), null, false, "10%"  )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("detailFulfillmentCenter"), null, false, "40%")%>

<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("detailListExpectedDate"), null, false, "40%" )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("detailListQuantity"), null, false,"10%" )%>
<%= comm.endDlistRow() %>

<!-- Need to have a for loop to look for all the member groups -->


<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers



  var startIndex = <%=Integer.parseInt(request.getParameter("startindex"))%>;
  var listSize = <%=Integer.parseInt(request.getParameter("listsize"))%>;
  var endIndex = startIndex + listSize;
  var j = 0;
  if (endIndex > numRows){
    endIndex = numRows;
  }
  for (var i = 0; i < numRows ; i++){
  //for (var i = startIndex; i < endIndex ; i++){
    if (j == 0){
      document.writeln('<TR CLASS="list_row1">');
      j = 1;
    }else{
      document.writeln('<TR CLASS="list_row2">');
      j = 0;
    }
    
    addDlistCheck( i, "none" );
    addDlistColumn( vendorDetailList[i].sku, "none" );
    addDlistColumn( vendorDetailList[i].ffmName , "none" );
    
    var tempDisplayName = vendorDetailList[i].formattedExpectedDate;
    addDlistColumn( vendorDetailList[i].formattedExpectedDate, "none" );
    addDlistColumn( vendorDetailList[i].qtyOrdered, "none" );
    //document.writeln('<TR>');

  }
       //-->
</SCRIPT>



<%= comm.endDlistTable() %>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  if (numRows == 0){
    document.writeln('<br>');
    document.writeln ('<%= UIUtil.toJavaScript(vendorPurchaseListNLS.get("vendorPODetailNoRows")) %>');
   
   
  }

     //-->
</SCRIPT>


</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  parent.setResultssize(getResultsize());
 
   //-->
</SCRIPT>

</BODY>
</HTML>
