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

function loadSelectValue (entryField, value) {
   if (value != top.undefined) {
      for (var i=0; i<entryField.length; i++) {
         if (entryField.options[i].value == value) {
            entryField.options[i].selected = true;
         }
      }
   }
}

function loadCheckValue (entryField, value) {
   if (entryField.value == value) {
      entryField.checked = true;
   }
}

function loadCheckValues (entryField, value) {
   for (var i=0; i<entryField.length; i++) {
      if (entryField[i].value == value) {
         entryField[i].checked = true;
         break;
      }
   }
}

function ContractReturnChargeModel () {
   var crcm = new Object();

   crcm.referenceNumber = "";
   crcm.action = "";

   crcm.chargePolicyList = new Array();
   crcm.chargePolicyName = "";
   crcm.chargePolicyType = "";

   crcm.approvalPolicyList = new Array();
   crcm.approvalPolicyName = "";
   crcm.approvalPolicyType = "";

   return crcm;
}

function ContractReturnPaymentModel () {
   var crpm = new Object();

   crpm.paymentPolicyList = new Array();
   crpm.returnPaymentPolicy = new Array();
   crpm.policyType = "";

   return crpm;
}

function ContractReturnPaymentTC (refnum, action, name) {
   var crptc = new Object();

   crptc.referenceNumber = refnum;
   crptc.action = action;
   crptc.returnPaymentPolicy = name;

   return crptc;
}

function submitReturnCharge (contract) {
   var o = get("ContractReturnChargeModel");
   if (o != null) {
      // check if this is a new contract, no return charge and approval policies are specified
      if ((o.chargePolicyName == "") && (o.action == "new")) {
         return;
      }

      contract.ReturnTCReturnCharge = new Object();
      if (o.referenceNumber != "") {
         contract.ReturnTCReturnCharge.referenceNumber = o.referenceNumber;
      }
      contract.ReturnTCReturnCharge.action = o.action;
      contract.ReturnTCReturnCharge.ReturnChargePolicyRef = new Object();
      contract.ReturnTCReturnCharge.ReturnChargePolicyRef.policyName = o.chargePolicyName;
      contract.ReturnTCReturnCharge.ReturnChargePolicyRef.StoreRef = new Object();
      contract.ReturnTCReturnCharge.ReturnChargePolicyRef.StoreRef.name = o.chargePolicyList[0].storeIdentity;
      contract.ReturnTCReturnCharge.ReturnChargePolicyRef.StoreRef.Owner = new Object();
      contract.ReturnTCReturnCharge.ReturnChargePolicyRef.StoreRef.Owner = o.chargePolicyList[0].member;
      contract.ReturnTCReturnCharge.ReturnApprovalPolicyRef = new Object();
      contract.ReturnTCReturnCharge.ReturnApprovalPolicyRef.policyName = o.approvalPolicyName;
      contract.ReturnTCReturnCharge.ReturnApprovalPolicyRef.StoreRef = new Object();
      contract.ReturnTCReturnCharge.ReturnApprovalPolicyRef.StoreRef.name = o.approvalPolicyList[0].storeIdentity;
      contract.ReturnTCReturnCharge.ReturnApprovalPolicyRef.StoreRef.Owner = new Object();
      contract.ReturnTCReturnCharge.ReturnApprovalPolicyRef.StoreRef.Owner = o.approvalPolicyList[0].member;
   }
   return;
}

function submitReturnPayment (contract) {
   var o = get("ContractReturnPaymentModel");
   if (o != null) {
      if (o.returnPaymentPolicy.length > 0)
         contract.ReturnTCRefundPaymentMethod = new Array();
      for (var i=0; i<o.returnPaymentPolicy.length; i++) {
         contract.ReturnTCRefundPaymentMethod[i] = new Object();
         if (o.returnPaymentPolicy[i].referenceNumber != "") {
            contract.ReturnTCRefundPaymentMethod[i].referenceNumber = o.returnPaymentPolicy[i].referenceNumber;
         }
         contract.ReturnTCRefundPaymentMethod[i].action = o.returnPaymentPolicy[i].action;
         contract.ReturnTCRefundPaymentMethod[i].ReturnPaymentPolicyRef = new Object();
         contract.ReturnTCRefundPaymentMethod[i].ReturnPaymentPolicyRef.policyName = o.returnPaymentPolicy[i].returnPaymentPolicy;
         var policyIndex = findIndexInPolicyList(o.paymentPolicyList, o.returnPaymentPolicy[i].returnPaymentPolicy);
         contract.ReturnTCRefundPaymentMethod[i].ReturnPaymentPolicyRef.StoreRef = new Object();
         contract.ReturnTCRefundPaymentMethod[i].ReturnPaymentPolicyRef.StoreRef.name = o.paymentPolicyList[policyIndex].storeIdentity;
         contract.ReturnTCRefundPaymentMethod[i].ReturnPaymentPolicyRef.StoreRef.Owner = new Object();
         contract.ReturnTCRefundPaymentMethod[i].ReturnPaymentPolicyRef.StoreRef.Owner = o.paymentPolicyList[policyIndex].member;
      }
      return;
   }
   return;
}

function validateReturns () {
   var o = get("ContractReturnChargeModel");

   if (o != null) {
      if (((o.approvalPolicyName == "") && (o.chargePolicyName != "")) || ((o.approvalPolicyName != "") && (o.chargePolicyName == ""))) {
         put("returnChargeNotSpecified", true);
         gotoPanel("notebookReturnsReturns");
         return false;
      }
   }

   return true;
}

function submitReturns (contract) {

   /*90288*/
   var ccdm = get("ContractCommonDataModel");
   if (ccdm)
   {
      if (ccdm.tcLockInfo["ReturnsTC"]!=null)
      {
         if (ccdm.tcLockInfo["ReturnsTC"].shouldTCbeSaved==false)
         {
            // Skip saving the terms and conditions
            return;
         }
      }
   }

   submitReturnCharge(contract);
   submitReturnPayment(contract);

   return true;
}

