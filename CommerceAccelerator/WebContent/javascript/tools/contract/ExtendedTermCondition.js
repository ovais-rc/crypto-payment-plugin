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

// set this flag to true if you want to display the debugging XML popup window
var debug=false;
// set this flag to false if you do not want the contract to be submitted
// (created/udpated) after the XML popup appears
var submitWhileDebugging=true;

var priceListConfirmCalled = false;


function preSubmitHandler()
 {
 
   addURLParameter("XMLFile", "contract.UpdateTermConditionDialog");
   addURLParameter("xsd", "true");
  // var redirectURL = top.getWebPath() + "DialogView?XMLFile=contract.ContractList";

   //addURLParameter("redirecturl", redirectURL);
   //alert("testExtendedTermCondition.js");

	var o=get("ContractCustomerTCModel");
		
	if(o!=null){
	 addURLParameter("contractId", o.contractId);
	 addURLParameter("lastUpdatedTime", o.contractLastUpdate);
	// alert(o.contractId + o.contractLastUpdate);
	 
		var tcs=o.tcs;
		var customerTCArray=new Array();
		var newObject = new Object;
		var count=0;
		//var tcs=o.tcs;
		//var customerTCArray=new Array();
		for(var i=0;i<tcs.length;i++){
			if(tcs[i].save){
				var ExtendTC=new Object();
				ExtendTC.type=tcs[i].type;
				ExtendTC.Property=new Array();
				var propertyArray=new Array();
				var properties=tcs[i].properties;
				var action=tcs[i].action;
				var referenceNum=tcs[i].referenceNumber;
				if(action=='update' && referenceNum!=null && referenceNum!=""){
					ExtendTC.action=action;
					ExtendTC.referenceNumber=referenceNum;
				}
				else{
					ExtendTC.action='new';
				}
				
				for(var j=0;j<properties.length;j++){
					Property=new Object();
					Property.name=properties[j].name;
					Property.value=properties[j].value;
					ExtendTC.Property[j]=Property;
				}
				customerTCArray[count++]=ExtendTC;
			}
		}
		newObject.TermCondition=customerTCArray;		
		
		Xput("Package", newObject);
   		putXSDnames("Package", "Package.xsd");
 
 

   if (debug) {
       popupXMLwindow(newObject, "Package");
     }

   
 }
 
 return true;
}

function submitFinishHandler(submitFinishMessage)
 {
  if (submitFinishMessage != null && submitFinishMessage != "")
	alertDialog(submitFinishMessage);
  submitCancelHandler();
 }

function submitCancelHandler()
 {
  if (top.goBack)
   {
    top.goBack();
   }
  else
   {
    window.location.replace("NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView");
   }
 }
 
 function validateExtendedTC(){
	var o=get("ContractCustomerTCModel");
	var somethingToSave = false;

	if(o!=null){
		var tcs=o.tcs;
		for(var i=0;i<tcs.length;i++){
			if(tcs[i].save){
				somethingToSave = true;
				var properties=tcs[i].properties;
				for(var j=0;j<properties.length;j++){
					if(properties[j].required=='true' && (properties[j].value==null || properties[j].value=="null" || properties[j].value=="")){
						put("requiredProperyEmpty",true);
						put("errorTCName",tcs[i].displayName);
						put("errorPropertyName",properties[j].displayName);
						gotoPanel("notebookExtendedTC");
						return false;
					}
				}
			}
		}
	}
	if (!somethingToSave){
		put("nothing_changed", true);
		gotoPanel("notebookExtendedTC");
		return false;
	}
	return true;
}
 


