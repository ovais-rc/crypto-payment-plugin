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
<%@ page language="java"
   import="com.ibm.commerce.tools.util.UIUtil,
   com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
   com.ibm.commerce.tools.contract.beans.ReturnTCDataBean" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>


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
   Integer myContractTCTypeID = new Integer(com.ibm.commerce.contract.util.ContractTCLockHelper.TCTYPE_RETURNS);
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





<%
   // Create an instance of the policy databean to use for policy selection
   PolicyListDataBean chargePolicyList = new PolicyListDataBean();
   PolicyListDataBean approvalPolicyList = new PolicyListDataBean();
   PolicyDataBean chargePolicy[] = null;
   PolicyDataBean approvalPolicy[] = null;

   int numberOfChargePolicy = 0;
   int numberOfApprovalPolicy = 0;

   chargePolicyList.setPolicyType(PolicyListDataBean.TYPE_RETURN_CHARGE);
   approvalPolicyList.setPolicyType(PolicyListDataBean.TYPE_RETURN_APPROVAL);

   DataBeanManager.activate(chargePolicyList, request);
   DataBeanManager.activate(approvalPolicyList, request);

   chargePolicy = chargePolicyList.getPolicyList();
   if (chargePolicy != null) {
      numberOfChargePolicy = chargePolicy.length;
   }
   approvalPolicy = approvalPolicyList.getPolicyList();
   if (approvalPolicy != null) {
      numberOfApprovalPolicy = approvalPolicy.length;
   }
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= contractsRB.get("contractReturnChargePanelPrompt") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/DateUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Contract.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Return.js">
</script>

<script LANGUAGE="JavaScript">



<!---- hide script from old browsers
var formElementChanged = false;
var returnChargePolicyDesc = new Array();
var returnApprovalPolicyDesc = new Array();

returnChargePolicyDesc[0] = "";
<% for (int i=0; i<numberOfChargePolicy; i++) { %>
returnChargePolicyDesc[<%= i+1 %>] = "<%= UIUtil.toJavaScript((String)chargePolicy[i].getLongDescription()) %>";
<% } %>

returnApprovalPolicyDesc[0] = "";
<% for (int i=0; i<numberOfApprovalPolicy; i++) { %>
returnApprovalPolicyDesc[<%= i+1 %>] = "<%= UIUtil.toJavaScript((String)approvalPolicy[i].getLongDescription()) %>";
<% } %>

function trimOptionText (optionText) {
   var returnText = optionText;
   if (returnText == null) return "";
   if (returnText.length > 64) {
      returnText = returnText.substring(0, 64) + " ...";
   }
   return returnText;
}

