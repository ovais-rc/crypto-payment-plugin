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

////////////////////////////////////////////////////////////////
//
// This javascript file is used for JSP UI object manipulation... all the objects are defined or initialized in the ShippingChargeAdjustmentPanel JSP.
// This javascript file provides the similar javascript functions as ShippingChargeAdjustment.js, but the implmentation is different.
// The JROM, JLOM objects are basically from the JSP page initialization.
//
////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////
// Function to display the JLOM and JROM for testing purposes
//////////////////////////////////////////////////////////////

function displayJROM(){
	var display = "JROM: \n\n";
	var JROMNodes = getJROMNodes();
	for (i in JROMNodes) {	
		display = display + "NodeID: " + i  + " Type= " + JROMNodes[i].nodeType + " RefID= " +	JROMNodes[i].refId + "\n";
		for (j in JROMNodes[i].adjustmentTCs) {
		  display = display + " PolicyID: " + j + 
		           " PolicyName= " + JROMNodes[i].adjustmentTCs[j].policyName +
		           " RefId= " + JROMNodes[i].adjustmentTCs[j].refId + 
		           " TargetType= " + JROMNodes[i].adjustmentTCs[j].targetType +
		           " AdjustmentType= " + JROMNodes[i].adjustmentTCs[j].adjustmentType + 
		           " AdjustmentValue= " + JROMNodes[i].adjustmentTCs[j].adjustmentValue +
		           " OwnerDn= " + JROMNodes[i].adjustmentTCs[j].ownerDn +
		           " Currency= " + JROMNodes[i].adjustmentTCs[j].currency +
		           " ReferenceName= " + JROMNodes[i].adjustmentTCs[j].referenceName +
		           " TermcondId= " + JROMNodes[i].adjustmentTCs[j].termcondId +
		           " ActionType= " + JROMNodes[i].adjustmentTCs[j].actionType +"\n";
		}
	}			
	return display;	
}

function displayJLOM(){
	var display = "JLOM:  \n\n";
	var JLOM = getJLOM();
	for (i in JLOM) {	
		display = display + "NodeID: " + i  + " Type= " + JLOM[i].nodeType + " RefID= " +	JLOM[i].refId + "\n";
		for (j in JLOM[i].adjustmentTCs) {
		  display = display + "PolicyID: " + j + 
		           " PolicyName= " + JLOM[i].adjustmentTCs[j].policyName +
		           " RefId= " + JLOM[i].adjustmentTCs[j].refId + 
		           " TargetType= " + JLOM[i].adjustmentTCs[j].targetType +
		           " AdjustmentType= " + JLOM[i].adjustmentTCs[j].adjustmentType + 
		           " AdjustmentValue= " + JLOM[i].adjustmentTCs[j].adjustmentValue +
		           " OwnerDn= " + JLOM[i].adjustmentTCs[j].ownerDn +
		           " Currency= " + JLOM[i].adjustmentTCs[j].currency +
		           " ReferenceName= " + JLOM[i].adjustmentTCs[j].referenceName +
		           " TermcondId= " + JLOM[i].adjustmentTCs[j].termcondId +
		           " ActionType= " + JLOM[i].adjustmentTCs[j].actionType +"\n";
		}
	}					
	return display;	
}
////////////////////////////////////////////////////////////////
// Functions accessible to the JROM and JLOM model
//
// This JavaScript is really providing an accelerator to manipulate the JROM and JLOM 
// object in the UI JSP and generate the XML object for contract command to save (create, update) and delete the TCs.
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
  var JROM = getJROM();
  if (adjustmentTCs[policyId] != null) {
    updateAdjustmentTC(adjustmentTCs[policyId], adjustmentType, adjustmentValue, currency);
  } else {
    adjustmentTCs[policyId] = new AdjustmentTC(policyId, policyName, refId, targetType, adjustmentType, adjustmentValue, ownerDn, currency, referenceName, termcondId, actionType);
  }
}

// mark to remove the adjustment TC from the adjustmentTC array
function removeAdjustmentTC(adjustmentTCs, policyId) {
  var JROM = getJROM();
  if (adjustmentTCs[policyId] != null) {
    adjustmentTCs[policyId].actionType = JROM.ACTION_TYPE_DELETE;
  }
}
    
    
// the update should based on the same policy, refId and termcondId if exists
function updateAdjustmentTC(adjustmentTC, adjustmentType, adjustmentValue, currency) {
  var JROM = getJROM();
  adjustmentTC.adjustmentType = adjustmentType;
  adjustmentTC.adjustmentValue = adjustmentValue;
  if (adjustmentType == JROM.ADJUSTMENT_TYPE_AMOUNT_OFF) {
    adjustmentTC.currency = currency;
  }
  adjustmentTC.actionType = JROM.ACTION_TYPE_UPDATE;  
}
        
