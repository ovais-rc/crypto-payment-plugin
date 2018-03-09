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
   	   	
    if (submitErrorStatus == "_ERR_RDN_ALREADY_EXIST")
    {
        put("nameExists", true);
        gotoPanel("OrgEntityGeneral");
    }
    
    if (submitErrorStatus == "_ERR_DN_ALREADY_EXIST")
    {
        put("dnNameExists", true);
        gotoPanel("OrgEntityGeneral");
    }
     if (submitErrorStatus == "_ERR_CMD_INVALID_PARAM")
    {
        put("invalidParam", true);
        gotoPanel("OrgEntityGeneral");
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
parent.location.replace(top.getWebPath() + "NewDynamicListView?ActionXMLFile=adminconsole.OrgEntityList&amp;cmd=OrgEntityListView" );
        }
   }

   function preSubmitHandler()
   {

   }

 
