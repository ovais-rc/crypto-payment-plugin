<!--      
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %> 

<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.inventory.objects.*" %>


<%@ include file= "../common/common.jsp" %>


<jsp:useBean id="fulfillmentCenterList" scope="request" class="com.ibm.commerce.inventory.beans.FulfillmentCenterListDataBean">
</jsp:useBean>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();

    // obtain the resource bundle for display
    Hashtable inventoryNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("inventory.VendorPurchaseNLS", locale);
    Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);
    
    if (inventoryNLS == null) System.out.println("!!!! RS is null");

    Integer store_id = cmdContext.getStoreId();
    String storeId = store_id.toString();

    Integer langId = cmdContext.getLanguageId();
    String strLangId = langId.toString();

    //fulfillmentCenterList.setLanguageId(strLangId);
    fulfillmentCenterList.setStoreentId(storeId);
 
    FulfillmentCenterDataBean fulfillmentCenters[] = null;
    int numberOffulfillmentCenters = 0;

    DataBeanManager.activate(fulfillmentCenterList, request);
    fulfillmentCenters = fulfillmentCenterList.getFulfillmentCenterList();

     if (fulfillmentCenters != null){
      numberOffulfillmentCenters = fulfillmentCenters.length;
    }

    Vector vecffmId = new Vector();
    Vector vecffmDisplayName = new Vector();
    Vector vecffmName = new Vector();

    FulfillmentCenterDataBean fulfillmentCenter;

    for (int i=0; i < numberOffulfillmentCenters ; i++)
    {
      fulfillmentCenter = fulfillmentCenters[i];

      String ffmcenterId = fulfillmentCenter.getFulfillmentCenterId();
      String ffmcenterDisplayName = fulfillmentCenter.getDisplayName();
      
      String ffmName = fulfillmentCenter.getDisplayName();
      ffmName = UIUtil.toHTML(UIUtil.toJavaScript(ffmName));
      ffmName = "\"" + ffmName + "\"";
      
      //String ffmName = "\"" + fulfillmentCenter.getDisplayName() + "\"";
      if (ffmName == null)
      {
        ffmName = ffmcenterId;
      }
      vecffmId.addElement(ffmcenterId);
      vecffmDisplayName.addElement(ffmcenterDisplayName);
      vecffmName.addElement(ffmName);

    }

    String status2 = request.getParameter("status2");
    String status = request.getParameter("status");    
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>
<SCRIPT>
var updating = false;
var changeRow = parent.get("changeRow"); 
var passedItemspc_id = null;
var passedShortDesc = null;
var passedSku = null;
var passedUom = "";
var itemData;

var status = '<%=UIUtil.toJavaScript(status)%>';
var status2 = '<%=UIUtil.toJavaScript(status2)%>';

//alertDialog(status2 + " " + status);
 
function init()
{
  document.dialog1.YEAR1.value = getCurrentYear();
  document.dialog1.MONTH1.value = getCurrentMonth();
  document.dialog1.DAY1.value = getCurrentDay();
}

