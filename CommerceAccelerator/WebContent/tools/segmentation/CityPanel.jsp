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
function showCity () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_CITY_OP %>);
		showDivision(document.all.cityDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadCity () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_CITY_OP %>, o.<%= SegmentConstants.ELEMENT_CITY_OP %>);
				loadStringValues(<%= SegmentConstants.ELEMENT_CITIES %>, o.<%= SegmentConstants.ELEMENT_CITIES %>);
			}
		}
		showCity();
		<%= SegmentConstants.ELEMENT_CITY_OP %>.focus();
	}
}

function saveCity () {
	with (document.segmentForm) {
		addStringToSelect(<%= SegmentConstants.ELEMENT_CITIES %>, <%= SegmentConstants.ELEMENT_CITIES + "Input" %>);
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_CITY_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_CITY_OP %>);
				o.<%= SegmentConstants.ELEMENT_CITIES %> = getStringValues(<%= SegmentConstants.ELEMENT_CITIES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_CITY_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_CITY_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_CITY_OP %>" id="<%= SegmentConstants.ELEMENT_CITY_OP %>" onChange="showCity()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_CITY) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_CITY_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_CITY_NOT_ONE_OF) %></option>
</select>

<div id="cityDiv" style="display: none; margin-left: 20">
<%= generateStringValuesControl(segmentsRB, SegmentConstants.MSG_CITIES_PROMPT, SegmentConstants.ELEMENT_CITIES, SegmentConstants.MSG_SPECIFIED_CITIES) %>
</div>
