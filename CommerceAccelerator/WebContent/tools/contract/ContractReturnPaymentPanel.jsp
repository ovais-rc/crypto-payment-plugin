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
   com.ibm.commerce.payment.beans.*,
   com.ibm.commerce.tools.contract.beans.MemberDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyDataBean,
   com.ibm.commerce.tools.contract.beans.PolicyListDataBean,
   com.ibm.commerce.tools.contract.beans.ReturnTCDataBean,
   com.ibm.commerce.tools.contract.beans.PaymentTCDataBean" %>

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
   // always filter out the credit policy
   String sCreditText = PaymentPolicyListDataBean.POLICY_NAME_CREDIT_LINE;

   //used if a credit policy does not exist
   boolean bNotFoundCreditPolicy = true;

   // Create an instance of the policy databean to use for policy selection
   PolicyListDataBean policyList;
   PolicyDataBean policy[] = null;
   int numberOfPolicy = 0;
   policyList = new PolicyListDataBean();
   policyList.setPolicyType(PolicyListDataBean.TYPE_RETURN_PAYMENT);
   DataBeanManager.activate(policyList, request);
   policy = policyList.getPolicyList();
   if (policy != null) {
      numberOfPolicy = policy.length;
   }
   try {
   PaymentTCDataBean temptc = new   PaymentTCDataBean(new Long(accountId), new Integer(fLanguageId));
   DataBeanManager.activate(temptc, request);
   String[] tempPolicyName;
      tempPolicyName = temptc.getPolicyName();
      if (tempPolicyName.length >0)
            bNotFoundCreditPolicy = false;
   }
   catch (Exception e) {
   }

%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= contractsRB.get("contractReturnPaymentPanelPrompt") %></title>

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
var returnPaymentPolicyData = new Array();
var accountHasCredit = true;
var policyHasCredit = true;

