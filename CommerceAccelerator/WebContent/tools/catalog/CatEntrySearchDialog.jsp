


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
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
<%@ page import="com.ibm.commerce.ras.*" %>

<%@ include file="../common/common.jsp" %>

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
					"Exception getting catalog list in title");			  
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
	// valid values can be "catentry", "product", "notItem", or "package"
	///////////////////////
	String searchType	= jspHelper.getParameter("searchType");

	///////////////////////
	// optional input parameter for next action taker
	// can be replaced by setting the redirection parameters
	// valid values can be "PLU", "MA", "NC", "PB"
	// special value "GO_BACK" indicates results to be send back to previous page
	///////////////////////
	String actionEP		= jspHelper.getParameter("actionEP");
	String goback		= jspHelper.getParameter("goback");
	
	///////////////////////
	// optional boolean input parameter to indicate whether to search for all stores
	// or the current store only
	///////////////////////
	String allStores	= jspHelper.getParameter("allStores");
	
	if((redirectURL==null) || (redirectURL.length()==0)) {	
		redirectURL 	= "/webapp/wcs/tools/servlet/ProductUpdateDialog"; }

	if((redirectCmd==null) || (redirectCmd.length()==0)) {
		redirectCmd 	= ""; }

	if((redirectXML==null)|| (redirectXML.length()==0))	{
		redirectXML 	= ""; }

	String redirectTitle	= (String)categoryFindNLS.get("catalogSearch_resultTitle_sampleProduct");

	if (actionEP != null) {
		if (actionEP.equals("PLU")) {
			redirectTitle 	= (String)categoryFindNLS.get("catalogSearch_PLUResultTitle");
			redirectURL	= "/webapp/wcs/tools/servlet/ProductUpdateDialog";
			searchType	= "notItem";
		} else if (actionEP.equals("MA")) {
			redirectTitle	= (String)categoryFindNLS.get("catalogSearch_MAResultTitle");
		} else if (actionEP.equals("NC")) {
			redirectTitle	= (String)categoryFindNLS.get("catalogSearch_NCResultTitle");
		} else if (actionEP.equals("PB")) {
			redirectTitle	= (String)categoryFindNLS.get("catalogSearch_PBResultTitle");
		}
	}
	
	if (searchType == null || (!searchType.equals("catentry") && 
	    !searchType.equals("product") && !searchType.equals("item") && 
	    !searchType.equals("notItem") && !searchType.equals("package"))) {
		searchType = "catentry"; }
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<TITLE><%=categoryFindNLS.get("catentrySearchTitle")%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
var strActionEP="<%=UIUtil.toJavaScript(actionEP)%>";
var goback="<%=UIUtil.toJavaScript(goback)%>";

<%--
//---------------------------------------------------------------------
//- Display functions
//---------------------------------------------------------------------
--%>
/////////////////////////
// initialization
/////////////////////////
function onLoad() {

	//
	// Ensure that if we hit the bct find we flush the saved data
	top.put("ProductUpdateDetailDataExists", "false");

<%
	if (actionEP != null) {
		if (actionEP.equals("PLU")) {
		} else if (actionEP.equals("MA")) {
%>
			parent.setCurrentPanelAttribute("helpKey","MC.catalogTool.catentrySearchMA.Help");
<%
		} else if (actionEP.equals("NC")) {
		} else if (actionEP.equals("PB")) {
%>
			parent.setCurrentPanelAttribute("helpKey","MC.catalogTool.catentrySearchPB.Help");
<%
		}
	}
%>
	selectDefaultCatentryTypes()

	adjustDropdownWidth();
	
	parent.setContentFrameLoaded(true);
}

function adjustInputClassDropdownWidth(oDropdown)
{
	if(oDropdown.scrollWidth<200)				//.input uesed to setwidth =200px
	 	oDropdown.style.width="200px";
}

function adjustDropdownWidth()
{	
	adjustInputClassDropdownWidth(document.all.skuOp);
	adjustInputClassDropdownWidth(document.all.nameOp);
	adjustInputClassDropdownWidth(document.all.manuNumOp);
	adjustInputClassDropdownWidth(document.all.manuNameOp);
	adjustInputClassDropdownWidth(document.all.categoryOp);
}

