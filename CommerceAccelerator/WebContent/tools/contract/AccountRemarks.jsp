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
import="com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.tools.contract.beans.ContractDataBean,
   com.ibm.commerce.tools.contract.beans.AccountDataBean,
   com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>
<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("accountRemarksTitle") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">

function loadPanelData()
{
  with (document.remarksForm)
  {
    if (parent.setContentFrameLoaded)
    {
      parent.setContentFrameLoaded(true);
    }

    if (parent.get)
    {
      var hereBefore = parent.get("AccountRemarksModelLoaded", null);
      if (hereBefore != null)
      {
         //alert('Remarks - back to same page - load from model');
         // have been to this page before - load from the model
         var o = parent.get("AccountRemarksModel", null);
         if (o != null)
         {
            Remarks.value = o.remarks;
         }

      }
      else
      {
   // this is the first time on this page
   //alert('Remarks - first time on page');

        // create the model
        var arm = new Object();
   arm.remarks = "";

        parent.put("AccountRemarksModel", arm);
   parent.put("AccountRemarksModelLoaded", true);

   // check if this is an update
   if (<%= foundAccountId %> == true)
   {
      //alert('Load from the databean');
      // load the data from the databean
            <%
            // Create an instance of the databean to use if we are doing an update
            if (foundAccountId)
            {
               AccountDataBean account = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
               DataBeanManager.activate(account, request);
      %>
               Remarks.value = decodeNewLines('<%= UIUtil.toJavaScript((String)account.getAccountRemarks()) %>');
      <%
            }
           %>
   }
      }

      // handle error messages back from the validate page
      if (parent.get("remarksTooLong", false))
      {
        parent.remove("remarksTooLong");
        alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountRemarksTooLong"))%>");
      }
      Remarks.focus();
    }
  }
}

function savePanelData()
{
  //alert ('Remarks savePanelData');
  with (document.remarksForm)
  {
    if (parent.get)
    {
      var o = parent.get("AccountRemarksModel", null);
      if (o != null)
      {
         o.remarks = Remarks.value;
      }
    }
  }
}


</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("accountRemarksTitle") %></h1>

<form NAME="remarksForm" id="remarksForm">

<p><label for="AccountRemarksPanel_FormInput_Remarks_In_remarksForm_1"><%= contractsRB.get("notebookRemarks") %></label><br>
<textarea NAME="Remarks" id="AccountRemarksPanel_FormInput_Remarks_In_remarksForm_1" ROWS="20" COLS="70" WRAP=physical onKeyDown="limitTextArea(this.form.Remarks,4000);" onKeyUp="limitTextArea(this.form.Remarks,4000);">
</textarea>

</form>
</body>
</html>


