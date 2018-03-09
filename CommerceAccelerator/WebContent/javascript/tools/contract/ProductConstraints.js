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

function ContractProductConstraintsModel() {
  var cpcm = new Object();

  cpcm = productSetPolicyList = new Array(); // holds all the product set business policies for the store/storegroup

  cpcm.inclusionProductSetSwitch = false;
  cpcm.exclusionProductSetSwitch = false;

  // this array stores all the defined price/product set TCs defined in this contract
  cpcm.productSetTC = new Array();

  cpcm.pstc_ci = new ContractCustomProductSetTC();  // only one per contract
  cpcm.pstc_ce = new ContractCustomProductSetTC();  // only one per contract

  cpcm.pstc_si = new Array();  // existing standard inclusion PS in the contract
  cpcm.available_ps_si = new Array(); // available inclusion sloshbucket
  cpcm.selected_ps_si = new Array();  // selected inclusion sloshbucket

  cpcm.pstc_se = new Array();  // existing standard exclusion PS in the contract
  cpcm.available_ps_se = new Array(); // available exclusion sloshbucket
  cpcm.selected_ps_se = new Array();  // selected exclusion sloshbucket

  return cpcm;
}

function ContractCustomProductSetTC () {
  var cpstc = new Object();

  cpstc.tcInContract = false;
  cpstc.modifiedInSession = false;
  cpstc.markedForDelete = false;
  cpstc.referenceNumber = "";

  cpstc.inclusionCustomProductSetName = "";
  cpstc.inclusionCustomProductSetSelection = new Array();

  cpstc.exclusionCustomProductSetName = "";
  cpstc.exclusionCustomProductSetSelection = new Array();

  return cpstc;
}

function ContractStandardProductSetTC () {
  var cspstc = new Object();

  cspstc.tcInContract = false;
  cspstc.modifiedInSession = false;
  cspstc.markedForDelete = false;
  cspstc.referenceNumber = "";

  cspstc.productSetPolicyName = "";
  cspstc.productSetPolicyId = "";
  cspstc.productSetPolicyDescription="";

  return cspstc;
}

///////////////////////////////////////
// SUBMIT/VALIDATION SCRIPTS
///////////////////////////////////////
function validateProductConstraints() {

  // get the category pricing model!
  var cpcm = get("ContractProductConstraintsModel");

  if (cpcm != null) {

  }
  return true;
}

// Is an item in an array of values
function isProductSetInContract(psId, productSetTCs) {
   for (var i=0; i<productSetTCs.length; i++) {
   if (productSetTCs[i].productSetPolicyId == psId)
      return true;
   }
   return false;
}

function submitProductConstraints(contract) {

   /*90288*/
   var ccdm = get("ContractCommonDataModel");
   if (ccdm)
   {
      if (ccdm.tcLockInfo["PricingTC"]!=null)
      {
         if (ccdm.tcLockInfo["PricingTC"].shouldTCbeSaved==false)
         {
            // Skip saving the terms and conditions
            return;
         }
      }
   }

  var psId;
  var action;
  var tc_refnum;

  // get the category pricing model!
  var cpcm = get("ContractProductConstraintsModel");

  if (cpcm != null) {
    var ccdm = get("ContractCommonDataModel");

    var standardInclusionArray = new Array();
    var standardExclusionArray = new Array();
    var customInclusionArray = new Array();
    var customExclusionArray = new Array();

    // check the model to see which product set TCs should be generated

    // STANDARD INCLUSION PS
    // create the new product sets...
    for (var i=0; i<cpcm.selected_ps_si.length; i++) {
        psId = cpcm.selected_ps_si[i].value;
        tc_refnum = "";
        // only create the TC if it does not already exist in the contract
        if (! isProductSetInContract(psId, cpcm.pstc_si)) {
             // this is a new TC, add it to the contract
             action = "new";
             createProductSetTCstandardInclusion(standardInclusionArray, psId, action, tc_refnum, cpcm);
        }
    }

    // delete the removed ones
    // only delete ones that are currently in the contract
    for (var i=0; i<cpcm.pstc_si.length; i++) {
        psId = cpcm.pstc_si[i].productSetPolicyId;
        tc_refnum = cpcm.pstc_si[i].referenceNumber;
        if (isNameInTextValueArray(psId, cpcm.selected_ps_si) == false) {
            // this one has been delete from the sloshbucket, remove the TC from the contract
            action = "delete";
            createProductSetTCstandardInclusion(standardInclusionArray, psId, action, tc_refnum, cpcm);
        }
    }
    // CUSTOM EXCLUSION PS
    if (cpcm.pstc_ci.inclusionCustomProductSetSelection.length > 0) {
        createProductSetTCcustomInclusion(customInclusionArray, cpcm.pstc_ci, ccdm);
    }

    // STANDARD EXCLUSION PS
    // create the new product sets...
    for (var i=0; i<cpcm.selected_ps_se.length; i++) {
        psId = cpcm.selected_ps_se[i].value;
        tc_refnum = "";
        // only create the TC if it does not already exist in the contract
        if (! isProductSetInContract(psId, cpcm.pstc_se)) {
             // this is a new TC, add it to the contract
             action = "new";
             createProductSetTCstandardExclusion(standardExclusionArray, psId, action, tc_refnum, cpcm);
        }
    }

    // delete the removed ones
    // only delete ones that are currently in the contract
    for (var i=0; i<cpcm.pstc_se.length; i++) {
        psId = cpcm.pstc_se[i].productSetPolicyId;
        tc_refnum = cpcm.pstc_se[i].referenceNumber;
        if (isNameInTextValueArray(psId, cpcm.selected_ps_se) == false) {
            // this one has been delete from the sloshbucket, remove the TC from the contract
            action = "delete";
            createProductSetTCstandardExclusion(standardExclusionArray, psId, action, tc_refnum, cpcm);
        }
    }
    // CUSTOM EXCLUSION PS
    if (cpcm.pstc_ce.exclusionCustomProductSetSelection.length > 0) {
        createProductSetTCcustomExclusion(customExclusionArray, cpcm.pstc_ce, ccdm);
    }

    if (standardInclusionArray.length > 0) {
   contract.ProductSetTCInclusion = new Array();
   contract.ProductSetTCInclusion = standardInclusionArray;
    }
    if (standardExclusionArray.length > 0) {
   contract.ProductSetTCExclusion = new Array();
   contract.ProductSetTCExclusion = standardExclusionArray;
    }
    if (customInclusionArray.length > 0) {
   contract.ProductSetTCCustomInclusion = new Array();
   contract.ProductSetTCCustomInclusion = customInclusionArray;
    }
    if (customExclusionArray.length > 0) {
   contract.ProductSetTCCustomExclusion = new Array();
   contract.ProductSetTCCustomExclusion = customExclusionArray;
    }
  } // end if

  return true;
}

