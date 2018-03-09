<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.search.beans.*" %>

<%@ include file="eCouponCommon.jsp" %>

<%
	boolean needValidation;
	boolean leavePanel;
	boolean isInvalid;
	String categoryIdentifier = request.getParameter("categoryIdentifier");
	String minCatQty = request.getParameter("minCatQty");
	String maxCatQty = request.getParameter("maxCatQty");
	String minCatAmt = request.getParameter("minCatAmt");
	String maxCatAmt = request.getParameter("maxCatAmt");

	if (categoryIdentifier == null) {
		needValidation = true;
		leavePanel = false;
		isInvalid = false;
	}
	else {
		// get all the stores found in the catalog store path
		String catalogStoreIds = commContext.getStoreId().toString();
		try {
			Integer relatedStores[] = commContext.getStore().getStorePath(com.ibm.commerce.server.ECConstants.EC_STRELTYP_CATALOG);
			for (int i=0; i<relatedStores.length; i++) {
				catalogStoreIds += "," + relatedStores[i].toString();
			}
		}
		catch (Exception e) {
		}

		// use the search API to check if the given category identifier is valid or not
		try {
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
				needValidation = false;
				leavePanel = true;
				isInvalid = false;
			}
			else {
				needValidation = true;
				leavePanel = false;
				isInvalid = true;
			}
		}
		catch (Exception e) {
			needValidation = true;
			leavePanel = false;
			isInvalid = true;
		}
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%= eCouponWizardNLS.get("eCouponAddCategoryWindowTitle") %></title>

<%= feCouponHeader %>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/NumberFormat.js">
</script>
<script language="Javascript">
//global var to get the selected currency
var fCurr = top.getData("eCouponCurr");
var needValidation = <%= needValidation %>;
var leavePanel = <%= leavePanel %>;
var isInvalid = <%= isInvalid %>;

function initializeState () {
	var foundSku = top.getData("categorySearchSkuArray");

	if (foundSku != null) {
		document.f1.categorySKU.value = foundSku[0].categorySku;
		top.saveData(null, "categorySearchSkuArray");
		top.saveData(null, "findSkuSearchString");
	}
	else {
<%	if (categoryIdentifier != null) { %>
		document.f1.categorySKU.value = "<%=UIUtil.toJavaScript( categoryIdentifier )%>";
<%	} else { %>
	if ((top.getData("categorySKU") != null) && (top.getData("categorySKU") != "")) {
		document.f1.categorySKU.value = top.getData("categorySKU");
		top.saveData(null, "categorySKU");
	}
<%	} %>
	}

<%	if (minCatQty != null) { %>
	document.f1.minCatQty.value = "<%=UIUtil.toJavaScript( minCatQty )%>";
<%	} else { %>
	if ((top.getData("minCatQty") != null) && (top.getData("minCatQty") != "")) {
		document.f1.minCatQty.value = top.getData("minCatQty");
		top.saveData(null, "minCatQty");
	}
<%	} %>

<%	if (maxCatQty != null) { %>
	document.f1.maxCatQty.value = "<%=UIUtil.toJavaScript( maxCatQty )%>";
<%	} else { %>
	if ((top.getData("maxCatQty") != null) && (top.getData("maxCatQty") != "")) {
		document.f1.maxCatQty.value = top.getData("maxCatQty");
		top.saveData(null, "maxCatQty");
	}
<%	} %>

<%	if (minCatAmt != null) { %>
	document.f1.minCatAmt.value = "<%=UIUtil.toJavaScript( minCatAmt )%>";
<%	} else { %>
	if ((top.getData("minCatAmt") != null) && (top.getData("minCatAmt") != "")) {
		document.f1.minCatAmt.value = top.getData("minCatAmt");
		top.saveData(null, "minCatAmt");
	}
<%	} %>

<%	if (maxCatAmt != null) { %>
	document.f1.maxCatAmt.value = "<%=UIUtil.toJavaScript( maxCatAmt )%>";
<%	} else { %>
	if ((top.getData("maxCatAmt") != null) && (top.getData("maxCatAmt") != "")) {
		document.f1.maxCatAmt.value = top.getData("maxCatAmt");
		top.saveData(null, "maxCatAmt");
	}
<%	} %>

	if (leavePanel) {
		savePanelData();
	}
	else {
		if (isInvalid) {
			alertDialog("<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategorySKUWrong")) %>");
			document.f1.categorySKU.select();
		}
	}

	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}

function cancelAction () {
	top.goBack();
}

