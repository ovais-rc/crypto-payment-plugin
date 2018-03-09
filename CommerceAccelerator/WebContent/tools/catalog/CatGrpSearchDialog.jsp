<%--
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
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>
<%@ page import="com.ibm.commerce.ras.*" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%!
///////////////////////////////
// get the complete list of catalog within the store for display purpose
///////////////////////////////
public Vector getCatalogList(Integer storeID) {
	Vector catalogList = new Vector();
	
	CatalogDataBean catalogs = new CatalogDataBean();
	
	try {
		Enumeration e = catalogs.findByStoreId(storeID);
		while (e.hasMoreElements()) {
			com.ibm.commerce.catalog.objects.CatalogAccessBean catalog = (com.ibm.commerce.catalog.objects.CatalogAccessBean) e.nextElement();
			catalogList.addElement(catalog);
		}
	} catch (Exception ex) {
	  	ECTrace.trace(ECTraceIdentifiers.COMPONENT_CATALOGTOOL, this.getClass().getName(), "getCatalogList",
					"");			  	
	}
	
	return catalogList;
}
%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>


<%
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
    	Integer storeId 	= cmdContextLocale.getStoreId();
    	Integer langId		= cmdContextLocale.getLanguageId();
        Hashtable categoryFindNLS = (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);

	JSPHelper jspHelper 	= new JSPHelper(request);
	
	///////////////////////
	// optional input parameters for redirection purpose, defaulted to sample product list
	///////////////////////
	String redirectURL	= jspHelper.getParameter("redirectURL");
	String redirectCmd	= jspHelper.getParameter("redirectCmd");
	String redirectXML	= jspHelper.getParameter("redirectXML");
	///////////////////////
	// optional input parameter to specify initial search catalog
	///////////////////////
	String catalogID	= jspHelper.getParameter("catID");
	
	///////////////////////
	// optional input parameter defaulted to all catentries
	// valid values can be "category"
	///////////////////////
	String searchType	= jspHelper.getParameter("searchType");
	
	///////////////////////
	// optional input parameter for next action taker
	// can be replaced by setting the redirection parameters
	// valid values can be "PLU", "MA", "NC", "PB", "CG"
	// special value "GO_BACK" indicates results to be send back to previous page
	///////////////////////
	String actionEP		= jspHelper.getParameter("actionEP");
	
	if (searchType == null || !searchType.equals("category")) {
		searchType = "category";
	}

	if((redirectURL==null) || (redirectURL.length()==0)) {
		redirectURL 	= "";
	}

	if((redirectCmd==null) || (redirectCmd.length()==0)) {
		redirectCmd 	= "";
	}

	if((redirectXML==null)|| (redirectXML.length()==0))	{
		redirectXML 	= "";
	}

	String redirectTitle	= (String)categoryFindNLS.get("catalogSearch_resultType_sampleCategory");
	
	if (actionEP != null) {
		if (actionEP == "PLU") {
			redirectTitle 	= (String)categoryFindNLS.get("catalogSearch_PLUResultTitle");
		} else if (actionEP == "MA") {
			redirectTitle	= (String)categoryFindNLS.get("catalogSearch_MAResultTitle");
		} else if (actionEP == "NC") {
			redirectTitle	= (String)categoryFindNLS.get("catalogSearch_NCResultTitle");
		} else if (actionEP == "PB") {
			redirectTitle	= (String)categoryFindNLS.get("catalogSearch_PBResultTitle");
		}
	}
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<TITLE><%=categoryFindNLS.get("categorySearchTitle")%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
var strAction="<%=actionEP%>";

<%--
//---------------------------------------------------------------------
//- Display functions
//---------------------------------------------------------------------
--%>
/////////////////////////
// initialization
/////////////////////////
function onLoad() {
	parent.setContentFrameLoaded(true);
}

////////////////////////
// clean up the form
////////////////////////
function cleanForm() {
	document.searchForm.reset();
}

<%--
//---------------------------------------------------------------------
//- Action functions
//---------------------------------------------------------------------
--%>
///////////////////////
// validate all the inputs before sending form to result page
///////////////////////
function validateEntries() {
	return true;
}

///////////////////////
// return back to the previous page with the form value if GO_BACK option is specified
///////////////////////
function goBackWithParameters(urlPara)
{
	top.mccbanner.counter --;
	top.mccbanner.showbct();
	
	top.showContent(top.mccbanner.trail[top.mccbanner.counter].location, 
					urlPara);

}

///////////////////////
// activation search action and forward to resulting page when data are validated
///////////////////////
function findAction() {
	if (validateEntries() == true) {
		url 			= "<%=redirectURL%>";
		var urlPara 		= new Object();
		urlPara.listsize	= '22';
		urlPara.startindex	= '0';
  		urlPara.cmd		= "<%=redirectCmd%>";
  		urlPara.ActionXMLFile	= "<%=redirectXML%>";
  		urlPara.XMLFile		= "<%=redirectXML%>";
  		urlPara.searchType	= "<%=searchType%>";
  		urlPara.catID		= document.all.catalogID.value;
  		urlPara.identifier	= document.all.identifier.value;
  		urlPara.identifierOp	= document.all.identifierOp.value; 		
  		urlPara.name		= document.all.name.value;
  		urlPara.nameOp		= document.all.nameOp.value;
  		urlPara.searchScope	= document.all.searchScope.checked;
  		urlPara.CGpublished	= document.all.published.value;
  		urlPara.CGnotPublished	= document.all.notPublished.value;
  		urlPara.displayNum	= document.all.displayNum.value;
  		urlPara.orderby		= document.all.sortBy.value;

		if(strAction!="GO_BACK")
			top.setContent("<%=redirectTitle%>",url,true, urlPara);     
		else
			goBackWithParameters(urlPara);

		return true;
	}
	return false;
}

