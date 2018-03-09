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

<%@ include file="SegmentCommon.jsp" %>

<script language="JavaScript">
<!-- hide script from old browsers
function showOrders () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ORDERS_OP %>);
		showDivision(document.all.ordersValueDiv, (selectValue == "<%= SegmentConstants.VALUE_EQUAL_TO %>" ||
			selectValue == "<%= SegmentConstants.VALUE_GREATER_THAN_OR_EQUAL_TO %>" ||
			selectValue == "<%= SegmentConstants.VALUE_LESS_THAN_OR_EQUAL_TO %>"));
		showDivision(document.all.ordersRangeDiv, selectValue == "<%= SegmentConstants.VALUE_RANGE %>");
	}
}

function loadOrders () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_ORDERS_OP %>, o.<%= SegmentConstants.ELEMENT_ORDERS_OP %>);
				loadValue(<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>, o.<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>);
				loadValue(<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>, o.<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>);
				loadValue(<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>, o.<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>);
			}
		}

		showOrders();

		if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_ORDERS_VALUE %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_ORDERS_VALUE %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_ORDERS)) %>");
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>.select();
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_ORDERS_VALUE_1 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_ORDERS_VALUE_1 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_ORDERS)) %>");
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>.select();
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_ORDERS_VALUE_2 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_ORDERS_VALUE_2 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_ORDERS)) %>");
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>.select();
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>.focus();
		}
		else if (parent.get && parent.get("invalidRangeOrdersValue", false)) {
			parent.remove("invalidRangeOrdersValue");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("segmentDetailsOrdersInvalidRange")) %>");
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>.select();
			<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>.focus();
		}
	}
}

function saveOrders () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_ORDERS_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ORDERS_OP %>);
				o.<%= SegmentConstants.ELEMENT_ORDERS_VALUE %> = getIntValue(<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>);
				o.<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %> = getIntValue(<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>);
				o.<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %> = getIntValue(<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ORDERS_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ORDERS_OP %>" id="<%= SegmentConstants.ELEMENT_ORDERS_OP %>" onChange="showOrders()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ORDERS) %></option>
	<option value="<%= SegmentConstants.VALUE_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_GREATER_THAN_OR_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_GREATER_THAN_OR_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_LESS_THAN_OR_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_LESS_THAN_OR_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_RANGE %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_RANGE) %></option>
</select>

<div id="ordersValueDiv" style="display: none; margin-left: 20">
<p><label for="<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_VALUE_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>" name="<%= SegmentConstants.ELEMENT_ORDERS_VALUE %>" size="8" maxlength="8"></input>
</div>

<div id="ordersRangeDiv" style="display: none; margin-left: 20">
<p><label for="<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_VALUE_1_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>" name="<%= SegmentConstants.ELEMENT_ORDERS_VALUE_1 %>" size="8" maxlength="8"></input><br>
<label for="<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>"><%= segmentsRB.get(SegmentConstants.MSG_ORDERS_VALUE_2_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>" name="<%= SegmentConstants.ELEMENT_ORDERS_VALUE_2 %>" size="8" maxlength="8"></input>
</div>
