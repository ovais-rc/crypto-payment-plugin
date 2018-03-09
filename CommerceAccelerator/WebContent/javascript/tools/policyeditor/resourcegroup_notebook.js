//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------

   function submitErrorHandler (errMessage)
   {
     alertDialog(errMessage);
   }

   function submitFinishHandler (SubmitFinishMessage)
   {
     theURL = top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=policyeditor.resourcegroupsList&amp;cmd=resourcegroupListView&amp;resultmsg=' + SubmitFinishMessage;
     top.mccbanner.removebct();
     top.showContent(theURL);
   }

   function submitCancelHandler()
   {
    theURL = top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=policyeditor.resourcegroupsList&amp;cmd=resourcegroupListView';
    top.mccbanner.removebct();
    top.showContent(theURL);
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
     if (window.CONTENTS.document.createForm.explicit.value=="yes") 
     {
     params = new Object();
     var i;
     var resCgryIdStr = ""
     for( i = 0 ; i < window.CONTENTS.document.createForm.resourceSelected.options.length; i ++)
     {
      if(i !=0) 
      {
        resCgryIdStr = resCgryIdStr + ",";
      }
       resCgryIdStr = resCgryIdStr + window.CONTENTS.document.createForm.resourceSelected.options[i].value;
     }
     top.mccbanner.removebct();
     params['viewtaskname'] = window.CONTENTS.document.createForm.viewtaskname.value;
     params['ActionXMLFile'] = window.CONTENTS.document.createForm.ActionXMLFile.value; 
     params['cmd'] = window.CONTENTS.document.createForm.cmd.value;
     params['resGrpId'] = window.CONTENTS.document.createForm.resGrpId.value;
     params['resGrpName'] = trim(window.CONTENTS.document.createForm.resourcegroupName.value);
     params['resGrpDisplayName'] = trim(window.CONTENTS.document.createForm.resGrpDisplayName.value);
     params['resGrpDesc'] = trim(window.CONTENTS.document.createForm.resourcegroupDescription.value);
     params['resCgryId'] = resCgryIdStr;
     params['authToken'] = trim(window.CONTENTS.document.createForm.authToken.value);
     top.showContent(top.getWebappPath() + 'ResGrpUpdateCmd',params);
     }
     else
     {
     //top.showContent('/webapp/wcs/tools/servlet/ResGrpImplicitSaveCmd');
     window.NAVIGATION.document.forms.submitForm.action='ResGrpImplicitSaveCmd';
     window.NAVIGATION.document.forms.submitForm.XML.value = modelToXML("XML");
     window.NAVIGATION.document.forms.submitForm.XMLString.value = XmodelToXML("XMLString");
     window.NAVIGATION.document.forms.submitForm.submit();
     finishAlreadyClicked = false;
     }
}
