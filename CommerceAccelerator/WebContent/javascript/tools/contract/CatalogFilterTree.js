/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2002, 2003, 2004
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/



// The catalog and category iframes are created when the catalog tree is loaded.
window.onload=createDialogFrames;

DTreeConfig.rootIcon = '/wcs/images/tools/contract/folderclosed.gif';
DTreeConfig.openRootIcon = '/wcs/images/tools/contract/folderopen.gif';
DTreeConfig.folderIcon = '/wcs/images/tools/contract/folderclosed.gif';
DTreeConfig.openFolderIcon = '/wcs/images/tools/contract/folderopen.gif';
DTreeConfig.fileIcon = null;
DTreeConfig.contextMenuButton = 'both';

// This is a global variable that indicates whether the "Calculate Price" menu item is enabled or not
var showCalculatePriceMenuItem = true;

// global variable that points to the JROM
var JROM = parent.getJROM();

var nodeType;
var indicatorTimeout = 100;

// global for the truncated merchant store name
var gStoreName = null;

// myHash is a temporary object to hold temporary data.
var myHash = new Object();

function put(key, value){
   myHash[key] = value;
}

function get(key){
   return myHash[key];
}

function remove(key){
   myHash[key] = null;
}

//This function brings up the catalog include iframe when the include menu is chosen for a catalog node.
function catalogIncludeDialog(type) {
   if (JROM.delegationGrid == false) {
      popupIFRAME("catalogIncludeIframe", type);
   } else {
      popupIFRAME("delegationGridIframe", type);
   }
}

//This function brings up the category include iframe when the include menu is chosen for a category node.
function categoryIncludeDialog(type) {
   if (JROM.delegationGrid == false) {
      popupIFRAME("categoryIncludeIframe", type);
      } else {
      popupIFRAME("delegationGridIframe", type);
   }
}

//This function brings up the catentry include iframe when the include menu is chosen for a catentry node.
function catentryIncludeDialog(type) {
   if (JROM.delegationGrid == false) {
      popupIFRAME("catentryIncludeIframe", type);
   } else {
      popupIFRAME("delegationGridIframe", type);
   }
}

function popupIFRAME(IFRAMEid, type) {

   var lastNode = getHighlightedNode();
   var oCM = document.getElementById("ContextMenu");

   isLoaded = document.getElementById(IFRAMEid).contentWindow.isLoaded;

   if(! defined(isLoaded)) {
      // if the IFRAME is not loaded yet, then try to reload it...
      document.getElementById(IFRAMEid).contentWindow.document.location.reload();

      alertDialog(parent.getIFRAMEnotLoadedMessage());
   }
   else {
      document.getElementById(IFRAMEid).style.top = getObjPageY(oCM);
      document.getElementById(IFRAMEid).style.left = getObjPageX(oCM);

      var nodeType = getType(type);
      document.getElementById(IFRAMEid).style.visibility = "visible";
      document.getElementById(IFRAMEid).contentWindow.load(nodeType);
   }
}

// This function cancels all the settings for the node chosen as well as the implicit children nodes.
function cancelSettings(type){
   nodeType = type;
   var lastNodeSelected = getHighlightedNode();

   // start the refreshing indicator
   startIndicator(lastNodeSelected.id + "-anchor", parent.getIndicatorMessage());

   setTimeout("doCancelSettings(nodeType)", indicatorTimeout);
}

// This function cancels all the settings for the node chosen as well as the implicit children nodes.
function doCancelSettings(type){
   var nodeType = getType(type);
   var lastNodeSelected = getHighlightedNode();
   var precedence = getLastNodePrecedence();

   // start the refreshing indicator
   startIndicator(lastNodeSelected.id + "-anchor", parent.getIndicatorMessage());

   // check for a fixed price entry
   var FIXED = parent.getFIXED();
   if (FIXED.customPriceTC[lastNodeSelected.value] != null && !FIXED.customPriceTC[lastNodeSelected.value].markedForDelete) {
      FIXED.customPriceTC[lastNodeSelected.value].markedForDelete = true;
      FIXED.customPriceTC[lastNodeSelected.value].action = "delete";
      FIXED.modifiedInSession = true;
      parent.enableDialogButtons();
   } else {
      // clear the entry from the JPOM if this is a catentry node!
      if (nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATENTRY]) {
         parent.removeFromJPOM(lastNodeSelected.adjustment);
      }

      // saving the changes
         parent.saveJLOMRow(lastNodeSelected.value, precedence, nodeType, "DELETED", "DELETED", "DELETED");
      }

      // if the node is root
   if(lastNodeSelected.parentNode == null || lastNodeSelected.parentNode == "" ){
      lastNodeSelected.mode = null;
      lastNodeSelected.adjustment = null;
      lastNodeSelected.isExplicit = false;
   }else{
      // get the settings of the parent and assign them to the children
      lastNodeSelected.adjustment = lastNodeSelected.parentNode.adjustment;
      lastNodeSelected.mode = lastNodeSelected.parentNode.mode;
      lastNodeSelected.synch = lastNodeSelected.parentNode.synch;
      lastNodeSelected.isExplicit = false;
   }

   // set the node filters as well as the children.
   setNodeFilters(lastNodeSelected, lastNodeSelected.mode, lastNodeSelected.adjustment, lastNodeSelected.isExplicit, lastNodeSelected.synch);
   setChildrenNodesSettings(lastNodeSelected, lastNodeSelected.mode, lastNodeSelected.adjustment, lastNodeSelected.synch, false);

   // refresh the tree and stop the refreshing indicator
   stopIndicator();
}

// This function performs a quick include on the node selected. Quick Include will set the price adjustment to 0 and will
// synchronize the node.
function quickInclude(type){

   var nodeType = getType(type);

   // if we do not know if the category inclusions are synched or not, then ask the user
   if(nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATEGORY] && JROM.includedCategoriesAreSynched == false && JROM.includedCategoriesAreUnSynched == false){
      if(confirmDialog(parent.getIncludeCategorySynchronizedQuestion())){
         JROM.includedCategoriesAreSynched = true;
      } else {
         JROM.includedCategoriesAreUnSynched = true;
         var catalogRow = parent.findCatalogInModel();
         if (catalogRow != null) {
//alert('remove catalog setting');
               removeRootNodeSetting(lastNodeSelected.parentNode);
         }
      }
//alert("Synch " + JROM.includedCategoriesAreSynched + " UnSynch " + JROM.includedCategoriesAreUnSynched);
      parent.refreshCatalogFilterTitleDivision();
   }

   var lastNodeSelected = parent.tree.getHighlightedNode();
      var synch = "true";
      if (JROM.includedCategoriesAreUnSynched == true) {
         synch = "false";
      }
      var adjustment = 0;
      var precedence = getLastNodePrecedence();

   // start the refreshing indicator
   startIndicator(lastNodeSelected.id + "-anchor", parent.getIndicatorMessage());

   // saving the node's filters
   parent.saveJLOMRow(lastNodeSelected.value, precedence, nodeType, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], synch, adjustment);

   // set the node filters as well as the children.
   setNodeFilters(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], adjustment, true, synch);
   setChildrenNodesSettings(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE], adjustment, "false");

   // stop the refreshing indicator
   stopIndicator();
}

// This function performs a quick Exclude on the selected node. Quick Exclude will set the mode to "exclude" and will synchronize the node.
function quickExclude(type){

   var nodeType = getType(type);
   var confirmMessage = parent.getConfirmExclusionMessageText();
   var lastNodeSelected = getHighlightedNode();
   var doExclusion = true;

   if(hasChildInclusion(lastNodeSelected)){
      if(!confirmDialog(confirmMessage)){
         doExclusion = false;
      }
   }

   if(doExclusion){
      // start the refreshing indicator
      startIndicator(lastNodeSelected.id + "-anchor", parent.getIndicatorMessage());

      // check for a fixed price entry
      var FIXED = parent.getFIXED();
      if (FIXED.customPriceTC[lastNodeSelected.value] != null) {
         FIXED.customPriceTC[lastNodeSelected.value].markedForDelete = true;
         FIXED.customPriceTC[lastNodeSelected.value].action = "delete";
         FIXED.modifiedInSession = true;
         parent.enableDialogButtons();
      } else {
         // clear the entry from the JPOM if this is an explicitly set catentry node!
         if (lastNodeSelected.isExplicit && nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATENTRY]) {
            parent.removeFromJPOM(lastNodeSelected.adjustment);
         }
      }
         var synch = "true";
         var adjustment = 0; // cancel out any previous adjustment
         var precedence = getLastNodePrecedence();

         // saving the node' filters
      parent.saveJLOMRow(lastNodeSelected.value, precedence, nodeType, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE], synch, adjustment);


      // set the node filters as well as the children.
      setNodeFilters(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE], adjustment, true, "true");
      setChildrenNodesSettings(lastNodeSelected, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE], adjustment, "true", true);

      // stop the refreshing indicator
      stopIndicator();
   }
}

