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
  
   function validateAllPanels(){
     
   }

   function submitErrorHandler (errMessage){
     
   }

   function submitFinishHandler (finishMessage){
     
   }

   function preSubmitHandler(){

     var temp = top.getData("formattedExpectedDate");

     var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=inventory.VendorWizard&startingPage=vendorPurchaseOrderDetailList";
     if ((temp == "null") || (temp == null)){
       url += "&formattedExpectedDate=";
     } else {
       url += "&formattedExpectedDate=" + temp;
     }
     window.location.replace(url);

   }
   
   function submitCancelHandler(){
     if (CONTENTS.cancel()) {   
       preSubmitHandler();
     }
   }

 
