<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c)  Copyright  IBM Corp.  2000, 2016      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<?xml version="1.0"?>
<%@ include file="eCouponCommon.jsp" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>

<%
	StoreAccessBean storeAB = com.ibm.commerce.server.WcsApp.storeRegistry.find(fStoreId);

	// get the supported currencies for a store
	CurrencyManager cm = CurrencyManager.getInstance();
	String[] supportedCurrencies = cm.getSupportedCurrencies( storeAB );
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title><%= eCouponWizardNLS.get("eCouponDetails_title") %></title>
<%= feCouponHeader %>

<script src="/wcs/javascript/tools/common/Util.js">
</script>
<script src="/wcs/javascript/tools/common/DateUtil.js">
</script>

<script language="JavaScript">
function initializeState () {
	var visitedDetailsForm = parent.get("visitedDetailsForm", false);
	if (visitedDetailsForm) {
		// load the catalog id to the checkboxes
		if (document.detailsForm.catalog != undefined) {
			if (document.detailsForm.catalog.type == "radio") {
				document.detailsForm.catalog.checked = true;
			}
			else {
				for (var i=0; i<document.detailsForm.catalog.length; i++) {
					if (parent.get("catalogId") == document.detailsForm.catalog[i].value) {
						document.detailsForm.catalog[i].checked = true;
						break;
					}
				}
			}
		}

		// added for modify coupon promotion
		// get curr selected index if modify
		if (!eval(parent.get("newECouponPromotion"))) {
			currArray();
			getCurrIndex();
		}

		loadDiscCurr();
		document.detailsForm.eCouponCurr.selectedIndex = parent.get("eCouponCurrSelectedIndex");

		var hasNumOffer = parent.get("hasNumOffer", false);
		if (hasNumOffer) {
			document.detailsForm.hasNumOffer[1].checked = true;
			if (parent.get("eCouponNumOffer")) {
				document.detailsForm.eCouponNumOffer.value = parent.get("eCouponNumOffer");
			}
			showNumOfferField();
		}
		else {
			document.detailsForm.hasNumOffer[0].checked = true;
			hideNumOfferField();
		}

		// added for modify coupon promotion
		if (eval(parent.get("newECouponPromotion"))) {
			if (eval(parent.get("purchaseConditionType")) == 0) {
				document.detailsForm.purchaseConditionType[0].checked = true;
				document.detailsForm.purchaseConditionType[0].focus();
			}
			else if (eval(parent.get("purchaseConditionType")) == 1) {
				document.detailsForm.purchaseConditionType[1].checked = true;
				document.detailsForm.purchaseConditionType[1].focus();
			}
			else {
				document.detailsForm.purchaseConditionType[2].checked = true;
				document.detailsForm.purchaseConditionType[2].focus();
				showCatalogs();
			}
		}
	}
	else {
		// populate the currency array and the select
		currArray();

		// put currency options into box ...
		loadDiscCurr();
	}

	parent.setContentFrameLoaded(true);
}

