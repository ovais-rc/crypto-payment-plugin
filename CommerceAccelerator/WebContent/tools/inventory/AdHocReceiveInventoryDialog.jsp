<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

			
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
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Locale" %>
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
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.ItemInventoryDataBean" %>
<%@ page import="com.ibm.commerce.inventory.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="vendorList" scope="request" class="com.ibm.commerce.inventory.beans.VendorListDataBean">
</jsp:useBean>

<jsp:useBean id="invAvailable" scope="request" class="com.ibm.commerce.inventory.beans.ItemInventoryListDataBean">
</jsp:useBean>

<%
response.setContentType("text/html;charset=UTF-8");
CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = commandContext.getLocale();
Hashtable resources = (Hashtable) ResourceDirectory.lookup("inventory.VendorPurchaseNLS", locale);
Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);

String tooBig = "no";

String strFfmcenterId = UIUtil.getFulfillmentCenterId(request);

Integer langId = commandContext.getLanguageId();
String strLangId = langId.toString();

Integer storeId = commandContext.getStoreId();
String strStoreId = storeId.toString();

StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(storeId);

// get the supported currencies for a store
CurrencyManager cm = CurrencyManager.getInstance();
String[] supportedCurrencies = cm.getSupportedCurrencies( storeAB );


VendorDataBean vendors[] = null;
int numberOfvendors = 0;



String struOM = request.getParameter("uOM");
String strVendorId = request.getParameter("vendorId");
String strRaDetailId = request.getParameter("raDetailId");
String strItemSpcId = request.getParameter("itemSpcId");
String q   ;
/////////////////////////////
invAvailable.setFulfillmentCenterId(strFfmcenterId);
invAvailable.setStoreId(strStoreId);
invAvailable.setItemSpcId(strItemSpcId);

ItemInventoryDataBean quantityAvail[] = null;
int numberOfRows = 0;

try{
    DataBeanManager.activate(invAvailable, request);
    } catch(Exception e) {
      tooBig = "yes";   
    } 
    if (tooBig.equals("no")) {
          quantityAvail = invAvailable.getItemInventoryList();
    }
    q = (String)"0";

    if (quantityAvail != null){
      numberOfRows = quantityAvail.length;
      ItemInventoryDataBean quantityFFC ;
      for (int i = 0 ; i < numberOfRows; i++){
        quantityFFC = quantityAvail[i]; 
        q = quantityFFC.getQtyAvailable();
      }
    }
////////////////////////////////
    vendorList.setLanguageId(strLangId);
    vendorList.setStoreentId(strStoreId);

    DataBeanManager.activate(vendorList, request);
    vendors = vendorList.getVendorList();

    if (vendors != null){
      numberOfvendors = vendors.length;
    }

    Vector vecVendorId = new Vector();
    Vector vecVendorDisplayName = new Vector();
    Vector vecVendorName = new Vector();
    VendorDataBean vendor;

    for (int i=0; i < numberOfvendors ; i++)
    {
      vendor = vendors[i];

      String vendorId = vendor.getVendorId();
      String vendorDisplayName = vendor.getVendorName();
      String vendorName = "\"" + vendor.getVendorName() + "\"";
      if (vendorName == null)
      {
        vendorName = vendorId;
      }
      vecVendorId.addElement("\""+vendorId + "\"");
      vecVendorDisplayName.addElement(vendorDisplayName);
      vecVendorName.addElement(vendorName);
    }


%>

<HTML>

<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">


<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>


<SCRIPT>
var formatedQuantity;
formatedQuantity = parent.formatInteger(<%= q %>, "<%=strLangId%>");

var checkCalc = "no";

function trimQuantity(){
document.receiveForm.QTYRECEIVING.value=trim(document.receiveForm.QTYRECEIVING.value);

}

var validateFlag = false;

function beforeActivate() {
	validateFlag = true;
}

function beforeDeactivate() {
	validateFlag = false;
}

function validateTotalCost() {
	if(validateFlag == true) {
		totalCost();
	} 
}

function totalCost()
{

var quantity = trim(document.receiveForm.QTYRECEIVING.value);
var newQuantity = quantity;
var cost=trim(document.receiveForm.UNITCOST.value);

if (quantity > 2147483647){ // Validate the largest value <%= q %>
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("QuantityLimit"))%>');
  document.receiveForm.QTYRECEIVING.select();
  document.receiveForm.QTYRECEIVING.focus();
  return false;
}


var available = parent.strToInteger(<%= q %>,  "<%=strLangId%>");

