<!-- ==================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.experimentation.ExperimentConstants,
	com.ibm.commerce.tools.experimentation.search.CatalogEntrySearchListDataBean,
	com.ibm.commerce.tools.experimentation.search.CatalogGroupSearchListDataBean,
	com.ibm.commerce.tools.experimentation.search.CollateralSearchListDataBean,
	com.ibm.commerce.tools.experimentation.search.PromotionSearchListDataBean" %>

<%@ include file="common.jsp" %>

<%
	String searchType = request.getParameter("searchType");
	String searchActionType = request.getParameter("searchActionType");
	String searchString = request.getParameter("searchString");
	String searchStringType = request.getParameter("searchStringType");
	String initialLoad = request.getParameter("initialLoad");
	String maxNumberOfResultForPromotionSearch = (String) experimentRB.get("maxNumberOfResultForPromotionSearch");
	String maxNumberOfResultForProductSearch = (String) experimentRB.get("maxNumberOfResultForProductSearch");
	String maxNumberOfResultForCategorySearch = (String) experimentRB.get("maxNumberOfResultForCategorySearch");
	String maxNumberOfResultForContentSearch = (String) experimentRB.get("maxNumberOfResultForContentSearch");
	Vector searchResultId = new Vector();
	Vector searchResultName = new Vector();
	String finishActionType = "";
	int totalResultSize = 0;

	if (searchType != null) {
		// get all the stores found in the store path
		String allRelatedStores = experimentCommandContext.getStoreId().toString();

		if (searchType.equals("product")) {
			finishActionType = "invalidProduct";
			if (searchString != null && searchStringType != null) {
				CatalogEntrySearchListDataBean productSearchDB = new CatalogEntrySearchListDataBean();
				if (searchStringType.equals("partnumber")) {
					productSearchDB.setPartNumber(searchString);
					productSearchDB.setPartNumberType(searchActionType);
				}
				else if (searchStringType.equals("name")) {
					productSearchDB.setCatentryName(searchString);
					productSearchDB.setCatentryNameType(searchActionType);
				}
				productSearchDB.setMarkForDelete("0");
				productSearchDB.setPublished("1");
				productSearchDB.setIndexEnd(maxNumberOfResultForProductSearch);
				DataBeanManager.activate(productSearchDB, request);
				if (productSearchDB.getCatalogEntryList() != null && productSearchDB.getCatalogEntryList().length > 0) {
					for (int i=0; i<productSearchDB.getCatalogEntryList().length; i++) {
						searchResultId.addElement(productSearchDB.getCatalogEntryList()[i].getId().toString());
						searchResultName.addElement(productSearchDB.getCatalogEntryList()[i].getName().trim() + " (" + productSearchDB.getCatalogEntryList()[i].getPartNumber().trim() + ")");
					}
					totalResultSize = productSearchDB.getResultSetSize();
					finishActionType = "validProduct";
				}
			}
		}
		else if (searchType.equals("category")) {
			finishActionType = "invalidCategory";
			if (searchString != null && searchStringType != null) {
				CatalogGroupSearchListDataBean categorySearchDB = new CatalogGroupSearchListDataBean();
				if (searchStringType.equals("identifier")) {
					categorySearchDB.setIdentifier(searchString);
					categorySearchDB.setIdentifierType(searchActionType);
				}
				else if (searchStringType.equals("name")) {
					categorySearchDB.setCatgroupName(searchString);
					categorySearchDB.setCatgroupNameType(searchActionType);
				}
				categorySearchDB.setMarkForDelete("0");
				categorySearchDB.setPublished("1");
				categorySearchDB.setIndexEnd(maxNumberOfResultForCategorySearch);
				DataBeanManager.activate(categorySearchDB, request);
				if (categorySearchDB.getCatalogGroupList() != null && categorySearchDB.getCatalogGroupList().length > 0) {
					for (int i=0; i<categorySearchDB.getCatalogGroupList().length; i++) {
						searchResultId.addElement(categorySearchDB.getCatalogGroupList()[i].getId().toString());
						searchResultName.addElement(categorySearchDB.getCatalogGroupList()[i].getName().trim());
					}
					totalResultSize = categorySearchDB.getResultSetSize();
					finishActionType = "validCategory";
				}
			}
		}
		else if (searchType.equals("promotion")) {
			finishActionType = "invalidPromotion";
			if (searchString != null) {
				PromotionSearchListDataBean promotionSearchDB = new PromotionSearchListDataBean();
				promotionSearchDB.setPromotionName(searchString);
				promotionSearchDB.setPromotionNameType(searchActionType);
				promotionSearchDB.setIndexEnd(maxNumberOfResultForPromotionSearch);
				DataBeanManager.activate(promotionSearchDB, request);
				if (promotionSearchDB.getPromotionList() != null && promotionSearchDB.getPromotionList().length > 0) {
					for (int i=0; i<promotionSearchDB.getPromotionList().length; i++) {
						searchResultId.addElement(promotionSearchDB.getPromotionList()[i].getId().toString());
						searchResultName.addElement(promotionSearchDB.getPromotionList()[i].getName().trim());
					}
					totalResultSize = promotionSearchDB.getResultSetSize();
					finishActionType = "validPromotion";
				}
			}
		}
		else if (searchType.equals("promotionCollateral")) {
			finishActionType = "invalidPromotionCollateral";
			if (searchString != null) {
				CollateralSearchListDataBean collateralSearchDB = new CollateralSearchListDataBean();
				collateralSearchDB.setCollateralName(searchString);
				collateralSearchDB.setCollateralNameType(searchActionType);
				collateralSearchDB.setIndexEnd(maxNumberOfResultForContentSearch);
				DataBeanManager.activate(collateralSearchDB, request);
				if (collateralSearchDB.getCollateralList() != null && collateralSearchDB.getCollateralList().length > 0) {
					for (int i=0; i<collateralSearchDB.getCollateralList().length; i++) {
						searchResultId.addElement(collateralSearchDB.getCollateralList()[i].getId().toString());
						searchResultName.addElement(collateralSearchDB.getCollateralList()[i].getName().trim());
					}
					totalResultSize = collateralSearchDB.getResultSetSize();
					finishActionType = "validPromotionCollateral";
				}
			}
		}
		else if (searchType.equals("collateral")) {
			finishActionType = "invalidCollateral";
			if (searchString != null) {
				CollateralSearchListDataBean collateralSearchDB = new CollateralSearchListDataBean();
				collateralSearchDB.setCollateralName(searchString);
				collateralSearchDB.setCollateralNameType(searchActionType);
				collateralSearchDB.setUseCursor(false);
				DataBeanManager.activate(collateralSearchDB, request);
				if (collateralSearchDB.getCollateralList() != null && collateralSearchDB.getCollateralList().length > 0) {
					for (int i=0; i<collateralSearchDB.getCollateralList().length; i++) {
						// if the size of result set reaches its limit, exit this loop
						if (totalResultSize >= Integer.valueOf(maxNumberOfResultForContentSearch).intValue()) {
							break;
						}

						// skip this collateral if it is a promotional collateral
						String urlLink = collateralSearchDB.getCollateralList()[i].getUrlLink();
						if (urlLink != null &&
							(urlLink.indexOf(CampaignConstants.URL_PROMOTION_DISPLAY) >= 0 ||
							urlLink.indexOf(CampaignConstants.URL_PROMOTION_ADD) >= 0 ||
							urlLink.indexOf(CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION) >= 0)) {
							continue;
						}

						// populate search result objects and increment counter
						searchResultId.addElement(collateralSearchDB.getCollateralList()[i].getId().toString());
						searchResultName.addElement(collateralSearchDB.getCollateralList()[i].getName().trim());
						totalResultSize++;
					}
					finishActionType = "validCollateral";
				}
			}
		}
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
function replaceField (source, pattern, replacement) {
	returnString = "";
	index1 = source.indexOf(pattern);
	index2 = index1 + pattern.length;
	returnString += source.substring(0, index1) + replacement + source.substring(index2);
	return returnString;
}

var isDuplicate = false;
with (parent.document.experimentContentSelectionForm) {
<%
	//
	// valid product
	//
	if (finishActionType.equals("validProduct")) {
%>
	var productSize = selectedProduct.options.length;
	for (var i=availableProduct.options.length-1; i>=0; i--) {
		availableProduct.options[i] = null;
	}
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	isDuplicate = false;
	for (var i=0; i<selectedProduct.options.length; i++) {
		if (selectedProduct.options[i].value == "<%= searchResultId.elementAt(i) %>") {
			isDuplicate = true;
			break;
		}
	}
	if (!isDuplicate) {
		availableProduct.options[availableProduct.options.length] = new Option(trim("<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>"), "<%= searchResultId.elementAt(i) %>", false, false);
		productSize++;
	}
<%		} %>
	parent.document.all.productCount.innerText = productSize;
	parent.initializeSloshBuckets(selectedProduct, removeFromProductSloshBucketButton, availableProduct, addToProductSloshBucketButton);
	parent.changePageElementStateOffSearch(searchProductButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForProductSearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForProductSearch %>"));
	}
<%
	}
	//
	// invalid product
	//
	else if (finishActionType.equals("invalidProduct")) {
%>
	productSearch.focus();
	parent.initializeSloshBuckets(selectedProduct, removeFromProductSloshBucketButton, availableProduct, addToProductSloshBucketButton);
	parent.changePageElementStateOffSearch(searchProductButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("noSearchResultFound")) %>");
	}
<%
	}
	//
	// valid category
	//
	else if (finishActionType.equals("validCategory")) {
%>
	var categorySize = selectedCategory.options.length;
	for (var i=availableCategory.options.length-1; i>=0; i--) {
		availableCategory.options[i] = null;
	}
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	isDuplicate = false;
	for (var i=0; i<selectedCategory.options.length; i++) {
		if (selectedCategory.options[i].value == "<%= searchResultId.elementAt(i) %>") {
			isDuplicate = true;
			break;
		}
	}
	if (!isDuplicate) {
		availableCategory.options[availableCategory.options.length] = new Option(trim("<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>"), "<%= searchResultId.elementAt(i) %>", false, false);
		categorySize++;
	}
<%		} %>
	parent.document.all.categoryCount.innerText = categorySize;
	parent.initializeSloshBuckets(selectedCategory, removeFromCategorySloshBucketButton, availableCategory, addToCategorySloshBucketButton);
	parent.changePageElementStateOffSearch(searchCategoryButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForCategorySearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForCategorySearch %>"));
	}
