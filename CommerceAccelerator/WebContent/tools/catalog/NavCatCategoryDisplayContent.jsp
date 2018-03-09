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
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
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
	String orderByParm = helper.getParameter("orderby");
	
	// Validate input parms
	try
	{
		if(orderByParm != null && orderByParm.trim().length()!=0)
		{
			//Allowed values
			HashSet allowedTokens = new HashSet();
			allowedTokens.add("DISPCGPREL");
			allowedTokens.add("DISPCGPREL_ID");
			allowedTokens.add("LANGUAGE_ID");
			allowedTokens.add("DEVICEFMT_ID");
			allowedTokens.add("PAGENAME");
			allowedTokens.add("DESCRIPTION");
			allowedTokens.add("RANK");
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
	
	if (orderByParm == null) orderByParm = "RANK";

	Integer languageId = cmdContext.getLanguageId();


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Run the query to return the store path enabled products
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	Vector vResults = new Vector();
	try
	{
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT DISPCGPREL_ID, LANGUAGE_ID, DEVICEFMT_ID, PAGENAME, DESCRIPTION, RANK, STOREENT_ID";
				 strSQL += " FROM DISPCGPREL";
				 strSQL += " WHERE CATGROUP_ID=0 AND STOREENT_ID" + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
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

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoryDisplayContent_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>

	var rankArray = new Array();

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad () 
	{
		if (getTableSize(CategoryDisplayList) == 0) 
		{
			divEmpty.innerHTML = "<BR><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_NoTemplates"))%>";
			divEmpty.style.display = "block";
		}
		setChecked();
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// refresh(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// - this function is called when the frame is reloaded it will save the
	//   sequences first if they have changed
	//////////////////////////////////////////////////////////////////////////////////////
	function refresh(value)
	{
		if (sequenceChanges(value) == false)
		{
			if (value == "none") mySort("<%=orderByParm%>");
			else if (value == "close")  top.goBack();
			else if (value == "create") createButton();
			else if (value == "edit")   editButtonFunction();
			else mySort(value);
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// validateSequences()
	//
	// @return true - if the sequences are valid, otherwise false
	//
	// - this function determines if the sequence values are valid numbers
	//////////////////////////////////////////////////////////////////////////////////////
	function validateSequences()
	{
		for (var i=0; i<rankArray.length; i++)
		{
			if (top.isValidNumber(rankInput[i].value, <%=languageId%>) == false)
			{
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_InvalidSequence"))%>");
				rankInput[i].focus();
				return false;
			}
		}

		return true;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// sequenceChanges(value)
	//
	// @param value - value is a field that can be used to determine redirect logic
	//
	// @return true - if the sequence has changed, otherwise false
	//
	// - this function determines if the sequence has changed saving them if they have
	//////////////////////////////////////////////////////////////////////////////////////
	function sequenceChanges(value)
	{
		if (validateSequences() == false) return true;

		var ranks = new Array();
		for (var i=0; i<rankArray.length; i++)
		{
			var seqValue = top.strToNumber(rankInput[i].value, <%=languageId%>);
			if (rankArray[i] != seqValue)
			{
				var index = ranks.length;
				ranks[index] = new Object();
				ranks[index].templateId = getCheckBoxId(CategoryDisplayList, i+1);
				ranks[index].sequence   = seqValue;
				rankArray[i] = seqValue;
			}
		}

		if (ranks.length > 0)
		{
			var obj = new Object();
			obj.value     = value;
			obj.sequences = ranks;
			parent.categoryDisplayBottom.submitFunction("NavCatCategoryDisplaySequenceControllerCmd", obj);
			return true
		} 

		return false;
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
		urlPara.orderby = value;
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatCategoryDisplayContent", urlPara, "categoryDisplayContents");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked() 
	//
	// - this function is called whenever a checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(CategoryDisplayList);
		if (defined(parent.categoryDisplayContentsButtons.setButtons)) parent.categoryDisplayContentsButtons.setButtons(count);
		setCheckHeading(CategoryDisplayList, (count == getTableSize(CategoryDisplayList)));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectDeselectAll() 
	//
	// - this function is called when the select/deselect all checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function selectDeselectAll()
	{
		setAllRowChecks(CategoryDisplayList, event.srcElement.checked);
		parent.categoryDisplayContentsButtons.setButtons(getNumberOfChecks(CategoryDisplayList));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// createButton()
	//
	// - this function processes a click of the create button
	//////////////////////////////////////////////////////////////////////////////////////
	function createButton()
	{
		var url = "/webapp/wcs/tools/servlet/NavCatCategoryDisplayCreateDialog";
		var urlPara = new Object();
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_CreateBCT"))%>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// editButton(value)
	//
	// @param value - the templateId value
	//
	// - this function processes a click of the edit button
	//////////////////////////////////////////////////////////////////////////////////////
	function editButton(value)
	{
		if (!value) value = getFirstCheckedId(CategoryDisplayList);
		top.put("NavCatCategoryDisplayEditValue", value);
		refresh("edit");
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// editButtonFunction()
	//
	// - this function processes a click of the edit button
	//////////////////////////////////////////////////////////////////////////////////////
	function editButtonFunction()
	{
		var value = top.get("NavCatCategoryDisplayEditValue", null);

		var url = "/webapp/wcs/tools/servlet/NavCatCategoryDisplayCreateDialog";
		var urlPara = new Object();
		urlPara.templateId  = value;
		top.setContent("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_EditBCT"))%>", url, true, urlPara);     
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - this function processes a click of the delete button
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		var obj = new Object();
		obj.templateId = new Array();

		for (var i=1; i<CategoryDisplayList.rows.length; i++)
		{
			if (CategoryDisplayList.rows(i).cells(0).firstChild.checked)
			{
				obj.templateId[obj.templateId.length] = CategoryDisplayList.rows(i).cells(0).firstChild.value;
			}
		}

		parent.categoryDisplayBottom.submitFunction("NavCatCategoryDisplayDeleteControllerCmd", obj);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// closeButton()
	//
	// - this function processes a click of the close button and checks the sequence
	//////////////////////////////////////////////////////////////////////////////////////
	function closeButton()
	{
	}


</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>

	document.writeln("<H1><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplayDialog_Title"))%></H1>");

	startDlistTable("CategoryDisplayList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Pagename"))%>",     true,  "null", "PAGENAME",     <%=orderByParm.equals("PAGENAME")%>,     "refresh" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Description"))%>",  true,  "null", "DESCRIPTION",  <%=orderByParm.equals("DESCRIPTION")%>,  "refresh" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Language"))%>",     false, "null", "LANGUAGE_ID",  <%=orderByParm.equals("LANGUAGE_ID")%>,  "refresh" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Device"))%>",       false, "null", "DEVICEFMT_ID", <%=orderByParm.equals("DEVICEFMT_ID")%>, "refresh" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Rank"))%>",         false, "1",    "RANK",         <%=orderByParm.equals("RANK")%>,         "refresh" );

	endDlistRow();

