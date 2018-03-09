<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>


<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
%>

<HTML>
<HEAD>

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Title"))%></TITLE>
<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

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
	// setIcons(index)
	//
	// @param index the currently selected icon
	//
	// - this function sets the icon images
	//////////////////////////////////////////////////////////////////////////////////////
	function setIcons(index)
	{
		switch(index)
		{
			case 0:
				infoIMG.src="/wcs/images/tools/catalog/info_unselected.bmp";
				newIMG.src="/wcs/images/tools/catalog/new_unselected.bmp";
				editIMG.src="/wcs/images/tools/catalog/edit_unselected.bmp";
				treeIMG.src="/wcs/images/tools/catalog/tree_selected.bmp";
				searchIMG.src="/wcs/images/tools/catalog/search_unselected.bmp";
				break;
			case 1:
				break;
			case 2:
				infoIMG.src="/wcs/images/tools/catalog/info_unselected.bmp";
				newIMG.src="/wcs/images/tools/catalog/new_selected.bmp";
				editIMG.src="/wcs/images/tools/catalog/edit_unselected.bmp";
				treeIMG.src="/wcs/images/tools/catalog/tree_unselected.bmp";
				searchIMG.src="/wcs/images/tools/catalog/search_unselected.bmp";
				break;
			case 3:
				infoIMG.src="/wcs/images/tools/catalog/info_unselected.bmp";
				newIMG.src="/wcs/images/tools/catalog/new_unselected.bmp";
				editIMG.src="/wcs/images/tools/catalog/edit_unselected.bmp";
				treeIMG.src="/wcs/images/tools/catalog/tree_unselected.bmp";
				searchIMG.src="/wcs/images/tools/catalog/search_selected.bmp";
				break;
			case 4:
				infoIMG.src="/wcs/images/tools/catalog/info_unselected.bmp";
				newIMG.src="/wcs/images/tools/catalog/new_unselected.bmp";
				editIMG.src="/wcs/images/tools/catalog/edit_selected.bmp";
				treeIMG.src="/wcs/images/tools/catalog/tree_unselected.bmp";
				searchIMG.src="/wcs/images/tools/catalog/search_unselected.bmp";
				break;
			case 5:
				infoIMG.src="/wcs/images/tools/catalog/info_selected.bmp";
				newIMG.src="/wcs/images/tools/catalog/new_unselected.bmp";
				editIMG.src="/wcs/images/tools/catalog/edit_unselected.bmp";
				treeIMG.src="/wcs/images/tools/catalog/tree_unselected.bmp";
				searchIMG.src="/wcs/images/tools/catalog/search_unselected.bmp";
				break;
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setTitleValue(value)
	//
	// @param value the NLS enabled value of the title
	//
	// - this function set the title frame text
	//////////////////////////////////////////////////////////////////////////////////////
	function setTitleValue(value)
	{
		titleID.firstChild.firstChild.nodeValue = value;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// getTitleValue()
	//
	// - this function returns the text value of the title
	//////////////////////////////////////////////////////////////////////////////////////
	function getTitleValue()
	{
		return titleID.firstChild.firstChild.nodeValue;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// infoOnOff()
	//
	// - this function processes a click of the info icon
	//////////////////////////////////////////////////////////////////////////////////////
	function infoOnOff()
	{
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.setSourceFrame(5, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceInformation_Title"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// newOnOff()
	//
	// - this function processes a click of the new icon
	//////////////////////////////////////////////////////////////////////////////////////
	function newOnOff()
	{
		if (parent.getWorkframeReady() == false) return;
		
		if(parent.bStoreViewOnly)	return;
		
		top.showProgressIndicator(true);
		parent.setSourceFrame(2, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame1"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// editOnOff()
	//
	// - this function processes a click of the edit icon
	//////////////////////////////////////////////////////////////////////////////////////
	function editOnOff()
	{
		if (parent.getWorkframeReady() == false) return;
		
		if (parent.targetTreeFrame.showMenu_Edit()==false) return;
		
		top.showProgressIndicator(true);
		parent.showEditCategory();
		top.showProgressIndicator(false);
		//parent.setSourceFrame(4, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame4"))%>");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// treeOnOff()
	//
	// - this function processes a click of the tree icon
	//////////////////////////////////////////////////////////////////////////////////////
	function treeOnOff()
	{
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.setSourceFrame(0, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame0"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// searchOnOff()
	//
	// - this function processes a click of the search icon
	//////////////////////////////////////////////////////////////////////////////////////
	function searchOnOff()
	{
		if (parent.getWorkframeReady() == false) return;
		top.showProgressIndicator(true);
		parent.setSourceFrame(3, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame2"))%>");
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// help()
	//
	// - this function processes a click of the helpicon
	//////////////////////////////////////////////////////////////////////////////////////
	function help()
	{
		parent.openPanelHelp('SOURCE');
	}

</SCRIPT>

</HEAD>

<BODY CLASS=NavCatSourceTitle SCROLL=NO ONLOAD=onLoad() ONCONTEXTMENU="return false;">

	<TABLE WIDTH=100% HEIGHT=100% BORDER=0 CELLPADDING=0 CELLSPACING=0>   
		<TR>
			<TD ALIGN=LEFT VALIGN=MIDDLE ID=titleID><FONT COLOR=gray><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame0"))%></FONT></TD>
			<TD ALIGN=LEFT >&nbsp;</TD>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=30 ><IMG BORDER=0 ID=infoIMG   ONCLICK=infoOnOff()   ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceInformation_Title"))%>" SRC="/wcs/images/tools/catalog/info_selected.bmp"   HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=30 ><IMG BORDER=0 ID=newIMG    ONCLICK=newOnOff()    ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame1"))%>" SRC="/wcs/images/tools/catalog/new_unselected.bmp"    HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=30 ><IMG BORDER=0 ID=editIMG   ONCLICK=editOnOff()   ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame4"))%>" SRC="/wcs/images/tools/catalog/edit_unselected.bmp"   HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=30 ><IMG BORDER=0 ID=treeIMG   ONCLICK=treeOnOff()   ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame0"))%>" SRC="/wcs/images/tools/catalog/tree_unselected.bmp"     HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=30 ><IMG BORDER=0 ID=searchIMG ONCLICK=searchOnOff() ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Frame2"))%>" SRC="/wcs/images/tools/catalog/search_unselected.bmp" HEIGHT=22 WIDTH=22></TD>
			<TD ALIGN=RIGHT VALIGN=MIDDLE WIDTH=30 ><IMG BORDER=0 ID=helpIMG   ONCLICK=help() 		 ALT="<%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceTitle_Help"))%>" SRC="/wcs/images/tools/catalog/help.bmp" HEIGHT=22 WIDTH=22></TD>
			<TD WIDTH=10></TD>
		</TR>
	</TABLE>
</BODY>
</HTML>