function savePanelData () {
	// save all currency and other stuff
	// put currency choice in the top frame ...
	parent.put("eCouponCurrSelectedIndex", document.detailsForm.eCouponCurr.selectedIndex);

	// put actual currency in top frame to be used by server side command
	var storeCurrs = parent.get("storeCurrArray");
	parent.put("eCouponCurr", storeCurrs[document.detailsForm.eCouponCurr.selectedIndex]);

	// Put the num coupons
	if (document.detailsForm.hasNumOffer[1].checked) {
		parent.put("hasNumOffer", true);
		if (isValidPositiveInteger(trim(document.detailsForm.eCouponNumOffer.value))) {
			parent.put("eCouponNumOffer", parent.strToNumber(trim(document.detailsForm.eCouponNumOffer.value), "<%= fLanguageId %>"));
		}
	}
	else {
		parent.put("hasNumOffer", false);
	}

	// added the if condition for modify coupon promotion
	if (eval(parent.get("newECouponPromotion"))) {
		i = 0;
		while (!document.detailsForm.purchaseConditionType[i].checked) {
			i++;
		}
		switch (eval(i)) {
			case 0:

				parent.setNextBranch("eCouponProductPurchaseCondition");
				// Make sure u add a panel for product purchase condition TO DO
				parent.put("purchaseConditionType",0);

				//null for order
				parent.put("visitedOrderValueForm",null)
				parent.put("visitedOrderPurchaseCondition",null)
				parent.put("minAmt",null)
				parent.put("maxAmt",null)
				parent.put("orderType",null)
				parent.put("orderPercentageAmt",null)
				parent.put("orderFixedAmt",null)
				//null for category
				parent.put("visitedCategoryValueForm",null)
				parent.put("visitedCategoryPurchaseCondition",null)
				parent.put("minCatAmt",null)
				parent.put("maxCatAmt",null)
				parent.put("minCatQty",null)
				parent.put("maxCatQty",null)
				parent.put("categoryType",null)
				parent.put("categoryPercentageAmt",null)
				parent.put("categoryFixedAmt",null)

				break;

			case 1:

				parent.setNextBranch("eCouponOrderPurchaseCondition");
				// TO DO add no panel access to product discount page
				parent.put("purchaseConditionType",1);

				parent.put("product",null)
				parent.put("oldPurchaseConditionType",null)
				parent.put("visitedProductPurchaseForm",null)
				parent.put("checkedProducts",null)
				parent.put("productType",null)
				parent.put("productFixedAmt",null)
				parent.put("productPercentageAmt",null)

				parent.put("visitedCategoryValueForm",null)
				parent.put("visitedCategoryPurchaseCondition",null)
				parent.put("minCatAmt",null)
				parent.put("maxCatAmt",null)
				parent.put("minCatQty",null)
				parent.put("maxCatQty",null)
				parent.put("categoryType",null)
				parent.put("categoryPercentageAmt",null)
				parent.put("categoryFixedAmt",null)

				break;

			case 2:

				parent.setNextBranch("eCouponCategoryPurchaseCondition");
				// TO DO add no panel access to product discount page
				parent.put("purchaseConditionType",2);

				parent.put("product",null)
				parent.put("oldPurchaseConditionType",null)
				parent.put("visitedProductPurchaseForm",null)
				parent.put("checkedProducts",null)
				parent.put("productType",null)
				parent.put("productFixedAmt",null)
				parent.put("productPercentageAmt",null)

				parent.put("visitedOrderValueForm",null)
				parent.put("visitedOrderPurchaseCondition",null)
				parent.put("minAmt",null)
				parent.put("maxAmt",null)
				parent.put("orderType",null)
				parent.put("orderPercentageAmt",null)
				parent.put("orderFixedAmt",null)

				// get the catalog id from the checkboxes
				if (document.detailsForm.catalog != undefined) {
					if (document.detailsForm.catalog.type == "radio") {
						parent.put("catalogId", document.detailsForm.catalog.value);
					}
					else {
						for (var i=0; i<document.detailsForm.catalog.length; i++) {
							if (document.detailsForm.catalog[i].checked) {
								parent.put("catalogId", document.detailsForm.catalog[i].value);
								break;
							}
						}
					}
				}

				break;
		}
	}

	parent.put("visitedDetailsForm", true);
	return true;
}

function validatePanelData () {
	if (document.detailsForm.hasNumOffer[1].checked) {
		if ((!isValidPositiveInteger(trim(document.detailsForm.eCouponNumOffer.value))) || (eval(document.detailsForm.eCouponNumOffer.value) == 0)) {
			reprompt(document.detailsForm.eCouponNumOffer, "<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponNumOfferInvalid").toString()) %>");
			parent.put("visitedDetailsForm", false);
			return false;
		}
	}
	return true;
}

function currArray () {
	var currArray = new Array();
<%
	int i = 0;
	while (i < supportedCurrencies.length) {
%>
	currArray[<%= i %>] = "<%= supportedCurrencies[i] %>";
<%
		i++;
	}
%>

	// sort currency
	currArray.sort();
	parent.put("storeCurrArray", currArray);
}

