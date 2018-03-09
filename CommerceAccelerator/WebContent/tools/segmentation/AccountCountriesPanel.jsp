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

function showAccountCountries () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %>);
		showDivision(document.all.accountCountriesDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_ALL_OF %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
	}
}

function loadAccountCountries () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %>, o.<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %>);
				var values = o.<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>;
				var currentSelected = 0;
				var currentAvailable = 0;
				for (var i=0; i<allCountries.length; i++) {
					var found = false;
					for (var j=0; j<values.length; j++) {
						if (allCountries[i].countryAbbr == values[j]) {
							<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>.options[currentSelected] = new Option(allCountries[i].countryName, allCountries[i].countryAbbr);
							currentSelected++;
							found = true;
							break;
						}
					}
					if (!found) {
						availableAccountCountries.options[currentAvailable] = new Option(allCountries[i].countryName, allCountries[i].countryAbbr);
						currentAvailable++;
					}
				}
			}
			initializeSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>, removeFromCountriesSloshBucketButton, availableAccountCountries, addToCountriesSloshBucketButton);
		}
		showAccountCountries();
	}
}

function saveAccountCountries () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %>);
				var values = new Array();
				for (var i=0; i < <%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>.length; i++) {
					values[i] = <%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>.options[i].value;
				}
				o.<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %> = values;
			}
		}
	}
}

function addToSelectedAccountCountries () {
	with (document.segmentForm) {
		move(availableAccountCountries, <%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>, addToCountriesSloshBucketButton, availableAccountCountries, removeFromCountriesSloshBucketButton);
	}
}

function removeFromSelectedAccountCountries () {
	with (document.segmentForm) {
		move(<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>, availableAccountCountries);
		updateSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>, removeFromCountriesSloshBucketButton, availableAccountCountries, addToCountriesSloshBucketButton);
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_COUNTRIES_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %>" id="<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES_OP %>" onChange="showAccountCountries()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ACCOUNT_COUNTRIES) %></option>
	<option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_COUNTRIES_ONE_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_ALL_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_COUNTRIES_ALL_OF) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_COUNTRIES_NOT_ONE_OF) %></option>
</select>

<div id="accountCountriesDiv" style="display: none; margin-left: 20">
<br/>
<table>
	<tr>
		<td>
			<label for="<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>"><%= segmentsRB.get(SegmentConstants.MSG_SELECTED_ACCOUNT_COUNTRIES_PROMPT) %></label><br>
			<select name="<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>"
				id="<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>"
				tabindex="1"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.removeFromCountriesSloshBucketButton, document.segmentForm.availableAccountCountries, document.segmentForm.addToCountriesSloshBucketButton);">
			</select>
		</td>
		<td width="150px" align="center">
			<table cellpadding="2" cellspacing="2">
				<tr><td>
					<input type="button" tabindex="4" name="addToCountriesSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_COUNTRIES_ADD_BUTTON) %>  " onClick="addToSelectedAccountCountries()">
				</td></tr>
				<tr><td>
					<input type="button" tabindex="2" name="removeFromCountriesSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_COUNTRIES_REMOVE_BUTTON) %>  " onClick="removeFromSelectedAccountCountries()">
				</td></tr>
			</table>
		</td>
		<td>
			<label for="availableAccountCountries"><%= segmentsRB.get(SegmentConstants.MSG_AVAILABLE_ACCOUNT_COUNTRIES_PROMPT) %></label><br>
			<select name="availableAccountCountries"
				id="availableAccountCountries"
				tabindex="3"
				class="selectWidth"
				size="10"
				multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.addToCountriesSloshBucketButton, document.segmentForm.<%= SegmentConstants.ELEMENT_ACCOUNT_COUNTRIES %>, document.segmentForm.removeFromCountriesSloshBucketButton);">
			</select>
		</td>
	</tr>
</table>
</div>