function setupDate()
{
  window.yearField = document.dialog1.YEAR1;
  window.monthField = document.dialog1.MONTH1;
  window.dayField = document.dialog1.DAY1;
}


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{

top.saveData("null", "formattedExpectedDate");
 
 if (changeRow != null) {
    updating = true;
    var blank = null;

    
    var ffmcenterId = changeRow.ffmcenterId;
    var vecffmId = new Array();
    vecffmId = <%= vecffmId %>;
    for (var i=0; (i < <%= numberOffulfillmentCenters %> - 1) && (vecffmId[i] != ffmcenterId); i++){
    }
    if (vecffmId[i] == ffmcenterId)
       changeRow.ffmIndex = i; 
       //alertDialog ("i=" + i + ";ffmIndex=" + changeRow.ffmIndex);
    
       //var itemspcId = changeRow.itemspcId;
       passedItemspc_id = changeRow.itemspcId ;
       passedShortDesc = changeRow.itemName ;
       passedSku = changeRow.sku;
       passedUom = changeRow.uom;
       //alertDialog ("itemspcId="+passedItemspc_id);
  
    //document.dialog1.itemId.value = changeRow.itemIndex  ;
    document.dialog1.ffmId.value = changeRow.ffmIndex ;
    document.dialog1.YEAR1.value = changeRow.expectedYear  ;
    document.dialog1.MONTH1.value = changeRow.expectedMonth;
    document.dialog1.DAY1.value =  changeRow.expectedDay;
    document.dialog1.quantity.value = changeRow.qtyOrdered ; 
    
    if (changeRow.raDetailComment.value == null) {
      changeRow.raDetailComment.value = ""
    }
    
    document.dialog1.raDetailComment.value = changeRow.raDetailComment ;
    
    top.saveData(changeRow.expectedYear + '-' + changeRow.expectedMonth +'-'+ changeRow.expectedDay + ' 00:00:00.0' , "formattedExpectedDate");
    
  }
  
   var tempVendorDetail = parent.get("tempVendorDetail");
   if (tempVendorDetail != null) {
     
     var ffmcenterId = tempVendorDetail.ffmcenterId;
     var vecffmId = new Array();
     vecffmId = <%= vecffmId %>;
     for (var i=0; (i < <%= numberOffulfillmentCenters %> - 1) && (vecffmId[i] != ffmcenterId); i++){
     }
     if (vecffmId[i] == ffmcenterId)
       tempVendorDetail.ffmIndex = i; 

       document.dialog1.ffmId.value = tempVendorDetail.ffmIndex ;
       document.dialog1.YEAR1.value = tempVendorDetail.expectedYear  ;
       document.dialog1.MONTH1.value = tempVendorDetail.expectedMonth;
       document.dialog1.DAY1.value =  tempVendorDetail.expectedDay;
       document.dialog1.quantity.value = tempVendorDetail.qtyOrdered ;

       document.dialog1.raDetailComment.value= tempVendorDetail.raDetailComment ;
       parent.remove("tempVendorDetail");
  
   }
  

  if (<%= numberOffulfillmentCenters %> < 1){
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("noFulfillmentCenters"))%>');
    parent.location.replace("/webapp/wcs/tools/servlet/WizardView?XMLFile=inventory.VendorWizard&startingPage=vendorPurchaseOrderDetailList");
  }

  
  if (parent.setContentFrameLoaded){
    parent.setContentFrameLoaded(true);
  }
}

function getItemDescription(){
 return passedShortDesc ;
}

