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
  


   function submitErrorHandler (errMessage)
   {
     
     alertDialog(convertFromTextToHTML(errMessage));
   }

   function submitFinishHandler (finishMessage)
   {
     if (finishMessage != null){
       alertDialog(convertFromTextToHTML(finishMessage));
     }
    
     top.goBack();
   }

   function preSubmitHandler()
   { 
     
   }
   
   
   function submitCancelHandler() {
     
     if (CONTENTS.cancel()){
       if (top.goBack) {
         top.goBack();
       }
     }
     
   }

 
