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
import="com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.tools.contract.beans.ContractDataBean" %>

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
 <style type='text/css'>
 .selectWidth {width: 400px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(contractCommandContext.getLocale()) %>" type="text/css">

 <title><%= contractsRB.get("contractDocumentationPanelPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">



function loadPanelData()
 {
  with (document.documentationForm)
   {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }

    if (parent.get)
     {
      var hereBefore = parent.get("ContractDocumentationModelLoaded", null);
      if (hereBefore != null) {
   //alert('Documentation - back to same page - load from model');
   // have been to this page before - load from the model
        var o = parent.get("ContractDocumentationModel", null);
   if (o != null) {
      loadSelectValues(SelectedDocumentation, o.selectedDocumentation);
   }

     } else {
   // this is the first time on this page
   //alert('Documentation - first time on page');

   // create the model
        var cbm = new ContractDocumentationModel();
        parent.put("ContractDocumentationModel", cbm);
   parent.put("ContractDocumentationModelLoaded", true);

   // check if this is an update
   if (<%= foundContractId %> == true) {
      //alert('Load from the databean');
      // load the data from the databean
      <%
      // Create an instance of the databean to use if we are doing an update
      if (foundContractId) {
         ContractDataBean cdb = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
         DataBeanManager.activate(cdb, request);
         out.println("var docArray = new Array();");
         Vector docs = cdb.getContractAttachments();
         for (int index = 0; index < docs.size(); index++) {
            out.println("docArray[docArray.length] = \"" + UIUtil.toJavaScript((String)docs.elementAt(index)) + "\";");
            out.println("cbm.contractDocumentation[cbm.contractDocumentation.length] = \"" + UIUtil.toJavaScript((String)docs.elementAt(index)) + "\";");
         }
         out.println("loadSelectValues(SelectedDocumentation, docArray);");
      }
      %>
   }
     }

      document.documentationForm.DocName.focus();
      setButtonContext(SelectedDocumentation, removeButton);
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
   myFormNames[0]  = "documentationForm";
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
  //alert ('Documentation savePanelData');
  with (document.documentationForm)
   {
    if (parent.get)
     {
        var o = parent.get("ContractDocumentationModel", null);
        if (o != null) {
      o.selectedDocumentation = getSelectValues(SelectedDocumentation);
        }
     }
   }
 }

  // validate the sku when add to the list
  function validateAddDocument(s) {
     if (isEmpty(s)) {
         return false;
     }
     // make sure the name will not be duplicate
     var inputName = trim(s);
     for (var i = 0; i < document.documentationForm.SelectedDocumentation.options.length; i++) {
        var name = document.documentationForm.SelectedDocumentation.options[i];
      if (inputName == name.value)
         return false;
     }
     if (!isValidUTF8length(s, 254))
     {
       alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractDocumentationTooLong"))%>");
       return false;
     }
     return true;
  }

  function addDocumentation() {
      var inputName = trim(document.documentationForm.DocName.value);
      if (validateAddDocument(inputName)) {
          var nextOptionIndex = document.documentationForm.SelectedDocumentation.options.length;
          document.documentationForm.SelectedDocumentation.options[nextOptionIndex] = new Option(inputName, // name
                                                                                      inputName, // value
                                                                                      false,    // defaultSelected
                                                                                      false);   // selected
      }
      document.documentationForm.DocName.value = "";
      document.documentationForm.DocName.focus();
  }

  function removeDocumentation(selectedMultiselect) {
    // remember the deleted ones
    var o = parent.get("ContractDocumentationModel", null);
    if (o != null) {
       for(var i = selectedMultiselect.options.length - 1; i >= 0; i--) {
          if (selectedMultiselect.options[i].selected && selectedMultiselect.options[i].value != "") {
                var deleteIndex = o.deletedDocumentation.length;
      o.deletedDocumentation[deleteIndex] = selectedMultiselect.options[i].value;
                selectedMultiselect.options[i] = null;  // remove the selection from the list
          }
       }
   }
   setButtonContext(selectedMultiselect, document.documentationForm.removeButton);
  }

function keydown(name,selectedMultiselect)
{
   // press 'Enter' is equal to click on 'Add' button
   if(event.keyCode==13 && name == "DocName")
   {
      addDocumentation();
      event.returnValue=false;
   }
   // press 'Del' is equal to click on 'Remove' button
   else if(event.keyCode==46 && name == "SelectedDocumentation")
   {
      removeDocumentation(selectedMultiselect);
      event.returnValue=false;
   }
}


</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractDocumentationPanelPrompt") %></h1>

<form NAME="documentationForm" id="documentationForm">

<%= contractsRB.get("contractDocumentationText") %>
<p>
  <table id="ContractDocumentationPanel_Table_1">
  <tr>
    <td valign="top" id="ContractDocumentationPanel_TableCell_1">
       <label for="ContractDocumentationPanel_FormInput_DocName_In_documentationForm_1"><%= contractsRB.get("contractDocumentationName") %></label><br>
   <input class='selectWidth' NAME="DocName" TYPE="TEXT" size=30 maxlength=254 onkeydown="keydown('DocName');" id="ContractDocumentationPanel_FormInput_DocName_In_documentationForm_1">
    </td>
    <td valign="top" width=100px id="ContractDocumentationPanel_TableCell_2">
       <br>
       <button type='BUTTON' value='AddDocumentation' name='addButton' CLASS=enabled onClick='addDocumentation();'><%= contractsRB.get("addnoelipsis") %></button>
    </td>
    </tr>
    <tr></tr>
    <tr>
      <td id="ContractDocumentationPanel_TableCell_3">
       <label for="ContractDocumentationPanel_FormInput_SelectedDocumentation_In_documentationForm_1"><%= contractsRB.get("contractDocumentationSelected") %></label><br>
       <select name="SelectedDocumentation" id="ContractDocumentationPanel_FormInput_SelectedDocumentation_In_documentationForm_1" class='selectWidth' multiple size=10 onkeydown="keydown('SelectedDocumentation',this.form.SelectedDocumentation);" onChange="setButtonContext(this.form.SelectedDocumentation, this.form.removeButton);">
       </select>
      </td>
      <td valign="top" width=100px id="ContractDocumentationPanel_TableCell_4">
   <br>
       <button type='BUTTON' value='RemoveDocumentation' name='removeButton' CLASS=enabled onClick='removeDocumentation(this.form.SelectedDocumentation);'><%= contractsRB.get("remove") %></button>
     </td>
  </tr>
  </table>

</form>
</body>
</html>


