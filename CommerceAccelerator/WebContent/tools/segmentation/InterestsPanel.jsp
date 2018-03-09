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
<%@ include file="StringValuesControl.jspf" %>

<script language="JavaScript">
<!-- hide script from old browsers
function showInterests () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_INTERESTS_OP %>);
		showDivision(document.all.interestsDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_ALL_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadInterests () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_INTERESTS_OP %>, o.<%= SegmentConstants.ELEMENT_INTERESTS_OP %>);
				loadStringValues(<%= SegmentConstants.ELEMENT_INTERESTS %>, o.<%= SegmentConstants.ELEMENT_INTERESTS %>);
			}
		}
		showInterests();
	}
}

function saveInterests () {
	with (document.segmentForm) {
		addStringToSelect(<%= SegmentConstants.ELEMENT_INTERESTS %>, <%= SegmentConstants.ELEMENT_INTERESTS + "Input" %>);
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_INTERESTS_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_INTERESTS_OP %>);
				o.<%= SegmentConstants.ELEMENT_INTERESTS %> = getStringValues(<%= SegmentConstants.ELEMENT_INTERESTS %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_INTERESTS_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_INTERESTS_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_INTERESTS_OP %>" id="<%= SegmentConstants.ELEMENT_INTERESTS_OP %>" onChange="showInterests()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_INTERESTS) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_INTERESTS_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_ALL_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_INTERESTS_ALL_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_INTERESTS_NOT_ONE_OF) %></option>
</select>

<div id="interestsDiv" style="display: none; margin-left: 20">
<%= generateStringValuesControl(segmentsRB, SegmentConstants.MSG_INTERESTS_PROMPT, SegmentConstants.ELEMENT_INTERESTS, SegmentConstants.MSG_SPECIFIED_INTERESTS) %>
</div>
