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

///////////////////////////////////////
// MODEL OBJECT CONSTRUCTOR/CLONING SCRIPTS
///////////////////////////////////////
function ContractOrderApprovalModel() {
  var coam = new Object();

  coam.contractHasOrderApproval = false;
  coam.contractMinimumAmountValue = "";
  coam.contractMinimumAmountCurrency = "";

  coam.orderApprovalRequiredSwitch = false;
  coam.orderApprovalMinimumAmountValue = "";
  coam.orderApprovalMinimumAmountCurrency = "";

  coam.referenceNumber = "";

  return coam;
}

///////////////////////////////////////
// SUBMIT/VALIDATION SCRIPTS
///////////////////////////////////////
function validateOrderApproval() {
  var coam = get("ContractOrderApprovalModel");
  if (coam != null) {
    if (coam.orderApprovalRequiredSwitch) {
       if (coam.orderApprovalMinimumAmountCurrency == "") {
          put("contractOrderApprovalSpecifyCurrency", true);
          gotoPanel("notebookOrderApproval");
          return false;
       }
            var ccdm = get("ContractCommonDataModel");
       if (isValidCurrency(coam.orderApprovalMinimumAmountValue,
            coam.orderApprovalMinimumAmountCurrency,
            ccdm.flanguageId) == false) {
          put("contractOrderApprovalSpecifyCurrencyValue", true);
          gotoPanel("notebookOrderApproval");
          return false;
       }
    }
  }
  return true;
}

function submitOrderApproval(contract) {

  // get the OA model!
  var coam = get("ContractOrderApprovalModel");
  var ccdm = get("ContractCommonDataModel");
  var flanguageId=ccdm.flanguageId;

  if (coam != null) {

   /*90288*/
   if (ccdm.tcLockInfo["OrderApprovalTC"]!=null)
   {
      if (ccdm.tcLockInfo["OrderApprovalTC"].shouldTCbeSaved==false)
      {
         // Skip saving the terms and conditions
         return;
      }
   }

   if (coam.contractHasOrderApproval == true && coam.orderApprovalRequiredSwitch == false) {
      // this is a delete
      contract.OrderApprovalTC = new Object();
      contract.OrderApprovalTC.MonetaryAmount = new Object();
      contract.OrderApprovalTC.MonetaryAmount.value = coam.contractMinimumAmountValue;
      contract.OrderApprovalTC.MonetaryAmount.currency = coam.contractMinimumAmountCurrency;
      contract.OrderApprovalTC.action = "delete";
      contract.OrderApprovalTC.referenceNumber = coam.referenceNumber;
   }
   else if (coam.contractHasOrderApproval == true && coam.orderApprovalRequiredSwitch == true) {
      // this is a change
      contract.OrderApprovalTC = new Object();
      contract.OrderApprovalTC.MonetaryAmount = new Object();
      contract.OrderApprovalTC.MonetaryAmount.value = currencyToNumber(coam.orderApprovalMinimumAmountValue,coam.orderApprovalMinimumAmountCurrency,flanguageId);
      contract.OrderApprovalTC.MonetaryAmount.currency = coam.orderApprovalMinimumAmountCurrency;
      contract.OrderApprovalTC.action = "update";
      contract.OrderApprovalTC.referenceNumber = coam.referenceNumber;
   }
   else if (coam.contractHasOrderApproval == false && coam.orderApprovalRequiredSwitch == true) {
      // this is new
      contract.OrderApprovalTC = new Object();
      contract.OrderApprovalTC.MonetaryAmount = new Object();
      contract.OrderApprovalTC.MonetaryAmount.value = currencyToNumber(coam.orderApprovalMinimumAmountValue,coam.orderApprovalMinimumAmountCurrency,flanguageId);
      contract.OrderApprovalTC.MonetaryAmount.currency = coam.orderApprovalMinimumAmountCurrency;
      contract.OrderApprovalTC.action = "new";
   }
  }

  return true;
}



///////////////////////////////////////
// ORDER APPROVAL TC XML CREATION SCRIPTS
///////////////////////////////////////


///////////////////////////////////////
// MISC SCRIPTS
///////////////////////////////////////
function getDivisionStatus(aSwitch) {
    return (aSwitch == true || aSwitch != 0) ? "block" : "none";
}

function loadSelectValue(select, value) {
    for (var i = 0; i < select.length; i++) {
        if (select.options[i].value == value) {
            select.options[i].selected = true;
            return;
        }
    }
}


