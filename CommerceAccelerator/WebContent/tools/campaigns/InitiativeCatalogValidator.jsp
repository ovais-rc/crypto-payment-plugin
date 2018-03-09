<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<%@ page language="java"
	import="com.ibm.commerce.search.beans.AdvancedCatEntrySearchListDataBean,
	com.ibm.commerce.search.beans.CategorySearchListDataBean" %>

<%@ include file="common.jsp" %>

<%
	String searchType = request.getParameter("searchType");
	String locationType = request.getParameter("locationType");
	String productSku = request.getParameter("productSku");
	String productName = "";
	String categoryIdentifier = request.getParameter("categoryIdentifier");
	String categoryName = "";
	String actionType = "";

	if (searchType != null) {
		// get all the stores found in the catalog store path
		String catalogStoreIds = campaignCommandContext.getStoreId().toString();

		if (searchType.equals("product")) {
			actionType = "invalidProduct";
			if (productSku != null) {
				// use the search API to check if the given product SKU is valid or not
				try {
					Integer relatedStores[] = campaignCommandContext.getStore().getStorePath(com.ibm.commerce.server.ECConstants.EC_STRELTYP_CATALOG);
					for (int i=0; i<relatedStores.length; i++) {
						catalogStoreIds += " " + relatedStores[i].toString();
					}

					AdvancedCatEntrySearchListDataBean productSearchDB = new AdvancedCatEntrySearchListDataBean();
					productSearchDB.setSku(productSku);
					productSearchDB.setSkuCaseSensitive("yes");
					productSearchDB.setSkuOperator("EQUAL");
					productSearchDB.setMarkForDelete("0");
					productSearchDB.setPublished("1");
					productSearchDB.setStoreIds(catalogStoreIds);
					productSearchDB.setStoreIdOperator("IN");
					com.ibm.commerce.beans.DataBeanManager.activate(productSearchDB, request);
					if (productSearchDB.getResultList().length > 0) {
						productName = productSearchDB.getResultList()[0].getDescription(campaignCommandContext.getLanguageId()).getName();
						actionType = "validProduct";
					}
				}
				catch (Exception e) {
				}
			}
		}
		else if (searchType.equals("category")) {
			actionType = "invalidCategory";
			if (categoryIdentifier != null) {
				// use the search API to check if the given category identifier is valid or not
				try {
					Integer relatedStores[] = campaignCommandContext.getStore().getStorePath(com.ibm.commerce.server.ECConstants.EC_STRELTYP_CATALOG);
					for (int i=0; i<relatedStores.length; i++) {
						catalogStoreIds += "," + relatedStores[i].toString();
					}

					CategorySearchListDataBean categorySearchDB = new CategorySearchListDataBean();
					categorySearchDB.setIdentifier(categoryIdentifier);
					categorySearchDB.setIdentifierCaseSensitive("yes");
					categorySearchDB.setIdentifierOperator("EQUAL");
					categorySearchDB.setIdentifierType("EXACT");
					categorySearchDB.setMarkForDelete("0");
					categorySearchDB.setPublished("1");
					categorySearchDB.setStoreId(catalogStoreIds);
					categorySearchDB.setStoreIdOperator("IN");
					com.ibm.commerce.beans.DataBeanManager.activate(categorySearchDB, request);
					if (categorySearchDB.getResultList().length > 0) {
						categoryName = categorySearchDB.getResultList()[0].getDescription(campaignCommandContext.getLanguageId()).getName();
						actionType = "validCategory";
					}
				}
				catch (Exception e) {
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
var isDuplicate = false;
<%
	//
	// valid product SKU
	//
	if (actionType.equals("validProduct")) {
		if (locationType.equals("whatAction")) {
%>
for (var i=0; i<parent.document.initiativeForm.selectedSKUs.options.length; i++) {
	if (parent.document.initiativeForm.selectedSKUs.options[i].value == "<%= UIUtil.toJavaScript(productSku) %>") {
		isDuplicate = true;
		break;
	}
}
if (!isDuplicate) {
	parent.document.initiativeForm.selectedSKUs.options[parent.document.initiativeForm.selectedSKUs.options.length] = new Option(trim("<%= UIUtil.toJavaScript(productName) %>") + " (" + trim("<%= UIUtil.toJavaScript(productSku) %>") + ")", "<%= UIUtil.toJavaScript(productSku) %>", false, false);
	parent.document.initiativeForm.productSKU.value = "";
}
else {
	alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("productSKUAlreadyExist")) %>");
}
parent.document.initiativeForm.productSKU.focus();
parent.document.initiativeForm.whatAddProductButton.disabled = false;
parent.document.initiativeForm.whatAddProductButton.className = "enabled";
parent.document.initiativeForm.whatAddProductButton.id = "enabled";
<%		} else if (locationType.equals("whichCondition")) { %>
parent.document.initiativeForm.whichSkuValue.value = "<%= UIUtil.toJavaScript(productSku) %>";
parent.document.initiativeForm.whichSkuNameValue.value = "<%= UIUtil.toJavaScript(productName) %>";
parent.addWhichChoice();
parent.document.initiativeForm.whichAddSkuButton.disabled = false;
parent.document.initiativeForm.whichAddSkuButton.className = "enabled";
parent.document.initiativeForm.whichAddSkuButton.id = "enabled";
<%
		}
	//
	// invalid product SKU
	//
	} else if (actionType.equals("invalidProduct")) {
		if (locationType.equals("whatAction")) {
%>
alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseEnterValidSKU")) %>");
parent.document.initiativeForm.productSKU.focus();
parent.document.initiativeForm.whatAddProductButton.disabled = false;
parent.document.initiativeForm.whatAddProductButton.className = "enabled";
parent.document.initiativeForm.whatAddProductButton.id = "enabled";
<%		} else if (locationType.equals("whichCondition")) { %>
alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseEnterValidSKU")) %>");
parent.document.initiativeForm.whichSkuValue.focus();
parent.document.initiativeForm.whichAddSkuButton.disabled = false;
parent.document.initiativeForm.whichAddSkuButton.className = "enabled";
parent.document.initiativeForm.whichAddSkuButton.id = "enabled";
<%
		}
	//
	// valid category identifier
	//
	} else if (actionType.equals("validCategory")) {
		if (locationType.equals("whatAction")) {
%>
for (var i=0; i<parent.document.initiativeForm.selectedCategory.options.length; i++) {
	if (parent.document.initiativeForm.selectedCategory.options[i].value == "<%= UIUtil.toJavaScript(categoryIdentifier) %>") {
		isDuplicate = true;
		break;
	}
}
if (!isDuplicate) {
	parent.document.initiativeForm.selectedCategory.options[parent.document.initiativeForm.selectedCategory.options.length] = new Option(trim("<%= UIUtil.toJavaScript(categoryName) %>"), "<%= UIUtil.toJavaScript(categoryIdentifier) %>", false, false);
	parent.document.initiativeForm.categoryIdentifier.value = "";
}
else {
	alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("categoryIdentifierAlreadyExist")) %>");
}
parent.document.initiativeForm.categoryIdentifier.focus();
parent.document.initiativeForm.whatAddCategoryButton.disabled = false;
parent.document.initiativeForm.whatAddCategoryButton.className = "enabled";
parent.document.initiativeForm.whatAddCategoryButton.id = "enabled";
<%		} else if (locationType.equals("whichCondition")) { %>
parent.document.initiativeForm.whichCategoryValue.value = "<%= UIUtil.toJavaScript(categoryIdentifier) %>";
parent.document.initiativeForm.whichCategoryNameValue.value = "<%= UIUtil.toJavaScript(categoryName) %>";
parent.addWhichChoice();
parent.document.initiativeForm.whichAddCategoryButton.disabled = false;
parent.document.initiativeForm.whichAddCategoryButton.className = "enabled";
parent.document.initiativeForm.whichAddCategoryButton.id = "enabled";
<%
		}
	//
	// invalid category identifier
	//
	} else if (actionType.equals("invalidCategory")) {
		if (locationType.equals("whatAction")) {
%>
alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseEnterValidCategory")) %>");
parent.document.initiativeForm.categoryIdentifier.focus();
parent.document.initiativeForm.whatAddCategoryButton.disabled = false;
parent.document.initiativeForm.whatAddCategoryButton.className = "enabled";
parent.document.initiativeForm.whatAddCategoryButton.id = "enabled";
<%		} else if (locationType.equals("whichCondition")) { %>
alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseEnterValidCategory")) %>");
parent.document.initiativeForm.whichCategoryValue.focus();
parent.document.initiativeForm.whichAddCategoryButton.disabled = false;
parent.document.initiativeForm.whichAddCategoryButton.className = "enabled";
parent.document.initiativeForm.whichAddCategoryButton.id = "enabled";
<%
		}
	//
	// error while searching the catalog
	//
	} else {
%>
alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("catalogSearchFailed")) %>");
<%	} %>
//-->
</script>
</head>

</html>