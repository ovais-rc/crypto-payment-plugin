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

   function submitErrorHandler (errMessage)
   {
     //alert("Inside my version of submitErrorHandler()");
     alertDialog(errMessage);
     gotoPanel("userGeneralUserInfo");
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
parent.location.replace(top.getWebPath() + "NewDynamicListView?cmd=AdminConUserAdminView&amp;ActionXMLFile=adminconsole.UserAdminList" );
        }
   }

   function preSubmitHandler()
   {
  	remove("allgrpList");
  	remove("originalList");
  	remove("assignedList");
	remove("accessgroup");
   }

 
