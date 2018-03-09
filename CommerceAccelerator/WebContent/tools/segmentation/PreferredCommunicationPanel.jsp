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
<%@ include file="ValueCheckBox.jspf" %>

<script language="JavaScript">
<!-- hide script from old browsers
function showPreferredCommunication () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %>);
		showDivision(document.all.preferredCommunicationDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>"));
	}
}

function loadPreferredCommunication () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %>, o.<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %>);
				loadCheckBoxValues(<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_VALUES %>, o.<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_VALUES %>);
			}
		}
		showPreferredCommunication();
	}
}

function savePreferredCommunication () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %>);
				o.<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_VALUES %> = getCheckBoxValues(<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_VALUES %>);
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_PREFERRED_COMMUNICATION_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %>" id="<%= SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_OP %>" onChange="showPreferredCommunication()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_PREFERRED_COMMUNICATION) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_PREFERRED_COMMUNICATION_ONE_OF) %></option>
</select>

<div id="preferredCommunicationDiv" style="display: none; margin-left: 20">
<br/>
<%= generateValueCheckBox(segmentsRB, SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_VALUES, SegmentConstants.MSG_PREFERRED_COMMUNICATION, "P") %>
<%= generateValueCheckBox(segmentsRB, SegmentConstants.ELEMENT_PREFERRED_COMMUNICATION_VALUES, SegmentConstants.MSG_PREFERRED_COMMUNICATION, "E") %>
</div>
