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

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.ras.*" %>

<%@ include file="../common/common.jsp" %>

<%!
///////////////////////////////
// get the complete list of catalog within the store for display purpose
///////////////////////////////
public Vector getCatalogList(Integer storeID) 
{
	Vector vCatalogs = new Vector();

	try
	{
		CatalogAccessBean abCatalogs = new CatalogAccessBean();
		Enumeration eCatalogs = abCatalogs.findByStoreId(storeID);
		while (eCatalogs.hasMoreElements())
		{
			CatalogAccessBean abCatalog = (CatalogAccessBean) eCatalogs.nextElement();
			vCatalogs.addElement(abCatalog);
		}
	}
	catch (Exception e)
	{
		ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getCatalogList", "Exception getting catalog list in title");
	}
	
	return vCatalogs;
}
%>

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CatalogNLS", cmdContext.getLocale());
	com.ibm.commerce.server.JSPHelper helper = new com.ibm.commerce.server.JSPHelper(request);
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearch_Title"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>

	//////////////////////////////////////////////////////////////////////////////////////
	// onLoad() 
	//
	// - this gets called on load of the page
	//////////////////////////////////////////////////////////////////////////////////////
	function onLoad() 
	{
		adjustDropdownWidth();
		inputIdent.focus();
	}

	function adjustInputClassDropdownWidth(oDropdown)
	{
		if(oDropdown.scrollWidth<200)				//.input uesed to setwidth =200px
		 	oDropdown.style.width="200px";
	}
	
	function adjustDropdownWidth()
	{	
		adjustInputClassDropdownWidth(document.all.selectIdent);
		adjustInputClassDropdownWidth(document.all.selectName);
		adjustInputClassDropdownWidth(document.all.selectCatalog);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// resetButton()
	//
	// - this function processes a click of a reset button
	//////////////////////////////////////////////////////////////////////////////////////
	function resetButton()
	{
		inputName.value = "";
		selectName.selectedIndex = 0;
		inputIdent.value = "";
		selectIdent.selectedIndex = 0;
		selectCatalog.selectedIndex = 0;
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// searchButton()
	//
	// - this function processes a click of a search button
	//////////////////////////////////////////////////////////////////////////////////////
	function searchButton() 
	{
		var urlPara = new Object();
		urlPara.name         = inputName.value;
		urlPara.nameOp       = selectName.value;
		urlPara.identifier   = inputIdent.value;
		urlPara.identifierOp = selectIdent.value;
		urlPara.catalogId    = selectCatalog.value;

		parent.setCatgroupSearchResults(urlPara);
	}


	//////////////////////////////////////////////////////////////////////////////////////
	// handleEnterPressed() 
	//
	// - perform a default action if the enter key is pressed
	//////////////////////////////////////////////////////////////////////////////////////
	function handleEnterPressed() 
	{
		if(event.keyCode != 13) return;
		if (parent.getWorkframeReady() == false) return;
		parent.categoriesSearchButtons.searchButton();
	}


</SCRIPT>
</HEAD>

<STYLE TYPE='text/css'>
INPUT.input {width:200px;}
SELECT.input {width:"auto";}	
</STYLE>

<BODY CLASS=content ONKEYPRESS="handleEnterPressed();" ONLOAD=onLoad() ONCONTEXTMENU="return false;">

<%=(String)rbCategory.get("NavCatCategoriesSearch_Instructions")%>
<BR>
<BR>

<TABLE BORDER=0>
	<TR>
		<TD COLSPAN=3><LABEL for="inputIdent"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearch_Code"))%></LABEL></TD>
	</TR>
	<TR>
		<TD><INPUT TYPE="text" ID="inputIdent" NAME="inputIdent" CLASS="input" MAXLENGTH="64"></TD>
		<TD>&nbsp;<LABEL for="selectIdent"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearch_Code")) %></SPAN></LABEL></TD>
		<TD> 
			<SELECT ID="selectIdent" NAME="selectIdent" CLASS="input">
				<OPTION VALUE="LIKE"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_operator_like"))%></OPTION>
				<OPTION VALUE="="><%=UIUtil.toHTML((String)rbCategory.get("NavCat_operator_exact"))%></OPTION>
			</SELECT>
		</TD>
	</TR>
	<TR><TD></TD></TR>
	<TR>
		<TD COLSPAN=3><LABEL for="inputName"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearch_Name"))%></LABEL></TD>
	</TR>
	<TR>
		<TD><INPUT TYPE="text" ID="inputName" NAME="inputName" CLASS="input" MAXLENGTH="254"></TD>
		<TD>&nbsp;<LABEL for="selectName"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearch_Name")) %></SPAN></LABEL></TD>
		<TD>
			<SELECT ID="selectName" NAME="selectName" CLASS="input">
				<OPTION VALUE="LIKE"><%=UIUtil.toHTML((String)rbCategory.get("NavCat_operator_like"))%></OPTION>
				<OPTION VALUE="="><%=UIUtil.toHTML((String)rbCategory.get("NavCat_operator_exact"))%></OPTION>
			</SELECT>
		</TD>
	</TR>
	<TR><TD></TD></TR>
	<TR>
		<TD><LABEL for="selectCatalog"><%=UIUtil.toHTML((String)rbCategory.get("NavCatCategoriesSearch_Catalog"))%></LABEL></TD>
	</TR>
	<TR>
		<TD COLSPAN=3>
			<SELECT ID="selectCatalog" NAME="selectCatalog" CLASS='input'>
<%
			Vector vCatalogs = getCatalogList(cmdContext.getStoreId());
			for (int i=0; i<vCatalogs.size(); i++) 
			{  
				CatalogAccessBean abCatalog = (CatalogAccessBean) vCatalogs.elementAt(i);
				String strCatalogId = abCatalog.getCatalogReferenceNumber(); 
%>
				<OPTION VALUE="<%=strCatalogId%>"><%=UIUtil.toHTML(abCatalog.getIdentifier())%>
<%
			}
%>
			</SELECT>
		</TD>
	</TR>
</TABLE>

</BODY>
</HTML>