function loadDiscCurr () {
	var storeCurrs = parent.get("storeCurrArray");

	for (var i=0; i<storeCurrs.length; i++) {
		document.detailsForm.eCouponCurr.options[i] = new Option(storeCurrs[i], storeCurrs[i], false, false);
	}
}

// added for modify coupon promotion
function getCurrIndex () {
	var storeCurrs = parent.get("storeCurrArray");
	var selectedCurr = parent.get("eCouponCurr");

	for (var i=0; i<storeCurrs.length; i++) {
		// compare the eCouponCurr and get its index
		if (storeCurrs[i] == selectedCurr) {
			parent.put("eCouponCurrSelectedIndex", i);
			break;
		}
	}
}

function hideNumOfferField () {
	document.all["numOfferArea"].style.display = "none";
}

function showNumOfferField () {
	document.all["numOfferArea"].style.display = "block";
	document.detailsForm.eCouponNumOffer.focus();
}

//added to support modify coupon promotion and category coupons
function writePurchaseCond () {
	if (!eval(parent.get("newECouponPromotion"))) {
		document.write("<I>");
		document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponPurchaseConditionTypeLabelWithColon").toString()) %>");
		if (eval(parent.get("purchaseConditionType")) == 0) {
			// product
			document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponProductPurchaseConditionType").toString()) %>");
		}
		else if (eval(parent.get("purchaseConditionType")) == 1) {
			// order
			document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponOrderPurchaseConditionType").toString()) %>");
		}
		else if (eval(parent.get("purchaseConditionType")) == 2) {
			// category
			document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCategoryPurchaseConditionType").toString()) %>");
		}
		document.write("</I>");
	}
	else {
		document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponPurchaseConditionTypeLabel").toString()) %>");
		document.write("<br>");
		document.write("<input type=\"radio\" name=\"purchaseConditionType\" onclick=\"javascript:hideCatalogs()\;\" checked>" + " <%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponProductPurchaseConditionType").toString()) %>");
		document.write("<br>");
		document.write("<input type=\"radio\" name=\"purchaseConditionType\" onclick=\"javascript:hideCatalogs()\;\" >" + " <%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponOrderPurchaseConditionType").toString()) %>");
		document.write("<br>");
		document.write("<input type=\"radio\" name=\"purchaseConditionType\"  onclick=\"javascript:showCatalogs()\;\">" + " <%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCategoryPurchaseConditionType").toString()) %>");
		document.write("<div id=\"catalogArea\" style=\"display:none\;\">");
		document.write("<blockquote>");
<%
	try {
		CommandContextImpl commandContext = (CommandContextImpl)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		if (commandContext == null) {
			return;
		}
		Integer storeId = commandContext.getStoreId();
		Integer langId = commandContext.getLanguageId();
		boolean firstCat = true;

		CatalogAccessBean tempCAB = new CatalogAccessBean();
		Enumeration catalogs = tempCAB.findByStoreId(storeId);
%>
		document.write("<table cellpadding=1 cellspacing=0 border=0 width=90% bgcolor=6D6D7C><tr><td>");
		document.write("<table id=\"catalogTable\" class=\"list\" border=0 cellpadding=0 cellspacing=0 width=100%>");
		document.write("<tr>");
		document.write("<th class=\"list_header\" textcolor=\"white\">&nbsp;</th>");
		document.write("<th class=\"list_header\" textcolor=\"white\">");
		document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCatalogIdentifier").toString()) %></th>");
		document.write("<th class=\"list_header\" textcolor=\"white\">");
		document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCatalogName").toString()) %></th>");
		document.write("<th class=\"list_header\" textcolor=\"white\">");
		document.write("<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCatalogDescription").toString()) %></th>");
		document.write("</tr>");
