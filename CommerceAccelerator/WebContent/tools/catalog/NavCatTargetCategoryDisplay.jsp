<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2017
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
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
	String strCategoryId = helper.getParameter("categoryId");
   String orderByParm   = helper.getParameter("orderby");

	try
	{
		Long.parseLong(strCategoryId);
		
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
				 strSQL += " WHERE CATGROUP_ID=" + strCategoryId;
				 strSQL += " AND STOREENT_ID" + CatalogSqlHelper.getStorePathInClauseSQL(cmdContext.getStoreId());
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

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplay_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>

	var iMaxRank = 0;

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called when the frame is loaded
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad () 
	{
		top.showProgressIndicator(true);	
		if (getTableSize(CategoryDisplayList) == 0) 
		{
			divEmpty.innerHTML = "<BR><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_NoTemplates"))%>";
			divEmpty.style.display = "block";
		}
		setChecked();
		top.showProgressIndicator(false);	
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked() 
	//
	// - this function is called whenever a checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(CategoryDisplayList);
		if (parent.targetCategoryDisplayButtons.setButtons) parent.targetCategoryDisplayButtons.setButtons(count);
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
		parent.targetCategoryDisplayButtons.setButtons(getNumberOfChecks(CategoryDisplayList));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// deleteButton()
	//
	// - this function processes a click of the delete button
	//////////////////////////////////////////////////////////////////////////////////////
	function deleteButton()
	{
		top.showProgressIndicator(true);	
		for (var i=CategoryDisplayList.rows.length-1; i>=1; i--)
		{
			if (getChecked(CategoryDisplayList, i))
			{
				delRow("CategoryDisplayList",i);
			}
		}
		setChecked();
		top.showProgressIndicator(false);	
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// okButton()
	//
	// - this function processes a click of the ok button to process the save the changes
	//////////////////////////////////////////////////////////////////////////////////////
	function okButton()
	{
		var obj = new Object();
		obj.categoryId = "<%=strCategoryId%>";
		obj.templates = new Array();

		var ranks= new Array();
		
		for (var i=1; i<CategoryDisplayList.rows.length; i++)
		{
			var seqValue = top.strToNumber(rankInput[i-1].value, <%=languageId%>);
			if (top.isValidNumber(rankInput[i-1].value, <%=languageId%>) == false)
			{
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_InvalidSequence"))%>");
				rankInput[i-1].focus();
				return false;
			}
			
			//check for duplicated ranks
			ranks[i-1]=top.strToNumber(rankInput[i-1].value, <%=languageId%>);
			for(var k=0; k<i-1; k++)
			{
				if(ranks[i-1] == ranks[k])
				{
					alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetProducts_DuplicateSequence"))%>");		
					rankInput[i-1].focus();
					return false;
				}	
			}
			
			var templateObject = new Object();
			templateObject.templateId = getCheckBoxId(CategoryDisplayList, i); 
			templateObject.sequence = seqValue;
			obj.templates[i-1] = templateObject;
		}
		
		parent.targetCategoryDisplayBottom.submitFunction("NavCatTargetCategoryDisplayControllerCmd", obj);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addRowToList(newRow)
	//
	// - this function adds a row to the list
	//////////////////////////////////////////////////////////////////////////////////////
	function addRowToList(newRow)
	{
		var cell;
		var rowIndex = CategoryDisplayList.rows.length;

		insRow("CategoryDisplayList", rowIndex);
		//insCheckBox("CategoryDisplayList",rowIndex,0,"Add","setChecked()",newRow.templateId);
		insCheckBox("CategoryDisplayList",rowIndex,0,newRow.templateId,"setChecked()",newRow.templateId);
		
		cell = getCell("CategoryDisplayList",rowIndex,1);
		cell.className = list_col_style;
		cell.innerHTML = newRow.name;

		cell = getCell("CategoryDisplayList",rowIndex,2);
		cell.className = list_col_style;
		cell.innerHTML = newRow.description;

		cell = getCell("CategoryDisplayList",rowIndex,3);
		cell.className = list_col_style;
		cell.innerHTML = newRow.language;

		cell = getCell("CategoryDisplayList",rowIndex,4);
		cell.className = list_col_style;
		cell.innerHTML = newRow.device;

		cell = getCell("CategoryDisplayList",rowIndex,5);
		cell.className = list_col_style;
		cell.style.textAlign = "right";
		cell.innerHTML = "<INPUT NAME=rankInput SIZE=5 VALUE=\""+top.formatNumber("0.0", <%=languageId%>, 2)+"\" STYLE=\"background-color:transparent; text-align:right;\">";

		divEmpty.style.display = "none";
	}


</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>

	document.writeln("<H1><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetCategoryDisplay_TitleH1"))%></H1>");

	startDlistTable("CategoryDisplayList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Pagename"))%>",    true,  "null");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Description"))%>", true,  "null");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Language"))%>",    true,  "null");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Device"))%>",      true,  "null");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Rank"))%>",        false, "null");

	endDlistRow();


<%
	int rowselect = 1;
	for (int i=0; i<vResults.size(); i++)
	{
		Vector vResult = (Vector) vResults.elementAt(i);

		String strDevice = "";
		String strLanguage = "";
		Double dRank        = new Double(0.0);
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
		startDlistRow(<%=rowselect+1%>);
		addDlistCheck( "<%=lTemplateId%>", "setChecked()", "<%=lTemplateId%>" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strPagename)%>", "none", "word-break:break-all;" );
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