// This function creates a new JLOM node
function JLOMNode (nodeId, nodeType, refId, adjustmentTCs) {	
	this.nodeId = nodeId;
	this.nodeType = nodeType;
	this.refId = refId;
	this.adjustmentTCs = adjustmentTCs;		
}

// This function creates a new JROM node
function JROMNode (nodeId, nodeType, refId, adjustmentTCs) {	
	this.nodeId = nodeId;
	this.nodeType = nodeType;
	this.refId = refId;
	this.adjustmentTCs = adjustmentTCs;		
}

// This function adds a new JROM node to the JROM array.
function addNewJROMNode(JROMID, nodeType, adjustmentTCs) {
	var JROMNodes = getJROMNodes();
	var refID = JROMID.substring(3, JROMID.length); 	
	JROMNodes[JROMID] = new JROMNode (JROMID, nodeType, refID, adjustmentTCs);
}

// This function adds a new JLOM node to the JLOM array.
function addNewJLOMNode(JLOMID, nodeType, adjustmentTCs) {
	var JLOMNodes = getJLOM();
	var refID = JLOMID.substring(3, JLOMID.length); 	
	JLOMNodes[JLOMID] = new JLOMNode (JLOMID, nodeType, refID, adjustmentTCs);
}
// This function creates a new AvailablePolicy object
function AvailablePolicy(POLICYID, name, shortDescription) {
  this.id = POLICYID;
  this.name = name;
  this.description = shortDescription;
}

// function Save an AdjustmentTC in JLOMNode
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
// function to copy an AdjustmentTC from JROM to JLOM
function copyAdjustmentTCFromJROMToJLOM(JLOMID, policyId) {
  // alert("in copy Adjustment method!");
  var JROM = getJROM();
  var newAdjustmentTC = findAdjustmentTCInJROMNode(JLOMID, policyId);
  if ( newAdjustmentTC != null) {
    // copy
    var node = findNodeInJROM(JLOMID);
    if (node != null) {
      var nodeType = node.nodeType;
      saveAdjustmentTCInJLOM(JLOMID, nodeType, newAdjustmentTC);
    }
  } else {
    // no need to copy
  }
}
// fucntion to mark an AdjustmentTC to delete in JLOMNode, if not exist in JLOM, but exist in JROM, then copy to JLOM and mark to delete.
function removeAdjustmentTCInJLOM(JLOMID, policyId) {
  var JROM = getJROM();
  var JLOMNodeAdjustmentTC = findAdjustmentTCInJLOMNode(JLOMID, policyId);
  if (JLOMNodeAdjustmentTC != null) {
    // Adjustment TC exists in JLOM 
    alertDebug("found TC from JLOM to remove");   
    JLOMNodeAdjustmentTC.actionType = JROM.ACTION_TYPE_DELETE;
  } else {
    JLOMNodeAdjustmentTC = findAdjustmentTCInJROMNode(JLOMID, policyId);
    if (JLOMNodeAdjustmentTC != null) {
      // Adjustment TC exists in JROM
      // copy over and mark to delete
      alertDebug( "Found TC from JROM to remove");
      copyAdjustmentTCFromJROMToJLOM(JLOMID, policyId);
      var newAdjustmentTC = findAdjustmentTCInJLOMNode(JLOMID, policyId);
      if (newAdjustmentTC != null) {
      	newAdjustmentTC.actionType = JROM.ACTION_TYPE_DELETE;
      	alertDebug("copy succeed!");
      } else {
      	alertDebug('copy was not successful');
      }
    } else {
      alertDebug("couldn't find this TC anywhere, skip it.");
      // no adjustment TC exists at all. No actions
    }
  }
}
// this function used for "cancel Setting button"
function removeAllTCInJLOM(JLOMID) {
  var JROM = getJROM();
  // this function mark all the adjustment TCs in JLOM node to "delete", if JLOM node is null but exist in JROM,
  // then copy JROM node to JLOM and then mark it to delete
  var JLOMNode = findNodeInModel(JLOMID);
	if (JLOMNode != null) {
	    // mark for delete all
	  for (policyId in JLOMNode.adjustmentTCs) {
	    JLOMNode.adjustmentTCs[policyId].actionType = JROM.ACTION_TYPE_DELETE;
	  // alert(policyId + " is removed.");
	  }
	}
}

