/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//----------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////

function submitErrorHandler(submitErrorMessage, submitErrorStatus)
{
  alertDialog(submitErrorMessage);
}

function submitFinishHandler(submitFinishMessage)
{
	alertDialog(submitFinishMessage);
	var nextView = top.getData("nextView");
	top.put("newTemplateName",NAVIGATION.requestProperties["newTemplateName"]);
	top.put("newTemplateMessageId",NAVIGATION.requestProperties["newTemplateMessageId"]);
	if (top.goBack && nextView != "newEmailActivity")
    {
        top.goBack();
    }
	else
	{
	  top.goBack("2");
	  url = top.getWebappPath() + 'DialogView?XMLFile=emailactivity.EmailActivityDialogAdd';
      top.setContent("New Email Activity", url, true);
	}
 }


function submitCancelHandler()
{
  if(self.CONTENTS.shouldGoBack())
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

function saveNCreateEmailActivity()
{
	top.saveData("newEmailActivity", "nextView");
	var comingFrom = top.get("comingFrom");
	if(comingFrom == "emailActivityPage")
	{
		//we are coming from emailActivity page itself..
		// by clicking new template button
		top.put("templateList","!readOnly");
		top.put("afterCreationGoTo","emailActivityListPage");
		//select this template name in the drop down box in activity page...
		top.put("preSelectTemplateName", "true");
	}
	else
	{
		//now we are going to create email activity...
		top.put("templateList","readOnly");
		top.put("afterCreationGoTo","TemplateListPage");
	}
	finish();
}



