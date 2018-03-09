<!-- rfq_response_catentry_search_dialog.jsp -->
<!--  
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="java.util.*" %> 
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ include file="../common/common.jsp" %>

<%!
    public Vector getCatalogList(Integer storeID) 
    {
	Vector catalogList = new Vector();
	CatalogDataBean catalogs = new CatalogDataBean();
	try {
	    Enumeration e = catalogs.findByStoreId(storeID);
	    while (e.hasMoreElements()) {
		CatalogAccessBean catalog = (CatalogAccessBean) e.nextElement();
		catalogList.addElement(catalog);
	    }
	} catch (Exception ex) {
	    ECTrace.trace(ECTraceIdentifiers.COMPONENT_RFQ, "rfq_response_catentry_search_dialog.jsp", "getCatalogList", "Exception getting catalog list in title");
	}	
	return catalogList;
    }
%>

<%
    CommandContext cmdContextLocale = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContextLocale.getLocale();
    Integer storeId = cmdContextLocale.getStoreId();
    Integer langId = cmdContextLocale.getLanguageId();
    Hashtable rfqNLS = (Hashtable) ResourceDirectory.lookup("rfq.rfqNLS", jLocale);
    
    JSPHelper jspHelper = new JSPHelper(request);	
    
    String redirectURL = jspHelper.getParameter("redirectURL");
    String redirectCmd = jspHelper.getParameter("redirectCmd");
    String redirectXML = jspHelper.getParameter("redirectXML");	
    
    String catalogID = jspHelper.getParameter("catID");	
    
    String allStores = jspHelper.getParameter("allStores");	
    if ((redirectURL==null) || (redirectURL.length()==0)) {
        redirectURL = "/webapp/wcs/tools/servlet/NewDynamicListView" ;
    }
    if ((redirectCmd==null) || (redirectCmd.length()==0)) {
        redirectCmd = "RFQResponseCatentrySearchResult";
    }
    if ((redirectXML==null)|| (redirectXML.length()==0)) {
    	redirectXML = "rfq.rfqResponseCatentrySearchResult";
    }
    String redirectTitle = (String)rfqNLS.get("catalogSearch_resultTitle_sampleProduct");
    String searchType = "item";
    String catentry_id = jspHelper.getParameter("catentry_id");
    if ((catentry_id.equals("undefined") || catentry_id == null) || (catentry_id.length()==0)) {
    	catentry_id = "";
    }
    String type ="";
    if (! catentry_id.equals(""))	{					
	CatalogEntryAccessBean ceAB = new CatalogEntryAccessBean();
	ceAB.setInitKey_catalogEntryReferenceNumber(catentry_id);					

	type = ceAB.getType();
	if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) searchType = "item";
	if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) searchType = "product";	
	if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) searchType = "package";	
	if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_BUNDLEBEAN)) searchType = "bundle";				
	if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) searchType = "dynamicKit";				
    } 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<style type='text/css'>
    .input {width:300px;}
    .stylingFrame {margin-top:0px;margin-bottom:0px;}
    .topForm {margin-bottom:0px;margin-top:1px}