///////////////////////
// This function preselect the default catalog entry types for search
///////////////////////
function selectDefaultCatentryTypes() {

	if ("<%=searchType%>" == "package") {
		document.all.searchProduct.disabled = true;
		document.all.searchItem.disabled = true;
		document.all.searchPackage.checked = true;
		
	} else if ("<%=searchType%>" == "item") {
		parent.setCurrentPanelAttribute("helpKey","MC.catalogTool.catentrySearchSKU.Help");
		document.all.searchProduct.disabled = true;
		document.all.searchItem.checked = true;
		document.all.searchDynKit.disabled = true;
		document.all.searchPackage.disabled = true;
		document.all.searchBundle.disabled = true;
		
	} else if ("<%=searchType%>" == "notItem") {
		document.all.searchProduct.checked = true;
//		document.all.searchItem.disabled = true;
		
	} else if ("<%=searchType%>" == "product") {
		document.all.searchProduct.checked = true;
		document.all.searchItem.disabled = true;
		document.all.searchPackage.disabled = true;
		document.all.searchBundle.disabled = true;
		document.all.searchDynKit.disabled = true;
		
	} else {
		document.all.searchProduct.checked = true;
	}

}//End of defaultSelectedTypes()

////////////////////////
// clean up the form
////////////////////////
function cleanForm() {
	document.searchForm.reset();
}

////////////////////////
// display catentry search types only when specific option is chosen
////////////////////////
function searchTypes() {
	if (document.searchForm.searchType[0].checked) {
		document.all.typeFrame.style.display = "none";
	} else {
		document.all.typeFrame.style.display = "block";
		for (var i=1; i<searchTypeTable.rows(0).cells.length; i++)
		{
			if (searchTypeTable.rows(0).cells(i).firstChild.disabled)
			{
				searchTypeTable.rows(0).cells(i).style.display = "none";
			}
		}
	}
}


////////////////////////
// This function check to make sure at least 1 type is selected for search
////////////////////////
function checkTypes() {
	if (! ( document.typeFrame.searchProduct.checked | document.typeFrame.searchItem.checked 
              | document.typeFrame.searchPackage.checked | document.typeFrame.searchBundle.checked 
              | document.typeFrame.searchDynKit.checked))
	{
		alertDialog("<%=UIUtil.toJavaScript((String)categoryFindNLS.get("catalogSearch_searchSpecifiedType"))%>");
		selectDefaultCatentryTypes();
		return false;
	}		
	else
	{
		return true;
	}

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
	//return true;
	return checkTypes();
}

///////////////////////
// return back to the previous page with the form value if GO_BACK option is specified
///////////////////////
function goBackWithParameters(urlPara)
{
	top.mccbanner.counter --;
	top.mccbanner.counter --;
	top.mccbanner.showbct();
	
	top.setContent("<%=redirectTitle%>",url,true, urlPara);     

}

