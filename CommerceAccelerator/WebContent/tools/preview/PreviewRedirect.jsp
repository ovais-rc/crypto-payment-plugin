<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<%@include file="../common/common.jsp" %>  

<%@page import ="com.ibm.commerce.server.JSPHelper" %>
<%@page import ="com.ibm.commerce.content.preview.command.CMWSPreviewConstants" %>
<%@page import ="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@page import ="com.ibm.commerce.command.CommandContext" %>
<%@page import ="com.ibm.commerce.server.ECConstants" %>
<%@page import ="com.ibm.commerce.tools.util.*" %>

<%
	
	JSPHelper helper= new JSPHelper(request);
		
	String redirecturl = helper.getParameter(CMWSPreviewConstants.REDIRECT_STORE_URL);	
	
	String tempredirect = null;
	while (redirecturl.indexOf("~~amp~~") != -1) {
			int i=redirecturl.indexOf("~~amp~~");
			tempredirect = redirecturl.substring(0,i) + "&" +redirecturl.substring(i+7);
			redirecturl = tempredirect;	
	}
	
	String status = "status=" + helper.getParameter(CMWSPreviewConstants.PRVW_TIME_STATUS);
	String startTime = "&start=" + helper.getParameter(CMWSPreviewConstants.SCHED_START_TIME);
	String invstatus = "&invstatus=" + helper.getParameter(CMWSPreviewConstants.PRVW_INVCONST_TYPE);
	String header = "Header.jsp?" + status + startTime + invstatus;

	CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Hashtable previewNLS = (Hashtable)ResourceDirectory.lookup("preview.PreviewNLS", cmdContext.getLocale());      
%>

<HTML>
<HEAD> 
<TITLE><%= UIUtil.toHTML((String)previewNLS.get("previewTopFrameTitle")) %></TITLE>  
</HEAD> 
<FRAMESET rows ="15%,85%" >
	<FRAME SRC="<%= UIUtil.toHTML(header) %>" TITLE="<%= UIUtil.toHTML((String)previewNLS.get("previewHeaderFrameTitle")) %>" />
	<FRAME SRC="<%= UIUtil.toHTML(redirecturl) %>"  TITLE="<%= UIUtil.toHTML((String)previewNLS.get("previewBodyFrameTitle")) %>"/> 
</FRAMESET>	
</HTML>

