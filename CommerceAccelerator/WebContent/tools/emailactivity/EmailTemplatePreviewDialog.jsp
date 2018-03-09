<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>

<%@include file="../common/common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="EmailActivityCommon.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.emarketing.emailtemplate.databeans.EmailTemplateSummaryDatabean" %>
<%@ page import="com.ibm.commerce.emarketing.emailtemplate.tag.TagEngineImpl" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import= "com.ibm.commerce.emarketing.objects.EmailMessageAccessBean" %>
<%@ page import= "com.ibm.commerce.emarketing.emailtemplate.tag.TagUtil" %>
<%@ page import= "com.ibm.commerce.tools.util.Util" %>
<%@ page import = "com.ibm.commerce.emarketing.emailtemplate.tag.*" %>

<meta http-equiv="Content-Type" content="text/html" />
<title><%= emailActivityRB.get("emailActivityPreviewDialogTitle") %></title>

<%  
	String result = null;
	CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	if (commandContext == null) {
		System.out.println("Email Template commandContext is null");
		return;
	}
	String templateType = (String)request.getParameter("templateType");
	String messageId = (String)request.getParameter("messageId");
	String previewRequestFrom = (String)request.getParameter("previewRequestFrom");
	String userId = commandContext.getUserId().toString();
	
	String storeId = request.getParameter(ECConstants.EC_STORE_ID);
	if (storeId!=null) {
	    commandContext.setStoreId( new Integer(storeId) );
	} else {
        storeId = commandContext.getStoreId().toString();
    }

	if(previewRequestFrom != null && previewRequestFrom.equals("EmailActivityDialog"))
	{
			//get the template type...
			EmailTemplateSummaryDatabean etsdb = new EmailTemplateSummaryDatabean(); 
			etsdb.setMessageId(messageId);
			DataBeanManager.activate(etsdb,request);
			templateType = etsdb.getTemplateType();
	}

	if(templateType != null && templateType.equals("1"))
	{
		//JSP template type..
		EmailMessageAccessBean emailMessageAB = new EmailMessageAccessBean();
		emailMessageAB.setInitKey_emailMessageId(new Integer(messageId));
		String jspPath = emailMessageAB.getJspPath();
		String emlMsgStoreId = emailMessageAB.getStoreEntityId();
        
		//If jspPath begins with http:// or https://, or end with ".jsp", treat it as a direct JSP page,
		//otherwise, treat it as a view struts, try to get the content from a URL composer. 
		if (jspPath.startsWith("http://") || jspPath.startsWith("https://") || jspPath.endsWith(".jsp")) {
            StringBuffer urlBuffer = null;
            //For direct JSP page, if jspPath is not begins with "http://" or "https://" , construct the full path..
		    if (jspPath.startsWith("http://") || jspPath.startsWith("https://")){
			    urlBuffer = new StringBuffer(jspPath);
            }
		    else if (jspPath.endsWith(".jsp")){
                //construct the URL...
                urlBuffer = new StringBuffer();
                urlBuffer.append(TagUtil.getMainURL());
                String directory = commandContext.getStore().getDirectory();
                //Directory name may contain spaces..so discard it..
                directory = com.ibm.commerce.tools.util.Util.replace(directory, " ","");
                urlBuffer.append("/" + directory);	
                urlBuffer.append("/" + jspPath);
            }

            if (urlBuffer.indexOf("?") == -1) {
                urlBuffer.append("?");
            }
            else {
                urlBuffer.append("&");
            }

            urlBuffer.append("storeId="+storeId);
            urlBuffer.append("&recipientId="+userId);
            urlBuffer.append("&preview=true");
            urlBuffer.append("&emlMsgStoreId="+emlMsgStoreId);
            try {
                result = TagUtil.getContentsAt(urlBuffer.toString());
            }
            catch(Exception ex) {
                result = (String)emailActivityRB.get("jspTemplatePreviewError");
            }
        }
		else { // For "view", call composer to get the content
		    TypedProperty properties = new TypedProperty();
		    properties.putUrlParam("storeId", storeId);
		    properties.putUrlParam("recipientId", userId);
		    properties.putUrlParam("preview", "true");
		    properties.putUrlParam("emlMsgStoreId", emlMsgStoreId);
		    
		    result = TagUtil.getSpotContentFromView( jspPath, userId, storeId, properties );
        }        

	}
	else if(templateType != null && templateType.equals("0"))
	{
		String emailBody = null;
		String recordOpen = null;
		String contentFormat = null;
		if(messageId == null || messageId.equals("null")) {
			//preview button clicked in template creation dlg page..
			emailBody = (String)request.getParameter("emailBody");
			contentFormat = (String)request.getParameter("contentFormat");
		}
		else {
			//preview button clicked in template list page or in email activity creation page..
			EmailTemplateSummaryDatabean etsdb = new EmailTemplateSummaryDatabean(); 
			etsdb.setMessageId(messageId);
			DataBeanManager.activate(etsdb,request);
			emailBody = etsdb.getEmailBody();
			contentFormat = etsdb.getContentFormat();
		}

		TagEngine engine = new TagEngineImpl();
		engine.setCommandContext(commandContext);
		engine.setTagParameters("recipientId",userId);
		engine.setTagParameters("storeId",storeId);
		engine.setTagParameters("contentFormat",contentFormat);
		//since this is preview, no need to generate actions for optOut & unsubscribe & record open...
		engine.setTagParameters(TagConstants.PARAM_EMAIL_ACTION,"0");
		engine.setTagParameters("recordOpen","0");

		try{
			result = engine.renderEmailContent(emailBody);
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
	}
%>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}

//-->

</script>

</head>

<body class="content" onload="loadPanelData();">
<h1><%= emailActivityRB.get("emailActivityPreviewDialogTitle") %></h1>
<%= result %>
<p></p>
</body>
</html>