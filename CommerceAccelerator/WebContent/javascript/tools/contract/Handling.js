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

function ContractHandlingChargesModel() {
  var chcm = new Object();

  chcm.handlingChargesEnabled = false;
  chcm.handlingAmount = "";
  chcm.orderCurrency = "";
  chcm.firstReleaseFree = false;
  chcm.handlingChargeFixedAmount = "";
  chcm.handlingChargePercentage = "";
  chcm.handlingChargePercentageAmount = "";
  chcm.handlingChargeTypeFixed = false;
  chcm.referenceNumber = "";
  
  return chcm;
}

function validateHandlingCharges() {
  var chcm = get("ContractHandlingChargesModel");
  if (chcm != null && chcm.handlingChargesEnabled) {
    var ccdm = get("ContractCommonDataModel");
    if (chcm.handlingAmount <= 0) {
      put("contractHandlingChargesInvalidHandlingAmount", true);
      gotoPanel("notebookHandlingCharges");
      return false;
    }
    if (!isValidCurrency(chcm.handlingAmount, chcm.orderCurrency, ccdm.flanguageId)) {
      put("contractHandlingChargesInvalidHandlingAmount", true);
      gotoPanel("notebookHandlingCharges");
      return false;
    }
    if (chcm.handlingChargeTypeFixed) {
      // Fixed handling charge
      if (!isValidCurrency(chcm.handlingChargeFixedAmount, chcm.orderCurrency, ccdm.flanguageId)) {
        put("contractHandlingChargesInvalidFixedMaxHandlingAmount", true);
        gotoPanel("notebookHandlingCharges");
        return false;
      }
    } else {
      // Percentage handling charge
      if (!isValidCurrency(chcm.handlingChargePercentageAmount, chcm.orderCurrency, ccdm.flanguageId)) {
        put("contractHandlingChargesInvalidPercentageMaxHandlingAmount", true);
        gotoPanel("notebookHandlingCharges");
        return false;
      }
      if (chcm.handlingChargePercentage <= 0 || chcm.handlingChargePercentage > 100) {
        put("contractHandlingChargesInvalidPercentage", true);
        gotoPanel("notebookHandlingCharges");
        return false;
      }
    }
  }
  return true;
}

function submitHandlingCharges(contract) {
  
  // get the HC model!
  var chcm = get("ContractHandlingChargesModel");
  var ccdm = get("ContractCommonDataModel");
  var flanguageId=ccdm.flanguageId;
  
  if (chcm != null) {
    if(chcm.referenceNumber != "" || chcm.handlingChargesEnabled) {
      contract.HandlingChargeTC = new Object();
      if (!chcm.handlingChargesEnabled) {
      	// Delete
        contract.HandlingChargeTC.action = "delete";
      	contract.HandlingChargeTC.referenceNumber = chcm.referenceNumber;
      } else {
      	if (chcm.referenceNumber == "" && chcm.handlingChargesEnabled) {
      	  // Create
      	  contract.HandlingChargeTC.action = "new";
      	} else {
      	  // Update
      	  contract.HandlingChargeTC.action = "update";
      	  contract.HandlingChargeTC.referenceNumber = chcm.referenceNumber;
      	}
      }
      contract.HandlingChargeTC.firstReleaseFree = chcm.firstReleaseFree;
      contract.HandlingChargeTC.HandlingCharge = new Object();
      contract.HandlingChargeTC.HandlingCharge.MonetaryAmount = new Object();
      contract.HandlingChargeTC.HandlingCharge.MonetaryAmount.value = chcm.handlingAmount;
      contract.HandlingChargeTC.HandlingCharge.MonetaryAmount.currency = chcm.orderCurrency;
      contract.HandlingChargeTC.MaximumHandlingCharge = new Object();
      contract.HandlingChargeTC.MaximumHandlingCharge.MonetaryAmount = new Object();
      contract.HandlingChargeTC.MaximumHandlingCharge.MonetaryAmount.value = (chcm.handlingChargeTypeFixed) ? chcm.handlingChargeFixedAmount : chcm.handlingChargePercentageAmount;
      contract.HandlingChargeTC.MaximumHandlingCharge.MonetaryAmount.currency = chcm.orderCurrency;
      contract.HandlingChargeTC.MaximumHandlingCharge.PriceAdjustment = new Object();
      contract.HandlingChargeTC.MaximumHandlingCharge.PriceAdjustment.signedPercentage = chcm.handlingChargePercentage;
    }
  }
  return true;
}
