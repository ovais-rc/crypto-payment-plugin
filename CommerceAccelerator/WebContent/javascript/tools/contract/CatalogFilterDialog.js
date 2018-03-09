//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2002, 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

var buttonsDisabledOnLoad = false;


function preSubmitHandler()
{
   var JROM = CONTENTS.getJROM();
   var redirectURL = top.getWebPath() + "DialogView?XMLFile=contract.CatalogFilterDialog";

   addURLParameter("redirecturl", redirectURL);
   addURLParameter("XMLFile", "contract.CatalogFilterDialog");
      addURLParameter("contractId", JROM.contractId);
      addURLParameter("deploy", true);
      addURLParameter("storeId", JROM.storeId);
      addURLParameter("lastUpdatedTime", JROM.contractLastUpdateTime);

      var termConditionList = new Object();

      if(CONTENTS.createPriceTCMasterCatalogWithFiltering){
         var PriceTCMasterCatalogWithFiltering = new CONTENTS.createPriceTCMasterCatalogWithFiltering();
         termConditionList.PriceTCMasterCatalogWithFiltering = PriceTCMasterCatalogWithFiltering;
         termConditionList.PriceTCMasterCatalogWithFiltering.action = "update";
         termConditionList.PriceTCMasterCatalogWithFiltering.referenceNumber = JROM.termConditionId;

      if (termConditionList.PriceTCMasterCatalogWithFiltering.referenceNumber == "null") {
         termConditionList.PriceTCMasterCatalogWithFiltering.action = "new";
      }
      }

   var FIXED = CONTENTS.getFIXED();
   // create a custom price list XML
      CONTENTS.createFixedPriceTCCustomPriceList(termConditionList, FIXED, JROM.contractId);

   // Create a PriceTCConfigBuildBlock XML
   var JKIT = CONTENTS.getJKIT();
   termConditionList.PriceTCConfigBuildBlock = CONTENTS.createPriceTCConfigBuildBlock(JKIT, JROM);

   putXSDnames("TermConditionList", "Package.xsd");
      Xput("TermConditionList", termConditionList);

   // if you uncomment the following line, you need to comment out the createFixedPriceTCCustomPriceList
   // line above
      //popupXMLwindow(termConditionList, "TermConditionList");
}

function submitFinishHandler(submitFinishMessage){

   if(submitFinishMessage != null && submitFinishMessage != ""){
      var url = "DialogView?XMLFile=contract.CatalogFilterDialog";
      url += self.CONTENTS.getContractNVP();
      url += self.CONTENTS.getHostingNVP();
      window.location.replace(url);
      alertDialog(submitFinishMessage);
   }
}

function submitCancelHandler(){
   var cancelMessage = CONTENTS.getCancelMessageNLText();
   if(confirmDialog(cancelMessage)){

   /*90288*/
   waitForPricingTCsUnlockBeforeExit = true;
   unlockPricingTCs("submitCancelHandler");
   window.setTimeout("waitForPricingTCsUnlockBeforeExitBack()", 500);
   return;

/*
      var contractEdit = self.CONTENTS.getContractNVP();
      if (contractEdit.length != 0) {
         top.goBack();
      } else {
         var url = "DialogView?XMLFile=contract.CatalogFilterDialog";
         url += self.CONTENTS.getContractNVP();
         url += self.CONTENTS.getHostingNVP();
         window.location.replace(url);
      }
*/
   }
}

function submitErrorHandler(submitErrorMessage, submitErrorStatus){

   if (submitErrorStatus == "ContractHasBeenChanged"){
      var url = "DialogView?XMLFile=contract.CatalogFilterDialog";
      url += self.CONTENTS.getContractNVP();
      url += self.CONTENTS.getHostingNVP();
      window.location.replace(url);
         alertDialog(CONTENTS.getConcurrencyErrorMessageText());
      }else if (submitErrorStatus == "WrongStateForUpdate"){
         alertDialog(CONTENTS.getPublishNotCompleteErrorMessageText());
      }else{
         alertDialog(CONTENTS.getGenericErrorMessageText());
      }
}

function refreshAction(){
      var url = "DialogView?XMLFile=contract.CatalogFilterDialog";
      url += self.CONTENTS.getContractNVP();
      url += self.CONTENTS.getHostingNVP();
      window.location.replace(url);
}

function goHomeAction(){
   top.setHome();
}

function navigationOnLoad() {
   if (NAVIGATION.document.getElementsByName("OKButton")[0] &&
       NAVIGATION.document.getElementsByName("CancelButton")[0]) {

         // only disable the button once when the tree is first loaded.  if the buttons
         // have been enabled at some point, they should not be disabled here...
         if (! buttonsDisabledOnLoad) {
         NAVIGATION.document.getElementsByName("OKButton")[0].disabled = true;
       NAVIGATION.document.getElementsByName("OKButton")[0].className='disabled';
       NAVIGATION.document.getElementsByName("OKButton")[0].id='disabled';
         //NAVIGATION.document.getElementsByName("CancelButton")[0].disabled = true;
         //NAVIGATION.document.getElementsByName("OKButton")[0].style.background = '#1C5890';
         //NAVIGATION.document.getElementsByName("CancelButton")[0].style.background = '#1C5890';

         buttonsDisabledOnLoad = true;
      }
   }
}


