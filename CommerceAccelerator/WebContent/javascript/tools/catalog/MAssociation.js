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

var DEBUG=true;

var ACTION_ADD="add";
var ACTION_UPDATE="update";
var ACTION_REMOVE="remove";
var ACTION_NONE="none";									

/////////////////////////////////////////////////////////////////////////////////////
// MASourceObj(catentryId, partNumber, type, name, numberOfTargets)
//
// - constructor for MerchandisingAssociation Source object
/////////////////////////////////////////////////////////////////////////////////////
function MASourceObj(catentryId, partNumber, type, name, numberOfTargets)
{
	this.catentryId 		= catentryId;
	this.partNumber 		= partNumber;
	this.type				= type;
	this.name 				= name;
	this.numberOfTargets 	= numberOfTargets;
}

/////////////////////////////////////////////////////////////////////////////////////
// MATargetObj(catentryId, partNumber, name, shortDesc, associationType, semantic, qty, associationId, sequence, year, month, day, store, editable, type)
//
// - constructor for MerchandisingAssociation Target object
/////////////////////////////////////////////////////////////////////////////////////
function MATargetObj(catentryId, partNumber, name, shortDesc, associationType, semantic, qty, associationId, sequence, year, month, day, store, editable, type)
{
	this.catentryId 			= catentryId;
	this.partNumber 			= partNumber;
	this.name 					= name;
	this.shortDesc				= shortDesc;
	this.associationType 		= associationType;
	this.semantic				= semantic;
	this.type					= type;

	this.qty					= qty;
	this.associationId			= associationId;	
	this.sequence				= sequence;

	this.editable				= (editable==null)? true: editable;
	this.action					= ACTION_NONE;	
	
	// for 3Q, the following fields not exist
	this.year					= (year==null)? "":year;	//new Date().getFullYear():year;
	this.month					= (month==null)? "":month;	//new Date().getMonth()+1:month;
	this.day					= (day==null)? "":day;		//new Date().getDate():day;
	this.store					= (store==null)? 0:store;
}

MATargetObj.prototype.setAction			= 	setMATargetAction;
MATargetObj.prototype.getAction			= 	getMATargetAction;
MATargetObj.prototype.equals			= 	equalsMATarget;

/////////////////////////////////////////////////////////////////////////////////////
// setMATargetAction(action)
//
// - set action for a Target Object
/////////////////////////////////////////////////////////////////////////////////////
function setMATargetAction(action)
{
	switch(action)
	{
		case ACTION_ADD:	
		case ACTION_UPDATE:
							// can only from NONE to Add or Update
							if(this.action==ACTION_NONE)
								this.action=action;
							else
								if(this.action==ACTION_REMOVE)
									alertDebug(" set add/update action to removed one?");	
							break;
							
		case ACTION_REMOVE:
							// can only remove existing (including updated) SKUs
							if( (this.action==ACTION_NONE) ||(this.action==ACTION_UPDATE))
								this.action=action;
							else
								alertDebug("set remove action to new one?");	
							break;					
		case ACTION_NONE:
							// cannot set to NONE (the init status)
							alertDebug("set action to none?");
							break;
	}						
	
	return this.flag;
}

/////////////////////////////////////////////////////////////////////////////////////
// getMATargetAction()
//
// - get action from a Target Object
/////////////////////////////////////////////////////////////////////////////////////
function getMATargetAction()
{
	return this.action;
}	

