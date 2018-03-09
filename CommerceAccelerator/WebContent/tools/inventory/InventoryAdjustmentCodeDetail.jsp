<!--      
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
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
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.inventory.objects.*" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>

<%@ include file= "../common/common.jsp" %>

<jsp:useBean id="InventoryAdjustmentCode" scope="request"
	class="com.ibm.commerce.inventory.beans.InventoryAdjustmentCodeDataBean">
</jsp:useBean>


<%
CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();

// obtain the resource bundle for display
Hashtable inventoryNLS = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup( "inventory.VendorPurchaseNLS", locale);

Integer store_id = cmdContext.getStoreId();
String storeId = store_id.toString();

Integer langId = cmdContext.getLanguageId();
String strLangId = langId.toString();

String invAdjCode = "";
String invAdjCodeDesc = "";
JSPHelper jspHelper = new JSPHelper(request);
String status = jspHelper.getParameter("status");
status = UIUtil.toHTML(status);
if (!status.equalsIgnoreCase("change")){
	status = "new";
}
String invAdjCodeId = jspHelper.getParameter("invAdjCodeId");

if (status.equalsIgnoreCase("change")) {
    
    //get invAdjCode corresponding to invAdjCodeId
	InventoryAdjustmentCode.setInvAdjCodeId(invAdjCodeId);
    InventoryAdjustmentCode.populate() ;
	invAdjCode = InventoryAdjustmentCode.getAdjustCode();
	if (invAdjCode == null) {
        invAdjCode = "";
    }
    
    //get invAdjCodeDesc corresponding to invAdjCodeId
    try {
	    InventoryAdjustmentCodeDescriptionAccessBean abInventoryAdjustmentCodeDescription = new InventoryAdjustmentCodeDescriptionAccessBean();
    	abInventoryAdjustmentCodeDescription.setInitKey_invAdjCodeId(invAdjCodeId);
		abInventoryAdjustmentCodeDescription.setInitKey_languageId(strLangId);
	    invAdjCodeDesc = abInventoryAdjustmentCodeDescription.getDescription();
	    if (invAdjCodeDesc == null) {
	        invAdjCodeDesc = "";
        }
    } catch (Exception e) {
        invAdjCodeDesc = "";
    }

}

//StoreAccessBean sa = cmdContext.getStore();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<%=fHeader%>
<LINK rel="stylesheet" href="<%=UIUtil.getCSSFile(locale)%>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>

var status = '<%=status%>';

if (status == "change") {
     parent.put("invAdjCodeId", "<%=UIUtil.toJavaScript(invAdjCodeId)%>");
     parent.put("invAdjCode","<%=UIUtil.toJavaScript(invAdjCode)%>");
     parent.put("invAdjCodeDesc","<%=UIUtil.toJavaScript(invAdjCodeDesc)%>");
}   

function initializeState()
{ 
  document.dialog1.id.value = '<%=UIUtil.toJavaScript(invAdjCodeId)%>';
  document.dialog1.name.value = '<%=UIUtil.toJavaScript(invAdjCode)%>';
  document.dialog1.description.value = '<%=UIUtil.toJavaScript(invAdjCodeDesc)%>';
  if (parent.setContentFrameLoaded){
    parent.setContentFrameLoaded(true);
  }
}

function isValidAdjCodName(myString) {
    var invalidChars = "~!@#$%^&*()+=[]{};:,<>?/|`"; // invalid chars
    invalidChars += "\t\'\"\\"; // escape sequences
    invalidChars += "0123456789";
    invalidChars += "abcdefghijklmnopqrstuvwxyz";

    // if the string is empty it is not a valid name
    if (isEmpty(myString)) return false;
    
    // if the string length not 4, it is not a valid name
    if(myString.length != 4) return false;
    
    // look for presence of invalid characters.  if one is
    // found return false.  otherwise return true
    for (var i=0; i<myString.length; i++) {
      if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
        return false;
      }
    }
    return true;
}

function validatePanelData()
{
  var validName = document.dialog1.name.value;
  if (!isValidAdjCodName(validName)){
    alertDialog('<%=UIUtil.toJavaScript((String) inventoryNLS.get("invalidInventoryAdjustmentCodeName"))%>');
    document.dialog1.name.select();
    document.dialog1.name.focus();
    return false;
  }
  if ( !isValidUTF8length( validName, 4 )) {
    alertDialog('<%=UIUtil.toJavaScript((String) inventoryNLS.get("invalidInventoryAdjustmentCodeName"))%>');
    document.dialog1.name.select();
    document.dialog1.name.focus();
    return false;
  }
 
  var validDesc = document.dialog1.description.value;
  if (validDesc == "") {
    alertDialog('<%=UIUtil.toJavaScript((String) inventoryNLS.get("blankField"))%>');
    document.dialog1.description.select();
    document.dialog1.description.focus();
    return false;
  }
  if ( !isValidUTF8length( validDesc, 254 )) {
    alertDialog('<%=UIUtil.toJavaScript((String) inventoryNLS.get("inventoryAdjustmentCodeMaxChar"))%>');
    document.dialog1.description.select();
    document.dialog1.description.focus();
    return false;
  } 

  return true;
}

function savePanelData()
{
  parent.put("invAdjCode", trim(document.dialog1.name.value));
  parent.put("invAdjCodeDesc", trim(document.dialog1.description.value));

}

function cancel () 
{
  var answer = parent.confirmDialog('<%=UIUtil.toJavaScript(
	(String) inventoryNLS.get("VendorPurchaseCancelConfirmation"))%>');

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

(c)  Copyright  IBM Corp.  2000,2001      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="initializeState()" CLASS="content">

<script language="javascript"> <!-- alert("InventoryAdjustmentCodeDetail.jsp"); --> </script> 

<SCRIPT>
if (status == "change")  {
  document.writeln('<H1>');
  document.writeln('<%=UIUtil.toJavaScript((String) inventoryNLS.get("inventoryAdjustmentCodeDetailTitleChange"))%>');
  document.writeln('</H1>');
  document.writeln('<P>');
} else {
  document.writeln('<H1>');
  document.writeln('<%=UIUtil.toJavaScript((String) inventoryNLS.get("inventoryAdjustmentCodeDetailTitleNew"))%>');
  document.writeln('</H1>');
  document.writeln('<P>');
}                          
</SCRIPT>
<FORM NAME="dialog1">
<TABLE border=0 cellspacing=0 cellpadding=0>
	<TR>
		<TD><label for="name"><%=UIUtil.toHTML((String) inventoryNLS.get("inventoryAdjustmentCodeNameRequired"))%></label></TD>
	</TR>
	<TR>
		<TD><INPUT NAME=name id="name" size="10" type="text" maxlength="4"></TD>
	</TR>
</TABLE>
<P>


<TABLE border=0 cellspacing=0 cellpadding=0>
	<TR>
		<TD><label for="description"><%=UIUtil.toHTML((String) inventoryNLS.get("inventoryAdjustmentCodeDescriptionRequired"))%></label></TD>
	</TR>
	<TR>
		<TD><INPUT NAME=description ID="description" size="80" type="text" maxlength="254"></TD>
	</TR>
</TABLE>

<P>


</FORM>
</BODY>
</HTML>