function loadPanelData () {
   with (document.returnChargeForm) {
      if (parent.setContentFrameLoaded) {
         parent.setContentFrameLoaded(true);
      }
      if (parent.get) {
         var hereBefore = parent.get("ContractReturnChargeModelLoaded", null);
         if (hereBefore != null) {
            // have been to this page before - load from the model
            var o = parent.get("ContractReturnChargeModel", null);
            if (o != null) {
               for (var i=0; i<o.chargePolicyList.length; i++) {
                  if (o.chargePolicyList[i].policyName == o.chargePolicyName) {
                     ReturnChargePolicy.options[i+1] = new Option(trimOptionText(o.chargePolicyList[i].displayText), o.chargePolicyList[i].policyName, true, true);
                  }
                  else {
                     ReturnChargePolicy.options[i+1] = new Option(trimOptionText(o.chargePolicyList[i].displayText), o.chargePolicyList[i].policyName, false, false);
                  }
               }
               for (var i=0; i<o.approvalPolicyList.length; i++) {
                  if (o.approvalPolicyList[i].policyName == o.approvalPolicyName) {
                     ReturnApprovalPolicy.options[i+1] = new Option(trimOptionText(o.approvalPolicyList[i].displayText), o.approvalPolicyList[i].policyName, true, true);
                  }
                  else {
                     ReturnApprovalPolicy.options[i+1] = new Option(trimOptionText(o.approvalPolicyList[i].displayText), o.approvalPolicyList[i].policyName, false, false);
                  }
               }
            }
         }
         else {
            // get return charge and approval policy data from the policy data bean
            var chargePolicyList = new Array();
            var approvalPolicyList = new Array();
<%
   for (int i=0; i<numberOfChargePolicy; i++) {
      MemberDataBean mdb = new MemberDataBean();
      mdb.setId(chargePolicy[i].getStoreMemberId());
      DataBeanManager.activate(mdb, request);
%>
            chargePolicyList[chargePolicyList.length] = new PolicyObject("<%= UIUtil.toJavaScript((String)chargePolicy[i].getShortDescription()) %>", "<%= UIUtil.toJavaScript(chargePolicy[i].getPolicyName()) %>", "<%= chargePolicy[i].getId() %>", "<%= UIUtil.toJavaScript(chargePolicy[i].getStoreIdentity()) %>", new Member("<%= mdb.getMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>", "<%= mdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>"));
<%
   }
   for (int i=0; i<numberOfApprovalPolicy; i++) {
      MemberDataBean mdb = new MemberDataBean();
      mdb.setId(approvalPolicy[i].getStoreMemberId());
      DataBeanManager.activate(mdb, request);
%>
            approvalPolicyList[approvalPolicyList.length] = new PolicyObject("<%= UIUtil.toJavaScript((String)approvalPolicy[i].getShortDescription()) %>", "<%= UIUtil.toJavaScript(approvalPolicy[i].getPolicyName()) %>", "<%= approvalPolicy[i].getId() %>", "<%= UIUtil.toJavaScript(approvalPolicy[i].getStoreIdentity()) %>", new Member("<%= UIUtil.toJavaScript(mdb.getMemberType()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>", "<%= mdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>"));
<% } %>

            // this is the first time on this page
            // create the model
            var crcm = new ContractReturnChargeModel();
            crcm.chargePolicyList = chargePolicyList;
            crcm.chargePolicyType = "<%= PolicyListDataBean.TYPE_RETURN_CHARGE %>";
            crcm.approvalPolicyList = approvalPolicyList;
            crcm.approvalPolicyType = "<%= PolicyListDataBean.TYPE_RETURN_APPROVAL %>";
            parent.put("ContractReturnChargeModel", crcm);
            parent.put("ContractReturnChargeModelLoaded", true);

            // load the data from the returns TC databean
<%
   String tcReferenceNumber = "";
   String tcReturnChargePolicy = "";
   String tcReturnApprvoalPolicy = "";
   if (foundContractId) {
      ReturnTCDataBean tcData = new ReturnTCDataBean(new Long(contractId), new Integer(fLanguageId));
      DataBeanManager.activate(tcData, request);
      tcReferenceNumber = tcData.getReturnChargeReferenceNumber();
      tcReturnChargePolicy = tcData.getReturnChargePolicy();
      tcReturnApprvoalPolicy = tcData.getReturnApprovalPolicy();
   }
%>
            for (var i=0; i<chargePolicyList.length; i++) {
               if (chargePolicyList[i].policyName == "<%= UIUtil.toJavaScript(tcReturnChargePolicy) %>") {
                  ReturnChargePolicy.options[i+1] = new Option(trimOptionText(chargePolicyList[i].displayText), chargePolicyList[i].policyName, true, true);
               }
               else {
                  ReturnChargePolicy.options[i+1] = new Option(trimOptionText(chargePolicyList[i].displayText), chargePolicyList[i].policyName, false, false);
               }
            }
            for (var i=0; i<approvalPolicyList.length; i++) {
               if (approvalPolicyList[i].policyName == "<%= UIUtil.toJavaScript(tcReturnApprvoalPolicy) %>") {
                  ReturnApprovalPolicy.options[i+1] = new Option(trimOptionText(approvalPolicyList[i].displayText), approvalPolicyList[i].policyName, true, true);
               }
               else {
                  ReturnApprovalPolicy.options[i+1] = new Option(trimOptionText(approvalPolicyList[i].displayText), approvalPolicyList[i].policyName, false, false);
               }
            }

            // save data in contract to keep track of update on this page
            var crcmic = new ContractReturnChargeModel();
            crcmic.referenceNumber = "<%= tcReferenceNumber %>";
            crcmic.chargePolicyList = chargePolicyList;
            crcmic.chargePolicyName = "<%= UIUtil.toJavaScript(tcReturnChargePolicy) %>";
            crcmic.chargePolicyType = "<%= PolicyListDataBean.TYPE_RETURN_CHARGE %>";
            crcmic.approvalPolicyList = approvalPolicyList;
            crcmic.approvalPolicyName = "<%= UIUtil.toJavaScript(tcReturnApprvoalPolicy) %>";
            crcmic.approvalPolicyType = "<%= PolicyListDataBean.TYPE_RETURN_APPROVAL %>";

            if (crcmic.referenceNumber != "") {
               parent.put("ContractReturnChargeModelInContract", crcmic);
            }
         }

         // handle error messages back from the validate page
         if (parent.get("returnChargeNotSpecified", false)) {
            parent.remove("returnChargeNotSpecified");
            alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractReturnChargeNotSpecified")) %>");
         }
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
   myFormNames[0]  = "returnChargeForm";
   var contractCommonDataModel = parent.get("ContractCommonDataModel", null);

   handleTCLockStatus("ReturnsTC",
                      contractCommonDataModel,
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_TCName_Returns")) %>",
                      "<%= myContractTCTypeID.toString() %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTC")) %>",
                      "<%= UIUtil.toJavaScript((String)contractsRB.get("CCL_MsgLockTCPrompt")) %>",
                      myFormNames,
                      4);

}

