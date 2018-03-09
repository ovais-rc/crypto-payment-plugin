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

/////////////////////////////////////////////
// MODEL OBJECT CONSTRUCTOR/CLONING SCRIPTS
/////////////////////////////////////////////

function ContractCategoryPricingModel () {
   var cpm = new Object();

        // there is only one master catalog price list policy per store...
        // therefore, it is maintained once here, at the pricing model level.
        // it is populated in the category list page at first load time.
        cpm.masterCatalogPriceListPolicy = new Object();

        // this contains a full list of all the product set policies for the store.
        cpm.productSetPolicyList = new Array();

   // this array stores all the defined price/product set TCs defined in this contract
   cpm.priceTC = new Array();

   return cpm;
}

function ContractPriceTC () {
   var cptc = new Object();

   cptc.tcInContract = false;
   cptc.modifiedInSession = false;
   cptc.markedForDelete = false;
   cptc.referenceNumber = "";

   cptc.percentagePricingRadio = "";

   cptc.adjustmentOnMasterCatalogValue = "0";

   cptc.adjustmentOnStandardProductSetSelectedCategories = new Array();
   cptc.adjustmentOnStandardProductSetAvailableCategories = new Array();
   cptc.adjustmentOnStandardProductSetValue = "0";
   cptc.adjustmentOnStandardProductSetPolicyId = "";
   cptc.adjustmentOnStandardProductSetDisplayText = "";

   cptc.adjustmentOnCustomProductSetName = "";
   cptc.adjustmentOnCustomProductSetValue = "0";
   cptc.adjustmentOnCustomProductSetSelection = new Array();

   return cptc;
}

// Javascripts often passed by reference instead of by value.
// In order to update a model object in a dialog you first need to completely
// clone the original model element, otherwise, you will overwrite the original
// (which is a problem if the user makes changes and clicks cancel)
function clonePriceTC (source, target) {
   // copy all the high level attributes

   target.tcInContract = source.tcInContract;
   target.modifiedInSession = source.modifiedInSession;
   target.markedForDelete = source.markedForDelete;
   target.referenceNumber = source.referenceNumber;

   target.percentagePricingRadio = source.percentagePricingRadio;

   target.adjustmentOnMasterCatalogValue = source.adjustmentOnMasterCatalogValue;

        // these are arrays and they never need to be cloned...
   //target.adjustmentOnStandardProductSetSelectedCategories = source.adjustmentOnStandardProductSetSelectedCategories;
   //target.adjustmentOnStandardProductSetAvailableCategories = source.adjustmentOnStandardProductSetAvailableCategories;
   target.adjustmentOnStandardProductSetValue = source.adjustmentOnStandardProductSetValue;
   target.adjustmentOnStandardProductSetPolicyId = source.adjustmentOnStandardProductSetPolicyId;
   target.adjustmentOnStandardProductSetDisplayText = source.adjustmentOnStandardProductSetDisplayText;

   target.adjustmentOnCustomProductSetName = source.adjustmentOnCustomProductSetName;
   target.adjustmentOnCustomProductSetValue = source.adjustmentOnCustomProductSetValue;

   cloneCatEntryArray(source.adjustmentOnCustomProductSetSelection,
      target.adjustmentOnCustomProductSetSelection);

   return;
}

function cloneCatEntryArray (source, target) {
   for (i=0; i<source.length; i++) {
      // only clone entries which have not been deleted
      if (source[i].type == "CG" || source[i].type == "CE") {
         target[target.length] = new CatEntry(source[i].displayText,
                                         source[i].refnum,
                                         source[i].id,
                                         source[i].member,
                                         source[i].type);
      }
   }
}

// function to create a CatEntry object.
// an array of catentries is maintained for each cat/item select box.
// we need to track the displayText for display purposes, the reference number which is actually used
// at XML creation time, and the type ("CG" for CatGroup, or "CE" for CatalogEntry) as each select
// box can store either.
function CatEntry (displayText, refnum, id, member, type) {
   var myCE = new Object();

   myCE.displayText = displayText;
   myCE.refnum = refnum;
   myCE.id = id;
   myCE.member = member;
   myCE.type = type;  // can be either "CG" for CatGroup, or "CE" for CatEntry

   return myCE;
}

