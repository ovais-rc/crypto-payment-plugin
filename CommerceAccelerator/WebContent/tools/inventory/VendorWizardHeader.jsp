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
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.inventory.objects.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>

<%@ include file= "../common/common.jsp" %>

<jsp:useBean id="vendorList" scope="request" class="com.ibm.commerce.inventory.beans.VendorListDataBean">
</jsp:useBean>

<jsp:useBean id="vendorPO" scope="request" class="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordDataBean">
</jsp:useBean>

<jsp:useBean id="vendorDetailList" scope="request" class="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordListDataBean">
</jsp:useBean>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
%>

<%
    // obtain the resource bundle for display
    Hashtable inventoryNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("inventory.VendorPurchaseNLS", locale);
    Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);
    
    if (inventoryNLS == null) System.out.println("!!!! RS is null");

    String userGeneralAdminTypeUpdateFailed = UIUtil.toJavaScript((String)inventoryNLS.get("userGeneralAdminTypeUpdateFailed"));
    
    String VendorPOId = request.getParameter("raId");
        
    String status = request.getParameter("status");
%>
  
<%
  String vendorName = null;
  String orderYear = null;
  String orderDay = null;
  String orderMonth = null;
  String externalId = "";

  int numberOfvendors = 0;
  
  Vector vecVendorId = new Vector();
  Vector vecVendorDisplayName = new Vector();
  Vector vecVendorName = new Vector();
  
  Integer store_id = cmdContext.getStoreId();
  String storeId = store_id.toString();

  Integer langId = cmdContext.getLanguageId();
  String strLangId = langId.toString();
  
  String vendorId = null;

  if (!status.equalsIgnoreCase("change")) {
    VendorDataBean vendors[] = null;

    vendorList.setLanguageId(strLangId);
    vendorList.setStoreentId(storeId);

    DataBeanManager.activate(vendorList, request);
    vendors = vendorList.getVendorList();

    if (vendors != null){
      numberOfvendors = vendors.length;
    }


    VendorDataBean vendor;

    for (int i=0; i < numberOfvendors ; i++) {
      vendor = vendors[i];

      vendorId = vendor.getVendorId();
      String vendorDisplayName = vendor.getVendorName();
      vendorName = "+vendor.getVendorName()+";
      //vendorName = "\"" + vendor.getVendorName() + "\"";
      if (vendorName == null)
      {
        vendorName = vendorId;
      }
      vecVendorId.addElement(vendorId);
      vecVendorDisplayName.addElement(vendorDisplayName);
      vecVendorName.addElement(vendorName);
    }
  } else {
  
    numberOfvendors = 1;
    
    vendorPO.setLanguageId(strLangId);
    vendorPO.setExpectedInventoryRecordId(VendorPOId);
    
    DataBeanManager.activate(vendorPO, request);
    
    vendorName = vendorPO.getVendorName();
    String orderDate = vendorPO.getOrderDate();
    externalId = vendorPO.getExternalId();
    if (externalId == null) {
      externalId = "";
    }
    
    vendorId = vendorPO.getVendorId();
    
    Timestamp t = Timestamp.valueOf(orderDate);
    orderYear = TimestampHelper.getYearFromTimestamp(t);
    orderDay = TimestampHelper.getDayFromTimestamp(t);
    orderMonth = TimestampHelper.getMonthFromTimestamp(t);

  } 
   
  // construct the string representation of the vector.
  // It should be like: ["10051", "10201", "3074457345616676718"], 
  // instead of [10051, 10201, 3074457345616676718]. 
  // The latter will cause JS to initiate it as an integer array, 
  // then lose precision when the integer is very big.
  StringBuffer vendorsListVector = new StringBuffer("[");
  for (int k=0; k<vecVendorId.size(); k++) {
    if (k>0) {
      vendorsListVector.append(", ");
    }
    vendorsListVector.append("\"" + vecVendorId.get(k) + "\"");
  }
  vendorsListVector.append("]");

%>   
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT>

var status = "<%=UIUtil.toJavaScript(status)%>";
//alertDialog(status);

if (status == "change") {
   if (top.getData("orderYear") == null) {
     top.saveData("<%= orderYear %>", "orderYear");
   }
   if (top.getData("orderMonth") == null) {
     top.saveData("<%= orderMonth %>", "orderMonth");
   }
   if (top.getData("orderDay") == null) {
     top.saveData("<%= orderDay %>", "orderDay");
   }
   if (top.getData("vendorId") == null) {
     top.saveData("<%=vendorId%>", "vendorId");
   }

   if (top.getData("externalId") == null) {
     var exId = "<%=UIUtil.toJavaScript(externalId) %>";
     top.saveData(exId, "externalId");
   }

}


