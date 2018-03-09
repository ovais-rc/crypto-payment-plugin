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
function showCompany () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_COMPANY_OP %>);
		showDivision(document.all.companyDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadCompany () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_COMPANY_OP %>, o.<%= SegmentConstants.ELEMENT_COMPANY_OP %>);
				loadStringValues(<%= SegmentConstants.ELEMENT_COMPANIES %>, o.<%= SegmentConstants.ELEMENT_COMPANIES %>);
			}
		}
		showCompany();
	}
}

function saveCompany () {
	with (document.segmentForm) {
		addStringToSelect(<%= SegmentConstants.ELEMENT_COMPANIES %>, <%= SegmentConstants.ELEMENT_COMPANIES + "Input" %>);
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_COMPANY_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_COMPANY_OP %>);
				o.<%= SegmentConstants.ELEMENT_COMPANIES %> = getStringValues(<%= SegmentConstants.ELEMENT_COMPANIES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_COMPANY_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_COMPANY_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_COMPANY_OP %>" id="<%= SegmentConstants.ELEMENT_COMPANY_OP %>" onChange="showCompany()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_COMPANY) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_COMPANY_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_COMPANY_NOT_ONE_OF) %></option>
</select>

<div id="companyDiv" style="display: none; margin-left: 20">
<%= generateStringValuesControl(segmentsRB, SegmentConstants.MSG_COMPANIES_PROMPT, SegmentConstants.ELEMENT_COMPANIES, SegmentConstants.MSG_SPECIFIED_COMPANIES) %>
</div>