/*90288*/
//-----------------------------------------------------------
// Function: wait the 'waitForPricingTCsUnlockBeforeExit'
//           is set to false by user's page. (no pause/sleep
//           functions available in javascript)
//-----------------------------------------------------------
var waitForPricingTCsUnlockBeforeExit;
function waitForPricingTCsUnlockBeforeExitBack()
{
   //alert("waitForPricingTCsUnlockBeforeExitBack");
   if (waitForPricingTCsUnlockBeforeExit)
   {
      window.setTimeout("waitForPricingTCsUnlockBeforeExitBack()", 500);
      return;
   }

   //alert("Do the rest of original submitCancelHandler does");

   // Do the rest of original submitCancelHandler does
   var contractEdit = self.CONTENTS.getContractNVP();
   if (contractEdit.length != 0)
   {
      top.goBack();
   }
   else
   {
      var url = "DialogView?XMLFile=contract.CatalogFilterDialog";
      url += self.CONTENTS.getContractNVP();
      url += self.CONTENTS.getHostingNVP();
      window.location.replace(url);
   }
}



/*90288*/
//-----------------------------------------------------------
// This is a callback function from the bean curb container,
// it allows the notebook to perform clean up job when user
// click a bean curb link from a notebook.
// This will perform the pricing terms and conditions
// unlock operations.
//-----------------------------------------------------------
function cancelOnBCT()
{
	
	if (!NAVIGATION.document.getElementsByName("OKButton")[0].disabled) {
	   if (parent.confirmDialog(top.confirm_message)==false)
	   {
	      // User chooses to stay and edit more
	      return false;
	   }
	}
   unlockPricingTCs("cancelOnBCT");
   return true;
}


/*90288*/
//----------------------------------------------------------------
// This is a callback function from the ContractTCLockHelperFrame
//----------------------------------------------------------------
function contractTCLockHelperFrameDone(callbackID, overallResultCode, resultCodes)
{
   //alert("callbackID = " + callbackID);

   if (callbackID=="cancelOnBCT")
   {
      top.mccbanner.waitForCancel = false;
      return;
   }
   else if (callbackID=="submitCancelHandler")
   {
      waitForPricingTCsUnlockBeforeExit = false;
   }
   else if (callbackID=="unlockAndLockContractTC")
   {
      return;
   }
   else if (callbackID=="validatePricingTCLock")
   {
      checkPricingTCUnlockResult(overallResultCode, resultCodes);
   }
}


/*90288*/
//--------------------------------------------------------------
// This function dynamically creates an invisible iframe as the
// channel to invoke backend services to unlock the Pricing TC
//--------------------------------------------------------------
function unlockPricingTCs(callbackID)
{
//   alert("unlockPricingTCs() entry");

   if (callbackID==null) { callbackID = "normal"; }

   /*d93206*/
   if (CONTENTS.getJROM==null)
   {
      contractTCLockHelperFrameDone(callbackID, null, null);
      return;
   }

   var JROM = CONTENTS.getJROM();
   if (JROM==null)
   {
      alert("unlockPricingTCs()::JROM is null");
      contractTCLockHelperFrameDone(callbackID, null, null);
      return;
   }

   //-----------------------------------------------------------------
   // Construct the IFRAME as the action frame for doing the unlocking
   //-----------------------------------------------------------------
   var lockHelperIFrame = document.createElement("IFRAME");
   lockHelperIFrame.id="LockHelperIFrame";
   lockHelperIFrame.src="/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   lockHelperIFrame.style.position = "absolute";
   lockHelperIFrame.style.visibility = "hidden";
   lockHelperIFrame.style.height="0";
   lockHelperIFrame.style.width="0";
   lockHelperIFrame.frameborder="0";
   lockHelperIFrame.MARGINHEIGHT="0";
   lockHelperIFrame.MARGINWIDTH="0";


   // Require to remove the existing LockHelperIFrame iframe if it
   // is existed, and replace a new one. Otherwise, after the first time
   // of this function is being called, all the subsequence calls to
   // this function will not take effect invoking the URL in the iframe.
   var oldElem = document.getElementById("LockHelperIFrame");
   if (oldElem)
   {
      //alert("oldElem is found");
      var removedNode = oldElem.parentNode.replaceChild(lockHelperIFrame, oldElem);
   }
   else
   {
      //alert("oldElem is not found");
      document.body.appendChild(lockHelperIFrame);
   }


   var queryString;
   var webAppPath = "/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   var traceLog = "";

   //----------------------------
   // Unlock Pricing TC
   //----------------------------
   if (JROM.tcLockInfo)
   {
      if (JROM.tcLockInfo["PricingTC"]!=null)
      {
         if (JROM.tcLockInfo["PricingTC"].shouldTCbeSaved==true)
         {
            traceLog += "PricingTC";
            queryString = "?contractid=" + JROM.tcLockInfo["PricingTC"].contractID
                        + "&tctype=1&service=2"
                        + "&callbackid=" + callbackID;
            document.all.LockHelperIFrame.src = webAppPath + queryString;
         }
      }
   }

   // If no unlock operation is needed, invoke the contractTCLockHelperFrameDone() to close the job.
   //alert("traceLog=" + traceLog);
   if (traceLog=="")
   {
      contractTCLockHelperFrameDone(callbackID, null, null);
   }

}


