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
// KitObj(catentryId, partNumber, type, name, shortDesc, numberOfskus, editable)
//
// - constructor for the Kit Object
/////////////////////////////////////////////////////////////////////////////////////
function KitObj(catentryId, partNumber, type, name, shortDesc, numberOfskus, editable)
{
	this.catentryId 	= catentryId;
	this.partNumber 	= partNumber;
	this.type			= type;
	this.name 			= name;
	this.shortDesc 		= shortDesc;
	this.numberOfskus 	= numberOfskus;
	
	if(editable==null)
		this.editable		= true;
	else
		this.editable		= editable;	
}

/////////////////////////////////////////////////////////////////////////////////////
// SKUObj(catentryId, partNumber, name, shortDesc, qty, sequence)
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
// cloneObj(o)
//
// - clone a general object
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
// isSKUinArray( partNumber,arraySKU)
//
// - check if a SKU in an array
/////////////////////////////////////////////////////////////////////////////////////
function isSKUinArray( partNumber,arraySKU)
{
	for(var i=0; i<arraySKU.length; i++)
		if(arraySKU[i].partNumber == partNumber)
		  if(arraySKU[i].action != ACTION_REMOVE)
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
// variables used for Kit contents model and xml data
/////////////////////////////////////////////////////////////////////////////////////
var KIT_MODEL		=	"__KITContentModel";
var XML_ROOT		=	"CatalogToolsXML";
var XML_DTD			=	"CatalogTools.dtd";

/////////////////////////////////////////////////////////////////////////////////////
// KitContentsModel()
//
// - constructor for the Kit Contents model
/////////////////////////////////////////////////////////////////////////////////////
function KitContentsModel()
{
	this.DTableListRows				= new Array();
	this.DTableListRemovedRows		= new Array();

	this.DTableContentsRows			= new Array();
	this.DTableContentsRemovedRows	= new Array();
	this.bShowCommonContent			= false;
	this.bCommonContentRefreshed	= false;
	
	this.nListScrollTop				= 0;
	this.nContentScrollTop			= 0;
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
// - - TFW standard function, validate the SKU List table
/////////////////////////////////////////////////////////////////////////////////////
function validatePanelData()
{
	return parent.CONTENTS.Content.validateAndSaveData();
}

/////////////////////////////////////////////////////////////////////////////////////
// preSubmitHandler()
//
// - TFW standard function, build the xml data here
/////////////////////////////////////////////////////////////////////////////////////
function preSubmitHandler()
{
   Xput(XML_ROOT, CONTENTS.ListBtn.buildXMLData());			// will be moved into this js file
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
	CONTENTS.List.clearAllChangedFlags();
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
	
	if(defined(CONTENTS.List.getCancelConfirmMessage))
		if(CONTENTS.List.contentsChanged())
 			if(!confirmDialog(CONTENTS.List.getCancelConfirmMessage()))
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
	
	if(defined(List.getCancelConfirmMessage))
		if(List.contentsChanged())
 			if(!confirmDialog(List.getCancelConfirmMessage()))
 				bGoback=false;
	if(bGoback)
 		top.goBack();		
}