//////////////////////////
// cancel search 
//////////////////////////
function cancelAction() {
	top.goBack();
}


</SCRIPT>
</HEAD>


<BODY CLASS=content ONLOAD="onLoad();">

<STYLE TYPE='text/css'>
	.input {width:200px;}
</STYLE>

<H1><%=categoryFindNLS.get("categorySearchTitle")%></H1>

<%=categoryFindNLS.get("categorySearchInstruction")%>
<FORM NAME="searchForm" ACTION="" METHOD="post">

<TABLE BORDER=0>
	<TR>
	  <TD COLSPAN=3><label for="identifierID"><%=categoryFindNLS.get("catalogSearch_identifier")%></label></TD>
	</TR>
	<TR>
	   <TD><INPUT TYPE="text" id="identifierID" NAME="identifier" CLASS="input" MAXLENGTH="64"></TD>
	   <TD>&nbsp;<label for="identifierOpID"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("catalogSearch_identifier")) %></SPAN></label></TD>
	   <TD> 
	   	<SELECT id="identifierOpID" NAME="identifierOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=categoryFindNLS.get("catalogSearch_operator_like")%></OPTION>
	  	<OPTION VALUE="="><%=categoryFindNLS.get("catalogSearch_operator_exact")%></OPTION>
	  	</SELECT>
	   </TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	  <TD COLSPAN=3><label for="nameID"><%=categoryFindNLS.get("catalogSearch_name")%></label></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="text" id="nameID" NAME="name" CLASS="input" MAXLENGTH="254"></TD>
	  <TD>&nbsp;<label for="nameOpID"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("catalogSearch_name")) %></SPAN></label></TD>
	  <TD>
	  	<SELECT id="nameOpID" NAME="nameOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=categoryFindNLS.get("catalogSearch_operator_like")%></OPTION>
	  	<OPTION VALUE="="><%=categoryFindNLS.get("catalogSearch_operator_exact")%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR>
	  <TD COLSPAN=3>&nbsp;<INPUT TYPE="checkbox" id="searchScopeID" NAME="searchScope"><label for="searchScopeID"><%=categoryFindNLS.get("catalogSearch_include_desc")%></label></TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	  <TD><label for="catalogID"><%=categoryFindNLS.get("catalogSearch_catalog")%></label></TD>
	</TR>
	<TR>
	  <TD>
	  	<SELECT id="catalogID" NAME="catalogID" CLASS='input'>
		<%
	  		Vector catalogList = getCatalogList(storeId);
	  		for (int i=0; i<catalogList.size(); i++) {  
	  			String catID = ((com.ibm.commerce.catalog.objects.CatalogAccessBean)(catalogList.get(i))).getCatalogReferenceNumber(); %>
	  			<OPTION VALUE="<%=catID%>"
	  			<% if (catalogID != null && catalogID.equals(catID)) {%>
	  				SELECTED
	  			<% } %>
	  			> 
	  			<%=((com.ibm.commerce.catalog.objects.CatalogAccessBean)(catalogList.get(i))).getDescription(langId).getName()%>
	  	<%	}
	  	%>
	  	
	  	</SELECT>
	  </TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	  <TD><%=categoryFindNLS.get("catalogSearch_productOption")%></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="checkbox" id="publishedID" NAME="published"><label for="publishedID"><%=categoryFindNLS.get("catalogSearch_published")%></label></TD>
	  <TD></TD>
	  <TD><INPUT TYPE="checkbox" id="notPublishedID" NAME="notPublished"><label for="notPublishedID"><%=categoryFindNLS.get("catalogSearch_notPublished")%></label></TD>
	</TR>  
	<TR><TD></TD></TR>
</TABLE>

</FORM>

<FORM>
<TABLE BORDER=0>
  <TR>
  	<TD><label for="displayNumID"><%=categoryFindNLS.get("catalogSearch_displayNum")%></label>
  		<SELECT id="displayNumID" NAME="displayNum">
  		<OPTION VALUE="10">10
  		<OPTION VALUE="20">20
  		<OPTION VALUE="30">30
  		</SELECT>
  	</TD>
  	<TD>
  	    <label for="sortByID"><%=categoryFindNLS.get("catalogSearch_sortBy")%></label>
		<SELECT id="sortByID" NAME="sortBy">
		<OPTION VALUE="identifier"><%=categoryFindNLS.get("catalogSearch_identifier")%>
		<OPTION VALUE="Name"><%=categoryFindNLS.get("catalogSearch_name")%>
  		</SELECT>
  	</TD>
  </TR>
</TABLE>
</FORM>

</BODY>
</HTML>

