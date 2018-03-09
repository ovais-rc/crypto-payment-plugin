<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

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


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Run the query to return the store path enabled products
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	int rowselect  = 0;
	Vector vResult = new Vector();
	try
	{
		// SELECT LIST OF CATALOG ENTRIES WITHIN THE SELECTED CATEGORY
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT CATALOG.CATALOG_ID, CATALOG.IDENTIFIER";
				 strSQL += " FROM CATALOG, STORECAT";
				 strSQL += " WHERE CATALOG.CATALOG_ID=STORECAT.CATALOG_ID";
				 strSQL += " AND STORECAT.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());

		vResult = abHelper.executeQuery(strSQL);
	} catch (Exception ex) { vResult = new Vector(); }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatSourceCatalogList_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>
	
	var globalSelectedCatalogId = null;

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the page
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// displayButton()
	//
	// - this function processes a displayButton click and draws the selected catalog
	//////////////////////////////////////////////////////////////////////////////////////
	function displayButton()
	{
		if (globalSelectedCatalogId == null) return;
		parent.setNavCatSourceTree(globalSelectedCatalogId, 0);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// displayLink(catalogId)
	//
	// @param catalogId - the catalog identifier of the catalog to draw
	//
	// - this function processes a click of the catalog and draws its tree
	//////////////////////////////////////////////////////////////////////////////////////
	function displayLink(catalogId)
	{
		top.showProgressIndicator(true);		
		parent.setNavCatSourceTree(catalogId, 0);
		top.showProgressIndicator(false);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked()
	//
	// - this function updates the buttons based on a new checkbox click
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		if (event.srcElement.checked) globalSelectedCatalogId = event.srcElement.value;
		parent.sourceTreeFrameButtons.setButtons(getNumberOfChecks(NavCatSourceCatalogList));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// handleEnterPressed() 
	//
	// - perform a default action if the enter key is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function handleEnterPressed() 
	{
		if(event.keyCode != 13) return;

		if (parent.sourceTreeFrameButtons.displayButton)
		{
			parent.sourceTreeFrameButtons.displayButton();
		}
	}


</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONKEYPRESS=handleEnterPressed() ONCONTEXTMENU="return false;">

<%=(String)rbCategory.get("NavCatSourceCatalogList_Info")%>
<BR>
<BR>

<SCRIPT>

	startDlistTable("NavCatSourceCatalogList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(false);
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCat_Catalog"))%>", true,  "null");
	endDlistRow();
<%
	for (int i=0; i<vResult.size(); i++)
	{
		Vector vRow = (Vector) vResult.elementAt(i);
		Long lCatalogId = new Long(vRow.elementAt(0).toString());
%>
		startDlistRow(<%=rowselect+1%>);
		addDlistCheck( "<%=lCatalogId%>", "setChecked()", "<%=lCatalogId%>" );
		addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(((String)vRow.elementAt(1)).trim())%>"), "javascript:displayLink('<%=lCatalogId%>')", "word-break:break-all;" );
		endDlistRow();
<%
		rowselect = 1 - rowselect;
	}
%>
	endDlistTable();

</SCRIPT>

</BODY>
</HTML>