<%
	}
	//
	// invalid category
	//
	else if (finishActionType.equals("invalidCategory")) {
%>
	categorySearch.focus();
	parent.initializeSloshBuckets(selectedCategory, removeFromCategorySloshBucketButton, availableCategory, addToCategorySloshBucketButton);
	parent.changePageElementStateOffSearch(searchCategoryButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("noSearchResultFound")) %>");
	}
<%
	}
	//
	// valid promotion name
	//
	else if (finishActionType.equals("validPromotion")) {
%>
	var selectedPromotionId = null;
	for (var i=selectedPromotion.options.length-1; i>=0; i--) {
		if (selectedPromotion.options[i].selected) {
			selectedPromotionId = selectedPromotion.options[i].value;
		}
		selectedPromotion.options[i] = null;
	}
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	if (selectedPromotionId != null && "<%= searchResultId.elementAt(i) %>" == selectedPromotionId) {
		selectedPromotion.options[selectedPromotion.options.length] = new Option(trim("<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>"), "<%= searchResultId.elementAt(i) %>", false, true);
	}
	else {
		selectedPromotion.options[selectedPromotion.options.length] = new Option(trim("<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>"), "<%= searchResultId.elementAt(i) %>", false, false);
	}
<%		} %>
	parent.document.all.promotionCount.innerText = "<%= searchResultId.size() %>";
	parent.changePageElementStateOffSearch(searchPromotionButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForPromotionSearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForPromotionSearch %>"));
	}
