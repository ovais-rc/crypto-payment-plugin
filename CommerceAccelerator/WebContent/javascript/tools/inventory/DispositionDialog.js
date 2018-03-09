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


function okBack() {
    top.goBack();
}

  
function submitErrorHandler (errMessage){}
  

function submitFinishHandler (finishMessage){
     	alertDialog(convertFromTextToHTML(finishMessage));
        submitCancelHandler();
}
  
     
function preSubmitHandler(){}

     
function submitCancelHandler(){
        top.goBack()
}
     

function addDisposition() { 
	if (CONTENTS.validatePanelData()){
		  CONTENTS.savePanelData()
	}
}
        
     
  
   