function excludeNode(nodeItem, type){

   var confirmMessage = parent.getConfirmExclusionMessageText();
   var doExclusion = true;

   if(hasChildInclusion(nodeItem)){
      if(!confirmDialog(confirmMessage)){
         doExclusion = false;
      }
   }

   if(doExclusion){
      // check for a fixed price entry
      var FIXED = parent.getFIXED();
      if (FIXED.customPriceTC[nodeItem.value] != null) {
         FIXED.customPriceTC[nodeItem.value].markedForDelete = true;
         FIXED.customPriceTC[nodeItem.value].action = "delete";
         FIXED.modifiedInSession = true;
      } else {
         // clear the entry from the JPOM if this is an explicitly set catentry node!
         if (nodeItem.isExplicit && type == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATENTRY]) {
            parent.removeFromJPOM(nodeItem.adjustment);
         }

            var synch = "true";
            var adjustment = 0; // cancel out any previous adjustment
            var precedence = getNodePrecedence(nodeItem);

            // saving the node' filters
         parent.saveJLOMRow(nodeItem.value, precedence, nodeType, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE], synch, adjustment);
      }

      // set the node filters as well as the children.
      setNodeFilters(nodeItem, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE], adjustment, true, "true");
      setChildrenNodesSettings(nodeItem, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE], adjustment, "true", true);

      nodeItem.redrawAll();
   }
}

function removeRootNodeSetting(nodeItem){

   // find the root node
   var rootNode = null;
   while (rootNode == null) {
      if (nodeItem.parentNode == null)
         rootNode = nodeItem;
      nodeItem = nodeItem.parentNode;
   }

   // remove the setting
   parent.saveJLOMRow(rootNode.value, 0, JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG], "DELETED", "DELETED", "DELETED");

   rootNode.mode = null;
   rootNode.adjustment = null;
   rootNode.isExplicit = false;

   // set the node filters as well as the children.
   setNodeFilters(rootNode, rootNode.mode, rootNode.adjustment, rootNode.isExplicit, rootNode.synch);
   setChildrenNodesSettings(rootNode, rootNode.mode, rootNode.adjustment, rootNode.synch, false);

   rootNode.redrawAll();

}

// This function is being called when the user tries to expand an excluded category or an excluded product.
function popAlertBox(){
   alertDialog(parent.getNotExpandableNLText());
}

// This function calculates and returns the price of a catentry.
function calculatePrice(){
   var lastNodeSelected = getHighlightedNode();
   var catentryID = lastNodeSelected.value.substring(3, lastNodeSelected.value.length);

   // check first if changes have been made to the tree.
   if(parent.getJLOMSize() > 0){
      alertDialog(parent.getCannotPerformCalculatePriceMessageText());
      showCalculatePriceMenuItem = false;
      return;
   }

   // start the refreshing indicator
   startIndicator(lastNodeSelected.id + "-anchor", parent.getCalculateMessage());

   // create the calculatePrice iframe
   var calculatePriceIframeDialog = document.createElement("IFRAME");
   calculatePriceIframeDialog.id="calculatePriceIframe";
   calculatePriceIframeDialog.src="/webapp/wcs/tools/servlet/ContractCatalogFilterPriceCalculationPanel?catentryID=" + catentryID + "&contractID=" + JROM.contractId  + "&catentryName=" + parent.getNodeText(lastNodeSelected);
   calculatePriceIframeDialog.style.position = "absolute";
   calculatePriceIframeDialog.style.visibility = "hidden";
   calculatePriceIframeDialog.style.height="130";
   calculatePriceIframeDialog.style.width="220";
   calculatePriceIframeDialog.style.top="130";
   calculatePriceIframeDialog.style.left="330";
   calculatePriceIframeDialog.frameborder="1";
   calculatePriceIframeDialog.MARGINHEIGHT="0"
   calculatePriceIframeDialog.MARGINWIDTH="0";
   document.body.appendChild(calculatePriceIframeDialog);

   // the indicator will be stoped when the alert popup comes up.

   // set the node filters
   setNodeFilters(lastNodeSelected, lastNodeSelected.mode, lastNodeSelected.adjustment, lastNodeSelected.isExplicit, lastNodeSelected.synch);
}

// This function returns the node type.
function getType(type){

   if(type == JROM.FILTER_TYPE_CATALOG){
      return JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG];
   }else if(type == JROM.FILTER_TYPE_CATEGORY){
      return JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATEGORY];
   }else{
      return JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATENTRY];
   }
}

// This function returns the precedence of the last node selected.
function getLastNodePrecedence(){

   var lastNodeSelected = getHighlightedNode();
   var lastNodePath = getValuePath(lastNodeSelected);
   var precedence = numOfOccur(lastNodePath, '/');

   if(lastNodeSelected.isCatentryNode){
         if(lastNodeSelected.isProduct){
         precedence = JROM.DEFAULT_PRODUCT_PRECEDENCE;
      }
         else if(lastNodeSelected.isItem){
         precedence = JROM.DEFAULT_ITEM_PRECEDENCE;
      }
      else {
         precedence = JROM.DEFAULT_ITEM_PRECEDENCE;
      }
   }

   return precedence;
}

// This function returns the precedence of a node.
// Currently only called for Category nodes
function getNodePrecedence(nodeItem){

   var lastNodePath = getValuePath(nodeItem);
   var precedence = numOfOccur(lastNodePath, '/');

/* if(nodeItem.isCatentryNode){
         if(nodeItem.isProduct){
         precedence = JROM.DEFAULT_PRODUCT_PRECEDENCE;
      }
         else if(nodeItem.isItem){
         precedence = JROM.DEFAULT_ITEM_PRECEDENCE;
      }
      else {
         precedence = JROM.DEFAULT_PRODUCT_PRECEDENCE;
      }
   }
*/
//alert(precedence);

   return precedence;
}

// This function loads the "markup" or the "markdown" value depending on the sign of the adjustment.
function loadSignedAdjustment(adjustment,sign) {
    if (adjustment > 0) {
        // this is a markup
        sign.options[1].selected = true;
    }
    else {
        // this is a markdown
        sign.options[0].selected = true;
    }
}


// This function gets the signed adjustment value depending on whether the adjustment is a "markup" or a "markown".
function getSignedAdjustment(adjustment, sign) {

    var signedAdjustment = parent.parent.strToNumber(adjustment, JROM.languageId);
    var signValue = sign.options[sign.selectedIndex].value;

    if (signValue == "markup") {
        signedAdjustment = '+' + signedAdjustment;
    }
    else if (signValue == "markdown") {
        signedAdjustment = '-' + signedAdjustment;
    }
    return signedAdjustment;
}

// This function creates the catalog and category include iframes.
function createDialogFrames() {
   parent.parent.setContentFrameLoaded(false);

   // create the catalog iframe
   var catalogIncludeIframeDialog = document.createElement("IFRAME");
   catalogIncludeIframeDialog.id="catalogIncludeIframe";
   catalogIncludeIframeDialog.src="/webapp/wcs/tools/servlet/ContractCatalogIncludePanel";
   catalogIncludeIframeDialog.style.position = "absolute";
   catalogIncludeIframeDialog.style.visibility = "hidden";
   catalogIncludeIframeDialog.style.height="130";
   catalogIncludeIframeDialog.style.width="280";
   catalogIncludeIframeDialog.frameborder="1";
   catalogIncludeIframeDialog.MARGINHEIGHT="0"
   catalogIncludeIframeDialog.MARGINWIDTH="0";
   //catalogIncludeIframeDialog.onblur=hideCatalogIncludeIframe;
   document.body.appendChild(catalogIncludeIframeDialog);

   // create the category iframe
   var categoryIncludeIframeDialog = document.createElement("IFRAME");
   categoryIncludeIframeDialog.id="categoryIncludeIframe";
   categoryIncludeIframeDialog.src="/webapp/wcs/tools/servlet/ContractCategoryIncludePanel";
   categoryIncludeIframeDialog.style.position = "absolute";
   categoryIncludeIframeDialog.style.visibility = "hidden";
   categoryIncludeIframeDialog.style.height="130";
   categoryIncludeIframeDialog.style.width="280";
   categoryIncludeIframeDialog.frameborder="1";
   categoryIncludeIframeDialog.MARGINHEIGHT="0"
   categoryIncludeIframeDialog.MARGINWIDTH="0";
   //categoryIncludeIframeDialog.onblur=hideCategoryIncludeIframe;
   document.body.appendChild(categoryIncludeIframeDialog);

   // create the catentry iframe
   var catentryIncludeIframeDialog = document.createElement("IFRAME");
   catentryIncludeIframeDialog.id="catentryIncludeIframe";
   catentryIncludeIframeDialog.src="/webapp/wcs/tools/servlet/ContractCatentryIncludePanel";
   catentryIncludeIframeDialog.style.position = "absolute";
   catentryIncludeIframeDialog.style.visibility = "hidden";
   catentryIncludeIframeDialog.style.height="200";
   catentryIncludeIframeDialog.style.width="280";
   catentryIncludeIframeDialog.frameborder="1";
   catentryIncludeIframeDialog.MARGINHEIGHT="0"
   catentryIncludeIframeDialog.MARGINWIDTH="0";
   //catentryIncludeIframeDialog.onblur=hideCatentryIncludeIframe;
   document.body.appendChild(catentryIncludeIframeDialog);

   if (JROM.delegationGrid == true) {
      // create the delegation grid iframe
      var delegationGridIframeDialog = document.createElement("IFRAME");
      delegationGridIframeDialog.id="delegationGridIframe";
      delegationGridIframeDialog.src="/webapp/wcs/tools/servlet/DelegationGridIncludePanel";
      delegationGridIframeDialog.style.position = "absolute";
      delegationGridIframeDialog.style.visibility = "hidden";
      delegationGridIframeDialog.style.height="130";
      delegationGridIframeDialog.style.width="280";
      delegationGridIframeDialog.frameborder="1";
      delegationGridIframeDialog.MARGINHEIGHT="0"
      delegationGridIframeDialog.MARGINWIDTH="0";
      //delegationGridIframeDialog.onblur=hideDelegationGridIframe;
      document.body.appendChild(delegationGridIframeDialog);
   }
   // disable the tree, until the IFRAMES are all loaded...
      DTreeHandler.isLoading = true;

   // select the top node
   tree.select();
   var lastNodeSelected = getHighlightedNode();

   // start the refreshing indicator
   startIndicator(lastNodeSelected.id + "-anchor", parent.getLoadingMessage());

   // now set a timeout to activate the tree only once all of these IFRAME have been loaded...
   setTimeout("checkIFRAMES()", 100);
}