</style>
<title><%=rfqNLS.get("catentrySearchTitle")%></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script type="text/javascript">
    var endresult_to_contract = top.getData("endresult_to_contract",1);
    if (endresult_to_contract == undefined)
    {
        endresult_to_contract = false;
    }

    function onLoad() 
    {
	selectDefaultCatentryTypes();
	parent.setContentFrameLoaded(true);	
    }

    function cleanForm() 
    {
	document.searchForm.reset();
    }

    function validateEntries() 
    {
	return true;
    }

    function findAction() 
    {
	if (validateEntries() == true) 
	{
	    url = "<%=redirectURL%>";
	    var urlPara = new Object();
	    urlPara.listsize	= '22';
	    urlPara.startindex	= '0';
	    urlPara.cmd		= "<%=redirectCmd%>";
	    urlPara.ActionXMLFile = "<%=redirectXML%>";
  	    urlPara.XMLFile	= "<%=redirectXML%>";
  	    urlPara.searchType	= "catentry";
  	    urlPara.actionEP	= "";
  	    urlPara.catID	= document.all.catalogID.value;
  	    urlPara.category	= document.all.category.value;
  	    urlPara.categoryOp	= document.all.categoryOp.value;
  	    urlPara.sku         = document.all.sku.value;
  	    urlPara.skuOp	= document.all.skuOp.value;
  	    urlPara.name	= document.all.name.value;
  	    urlPara.nameOp	= document.all.nameOp.value;
  	    urlPara.searchScope	= true;
  	    urlPara.manuNum	= document.all.manuNum.value;
      	    urlPara.manuNumOp	= document.all.manuNumOp.value;
  	    urlPara.manuName	= document.all.manuName.value;
  	    urlPara.manuNameOp	= document.all.manuNameOp.value;
  	    urlPara.CEpublished	= document.all.published.value;
  	    urlPara.CEnotPublished = document.all.notPublished.value;
  	    urlPara.displayNum	= document.all.displayNum.value;
  	    urlPara.orderby	= document.all.sortBy.value; 
 	    if ("<%=allStores%>" != "true") 
    		urlPara.storeId	= "<%=storeId%>";
    		
    	    if (document.searchForm.searchType[0].checked) 
	    {
  		if ("<%=searchType%>" == "item" || 
		    "<%=searchType%>" == "package") 
		{
		    urlPara.searchItem	= true;
		    urlPara.searchPackage = true;
		} else {
		    if ("<%=searchType%>" == "notItem") 
			urlPara.searchItem = false;
		    else
		        urlPara.searchItem = true;
		    urlPara.searchPackage = true;
		    if (endresult_to_contract) 
		    {
	 		urlPara.searchProduct = true;
		    }
 	        }
  	    } else {
	  	urlPara.searchItem      = document.all.searchItem.checked;
	  	urlPara.searchPackage	= document.all.searchPackage.checked;
	  	urlPara.searchProduct   = document.all.searchProduct.checked;
	  	urlPara.searchBundle	= document.all.searchBundle.checked;
	  	urlPara.searchDynKit	= document.all.searchDynKit.checked;
	    }   		
  	    
	    top.setContent("<%=redirectTitle%>",url,true, urlPara); 
  	    return true;
	}
	return false;
    }

    function cancelAction() 
    {
	top.goBack();
    }

    ///////////////////////
    // This function preselects the default catalog entry types for search
    ///////////////////////
    function selectDefaultCatentryTypes() 
    {
	if ("<%=searchType%>" == "package") {
	    document.all.searchPackage.checked = true; 
	    document.all.searchBundle.disabled = true;
	    document.all.searchDynKit.disabled = true;
		
	} else if ("<%=searchType%>" == "item") {
	    parent.setCurrentPanelAttribute("helpKey","MC.catalogTool.catentrySearchSKU.Help");
	    document.all.searchItem.checked = true;
	    document.all.searchProduct.disabled = true;
	    document.all.searchBundle.disabled = true;
	    document.all.searchDynKit.disabled = true;
		
	} else if ("<%=searchType%>" == "notItem") {
  	    document.all.searchItem.disabled = true;
	    document.all.searchProduct.checked = true;
		
	} else if ("<%=searchType%>" == "product") {
	    if (endresult_to_contract) 
	    {
		document.all.searchProduct.checked = true;
	    }
	    else
	    {
		document.all.searchItem.checked = true;
		document.all.searchProduct.disabled = true;
	    }
	    document.all.searchBundle.disabled = true;
	    document.all.searchDynKit.disabled = true;
		
	} else if ("<%=searchType%>" == "bundle") {
	    document.all.searchItem.checked = true;
	    document.all.searchProduct.disabled = true;
	    document.all.searchBundle.disabled = true;
	    document.all.searchDynKit.disabled = true;
		
	} else if ("<%=searchType%>" == "dynamicKit") {
	    document.all.searchItem.checked = true;
	    if (!endresult_to_contract) 
	    {
		document.all.searchProduct.disabled = true;
	    }
	    document.all.searchBundle.disabled = true;
	    document.all.searchDynKit.disabled = true;	
		
	} else {
	    document.all.searchProduct.checked = true;
	}

    }//End of defaultSelectedTypes()

    ////////////////////////
    // display catentry search types only when specific option is chosen
    ////////////////////////
    function searchTypes() 
    {
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
    function checkTypes() 
    {
	if (! ( document.typeFrame.searchProduct.checked | document.typeFrame.searchItem.checked 
              | document.typeFrame.searchPackage.checked | document.typeFrame.searchBundle.checked 
              | document.typeFrame.searchDynKit.checked))
	{
	    alertDialog("<%=UIUtil.toJavaScript((String)rfqNLS.get("catalogSearch_searchSpecifiedType"))%>");
	    selectDefaultCatentryTypes();
	    return false;
	}		
	else
	{
	    return true;
	}
    }
 
</script>
</head>

<body class="content" onload="onLoad();">

<h1>
    <%=rfqNLS.get("catentrySearchTitle")%>
</h1>

<%=rfqNLS.get("catentrySearchInstruction")%>

<form name="searchForm" action="" class="topForm" method="post">

<table border="0">
    <tr>
   	<td colspan="3">
	    <label for="sku"><%=rfqNLS.get("catalogSearch_SKU")%></label>
	</td>
    </tr>
    <tr>
   	<td><input type="text" name="sku" id="sku" class="input" maxlength="64" /></td>
	<td>&nbsp;</td>
	<td> 
	    <label for="skuOp"></label>
	    <select name="skuOp" id="skuOp" class="input">
	  	<option value="LIKE">
	 	    <%=rfqNLS.get("catalogSearch_operator_like")%>
		</option>
	  	<option value="EQUAL">
		    <%=rfqNLS.get("catalogSearch_operator_exact")%>
		</option>
	    </select>
	</td>
    </tr>
    <tr><td></td></tr>
    <tr>
  	<td colspan="3">
	    <label for="name"><%=rfqNLS.get("catalogSearch_name")%></label>
	</td>
    </tr>
    <tr>
	<td><input type="text" name="name" id="name" class="input" maxlength="64" /></td>
	<td>&nbsp;</td>
	<td>
	    <label for="nameOp"></label>
	    <select name="nameOp" id="nameOp" class="input">
	  	<option value="LIKE">
		    <%=rfqNLS.get("catalogSearch_operator_like")%>
		</option>
	  	<option value="EQUAL">
		    <%=rfqNLS.get("catalogSearch_operator_exact")%>
		</option>
	    </select>
	</td>
    </tr>
    <tr><td></td></tr>
    <tr>
   	<td colspan="3">
	    <label for="manuNum"><%=rfqNLS.get("catalogSearch_manufacturer_partnumber")%></label>
	</td>
    </tr>
    <tr>
  	<td><input type="text" name="manuNum" id="manuNum" class="input" maxlength="64" /></td>
  	<td>&nbsp;</td>
	<td>
	    <label for="manuNumOp"></label>
	    <select name="manuNumOp" id="manuNumOp" class="input">
	  	<option value="LIKE">
		    <%=rfqNLS.get("catalogSearch_operator_like")%>
		</option>
	  	<option value="EQUAL">
		    <%=rfqNLS.get("catalogSearch_operator_exact")%>
		</option>
	    </select>
	</td>
    </tr>
    <tr><td></td></tr>
    <tr>
   	<td colspan="3">
	    <label for="manuName"><%=rfqNLS.get("catalogSearch_manufacturer")%></label>
	</td>
    </tr>
    <tr>
	<td>
	    <input type="text" name="manuName" id="manuName" class="input" maxlength="64" />
	</td>
	<td>&nbsp;</td>
	<td>
  	    <label for="manuNameOp"></label>
  	    <select name="manuNameOp" id="manuNameOp" class="input">
	     	<option value="LIKE">
		    <%=rfqNLS.get("catalogSearch_operator_like")%>
		</option>
	  	<option value="EQUAL">
		    <%=rfqNLS.get("catalogSearch_operator_exact")%>
		</option>
	    </select>
	</td>
    </tr>
    <tr><td></td></tr>
    <tr>
  	<td>
	    <label for="catalogID"><%=rfqNLS.get("catalogSearch_catalog")%></label>
	</td>
    </tr>
    <tr>
	<td>
	    <select name="catalogID" id="catalogID" class='input'>
<%
    Vector catalogList = getCatalogList(storeId);
    for (int i=0; i<catalogList.size(); i++) 
    {  
  	String catID = ((CatalogAccessBean)(catalogList.get(i))).getCatalogReferenceNumber(); 
  
	if (catalogID != null && catalogID.equals(catID)) 
	{ 
%>
		<option value="<%=catID%>" selected="selected">
                <%=((CatalogAccessBean)(catalogList.get(i))).getDescription(langId).getName()%>
        	</option>
<%
	} 
	else
        {
%>
                <option value="<%=catID%>">
                <%=((CatalogAccessBean)(catalogList.get(i))).getDescription(langId).getName()%>
        	</option>
<%
        }
    }
%>
	    </select>
	</td>
    </tr>
    <tr><td></td></tr>
    <tr>
  	<td>
	    <label for="category"><%=rfqNLS.get("catalogSearch_category")%></label>
	</td>
    </tr>
    <tr>
  	<td>
	    <input type="text" name="category" id="category"class="input" maxlength="254" />
    	</td>
    	<td></td>
    	<td>
	    <label for="categoryOp"></label>
	    <select name="categoryOp" id="categoryOp" class="input">
	  	<option value="LIKE">
		    <%=rfqNLS.get("catalogSearch_operator_like")%>
		</option>
	  	<option value="EQUAL">
		    <%=rfqNLS.get("catalogSearch_operator_exact")%>
		</option>
	    </select>
  	</td>
    </tr>
    <tr>
  	<td>
	    <label for="published">
	    <input type="checkbox" name="published" id="published" />
	    <%=rfqNLS.get("catalogSearch_published")%>
	    </label>
	</td>
	<td></td>
	<td>
	    <label for="notPublished">
	    <input type="checkbox" name="notPublished" id="notPublished" />
	    <%=rfqNLS.get("catalogSearch_notPublished")%>
	    </label>
	</td>
    </tr>  
    <tr><td></td></tr>
    
    <!-- Search type -->
  	<tr><td colspan="6"><%=rfqNLS.get("catalogSearch_searchType")%></td></tr>
	<tr>
	  <td colspan="6">
	  	<label for="searchTypeAll">
	  	<input type="radio" name="searchType" id="searchTypeAll" value="all" onclick="searchTypes();" checked="checked" />
		<%=rfqNLS.get("catalogSearch_searchAll")%>
		</label>
	  	
	  </td>
	</tr>
    	<tr>
	  <td colspan="6">
	  	<label for="searchTypeTypes">
	  	<input type="radio" name="searchType" id="searchTypeTypes" value="types" onclick="searchTypes();" /><%=rfqNLS.get("catalogSearch_searchSpecifiedType")%>
	  	</label>
	  </td>
	</tr>
    
    <tr><td></td></tr>
</table>

</form>

<form name="typeFrame" style="display:none" class="stylingFrame" action="">
<table border="0" id="searchTypeTable">
	<tr>
	  <td>&nbsp;</td>
	  <td>
	  	<input type="checkbox" style="margin-left:30px;" name="searchProduct" id="searchProductType" />
	  	<label for="searchProductType">
	  	<%=rfqNLS.get("catalogSearch_searchProduct")%>
	  	</label>
	  </td>
	  <td>
	  	<input type="checkbox" style="margin-left:30px;" name="searchItem" id="searchItemType" />
	  	<label for="searchItemType">
	  	<%=rfqNLS.get("catalogSearch_searchItem")%>
	  	</label>
	  </td>
	  <td>
	  	<input type="checkbox" style="margin-left:30px;" name="searchPackage" id="searchPackageType" />
	  	<label for="searchPackageType">
	  	<%=rfqNLS.get("catalogSearch_searchPackage")%>
	  	</label>
	  </td>
	  <td>
	  	<input type="checkbox" style="margin-left:30px;" name="searchBundle" id="searchBundleType" />
	  	<label for="searchBundleType">
	  	<%=rfqNLS.get("catalogSearch_searchBundle")%>
	  	</label>
	  </td>
	  <td>
	  	<input type="checkbox" style="margin-left:30px;" name="searchDynKit" id="searchDynKitType" />
	  	<label for="searchDynKitType">
	  	<%=rfqNLS.get("catalogSearch_searchDynKit")%>
	  	</label>	  	
	  </td>
	</tr>
</table>
</form>

<form class="stylingFrame" action="">
<table border="0">
    <tr><td></td></tr>
    <tr>
  	<td><label for="displayNum"><%=rfqNLS.get("catalogSearch_displayNum")%></label></td>
  	<td>&nbsp;</td>
  	<td>
  	    <select name="displayNum" id="displayNum">
  		<option value="25">25</option>
  		<option value="50">50</option>
  		<option value="100">100</option>
  		<option value="250">250</option>
  		<option value="500">500</option>
  	    </select>
  	</td>
    </tr>
    <tr>
  	<td><label for="sortBy"><%=rfqNLS.get("catalogSearch_sortBy")%></label></td>
  	<td>&nbsp;</td>
  	<td>
	    <select name="sortBy" id="sortBy">
		<option value="SKU"><%=rfqNLS.get("catalogSearch_SKU")%></option>
		<option value="Name"><%=rfqNLS.get("catalogSearch_name")%></option>
  	    </select>
  	</td>
    </tr>
</table>
</form>

</body>
</html>
