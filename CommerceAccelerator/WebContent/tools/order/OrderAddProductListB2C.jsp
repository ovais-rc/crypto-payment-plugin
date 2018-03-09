<%-- 
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>

<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.helpers.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@include file="../../tools/common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
   	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   	Locale jLocale 		= cmdContextLocale.getLocale();
   	String currency		= cmdContextLocale.getCurrency();
   	Hashtable orderAddProducts 	= (Hashtable)ResourceDirectory.lookup("order.orderAddProducts", jLocale);

	// retrieve request parameters
	JSPHelper jspHelper 	= new JSPHelper(request);
	String customerId	= jspHelper.getParameter("customerId");
	String searchProductDesc = jspHelper.getParameter("searchProductDesc");
	String descSearchType    = jspHelper.getParameter("descSearchType");
	String searchProductName = jspHelper.getParameter("searchProductName");
	String nameSearchType    = jspHelper.getParameter("nameSearchType");
	String searchSKUNumber   = jspHelper.getParameter("searchSKUNumber");
	String skuSearchType     = jspHelper.getParameter("skuSearchType");
	String searchType        = jspHelper.getParameter("searchType");
	String searchMaxMatches  = jspHelper.getParameter("searchMaxMatches");
	
	String cusCurrency = new String();
	UserRegistrationDataBean userDataBean = new UserRegistrationDataBean();
	
	userDataBean.setUserId(customerId);
	com.ibm.commerce.beans.DataBeanManager.activate(userDataBean, request);
	cusCurrency = userDataBean.getPreferredCurrency();
	
	if (cusCurrency != null && !cusCurrency.equals("")) {
		currency = cusCurrency;
	}
	
	//get product search bean
	ProductListBean pList = new ProductListBean();
	pList.setNameLike(searchProductName);
	pList.setNameSearchType(nameSearchType);
	pList.setSKULike(searchSKUNumber);
	pList.setSkuSearchType(skuSearchType);
	pList.setDescLike(searchProductDesc);
	pList.setDescSearchType(descSearchType);
	pList.setSearchTypes(searchType);
	pList.setMaxMatches(searchMaxMatches);
	pList.setOrderBy("name");
	pList.setShopperId(customerId);
	pList.setCommandContext(cmdContextLocale);
	pList.setCurrency(currency);
	pList.setUsage("new");
	
	com.ibm.commerce.beans.DataBeanManager.activate(pList, request);
	
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>

<html>
<head>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 

<title><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageList")) %></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script language="JavaScript" type="text/javascript">
	<!-- <![CDATA[

//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------
function initializeState() {
	parent.setContentFrameLoaded(true);
}

function getResultsSize() {
	return <%=pList.getListSize() %>;
}


//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------
function add() {
	var itemForm = document.itemListForm;
	var totalSize = getResultsSize();
	var catentryId;

	if (totalSize > 0) {
		if (totalSize != 1) {
			for (var j=0; j<totalSize; j++) {
				if (itemForm["selectedProduct"][j].checked) 
					catentryId = itemForm["selectedProduct"][j].value;
			}
		} else {
			catentryId = itemForm["selectedProduct"].value;
		}

		var searchResultURL 		= "/webapp/wcs/tools/servlet/DialogView"
		var URLParam = new Object();
		URLParam.customerId					= "<%=customerId%>";
		URLParam.currency					= "<%=currency%>";
		URLParam["<%= OrderConstants.EC_CATENTRY_ID %>"]	= catentryId;
	
		if (itemForm["Type_"+catentryId].value == "ItemBean")
			URLParam.XMLFile = "order.orderAddProductItemDetailsDialogB2C";
		else if (itemForm["Type_"+catentryId].value == "ProductBean")
			URLParam.XMLFile = "order.orderAddProductProductDetailsDialogB2C";
		else if (itemForm["Type_"+catentryId].value == "PackageBean")
			URLParam.XMLFile = "order.orderAddProductPackageDetailsDialogB2C";
		else if (itemForm["Type_"+catentryId].value == "BundleBean")
			URLParam.XMLFile = "order.orderAddProductBundleDetailsDialogB2C";
		
		//top.saveData(URLParam,"OrderProductSearchURLParam");
		top.mccmain.submitForm(searchResultURL,URLParam);
 		top.refreshBCT();
	}
	else {
		//display a message to indicate that no items are listed...
		alertDialog("<%= UIUtil.toJavaScript((String)orderAddProducts.get("addProductPageListNoItemsSelected")) %>");
		return;
	}
}

function closeDialog()
{
	top.goBack();
}
//[[>-->
</script>
</head>


<body class="content" onload="initializeState();">
<h1><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageList")) %></h1>
<form name="itemListForm">	
	<%= (String)orderAddProducts.get("addProductPageListDescription") %>
	<br /><br />

	<table class="list" border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr class="list_roles">
	<th width="5%" class="list_header">
	</th>	
	<th width="25%" class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageName")) %>
	</th>
	<th width="20%" class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageSKU")) %>
	</th>
	<th width="30%" class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageDescription")) %>
	</th>
	<th width="20%" class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageType")) %>
	</th>
	</tr>	

	<%
	int rowselect = 1;
	String classStr = "list_row1";
	for (int i=0; i<pList.getListSize(); i++)
	{
		String checked = "";
		if (i == 0) {
			checked = "checked";
		}
		
		String labelName = "productName" + i;
	%>
		<tr class="<%= classStr %>">
			<td>
			<input type="radio" id="<%= labelName %>" name="selectedProduct" <%= checked %> value="<%= pList.getProductListData(i).getCatentryId() %>" />
			</td>
			<td>
			<label for="<%= labelName %>"><%= pList.getProductListData(i).getName() %></label>
			</td>
			<td>
			<%= pList.getProductListData(i).getPartNumber() %>
			</td>
			<td>
			<%= pList.getProductListData(i).getDescription() %>
			</td>
			<td>
			<%= UIUtil.toHTML((String)orderAddProducts.get(pList.getProductListData(i).getType().trim())) %>
			<script type="text/javascript">
			<!-- <![CDATA[
			document.writeln('<INPUT type="hidden" name="Type_<%= pList.getProductListData(i).getCatentryId() %>" value="<%= pList.getProductListData(i).getType() %>" >');
			//[[>-->
			</script>
			</td>
		</tr>
		<% 
		if (rowselect == 1) {
			rowselect = 2;
			classStr = "list_row2";
		} else {
			rowselect = 1;
			classStr = "list_row1";
		}
	} 
	%>
	</table>
<%
	if (pList.getListSize() == 0) {
%>

<p></p><p></p>
<table cellspacing="0" cellpadding="3" border="0">
<tr>
	<td colspan="7">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageListNoItemsFound")) %>
	</td>
</tr>
</table>
<% 	} %>

</form>
</body>
</html>