function goBackWithParametersWithoutChangingTitle(urlPara)
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
		url 			= "<%=UIUtil.toJavaScript(redirectURL)%>";
		var urlPara 		= new Object();
		urlPara.listsize	= '22';
		urlPara.startindex	= '0';
  		urlPara.cmd		= "<%=UIUtil.toJavaScript(redirectCmd)%>";
  		urlPara.ActionXMLFile	= "<%=UIUtil.toJavaScript(redirectXML)%>";
  		urlPara.XMLFile		= "<%=UIUtil.toJavaScript(redirectXML)%>";
  		urlPara.searchType	= "<%=searchType%>";
  		urlPara.actionEP	= "<%=UIUtil.toJavaScript(actionEP)%>";
  		urlPara.catID		= document.all.catalogID.value;
  		urlPara.category	= document.all.category.value;
  		urlPara.categoryOp	= document.all.categoryOp.value;
  		urlPara.sku             = document.all.sku.value;
  		urlPara.skuOp		= document.all.skuOp.value;
  		urlPara.name		= document.all.name.value;
  		urlPara.nameOp		= document.all.nameOp.value;
  		urlPara.searchScope	= document.all.searchScope.checked;
  		urlPara.manuNum		= document.all.manuNum.value;
  		urlPara.manuNumOp	= document.all.manuNumOp.value;
  		urlPara.manuName	= document.all.manuName.value;
  		urlPara.manuNameOp	= document.all.manuNameOp.value;
  		urlPara.CEpublished	= document.all.published.checked;
  		urlPara.CEnotPublished	= document.all.notPublished.checked;
  		urlPara.displayNum	= document.all.displayNum.value;
  		urlPara.orderby		= document.all.sortBy.value;
  		urlPara.languageId	= "<%=langId%>";
 
 		if ("<%=UIUtil.toJavaScript(allStores)%>" != "true") 
 	   		urlPara.storeId		= "<%=storeId.toString()%>";

 		if (document.searchForm.searchType[0].checked) {
  			if ("<%=searchType%>" == "package") {
				urlPara.searchPackage	= true;
				urlPara.searchBundle	= true;
				urlPara.searchDynKit	= true;

				
			} else if ("<%=searchType%>" == "item") {
				urlPara.searchItem	= true;
			} else {
	 			urlPara.searchProduct 	= true;
  				
  				if ("<%=searchType%>" != "product") {
					urlPara.searchItem	= true;
					urlPara.searchPackage	= true;
					urlPara.searchBundle	= true;
					urlPara.searchDynKit	= true;
				}

				if ("<%=searchType%>" == "notItem") 
					urlPara.searchItem	= false;
 			}
  		} else {
	  		urlPara.searchProduct   = document.all.searchProduct.checked;
	  		urlPara.searchItem      = document.all.searchItem.checked;
	  		urlPara.searchPackage	= document.all.searchPackage.checked;
	  		urlPara.searchBundle	= document.all.searchBundle.checked;
	  		urlPara.searchDynKit	= document.all.searchDynKit.checked;
	  	}
	  	
	  	
		if(goback=="true")
			goBackWithParameters(urlPara);
		else if(strActionEP=="GO_BACK")
			goBackWithParametersWithoutChangingTitle(urlPara);
		else	
			top.setContent("<%=redirectTitle%>",url,true, urlPara);     

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
INPUT.input {width:200px;}
SELECT.input {width:"auto";}	
	.stylingFrame {margin-top:0px;margin-bottom:0px;}
	.topForm {margin-bottom:0px;margin-top:1px}
</STYLE>

<H1>
<% if (searchType.equals("product")) { %>
	<%=categoryFindNLS.get("catalogSearch_productSearch")%>
<% } else if (searchType.equals("item")) { %>
	<%=categoryFindNLS.get("catalogSearch_itemSearch")%>
<% } else if (searchType.equals("package")) { %>
	<%=categoryFindNLS.get("catalogSearch_packageSearch")%>
<% } else { %>
	<%=categoryFindNLS.get("catentrySearchTitle")%>
<% } %>
</H1>

<%=categoryFindNLS.get("catentrySearchInstruction")%>

<FORM NAME="searchForm" ACTION="" CLASS="topForm" METHOD="post">


