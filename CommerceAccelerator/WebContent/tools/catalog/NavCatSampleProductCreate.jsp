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
	Vector vResults = new Vector();
	try
	{
		// SELECT LIST OF CATALOG ENTRIES WITHIN THE SELECTED CATEGORY
		ServerJDBCHelperBean abHelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
		String strSQL  = "SELECT ATTRIBUTE_ID, ATTRTYPE_ID, NAME, DESCRIPTION FROM ATTRIBUTE WHERE CATENTRY_ID=0 and LANGUAGE_ID="+cmdContext.getStore().getLanguageId();
		vResults = abHelper.executeQuery(strSQL);
	} catch (Exception ex) { vResults = new Vector(); }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
	<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/catalog/NavCatCommonFunctions.js"></SCRIPT>
	<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

<SCRIPT>

function PropertyData(attributes) 
{
    this.attributes = attributes;
}  

Property.ID = "attributes";


function Property(attributes) 
{
    this.data = new PropertyData(attributes);
    this.id = Property.ID;
    this.formref = null;
}    


	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad()
	//
	// - this function is called upon load of the page
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
		parent.setContentFrameLoaded(true);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// setChecked() 
	//
	// - this function is called whenever a checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function setChecked()
	{
		var count = getNumberOfChecks(NavCatSampleList);
		setCheckHeading(NavCatSampleList, (count == getTableSize(NavCatSampleList)));
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// selectDeselectAll() 
	//
	// - this function is called when the select/deselect all checkbox is clicked
	//////////////////////////////////////////////////////////////////////////////////////
	function selectDeselectAll()
	{
		setAllRowChecks(NavCatSampleList, event.srcElement.checked);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// savePanelData() 
	//
	// - this function is called when leaving the page
	//////////////////////////////////////////////////////////////////////////////////////
	function savePanelData()
	{
		var checkArray = new Array();
		for (var i=1; i<NavCatSampleList.rows.length; i++)
		{
			if (getChecked(NavCatSampleList, i))
			{
				checkArray[checkArray.length] = getCheckBoxId(NavCatSampleList, i);
			}
		}

		var prop = new Property(checkArray);
		parent.put(Property.ID, prop.data);
	}


</SCRIPT>
</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<H1>Select the attributes you want copied to the new product.</H1>
<BR>
<BR>

<SCRIPT>

	startDlistTable("NavCatSampleList", "100%");
	startDlistRowHeading();
	addDlistCheckHeading(true, "selectDeselectAll()");
	addDlistColumnHeading("Name", true,  "null");
	addDlistColumnHeading("Type", false,  "1");
	addDlistColumnHeading("Description", true,  "null");
	endDlistRow();
<%
	for (int i=0; i<vResults.size(); i++)
	{
		Vector vRow = (Vector) vResults.elementAt(i);
		String strId = "";
		if (vRow.elementAt(0) != null) strId = vRow.elementAt(0).toString();
		String strName = "";
		if (vRow.elementAt(2) != null) strName = vRow.elementAt(2).toString();
		String strType = "";
		if (vRow.elementAt(1) != null) strType = vRow.elementAt(1).toString();
		String strDesc = "";
		if (vRow.elementAt(3) != null) strDesc = vRow.elementAt(3).toString();
%>
		startDlistRow(<%=rowselect+1%>);
		addDlistCheck( "<%=strId%>", "setChecked()", "<%=strId%>" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strName)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strType)%>", "none", "word-break:break-all;" );
		addDlistColumn( "<%=UIUtil.toJavaScript(strDesc)%>", "none", "word-break:break-all;" );
		endDlistRow();
<%
		rowselect = 1 - rowselect;
	}
%>
	endDlistTable();

</SCRIPT>

</BODY>
</HTML>
