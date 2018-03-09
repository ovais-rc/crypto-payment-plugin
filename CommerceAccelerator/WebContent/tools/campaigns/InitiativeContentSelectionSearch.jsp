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
	com.ibm.commerce.tools.experimentation.search.CollateralSearchListDataBean" %>

<%@ include file="common.jsp" %>

<%
	String searchType = request.getParameter("searchType");
	String searchActionType = request.getParameter("searchActionType");
	String searchString = request.getParameter("searchString");
	String searchStringType = request.getParameter("searchStringType");
	String initialLoad = request.getParameter("initialLoad");
	String maxNumberOfResultForContentSearch = (String) campaignsRB.get("maxNumberOfResultForContentSearch");
	Vector searchResultId = new Vector();
	Vector searchResultName = new Vector();
	Vector searchResultStoreId = new Vector();
	String finishActionType = "";
	int totalResultSize = 0;

	if (searchType != null) {
		// get all the stores found in the store path
		String allRelatedStores = campaignCommandContext.getStoreId().toString();

		if (searchType.equals("promotionCollateral")) {
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
						if (urlLink != null && urlLink.indexOf(CampaignConstants.URL_ACCEPT_COUPON) >= 0) {
							continue;
						}

						// populate search result objects and increment counter
						searchResultId.addElement(collateralSearchDB.getCollateralList()[i].getId().toString());
						searchResultName.addElement(collateralSearchDB.getCollateralList()[i].getName().trim());
						searchResultStoreId.addElement(collateralSearchDB.getCollateralList()[i].getStoreId().toString());
						totalResultSize++;
					}
				}
			}
			finishActionType = totalResultSize > 0 ? "validPromotionCollateral" : "invalidPromotionCollateral";
		}
		else if (searchType.equals("couponCollateral")) {
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
						if (urlLink == null || urlLink.indexOf(CampaignConstants.URL_ACCEPT_COUPON) < 0) {
							continue;
						}

						// populate search result objects and increment counter
						searchResultId.addElement(collateralSearchDB.getCollateralList()[i].getId().toString());
						searchResultName.addElement(collateralSearchDB.getCollateralList()[i].getName().trim());
						searchResultStoreId.addElement(collateralSearchDB.getCollateralList()[i].getStoreId().toString());
						totalResultSize++;
					}
				}
			}
			finishActionType = totalResultSize > 0 ? "validCouponCollateral" : "invalidCouponCollateral";
		}
		else if (searchType.equals("collateral")) {
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
							urlLink.indexOf(CampaignConstants.URL_ADD_ITEM_WITH_PROMOTION) >= 0 ||
							urlLink.indexOf(CampaignConstants.URL_ACCEPT_COUPON) >= 0)) {
							continue;
						}

						// populate search result objects and increment counter
						searchResultId.addElement(collateralSearchDB.getCollateralList()[i].getId().toString());
						searchResultName.addElement(collateralSearchDB.getCollateralList()[i].getName().trim());
						searchResultStoreId.addElement(collateralSearchDB.getCollateralList()[i].getStoreId().toString());
						totalResultSize++;
					}
				}
			}
			finishActionType = totalResultSize > 0 ? "validCollateral" : "invalidCollateral";
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
var initiativeDataBean = null;
if (parent.parent.get) {
	initiativeDataBean = parent.parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);
}
with (parent.document.initiativeForm) {
<%
	//
	// valid promotion collateral name
	//
	if (finishActionType.equals("validPromotionCollateral")) {
%>
	var promotionCollateralSize = selectedPromotionCollateral.options.length;
	for (var i=availablePromotionCollateral.options.length-1; i>=0; i--) {
		availablePromotionCollateral.options[i] = null;
	}
	initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %> = new Array();
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	isDuplicate = false;
	for (var i=0; i<selectedPromotionCollateral.options.length; i++) {
		if (selectedPromotionCollateral.options[i].value == "<%= searchResultId.elementAt(i) %>") {
			isDuplicate = true;
			break;
		}
	}
	if (!isDuplicate) {
		var newResultObject = new Object();
		newResultObject.collateralID = "<%= searchResultId.elementAt(i) %>";
		newResultObject.name = "<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>";
		newResultObject.storeID = "<%= searchResultStoreId.elementAt(i) %>";
		initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_DISCOUNT_COLLATERAL %>.length] = newResultObject;
		availablePromotionCollateral.options[availablePromotionCollateral.options.length] = new Option(trim(newResultObject.name), newResultObject.collateralID, false, false);
		promotionCollateralSize++;
	}
<%		} %>
	parent.document.all.promotionCollateralCount.innerText = promotionCollateralSize;
	parent.initializeSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	parent.changePageElementStateOffSearch(searchPromotionCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForContentSearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)campaignsRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForContentSearch %>"));
	}
