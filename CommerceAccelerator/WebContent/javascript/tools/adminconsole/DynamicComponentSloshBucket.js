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

   function validateAllPanels()
   {
     //alert("Inside my version of validateAllPanels()");
   }

   function submitErrorHandler (errMessage)
   {
     
     alert(errMessage);
   }

   function submitFinishHandler (finishMessage)
   {
     
    submitCancelHandler();

   }

   function submitCancelHandler()
   {
     
     if (top.goBack) {
        //alert("Going back"); 
        top.goBack();
     }
     else
     {

	parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=adminconsole.DynamicCOmponent");
     }
   }
   
   function preSubmitHandler()
   {
    
   }

 
