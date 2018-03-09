<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003-2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.icu.text.UTF16" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper jspHelper = new com.ibm.commerce.server.JSPHelper(request);
	String strExtendedFunction = jspHelper.getParameter("extendedFunction");

	boolean bExtFunctionCategoryTemplate=false;
	boolean bExtFunctionMasterCatalog=false;
	boolean bExtFunctionSKU=false;

	if((strExtendedFunction!=null)&&(strExtendedFunction.trim().length()>0)&&(strExtendedFunction.trim().equalsIgnoreCase("false")==false))
	{		
		StringBuffer sbTemp= new StringBuffer();
		
		for(int i=0; i<strExtendedFunction.length(); i++)
		{
			char c=strExtendedFunction.charAt(i);
			if(c >' ')  sbTemp.append(c);
		}
		
		strExtendedFunction=sbTemp.toString().toLowerCase();
		
		//CategoryTemplate flag needs to backward compatible
		bExtFunctionCategoryTemplate=((strExtendedFunction.equals("true")) || strExtendedFunction.indexOf("categorytemplate=true")>=0) ;
		bExtFunctionMasterCatalog=(strExtendedFunction.indexOf("mastercatalog=true")>=0);
		bExtFunctionSKU=(strExtendedFunction.indexOf("sku=true")>=0);
	}		

	//the displayNumberOfProducts parameter passed through url decides if the numbers on the trees need to display or not
	String strDisplayNumberOfProducts = jspHelper.getParameter("displayNumberOfProducts");
	if (strDisplayNumberOfProducts == null || strDisplayNumberOfProducts.equals("false") == false)
	{
		strDisplayNumberOfProducts = "true";	//enabled by default
	}
	else
		strDisplayNumberOfProducts="false";
%>

<HTML>

<SCRIPT>

	top.put("ExtFunctionCategoryTemplate",<%=bExtFunctionCategoryTemplate%>);
	top.put("ExtFunctionMasterCatalog", <%=bExtFunctionMasterCatalog%>);
	top.put("ExtFunctionSKU",<%=bExtFunctionSKU%>);

	
	var bDisplayNumberOfProducts=<%=strDisplayNumberOfProducts%>;

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// getHelp()
	//
	// - return F1 help key for the page
	//////////////////////////////////////////////////////////////////////////////////////
	function getHelp()
	{
		return "MC.catalogTool.salesCatalogList.Help";
	}

</SCRIPT>


	<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=catalogListFS NAME=catalogListFS ROWS="60, *" ONLOAD=onLoad()>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=catalogListTitle TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogListTitle_Title"))%>" SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCatalogListTitle">
		<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=catalogListContentsFS NAME=catalogListContentsFS COLS="*, 160">
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=catalogListContents        TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogListContent_Title"))%>"              SRC="/webapp/wcs/tools/servlet/NavCatCatalogListContent?ExtFunctionMasterCatalog=<%=bExtFunctionMasterCatalog%>">
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 NAME=catalogListContentsButtons TITLE="<%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogListButtons_Title"))%>" SCROLLING=NO SRC="/webapp/wcs/tools/servlet/NavCatCatalogListButtons">
		</FRAMESET>
	</FRAMESET>


</HTML>

