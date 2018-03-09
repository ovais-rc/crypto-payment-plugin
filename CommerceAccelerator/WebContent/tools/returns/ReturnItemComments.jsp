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
<%@ page import="com.ibm.commerce.ordermanagement.beans.RMAItemDataBean" %>
<%@include file="../common/common.jsp" %>

<%
try{
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale = cmdContext.getLocale();
	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
	JSPHelper jspHelper = new JSPHelper(request);
%>

<%
	String returnItemId = jspHelper.getParameter("returnItemId");
	RMAItemDataBean rmaItem = new RMAItemDataBean();
	rmaItem.setRmaItemId(returnItemId);
 	com.ibm.commerce.beans.DataBeanManager.activate(rmaItem, request);
	String returnId = rmaItem.getRmaId();
	String rmaItemComment = rmaItem.getComments();
	if ( rmaItemComment == null)
		rmaItemComment = "";
	String customerId = rmaItem.getMemberId();
%>
<HTML>
<HEAD>

<LINK REL="stylesheet" HREF="<%= UIUtil.getCSSFile(jLocale) %>" TYPE="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>
<SCRIPT>
function init() 
{
   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}
function loadPanelData()
{
	document.commentsForm.commentsTextArea.value="<%= UIUtil.toJavaScript(rmaItemComment) %>"
}
function changeComments()
{
	var itemComments = document.commentsForm.commentsTextArea.value;
	
	if (!validateLength(itemComments))
		return;
	
	var CSRReturnItemUpdateParam = new Object();
	CSRReturnItemUpdateParam["returnId"] = "<%= returnId %>";
	CSRReturnItemUpdateParam["customerId"] = "<%= customerId %>";
	CSRReturnItemUpdateParam["returnItem"] = new Object();
	CSRReturnItemUpdateParam["returnItem"]["returnItemId"] = "<%= returnItemId %>";
	CSRReturnItemUpdateParam["returnItem"]["comment"] = itemComments;

	document.CSRReturnItemUpdateForm.XML.value = generateXML(CSRReturnItemUpdateParam,"XML",null);
	document.CSRReturnItemUpdateForm.URL.value = "ReturnItemCommentsRedirect";
	document.CSRReturnItemUpdateForm.submit();
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
function submitCancelHandler()
{
	top.goBack();
}
</SCRIPT>

<TITLE><%= UIUtil.toHTML((String)returnsNLS.get("reasonForReturnDialogTitle")) %></TITLE>

</HEAD>

<BODY style="background-repeat: no-repeat; background-image: url(/wcs/images/tools/toc/W_custome_orders.jpg)" onLoad="init();" class="content">

<FORM NAME="CSRReturnItemUpdateForm" METHOD="post" ACTION="CSRReturnItemUpdate">
	<INPUT TYPE='hidden' NAME="XML" VALUE=""> 
	<INPUT TYPE='hidden' NAME="URL" VALUE="">
</FORM>


<H1><%= UIUtil.toHTML((String)returnsNLS.get("reasonForReturnDialogTitle")) %></H1>

<DIV><%= (String)returnsNLS.get("reasonForReturnDialogExplainInHTML") %></DIV><BR><BR>

<FORM name="commentsForm">

<label for="commentsTextArea"><%= UIUtil.toHTML((String)returnsNLS.get("reasonForReturnDialogLabel")) %></label><BR>
<TEXTAREA  name="commentsTextArea" id="commentsTextArea" rows="6" cols="70"></TEXTAREA>

</FORM><SCRIPT>loadPanelData()</SCRIPT>

</BODY>
</HTML>


<%
}
catch (Exception e)
{
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
