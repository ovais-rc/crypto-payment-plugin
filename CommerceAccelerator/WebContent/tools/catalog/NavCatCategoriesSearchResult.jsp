<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003, 2017
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.icu.text.UTF16" %>
<%@include file="../common/common.jsp" %>

<%!
	private String escapeSingleQuotes(String strInput)
	{
		String strResult = "";
		/*icu4j changes
		for (int i=0; i<strInput.length(); i++)
		{
			if (strInput.charAt(i) == '\'') { strResult += "'"; }
			strResult += strInput.charAt(i);
		}
		*/
		int ch=0;
		for (int i=0; i<strInput.length(); i+=UTF16.getCharCount(ch))
		{   ch=UTF16.charAt(strInput,i);
			if ((char) ch == '\'') { strResult += "'"; }
			strResult += (char) ch;
		}
		return strResult;
	}
%>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);

	String name         = helper.getParameter("name"); 
	String nameOp       = helper.getParameter("nameOp"); 
	String identifier   = helper.getParameter("identifier"); 
	String identifierOp = helper.getParameter("identifierOp"); 
	String catalogId    = helper.getParameter("catalogId"); 
	
	// Validate input parms
	try
	{
		Long.parseLong(catalogId);
	}
	catch(Exception e)
	{
		throw e;
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Run the query to return the store path enabled products
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	Vector vResults1 = new Vector();
	Vector vResults2 = new Vector();

	try
	{
		String strSQL = "";
		String strSQL2 = "";
		String strName = "";
		String strCatalog1 = "";
		String strCatalog2 = "";
		String strIdentifier = "";

		//
		// Determine the identifier where clause
		if (identifier != null && identifier.trim().equals("") == false)
		{
			if (identifierOp.trim().equals("="))
			{
				strIdentifier = " AND CATGROUP.IDENTIFIER='" + escapeSingleQuotes(identifier) + "'";
			} 
			else 
			{
				strIdentifier = " AND upper(CATGROUP.IDENTIFIER) LIKE '%" + escapeSingleQuotes(identifier.toUpperCase()) + "%'";
			}
		}

		//
		// Determine the name where clause
		if (name != null && name.trim().equals("") == false)
		{
			if (nameOp.trim().equals("="))
			{
				strName += " AND CATGRPDESC.NAME='" + escapeSingleQuotes(name) + "'";
				strName += " AND CATGRPDESC.LANGUAGE_ID=" + cmdContext.getLanguageId().toString();
			} 
			else 
			{
				strName += " AND upper(CATGRPDESC.NAME) LIKE '%" + escapeSingleQuotes(name.toUpperCase()) + "%'";
				strName += " AND CATGRPDESC.LANGUAGE_ID=" + cmdContext.getLanguageId().toString();
			}
		}

		//
		// Determine the catalog where clause
		if (catalogId != null && catalogId.trim().equals("-1") == false)
		{
			strCatalog1 = " AND CATTOGRP.CATALOG_ID=" + catalogId;
			strCatalog2 = " AND CATGRPREL.CATALOG_ID=" + catalogId;
		}

		//
		// Determine the SQL String
		if (name == null || name.trim().equals(""))
		{
			strSQL  = "SELECT DISTINCT CATGROUP.CATGROUP_ID, CATGROUP.IDENTIFIER, CATTOGRP.CATALOG_ID";
			strSQL += " FROM CATGROUP, STORECGRP, CATTOGRP";
			strSQL += " WHERE CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=CATTOGRP.CATGROUP_ID";
			strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
			strSQL += strCatalog1;
			strSQL += strIdentifier;

			strSQL2  = "SELECT DISTINCT CATGROUP.CATGROUP_ID, CATGROUP.IDENTIFIER, CATGRPREL.CATALOG_ID";
			strSQL2 += " FROM CATGROUP, STORECGRP, CATGRPREL";
			strSQL2 += " WHERE CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=CATGRPREL.CATGROUP_ID_CHILD";
			strSQL2 += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
			strSQL2 += strCatalog2;
			strSQL2 += strIdentifier;
		}
		else
		{
			strSQL  = "SELECT DISTINCT CATGROUP.CATGROUP_ID, CATGROUP.IDENTIFIER, CATTOGRP.CATALOG_ID";
			strSQL += " FROM CATGROUP, STORECGRP, CATTOGRP, CATGRPDESC";
			strSQL += " WHERE CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=CATTOGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID";
			strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
			strSQL += strCatalog1;
			strSQL += strIdentifier;
			strSQL += strName;

			strSQL2  = "SELECT DISTINCT CATGROUP.CATGROUP_ID, CATGROUP.IDENTIFIER, CATGRPREL.CATALOG_ID";
			strSQL2 += " FROM CATGROUP, STORECGRP, CATGRPREL, CATGRPDESC";
			strSQL2 += " WHERE CATGROUP.CATGROUP_ID = STORECGRP.CATGROUP_ID AND CATGROUP.CATGROUP_ID=CATGRPREL.CATGROUP_ID_CHILD AND CATGROUP.CATGROUP_ID = CATGRPDESC.CATGROUP_ID";
			strSQL2 += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
			strSQL2 += strCatalog2;
			strSQL2 += strIdentifier;
			strSQL2 += strName;
		}

		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		vResults1 = abHelper.executeQuery(strSQL);

		if (strSQL2.equals("") == false)
		{
			abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
			vResults2 = abHelper.executeQuery(strSQL2);

			for (int i=0; i<vResults2.size(); i++)
			{
				vResults1.addElement((Vector)vResults2.elementAt(i));
			}
		}
	}
	catch (Exception e) {}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearchResult_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>

	var currentElementIndex = null;
	var categoryArray = new Array();

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad () 
	{
		if (getTableSize(NavCatCategoriesList) == 0) 
		{
			divEmpty.innerHTML = "<BR><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoriesSearchResult_Empty"))%>";
			divEmpty.style.display = "block";
		}
		resetButtons();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// categoryObject(catgroupId, catalogId, identifier)
	//
	// - Creates an instance of a category object
	//////////////////////////////////////////////////////////////////////////////////////
	function categoryObject(catgroupId, catalogId, identifier)
	{
		this.targetCatalogId   = null;
		this.parentCategoryId  = null;
		this.sourceCatalogId   = catalogId;
		this.sourceCategoryId  = catgroupId;
		this.includeCatentries = false;
		this.identifier        = identifier;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// treeButton()
	//
	// - this function processes a click of the list tree button
	//////////////////////////////////////////////////////////////////////////////////////
	function treeButton()
	{
		var index = getFirstChecked(NavCatCategoriesList);
		if (index == -1) return;

		var currentElement = categoryArray[index];
		parent.setNavCatSourceTree(currentElement.sourceCatalogId, currentElement.sourceCategoryId);
		parent.setSourceFrame(0, "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSourceTitle_Frame0"))%>");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// productsButton()
	//
	// - this function processes a click of the list products button
	//////////////////////////////////////////////////////////////////////////////////////
	function productsButton()
	{
		var index = getFirstChecked(NavCatCategoriesList);
		if (index == -1) return;

		var categoryString = "";
		var identifierString = "";
		for (var i=1; i<NavCatCategoriesList.rows.length; i++)
		{
			if (NavCatCategoriesList.rows(i).cells(0).firstChild.checked)
			{
				var currentElement = categoryArray[i];
				if (categoryString.length > 1) 
				{
					categoryString += ",";
				}
				categoryString += currentElement.sourceCategoryId;
			}
		}

		parent.showSourceProducts(identifierString, currentElement.sourceCatalogId, categoryString);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked()
	//
	// - this function processes a click of a checkbox on the list
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(NavCatCategoriesList);
		parent.categoriesResultButtons.setButtons(count);
		setCheckHeading(NavCatCategoriesList, (count == getTableSize(NavCatCategoriesList)));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// resetButtons()
	//
	// - this function will reset the buttons in the button frame
	//////////////////////////////////////////////////////////////////////////////////////
	function resetButtons()
	{
		if (parent.categoriesResultButtons.setButtons) parent.categoriesResultButtons.setButtons(getNumberOfChecks(NavCatCategoriesList));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectDeselectAll()
	//
	// - this function processes a click of a select all checkbox
	//////////////////////////////////////////////////////////////////////////////////////
	function selectDeselectAll()
	{
		setAllRowChecks(NavCatCategoriesList, event.srcElement.checked);
		parent.categoriesResultButtons.setButtons(getNumberOfChecks(NavCatCategoriesList));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// copyButton(includeCatentries)
	//
	// @param includeCatentries - if true will copy all children catentries of the category
	//
	// - this function copies the categories to the target tree
	//////////////////////////////////////////////////////////////////////////////////////
	function copyButton(includeCatentries)
	{
		var j=0;
		var objObject = new Object();
		objObject.object = new Array();

		for (var i=1; i<NavCatCategoriesList.rows.length; i++)
		{
			if (NavCatCategoriesList.rows(i).cells(0).firstChild.checked)
			{
				var currentElement = categoryArray[i];
				var obj = new Object();
				obj.targetCatalogId   = parent.currentTargetDetailCatalog;
				obj.parentCategoryId  = parent.currentTargetTreeElement.id;
				obj.sourceCatalogId   = currentElement.sourceCatalogId;
				obj.sourceCategoryId  = currentElement.sourceCategoryId;
				obj.includeCatentries = includeCatentries;
				objObject.object[j] = obj;
				j++;
			}
		}

		parent.workingFrame.submitFunction("NavCatCopyCategoryControllerCmd", objObject);
	}

</SCRIPT>

<STYLE TYPE='text/css'>
TR.list_row_lock { background-color: ButtonFace; height: 20px; word-wrap: break-word; }
</STYLE>

</HEAD>

<BODY CLASS="content" ONLOAD=onLoad() ONCONTEXTMENU="return false;">


<SCRIPT>

<%
		CatalogAccessBean abCatalog = new CatalogAccessBean();
		abCatalog.setInitKey_catalogReferenceNumber(catalogId);
		String strCatalogIdent = abCatalog.getIdentifier();
%>
	document.writeln("<b>" + parent.replaceField("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoriesSearchResult_WhichCatalog"))%>", changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strCatalogIdent)%>")) + "</b><BR><BR>");

	startDlistTable("NavCatCategoriesList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoriesSearchResult_Identifier"))%>", true, "null", "", true );
	endDlistRow();
