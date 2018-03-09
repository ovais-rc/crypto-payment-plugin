<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeScheduleDataBean,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeScheduleListDataBean,
	java.text.DateFormat" %>

<%@ include file="common.jsp" %>

<%
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, campaignCommandContext.getLocale());

	CampaignInitiativeScheduleListDataBean initiativeScheduleList = new CampaignInitiativeScheduleListDataBean();
	CampaignInitiativeScheduleDataBean initiativeSchedules[] = null;
	int numberOfInitiativeSchedules = 0;
	DataBeanManager.activate(initiativeScheduleList, request);
	initiativeSchedules = initiativeScheduleList.getCampaignInitiativeScheduleList();
	if (initiativeSchedules != null) {
		numberOfInitiativeSchedules = initiativeSchedules.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("initiativeSummaryDialogTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var defaultCurrency = "";
var inventoryLevel = new Array();
var offerPrice = new Array();
var availableDate = "";

////////////////////////////////////////////////////////////////////////////////////
// This method is used to return the display text of the customer behavior type
// given the identifier.
////////////////////////////////////////////////////////////////////////////////////
function getWhichText (whichAction) {
	if (whichAction == "<%= CampaignConstants.SHOPPING_CART_CONTAINS_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_CONTAINS_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPPING_CART_DOESNOT_CONTAIN_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_DOES_NOT_CONTAIN_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPPING_CART_CONTAINS_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_CONTAINS_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPPING_CART_DOESNOT_CONTAIN_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOPPING_CART_DOES_NOT_CONTAIN_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_CONTAINS_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_CONTAINS_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_DOESNOT_CONTAIN_SKU %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_DOES_NOT_CONTAIN_SKU)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_CONTAINS_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_CONTAINS_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.PURCHASE_HISTORY_DOESNOT_CONTAIN_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_PURCHASE_HISTORY_DOES_NOT_CONTAIN_CATEGORY)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPCART_TOTAL_GREATERTHAN %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOP_CART_TOTAL_GREATER_THAN)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPCART_TOTAL_LESSTHAN %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOP_CART_TOTAL_LESS_THAN)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.SHOPCART_TOTAL_EQUALTO %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_SHOP_CART_TOTAL_EQUAL_TO)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.BROWSING_PRODUCT %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_BROWSING_PRODUCT)) %>";
	}
	else if (whichAction == "<%= CampaignConstants.BROWSING_CATEGORY %>") {
		return "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_ADD_BROWSING_CATEGORY)) %>";
	}
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to get all the data of this initiative to display on the
// page.
////////////////////////////////////////////////////////////////////////////////////
function loadInitiative () {
	var initiative = parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);

	if (initiative != null) {
		// set the currency of this initiative
		defaultCurrency = initiative.currency;

		// display name, description and selected campaign
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryNamePrompt")) %>", initiative.<%= CampaignConstants.ELEMENT_INITIATIVE_NAME %>);
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryDescriptionPrompt")) %>", convertFromTextToHTML(initiative.<%= CampaignConstants.ELEMENT_DESCRIPTION %>));
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryCampaignPrompt")) %>", convertFromTextToHTML(initiative.<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>));

		// display dates for targeting customers
		displayTargetDates("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryTargetDatesPrompt")) %>", initiative.<%= CampaignConstants.ELEMENT_DAYS_OF_THE_WEEK %>, initiative.<%= CampaignConstants.ELEMENT_EVERYDAY %>);

		// display initiative content type
		displayContentType("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryContentTypePrompt")) %>", initiative.<%= CampaignConstants.ELEMENT_WHAT_TYPE %>);

		// display displayed content section's title and the content details
		displayRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryDisplayedContentTitle")) %>", "");
		displayContentDetail(initiative);

		// display target customers
		displayTargetCustomers("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryTargetCustomersPrompt")) %>", initiative.<%= CampaignConstants.ELEMENT_SELECTED_SEGMENTS %>);

		// display target customer behaviors
		displayTargetCustomerBehaviors("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryTargetCustomerBehaviorsPrompt")) %>", initiative.<%= CampaignConstants.ELEMENT_WHEN_CHOICES %>);

		// display schedules associated with this initiative
		displaySchedules("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySchedulesPrompt")) %>");
	}
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display a single row on the page given the field name and
// field value.
////////////////////////////////////////////////////////////////////////////////////
function displayRow (columnName, columnValue) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
	document.writeln('		<td><i>' + columnValue + '</i></td>');
	document.writeln('	</tr>');
	document.writeln('</table></p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the initiative classification given the field
// title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displayContentType (columnName, columnValue) {
	var displayValue = "";
	if (columnValue == "<%= CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL)) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_COUPON_COLLATERAL %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.WHAT_TYPE_COUPON_COLLATERAL)) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_PRODUCT %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.WHAT_TYPE_PRODUCT)) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_CATEGORY %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.WHAT_TYPE_CATEGORY)) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_COLLATERAL %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.WHAT_TYPE_COLLATERAL)) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_UP_SELL %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.WHAT_TYPE_UP_SELL)) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_CROSS_SELL %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.WHAT_TYPE_CROSS_SELL)) %>";
	}
	displayRow(columnName, displayValue);
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display a single row on the page given the field name and
// field value, with the row indented and starts with a HTML bullet.
////////////////////////////////////////////////////////////////////////////////////
function displayIndentRow (columnName, columnValue) {
	document.writeln('<table border="0" cellspacing="1" cellpadding="1"');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap><li>' + columnName + '&nbsp;</li></td>');
	document.writeln('		<td><i>' + columnValue + '</i></td>');
	document.writeln('	</tr>');
	document.writeln('</table>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the displayed content given the field title and
// its value.
////////////////////////////////////////////////////////////////////////////////////
function displayDisplayedContent (columnName, columnValue) {
	var displayValue = "";
	if (columnValue == "<%= CampaignConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeWhatSpecificProduct")) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_CATEGORY %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeWhatRecommendCategory")) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_COLLATERAL %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeWhatCollateral")) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_COLLABORATIVE_FILTERING %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeWhatCollaborativeFiltering")) %>";
	}
	else if (columnValue == "<%= CampaignConstants.WHAT_TYPE_PRODUCT_ATTRIBUTES %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeWhatFollowingCriteria")) %>";
	}
	else {
		return;
	}
	displayIndentRow(columnName, displayValue);
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the selected products in product recommendation
// or selected categories in category recommendation given the field title and its
// value.
////////////////////////////////////////////////////////////////////////////////////
function displayProductCategory (columnName, columnValues) {
	document.writeln('<table border="0" cellspacing="1" cellpadding="1">');
	if (columnValues.length == 0) {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap><li>' + columnName + '&nbsp;</li></td>');
		document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedNone")) %>' + '</i></td>');
		document.writeln('	</tr>');
	}
	else {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap><li>' + columnName + '&nbsp;</li></td>');
		document.writeln('		<td><i>' + columnValues[0] + '</i></td>');
		document.writeln('	</tr>');
	}
	if (columnValues.length > 1) {
		for (var i=1; i<columnValues.length; i++) {
			document.writeln('	<tr>');
			document.writeln('		<td>&nbsp;</td>');
			document.writeln('		<td><i>' + columnValues[i] + '</i></td>');
			document.writeln('	</tr>');
		}
	}
	document.writeln('</table>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the inventory level filter using the value stored
// in the common javascript variable in the page.
////////////////////////////////////////////////////////////////////////////////////
function displayInventoryLevel () {
	if (inventoryLevel.length == 0) return;

	displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeInventory")) %>", "");

	for (var i=0; i<inventoryLevel.length; i++) {
		var inventoryOperator = "";
<%	for (int i=0; i<CampaignConstants.operatorArray.length; i++) { %>
		if (inventoryLevel[i].value1 == "<%= CampaignConstants.operatorArray[i] %>") {
			inventoryOperator = "<%= campaignsRB.get("initiativeWhat" + CampaignConstants.operatorArray[i]) %>";
		}
<%	} %>

		var inventoryValue = parent.numberToStr(inventoryLevel[i].value2, "<%= campaignCommandContext.getLanguageId().toString() %>", 0);
		if (inventoryValue.toString() == "NaN") {
			inventoryValue = inventoryLevel[i].value2;
		}

		document.writeln('<ul><table border="0" cellspacing="1" cellpadding="1"');
		document.writeln('	<tr>');
		document.writeln('		<td><li><i>' + inventoryOperator + '&nbsp;' + inventoryValue + '</i></li></td>');
		document.writeln('	</tr>');
		document.writeln('</table></ul>');
	}
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the offer price filter using the value stored in
// the common javascript variable in the page.
////////////////////////////////////////////////////////////////////////////////////
function displayOfferPrice () {
	if (offerPrice.length == 0) return;

	displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributePrice")) %>", "");

	for (var i=0; i<offerPrice.length; i++) {
		var priceOperator = "";
<%	for (int i=0; i<CampaignConstants.operatorArray.length; i++) { %>
		if (offerPrice[i].value1 == "<%= CampaignConstants.operatorArray[i] %>") {
			priceOperator = "<%= campaignsRB.get("initiativeWhat" + CampaignConstants.operatorArray[i]) %>";
		}
<%	} %>

		var priceValue = parent.numberToCurrency(offerPrice[i].value2, defaultCurrency, "<%= campaignCommandContext.getLanguageId().toString() %>");
		if (priceValue.toString() == "NaN") {
			priceValue = offerPrice[i].value2;
		}

		document.writeln('<ul><table border="0" cellspacing="1" cellpadding="1"');
		document.writeln('	<tr>');
		document.writeln('		<td><li><i>' + priceOperator + '&nbsp;' + priceValue + '&nbsp;(' + defaultCurrency + ')</i></li></td>');
		document.writeln('	</tr>');
		document.writeln('</table></ul>');
	}
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the availability date filter using the value
// stored in the common javascript variable in the page.
////////////////////////////////////////////////////////////////////////////////////
function displayAvailableDate () {
	if (availableDate == "") return;

	displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeDate")) %>", "");

	var lastDashIndex = availableDate.indexOf("-", 5);
	document.writeln('<ul>');
	displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeYear")) %>", availableDate.substring(0, 4));
	displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeMonth")) %>", availableDate.substring(5, lastDashIndex));
	displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeDay")) %>", availableDate.substring(lastDashIndex + 1));
	document.writeln('</ul>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display all the values in the product suggestion filter
// given the initiative databean object.
////////////////////////////////////////////////////////////////////////////////////
function displayProductAttributes (initiativeObj) {
	var paObj = initiativeObj.productAttributes;

	for (var i=0; i<paObj.length; i++) {
		if (paObj[i].type == "<%= CampaignConstants.CATEGORY %>") {
			displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeCategory")) %>", initiativeObj.productAttributesCGName);
		}
		else if (paObj[i].type == "<%= CampaignConstants.PRODUCT_DESCRIPTION %>") {
			displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeKeyword")) %>", paObj[i].value1);
		}
		else if (paObj[i].type == "<%= CampaignConstants.SKU %>") {
			displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryProductAttributeSKU")) %>", paObj[i].value1);
		}
		else if ((paObj[i].type == "<%= CampaignConstants.LOW_INVENTORY %>") || (paObj[i].type == "<%= CampaignConstants.HIGH_INVENTORY %>")) {
			var inventoryLevelLength = inventoryLevel.length;
			inventoryLevel[inventoryLevelLength] = new Object();
			inventoryLevel[inventoryLevelLength].value1 = paObj[i].value1;
			inventoryLevel[inventoryLevelLength].value2 = paObj[i].value2;
		}
		else if ((paObj[i].type == "<%= CampaignConstants.LOW_PRICE %>") || (paObj[i].type == "<%= CampaignConstants.HIGH_PRICE %>")) {
			var offerPriceLength = offerPrice.length;
			offerPrice[offerPriceLength] = new Object();
			offerPrice[offerPriceLength].value1 = paObj[i].value1;
			offerPrice[offerPriceLength].value2 = paObj[i].value2;
		}
		else if (paObj[i].type == "<%= CampaignConstants.AVAILABLE_AFTER %>") {
			if (!isEmpty(paObj[i].value1)) {
				availableDate = paObj[i].value1;
			}
		}
	}

	displayInventoryLevel();
	displayOfferPrice();
	displayAvailableDate();
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display all the ad copies selected as the awareness
// advertisement given the field title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displayAdCopy (columnName, columnValues) {
	document.writeln('<table border="0" cellspacing="1" cellpadding="1">');
	if (columnValues.length == 0) {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap><li>' + columnName + '&nbsp;</li></td>');
		document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedAdCopyNone")) %>' + '</i></td>');
		document.writeln('	</tr>');
	}
	else {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap><li>' + columnName + '&nbsp;</li></td>');
		document.writeln('		<td><i>' + columnValues[0].name + '</i></td>');
		document.writeln('	</tr>');
	}
	if (columnValues.length > 1) {
		for (var i=1; i<columnValues.length; i++) {
			document.writeln('	<tr>');
			document.writeln('		<td>&nbsp;</td>');
			document.writeln('		<td><i>' + columnValues[i].name + '</i></td>');
			document.writeln('	</tr>');
		}
	}
	document.writeln('</table>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the selected type of cross-sell/up-sell used in
// this initiative given the field title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displaySellContent (columnName, columnValue) {
	var displayValue = "";
	if (columnValue == "<%= CampaignConstants.SELL_CONTENT_TYPE_CONTENT_OF_CURRENT_PAGE %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySellContentPage")) %>";
	}
	else if (columnValue == "<%= CampaignConstants.SELL_CONTENT_TYPE_SHOPPING_CART_CONTAINS %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySellContentShoppingCart")) %>";
	}
	else if (columnValue == "<%= CampaignConstants.SELL_CONTENT_TYPE_PURCHASE_HISTORY_CONTAINS %>") {
		displayValue = "<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySellContentPreviousPurchase")) %>";
	}
	else {
		return;
	}
	displayIndentRow(columnName, displayValue);
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the type of content to be displayed in this
// initiative given the initiative databean object.
////////////////////////////////////////////////////////////////////////////////////
function displayContentDetail (initiativeObj) {
	// indent the entire section
	document.writeln('<ul>');

	// display what type
	displayDisplayedContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryDisplayedContentPrompt")) %>", initiativeObj.<%= CampaignConstants.ELEMENT_WHAT_TYPE %>);

	// display the content detail
	var whatTypeValue = initiativeObj.<%= CampaignConstants.ELEMENT_WHAT_TYPE %>;
	if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_SPECIFIC_PRODUCTS %>") {
		displayProductCategory("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedProduct")) %>", initiativeObj.productNames);
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_CATEGORY %>") {
		displayProductCategory("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedCategory")) %>", initiativeObj.selectedCategoriesNames);
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_COLLATERAL %>") {
		displayAdCopy("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedAdCopy")) %>", initiativeObj.<%= CampaignConstants.ELEMENT_SELECTED_COLLATERAL %>);
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_PRODUCT_ATTRIBUTES %>") {
		displayProductAttributes(initiativeObj);
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_UP_SELL %>") {
		displaySellContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryUpSellContent")) %>", initiativeObj.<%= CampaignConstants.ELEMENT_SELL_CONTENT_TYPE %>);
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_CROSS_SELL %>") {
		displaySellContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryCrossSellContent")) %>", initiativeObj.<%= CampaignConstants.ELEMENT_SELL_CONTENT_TYPE %>);
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_DISCOUNT_COLLATERAL %>") {
		displayIndentRow("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedDiscount")) %>", initiativeObj.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_CODE %>);
		displayAdCopy("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedAdCopy")) %>", initiativeObj.<%= CampaignConstants.ELEMENT_SELECTED_DISCOUNT_COLLATERAL %>);
	}
	else if (whatTypeValue == "<%= CampaignConstants.WHAT_TYPE_COUPON_COLLATERAL %>") {
		displayAdCopy("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedAdCopy")) %>", initiativeObj.<%= CampaignConstants.ELEMENT_SELECTED_COUPON_COLLATERAL %>);
	}
	else {
		return;
	}

	// outdent the entire section
	document.writeln('</ul>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the selected customer profile(s) to be targeted
// in this initiative given the field title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displayTargetCustomers (columnName, columnValues) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	if (columnValues.length == 0) {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
		document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryTargetCustomersAll")) %>' + '</i></td>');
		document.writeln('	</tr>');
	}
	else {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
		document.writeln('		<td><i>' + convertFromTextToHTML(columnValues[0]) + '</i></td>');
		document.writeln('	</tr>');
	}
	if (columnValues.length > 1) {
		for (var i=1; i<columnValues.length; i++) {
			document.writeln('	<tr>');
			document.writeln('		<td>&nbsp;</td>');
			document.writeln('		<td><i>' + convertFromTextToHTML(columnValues[i]) + '</i></td>');
			document.writeln('	</tr>');
		}
	}
	document.writeln('</table></p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display the selected dates for targeting customers
// in this initiative given the field title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displayTargetDates (columnName, columnValues, isEveryday) {
	document.writeln('<p><table border="0" cellspacing="0" cellpadding="0">');
	if (isEveryday) {
		document.writeln('	<tr>');
		document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
		document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("whenListEveryday")) %>' + '</i></td>');
		document.writeln('	</tr>');
	}
	else {
		for (var i=0; i<columnValues.length; i++) {
			document.writeln('	<tr>');

			//
			// only include the column name for the first entry
			//
			if (i == 0) {
				document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
			}
			else {
				document.writeln('		<td>&nbsp;</td>');
			}

			//
			// display the current selected dates of the week
			//
			if (columnValues[i] == "<%= CampaignConstants.MONDAY %>") {
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_MONDAY)) %>' + '</i></td>');
			}
			else if (columnValues[i] == "<%= CampaignConstants.TUESDAY %>") {
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_TUESDAY)) %>' + '</i></td>');
			}
			else if (columnValues[i] == "<%= CampaignConstants.WEDNESDAY %>") {
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_WEDNESDAY)) %>' + '</i></td>');
			}
			else if (columnValues[i] == "<%= CampaignConstants.THURSDAY %>") {
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_THURSDAY)) %>' + '</i></td>');
			}
			else if (columnValues[i] == "<%= CampaignConstants.FRIDAY %>") {
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_FRIDAY)) %>' + '</i></td>');
			}
			else if (columnValues[i] == "<%= CampaignConstants.SATURDAY %>") {
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_SATURDAY)) %>' + '</i></td>');
			}
			else if (columnValues[i] == "<%= CampaignConstants.SUNDAY %>") {
				document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_SUNDAY)) %>' + '</i></td>');
			}

			document.writeln('	</tr>');
		}
	}
	document.writeln('</table></p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display all the customer behavior(s) defined in this
// initiative given the field title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displayTargetCustomerBehaviors (columnName, columnValues) {
	document.writeln('<p>');

	document.writeln('<table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
	if (columnValues.length == 0) {
		document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedNone")) %>' + '</i></td>');
	}
	document.writeln('	</tr>');
	document.writeln('</table><br/>');

	if (columnValues.length > 0) {
		document.writeln('<table class="list" border="0" cellpadding="1" cellspacing="1">');
		startDlistRowHeading();
		addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryCustomerBehaviorColumn")) %>', true, 'null', null, false);
		addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummaryValueColumn")) %>', true, 'null', null, false);

		var rowselect = 1;
		for (var i=0; i<columnValues.length; i++) {
			var columnValue = columnValues[i];

			startDlistRow(rowselect);
<%	for (int i=0; i<CampaignConstants.whenArray.length; i++) { %>
			if ((columnValue.action == "<%= CampaignConstants.whenActionArray[i] %>") && (columnValue.type == "<%= CampaignConstants.whenTypeArray[i] %>")) {
				addDlistColumn(getWhichText("<%= CampaignConstants.whenArray[i] %>"), 'none', 'font-size: 10pt;');
			}
<%	} %>
			var value1 = columnValue.value1;
			var value2 = columnValue.value2;
			if (columnValue.type == "<%= CampaignConstants.PRICE %>") {
				value1 = parent.numberToCurrency(columnValue.value1, defaultCurrency, "<%= campaignCommandContext.getLanguageId().toString() %>");
			}
			if (columnValue.type == "<%= CampaignConstants.SKU %>" || columnValue.type == "<%= CampaignConstants.PRODUCT %>") {
				addDlistColumn(value2 + " (" + value1 + ")", 'none', 'font-size: 10pt;');
			}
			else {
				addDlistColumn(replaceSpecialChars(value1 + " " + columnValue.value2), 'none', 'font-size: 10pt;');
			}
			endDlistRow();

			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		}

		document.writeln('</table>');
	}

	document.writeln('</p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to display all the e-marketing spot(s) scheduled by this
// initiative and the start date and end date of the schedule given the field
// title and its value.
////////////////////////////////////////////////////////////////////////////////////
function displaySchedules (columnName) {
	document.writeln('<p>');

	document.writeln('<table border="0" cellspacing="0" cellpadding="0">');
	document.writeln('	<tr>');
	document.writeln('		<td valign="top" nowrap>' + columnName + '&nbsp;</td>');
<%	if (numberOfInitiativeSchedules == 0) { %>
	document.writeln('		<td><i>' + '<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSummarySelectedNone")) %>' + '</i></td>');
<%	} %>
	document.writeln('	</tr>');
	document.writeln('</table><br/>');

<%	if (numberOfInitiativeSchedules > 0) { %>
	startDlistTable('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleListSummary")) %>');
	startDlistRowHeading();
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleListEmsColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryStartDateColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryEndDateColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryPriorityColumn")) %>', true, 'null', null, false);
	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSummaryStatusColumn")) %>', true, 'null', null, false);
<%
		int rowselect = 1;
		CampaignInitiativeScheduleDataBean initiativeSchedule;
		for (int i=0; i<numberOfInitiativeSchedules; i++) {
			initiativeSchedule = initiativeSchedules[i];
%>
	startDlistRow(<%= rowselect %>);
	addDlistColumn('<%= UIUtil.toJavaScript(initiativeSchedule.getEMarketingSpotName()) %>', 'none', 'font-size: 10pt;');
	addDlistColumn('<%= UIUtil.toJavaScript(dateFormat.format(initiativeSchedule.getStartDate())) %>', 'none', 'font-size: 10pt;');
<%			if (initiativeSchedule.getEndDate().compareTo(CampaignConstants.TIMESTAMP_END_OF_TIME) >= 0) { %>
	addDlistColumn('<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_NEVER)) %>', 'none', 'font-size: 10pt;');
<%			} else { %>
	addDlistColumn('<%= UIUtil.toJavaScript(dateFormat.format(initiativeSchedule.getEndDate())) %>', 'none', 'font-size: 10pt;');
<%			} %>
<%			if (initiativeSchedule.getPriority() == null) { %>
	addDlistColumn('<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeScheduleSelectPriority")) %>', 'none', 'font-size: 10pt;');
<%			} else { %>
	addDlistColumn('<%= UIUtil.toJavaScript(initiativeSchedule.getPriority().toString()) %>', 'none', 'font-size: 10pt;');
<%			} %>
	addDlistColumn('<%= UIUtil.toJavaScript((String)campaignsRB.get(initiativeSchedule.getInitiativeStatus())) %>', 'none', 'font-size: 10pt;');
<%
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
		}
%>
	endDlistRow();
	endDlistTable();
<%	} %>

	document.writeln('</p>');
}

////////////////////////////////////////////////////////////////////////////////////
// This method is used to load panel data and instantiate page properties.
////////////////////////////////////////////////////////////////////////////////////
function loadPanelData () {
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}
//-->
</script>
</head>

<body class="content" onload="loadPanelData();">

<h1><%= campaignsRB.get("initiativeSummaryDialogTitle") %></h1>

<script language="JavaScript">
<!-- hide script from old browsers
loadInitiative();
//-->
</script>

</body>

</html>