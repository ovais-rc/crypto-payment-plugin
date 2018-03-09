/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* 
* (c) Copyright IBM Corp. 2005
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

// global variable that points to the JROM
var JROM = parent.getJROM();
var shipmodes = parent.getAvailableShipmodes();

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

//This function brings up the adjustment TC form iframe when the set Discount menu is chosen for a node.
function setDiscountDialog(objectType) {
  if (objectType == JROM.FILTER_TYPE_CATALOG) {
    popupIFRAME("catalogAdjustmentTCIframe", objectType);
  } else if (objectType == JROM.FILTER_TYPE_CATEGORY) {
    popupIFRAME("categoryAdjustmentTCIframe", objectType);
  } else if (objectType == JROM.FILTER_TYPE_CATENTRY) {
    popupIFRAME("catentryAdjustmentTCIframe", objectType);
  }
}

function popupIFRAME(IFRAMEid, objectType) {
   
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

      var nodeType = getType(objectType);
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
   
   // start the refreshing indicator
   startIndicator(lastNodeSelected.id + "-anchor", parent.getIndicatorMessage());
   parent.removeAllTCInJLOM(lastNodeSelected.value);

   // set the node filters as well as the children.
   var emptyAdjustmentTCs = new Array();
   setNodeFilters(lastNodeSelected, emptyAdjustmentTCs);
   setChildrenNodesSettings(lastNodeSelected);

   // refresh the tree and stop the refreshing indicator
   stopIndicator();
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
   var emptyAdjustmentTCs = new Array();
   parent.removeAllTCInJLOM(rootNode.value);

   // set the node filters as well as the children.
   setNodeFilters(rootNode, emptyAdjustmentTCs);
   setChildrenNodesSettings(rootNode);

   rootNode.redrawAll();

}

