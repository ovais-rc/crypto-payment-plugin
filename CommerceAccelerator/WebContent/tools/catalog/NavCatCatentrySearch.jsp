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

<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 	= cmdContext.getLocale();
    Integer storeId = cmdContext.getStoreId();
    Integer langId	= cmdContext.getLanguageId();
    Hashtable rbCategory = (Hashtable) ResourceDirectory.lookup("catalog.CategoryNLS", jLocale);

	JSPHelper jspHelper 	= new JSPHelper(request);
	
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">

<TITLE><%=UIUtil.toHTML((String)rbCategory.get("NavCatCatentrySearchDialog_Title"))%></TITLE>

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
		document.all.sku.focus();
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
		adjustInputClassDropdownWidth(document.all.catalogID);
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// resetButton()
	//
	// - reset the fields of the form
	//////////////////////////////////////////////////////////////////////////////////////
	function resetButton()
	{
		document.searchForm.reset();
		searchTypes();
	}

	var searchParam = new Object();
	
	//////////////////////////////////////////////////////////////////////////////////////
	// searchButton()
	//
	// - 
	//////////////////////////////////////////////////////////////////////////////////////
	function searchButton() 
	{
		if(checkTypes()!=true)
			return false;
		
		searchParam.listsize	= '20';
		searchParam.startIndex	= '0';
  		searchParam.orderby		= 'CatEntryType';	//SKU	//document.all.sortBy.value;
  		searchParam.displayNum	= searchParam.listsize; 	//document.all.displayNum.value;
		
  		//searchParam.actionEP	= "";
  		searchParam.catID		= document.all.catalogID.value;
  		searchParam.category	= document.all.category.value;
  		searchParam.categoryOp	= document.all.categoryOp.value;
  		searchParam.sku         = document.all.sku.value;
  		searchParam.skuOp		= document.all.skuOp.value;
  		searchParam.name		= document.all.name.value;
  		searchParam.nameOp		= document.all.nameOp.value;
  		searchParam.searchScope	= document.all.searchScope.checked;
  		searchParam.manuNum		= document.all.manuNum.value;
  		searchParam.manuNumOp	= document.all.manuNumOp.value;
  		searchParam.manuName	= document.all.manuName.value;
  		searchParam.manuNameOp	= document.all.manuNameOp.value;
  		searchParam.CEpublished	= document.all.published.checked;
  		searchParam.CEnotPublished	= document.all.notPublished.checked;

  		searchParam.languageId	= "<%=langId%>";
  	   	searchParam.storeId		= "<%=storeId.toString()%>";

  		searchParam.searchType	= "notItem";
  		if(document.searchForm.searchType[0].checked)
  		{
			searchParam.searchProduct   = true;
			searchParam.searchItem      = top.get("ExtFunctionSKU",false);	// no item uless the extFunc is enabled
			searchParam.searchPackage	= true;
			searchParam.searchBundle	= true;
			searchParam.searchDynKit	= true;
  		}
  		else
  		{
			searchParam.searchProduct   = document.all.searchProduct.checked;
			if(top.get("ExtFunctionSKU",false))
				searchParam.searchItem=document.all.searchItem.checked;
			else	
				searchParam.searchItem= false;	
			searchParam.searchPackage	= document.all.searchPackage.checked;
			searchParam.searchBundle	= document.all.searchBundle.checked;
			searchParam.searchDynKit	= document.all.searchDynKit.checked;
		}
		
		parent.setCatentrySearchResults(searchParam);
		
		return true;
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
		parent.catentrySearchButtonsFrame.searchButton();
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// searchTypes()
	// - display catentry search types only when specific option is chosen
	//////////////////////////////////////////////////////////////////////////////////////
	function searchTypes() 
	{
		if (document.searchForm.searchType[0].checked) 
		{
			document.all.typeFrame.style.display = "none";
		} 
		else 
		{
			for (var i=1; i<searchTypeTable.rows(0).cells.length; i++)
			{
				if (searchTypeTable.rows(0).cells(i).firstChild.disabled)
				{
					searchTypeTable.rows(0).cells(i).style.display = "none";
				}
			}
			document.all.typeFrame.style.display = "block";
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////
	// checkTypes()
	// - This function check to make sure at least 1 type is selected for search
	//////////////////////////////////////////////////////////////////////////////////////
	function checkTypes() {
	    if( document.searchForm.searchType[0].checked != true)
			if (! ( document.typeFrame.searchProduct.checked 
		           || document.typeFrame.searchPackage.checked 
		           || document.typeFrame.searchBundle.checked 
		           || document.typeFrame.searchDynKit.checked
		           ||(top.get("ExtFunctionSKU",false)&& document.all.searchItem.checked)))
			{
				alertDialog("<%=UIUtil.toJavaScript((String)rbCategory.get("catalogSearch_searchSpecifiedType"))%>");
				return false;
			}		
	
		return true;
	}

</SCRIPT>

<STYLE TYPE='text/css'>
INPUT.input {width:200px;}
SELECT.input {width:"auto";}	
	.stylingFrame {margin-top:0px;margin-bottom:0px;}
	.topForm {margin-bottom:0px;margin-top:1px}
</STYLE>

</HEAD>

<BODY CLASS=content ONLOAD=onLoad() ONKEYPRESS=handleEnterPressed() ONCONTEXTMENU="return false;">

<H1>
	<%= UIUtil.toHTML((String)rbCategory.get("catentrySearchTitle"))%>
</H1>

<%= rbCategory.get("catentrySearchInstruction")%>

<br>

<FORM NAME="searchForm" ACTION="" CLASS="topForm" METHOD="post">


<TABLE BORDER=0>
	<TR>
	   <TD COLSPAN=3><LABEL for="sku"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_SKU"))%></LABEL></TD>
	</TR>
	<TR>
	   <TD><INPUT TYPE="text" ID="sku" NAME="sku" CLASS="input" MAXLENGTH="64"></TD>
	   <TD>&nbsp;<LABEL for="skuOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_SKU"))%></SPAN></LABEL></TD>
	   <TD> 
	   	<SELECT ID="skuOp" NAME="skuOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_like"))%></OPTION>
	  	<OPTION VALUE="EQUAL"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_exact"))%></OPTION>
	  	</SELECT>
	   </TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	  <TD COLSPAN=3><LABEL for="name"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_name"))%></LABEL></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="name" NAME="name" CLASS="input" MAXLENGTH="64"></TD>
	  <TD>&nbsp;<LABEL for="nameOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_name"))%></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="nameOp" NAME="nameOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_like"))%></OPTION>
	  	<OPTION VALUE="EQUAL"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_exact"))%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR>
	  <TD COLSPAN=3>&nbsp;<INPUT TYPE="checkbox" ID="searchScope" NAME="searchScope"><LABEL for="searchScope"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_include_desc"))%></LABEL></TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	   <TD COLSPAN=3><LABEL for="manuNum"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_manufacturer_partnumber"))%></LABEL></TD></TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="manuNum" NAME="manuNum" CLASS="input" MAXLENGTH="64"></TD>
	  <TD>&nbsp;<LABEL for="manuNumOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_manufacturer_partnumber"))%></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="manuNumOp" NAME="manuNumOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_like"))%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_exact"))%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR><TD></TD></TR>
	
	<TR>
	   <TD COLSPAN=3><LABEL for="manuName"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_manufacturer"))%></LABEL></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="manuName" NAME="manuName" CLASS="input" MAXLENGTH="64"></TD>
	  <TD>&nbsp;<LABEL for="manuNameOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_manufacturer"))%></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="manuNameOp" NAME="manuNameOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_like"))%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_exact"))%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR><TD></TD></TR>
	<TR>
	  <TD><LABEL for="catalogID"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_catalog"))%></LABEL></TD>
	</TR>
	<TR>
	  <TD COLSPAN=3>
	  	<SELECT ID="catalogID" NAME="catalogID" CLASS='input'>
		<%
	  		Vector catalogList = getCatalogList(storeId);
	  		String strCatalogName;
	  		for (int i=0; i<catalogList.size(); i++) {  
	  			String catID = ((com.ibm.commerce.catalog.objects.CatalogAccessBean)(catalogList.get(i))).getCatalogReferenceNumber();%>
	  			<OPTION VALUE="<%=catID%>"> 
	  			<%{
	  				strCatalogName=null;
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
	  			}%>
	  			<%=UIUtil.toHTML(strCatalogName)%>
	  	<%	}
	  	%>
	  	
	  	</SELECT>
	  </TD>
	</TR>
	<TR><TD></TD></TR>
	<TR>
	  <TD><LABEL for="category"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_category"))%></LABEL></TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="text" ID="category" NAME="category" CLASS="input" MAXLENGTH="254"></TD>
	  <TD><LABEL for="categoryOp"><SPAN STYLE="display:none;"><%= UIUtil.toHTML((String)rbCategory.get("catalogSearch_category"))%></SPAN></LABEL></TD>
	  <TD>
	  	<SELECT ID="categoryOp" NAME="categoryOp" CLASS="input">
	  	<OPTION VALUE="LIKE"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_like"))%></OPTION>
	  	<OPTION VALUE="EQUAL"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_operator_exact"))%></OPTION>
	  	</SELECT>
	  </TD>
	</TR>
	<TR>
	  <TD><INPUT TYPE="checkbox" ID="published" NAME="published"><LABEL for="published"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_published"))%></LABEL></TD>
	  <TD></TD>
	  <TD><INPUT TYPE="checkbox" ID="notPublished" NAME="notPublished"><LABEL for="notPublished"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_notPublished"))%></LABEL></TD>
	</TR>  
	<TR><TD></TD></TR>
