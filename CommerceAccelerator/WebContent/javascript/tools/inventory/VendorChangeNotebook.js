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

   function submitErrorHandler (errMessage)
   {
     
      alertDialog(convertFromTextToHTML(errMessage));
   }

   function submitFinishHandler (finishMessage)
   {
        alertDialog(convertFromTextToHTML(finishMessage));
	submitCancelHandler();
   }

   function submitCancelHandler()
   {
     if (top.goBack) {
       top.goBack();
     } 
   }

   function preSubmitHandler()
   {
        //remove("allgrpList");
  	//remove("originalList");
  	//remove("assignedList");
	//remove("accessgroup");
   }

 /////////////////////////////////
 function updateBillingAddress()
   {
 
   	CONTENTS.updateBillingAddress();
   }
   
  function validateAllPanels() 
  {
     if(!CONTENTS.validatePanelData()){
         
      gotoPanel("vendorNameAddress");
          
           return false;
     }
  }
 
   function savePanelData()
   {
 
   	CONTENTS.savePanelData();
  }