function validatePanelData()
{

  if (passedItemspc_id  == null ){
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("noItemSelected"))%>');
    parent.remove("vendorDetail");
    parent.remove("changeRow");
    top.saveData("null", "formattedExpectedDate");
    return false;
  }

  if ( !isValidPositiveInteger(document.dialog1.YEAR1.value )) {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidDate"))%>');
    document.dialog1.YEAR1.select();
    document.dialog1.YEAR1.focus();
    parent.remove("vendorDetail");
    parent.remove("changeRow");
    top.saveData("null", "formattedExpectedDate");
    return false;
  }

  if (!validDate(document.dialog1.YEAR1.value , document.dialog1.MONTH1.value, document.dialog1.DAY1.value)){
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidDate"))%>');
    document.dialog1.YEAR1.select();
    document.dialog1.YEAR1.focus();
    parent.remove("vendorDetail");
    parent.remove("changeRow");
    top.saveData("null", "formattedExpectedDate");
    return false;
  }

  var quantity = document.dialog1.quantity.value;
  if ( !isValidPositiveInteger(quantity)) {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidQuantity"))%>');
    document.dialog1.quantity.select();
    document.dialog1.quantity.focus();
    parent.remove("vendorDetail");
    parent.remove("changeRow");
    top.saveData("null", "formattedExpectedDate");
    return false;
  } else {
    if (quantity == "0" ) {
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidQuantity"))%>');
      document.dialog1.quantity.select();
      document.dialog1.quantity.focus();
      parent.remove("vendorDetail");
      parent.remove("changeRow");
      top.saveData("null", "formattedExpectedDate");
      return false;
    }
    if (document.dialog1.quantity.value > 2147483647) {
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityOrderedExceed"))%>');
      document.dialog1.quantity.select();
      document.dialog1.quantity.focus();
      parent.remove("vendorDetail");
      parent.remove("changeRow");
      top.saveData("null", "formattedExpectedDate");
      return false;
    }
  }

  var raDetailComment = document.dialog1.raDetailComment.value;
  if ( !isValidUTF8length( raDetailComment, 254 )) {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("commentExceedMaxLength"))%>');
    document.dialog1.raDetailComment.select();
    document.dialog1.raDetailComment.focus();
    parent.remove("vendorDetail");
    parent.remove("changeRow");
    top.saveData("null", "formattedExpectedDate");
    return false;
  }


  var validateVendorDetailList = parent.get("validateVendorDetailList");
  if ( validateVendorDetailList != null ) {
    var validateItemName = null;
    var validateFfmCenterID = null;
    var validateExpectedDate = null;
    for ( i=0; i < validateVendorDetailList.length; i++ ) {
      validateItemName = validateVendorDetailList[i].itemName;
      validateFfmCenterID = validateVendorDetailList[i].ffmcenterId;
      validateExpectedDate = validateVendorDetailList[i].expectedDate;
      //alertDialog(validateItemName+validateFfmCenterID+validateExpectedDate);
      if (changeRow != null) {
        if (vendorDetail.itemName == changeRow.itemName &&
                                vendorDetail.ffmcenterId == changeRow.ffmcenterId &&
                                vendorDetail.expectedDate == changeRow.expectedDate ) {
            
            return true;
        }
      }
      if (validateItemName == vendorDetail.itemName &&
                              validateFfmCenterID == vendorDetail.ffmcenterId &&
                              validateExpectedDate == vendorDetail.expectedDate) {
        
        alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("duplicate"))%>');
        parent.remove("vendorDetail");
        parent.remove("changeRow");
        top.saveData("null", "formattedExpectedDate");
        return false;
      }
    }
  }


  return true;
}

function savePanelData()
{
   
   var ffmIndex = document.dialog1.ffmId.value;
      
   var vecffmId = new Array();
   var vecffmName = new Array();

   vecffmId = <%= vecffmId %>;
   vecffmName =  <%= vecffmName %> ;

   var ffmId = vecffmId[ffmIndex];
   var ffmName = vecffmName[ffmIndex];

   vendorDetail = new Object();

   vendorDetail.ffmIndex = document.dialog1.ffmId.value;
   vendorDetail.ffmName = ffmName;
   vendorDetail.ffmcenterId = ffmId;

   vendorDetail.itemName = passedShortDesc;
   vendorDetail.itemspcId = passedItemspc_id;
   vendorDetail.sku = passedSku;
   vendorDetail.uom = passedUom;
   
   if ((document.dialog1.MONTH1.value != "") && (trim(document.dialog1.MONTH1.value.length) < 2)) {
     document.dialog1.MONTH1.value = "0" + document.dialog1.MONTH1.value;
   }
   
   if ((document.dialog1.DAY1.value != "") && (trim(document.dialog1.DAY1.value.length) < 2)) {
     document.dialog1.DAY1.value = "0" + document.dialog1.DAY1.value;
   }
   
   vendorDetail.expectedYear = document.dialog1.YEAR1.value;
   vendorDetail.expectedMonth = document.dialog1.MONTH1.value;
   vendorDetail.expectedDay = document.dialog1.DAY1.value ;
   
   vendorDetail.expectedDate = document.dialog1.YEAR1.value + '-' + document.dialog1.MONTH1.value +'-'+ document.dialog1.DAY1.value + ' 00:00:00.0'; 
   vendorDetail.formattedExpectedDate = vendorDetail.expectedDate;

	
	
   vendorDetail.raDetailComment = trim(document.dialog1.raDetailComment.value);
   vendorDetail.qtyOrdered = document.dialog1.quantity.value;
   
   vendorDetail.raDetailId = null;
   vendorDetail.status = "N";
   vendorDetail.qtyReceived = 0 ;

   if ((status== "change") && (status2 != "changeAdd") && (status2 != "newAdd")){
     vendorDetail.raDetailId = changeRow.raDetailId;
     vendorDetail.qtyReceived = changeRow.qtyReceived;
     if (vendorDetail.raDetailId != null) {
       vendorDetail.status = "C";
     }
   }


     if ( updating == true){
       if (changeRow.status == "O") {
         vendorDetail.status = "C";
       }
       vendorDetail.rowNum = changeRow.rowNum;
       parent.put("changeRow", vendorDetail);
     }else{
       parent.put("vendorDetail", vendorDetail);
     }
     
     top.saveData('<%=UIUtil.toJavaScript(status)%>',"current");
     
     top.saveData(vendorDetail.formattedExpectedDate, "formattedExpectedDate");
     

  //}
}