function checkIFRAMES() {
   var isLoaded1 = document.getElementById("catalogIncludeIframe").contentWindow.isLoaded;
   var isLoaded2 = document.getElementById("categoryIncludeIframe").contentWindow.isLoaded;
   var isLoaded3 = document.getElementById("catentryIncludeIframe").contentWindow.isLoaded;
   var isLoaded4 = true;
   if (JROM.delegationGrid == true) {
      isLoaded4 = document.getElementById("delegationGridIframe").contentWindow.isLoaded;
   }

   if (defined(isLoaded1) && defined(isLoaded2) && defined(isLoaded3) && defined(isLoaded4)) {
      stopIndicator();

      // at this point if all the IFRAMES are loaded, then the content frame is loaded!
      parent.parent.setContentFrameLoaded(true);
   }
   else {
      // reset the timer to check again in one second
      setTimeout("checkIFRAMES()", 100);
   }
}

// This function hides the catalog include iframe.
function hideCatalogIncludeIframe(){
   document.getElementById("catalogIncludeIframe").style.visibility = "hidden";
}

// This function hides the category include iframe.
function hideCategoryIncludeIframe(){
   document.getElementById("categoryIncludeIframe").style.visibility = "hidden";
}

// This function hides the catentry include iframe.
function hideCatentryIncludeIframe(){
   document.getElementById("catentryIncludeIframe").style.visibility = "hidden";
}

// This function hides the delegation grid include iframe.
function hideDelegationGridIframe(){
   if (JROM.delegationGrid == true) {	
       document.getElementById("delegationGridIframe").style.visibility = "hidden";
   }
}

// This function starts an indicator to notify the user that the subtree is refreshing.
function startIndicator(id, indicatorMessage){
   document.getElementById(id).innerHTML = indicatorMessage;
      DTreeHandler.isLoading = true;
   top.showProgressIndicator(true);
}

// This function stops the refreshing indicator.
function stopIndicator(){
   setTimeout("getHighlightedNode().redrawAll(); DTreeHandler.isLoading = false; getHighlightedNode().select(); top.showProgressIndicator(false);", indicatorTimeout);
}

// This function is a user exit that is called when the toolsFramework function setNode is called. This
// allows the developer to modify the node before it is rendered on the tree.
function userSetNode(nodeItem){
   userInitializeNode(nodeItem);

      var row = parent.findRowInModel(nodeItem.value);

      // check for an explicit fixed price
   var FIXED = parent.getFIXED();
   if (FIXED.customPriceTC[nodeItem.value] != null && FIXED.customPriceTC[nodeItem.value].markedForDelete != true) {
         var explicitFlag = true;
         var mode = JROM.FIXED_PRICE_TYPE;
      var index = parent.findStoreDefaultCurrencyIndex(FIXED.customPriceTC[nodeItem.value].productPriceInfo);
      var price = parent.parent.numberToCurrency(FIXED.customPriceTC[nodeItem.value].productPriceInfo[index].productPrice,
          FIXED.storeDefaultCurrency, JROM.languageId);

      // if node is not the root
         if (nodeItem.parentNode != null) {
            //if parent node is excluded, then delete the child node
            if (nodeItem.parentNode.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]) {
               explicitFlag = false;
            mode = nodeItem.parentNode.mode;

            //delete the node settings
            FIXED.customPriceTC[nodeItem.value].markedForDelete = true;
            FIXED.customPriceTC[nodeItem.value].action = "delete";
            FIXED.modifiedInSession = true;
            parent.enableDialogButtons();
         }
         }

      // set the node's filters
         setNodeFilters(nodeItem, mode, price, explicitFlag, "true");
      } else
      //found an explicit setting
      if(row != null){
         var explicitFlag = true;
         var mode = row.mode;
         var adjustment = row.adjustment;

         // if node is not the root
         if(nodeItem.parentNode != null){
            //if parent node is excluded, then delete the child node
            if(nodeItem.parentNode.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]){
               explicitFlag = false;
            mode = nodeItem.parentNode.mode;
            adjustment = nodeItem.parentNode.adjustment;
            var precedence = row.precedence;
            var nodeType = row.nodeType;

            //delete the node from JROM or JLOM
            parent.saveJLOMRow(nodeItem.value, precedence, nodeType, "DELETED", "DELETED", "DELETED");
            }
         }

         // set the node's filters
         setNodeFilters(nodeItem, mode, adjustment, explicitFlag, row.synch);

      }else{
         // implicit setting
         // if node is not the root
         if(nodeItem.parentNode != null){
         if(nodeItem.parentNode.isHostingExcluded) {
            setNodeFilters(nodeItem, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE], nodeItem.parentNode.adjustment, false, nodeItem.parentNode.synch);
         } else {
            setNodeFilters(nodeItem, nodeItem.parentNode.mode, nodeItem.parentNode.adjustment, false, nodeItem.parentNode.synch);
         }
         } else {
         // may be a setting from the hosting contract for entire catalog
         var catRow = parent.cfm.parentJROM.rows[nodeItem.value];
         if (catRow != null && catRow.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]) {
            setNodeFilters(nodeItem, JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE],
                  catRow.adjustment, false, "true");
         } else if (JROM.hostingMode == true) {
            // to get appropriate menu in hosting mode
            setNodeFilters(nodeItem, null, null, false, "true");
         }

      }
      }

      return nodeItem;
}

// this function primes some data for every node in the tree.
// this is mostly done to optimize performance.
function userInitializeNode(nodeItem) {
   // initialize all the node settings to false
   nodeItem.nodePrefix = "";
   nodeItem.isCatentryNode = false;
   nodeItem.isCatgroupNode = false;
   nodeItem.isCatalogNode = false;
   nodeItem.isProduct = false;
   nodeItem.isItem = false;
   nodeItem.isKit = false;
   nodeItem.isBundle = false;
   nodeItem.isResellerOverride = false;
   nodeItem.isResellerCatgroup = false;
   nodeItem.isResellerCatentry = false;
   nodeItem.isAdjustmentDisabled = false;
   nodeItem.isHostingExcluded = false;
   nodeItem.hasUnsynchData = false;
   nodeItem.notInProductSets = false;
   // If the ITEM catentries have offer prices in the price list, then if the parent PRODUCT has a fixed price, the ITEM does not get
   // the fixed price. If this is the case for your catalog, then itemsHaveOfferPrices should be true
   // If the ITEM catentries do not have offer prices, then if the parent PRODUCT has a fixed price, the ITEM does get
   // the fixed price. If this is the case for your catalog, then itemsHaveOfferPrices should be false
   // assume item has an offer price unless told otherwise
   nodeItem.hasOfferPrice = true;

   // get the 2 letter node prefix
   nodeItem.nodePrefix = nodeItem.value.substring(0,2);

   if (nodeItem.nodePrefix == "CE") {
      nodeItem.isCatentryNode = true;
   }
   else if (nodeItem.nodePrefix == "CG") {
      nodeItem.isCatgroupNode = true;
   }
   else if (nodeItem.nodePrefix == "CA") {
      nodeItem.isCatalogNode = true;
   }

   // param is of format  menuName,1,2,%
   // 1 == if T, then there is an offer price, F if no offer price
   // 2 == if T, then there is unsynch data, if no data then it is F
   // % is the % discount for the product
   var firstComma = nodeItem.contextMenuUrlParam.indexOf(',');
   var contextMenu = nodeItem.contextMenuUrlParam.slice(0, firstComma);
   // set the boolean flags based on what type of node this is....
   if (nodeItem.isCatentryNode) {
      var isThereAnOfferPrice = nodeItem.contextMenuUrlParam.slice(firstComma + 1, firstComma + 2);
      //alert('OfferPrice ' + isThereAnOfferPrice);
      if (isThereAnOfferPrice == "F") {
         nodeItem.hasOfferPrice = false;
      }
      var isThereUnsynchData = nodeItem.contextMenuUrlParam.slice(firstComma + 3, firstComma + 4);
      //alert('UnsynchData ' + isThereUnsynchData);
      if (isThereUnsynchData == "T") {
         nodeItem.hasUnsynchData = true;
         var price = parent.parent.strToNumber(nodeItem.contextMenuUrlParam.slice(firstComma + 5),
               JROM.languageId);
         nodeItem.unsynchData = price;
      //alert(nodeItem.unsynchData);
      } else if (isThereUnsynchData == "F") {
         nodeItem.notInProductSets = true;
      }

      if(contextMenu == "product"){
         nodeItem.isProduct = true;
      }
      else if(contextMenu == "item"){
         nodeItem.isItem = true;
      }
      else if(contextMenu == "kit"){
         nodeItem.isKit = true;
         //nodeItem.isAdjustmentDisabled = true;
      }
      else if(contextMenu == "bundle"){
         nodeItem.isBundle = true;
         nodeItem.isAdjustmentDisabled = true;
      }
      else if(contextMenu == "resellerOverride"){
         nodeItem.isResellerOverride = true;
         nodeItem.isAdjustmentDisabled = true;
      }
      else if(contextMenu == "resellerCatgroup"){
         nodeItem.isResellerCatgroup = true;
         nodeItem.isAdjustmentDisabled = true;
      }
      else if(contextMenu == "hostingContractExclusion") {
         nodeItem.isHostingExcluded = true;
         nodeItem.isAdjustmentDisabled = true;
      }
      else if(contextMenu == "resellerCatentry"){
         nodeItem.isResellerCatentry = true;
         nodeItem.isAdjustmentDisabled = true;
      }

      if (JROM.delegationGrid == true) {
            nodeItem.contextMenu = "catEntryDelegationGridInclude";
      }
   }
   else if (nodeItem.isCatgroupNode) {
      if(contextMenu == "resellerCatgroup"){
         nodeItem.isResellerCatgroup = true;
         nodeItem.isAdjustmentDisabled = true;
      }
      else if(contextMenu == "hostingContractExclusion") {
         nodeItem.isHostingExcluded = true;
         nodeItem.isAdjustmentDisabled = true;
      }

      if (JROM.delegationGrid == true) {
            nodeItem.contextMenu = "categoryDelegationGridInclude";
      }
   }
   else if (nodeItem.isCatalogNode) {
       if (JROM.delegationGrid == true) {
            nodeItem.contextMenu = "catalogDelegationGridInclude";
         }
   }

   // check for exclusion in parent contract
   var row = parent.cfm.parentJROM.rows[nodeItem.value];
   if (row != null && row.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]) {
      nodeItem.isHostingExcluded = true;
      nodeItem.isAdjustmentDisabled = true;
   }
}