function savePanelData () {
   with (document.returnChargeForm) {
      if (parent.get) {
         var o = parent.get("ContractReturnChargeModel", null);
         if (o != null) {
            o.chargePolicyName = ReturnChargePolicy.options[ReturnChargePolicy.selectedIndex].value;
            o.approvalPolicyName = ReturnApprovalPolicy.options[ReturnApprovalPolicy.selectedIndex].value;

            var tcInContract = parent.get("ContractReturnChargeModelInContract", null);
            if (tcInContract != null) {
               o.referenceNumber = tcInContract.referenceNumber;

               if (o.chargePolicyName == "") {
                  o.action = "delete";
               }
               else {
                  if ((o.chargePolicyName == tcInContract.chargePolicyName) && (o.approvalPolicyName == tcInContract.approvalPolicyName)) {
                     o.action = "noaction";
                  }
                  else {
                     o.action = "update";
                  }
               }
            }
            else {
               o.referenceNumber = "";
               o.action = "new";
            }
         }
      }
   }
}

function formOnChange () {
   formElementChanged = true;
}

function detailOnChange () {
   var currentIndex;

   currentIndex = document.returnChargeForm.ReturnChargePolicy.selectedIndex;
   if (currentIndex == 0) {
      chargeDetailDiv.style.display = "none";
   }
   else {
      chargeDetail.innerHTML = returnChargePolicyDesc[currentIndex];
      chargeDetailDiv.style.display = "";
   }

   currentIndex = document.returnChargeForm.ReturnApprovalPolicy.selectedIndex;
   if (currentIndex == 0) {
      approvalDetailDiv.style.display = "none";
   }
   else {
      approvalDetail.innerHTML = returnApprovalPolicyDesc[currentIndex];
      approvalDetailDiv.style.display = "";
   }
}
//-->

</script>
</head>

<body onLoad="loadPanelData();detailOnChange();" class="content">

<h1><%= contractsRB.get("contractReturnChargePanelPrompt") %></h1>

<form name="returnChargeForm" id="returnChargeForm">

<p><label for="ContractReturnChargePanel_FormInput_ReturnChargePolicy_In_returnChargeForm_1"><%= contractsRB.get("contractReturnChargePolicyPrompt") %></label><br>
<select id="ContractReturnChargePanel_FormInput_ReturnChargePolicy_In_returnChargeForm_1" name="ReturnChargePolicy" onChange="formOnChange();detailOnChange();">
   <option value=""><%= contractsRB.get("contractReturnChargeNoReturns") %></option>
</select>

<div id="chargeDetailDiv" style="display:none;">
<table border="0" cellpadding="5" cellspacing="5" id="ContractReturnChargePanel_Table_1">
   <tr>
      <td valign="top" nowrap id="ContractReturnChargePanel_TableCell_1"><%= contractsRB.get("contractReturnChargeDetailPrompt") %></td>
      <td id="ContractReturnChargePanel_TableCell_2"><i><div id="chargeDetail"></div></i></td>
   </tr>
</table>
</div>

<p><label for="ContractReturnChargePanel_FormInput_ReturnApprovalPolicy_In_returnChargeForm_1"><%= contractsRB.get("contractReturnChargeApprovalPolicyPrompt") %></label><br>
<select id="ContractReturnChargePanel_FormInput_ReturnApprovalPolicy_In_returnChargeForm_1" name="ReturnApprovalPolicy" onChange="formOnChange();detailOnChange();">
   <option value=""><%= contractsRB.get("contractReturnChargeNoReturns") %></option>
</select>

<div id="approvalDetailDiv" style="display:none;">
<table border="0" cellpadding="5" cellspacing="5" id="ContractReturnChargePanel_Table_2">
   <tr>
      <td valign="top" nowrap id="ContractReturnChargePanel_TableCell_3"><%= contractsRB.get("contractReturnChargeApprovalDetailPrompt") %></td>
      <td id="ContractReturnChargePanel_TableCell_4"><i><div id="approvalDetail"></div></i></td>
   </tr>
</table>
</div>

</form>

</body>

</html>