function findItem(){ 
   url="/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.AddItemSearchDialog" 
   
   savePanelData();
   
   parent.put("tempVendorDetail", vendorDetail);
   parent.remove("vendorDetail");
   
   top.saveData('<%=UIUtil.toJavaScript(status)%>',"current");
   top.saveModel(parent.model);
   parent.location.replace(url);

}


function cancel () 
{
  
  var answer = parent.confirmDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("VendorPurchaseCancelConfirmation"))%>');

  return answer;
}


</SCRIPT>
<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  2000,2001.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="initializeState()" CLASS="content">

<script language="javascript"> <!-- alert("VendorDetail.jsp"); --></script> 

<SCRIPT>
  if (changeRow != null){
    passedItemspc_id = changeRow.itemspcId ;
    passedShortDesc = changeRow.itemName ;
    passedSku = changeRow.sku;
    passedUom = changeRow.uom;
  }else{
    itemData =   parent.get("itemSearchData");
    if (itemData != null){
      passedItemspc_id  =   itemData.itemspc_id ;
      passedShortDesc  =  itemData.shortDescription ;
      passedSku = itemData.sku ;
      passedUom = itemData.uom;
      parent.remove("itemSearchData");
    }
  }
</SCRIPT>


<SCRIPT FOR=document EVENT="onclick()">
document.all.CalFrame.style.display="none";
</SCRIPT>
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp"></IFRAME>

<SCRIPT>
if ( (status2 == "changeAdd") || (status2 == "newAdd") ) {
  document.writeln('<H1>');
  document.writeln('<%= UIUtil.toHTML((String)inventoryNLS.get("vendorPurchaseOrderDetailAdd")) %>');
  document.writeln('</H1>');
  document.writeln('<P>');
  } else {
  document.writeln('<H1>');
  document.writeln('<%= UIUtil.toHTML((String)inventoryNLS.get("vendorPurchaseOrderDetailChange")) %>');
  document.writeln('</H1>');
  document.writeln('<P>');
}                          
</SCRIPT>                      

<FORM NAME="dialog1">
<!-- // <LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">  -->
<P>
    <TABLE border=0 cellspacing=0 cellpadding=0>
      <TR>
        <TD><%= UIUtil.toHTML((String)inventoryNLS.get("itemLabel")) %>  
      	<i>
        <SCRIPT>
          var noButton = getItemDescription();
            if (noButton == ""){
      	      noButton = null;
      	    }
      	    if ((noButton == null) || (noButton == "")){
      	      document.write('<INPUT TYPE = "button" name = "getItem" value = "' + '<%= UIUtil.toHTML((String)inventoryNLS.get("findButton")) %>'  + '" onClick = "findItem()">');
      	    } else{
      	      document.write(noButton);
            }
      	</SCRIPT>
      	</i>
      	</TD>
      </TR>
    </TABLE>
    <P>


    <TABLE border=0 cellspacing=0 cellpadding=0>
       <TBODY>
          
           <TR>          
            <TD><LABEL for="ffmlb"><%= UIUtil.toHTML((String)inventoryNLS.get("fulfillmentCenter")) %></LABEL></TD>
          </TR>
          <TR>
            <TD>
              <SELECT NAME=ffmId ID="ffmlb" >
