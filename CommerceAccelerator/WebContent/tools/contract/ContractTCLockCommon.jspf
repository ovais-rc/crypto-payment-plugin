<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*,
     com.ibm.commerce.command.CommandContext,
     com.ibm.commerce.server.ECConstants,
     com.ibm.commerce.ras.ECTrace,
     com.ibm.commerce.ras.ECTraceIdentifiers,
     com.ibm.commerce.tools.util.*" %>


<%
   //-----------------------------------------------------------------
   // Obtain the specified contract terms and condition type unique ID
   //-----------------------------------------------------------------
   Integer contractTCTypeID = (Integer) request.getAttribute("com.ibm.commerce.contract.util.CONTRACT_TCTYPE_ID");
   if (contractTCTypeID == null)
   {
     ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                   "tools/contract/ContractTCLockCommon.jsp",
                   "service",
                   "com.ibm.commerce.contract.util.CONTRACT_TCTYPE_ID is null");
   }


   //--------------------------------------------------------------
   // Checking the terms and conditions lock for the given TC type
   // in contract change mode. This is not applicable if a draft
   // contract is not even created. The resulting variables are
   // listed below:
   //
   // lockHelperRC    - return code from using ContractTCLockHelper
   // tcLockOwner     - the current TC's lock owner user loggon ID
   // tcLockTimestamp - the current TC's lock creation timestamp
   //--------------------------------------------------------------
   int    lockHelperRC    = 0;
   String tcLockOwner     = "";
   String tcLockTimestamp = "";

   if (foundContractId && contractTCTypeID!=null)
   {
      try
      {
         com.ibm.commerce.contract.util.ContractTCLockHelper myLockHelper
               = new com.ibm.commerce.contract.util.ContractTCLockHelper
                     (contractCommandContext,
                      new Long(contractId),
                      contractTCTypeID.intValue());
         lockHelperRC    = myLockHelper.managingLock();
         tcLockOwner     = myLockHelper.getCurrentLockOwnerLogonId();
         tcLockTimestamp = myLockHelper.getCurrentLockCreationTimestamp();
      }
      catch (Exception exp)
      {
        ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                      "tools/contract/ContractTCLockCommon.jsp",
                      "service",
                      "ContractTCLockHelper creation fails: " + exp.toString());
         exp.printStackTrace();
      }
   }


%>



<script LANGUAGE="JavaScript">
<%--
//-------------------------------------------------------
// GLOBAL VARIABLES
//
// These variables capture the return code and some
// lock details of executing the ContractTCLockHelper.
// The contractTCLockHelperRC will always be "0" if it
// is in a draft contract creation mode.
//-------------------------------------------------------
--%>
var contractTCLockHelperRC = "<%= lockHelperRC %>";
var contractTCLockOwner    = "<%= tcLockOwner %>";
var contractTCLockTime     = "<%= tcLockTimestamp %>";
var shouldTCbeSaved        = false;



<%--
//------------------------------------------------------------------------
// Function Name: handleTCLockStatus
//
// This function handle the current lock status for the terms and
// conditions. It will determine the dialog to interact with user
// according to the lock status return code 'contractTCLockHelperRC'.
//
//------------------------------------------------------------------------
// Parameters:
//
// tcNameTagInJavaScriptDataModel
//   - The index name used to reference the lockInfo's data record
//     within the given java script data model. For example, it can
//     be "OrderApprovalTC", "ShippingTC", "GeneralOthersPages", etc.
//
// javaScriptDataModel
//   - The data model will be used to store the lock information.
//
// tcTypeName
//   - The display name of the contract's terms and conditions.
//
// tcTypeID
//   - The contract's terms and conditions type unique identifier.
//
// msgWarnUserTCIsLocked
//   - The display message that warns user about the current terms
//     and conditions are currently locked by another user.
//
// msgWarnUserTCIsLockedButAllowUnlock
//   - The display message that prompts user to optionally unlock
//     the terms and conditions even though the terms and conditions
//     are currently locked by another user.
//
// toBeDisabledFormNames
//   - A list of HTML forms that should be disabled to prevent
//     user's inputs if the terms and conditions are locked by
//     another user.
//
// tctypeForContractTCLockHelperFrame
//   - Specify the terms and conditions type number defined in the
//     ContractTCLockHelperFrame.jsp URL parameters, current valid
//     options are listed below:
//                      1 - Pricing TC
//                      2 - Shipping TC
//                      3 - Payment TC
//                      4 - Returns TC
//                      5 - Order Approval TC
//                      6 - General, Participants, Attachment,
//                          and Remarks Pages
//
//------------------------------------------------------------------------

