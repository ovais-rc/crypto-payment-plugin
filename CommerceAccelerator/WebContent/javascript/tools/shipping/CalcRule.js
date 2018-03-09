//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

function padZero (entry) {
  if (entry.length == 1)
	return '0' + entry;
  return entry;
}


function validateGeneralPanel () {

   
  return true;
}


function validateShpjrulePanel() {
  return true;
}

function validateCalcRangeTylePanel() {
  return true;
}

function validateCalcRuleFixedChargePanel() {
  return true;
}

function validateCalcRulePerUnitChargePanel() {
  return true;
}

function validateCalcRulePercentageChargePanel() {
  return true;
}

function validateAllPanels()
 {
   if (this.validateGeneralPanel) {
     if (validateGeneralPanel() == false) {
	return false;
     } 
   }
//alert("Before Validate ShpjrulePanel");
   if (this.validateShpjrulePanel) {
     if (validateShpjrulePanel() == false) {
	return false;
     } 
   }
   if (this.validateCalcRangeTylePanel) {
     if (validateCalcRangeTylePanel() == false) {
	return false;
     } 
   }
//alert("Before Validate CalcRuleFixedChargePanel");
   if (this.validateCalcRuleFixedChargePanel) {
     if (validateCalcRuleFixedChargePanel() == false) {
	return false;
     } 
   }
//alert("Before Validate CalcRulePerUnitChargePanel");
   if (this.validateCalcRulePerUnitChargePanel) {
     if (validateCalcRulePerUnitChargePanel() == false) {
	return false;
     } 
   }
//alert("Before Validate CalcRulePercentageChargePanel");
   if (this.validateCalcRulePercentageChargePanel) {
     if (validateCalcRulePercentageChargePanel() == false) {
	return false;
     } 
   }

  return true;
 }
 





function preSubmitHandler()
 {
  
      return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
 	
  if (submitErrorStatus == "calcRuleExists")
   {
    put("calcRuleExists", true);
    gotoPanel("calcRuleGeneralPanel");
   }
  else
   {
    put("calcRuleGenericError", true);
    gotoPanel("calcRuleGeneralPanel");
   }

 }

function submitFinishHandler(submitFinishMessage)
 {
  
  if (submitFinishMessage != null && submitFinishMessage != "") {
	var o = get("calcRuleDetailsBean");
	if (o.id == "") {
		alertDialog(submitFinishMessage);
	}
  }
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
    window.location.replace("CalcRulesByCalcCodeView?ActionXMLFile=shipping.CalcRulesByCalcCodeList&cmd=CalcRulesByCalcCodeListView");
   }
 }