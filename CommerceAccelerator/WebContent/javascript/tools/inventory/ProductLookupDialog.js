//BR updated 20011120 - 0944
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
     if (errMessage != null){
       alertDialog(convertFromTextToHTML(errMessage) );
     }
   }

   function submitCancelHandler(){

	top.goBack();

   }
   
   function preSubmitHandler(){

     
   }

 function getResultList(){
  var good  = CONTENTS.validate();
  if (good == 'true'){
    CONTENTS.getResultList();
  }
}



