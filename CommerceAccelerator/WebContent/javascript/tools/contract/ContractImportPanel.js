/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

function submitCancelHandler()
{	
	top.goBack();
}

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
{ 
   if (submitErrorStatus == "DuplicatedContractName")
   {
      put("contractExists", true);
      gotoPanel("ContractImportPanel");  
   }
   else if (submitErrorStatus == "WrongMemberParticipantInfo" || submitErrorStatus == "WrongContractOwnerMemberInfo" 
   || submitErrorStatus == "LocaleError" || submitErrorStatus == "RetrieveOrgId" || submitErrorStatus == "WrongContractState"
   || submitErrorStatus == "DuplicateKeyInTC" || submitErrorStatus == "MissingPriceTCInContract" || submitErrorStatus == "MissingBuyerParticipantInContract" 
   || submitErrorStatus == "ContractExpired" || submitErrorStatus == "MissingShippingChargeTCInContract" 
   || submitErrorStatus == "ReturnChargeAndRefundMethodDoNotMatch" || submitErrorStatus == "UserDoNotHaveAuthorityToRunDeployCommand"
   || submitErrorStatus == "WrongNumberOfProviderParticipant" || submitErrorStatus == "WrongNumberOfSupplierParticipant" 
   || submitErrorStatus == "WrongNumberOfHostParticipant" || submitErrorStatus == "WrongNumberOfRecipientParticipant" 
   || submitErrorStatus == "WrongNumberOfResellerParticipant"   || submitErrorStatus == "MissingSellerParticipantInContract"
   || submitErrorStatus == "FoundMoreThanOneOrderApprovalTCInContract"   || submitErrorStatus == "FoundMoreThanOneReturnTCReturnChargeInContract"
   || submitErrorStatus == "CannotHaveMoreThanOneMCOptionalAdjustmentTC"
   || submitErrorStatus == "NoSuspendWithActiveContractReferral"   || submitErrorStatus == "NoCancelWithActiveContractReferral"
   || submitErrorStatus == "NoSubmitWithNonActiveContractReferral"
   || submitErrorStatus == "ContractMarkForDelete" || submitErrorStatus == "DuplicateKeyInTPC" )
   {
      put(submitErrorStatus, true);
      if (submitErrorMessage != null && submitErrorMessage.length > 0) {
      	put("ErrorMessage", submitErrorMessage);
      }
      gotoPanel("ContractImportPanel");  
   }
   else
   {
      put("contractGenericError", true);
      gotoPanel("ContractImportPanel");  
   }
}

function submitFinishHandler(submitFinishMessage)
{
   put("importDone", true);
   gotoPanel("ContractImportPanel");  
}
 
 
function preSubmitHandler()
{
   //Skip the TFW form and submit form in JSP directly.
   self.CONTENTS.document.uploadForm.submit();
   return true;
}

// This function takes in a text and performs some substitution		
function changeSpecialText(rawDisplayText,textOne, textTwo, textThree, textFour) {
    	var displayText = rawDisplayText.replace(/%1/, textOne);
    
    	if (textTwo != null){
	    	displayText = displayText.replace(/%2/, textTwo);
	}
    	if (textThree != null){
	    	displayText = displayText.replace(/%3/, textThree);
	}
    	if (textFour != null){
	    	displayText = displayText.replace(/%4/, textFour);
	}	    
    	return displayText;
}
