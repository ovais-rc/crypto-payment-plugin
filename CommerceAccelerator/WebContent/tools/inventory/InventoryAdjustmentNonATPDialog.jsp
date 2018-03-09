<!--   
// BR updated 20020321 - 1620
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
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
<%@ page import="com.ibm.commerce.inventory.beans.InventoryAdjustmentCodeDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.ItemInventoryDataBean" %>
<%@ page import="com.ibm.commerce.inventory.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ include file= "../common/common.jsp" %>



<%
 try {
   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   
   Locale jLocale = cmdContext.getLocale();
     Hashtable inventoryNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("inventory.VendorPurchaseNLS", jLocale);
   
   String jLanguageID = cmdContext.getLanguageId().toString();
    Integer langId = cmdContext.getLanguageId();
   java.util.Hashtable itemResource = (java.util.Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
%>

<% 
   // get parameters from URL
  
   String catEntryRefNum = request.getParameter("catEntryId"); 

   Integer storeId = cmdContext.getStoreId();
  
  String ffcId = UIUtil.getFulfillmentCenterId(request);
   
   // activate inventory
   InventoryAccessBean inventory = new InventoryAccessBean();
   String qtty = "";
   String flags = "";
   try{
   		inventory.setInitKey_catalogEntryId(catEntryRefNum);
		inventory.setInitKey_fulfillmentCenterId(ffcId);
		inventory.setInitKey_storeId(storeId.toString());
   
		qtty = inventory.getQuantity();
   		flags = inventory.getInventoryFlags();
   }catch (Exception e)
         {
           qtty = "0";
         }
         int flagUpdate = 1;
   int flagCheck = 1;
   if(flags.equals("0")){
          flagUpdate = 1;
          flagCheck = 1;
   }else  if (flags.equals("1")) {
          flagUpdate = 0;
          flagCheck = 1;
   } else if (flags.equals("2")) {
          flagUpdate = 1;
          flagCheck = 0;
   } else if (flags.equals("3")) {
        flagUpdate = flagCheck = 0;
   }
%>



 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
 <HEAD>
 <%= fHeader%>

<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
 <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
 <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
 <SCRIPT SRC="/wcs/javascript/tools/common/NumberFormat.js"></SCRIPT>


<TITLE><%=UIUtil.toHTML((String)itemResource.get("inventoryTitle"))%></TITLE>
 
 <SCRIPT>

var incDec;
var confirm ;
var quantity ;
var qtyAvailable;
function clickfocus(rowName){
    if (rowName == "INCREASE"){
      document.inventory.invUpdateValue.value = '';
      document.inventory.invUpdateMode[0].focus();
      
    }else if (rowName == "DECREASE"){
      document.inventory.invUpdateValue.value = '';
      document.inventory.invUpdateMode[1].focus();
    }
  }
function validatePanelData(){ //start validatePanelData
  
    qtyAvailable = <%= qtty %>;
    qtyAvailable = strToInteger(qtyAvailable,"<%=langId%>");
    var quantityStr = quantity ;
    quantity =  strToInteger(quantity,  "<%=langId%>");
   var remaining = qtyAvailable + quantity;      
     var minInt = - 2147483648 ;
   minInt = strToInteger(minInt,   "<%=langId%>");
    var maxInt = 2147483647 ;
    maxInt = strToInteger(maxInt,   "<%=langId%>");
     var isInc = document.inventory.invUpdateMode[0].checked;
     var isDec = document.inventory.invUpdateMode[1].checked;
    if (!isValidNumber(quantity, "<%=langId%>", true)) {
      if(isInc == true || isDec == true){
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
      if (incDec == "INC"){
        document.inventory.invUpdateMode[0].focus();
      }else{
        document.inventory.invUpdateMode[1].focus();
      }        
      return false;
     }else{
         return true;
     }    
    }else{
       //check to see if - amount is more than quantity available
      if (!isValidNumber(quantity, "<%=langId%>", false)) {
         if (incDec == "INC"){
          alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
          document.inventory.invUpdateMode[1].focus();
          return false;
        }
         if ( remaining < 0 ){
          alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount2"))%>');
          if (incDec == "INC"){
            document.inventory.invUpdateMode[0].focus();
          }else{
            document.inventory.invUpdateMode[1].focus();
          } 
          return false;
        }
        if ( quantity < minInt ){
          alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityAdjustExceedMin"))%>');
          if (incDec == "INC"){
                 document.inventory.invUpdateMode[0].focus();
          }else{
         document.inventory.invUpdateMode[1].focus();
          } 
          return false;
        } 
      } 
    } 
    var plus = "+" ;
    if (quantityStr.indexOf(plus) != -1){ 
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
      if (incDec == "INC"){
         document.inventory.invUpdateMode[0].focus();
      }else{
       document.inventory.invUpdateMode[1].focus();
      } 
      return false;
    }
    if (quantity == 0 ){
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityZero"))%>');
      if (incDec == "INC"){
         document.inventory.invUpdateMode[0].focus();
      }else{
     document.inventory.invUpdateMode[1].focus();
      } 
      return false;
    }  
      if ( quantity > maxInt ){
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("QuantityAdjustLimit"))%>');
      if (incDec == "INC"){
          document.inventory.invUpdateMode[0].focus();
      }else{
          document.inventory.invUpdateMode[1].focus();
      } 
      return false;
    }
    if ( remaining > maxInt ){
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("QuantityAdjustLimitation"))%>');
      if (incDec == "INC"){
       document.inventory.invUpdateMode[0].focus();
      }else{
     document.inventory.invUpdateMode[1].focus();
      } 
      return false;
    }
   
    answer = confirmDialog(confirm);
    if (answer == false) {
        if(incDec == "INC"){
      document.inventory.invUpdateMode[0].focus();
        }else{
       document.inventory.invUpdateMode[1].focus();
        }        
        return false;  
     }
    
    return true;
  } //end validatePanelData