// This function set filters on a node and depending on the mode, sets the right icons and menu context.
function setNodeFilters(nodeItem, mode, adjustment, isExplicit, synch){
   nodeItem.mode = mode;
   nodeItem.adjustment = adjustment;
   nodeItem.isExplicit = isExplicit;
   nodeItem.synch = synch;

   // if the node is a catentry, then set the folder icon to null. This is required so that
   // there is no folder for a catentry.
   if(nodeItem.isCatentryNode){
      parent.doIconReplacement(nodeItem, null, null);
   }

   nodeItem.userIcons = new Array();
   parent.setNodeText(nodeItem, parent.getNodeText(nodeItem));

   if(nodeItem.isHostingExcluded) {
      mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE];
      nodeItem.mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE];
   }

   if (isExplicit == false && mode != JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]) {
      // special override - an item does not get its parents fixed price
      if(nodeItem.isCatentryNode && nodeItem.parentNode.mode == JROM.FIXED_PRICE_TYPE && nodeItem.hasOfferPrice == true) {
         mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE];
         nodeItem.mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE];
         adjustment = nodeItem.parentNode.parentNode.adjustment;
         nodeItem.adjustment = nodeItem.parentNode.parentNode.adjustment;
         synch = "true";
         nodeItem.synch = "true";
      }
   }

   if (mode != JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]) {
     // check for fixed price in parent contract
     var row = parent.cfm.parentFIXED.customPriceTC[nodeItem.value];
     if (row != null) {
        var takeParentFixedPrice = false;
        // parent has fixed price, check if we should use it
        if (isExplicit == false) {
            // we do not have a setting, so take parent fixed price
            takeParentFixedPrice = true;
        } else {
            // we have a setting, check fixed or %
            if (mode == JROM.FIXED_PRICE_TYPE) {
               // we have a fixed price, do a comparison
               if (defined(adjustment) && doesNodeReduceBaseContractFixedPrice(nodeItem, adjustment)) {
                  takeParentFixedPrice = true;
               }
         } else {
            // we have a % adjustment
            takeParentFixedPrice = true;
         }
       }
       if (takeParentFixedPrice == true) {
         var row = parent.cfm.parentFIXED.customPriceTC[nodeItem.value];
         if (row != null) {
           var index = parent.findStoreDefaultCurrencyIndex(parent.cfm.parentFIXED.customPriceTC[nodeItem.value].productPriceInfo);
           var price = parent.parent.numberToCurrency(parent.cfm.parentFIXED.customPriceTC[nodeItem.value].productPriceInfo[index].productPrice,
               parent.cfm.FIXED.storeDefaultCurrency, JROM.languageId);
      adjustment = price;
      nodeItem.adjustment = price;
      mode = JROM.FIXED_PRICE_TYPE;
      nodeItem.mode = JROM.FIXED_PRICE_TYPE;
      synch = "true";
      nodeItem.synch = "true";
         }
       }
     } else if (doesNodeHaveBaseContractAdjustment(nodeItem) != null) {
         // there is an adjustment in parent contract
         var takeParentPctgPrice = false;
         // parent has percentage price, check if we should use it
         if (isExplicit == false) {
            // we do not have a setting, so take parent percentage price, only if we are not a fixed price
            if (mode == JROM.FIXED_PRICE_TYPE) {
               // we have a fixed price, so use that one
         takeParentPctgPrice = false;
         } else {
			if (defined(adjustment)) {
			        //if the customer contract did't define the adjustment or current adjustment is not more better than parent.
				if (doesNodeReduceBaseContractAdjustment(nodeItem, adjustment) || parent.cfm.JROM.rows[nodeItem.value]==null) {
         			   takeParentPctgPrice = true;
         			} else {
         			   takeParentPctgPrice = false;
         			}
         		} else {            	
                               takeParentPctgPrice = true;
                        }
            }
         } else {
            // we have a setting, check fixed or %
            if (mode == JROM.FIXED_PRICE_TYPE) {
               // we have a fixed price, so use that one
         takeParentPctgPrice = false;
         } else {
            	// we have a % adjustment, do a comparison
        	//if the customer contract did't define the adjustment or current adjustment is not more better than parent.
		if (defined(adjustment) && doesNodeReduceBaseContractAdjustment(nodeItem, adjustment)) {
                  takeParentPctgPrice = true;
                }
         }
        }
        if (takeParentPctgPrice == true) {
         var row = parent.cfm.parentJROM.rows[nodeItem.value];
         if (row != null && row.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]) {
               adjustment = row.adjustment;
               nodeItem.adjustment = row.adjustment;
               mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE];
               nodeItem.mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE];
               synch = "true";
               nodeItem.synch = "true";
         } else {
            // not on this node, just take from parent node
               adjustment = nodeItem.parentNode.adjustment;
               nodeItem.adjustment = nodeItem.parentNode.adjustment;
               mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE];
               nodeItem.mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE];
               synch = "true";
               nodeItem.synch = "true";
         }
        }
     }
   }

   //alert("mode = " + mode + " synch = " + synch + " adj = " + adjustment + " explicit = " + isExplicit );
   //alert("notInProductSets = " + nodeItem.notInProductSets + " hasUnsynchData = " + nodeItem.hasUnsynchData);

   // set the node text if the node is not in "exclude" mode
   // set the text for a fixed price
   if (mode == JROM.FIXED_PRICE_TYPE && adjustment != null) {
      var FIXED = parent.getFIXED();
         var oldText = parent.getNodeText(nodeItem);
         var newText = oldText + " [" + adjustment + " " + FIXED.storeDefaultCurrency + "]";
         parent.setNodeText(nodeItem, newText);
   } else
   if( (nodeItem.hasUnsynchData == true) ||
       (mode!= null && mode != JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE] && adjustment != null
       && nodeItem.notInProductSets == false
        /*&& (synch == "true" || (synch == "false" && isExplicit == true)) */
        ) ) {
            // set the text for a percentage adjustment
         var adjustmentText;
         if (nodeItem.hasUnsynchData && isExplicit == false) {
            adjustment = nodeItem.unsynchData;
         }
	//alert(adjustment + " " + (adjustment >= 0));
         if(adjustment >= 0){
            adjustmentText = '+' + parent.parent.numberToStr(adjustment, JROM.languageId) + "%";
         }else{
            adjustmentText = parent.parent.numberToStr(adjustment, JROM.languageId) + "%";
         }
         var oldText = parent.getNodeText(nodeItem);

         if(nodeItem.isAdjustmentDisabled && mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]){
            if(nodeItem.isBundle){
               adjustmentText = parent.getBundleAdjustmentText();
            //}else if(nodeItem.isKit){
            // adjustmentText = parent.getKitAdjustmentText();
            }else if(nodeItem.isResellerOverride ||
                     nodeItem.isResellerCatgroup ||
                     nodeItem.isResellerCatentry) {
               adjustmentText = trimStoreName(parent.getStoreName());
            }
         }
         if(nodeItem.isKit) {
            // kits only get an explicit adjustment or from the parent product, they do not inherit from parent categories
            if (!isExplicit) {
               // also make sure base contract does not have the adjustment
               var row = parent.cfm.parentJROM.rows[nodeItem.value];
               if (row == null) {
               	  // check the if the parent of the kit is a product
               	  if (nodeItem.parentNode != null && nodeItem.parentNode.isProduct && 
               	      nodeItem.parentNode.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]) {
               	      if (!nodeItem.parentNode.isExplicit) {
               	     	      row = parent.cfm.parentJROM.rows[nodeItem.parentNode.value];
               	     	      if (row == null) {
               	     	      	// parent product has not adjustments
               	     	      	adjustmentText = parent.getKitAdjustmentText();
               	     	      } // base product adjustment, use explicit base product adjustment
		      } // if product has explicit, the use product explicit adjustment
                  } else {
                  	// parent is a category, do not use its adjustment
		  	adjustmentText = parent.getKitAdjustmentText();
		  }
               } // base adjustment, use explicit base adjustment
            }  // if explicit, use explicit adjustment
         }

         var newText = oldText + " [" + adjustmentText + "]";
         parent.setNodeText(nodeItem, newText);
      }

      //set the right icons and menus
      if(nodeItem.isCatentryNode){
         if(mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE] ||
            mode == JROM.FIXED_PRICE_TYPE) {
            //if (nodeItem.synch == "true" || nodeItem.hasUnsynchData) {
            if (nodeItem.notInProductSets == false) {
               parent.addIcon(nodeItem, "included.gif");
            }
            nodeItem.contextMenu = "catEntryWithoutQuickInclude";
         }else if(mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]){
            parent.addIcon(nodeItem, "excluded.gif");
            nodeItem.contextMenu = "catEntryWithoutQuickExclude";
         }else if (JROM.hostingMode == true) {
            nodeItem.contextMenu = "catEntryHostingExcludeOnly";
         }else if (JROM.baseContractMode == true) {
            nodeItem.contextMenu = "catEntryBaseContract";
         }else{
            // these types of nodes get the quick include menu
            if(nodeItem.isResellerOverride ||
               nodeItem.isResellerCatentry ||
               nodeItem.isBundle
               //|| nodeItem.isKit
               ){
                  nodeItem.contextMenu = "catEntryWithQuickInclude";
            }else{
                  nodeItem.contextMenu = "catEntryAll";
            }
         }
         if (JROM.delegationGrid == true) {
            nodeItem.contextMenu = "catEntryDelegationGridInclude";
         }
      }
      else if(nodeItem.isCatalogNode){
         if(mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]){
            parent.doIconReplacement(nodeItem, "folderopenincluded.gif", "folderclosedincluded.gif");
            nodeItem.contextMenu = "catalogWithoutQuickInclude";
         }else if (JROM.hostingMode == true) {
            parent.doIconReplacement(nodeItem, "folderopen.gif", "folderclosed.gif");
            nodeItem.contextMenu = "catalogHostingExcludeOnly";
         }else{
            parent.doIconReplacement(nodeItem, "folderopen.gif", "folderclosed.gif");
            nodeItem.contextMenu = "catalogAll";
         }
         if (JROM.delegationGrid == true) {
            nodeItem.contextMenu = "catalogDelegationGridInclude";
         }
      }
      else if(nodeItem.isCatgroupNode){
         if(mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]){
            //if (nodeItem.synch == "false") {
            // parent.doIconReplacement(nodeItem, "folderopen.gif", "folderclosed.gif");
            //} else {
            parent.doIconReplacement(nodeItem, "folderopenincluded.gif", "folderclosedincluded.gif");
            //}
            nodeItem.contextMenu = "categoryWithoutQuickInclude";
         }else if(mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]){
            parent.doIconReplacement(nodeItem, "folderopenexcluded.gif", "folderclosedexcluded.gif");
            nodeItem.contextMenu = "categoryWithoutQuickExclude";
         }else if (JROM.hostingMode == true) {
            parent.doIconReplacement(nodeItem, "folderopen.gif", "folderclosed.gif");
            nodeItem.contextMenu = "categoryHostingExcludeOnly";
         }else if (JROM.baseContractMode == true) {
            parent.doIconReplacement(nodeItem, "folderopen.gif", "folderclosed.gif");
            nodeItem.contextMenu = "categoryBaseContract";
         }else{
            parent.doIconReplacement(nodeItem, "folderopen.gif", "folderclosed.gif");
            nodeItem.contextMenu = "categoryAll";
            if(nodeItem.isResellerCatgroup){
               nodeItem.contextMenu = "categoryAllForReseller";
            }
         }
         if (JROM.delegationGrid == true) {
            nodeItem.contextMenu = "categoryDelegationGridInclude";
         }
      }

   // show the filter icon if the node has explicit settings
   if(isExplicit){
      parent.addIcon(nodeItem, "filter.gif");
   }
}