function init()
{
  document.wizard1.YEAR1.value = getCurrentYear();
  document.wizard1.MONTH1.value = getCurrentMonth();
  document.wizard1.DAY1.value = getCurrentDay();
}

function setupDate()
{
  window.yearField = document.wizard1.YEAR1;
  window.monthField = document.wizard1.MONTH1;
  window.dayField = document.wizard1.DAY1;
}


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
 
  var validOrderDate = parent.get("validOrderDate");
  if ( validOrderDate != null ) {
    if ( validOrderDate == "false"){
      parent.put("validOrderDate", "null");
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidDate"))%>');
      document.wizard1.YEAR1.select();
      document.wizard1.YEAR1.focus();
    }
  }

  var validExternalId = parent.get("validExternalId");
  if ( validExternalId != null ) {
    if ( validExternalId == "false"){
      parent.put("validExternalId", "null");
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("externalIdExceedMaxLength"))%>');
    }
  }

  var year = top.getData("orderYear");
  if(year != null) {
    document.wizard1.YEAR1.value = year;
  }

  var month = top.getData("orderMonth");
  if(month != null) {
    document.wizard1.MONTH1.value = month;
  }

  var day = top.getData("orderDay");
  if(day != null) {
    document.wizard1.DAY1.value = day;
  }
  
  var externalId = top.getData("externalId");
  if (externalId != null) {
    document.wizard1.externalId.value = externalId;
  }
  
  if (status != "change") {
    var vendorIndex2= top.getData("vendorIndex");
    if (vendorIndex2 != null) {
      document.wizard1.vendorId.value = vendorIndex2;
    }
  }
  
  if (<%= numberOfvendors %> < 1){
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("noVendors"))%>');
    top.goBack();
  }
  
  parent.setContentFrameLoaded(true);
  
}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function validatePanelData()
{

  if ( !isValidPositiveInteger(document.wizard1.YEAR1.value)) {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidDate"))%>');
    document.wizard1.YEAR1.select();
    document.wizard1.YEAR1.focus();
    return false;
  }

  if (!validDate(document.wizard1.YEAR1.value , document.wizard1.MONTH1.value, document.wizard1.DAY1.value)){
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidDate"))%>');
    document.wizard1.YEAR1.select();
    document.wizard1.YEAR1.focus();
    return false;
  }

  if (!isValidUTF8length( document.wizard1.externalId.value, 20)) {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("externalIdExceedMaxLength"))%>');
    document.wizard1.externalId.select();
    document.wizard1.externalId.focus();
    return false;
  }

  return true;
}


