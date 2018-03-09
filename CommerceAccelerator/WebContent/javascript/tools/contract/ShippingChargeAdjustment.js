/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* (c) Copyright IBM Corp. 2005
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

////////////////////////////////////////////////////////////////
//
// This javascript file is used for XML object submition only... all the objects are retrieved from model.
// This javascript file provides the similar javascript functions as ShippingChargeAdjustmentFilter.js, but the implmentation is different.
// The JROM, JLOM objects are basically from the model after JSP page submittion.
//
////////////////////////////////////////////////////////////////


// This function creates a new adjustmentTC
// refId and targetType identify the target is category,catentry or entire order
// policyId will be the identifier for each adjustmentTC associated to one target. if policyId is -1, means to all shipmodes.
// actionType indicate if this tc is new, or updated or removed or no action...
// if this is an existing tc, the termcondId should not be empty.
function AdjustmentTC(policyId, policyName, refId, targetType, adjustmentType, adjustmentValue, ownerDn, currency, referenceName, termcondId, actionType) {
  this.policyId = policyId;
  this.policyName = policyName;
  this.refId = refId;
  this.targetType = targetType;
  this.adjustmentType = adjustmentType;
  this.adjustmentValue = adjustmentValue;
  this.ownerDn = ownerDn;
  this.currency = currency;
  this.referenceName = referenceName;
  this.termcondId = termcondId;
  this.actionType = actionType;
}
// if same TC exists, then update it.
function addAdjustmentTC(adjustmentTCs, policyId, policyName, refId, targetType, adjustmentType, adjustmentValue, ownerDn, currency, referenceName, termcondId, actionType) {
  if (adjustmentTCs[policyId] != null) {
    updateAdjustmentTC(adjustmentTCs[policyId], adjustmentType, adjustmentValue, currency);
  } else {
    adjustmentTCs[policyId] = new AdjustmentTC(policyId, policyName, refId, targetType, adjustmentType, adjustmentValue, ownerDn, currency, referenceName, termcondId, actionType);
  }
}


// the update should based on the same policy, refId and termcondId if exists
function updateAdjustmentTC(adjustmentTC, adjustmentType, adjustmentValue, currency) {
  var JROM = getShippingChargeAdjustmentJROM();
  if (JROM != null) {
    adjustmentTC.adjustmentType = adjustmentType;
    adjustmentTC.adjustmentValue = adjustmentValue;

    if (adjustmentType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
      adjustmentTC.currency = currency;
    }
    adjustmentTC.actionType = JROM.ACTION_TYPE_UPDATE;
  }
}

// This function creates a new JLOM node
function JLOMNode (nodeId, nodeType, refId, adjustmentTCs) {
   this.nodeId = nodeId;
   this.nodeType = nodeType;
   this.refId = refId;
   this.adjustmentTCs = adjustmentTCs;
}

// This function adds a new JLOM node to the JLOM array.
function addNewJLOMNode(JLOMID, nodeType, adjustmentTCs) {
   var JLOMNodes = getShippingChargeAdjustmentJLOM();
   var refID = JLOMID.substring(3, JLOMID.length);
   if (JLOMNodes != null) {
     JLOMNodes[JLOMID] = new JLOMNode (JLOMID, nodeType, refID, adjustmentTCs);
   }
}

// function Save an AdjustmentTC in JLOMNode #
function saveAdjustmentTCInJLOM(JLOMID, nodeType, adjustmentTC) {
  var JLOMNode = findNodeInJLOM(JLOMID);
   if (JLOMNode != null) {
     // modify the existing node for the new TC
     var JLOMNodeAdjustmentTC = findAdjustmentTCInJLOMNode(JLOMNode, adjustmentTC.policyId);
     if (JLOMNodeAdjustmentTC != null) {
       // exist, modify it
       updateAdjustmentTC(JLOMNodeAdjustmentTC, adjustmentTC.adjustmentType, adjustmentTC.adjustmentValue, adjustmentTC.currency);
     } else {
       // add a new one into the array
       addAdjustmentTC(JLOMNode.adjustmentTCs,
                           adjustmentTC.policyId,
                           adjustmentTC.policyName,
                           adjustmentTC.refId,
                           adjustmentTC.targetType,
                           adjustmentTC.adjustmentType,
                           adjustmentTC.adjustmentValue,
                           adjustmentTC.ownerDn,
                           adjustmentTC.currency,
                           adjustmentTC.referenceName,
                           adjustmentTC.termcondId,
                           adjustmentTC.actionType);
     }
   } else {
     // create a new JLOMNode then add TC
     var newAdjustmentTCs = new Array();
     newAdjustmentTCs[adjustmentTC.policyId] = adjustmentTC;
     addNewJLOMNode(JLOMID, nodeType, newAdjustmentTCs);
   }
}