///////////////////////////////////////
// SUBMIT/VALIDATION SCRIPTS
///////////////////////////////////////
function validateCategoryPricing () {
   return true;
}

// This function returns the JROM object
function getJROM(){
   //alert('getJROM in Pricing.js');
   var cfm = get("ContractFilterModel");
   return cfm.JROM;
}

// This function returns the fixed tcs
function getFIXED(){
   var cfm = get("ContractFilterModel");
   return cfm.FIXED;
}

// This function returns the parent contract fixed tcs
function getParentFIXED(){
   var cfm = get("ContractFilterModel");
   return cfm.parentFIXED;
}

// This function returns the JROM array of rows
function getJROMRows(){
   var cfm = get("ContractFilterModel");
   return cfm.JROM.rows;
}

// This function returns the JLOM array of rows
function getJLOM(){
   var cfm = get("ContractFilterModel");
   return cfm.JLOM;
}

// This function returns the JPOM hash table
function getJPOM() {
   var cfm = get("ContractFilterModel");
   return cfm.JPOM;
}
function submitCategoryPricing (contract) {

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

   // Catalog Filter

   var getCFM = get("ContractFilterModel");
   if (getCFM != null) {
      // check if changes have been made
         if(createPriceTCMasterCatalogWithFiltering && getCFM.JROM.areButtonsDisabled == false){
            var PriceTCMasterCatalogWithFiltering = new createPriceTCMasterCatalogWithFiltering();
            PriceTCMasterCatalogWithFiltering.action = "update";
            PriceTCMasterCatalogWithFiltering.referenceNumber = getCFM.JROM.termConditionId;
         if (PriceTCMasterCatalogWithFiltering.referenceNumber == "null") {
            PriceTCMasterCatalogWithFiltering.action = "new";
         }
         if (!defined(PriceTCMasterCatalogWithFiltering.CatalogSelection.Selection) && PriceTCMasterCatalogWithFiltering.CatalogSelection.includeEntireCatalog != "true") {
            PriceTCMasterCatalogWithFiltering.action = "delete";
         }

         if ( PriceTCMasterCatalogWithFiltering.action == "new" ||
              (PriceTCMasterCatalogWithFiltering.action == "update" && PriceTCMasterCatalogWithFiltering.referenceNumber != "null") ||
              (PriceTCMasterCatalogWithFiltering.action == "delete" && PriceTCMasterCatalogWithFiltering.referenceNumber != "null") ) {
            contract.PriceTCMasterCatalogWithFiltering = PriceTCMasterCatalogWithFiltering;
         }
         }
      // create a custom price list XML
         createFixedPriceTCCustomPriceList(contract, getCFM.FIXED, getCFM.JROM.contractId);
      }
   // End Catalog Filter
   // get the category pricing model!
   var cpm = get("ContractCategoryPricingModel");

   if (cpm != null) {
      var ccdm = get("ContractCommonDataModel");

      // loop through the ContractPriceTCs and create TC as per contract DTD
      var priceTCnum = cpm.priceTC.length;

      var masterCatalogArray = new Array();
      var selectiveAdjustmentArray = new Array();

      for (var i=0; i<priceTCnum; i++) {
         // get the price TC from the array
         var cptc = cpm.priceTC[i];

         // for each cptc (row in the pricing dynamic list,
         // created within the pricing dialog, you can create multiple
         // PriceTCs - depending on the radio option selected.
         // you can also create 3 different kinds of price TCs
         if (cptc.percentagePricingRadio == "masterPriceTC") {
            // create a master catalog adjustment price TC
            createPriceTCMasterCatalogWithOptionalAdjustment(masterCatalogArray, cptc, ccdm);
         }
         else if (cptc.percentagePricingRadio == "standardPriceTC") {
            // create a price TC /w selective adjustment on standard product set
            createPriceTCPriceListWithSelectiveAdjustment(selectiveAdjustmentArray,
                                                          cpm,
                                                          cptc,
                                                          ccdm);
         }
         else if (cptc.percentagePricingRadio == "customPriceTC") {
            // create a price TC /w selective adjustment on custom product set
            createPriceTCPriceListWithAdjustmentOnCustomProductSet(selectiveAdjustmentArray,
                                                                   cpm,
                                                                   cptc,
                                                                   ccdm);
         }
         else {
            // unsupported price TC type...
            return false;
              }
      }
      if (masterCatalogArray.length > 0) {
         contract.PriceTCMasterCatalogWithOptionalAdjustment = new Array();
         contract.PriceTCMasterCatalogWithOptionalAdjustment = masterCatalogArray;
      }
      if (selectiveAdjustmentArray.length > 0) {
         contract.PriceTCPriceListWithSelectiveAdjustment = new Array();
         contract.PriceTCPriceListWithSelectiveAdjustment = selectiveAdjustmentArray;
      }
   }

   return true;
}

