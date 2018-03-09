<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2013
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
   com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
   //----------------------------------------------------------------
   // CONTRACT LOCK HELPER
   // STEP 1 (Specify TC Type ID)
   //
   // After including the ContractCommon.jsp file, please include
   // the following code segment before including the JSP file
   // ContractTCLockCommon.jspf, and change the myContractTCTypeID
   // accordingly.
   //----------------------------------------------------------------
   Integer myContractTCTypeID = new Integer(com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_GENERAL_OTHERS_PAGES);
   request.setAttribute("com.ibm.commerce.contract.util.CONTRACT_TCTYPE_ID", myContractTCTypeID);
%>


<%--
   //----------------------------------------------------------------
   // CONTRACT LOCK HELPER
   // STEP 2 (Manage & Renew Lock)
   //
   // Include the JSP file ContractTCLockCommon.jspf which will
   // perform the checking of the terms and conditions lock for
   // the previously specified contract TC type ID. If necessary,
   // it will renew the lock on the TC for the current logon user.
   // The checking will only be performed in contract change mode.
   //----------------------------------------------------------------
--%>
<%@include file="ContractTCLockCommon.jspf" %>





<html>

<head>
 <%= fHeader %>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractRemarksTitle") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
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
      var hereBefore = parent.get("ContractRemarksModelLoaded", null);
      if (hereBefore != null) {
   //alert('Remarks - back to same page - load from model');
   // have been to this page before - load from the model
        var o = parent.get("ContractRemarksModel", null);
   if (o != null) {
      Remarks.value = o.remarks;
   }

     } else {
   // this is the first time on this page
   //alert('Remarks - first time on page');

   // create the model
        var crm = new Object();
   crm.remarks = "";

        parent.put("ContractRemarksModel", crm);
   parent.put("ContractRemarksModelLoaded", true);

   // check if this is an update
   if (<%= foundContractId %> == true) {
      //alert('Load from the databean');
      // load the data from the databean
      <%
      // Create an instance of the databean to use if we are doing an update
      if (foundContractId) {
         ContractDataBean contract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
         DataBeanManager.activate(contract, request);
      %>
               Remarks.value = decodeNewLines('<%= UIUtil.toJavaScript((String)contract.getContractComment()) %>');
      <%
      }
      %>
   } else {
   }

     }

    // handle error messages back from the validate page
    if (parent.get("remarksTooLong", false))
     {
      parent.remove("remarksTooLong");
      var cgm = parent.get("ContractGeneralModel");
      if (cgm != null && cgm.usage == "DelegationGrid") {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("delegationGridRemarksTooLong"))%>");
      } else {
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("remarksTooLong"))%>");
      }
     }
     Remarks.focus();

    }
   }

<%--
   //----------------------------------------------------------------
   // CONTRACT LOCK HELPER
   // STEP 3 (Handling Lock Status)
   //
   // The handlTCLockStatus function will take care of the locking
   // status for the terms and conditions. According to the status
   // and system configuration, it will display various dialogs
   // to the end user. Before invoking the handleTCLockStatus()
   // function, some parameters are required. Please refer to the
   // ContractTCLockCommon.jspf for details.
   //----------------------------------------------------------------
--%>
   var myFormNames = new Array();
   myFormNames[0]  = "remarksForm";
   var contractCommonDataModel = parent.get("ContractCommonDataModel", null);

   handleTCLockStatus("GeneralOthersPages",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_OtherPages")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockPages")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockPagesPrompt")) %>",
                      myFormNames,
                      6);
 }

function savePanelData()
 {
  //alert ('Remarks savePanelData');
  with (document.remarksForm)
   {
    if (parent.get)
     {
        var o = parent.get("ContractRemarksModel", null);
        if (o != null) {
            o.remarks = Remarks.value;
        }
     }
   }
 }


</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("notebookRemarks") %></h1>

<form NAME="remarksForm" id="remarksForm">

<p><label for="ContractRemarks_FormInput_Remarks_In_remarksForm_1"><%= contractsRB.get("notebookRemarks") %></label><br>
<textarea id="ContractRemarks_FormInput_Remarks_In_remarksForm_1" NAME="Remarks" ROWS="20" COLS="70" WRAP=physical onKeyDown="limitTextArea(this.form.Remarks,4000);" onKeyUp="limitTextArea(this.form.Remarks,4000);">
</textarea>

</form>
</body>
</html>


