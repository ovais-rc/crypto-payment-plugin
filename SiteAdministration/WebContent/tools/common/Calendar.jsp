<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="common.jsp" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = null;

	// use server default locale if no command context is found
	if (cmdContext != null) {
		locale = cmdContext.getLocale();
	}
	else {
		locale = Locale.getDefault();
	}

	// get calendar for this locale to determine what the first day of the week is so we can display our calendar appropriately
	if (locale==null) {
		locale=Locale.US;
	}

	java.util.Calendar calendar = java.util.Calendar.getInstance(locale);
	int fdow = calendar.getFirstDayOfWeek();
	boolean yearFirst = false;

	if (Util.isDoubleByteLocale(locale))
		yearFirst = true;

	// obtain the resource bundle for display
	Hashtable calendarNLS = (Hashtable)ResourceDirectory.lookup("common.calendarNLS", locale);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title><%= calendarNLS.get("calendarTitle") %></title>
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
<style type="text/css">

html,body { overflow: hidden; }

</style>
<script type="text/javascript" src="/wcs/javascript/tools/common/Calendar.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript">

var calDisplayed = false;
var adjusted = false;
var calendar = new Calendar();
var focusIndex;

function init() {
	// pop up
	if (opener) {
		setDate();
		adjustFrameSize();
	}
	// iframe
	else {
		if (parent.yearField == null || parent.monthField == null || parent.dayField == null)
			setToday();
		else
			setDate();
	}
}

function setDate() {
	var day, month, year;

	if (opener) {
		this.yearField = opener.yearField;
		this.monthField = opener.monthField;
		this.dayField = opener.dayField;
	}
	else {
		this.yearField = parent.yearField;
		this.monthField = parent.monthField;
		this.dayField = parent.dayField;
	}

	year = this.yearField.value;
	month = this.monthField.value;
	day = this.dayField.value;

	if (!isValidDate(day, month, year)) {
		setToday();
	}
	else {
		calendar.setDate(day, month, year);
		document.calControl.month.selectedIndex = calendar.getCurrentMonth() - 1;
		document.calControl.year.value = calendar.getCurrentYear();
		displayCalendar();
	}
}

function setToday() {
	// SET DAY MONTH AND YEAR TO TODAY'S DATE
	day = calendar.getCurrentDay();
	month = calendar.getCurrentMonth();
	year = calendar.getCurrentYear();

	document.calControl.month.selectedIndex = month - 1;
	document.calControl.year.value = year;
	displayCalendar();
}

// SET FORM FIELD VALUE TO THE DATE SELECTED
function returnDate(inDay) {
	var day = inDay;
	var month = (document.calControl.month.selectedIndex) + 1;
	var year = document.calControl.year.value;

	if (("" + month).length == 1) {
		month = "0" + month;
	}

	if (day.length == 1) {
		day = "0" + day;
	}

	if (day != "     ") {
		yearField.value = year;
		monthField.value = month;
		dayField.value = day;

		if (opener)
			window.close();
		else
			parent.document.all.CalFrame.style.display="none";
	}
}

function isValidYear(year) {
	if (isNaN(Number(year)) || year < 1900 || year > 9999)
		return false;
	else
		return true;
}

function isFourDigit(year) {
	if (year.length == 4 && !isNaN(Number(year)))
		return true;
	else
		return false;
}

function setThisDate() {
	var day = calendar.getCurrentDay();
	var month = document.calControl.month.selectedIndex + 1;
	var year = document.calControl.year.value;

	if (isFourDigit(year)) {
		if (!isValidYear(year)) {
			alertDialog("<%= UIUtil.toJavaScript(calendarNLS.get("yearErrorMsg")) %>");
			document.calControl.year.select();
		}
		else if (day > 0 && day < 32) {
			while (!isValidDate(day, month, year)) {
				day--;
			}
			calendar.setDate(day, month, year);
			updateCalendar();
			calDisplayed = true;
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript(calendarNLS.get("dateErrorMsg")) %>");
			document.calControl.year.select();
		}
	}
	else {
		alertDialog("<%= UIUtil.toJavaScript(calendarNLS.get("year4digitMsg")) %>");
		document.calControl.year.select();
	}
}