function createPriceTCActions (cptc, priceTC) {
   if (cptc.tcInContract) {
      priceTC.referenceNumber = cptc.referenceNumber;
      if (cptc.markedForDelete)
         priceTC.action = "delete";
      else if (cptc.modifiedInSession)
         priceTC.action = "update";
      else
         priceTC.action = "noaction";
   }
   else {
      priceTC.action = "new";
      if (cptc.markedForDelete)
         priceTC.action = "noaction";
   }
}

///////////////////////////////////////
// PRICE TC XML CREATION SCRIPTS
///////////////////////////////////////
function createPriceTCMasterCatalogWithOptionalAdjustment (masterCatalogArray, cptc, ccdm) {
   var myTC = new Object();

   createPriceTCActions(cptc, myTC);

   if (myTC.action == "noaction") {
      return true;
   }

        myTC.PriceAdjustment = new Object();
   myTC.PriceAdjustment.signedPercentage = cptc.adjustmentOnMasterCatalogValue;

   // add the price TC to the TC array
   masterCatalogArray[masterCatalogArray.length] = myTC;

   //alert('Creating createPriceTCMasterCatalogWithOptionalAdjustment:\n'+convert2XML(myTC, null));

   return true;
}

function createPriceTCPriceListWithSelectiveAdjustment (selectiveAdjustmentArray, cpm, cptc, ccdm) {
   var myTC = new Object();

   createPriceTCActions(cptc, myTC);

   if (myTC.action == "noaction") {
      return true;
   }

   myTC.PricePolicyRef = new Object();

   // the price list is *always* the master catalog price list...
   myTC.PricePolicyRef =
      new PolicyReference("Price",
                                    new PolicyObject('policy_description',
                                                     cpm.masterCatalogPriceListPolicy.policyName,
                                                     'policy_id',
                                                     cpm.masterCatalogPriceListPolicy.storeIdentity,
                                                     cpm.masterCatalogPriceListPolicy.member)
                                   );

   myTC.PriceAdjustmentOnProductSet = new Object();
   myTC.PriceAdjustmentOnProductSet.ProductSetInclusion = new Object();
   myTC.PriceAdjustmentOnProductSet.ProductSetInclusion.ProductSetPolicyRef = new Object();

   // find the policy ID saved in the price TC in the full list of standard product set policies saved in the
   // global pricing model for the contract.  this way, we can pull out the policy name and member info for the policy
   // and use it to create the XML required.
        var policyIndex = findIndexInPolicyList(cpm.productSetPolicyList,
                                                cptc.adjustmentOnStandardProductSetPolicyId,
                                                "ID");

        if (policyIndex >= 0) {
       myTC.PriceAdjustmentOnProductSet.ProductSetInclusion.ProductSetPolicyRef =
         new PolicyReference("ProductSet",
                          cpm.productSetPolicyList[policyIndex]);

       myTC.PriceAdjustmentOnProductSet.PriceAdjustment = new Object();
       myTC.PriceAdjustmentOnProductSet.PriceAdjustment.signedPercentage = cptc.adjustmentOnStandardProductSetValue;
        }

   // add the price TC to the TC array
   selectiveAdjustmentArray[selectiveAdjustmentArray.length] = myTC;

   //alert('Creating PriceTCPriceListWithSelectiveAdjustment:\n'+convert2XML(myTC, null));

   return true;
}

