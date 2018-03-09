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
   com.ibm.commerce.command.CommandFactory,
   com.ibm.commerce.tools.contract.beans.ContractDataBean,
   com.ibm.commerce.user.beans.OrganizationDataBean,
   com.ibm.commerce.user.beans.OrgEntityDataBean,
   com.ibm.commerce.user.objects.MemberGroupAccessBean,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.AccountDataBean" %>

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
 .selectWidth {width: 300px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("contractBuyerPanelPrompt") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/SwapList.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>

 <script LANGUAGE="JavaScript">



function loadPanelData()
 {
  with (document.buyerForm)
   {
    if (parent.setContentFrameLoaded)
     {
      parent.setContentFrameLoaded(true);
     }

    if (parent.get)
     {
      var hereBefore = parent.get("ContractBuyerModelLoaded", null);
      if (hereBefore != null) {
   //alert('Buyer - back to same page - load from model');
   // have been to this page before - load from the model
        var o = parent.get("ContractBuyerModel", null);
   if (o != null) {
           loadTextValueSelectValues(SelectedBuyers, o.selectedBuyers);
         loadTextValueSelectValues(AvailableBuyers, o.availableBuyers);
                 loadTextValueSelectValues(SelectedMemberGroups, o.selectedMemberGroups);
         loadTextValueSelectValues(AvailableMemberGroups, o.availableMemberGroups);
   }

     } else {
   // this is the first time on this page
   //alert('Buyer - first time on page');

   // create the model
        var cbm = new ContractBuyerModel();
        parent.put("ContractBuyerModel", cbm);
   parent.put("ContractBuyerModelLoaded", true);

   // check if this is an update
   if (<%= foundContractId %> == true) {
      //alert('Load from the databean');
      // load the data from the databean
      <%
      // Create an instance of the databean to use if we are doing an update
      if (foundContractId) {
         ContractDataBean contract = new ContractDataBean(new Long(contractId), new Integer(fLanguageId));
         DataBeanManager.activate(contract, request);
         int buyerSize = contract.getBuyerName().size();
         for (int i = 0; i < buyerSize; i++) {
            out.println("SelectedBuyers.options[" + i + "] = new Option(\"" +
               UIUtil.toJavaScript(contract.getBuyerName(i)) + "\",\"" +
               contract.getBuyerNumber(i) + "\", false, false);");
            out.println("cbm.contractBuyers[" + i + "] = '" + contract.getBuyerNumber(i) + "';");
         }
         int mgrGrpSize = contract.getMemberGroupName().size();
         for (int i = 0; i < mgrGrpSize; i++) {
            out.println("SelectedMemberGroups.options[" + i + "] = new Option(\"" +
               UIUtil.toJavaScript(contract.getMemberGroupName(i)) + "\",\"" +
               contract.getMemberGroupId(i) + "\", false, false);");
            out.println("cbm.contractMemberGroups[" + i + "] = new Object();");
            out.println("cbm.contractMemberGroups[" + i + "].value = '" + contract.getMemberGroupId(i) + "';");
            out.println("cbm.contractMemberGroups[" + i + "].text = '" + UIUtil.toJavaScript(contract.getMemberGroupName(i)) + "';");
         }
      }
      %>
   }

   // initialize available buyers
   var count = 0;
   <%
    try {
      // get the customer
      AccountDataBean adb = new AccountDataBean(new Long(accountId), new Integer(fLanguageId));
      DataBeanManager.activate(adb, request);
      String customerId = adb.getCustomerId();

      // get the organization
      OrganizationDataBean orgEntityDB = new OrganizationDataBean();
      orgEntityDB.setDataBeanKeyMemberId(customerId);
      orgEntityDB.setCommandContext(contractCommandContext);
      orgEntityDB.populate();

      // get the customer's descendant organizations
      OrgEntityDataBean orgEntityDescendants = new OrgEntityDataBean();
      orgEntityDescendants.setDataBeanKeyMemberId(customerId);
      orgEntityDescendants.setCommandContext(contractCommandContext);
      orgEntityDescendants.populate();
      Long[] orgList = orgEntityDescendants.getDescendantOrgEntities();
   %>
      // add the customer to the available list
      if (!isInTextValueList(SelectedBuyers, "<%= UIUtil.toJavaScript(orgEntityDB.getDistinguishedName()) %>")) {
         AvailableBuyers.options[count++] = new Option("<%= UIUtil.toJavaScript(orgEntityDB.getOrganizationName()) %>", "<%= UIUtil.toJavaScript(orgEntityDB.getDistinguishedName()) %>", false, false);
      }
   <%
      // add the customer's descendant orgs to the available list
      for (int j = 0; j < orgList.length; j++) {
         Long orgId = orgList[j];
         OrganizationDataBean orgDB = new OrganizationDataBean();
         orgDB.setDataBeanKeyMemberId(orgId.toString());
         orgDB.setCommandContext(contractCommandContext);
         orgDB.populate();
         //DataBeanManager.activate(orgDB, request);
         if (!fStoreMemberId.equals(orgId.toString())) {
            out.println("if (!isInTextValueList(SelectedBuyers, \"" + UIUtil.toJavaScript(orgDB.getDistinguishedName()) + "\")) {");
            out.println("AvailableBuyers.options[count++] = new Option(\"" +
               UIUtil.toJavaScript(orgDB.getOrganizationName()) + "\",\"" +
               UIUtil.toJavaScript(orgDB.getDistinguishedName()) + "\", false, false);");
            out.println("}");
         }
      }
     } catch (Exception e)
      {
      }
    %>
   // initialize available member groups
   count = 0;
   <%
    try {
      Vector list = new MemberDataBean().getMemberGroups();
            if (list != null && list.size() > 0)
            {
               for (int loop = 0; loop < list.size(); loop++) {
         Vector row = (Vector)list.elementAt(loop);
            String memberGroupName = row.elementAt(0).toString();
            String memberGroupOwnerId = row.elementAt(1).toString();
            String memberGroupId = row.elementAt(2).toString();
            MemberDataBean _mbrGrpOwner = new MemberDataBean();
         _mbrGrpOwner.setId(memberGroupOwnerId);
         _mbrGrpOwner.populate();
   %>
      // add the member group to the available list
      if (!isInTextValueList(SelectedMemberGroups, "<%= UIUtil.toJavaScript(memberGroupId) %>")) {
         AvailableMemberGroups.options[count++] = new Option("<%= UIUtil.toJavaScript(memberGroupName) %>", "<%= UIUtil.toJavaScript(memberGroupId) %>", false, false);
      }
      cbm.MemberGroupOwners['<%= memberGroupId %>'] =
                   new Member('<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberType()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberDN()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberGroupName()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberGroupOwnerMemberType()) %>',
                     '<%= UIUtil.toJavaScript(_mbrGrpOwner.getMemberGroupOwnerMemberDN()) %>');
   <%
         } // end for
      } // end if
     } catch (Exception e)
      {
      out.println(e);
      }
    %>

// AvailableBuyers.options[0] = new Option("AAA", "A", false, false);
// AvailableBuyers.options[1] = new Option("BBB", "B", false, false);
// AvailableBuyers.options[2] = new Option("CCC", "C", false, false);
// AvailableMemberGroups.options[0] = new Option("AAA", "A", false, false);
// AvailableMemberGroups.options[1] = new Option("BBB", "B", false, false);
// AvailableMemberGroups.options[2] = new Option("CCC", "C", false, false);
     }

      initializeSloshBuckets(SelectedBuyers,
                             removeFromSloshBucketButton,
                             AvailableBuyers,
                             addToSloshBucketButton);

      initializeSloshBuckets(SelectedMemberGroups,
                             removeFromSloshBucketMbrGrpButton,
                             AvailableMemberGroups,
                             addToSloshBucketMbrGrpButton);

    // handle error messages back from the validate page


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
   myFormNames[0]  = "buyerForm";
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
  //alert ('Buyer savePanelData');
  with (document.buyerForm)
   {
    if (parent.get)
     {
        var o = parent.get("ContractBuyerModel", null);
        if (o != null) {
           o.selectedBuyers = getTextValueSelectValues(SelectedBuyers);
           o.availableBuyers = getTextValueSelectValues(AvailableBuyers);
            o.selectedMemberGroups = getTextValueSelectValues(SelectedMemberGroups);
           o.availableMemberGroups = getTextValueSelectValues(AvailableMemberGroups);
        }
     }
   }
 }


function addToSelectedBuyers()
 {
  with (document.buyerForm)
   {
    move(AvailableBuyers, SelectedBuyers);
    updateSloshBuckets(AvailableBuyers,
                       addToSloshBucketButton,
                       SelectedBuyers,
                       removeFromSloshBucketButton);
   }
 }

function removeFromSelectedBuyers()
 {
  with (document.buyerForm)
   {
    move(SelectedBuyers, AvailableBuyers);
    updateSloshBuckets(SelectedBuyers,
                       removeFromSloshBucketButton,
                       AvailableBuyers,
                       addToSloshBucketButton);
   }
 }

function addToSelectedMemberGroups()
 {
  with (document.buyerForm)
   {
    move(AvailableMemberGroups, SelectedMemberGroups);
    updateSloshBuckets(AvailableMemberGroups,
                       addToSloshBucketMbrGrpButton,
                       SelectedMemberGroups,
                       removeFromSloshBucketMbrGrpButton);
   }
 }

function removeFromSelectedMemberGroups()
 {
  with (document.buyerForm)
   {
    move(SelectedMemberGroups, AvailableMemberGroups);
    updateSloshBuckets(SelectedMemberGroups,
                       removeFromSloshBucketMbrGrpButton,
                       AvailableMemberGroups,
                       addToSloshBucketMbrGrpButton);
   }
 }


</script>

</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractBuyerPanelPrompt") %></h1>

<form NAME="buyerForm" id="buyerForm">

<script>
   var base = parent.get("baseContract", null);
   if (base != null && base == "true") {
      document.write ("<%=UIUtil.toJavaScript(contractsRB.get("contractBuyerPanelNotForBaseContracts"))%>");
   }
</script>
<table border=0 id="ContractBuyerPanel_Table_1">
 <tr>
  <td width=160 id="ContractBuyerPanel_TableCell_1"></td>
  <td width=70 id="ContractBuyerPanel_TableCell_2"></td>
  <td width=10 id="ContractBuyerPanel_TableCell_3"></td>
  <td width=160 id="ContractBuyerPanel_TableCell_4"></td>
 </tr>

 <tr>
  <td valign='top' id="ContractBuyerPanel_TableCell_5">
    <label for="ContractBuyerPanel_FormInput_SelectedBuyers_In_buyerForm_1"><%= contractsRB.get("contractBuyerSelected") %></label><br>
    <select NAME="SelectedBuyers" id="ContractBuyerPanel_FormInput_SelectedBuyers_In_buyerForm_1" TABINDEX="1" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.buyerForm.removeFromSloshBucketButton, document.buyerForm.AvailableBuyers, document.buyerForm.addToSloshBucketButton);">
    </select>
  </td>
  <td width=100px id="ContractBuyerPanel_TableCell_6">
   <table cellpadding="2" cellspacing="2">
   <tr><td>
    <INPUT TYPE="button"
           TABINDEX="4"
           NAME="addToSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketAdd") %>  "
           ONCLICK="addToSelectedBuyers()">
   </td></tr>
   <tr><td>
    <INPUT TYPE="button"
           TABINDEX="2"
           NAME="removeFromSloshBucketButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketRemove") %>  "
           ONCLICK="removeFromSelectedBuyers()">
   </td></tr>
   </table>
  </td>
  <td width=10 id="ContractBuyerPanel_TableCell_7"></td>
  <td valign='top' id="ContractBuyerPanel_TableCell_8">
    <label for="ContractBuyerPanel_FormInput_AvailableBuyers_In_buyerForm_1"><%= contractsRB.get("contractBuyerAvailable") %></label><br>
    <select NAME="AvailableBuyers" id="ContractBuyerPanel_FormInput_AvailableBuyers_In_buyerForm_1" TABINDEX="3" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.buyerForm.addToSloshBucketButton, document.buyerForm.SelectedBuyers, document.buyerForm.removeFromSloshBucketButton);">
    </select>
  </td>
 </tr>
  <tr>
  <td width=160 id="ContractBuyerPanel_TableCell_9"></td>
  <td width=70 id="ContractBuyerPanel_TableCell_10"></td>
  <td width=10 id="ContractBuyerPanel_TableCell_11"></td>
  <td width=160 id="ContractBuyerPanel_TableCell_12"></td>
 </tr>

 <tr>
  <td valign='top' id="ContractBuyerPanel_TableCell_13">
    <label for="ContractBuyerPanel_FormInput_SelectedMemberGroups_In_buyerForm_1"><%= contractsRB.get("contractMemberGroupSelected") %></label><br>
    <select NAME="SelectedMemberGroups" id="ContractBuyerPanel_FormInput_SelectedMemberGroups_In_buyerForm_1" TABINDEX="1" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.buyerForm.removeFromSloshBucketMbrGrpButton, document.buyerForm.AvailableMemberGroups, document.buyerForm.addToSloshBucketMbrGrpButton);">
    </select>
  </td>
  <td width=100px id="ContractBuyerPanel_TableCell_14">
   <table cellpadding="2" cellspacing="2">
   <tr><td>
    <INPUT TYPE="button"
           TABINDEX="4"
           NAME="addToSloshBucketMbrGrpButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketAdd") %>  "
           ONCLICK="addToSelectedMemberGroups()">
   </td></tr>
   <tr><td>
    <INPUT TYPE="button"
           TABINDEX="2"
           NAME="removeFromSloshBucketMbrGrpButton"
           VALUE="  <%= contractsRB.get("GeneralSloshBucketRemove") %>  "
           ONCLICK="removeFromSelectedMemberGroups()">
   </td></tr>
   </table>
  </td>
  <td width=10 id="ContractBuyerPanel_TableCell_15"></td>
  <td valign='top' id="ContractBuyerPanel_TableCell_16">
    <label for="ContractBuyerPanel_FormInput_AvailableMemberGroups_In_buyerForm_1"><%= contractsRB.get("contractMemberGroupAvailable") %></label><br>
    <select NAME="AvailableMemberGroups" id="ContractBuyerPanel_FormInput_AvailableMemberGroups_In_buyerForm_1" TABINDEX="3" CLASS="selectWidth" SIZE="10" MULTIPLE onChange="javascript:updateSloshBuckets(this, document.buyerForm.addToSloshBucketMbrGrpButton, document.buyerForm.SelectedMemberGroups, document.buyerForm.removeFromSloshBucketMbrGrpButton);">
    </select>
  </td>
 </tr>
</table>

</form>
</body>
</html>


