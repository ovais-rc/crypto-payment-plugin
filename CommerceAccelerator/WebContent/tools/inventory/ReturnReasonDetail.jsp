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
<%@ page import="com.ibm.commerce.utils.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.*" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>

<%@ include file= "../common/common.jsp" %>

<jsp:useBean id="returnReasons" scope="request" class="com.ibm.commerce.ordermanagement.beans.ReturnReasonDataBean">
</jsp:useBean>


<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();

    // obtain the resource bundle for display
    Hashtable inventoryNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("inventory.VendorPurchaseNLS", locale);
    
    Integer store_id = cmdContext.getStoreId();
    String storeId = store_id.toString();

    Integer langId = cmdContext.getLanguageId();
    String strLangId = langId.toString();

    String rntRsnType = "";
    String rntRsnDesc = "";
    String rntRsnCode = "";

    
    String status = request.getParameter("status");

    String rsnId = request.getParameter("rtnRsnId");
    
    if (status.equalsIgnoreCase("change")) {
    
      returnReasons.setDataBeanKeyRtnReasonId(rsnId);
      
      DataBeanManager.activate(returnReasons, request);
      
      rntRsnType = returnReasons.getReasonType();
      rntRsnCode = returnReasons.getCode();
      if (rntRsnCode == null) {
        rntRsnCode = "";
      }
      
      ReturnReasonDescriptionAccessBean reasonDesc = new ReturnReasonDescriptionAccessBean();
      
      try {
        reasonDesc = returnReasons.getDescription(langId);
        rntRsnDesc = reasonDesc.getDescription();
	if (rntRsnDesc == null) {
	  rntRsnDesc = "";
        }
      } catch (Exception e) {
        rntRsnDesc = "";
      }

      
    }
    

   StoreAccessBean sa = cmdContext.getStore();
   String StoreType = sa.getStoreType();
   if (StoreType == null) {
     StoreType = "";
   }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>

var status = '<%=UIUtil.toJavaScript(status)%>';
//alert(status);
var testId = "";
var displayType = "";
var storeType = '<%=StoreType%>';


if (status == "change") {

     parent.put("reasonType","<%= rntRsnType %>");

     parent.put("rsnCode","<%= UIUtil.toJavaScript(rntRsnCode) %>");

     parent.put("rsnDesc","<%= UIUtil.toJavaScript(rntRsnDesc) %>");
   
     parent.put("rtnreasonId", "<%=UIUtil.toJavaScript(rsnId)%>");

     var rtnRsnType = parent.get("reasonType");
    
    
  if (rtnRsnType != null) {
    if(rtnRsnType == 'B') {
      displayType = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnBoth")) %>';
    }
    if(rtnRsnType == 'C') {
      displayType = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnCustomer")) %>';
    }
    if(rtnRsnType == 'M') {
      if (storeType == 'B2C' || storeType == 'RHS' || storeType == 'MHS') {
        displayType = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnMerchant")) %>';
      } else {
        displayType = '<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnSeller")) %>';
      }
    }
  }

  
}   


function initializeState()
{

    document.dialog1.name.value = '<%= UIUtil.toJavaScript(rntRsnCode) %>';

    document.dialog1.description.value = '<%= UIUtil.toJavaScript(rntRsnDesc) %>';


  if (parent.setContentFrameLoaded){
    parent.setContentFrameLoaded(true);
  }
}

function validatePanelData()
{

  var validName = document.dialog1.name.value;
  if (validName == "") {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("blankField"))%>');
    document.dialog1.name.select();
    document.dialog1.name.focus();
    return false;
  }
  if ( !isValidUTF8length( validName, 30 )) {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("reasonNameMaxChar"))%>');
    document.dialog1.name.select();
    document.dialog1.name.focus();
    return false;
  }
 
  var validDesc = document.dialog1.description.value;
  if (validDesc == "") {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("blankField"))%>');
    document.dialog1.description.select();
    document.dialog1.description.focus();
    return false;
  }
  if ( !isValidUTF8length( validDesc, 60 )) {
    alertDialog('<%=UIUtil.toJavaScript((String)inventoryNLS.get("reasonDescMaxChar"))%>');
    document.dialog1.description.select();
    document.dialog1.description.focus();
    return false;
  } 

  return true;
}

