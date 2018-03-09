//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

/*********************************************************/
/*                  CALENDAR UTILITIES                   */
/*********************************************************/

/**********************************************************
* Check if a given date is valid.
* inDay   - value of the day, e.g. 1 - 31.
* inMonth - value of the month, e.g. 1 - 12.
* inYear  - value of the year, e.g. 1 - 9999.
* Return: true or false.
**********************************************************/
function isValidDate(inDay, inMonth, inYear) {
	var days;

	inYear = parseInt(inYear, 10);
	inMonth = parseInt(inMonth, 10);
	inDay = parseInt(inDay, 10);

	if (!isNaN(inYear) && !isNaN(inMonth) && !isNaN(inDay)) {
		if ((inYear > 0 && inYear < 10000) &&
			(inMonth > 0 && inMonth < 13) &&
			(inDay > 0 || inDay < 32)) {
			days = getNumDaysInMonth(inMonth, inYear);

			if (inYear == 1752 && inMonth == 9) {
				days = 30;
				if (inDay > 2 && inDay < 14)
					return false;
			}

			if (inDay > 0 && inDay <= days)
				return true;
			else
				return false;
		}
		else
			return false;
	}
	else
		return false;
}

/**********************************************************
* Check if a given year is within the valid year range.
* year  - value of the year, e.g. 1 - 9999.
* Return: true or false.
**********************************************************/
function isLeapYear(year) {
	if (year < 1 || year > 9999)
		return false;

	if (year > 1752) {
		if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0)
			return true;
		else
			return false;
	}
	else {
		if (year % 4 == 0)
			return true;
		else
			return false;
	}
}

/**********************************************************
* Get the number of days in particular month and year.
* year - an input year,.
* Return: true or false.
**********************************************************/
function getNumDaysInMonth(month, year) {
	var days;

	if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
		days = 31;
	else if (month == 4 || month == 6 || month == 9 || month == 11)
		days = 30;
	else if (month == 2)
		if (isLeapYear(year))
			days = 29;
	else
		days = 28;

	if (month == 9 && year == 1752)
		days = 19;

	return days;
}


/*********************************************************/
/*                   CALENDAR CLASS                      */
/*********************************************************/


/**********************************************************
* Calendar class.
* Default date is set to today's date.
* Public methods:
* - setDate(day, month, year)
* - setToday()
* - setPreviousDay()
* - setPreviousWeek()
* - setPreviousMonth()
* - setPreviousYear()
* - setNextDay()
* - setNextWeek()
* - setNextMonth()
* - setNextYear()
* - getCurrentDate()
* - getCurrentDay()
* - getCurrentMonth()
* - getCurrentYear()
* - getCurrentDayOfWeek()
* - getLastDayOfMonth()
* - getNumDaysOfMonth()
**********************************************************/
function Calendar() {
	var now = new Date();

	this.day = now.getDate();
	this.month = now.getMonth() + 1;
	this.year = now.getYear();
	this.setDate = Calendar.setDate;
	this.setToday = Calendar.setToday;
	this.setPreviousDay = Calendar.setPreviousDay;
	this.setPreviousWeek = Calendar.setPreviousWeek;
	this.setPreviousMonth = Calendar.setPreviousMonth;
	this.setPreviousYear = Calendar.setPreviousYear;
	this.setNextDay = Calendar.setNextDay;
	this.setNextWeek = Calendar.setNextWeek;
	this.setNextMonth = Calendar.setNextMonth;
	this.setNextYear = Calendar.setNextYear;
	this.getCurrentDate = Calendar.getCurrentDate;
	this.getCurrentDay = Calendar.getCurrentDay;
	this.getCurrentMonth = Calendar.getCurrentMonth;
	this.getCurrentYear = Calendar.getCurrentYear;
	this.getCurrentDayOfWeek = Calendar.getCurrentDayOfWeek;
	this.getCurrentDayOfWeekOfFirst = Calendar.getCurrentDayOfWeekOfFirst;
	this.getLastDayOfMonth = Calendar.getLastDayOfMonth;
	this.getNumDaysOfMonth = Calendar.getNumDaysOfMonth;
}

/**********************************************************
* Set the calendar to a specific date.
* day   - value of the day, e.g. 1 - 31.
* month - value of the month, e.g. 1 - 12.
* year  - value of the year, e.g. 1 - 9999.
**********************************************************/
function Calendar.setDate(day, month, year) {
	this.day = parseInt(day, 10);
	this.month = parseInt(month, 10);
	this.year = parseInt(year, 10);
}

/**********************************************************
* Set the calendar to today's date.
**********************************************************/
function Calendar.setToday() {
	var now = new Date();

	this.day = now.getDate();
	this.month = now.getMonth() + 1;
	this.year = now.getYear();
}

/**********************************************************
* Set the calendar to previous day.
**********************************************************/
function Calendar.setPreviousDay() {
	var day = this.day;
	var month = this.month;
	var year = this.year;
	var firstDay = false;

	if (month == 9 && year == 1752 && day - 1 > 2 && day - 1 < 14)
		day = 2;
	else if (day - 1 >= 1)
		day--;
	else {
		firstDay = true;
		day = 31;

		if (month > 1)
			month--;
		else {
			month = 12;
			year--;
		}

		while(!isValidDate(day, month, year) && year >= 1)
			day--;
	}

	if (isValidDate(day, month, year)) {
		this.day = day;
		if (firstDay)
			this.setPreviousMonth();
	}
}

/**********************************************************
* Set the calendar to previous week.
**********************************************************/
function Calendar.setPreviousWeek() {
	var i;

	for (i=0; i<7; i++)
		this.setPreviousDay();
}