////////////////////////////////////////////////////////////
// Add new range to the state of info
////////////////////////////////////////////////////////////
function savePanelData () {
	if (validatePanelData()) {
		var datasent = new Object;
		var categorys = new Array();
		if (top.getData("category", 1)) {
			categorys = top.getData("category", 1);
		}

		datasent.categorySKU = document.f1.categorySKU.value;
		datasent.minCatQty = document.f1.minCatQty.value;
		datasent.maxCatQty = document.f1.maxCatQty.value;
		datasent.minCatAmt = document.f1.minCatAmt.value;
		datasent.maxCatAmt = document.f1.maxCatAmt.value;

		categorys[categorys.length] = datasent;

		//
		// save the current data and go back to the previous widget
		//
		top.sendBackData(categorys, "category");
		top.goBack();

		return true;
	}

	return false;
}

function writeCurrency () {
	var storeCurrs;
	storeCurrs = top.getData("storeCurrArray", 1);
	document.write(storeCurrs[top.getData("eCouponCurrSelectedIndex", 1)]);
}

/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function validatePanelData () {
	if (isEmpty(document.f1.categorySKU.value)) {
		reprompt(document.f1.categorySKU, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCategorySKUBlankMsg").toString()) %>");
		return false;
	}
	else {
		// check if the selected category is already existed or not
		var categorySet = top.getData("category", 1);
		for (var j=0; j<categorySet.length; j++) {
			if (trim(categorySet[j].categorySKU) == trim(document.f1.categorySKU.value)) {
				alertDialog("<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategorySKUInvalid")) %>");
				return false;
			}
		}
	}

	if ((!isEmpty(document.f1.minCatQty.value)) && ((!isValidPositiveInteger(trim(document.f1.minCatQty.value))) || (document.f1.minCatQty.value<=0))) {
		reprompt(document.f1.minCatQty, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMinNotNumber").toString()) %>");
		return false;
	}
	else if ((!isEmpty(document.f1.maxCatQty.value)) && ((!isValidPositiveInteger(trim(document.f1.maxCatQty.value))) || (document.f1.maxCatQty.value<=0))) {
		reprompt(document.f1.maxCatQty, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMaxNotNumber").toString()) %>");
		return false;
	}
	else if ((!isEmpty(document.f1.minCatQty.value)) && (!isEmpty(document.f1.maxCatQty.value)) && (parent.strToInteger(trim(document.f1.maxCatQty.value)) < parent.strToInteger(trim(document.f1.minCatQty.value)))) {
		reprompt(document.f1.maxCatQty, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMaxMinNumInvalid").toString()) %>");
		return false;
	}

	// Now validate the order level data - similar to what's done on order page
	if (!isEmpty(document.f1.minCatAmt.value)) {
		if (parent.currencyToNumber(trim(document.f1.minCatAmt.value), fCurr,"<%= fLanguageId %>").toString().length > 14) {
			reprompt(document.f1.minCatAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catCurrencyTooLong").toString()) %>");
			return false;
		}
		else if (!parent.isValidCurrency(trim(document.f1.minCatAmt.value), fCurr, "<%= fLanguageId %>")) {
			reprompt(document.f1.minCatAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMinAmtInvalid").toString()) %>");
			return false;
		}
		else if (document.f1.minCatAmt.value <= 0) {
			// Flagging error if minCat amount is 0 - which merchant might do if he does not want to give value condition
			reprompt(document.f1.minCatAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMinAmtInvalid").toString()) %>");
			return false;
		}
	}

	if (!isEmpty(document.f1.maxCatAmt.value)) {
		if (parent.currencyToNumber(trim(document.f1.maxCatAmt.value), fCurr, "<%= fLanguageId %>").toString().length > 14) {
			reprompt(document.f1.maxCatAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catCurrencyTooLong").toString()) %>");
			return false;
		}
		else if (!parent.isValidCurrency(trim(document.f1.maxCatAmt.value), fCurr, "<%= fLanguageId %>")) {
			reprompt(document.f1.maxCatAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMaxAmtInvalid").toString()) %>");
			return false;
		}
		else if (document.f1.maxCatAmt.value <= 0) {
			reprompt(document.f1.maxCatAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMaxAmtInvalid").toString()) %>");
			return false;
		}
	}

	if ((!isEmpty(document.f1.minCatAmt.value)) && (!isEmpty(document.f1.maxCatAmt.value)) && ((parent.currencyToNumber(trim(document.f1.maxCatAmt.value),fCurr,"<%= fLanguageId %>")) < (parent.currencyToNumber(trim(document.f1.minCatAmt.value), fCurr, "<%= fLanguageId %>")))) {
		reprompt(document.f1.maxCatAmt, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catMaxMinAmtInvalid").toString()) %>");
		return false;
	}

	// now checking if both are null
	if ((isEmpty(document.f1.minCatQty.value)) && (isEmpty(document.f1.minCatAmt.value))) {
		reprompt(document.f1.minCatQty, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("catBothMinNull").toString()) %>");
		return false;
	}

	// Check if Category SKU already Exists or not
	var categorys = new Array();
	if (top.getData("category")) {
		categorys = top.getData("category");
		for (var i=0; i<categorys.length; i++) {
			if (categorys[i].categorySKU == document.f1.categorySKU.value) {
				alertDialog("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCategorySKUInvalid").toString()) %>");
				document.f1.categorySKU.select();
				return false;
			}
		}
	}

	// Check if Category SKU is valid or not
	if (needValidation) {
		this.location.replace("/webapp/wcs/tools/servlet/eCouponWizCategoryAddView?categoryIdentifier=" + trim(document.f1.categorySKU.value) + "&minCatQty=" + trim(document.f1.minCatQty.value) + "&maxCatQty=" + trim(document.f1.maxCatQty.value) + "&minCatAmt=" + trim(document.f1.minCatAmt.value) + "&maxCatAmt=" + trim(document.f1.maxCatAmt.value));
		return false;
	}
	else {
		return true;
	}
}

