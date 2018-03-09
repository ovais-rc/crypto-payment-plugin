<!-- 
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2017
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

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
	String strCatentryId = helper.getParameter("catentryId");
	
	// Validate input parms
	try
	{
		Long.parseLong(strCatentryId);
		
	}
	catch(Exception e)
	{
		throw e;
	}
	
	String strIncludeMaster = helper.getParameter("includeMaster");
	Long lMasterCatalogId = cmdContext.getStore().getMasterCatalog().getCatalogReferenceNumberInEntityType();


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the product code
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CatalogEntryAccessBean abCatentry = new CatalogEntryAccessBean();
	abCatentry.setInitKey_catalogEntryReferenceNumber(strCatentryId);
	String strCode = UIUtil.toJavaScript(abCatentry.getPartNumber());


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Run the query to return the store path enabled products
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	Vector vResults = new Vector();

	try
	{
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT CATGPENREL.CATALOG_ID, CATGPENREL.CATGROUP_ID";
				 strSQL += " FROM CATENTRY, CATGPENREL, STORECGRP";
				 strSQL += " WHERE CATGPENREL.CATGROUP_ID=STORECGRP.CATGROUP_ID AND CATGPENREL.CATENTRY_ID=CATENTRY.CATENTRY_ID";
				 strSQL += " AND CATGPENREL.CATENTRY_ID=" +  strCatentryId;
				 strSQL += " AND STORECGRP.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());

		vResults = abHelper.executeQuery(strSQL);

		//
		// Do we exclude master catalog categories
		if (strIncludeMaster == null || strIncludeMaster.equals("yes") == false)
		{
			for (int i=vResults.size()-1; i>=0; i--)
			{
				Vector vResult = (Vector) vResults.elementAt(i);
				Long lCatalogId = new Long(vResult.elementAt(0).toString());
				if (lCatalogId.longValue() == lMasterCatalogId.longValue())
				{
					vResults.removeElementAt(i);
				}
			}
		}
	} 
	catch (Exception ex) 
	{
		vResults = new Vector();
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("ProductCatCategoryList_Title"))%></TITLE>

