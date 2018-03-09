<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<HTML>
<HEAD>

<%@ page import = "java.util.*" %>
<%@ page import = "com.ibm.commerce.command.CommandContext" %>
<%@ page import = "com.ibm.commerce.tools.util.*" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strMessage = helper.getParameter("SubmitFinishMessage");
	String strCatgroupId   = helper.getParameter("catgroupId");
	String strCategoryCode = helper.getParameter("categoryCode");
%>
<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCreateCategoryButtons_Title"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/ConvertToXML.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// applyButton() 
	//
	// - this function is called to submit the category for creation
	//////////////////////////////////////////////////////////////////////////////////////
	function applyButton()
	{
		top.showProgressIndicator(true);
		parent.createCategory.createButton(false);
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// okButton() 
	//
	// - this function is called to submit the category for creation and close the page
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton()
	{
		top.showProgressIndicator(true);
		parent.createCategory.createButton(true);
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// closeButton() 
	//
	// - this function closes the screen and returns to the info page
	//////////////////////////////////////////////////////////////////////////////////////
	function closeButton()
	{
		top.showProgressIndicator(true);
		parent.createCategory.resetButton();
		parent.setSourceFrame(5, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceInformation_Title"))%>");
		top.showProgressIndicator(false);
	}


</SCRIPT>

</HEAD>

<BODY CLASS=button ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<TABLE WIDTH=100% HEIGHT=35 BORDER=0 CELLPADDING=0 CELLSPACING=2 >
		<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
		<TR VALIGN=MIDDLE WIDTH=100%>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=100%>
				<BUTTON NAME="applyButton" ID="dialog" onclick="applyButton()"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Apply"))%></BUTTON>
				&nbsp;
				<BUTTON NAME="okButton" ID="dialog" onclick="okButton()"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_OK"))%></BUTTON>
				&nbsp;
				<BUTTON NAME="closeButton" ID="dialog" onclick="closeButton()"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_Cancel"))%></BUTTON>
			</TD>
		</TR>
		<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
	</TABLE>
 
</BODY>
</HTML>
