/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* 5724-A18
*
* (c) Copyright IBM Corp. 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

//////////////////////////////////////////////////////////////
// Function to display the JLOM and JROM for testing purposes
//////////////////////////////////////////////////////////////

function displayJROM(){
   var display = "JROM: \n\n";
   var JROMRows = getJROMRows();
   for (i in JROMRows) {
      display = display + "RowID: " + i  + " Type= " + JROMRows[i].nodeType + " RefID= " +   JROMRows[i].refID + " mode= " + JROMRows[i].mode + " Synch= " + JROMRows[i].synch + " Adj= " + JROMRows[i].adjustment + "\n";
   }
   //alert(display);
}

function displayJLOM(){
   var display = "JLOM:  \n\n";
   var JLOM = getJLOM();
   for (refID in JLOM){
      display = display + "RowID: " + refID  + " Type= " + JLOM[refID].nodeType + " RefID= " +  JLOM[refID].refID + " mode= " + JLOM[refID].mode + " Synch= " + JLOM[refID].synch + " Adj= " + JLOM[refID].adjustment +  " Prec= " + JLOM[refID].precedence + "\n";
   }
   //alert(display);
}


/*d79166*/
function displayJKIT()
{
   var display = "[JKIT javascript object model]\n\n";
   var jkit = getJKIT();
   if (jkit==null) { alert("JKIT is empty"); return; }

   display += "referenceNumber=" + jkit.referenceNumber + "\n";
   display += "action=" + jkit.action + "\n";
   display += "storeDefaultCurrency=" + jkit.storeDefaultCurrency + "\n";

   var configList = jkit.configurationList;
   display += "configurations list: \n";

   for (kitID in configList)
   {
      display = display + "   kitID: " + kitID
              + ", refID= " + configList[kitID].catalogEntryRef
              + ", action= " + configList[kitID].action
              + "\n";

      var blockList = configList[kitID].buildBlockList;
      for (bbID in blockList)
      {
         display = display + "      bbID: " + bbID
                 + ", refID= " + blockList[bbID].catalogEntryRef
                 + ", name= " + blockList[bbID].name
                 + ", sku= " + blockList[bbID].sku
                 + ", adjType= " + blockList[bbID].adjustmentType + "\n";

         if (   (blockList[bbID].percentageOfferAdjustmentValue!=null)
             && (blockList[bbID].percentageOfferAdjustmentValue!="") )
         {
            display += "         precentageAdjustment: adjValue= " + blockList[bbID].percentageOfferAdjustmentValue
                    + ", offerType= " + blockList[bbID].percentageOfferType + "\n";
         }

         var priceOfferList = blockList[bbID].priceOffers;
         for(currencyID in priceOfferList)
         {
            display += "         priceAdjustment[" + currencyID + "]: value=" + priceOfferList[currencyID].priceAdjustmentValue
                     + ", currency= " + priceOfferList[currencyID].priceCurrency
                     + "\n";

         }//end-for-currencyID

      }//end-for-bbID

   }//end-for-kitID

   alert(display);
}


////////////////////////////////////////////////////////////////
// Functions accessible to the JROM and JLOM model
////////////////////////////////////////////////////////////////

// This function creates a new JLOM row
function JLOMrow (rowID, precedence, nodeType, refID, mode, synch, adjustment) {
   this.rowID = rowID;
   this.precedence = precedence;
   this.nodeType = nodeType;
   this.refID = refID;
   this.mode = mode;
   this.synch = synch;
   this.adjustment = adjustment;
}

// This function creates a new JROM row
function JROMrow (rowID, precedence, nodeType, refID, mode, synch, adjustment) {
   this.rowID = rowID;
   this.precedence = precedence;
   this.nodeType = nodeType;
   this.refID = refID;
   this.mode = mode;
   this.synch = synch;
   this.adjustment = adjustment;
}

// This function adds a new JROM row to the JROM array.
function addNewJROMRow(JROMID, precedence, nodeType, mode, synch, adjustment) {
   var JROMRows = getJROMRows();
   var refID = JROMID.substring(3, JROMID.length);
   JROMRows[JROMID] = new JROMrow (JROMID, precedence, nodeType, refID, mode, synch, adjustment);
}

// This function adds a new JLOM row to the JLOM array.
function addNewJLOMRow(JLOMID, precedence, nodeType, mode, synch, adjustment) {
   var JLOM = getJLOM();
   var refID = JLOMID.substring(3, JLOMID.length);
   JLOM[JLOMID] = new JLOMrow (JLOMID, precedence, nodeType, refID, mode, synch, adjustment);
}

