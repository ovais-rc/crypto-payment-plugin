<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2003
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
	String productSku = request.getParameter("productSku");
	String productQty = request.getParameter("productQty");

	if (productSku == null) {
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
				catalogStoreIds += " " + relatedStores[i].toString();
			}
		}
		catch (Exception e) {
		}

		// use the search API to check if the given product SKU is valid or not
		try {
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
<title><%= eCouponWizardNLS.get("eCouponAddProductWindowTitle") %></title>

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
	var foundSku = top.getData("productSearchSkuArray");

	if (foundSku != null) {
		document.f1.productSKU.value = foundSku[0].productSku;
		top.saveData(null, "productSearchSkuArray");
		top.saveData(null, "findSkuSearchString");
	}
	else {
<%	if (productSku != null) { %>
		document.f1.productSKU.value = "<%=UIUtil.toJavaScript( productSku )%>";
<%	} else { %>
		if (top.getData("productSKU") != null) {
			document.f1.productSKU.value = top.getData("productSKU");
			top.saveData(null, "productSKU");
		}
<%	} %>
	}

<%	if (productQty != null) { %>
	document.f1.qty.value = "<%=UIUtil.toJavaScript( productQty )%>";
<%	} else { %>
	if (top.getData("qty") != null) {
		document.f1.qty.value = top.getData("qty");
		top.saveData(null, "qty");
	}
<%	} %>

	if (leavePanel) {
		savePanelData();
	}
	else {
		if (isInvalid) {
			alertDialog("<%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductSKUWrong")) %>");
			document.f1.productSKU.select();
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
		var products = new Array();
		if (top.getData("product", 1)) {
			products = top.getData("product", 1);
		}
		datasent.productSKU = document.f1.productSKU.value;
		datasent.qty = document.f1.qty.value;
		products[products.length] = datasent;

		//
		// save the current data and go back to the previous widget
		//
		top.sendBackData(products, "product");
		top.goBack();

		return true;
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function validatePanelData () {
	if (isEmpty(document.f1.productSKU.value)) {
		reprompt(document.f1.productSKU, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponProductSKUBlankMsg").toString()) %>");
		return false;
	}
	else if ((!isValidPositiveInteger(trim(document.f1.qty.value))) || (eval(document.f1.qty.value)==0)) {
		reprompt(document.f1.qty, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("prodMinNotNumber").toString()) %>");
		return false;
	}

	// Check if Product SKU already Exists or not
	var products = new Array();
	if (top.getData("product")) {
		products = top.getData("product");
		for (var i=0; i<products.length; i++) {
			if (products[i].productSKU == document.f1.productSKU.value) {
				alertDialog("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponProductSKUInvalid").toString()) %>");
				document.f1.productSKU.select();
				return false;
			}
		}
	}

	// Check if Product SKU is valid or not
	if (needValidation) {
		this.location.replace("/webapp/wcs/tools/servlet/eCouponWizProductAddView?productSku=" + trim(document.f1.productSKU.value) + "&productQty=" + trim(document.f1.qty.value));
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

	if (document.f1.productSKU.value != null) {
		top.saveData(document.f1.productSKU.value, "productSKU");
	}
	if (document.f1.qty.value != null) {
		top.saveData(document.f1.qty.value, "qty");
	}
	top.saveData("/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponProductAdd", "finderReturnURL");

	//
	// go to the search result panel
	//
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponProductFindDialog";
	top.setContent("<%= eCouponWizardNLS.get("eCouponProductFindPrompt") %>", url, true);
}

</script>
</head>

<body class="content" onload="initializeState();">

<h1><%= eCouponWizardNLS.get("eCouponAddProductWindowTitle") %></h1>
<form name="f1" id="f1">
<label for="productSKU"><%= eCouponWizardNLS.get("eCouponProductSKU") %></label>
<br />
<input type='text' name='productSKU' value="" size="14" maxlength="64" id="productSKU" />&nbsp;&nbsp;<button type='button' value='searchSKU' name='findSkuButton' class="enabled" onclick="gotoSearchSkuDialog()"><%= eCouponWizardNLS.get("eCouponFindProduct") %></button> <br /><br />
<p>
<label for="qty"><%= eCouponWizardNLS.get("eCouponProductQty") %></label>
<br />
<input type='text' name='qty' value="" size="14" maxlength="14" id="qty" /><br /><br />
</p></form>

<script>
document.f1.productSKU.focus();
parent.setContentFrameLoaded(true);

</script>

</body>

</html>