function loadPanelData () {
   with (document.returnPaymentForm) {
      if (parent.setContentFrameLoaded) {
         parent.setContentFrameLoaded(true);
      }
      if (parent.get) {
         var hereBefore = parent.get("ContractReturnPaymentModelLoaded", null);
         if (hereBefore != null) {
            // have been to this page before - load from the model
            var o = parent.get("ContractReturnPaymentModel", null);
            if (o != null) {
               for (var i=0; i<o.returnPaymentPolicy.length; i++) {
                  if (o.returnPaymentPolicy[i].action != "delete") {
                     if (returnPaymentPolicyData.length == 1) {
                        loadCheckValue(ReturnPaymentPolicy, o.returnPaymentPolicy[i].returnPaymentPolicy);
                     }
                     else if (returnPaymentPolicyData.length > 1) {
                        loadCheckValues(ReturnPaymentPolicy, o.returnPaymentPolicy[i].returnPaymentPolicy);
                     }
                  }
               }
               //make sure that if you have a checkmark in the Credit checkbox that the checkbox is not disabled
               //even if a credit line doesn't exist
               for (var i=0; i<o.returnPaymentPolicy.length; i++) {
                  if(<%=bNotFoundCreditPolicy%> && ReturnPaymentPolicy[i].value == "Credit"){
                     if(ReturnPaymentPolicy[i].checked == true){
                        ReturnPaymentPolicy[i].disabled = false;
                     }
                  }
               }
               //end of credit line section

            }
         }
         else {
            // this is the first time on this page
            // create the model
            var crm = new ContractReturnPaymentModel();
            crm.paymentPolicyList = returnPaymentPolicyData;
            crm.policyType = "<%= PolicyListDataBean.TYPE_RETURN_PAYMENT %>";
            parent.put("ContractReturnPaymentModel", crm);
            parent.put("ContractReturnPaymentModelLoaded", true);

            // check if this is an update
            if (<%= foundContractId %> == true) {
               // save data in contract to keep track of update on this page
               var crpmic = new ContractReturnPaymentModel();
               crpmic.returnPaymentPolicy = new Array();

               // load the data from the returns TC databean
<%
   if (foundContractId) {
      ReturnTCDataBean tcData = new ReturnTCDataBean(new Long(contractId), new Integer(fLanguageId));
      DataBeanManager.activate(tcData, request);
      String[] paymentRefNumData = tcData.getReturnPaymentReferenceNumbers();
      String[] paymentPolicyData = tcData.getReturnPaymentPolicies();
      if (paymentRefNumData != null) {
         for (int i=0; i<paymentRefNumData.length; i++) {
%>
               if (returnPaymentPolicyData.length == 1) {
                  loadCheckValue(ReturnPaymentPolicy, "<%= UIUtil.toJavaScript(paymentPolicyData[i]) %>");
               }
               else if (returnPaymentPolicyData.length > 1) {
                  loadCheckValues(ReturnPaymentPolicy, "<%= UIUtil.toJavaScript(paymentPolicyData[i]) %>");
               }


               crpmic.returnPaymentPolicy[crpmic.returnPaymentPolicy.length] = new ContractReturnPaymentTC("<%= UIUtil.toJavaScript(paymentRefNumData[i]) %>", "", "<%= UIUtil.toJavaScript(paymentPolicyData[i]) %>");
<%
         }

%>
         //make sure that if you have a checkmark in the Credit checkbox that the checkbox is not disabled
         //even if a credit line doesn't exist
         for (var k=0; k<ReturnPaymentPolicy.length; k++) {
               if(<%=bNotFoundCreditPolicy%> && ReturnPaymentPolicy[k].value == "Credit" && ReturnPaymentPolicy[k].checked == true){
                  ReturnPaymentPolicy[k].disabled = false;
               }
         }
<%




      }
   }
%>
               if (crpmic.returnPaymentPolicy.length > 0) {
                  parent.put("ContractReturnPaymentModelInContract", crpmic);
               }
            }
         }

         // handle error messages back from the validate page
         // no error to handle for this page
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
   myFormNames[0]  = "returnPaymentForm";
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
   with (document.returnPaymentForm) {
      if (parent.get) {
         var o = parent.get("ContractReturnPaymentModel", null);
         if (o != null) {
            var tcInContract = parent.get("ContractReturnPaymentModelInContract", null);
            var actionFlag = false;
            o.returnPaymentPolicy = new Array();

            // if this is an update, check entries already in contract, and apply appropriate actions to each one
            // else, loop through each checked policy and add to model
            if ((tcInContract != null) && (tcInContract.returnPaymentPolicy != null)) {
               // check if there is only one checkbox on this page
               if (returnPaymentPolicyData.length == 1) {
                  // 4 possible actions:
                  // loop through each entries in contract
                  // 1. if it exists on this page, and checked, no action
                  // 2. if it exists on this page, and not checked, delete
                  // 3. if it does not exist on this page, delete
                  // if entry is found on this page that does not exist in contract after the loop
                  // 4. if it is checked, add new
                  for (var i=0; i<tcInContract.returnPaymentPolicy.length; i++) {
                     actionFlag = true;
                     if (ReturnPaymentPolicy.value == tcInContract.returnPaymentPolicy[i].returnPaymentPolicy) {
                        if (ReturnPaymentPolicy.checked) {
                           // ***** action 1 *****
                           o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC(tcInContract.returnPaymentPolicy[i].referenceNumber, "noaction", tcInContract.returnPaymentPolicy[i].returnPaymentPolicy);
                        }
                        else {
                           // ***** action 2 *****
                           o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC(tcInContract.returnPaymentPolicy[i].referenceNumber, "delete", tcInContract.returnPaymentPolicy[i].returnPaymentPolicy);
                        }
                     }
                     else {
                        // ***** action 3 *****
                        o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC(tcInContract.returnPaymentPolicy[i].referenceNumber, "delete", tcInContract.returnPaymentPolicy[i].returnPaymentPolicy);
                     }
                  }
                  if (!actionFlag) {
                     if (ReturnPaymentPolicy.checked) {
                        // ***** action 4 *****
                        o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC("", "new", ReturnPaymentPolicy.value);
                     }
                  }
               }
               else if (returnPaymentPolicyData.length > 1) {
                  for (var i=0; i<ReturnPaymentPolicy.length; i++) {
                     for (var j=0; j<tcInContract.returnPaymentPolicy.length; j++) {
                        if (ReturnPaymentPolicy[i].value == tcInContract.returnPaymentPolicy[j].returnPaymentPolicy) {
                           actionFlag = true;
                           if (ReturnPaymentPolicy[i].checked) {
                              // ***** action 1 *****
                              o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC(tcInContract.returnPaymentPolicy[j].referenceNumber, "noaction", tcInContract.returnPaymentPolicy[j].returnPaymentPolicy);
                           }
                           else {
                              // ***** action 2 *****
                              o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC(tcInContract.returnPaymentPolicy[j].referenceNumber, "delete", tcInContract.returnPaymentPolicy[j].returnPaymentPolicy);
                           }
                        }
                     }
                     if (!actionFlag) {
                        if (ReturnPaymentPolicy[i].checked) {
                           // ***** action 4 *****
                           o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC("", "new", ReturnPaymentPolicy[i].value);
                        }
                     }
                     else {
                        actionFlag = false;
                     }
                  }
                  for (var i=0; i<tcInContract.returnPaymentPolicy.length; i++) {
                     for (var j=0; j<ReturnPaymentPolicy.length; j++) {
                        if (tcInContract.returnPaymentPolicy[i].returnPaymentPolicy == ReturnPaymentPolicy[j].value) {
                           actionFlag = true;
                           break;
                        }
                     }
                     if (!actionFlag) {
                        // ***** action 3 *****
                        o.returnPaymentPolicy[o.returnPaymentPolicy.length] = new ContractReturnPaymentTC(tcInContract.returnPaymentPolicy[i].referenceNumber, "delete", tcInContract.returnPaymentPolicy[i].returnPaymentPolicy);
                     }
                     else {
                        actionFlag = false;
                     }
                  }
               }
            }
            else {
               // check if there is only one checkbox on this page
               if (returnPaymentPolicyData.length == 1) {
                  if (ReturnPaymentPolicy.checked) {
                     o.returnPaymentPolicy[0] = new ContractReturnPaymentTC("", "new", ReturnPaymentPolicy.value);
                  }
               }
               else if (returnPaymentPolicyData.length > 1) {
                  var checkCounter = 0;
                  for (var i=0; i<ReturnPaymentPolicy.length; i++) {
                     if (ReturnPaymentPolicy[i].checked) {
                        o.returnPaymentPolicy[checkCounter] = new ContractReturnPaymentTC("", "new", ReturnPaymentPolicy[i].value);
                        checkCounter++;
                     }
                  }
               }
            }
         }
      }
   }
}

function formOnChange () {
   formElementChanged = true;
}
//-->

</script>
</head>

<body ONLOAD="loadPanelData()" class="content">

<h1><%= contractsRB.get("contractReturnPaymentPanelPrompt") %></h1>

<form NAME="returnPaymentForm" id="returnPaymentForm">

<table border="0" cellpadding="2" cellspacing="2" id="ContractReturnPaymentPanel_Table_1">
<script language="JavaScript">
<!---- hide script from old browsers
if (parent.get("ContractCommonDataModel") != null) {
   accountHasCredit = parent.get("ContractCommonDataModel").accountHasCredit;
}

<%
   /*********************************************************************************/
   // loop through each credits from policy (embedded finder) to check for excludes
   /*********************************************************************************/
   for (int i=0; i<numberOfPolicy; i++) {
      MemberDataBean mdb = new MemberDataBean();
      mdb.setId(policy[i].getStoreMemberId());
      DataBeanManager.activate(mdb, request);

      if (policy[i].getPolicyName().equals(sCreditText)) {
%>
policyHasCredit = true;
<%    } else { %>
policyHasCredit = false;
<%    } %>
if (accountHasCredit || (!accountHasCredit && !policyHasCredit)) {
   returnPaymentPolicyData[returnPaymentPolicyData.length] = new PolicyObject("<%= UIUtil.toJavaScript((String)policy[i].getShortDescription()) %>", "<%= UIUtil.toJavaScript(policy[i].getPolicyName()) %>", "<%= policy[i].getId() %>", "<%= UIUtil.toJavaScript(policy[i].getStoreIdentity()) %>", new Member("<%= mdb.getMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>", "<%= mdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>"));
}
<% } %>

if (returnPaymentPolicyData.length > 0) {
   for (var i=0; i<returnPaymentPolicyData.length; i++) {
      document.writeln('<tr><td id="ContractReturnPaymentPanel_TableCell_0' + i + '" >');
      if(<%=bNotFoundCreditPolicy%> && returnPaymentPolicyData[i].policyName == "Credit"){
         document.writeln('<input id="ContractReturnPaymentPanel_FormInput_1_' + i + '" type="checkbox" name="ReturnPaymentPolicy" disabled value="' + returnPaymentPolicyData[i].policyName + '" onClick="if (this.checked == false){ this.disabled=true;} formOnChange();" >');
         document.writeln(returnPaymentPolicyData[i].displayText);
         document.writeln(' <%= UIUtil.toJavaScript((String)contractsRB.get("contractReturnPaymentCreditLineWarning")) %>');
      }
      else{
         document.writeln('<input id="ContractReturnPaymentPanel_FormInput_2_' + i + '" type="checkbox" name="ReturnPaymentPolicy" value="' + returnPaymentPolicyData[i].policyName + '" onClick="formOnChange();">');
         document.writeln(returnPaymentPolicyData[i].displayText);
      }
      document.writeln('</td></tr>');
   }
}
else {
   document.writeln('<tr><td id="ContractReturnPaymentPanel_TableCell_1"><%= UIUtil.toJavaScript((String)contractsRB.get("contractReturnPaymentEmpty")) %></td></tr>');
}
//-->

</script>
</table>

</form>

</body>

</html>
