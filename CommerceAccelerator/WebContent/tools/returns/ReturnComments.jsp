<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">


<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.RMADataBean" %>
<%@include file="../common/common.jsp" %>
<%
try{
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);
%>

<HTML>
<HEAD>

<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>

<%
	String returnId = jspHelper.getParameter("returnId");
	RMADataBean rma = new RMADataBean();
	rma.setRmaId(returnId);
 	com.ibm.commerce.beans.DataBeanManager.activate(rma, request);
	String rmaComment = rma.getComments();
	if ( rmaComment == null)
			rmaComment = "";
%>

<%
request.setAttribute("returnId", returnId);
request.setAttribute("returnsNLS", returnsNLS);
%>
<jsp:include page="/tools/returns/ReturnFinishHandler.jsp" flush="true" />

<SCRIPT>
function init() 
{
   parent.put("prev",parent.getCurrentPanelAttribute("name"));
   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}
function savePanelData()
{
	parent.put("returnComment",document.commentsForm.commentsTextArea.value);
}
function validateNoteBookPanel()
{
	return validatePanelData();
}
function validatePanelData()
{
	return validateLength(document.commentsForm.commentsTextArea.value);
}
function loadPanelData()
{
	var data = parent.get("returnComment");
	if (data == null)
		data = "<%= UIUtil.toJavaScript(rmaComment) %>";
	document.commentsForm.commentsTextArea.value=data;
}
function validateLength(text)
{
	if (!isValidUTF8length(text, 254))
	{
		alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("TextExceedMaxLengthMsg")) %>");
		return false;
	}
	return true;
}

</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("returnCommentsTitle")) %></TITLE>

</HEAD>

<BODY onload="init();" class="content">

<H1><%= UIUtil.toHTML((String)returnsNLS.get("returnCommentsTitle")) %></H1>

<DIV><%= (String)returnsNLS.get("returnCommentsExplainInHTML") %></DIV><BR><BR>

<FORM NAME="callActionForm" ACTION="" method="post">
	<INPUT TYPE='hidden' NAME="URL" VALUE="">
	<INPUT TYPE='hidden' NAME="XML" VALUE="">
</FORM>

<FORM name="commentsForm">

<label for="commentsTextArea"><%= UIUtil.toHTML((String)returnsNLS.get("returnCommentsLabel")) %></label><BR>
<TEXTAREA  name="commentsTextArea" id="commentsTextArea" rows="6" cols="70"></TEXTAREA>

</FORM>

<SCRIPT>loadPanelData()</SCRIPT>
</BODY>
</HTML>


<%
}
catch (Exception e)
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
