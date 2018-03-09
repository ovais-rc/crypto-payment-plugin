/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

    function submitCancelHandler()
    {
    	put("uploadDone", false);
	top.goBack();
    }

    function submitErrorHandler(submitErrorMessage)
    { 
        alertDialog(submitErrorMessage);
      	put("uploadGenericError", true);
  	gotoPanel("addrfqattachment");  
    }

    function submitFinishHandler(submitFinishMessage)
    {
   	// Get the attachment Id.
    	var requestProperties = new Array();
    	requestProperties = NAVIGATION.getRequestProperties();
    	var attachmentId = requestProperties["attachmentId"];
    	var attachFilename = requestProperties["attachFilename"];
    	var attachFilesize = requestProperties["attachFilesize"];

    	var anAttachment = new Object();
    	anAttachment = top.getData("anAttachment",1);
    	anAttachment.attachmentId = attachmentId;
    	anAttachment.attachFilename = attachFilename;
    	anAttachment.attachFilesize = attachFilesize;
    	top.sendBackData(anAttachment,"anAttachment");

    	var allAttachments = new Object();
    	allAttachments = top.getData("allAttachments",1);
    	allAttachments[allAttachments.length] = anAttachment;
    	top.sendBackData(allAttachments,"allAttachments");

    	put("uploadDone", true);
    	top.goBack();
    }
 
    function preSubmitHandler()
    {
   	// Skip the TFW form and submit form in JSP directly.
   	self.CONTENTS.document.rfqAttachmentForm.submit();
   	return true;
    }
