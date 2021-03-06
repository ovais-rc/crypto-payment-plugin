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

<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.segmentation.SegmentStatesDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	SegmentStatesDataBean segmentStates = new SegmentStatesDataBean();
	DataBeanManager.activate(segmentStates, request);
	SegmentStatesDataBean.State[] states = segmentStates.getStates();
%>

<style type="text/css">
.selectWidth {width: 280px;}
</style>

<script language="JavaScript">
<!-- hide script from old browsers
var allStates = new Array();
<%
	if (states != null) {
		for (int i=0; i<states.length; i++) {
%>
allStates[<%= i %>] = new Object();
allStates[<%= i %>].stateName = "<%= states[i].getName() %>";
allStates[<%= i %>].stateAbbr = "<%= states[i].getAbbr() %>";
<%
		}
	}
%>

function showState () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_STATE_OP %>);
		showDivision(document.all.stateDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadState () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_STATE_OP %>, o.<%= SegmentConstants.ELEMENT_STATE_OP %>);
				var values = o.<%= SegmentConstants.ELEMENT_STATES %>;
				var currentSelected = 0;
				var currentAvailable = 0;
				for (var i=0; i<allStates.length; i++) {
					var found = false;
					for (var j=0; j<values.length; j++) {
						if (allStates[i].stateAbbr == values[j]) {
							<%= SegmentConstants.ELEMENT_STATES %>.options[currentSelected] = new Option(allStates[i].stateName, allStates[i].stateAbbr);
							currentSelected++;
							found = true;
							break;
						}
					}
					if (!found) {
						availableStates.options[currentAvailable] = new Option(allStates[i].stateName, allStates[i].stateAbbr);
						currentAvailable++;
					}
				}
			}
			initializeSloshBuckets(<%= SegmentConstants.ELEMENT_STATES %>, removeFromStateSloshBucketButton, availableStates, addToStateSloshBucketButton);
		}
		showState();
	}
}

function saveState () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_STATE_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_STATE_OP %>);
				var values = new Array();
				for (var i=0; i < <%= SegmentConstants.ELEMENT_STATES %>.length; i++) {
					values[i] = <%= SegmentConstants.ELEMENT_STATES %>.options[i].value;
				}
				o.<%= SegmentConstants.ELEMENT_STATES %> = values;
			}
		}
	}
}

function addToSelectedStates () {
	with (document.segmentForm) {
		move(availableStates, <%= SegmentConstants.ELEMENT_STATES %>);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_STATES %>, addToStateSloshBucketButton, availableStates, removeFromStateSloshBucketButton);
	}
}

function removeFromSelectedStates () {
	with (document.segmentForm) {
		move(<%= SegmentConstants.ELEMENT_STATES %>, availableStates);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_STATES %>, removeFromStateSloshBucketButton, availableStates, addToStateSloshBucketButton);
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_STATE_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_STATE_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_STATE_OP %>" id="<%= SegmentConstants.ELEMENT_STATE_OP %>" onChange="showState()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_STATE) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_STATE_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_STATE_NOT_ONE_OF) %></option>
</select>

<div id="stateDiv" style="display: none; margin-left: 20">
<br/>
<table>
	<tr>
		<td>
			<label for="<%= SegmentConstants.ELEMENT_STATES %>"><%= segmentsRB.get(SegmentConstants.MSG_SELECTED_STATES_PROMPT) %></label><br>
			<select name="<%= SegmentConstants.ELEMENT_STATES %>"
				id="<%= SegmentConstants.ELEMENT_STATES %>"
				tabindex="1"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.removeFromStateSloshBucketButton, document.segmentForm.availableStates, document.segmentForm.addToStateSloshBucketButton);">
			</select>
		</td>
		<td width="150px" align="center">
			<table cellpadding="2" cellspacing="2">
				<tr><td>
					<input type="button" tabindex="4" name="addToStateSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_STATE_ADD_BUTTON) %>  " onClick="addToSelectedStates()">
				</td></tr>
				<tr><td>
					<input type="button" tabindex="2" name="removeFromStateSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_STATE_REMOVE_BUTTON) %>  " onClick="removeFromSelectedStates()">
				</td></tr>
			</table>
		</td>
		<td>
			<label for="availableStates"><%= segmentsRB.get(SegmentConstants.MSG_AVAILABLE_STATES_PROMPT) %></label><br>
			<select name="availableStates"
				id="availableStates"
				tabindex="3"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.addToStateSloshBucketButton, document.segmentForm.<%= SegmentConstants.ELEMENT_STATES %>, document.segmentForm.removeFromStateSloshBucketButton);">
			</select>
		</td>
	</tr>
</table>
</div>