// This function is used to save changes made to the JLOM array
function saveJLOMRow(JLOMID, precedence, nodeType, mode, synch, adjustment){

   var JROM = getJROM();
   if (nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG]){
      synch = "true";

   }
   else if (nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATENTRY]){
      synch = "true";
   }

   var JLOMrow = findRowInJLOM(JLOMID);
   //modify
   if (JLOMrow != null) {
      JLOMrow.mode = mode;
      JLOMrow.synch = synch;
      JLOMrow.adjustment = adjustment;

   // create a new row in JLOM
   }
   else {
      addNewJLOMRow(JLOMID, precedence, nodeType, mode, synch, adjustment);
   }

   // ensure the save/cancel buttons are enabled
   enableDialogButtons();
}

// This function returns the corresponding row of the last node selected from the JLOM or JROM model.
function getSelectedNodeRowFromModel(){
   var lastNode = tree.getHighlightedNode();
   if (lastNode!="") {
      var ref_id = lastNode.value;
      var JLOMrow = findRowInJLOM(ref_id);
      if(JLOMrow != null){
         return JLOMrow;
      }else{
         return findRowInJROM(ref_id);
      }
   }
}

// This function returns the row as specified by the rowID from the JROM.
function findRowInJROM(rowID){
   var JROMRows = getJROMRows();
   return JROMRows[rowID];
}

// This function returns the row as specified by the rowID from the JLOM.
function findRowInJLOM(rowID){
   var JLOM = getJLOM();
   return JLOM[rowID];
}

// This function returns the length of the JLOM.
function getJLOMSize(){
   var JLOM = getJLOM();
   var i = 0;
   for(rowID in JLOM){
      i++;
   }
   return i;
}

// This function returns the row as specified by the rowID from the model.
function findRowInModel(rowID){
   var JLOMrow = findRowInJLOM(rowID);
      if(JLOMrow != null){
         return JLOMrow;
      }else{
         return findRowInJROM(rowID);
      }

}

// This function returns the first instance of a catalog in the model.
function findCatalogInModel(){

   var JROMRows = getJROMRows();
   var JLOM = getJLOM();
   var JROM = getJROM();

   for (refID in JLOM){
      if(JLOM[refID].nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG]){
         return JLOM[refID];
      }
   }

   for (refID in JROMRows){
      if(JROMRows[refID].nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG]){
         return JROMRows[refID];
      }
   }

   // if not found, then return null
   return null;
}

// This function returns the node name.
function getNodeText(node){
   return trimPercentage(node.name);
}

// This function sets the node name.
function setNodeText(node, newText){
   node.name = newText;
}

// This function trims the text to remove the percentage section at the end of the text.
function trimPercentage(text){
   var textLength = text.length;
   var sub = text.substring(textLength-1, textLength);

   if(sub == "]"){
      var pos = text.lastIndexOf(" [", textLength-1);
      var newText = text.substring(0, pos);
      return newText;

   }
   return text;
}

// This function adds an additional icon to the node selected.
function addIcon(node, newIcon){
   node.userIcons[node.userIcons.length] = "/wcs/images/tools/contract/" + newIcon;

}

// This function replaces the folder icon depending on whether it is an open or closed folder
function doIconReplacement(node, opengif, closedgif){
   if(opengif == null){
      //node.openIcon = opengif;
      node.setOpenIcon(null);
   }else{
      node.setOpenIcon("/wcs/images/tools/contract/" + opengif);
   }

   if(closedgif == null){
      //node.icon = closedgif;
      node.setIcon(null);
   }else{
      node.setIcon("/wcs/images/tools/contract/" + closedgif);

   }

}

// This function finds the index of the offer in the store default currency
function findStoreDefaultCurrencyIndex(productPriceInfo) {
   if (productPriceInfo == null)
      return 0;

   for (var j=0; j<productPriceInfo.length; j++) {
      if (productPriceInfo[j].productPriceIsDefault == true) {
         return j;
      }
   }
   return 0;
}

