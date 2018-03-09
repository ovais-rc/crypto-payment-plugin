/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/



// accepts date in YYYY-MM-DD format and validates it if is within
// the year range of 1900 to 9999
// Returns true if date is a valid date
//         false otherwise
function validDate(inYear,inMonth,inDay)
{
   if (inDay.length > 0 && inDay.charAt(0) == "0")
     {
      inDay = inDay.substring(1, inDay.length);
     }

   if (inMonth.length > 0 && inMonth.charAt(0) == "0")
     {
      inMonth = inMonth.substring(1, inMonth.length);
     }

   if (inYear.length == 4 &&
       (inMonth.length == 1 || inMonth.length == 2) &&
       (inDay.length == 1 || inDay.length == 2))
    {
        var day = parseInt(inDay);
        var month = parseInt(inMonth);
        var year = parseInt(inYear);
        var dayString = day.toString();
        var monthString = month.toString();
        var yearString = year.toString();

        if ((year != NaN && yearString.length == 4 && year >= 1900 && year <= 9999 ) &&
           (month != NaN && month >= 1 && month <= 12 && (monthString.length == inMonth.length)) && (day != NaN && (inDay.length == dayString.length)))
        {

            var daysMonth = getDaysInMonth(month, year);

            if (day >= 1 && day <= daysMonth)
            {
                return true;
            }
        }
        else
        {
            return false;
        }

     }
    return false;
}

// CHECK TO SEE IF YEAR IS A LEAP YEAR
function isLeapYear(Year)
{
        if (((Year % 4) == 0) && ((Year % 100) != 0) || ((Year % 400) == 0)) {
          return (true);
        }
        else {
          return (false);
        }
}


// GET NUMBER OF DAYS IN MONTH
function getDaysInMonth(month, year)
{
        var days;

        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
          days = 31;
        else if (month == 4 || month == 6 || month == 9 || month == 11)
          days = 30;
        else if (month == 2)
        {
          if (isLeapYear(year)) {
            days = 29;
          }
          else {
            days = 28;
          }
        }
        return (days);
}



// Get the current year in the form YYYY
function getCurrentYear()
{
    var now   = new Date();
    var year  = now.getYear();

    return year;
}

// Get the current month in the form MM
function getCurrentMonth()
{
    var now   = new Date();
    var month = now.getMonth() + 1;

    if (("" + month).length == 1)
    {
        month = "0" + month;
    }

    return month;

}

// Get the current day in the form DD
function getCurrentDay()
{
    var now   = new Date();
    var day   = now.getDate();

    if (("" + day).length == 1)
    {
        day = "0" + day;
    }

    return day;
}


//////////////////////////////////////////////////////////
// check that the end date/time follows a start date/time.  this is useful for validating 2 dates
// to make sure that one is greater or equal to the other.
// you should validate the dates first to make sure they are in this format and valid.
// this function expect the startTime and endTime args to be in 'HH:MM' format.
// you should validate the times first to make sure they are in this format and valid.
//
// by Glen Shortliffe,Dean Hildebrand
//
// Input: startDate, endDate, startTime, endTime
// enter null for date args if only a time comparison is needed
// enter null for time args if only a date comparison is needed
// enter all args if date and time need to be compared
// Return code = true, endDate+endTime > startDate+startTime
// Return code = false, endDate+endTime < startDate+startTime
// Return code = -1, endDate+endTime == startDate+startTime
//////////////////////////////////////////////////////////

function validateStartEndDateTime(inStartYear,inStartMonth,inStartDay,inEndYear,inEndMonth,inEndDay,startTime,endTime)
{
    var inStartHour = 0;
    var inStartMinute = 0;
    var inStartSecond = 0;

    var inEndHour = 0;
    var inEndMinute = 0;
    var inEndSecond = 0;

    // parse the hours and minutes from the startTime
    if (startTime != null) {
       inStartHour = startTime.substring(0,startTime.indexOf(":"));
       inStartMinute = startTime.substring(startTime.indexOf(":") + 1);
    }

    // parse the hours and minutes from the endTime
    if (endTime != null) {
       inEndHour = endTime.substring(0,endTime.indexOf(":"));
       inEndMinute = endTime.substring(endTime.indexOf(":") + 1);
    }

    // alert('START\nY='+inStartYear+'\nM='+inStartMonth+'\nD='+inStartDay+'\nh='+inStartHour+'\nm='+inStartMinute+'\ns='+inStartSecond);
    // alert('END\nY='+inEndYear+'\nM='+inEndMonth+'\nD='+inEndDay+'\nh='+inEndHour+'\nm='+inEndMinute+'\ns='+inEndSecond);

    // create a date object for the startdate
    var sDate = new Date(inStartYear,
                         inStartMonth-1,
                         inStartDay,
                         inStartHour,
                         inStartMinute,
                         inStartSecond);

    // create a date object for the enddate
    var eDate = new Date(inEndYear,
                         inEndMonth-1,
                         inEndDay,
                         inEndHour,
                         inEndMinute,
                         inEndSecond);

    // generate millisecond internal representations of the start/end dates
    var startMilliTime = sDate.getTime();
    var endMilliTime = eDate.getTime();

    // alert ('start='+startMilliTime+' end='+endMilliTime);

    // if startMilliTime is greater than endMillTime return false.
    // otherwise return true.
    // note: startdate = enddate returns true!
    if (startMilliTime == endMilliTime)
    {
        return -1;
    }
    else if (startMilliTime > endMilliTime)
    {
        return false;
    }
    else if (startMilliTime < endMilliTime)
    {
        return true;
    }
}

