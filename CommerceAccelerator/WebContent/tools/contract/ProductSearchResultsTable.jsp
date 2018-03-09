<!-- ==========================================================================
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
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.contract.beans.MemberDataBean,
	com.ibm.commerce.tools.contract.beans.ProductSearchListDataBean,
	com.ibm.commerce.user.beans.*,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.util.UIUtil,
	com.ibm.commerce.datatype.TypedProperty" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<%
	String ActionXMLFile = "";
	String _contractId = "";
	String catalogId = "";
	String categoryId = "";
	String categoryDisplayText = "";
	String searchActionType = "";
	String searchSelectionType = "";
	String targetView = "";
	String targetXML = "";
	String srCategoryName = "";
	String srCategoryShort = "";
	String srCategoryNameType = "";
	String srCategoryShortType = "";
	String srItemSku = "";
	String srItemName = "";
	String srItemShort = "";
	String srItemSkuType = "";
	String srItemNameType = "";
	String srItemShortType = "";
	String orderByParm = "";

	try {
		TypedProperty requestProperties = (TypedProperty)request.getAttribute("RequestProperties");
		if (requestProperties != null) {
			ActionXMLFile = (String)requestProperties.getString("ActionXMLFile");
			_contractId = (String)requestProperties.getString("contractId");
			catalogId = (String)requestProperties.getString("catalogId");
			categoryId = (String)requestProperties.getString("categoryId");
			categoryDisplayText = (String)requestProperties.getString("categoryDisplayText");
			searchActionType = (String)requestProperties.getString("searchActionType");
			searchSelectionType = (String)requestProperties.getString("searchSelectionType");
			targetView = (String)requestProperties.getString("targetView");
			targetXML = (String)requestProperties.getString("targetXML");
			srCategoryName = (String)requestProperties.getString("srCategoryName");
			srCategoryShort = (String)requestProperties.getString("srCategoryShort");
			srCategoryNameType = (String)requestProperties.getString("srCategoryNameType");
			srCategoryShortType = (String)requestProperties.getString("srCategoryShortType");
			srItemSku = (String)requestProperties.getString("srItemSku");
			srItemName = (String)requestProperties.getString("srItemName");
			srItemShort = (String)requestProperties.getString("srItemShort");
			srItemSkuType = (String)requestProperties.getString("srItemSkuType");
			srItemNameType = (String)requestProperties.getString("srItemNameType");
			srItemShortType = (String)requestProperties.getString("srItemShortType");

		        orderByParm = request.getParameter("orderby");
		}

	int numberOfResults = 0;
	if (orderByParm.length() == 0 && searchSelectionType.equals("CE")) {
		orderByParm = ProductSearchListDataBean.ORDER_BY_PRODUCT_NAME;
        }
	if (orderByParm.length() == 0 && searchSelectionType.equals("CG")) {
		orderByParm = ProductSearchListDataBean.ORDER_BY_CATEGORY_NAME;
        }
	ProductSearchListDataBean cList = new ProductSearchListDataBean();
	cList.setSearchType(searchSelectionType);
	cList.setStoreID(fStoreId.toString());
	cList.setLanguageID(fLanguageId);
	cList.setCatalogID(catalogId);
	cList.setOrderBy(orderByParm);
	cList.setContractID(_contractId);

	if (searchSelectionType.equals("CG")) {
		cList.setName(srCategoryName);
		cList.setNameLike(srCategoryNameType);
		cList.setShortDescription(srCategoryShort);
		cList.setShortDescriptionLike(srCategoryShortType);
	} else if (searchSelectionType.equals("CE")) {
      		cList.setPartNumber(srItemSku);
		cList.setPartNumberLike(srItemSkuType);
		cList.setName(srItemName);
		cList.setNameLike(srItemNameType);
		cList.setShortDescription(srItemShort);
		cList.setShortDescriptionLike(srItemShortType);
		//cList.setCategoryName(strCategoryName);
		//cList.setCategoryNameCaseSensitive(request.getParameter("categoryNameCaseSensitive"));
	}

	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;

	cList.setIndexBegin(""+startIndex);
	cList.setIndexEnd(""+endIndex);

	DataBeanManager.activate(cList, request);

	int totalsize = cList.getResultSetSize();
	int totalpage = (totalsize+listSize-1)/listSize;

	numberOfResults = totalsize;
	if (endIndex > numberOfResults) {
		endIndex = numberOfResults;
	}
%>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<title><%= contractsRB.get("contractProductSearchResultsTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Pricing.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
// retrieve from the price dialog's model
// the array put there for search results storage
var currentArray = top.getData("currentArray", null);
var resultContainer = new Array();
var resultIndex = 0;

if (currentArray == null) {
	currentArray = new Array();
}

function performAdd () {
	var skuArray = top.getData("finderSelectionArray", 1);
	var numberOfNewEntries = 0;
	var duplicateCheck = false;

	if (skuArray == null) {
		skuArray = new Object();
	}

	for (var i=0; i<currentArray.length; i++) {
		// if duplicate is found, do nothing and move to the next item
		for (var j=0; j<skuArray.length; j++) {
			if ((skuArray[j].type == "<%= searchSelectionType %>") && (skuArray[j].refnum == currentArray[i].id)) {
				duplicateCheck = true;
				break;
			}
		}
		if (!duplicateCheck) {
		        var displayText = currentArray[i].name;
		        
		        // if we are finding catentries and the name is null or empty, then
		        // we are going to set the displayText to be the  the identifier (SKU) into thy 
		        if ("<%= searchSelectionType %>" == "CE") {
		            if (isEmpty(displayText)) {
		                displayText = currentArray[i].identifier;
		            }
		            else {
		                displayText += " (" + currentArray[i].identifier + ")";
		            }
		        }
		        
			skuArray[skuArray.length] = new CatEntry(displayText, currentArray[i].id, currentArray[i].identifier, currentArray[i].Member, "<%= searchSelectionType %>");
		}
		else {
			duplicateCheck = false;
		}
	}

	if (currentArray.length > 0) {
		// go back to the finder's caller!
		top.goBack();
	}
	else {
	        if ("<%= searchSelectionType %>" == "CE") {
			alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductSearchAtLeastOneItem")) %>");
		} else {
			alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractPricingErrorSpecifyCategory")) %>");
		}
	}
}