/////////////////////////////////////////////////////////////////////////////////////
// equalsMATarget(oTarget)
//
// - compare two Target Objects
/////////////////////////////////////////////////////////////////////////////////////
function equalsMATarget(oTarget)
{
	if(this.associationType!=oTarget.associationType)
		return false;
		
	if(this.semantic!=oTarget.semantic)
		return false;

	if((this.catentryId) != (oTarget.catentryId))
		return false;
		
	//for PCD, check store
	if(this.store!=oTarget.store)
		return false;
	
	return true;	
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneObj(o)
//
// - clone an Object
/////////////////////////////////////////////////////////////////////////////////////
function cloneObj(o) 
{
	var oNew = new Object();
	
    for (i in o) 
    {
       if (typeof i != 'object') 
       	 oNew[i] = o[i];
       else	 	
         oNew[i] = new cloneOBJ(o[i]);
    }
    
    return oNew;
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneMATarget(o)
//
// - clone a Target Object
/////////////////////////////////////////////////////////////////////////////////////
function cloneMATarget(o)
{
	var oTarget = new MATargetObj();
		for(var x in o)
		 if(typeof o[x] != "function")
		 {
		 	if(typeof o[x] == "object")
		 		oTarget[x] = cloneObj(o[x]);
		 	else
		 		oTarget[x] = o[x];	
		 }
		 	
	return oTarget;	 	
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneMATargetArray(a)
//
// - clone a Target array
/////////////////////////////////////////////////////////////////////////////////////
function cloneMATargetArray(a)
{
	var arrayTargets = new Array();
	
	for(var i=0; i< a.length; i++)
		arrayTargets[arrayTargets.length]= cloneMATarget(a[i]);
		
	return arrayTargets;	
}

/////////////////////////////////////////////////////////////////////////////////////
// SKUObj(catentryId, partNumber, name, shortDesc, qty, sequence, type)
//
// - constructor for the SKU Object
/////////////////////////////////////////////////////////////////////////////////////
function SKUObj(catentryId, partNumber, name, shortDesc, qty, sequence, type)
{
	this.catentryId = catentryId;
	this.partNumber = partNumber;
	this.name 		= name;
	this.shortDesc 	= shortDesc;
	this.qty 		= qty;
	this.type 		= type;
	
	if(sequence==null)
		this.sequence=-1;
	else
		this.sequence= sequence;	
		
	this.action		= ACTION_NONE;	
}
SKUObj.prototype.setAction		= 	setAction;
SKUObj.prototype.getAction		= 	getAction;

/////////////////////////////////////////////////////////////////////////////////////
// setAction(action)
//
// - set action for a SKU Object
/////////////////////////////////////////////////////////////////////////////////////
function setAction(action)
{
	switch(action)
	{
		case ACTION_ADD:	
		case ACTION_UPDATE:
							// can only from NONE to Add or Update
							if(this.action==ACTION_NONE)
								this.action=action;
							else
								if(this.action==ACTION_REMOVE)
									alertDebug(" set add/update action to removed one?");	
							break;
							
		case ACTION_REMOVE:
							// can only remove existing (including updated) SKUs
							if( (this.action==ACTION_NONE) ||(this.action==ACTION_UPDATE))
								this.action=action;
							else
								alertDebug("set remove action to new one?");	
							break;					
		case ACTION_NONE:
							// cannot set to NONE (the init status)
							alertDebug("set action to none?");
							break;
	}						
	
	return this.flag;
}	

/////////////////////////////////////////////////////////////////////////////////////
// getAction()
//
// - get action from a SKU Object
/////////////////////////////////////////////////////////////////////////////////////
function getAction()
{
	return this.action;
}	

/////////////////////////////////////////////////////////////////////////////////////
// cloneSKU(o)
//
// - clone a SKU Object
/////////////////////////////////////////////////////////////////////////////////////
function cloneSKU(o)
{
	var oSKU = new SKUObj();
		for(var x in o)
		 if(typeof o[x] != "function")
		 {
		 	if(typeof o[x] == "object")
		 		oSKU[x] = cloneObj(o[x]);
		 	else
		 		oSKU[x] = o[x];	
		 }
		 	
	return oSKU;	 	
}

/////////////////////////////////////////////////////////////////////////////////////
// cloneSKUArray(arraySKU)
//
// - clone a SKU array
/////////////////////////////////////////////////////////////////////////////////////
function cloneSKUArray(a)
{
	var arraySKUs = new Array();
	
	for(var i=0; i< a.length; i++)
		arraySKUs[arraySKUs.length]= cloneSKU(a[i]);
		
	return arraySKUs;	
}

/////////////////////////////////////////////////////////////////////////////////////
// isTargetInArray(oTarget, arrayTargets)
//
// - check if a Target in an array
/////////////////////////////////////////////////////////////////////////////////////
function isTargetInArray(oTarget, arrayTargets)
{
	for(var i=0; i<arrayTargets.length; i++)
		if(arrayTargets[i].equals(oTarget))
		  if(arrayTargets[i].action != ACTION_REMOVE)
				return true;
	return false;		
}
////////////////////////////////////////////////////////////////////////////////////////
function inspect(obj) {
	var output = "";

	if (obj == null) {
		return null;
	}
	else {
		for (var i in obj) {
			output += i + " : " + obj[i] + "\n";
		}
		return output;
	}
}

function alertDebug(strMsg)
{
}

function popupXMLwindow(jsXMLobject, rootNode) 
{
    top.popupXMLobject = jsXMLobject;
    top.popupXMLobjectRootNode = rootNode;

    window.open('/webapp/wcs/tools/servlet/PopupXMLwindowView',
                'popupXMLwindow',
                'toolbar=no,menubar=no,location=no,scrollbars=yes,resize=yes,status=no,width=800,height=600');
}

/////////////////////////////////////////////////////////////////////////////////////
// variables used for MAssocmodel and xml data
/////////////////////////////////////////////////////////////////////////////////////
var MA_MODEL		=	"__MAssociationModel";
var XML_ROOT		=	"CatalogToolsXML";
var XML_DTD			=	"CatalogTools.dtd";

/////////////////////////////////////////////////////////////////////////////////////
// MAssocModel()
//
// - constructor for the MAssoc model
/////////////////////////////////////////////////////////////////////////////////////
function MAssocModel()
{
	this.DTableSourceRows			= new Array();
	this.DTableSourceRemovedRows	= new Array();

	this.DTableTargetRows			= new Array();
	this.DTableTargetRemovedRows	= new Array();
	this.bShowCommonTargets			= false;
	this.bCommonTargetsRefreshed	= false;
	
	this.nSourceScrollTop			= 0;
	this.nTargetScrollTop			= 0;
}

/////////////////////////////////////////////////////////////////////////////////////
// variables used for SKU Pick List
/////////////////////////////////////////////////////////////////////////////////////
var SKU_PICK_ACTION_NONE	=	"SKU_PICK_NONE";
var SKU_PICK_ACTION_ADD		=	"SKU_PICK_ADD";
var SKU_PICK_ACTION_REPLACE	=	"SKU_PICK_REPLACE";						//not used yet
var SKU_PICK_LIST			=	"__KITSKUPickList";


/////////////////////////////////////////////////////////////////////////////////////
// validatePanelData()
//
// - - TFW standard function, validate the Target List table
/////////////////////////////////////////////////////////////////////////////////////
function validatePanelData()
{
	return parent.CONTENTS.Target.validateAndSaveData();
}

/////////////////////////////////////////////////////////////////////////////////////
// preSubmitHandler()
//
// - TFW standard function, build the xml data here
/////////////////////////////////////////////////////////////////////////////////////
function preSubmitHandler()
{
   Xput(XML_ROOT, CONTENTS.SourceBtn.buildXMLData());			// will be moved into this js file
   putDTDname(XML_DTD);
}

/////////////////////////////////////////////////////////////////////////////////////
// submitFinishHandler()
//
// - TFW standard function, display finish message
// -- extended this function: do not go back, but clear all actions in our model
/////////////////////////////////////////////////////////////////////////////////////
function submitFinishHandler(submitFinishMessage)
{
	alertDialog(submitFinishMessage);
    //top.goBack();							//the save button clicked, do no return!	
    
	//clear all changed flags and all actions in our Model
	CONTENTS.Source.clearAllChangedFlags();
}
 
/////////////////////////////////////////////////////////////////////////////////////
// submitErrorHandler()
//
// - TFW standard function, display error message
/////////////////////////////////////////////////////////////////////////////////////
function submitErrorHandler(submitErrorMessage, submitErrorStatus)
{
	alertDialog(submitErrorMessage);

}

/////////////////////////////////////////////////////////////////////////////////////
// submitCancelHandler()
//
// - TFW standard function, display a confirmaiton message before quit
/////////////////////////////////////////////////////////////////////////////////////
function submitCancelHandler()
{
	var bGoback=true;
	
	if(defined(CONTENTS.Source.getCancelConfirmMessage))
		if(CONTENTS.Source.contentsChanged())
 			if(!confirmDialog(CONTENTS.Source.getCancelConfirmMessage()))
 				bGoback=false;
	if(bGoback)
 		top.goBack();		
}

/////////////////////////////////////////////////////////////////////////////////////
// btnSave_onClick()
//
// - custimized button, save the data but not return
/////////////////////////////////////////////////////////////////////////////////////
function btnSave_onClick()
{
	parent.finish();
}

/////////////////////////////////////////////////////////////////////////////////////
// btnReturn_onClick
//
// - custimized button, the same as the Cancel button
/////////////////////////////////////////////////////////////////////////////////////
function btnReturn_onClick()
{
	var bGoback=true;
	
	if(defined(Source.getCancelConfirmMessage))
		if(Source.contentsChanged())
 			if(!confirmDialog(Source.getCancelConfirmMessage()))
 				bGoback=false;
	if(bGoback)
 		top.goBack();		
}