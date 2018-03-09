//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*


/////////////////////////////////////////////
// MODEL OBJECT CONSTRUCTOR/CLONING SCRIPTS
/////////////////////////////////////////////

function KitPricingModel()
{
   var kpm = new Object();

   kpm.referenceNumber        = "";
   kpm.action                 = "noaction";
   kpm.owner                  = null;
   kpm.storeDefaultCurrency   = "";
   kpm.priceListPolicyArray   = new Array();
   kpm.priceListIdArray       = new Array();
   kpm.configurationList      = new Array();
   kpm.parentConfigurationList = new Array();
   kpm.isValidated            = true;
   return kpm;
}


function KPMConfiguration()
{
   var obj = new Object();

   obj.catalogEntryRef = "";
   obj.action          = "";
   obj.buildBlockList  = new Array();
   return obj;
}


function KPMBuildBlock()
{
   var obj = new Object();

   obj.catalogEntryRef = "";
   obj.name            = "";
   obj.sku             = "";
   obj.adjustmentType  = ""; // 1=markdown, 2=markup, 3=price

   // Percentage offer adjustment
   obj.percentageOfferType = "Include";
   obj.percentageOfferAdjustmentValue = "";

   // A list of price offer adjustments based on currency type
   obj.priceOffers = new Array();

   return obj;
}


function KPMPriceAdjustment()
{
   var obj = new Object();

   obj.priceAdjustmentValue = "";
   obj.priceCurrency        = "";
   obj.priceMinQty          = "";
   obj.priceMaxQty          = "";
   obj.priceStartTime       = "";
   obj.priceEndTime         = "";
   return obj;
}



///////////////////////////////////////
// SUBMIT/VALIDATION SCRIPTS
///////////////////////////////////////

function validateKitPricing()
{
   // The kit pricing adjustment validation is actually done in the
   // kit component pricing form. A validation result flag is set to
   // the KitPricingModel's isValidated attribute. We will use this
   // attribute to determin of passing the validation.

   var getCFM = get("ContractFilterModel");
   if (getCFM==null) { return true; }

   var jkit = getCFM.JKIT;
   if (jkit==null) { return true; }

   return jkit.isValidated;
}



//---------------------------------------------------------------------------
// Function Name: createPriceTCConfigBuildBlock
//
// This function constructs the XML segment for the PriceTCConfigBuildBlock.
//---------------------------------------------------------------------------
function createPriceTCConfigBuildBlock(JKIT, JROM)
{
   var jkit = JKIT;
   var myTC = new Object();

   if (jkit.action=="noaction")
   {
      // Skip, no changes for this terms and conditions
      myTC.action = jkit.action;
   }
   else if (jkit.action=="new")
   {
      myTC.action = jkit.action;
   }
   else if (jkit.action=="update")
   {
      myTC.action = jkit.action;
      myTC.referenceNumber = jkit.referenceNumber;
   }
   else
   {
      // unknown, default to no action
      myTC.action = jkit.action;
   }

   // Construct the XML parts
   createPricePolicyRefXML(JROM, myTC);
   myTC.ConfigBuildBlockList = new Object();
   myTC.ConfigBuildBlockList.Owner = jkit.owner;
   createConfigurationListXML(jkit, myTC);

   return myTC;
}


//---------------------------------------------------------------------------
// Function Name: submitKitPricing
//
// This function prepares the PriceTCConfigBuildBlock XML segment for
// submitting to the server.
//---------------------------------------------------------------------------
function submitKitPricing(contract)
{
   var getCFM = get("ContractFilterModel");
   if (getCFM==null) { return true; }

   var jkit = getCFM.JKIT;
   if (jkit==null) { return true; }

   var jrom = getCFM.JROM;
   if (jrom==null) { return true; }

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

   if ((jkit.action=="new") || (jkit.action=="update"))
   {
      contract.PriceTCConfigBuildBlock = createPriceTCConfigBuildBlock(jkit, jrom);
   }
   else
   {
      // Skip it, no changes for this terms and conditions
      return true;
   }

   return true;
}