/**********************************************************
* Set the calendar to previous month.
**********************************************************/
function Calendar.setPreviousMonth() {
	var day = this.day
	var month = this.month;
	var year = this.year;

	if (month == 1 && year > 1) {
		month = 12;
		year--;
	}
	else
		month--;

	while(!isValidDate(day, month, year) && year >= 1)
			day--;

	this.day = day;
	this.month = month;
	if (month == 12)
		this.setPreviousYear();
}

/**********************************************************
* Set the calendar to previous year.
**********************************************************/
function Calendar.setPreviousYear() {
	var day = this.day;
	var month = this.month;
	var year = this.year;

	if (year > 1) {
		year--;

		while(!isValidDate(day, month, year) && year >= 1)
			day--;

		this.day = day;
		this.year = year;
	}
}

/**********************************************************
* Set the calendar to next day.
**********************************************************/
function Calendar.setNextDay() {
	var day = this.day;
	var month = this.month;
	var year = this.year;
	var lastDay = this.getLastDayOfMonth();

	if (month == 9 && year == 1752 && day + 1 > 2 && day + 1 < 14)
		day = 14;
	else if (day + 1 <= lastDay)
		day++;
	else {
		day = 1;

		if (month < 12)
			month++;
		else {
			month = 1;
			year++;
		}
	}

	if (isValidDate(day, month, year)) {
		this.day = day;
		if (day == 1)
			this.setNextMonth();
	}
}

/**********************************************************
* Set the calendar to next week.
**********************************************************/
function Calendar.setNextWeek() {
	var i;

	for (i=0; i<7; i++)
		this.setNextDay();
}

/**********************************************************
* Set the calendar to next month.
**********************************************************/
function Calendar.setNextMonth() {
	var day = this.day
	var month = this.month;
	var year = this.year;

	if (month == 12 && year < 9999) {
		month = 1;
		year++;
	}
	else
		month++;

	while(!isValidDate(day, month, year) && year >= 1)
		day--;

	this.day = day;
	this.month = month;
	if (month == 1)
		this.setNextYear();
}

/**********************************************************
* Set the calendar to next year.
**********************************************************/
function Calendar.setNextYear() {
	var day = this.day;
	var month = this.month;
	var year = this.year;

	if (year < 9999) {
		year++;

		while(!isValidDate(day, month, year) && year >= 1)
			day--;

		this.day = day;
		this.year = year;
	}
}

/**********************************************************
* Get the current day in the YYYYMMDD format.
* Return: YYYYMMDD.
**********************************************************/
function Calendar.getCurrentDate() {
	var day = (this.day < 10)?("0" + this.day):(this.day);
	var month = (this.month < 10)?("0" + this.month):(this.month);

	return this.year.toString() + month + day;
}

/**********************************************************
* Get the day that the calendar currently points to.
* Return: 1 - 31.
**********************************************************/
function Calendar.getCurrentDay() {
	return this.day;
}

/**********************************************************
* Get the month that the calendar currently points to.
* Return: 1 - 12.
**********************************************************/
function Calendar.getCurrentMonth() {
	return this.month;
}

/**********************************************************
* Get the year that the calendar currently points to.
* Return: 1 - 9999.
**********************************************************/
function Calendar.getCurrentYear() {
	return this.year;
}

/**********************************************************
* Get day of week of the current date.
* Return: 0(Sun) - 6(Sat)
**********************************************************/
function Calendar.getCurrentDayOfWeek() {
	var firstDay = this.getCurrentDayOfWeekOfFirst();
	var day = this.day - 1;
	var month = this.month;
	var year = this.year;

	if (day >= 13 && day <= 29 && month == 9 && year == 1752)
		day = day - 11;

	return ((day + firstDay) % 7);
}

/**********************************************************
* Get day of week of first of the month.
* Return: 0(Sun) - 6(Sat)
**********************************************************/
function Calendar.getCurrentDayOfWeekOfFirst() {
	var firstDay, startYear, numDays, m, y;
	var month = this.month;
	var year = this.year;

	if (year >= 1 && year <= 999) {
		firstDay = 6;
		startYear = 1;
	}
	else if (year >= 1000 && year <= 1999) {
		firstDay = 1;
		startYear = 1000;
	}
	else {
		y = Math.floor(year / 1000);

		if (y % 2 == 0)
			firstDay = 6;
		else
			firstDay = 3;

		startYear = y * 1000;
	}

	for (y=startYear; y<=year; y++) {
		m = 1;
		while (m <= 12) {
			if (m == month && y == year) {
				m = 13;
			}
			else {
				numDays = getNumDaysInMonth(m, y);
				firstDay = (numDays + firstDay) % 7;
				m++;
			}
		}
	}

	return firstDay;
}

/**********************************************************
* Get the last day of the mnoth.
* Return: 31, 30, 29, 28.
**********************************************************/
function Calendar.getLastDayOfMonth() {
	var lastDay;
	var month = this.month;
	var year = this.year;

	if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
		lastDay = 31;
	else if (month == 4 || month == 6 || month == 9 || month == 11)
		lastDay = 30;
	else if (month == 2)
		if (isLeapYear(year))
			lastDay = 29;
	else
		lastDay = 28;

	return lastDay;
}

/**********************************************************
* Get the number of days that the current month has.
* Return: 0(Sun) - 6(Sat)
**********************************************************/
function Calendar.getNumDaysOfMonth() {
	var month = this.month;
	var year = this.year;
	var days = getNumDaysInMonth(month, year);

	return days;
}
