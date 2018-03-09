<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2003, 2017 All Rights Reserved.

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
<%@ page import="com.ibm.commerce.attachment.common.ECAttachmentConstants" %>

<%@include file="../common/common.jsp" %>

<%
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Get the command context
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);

	String orderByParm     = helper.getParameter("orderby");
	
	// Validate input parms
	try
	{
		if(orderByParm != null && orderByParm.trim().length()!=0)
		{
			//Allowed values
			HashSet allowedTokens = new HashSet();
			allowedTokens.add("CATALOG");
			allowedTokens.add("CATALOG_ID");
			allowedTokens.add("IDENTIFIER");
			allowedTokens.add("DESCRIPTION");
			allowedTokens.add("STORECAT");
			allowedTokens.add("STOREENT_ID");
			allowedTokens.add("ASC");
			allowedTokens.add("DESC");
			
			StringTokenizer parms = new StringTokenizer(orderByParm, ",. ");
			while( parms.hasMoreTokens() )
			{
				if( !allowedTokens.contains(parms.nextToken().trim().toUpperCase()) )
				{
					throw new Exception();
				}
			}
		}
	}
	catch(Exception e)
	{
		throw e;
	}
	
	if (orderByParm == null) orderByParm = "CATALOG.IDENTIFIER";

	String strExtFunctionMasterCatalog = helper.getParameter("ExtFunctionMasterCatalog");
	Long lMasterCatalogId = new Long(cmdContext.getStore().getMasterCatalog().getCatalogReferenceNumber());


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Run the query to return the store path enabled products
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	Vector vResults = new Vector();
	try
	{
		// SELECT LIST OF CATALOG ENTRIES WITHIN THE SELECTED CATEGORY
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT CATALOG.CATALOG_ID, CATALOG.IDENTIFIER, CATALOG.DESCRIPTION, STORECAT.STOREENT_ID";
				 strSQL += " FROM CATALOG, STORECAT";
				 strSQL += " WHERE CATALOG.CATALOG_ID=STORECAT.CATALOG_ID";
				 strSQL += " AND STORECAT.STOREENT_ID " + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
				 strSQL += " ORDER BY " + orderByParm;
		vResults = abHelper.executeQuery(strSQL);

	} 
	catch (Exception ex) 
	{
		vResults = new Vector();
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatalogListContent_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
	<script src="/wcs/javascript/tools/attachment/Constants.js"></script>

<SCRIPT>

	var sequenceArray = new Array();
	var masterCatalogId = '<%=lMasterCatalogId %>';


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad () 
	{
		if (getTableSize(NavCatCatalogList) == 0) 
		{
			divEmpty.innerHTML = "<BR><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListContent_NoCatalogs"))%>";
			divEmpty.style.display = "block";
		}
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// mySort(value)
	//
	// @param value - the order by value to sort against
	//
	// - this function reloads the page to sort by the requested sort feature
	//////////////////////////////////////////////////////////////////////////////////////
	function mySort(value)
	{
		var urlPara = new Object();
		urlPara.orderby                   = value;
		urlPara.ExtFunctionMasterCatalog  = <%= strExtFunctionMasterCatalog %>;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatCatalogListContent", urlPara, "catalogListContents");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked() 
	//
	// - this function is called whenever a checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(NavCatCatalogList);
		var doIOwn = getDoIOwnFromChecked(NavCatCatalogList);
		var isMasterCatalogSelected = getIsMasterCatalogSelected(NavCatCatalogList,masterCatalogId);
		if (parent.catalogListContentsButtons.setButtons) parent.catalogListContentsButtons.setButtons(count, doIOwn, isMasterCatalogSelected);
		setCheckHeading(NavCatCatalogList, (count == getTableSize(NavCatCatalogList)));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectDeselectAll() 
	//
	// - this function is called when the select/deselect all checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function selectDeselectAll()
	{
		setAllRowChecks(NavCatCatalogList, event.srcElement.checked);
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// changeButton() 
	//
	// - this function processes a click of the change button
	//////////////////////////////////////////////////////////////////////////////////////
	function changeButton()
	{
		var url = "/webapp/wcs/tools/servlet/NavCatCatalogCreateDialog";
		var urlPara = new Object();
		urlPara.actionCmd = "update";
		urlPara.catalogId = getFirstCheckedId(NavCatCatalogList);
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_UpdateBCT"))%>", url, true, urlPara);     
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// modelButton() 
	//
	// - this function processes a click of the model button
	//////////////////////////////////////////////////////////////////////////////////////
	function modelButton()
	{
		var url = "/webapp/wcs/tools/servlet/NavCatDialog";
		var urlPara = new Object();
		urlPara.rfnbr      = getFirstCheckedId(NavCatCatalogList);
		urlPara.displayNumberOfProducts=parent.bDisplayNumberOfProducts;
		urlPara.ExtFunctionSKU=top.get("ExtFunctionSKU",false);
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_ModelBCT"))%>", url, true, urlPara);     
	} 


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - this function is called when the delete button is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		var obj = new Object();
		obj.catalogIds = new Array();
		for (var i=1; i<NavCatCatalogList.rows.length; i++)
		{
			if (getChecked(NavCatCatalogList, i))
			{
				obj.catalogIds[obj.catalogIds.length] = getCheckBoxId(NavCatCatalogList, i);
			}
		}
		parent.catalogListTitle.submitFunction("NavCatCatalogDeleteControllerCmd", obj);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// modelCatalog(catalogId)
	//
	// @param catalogId - the catalog id of the catalog to model
	//
	// - this function is called when the hyperlink is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function modelCatalog(catalogId)
	{
		var url = "/webapp/wcs/tools/servlet/NavCatDialog";
		var urlPara = new Object();
		urlPara.rfnbr = catalogId;
		urlPara.displayNumberOfProducts=parent.bDisplayNumberOfProducts;
		urlPara.ExtFunctionSKU=top.get("ExtFunctionSKU",false);
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListButtons_ModelBCT"))%>", url, true, urlPara);     
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarListAttachment(attachmentAccessGained)
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function showAttachmentsAction(attachmentAccessGained) {

		var url = top.getWebPath() + "AttachmentListDialogView";
		var urlPara = new Object();

		urlPara.objectId    = getFirstCheckedId(NavCatCatalogList);
		urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG%>";
		urlPara.readOnly = !attachmentAccessGained;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbProduct.get("ProductUpdateMenuTitle_ShowAttachment"))%>", url, true, urlPara);   
	}
	
	//////////////////////////////////////////////////////////////////////////////////////
	// toolbarAddAttachment()
	//
	// - check if it is a valid integer
	//////////////////////////////////////////////////////////////////////////////////////
	function addAttachmentAction() {

		var url 			= top.getWebPath() + "PickAttachmentAssetsTool";
		var urlPara  		= new Object();

		urlPara.objectId    = getFirstCheckedId(NavCatCatalogList);
		urlPara.objectType = "<%=ECAttachmentConstants.EC_ATCH_OBJECT_TYPE_CATALOG%>";
		urlPara.saveChanges = true;
		urlPara.returnPage = CONSTANT_TOOL_LIST;
		
		top.setContent("<%=UIUtil.toJavaScript((String) rbProduct.get("ProductUpdateMenuTitle_AddAttachment"))%>", url, true, urlPara);

	}
	