// This function is being called when the user tries to expand an excluded category or an excluded product.
function popAlertBox(){
   alertDialog(parent.getNotExpandableNLText());
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

// This function creates the catalog and category shipping charge adjustment TCs iframes.
function createDialogFrames() {
   parent.parent.setContentFrameLoaded(false);

   // create the catalog iframe
   var catalogIncludeIframeDialog = document.createElement("IFRAME");
   catalogIncludeIframeDialog.id="catalogAdjustmentTCIframe";
   catalogIncludeIframeDialog.src="/webapp/wcs/tools/servlet/ContractCatalogShippingChargeAdjustmentPanel";
   catalogIncludeIframeDialog.style.position = "absolute";
   catalogIncludeIframeDialog.style.visibility = "hidden";
   catalogIncludeIframeDialog.style.height="200";
   catalogIncludeIframeDialog.style.width="450";
   catalogIncludeIframeDialog.frameborder="1";
   catalogIncludeIframeDialog.MARGINHEIGHT="0"
   catalogIncludeIframeDialog.MARGINWIDTH="0";
   //catalogIncludeIframeDialog.onblur=hideCatalogAdjustmentTCIframe;
   document.body.appendChild(catalogIncludeIframeDialog);

   // create the category iframe
   var categoryIncludeIframeDialog = document.createElement("IFRAME");
   categoryIncludeIframeDialog.id="categoryAdjustmentTCIframe";
   categoryIncludeIframeDialog.src="/webapp/wcs/tools/servlet/ContractCategoryShippingChargeAdjustmentPanel";
   categoryIncludeIframeDialog.style.position = "absolute";
   categoryIncludeIframeDialog.style.visibility = "hidden";
   categoryIncludeIframeDialog.style.height="200";
   categoryIncludeIframeDialog.style.width="450";
   categoryIncludeIframeDialog.frameborder="1";
   categoryIncludeIframeDialog.MARGINHEIGHT="0"
   categoryIncludeIframeDialog.MARGINWIDTH="0";
   //categoryIncludeIframeDialog.onblur=hideCategoryAdjustmentTCIframe;
   document.body.appendChild(categoryIncludeIframeDialog);

   // create the catentry iframe
   var catentryIncludeIframeDialog = document.createElement("IFRAME");
   catentryIncludeIframeDialog.id="catentryAdjustmentTCIframe";
   catentryIncludeIframeDialog.src="/webapp/wcs/tools/servlet/ContractCatentryShippingChargeAdjustmentPanel";
   catentryIncludeIframeDialog.style.position = "absolute";
   catentryIncludeIframeDialog.style.visibility = "hidden";
   catentryIncludeIframeDialog.style.height="200";
   catentryIncludeIframeDialog.style.width="450";
   catentryIncludeIframeDialog.frameborder="1";
   catentryIncludeIframeDialog.MARGINHEIGHT="0"
   catentryIncludeIframeDialog.MARGINWIDTH="0";
   //catentryIncludeIframeDialog.onblur=hideCatentryAdjustmentTCIframe;
   document.body.appendChild(catentryIncludeIframeDialog);

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
   var isLoaded1 = document.getElementById("catalogAdjustmentTCIframe").contentWindow.isLoaded;
   var isLoaded2 = document.getElementById("categoryAdjustmentTCIframe").contentWindow.isLoaded;
   var isLoaded3 = document.getElementById("catentryAdjustmentTCIframe").contentWindow.isLoaded;

   if (defined(isLoaded1) && defined(isLoaded2) && defined(isLoaded3)) {
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
function hideCatalogAdjustmentTCIframe(){
   document.getElementById("catalogAdjustmentTCIframe").style.visibility = "hidden";
}

// This function hides the category include iframe.
function hideCategoryAdjustmentTCIframe(){
   document.getElementById("categoryAdjustmentTCIframe").style.visibility = "hidden";
}

// This function hides the catentry include iframe.
function hideCatentryAdjustmentTCIframe(){
   document.getElementById("catentryAdjustmentTCIframe").style.visibility = "hidden";
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
   // set the node value for all TCs associated with
   var row = parent.findNodeInModel(nodeItem.value);
   if (row != null) {
      setNodeFilters(nodeItem, row.adjustmentTCs);        
   } else {
      setNodeFilters(nodeItem, null);
   } 
   return nodeItem;
}

// this function primes some data for every node in the tree.
// this is mostly done to optimize performance.
function userInitializeNode(nodeItem) {
   // initialize all the node settings to false
   nodeItem.nodePrefix = "";
   nodeItem.refId = "";
   nodeItem.isCatentryNode = false;
   nodeItem.isCatgroupNode = false;
   nodeItem.isCatalogNode = false;
   nodeItem.isProduct = false;
   nodeItem.isItem = false;
   nodeItem.isKit = false;
   nodeItem.isBundle = false;
   // get the 2 letter node prefix
   nodeItem.nodePrefix = nodeItem.value.substring(0,2);
   nodeItem.refId = nodeItem.value.substr(3);
   nodeItem.ownerDn = "";
   nodeItem.referenceName = "";
   
   if (nodeItem.nodePrefix == "CE") {
      nodeItem.isCatentryNode = true;      
   }
   else if (nodeItem.nodePrefix == "CG") {
      nodeItem.isCatgroupNode = true;
   }
   else if (nodeItem.nodePrefix == "CA") {
      nodeItem.isCatalogNode = true;
   }

   // param is of format  menuName,
   var firstComma = nodeItem.contextMenuUrlParam.indexOf(',');
   var contextMenu = nodeItem.contextMenuUrlParam.slice(0, firstComma);
   // set the boolean flags based on what type of node this is....
   if(contextMenu == "product"){
       nodeItem.isProduct = true;
   }
   else if(contextMenu == "item"){
       nodeItem.isItem = true;
   }
   else if(contextMenu == "kit"){
       nodeItem.isKit = true;
   }
   else if(contextMenu == "bundle"){
       nodeItem.isBundle = true;
       nodeItem.isAdjustmentDisabled = true;
   }
}

// This function set filters on a node and depending on how many adjustmentTCs, sets the right icons and menu context.
function setNodeFilters(nodeItem, adjustmentTCs){
   nodeItem.adjustmentTCs = adjustmentTCs;
  
   // if the node is a catentry, then set the folder icon to null. This is required so that
   // there is no folder for a catentry.
   if(nodeItem.isCatentryNode){
      parent.doIconReplacement(nodeItem, null, null);
   }

   nodeItem.userIcons = new Array();
   parent.setNodeText(nodeItem, parent.getNodeText(nodeItem));
   
   var adjustmentText = getEntireAdjustmentTextForNode(nodeItem);

   if (doesNodeItemHavePolicySettings(nodeItem, true) == true) {
   	   parent.addIcon(nodeItem, "filter.gif");
   }
   
   if (adjustmentText.length>0) {
   	  var oldText = parent.getNodeText(nodeItem);
          adjustmentText = adjustmentText.substr(0,adjustmentText.length-2);
          var newText = oldText + " [" + adjustmentText + "]";
          parent.setNodeText(nodeItem, newText);
          parent.addIcon(nodeItem, "included.gif");
   }
}

function doesNodeItemHavePolicySettings(nodeItem, checkAll) {
	var retValue = false;
	if (checkAll == true) {
    		var row = parent.findAdjustmentTCInModel(nodeItem.value, 0);
    		if (row != null && row.actionType != JROM.ACTION_TYPE_DELETE) {
    			return true;
    		}		
	}
	if (parent.getShipmodePolicyQty()>0) {
    		for (policyId in shipmodes) {
    			var row = parent.findAdjustmentTCInModel(nodeItem.value, policyId);
    			if (row != null && row.actionType != JROM.ACTION_TYPE_DELETE) {
    				return true;
    			}
    		}
    	}
	return retValue;
}

function getEntireAdjustmentTextForNode(nodeItem) {
	// check if this entry has "All shipmodes"
	var row = parent.findAdjustmentTCInModel(nodeItem.value, 0);
	if (row != null && row.actionType != JROM.ACTION_TYPE_DELETE) {
		// adjustment is on this node
		return getAdjustmentTextForRow(row, 0, 0);
	}
	// ok, entry does not have all shipmodes
	// check if it has any settings at all
	if (doesNodeItemHavePolicySettings(nodeItem, false) == false) {
		// if it does not, then go to the parent to get it's text
		if (nodeItem.parentNode != null) {
			return getEntireAdjustmentTextForNode(nodeItem.parentNode);
		} else {
			return "";
		}
	} else {
		// if it does have settings, then show the individual settings
		// for any policy that does not have a setting, go to the parent
   		if (parent.getShipmodePolicyQty()>0) {
   			// have some policies 
   			var adjustmentText = "";
    			for (policyId in shipmodes) {
    				var row = parent.findAdjustmentTCInModel(nodeItem.value, policyId);
    				if (row != null && row.actionType != JROM.ACTION_TYPE_DELETE) {
    					adjustmentText += getAdjustmentTextForRow(row, policyId, 0);
    				} else {
    					// does not have a setting for this policy
    					// check if parent has all setting, individual setting or keep walking tree   
    					var nextToCheck = nodeItem.parentNode;
    					while (nextToCheck != null) {
    						// parent has All Shipmodes setting
    						var row = parent.findAdjustmentTCInModel(nextToCheck.value, 0);
						if (row != null && row.actionType != JROM.ACTION_TYPE_DELETE) {
							adjustmentText += getAdjustmentTextForRow(row, 0, policyId);
							break;
						}
						// parent has individual policy setting
						row = parent.findAdjustmentTCInModel(nextToCheck.value, policyId);
						if (row != null && row.actionType != JROM.ACTION_TYPE_DELETE) {
							adjustmentText += getAdjustmentTextForRow(row, policyId, 0);
							break;
						}
						// go to next node
						nextToCheck = nextToCheck.parentNode;
    					} 					
    				}
			} // end for
			return adjustmentText;
   		} // end if shipmode policy		
	}
	
	return "";
}	
	
function getAdjustmentTextForRow(row, policyId, overridePolicyId) {
		var adjustmentText = "";
	    	if (row != null) {
    			// display the proper text
    			if (row.actionType != JROM.ACTION_TYPE_DELETE) {
            			if (row.adjustmentType == parent.sfm.JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
              				adjustmentText = adjustmentText + parent.parent.numberToCurrency(row.adjustmentValue, parent.sfm.JROM.storeDefaultCurrency, JROM.languageId) + " "
                              		+ parent.sfm.JROM.storeDefaultCurrency + " ";
                              		if (overridePolicyId != 0) {
                              			adjustmentText = adjustmentText + shipmodes[overridePolicyId].description + ", ";
                              		} else if (policyId == JROM.POLICY_ALL_SHIPMODES) {
                				adjustmentText = adjustmentText + row.policyName + ", ";
              				} else {
              					adjustmentText = adjustmentText + shipmodes[policyId].description + ", ";
              				}
            			} else if (row.adjustmentType == parent.sfm.JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF) {
              				if (row.adjustmentValue >= 0) {
						adjustmentText = adjustmentText + '+' + parent.parent.numberToStr(row.adjustmentValue, JROM.languageId) + "% ";
					} else {
						adjustmentText = adjustmentText + parent.parent.numberToStr(row.adjustmentValue, JROM.languageId) + "% ";
					}
                              		if (overridePolicyId != 0) {
                              			adjustmentText = adjustmentText + shipmodes[overridePolicyId].description + ", ";
                              		} else if (policyId == JROM.POLICY_ALL_SHIPMODES) {
              					adjustmentText = adjustmentText + row.policyName + ", ";
              				} else {
              					adjustmentText = adjustmentText + shipmodes[policyId].description + ", ";
              				}	
            			}
          		} // end if not delete
    		} // end if row
    		return adjustmentText;
}    			

// This function is a recursive function that sets the filters for a node's children. 
// This function is trying to inheritant all the parent settings to its children. this is function will be modified later.
function setChildrenNodesSettings(nodeItem){

   if(nodeItem.hasChildNodes()){
      for(var i=0; i < nodeItem.childNodes.length; i++){
         // recursive calls to set the children's children.
         setNodeFilters(nodeItem.childNodes[i], nodeItem.childNodes[i].adjustmentTCs);
         setChildrenNodesSettings(nodeItem.childNodes[i]);
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

// This function checks if a node item has children which are explicitly adjustmentTC.
function hasChildInclusion(nodeItem){
   for(var i=0; i < nodeItem.childNodes.length; i++){
      if(nodeItem.childNodes[i].isExplicit){
         return true;
      } else {
         // check for a fixed price
      }

      //recursive call until there is no more children
      if(nodeItem.childNodes[i].hasChildNodes()){
         return hasChildInclusion(nodeItem.childNodes[i]);
      }
   }
   return false;
}


// This function goes through the subtree defined by the nodeItem and checks if a node has an explicit setting defined by the user.
function hasExplicitSettings(nodeItem){

   if(nodeItem.isExplicit){
      return true;
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
   var JROMRows = parent.getJROMNodes();
   var JROM = parent.getJROM();
   
   for(nodeID in JLOM){
      var size = parent.getAdjustmentTCsSize(JLOM[nodeID].adjustmentTCs);
      if(size > 0){
         return true;
      }
   }

   return false;
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

// This function gets the signed adjustment value depending on whether the adjustment is a "markup" or a "markown".
function getSignedAdjustment(adjustment, sign) {
    var signedAdjustment = parent.parent.strToNumber(adjustment, JROM.languageId);
    
    if (sign == JROM.ADJUSTMENT_TYPE_PERCENTAGE_UP) {
        signedAdjustment = '+' + signedAdjustment;
    }
    else if (sign == JROM.ADJUSTMENT_TYPE_PERCENTAGE_DOWN) {
        signedAdjustment = '-' + signedAdjustment;
    }
    return signedAdjustment;
}

// This function overrides the ToolsFramework "OnBeforeToString" function and this function allows the
// developer to manipulate the menu items in the menu.
ContextMenu.prototype.onBeforeToString = function () {

   if (DTreeHandler.focusNode != null){

      var node = DTreeHandler.focusNode;

         for(var i=0; i < this.menu.length; i++){

            // the cancel setting menu option is only enabled for filter nodes
            if(this.menu[i] != null && this.menu[i].name == parent.getCancelSettingsMenuText()){
               if(doesNodeItemHavePolicySettings(node, true) == true) {
                  this.menu[i].enabled = true;
               }else{
                  this.menu[i].enabled = false;
               }
            }
         }
   }
   this.menu = processExpandInContextMenu(this.menu);
}

DTreeAbstractNode.prototype.onHideContextMenu = function () {
	hideCatalogAdjustmentTCIframe();
	hideCategoryAdjustmentTCIframe();
	hideCatentryAdjustmentTCIframe();
}