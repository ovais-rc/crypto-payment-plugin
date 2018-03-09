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
<%@page language="java" import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.contract.util.ContractCmdUtil" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   String contractUsage = null;
   String stateParm = null;
   try {
     contractUsage = contractCommandContext.getRequestProperties().getString("contractUsage");
     stateParm = contractCommandContext.getRequestProperties().getString("state");
   } catch (Exception e) {
   	contractUsage = null;
   	stateParm = null;
   }
   
   	String contractExportTitle = "";
   	Integer usage = new Integer(contractUsage);
	if(ContractCmdUtil.isDelegationGridContract(usage) ){ 
		contractExportTitle = (String) contractsRB.get ("delegationGridExportTitle");
	}
	else { 
		contractExportTitle = (String) contractsRB.get ("contractExportTitle");
	}	   	
%>

<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractExportTitle %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">
function getSuccessMessageNLText(){
   if ("<%=contractUsage%>" == "6")
   	return "<%=UIUtil.toJavaScript((String)contractsRB.get("delegationGridExportSuccessConfirmation"))%>";
   else 
   	return "<%=UIUtil.toJavaScript((String)contractsRB.get("contractExportSuccessConfirmation"))%>";
}
 
function loadPanelData()
 {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }
    if (parent.get("contractExists", false))
     {
      parent.remove("contractExists");
      if ("<%=contractUsage%>" == "6")
      	alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridExists"))%>");
      else
      	alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractExists"))%>");      
     }
    else if (parent.get("contractGenericError", false))
     {
      parent.remove("contractGenericError");
      if ("<%=contractUsage%>" == "6")      
          alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridNotExported"))%>");
      else
          alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractNotExported"))%>");          
     }

    document.exportForm.name.focus();
 }

function getContractId()
{
	return "<%=UIUtil.toHTML(contractId)%>";
}

function getLanguageId()
{
	return "<%=fLanguageId%>";
}

function getContractUsage()
{
	return "<%=contractUsage%>";
}

function getState()
{
	return "<%=UIUtil.toHTML(stateParm)%>";
}

function getAccountId()
{
	return "<%=UIUtil.toHTML(accountId)%>";
}

function validatePanelData()
{
  if (!document.exportForm.name.value)
   {
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("fileNameRequired"))%>");
      document.exportForm.name.focus();
      return false;
   }
  else if (!isValidUTF8length(document.exportForm.name.value, 200))
   {
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("fileNameTooLong"))%>");
      document.exportForm.name.focus();
      return false;
   }
  else if (!isValidFileName(document.exportForm.name.value))
   {
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractSearchInvalidCharMsg"))%>");
      document.exportForm.name.focus();
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

<h1><%= contractExportTitle %></h1>

<form NAME="exportForm" id="exportForm">

<p><label for="ContractExportPanel_FormInput_name_In_exportForm_1"><%= contractsRB.get("contractExportLabel") %></label><br>
<input NAME="name" TYPE="TEXT" size=30 maxlength=200 onkeydown="keydown();" id="ContractExportPanel_FormInput_name_In_exportForm_1"><br>
<br>
<!-- function currently not required
<INPUT type=checkbox name=exportAll><%= contractsRB.get("exportAllDates") %>
-->

</form>
</body>
</html>