// This function is a recursive function that sets the filters for a node's children. The parameter
// "applyToAllChildren" is a boolean flag that indicates whether or not we should apply the settings to all
// explicit children nodes as well.
function setChildrenNodesSettings(nodeItem, mode, adjustment, synch, applyToAllChildren){
   // set the icons of all catentries nodes to null so that folder icon is not displayed.
   setCatentriesIcon(nodeItem);
   if(nodeItem.hasChildNodes()){
      var adjustmentPassedIn = adjustment;
      var modePassedIn = mode;
      for(var i=0; i < nodeItem.childNodes.length; i++){
         // reset the adjustment
         adjustment = adjustmentPassedIn;
         mode = modePassedIn;
         if((!nodeItem.childNodes[i].isExplicit && !nodeItem.childNodes[i].isHostingExcluded) || applyToAllChildren /*|| nodeItem.childNodes[i].mode == JROM.FIXED_PRICE_TYPE */){
      // NOT true anymore if its a fixed price, the explicit setting should not block the children from getting the
      // NOT true anymore new setting because an item does not inherits its parents fixed price

            var explicitFlag;
            if(applyToAllChildren && nodeItem.childNodes[i].isExplicit){
               explicitFlag = false;
               // check for a fixed price entry
               var FIXED = parent.getFIXED();
               if (FIXED.customPriceTC[nodeItem.childNodes[i].value] != null) {
                  FIXED.customPriceTC[nodeItem.childNodes[i].value].markedForDelete = true;
                  FIXED.customPriceTC[nodeItem.childNodes[i].value].action = "delete";
                  FIXED.modifiedInSession = true;
               } else {
                  //If the node is explicit, then there is an entry in JROM or JLOM.
                  var rowInModel = parent.findRowInModel(nodeItem.childNodes[i].value);
                  if(rowInModel != null){
                     // clear the entry from the JPOM if this is an explicitly set catentry node!
                     if (rowInModel.nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATENTRY]) {
                        parent.removeFromJPOM(rowInModel.adjustment);
                     }

                     var precedence = rowInModel.precedence;
                     var nodeType = rowInModel.nodeType;
                     //delete the node from JROM or JLOM
                     parent.saveJLOMRow(nodeItem.childNodes[i].value, precedence, nodeType, "DELETED", "DELETED", "DELETED");
                  }
               }
            }else{
               explicitFlag = nodeItem.childNodes[i].isExplicit;
            }

            //set the node's filters
            if (nodeItem.childNodes[i].mode != JROM.FIXED_PRICE_TYPE) {
               if (explicitFlag == false) {
                  // check for adjustment in parent contract
                  var row = parent.cfm.parentJROM.rows[nodeItem.childNodes[i].value];
                  if (row != null && row.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]) {
                     // only do this if there if the new adjustment is better that the base contract adjustment
                     //alert(' 2 adjustment ' + adjustment + ' row.adjustment ' + row.adjustment)
                     //alert(' 2 ' + parent.getNodeText(nodeItem.childNodes[i]) + ' compare '  +  (adjustment > row.adjustment) + ' no explicit parent ' + !isOneParentNodeExplicitlyIncluded(nodeItem.childNodes[i]));
                     if (isOneParentNodeExplicitlyIncluded(nodeItem.childNodes[i], adjustment) && adjustment < row.adjustment) {
                        // no changes required as this contract has set a better adjustment
                     } else {
                        adjustment = row.adjustment;
                        if (mode != JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]) {
                           mode = JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE];
                        }
                     }
                  }
               }
               //alert(' C ' + parent.getNodeText(nodeItem.childNodes[i]) + ' mode '  +  mode + ' adj ' + adjustment + ' explicitFlag ' + explicitFlag + ' synch ' + synch);
               setNodeFilters(nodeItem.childNodes[i], mode, adjustment, explicitFlag, synch);
            } else {
               // for fixed price, only set if node is not explicit, or it has been excluded
               if (!nodeItem.childNodes[i].isExplicit || nodeItem.childNodes[i].parentNode.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE]) {
                  if (nodeItem.childNodes[i].hasOfferPrice == false || nodeItem.childNodes[i].parentNode.mode != JROM.FIXED_PRICE_TYPE) {
                     setNodeFilters(nodeItem.childNodes[i], nodeItem.childNodes[i].parentNode.mode, adjustment, explicitFlag, synch);
                  }
               }
            }

            // recursive calls to set the children's children.
            if(nodeItem.childNodes[i].hasChildNodes()){
               if(applyToAllChildren){
                  setChildrenNodesSettings(nodeItem.childNodes[i], mode, adjustment, synch, true);
               }else{
                  setChildrenNodesSettings(nodeItem.childNodes[i], mode, adjustment, synch, false);
               }
            }
         }
      }
   }
}

// This function loops through all the node's children and set the folder icon to null if a child is a catentry node.
// This function is needed because the folder icon is not required for catentries.
function setCatentriesIcon(nodeItem){

   if(nodeItem.value.substring(0,2) == "CE"){
      parent.doIconReplacement(nodeItem, null, null);
   }

   for(var i=0; i < nodeItem.childNodes.length; i++){
      if(nodeItem.childNodes[i].hasChildNodes()){
         setCatentriesIcon(nodeItem.childNodes[i]);
      }
   }
}

