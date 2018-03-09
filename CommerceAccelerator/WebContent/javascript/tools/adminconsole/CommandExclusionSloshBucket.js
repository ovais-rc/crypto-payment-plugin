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

function submitFinishHandler(submitFinishMessage)
 {
  submitCancelHandler();
 }

function submitCancelHandler()
 {
   if (top.goBack) {
      top.goBack();
   }
   else
   {
    window.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=adminconsole.CommandExclusionSloshBucket");
   }
 }
 
function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
  if (submitErrorStatus == "segmentExists")
   {
    put("segmentExists", true);
    gotoPanel("segmentNotebookGeneralPanel");
   }
  else if (submitErrorStatus == "segmentChanged")
   {
    put("segmentChanged", true);
    gotoPanel("segmentNotebookGeneralPanel");
   }
  else
   {
    alertDialog(submitErrorMessage);
   }
 }