</TABLE>

<TABLE BORDER=0> 
	<TR><TD COLSPAN=6><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_searchType"))%></TD></TR>
	<TR>
	  <TD COLSPAN=6>
	  	<INPUT TYPE="radio" ID="catalogSearch_selectNoItemSearch" NAME="searchType" VALUE="all" ONCLICK="searchTypes();" CHECKED>

	  	<script>
	  	if(top.get("ExtFunctionSKU",false))
	  		document.writeln(" <LABEL for=\"catalogSearch_selectNoItemSearch\"><%=UIUtil.toJavaScript((String)rbCategory.get("catalogSearch_searchAll"))%></LABEL>");
	  	else
			document.writeln(" <LABEL for=\"catalogSearch_selectNoItemSearch\"><%=UIUtil.toJavaScript((String)rbCategory.get("catalogSearch_selectNoItemSearch"))%></LABEL>");
		</script>
			
	  </TD>
	</TR>
	<TR>
	  <TD COLSPAN=6>
	  	<INPUT TYPE="radio" ID="catalogSearch_searchSpecifiedType" NAME="searchType" VALUE="types" ONCLICK="searchTypes();">
	  		<LABEL for="catalogSearch_searchSpecifiedType"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_searchSpecifiedType"))%></LABEL>
	  </TD>
	</TR>