// called when a checkbox is clicked
function performUpdate (isAll, checkObject) {
	var newIndex;
	var resultFound = false;

	if (isAll) {
		for (var i=0; i<resultContainer.length; i++) {
			for (var j=0; j<currentArray.length; j++) {
				// case 1: if deselect and current entry found, remove current entry
				// case 2: if select and current entry found, do nothing
				if (currentArray[j] != null) {
					if (resultContainer[i].id == currentArray[j].id) {
						resultFound = true;
						if (!checkObject.checked) {
							currentArray[j] = null;
							break;
						}
					}
				}
			}
			// case 3: if select and current entry not found, add current entry
			// case 4: if deselect and current entry not found, do nothing
			if (!resultFound) {
				if (checkObject.checked) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
				}
			}
			else {
				resultFound = false;
			}
		}
	}
	else {
		if (checkObject.checked) {
			for (var i=0; i<resultContainer.length; i++) {
				if (resultContainer[i].id == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].id == checkObject.name) {
					currentArray[i] = null;
					break;
				}
			}
		}
	}

	var tempArray = new Array();
	for (var i=0; i<currentArray.length; i++) {
		if (currentArray[i] != null) {
			tempArray[tempArray.length] = currentArray[i];
		}
	}
	currentArray = tempArray;

	top.saveData(currentArray, "currentArray");
}

// called when cancel button is clicked
function performCancel () {
	var urlparm = new Object();
	urlparm.XMLFile = "contract.PriceListProductFindDialog";
	urlparm.contractId = "<%= _contractId %>";
	urlparm.catalogId = "<%= catalogId %>";
	urlparm.categoryId = "<%= categoryId %>";
	urlparm.categoryDisplayText = "<%= UIUtil.toJavaScript(categoryDisplayText) %>";
	urlparm.searchActionType = "<%= searchActionType %>";
	urlparm.searchSelectionType = "<%= searchSelectionType %>";
	urlparm.targetView = "<%= targetView %>";
	urlparm.targetXML = "<%= targetXML %>";
	urlparm.srCategoryName = "<%= UIUtil.toJavaScript(srCategoryName) %>";
	urlparm.srCategoryShort = "<%= UIUtil.toJavaScript(srCategoryShort) %>";
	urlparm.srCategoryNameType = "<%= srCategoryNameType %>";
	urlparm.srCategoryShortType = "<%= srCategoryShortType %>";
	urlparm.srItemSku = "<%= UIUtil.toJavaScript(srItemSku) %>";
	urlparm.srItemName = "<%= UIUtil.toJavaScript(srItemName) %>";
	urlparm.srItemShort = "<%= UIUtil.toJavaScript(srItemShort) %>";
	urlparm.srItemSkuType = "<%= srItemSkuType %>";
	urlparm.srItemNameType = "<%= srItemNameType %>";
	urlparm.srItemShortType = "<%= srItemShortType %>";
	top.setContent("<%= UIUtil.toJavaScript(contractsRB.get("contractProductFindPanelTitle")) %>", "/webapp/wcs/tools/servlet/PriceListProductFindDialogView", false, urlparm);
}

function getResultsSize () {
	return <%= numberOfResults %>;
}

function onLoad () {
	//alert('total <%= numberOfResults %> start <%= startIndex %> end <%= endIndex %> listsize <%= listSize %> page <%= totalpage %>');
	parent.loadFrames();
}
//-->

</script>
</head>

<body onLoad="onLoad();" class="content_list">

