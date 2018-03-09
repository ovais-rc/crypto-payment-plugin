/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.2002,2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////

function preSubmitHandler()
 { 
   self.CONTENTS.passParameters();   
   return true;
 }

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
 {
   if(submitErrorMessage == "CreateEmailActivityUnsuccessful"){
       self.CONTENTS.showCreateEmailActivityErrorMessage();
   } else if(submitErrorMessage == "UpdateEmailActivityUnsuccessful"){
        self.CONTENTS.showChangeEmailActivityErrorMessage();
   } else if(submitErrorMessage == "emailActivityDuplicateName"){
        self.CONTENTS.showDuplicateEmailActivityErrorMessage();
   }
/*
   if (top.goBack)
       {
           top.goBack();
    }
*/

 }

function submitFinishHandler(submitFinishMessage)
 {
    self.CONTENTS.showEmailActivitySuccessMessage(); 
    var emailActivityResult = new Array();
    emailActivityResult[0] = new Object();
    emailActivityResult[0].emailActivityId = window.NAVIGATION.requestProperties["emailPromotionId"];
    emailActivityResult[0].emailActivityStoreId = window.NAVIGATION.requestProperties["storeEntityId"];
    top.sendBackData(emailActivityResult, "emailActivityResult");
    
   var afterCreationGoTo = top.get("afterCreationGoTo");
   top.remove("afterCreationGoTo");
   if(afterCreationGoTo == "TemplateListPage")
   {
  	   goToTemplateListPage();
   }
   else if (top.goBack)
    {
        top.goBack();
    }
 }

function submitCancelHandler()
 {  
   var afterCreationGoTo = top.get("afterCreationGoTo");
   if(afterCreationGoTo == "TemplateListPage")
   {
	   goToTemplateListPage();
   }
   else if(self.CONTENTS.shouldGoBack()) 
   {
       if (top.goBack)
       {
              top.goBack();
       }
   }
 }

 function cancelOnBCT()
 {
  if(self.CONTENTS.shouldGoBack())
  {
	 if (top.goBack)
	   {
		   top.goBack();
	   }
  }
 }

function goToTemplateListPage()
{
	var url = top.getWebappPath() + 'NewDynamicListView?ActionXMLFile=emailactivity.EmailTemplateList&amp;cmd=EmailTemplateListView&amp;orderby=name&amp;viewType=allTemplatesTypes';
	var BCT = top.get("emailTemplateListBCT");
	if (top.setContent)
	{
		//remove email tempalte list apge...and use navigation.properties.....dont hard code it here..
		top.setContent(BCT, url, true);
	}
	else
	{
		parent.location.replace(url);
	}
}