// This function returns the corresponding JROMNode or JLOMNode of the last tree node selected from the JLOM or JROM model.
function getSelectedNodeRowFromModel(){		
	var lastNode = tree.getHighlightedNode();
	if (lastNode!="") {
		var ref_id = lastNode.value;	
		var JLOMNode = findNodeInJLOM(ref_id);		
		if(JLOMnode != null){
			return JLOMnode;			
		}else{	
			return findNodeInJROM(ref_id);
		}	    		    	    
	} 	
}

// This function returns the node as specified by the nodeID from the JROM.
function findNodeInJROM(nodeID){
	var JROMNodes = getJROMNodes();	
	return JROMNodes[nodeID];
}

// This function returns the adjustment TC as specified by the policy id in a JROM node
function findAdjustmentTCInJROMNode(nodeID, policyId) {
  var JROMNode = findNodeInJROM(nodeID);
  if (JROMNode != null) {
    var adjustmentTCs = JROMNode.adjustmentTCs;
    return adjustmentTCs[policyId];
  } else {
    return null;
  }
}

// This function returns the node as specified by the nodeID from the JLOM.
function findNodeInJLOM(nodeID){	
	var JLOM = getJLOM();
	return JLOM[nodeID];
}
// This function returns the adjustment TC as specified by the policy id in a JLOM node
function findAdjustmentTCInJLOMNode(nodeID, policyId) {
  var JLOMNode = findNodeInJLOM(nodeID);
  if (JLOMNode != null) {
    var adjustmentTCs = JLOMNode.adjustmentTCs;
    return adjustmentTCs[policyId];
  } else {
    return null;
  }
}

// This function returns the length of the JLOM.
function getJLOMSize(){
	var JLOM = getJLOM();	
	var i = 0;
	for(nodeID in JLOM){
		i++;
	}
	return i;
}

function getAdjustmentTCsSize(adjustmentTCs) {
  var i = 0;
  for(policyID in adjustmentTCs) {
    i++;
  }
  return i;
}

// This function returns the node as specified by the nodeID from the model.
function findNodeInModel(nodeID){		
	var JLOMnode = findNodeInJLOM(nodeID);		
	if(JLOMnode != null){
		return JLOMnode;			
	}else{	
		return findNodeInJROM(nodeID);
	}	
}

// This function returns the adjustmentTC in the model by node id and policy id.
function findAdjustmentTCInModel(nodeID, policyId){
  var node = findNodeInModel(nodeID);
  if (node !=null) {
    return node.adjustmentTCs[policyId];
  } else {
    return null;
  }
}

// This function returns the first instance of a catalog in the model.
function findCatalogInModel(){

	var JROMNodes = getJROMNodes();
	var JLOM = getJLOM();
	var JROM = getJROM();
	
	for (refID in JLOM){
		if(JLOM[refID].nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG]){
			return JLOM[refID];			 
		}								
	}
	
	for (refID in JROMNodes){
		if(JROMNodes[refID].nodeType == JROM.FILTER_TYPES[JROM.FILTER_TYPE_CATALOG]){
			return JROMNodes[refID];			 
		}										
	}
	
	// if not found, then return null
	return null;			
}

// This function returns the node name.
function getNodeText(node){	
	return trimAdjustment(node.name);
}

// This function sets the node name.
function setNodeText(node, newText){	
	node.name = newText;
}

// This function trims the text to remove the adjustment section at the end of the text.
function trimAdjustment(text){
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

// This function determines the action done by the user on a particular node specified by the rowID.
function getAction(nodeId, policyId){
	var JLadjustment = findAdjustmentTCInJLOMNode(nodeId, policyId);
	var JRadjustment = findAdjustmentTCInJROMNode(nodeId, policyId);
	var JROM = getJROM();
	
	var newAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_NEW];
	var updateAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_UPDATE];
	var deleteAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_DELETE];
	var noAction = JROM.ACTION_TYPES[JROM.ACTION_TYPE_NOACTION];
	
	//new action
	if(JLadjustment != null && JRadjustment == null){
		if(JLadjustment.actionType != JROM.ACTION_TYPE_DELETE){
			return newAction;
		}else{
			return null;
		}
		
	//update action or delete action	
	}else if(JLadjustment != null && JRadjustment != null){	
		if(JLadjustment.actionType != JROM.ACTION_TYPE_DELETE){
			return updateAction;
		}else{
			return deleteAction;
		}	
	//no action	
	}else if(JLadjustment == null && JRadjustment != null){
		return noAction;
	}
	return null;					
}