// This function determines the action done by the user on a particular node specified by the rowID.
function getAction(rowID){
   var JLOMRow = findRowInJLOM(rowID);
   var JROMRow = findRowInJROM(rowID);
   var JROM = getJROM();

   var newAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_NEW];
   var updateAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_UPDATE];
   var deleteAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE];
   var noAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_NOACTION];

   //new action
   if(JLOMRow != null && JROMRow == null){
      if(JLOMRow.mode != "DELETED"){
         return newAction;
      }else{
         return null;
      }

   //update action or delete action
   }else if(JLOMRow != null && JROMRow != null){
      if(JLOMRow.mode != "DELETED"){
         return updateAction;
      }else{
         return deleteAction;
      }
   //no action
   }else if(JLOMRow == null && JROMRow != null){
      return noAction;
   }
   return null;
}

////////////////////////////////////////////////////////////////
// Functions accessible to the JPOM model
////////////////////////////////////////////////////////////////

function getJPOMsize() {
   var JPOM = getJPOM();
   var size = 0

   for (var key in JPOM) {
      size++;
   }
   return size;
}

function printJPOM() {
   var JPOM = getJPOM();
   var JPOMstring = "JPOM[size="+getJPOMsize()+"]:\n";

   for (var key in JPOM) {
      JPOMstring += "key="+key+" value="+JPOM[key]+"\n";
   }

   return JPOMstring;
}

function printJPOMallowableValues() {
   var JPOM = getJPOM();
   var JPOMstring = "<br>";
   var spacer = ", ";
   var sortedJPOM = new Array();

   // build new array by adjustment key...
   for (var key in JPOM) {
      sortedJPOM[sortedJPOM.length] = key;
   }

   sortedJPOM.sort(compareJPOMadjustments);

   for (var i=0; i<sortedJPOM.length; i++) {
      if (i != 0) JPOMstring += ", ";
      JPOMstring += sortedJPOM[i];
   }

   return JPOMstring;
}

function compareJPOMadjustments(a, b) {
   return a - b;
}

function addToJPOM(adjustment) {
   var JPOM = getJPOM();

   // if the adjustment exists, increment the counter
   // otherwise, set the counter to 1
   var count = inJPOM(adjustment);

   if (count > 0) JPOM[adjustment]++;
   else (JPOM[adjustment]) = 1;

   // return the new count
   return count++;
}

function removeFromJPOM(adjustment) {
   var JPOM = getJPOM();

   // if the count == 1, then we are removing the last entry.  delete from the hash table
   // if count >= 2, then decrement the count
   // otherwise, there is nothing to remove.  this is an error.
   var count = inJPOM(adjustment);
   if (count == 1) {
      delete(JPOM[adjustment]);
      count = 0;
   }
   else if (count > 1) {
      JPOM[adjustment]--;
      count--;
   }
   else if (count == 0) {
      count = 0;
   }

   // return the new count for the adjustment
   return count;
}

function inJPOM(adjustment) {
   // check to see if an adjustment exists in the JPOM.
   // if it does return the count, otherwise return 0
   var JPOM = getJPOM();
   var count = JPOM[adjustment];
   if (count) return count;
   else return 0;
}


/////////////////////////////////////////////////////////////////
// XML CREATION SCRIPTS
/////////////////////////////////////////////////////////////////

function createPriceTCMasterCatalogWithFiltering(){
   var JROM = getJROM();
   var myPriceTCMasterCatalogWithFiltering = new Object();
   var pricePolicyArray = new Array();
   // loop through the price policies and add them to the TC XML
   for (var i=0; i<JROM.priceListPolicyArray.length; i++) {
      pricePolicyArray[i] = new PolicyReference("Price", JROM.priceListPolicyArray[i]);
   }
   if (pricePolicyArray.length > 0) {
      myPriceTCMasterCatalogWithFiltering.PricePolicyRef = pricePolicyArray;
   }
   // add the catalog selections to the the TC XML
   myPriceTCMasterCatalogWithFiltering.CatalogSelection = new CatalogSelection();
   return myPriceTCMasterCatalogWithFiltering;
}

