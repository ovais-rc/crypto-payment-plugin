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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.context.globalization.GlobalizationContext" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbAttachment = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("attachment.AttachmentNLS", ((GlobalizationContext) cmdContext.getContext(GlobalizationContext.CONTEXT_NAME)).getLocale());

	// retrieve object Id
	JSPHelper jspHelper = new JSPHelper(request);
	String objectId = jspHelper.getParameter("objectId");
	String objectType = jspHelper.getParameter("objectType");
	String finishMessage = jspHelper.getParameter("SubmitFinishMessage");
	String readOnly = jspHelper.getParameter("readOnly");

	if (finishMessage == null) {
		finishMessage = "";
	} // if
	
	// TODO: this needs to change to use the access control helper when access control is ready
	if (readOnly == null) {
		readOnly = "false";
	} // if
%>

<html>

<head>
	<title><%=UIUtil.toHTML((String) rbAttachment.get("AttachmentList_Title_Dialog"))%></title>

	<script src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
	<script SRC="/wcs/javascript/tools/attachment/AttachmentCommonFunctions.js"></script>
	<script SRC="/wcs/javascript/tools/common/Util.js"></script>
	
	<script>

		var objectId = "<%=UIUtil.toJavaScript(objectId)%>";
		var objectType = "<%=UIUtil.toJavaScript(objectType)%>";
		var readOnly = <%=UIUtil.toJavaScript(readOnly)%>;
	
		/**
		*	startup function
		*/
		function onLoad() {
			top.showProgressIndicator(false);
	
	<%		if (finishMessage.equals("AttachmentUpdateSubmit_Success")) { %>
	
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentUpdateSubmit_Success"))%>');
	
	<%		} else if (finishMessage.equals("AttachmentUpdateSubmit_Failed")) { %>
	
			alertDialog('<%=UIUtil.toJavaScript((String) rbAttachment.get("AttachmentUpdateSubmit_Failed"))%>');
		
	<%		} %>
			AttachmentList.loadState();
		}

		//////////////////////////////////////////////////////////////////////////////////////
		// getHelp()
		//
		// - return  help key for the page
		//////////////////////////////////////////////////////////////////////////////////////
		function getHelp() {
			return "MC.attachment.AttachementListDialog.Help";
		}
	
		/**
		*	Assign a usage to a relation
		*
		*	@param atchObj - object to be submitted
		*/
		function assignUsage(atchObj) {
		
			top.showProgressIndicator(true);
			submitFunction("AttachmentXMLUpdate", atchObj, "form1");
		}
		
		/**
		*	Delete attachment relations
		*
		*	@param atchObj - object to be submitted
		*/
		function deleteRelations(atchObj) {
	
			top.showProgressIndicator(true);
			submitFunction("AttachmentXMLUpdate", atchObj, "form1");
		}
		
		/**
		*	Refresh the list page
		*/
		function refreshList() {
		
			urlPara = new Object();
			
			urlPara.objectType = "<%=UIUtil.toJavaScript(objectType)%>";
			urlPara.objectId = "<%=UIUtil.toJavaScript(objectId)%>";
			
			top.mccmain.submitForm("<%=UIUtil.getWebappPath(request)%>AttachmentListView", urlPara, "AttachmentList");
		}

	</script>
	
</head>
	
	<form name="form1" action="dummy" onsubmit="return false;" method="post">
		<input type=hidden name=XML value="a">
		<input type="hidden" name="authToken" value="${authToken}">
	</form>
	
	<frameset framespacing="0" border="0" frameborder="0" rows="50,*" onload=onLoad()>
		<frame noresize src="<%=UIUtil.getWebappPath(request)%>AttachmentListTitleView?objectId=<%=objectId%>&objectType=<%=objectType%>" title="<%=UIUtil.toHTML((String) rbAttachment.get("AttachmentList_Title"))%>" name="AttachmentListTitle">
		<frameset frameborder=no framespacing=0 ID=atchList name=atchList cols="*, 160" style="=border-width:0px;">
				<frame noresize frameborder=no framespacing=0 title="<%=UIUtil.toHTML((String) rbAttachment.get("AttachmentList_Title_List"))%>" name=AttachmentList src="<%=UIUtil.getWebappPath(request)%>AttachmentListView?objectId=<%=objectId%>&objectType=<%=objectType%>&readOnly=<%=readOnly%>">
				<frame noresize frameborder=no framespacing=0 title="<%=UIUtil.toHTML((String) rbAttachment.get("AttachmentList_Title_Button"))%>" name=AttachmentListButtons src="<%=UIUtil.getWebappPath(request)%>AttachmentListButtonsView">
		</frameset>
	</frameset>
	


</html>

