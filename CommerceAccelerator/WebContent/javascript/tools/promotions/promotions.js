/*==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================*/
   function submitErrorHandler (errMessage, errStatus)
   {
   	alertDialog(errMessage);
   	if (errStatus == "discountDuplicateName")
   	{
   		gotoPanel("DiscountWizardWelcome");
   	}
   	else
   	{
   		top.goBack();
   	}
   }

   function submitFinishHandler (finishMessage)
   {
	var promotionResult = new Object();
	promotionResult.promotionId = window.NAVIGATION.requestProperties["promotionId"];
	promotionResult.promotionName = window.NAVIGATION.requestProperties["promotionName"];
	top.sendBackData(promotionResult, "promotionResult");

   	alertDialog(finishMessage);
   	top.goBack();
   }

   function submitCancelHandler()
   {
   	//eventually use top.goBack() in MC
	top.goBack();
   }

   function preSubmitHandler()
   {

   }

