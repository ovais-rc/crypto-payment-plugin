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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%	String loginLanguageId = campaignCommandContext.getLanguageId().toString(); %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= UIUtil.toHTML((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_TITLE)) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Initiative.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/ConvertToXML.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var initiativeDataBean = parent.parent.parent.get("<%= CampaignConstants.ELEMENT_INITIATIVE %>", null);
var whichChoices = initiativeDataBean.<%= CampaignConstants.ELEMENT_WHEN_CHOICES %>;
var numberOfWhichChoices = whichChoices.length;
var defaultCurrency = initiativeDataBean.currency;

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

function deleteWhichChoice () {
	var checkedWhichChoices = parent.getChecked();
	if (checkedWhichChoices.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_DELETE_CONFIRMATION)) %>")) {
			if (initiativeDataBean != null) {
				// create a new when choices array which will store the remaining (non-deleted) when choices
				var newWhichChoices = new Array();

				// loop through all the when choices...
				// if a choice is not marked for deletion, store it in the new array, otherwise skip.
				for (i=0; i<whichChoices.length; i++) {
					var doDelete = false;
					for (j=0; j<checkedWhichChoices.length; j++) {
						if (checkedWhichChoices[j] == i) {
							// the when choice checkbox "name" was found in the checked array, set delete flag
							doDelete = true;
							break;
						}
					}
					// if this when choice is not to be deleted, copy it to the new array
					if (!doDelete) {
						newWhichChoices[newWhichChoices.length] = new Object();
						newWhichChoices[newWhichChoices.length-1] = whichChoices[i];
					}
				}
				initiativeDataBean.<%= CampaignConstants.ELEMENT_WHEN_CHOICES %> = newWhichChoices;
			}

			// reload page now that the when choice have been deleted
			parent.location.reload();
		}
	}
}

function loadPanelData () {
	// load the button frame and set base panel ready flag
	parent.loadFrames();
	parent.parent.setReadyFlag("whichListPanel");
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content_list">

<form name="initiativeWhichForm" id="initiativeWhichForm">

<%= comm.startDlistTable((String)campaignsRB.get("whenListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_CUSTOMER_BEHAVIOUR), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_VALUE), null, false) %>
<%= comm.endDlistRow() %>

<script language="JavaScript">
<!-- hide script from old browsers
var rowselect = 1;

for (var i=0; i<numberOfWhichChoices; i++) {
	var whichChoice = whichChoices[i];

	startDlistRow(rowselect);

	addDlistCheck(i);
<%	for (int i=0; i<CampaignConstants.whenArray.length; i++) { %>
	if ((whichChoice.action == "<%= CampaignConstants.whenActionArray[i] %>") && (whichChoice.type == "<%= CampaignConstants.whenTypeArray[i] %>")) {
		addDlistColumn(getWhichText("<%= CampaignConstants.whenArray[i] %>"), "none");
	}
<%	} %>
	var value1 = whichChoice.value1;
	var value2 = whichChoice.value2;
	if (whichChoice.type == "<%= CampaignConstants.PRICE %>") {
		value1 = parent.parent.parent.numberToCurrency(whichChoice.value1, defaultCurrency, "<%= loginLanguageId %>");
		addDlistColumn(replaceSpecialChars(value1 + " " + value2), "none");
	}
	else if (whichChoice.type == "<%= CampaignConstants.SKU %>" || whichChoice.type == "<%= CampaignConstants.PRODUCT %>") {
		addDlistColumn(value2 + " (" + value1 + ")", "none");
	}
	else if (whichChoice.type == "<%= CampaignConstants.CATEGORY %>") {
		addDlistColumn(replaceSpecialChars(value1), "none");
	}

	endDlistRow();

	if (rowselect == 1) {
		rowselect = 2;
	}
	else {
		rowselect = 1;
	}
}
//-->
</script>

<%= comm.endDlistTable() %>

<script language="JavaScript">
<!-- hide script from old browsers
if (numberOfWhichChoices == 0) {
	document.writeln('<br />');
	document.writeln('<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_WHEN_LIST_EMPTY)) %>');
}
//-->
</script>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(numberOfWhichChoices);
//-->
</script>

</body>

</html>