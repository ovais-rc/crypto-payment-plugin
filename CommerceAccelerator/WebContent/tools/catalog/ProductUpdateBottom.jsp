<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper jspHelper	= new com.ibm.commerce.server.JSPHelper(request);	
	String finishMessage = jspHelper.getParameter("SubmitFinishMessage");
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>

function okButton()
{
	if (!parent.contentFrame.okButton) return;
	form1.CatalogXML.value = parent.contentFrame.okButton();
	if (form1.CatalogXML.value == "FAILED") return;
	document.form1.submit();
	top.showProgressIndicator(true);
}

function cancelButton()
{
	if (parent.contentFrame.leavingPageFunction && parent.contentFrame.leavingPageFunction() == false) return;
	top.goBack();
}

function onLoad()
{

	if (parent.readonlyAccess == true)
	{
		dialog[0].disabled = true;
	}

<%
	if (finishMessage != null && finishMessage.equals("ProductUpdateSubmit_Success")) 
	{ 
%>
		parent.contentFrame.successfullySaved();
		top.showProgressIndicator(false);
<% 
	} 

	if (finishMessage != null) 
	{ 
%>
		alertDialog('<%= UIUtil.toJavaScript((String)rbProduct.get(finishMessage)) %>');
		top.showProgressIndicator(false);
<%
	}
%>
}

</SCRIPT>

</HEAD>
<BODY SCROLL=NO MARGIN=0 ONLOAD=onLoad()>
<FORM NAME="form1" action="CatalogEntryXMLControllerCmd" ONSUBMIT="return false;" method="POST">
  <INPUT TYPE="hidden" NAME="CatalogXML" VALUE="">
</FORM>
<TABLE WIDTH=100% HEIGHT=100% CELLPADDING=0 CELLSPACING=0>
	<TR HEIGHT=36>
		<TD class="button">
			<TABLE WIDTH=100% BORDER=0 CELLPADDING=0 CELLSPACING=2 >
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
				<TR VALIGN=MIDDLE>
					<TD ALIGN=RIGHT VALIGN=MIDDLE>
						<BUTTON NAME="okButton"     ID=dialog onclick="okButton()" style="height:20px; cursor: default;"><%=UIUtil.toHTML((String)rbProduct.get("productUpdateBottom_OK"))%></BUTTON>
						&nbsp;
						<BUTTON NAME="cancelButton" ID=dialog onclick="cancelButton()" style="height:20px; cursor: default;"><%=UIUtil.toHTML((String)rbProduct.get("productUpdateBottom_Cancel"))%></BUTTON>
					</TD>
				</TR>
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			</TABLE>
		</TD>
	</TR>
</TABLE>
</BODY>
</HTML>