<SCRIPT>

	var objectArray = Array();


	//////////////////////////////////////////////////////////////////////////////////////
	// myObject(catalogId, categoryId, index)
	//
	// @param catalogId - the catalogId of the relationship
	// @param categoryId - the categoryId of the relationship
	// @param index - the index into the array for maintenance purposes
	//
	// - this creates an object to save the state of the relationships
	//////////////////////////////////////////////////////////////////////////////////////
	function myObject(catalogId, categoryId, index)
	{
		this.catalogId = catalogId;
		this.categoryId = categoryId;
		this.index = index;
		this.action = "NONE";
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the frame
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked()
	//
	// - this function is called when a row is selected
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(ProductCatCategorylist);
		var total = getTableSize(ProductCatCategorylist);
		if (total == 0) 
		{
			emptyList.style.display = "block";
		} else {
			emptyList.style.display = "none";
		}
		if (parent.categoryListButtons.setButtons) parent.categoryListButtons.setButtons(count);
		setCheckHeading(ProductCatCategorylist, (count == total && total != 0));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectDeselectAll()
	//
	// - this function selects or deselects all rows
	//////////////////////////////////////////////////////////////////////////////////////
	function selectDeselectAll()
	{
		setAllRowChecks(ProductCatCategorylist, event.srcElement.checked);
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// displayButtonClicked()
	//
	// - this function processes a display button click and hilites the selected category
	//////////////////////////////////////////////////////////////////////////////////////
	function displayButtonClicked()
	{
		var selectedObject = objectArray[getFirstCheckedId(ProductCatCategorylist)];
		parent.hiliteCatalogTree(selectedObject.catalogId, selectedObject.categoryId);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButtonClicked()
	//
	// - this function processes a delete button click and removes the hilited rows
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButtonClicked()
	{
		for (var i=ProductCatCategorylist.rows.length-1; i>0; i--)
		{
			if (ProductCatCategorylist.rows(i).cells(0).firstChild.checked)
			{
				var index = ProductCatCategorylist.rows(i).cells(0).firstChild.value;
				var selectedObject = objectArray[index];
				if (selectedObject.action == "NONE")
				{
					selectedObject.action = "DELETE";
				} else {
					selectedObject.action = "DISCARD";
				}
				delRow("ProductCatCategorylist", i);
			}
		}
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addCategoryToList(catalogId, categoryId, catalogIdent, categoryIdent)
	//
	// @param catalogId - the catalog which the category belongs to
	// @param categoryId - the category to which the product is being added
	// @param catalogIdent - the catalog identifier
	// @param categoryIdent - the category identifier
	//
	// - this function adds a product to the selected catalog/category
	//////////////////////////////////////////////////////////////////////////////////////
	function addCategoryToList(catalogId, categoryId, catalogIdent, categoryIdent)
	{
		var index = -1;
		var selectedObject = findInArray(catalogId, categoryId, catalogIdent, categoryIdent);
		if (selectedObject == null)
		{
			index = objectArray.length;
			selectedObject = new myObject(catalogId, categoryId, index);
			selectedObject.action = "ADD";
			objectArray[index] = selectedObject;
		} else {
			if (selectedObject.action == "NONE" || selectedObject.action == "ADD")
			{
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCatCategoryList_ExistsMsg"))%>");
			} else {
				selectedObject.action = "NONE";
				index = selectedObject.index;
			}
		}

		if (index > -1)
		{
			var rowId = ProductCatCategorylist.rows.length;
			insRow("ProductCatCategorylist",rowId);
			insCheckBox("ProductCatCategorylist",rowId,0,index,"setChecked()",index);
			var cell1 = getCell("ProductCatCategorylist",rowId,1);
			var cell2 = getCell("ProductCatCategorylist",rowId,2);
			cell1.style.wordBreak = "break-all";
			cell1.className = "list_info1";
			cell1.innerHTML = catalogIdent;
			cell2.style.wordBreak = "break-all";
			cell2.className = "list_info1";
			cell2.innerHTML = categoryIdent;

			setCheckHeading(ProductCatCategorylist, false);
			emptyList.style.display = "none";
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// findInArray(catalogId, categoryId)
	//
	// @param catalogId - the catalog being searched for
	// @param categoryId - the category being searched for
	//
	// - this function returns the object if found otherwise null
	//////////////////////////////////////////////////////////////////////////////////////
	function findInArray(catalogId, categoryId)
	{
		for (var i=0; i<objectArray.length; i++)
		{
			var selectedObject = objectArray[i];
			if (selectedObject.action == "DISCARD") continue;
			if (selectedObject.catalogId == catalogId && selectedObject.categoryId == categoryId) return selectedObject;
		}
		return null;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// saveButtonClick()
	//
	// - this function calls the server method to save the changes to the category
	//////////////////////////////////////////////////////////////////////////////////////
	function saveButtonClick()
	{
		var saveObject = new Object();
		saveObject.catentryId = "<%=strCatentryId%>";
		saveObject.changes = new Array();
		for (var i=0; i<objectArray.length; i++)
		{
			var selectedObject = objectArray[i];
			if (selectedObject.action == "DELETE" || selectedObject.action == "ADD")
			{
				saveObject.changes[saveObject.changes.length] = selectedObject;
			}
		}

		if (saveObject.changes.length == 0)
		{
			alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCatCategoryList_NothingToSave"))%>");
			parent.closeProductCat();
		} else {
			parent.categoryBottom.submitChanges(saveObject);
		}
	}


</SCRIPT>
</HEAD>

<BODY ONLOAD=onLoad() CLASS=content>

<SCRIPT>
	document.writeln("<H1>");
	document.writeln(parent.replaceField("<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCatCategoryList_H1"))%>", "<%=strCode%>"));
	document.writeln("</H1>");

	startDlistTable("ProductCatCategorylist", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCatCategoryList_Catalog"))%>",  true,  "null");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("ProductCatCategoryList_Category"))%>", true,  "null");
	endDlistRow();
<%
	int rowselect = 1;
	for (int i=0; i<vResults.size(); i++)
	{
		String strCatalogIdentifier = "";
		String strCatgroupIdentifier = "";
		Long lCatalogId  = null;
		Long lCatgroupId = null;

		try 
		{
			Vector vResult = (Vector) vResults.elementAt(i);
			lCatalogId  = new Long(vResult.elementAt(0).toString());
			lCatgroupId = new Long(vResult.elementAt(1).toString());

			CatalogAccessBean abCatalog = new CatalogAccessBean();
			abCatalog.setInitKey_catalogReferenceNumber(lCatalogId.toString());
			strCatalogIdentifier = abCatalog.getIdentifier();

			CatalogGroupAccessBean abCatgroup = new CatalogGroupAccessBean();
			abCatgroup.setInitKey_catalogGroupReferenceNumber(lCatgroupId.toString());
			strCatgroupIdentifier = abCatgroup.getIdentifier();
		} 
		catch (Exception e)
		{
			lCatalogId  = new Long(-1);
			lCatgroupId  = new Long(-1);
			strCatalogIdentifier = (String)rbCategory.get("ProductCatTree_NoneSelected");
			strCatgroupIdentifier = (String)rbCategory.get("ProductCatTree_NoneSelected");
		}
%>
		objectArray[<%=i%>] = new myObject(<%=lCatalogId%>,<%=lCatgroupId%>,<%=i%>);
		startDlistRow(<%=rowselect+1%>);
		addDlistCheck( "<%=i%>", "setChecked()", "<%=i%>" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strCatalogIdentifier)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strCatgroupIdentifier)%>", "none", "word-break:break-all;" );
		endDlistRow();
<%
		rowselect = 1 - rowselect;
	}
%>
	endDlistTable();

</SCRIPT>

<DIV ID="emptyList" STYLE="padding-top:10px;display:none;">
	<%=(String)rbCategory.get("ProductCatCategoryList_NoCategories")%>
</DIV>

</BODY>
</HTML>
