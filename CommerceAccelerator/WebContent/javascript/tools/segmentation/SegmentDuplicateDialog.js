/*==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================*/
   function submitErrorHandler (errMessage)
   {
   	alertDialog(errMessage);
   	top.goBack();
   }

   function submitFinishHandler (finishMessage)
   {
   	top.goBack();	
   }

   function submitCancelHandler()
   {
   	top.goBack();
   }

   function preSubmitHandler()
   {
   	
   }

