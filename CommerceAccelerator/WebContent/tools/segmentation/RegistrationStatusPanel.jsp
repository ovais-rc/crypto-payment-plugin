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
function loadRegistrationStatus () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %>);
			}
		}
		<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %>.focus();
	}
}

function saveRegistrationStatus () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTRATION_STATUS_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %>" id="<%= SegmentConstants.ELEMENT_REGISTRATION_STATUS_OP %>">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_REGISTRATION_STATUS) %></option>
	<option value="<%= SegmentConstants.VALUE_REGISTERED %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTERED) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_REGISTERED %>"><%= segmentsRB.get(SegmentConstants.MSG_NOT_REGISTERED) %></option>
</select>
