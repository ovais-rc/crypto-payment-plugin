/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/

function preSubmitHandler()
 {
   self.CONTENTS.passParameters();   
   return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
   if(submitErrorMessage == "CreateUnsuccessfull"){
     self.CONTENTS.showAssignCustErrorMessage();
   } 
   
   if (top.goBack)
       {
           top.goBack();
    }
 }

function submitFinishHandler(submitFinishMessage)
 {
    self.CONTENTS.showSuccessMessage(); 
    
    if (top.goBack)
    {
        top.goBack();
    }
 }

function submitCancelHandler()
 {  
   if(self.CONTENTS.shouldGoBack()) {
       if (top.goBack)
       {
              top.goBack();
       }
   }
 }