<%
	}
	//
	// invalid promotion collateral name
	//
	else if (finishActionType.equals("invalidPromotionCollateral")) {
%>
	parent.initializeSloshBuckets(selectedPromotionCollateral, removeFromPromotionCollateralSloshBucketButton, availablePromotionCollateral, addToPromotionCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedPromotionCollateral, availablePromotionCollateral, summaryPromotionCollateralButton);
	parent.changePageElementStateOffSearch(searchPromotionCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("noSearchResultFound")) %>");
		promotionCollateralSearch.focus();
	}
<%
	}
	//
	// valid coupon collateral name
	//
	else if (finishActionType.equals("validCouponCollateral")) {
%>
	var couponCollateralSize = selectedCouponCollateral.options.length;
	for (var i=availableCouponCollateral.options.length-1; i>=0; i--) {
		availableCouponCollateral.options[i] = null;
	}
	initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %> = new Array();
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	isDuplicate = false;
	for (var i=0; i<selectedCouponCollateral.options.length; i++) {
		if (selectedCouponCollateral.options[i].value == "<%= searchResultId.elementAt(i) %>") {
			isDuplicate = true;
			break;
		}
	}
	if (!isDuplicate) {
		var newResultObject = new Object();
		newResultObject.collateralID = "<%= searchResultId.elementAt(i) %>";
		newResultObject.name = "<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>";
		newResultObject.storeID = "<%= searchResultStoreId.elementAt(i) %>";
		initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COUPON_COLLATERAL %>.length] = newResultObject;
		availableCouponCollateral.options[availableCouponCollateral.options.length] = new Option(trim(newResultObject.name), newResultObject.collateralID, false, false);
		couponCollateralSize++;
	}
<%		} %>
	parent.document.all.couponCollateralCount.innerText = couponCollateralSize;
	parent.initializeSloshBuckets(selectedCouponCollateral, removeFromCouponCollateralSloshBucketButton, availableCouponCollateral, addToCouponCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedCouponCollateral, availableCouponCollateral, summaryCouponCollateralButton);
	parent.changePageElementStateOffSearch(searchCouponCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForContentSearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)campaignsRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForContentSearch %>"));
	}
<%
	}
	//
	// invalid coupon collateral name
	//
	else if (finishActionType.equals("invalidCouponCollateral")) {
%>
	parent.initializeSloshBuckets(selectedCouponCollateral, removeFromCouponCollateralSloshBucketButton, availableCouponCollateral, addToCouponCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedCouponCollateral, availableCouponCollateral, summaryCouponCollateralButton);
	parent.changePageElementStateOffSearch(searchCouponCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("noSearchResultFound")) %>");
		couponCollateralSearch.focus();
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
	initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %> = new Array();
<%		for (int i=0; i<searchResultId.size(); i++) { %>
	isDuplicate = false;
	for (var i=0; i<selectedCollateral.options.length; i++) {
		if (selectedCollateral.options[i].value == "<%= searchResultId.elementAt(i) %>") {
			isDuplicate = true;
			break;
		}
	}
	if (!isDuplicate) {
		var newResultObject = new Object();
		newResultObject.collateralID = "<%= searchResultId.elementAt(i) %>";
		newResultObject.name = "<%= UIUtil.toJavaScript((String)searchResultName.elementAt(i)) %>";
		newResultObject.storeID = "<%= searchResultStoreId.elementAt(i) %>";
		initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>[initiativeDataBean.<%= CampaignConstants.ELEMENT_AVAILABLE_COLLATERAL %>.length] = newResultObject;
		availableCollateral.options[availableCollateral.options.length] = new Option(trim(newResultObject.name), newResultObject.collateralID, false, false);
		collateralSize++;
	}
<%		} %>
	parent.document.all.collateralCount.innerText = collateralSize;
	parent.initializeSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	parent.changePageElementStateOffSearch(searchCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y" && <%= totalResultSize %> > <%= maxNumberOfResultForContentSearch %>) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)campaignsRB.get("tooManySearchResultFound")) %>", "?", "<%= maxNumberOfResultForContentSearch %>"));
	}
<%
	}
	//
	// invalid collateral name
	//
	else if (finishActionType.equals("invalidCollateral")) {
%>
	parent.initializeSloshBuckets(selectedCollateral, removeFromCollateralSloshBucketButton, availableCollateral, addToCollateralSloshBucketButton);
	parent.initializeSummaryButton(selectedCollateral, availableCollateral, summaryCollateralButton);
	parent.changePageElementStateOffSearch(searchCollateralButton);
	if ("<%=UIUtil.toJavaScript( initialLoad )%>" != "Y") {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("noSearchResultFound")) %>");
		collateralSearch.focus();
	}
<%
	}
	//
	// error while searching the catalog
	//
	else {
%>
	alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSearchFailed")) %>");
	top.showProgressIndicator(false);
<%	} %>
}
//-->
</script>
</head>

</html>