quantity = parent.strToInteger(quantity,  "<%=strLangId%>");
var maximum = 0;
maximum = quantity + available;

if (maximum > 2147483647){ // Validate the largest value <%= q %>
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("QuantityLimitation"))%>');
  document.receiveForm.QTYRECEIVING.select();
  document.receiveForm.QTYRECEIVING.focus();
  return false;
}


if ( !isValidPositiveInteger(newQuantity)|newQuantity==0){ // Validate positive quantity
   
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidQuantity"))%>');
  document.receiveForm.QTYRECEIVING.select();
  document.receiveForm.QTYRECEIVING.focus();
  return false;
}



if (cost < 0|cost>99999999999){ // Validate Unit Cost
  
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidUnitCost"))%>');
  document.receiveForm.UNITCOST.select();
  document.receiveForm.UNITCOST.focus();
  return false;
}



if ( !parent.isValidCurrency(cost, document.receiveForm.Currency.value, "<%=strLangId%>")){ //Validate applicable Currency
   
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidUnitCost"))%>');
  document.receiveForm.UNITCOST.select();
  document.receiveForm.UNITCOST.focus();
  return false;
}



var convertedCost = parent.currencyToNumber(cost, document.receiveForm.Currency.value, "<%=strLangId%>");


var total;

total = newQuantity * convertedCost;

total = round(total,2);
total = parent.numberToCurrency(total, document.receiveForm.Currency.value, "<%=strLangId%>");
document.all.RECEIVINGCOST.innerHTML=total;


if (document.all.RECEIVINGCOST.innerHTML == "NaN"){

document.all.RECEIVINGCOST.innerHTML="";


      alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidTotalCost"))%>');
      document.receiveForm.QTYRECEIVING.value = "";
      document.receiveForm.UNITCOST.value = "";
      document.receiveForm.QTYRECEIVING.focus();
     
 }
checkCalc = "yes";
 

}



function savePanelData()
{

var vendorIndex = document.receiveForm.vendorId.value;
var currency = document.receiveForm.Currency.value;
var vecVendorId = new Array();
vecVendorId = <%= vecVendorId %>;
vendorId = vecVendorId[vendorIndex];

var qtyReceived = document.receiveForm.QTYRECEIVING.value;
var receivingCost = document.all.RECEIVINGCOST.innerText;
var unitCost = parent.currencyToNumber(document.receiveForm.UNITCOST.value, document.receiveForm.Currency.value, "<%=strLangId%>");
var rctComments = document.receiveForm.RCTCOMMENTS.value;
var qtyComments = document.receiveForm.QTYCOMMENTS.value;
var storeId = '<%=strStoreId%>';
var languageId = '<%=strLangId%>';
var ffmcenterId = '<%=strFfmcenterId%>';
var itemSpcId = '<%=UIUtil.toJavaScript(strItemSpcId)%>';
var receiptDate = document.receiveForm.YEAR1.value + '-' + document.receiveForm.MONTH1.value + '-' + document.receiveForm.DAY1.value + ' 00:00:00.000'; 


parent.put("qtyReceived",qtyReceived);
parent.put("cost",unitCost);

parent.put("comment2",qtyComments);
parent.put("vendorId",vendorId);
parent.put("storeId",storeId);
parent.put("languageId",languageId);
parent.put("ffmcenterId",ffmcenterId);
parent.put("comment1",rctComments);
parent.put("receiptDate",receiptDate);
parent.put("itemspcId",itemSpcId);
parent.put("currency",currency);
}

function currArray()
{

	var currArray = new Array();
	<% int a=0;
	while (a < supportedCurrencies.length) 
	{%>
		currArray[<%=a%>] = "<%=supportedCurrencies[a]%>";
		<%a++;
	}%>


	parent.put("storeCurrArray", currArray);
	
}

function loadDiscCurr()
{
	var storeCurrs = parent.get("storeCurrArray");

	for(var a=0; a<storeCurrs.length; a++)
	{
		document.receiveForm.Currency.options[a] = new Option(storeCurrs[a], storeCurrs[a], false, false);
	}
}

function setupDate()
{
  window.yearField = document.receiveForm.YEAR1;
  window.monthField = document.receiveForm.MONTH1;
  window.dayField = document.receiveForm.DAY1;
}