// This function checks if a node item has children which are explicitly included or excluded.
function hasChildInclusion(nodeItem){
   for(var i=0; i < nodeItem.childNodes.length; i++){
      if(nodeItem.childNodes[i].isExplicit){
         return true;
      } else {
         // check for a fixed price
         var FIXED = parent.getFIXED();
         if (FIXED.customPriceTC[nodeItem.childNodes[i].value] != null && FIXED.customPriceTC[nodeItem.childNodes[i].value].markedForDelete != true) {
            return true;
         }
      }

      //recursive call until there is no more children
      if(nodeItem.childNodes[i].hasChildNodes()){
         return hasChildInclusion(nodeItem.childNodes[i]);
      }
   }
   return false;
}


/*d79166*/

// This flag is toggled when user clicks a kit or non-kit node from the tree.
var isLastUserClicksKitNode=false;

// This variable stores the last user clicked node
var lastClickedNode=new Object();


//---------------------------------------------------------------------------
// Function Name: getLastClickedNode
//
// This function returns the last user clicked node
//---------------------------------------------------------------------------
function getLastClickedNode()
{
   return lastClickedNode;
}


//---------------------------------------------------------------------------
// Function Name: getArraySize
//
// This functino returns the numbers of elements within a given array
//---------------------------------------------------------------------------
function getArraySize(myArray)
{
   var count=0;
   for (element in myArray)
   {
      count++;
   }
   return count;
}



//---------------------------------------------------------------------------
// Function Name: saveKitComponentsInPanel
//
// This function is invoked from parent's savePanelData. It saves the user's
// data on the current kit component pricing panel to the data model JKIT.
//---------------------------------------------------------------------------
function saveKitComponentsInPanel()
{
   if (isLastUserClicksKitNode==true)
   {
      setKitComponentPricing(lastClickedNode);
   }
}


//------------------------------------------------------------------
// The lastDKFrameSetSize variable stores the previous frameset size
// after user has been resized the frameset. The default value is
// set to around 55% for the dynamic kit components panel.
//------------------------------------------------------------------
var lastDKFrameSetSize = "20,25,55"; // default frameset size


//---------------------------------------------------------------------------
// Function Name: userClicksKitNode
//
// This function is invoked when a user clicks on a dynamic kit node. It will
// change the frameset size to display the kit component pricing frame.
//---------------------------------------------------------------------------
function userClicksKitNode(selectedNode)
{
   if (parent.document.all("catalogFilterMainFrame"))
   {
      if (lastClickedNode.value == selectedNode.value)
      {
         // Skip to reload the kit component pricing if user click the same node again
         return;
      }
      else
      {
         //alert("lastClickedNode.value is DIFF");
      }

      // Check if the last click node is also a kit node, store the pricing
      if (isLastUserClicksKitNode==true)
      {
         // Set the price adjustment to the recent kit node
         var validValues = setKitComponentPricing(lastClickedNode);
         if (!validValues) { return; } // exit
      }

      isLastUserClicksKitNode = true;
      lastClickedNode = selectedNode;
      parent.gLastClickedTreeNode = selectedNode;

      // Resize & show the kit component pricing frame to user
      parent.catalogFilterMainFrame.setAttribute("kcpNodeName", selectedNode.name);

      if (   (parent.catalogFilterMainFrame.rows=="20,80,0")
          || (parent.catalogFilterMainFrame.rows=="20%, 80%, 0%") )
      {
         // Resize the frameset to previous user's setting
         parent.catalogFilterMainFrame.rows = lastDKFrameSetSize;
      }
      else
      {
         var tempSetSize = parent.catalogFilterMainFrame.rows;
         parent.catalogFilterMainFrame.rows = tempSetSize;
      }

      lastDKFrameSetSize = parent.catalogFilterMainFrame.rows;

      var kitPricingFrameURL = "/webapp/wcs/tools/servlet/ContractKitComponentView";
      parent.kitPricingFrame.location = kitPricingFrameURL;
   }

}


//---------------------------------------------------------------------------
// Function Name: userClicksNonKitNode
//
// This function is invoked when a user clicks on a non-dynamic kit node. It will
// restore the frameset to the original sizing which hides the kit component
// pricing frame.
//---------------------------------------------------------------------------
function userClicksNonKitNode(selectedNode)
{
   if (parent.document.all("catalogFilterMainFrame"))
   {
      if (lastClickedNode.value == selectedNode.value)
      {
         isLastUserClicksKitNode = false;
      }
      else
      {
         //alert("lastClickedNode.value is DIFF");
      }

      // Check the last user clicked node was kit or non-kit node.
      if (isLastUserClicksKitNode==true)
      {
         //alert("userClicksNonKitNode & isLastUserClicksKitNode=TRUE");

         // Save up the kit node price adjustment details if any changes
         var validValues = setKitComponentPricing(lastClickedNode);
         if (!validValues) { return; } // exit
         isLastUserClicksKitNode = false;
      }
      else
      {
         //alert("userClicksNonKitNode & isLastUserClicksKitNode=FALSE");
      }

      lastClickedNode = selectedNode;
      parent.gLastClickedTreeNode = selectedNode;

      // Before resizing the kit component pricing frame to invisible,
      // persists the current frameset settings if it's not zero%.
      if (   (parent.catalogFilterMainFrame.rows!="20,80,0")
          && (parent.catalogFilterMainFrame.rows!="20%, 80%, 0%") )
      {
         lastDKFrameSetSize = parent.catalogFilterMainFrame.rows;
      }
      parent.catalogFilterMainFrame.rows = "20,80,0";
      parent.kitPricingFrame.location = "/wcs/tools/common/blank.html";
   }

}


//---------------------------------------------------------------------------
// Function Name: setKitComponentPricing
//
// This function validates the pricing adjustment values, compares, and
// stores the updated kit component pricing details back to the JKIT model.
//
// Return: true  - if the pricing adjustment values are valid
//         false - if the pricing adjustment values are invalid
//---------------------------------------------------------------------------
function setKitComponentPricing(kitNode)
{
   var debugMsg = "NONE";

   // Check the user's data is valid before checking any data changes
   if (parent.kitPricingFrame.validatePanelData()==false)
   {
      // Invalid data from user inputs, skip changes
      debugMsg = "Invalid data from user inputs, skip changes";
      //alert("HasChanges: " + debugMsg);
      return false;
   }


   var JKIT = parent.getJKIT();
   var kitConfiguration = JKIT.configurationList[kitNode.value];
   var kcpList = parent.kitPricingFrame.getKitComponentPricingList();

   if (kitConfiguration==null)
   {   
//alert("no existing JKIT configuration");
      if ((kcpList==null) || (kcpList.length==0))
      {
         // No changes, skip it
         debugMsg = "No changes, skip it";
//alert("HasChanges: " + debugMsg);
         return true;
      }
      
      var parentConfiguration = JKIT.parentConfigurationList[kitNode.value];
      if (parentConfiguration != null) {
//alert("compare to parent configuration");      	
      	// check if any changes have been made to the copy
      	var oldList = parentConfiguration.buildBlockList;
        var oldListSize  = (oldList==null)  ? 0 : getArraySize(oldList);
        var kcpListSize = (kcpList==null) ? 0 : kcpList.length;
        if (oldListSize==kcpListSize) {
//alert("lists are the same size");         	
           // Loop through each kit components and check any changes
           var hasChanges = false;
           for (var k=0; k<kcpListSize; k++)
           {
              var node = kcpList[k];
              var oldNodeIndex = "CE-" + node.componentReferenceNum;
              var buildblock = oldList[oldNodeIndex];

              if (buildblock==null)
              {
                // Couldn't find the kit component from existing JKIT model
                // New component is added to the kit, changes happen.
                hasChanges = true;
                debugMsg = "New component is added to the kit";
                break;
              }

              if (buildblock.adjustmentType != node.adjustmentType)
              {
                 // Different adjustment type
                 hasChanges = true;
                 debugMsg = "Different adjustment type";
                 break;
              }

              if ((node.adjustmentType=="1") || (node.adjustmentType=="2"))
              {
                if (parent.parent.strToNumber(buildblock.percentageOfferAdjustmentValue)!=parent.parent.strToNumber(node.adjustmentValue))
                {
//alert( parent.parent.strToNumber( buildblock.percentageOfferAdjustmentValue));
//alert(  parent.parent.strToNumber(             	node.adjustmentValue));
                  // Different percentage adjustment value
                  hasChanges = true;
                  debugMsg = "Different percentage adjustment value";
                  break;
                }
              }
              else
              {
                 // Fixed price adjustment
                 if (buildblock.priceOffers==null)
                 {
                    // New price adjustment is added
                    hasChanges = true;
                    debugMsg = "New price adjustment is added";
                    break;
                 }

                 if (parent.parent.strToNumber(buildblock.priceOffers[node.adjustmentCurrency].priceAdjustmentValue)!=parent.parent.strToNumber(node.adjustmentValue))
                 {
                    // Different fixed price adjustment value
                    hasChanges = true;
                    debugMsg = "Different fixed price adjustment value";
                    break;
                 }
              }
          }//end-for
          //alert("HasChanges: " + debugMsg);
          if (hasChanges == false) {
          	// No changes, skip it
         	debugMsg = "No changes to base configuration, skip it";
//alert("HasChanges: " + debugMsg);
                return true;
          }
       } // end same size list
      } // end if parentConfiguration

      // New kit components have been defined by user
      kitConfiguration = new Object();
      kitConfiguration.catalogEntryRef = kitNode.value.substring(3, kitNode.value.length);
      kitConfiguration.action = "new";
      kitConfiguration.buildBlockList = getBuildBlockListFromKitComponentPricing(kcpList);
      JKIT.configurationList[kitNode.value] = kitConfiguration;
      updateJKITActionIfHasChanges(JKIT);
      debugMsg = "New kit components have been defined by user";
//alert("HasChanges: " + debugMsg);
      return true;
   }


   //-------------------------------------------------------------
   // Compare the current and the existing data in the JKIT model
   //-------------------------------------------------------------

   var bbList = kitConfiguration.buildBlockList;
   var bbListSize  = (bbList==null)  ? 0 : getArraySize(bbList);
   var kcpListSize = (kcpList==null) ? 0 : kcpList.length;

   if ((bbListSize==0) && (kcpListSize==0))
   {
      // No changes, skip it
      debugMsg = "No changes, skip it";
      //alert("HasChanges: " + debugMsg);
      return true;
   }

   if ((bbListSize > 0) && (kcpListSize==0))
   {
      // Kit components have been removed by user
      kitConfiguration.action = "delete";
      kitConfiguration.buildBlockList = null;
      JKIT.configurationList[kitNode.value] = kitConfiguration;
      updateJKITActionIfHasChanges(JKIT);
      debugMsg = "Kit components have been removed by user";
      //alert("HasChanges: " + debugMsg);
      return true;
   }

   if (bbListSize==kcpListSize)
   {
      // Loop through each kit components and check any changes
      var hasChanges = false;
      for (var k=0; k<kcpListSize; k++)
      {
         var node = kcpList[k];
         var bbNodeIndex = "CE-" + node.componentReferenceNum;
         var buildblock = bbList[bbNodeIndex];

         if (buildblock==null)
         {
            // Couldn't find the kit component from existing JKIT model
            // New component is added to the kit, changes happen.
            hasChanges = true;
            debugMsg = "New component is added to the kit";
            break;
         }

         if (buildblock.adjustmentType != node.adjustmentType)
         {
            // Different adjustment type
            hasChanges = true;
            debugMsg = "Different adjustment type";
            break;
         }

         if ((node.adjustmentType=="1") || (node.adjustmentType=="2"))
         {
            if (buildblock.percentageOfferAdjustmentValue!=node.adjustmentValue)
            {
               // Different percentage adjustment value
               hasChanges = true;
               debugMsg = "Different percentage adjustment value";
               break;
            }
         }
         else
         {
            // Fixed price adjustment
            if (buildblock.priceOffers==null)
            {
               // New price adjustment is added
               hasChanges = true;
               debugMsg = "New price adjustment is added";
               break;
            }

            if (buildblock.priceOffers[node.adjustmentCurrency].priceAdjustmentValue!=node.adjustmentValue)
            {
               // Different fixed price adjustment value
               hasChanges = true;
               debugMsg = "Different fixed price adjustment value";
               break;
            }
         }

      }//end-for

   }
   else
   {
      // Different numbers of kit component implies changes
      debugMsg = "Different numbers of kit component implies changes";
      hasChanges = true;
   }

   //alert("HasChanges: " + debugMsg);

   if (hasChanges)
   {
      kitConfiguration.action = "update";
      kitConfiguration.buildBlockList = getBuildBlockListFromKitComponentPricing(kcpList);
      JKIT.configurationList[kitNode.value] = kitConfiguration;
      updateJKITActionIfHasChanges(JKIT);

   }//end-if-hasChanges

   return true;
}