<TABLE BORDER=0>
	<TR>
	   <TD COLSPAN=3><LABEL for="sku"><%=categoryFindNLS.get("catalogSearch_SKU")%></LABEL></TD>
	</TR>
	<TR>
	   <TD><INPUT TYPE="text" ID="sku" NAME="sku" CLASS="input" MAXLENGTH="64"></TD>
	   <TD>&nbsp;<LABEL for="skuOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("catalogSearch_SKU")) %></SPAN></LABEL></TD>
	   <TD> 
	   	<SELECT ID="skuOp" NAME="skuOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=categoryFindNLS.get("catalogSearch_operator_like")%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=categoryFindNLS.get("catalogSearch_operator_exact")%></OPTION>
	  	</SELECT>
	   </TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	  <TD COLSPAN=3><LABEL for="name"><%=categoryFindNLS.get("catalogSearch_name")%></LABEL></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="name" NAME="name" CLASS="input" MAXLENGTH="64"></TD>
	  <TD>&nbsp;<LABEL for="nameOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("catalogSearch_name")) %></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="nameOp" NAME="nameOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=categoryFindNLS.get("catalogSearch_operator_like")%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=categoryFindNLS.get("catalogSearch_operator_exact")%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR>
	  <TD COLSPAN=3>&nbsp;<INPUT TYPE="checkbox" ID="searchScope" NAME="searchScope"><LABEL for="searchScope"><%=categoryFindNLS.get("catalogSearch_include_desc")%></LABEL></TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	   <TD COLSPAN=3><LABEL for="manNum"><%=categoryFindNLS.get("catalogSearch_manufacturer_partnumber")%></LABEL></TD></TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="manNum" NAME="manuNum" CLASS="input" MAXLENGTH="64"></TD>
	  <TD>&nbsp;<LABEL for="manuNumOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("catalogSearch_manufacturer_partnumber")) %></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="manuNumOp" NAME="manuNumOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=categoryFindNLS.get("catalogSearch_operator_like")%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=categoryFindNLS.get("catalogSearch_operator_exact")%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	   <TD COLSPAN=3><LABEL for="manuName"><%=categoryFindNLS.get("catalogSearch_manufacturer")%></LABEL></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="manuName" NAME="manuName" CLASS="input" MAXLENGTH="64"></TD>
	  <TD>&nbsp;<LABEL for="manuNameOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("catalogSearch_manufacturer")) %></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="manuNameOp" NAME="manuNameOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=categoryFindNLS.get("catalogSearch_operator_like")%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=categoryFindNLS.get("catalogSearch_operator_exact")%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR><TD></TD></TR>
	<TR>
	  <TD><LABEL for="catalogID"><%=categoryFindNLS.get("catalogSearch_catalog")%></LABEL></TD>
	</TR>
	<TR>
	  <TD COLSPAN=3>
	  	<SELECT ID="catalogID" NAME="catalogID" CLASS='input' style="width:auto">
		<%
	  		Vector catalogList = getCatalogList(storeId);
	  		for (int i=0; i<catalogList.size(); i++) {  
	  			String catID = ((com.ibm.commerce.catalog.objects.CatalogAccessBean)(catalogList.get(i))).getCatalogReferenceNumber();%>
	  			<OPTION VALUE="<%=catID%>"
	  			<% if (catalogID != null && catalogID.equals(catID)) {%>
	  				SELECTED
	  			<% } %>
	  			> 
	  			<% 
	  				String strCatalogName=null;
	  				try{
	  					strCatalogName=((com.ibm.commerce.catalog.objects.CatalogAccessBean)(catalogList.get(i))).getDescription(langId, storeId).getName();
	  				}catch (Exception ex){
	  				}
	  				if ((strCatalogName==null) || (strCatalogName.trim().length()==0))	
	  				{
	  				    CatalogAccessBean aCatalogAB = new CatalogAccessBean();
	  				    aCatalogAB.setInitKey_catalogReferenceNumber(catID);
	  					strCatalogName= aCatalogAB.getIdentifier();
	  				}
	  			%>
	  			<%=UIUtil.toHTML(strCatalogName)%>
	  	<%	}
	  	%>
	  	
	  	</SELECT>
	  </TD>
	</TR>
	<TR><TD></TD></TR>
	<TR>
	  <TD><LABEL for="category"><%=categoryFindNLS.get("catalogSearch_category")%></LABEL></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="category" NAME="category" CLASS="input" MAXLENGTH="254"></TD>
	  <TD><LABEL for="categoryOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)categoryFindNLS.get("catalogSearch_category")) %></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="categoryOp" NAME="categoryOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=categoryFindNLS.get("catalogSearch_operator_like")%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=categoryFindNLS.get("catalogSearch_operator_exact")%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="checkbox" ID="published" NAME="published"><LABEL for="published"><%=categoryFindNLS.get("catalogSearch_published")%></LABEL></TD>
	  <TD></TD>
	  <TD><INPUT TYPE="checkbox" ID="notPublished" NAME="notPublished"><LABEL for="notPublished"><%=categoryFindNLS.get("catalogSearch_notPublished")%></LABEL></TD>
	</TR>  
	<TR><TD></TD></TR>
</TABLE>

<%
	if (searchType.equalsIgnoreCase("item")) {
%> <TABLE BORDER=0 STYLE="display:none"> <%
	} else {
%> <TABLE BORDER=0> <%
	}
