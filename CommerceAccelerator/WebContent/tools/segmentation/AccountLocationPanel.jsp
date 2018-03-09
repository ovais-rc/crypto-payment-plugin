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
	com.ibm.commerce.tools.segmentation.SegmentCountriesDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
	SegmentCountriesDataBean segmentCountries = new SegmentCountriesDataBean();
	DataBeanManager.activate(segmentCountries, request);
	SegmentCountriesDataBean.Country[] countries = segmentCountries.getCountries();
%>

<style type="text/css">
.selectWidth {width: 280px;}
</style>

<script language="JavaScript">
<!-- hide script from old browsers
var allCountries = new Array();
<%
	if (countries != null) {
		for (int i=0; i<countries.length; i++) {
%>
allCountries[<%= i %>] = new Object();
allCountries[<%= i %>].countryName = "<%= countries[i].getName() %>";
allCountries[<%= i %>].countryAbbr = "<%= countries[i].getAbbr() %>";
<%
		}
	}
%>

function showAccountLocation () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %>);
		showDivision(document.all.accountLocationDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadAccountLocation () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %>, o.<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %>);
				var values = o.<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>;
				var currentSelected = 0;
				var currentAvailable = 0;
				for (var i=0; i<allCountries.length; i++) {
					var found = false;
					for (var j=0; j<values.length; j++) {
						if (allCountries[i].countryAbbr == values[j]) {
							<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>.options[currentSelected] = new Option(allCountries[i].countryName, allCountries[i].countryAbbr);
							currentSelected++;
							found = true;
							break;
						}
					}
					if (!found) {
						availableAccountLocations.options[currentAvailable] = new Option(allCountries[i].countryName, allCountries[i].countryAbbr);
						currentAvailable++;
					}
				}
			}
			initializeSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>, removeFromLocationSloshBucketButton, availableAccountLocations, addToLocationSloshBucketButton);
		}
		showAccountLocation();
	}
}

function saveAccountLocation () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %>);
				var values = new Array();
				for (var i=0; i < <%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>.length; i++) {
					values[i] = <%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>.options[i].value;
				}
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %> = values;
			}
		}
	}
}

function addToSelectedAccountLocations () {
	with (document.segmentForm) {
		move(availableAccountLocations, <%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>, addToLocationSloshBucketButton, availableAccountLocations, removeFromLocationSloshBucketButton);
	}
}

function removeFromSelectedAccountLocations () {
	with (document.segmentForm) {
		move(<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>, availableAccountLocations);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>, removeFromLocationSloshBucketButton, availableAccountLocations, addToLocationSloshBucketButton);
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_LOCATION_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %>" id="<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATION_OP %>" onChange="showAccountLocation()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ACCOUNT_LOCATION) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_LOCATION_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_LOCATION_NOT_ONE_OF) %></option>
</select>

<div id="accountLocationDiv" style="display: none; margin-left: 20">
<br/>
<table>
	<tr>
		<td>
			<label for="<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>"><%= segmentsRB.get(SegmentConstants.MSG_SELECTED_ACCOUNT_LOCATIONS_PROMPT) %></label><br>
			<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>"
				id="<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>"
				tabindex="1"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.removeFromLocationSloshBucketButton, document.segmentForm.availableAccountLocations, document.segmentForm.addToLocationSloshBucketButton);">
			</select>
		</td>
		<td width="150px" align="center">
			<table cellpadding="2" cellspacing="2">
				<tr><td>
					<input type="button" tabindex="4" name="addToLocationSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_LOCATION_ADD_BUTTON) %>  " onClick="addToSelectedAccountLocations()">
				</td></tr>
				<tr><td>
					<input type="button" tabindex="2" name="removeFromLocationSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_LOCATION_REMOVE_BUTTON) %>  " onClick="removeFromSelectedAccountLocations()">
				</td></tr>
			</table>
		</td>
		<td>
			<label for="availableAccountLocations"><%= segmentsRB.get(SegmentConstants.MSG_AVAILABLE_ACCOUNT_LOCATIONS_PROMPT) %></label><br>
			<select name="availableAccountLocations"
				id="availableAccountLocations"
				tabindex="3"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.addToLocationSloshBucketButton, document.segmentForm.<%= SegmentConstants.ELEMENT_ACCOUNT_LOCATIONS %>, document.segmentForm.removeFromLocationSloshBucketButton);">
			</select>
		</td>
	</tr>
</table>
</div>