<%
	int rowselect = 0;
	for (int i=0; i<vResults.size(); i++)
	{
		Vector vResult = (Vector) vResults.elementAt(i);

		String strDevice = "";
		String strLanguage = "";
		Double dRank       = new Double(0.0);
		String strDescription = "";

		Long lTemplateId = new Long(vResult.elementAt(0).toString());
		String strPagename = (String) vResult.elementAt(3);

		if (vResult.elementAt(1) != null) 
		{ 
			LanguageDescriptionAccessBean abLanguage = new LanguageDescriptionAccessBean();
			abLanguage.setInitKey_languageId(cmdContext.getLanguageId().toString());
			abLanguage.setInitKey_descriptionLanguageId(vResult.elementAt(1).toString());
			strLanguage = abLanguage.getDescription();
		}

		if (vResult.elementAt(2) != null) 
		{ 
			DeviceFormatAccessBean abDevice = new DeviceFormatAccessBean();
			abDevice.setInitKey_deviceFormatId(vResult.elementAt(2).toString());
			strDevice = abDevice.getDeviceTypeId();
		}

		if (vResult.elementAt(4) != null) { strDescription = (String) vResult.elementAt(4); }
		if (vResult.elementAt(5) != null) { dRank          = new Double(vResult.elementAt(5).toString()); }

%>
		rankArray[rankArray.length] = "<%=dRank%>";
		startDlistRow(<%=rowselect+1%>);
		addDlistCheck( "<%=lTemplateId%>", "setChecked()", "<%=lTemplateId%>" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strPagename)%>", "javascript:editButton(<%=lTemplateId%>)", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strDescription)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strLanguage)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strDevice)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<INPUT NAME=rankInput SIZE=5 VALUE=\""+top.formatNumber("<%=dRank%>", <%=languageId%>, null)+"\" STYLE=\"background-color:transparent; text-align:right;\">", "none", "text-align:right" );
		endDlistRow();
<%
		rowselect = 1 - rowselect;
	}
%>
	endDlistTable();
	document.writeln("<INPUT TYPE=HIDDEN NAME=rankInput>");  // dummy to ensure an array

</SCRIPT>

<DIV ID=divEmpty STYLE="display: none;">
</DIV>

</BODY>
</HTML>
