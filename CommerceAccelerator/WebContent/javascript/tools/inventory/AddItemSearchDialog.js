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
   
   
   function submitCancelHandler(){
    
     var status = top.getData("current");
     if (status == "change") {
       var url = "/webapp/wcs/tools/servlet/NotebookView?XMLFile=inventory.VendorNotebookChange&startingPage=vendorPurchaseOrderDetailListChange";
       url += "&formattedExpectedDate=";

       //url += "&status2=" + "changeAdd";
       //url += "&status=" + status;
     } else {
       var url = "/webapp/wcs/tools/servlet/WizardView?XMLFile=inventory.VendorWizard&startingPage=vendorPurchaseOrderDetailList";
       url += "&formattedExpectedDate=";

       //url += "&status2=" + "newAdd";
       //url += "&status=" + status;
     }
     //alert(url);
     window.location.replace(url);
   }
      
   function preSubmitHandler(){
   
     submitCancelHandler();
   }



 function getResultList(){
  var good  = CONTENTS.validate();
  if (good == 'true'){
    CONTENTS.getResultList();
  }
}



