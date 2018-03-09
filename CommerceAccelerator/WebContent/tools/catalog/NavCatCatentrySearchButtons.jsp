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
	Hashtable rbCatalog = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css"> 

<SCRIPT>

	function searchAgainButton()
	{
		if (parent.getWorkframeReady() == false) return;
		document.body.innerHTML=searrhBodyHTML;
		parent.catentrySearchFS.rows = "*,0,35";
		parent.catentrySearchFrame.searchForm.sku.focus();
		parent.catentrySearchResultFrame.location.href = "/wcs/tools/common/blank.html";
	}

	var searrhBodyHTML=null;

	function searchButton()
	{
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		if(	parent.catentrySearchFrame.searchButton() == true)
		{
			searrhBodyHTML=document.body.innerHTML;
			var strHTML ="<TABLE WIDTH=100% HEIGHT=35 BORDER=0 CELLPADDING=0 CELLSPACING=2 >";
				strHTML+="	<TR VALIGN=MIDDLE WIDTH=100%>";
				strHTML+="	<tr><td class=dottedLine height=\"1\" colspan=10 width=100%></td></tr>";
				strHTML+="	<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=100%>";
				strHTML+="		<BUTTON NAME=\"searchAgainButton\" ID=\"dialog\" onclick=\"searchAgainButton()\"><%=UIUtil.toJavaScript((String)rbCatalog.get("NavCat_FindCatentries"))%></BUTTON> ";
				strHTML+="		&nbsp;";
				strHTML+="		<BUTTON NAME=\"closeButton\" ID=\"dialog\" onclick=\"closeButton()\"><%=UIUtil.toJavaScript((String)rbCatalog.get("NavCat_Close"))%></BUTTON>";
				strHTML+="	</TD>";
				strHTML+="	<tr><td class=dottedLine height=\"1\" colspan=10 width=100%></td></tr>";
				strHTML+="	</TR>";
				strHTML+="	</TABLE>";
			
			document.body.innerHTML=strHTML;
			parent.catentrySearchFS.rows = "0,*,35";
		}	
		top.showProgressIndicator(false);
	}

	function resetButton()
	{
		top.showProgressIndicator(true);
		parent.catentrySearchFrame.resetButton();
		parent.catentrySearchFrame.searchForm.sku.focus();
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
		parent.setSourceFrame(5, "<%=UIUtil.toJavaScript((String)rbCatalog.get("NavCatSourceInformation_Title"))%>");
		top.showProgressIndicator(false);
	}

</SCRIPT>

</HEAD>

<BODY CLASS="button" ONCONTEXTMENU="return false;">

		<TABLE WIDTH=100% HEIGHT=35 BORDER=0 CELLPADDING=0 CELLSPACING=2 >
			<TR VALIGN=MIDDLE WIDTH=100%>
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
				<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=100%>
					<BUTTON NAME="searchButton" ID="dialog" onclick="searchButton()"><%=UIUtil.toHTML((String)rbCatalog.get("NavCat_Search"))%></BUTTON>
					&nbsp;
					<BUTTON NAME="resetButton" ID="dialog" onclick="resetButton()"><%=UIUtil.toHTML((String)rbCatalog.get("NavCat_Reset"))%></BUTTON>
					&nbsp;
					<BUTTON NAME="closeButton" ID="dialog" onclick="closeButton()"><%=UIUtil.toHTML((String)rbCatalog.get("NavCat_Close"))%></BUTTON>
				</TD>
				<tr><td class=dottedLine height="1" colspan=10 width=100%></td></tr>
			</TR>
		</TABLE>
 
</BODY>
</HTML>