// This function returns the node as specified by the nodeID from the JLOM. #
function findNodeInJLOM(nodeID){
   var JLOM = getShippingChargeAdjustmentJLOM();
   if (JLOM != null) {
     return JLOM[nodeID];
   } else {
     return null;
   }
}
// This function returns the adjustment TC as specified by the policy id in a JLOM node #
function findAdjustmentTCInJLOMNode(nodeID, policyId) {
  var JLOMNode = findNodeInJLOM(nodeID);
  if (JLOMNode != null) {
    var adjustmentTCs = JLOMNode.adjustmentTCs;
    return adjustmentTCs[policyId];
  } else {
    return null;
  }
}


function getShippingChargeAdjustmentJROM() {
  var sfm = get("ContractShippingChargeAdjustmentModel",null);
  if (sfm != null) {
    return sfm.JROM;
  } else {
    return null;
  }
}

function getShippingChargeAdjustmentJROMNodes() {
  var sfm = get("ContractShippingChargeAdjustmentModel",null);
  if (sfm != null) {
    return sfm.JROM.nodes;
  } else {
    return null;
  }
}

function getShippingChargeAdjustmentJLOM() {
  var sfm = get("ContractShippingChargeAdjustmentModel",null);
  if (sfm != null) {
    return sfm.JLOM;
  } else {
    return null;
  }
}
/////////////////////////////////////////////////////////////////
// XML CREATION SCRIPTS
// Each object below represents a XML node
// "SCA" stands for Shipping Charge Adjustment
/////////////////////////////////////////////////////////////////

function SCACatalogRef(){
   var myCatalogRef = new Object();
   var JROM = getShippingChargeAdjustmentJROM();
   if (JROM != null) {
     if(JROM.catalogReferenceNumber != null && JROM.catalogReferenceNumber != ""){
        myCatalogRef.catalogReferenceNumber = JROM.catalogReferenceNumber;
     }
     myCatalogRef.name = JROM.catalogIdentifier;
     myCatalogRef.Owner = JROM.catalogOwner;
     return myCatalogRef;
   } else {
     return null;
   }
}

function SCACatalogGroupRef(node){
   var myCatalogGroupRef = new Object();
   myCatalogGroupRef.catalogGroupReferenceNumber = node.refId;
   return myCatalogGroupRef;
}

function SCACatalogEntryRef(node){
   var myCatalogEntryRef = new Object();
   myCatalogEntryRef.catalogEntryReferenceNumber = node.refId;
   return myCatalogEntryRef;
}

function SCAShippingModePolicyRef(node, policyId) {
  var JROM = getShippingChargeAdjustmentJROM();
  if (JROM != null) {
    var myShippingModePolicyRef = new Object();
    myShippingModePolicyRef.policyName = node.adjustmentTCs[policyId].policyName;
    myShippingModePolicyRef.StoreRef = new Object();
    myShippingModePolicyRef.StoreRef.name = JROM.storeName;
    myShippingModePolicyRef.StoreRef.Owner = new Object();
    myShippingModePolicyRef.StoreRef.Owner.OrganizationRef = new Object();
    myShippingModePolicyRef.StoreRef.Owner.OrganizationRef.distinguishName = JROM.storeOwnerDn;
    return myShippingModePolicyRef;
  } else {
    return null;
  }
}

function SCAMonetaryAmount(node, policyId) {
  var myAdjustment = new Object();
  myAdjustment.value = node.adjustmentTCs[policyId].adjustmentValue;
  myAdjustment.currency = node.adjustmentTCs[policyId].currency;
  return myAdjustment;
}