function CatalogSelection() {

   var myCatalogSelection = new Object();
   var catalogRow = findCatalogInModel();
   var JROMRows = getJROMRows();
   var JROM = getJROM();

   myCatalogSelection.CatalogRef = new CatalogRef();
   if (JROM.contractOwner != null) {
      myCatalogSelection.ProductSetOwner = JROM.contractOwner;
   } else {
      myCatalogSelection.ProductSetOwner = new Object();
      myCatalogSelection.ProductSetOwner.OrganizationRef = new Object();
      myCatalogSelection.ProductSetOwner.OrganizationRef.distinguishName = get("ContractCommonDataModel").storeMemberDN;
   }

   var rowAction = null;
   var includeEntireCatalogValue = "false";
   var adjustmentValue = 0;

   if(catalogRow != null){

      var catalogRowMode = null;
      rowAction = getAction(catalogRow.rowID);

      // when rowAction == "delete", this means that there is a row in JROM
      if(rowAction == JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE]){
         var JROMrow = JROMRows[catalogRow.rowID];

         //set the mode to "Exclude" so that includeEntireCatalog is false
         catalogRowMode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE];
         adjustmentValue = 0;

         // rowAction is set to "update" when we do a "delete" on the catalog
         rowAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_UPDATE];
      }else{
         catalogRowMode = catalogRow.mode;
         adjustmentValue = catalogRow.adjustment;
      }


      // if unsynched, then you cannot include the entire catalog
      if (JROM.includedCategoriesAreUnSynched == true) {
         //set the mode to "Exclude" so that includeEntireCatalog is false
         catalogRowMode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE];
         adjustmentValue = 0;
      }

      if(catalogRowMode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]){
         includeEntireCatalogValue = "true";
      }else if(catalogRowMode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]){
         includeEntireCatalogValue = "false";
      }

   }else{
      rowAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_NOACTION];
   }
  if(rowAction == null || rowAction==""){
		rowAction=JROM.ACTION_TYPES[JROM.ACTION_TYPE_NOACTION];	
	}
  if(adjustmentValue=="DELETED"){
		adjustmentValue=0;
	}

   myCatalogSelection.action = rowAction;
   myCatalogSelection.includeEntireCatalog = includeEntireCatalogValue;
   myCatalogSelection.signedPercentage = adjustmentValue;
   myCatalogSelection.immediateDeploy = "true";
   generateSelections(myCatalogSelection);
   return myCatalogSelection;
}

function CatalogRef(){
   var myCatalogRef = new Object();
   var JROM = getJROM();

   if(JROM.catalogReferenceNumber != null && JROM.catalogReferenceNumber != ""){
      myCatalogRef.catalogReferenceNumber = JROM.catalogReferenceNumber;
   }
   // for some reason, this causes a javascript error in some situations
   //if(JROM.catalogIdentifier != null && JROM.catalogIdentifier != "" && JROM.catalogOwner != null && JROM.catalogOwner != ""){
      myCatalogRef.name = JROM.catalogIdentifier;
      myCatalogRef.Owner = JROM.catalogOwner;
   //}
   return myCatalogRef;
}

function generateSelections(myCatalogSelection){
   var JLOM = getJLOM();
   var JROMRows = getJROMRows();
   var JROM = getJROM();
   var selectionArray = new Array();

   var i = 0;
   for(rowID in JLOM){
      var rowAction = getAction(JLOM[rowID].rowID);

      //(rowAction != null) means that there is a new row in the JLOM but the settings have been cancelled.
      if(JLOM[rowID].nodeType != JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG] && rowAction != null){
         var sel = new Selection(JLOM[rowID]);
         if (sel != null)
            selectionArray[i++] = sel;
      }
   }

   for(rowID in JROMRows){
      var JLOMrow = findRowInJLOM(JROMRows[rowID].rowID);

      // no action occurred for this JROM row.
      if(JLOMrow == null && JROMRows[rowID].nodeType != JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG]){
         var sel = new Selection(JROMRows[rowID]);
         if (sel != null)
            selectionArray[i++] = sel;
      }
   }

   if(selectionArray.length > 0){
      myCatalogSelection.Selection = selectionArray;
   }
}

function Selection(row){
   var mySelection = new Object();
   var JROMRows = getJROMRows();
   var JROM = getJROM();

   if(row != null){
      var rowAction = getAction(row.rowID);

      if(rowAction != null){
         mySelection.action = rowAction;

         // when rowAction == "delete", this means that there is a row in JROM
         if(rowAction == JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE]){
            if (JROM.contractState == JROM.CONTRACT_STATUS_DRAFT) {
               // for draft contracts, don't save delete items
               return null;
            }
            var JROMrow = JROMRows[row.rowID];
            mySelection.type = JROMrow.mode;
            mySelection.synchronize = JROMrow.synch;
            mySelection.Adjustment = new Adjustment(JROMrow);
         }else{
            if (JROM.contractState == JROM.CONTRACT_STATUS_DRAFT) {
               // for draft contracts, all items are new
               mySelection.action = JROM.ACTION_TYPES[JROM.ACTION_TYPE_NEW];
            }
            mySelection.type = row.mode;
            mySelection.synchronize = row.synch;
            mySelection.Adjustment = new Adjustment(row);
         }

         if(row.nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATEGORY]){
            // update synch flag if we are unsynched
            if (JROM.includedCategoriesAreUnSynched == true) {
               mySelection.synchronize = false;
            }
            mySelection.CatalogGroupRef = new CatalogGroupRef(row);
         }else if(row.nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATENTRY]){
            mySelection.CatalogEntryRef = new CatalogEntryRef(row);
         }
      }else{
         return null;
      }
   }
   return mySelection;
}

