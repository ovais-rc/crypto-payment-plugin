<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@ include file="SegmentCommon.jsp" %>

<script language="JavaScript">
<!-- hide script from old browsers
function showAccountCredit () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %>);
		showDivision(document.all.accountCreditValueDiv, (selectValue == "<%= SegmentConstants.VALUE_GREATER_THAN %>" ||
			selectValue == "<%= SegmentConstants.VALUE_LESS_THAN %>"));
		showDivision(document.all.accountCreditRangeDiv, selectValue == "<%= SegmentConstants.VALUE_RANGE %>");

		if (selectValue == "<%= SegmentConstants.VALUE_ZERO %>") {
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>.value = "0";
		}
		else if (selectValue == "<%= SegmentConstants.VALUE_100 %>") {
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>.value = "100";
		}
	}
}

function loadAccountCredit () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %>, o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %>);
				<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>.value = o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>;
				<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>.value = o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>;
				<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>.value = o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>;
			}
		}

		showAccountCredit();

		if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_ACCOUNT_CREDIT_VALUE %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_ACCOUNT_CREDIT_VALUE %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_ACCOUNT_CREDIT)) %>");
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>.select();
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_ACCOUNT_CREDIT_VALUE_1 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_ACCOUNT_CREDIT_VALUE_1 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_ACCOUNT_CREDIT)) %>");
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>.select();
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_ACCOUNT_CREDIT_VALUE_2 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_ACCOUNT_CREDIT_VALUE_2 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_ACCOUNT_CREDIT)) %>");
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>.select();
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>.focus();
		}
		else if (parent.get && parent.get("invalidRangeAccountCreditValue", false)) {
			parent.remove("invalidRangeAccountCreditValue");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("segmentDetailsAccountCreditInvalidRange")) %>");
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>.select();
			<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>.focus();
		}
	}
}

function getNumberValue (entryField) {
	var value = parent.strToNumber(entryField.value, <%= segmentCommandContext.getLanguageId() %>);
	if (!isNaN(entryField.value) || isNaN(value)) {
		return entryField.value;
	}
	return value;
}

function saveAccountCredit () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %>);
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %> = getNumberValue(<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>);
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %> = getNumberValue(<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>);
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %> = getNumberValue(<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %>" id="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_OP %>" onChange="showAccountCredit()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ACCOUNT_CREDIT) %></option>
	<option value="<%= SegmentConstants.VALUE_ZERO %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_ZERO) %></option>
	<option value="<%= SegmentConstants.VALUE_100 %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_100) %></option>
	<option value="<%= SegmentConstants.VALUE_GREATER_THAN %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_GREATER_THAN) %></option>
	<option value="<%= SegmentConstants.VALUE_LESS_THAN %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_LESS_THAN) %></option>
	<option value="<%= SegmentConstants.VALUE_RANGE %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_RANGE) %></option>
</select>

<div id="accountCreditValueDiv" style="display: none; margin-left: 20">
<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_VALUE_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>" name="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE %>" size="8">
</div>

<div id="accountCreditRangeDiv" style="display: none; margin-left: 20">
<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_VALUE_1_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>" name="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_1 %>" size="8">
<br>
<label for="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_CREDIT_VALUE_2_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>" name="<%= SegmentConstants.ELEMENT_ACCOUNT_CREDIT_VALUE_2 %>" size="8">
</div>
