//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

   function submitErrorHandler (errMessage)
   {
     alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage)
   {
     alertDialog(finishMessage );
   }

   function submitCancelHandler()
   {
     if(!confirmDialog(CONTENTS.getConfirmationMessage()))
     { return; }
     top.goBack();
   }

function trim(str) 
{
	//removes leading and trailing spaces
	if (str.length==0) 
		return "";  //exit on empty string
	while (str.charAt(0) == " ")
		str = str.substring(1,str.length);  //remove leading spaces
	while (str.charAt(str.length-1)==" ")
		str = str.substring(0,str.length-1); //remove trailing spaces
	return str;
}

   function preSubmitHandler()
   {
     params = new Object();
     var i;
     var actionIdStr = ""
     for( i = 0 ; i < window.CONTENTS.document.createForm.actionSelected.options.length; i ++)
     {
      if(i !=0) 
      {
        actionIdStr = actionIdStr + ",";
      }
       actionIdStr = actionIdStr + window.CONTENTS.document.createForm.actionSelected.options[i].value;
     }
     top.mccbanner.removebct();
     params['actGrpName'] = trim(window.CONTENTS.document.createForm.actiongroupName.value);
     params['actGrpDisplayName'] = trim(window.CONTENTS.document.createForm.actGrpDisplayName.value);
     params['actGrpDesc'] = trim(window.CONTENTS.document.createForm.actiongroupDescription.value);
     params['viewtaskname'] = window.CONTENTS.document.createForm.viewtaskname.value;
     params['actionId'] = actionIdStr;
     params['ActionXMLFile'] = window.CONTENTS.document.createForm.ActionXMLFile.value; 
     params['cmd'] = window.CONTENTS.document.createForm.cmd.value;
     params['authToken'] = window.CONTENTS.document.createForm.authToken.value;
     top.showContent(top.getWebappPath() + 'ActGrpAddCmd',params);
}

  