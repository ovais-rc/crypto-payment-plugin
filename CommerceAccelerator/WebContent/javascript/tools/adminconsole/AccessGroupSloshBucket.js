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

   function validateAllPanels()
   {
     //alert("Inside my version of validateAllPanels()");
   }

   function submitErrorHandler (errMessage)
   {
     //alert("Inside my version of submitErrorHandler()");
     alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage)
   {
     //alert("submitFinishHandler: Finishing");
     //top.sendBackData(get("assignedList"), "assignedDList");
     //top.sendBackData(get("deletedList"), "deletedDList");
     //top.sendBackData(get("addedList"), "addedDList");
     //submitCancelHandler();
     alertDialog(finishMessage);
   }

   function submitCancelHandler()
   {
     //alert("Cancelling the Access Member Groups changes");
     
     if (top.goBack) {
        //alert("Going back"); 
        top.goBack();
     }
     else
     {
parent.location.replace("/webapp/wcs/tools/servlet/AccessGroupDynamicListView?ActionXMLFile=adminconsole.AccessGroupList&cmd=AdminAccessGroupView&selected=SELECTED&listsize=20&startindex=0&refnum=0");
     }
   }
   
   function preSubmitHandler()
   {
     //alert("preSubmitHandler");
     top.sendBackData(get("assignedList"), "assignedDList");
     top.sendBackData(get("deletedList"), "deletedDList");
     top.sendBackData(get("addedList"), "addedDList");
     submitCancelHandler();
   }

 
