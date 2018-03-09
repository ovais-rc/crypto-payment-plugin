<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CatalogSearchListDataBean,
	com.ibm.commerce.tools.util.ResourceDirectory,
	com.ibm.commerce.tools.util.UIUtil,
	java.util.Hashtable" %>

<%@ include file="common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("productFindPanelTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
function loadSelectValue (obj, field) {
	for (var i=0; i<obj.length; i++) {
		if (obj.options[i].value == field) {
			obj.options[i].selected = true;
			break;
		}
	}
	return true;
}

function loadPanelData () {
	// prefill the find input box if the user entered
	// something on the previous screen.
	with (document.productSearchForm) {
		srPartNumber.value = "<%= UIUtil.toJavaScript(request.getParameter("srPartNumber")) %>";
		srName.value = "<%= UIUtil.toJavaScript(request.getParameter("srName")) %>";
		srShortDescription.value = "<%= UIUtil.toJavaScript(request.getParameter("srShortDescription")) %>";
		loadSelectValue(srPartNumberType, "<%=UIUtil.toJavaScript( request.getParameter("srPartNumberType") )%>");
		loadSelectValue(srNameType, "<%=UIUtil.toJavaScript( request.getParameter("srNameType") )%>");
		loadSelectValue(srShortDescriptionType, "<%=UIUtil.toJavaScript( request.getParameter("srShortDescriptionType") )%>");
		srPartNumber.focus();
	}

	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}

function hasInvalidChars (inputString) {
	var i = 0;
// Invalid characters should be escaped at the search level, therefore no need to validate here.
//
//	for (i=0; i<inputString.length; i++) {
//		var c = inputString.charAt(i);
//		switch (c) {
//			case "\"":
//			case "\\":
//			case "\'":
//			case "#":
//				return c;
//		}
//	}
	return null;
}

function replaceField (source, pattern, replacement) {
	returnString = "";
	index1 = source.indexOf(pattern);
	index2 = index1 + pattern.length;
	returnString += source.substring(0, index1) + replacement + source.substring(index2);
	return returnString;
}

function validateSearchSKU (s1, s2, s3) {
	if (isEmpty(s1) && isEmpty(s2) && isEmpty(s3)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_SKUSEARCH_CANNOT_BE_EMPTY)) %>");
		return false;
	}

	var invalidChar = "";

	invalidChar = hasInvalidChars(s1);
	if (invalidChar != null) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_CHARACTER)) %>", "?", invalidChar));
		return false;
	}
	invalidChar = hasInvalidChars(s2);
	if (invalidChar != null) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_CHARACTER)) %>", "?", invalidChar));
		return false;
	}
	invalidChar = hasInvalidChars(s3);
	if (invalidChar != null) {
		alertDialog(replaceField("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INVALID_CHARACTER)) %>", "?", invalidChar));
		return false;
	}

	return true;
}

function findProducts () {
	// get the search strings from the fields
	var skuSearchString = document.productSearchForm.srPartNumber.value;
	var nameSearchString = document.productSearchForm.srName.value;
	var shortSearchString = document.productSearchForm.srShortDescription.value;

	var skuSearchStringType = document.productSearchForm.srPartNumberType.options[document.productSearchForm.srPartNumberType.selectedIndex].value;
	var nameSearchStringType = document.productSearchForm.srNameType.options[document.productSearchForm.srNameType.selectedIndex].value;
	var shortSearchStringType = document.productSearchForm.srShortDescriptionType.options[document.productSearchForm.srShortDescriptionType.selectedIndex].value;

	// create the base url
	if (validateSearchSKU(skuSearchString, nameSearchString, shortSearchString)) {
		var url = "DialogView";
		var urlparm = new Object();
		urlparm.ActionXMLFile = "campaigns.ProductSearchList";
		urlparm.cmd = "ProductSearchView";
		urlparm.XMLFile = "campaigns.ProductSearchDialog";

		var waf = top.getData("searchType", 1);
		if (waf == "productSingle") {
			urlparm.resultLimit = "single";
			urlparm.catentryType = "";
		}
		else if (waf == "productMultiple") {
			urlparm.resultLimit = "multiple";
			urlparm.catentryType = "";
		}
		else if (waf == "itemSingle") {
			urlparm.resultLimit = "single";
			urlparm.catentryType = "<%= CatalogSearchListDataBean.CATENTRY_TYPE_ITEM %>";
		}
		else {
			urlparm.resultLimit = "multiple";
			urlparm.catentryType = "<%= CatalogSearchListDataBean.CATENTRY_TYPE_ITEM %>";
		}

		urlparm.srPartNumber = skuSearchString;
		urlparm.srName = nameSearchString;
		urlparm.srShortDescription = shortSearchString;
		urlparm.srPartNumberType = skuSearchStringType;
		urlparm.srNameType = nameSearchStringType;
		urlparm.srShortDescriptionType = shortSearchStringType;
		urlparm.storeId = "<%= campaignCommandContext.getStoreId().toString() %>";
		urlparm.languageId = "<%= campaignCommandContext.getLanguageId().toString() %>";
		urlparm.searchType = "<%= CatalogSearchListDataBean.SEARCH_TYPE_CATENTRY %>";
		urlparm.catentryBuyable = "1";
		urlparm.catentryPublished = "1";
		top.setContent("<%= UIUtil.toJavaScript(campaignsRB.get("ProductSearchBrowserTitle")) %>", url, false, urlparm);
	}
}

