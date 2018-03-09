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

   
   function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
  if (submitErrorStatus == "segmentExists")
   {
    put("segmentExists", true);
    gotoPanel("GeneralInfo");
   }
  else
   {
    alertDialog(submitErrorMessage);
   }
 }

   function submitFinishHandler (finishMessage)
   {
     submitCancelHandler();
   }

   function submitCancelHandler()
   {
        if (top.goBack) {
           top.goBack();
        } 
        else {
           alertDialog("Error: top.goBack invalid");
	parent.location.replace("/webapp/wcs/tools/servlet/DynamicListSCView?ActionXMLFile=adminconsole.MemberGroupList&cmd=AdminConMemberGroupView&listsize=20&startindex=0&refnum=0");
	}
   }

   function preSubmitHandler()
   {
   }

 
