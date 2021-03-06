<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentDataBean,
	com.ibm.commerce.tools.segmentation.SegmentListDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	SegmentListDataBean segmentList = new SegmentListDataBean();
	DataBeanManager.activate(segmentList, request);
	SegmentDataBean[] segments = segmentList.getSegmentList();
%>

<style type="text/css">
.selectWidth {width: 280px;}
</style>

<script language="JavaScript">
<!-- hide script from old browsers
var allSegments = new Array();
var segmentCount = 0;
<%
	if (segments != null) {
		for (int i=0; i<segments.length; i++) {
%>
if (parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>").id != "<%= segments[i].getId() %>") {
	allSegments[segmentCount] = "<%= UIUtil.toJavaScript(segments[i].getSegmentName()) %>";
	segmentCount++;
}
<%
		}
	}
%>

function showSegments () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_SEGMENTS_OP %>);
		showDivision(document.all.segmentsDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_ALL_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadSegments () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_SEGMENTS_OP %>, o.<%= SegmentConstants.ELEMENT_SEGMENTS_OP %>);
				var values = o.<%= SegmentConstants.ELEMENT_SEGMENTS %>;
				var currentSelected = 0;
				var currentAvailable = 0;
				for (var i=0; i<allSegments.length; i++) {
					var found = false;
					for (var j=0; j<values.length; j++) {
						if (allSegments[i] == values[j]) {
							<%= SegmentConstants.ELEMENT_SEGMENTS %>.options[currentSelected] = new Option(allSegments[i], allSegments[i]);
							currentSelected++;
							found = true;
							break;
						}
					}
					if (!found) {
						availableSegments.options[currentAvailable] = new Option(allSegments[i], allSegments[i]);
						currentAvailable++;
					}
				}
			}
			initializeSloshBuckets(<%= SegmentConstants.ELEMENT_SEGMENTS %>, removeFromSloshBucketButton, availableSegments, addToSloshBucketButton);
		}
		showSegments();
	}
}

function saveSegments () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_SEGMENTS_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_SEGMENTS_OP %>);
				var values = new Array();
				for (var i=0; i < <%= SegmentConstants.ELEMENT_SEGMENTS %>.length; i++) {
					values[i] = <%= SegmentConstants.ELEMENT_SEGMENTS %>.options[i].value;
				}
				o.<%= SegmentConstants.ELEMENT_SEGMENTS %> = values;
			}
		}
	}
}

function addToSelectedSegments () {
	with (document.segmentForm) {
		move(availableSegments, <%= SegmentConstants.ELEMENT_SEGMENTS %>);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_SEGMENTS %>, addToSloshBucketButton, availableSegments, removeFromSloshBucketButton);
	}
}

function removeFromSelectedSegments () {
	with (document.segmentForm) {
		move(<%= SegmentConstants.ELEMENT_SEGMENTS %>, availableSegments);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_SEGMENTS %>, removeFromSloshBucketButton, availableSegments, addToSloshBucketButton);
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_SEGMENTS_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_SEGMENTS_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_SEGMENTS_OP %>" id="<%= SegmentConstants.ELEMENT_SEGMENTS_OP %>" onChange="showSegments()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_SEGMENTS) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_SEGMENTS_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_ALL_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_SEGMENTS_ALL_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_SEGMENTS_NOT_ONE_OF) %></option>
</select>

<div id="segmentsDiv" style="display: none; margin-left: 20">
<br/>
<table>
	<tr>
		<td>
			<label for="<%= SegmentConstants.ELEMENT_SEGMENTS %>"><%= segmentsRB.get(SegmentConstants.MSG_SELECTED_SEGMENTS_PROMPT) %></label><br>
			<select name="<%= SegmentConstants.ELEMENT_SEGMENTS %>"
				id="<%= SegmentConstants.ELEMENT_SEGMENTS %>"
				tabindex="1"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.removeFromSloshBucketButton, document.segmentForm.availableSegments, document.segmentForm.addToSloshBucketButton);">
			</select>
		</td>
		<td width="150px" align="center">
			<table cellpadding="2" cellspacing="2">
				<tr><td>
					<input type="button" tabindex="4" name="addToSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_ADD_BUTTON) %>  " onClick="addToSelectedSegments()">
				</td></tr>
				<tr><td>
					<input type="button" tabindex="2" name="removeFromSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_SEGMENT_REMOVE_BUTTON) %>  " onClick="removeFromSelectedSegments()">
				</td></tr>
			</table>
		</td>
		<td>
			<label for="availableSegments"><%= segmentsRB.get(SegmentConstants.MSG_AVAILABLE_SEGMENTS_PROMPT) %></label><br>
			<select name="availableSegments"
				id="availableSegments"
				tabindex="3"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.addToSloshBucketButton, document.segmentForm.<%= SegmentConstants.ELEMENT_SEGMENTS %>, document.segmentForm.removeFromSloshBucketButton);">
			</select>
		</td>
	</tr>
</table>
</div>