/*90288*/
//--------------------------------------------------------------
// This function dynamically creates an invisible iframe as the
// channel to invoke backend services to unlock and relock the
// specific terms and conditions for the contract.
//
//       contractID - specify the contract ID
//
//       tctype - specify the terms and condition type, valid
//                options are listed below:
//                      1 - Pricing TC
//                      2 - Shipping TC
//                      3 - Payment TC
//                      4 - Returns TC
//                      5 - Order Approval TC
//                      6 - General, Participants, Attachment,
//                          and Remarks Pages
//
//--------------------------------------------------------------
function unlockAndLockContractTC(contractID, tctype)
{
   //alert("unlockAndLockContractTC(" + contractID + "," + tctype + ") entry");

   var callbackID = "unlockAndLockContractTC";
   var lockHelperIFrame = document.createElement("IFRAME");
   lockHelperIFrame.id="LockHelperIFrame_1";
   lockHelperIFrame.src="/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   lockHelperIFrame.style.position = "absolute";
   lockHelperIFrame.style.visibility = "hidden";
   lockHelperIFrame.style.height="0";
   lockHelperIFrame.style.width="0";
   lockHelperIFrame.frameborder="0";
   lockHelperIFrame.MARGINHEIGHT="0";
   lockHelperIFrame.MARGINWIDTH="0";


   // Require to remove the existing LockHelperIFrame_1 iframe if it
   // is existed, and replace a new one. Otherwise, after the first time
   // of this function is being called, all the subsequence calls to
   // this function will not take effect invoking the URL in the iframe.
   var oldElem = document.getElementById("LockHelperIFrame_1");
   if (oldElem)
   {
      //alert("oldElem is found");
      var removedNode = oldElem.parentNode.replaceChild(lockHelperIFrame, oldElem);
   }
   else
   {
      //alert("oldElem is not found");
      document.body.appendChild(lockHelperIFrame);
   }


   // Prepare the proper URL to invoke the helper
   var webAppPath = "/webapp/wcs/tools/servlet/ContractTCLockHelperFrameView";
   var queryString = "?contractid=" + contractID
                     + "&tctype=" + tctype
                     + "&service=1"
                     + "&callbackid=" + callbackID;

   document.all[lockHelperIFrame.id].src=webAppPath + queryString;

   //alert("unlockAndLockContractTC(" + contractID + "," + tctype + ") exit");
}


/*90288*/
// The 'hasCalled' flag helps avoiding endless loop to be
// happended when the tools framework's finish() is invoked.
var hasCalled_validatePricingTCLock=false;

// This store the warning message to be displayed to the user
var validatePricingTCLock_ErrMsg = "";


/*90288*/
//------------------------------------------------
// This function use the lock helper to validate
// the exisiting pricing TC lock
//------------------------------------------------
function validatePricingTCLock(errMsg)
{
   validatePricingTCLock_ErrMsg = errMsg;

   if (!hasCalled_validatePricingTCLock)
   {
      //alert("unlock TC");

      unlockPricingTCs("validatePricingTCLock");

      // Returning false will stop the tools framework submitting
      // the data to the backend. And it will wait for the lock
      // helper frame to callback with the result.
      return false;
   }
   else
   {
      //alert("unlock TC no need");
      hasCalled_validatePricingTCLock = false;
      return true;
   }
}


/*90288*/
//--------------------------------------------------------------
// This is a callback's callback function. When the lock helper
// frame is done, it callbacks the contractTCLockHelperFrameDone()
// which will call this function iff the lock helper invocation
// is originated from validatePricingTCLock() calling.
// This function will examine the return code from the unlock
// operation and prompt a warning message to user if appropiate.
//--------------------------------------------------------------
function checkPricingTCUnlockResult(overallRC, rcList)
{
   //alert("checkPricingTCUnlockResult(), overallRC=" + overallRC);

   if (overallRC=="1")
   {
      // Unlock is executed perfectly, reset the 'hasCalled'
      // flag and continue the data submission works to backend.

      hasCalled_validatePricingTCLock = true;
      this.finish();
   }
   else
   {
      // Fail to unlock, display warning message to the user
      hasCalled_validatePricingTCLock = false;
      alertDialog(validatePricingTCLock_ErrMsg);
   }
}
