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
function showPhone () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_PHONE_OP %>);
		showDivision(document.all.phoneDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadPhone () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_PHONE_OP %>, o.<%= SegmentConstants.ELEMENT_PHONE_OP %>);
				loadStringValues(<%= SegmentConstants.ELEMENT_PHONES %>, o.<%= SegmentConstants.ELEMENT_PHONES %>);
			}
		}
		showPhone();
	}
}

function savePhone () {
	with (document.segmentForm) {
		addStringToSelect(<%= SegmentConstants.ELEMENT_PHONES %>, <%= SegmentConstants.ELEMENT_PHONES + "Input" %>);
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_PHONE_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_PHONE_OP %>);
				o.<%= SegmentConstants.ELEMENT_PHONES %> = getStringValues(<%= SegmentConstants.ELEMENT_PHONES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_PHONE_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_PHONE_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_PHONE_OP %>" id="<%= SegmentConstants.ELEMENT_PHONE_OP %>" onChange="showPhone()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_PHONE) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_PHONE_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_PHONE_NOT_ONE_OF) %></option>
</select>

<div id="phoneDiv" style="display: none; margin-left: 20">
<%= generateStringValuesControl(segmentsRB, SegmentConstants.MSG_PHONES_PROMPT, SegmentConstants.ELEMENT_PHONES, SegmentConstants.MSG_SPECIFIED_PHONES) %>
</div>