function savePanelData()
{
   top.saveData(document.wizard1.YEAR1.value, "orderYear");
   top.saveData(document.wizard1.MONTH1.value, "orderMonth");
   top.saveData(document.wizard1.DAY1.value, "orderDay");
   var orderDate = document.wizard1.YEAR1.value + '-' + document.wizard1.MONTH1.value + '-' + document.wizard1.DAY1.value + ' 00:00:00.0'; 
   top.saveData(orderDate , "orderDate");
   top.saveData(document.wizard1.externalId.value, "externalId");
   
  if (status != "change") {
     var vendorIndex = document.wizard1.vendorId.value;
     
     var vecVendorId = new Array();
     var vecVendorName = new Array();
     vecVendorId = <%= vendorsListVector %>;
     vecVendorName = '<%= vecVendorName  %>';
     vendorId = vecVendorId[vendorIndex];
     var vendorName = vecVendorName[vendorIndex];
     top.saveData(vendorId, "vendorId");
  }
   top.saveData(vendorIndex, "vendorIndex");
   
   top.saveData(vendorName, "vendorName");
   
   parent.put("raId", "<%=UIUtil.toJavaScript(VendorPOId)%>");
   //parent.put("vendorId", "<%=vendorId%>");
   
   if (parent.get("addedSize") == null) {
     parent.put("addedSize", "0");
   }
   
   if (parent.get("removedSize") == null) {
     parent.put("removedSize", "0");
   }
   
   if (parent.get("changedSize") == null) {
     parent.put("changedSize", "0");
   }
   
   parent.put("orderDate", orderDate);
   parent.put("externalId", trim(document.wizard1.externalId.value));
   
   //alertDialog(parent.get("vendorId"));
   
   if (status != null){
     top.saveData(status, "status");
   }
 

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

<script language="javascript"><!-- alert("VendorWizardHeader.jsp"); --></script> 

<SCRIPT FOR=document EVENT="onclick()">
document.all.CalFrame.style.display="none";
</SCRIPT>
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp"></IFRAME>

<H1><%= UIUtil.toHTML((String)inventoryNLS.get("VendorPOHeaderHeading")) %></H1>


<FORM NAME="wizard1">
<table border=0 summary="<%=UIUtil.toHTML((String)inventoryNLS.get("PurchaseOrderTableSumWizardHeader"))%>">

<!-- <LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">  removed due to invalid location-->
<TR>
    <TD>
<p>    
<BngIdR>

<SCRIPT>
//alertDialog('<%=UIUtil.toJavaScript(status)%>');
</SCRIPT>


<%

 if (!status.equalsIgnoreCase("change")) {
     out.println("<TABLE border=0 cellspacing=0 cellpadding=0>");
     out.println("<TR>");
     out.println("<TD>");
     out.println("<LABEL for ='vendorlb'>"+UIUtil.toHTML((String)inventoryNLS.get("purchaseOrderVendor"))+"</LABEL>");
     out.println("</TD>");
     out.println("</TR>");
     out.println("<TR>");
     out.println("<TD>");
     out.println("<SELECT NAME=vendorId ID='vendorlb' width='100%'>");
     int firstTime = 1;
     for (int i=0; i< numberOfvendors ; i++) {
       vendorName = (String) vecVendorDisplayName.elementAt(i);
       out.println("<OPTION value=" + i);
         if (firstTime == 1) {
           out.println("SELECTED");
         }
       out.println(">");
       out.print(UIUtil.toHTML(vendorName));
       out.println("</OPTION>");
       firstTime = 0;
     }
     out.println("</SELECT>");  // ??? you may want to remove this line
     out.println("</TD>");
     out.println("</TR>");
     out.println("</TABLE>");
   } else {
     out.println("<TABLE border=0 cellspacing=0 cellpadding=0>");
     out.println("<TR>");
     out.println("<TD>");
     out.println(UIUtil.toHTML((String)inventoryNLS.get("purchaseOrderVendor2")));
     out.println("<I>");
     out.println(UIUtil.toHTML(vendorName));
     out.println("</I>");
     out.println("</TD>");
     out.println("</TR>");
     out.println("</TABLE>");
     
   }
%>


<TABLE border=0 cellspacing=0 cellpadding=0>
  <TR>
    <TD><LABEL for="externalId"><%= UIUtil.toHTML((String)inventoryNLS.get("externalID")) %></LABEL></TD>
  </TR>
  <TR>
    <TD><INPUT TYPE=TEXT VALUE="" NAME=externalId ID="externalId" SIZE=60 maxlength="20"></TD>
  </TR>
</TABLE>

<P>
<TABLE border=0 cellspacing=0 cellpadding=0>
  <TR>
      <TD colspan=2><LABEL><%= UIUtil.toHTML((String)inventoryNLS.get("purchaseOrderDateRequired")) %></LABEL></TD>
  </TR>
  
  <TR>
    <TD width=25></TD>
    <TD>
       <TABLE border=0 cellspacing=0 cellpadding=0>
         <TR>
           <TD><LABEL for="YEAR1"><%= UIUtil.toHTML((String)inventoryNLS.get("year")) %></LABEL></TD>
           <TD>&nbsp;</TD>
           <TD><LABEL for="MONTH1"><%= UIUtil.toHTML((String)inventoryNLS.get("month")) %></LABEL></TD>
           <TD>&nbsp;</TD>
           <TD><LABEL for="DAY1"><%= UIUtil.toHTML((String)inventoryNLS.get("day")) %></LABEL></TD>
         </TR>
         <TR>
           <TD ><INPUT TYPE=TEXT VALUE="" NAME=YEAR1 ID="YEAR1" SIZE=4 MAXLENGTH=4></TD>
           <TD></TD><TD ><INPUT TYPE=TEXT VALUE="" NAME=MONTH1 ID="MONTH1" SIZE=2 MAXLENGTH=2></TD>
           <TD></TD><TD><INPUT TYPE=TEXT VALUE="" NAME=DAY1 ID="DAY1" SIZE=2 MAXLENGTH=2></TD>
           <TD>&nbsp;</TD>
           <TD><A HREF="javascript:setupDate();showCalendar(document.wizard1.calImg)">
             <IMG SRC="/wcs/images/tools/calendar/calendar.gif" ALT="<%=inventoryNLS.get("chooseDate")%>" BORDER=0 id=calImg></A></TD>   
         </TR>
       </TABLE>
     </TD>
  </TR>
</TABLE>

  </TD>
</TR>
</TABLE>

</FORM>
</BODY>
</HTML>