function SCAPriceAdjustment(node, policyId) {
  var myAdjustment = new Object();
  myAdjustment.signedPercentage = node.adjustmentTCs[policyId].adjustmentValue;
  return myAdjustment;
}





//////////////////////////////////////////////////////////////////
//
// Validation and Submittion for all the TCs in the JLOM:
//
// Below is the logic to check which TC should be "add", "delete", "update" and "noaction":
//
// UI - JLOM           :          DB - JROM
// Step 1: Merge JROM TCs into JLOM TC list before review the whole JLOM list:
//        For JROM loop {
//            If JROM.TC NOT in JLOM {
//                 "noaction" for this TC,
//                 job: Copy TC from JROM to JLOM, specially copy the TCid from JROM to JLOM TC.
//            }
//            If JROM.TC in JLOM {
//                 If JLOM.TC is "delete" {
//                      job: Mark this as "delete", Copy TCid from JROM to the JLOM for this TC in case there is null in JLOM.
//                 }
//                 If JLOM.TC is "update" or "new" {
//                      job: Mark this as "update", Copy TCid from JROM to JLOM for this TC.
//                 }
//            }
//        }
// Step 2: Review all the JLOM TCs and generate the XML base on the review result:
//        For JLOM loop {
//            If TCid is NOT null, which means from DB: {
//                 job: Adding this TC to the XML
//                 if it was "delete": set to delete and will be removed by command,
//                 if it was "update": will be updated by command,
//                 if it was "noaction": command should do nothing.
//                 it should NOT be "new" after Step 1.
//            }
//            If TCid is null, which means this is from UI {
//                 job: Check if this TC is not marked "delete", then add into the XML as "new". Otherwise,do nothing.
//            }
//        }
//
//
//////////////////////////////////////////////////////////////////
function MergeJROMIntoJLOM(model) {
  if (model != null) {
    var JROM = model.JROM;
    var JROMNodes = model.JROM.nodes;
    var JLOMNodes = model.JLOM;
    for (nodeId in JROMNodes) {
      for (policyId in JROMNodes[nodeId].adjustmentTCs) {
        if (findAdjustmentTCInJLOMNode(nodeId, policyId) == null) {
          saveAdjustmentTCInJLOM(nodeId, JROMNodes[nodeId].nodeType, JROMNodes[nodeId].adjustmentTCs[policyId]);
          // assume the action is "noaction" because this is assigned when loading JROM.
        } else {
          JLOMNodes[nodeId].adjustmentTCs[policyId].termcondId = JROMNodes[nodeId].adjustmentTCs[policyId].termcondId;
          if (JLOMNodes[nodeId].adjustmentTCs[policyId].actionType == JROM.ACTION_TYPE_NEW ) {
            JLOMNodes[nodeId].adjustmentTCs[policyId].actionType = JROM.ACTION_TYPE_UPDATE;
          }
        }
      }
    }
  }
}

function validateShippingChargeAdjustment () {
   return true;
}

