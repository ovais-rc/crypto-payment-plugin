<!--   
// BR updated 20020321 - 1620
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
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
   
  
         	
   String flagUpdate = "1";
   String flagCheck = "1";
  
           

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

   

var confirm = null;

function validatePanelData(){ //start validatePanelData
    confirm = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("increaseQuantityMessage")) %>';
    var quantity = document.inventory.invUpdateValue.value;
    var quantityStr = quantity ;
    quantity =  strToInteger(quantity,  "<%=langId%>");
    var minInt = - 2147483648 ;
   minInt = strToInteger(minInt,   "<%=langId%>");
    var maxInt = 2147483647 ;
    maxInt = strToInteger(maxInt,   "<%=langId%>");
   
    if (!isValidNumber(quantity, "<%=langId%>", true)) {
      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
       document.inventory.invUpdateValue.focus();
      return false;
    }else{
        if ( quantity < minInt ){
        	alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityAdjustExceedMin"))%>');
	        document.inventory.invUpdateValue.focus();
	        return false;
	    } 
	    var plus = "+" ;
	    if (quantityStr.indexOf(plus) != -1){ 
	      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("invalidAdjustmentAmount"))%>');
	      document.inventory.invUpdateValue.focus();
	      return false;
	    }
	    if (quantity == 0 ){
	      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("ZeroQuantity"))%>');
	      document.inventory.invUpdateValue.focus();
	      return false;
	    }  
	    if ( quantity > maxInt ){
	      alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("quantityAdjustExceedMax"))%>');
	      document.inventory.invUpdateValue.focus();
	      return false;
	    }
    }
    answer = confirmDialog(confirm);
	    if (answer == false) {
	    	document.inventory.invUpdateValue.focus();
	      	return false;
     	    }
    return true;
  } //end validatePanelData
function savePanelData() {

 var ffcId = <%=ffcId%>;

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
    var quantity = document.inventory.invUpdateValue.value;
    
    parent.put("ffmcenterId",ffcId);
   	parent.put("catEntryId","<%=UIUtil.toJavaScript(catEntryRefNum)%>");
    parent.put("qtyReceived",quantity);
    parent.put("storeId",<%=storeId%>);
    parent.put("flagUpdate",flagUpdate);
    parent.put("flagCheck",flagCheck);
  
   
}

function cancel () {
    var answer = parent.confirmDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("standardCancelConfirmation"))%>');
    return answer ;
  }



function onLoad(){
     if (parent.setContentFrameLoaded){
       parent.setContentFrameLoaded(true);
      
   }
}
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>
<BODY ONLOAD="onLoad();" CLASS="content">
<%@include file="../common/NumberFormat.jsp" %>
<H1><%=UIUtil.toHTML((String)itemResource.get("inventoryTitle"))%></H1>
 <script language="javascript"><!--- alert("InventoryAdjustmentDialog.jsp"); --></script> 

<BR>
<FORM name="inventory">
   
<TABLE COLS=1 WIDTH="100%" >

<TR>
<TD><BR><%=UIUtil.toHTML((String)itemResource.get("invPrompt"))%></TD>
</TR>
<TR>
<TD></TD>
</TR>

<TR>
<TD><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT size="15" maxlength="30" type="text"  name="invUpdateValue" id="invUpdateValue" value=""><label for="invUpdateValue"></label></TD>
</TR>

 
<TR>
<TD><BR></TD>
</TR>
<TR>
<TD><BR><%=UIUtil.toHTML((String)itemResource.get("flagTitle"))%><BR></TD>
</TR>
<TR>
    <TD colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         <INPUT type="checkbox" name="flagUpdate" id="flagUpdate"> <label for="flagUpdate"> <%=UIUtil.toHTML((String)itemResource.get("flagUpdate"))%></label><BR>
    </TD>
</TR>
<TR>
    <TD colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <INPUT type="checkbox" name="flagCheck" id="flagCheck"> <label for="flagCheck"> <%=UIUtil.toHTML((String)itemResource.get("flagCheck"))%></label><BR>
    </TD>
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
