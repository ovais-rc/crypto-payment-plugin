//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.

function removeTopContents(){
	top.remove("answersVector");
	top.remove("questionObject");
	top.remove("featureArray");
	top.remove("constraintData");
	top.remove("linkArray");
	top.remove("checkedVals");
	top.remove("changedLinkData");
}

function submitErrorHandler(submitErrorMessage, submitErrorStatus) {
	removeTopContents();
	if(submitErrorStatus == "invalidSKUError"){
		put("invalidSKU", true);
		gotoPanel("gsAnswerLink");
	}
	else if(top.goBack){
		alertDialog(top.get("submitErrorMessageAnswer",submitErrorMessage));
		top.remove("submitErrorMessageAnswer");
		top.goBack();
	}
}

function submitFinishHandler(finishMessage) {
	removeTopContents();
	alertDialog(top.get("submitFinishMessageAnswer",finishMessage));
	top.remove("submitFinishMessageAnswer");
	if(top.goBack){
		top.goBack();
	}
}

function submitCancelHandler() {
	removeTopContents();
	if(top.goBack){
		top.goBack();
	}
}

function preSubmitHandler() {
	removeTopContents();
}

