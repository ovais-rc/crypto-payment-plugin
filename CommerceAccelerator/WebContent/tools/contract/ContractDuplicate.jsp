<!--==========================================================================
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
//*
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil,
	com.ibm.commerce.contract.util.ContractCmdUtil" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   String targetStoreId = null;
   try {
     targetStoreId = contractCommandContext.getRequestProperties().getString("targetStoreId");
     if (targetStoreId != null && targetStoreId.length() == 0) {
      targetStoreId = null;
     }
   } catch (Exception e) {
   }
   
   //get contract Usage parameter
   String usageParm = request.getParameter("contractUsage");
   if(usageParm == null){
      usageParm = "1";
   }
   Integer usage = new Integer(usageParm);
   
   String existMsg = (String)contractsRB.get("contractExists");
   String genericMsg = (String)contractsRB.get("contractGenericActionError");
   String nameRequired = (String)contractsRB.get("contractNameRequired");
   String tooLong = (String)contractsRB.get("contractNameTooLong");
   String title = (String)contractsRB.get("contractDuplicateTitle");
   String label = (String) contractsRB.get("contractDuplicateLabel");
   
   if(ContractCmdUtil.isDelegationGridContract(usage)) {
    existMsg = (String)contractsRB.get("delegationGridExists");
    nameRequired = (String)contractsRB.get("delegationGridNameRequired");
    tooLong = (String)contractsRB.get("delegationGridNameTooLong");
    title = (String)contractsRB.get("delegationGridDuplicateTitle");
    label = (String) contractsRB.get("delegationGridDuplicateLabel");   
   }
%>

<% if (targetStoreId == null) { // DUPLICATE %>
<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= title %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

 <script LANGUAGE="JavaScript">
function loadPanelData()
 {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
    if (parent.get("contractExists", false))
     {
      parent.remove("contractExists");
      alertDialog("<%= UIUtil.toJavaScript(existMsg)%>");
     }
    else if (parent.get("contractGenericError", false))
     {
      parent.remove("contractGenericError");
      alertDialog("<%= UIUtil.toJavaScript(genericMsg)%>");
     }

    document.duplicateForm.name.focus();
 }

function getContractId()
{
   return "<%=contractId%>";
}

function validatePanelData()
{
  if (!document.duplicateForm.name.value)
   {
      alertDialog("<%= UIUtil.toJavaScript(nameRequired)%>");
      document.duplicateForm.name.focus();
      return false;
   }
  else if (!isValidUTF8length(document.duplicateForm.name.value, 200))
   {
      alertDialog("<%= UIUtil.toJavaScript(tooLong)%>");
      document.duplicateForm.name.focus();
      return false;
   }
  return true;
}

function keydown()
{
   if(event.keyCode==13)
   {
      event.returnValue=false;
   }
}

</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= title %></h1>

<form NAME="duplicateForm" id="duplicateForm">

<p><label for="ContractDuplicate_FormInput_name_In_duplicateForm_1"><%= label %></label><br>
<input NAME="name" TYPE="TEXT" size=30 maxlength=200 onkeydown="keydown();" id="ContractDuplicate_FormInput_name_In_duplicateForm_1">

</form>
</body>
</html>
<% } else { // DEPLOY %>

<jsp:useBean id="storeLang" scope="request" class="com.ibm.commerce.tools.common.ui.StoreLanguageBean">
</jsp:useBean>

<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractDeployTitle") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

 <script LANGUAGE="JavaScript">
function loadPanelData()
 {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
    if (parent.get("contractDeployAlreadyError", false))
     {
      parent.remove("contractDeployAlreadyError");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractDeployAlreadyError"))%>");
     }
    else if (parent.get("contractDeployPolicyError", false))
     {
      parent.remove("contractDeployPolicyError");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractDeployPolicyError"))%>");
     }
    else if (parent.get("contractGenericError", false))
     {
      parent.remove("contractGenericError");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractNotSaved"))%>");
     }

    //document.duplicateForm.name.focus();
 }

<%
storeLang.Init(contractCommandContext);
storeLang.getStoresJS("stores", out);
%>

function getContractId()
{
   return "<%=contractId%>";
}

function getAccountId()
{
   return "<%=accountId%>";
}

function getTargetStoreId()
{
   return "<%=targetStoreId%>";
}

function validatePanelData()
{
// one must be selected
  if (document.deployForm.Store.selectedIndex == -1)
   {
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractDeployChooseError"))%>");
      return false;
   }
  return true;
}

function keydown()
{
   if(event.keyCode==13)
   {
      event.returnValue=false;
   }
}

</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractDeployTitle") %></h1>

<form NAME="deployForm" id="deployForm">

<p><label for="ContractDuplicate_FormInput_Store_In_deployForm_1"><%= contractsRB.get("contractDeployLabel") %></label><br>
<select NAME="Store" id="ContractDuplicate_FormInput_Store_In_deployForm_1" SIZE=10 width=100%>
<script>
for (var x=0; x<stores.length; x++) {
   if (stores[x].storeId != getTargetStoreId() ) {
      document.write("<OPTION value='" + stores[x].storeId + "' ");
      document.write(">" + stores[x].name + "</OPTION>");
   }
}

</script>
</select>


</form>
</body>
</html>
<% } %>