function createProductSetTCstandardExclusion(standardExclusionArray, psId, action, tc_refnum, cpcm) {
    var myTC = new Object();

    myTC.action = action;
    if (action != "new") {
        myTC.referenceNumber = tc_refnum;
    }

    myTC.ProductSetPolicyRef = new Object();

    var policyIndex = findIndexInPolicyList(cpcm.productSetPolicyList, psId, "ID");

    if (policyIndex >= 0) {
        myTC.ProductSetPolicyRef = new PolicyReference("ProductSet", cpcm.productSetPolicyList[policyIndex]);
    }

    // add the price TC to the TC array
    standardExclusionArray[standardExclusionArray.length] = myTC;

    //alert('Creating ProductSetTCstandardExclusion:\n'+convert2XML(myTC, null));

    return true;
}

function createProductSetTCstandardInclusion(standardInclusionArray, psId, action, tc_refnum, cpcm) {
    var myTC = new Object();

    myTC.action = action;
    if (action != "new") {
        myTC.referenceNumber = tc_refnum;
    }

    myTC.ProductSetPolicyRef = new Object();

    var policyIndex = findIndexInPolicyList(cpcm.productSetPolicyList, psId, "ID");

    if (policyIndex >= 0) {
        myTC.ProductSetPolicyRef = new PolicyReference("ProductSet", cpcm.productSetPolicyList[policyIndex]);
    }

    // add the price TC to the TC array
    standardInclusionArray[standardInclusionArray.length] = myTC;

    //alert('Creating ProductSetTCstandardInclusion:\n'+convert2XML(myTC, null));

    return true;
}

function createProductSetTCcustomExclusion(customExclusionArray, pstc, ccdm) {
    var myTC = new Object();
    createProductSetTCactions(pstc, myTC);

    myTC.ProductSet =
                new ProductSet(ccdm, pstc.exclusionCustomProductSetName, pstc.exclusionCustomProductSetSelection, null);

    // add the price TC to the TC array
    customExclusionArray[customExclusionArray.length] = myTC;

    //alert('Creating ProductSetTCcustomExclusion:\n'+convert2XML(myTC, null));

    return true;
}

function createProductSetTCcustomInclusion(customInclusionArray, pstc, ccdm) {
    var myTC = new Object();
    createProductSetTCactions(pstc, myTC);

    myTC.ProductSet =
                new ProductSet(ccdm, pstc.inclusionCustomProductSetName, pstc.inclusionCustomProductSetSelection, null);

    // add the price TC to the TC array
    customInclusionArray[customInclusionArray.length] = myTC;

    //alert('Creating ProductSetTCcustomInclusion:\n'+convert2XML(myTC, null));

    return true;
}

function createProductSetTCactions (cptc, productSetTC) {
    if (cptc.tcInContract) {
        productSetTC.referenceNumber = cptc.referenceNumber;
        if (cptc.markedForDelete)
            productSetTC.action = "delete";
        else if (cptc.modifiedInSession)
            productSetTC.action = "update";
        else
            productSetTC.action = "noaction";
    }
    else {
        productSetTC.action = "new";
        if (cptc.markedForDelete)
            productSetTC.action = "noaction";
    }
}
