<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
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
<%@ page import="com.ibm.commerce.inventory.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>

<%@ include file="../common/common.jsp" %>


<%
response.setContentType("text/html;charset=UTF-8");
CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = commandContext.getLocale();
Hashtable resources = (Hashtable) ResourceDirectory.lookup("inventory.VendorPurchaseNLS", locale);
Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);

Integer langId = commandContext.getLanguageId();
String strLangId = langId.toString();

Integer storeId = commandContext.getStoreId();
String strStoreId = storeId.toString();

StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(storeId);

// get the supported currencies for a store
CurrencyManager cm = CurrencyManager.getInstance();
String[] supportedCurrencies = cm.getSupportedCurrencies( storeAB );

String struOM = request.getParameter("uOM");
String strVendorId = request.getParameter("vendorId");
String strFfmcenterId = request.getParameter("ffmcenterId");
String strRaDetailId = request.getParameter("raDetailId");
String strItemSpcId = request.getParameter("itemSpcId");
String strReceived = request.getParameter("received");


%>

<HTML>

<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>

<SCRIPT>



function trimQuantity(){
document.receiveForm.QTYRECEIVING.value=trim(document.receiveForm.QTYRECEIVING.value);

}


function totalCost()
{

var quantity = trim(document.receiveForm.QTYRECEIVING.value);
var newQuantity = quantity;
var cost=trim(document.receiveForm.UNITCOST.value);

if (quantity > 2147483647){ // Validate the largest value
  alertDialog('<%=UIUtil.toJavaScript((String)resources.get("QuantityLimit"))%>');
  document.receiveForm.QTYRECEIVING.select();
  document.receiveForm.QTYRECEIVING.focus();
  return false;
}

var received = parent.strToInteger(<%=(strReceived == null ? null : UIUtil.toJavaScript(strReceived))%>,  "<%=strLangId%>");

quantity = parent.strToInteger(quantity,  "<%=strLangId%>");
var maximum = 0;
maximum = quantity + received;

if (maximum > 2147483647){ 
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
  
}


function savePanelData()
{
var currency = document.receiveForm.Currency.value;
var qtyReceived = document.receiveForm.QTYRECEIVING.value;
var receivingCost = document.all.RECEIVINGCOST.innerText;
var unitCost = parent.currencyToNumber(document.receiveForm.UNITCOST.value, document.receiveForm.Currency.value, "<%=strLangId%>");
var rctComments = document.receiveForm.RCTCOMMENTS.value;
var qtyComments = document.receiveForm.QTYCOMMENTS.value;
var vendorId = '<%=UIUtil.toJavaScript(strVendorId)%>';
var storeId = '<%=strStoreId%>';
var languageId = '<%=strLangId%>';
var ffmcenterId = '<%=UIUtil.toJavaScript(strFfmcenterId)%>';
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
 
var received = parent.strToInteger(<%=(strReceived == null ? null : UIUtil.toJavaScript(strReceived))%>,  "<%=strLangId%>");

quantity = parent.strToInteger(quantity,  "<%=strLangId%>");
var maximum = 0;
maximum = quantity + received;

if (maximum > 2147483647){ 
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

  if (!validDate(document.receiveForm.YEAR1.value , document.receiveForm.MONTH1.value, document.receiveForm.DAY1.value)){
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
  var answer = confirmDialog('<%=UIUtil.toJavaScript((String)resources.get("standardCancelConfirmation"))%>');
  if (answer) top.goBack();
  
}

function loadPanelData()
  
 {
  

  currArray();
  loadDiscCurr();
  
  if (parent.setContentFrameLoaded)
   {
    parent.setContentFrameLoaded(true);
   }
 }
</SCRIPT>
</HEAD>

<BODY ONLOAD="loadPanelData();" class="content">
<SCRIPT FOR=document EVENT="onclick()">
document.all.CalFrame.style.display="none";
</SCRIPT>

<script language="javascript"><!--alert("POReceiveInventoryDialog.jsp");--></script> 

<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="<%= calendarNLS.get("calendarTitle") %>" MARGINHEIGHT=0 MARGINWIDTH=0 FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/tools/servlet/tools/common/Calendar.jsp"></IFRAME>

<H1><%= UIUtil.toHTML((String)resources.get("receivingInventoryFor")) %></H1>
<FORM NAME="receiveForm" >
<LABEL><%= UIUtil.toHTML((String)resources.get("dateRequired")) %></LABEL>
<TABLE>
         <TR>
           <TD><LABEL for="YEAR1"><%= UIUtil.toHTML((String)resources.get("year")) %></LABEL></TD>
           <TD>&nbsp;</TD>
           <TD><LABEL for="MONTH1"><%= UIUtil.toHTML((String)resources.get("month")) %></LABEL></TD>
           <TD>&nbsp;</TD>
           <TD><LABEL for="DAY1"><%= UIUtil.toHTML((String)resources.get("day")) %></LABEL></TD>
         </TR>
         <TR>
           <TD><INPUT TYPE=TEXT VALUE="" NAME=YEAR1 ID="YEAR1" SIZE=4 maxlength=4></TD>
           <TD></TD>
           <TD><INPUT TYPE=TEXT VALUE="" NAME=MONTH1 ID="MONTH1" SIZE=2 maxlength=2></TD>
           <TD></TD>
           <TD><INPUT TYPE=TEXT VALUE="" NAME=DAY1 ID="DAY1" SIZE=2 maxlength=2></TD>
           <TD>&nbsp;</TD>
           <TD><A HREF="javascript:setupDate();showCalendar(document.receiveForm.calImg)">
             <IMG SRC="/wcs/images/tools/calendar/calendar.gif" ALT="<%=resources.get("chooseDate")%>" BORDER=0 id=calImg></A></TD>   
         </TR>
</TABLE>


<LABEL for="Currency"><%= UIUtil.toHTML((String)resources.get("currency")) %></LABEL>  
<BR>
<SELECT NAME="Currency" ID="Currency"></SELECT>
<P>
<%= UIUtil.toHTML((String)resources.get("unitOfMeasure")) %>  <i><%=UIUtil.toHTML(struOM)%></i> 
<P>
<LABEL for="QTYRECEIVING"><%= UIUtil.toHTML((String)resources.get("receivingQty")) %></LABEL>
<BR>
<INPUT TYPE = TEXT VALUE = "" NAME=QTYRECEIVING ID="QTYRECEIVING" SIZE=10  maxlength=10 onBlur="trimQuantity()"/>
<P>

<LABEL for="UNITCOST"><%= UIUtil.toHTML((String)resources.get("unitCost")) %></LABEL>
<BR>
<INPUT TYPE = TEXT VALUE = "" NAME=UNITCOST ID="UNITCOST" SIZE=15 maxlength=13 onBlur="totalCost()"/>
<P>

<%= UIUtil.toHTML((String)resources.get("receivingQtyCost")) %> <i><SPAN id=RECEIVINGCOST></SPAN></i>
<P>

<LABEL for="RCTCOMMENTS"><%= UIUtil.toHTML((String)resources.get("Comment1")) %></LABEL>
<BR>
<TEXTAREA NAME= RCTCOMMENTS ID=RCTCOMMENTS ROWS="2" COLS="50">
</TEXTAREA>


<LABEL for="QTYCOMMENTS"><%= UIUtil.toHTML((String)resources.get("Comment2")) %></LABEL>
<BR>
<TEXTAREA NAME= QTYCOMMENTS ID=QTYCOMMENTS ROWS="2" COLS="50">
</TEXTAREA>


</FORM>

</BODY>

</HTML>