--%>
function handleTCLockStatus(tcNameTagInJavaScriptDataModel,
                            javaScriptDataModel,
                            tcTypeName,
                            tcTypeID,
                            msgWarnUserTCIsLocked,
                            msgWarnUserTCIsLockedButAllowUnlock,
                            toBeDisabledFormNames,
                            tctypeForContractTCLockHelperFrame)
{
   if (contractTCLockHelperRC==0)
   {
      // Skip it because this is a new contract not even created yet
      return;
   }

   var forceUnlock = false;

   if (   (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ACQUIRE_NEWLOCK %>")
       || (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_RENEW_LOCK %>") )
   {
      // New lock has been acquired for the current user on this TC
      shouldTCbeSaved = true;
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_NOT_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, and user is not allowed to unlock.
      // Show warning message to the user

      shouldTCbeSaved = false;
      var tcName      = tcTypeName;
      var warningMsg  = msgWarnUserTCIsLocked;
      warningMsg = warningMsg.replace(/%3/, tcName);
      warningMsg = warningMsg.replace(/%1/, contractTCLockOwner);
      warningMsg = warningMsg.replace(/%2/, contractTCLockTime);

      alertDialog(warningMsg);
   }
   else if (contractTCLockHelperRC=="<%= com.ibm.commerce.contract.util.ContractTCLockHelper.RC_ALLOWED_TO_UNLOCK %>")
   {
      // This TC has been locked by someone, but user is allowed to unlock.
      // Promopt user to unlock

      var tcName    = tcTypeName;
      var promptMsg = msgWarnUserTCIsLockedButAllowUnlock;
      promptMsg = promptMsg.replace(/%3/, tcName);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);
      promptMsg = promptMsg.replace(/%2/, contractTCLockTime);
      promptMsg = promptMsg.replace(/%1/, contractTCLockOwner);

      if (confirmDialog(promptMsg))
      {
         // User clicks OK to unlock this TC
         shouldTCbeSaved = true;
         forceUnlock = true;
         parent.unlockAndLockContractTC("<%= contractId %>", tctypeForContractTCLockHelperFrame);
      }
      else
      {
         // User clicks CANCEL to give up the unlock of this TC
         shouldTCbeSaved = false;
      }
   }

   // Persist the flag to the given javascript data model (e.g. ContractCommonDataModel)
   if (javaScriptDataModel!=null)
   {
      javaScriptDataModel.tcLockInfo[tcNameTagInJavaScriptDataModel] = new Object();
      javaScriptDataModel.tcLockInfo[tcNameTagInJavaScriptDataModel].contractID = "<%= contractId %>";
      javaScriptDataModel.tcLockInfo[tcNameTagInJavaScriptDataModel].tcType = tcTypeID;
      javaScriptDataModel.tcLockInfo[tcNameTagInJavaScriptDataModel].shouldTCbeSaved = shouldTCbeSaved;
      javaScriptDataModel.tcLockInfo[tcNameTagInJavaScriptDataModel].forceUnlock = forceUnlock;
   }

   if (!shouldTCbeSaved)
   {
      // Disallow user to change any fields
      disableAllFormsElements(toBeDisabledFormNames);
   }

   return;

}//end-function-handleTCLockStatus



<%--
//------------------------------------------------------------------------
// Function Name: disableAllFormsElements
//
// This function disables all the elements in the forms, so that user will
// not able to change the contents in the forms fields. if additional logic
// is needed, developers can implement the logic in a callback javascript
// function named "postDisableAllFormsElements()".
//------------------------------------------------------------------------
--%>
function disableAllFormsElements(formNames)
{
   if (formNames!=null)
   {
      for (var i=0; i<formNames.length; i++)
      {
         for (var j=0; j<document.forms[formNames[i]].elements.length; j++)
         {
            document.forms[formNames[i]].elements[j].disabled = true;
         }
      }
   }

   //---------------------------------------------------------
   // If the user defines a function for handling post events,
   // call back the function 'postDisableAllFormsElements'.
   //---------------------------------------------------------
   if (this.postDisableAllFormsElements)
   {
      postDisableAllFormsElements();
   }

}



</script>