<%
		int rowselect = 1;
		while (catalogs.hasMoreElements()) {
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
%>
		document.write("<tr class=\"list_row<%= rowselect %>\" onmouseover=\"parent.tempClass=this.className;this.className=\'list_row3\';\" onmouseout=\"this.className=parent.tempClass\">");
		document.write("<td>");
<%
			CatalogAccessBean cAB = (CatalogAccessBean) catalogs.nextElement();
			if (firstCat) {
%>
		document.write("<input type=\"radio\" name=\"catalogId\" id=\"catalog\" value=\""+ <%= cAB.getCatalogReferenceNumber() %> + "\" checked>");
<%
				firstCat = false;
			}
			else {
%>
		document.write("<input type=\"radio\" name=\"catalogId\" id=\"catalog\" value=\""+ <%= cAB.getCatalogReferenceNumber() %> + "\" >");
<%			} %>
		document.write("</td>");
		document.write("<td class=\"list_info1\">");
		document.write("<%= cAB.getIdentifier() %>");
		document.write("</td>");
		document.write("<td class=\"list_info1\">");
<%
			String currentName = null;
			String currentDesc = null;
			try {
				CatalogDescriptionAccessBean cdAB = new CatalogDescriptionAccessBean();
				cdAB.setInitKey_catalogReferenceNumber(cAB.getCatalogReferenceNumber());
				cdAB.setInitKey_language_id(com.ibm.commerce.command.ECStringConverter.IntegerToString(langId));
				currentName = cdAB.getName();
				currentDesc = cdAB.getShortDescription();
			}
			catch (Exception e) {
			}
			if (currentName == null) {
				currentName = "&nbsp;";
			}
			if (currentDesc == null) {
				currentDesc = "&nbsp;";
			}
%>
		document.write("<%= currentName %>");
		document.write("</td>");
		document.write("<td class=\"list_info1\">");
		document.write("<%= currentDesc %>");
		document.write("</td>");
		document.write("</tr>");
<%		} %>
		document.write("</table></td></tr></table>");
<%
	}
	catch(Exception e) {
		e.printStackTrace();
	}
%>
		document.write("</blockquote>");
		document.write("</div>");
	}
}

function hideCatalogs () {
	document.all["catalogArea"].style.display = "none";
}

function showCatalogs () {
	document.all["catalogArea"].style.display = "block";

	if (document.detailsForm.catalog != undefined) {
		if (document.detailsForm.catalog.type == "radio") {
			document.detailsForm.catalog.focus();
		}
		else {
			for (var i=0; i<document.detailsForm.catalog.length; i++) {
				if (document.detailsForm.catalog[i].checked) {
					document.detailsForm.catalog[i].focus();
					break;
				}
			}
		}
	}
}
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>

<body class="content" onload="initializeState();">

<form name="detailsForm" onsubmit="return false;" id="detailsForm">

<h1><%= eCouponWizardNLS.get("eCouponDetails") %></h1>

<p><label for="eCouponCurr"><%= eCouponWizardNLS.get("eCouponCurrLabel") %></label><br />
<select name="eCouponCurr" id="eCouponCurr"></select> </p>

<p><label for="hasNumOffer"><%= eCouponWizardNLS.get("eCouponNumOfferLabel") %></label><br />
<input name="hasNumOffer" type="radio" onclick="javascript:hideNumOfferField();" checked ="checked" id="hasNumOffer" /> <%= eCouponWizardNLS.get("eCouponNotSpecified") %> <br />
<input name="hasNumOffer" type="radio" onclick="javascript:showNumOfferField();" id="hasNumOffer" />
<label for="eCouponNumOffer"><%= eCouponWizardNLS.get("eCouponSpecified") %></label> <br />
</p><div id="numOfferArea" style="display:none">
<blockquote>
<input name="eCouponNumOffer" id="eCouponNumOffer" type="text" size="14" maxlength="10" />
</blockquote>
</div>

<p>
<script language="JavaScript">
writePurchaseCond();
</script>
</p>

<script>
parent.setContentFrameLoaded(true);
</script>

</form>

</body>

</html>