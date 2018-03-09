<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable)ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strCatentryId = helper.getParameter("catentryId");
	String strIncludeMaster = helper.getParameter("includeMaster");
%>

<HTML>

<SCRIPT>

	var currentCatalogTreeId = 0;

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad()
	{
		setCatalogTree("-1", "0");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// replaceField(strInput, replaceString)
	//
	// @param strInput - the input strings whose ?s are to be replaced
	// @param replaceString - the string which is to replace a ?
	//
	// - this function is used to replace question marks within a property file string
	//////////////////////////////////////////////////////////////////////////////////////
	function replaceField(strInput, replaceString)
	{
		var strOutput = "";
		for (var i=0; i<strInput.length; i++)
		{
			if (strInput.charAt(i) == '?')
			{
				strOutput = strOutput + replaceString;
			} else {
				strOutput = strOutput + strInput.charAt(i);
			}
		}
		return strOutput;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setCatalogTree(catalogId, startCategory)
	//
	// @param catalogId - the catalogId of the tree to be drawn
	// @param startCategory - the categoryId of the category to hilite upon drawing
	//
	// - this function draws the tree in the right frame
	//////////////////////////////////////////////////////////////////////////////////////
	function setCatalogTree(catalogId, startCategory)
	{
		var urlPara = new Object();
		urlPara.catalogId = catalogId;
		urlPara.startCategory = startCategory;
		urlPara.includeMaster = "<%=strIncludeMaster%>";
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/ProductCatTree", urlPara, "categoryTree");
		currentCatalogTreeId = catalogId;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// hiliteCatalogTree(catalogId, startCategory)
	//
	// @param catalogId - the catalogId of the tree to be drawn
	// @param startCategory - the categoryId of the category to hilite upon drawing
	//
	// - this function hilites the selected category drawing the tree if necessary
	//////////////////////////////////////////////////////////////////////////////////////
	function hiliteCatalogTree(catalogId, startCategory)
	{
		if (currentCatalogTreeId == catalogId)
		{
			categoryTree.hiliteCategory(startCategory);
		} else {
			setCatalogTree(catalogId, startCategory);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addCategoryToList(catalogId, categoryId, catalogIdent, categoryIdent)
	//
	// @param catalogId - the catalogId of the new relationship
	// @param categoryId - the categoryId of the new relationship
	// @param catalogIdent - the catalog identifier of the new relationship
	// @param categoryIdent - the category identifier of the new relationship
	//
	// - this function adds a new relationship to the sales catalog list
	//////////////////////////////////////////////////////////////////////////////////////
	function addCategoryToList(catalogId, categoryId, catalogIdent, categoryIdent)
	{
		categoryList.addCategoryToList(catalogId, categoryId, catalogIdent, categoryIdent);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// closeProductCat()
	//
	// - this function closes (hides) the product/category tool
	//////////////////////////////////////////////////////////////////////////////////////
	function closeProductCat()
	{
		top.goBack();
	}

</SCRIPT>


	<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=frameset1 NAME=frameset1 ROWS="*,35 " STYLE="border-width:0px;" ONLOAD=onLoad()>
		<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=frameset2 NAME=frameset2 COLS="50%,*" ONLOAD=onLoad()>
			<FRAMESET FRAMEBORDER=NO FRAMESPACING=0 ID=categoryListFS NAME=categoryListFS STYLE="border-width:2px; border-style:inset;" COLS="*, 150">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="categoryList" NAME=categoryList        SRC="/webapp/wcs/tools/servlet/ProductCatCategoryList?includeMaster=<%=strIncludeMaster%>&catentryId=<%=strCatentryId%>">
				<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="categoryListButtons" NAME=categoryListButtons SRC="/webapp/wcs/tools/servlet/ProductCatCategoryListButtons">
			</FRAMESET>
			<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="categoryTree" NAME=categoryTree STYLE="border-width:2px; border-style:inset;" SRC="/wcs/tools/common/blank.html">
		</FRAMESET>
		<FRAME FRAMEBORDER=NO FRAMESPACING=0 TITLE="categoryBottom" NAME=categoryBottom  SRC="/webapp/wcs/tools/servlet/ProductCatBottom">
	</FRAMESET>


</HTML>

