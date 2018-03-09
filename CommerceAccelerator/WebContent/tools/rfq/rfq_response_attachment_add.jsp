<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ include file="../common/common.jsp" %>
<%
    //*** GET LOCALE FROM COMANDCONTEXT ***//
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    if( aCommandContext!= null ) {
   		locale = aCommandContext.getLocale();
    }
    if (locale == null) {
		locale = new Locale("en","US");
    }
    //*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
    JSPHelper jspHelper = new JSPHelper(request);
    String rfqId = jspHelper.getParameter("requestId");
    String responseId = jspHelper.getParameter("responseId");
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head> 
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript">
var msgMandatoryField = '<%= UIUtil.toJavaScript((String)rfqNLS.get("msgEmptyResponseValue")) %>';
var msgInvalidSize = '<%= UIUtil.toJavaScript((String)rfqNLS.get("msgInvalidSize254")) %>';
var allAttachments = new Object();
allAttachments = top.getData("allAttachments",1);
var VPDResult;
function initializeState() {
	parent.setContentFrameLoaded(true);
}
function loadPanelData() {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
function retrievePanelData() {
	return;
}
function savePanelData() {
	VPDResult = validatePanelData0();
	if (!VPDResult) { return; }
	var form = document.rfqAttachmentForm;
	var n = allAttachments.length;
    rfqAttachment = new Object();
    rfqAttachment.identity = n + 1;
    rfqAttachment.attachmentId = null;
    rfqAttachment.attachFilename = form.filename.value;
    rfqAttachment.attachDescription = form.<%= RFQConstants.EC_RFQ_ATTACHMENT_DESCRIPTION %>.value;
    rfqAttachment.attachFilesize = null;
    rfqAttachment.attachCopyFromRequest = "<%= RFQConstants.EC_RFQ_ATTACHMENT_COPYFROMREQUEST_NO %>";
    rfqAttachment.attachOrigFromResponse = "<%= RFQConstants.EC_RFQ_ATTACHMENT_ORIGFROMRESPONSE_NO %>";
    rfqAttachment.attachMarkForDelete = "<%= RFQConstants.EC_RFQ_ATTACHMENT_MARKFORDELETE_NO %>";
    rfqAttachment.attachUpdateDesc = "<%= RFQConstants.EC_RFQ_ATTACHMENT_UPDATEDESC_NO %>";
    top.sendBackData(rfqAttachment,"anAttachment");
}
function validatePanelData() {
	return VPDResult;
}
function validatePanelData0() {
	var form=document.rfqAttachmentForm;
	if (isInputStringEmpty(form.filename.value)) {
	    reprompt(form.filename, msgMandatoryField);
	    return false;
	}
	if (!isValidUTF8length(form.filename.value,254)) {
	    reprompt(form.filename, msgInvalidSize);
	    return false;
	}	
    return true;
}
</script>
</head>
<body onload="loadPanelData()" class="content">
<h1><%= rfqNLS.get("addrfqattachment") %> </h1>
<%= rfqNLS.get("instruction_Attachment_new") %>

<form enctype="multipart/form-data" method="post" name="rfqAttachmentForm" action="RFQResponseAttachmentUpload" target="NAVIGATION">
<p></p>
<input type="hidden" name="XMLFile" value="rfq.rfqResponseAttachmentAdd" />
<input type="hidden" name="refcmd" value="RFQResponseAttachmentUploadCmd" />
<%
    if (rfqId != null) {
%>
<input type="hidden" name="<%= RFQConstants.EC_RFQ_REQUEST_ID %>" value="<%= rfqId %>" />
<%
    }
    if (responseId != null) {
%>
<input type="hidden" name="<%= RFQConstants.EC_RFQ_RESPONSE_ID %>" value="<%= responseId %>" />
<%
    }
%>

<table>
    <tr>
        <td>
            <label for="attachDesc">
            <%= rfqNLS.get("description") %><br />
            </label>
            <textarea name="<%= RFQConstants.EC_RFQ_ATTACHMENT_DESCRIPTION %>" id="attachDesc" cols="50" rows="5"></textarea>
	</td>
    </tr>

    <tr>
        <td>
            <label for="attachFile">
	    <br /><%= rfqNLS.get("filename") %><br />
	    </label>
            <input type="file" name="filename" id="attachFile" size="50" />
            <input type="reset" name="Clear" value='<%= rfqNLS.get("rfqclear") %>' />
	</td>
    </tr>
</table>
</form>
<script type="text/javascript">
    initializeState();
    retrievePanelData();
</script>
</body>
</html>