//---------------------------------------------------------------------------
// Function Name: updateJKITActionIfHasChanges
//
// This functions updates the JKIT model's action type when changes happen
// on kit configuration.
//---------------------------------------------------------------------------
function updateJKITActionIfHasChanges(jkit)
{
   if (jkit.action=="noaction")
   {
      if ((jkit.referenceNumber==null) || (jkit.referenceNumber==""))
      {
         jkit.action = "new";
      }
      else
      {
         jkit.action = "update";
      }
   }
}


//---------------------------------------------------------------------------
// Function Name: getBuildBlockListFromKitComponentPricing
//
// This function loops through a given kit component pricing list to
// construct an array of build block
//---------------------------------------------------------------------------
function getBuildBlockListFromKitComponentPricing(kitComponentPricingList)
{
   var kcpList        = kitComponentPricingList;
   var buildBlockList = new Array();

   for (var k=0; k<kcpList.length; k++)
   {
      var buildblock = new Object();
      var node = kcpList[k];
      buildblock.catalogEntryRef = node.componentReferenceNum;
      buildblock.name = node.componentName;
      buildblock.sku = node.sku;
      buildblock.adjustmentType = node.adjustmentType;

      if (buildblock.adjustmentType=="3")
      {
         // Fixed price adjustment type
         buildblock.priceOffers = new Array();
         buildblock.priceOffers[node.adjustmentCurrency] = new Object();
         buildblock.priceOffers[node.adjustmentCurrency].priceAdjustmentValue
               = node.adjustmentValue;
         buildblock.priceOffers[node.adjustmentCurrency].priceCurrency
               = node.adjustmentCurrency;
      }
      else
      {
         // Percentage adjustment type
         buildblock.percentageOfferAdjustmentValue = node.adjustmentValue;
      }

      var bbNodeIndex = "CE-" + node.componentReferenceNum;
      buildBlockList[bbNodeIndex] = buildblock;

   }//end-for-kcpList

   return buildBlockList;
}



//---------------------------------------------------------------------------
// Function Name: hasKitConfigurationSettings
//
// This function goes through all the kit configuration to see if there are
// any changes on the component pricing adjustments.
//---------------------------------------------------------------------------
function hasKitConfigurationSettings()
{
   var jkit = parent.getJKIT();

   for(configID in jkit.configurationList)
   {
      var kitConfiguration = jkit.configurationList[configID];
      if (kitConfiguration!=null)
      {
         if (kitConfiguration.action!="noaction")
         {
            return true;
         }
      }
   }//end-for

   return false;
}


//---------------------------------------------------------------------------
// Function Name: debugNodeDetails
//
//---------------------------------------------------------------------------
function debugNodeDetails(node)
{
   var info = "curr node: ID=" + node.id
            + ", name=" + node.name
            + ", value=" + node.value
            + ", nodeType=" + node.nodeType
            + ", action=" + node.action
            + ", childrenUrlParam=" + node.childrenUrlParam + "\n";

   info = info + "lastClickedNode: ID=" + lastClickedNode.id
            + ", name=" + lastClickedNode.name
            + ", value=" + lastClickedNode.value
            + ", nodeType=" + lastClickedNode.nodeType
            + ", action=" + lastClickedNode.action
            + ", childrenUrlParam=" + lastClickedNode.childrenUrlParam + "\n";

   alert(info);
}

/*d79166*/




// This function overrides the ToolsFramework "OnBeforeToString" function and this function allows the
// developer to manipulate the menu items in the menu.
ContextMenu.prototype.onBeforeToString = function () {

   if (DTreeHandler.focusNode != null){

      var node = DTreeHandler.focusNode;

      /*d79166*/
      if (node.isKit)
      {
         userClicksKitNode(node);
      }
      else
      {
         userClicksNonKitNode(node);
      }

      if(! node.isCatalogNode){
         for(var i=0; i < this.menu.length; i++){

            // the cancel setting menu option is only enabled for filter nodes
            if(this.menu[i] != null && this.menu[i].name == parent.getCancelSettingsMenuText()){
               if(! node.isExplicit){
                  this.menu[i].enabled = false;
               }else{
                  this.menu[i].enabled = true;
               }
            }

            // the exclude menu option is only enabled if a parent node is included
            if(this.menu[i] != null && this.menu[i].name == parent.getExcludeMenuText()){
               if(node.parentNode != null){
                  if(node.parentNode.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE] ||
                     node.parentNode.mode == JROM.FIXED_PRICE_TYPE ||
                     JROM.hostingMode == true || JROM.baseContractMode == true){
                     this.menu[i].enabled = true;
                  }else{
                     // may be a setting from the hosting contract
                     var catRow = parent.cfm.parentJROM.rows[node.value];
                     // may be a fixed price setting from the hosting contract
                     var fixedRow = parent.cfm.parentFIXED.customPriceTC[node.value];
                     if (catRow != null && catRow.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE])
                        this.menu[i].enabled = true;
                     else if (fixedRow != null)
                        this.menu[i].enabled = true;
                     else
                        this.menu[i].enabled = false;
                  }
               }
            }

            // menu options can be disabled for reseller catgroups, catentries, and overrides.
            if(this.menu[i] != null &&
               (this.menu[i].name == parent.getCategorySetPriceAdjustmentMenuText() ||
                this.menu[i].name == parent.getCatentrySetPriceAdjustmentMenuText() ||
                this.menu[i].name == parent.getCategoryIncludeWithAdjustmentMenuText() ||
                this.menu[i].name == parent.getCatentryIncludeWithAdjustmentMenuText() ||
                this.menu[i].name == parent.getDelegationGridCatalogFilterMenuText()
                )) {

               if(node.isAdjustmentDisabled){
                  this.menu[i].enabled = false;
               }else{
                  this.menu[i].enabled = true;
               }
            }

            if(this.menu[i] != null && this.menu[i].name == parent.getCalculatePriceMenuText()){
               // dynamic kits have their prices calculated externally.  calculate price is disabled in this case.
               if(node.isKit){
                  this.menu[i].enabled = false;
               }else{
                  if(showCalculatePriceMenuItem){
                     if(node.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]){
                        this.menu[i].enabled = true;
                     }else{
                        this.menu[i].enabled = false;
                     }
                  }else{
                     this.menu[i].enabled = false;
                  }
               }
            }


         }
      } else {
         if (JROM.includedCategoriesAreUnSynched) {
            for(var i=0; i < this.menu.length; i++){
               // for unsynch, disallow include entire catalog
               // the cancel setting menu option is only enabled for filter nodes
               if(this.menu[i] != null && this.menu[i].name == parent.getIncludeCatalogMenuText()){
                  this.menu[i].enabled = false;
               }
            }
         }
      }
   }
   this.menu = processExpandInContextMenu(this.menu);
}