function savePanelData()
{

  parent.put("code", trim(document.dialog1.name.value));
  parent.put("description", trim(document.dialog1.description.value));
     
  if (status != "change") {
    if (document.dialog1.type.value == 'B' ) {
      parent.put("reasonType", "B");
    }
     
    if (document.dialog1.type.value == 'C') {
      parent.put("reasonType", "C");
    }
    
    if (document.dialog1.type.value == 'M') {
      parent.put("reasonType", "M");
    }
  }  
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

(c)  Copyright  IBM Corp.  2000,2001      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="initializeState()" CLASS="content">


<SCRIPT>
if (status == "change")  {
  document.writeln('<H1>');
  document.writeln('<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnReasonDetailTitleChange")) %>');
  document.writeln('</H1>');
  document.writeln('<P>');
  } else {
  document.writeln('<H1>');
  document.writeln('<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnReasonDetailTitleNew")) %>');
  document.writeln('</H1>');
  document.writeln('<P>');
}                          
</SCRIPT>  
<FORM NAME="dialog1">
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<TABLE border=0 cellspacing=0 cellpadding=0>
  <TR>
    <TD><label for="name"><%= UIUtil.toHTML((String)inventoryNLS.get("reasonNameRequired"))  %></label></TD>
  </TR>
  <TR>
    <TD><INPUT NAME=name ID="name" size="60" type="text" maxlength="30"></TD>
  </TR>
</TABLE>
<P> 
<TABLE border=0 cellspacing=0 cellpadding=0>
  <TR>
    <TD><label for="description"><%= UIUtil.toHTML((String)inventoryNLS.get("reasonDescriptionRequired"))%></label></TD>
  </TR>
  <TR>
    <TD><INPUT NAME=description ID="description" size="120" type="text" maxlength="60"></TD>
  </TR>
</TABLE>
<P>


<SCRIPT>
if (status == "change")  {
  document.writeln('<TR>');
    document.writeln('<TD>');
      document.writeln('<%= UIUtil.toJavaScript((String)inventoryNLS.get("reasonTypeChange")) %>');
      document.writeln('<I>');
      document.writeln(displayType);
      document.writeln('</I>');
    document.writeln('</TD>');
  document.writeln('</TR>');
}else{
  document.writeln('<TABLE border=0 cellspacing=0 cellpadding=0>');
    document.writeln('<TBODY>');
      document.writeln('<TR>');
        document.writeln('<TD>');
          document.writeln('<label for="type"><%= UIUtil.toJavaScript((String)inventoryNLS.get("reasonType")) %></label>');
        document.writeln('</TD>');
      document.writeln('</TR>');
      document.writeln('<TR>');
      document.writeln('<TD>');
      document.writeln('<SELECT size="1" name="type" id="type">');
        document.writeln('<OPTION value="B" >');
          document.writeln('<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnBoth")) %>');
          document.writeln('</OPTION>');
          document.writeln('<OPTION value="C" >');
            document.writeln('<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnCustomer")) %>');
          document.writeln('</OPTION>');
          
            if (storeType == 'B2C') {
              document.writeln('<OPTION value="M">');
              document.writeln('<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnMerchant")) %>');
            } else {
              document.writeln('<OPTION value="M">');
              document.writeln('<%= UIUtil.toJavaScript((String)inventoryNLS.get("returnSeller")) %>');            
            }
        document.writeln('</OPTION>');
      document.writeln('</SELECT>');
      document.writeln('</TD>');
      document.writeln('</TR>');
    document.writeln('</TBODY>');
  document.writeln('</TABLE>');
}
</SCRIPT>


</FORM>
</BODY>
</HTML>
