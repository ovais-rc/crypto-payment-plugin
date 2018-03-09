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
function showChildren () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_OP %>);
		showDivision(document.all.childrenValueDiv, (selectValue == "<%= SegmentConstants.VALUE_EQUAL_TO %>" ||
			selectValue == "<%= SegmentConstants.VALUE_GREATER_THAN_OR_EQUAL_TO %>" ||
			selectValue == "<%= SegmentConstants.VALUE_LESS_THAN_OR_EQUAL_TO %>"));
		showDivision(document.all.childrenRangeDiv, selectValue == "<%= SegmentConstants.VALUE_RANGE %>");
	}
}

function loadChildren () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_OP%>, o.<%= SegmentConstants.ELEMENT_CHILDREN_OP%>);
				loadSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_VALUE%>, o.<%= SegmentConstants.ELEMENT_CHILDREN_VALUE%>);
				loadSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_1%>, o.<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_1%>);
				loadSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_2%>, o.<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_2%>);
			}
		}
		showChildren();

		if (parent.get && parent.get("invalidRangeChildrenValue", false)) {
			parent.remove("invalidRangeChildrenValue");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("segmentDetailsChildrenInvalidRange")) %>");
			<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_1 %>.focus();
		}
	}
}

function saveChildren () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS%>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_CHILDREN_OP%> = getSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_OP%>);
				o.<%= SegmentConstants.ELEMENT_CHILDREN_VALUE%> = getSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_VALUE%>);
				o.<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_1%> = getSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_1%>);
				o.<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_2%> = getSelectValue(<%= SegmentConstants.ELEMENT_CHILDREN_VALUE_2%>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_CHILDREN_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_CHILDREN_OP %>" id="<%= SegmentConstants.ELEMENT_CHILDREN_OP %>" onChange="showChildren()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_CHILDREN) %></option>
	<option value="<%= SegmentConstants.VALUE_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_GREATER_THAN_OR_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_GREATER_THAN_OR_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_LESS_THAN_OR_EQUAL_TO %>"><%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_LESS_THAN_OR_EQUAL_TO) %></option>
	<option value="<%= SegmentConstants.VALUE_RANGE %>"><%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_RANGE) %></option>
</select>

<div id="childrenValueDiv" style="display: none; margin-left: 20">
<p><%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_VALUE_PROMPT) %><br>
<%= generateIntegerSelect(SegmentConstants.ELEMENT_CHILDREN_VALUE, 0, 20) %>
</div>

<div id="childrenRangeDiv" style="display: none; margin-left: 20">
<p><%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_VALUE_1_PROMPT) %><br>
<%= generateIntegerSelect(SegmentConstants.ELEMENT_CHILDREN_VALUE_1, 0, 20) %>
<br>
<%= segmentsRB.get(SegmentConstants.MSG_CHILDREN_VALUE_2_PROMPT) %><br>
<%= generateIntegerSelect(SegmentConstants.ELEMENT_CHILDREN_VALUE_2, 0, 20) %>
</div>