<script language="JavaScript">
<!---- hide script from old browsers
<%
	for (int i = 0; i < cList.getListSize(); i++) {
		try {
			MemberDataBean mdb = new MemberDataBean();
			mdb.setId(cList.getCatalogListData(i).getMemberID().toString());
			DataBeanManager.activate(mdb, request);
%>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].id = "<%= cList.getCatalogListData(i).getID() %>";
resultContainer[resultIndex].name = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getName()) %>";
resultContainer[resultIndex].memberId = "<%= cList.getCatalogListData(i).getMemberID() %>";
resultContainer[resultIndex].identifier = "<%= UIUtil.toJavaScript(cList.getCatalogListData(i).getIdentifier()) %>";
resultContainer[resultIndex].Member = new Member("<%= mdb.getMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberDN()) %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupName()) %>", "<%= mdb.getMemberGroupOwnerMemberType() %>", "<%= UIUtil.toJavaScript(mdb.getMemberGroupOwnerMemberDN()) %>");
resultIndex++;
<%
		}
		catch (Exception ex) {
		}
	}
%>
//-->
parent.set_t_item_page(<%=totalsize%>, <%=listSize%>);

</script>


<form name="productSearchForm" id="productSearchForm">

<%= comm.startDlistTable((String)contractsRB.get("contractProductSearchSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>

<%		if (searchSelectionType.equals("CG")) { %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductCategoryCode"), ProductSearchListDataBean.ORDER_BY_CATEGORY_IDENTIFIER, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_CATEGORY_IDENTIFIER)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductFindName"), ProductSearchListDataBean.ORDER_BY_CATEGORY_NAME, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_CATEGORY_NAME)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductFindShortDesc"), ProductSearchListDataBean.ORDER_BY_CATEGORY_SHORTDESCRIPTION, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_CATEGORY_SHORTDESCRIPTION)) %>
<%
		}
		else if (searchSelectionType.equals("CE")) {
%>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductFindSkuSearchString"), ProductSearchListDataBean.ORDER_BY_PRODUCT_CODE, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_PRODUCT_CODE)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductFindName"), ProductSearchListDataBean.ORDER_BY_PRODUCT_NAME, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_PRODUCT_NAME)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductFindShortDesc"), ProductSearchListDataBean.ORDER_BY_SHORTDESCRIPTION, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_SHORTDESCRIPTION)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductSearchResultsProductType"), null, false) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductFindCategory"), ProductSearchListDataBean.ORDER_BY_CATEGORY_NAME, orderByParm.equals(ProductSearchListDataBean.ORDER_BY_CATEGORY_NAME)) %>
<%= comm.addDlistColumnHeading((String)contractsRB.get("contractProductSearchResultsSKUs"), null, false) %>
<%		} %>

<%= comm.endDlistRow() %>
<%
		for (int i = 0; i < cList.getListSize(); i++) {
%>
<%= comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(cList.getCatalogListData(i).getID().toString(), "parent.setChecked();performUpdate(false, this);", cList.getCatalogListData(i).getName()) %>

<%			if (searchSelectionType.equals("CG")) { %>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getIdentifier()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getShortDescription()), "none") %>
<%
			}
			else if (searchSelectionType.equals("CE")) {
%>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getIdentifier()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getShortDescription()), "none") %>
<%				if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_PRODUCT)) { %>
<%= comm.addDlistColumn((String)contractsRB.get("contractProductSearchResultsProductTypeProduct"), "none") %>
<%				} else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_ITEM)) { %>
<%= comm.addDlistColumn((String)contractsRB.get("contractProductSearchResultsProductTypeItem"), "none") %>
<%				} else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_PACKAGE)) { %>
<%= comm.addDlistColumn((String)contractsRB.get("contractProductSearchResultsProductTypePackage"), "none") %>
<%				} else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_BUNDLE)) { %>
<%= comm.addDlistColumn((String)contractsRB.get("contractProductSearchResultsProductTypeBundle"), "none") %>
<%				} else if (cList.getCatalogListData(i).getCatentryType().equals(ProductSearchListDataBean.CATENTRY_TYPE_DYNAMIC_KIT)) { %>
<%= comm.addDlistColumn((String)contractsRB.get("contractProductSearchResultsProductTypeDynamicKit"), "none") %>
<%				} %>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getCategoryName()), "none") %>
<%			if (cList.getCatalogListData(i).getNumOfSKUs().toString().equals("0"))	{ %>
<%= comm.addDlistColumn("", "none") %>
<%				} else { %>
<%= comm.addDlistColumn(UIUtil.toHTML(cList.getCatalogListData(i).getNumOfSKUs().toString()), "none") %>
<%				} %>
<%			} %>

<%= comm.endDlistRow() %>
<%
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		}
%>
<%= comm.endDlistTable() %>
<%		if (numberOfResults == 0) { %>
<p><p>
<%= contractsRB.get("contractProductSearchEmpty") %>
<%
		}
	}
	catch (Exception e) {
out.println(e.toString());
	}
%>
</form>

<script>
<!--
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->

</script>

</body>

</html>