function getPreselectedStartDate(value) {
	 var now = new Date();
	 if (document.all.time.value=="Yesterday") {
		return now.getYear() + "-" + (now.getMonth()+1) + "-" + (now.getDate()-1) + " 00:00:00";
	 } else if (document.all.time.value=="Weekly") {
	 	var startDay = null;
	 	var startMonth = null;
	 	var startYear = null;
	 	if (now.getDate()-now.getDay() < 1) {
	 		if (now.getMonth() == 0) {
	 			startYear = now.getYear() - 1;
	 			startMonth = 12;
	 		} else {
	 			startYear = now.getYear();
	 			startMonth = now.getMonth();
	 		}
	 		startDay = getDaysInMonth(startMonth, startYear) - now.getDay() + now.getDate();
	 	} else {
			startDay = now.getDate()-now.getDay();
			startMonth = now.getMonth()+1;
			startYear = now.getYear();
		}
		return startYear + "-" + startMonth + "-" + startDay + " 00:00:00";
	 } else if (document.all.time.value=="Monthly") {
		return now.getYear() + "-" + (now.getMonth()+1) + "-01 00:00:00";
	 } else if (document.all.time.value=="Quarterly") {
		return now.getYear() + "-" + ((Math.floor(now.getMonth()/3)*3)+1) + "-01 00:00:00";
	 } else if (document.all.time.value=="Yearly") {
		return now.getYear() + "-01-01 00:00:00";
	 }
}

function getPreselectedEndDate(value) {
	 var now = new Date();
	 if (document.all.time.value=="Yesterday") {
			return now.getYear() + "-" + (now.getMonth()+1) + "-" + (now.getDate()-1) + " 23:59:59";
	 } else if (document.all.time.value=="Weekly") {
	 	var endDay = null;
	 	var endMonth = null;
	 	var endYear = null;
	 	if (now.getDate()+(6 - now.getDay()) > getDaysInMonth(now.getMonth()+1, now.getYear())) {
	 		if (now.getMonth() == 11) {
	 			endYear = now.getYear() + 1;
	 			endMonth = 1;
	 			endDay = now.getDate() - now.getDay() + 6 - getDaysInMonth(12, endYear);
	 		} else {
	 			endYear = now.getYear();
	 			endMonth = now.getMonth()+ 2;
	 			endDay = now.getDate() - now.getDay() + 6 - getDaysInMonth(endMonth-1, endYear);
	 		}

	 	} else {
			endDay = now.getDate() - now.getDay() + 6;
			endMonth = now.getMonth()+1;
			endYear = now.getYear();
		}
		return endYear + "-" + endMonth + "-" + endDay + " 23:59:59";
	 } else if (document.all.time.value=="Monthly") {
			return now.getYear() + "-" + (now.getMonth()+1) + "-" + getDaysInMonth(now.getMonth()+1, now.getYear()) + " 23:59:59";
	 } else if (document.all.time.value=="Quarterly") {
			return now.getYear() + "-" + ((Math.floor(now.getMonth()/3)*3)+3) + "-" + getDaysInMonth(((Math.floor(now.getMonth()/3)*3)+3), now.getYear()) + " 23:59:59";
	 } else if (document.all.time.value=="Yearly") {
			return now.getYear() + "-12-31 23:59:59";
	 }
}

function showCalendar(calImg) {
   var calFrame = document.getElementById("CalFrame");
   var left=0;
   var top=0;

   for(var p=calImg; p&&p.tagName!='BODY'; p=p.offsetParent){
	      left+=p.offsetLeft;
	      top+=p.offsetTop;
   }

   var height=calImg.offsetHeight;
   var pHeight=calFrame.style.pixelHeight;
   var sTop=document.body.scrollTop;
   calFrame.style.left=left;

   if(top-pHeight >= sTop && top+height+pHeight > document.body.clientHeight+sTop)
     calFrame.style.top=top-pHeight;
   else
     calFrame.style.top=top+height;

   CalFrame.setDate(); // it's CalFrame not calFrame! using ID here
   calFrame.style.display="block";
   CalFrame.adjustFrameSize();
}

function hideCalendar() {
   var calFrame = document.getElementById("CalFrame"); 
   calFrame.style.display = "none";
}