</TABLE>
</FORM>

<FORM NAME="typeFrame" STYLE="display:none" CLASS="stylingFrame">
<TABLE BORDER=0 ID=searchTypeTable>
	<TR>
	  <TD>&nbsp;</TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:5px;" ID="searchProduct" NAME="searchProduct"><LABEL for="searchProduct"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_searchProduct"))%></LABEL></TD>
	  
	  <script>
	  if(top.get("ExtFunctionSKU",false))
	  	document.writeln(" <TD><INPUT TYPE=\"checkbox\" STYLE=\"margin-left:5px;\" ID=\"searchItem\" NAME=\"searchItem\"><LABEL for=\"searchItem\"><%=rbCategory.get("catalogSearch_searchItem")%></LABEL></TD>");
	  </script>
	  
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:5px;" ID="searchPackage" NAME="searchPackage"><LABEL for="searchPackage"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_searchPackage"))%></LABEL></TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:5px;" ID="searchBundle" NAME="searchBundle"><LABEL for="searchBundle"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_searchBundle"))%></LABEL></TD>
	  <TD><INPUT TYPE="checkbox" STYLE="margin-left:5px;" ID="searchDynKit" NAME="searchDynKit"><LABEL for="searchDynKit"><%=UIUtil.toHTML((String)rbCategory.get("catalogSearch_searchDynKit"))%></LABEL></TD>
	</TR>
</TABLE>
</FORM>

</BODY>
</HTML>