<%
	int nStoreId=cmdContext.getStoreId().intValue();
	int rowselect = 0;
	for (int i=0; i<vResults1.size(); i++)
	{
		Vector vRow = (Vector) vResults1.elementAt(i);

		int nCategoryStoreId=-1;
		StoreCatalogGroupAccessBean abStoreCategory = new StoreCatalogGroupAccessBean();
		Enumeration enStoreCategory = abStoreCategory.findByCatalogGroupId(new Long(vRow.elementAt(0).toString()));
		if(enStoreCategory.hasMoreElements())
		{
			abStoreCategory = (StoreCatalogGroupAccessBean)enStoreCategory.nextElement();
			nCategoryStoreId = abStoreCategory.getStoreEntryIDInEntityType().intValue();
		}
		
%>
		categoryArray[<%=i+1%>] = new categoryObject("<%=vRow.elementAt(0).toString()%>", "<%=vRow.elementAt(2).toString()%>", "<%=UIUtil.toJavaScript(vRow.elementAt(1).toString())%>");
		<%if(nStoreId==nCategoryStoreId) {%>
			startDlistRow(<%=rowselect+1%>);
		<%}else{%>	
			startDlistRow("_lock"); 
		<%}%>
		addDlistCheck( "<%=new Long(vRow.elementAt(0).toString())%>", "setChecked()", "<%=new Long(vRow.elementAt(0).toString())%>" );
		addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(vRow.elementAt(1).toString().trim())%>"), "none", "word-break:break-all;" );
		endDlistRow();
<%
		rowselect = 1 - rowselect;
	}
%>
	endDlistTable();

</SCRIPT>

<DIV ID=divEmpty STYLE="display: none;">
</DIV>

</BODY>
</HTML>
