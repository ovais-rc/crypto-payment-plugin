/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2003
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

function submitCancelHandler()
{
 
    top.goBack();
}

function submitErrorHandler (submitErrorMessage) {
        alertDialog(submitErrorMessage);
  	gotoPanel("rfqnewprdattrib");  
}

function submitFinishHandler (finishMessage) {

    
    	top.goBack();
}

function preSubmitHandler()
{
     self.CONTENTS.Okaction();
     if ( self.CONTENTS.isAttachmet && self.CONTENTS.isReady)
     {
         self.CONTENTS.document.attrDiag.submit();
         return true;
     }
 
     return false; 
}