function validatePanelData(){

document.receiveForm.QTYRECEIVING.value = trim(document.receiveForm.QTYRECEIVING.value);
document.receiveForm.UNITCOST.value=trim(document.receiveForm.UNITCOST.value);

var quantity = trim(document.receiveForm.QTYRECEIVING.value);
var newQuantity = quantity;
var cost=trim(document.receiveForm.UNITCOST.value);



if (quantity > 2147483647){ // Validate the largest value <%= q %>
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("QuantityLimit"))%>');
  document.receiveForm.QTYRECEIVING.select();
  document.receiveForm.QTYRECEIVING.focus();
  return false;
}


var available = parent.strToInteger(<%= q %>,  "<%=strLangId%>");

quantity = parent.strToInteger(quantity,  "<%=strLangId%>");
var maximum = 0;
maximum = quantity + available;

if (maximum > 2147483647){ // Validate the largest value <%= q %>
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("QuantityLimitation"))%>');
  document.receiveForm.QTYRECEIVING.select();
  document.receiveForm.QTYRECEIVING.focus();
  return false;
}



  if ( !isValidPositiveInteger(newQuantity)|newQuantity==0){ // Validate positive quantity
   
    alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidQuantity"))%>');
    document.receiveForm.QTYRECEIVING.value = "";
    document.receiveForm.QTYRECEIVING.select();
    document.receiveForm.QTYRECEIVING.focus();
    return false;
}

if ( !parent.isValidCurrency(cost, document.receiveForm.Currency.value, "<%=strLangId%>")){ //Validate applicable Currency
   
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidUnitCost"))%>');
  document.receiveForm.UNITCOST.select();
  document.receiveForm.UNITCOST.focus();
  return false;
}


if (cost < 0){ // Validate Unit Cost
   
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidUnitCost"))%>');
  document.receiveForm.UNITCOST.select();
  document.receiveForm.UNITCOST.focus();
  return false;
}

if (quantity > 2147483647){ // Validate the largest value
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("quantityOrderedExceed"))%>');
  document.receiveForm.QTYRECEIVING.select();
  document.receiveForm.QTYRECEIVING.focus();
  return false;
}  



 
//OTHER VALIDATIONS

  if (!validDate(document.receiveForm.YEAR1.value , document.receiveForm.MONTH1.value, document.receiveForm.DAY1.value))
    {
      
      alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidDate"))%>');
      document.receiveForm.YEAR1.select();
      document.receiveForm.YEAR1.focus();
      return false;
    }
  
  if ( !isValidPositiveInteger(document.receiveForm.YEAR1.value)) {
      alertDialog('<%=UIUtil.toJavaScript((String)resources.get("invalidDate"))%>');
      document.receiveForm.YEAR1.select();
      document.receiveForm.YEAR1.focus();
      return false;
  }
  

     var rctcomments = document.receiveForm.RCTCOMMENTS.value;
     if ( !isValidUTF8length( rctcomments, 254 )) 
     { 
       alertDialog('<%=UIUtil.toJavaScript((String)resources.get("commentExceedMaxLength"))%>');
       document.receiveForm.RCTCOMMENTS.select();
       document.receiveForm.RCTCOMMENTS.focus();
       return false;
     }
     
     var qtycomments = document.receiveForm.QTYCOMMENTS.value;
     if ( !isValidUTF8length( qtycomments, 254 )) 
     { 
       alertDialog('<%=UIUtil.toJavaScript((String)resources.get("commentExceedMaxLength"))%>');
       document.receiveForm.QTYCOMMENTS.select();
       document.receiveForm.QTYCOMMENTS.focus();
       return false;
  }
    return true;  
}

function cancel () {
  var answer = parent.confirmDialog('<%=UIUtil.toJavaScript((String)resources.get("standardCancelConfirmation"))%>');
 
  if (answer) top.goBack();
  
}

function loadPanelData()
{
var tooBig;
tooBig = "<%= tooBig %>";
if (tooBig == "yes"){
 alertDialog('<%=UIUtil.toJavaScript((String)resources.get("noReceive"))%>');
 top.goBack();
}

  currArray();
  loadDiscCurr();
  
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
   
   {
       var vendorIndex2= top.getData("vendorIndex");
       if (vendorIndex2 != null) {
       document.receiveForm.vendorId.value = vendorIndex2;
       parent.setContentFrameLoaded(true);
   } 
}
   
}
</SCRIPT>
</HEAD>

<BODY ONLOAD="loadPanelData();" class="content" onbeforeactivate ="beforeActivate()" onbeforedeactivate="beforeDeactivate()">
<SCRIPT FOR=document EVENT="onclick()">
document.all.CalFrame.style.display="none";

</SCRIPT>

<script language="javascript"><!--alert("AdHocReceiveInventoryDialog.jsp");--></script> 

