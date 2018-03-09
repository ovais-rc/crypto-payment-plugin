<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005, 2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<% 
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
	String atchRelId		= jspHelper.getParameter("atchRelId");
	String atchTargetId		= jspHelper.getParameter("atchTargetId");	
	String objectType		= jspHelper.getParameter("objectType");
	String objectId			= jspHelper.getParameter("objectId");
	String usageId			= jspHelper.getParameter("usageId");
	String sentBack			= jspHelper.getParameter("sentBack");
	String strTool      	= jspHelper.getParameter("tool");   // Valid values are: usage, description, asset or all
	String saveChanges		= jspHelper.getParameter("saveChanges");
	String returnPage       = jspHelper.getParameter("returnPage");

	if (sentBack == null) { sentBack = "false"; }
	if (strTool == null) { strTool = "all"; }
	if (saveChanges == null) { saveChanges = "true"; }
	if (returnPage == null) { returnPage = "0"; }

%>

<html>
<head>

<script>

	var strTool = "<%=strTool%>";
	var saveChanges = <%=saveChanges%>;
	var returnPage = <%=returnPage%>;

	/////////////////////////////////////////////////////////////////////////////////////
	// fcnOnLoad()
	//
	// - this function is called upon load of the page
	/////////////////////////////////////////////////////////////////////////////////////
	function fcnOnLoad()
	{
			top.showProgressIndicator(false);
	}

	/////////////////////////////////////////////////////////////////////////////////////
	// warningOnClose()
	//
	// - this function shows warning if there are changes that are not saved
	/////////////////////////////////////////////////////////////////////////////////////
	function warningOnClose() 
	{
		return atchUpdate.pageUpdated;
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// getHelp()
	//
	// - return help key for the page
	//////////////////////////////////////////////////////////////////////////////////////
	function getHelp() {
		switch(strTool)
		{
			case "description":	return "MC.attachment.AttachmentDescription.Help";
			case "asset" : return "MC.attachment.SpecifyLanguages.Help";
			default: return "MC.attachment.ChangeAttachment.Help";
		}
	}	
	
</script>


</head>

	<frameset frameborder=no framespacing=0 onload="fcnOnLoad()" ID=atchUpdateDialogFS name=atchUpdateDialogFS rows="*, 30" style="border-width:0px;">
		<frame noresize frameborder=no framespacing=0 title="<%=UIUtil.toHTML((String) rbAttachment.get("AttachmentChange_Title_Detail"))%>" name="atchUpdate" src="<%=UIUtil.getWebappPath(request)%>AttachmentUpdateView?usageId=<%=usageId%>&objectId=<%=objectId%>&objectType=<%=objectType%>&atchRelId=<%=atchRelId%>&atchTargetId=<%=atchTargetId%>&sentBack=<%=sentBack%>&tool=<%=strTool%>">
		<frame noresize frameborder=no framespacing=0 scrolling=no title="<%=UIUtil.toHTML((String) rbAttachment.get("AttachmentChange_Title_Bottom"))%>" name="atchUpdateBottom" src="<%=UIUtil.getWebappPath(request)%>AttachmentUpdateBottomView">
	</frameset>

</html>