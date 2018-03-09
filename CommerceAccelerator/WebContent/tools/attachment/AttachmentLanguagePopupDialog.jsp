<% 
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
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
// 040515           BLI       Creation Date
////////////////////////////////////////////////////////////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment  = (Hashtable) ResourceDirectory.lookup("attachment.AttachmentNLS",((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());	
	
	JSPHelper jspHelper		= new JSPHelper(request);
	String atchTargetId		= jspHelper.getParameter("atchTargetId");
	String atchAssetId		= jspHelper.getParameter("atchAssetId");
	String atchAssetLang	= jspHelper.getParameter("atchAssetLang");
	String saveChanges		= jspHelper.getParameter("saveChanges");
%>

<html>

<head>
	<script>
		var saveChanges = <%=saveChanges%>;


		function fcnOnLoad()
		{
			parent.resizePopup();
		}

	</script>
</head>

	<frameset onload="fcnOnLoad()" frameborder=no framespacing=0 ID=atchLangPopupDialogFS name=atchLangPopupDialogFS  rows="*, 35" style="border-width:0px;">
		<frame noresize frameborder=no framespacing=0 title="<%=UIUtil.toHTML((String) rbAttachment.get("AttachmentPopup_Title"))%> " name=atchLangPopupFS  src="<%=UIUtil.getWebappPath(request)%>AttachmentLanguagePopupView?saveChanges=<%=saveChanges%>&atchTargetId=<%=atchTargetId%>&atchAssetId=<%=atchAssetId%>&atchAssetLang=<%=atchAssetLang%>">
		<frame noresize frameborder=no framespacing=0 scrolling=no title="<%=UIUtil.toHTML((String) rbAttachment.get("AttachmentPopup_Title_Bottom"))%> " name=atchLangPopupBottomFS  src="<%=UIUtil.getWebappPath(request)%>AttachmentLanguagePopupBottomView">
	</frameset>
	
</html>