function savePanelData() {

 var ffcId = <%=ffcId%>;
 
 
  if (   document.inventory.invUpdateMode[0].checked){
      quantity = trim(document.inventory.invUpdateValue.value);
      incDec = "INC";
   	  confirm = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("increaseQuantityMessage")) %>';
    }else if (   document.inventory.invUpdateMode[1].checked){
      quantity = '-';
      quantity = quantity + trim(document.inventory.invUpdateValue.value);
       incDec = "DEC";
      confirm = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("decreaseQuantityMessage")) %>';
    }
    var flagUpdate ;
    var flagCheck ;
    if (document.inventory.flagUpdate.checked == true) {
        flagUpdate = "1";
    } else {
        flagUpdate = "0";
    }

    if (document.inventory.flagCheck.checked == true) {
        flagCheck = "1";
    } else {
        flagCheck = "0";
    }   
    parent.put("flagUpdate",flagUpdate);
    parent.put("flagCheck",flagCheck);
  
  
    parent.put("ffmcenterId",ffcId);
   	parent.put("catEntryId","<%=UIUtil.toJavaScript(catEntryRefNum)%>");
    parent.put("quantity",quantity);
    parent.put("storeId",<%=storeId%>);
    }

function initForm() {
 
    parent.setContentFrameLoaded(true);
}   


function cancel () {
    var answer = parent.confirmDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("standardCancelConfirmation"))%>');
    return answer ;
  }


</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY ONLOAD="initForm()" CLASS=content>
<%@include file="../common/NumberFormat.jsp" %>
<H1><%=UIUtil.toHTML((String)itemResource.get("inventoryTitle"))%></H1>
 <script language="javascript"><!--- alert("InventoryAdjustmentDialog.jsp"); --></script> 

<BR>
<FORM name="inventory">
   
<TABLE COLS=1 WIDTH="100%" >
<TR>
<TD><%=UIUtil.toHTML((String)itemResource.get("currentInventory"))%>   <I><SCRIPT>document.writeln(parent.numberToStr("<%=qtty%>","<%=langId%>", null))</SCRIPT></I></TD> 
</TR>

<TR>
<TD><BR><%=UIUtil.toHTML((String)itemResource.get("invPrompt"))%></TD>
</TR>
<TR>
<TD></TD>
</TR>


<TR>
<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="RADIO"  NAME="invUpdateMode"  VALUE="increment" id="increment" onClick='clickfocus("INCREASE")'> <label for="increment"> <%=UIUtil.toHTML((String)itemResource.get("increment"))%></label>&nbsp;&nbsp;
</TD>
</TR>

<TR>
<TD></TD>
</TR>

<TR>
<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="RADIO" NAME="invUpdateMode"  VALUE="decrement" id="decrement"  onClick='clickfocus("DECREASE")'> <label for="decrement"> <%=UIUtil.toHTML((String)itemResource.get("decrement"))%></label>&nbsp;&nbsp;
</TD>
</TR>

<TR>
<TD></TD>
</TR>

<TR>
<TD><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT size="15" maxlength="30" type="text"  name="invUpdateValue" value="" id="invUpdateValue" ><label for="invUpdateValue"></label></TD>
</TR>


<TR>
<TD><BR></TD>
</TR>
<TR>
<TD><BR><%=UIUtil.toHTML((String)itemResource.get("flagTitle"))%><BR></TD>
</TR>
<TR>
    <TD colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       <%
        if(flagUpdate==1){
        %>
         <INPUT type="checkbox" name="flagUpdate" checked="checked" id="flagUpdate">  <label for="flagUpdate"> <%=UIUtil.toHTML((String)itemResource.get("flagUpdate"))%></label><BR>
       <%
       }
       else{
       %>
  <INPUT type="checkbox" name="flagUpdate"  id="flagUpdate">  <label for="flagUpdate"> <%=UIUtil.toHTML((String)itemResource.get("flagUpdate"))%></label><BR>
       <%
       }
       %>
    </TD>
</TR>
<TR>
    <TD colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
     <%
        if(flagCheck==1){
        %>
        <INPUT type="checkbox" name="flagCheck" checked="checked" id="flagCheck">  <label for="flagCheck"> <%=UIUtil.toHTML((String)itemResource.get("flagCheck"))%></label></TD>
 <%
       }
       else{
       %>
         <INPUT type="checkbox" name="flagCheck"  id="flagCheck">  <label for="flagCheck"> <%=UIUtil.toHTML((String)itemResource.get("flagCheck"))%></label></TD>
<%
       }
       %>
</TR>


</TABLE>

 
</FORM>
 
<%
}
catch (Exception e) 
{
    com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e); 
}

%>

</BODY>
</HTML>