// This ToolsFramework function has been overridden to hide the context menu when all the menu items have been disabled.
ContextMenu.prototype.onToString = function (str) {

   str = processContextMenuHTML(str);
   if (DTreeHandler.focusNode != null){
      for(var i=0; i < this.menu.length; i++){
         if(this.menu[i] != null){
            if(this.menu[i].enabled){
               return str;
            }
         }
      }
   }
   return "";
}

// This function goes through the subtree defined by the nodeItem and checks if a node has an explicit setting defined by the user.
function hasExplicitSettings(nodeItem){

   if(nodeItem.isExplicit){
      return true;
   } else {
      // check for a fixed price
      var FIXED = parent.getFIXED();
      if (FIXED.customPriceTC[nodeItem.value] != null && FIXED.customPriceTC[nodeItem.value].markedForDelete != true) {
         return true;
      }
   }

   if(nodeItem.hasChildNodes()){
      for(var i=0; i < nodeItem.childNodes.length; i++){
         if(hasExplicitSettings(nodeItem.childNodes[i])){
            return true;
         }
      }
   }
   return false;
}

// This function goes through all the settings to see if there are inclusions or exclusions
function hasSettings(){
   var JLOM = parent.getJLOM();
   var JROMRows = parent.getJROMRows();
   var JROM = parent.getJROM();
   var FIXED = parent.getFIXED();

   for(rowID in JLOM){
      var rowAction = parent.getAction(JLOM[rowID].rowID);
      if(rowAction != null && rowAction != JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE]){
         return true;
      }
   }

   for(rowID in JROMRows){
      var JLOMrow = parent.findRowInJLOM(JROMRows[rowID].rowID);
      var rowAction = parent.getAction(JROMRows[rowID].rowID);
      // no action occurred for this JROM row.
      if(JLOMrow == null && rowAction != JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE]){
         return true;
      }
   }

   for(rowID in FIXED.customPriceTC) {
      if (!FIXED.customPriceTC[rowID].markedForDelete) {
         return true;
      }
   }

   /*d79166*/
   if (hasKitConfigurationSettings())
   {
      return true;
   }

   return false;
}

// This function goes through the subtree defined by the nodeItem and checks whether or not a node which is excluded
// has an included parent node.
function doesExcludedNodeHaveIncludedParent(nodeItem){

   if(nodeItem.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_EXCLUDE] &&
      nodeItem.isExplicit == true){

      if(!isOneParentNodeIncluded(nodeItem)){
         return false;
      }
   }

   if(nodeItem.hasChildNodes()){
      for(var i=0; i < nodeItem.childNodes.length; i++){
         if(!doesExcludedNodeHaveIncludedParent(nodeItem.childNodes[i])){
            return false;
         }
      }
   }
   return true;
}

// This function takes in a node as parameter and it goes up the hierarchy until it reaches the root to check
// whether or not the node has an included parent node.
function isOneParentNodeIncluded(nodeItem){

   if(nodeItem.parentNode != null){
      if(nodeItem.parentNode.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE] && nodeItem.parentNode.isExplicit){
         return true;
      }
      // check if node is in parent contract
      var catRow = parent.cfm.parentJROM.rows[nodeItem.parentNode.value];
      if (catRow != null && catRow.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]) {
         return true;
      }
      // check if node is in parent contract
      var fixedRow = parent.cfm.parentFIXED.customPriceTC[nodeItem.parentNode.value];
      if (fixedRow != null) {
         return true;
      }

      // check for a fixed price
      var FIXED = parent.getFIXED();
      if (FIXED.customPriceTC[nodeItem.parentNode.value] != null && FIXED.customPriceTC[nodeItem.parentNode.value].markedForDelete != true) {
         return true;
      }

      if(isOneParentNodeIncluded(nodeItem.parentNode)){
         return true;
      }
   }
   return false;
}

// This function takes in a node as parameter and it goes up the hierarchy in the parent contract
// until it reaches the root to check
// whether or not the node has an explicit adjustment.
function doesNodeHaveBaseContractAdjustment(nodeItem){

   if(nodeItem != null){
      //alert(nodeItem.value);
      // check if node is in parent contract
      var catRow = parent.cfm.parentJROM.rows[nodeItem.value];
      if (catRow != null && catRow.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]) {
   return catRow.adjustment;
      }
      return doesNodeHaveBaseContractAdjustment(nodeItem.parentNode);
   }
   return null;
}

// This function takes in a node as parameter and it goes up the hierarchy until it reaches the root to check
// whether or not the node has an included parent with an explicit adjustment.
function isOneParentNodeExplicitlyIncluded(nodeItem, adj){

   if(nodeItem.parentNode != null){
      if(nodeItem.parentNode.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE] && nodeItem.parentNode.isExplicit
          && nodeItem.parentNode.adjustment == adj){
         return true;
      }
      if(isOneParentNodeExplicitlyIncluded(nodeItem.parentNode, adj)){
         return true;
      }
   }
   return false;
}

// This function takes in a node as parameter and it goes up the hierarchy in the parent contract
// until it reaches the root to check
// whether or not the node has an explicit adjustment.
function doesNodeReduceBaseContractAdjustment(nodeItem, signedAdjustment){

   if(nodeItem != null){
      //alert(nodeItem.value);
      // check if node is in parent contract
      var catRow = parent.cfm.parentJROM.rows[nodeItem.value];
      if (catRow != null && catRow.mode == JROM.ENTITLEMENT_TYPES[JROM.ENTITLEMENT_TYPE_INCLUDE]) {
         //alert('parent adj' + catRow.adjustment);
         // adjustment must be lower, lower markup, or greater markdown
         if (signedAdjustment > catRow.adjustment) {
            return true;
         } else {
            return false;
         }
      }
      return doesNodeReduceBaseContractAdjustment(nodeItem.parentNode, signedAdjustment);
   }
   return false;
}

// This function takes in a node as parameter and it goes up the hierarchy in the parent contract
// until it reaches the root to check
// whether or not the node has an explicit adjustment.
function doesNodeReduceBaseContractFixedPrice(nodeItem, signedAdjustment){

   if(nodeItem != null){
      //alert('value' + nodeItem.value);
      // check if node is in parent contract
      var row = parent.cfm.parentFIXED.customPriceTC[nodeItem.value];
      if (row != null) {
         var index = parent.findStoreDefaultCurrencyIndex(parent.cfm.parentFIXED.customPriceTC[nodeItem.value].productPriceInfo);
         var price = parent.cfm.parentFIXED.customPriceTC[nodeItem.value].productPriceInfo[index].productPrice;
         //alert('parent adj ' + price + ' new adj ' + signedAdjustment);
         // adjustment must be lower, lower markup, or greater markdown
         if (parent.parent.strToNumber(signedAdjustment) > parent.parent.strToNumber(price)) {
            //alert('true new adj is bad - higher price');
            return true;
         } else {
            //alert('false');
            return false;
         }
      }
   }
   return false;
}

// This function checks if the adjustment specified by the user is the same as the parent's adjustment.
function isParentAdjustmentSame(adjustmentValue){

   var lastNodeSelected = getHighlightedNode();

   if(lastNodeSelected.parentNode != null && lastNodeSelected.parentNode.adjustment == adjustmentValue){
      return true;
   }else{
      return false;
   }
}

// This function takes in a text and performs some substitution
function changeSpecialText(rawDisplayText,textOne, textTwo, textThree, textFour) {
    var displayText = rawDisplayText.replace(/%1/, textOne);


    if (textTwo != null)
       displayText = displayText.replace(/%2/, textTwo);
    if (textThree != null)
       displayText = displayText.replace(/%3/, textThree);
    if (textFour != null)
       displayText = displayText.replace(/%4/, textFour);

    return displayText;
}

// This function trims the storeName if the latter contains 15 or more characters
function trimStoreName(storeName){
   // there should only be one store, so trim the store name once...
   if (gStoreName != null) {
      return gStoreName;
   }

   if(storeName != null){
      var nameLength = storeName.length;
      var limit = 15;
      if(nameLength > limit){
         var newStoreName = storeName.substring(0, limit) + "...";
         gStoreName = newStoreName;
         return newStoreName;
      }
      else{
         gStoreName = storeName;
         return storeName;
      }
   }
}

DTreeAbstractNode.prototype.onHideContextMenu = function () {
	hideCatalogIncludeIframe();
	hideCategoryIncludeIframe();
	hideCatentryIncludeIframe();
	hideDelegationGridIframe();
}