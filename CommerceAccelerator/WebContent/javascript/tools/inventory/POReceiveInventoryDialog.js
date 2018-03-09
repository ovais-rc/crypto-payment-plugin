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
  
   function validatePanel(){
     
   }

   function submitErrorHandler (errMessage){
   alertDialog(convertFromTextToHTML(errMessage)); 
   }

  function submitFinishHandler (finishMessage){
     alertDialog(convertFromTextToHTML(finishMessage));
     if (top.goBack) {
                  top.goBack();
       }
     
   }
   
   
  function submitCancelHandler(){
             CONTENTS.cancel();
            
       }
   
   
   function preSubmitHandler(){
    
   }

 
