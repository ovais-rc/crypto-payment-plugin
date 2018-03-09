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

   function submitErrorHandler (submitErrorMessage, submitErrorStatus) {
      	put("nameNotExists", true);
       	//gotoPanel("userGeneralRoles", null);
       	top.mccmain.mcccontent.CONTENTS.location.reload();
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
       
   }

   function preSubmitHandler()
   {
  	remove("allgrpList");
  	remove("originalList");
  	remove("assignedList");
	remove("accessgroup");
   }

 