<%
	}
	//
	// invalid promotion name
	//
	else if (finishActionType.equals("invalidPromotion")) {
%>
	promotionSearch.focus();
	parent.changePageElementStateOffSearch(searchPromotionButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("noSearchResultFound")) %>");
	}
<%
	}
	//
	// valid promotion collateral name
	//
	else if (finishActionType.equals("validPromotionCollateral")) {
%>
	var promotionCollateralSize = selectedPromotionCollateral.options.length;
	for (var i=availablePromotionCollateral.options.length-1; i>=0; i--) {
		availablePromotionCollateral.options[i] = null;
	}
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	isDuplicate = false;
	for (var i=0; i<selectedPromotionCollateral.options.length; i++) {
		if (selectedPromotionCollateral.options[i].value == "<%= searchResultId.elementAt(i) %>") {
			isDuplicate = true;
			break;
		}
	}
	if (!isDuplicate) {
		availablePromotionCollateral.options[availablePromotionCollateral.options.length] = new Option(trim("<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>"), "<%= searchResultId.elementAt(i) %>", false, false);
		promotionCollateralSize++;
	}
<%		} %>
	parent.document.all.promotionCollateralCount.innerText = promotionCollateralSize;
	parent.initializeSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	parent.changePageElementStateOffSearch(searchPromotionCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForContentSearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForContentSearch %>"));
	}
<%
	}
	//
	// invalid promotion collateral name
	//
	else if (finishActionType.equals("invalidPromotionCollateral")) {
%>
	promotionCollateralSearch.focus();
	parent.initializeSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	parent.changePageElementStateOffSearch(searchPromotionCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("noSearchResultFound")) %>");
	}
<%
	}
	//
	// valid collateral name
	//
	else if (finishActionType.equals("validCollateral")) {
%>
	var collateralSize = selectedCollateral.options.length;
	for (var i=availableCollateral.options.length-1; i>=0; i--) {
		availableCollateral.options[i] = null;
	}
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	isDuplicate = false;
	for (var i=0; i<selectedCollateral.options.length; i++) {
		if (selectedCollateral.options[i].value == "<%= searchResultId.elementAt(i) %>") {
			isDuplicate = true;
			break;
		}
	}
	if (!isDuplicate) {
		availableCollateral.options[availableCollateral.options.length] = new Option(trim("<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>"), "<%= searchResultId.elementAt(i) %>", false, false);
		collateralSize++;
	}
<%		} %>
	parent.document.all.collateralCount.innerText = collateralSize;
	parent.initializeSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	parent.changePageElementStateOffSearch(searchCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForContentSearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForContentSearch %>"));
	}
<%
	}
	//
	// invalid collateral name
	//
	else if (finishActionType.equals("invalidCollateral")) {
%>
	collateralSearch.focus();
	parent.initializeSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	parent.changePageElementStateOffSearch(searchCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("noSearchResultFound")) %>");
	}
<%
	}
	//
	// error while searching the catalog
	//
	else {
%>
	alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("contentSearchFailed")) %>");
	top.showProgressIndicator(false);
<%	} %>
}
//-->
</script>
</head>

</html>