</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>
	parent.sortImgMsg = "<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatSortMsg"))%>";
	
	startDlistTable("NavCatCatalogList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListContent_Identifier"))%>",  true, "null", "CATALOG.IDENTIFIER",  <%=orderByParm.equals("CATALOG.IDENTIFIER")%>,  "mySort" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCatalogListContent_Description"))%>", true, "null", "CATALOG.DESCRIPTION", <%=orderByParm.equals("CATALOG.DESCRIPTION")%>, "mySort" );
	endDlistRow();
<%
	int iStoreId = cmdContext.getStoreId().intValue();
	int rowselect = 1;
	for (int i=0; i<vResults.size(); i++)
	{
		Vector vResult = (Vector) vResults.elementAt(i);

		Long lCatalogId = new Long(vResult.elementAt(0).toString());
		String strIdent = (String) vResult.elementAt(1);
		String strDesc  = (String) vResult.elementAt(2);
		Integer iStoreEnt = new Integer(vResult.elementAt(3).toString());

		if(lCatalogId.longValue() == lMasterCatalogId.longValue())
			if(strExtFunctionMasterCatalog.equals("false")) 
				continue;
%>
		startDlistRow(<%=rowselect+1%>);
		addDlistCheck( "<%=lCatalogId%>", "setChecked()", "<%=(iStoreEnt.intValue() == iStoreId)%>" );
		if (<%=(iStoreEnt.intValue() == iStoreId)%>)
		{
			addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strIdent)%>"), "javascript:modelCatalog('<%=lCatalogId%>')", "word-break:break-all;" );
		} else {
			addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strIdent)%>"), "none", "word-break:break-all;" );
		}
		addDlistColumn( changeJavaScriptToHTML("<%=UIUtil.toJavaScript(strDesc)%>"),  "none", "word-break:break-all;" );
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