%>
	<TR><TD COLSPAN=6><%=categoryFindNLS.get("catalogSearch_searchType")%></TD></TR>
	<TR>
	  <TD COLSPAN=6>
	  	<INPUT TYPE="radio" NAME="searchType" id="searchTypeId1" VALUE="all" ONCLICK="searchTypes();" CHECKED>
	  	
		<% if (searchType.equals("product")) { %>
			<label for="searchTypeId1"><%=categoryFindNLS.get("catalogSearch_selectProductSearch")%></label>
		<% } else if (searchType.equals("package")) { %>
			<label for="searchTypeId1"><%=categoryFindNLS.get("catalogSearch_selectPackageSearch")%></label>
		<% } else if (searchType.equals("notItem")) { %>
			<label for="searchTypeId1"><%=categoryFindNLS.get("catalogSearch_selectNoItemSearch")%></label>
		<% } else if (searchType.equals("item")) { %>
			<label for="searchTypeId1"><%=categoryFindNLS.get("catalogSearch_selectItemSearch")%></label>
		<% } else { %>
			<label for="searchTypeId1"><%=categoryFindNLS.get("catalogSearch_searchAll")%></label>
		<% } %>
	  	
	  </TD>
	</TR>
	<TR>
	  <TD COLSPAN=6>
	  	<INPUT TYPE="radio" NAME="searchType" id="searchTypeId2" VALUE="types" ONCLICK="searchTypes();"><label for="searchTypeId2"><%=categoryFindNLS.get("catalogSearch_searchSpecifiedType")%></label>
	  </TD>
	</TR>
</TABLE>
</FORM>

<FORM NAME="typeFrame" STYLE="display:none" CLASS="stylingFrame">
<TABLE BORDER=0 ID=searchTypeTable>
	<TR>
	  <TD>&nbsp;</TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:30px;" ID="searchProduct" NAME="searchProduct"><LABEL for="searchProduct"><%=categoryFindNLS.get("catalogSearch_searchProduct")%></LABEL></TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:30px;" ID="searchItem" NAME="searchItem"><LABEL for="searchItem"><%=categoryFindNLS.get("catalogSearch_searchItem")%></LABEL></TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:30px;" ID="searchPackage" NAME="searchPackage"><LABEL for="searchPackage"><%=categoryFindNLS.get("catalogSearch_searchPackage")%></LABEL></TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:30px;" ID="searchBundle" NAME="searchBundle"><LABEL for="searchBundle"><%=categoryFindNLS.get("catalogSearch_searchBundle")%></LABEL></TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:30px;" ID="searchDynKit" NAME="searchDynKit"><LABEL for="searchDynKit"><%=categoryFindNLS.get("catalogSearch_searchDynKit")%></LABEL></TD>
	</TR>
</TABLE>
</FORM>

<FORM CLASS="stylingFrame">
<TABLE BORDER=0>
  <TR><TD></TD></TR>
  <TR>
  	<TD><LABEL for="displayNum"><%=categoryFindNLS.get("catalogSearch_displayNum")%></LABEL></TD>
  	<TD>&nbsp;</TD>
  	<TD>
  		<SELECT ID="displayNum" NAME="displayNum">
  		<OPTION VALUE="25">25
  		<OPTION VALUE="50">50
  		<OPTION VALUE="100">100
  		<OPTION VALUE="150">150
  		<OPTION VALUE="250">250
  		</SELECT>
  	</TD>
  </TR>
  <!-- Defect 95325 Remove Sort Option from page due to only one default choice. -->
  <INPUT TYPE="hidden" NAME="sortBy" VALUE=<%=categoryFindNLS.get("catalogSearch_sortBySKU")%>>
  <% /* Defect 95325 - Remove Sort Option from page due to only one default choice. %>
  <TR>
  	<TD><LABEL for="sortBy"><%=categoryFindNLS.get("catalogSearch_sortBy")%></LABEL></TD>
  	<TD>&nbsp;</TD>
  	<TD>
		<SELECT ID="sortBy" NAME="sortBy">
		<OPTION VALUE="SKU"><%=categoryFindNLS.get("catalogSearch_sortBySKU")%>
		<%--<OPTION VALUE="Name"><%=categoryFindNLS.get("catalogSearch_sortByName")%> --%>
  		</SELECT>
  	</TD>
  </TR>
  <% */ %>
</TABLE>
</FORM>

</BODY>
</HTML>