function Adjustment(row){
   var myAdjustment = new Object();
   var rowAction = getAction(row.rowID);
   if(rowAction != null){
      myAdjustment.signedPercentage = row.adjustment;
   }
   myAdjustment.precedence = row.precedence;
   return myAdjustment;
}

function CatalogGroupRef(row){
   var myCatalogGroupRef = new Object();
   myCatalogGroupRef.catalogGroupReferenceNumber = row.refID;
   return myCatalogGroupRef;
}

function CatalogEntryRef(row){
   var myCatalogEntryRef = new Object();
   myCatalogEntryRef.catalogEntryReferenceNumber = row.refID;
   return myCatalogEntryRef;
}

function createFixedPriceTCCustomPriceList (contract, cptc, contractId) {
   var myTC;
   var action;

   if (!cptc.tcInContract) {
      action = "new";
   }
   else {
      action = "delete";
      for (rowID in cptc.customPriceTC) {
         if (!cptc.customPriceTC[rowID].markedForDelete) {
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
      if (contractId != null && contractId != "null") {
         cptc.name = contractId + "_CustomPriceList";
      } else {
         // try to get new contract name
         cptc.name = get("ContractGeneralModel").name + "_CustomPriceList";
      }
   }
   myTC.PriceList.name = cptc.name;
   myTC.PriceList.description = cptc.description;
   myTC.PriceList.precedence = cptc.precedence;
   myTC.PriceList.type = cptc.type;

   var offerLength = 0;

   for(rowID in cptc.customPriceTC) {

      if ( (cptc.type == "C" && !cptc.customPriceTC[rowID].markedForDelete ) ||
           (cptc.type == "E" && cptc.customPriceTC[rowID].action != "noaction") )
      {
	 if (offerLength == 0) {
		myTC.PriceList.Offer = new Array();
	 }      	
         myTC.PriceList.Offer[offerLength] = new Object();
         myTC.PriceList.Offer[offerLength].published = cptc.customPriceTC[rowID].productPublished;
         myTC.PriceList.Offer[offerLength].referenceNumber = cptc.customPriceTC[rowID].productId;
         myTC.PriceList.Offer[offerLength].field1 = cptc.customPriceTC[rowID].productField1;
         if (cptc.type == "E") {
            myTC.PriceList.Offer[offerLength].action = cptc.customPriceTC[rowID].action;
            // if this was not in the existing contract, we need to modify the action
            if (cptc.customPriceTC[rowID].fromContract == false) {
               if (cptc.customPriceTC[rowID].action == "delete") {
                  myTC.PriceList.Offer[offerLength].action = "noaction";
               } else if (cptc.customPriceTC[rowID].action == "update") {
                  myTC.PriceList.Offer[offerLength].action = "new";
               }
            }
         }

         if (cptc.customPriceTC[rowID].productPriceInfo.length > 0) {
            var priceLength = 0;
            myTC.PriceList.Offer[offerLength].OfferPrice = new Array();
            for (var j=0; j<cptc.customPriceTC[rowID].productPriceInfo.length; j++) {
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength] = new Object();
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength].MonetaryAmount = new Object();
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength].MonetaryAmount.value = cptc.customPriceTC[rowID].productPriceInfo[j].productPrice; // item price
               myTC.PriceList.Offer[offerLength].OfferPrice[priceLength].MonetaryAmount.currency = cptc.customPriceTC[rowID].productPriceInfo[j].productPriceCurrency; // item currency
               priceLength++;
            }
         }
         offerLength++;
      }
   }

   myTC.PriceList.Owner = cptc.member;

   if (action == "delete") {
	// we can't delete the tc because existing orderitems will get deleted
	// just save an empty price list
	myTC.action = "update";
   }
   
   // add the custom price TC to the TC array
   if (offerLength > 0) {
      contract.PriceTCCustomPriceList = new Object();
      contract.PriceTCCustomPriceList = myTC;
      //alert(dumpObject(myTC));
   }

   return true;
}