function createPriceTCPriceListWithAdjustmentOnCustomProductSet (selectiveAdjustmentArray, cpm, cptc, ccdm) {
   var myTC = new Object();

   createPriceTCActions(cptc, myTC);

   if (myTC.action == "noaction") {
      return true;
   }

   myTC.PricePolicyRef = new Object();
   myTC.PricePolicyRef =
      new PolicyReference("Price",
                                    new PolicyObject('policy description',
                                                     cpm.masterCatalogPriceListPolicy.policyName,
                                                     'policy id',
                                                     cpm.masterCatalogPriceListPolicy.storeIdentity,
                                                     cpm.masterCatalogPriceListPolicy.member)
                                   );

   myTC.PriceAdjustmentOnProductSet = new Object();
   myTC.PriceAdjustmentOnProductSet.ProductSetInclusion = new Object();
   myTC.PriceAdjustmentOnProductSet.ProductSetInclusion.ProductSet =
      new ProductSet(ccdm,
                     cptc.adjustmentOnCustomProductSetName,
                     cptc.adjustmentOnCustomProductSetSelection,
                     null);

   myTC.PriceAdjustmentOnProductSet.PriceAdjustment = new Object();
   myTC.PriceAdjustmentOnProductSet.PriceAdjustment.signedPercentage =
      cptc.adjustmentOnCustomProductSetValue;

   // add the price TC to the TC array
   selectiveAdjustmentArray[selectiveAdjustmentArray.length] = myTC;

   //alert('Creating PriceTCPriceListWithAdjustmentOnCustomProductSet:\n'+convert2XML(myTC, null));

   return true;
}

// only pass in one of the 2 argument to return either an inclusion or an exclusion product set
function ProductSet (ccdm, psname, inclusionSetArray, exclusionSetArray) {
   var myPS = new Object();

   myPS.name = psname;
   myPS.catalogReferenceNumber = ccdm.catalogId;
   myPS.catalogIdentifier = ccdm.catalogIdentifier;
   myPS.description = "BRM CPS";

   if (inclusionSetArray != null) {
      myPS.PSInclusionList = new PSList(inclusionSetArray);
   }
   if (exclusionSetArray != null) {
      myPS.PSExclusionList = new PSList(exclusionSetArray);
   }

   myPS.ProductSetOwner = ccdm.StoreOwner;
   myPS.CatalogOwner = ccdm.CatalogOwner;

   return myPS;
}

// take an array of catgroups/catentries and returns a list for a PSInclusionList or PSExclusion object
function PSList (aSelectionArray) {
   var myPSList = new Object();

   if (aSelectionArray != null) {
      // first create all the cat entries...
      for (var i=0; i<aSelectionArray.length; i++) {
         if (aSelectionArray[i].type == "CE") {  // this is a CatalogEntry
            if (typeof(myPSList.CatalogEntryRef) == "undefined") {
               // this is the first go... create the array for the catentries
               myPSList.CatalogEntryRef = new Array();
            }
            myPSList.CatalogEntryRef[myPSList.CatalogEntryRef.length] = new CatalogEntry(aSelectionArray[i]);
                        }
      }
      // now create all the cat groups...
      for (var i=0; i<aSelectionArray.length; i++) {
         if (aSelectionArray[i].type == "CG") {  // this is a CatalogGroup
            if (typeof(myPSList.CatalogGroupRef) == "undefined") {
               // this is the first go... create the array for the catgroups
               myPSList.CatalogGroupRef = new Array();
            }
            myPSList.CatalogGroupRef[myPSList.CatalogGroupRef.length] = new CatalogGroup(aSelectionArray[i]);
         }
      }
   }

   return myPSList;
}

function CatalogGroup (entry) {
   var myCG = new Object();

   myCG.Owner = entry.member;
   myCG.groupIdentifier = entry.id;

   return myCG;
}

function CatalogEntry (entry) {
   var myCE = new Object();

   myCE.Owner = entry.member;
   myCE.partNumber = entry.id;

   return myCE;
}

function alertDebug(alertString) {
   if (debug) {
      alert(alertString);
   }
}
