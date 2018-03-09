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

   String orderByParm     = helper.getParameter("orderby");
   
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
	
	if (orderByParm == null) orderByParm = "DISPCGPREL_ID";


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

	<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatTargetCategoryDisplay2_Title"))%></TITLE>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>

	var templateArray = new Array();

	//////////////////////////////////////////////////////////////////////////////////////
	// templateObject()
	//
	// - this creates a new template object
	//////////////////////////////////////////////////////////////////////////////////////
	function templateObject(templateId) 
	{
		this.templateId = templateId;
		this.name = null;
		this.description = null;
		this.language = null;
		this.device = null;
	}


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
	// mySort(value)
	//
	// @param value - the order by value to sort against
	//
	// - this function reloads the page to sort by the requested sort feature
	//////////////////////////////////////////////////////////////////////////////////////
	function mySort(value)
	{
		if (value != "<%=orderByParm%>" ) 
		{
			var urlPara = new Object();
			urlPara.orderby = value;
			top.mccmain.submitForm("/webapp/wcs/tools/servlet/NavCatTargetCategoryDisplay2", urlPara, "targetCategoryDisplay2");
		}
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked() 
	//
	// - this function is called whenever a checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(CategoryDisplayList);
		if (defined(parent.targetCategoryDisplayButtons2.setButtons)) parent.targetCategoryDisplayButtons2.setButtons(count);
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
		parent.targetCategoryDisplayButtons2.setButtons(getNumberOfChecks(CategoryDisplayList));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// addButton()
	//
	// - this function processes a click of the add button
	//////////////////////////////////////////////////////////////////////////////////////
	function addButton()
	{
		for (var i=1; i<CategoryDisplayList.rows.length; i++)
		{
			if (getChecked(CategoryDisplayList, i))
			{
				parent.targetCategoryDisplay.addRowToList(templateArray[i]);
			}
		}
		setAllRowChecks(CategoryDisplayList, false);
		setChecked();
	}


</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<SCRIPT>

	document.writeln("<H1><%=UIUtil.toJavaScript((String)rbCategory.get("NavCatTargetCategoryDisplay2_TitleH1"))%></H1>");

	startDlistTable("CategoryDisplayList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Pagename"))%>",     true,  "null", "PAGENAME",     <%=orderByParm.equals("PAGENAME")%>,        "mySort" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Description"))%>",  true,  "null", "DESCRIPTION",  <%=orderByParm.equals("DESCRIPTION")%>, "mySort" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Language"))%>",     false, "null", "LANGUAGE_ID",  <%=orderByParm.equals("LANGUAGE_ID")%>, "mySort" );
	addDlistColumnHeading("<%=UIUtil.toJavaScript((String)rbCategory.get("NavCatCategoryDisplay_Device"))%>",       false, "null", "DEVICEFMT_ID", <%=orderByParm.equals("DEVICEFMT_ID")%>, "mySort" );

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

		templateArray[<%=i+1%>] = new templateObject("<%=lTemplateId%>");
		templateArray[<%=i+1%>].name        = "<%=UIUtil.toJavaScript(strPagename)%>";
		templateArray[<%=i+1%>].description = "<%=UIUtil.toJavaScript(strDescription)%>";
		templateArray[<%=i+1%>].language    = "<%=UIUtil.toJavaScript(strLanguage)%>";
		templateArray[<%=i+1%>].device      = "<%=UIUtil.toJavaScript(strDevice)%>";

		startDlistRow(<%=rowselect+1%>);
		addDlistCheck( "<%=lTemplateId%>", "setChecked()", "<%=lTemplateId%>" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strPagename)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strDescription)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strLanguage)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strDevice)%>", "none", "word-break:break-all;" );
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