function doOnKeyUp() {
	var year = document.calControl.year.value;
	calDisplayed = false;

	if (isFourDigit(year) || isNaN(Number(year)))
		document.calControl.year.blur();
}

function doOnBlur() {
	if (!calDisplayed) {
		setThisDate();
		document.calControl.year.focus();
	}
}

function displayCalendar() {
	var day = calendar.getCurrentDay();
	var month = calendar.getCurrentMonth();
	var year = calendar.getCurrentYear();
	var numberOfButtons = document.calButtons.length;
	var tempCal, numDays, offset, index;

	// for european countries, calendar begins with Monday.
<%
if ( fdow == calendar.SUNDAY ) { %>
	var isSunday = true;
<%}
else {%>
	var isSunday = false;
<%}%>

	document.calControl.month.selectedIndex = month - 1;
	document.calControl.year.value = year;

	// Disable all dayHeader buttons.
	for (i=0; i<numberOfButtons; i++) {
		document.calButtons.elements[i].disabled = true;
		document.calButtons.elements[i].value = "";
		document.calButtons.elements[i].className = "date";
	}

	// Set a temp calendar to point to first of the month and year.
	tempCal = new Calendar();
	tempCal.setDate(1, month, year);
	offset = tempCal.getCurrentDayOfWeekOfFirst();
	numDays = tempCal.getNumDaysOfMonth();

	if (!isSunday) {
		if (offset == 0)
			offset = 6
		else
			offset = offset - 1;
	}

	// Display the calendar.
	for (i=0; i<numDays; i++) {
		index = i + offset;
		document.calButtons.elements[index].disabled = false;
		document.calButtons.elements[index].value = tempCal.getCurrentDay();
		if (calendar.getCurrentDay() == tempCal.getCurrentDay()) {
			focusIndex = index;
			document.calButtons.elements[index].className = "date_selected";
		}
		tempCal.setNextDay();
	}
}

function changeFocus(button) {
       var tempCal = new Calendar();
       tempCal.setDate(1, calendar.getCurrentMonth(), calendar.getCurrentYear());
       var offset = tempCal.getCurrentDayOfWeekOfFirst();

       calendar.setDate(button.value, calendar.getCurrentMonth(), calendar.getCurrentYear());
       button.className = "date_selected";
       document.calButtons.elements[focusIndex].className = "date";
       focusIndex = calendar.getCurrentDay() + offset - 1;
}

function updateCalendar() {
	document.calControl.month.selectedIndex = calendar.getCurrentMonth() - 1;
	document.calControl.year.value = calendar.getCurrentYear();
	displayCalendar();
	return false;
}


function adjustCellSize() {
	var calControlWidth = document.getElementById("calControl").offsetWidth;
	var currentWidth;
	var maxWidth = 0;

	for (i=0; i<7; i++) {
		currentWidth = document.getElementById("day" + i).offsetWidth;
		currentWidth = parseInt(currentWidth, 10);
		if (currentWidth > maxWidth) {
			maxWidth = currentWidth;
		}
	}

	if (maxWidth < 25) {
		maxWidth = 25;
	}

	if (maxWidth * 7 < calControlWidth) {
		maxWidth = parseInt(calControlWidth / 7);
	}

	for (i=0; i<7; i++) {
		document.getElementById("day" + i).style.width = maxWidth;
	}

	for (i=0; i<document.calButtons.length; i++) {
		document.calButtons.elements[i].style.width = maxWidth;
	}

}

function adjustFrameSize() {
	if (adjusted) {
		return;
	}
	
	adjustCellSize();
	adjusted = true;
	var calBody = document.getElementById("calBody");
	var height = calBody.offsetHeight;
	var width = calBody.offsetWidth;
		
	if (opener) {
		window.resizeTo(width + 20, height + 35);
		window.focus();
	}
	else {
		var iframe = parent.document.getElementById("calFrame")
		iframe.style.width = width + 10;
		iframe.style.height = height + 5;
	}
}

