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
<%@ include file="IntegerSelect.jspf" %>

<script language="JavaScript">
<!-- hide script from old browsers
function showHousehold () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %>);
		showDivision(document.all.householdValueDiv, (selectValue == "<%= SegmentConstants.VALUE_EQUAL_TO %>" ||
			selectValue == "<%= SegmentConstants.VALUE_GREATER_THAN_OR_EQUAL_TO %>" ||
			selectValue == "<%= SegmentConstants.VALUE_LESS_THAN_OR_EQUAL_TO %>"));
		showDivision(document.all.householdRangeDiv, selectValue == "<%= SegmentConstants.VALUE_RANGE %>");
	}
}

function loadHousehold () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %>, o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %>);
				loadSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE %>, o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE %>);
				loadSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_1 %>, o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_1 %>);
				loadSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_2 %>, o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_2 %>);
			}
		}
		showHousehold();

		if (parent.get && parent.get("invalidRangeHouseholdValue", false)) {
			parent.remove("invalidRangeHouseholdValue");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("segmentDetailsHouseholdInvalidRange")) %>");
			<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_1 %>.focus();
		}
	}
}

function saveHousehold () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %>);
				o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE %> = getSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE %>);
				o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_1 %> = getSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_1 %>);
				o.<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_2 %> = getSelectValue(<%= SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_2 %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %>" id="<%= SegmentConstants.ELEMENT_HOUSEHOLD_OP %>" onChange="showHousehold()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_HOUSEHOLD) %></option>
	<option value="<%= SegmentConstants.VALUE_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_GREATER_THAN_OR_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_GREATER_THAN_OR_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_LESS_THAN_OR_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_LESS_THAN_OR_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_RANGE %>"><%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_RANGE) %></option>
</select>

<div id="householdValueDiv" style="display: none; margin-left: 20">
<p><%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_VALUE_PROMPT) %><br>
<%= generateIntegerSelect(SegmentConstants.ELEMENT_HOUSEHOLD_VALUE, 1, 20) %>
</div>

<div id="householdRangeDiv" style="display: none; margin-left: 20">
<p><%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_VALUE_1_PROMPT) %><br>
<%= generateIntegerSelect(SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_1, 1, 20) %>
<br>
<%= segmentsRB.get(SegmentConstants.MSG_HOUSEHOLD_VALUE_2_PROMPT) %><br>
<%= generateIntegerSelect(SegmentConstants.ELEMENT_HOUSEHOLD_VALUE_2, 1, 20) %>
</div>
