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
<%@ include file="DateEntryfield.jspf" %>

<script language="JavaScript">
<!-- hide script from old browsers
function showRegistrationDate () {
	with (document.segmentForm) {
		var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %>);
		showDivision(document.all.registrationDateDaysDiv, (selectValue == "<%= SegmentConstants.VALUE_WITHIN_THE_LAST %>" ||
			selectValue == "<%= SegmentConstants.VALUE_NOT_WITHIN_THE_LAST %>"));
		showDivision(document.all.registrationDateDateDiv, (selectValue == "<%= SegmentConstants.VALUE_BEFORE %>" ||
			selectValue == "<%= SegmentConstants.VALUE_AFTER %>"));
		showDivision(document.all.registrationDateRangeDiv, (selectValue == "<%= SegmentConstants.VALUE_RANGE %>"));
	}
}

function loadRegistrationDate () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				loadSelectValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %>);
				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>);

				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY %>);
				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH %>);
				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR %>);

				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_1 %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_1 %>);
				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_1 %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_1 %>);
				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>);

				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_2 %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_2 %>);
				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_2 %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_2 %>);
				loadValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2 %>, o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2 %>);
			}
		}
		else {
			loadCurrentDate(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY %>, <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH %>, <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR %>);
			loadCurrentDate(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_1 %>, <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_1 %>, <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>);
			loadCurrentDate(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_2 %>, <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_2 %>, <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2 %>);
		}

		showRegistrationDate();

		if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DAYS %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DAYS %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_DAYS)) %>");
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>.select();
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DATE %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DATE %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_DATE)) %>");
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR %>.select();
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DATE_1 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DATE_1 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_DATE)) %>");
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>.select();
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>.focus();
		}
		else if (parent.get && parent.get("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DATE_2 %>", false)) {
			parent.remove("<%= SegmentConstants.ELEMENT_INVALID_REGISTRATION_DATE_DATE_2 %>");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get(SegmentConstants.MSG_INVALID_DATE)) %>");
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2 %>.select();
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2 %>.focus();
		}
		else if (parent.get && parent.get("invalidRangeRegistrationDateDate", false)) {
			parent.remove("invalidRangeRegistrationDateDate");
			alertDialog("<%= UIUtil.toJavaScript((String) segmentsRB.get("segmentDetailsRegDateInvalidRange")) %>");
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>.select();
			<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>.focus();
		}
	}
}

function saveRegistrationDate () {
	with (document.segmentForm) {
		if (parent.get) {
			var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
			if (o != null) {
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %>);
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %> = getIntValue(<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>);

				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY %>.value;
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH %>.value;
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR %>.value;

				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_1 %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_1 %>.value;
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_1 %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_1 %>.value;
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1 %>.value;

				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_2 %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_2 %>.value;
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_2 %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_2 %>.value;
				o.<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2 %> = <%= SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2 %>.value;
			}
		}
	}
}
//-->
</script>

<p><label for="<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTRATION_DATE_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %>" id="<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_OP %>" onChange="showRegistrationDate()">
	<option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_REGISTRATION_DATE) %></option>
	<option value="<%= SegmentConstants.VALUE_WITHIN_THE_LAST %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTRATION_DATE_WITHIN_THE_LAST) %></option>
	<option value="<%= SegmentConstants.VALUE_NOT_WITHIN_THE_LAST %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTRATION_DATE_NOT_WITHIN_THE_LAST) %></option>
	<option value="<%= SegmentConstants.VALUE_BEFORE %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTRATION_DATE_BEFORE) %></option>
	<option value="<%= SegmentConstants.VALUE_AFTER %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTRATION_DATE_AFTER) %></option>
	<option value="<%= SegmentConstants.VALUE_RANGE %>"><%= segmentsRB.get(SegmentConstants.MSG_REGISTRATION_DATE_RANGE) %></option>
</select>

<div id="registrationDateDaysDiv" style="display: none; margin-left: 20">
<p>
<label for="<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>"><%= segmentsRB.get(SegmentConstants.MSG_DAYS_PROMPT) %></label><br>
<input id="<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>" name="<%= SegmentConstants.ELEMENT_REGISTRATION_DATE_DAYS %>" size="5" maxlength="5"></input><br>
</div>

<div id="registrationDateDateDiv" style="display: none; margin-left: 20">
<p>
<%= generateDateEntryfield(segmentsRB,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY,
		(String)segmentsRB.get(SegmentConstants.MSG_DATE_PROMPT), "calImgRegistrationDate1", "segmentForm") %>
</div>

<div id="registrationDateRangeDiv" style="display: none; margin-left: 20">
<p>
<%= generateDateEntryfieldPair(segmentsRB,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_1,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_1,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_1,
		(String)segmentsRB.get(SegmentConstants.MSG_DATE_1_PROMPT),
		SegmentConstants.ELEMENT_REGISTRATION_DATE_YEAR_2,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_MONTH_2,
		SegmentConstants.ELEMENT_REGISTRATION_DATE_DAY_2,
		(String)segmentsRB.get(SegmentConstants.MSG_DATE_2_PROMPT), "calImgRegistrationDate2", "calImgRegistrationDate3", "segmentForm") %>
</div>