<%
              int firstTime = 1;
              for (int i=0; i < numberOffulfillmentCenters ; i++){
                String ffmName = (String) vecffmDisplayName.elementAt(i);
                String ffmID = (String) vecffmId.elementAt(i);

%>
                <OPTION value="<%= i %>"
<%
                if (firstTime == 1){
%>
                  SELECTED
<%
                }
%>
                  >
                  <%= UIUtil.toHTML(ffmName) %>
                </OPTION>
<%

                  firstTime = 0;
                }
%>
              </SELECT>
            </TD>
          </TR>
        </TBODY>
        
     </TABLE>          
     <P>
     <TABLE border=0 cellspacing=0 cellpadding=0>
       <TR>
         <TD colspan=2><LABEL><%= UIUtil.toHTML((String)inventoryNLS.get("expectedDateRequired")) %></LABEL></TD>
       </TR>
  
       <TR>
         <TD width=25></TD>
       <TD>
         <TABLE>
           <TR>
             <TD><LABEL for="YEAR1"><%= UIUtil.toHTML((String)inventoryNLS.get("year")) %></LABEL></TD>
             <TD>&nbsp;</TD>
             <TD><LABEL for="MONTH1"><%= UIUtil.toHTML((String)inventoryNLS.get("month")) %></LABEL></TD>
             <TD>&nbsp;</TD>
             <TD><LABEL for="DAY1"><%= UIUtil.toHTML((String)inventoryNLS.get("day")) %></LABEL></TD>
           </TR>
           <TR>
             <TD ><INPUT TYPE=TEXT VALUE="" NAME=YEAR1 ID="YEAR1" SIZE=4 MAXLENGTH=4></TD>
             <TD></TD>
             <TD ><INPUT TYPE=TEXT VALUE="" NAME=MONTH1 ID="MONTH1" SIZE=2 MAXLENGTH=2></TD>
             <TD></TD>
             <TD><INPUT TYPE=TEXT VALUE="" NAME=DAY1 ID="DAY1" SIZE=2 MAXLENGTH=2></TD>
             <TD>&nbsp;</TD>
             <TD><A HREF="javascript:setupDate();showCalendar(document.dialog1.calImg)">
               <IMG SRC="/wcs/images/tools/calendar/calendar.gif" ALT="<%=inventoryNLS.get("chooseDate")%>" BORDER=0 id=calImg></A></TD>   
           </TR>
         </TABLE>
        </TD>
      </TR>
    </TABLE>
    <P>
    <TABLE border=0 cellspacing=0 cellpadding=0>
      <TR>
        <TD><label for="quantity"><%= UIUtil.toHTML((String)inventoryNLS.get("quantityRequired")) %></label></TD>
      </TR>
      <TR>
        <TD><INPUT NAME=quantity ID="quantity" size="15" type="text" MAXLENGTH=10></TD>
      </TR>
    </TABLE>
    <TABLE border=0 cellspacing=0 cellpadding=0>
      <TR>
        <TD><%= UIUtil.toHTML((String)inventoryNLS.get("unitOfMeasure")) %>
        <i>
          <SCRIPT>
          if (changeRow != null) {
            document.writeln(changeRow.uom);
          } else {
            document.writeln(passedUom);
          }
          </SCRIPT>
        </i>
        </TD>
      </TR>
    </TABLE>
    <P>
    <TABLE border=0 cellspacing=0 cellpadding=0>
      <TR>
        <TD><label for="raDetailComment"><%= UIUtil.toHTML((String)inventoryNLS.get("comments")) %></label></TD>
      </TR>
      <TR>
        <TD><TEXTAREA NAME=raDetailComment ID="raDetailComment" rows="7" cols="40" ></TEXTAREA></TD>
    </TABLE>
  

</FORM>
</BODY>
</HTML>