function gotoSearchSkuDialog () {
	top.saveData(null, "findSkuSearchString");
	top.saveData(null, "findNameSearchString");
	top.saveData(null, "findShortSearchString");
	top.saveData(null, "findSkuTypeSearchString");
	top.saveData(null, "findNameTypeSearchString");
	top.saveData(null, "findShortTypeSearchString");

	if (document.f1.categorySKU.value != null) {
		top.saveData(document.f1.categorySKU.value, "categorySKU");
	}
	if (document.f1.minCatQty.value != null) {
		top.saveData(document.f1.minCatQty.value, "minCatQty");
	}
	if (document.f1.maxCatQty.value != null) {
		top.saveData(document.f1.maxCatQty.value, "maxCatQty");
	}
	if (document.f1.minCatAmt.value != null) {
		top.saveData(document.f1.minCatAmt.value, "minCatAmt");
	}
	if (document.f1.maxCatAmt.value != null) {
		top.saveData(document.f1.maxCatAmt.value, "maxCatAmt");
	}

	top.saveData("/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponCategoryAdd", "finderReturnURL");

	//
	// go to the search result panel
	//
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponCategoryFindDialog";
	top.setContent("<%= eCouponWizardNLS.get("eCouponCategoryFindPrompt") %>", url, true);
}

</script>
</head>

<body class="content" onload="initializeState();">

<h1><%= eCouponWizardNLS.get("eCouponAddCategoryWindowTitle") %></h1>
<form name="f1" id="f1">
<label for="categorySKU"><%= eCouponWizardNLS.get("eCouponCategorySKU") %></label>
<br />
<input type='text' name='categorySKU' value="" size="30" maxlength="64" id="categorySKU" />&nbsp;&nbsp;<button type='button' value='searchSKU' name='findSkuButton' class="enabled" onclick="gotoSearchSkuDialog()"><%= eCouponWizardNLS.get("eCouponFindCategory") %></button> <br /><br />
<p>

<label for="minCatQty"><%= eCouponWizardNLS.get("eCouponAsterisk") %><%= eCouponWizardNLS.get("eCouponCategoryMinQty") %></label>
<input type='text' name='minCatQty' value="" size="14" maxlength="14" id="minCatQty" /><br /><br />

<label for="maxCatQty"><%= eCouponWizardNLS.get("eCouponCategoryMaxQty") %></label>
<input type='text' name='maxCatQty' value="" size="14" maxlength="14" id="maxCatQty" /> <%= eCouponWizardNLS.get("eCouponCategoryOptionalMsg") %><br /><br />

<label for="minCatAmt"><%= eCouponWizardNLS.get("eCouponAsterisk") %><%= eCouponWizardNLS.get("eCouponCategoryMinAmt") %></label>
<input type='text' name='minCatAmt' value="" size="14" maxlength="14" id="minCatAmt" />

<script language="JavaScript">
writeCurrency();

</script>

<br /><br />

<label for="maxCatAmt"><%= eCouponWizardNLS.get("eCouponCategoryMaxAmt") %></label>
<input type='text' name='maxCatAmt' value="" size="14" maxlength="14" id="maxCatAmt" />
<script language="JavaScript">
writeCurrency();

</script><%= eCouponWizardNLS.get("eCouponCategoryOptionalMsgLocale") %>

<br /><br />
</p></form>
<%= eCouponWizardNLS.get("eCouponCategoryPurchaseFooter") %>

<script>
document.f1.categorySKU.focus();
parent.setContentFrameLoaded(true);

</script>

</body>

</html>
