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
function showEmail () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_E_MAIL_OP %>);
		showDivision(document.all.emailDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadEmail () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_E_MAIL_OP %>, o.<%= SegmentConstants.ELEMENT_E_MAIL_OP %>);
				loadStringValues(<%= SegmentConstants.ELEMENT_E_MAILS %>, o.<%= SegmentConstants.ELEMENT_E_MAILS %>);
			}
		}
		showEmail();
	}
}

function saveEmail () {
	with (document.segmentForm) {
		addStringToSelect(<%= SegmentConstants.ELEMENT_E_MAILS %>, <%= SegmentConstants.ELEMENT_E_MAILS + "Input" %>);
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_E_MAIL_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_E_MAIL_OP %>);
				o.<%= SegmentConstants.ELEMENT_E_MAILS %> = getStringValues(<%= SegmentConstants.ELEMENT_E_MAILS %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_E_MAIL_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_E_MAIL_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_E_MAIL_OP %>" id="<%= SegmentConstants.ELEMENT_E_MAIL_OP %>" onChange="showEmail()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_E_MAIL) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_E_MAIL_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_E_MAIL_NOT_ONE_OF) %></option>
</select>

<div id="emailDiv" style="display: none; margin-left: 20">
<%= generateStringValuesControl(segmentsRB, SegmentConstants.MSG_E_MAILS_PROMPT, SegmentConstants.ELEMENT_E_MAILS, SegmentConstants.MSG_SPECIFIED_E_MAILS) %>
</div>
