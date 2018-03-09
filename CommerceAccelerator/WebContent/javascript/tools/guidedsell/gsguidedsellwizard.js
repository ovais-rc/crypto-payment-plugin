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
	top.remove("fromRemove");
	top.remove("pathId");
	top.remove("linkArray");
	top.remove("checkedVals");
	top.remove("changedLinkData");
}

function submitErrorHandler (errMessage){
	removeTopContents();
	gotoPanel("gsTreeInfo");
}

function submitFinishHandler (finishMessage){
	removeTopContents();
	if(top.goBack){
		top.goBack();
	}

}

function submitCancelHandler(){
	  removeTopContents();
        if (top.goBack) {
           top.goBack();
        } 
}

function preSubmitHandler(){
	removeTopContents();
}

 