</script>
</head>
<body onload="init();">
<div align="center" class="calendar">
	<table border="0" cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td id="calBody" align="center" valign="middle">
					<form name="calControl" method="get" onsubmit="updateCalendar(); return false;">
						<table id="calControl" border="0" cellpadding="0" cellspacing="2">
							<tbody>
								<tr>
									<td height="10"></td>									
								</tr>
								<tr>
									<td align="center">
										&nbsp;
<% if (yearFirst) { %>
										<label for="calYear" class="hidden-label"><%= calendarNLS.get("year") %></label>
										<input type="text" name="year" id="calYear" size="4" maxlength="4" onkeyup="doOnKeyUp();" onblur="doOnBlur();"/>
<% } %>
										<label for="calMonth" class="hidden-label"><%= calendarNLS.get("month") %></label>
										<select name="month" id="calMonth" onchange="setThisDate();">
											<option value="1"><%= calendarNLS.get("January") %></option>
											<option value="2"><%= calendarNLS.get("February") %></option>
											<option value="3"><%= calendarNLS.get("March") %></option>
											<option value="4"><%= calendarNLS.get("April") %></option>
											<option value="5"><%= calendarNLS.get("May") %></option>
											<option value="6"><%= calendarNLS.get("June") %></option>
											<option value="7"><%= calendarNLS.get("July") %></option>
											<option value="8"><%= calendarNLS.get("August") %></option>
											<option value="9"><%= calendarNLS.get("September") %></option>
											<option value="10"><%= calendarNLS.get("October") %></option>
											<option value="11"><%= calendarNLS.get("November") %></option>
											<option value="12"><%= calendarNLS.get("December") %></option>
										</select>
<% if (!yearFirst) { %>
										<label for="calYear" class="hidden-label"><%= calendarNLS.get("year") %></label>
										<input type="text" name="year" id="calYear" size="4" maxlength="4" onkeyup="doOnKeyUp();" onblur="doOnBlur();"/>
<% } %>
									</td>
								</tr>
								<tr>
									<td align="center">
										&nbsp;
										<button class="cal" name="previousYear" onclick="calendar.setPreviousYear(); updateCalendar();">&lt;&lt;</button>&nbsp;
										<button class="cal" name="previousMonth" onclick="calendar.setPreviousMonth(); updateCalendar();">&lt;</button>&nbsp;&nbsp;
										<button class="cal" name="today" onclick="calendar.setToday(); updateCalendar();"><%= calendarNLS.get("Today") %></button>&nbsp;&nbsp;
										<button class="cal" name="nextMonth" onclick="calendar.setNextMonth(); updateCalendar();">&gt;</button>&nbsp;
										<button class="cal" name="nextYear" onclick="calendar.setNextYear(); updateCalendar();">&gt;&gt;</button>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
					<form name="calButtons" onsubmit="return false;">
						<table id="calTable" border="0" cellpadding="1" cellspacing="0">
							<tbody>
								<tr class="cal">
<% if (fdow == calendar.SUNDAY) { %>
									<td id="day0" align="center"><%= calendarNLS.get("Sunday") %></td>
<% } %>
									<td id="day1" align="center"><%= calendarNLS.get("Monday") %></td>
									<td id="day2" align="center"><%= calendarNLS.get("Tuesday") %></td>
									<td id="day3" align="center"><%= calendarNLS.get("Wednesday") %></td>
									<td id="day4" align="center"><%= calendarNLS.get("Thursday") %></td>
									<td id="day5" align="center"><%= calendarNLS.get("Friday") %></td>
									<td id="day6" align="center"><%= calendarNLS.get("Saturday") %></td>
<% if (fdow != calendar.SUNDAY) { %>
									<td id="day0" align="center"><%= calendarNLS.get("Sunday") %></td>
<% } %>
								</tr>
<%
	int count = 0;
	for (int i=0; i<6; i++) {
		out.println("\t\t\t\t<tr>");
		for (int j=0; j<7; j++ ) {
			out.println("\t\t\t\t\t<td align=\"center\" valign=\"center\"><button class=\"date\" name=\"button" + count + "\" onclick=\"returnDate(this.value);\" onfocus=\"changeFocus(this);\"></button></td>");
			count++;
		}
		out.println("\t\t\t\t</tr>");
	}

%>
							</tbody>
						</table>
					</form>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>
