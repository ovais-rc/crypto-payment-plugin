//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2010 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

// set this flag to true if you want to display the debugging XML popup window
var debug=false;

//(created/udpated) after the XML popup appears
var submitWhileDebugging=true;

function preSubmitHandler()
{
  var redirectURL = top.getWebPath() + "DialogView?XMLFile=contract.PriceRuleDialog";
  var o=get("ContractCustomerTCModel");
  if(o!=null){
	  addURLParameter("redirecturl", redirectURL);
	  addURLParameter("contractId", o.contractId);
	  addURLParameter("deploy", true);
	  addURLParameter("storeId", o.storeId);
	  addURLParameter("lastUpdatedTime", o.contractLastUpdate);
	
	  addURLParameter("XMLFile", "contract.PriceRuleDialog");
	  //addURLParameter("xsd", "true");
	  addURLParameter("synchronousDeployment",true);
	
	  var contract = new Object();
  
	var tcs=o.tcs;
	var propertiesLength = 0;
	var customerTCArray=new Array();
	var count=0;
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
				propertiesLength++;
				Property=new Object();
				Property.name=properties[j].name;
				Property.value=properties[j].value;
				ExtendTC.Property[j]=Property;
			}
			customerTCArray[count++]=ExtendTC;
		}
	}
	if(propertiesLength>0){
		contract.TermCondition=customerTCArray;
	}
	Xput("Package", contract);
	putXSDnames("Package", "Package.xsd");
	
	if (debug) {
		popupXMLwindow(contract, "Package");
	}
  }
  
  return true;
}

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
{

	   if (submitErrorStatus == "ContractHasBeenChanged"){
	      var url = "DialogView?XMLFile=contract.PriceRuleDialog";
	      //url += self.CONTENTS.getContractNVP();
	      //url += self.CONTENTS.getHostingNVP();
	      window.location.replace(url);
	         alertDialog(CONTENTS.getConcurrencyErrorMessageText());
	   }
	   else if (submitErrorStatus == "WrongStateForUpdate"){
	         alertDialog(CONTENTS.getPublishNotCompleteErrorMessageText());
	   }
	   else{
	         alertDialog(submitErrorMessage);
	   }
}

function submitFinishHandler(submitFinishMessage)
{

	   if(submitFinishMessage != null && submitFinishMessage != ""){
	      //var url = "DialogView?XMLFile=contract.PriceRuleDialog";
	      //url += self.CONTENTS.getContractNVP();
	      //url += self.CONTENTS.getHostingNVP();
	      //window.location.replace(url);
	      alertDialog(submitFinishMessage);
	      top.goBack();
	   }
}

function submitCancelHandler(){
	   var cancelMessage = CONTENTS.getCancelMessageNLText();
	   if(confirmDialog(cancelMessage)){
		   //var url = "DialogView?XMLFile=contract.PriceRuleDialog";
		   //window.location.replace(url);
		   top.goBack();
	   }
}