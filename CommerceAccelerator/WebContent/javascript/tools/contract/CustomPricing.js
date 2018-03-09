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

function ContractCustomPricingModel () {
   var cpm = new Object();

   cpm.tcInContract = false;
   cpm.modifiedInSession = false;
   cpm.referenceNumber = "";
   cpm.plReferenceNumber = "";
   cpm.name = "";
   cpm.description = "";
   cpm.precedence = "";
   cpm.type = "";
   cpm.member = null;

   // this array stores the defined custom price list
   cpm.customPriceTC = new Array();

   return cpm;
}

function CustomPriceTC () {
   var cptc = new Object();

   cptc.markedForDelete = false;
   cptc.productId = "";
   cptc.productName = "";
   cptc.productMember = null;
   cptc.productIdentifier = "";
   cptc.productShortDescription = "";
   cptc.productPublished = "";
   cptc.productQuantityUnit = "";
   cptc.productField1 = "";
   cptc.productPriceInfo = new Array();

   return cptc;
}

function cloneCustomPriceTC (source, target) {
   // copy all the high level attributes
   target.markedForDelete = source.markedForDelete;
   target.productId = source.productId;
   target.productName = source.productName;
   target.productMember = source.productMember;
   target.productIdentifier = source.productIdentifier;
   target.productShortDescription = source.productShortDescription;
   target.productPublished = source.productPublished;
   target.productQuantityUnit = source.productQuantityUnit;
   target.productField1 = source.productField1;
   cloneCustomProductPriceArray(source.productPriceInfo, target.productPriceInfo);
}

function cloneCustomProductPriceArray (source, target) {
   for (i=0; i<source.length; i++) {
      target[target.length] = new CustomProductPrice(source[i].productPrice, source[i].productPriceCurrency, source[i].productPriceIsDefault);
   }
}

// function to create a CustomProductPrice object.
function CustomProductPrice (cpPrice, cpPriceCurrency, cpPriceIsDefault) {
   var myCPP = new Object();

   myCPP.productPrice = cpPrice;
   myCPP.productPriceCurrency = cpPriceCurrency;
   myCPP.productPriceIsDefault = cpPriceIsDefault;

   return myCPP;
}

///////////////////////////////////////
// SUBMIT/VALIDATION SCRIPTS
///////////////////////////////////////

function validateCustomPricing () {
   return true;
}

function submitCustomPricing (contract) {

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

   // get the custom pricing model!
   var cpm = get("ContractCustomPricingModel");

   if (cpm != null) {
      if (cpm.customPriceTC.length > 0) {
         // there is currently at least one product defined in the custom pricing model
         // create a custom price list XML
         createPriceTCCustomPriceList(contract, cpm);
      }
   }

   return true;
}

function createPriceTCCustomPriceList (contract, cptc) {
   var commonModel = get("ContractCommonDataModel");
   var myTC;
   var action;

   if (!cptc.tcInContract) {
      action = "new";
   }
   else {
      action = "delete";
      for (var i=0; i<cptc.customPriceTC.length; i++) {
         if (!cptc.customPriceTC[i].markedForDelete) {
            if (cptc.modifiedInSession) action = "update";
            else action = "noaction";
            break;
         }
      }
   }

   myTC = new Object();
   myTC.action = action;
   if ((action != "new") && (action != "noaction")) {
      myTC.referenceNumber = cptc.referenceNumber;
   }

   myTC.PriceList = new Object();
   if ((action != "new") && (action != "noaction")) {
      //myTC.PriceTC.PriceTCCustomPriceList.PriceList.referenceNumber = cptc.plReferenceNumber;
   }
   if (cptc.name == "") {
      cptc.name = get("ContractGeneralModel").name + "_CustomPriceList";
   }
   myTC.PriceList.name = cptc.name;
   myTC.PriceList.description = cptc.description;
   myTC.PriceList.precedence = cptc.precedence;
   myTC.PriceList.type = cptc.type;

   var offerLength = 0;
   myTC.PriceList.Offer = new Array();
   for (var i=0; i<cptc.customPriceTC.length; i++) {
      if ((!cptc.customPriceTC[i].markedForDelete) || (action == "delete")) {
         myTC.PriceList.Offer[offerLength] = new Object();
         if ((action != "new") && (action != "noaction")) {
            //myTC.PriceTC.PriceTCCustomPriceList.PriceList.Offer[offerLength].referenceNumber = cptc.plReferenceNumber;
         }
         myTC.PriceList.Offer[offerLength].published = cptc.customPriceTC[i].productPublished;
         myTC.PriceList.Offer[offerLength].quantityUnit = cptc.customPriceTC[i].productQuantityUnit;
         myTC.PriceList.Offer[offerLength].skuNumber = cptc.customPriceTC[i].productIdentifier;
         myTC.PriceList.Offer[offerLength].field1 = cptc.customPriceTC[i].productField1;

         if (cptc.customPriceTC[i].productPriceInfo.length > 0) {
            var priceLength = 0;
            myTC.PriceList.Offer[offerLength].OfferPrice = new Array();
            for (var j=0; j<cptc.customPriceTC[i].productPriceInfo.length; j++) {
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength] = new Object();
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength].MonetaryAmount = new Object();
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength].MonetaryAmount.value = cptc.customPriceTC[i].productPriceInfo[j].productPrice; // item price
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength].MonetaryAmount.currency = cptc.customPriceTC[i].productPriceInfo[j].productPriceCurrency; // item currency
               priceLength++;
            }
         }

         myTC.PriceList.Offer[offerLength].Owner = cptc.customPriceTC[i].productMember;
         offerLength++;
      }
   }

   myTC.PriceList.Owner = cptc.member;

   // add the custom price TC to the TC array
   if (offerLength > 0) {
      contract.PriceTCCustomPriceList = new Object();
      contract.PriceTCCustomPriceList = myTC;
   }

   return true;
}
