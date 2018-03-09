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
function showZipCode () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %>);
		showDivision(document.all.zipCodeDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadZipCode () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %>, o.<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %>);
				loadStringValues(<%= SegmentConstants.ELEMENT_ZIP_CODES %>, o.<%= SegmentConstants.ELEMENT_ZIP_CODES %>);
			}
		}
		showZipCode();
	}
}

function saveZipCode () {
	with (document.segmentForm) {
		addStringToSelect(<%= SegmentConstants.ELEMENT_ZIP_CODES %>, <%= SegmentConstants.ELEMENT_ZIP_CODES + "Input" %>);
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %>);
				o.<%= SegmentConstants.ELEMENT_ZIP_CODES %> = getStringValues(<%= SegmentConstants.ELEMENT_ZIP_CODES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ZIP_CODE_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %>" id="<%= SegmentConstants.ELEMENT_ZIP_CODE_OP %>" onChange="showZipCode()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ZIP_CODE) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ZIP_CODE_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ZIP_CODE_NOT_ONE_OF) %></option>
</select>

<div id="zipCodeDiv" style="display: none; margin-left: 20">
<%= generateStringValuesControl(segmentsRB, SegmentConstants.MSG_ZIP_CODES_PROMPT, SegmentConstants.ELEMENT_ZIP_CODES, SegmentConstants.MSG_SPECIFIED_ZIP_CODES) %>
</div>