function submitShippingChargeAdjustment(contract) {

   /*91996*/
   var ccdm = get("ContractCommonDataModel");
   if (ccdm)
   {
      if (ccdm.tcLockInfo["ShippingTC"]!=null)
      {
         if (ccdm.tcLockInfo["ShippingTC"].shouldTCbeSaved==false)
         {
            // Skip saving the terms and conditions
            return;
         }
      }
   }


  var sfm = get("ContractShippingChargeAdjustmentModel",null);
    // step 1:
  MergeJROMIntoJLOM(sfm);
  // step 2:
  var count = 0;

  if(sfm != null) {
    var JROM = sfm.JROM;
    var myTCs = new Array();
    // add each TC into myTCs
    var currentJLOM = sfm.JLOM;
    for (nodeId in currentJLOM) {
      for (policyId in currentJLOM[nodeId].adjustmentTCs) {
        if (currentJLOM[nodeId].adjustmentTCs[policyId].termcondId != null) {
          // this adjustment is already in the database
          myTCs[count] = new Object();
          myTCs[count].referenceNumber = currentJLOM[nodeId].adjustmentTCs[policyId].termcondId;
          if (currentJLOM[nodeId].adjustmentTCs[policyId].adjustmentType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF) {
            myTCs[count].PriceAdjustment = new SCAPriceAdjustment(currentJLOM[nodeId],policyId);
          } else if (currentJLOM[nodeId].adjustmentTCs[policyId].adjustmentType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
            myTCs[count].MonetaryAmount = new SCAMonetaryAmount(currentJLOM[nodeId],policyId);
          }
          if (currentJLOM[nodeId].adjustmentTCs[policyId].policyId != JROM.POLICY_ALL_SHIPMODES) {
            myTCs[count].ShippingModePolicyRef = new SCAShippingModePolicyRef(currentJLOM[nodeId],policyId);
          }
          if (currentJLOM[nodeId].adjustmentTCs[policyId].targetType == JROM.FILTER_TYPE_CATALOG) {
            // do nothing since this is for order
          } else if (currentJLOM[nodeId].adjustmentTCs[policyId].targetType == JROM.FILTER_TYPE_CATEGORY) {
            // for category
            myTCs[count].CatalogRef = new SCACatalogRef();
            myTCs[count].CatalogGroupRef = new SCACatalogGroupRef(currentJLOM[nodeId]);
          } else if (currentJLOM[nodeId].adjustmentTCs[policyId].targetType == JROM.FILTER_TYPE_CATENTRY) {
            // for catentry
            myTCs[count].CatalogRef = new SCACatalogRef();
            myTCs[count].CatalogEntryRef = new SCACatalogEntryRef(currentJLOM[nodeId]);
          }
          if (currentJLOM[nodeId].adjustmentTCs[policyId].actionType == JROM.ACTION_TYPE_DELETE) {
            // set to delete
            myTCs[count].action = "delete";
          } else if (currentJLOM[nodeId].adjustmentTCs[policyId].actionType == JROM.ACTION_TYPE_UPDATE) {
            // set to update
            myTCs[count].action = "update";
          } else if (currentJLOM[nodeId].adjustmentTCs[policyId].actionType == JROM.ACTION_TYPE_NOACTION) {
            // set to noaction
            myTCs[count].action = "noaction";
          }
          count++;
        } else {
          // this adjustment is new from the UI, only create "new" for those not "marked as delete"
          if (currentJLOM[nodeId].adjustmentTCs[policyId].actionType != JROM.ACTION_TYPE_DELETE) {
            myTCs[count] = new Object();
            if (currentJLOM[nodeId].adjustmentTCs[policyId].adjustmentType == JROM.ADJUSTMENT_TYPE_PERCENTAGE_OFF) {
              myTCs[count].PriceAdjustment = new SCAPriceAdjustment(currentJLOM[nodeId],policyId);
            } else if (currentJLOM[nodeId].adjustmentTCs[policyId].adjustmentType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
              myTCs[count].MonetaryAmount = new SCAMonetaryAmount(currentJLOM[nodeId],policyId);
            }
            if (currentJLOM[nodeId].adjustmentTCs[policyId].policyId != JROM.POLICY_ALL_SHIPMODES) {
              myTCs[count].ShippingModePolicyRef = new SCAShippingModePolicyRef(currentJLOM[nodeId],policyId);
            }
            if (currentJLOM[nodeId].adjustmentTCs[policyId].targetType == JROM.FILTER_TYPE_CATALOG) {
              // do nothing since this is for order
            } else if (currentJLOM[nodeId].adjustmentTCs[policyId].targetType == JROM.FILTER_TYPE_CATEGORY) {
              // for category
              myTCs[count].CatalogRef = new SCACatalogRef();
              myTCs[count].CatalogGroupRef = new SCACatalogGroupRef(currentJLOM[nodeId]);
            } else if (currentJLOM[nodeId].adjustmentTCs[policyId].targetType == JROM.FILTER_TYPE_CATENTRY) {
              // for catentry
              myTCs[count].CatalogRef = new SCACatalogRef();
              myTCs[count].CatalogEntryRef = new SCACatalogEntryRef(currentJLOM[nodeId]);
            }
            myTCs[count].action = "new";
            count++;
          }
        }
      }
    }

    if (myTCs.length > 0) {
      contract.ShippingTCShippingChargeAdjustment = new Array();
      contract.ShippingTCShippingChargeAdjustment = myTCs;
    }
  }
  return true;
}