//---------------------------------------------------------------------------
// Function Name: createPricePolicyRefXML
//
// This function builds the XML segment for the price policy reference part
//---------------------------------------------------------------------------
function createPricePolicyRefXML(JROM, myTC)
{
   var pricePolicyArray = new Array();

   // loop through the price policies and add them to the TC XML
   for (var i=0; i<JROM.priceListPolicyArray.length; i++)
   {
      pricePolicyArray[i] = new PolicyReference("Price", JROM.priceListPolicyArray[i]);
   }

   if (pricePolicyArray.length > 0)
   {
      myTC.PricePolicyRef = pricePolicyArray;
   }
}



//---------------------------------------------------------------------------
// Function Name: createConfigurationListXML
//
// This function builds the XML segment for the configuration part
//---------------------------------------------------------------------------
function createConfigurationListXML(JKIT, myTC)
{
   var jkit = JKIT;

   myTC.ConfigBuildBlockList.Configuration = new Array();

   var configurationTags = myTC.ConfigBuildBlockList.Configuration;
   var configList = jkit.configurationList;
   var count_i=0;

   for (kitID in configList)
   {
      var temp1_CatalogEntryRef = new Object();
      temp1_CatalogEntryRef.catalogEntryReferenceNumber = configList[kitID].catalogEntryRef;

      configurationTags[count_i]                         = new Object();
      configurationTags[count_i].action                  = configList[kitID].action;
      configurationTags[count_i].Base                    = new Object();
      configurationTags[count_i].Base.CatalogEntryRef    = temp1_CatalogEntryRef;
      configurationTags[count_i].FlatBuildBlockList      = new Object();
      configurationTags[count_i].FlatBuildBlockList.BuildBlock = new Array();

      var count_j=0;
      var blockList = configList[kitID].buildBlockList;
      var buildBlockTags = configurationTags[count_i].FlatBuildBlockList.BuildBlock;

      for (bbID in blockList)
      {
         var temp2_CatalogEntryRef = new Object();
         temp2_CatalogEntryRef.catalogEntryReferenceNumber =  blockList[bbID].catalogEntryRef;

         buildBlockTags[count_j]                  = new Object();
         buildBlockTags[count_j].CatalogEntryRef  = temp2_CatalogEntryRef;


         //-------------------------------------
         // Handling different adjustment types
         //-------------------------------------

         if (blockList[bbID].adjustmentType==1)
         {
            // Construct the 'Mark Down' of BuildBlockPercentageOffer part
            buildBlockTags[count_j].BuildBlockPercentageOffer = new Object();
            //buildBlockTags[count_j].BuildBlockPercentageOffer.type = "Include";
            buildBlockTags[count_j].BuildBlockPercentageOffer.PriceAdjustment = new Object();
            buildBlockTags[count_j].BuildBlockPercentageOffer.PriceAdjustment.signedPercentage
                  = "-" + blockList[bbID].percentageOfferAdjustmentValue;
         }
         else if (blockList[bbID].adjustmentType==2)
         {
            // Construct the 'Mark Up' of BuildBlockPercentageOffer part
            buildBlockTags[count_j].BuildBlockPercentageOffer = new Object();
            //buildBlockTags[count_j].BuildBlockPercentageOffer.type = "Include";
            buildBlockTags[count_j].BuildBlockPercentageOffer.PriceAdjustment = new Object();
            buildBlockTags[count_j].BuildBlockPercentageOffer.PriceAdjustment.signedPercentage
                  = "+" + blockList[bbID].percentageOfferAdjustmentValue;
         }
         else if (blockList[bbID].adjustmentType==3)
         {
            // Construct the BuildBlockFixedOffer part
            buildBlockTags[count_j].BuildBlockFixedOffer = new Array();
            var fixedOfferCount=0;

            for (currencyType in blockList[bbID].priceOffers)
            {
               buildBlockTags[count_j].BuildBlockFixedOffer[fixedOfferCount]
                     = new Object();
               buildBlockTags[count_j].BuildBlockFixedOffer[fixedOfferCount].MonetaryAmount
                     = new Object();
               buildBlockTags[count_j].BuildBlockFixedOffer[fixedOfferCount].MonetaryAmount.value
                     = blockList[bbID].priceOffers[currencyType].priceAdjustmentValue;
               buildBlockTags[count_j].BuildBlockFixedOffer[fixedOfferCount].MonetaryAmount.currency
                     = blockList[bbID].priceOffers[currencyType].priceCurrency;

               fixedOfferCount++;

            }//end-for-currencyType

         }//end-if-else

         count_j++;

      }//end-for-bbID

      count_i++;

   }//end-for-kitID

}