<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 NORESIZE FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp"></IFRAME>

<H1><%= UIUtil.toHTML((String)resources.get("adhocInventory")) %></H1>


<FORM NAME="receiveForm" >
<LABEL><%= UIUtil.toHTML((String)resources.get("dateRequired")) %></LABEL>
<TABLE>
         <TR>
           <TD><LABEL for="YEAR2"><%= UIUtil.toHTML((String)resources.get("year")) %></LABEL></TD>
           <TD>&nbsp;</TD>
           <TD><LABEL for="MONTH2"><%= UIUtil.toHTML((String)resources.get("month")) %></LABEL></TD>
           <TD>&nbsp;</TD>
           <TD><LABEL for="DAY2"><%= UIUtil.toHTML((String)resources.get("day")) %></LABEL></TD>
         </TR>
         <TR>
           <TD ><INPUT TYPE=TEXT VALUE="" NAME=YEAR1 ID="YEAR2" SIZE=4 maxlength=4></TD>
           <TD></TD><TD ><INPUT TYPE=TEXT VALUE="" NAME=MONTH1 ID="MONTH2" SIZE=2 maxlength=2></TD>
           <TD></TD><TD><INPUT TYPE=TEXT VALUE="" NAME=DAY1 ID="DAY2" SIZE=2 maxlength=2></TD>
           <TD>&nbsp;</TD>
           <TD><A HREF="javascript:setupDate();showCalendar(document.receiveForm.calImg)">
             <IMG SRC="/wcs/images/tools/calendar/calendar.gif" ALT="<%=resources.get("chooseDate")%>" BORDER=0 id=calImg></A></TD> 
         </TR>
</TABLE>

<TABLE>
    <TR>
      <TD><LABEL for="vendorlb"><%= UIUtil.toHTML((String)resources.get("purchaseOrderVendor")) %></LABEL></TD>
    </TR>

    <TR>
      <TD>
        <SELECT NAME=vendorId ID="vendorlb" >
<%
    int firstTime = 1;
    for (int i=0; i<numberOfvendors ; i++) {
      String vendorName = UIUtil.toHTML((String) vecVendorDisplayName.elementAt(i));
%>
      <OPTION value="<%= i %>"
<%
    if (firstTime == 1) {
%>
        SELECTED
<%
    }
%>
      >
      <%= vendorName %>
      </OPTION>
<%
    firstTime = 0;
    }
%>
        </SELECT>
      </TD>
    </TR>
</TABLE>

<LABEL for="Currency"><%= UIUtil.toHTML((String)resources.get("currency")) %></LABEL>  
<BR>
<SELECT NAME="Currency" ID="Currency"></SELECT>
<P>

<%= UIUtil.toHTML((String)resources.get("unitOfMeasure")) %>  <i><%=UIUtil.toHTML(struOM)%></i> 
<P>

<%= UIUtil.toHTML((String)resources.get("quantityAvailable")) %> <i>

<script>
document.write(formatedQuantity);
</script>
</i>
<P>

<LABEL for="QTYRECEIVING1"><%= UIUtil.toHTML((String)resources.get("receivingQty")) %></LABEL>
<BR>
<INPUT TYPE = TEXT VALUE = "" NAME=QTYRECEIVING ID="QTYRECEIVING1" SIZE=10  maxlength=10 onBlur="trimQuantity()"/>
<P>

<LABEL for="UNITCOST1"><%= UIUtil.toHTML((String)resources.get("unitCost")) %></LABEL>
<BR>
<INPUT TYPE = TEXT VALUE = "" NAME=UNITCOST ID="UNITCOST1" SIZE=15 maxlength=13 onBlur="validateTotalCost()"/>
<P>

<%= UIUtil.toHTML((String)resources.get("receivingQtyCost")) %> <i><SPAN id=RECEIVINGCOST></SPAN></i>
<P>

<LABEL for="RCTCOMMENTS"><%= UIUtil.toHTML((String)resources.get("Comment1")) %></LABEL>
<BR>
<TEXTAREA NAME= RCTCOMMENTS ID=RCTCOMMENTS ROWS="2" COLS="50">
</TEXTAREA>
</BR>

<LABEL for="QTYCOMMENTS"><%= UIUtil.toHTML((String)resources.get("Comment2")) %></LABEL>
</BR>
<TEXTAREA NAME= QTYCOMMENTS ID=QTYCOMMENTS ROWS="2" COLS="50">
</TEXTAREA>
</BR>

</FORM>

</BODY>

</HTML>
