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

   }



   
  function validateAllPanels() 
  {

  }
 
   function savePanelData()
   {
 
   	CONTENTS.savePanelData();
  }