function goBackToRefererURL () {
	// take the user back to the previous entry in the model...
	top.goBack();
}
//-->
</script>
</head>

<body onload="loadPanelData();" class="content">

<form name="productSearchForm" id="productSearchForm">

<h1><%= campaignsRB.get("productFindPrompt") %></h1>

<p><%= campaignsRB.get("productFindDescription") %></p>
<table border="0" cellpadding="0" cellspacing="0" id="WC_ProductFindPanel_Table_1">
	<tr>
		<td width="75" align="left" nowrap="nowrap" id="WC_ProductFindPanel_TableCell_1">&nbsp;</td>
		<td width="210" align="left" id="WC_ProductFindPanel_TableCell_2">&nbsp;</td>
	</tr>
	<tr valign="bottom">
		<td id="WC_ProductFindPanel_TableCell_3"></td>
		<td width="210" align="left" nowrap="nowrap" id="WC_ProductFindPanel_TableCell_4">
			<label for="srPartNumber"><%= campaignsRB.get("productFindSkuSearchString") %></label><br/>
			<input type="text" name="srPartNumber" size="20" maxlength="64" id="srPartNumber" />
		</td>
		<td id="WC_ProductFindPanel_TableCell_5">
			<label for="srPartNumberType"></label>
			<select name="srPartNumberType" id="srPartNumberType">
				<option value="<%= CatalogSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= campaignsRB.get("productFindMatchesContaining") %></option>
				<option value="<%= CatalogSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= campaignsRB.get("productFindExactPhrase") %></option>
			</select>
		</td>
	</tr>
	<tr><td colspan="4" id="WC_ProductFindPanel_TableCell_6">&nbsp;</td></tr>
	<tr valign="bottom">
		<td id="WC_ProductFindPanel_TableCell_7"></td>
		<td width="210" align="left" nowrap="nowrap" id="WC_ProductFindPanel_TableCell_8">
			<label for="srName"><%= campaignsRB.get("productFindName") %></label><br/>
			<input type="text" name="srName" size="20" maxlength="64" id="srName" />
		</td>
		<td id="WC_ProductFindPanel_TableCell_9">
			<label for="srNameType"></label>
			<select name="srNameType" id="srNameType">
				<option value="<%= CatalogSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= campaignsRB.get("productFindMatchesContaining") %></option>
				<option value="<%= CatalogSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= campaignsRB.get("productFindExactPhrase") %></option>
			</select>
		</td>
	</tr>
	<tr><td colspan="4" id="WC_ProductFindPanel_TableCell_10">&nbsp;</td></tr>
	<tr valign="bottom">
		<td id="WC_ProductFindPanel_TableCell_11"></td>
		<td width="210" align="left" nowrap="nowrap" id="WC_ProductFindPanel_TableCell_12">
			<label for="srShortDescription"><%= campaignsRB.get("productFindShortDesc") %></label><br/>
			<input type="text" name="srShortDescription" size="20" maxlength="64" id="srShortDescription" />
		</td>
		<td id="WC_ProductFindPanel_TableCell_13">
			<label for="srShortDescriptionType"></label>
			<select name="srShortDescriptionType" id="srShortDescriptionType">
				<option value="<%= CatalogSearchListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= campaignsRB.get("productFindMatchesContaining") %></option>
				<option value="<%= CatalogSearchListDataBean.TYPE_MATCH_IGNORE_CASE %>"><%= campaignsRB.get("productFindExactPhrase") %></option>
			</select>
		</td>
	</tr>
</table>

</form>

</body>

</html>
