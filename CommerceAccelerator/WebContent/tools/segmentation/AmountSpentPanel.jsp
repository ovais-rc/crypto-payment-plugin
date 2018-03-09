<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentDefaultCurrencyDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	SegmentDefaultCurrencyDataBean segmentDefaultCurrency = new SegmentDefaultCurrencyDataBean();
	DataBeanManager.activate(segmentDefaultCurrency, request);
	String defaultCurrency = segmentDefaultCurrency.getDefaultCurrency();
	Integer languageId = segmentCommandContext.getLanguageId();
%>

<script language="JavaScript">
<!-- hide script from old browsers
function showAmountSpent () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>);
		showDivision(document.all.amountSpentValueDiv, (selectValue == "<%= SegmentConstants.VALUE_GREATER_THAN %>" ||
			selectValue == "<%= SegmentConstants.VALUE_LESS_THAN %>"));
		showDivision(document.all.amountSpentRangeDiv, selectValue == "<%= SegmentConstants.VALUE_RANGE %>");

		if (selectValue == "<%= SegmentConstants.VALUE_ZERO %>") {
			loadValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>, 0);
		}
	}
}

function loadCurrencyValue (entryField, value) {
	var currencyValue = parent.numberToCurrency(value, "<%= defaultCurrency %>", <%= languageId %>);
	if (value > maxCurrencyValue) {
		entryField.value = parent.numberToCurrency(maxCurrencyValue, "<%= defaultCurrency %>", <%= languageId %>);
	}
	else if (isNaN(value)) {
		entryField.value = value;
	}
	else if (currencyValue === "NaN") {
		entryField.value = "";
	}
	else {
		entryField.value = currencyValue;
	}
}

function loadAmountSpent () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>, o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>);
				loadCurrencyValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>, o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>);
				loadCurrencyValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>, o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>);
				loadCurrencyValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>, o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>);
			}
		}

		showAmountSpent();

		if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_AMOUNT_SPENT_VALUE %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_AMOUNT_SPENT_VALUE %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_AMOUNT)) %>");
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>.select();
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_AMOUNT_SPENT_VALUE_1 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_AMOUNT_SPENT_VALUE_1 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_AMOUNT)) %>");
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>.select();
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_AMOUNT_SPENT_VALUE_2 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_AMOUNT_SPENT_VALUE_2 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_AMOUNT)) %>");
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>.select();
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>.focus();
		}
		else if (parent.get && parent.get("invalidRangeAmountSpentValue", false)) {
			parent.remove("invalidRangeAmountSpentValue");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("segmentDetailsAmountInvalidRange")) %>");
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>.select();
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>.focus();
		}
		else {
			<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>.focus();
		}
	}
}

function getCurrencyValue (entryField) {
	var value = parent.currencyToNumber(entryField.value, "<%= defaultCurrency %>", <%= languageId %>);
	if (!isNaN(entryField.value) || isNaN(value)) {
		return entryField.value;
	}
	return value;
}

function saveAmountSpent () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>);
				o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %> = getCurrencyValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>);
				o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %> = getCurrencyValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>);
				o.<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %> = getCurrencyValue(<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>" id="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_OP %>" onChange="showAmountSpent()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_AMOUNT_SPENT) %></option>
	<option value="<%= SegmentConstants.VALUE_ZERO %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_ZERO) %></option>
	<option value="<%= SegmentConstants.VALUE_GREATER_THAN %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_GREATER_THAN) %></option>
	<option value="<%= SegmentConstants.VALUE_LESS_THAN %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_LESS_THAN) %></option>
	<option value="<%= SegmentConstants.VALUE_RANGE %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_RANGE) %></option>
</select>

<div id="amountSpentValueDiv" style="display: none; margin-left: 20">
<p><label for="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_VALUE_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>" name="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE %>" size="8">
<%= defaultCurrency %>
</div>

<div id="amountSpentRangeDiv" style="display: none; margin-left: 20">
<p><label for="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_VALUE_1_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>" name="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_1 %>" size="8">
<%= defaultCurrency %>
<br>
<label for="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>"><%= segmentsRB.get(SegmentConstants.MSG_AMOUNT_SPENT_VALUE_2_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>" name="<%= SegmentConstants.ELEMENT_AMOUNT_SPENT_VALUE_2 %>" size="8">
<%= defaultCurrency %>
</div>
