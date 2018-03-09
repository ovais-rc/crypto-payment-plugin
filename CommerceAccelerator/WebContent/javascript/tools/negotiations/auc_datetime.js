//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*

//****************************************************************************
//  The following code is Calendar.js from Toronto
//****************************************************************************
////////////////////////////////////////////////////////////
// Calendar Utilities
//
// 1) getDateObject(adate, locale)
//
//     features  : retrieve the day,year,month from an
//                 formatted date string
//     parameters: a date string and calendar locale
//     output    : an object to include day, month and year
//                 string.  (object.dd, object.yy, object.mm)
//           
// 2) validateDate(adate, alocale)
//
//     features  : validate a date string based on its locale
//          parameters: a date string and calendar locale
//     output    : error string from 0 to 5 or return "true" 
//                 if the date format is correct.
//
// 3) isDateOrdered(date1, date2, alocale)
//
//     features  : compare two dates based on their locale and
//                 therefore, determine whether or not the
//                 date2 is later or equal to date1.
//     parameters: date1 and date2 string, calendar locale
//     output    : if return code = "true", the first date is samller 
//                 or equal to the 2nd  If return code = "0",  the 
//                 year of the first date is larger than the one
//                 in the second date.
//
// 4) validateTime(time1)
//
//      features   : check the time format
//      parameters : time string
//      output     : Return code = "true", time has a right format
//                   Return code = "false", time format is wrong
//
// 5) getYearFromTimeStamp(timestamp),
//    getMonthFromTimeStamp(timestamp),
//    getDayFromTimeStamp(timestamp)
//
//      features   : return year,month,day object from a timestamp
//      parameters : timestamp
//      output     : year,month,day string
//
// 6) getDateFormat(year, month, day, alocale) 
//
//      features   : format a date string based on a locale
//      parameters : year, month, day string and locale
//      output     : formatted date string based on the given
//                   locale
//
// 7) getDate(timestamp, alocale)
//    
//      features   : format a date string based on a locale
//      parameters : timestamp, locale
//      output     : formatted date string based on the given
//                   locale
//
// 8) formatTimeStamp(date, time, alocale)
//
//      features   : format to a timestamp
//      parameters : date string, time string, locale
//      output     : timestamp
//
// 9) getTimeFormat(hour, minute, second)
// 
//      features   : format to a time string
//      parameters : hour, minutes, second
//      output     : a formatted time string
////////////////////////////////////////////////////////////
var calendarInfo = new Object();

// English or any other unknown locales
calendarInfo["en_US"]              = new Object();
calendarInfo["en_US"]["format"]    = "mmddyy";
//calendarInfo["en_US"]["format"]    = "yymmdd";
calendarInfo["en_US"]["separator"] = "/";

// German locale
calendarInfo["de_DE"]              = new Object();
calendarInfo["de_DE"]["format"]    = "ddmmyy";
calendarInfo["de_DE"]["separator"] = ".";

// French locale
calendarInfo["fr_FR"]              = new Object();
calendarInfo["fr_FR"]["format"]    = "ddmmyy";
calendarInfo["fr_FR"]["separator"] = "/";

// Simplify Chinese locale
calendarInfo["zh_CN"]              = new Object();
calendarInfo["zh_CN"]["format"]    = "yymmdd";
calendarInfo["zh_CN"]["separator"] = "-";

// Traditional Chinese locale1
calendarInfo["zh_TW"]              = new Object();
calendarInfo["zh_TW"]["format"]    = "yymmdd";
calendarInfo["zh_TW"]["separator"] = "/";

calendarInfo["Zh_TW"]              = new Object();
calendarInfo["Zh_TW"]["format"]    = "yymmdd";
calendarInfo["Zh_TW"]["separator"] = "/";


// Japanese locale
calendarInfo["ja_JP"]              = new Object();
calendarInfo["ja_JP"]["format"]    = "yymmdd";
calendarInfo["ja_JP"]["separator"] = "/";

// Japanese locale
calendarInfo["Ja_JP"]              = new Object();
calendarInfo["Ja_JP"]["format"]    = "yymmdd";
calendarInfo["Ja_JP"]["separator"] = "/";

// Korean locale
calendarInfo["ko_KR"]              = new Object();
calendarInfo["ko_KR"]["format"]    = "yymmdd";
calendarInfo["ko_KR"]["separator"] = "-";

// Spanish locale
calendarInfo["es_ES"]              = new Object();
calendarInfo["es_ES"]["format"]    = "ddmmyy";
calendarInfo["es_ES"]["separator"] = "/";

// Brazilian locale
calendarInfo["pt_BR"]              = new Object();
calendarInfo["pt_BR"]["format"]    = "ddmmyy";
calendarInfo["pt_BR"]["separator"] = "/";

// Italian
calendarInfo["it_IT"]              = new Object();
calendarInfo["it_IT"]["format"]    = "ddmmyy";
calendarInfo["it_IT"]["separator"] = "/";

//Poland
calendarInfo["pl_PL"]              = new Object();
calendarInfo["pl_PL"]["format"]    = "yymmdd";
calendarInfo["pl_PL"]["separator"] = "/";

//Russian
calendarInfo["ru_RU"]              = new Object();
calendarInfo["ru_RU"]["format"]    = "mmddyy";
calendarInfo["ru_RU"]["separator"] = ".";

//Romania
calendarInfo["ro_RO"]              = new Object();
calendarInfo["ro_RO"]["format"]    = "mmddyy";
calendarInfo["ro_RO"]["separator"] = ".";

//////////////////////////////////////////////////////////////
// This function is used to return an object to include string
// to represent the day, month and year 
//////////////////////////////////////////////////////////////
function getDateObject(adate, locale)
{
  var dateObj = new Object();
  var mm, dd, yy;
  var separator = calendarInfo[locale]["separator"];

  if (calendarInfo[locale]["format"] == "mmddyy")
  {
    mm = adate.substring(0, adate.indexOf(separator));
    dd = adate.substring(adate.indexOf(separator) + 1, adate.lastIndexOf(separator));
    yy = adate.substring(adate.lastIndexOf(separator) + 1, adate.length);
  }
  else if (calendarInfo[locale]["format"] == "ddmmyy")
  {
    dd = adate.substring(0, adate.indexOf(separator));
    mm = adate.substring(adate.indexOf(separator) + 1, adate.lastIndexOf(separator));
    yy = adate.substring(adate.lastIndexOf(separator) + 1, adate.length);
  }
  else if (calendarInfo[locale]["format"] == "yymmdd")
  {
    yy = adate.substring(0, adate.indexOf(separator));
    mm = adate.substring(adate.indexOf(separator) + 1, adate.lastIndexOf(separator));
    dd = adate.substring(adate.lastIndexOf(separator) + 1, adate.length);
  }
  else
  { // default
    mm = adate.substring(0,adate.indexOf(separator));
    dd = adate.substring(adate.indexOf(separator) + 1, adate.lastIndexOf(separator));
    yy = adate.substring(adate.lastIndexOf(separator) + 1, adate.length);
  }

  dateObj.mm = mm;  // month
  dateObj.dd = dd;  // day
  dateObj.yy = yy;  // year

  return dateObj;
}


/////////////////////////////////////////////////////////////
// This function is used to validate the date to make sure //
// that the date is OK for that particular locale          //
//                                                         //
// input: date(11/10/1999), locale(en_US)                  //
// return value:                                           //
// [ if return value is other than "true", you should      //
//   implement your own message to display the error info. //
//                                                         //
// if return code = "true", date is valid                  //
// if return code = "0", month is not a number             //
// if return code = "1", Day is not the number             //
// if return code = "2", year is not the number            //
// if return code = "3", month is <= 0 or > 12             //
// if return code = "4", day is <=0 or >31                 //
// if return code = "5", year is <=1900 or > 9999          //
/////////////////////////////////////////////////////////////
function validateDate(adate, alocale) {

  var mm, dd, yy;

  if (adate == "") return false;

  var dateObj = getDateObject(adate, alocale);

  mm =dateObj.mm;
  dd =dateObj.dd;
  yy =dateObj.yy;
  
  if ( isNaN(mm) ) {      
     return "0";  // month is not a number
  }
  if ( isNaN(dd) ) {      
     return "1";  // day is not a number
  }
  if ( isNaN(yy) ) {      
     return "2";  // year is not a number
  }
  if ( mm <=0 || mm > 12 ) {                             
     return "3";  // month is not between 1 and 12
  }                                                                             
  if ( dd <=0 || dd > 31 ) {  
     return "4";  // day is not between 1 and 31
  }                                             
  if ( yy <= 1900 || yy > 9999 ) {    
      return "5"; // year is not between 1900 and 9999
  }        
  return "true";
}


////////////////////////////////////////////////////////////////////////
// This function will be used to compare 2 dates to determine whether 
// or not the first date is smaller or equal to the 2nd date
// 
// Input:  date one(11/10/1999), date two(12/10/2999), locale(en_US)
// Return value:
// If return code = "true", the first date is samller or equal to the 2nd 
// If return code = "0",  the year of the first date is larger than the one
//                  in the second date.
////////////////////////////////////////////////////////////////////////
function isDateOrdered(date1, date2, alocale) {

   var mm1, dd1, yy1, mm2, dd2, yy2;

   var dateObj1 = getDateObject(date1, alocale);
   mm1 = dateObj1.mm;
        dd1 = dateObj1.dd;
        yy1 = dateObj1.yy;

        var dateObj2 = getDateObject(date2, alocale);
   mm2 = dateObj2.mm;
        dd2 = dateObj2.dd;
        yy2 = dateObj2.yy;   
   
   var diff= eval("yy1-yy2");      
   if ( parseInt(diff) > 0 ) {       
      return "0"; // wrong date
   } else 
   if ( parseInt(diff) == 0 ) { // further check for month if years are the same
     var monthDiff = eval("mm1-mm2");          
     if ( parseInt(monthDiff) > 0 ) {                  
       return "0";
     } else
     if ( parseInt(monthDiff) == 0 ) { // further check for day if months are the same
        var dayDiff = eval("dd1-dd2");
        if ( parseInt(dayDiff) > 0 ) {             
           return "0";
         }
      } // end of further check for day
   } // end of further check for month
   
   return "true";
}



//////////////////////////////////////////////////////////
// This function will check whether or not the time has 
// a valid format. hh:mm:ss AM or PM
//
// Input: time
// Return code = "true", time has a right format
// Return code = "false", time format is wrong
//////////////////////////////////////////////////////////
function validateTime(time1) {

   var delimiter = ":"; 
   var hh, mm, ss;

   if (time1 == "" || time1.indexOf(delimiter) == -1) return false;
   
   hh = time1.substring(0,time1.indexOf(delimiter));
   mm = time1.substring(time1.indexOf(delimiter) + 1, time1.lastIndexOf(delimiter));
   ss = time1.substring(time1.lastIndexOf(delimiter) + 1, time1.lastIndexOf(" ")); 
   amPm = time1.substring(time1.lastIndexOf(" ")+1);
            
   if (hh=="" || mm == "" || ss == "") return "false";
   if (isNaN(hh) || isNaN(mm) || isNaN(ss)) return "false";

   var undefined
   if (amPm === undefined) return "false";
   if (amPm.toUpperCase() != "AM" && amPm.toUpperCase() != "PM") return "false";

   if ( parseInt(hh) > 12 || parseInt(hh) < 0 ) return "false";
   if ( parseInt(mm) > 60 || parseInt(mm) < 0 ) return "false";
   if ( parseInt(ss) > 60 || parseInt(ss) < 0 ) return "false";
   return "true";
}


////////////////////////////////////////////////////////////////
// Get year from a given timestamp:
// timestamp has the following format: 1999-10-10-00.00.00.0
// Return year as a string
////////////////////////////////////////////////////////////////
function getYearFromTimeStamp(timestamp) {  
        return timestamp.substring(0,4);
}


////////////////////////////////////////////////////////////////
// Get month from a given timestamp:
// timestamp has the following format: 1999-10-10-00.00.00.0
// Return month as a string
////////////////////////////////////////////////////////////////
function getMonthFromTimeStamp(timestamp) {
  return timestamp.substring(5, 7);
}


////////////////////////////////////////////////////////////////
// Get day from a given timestamp:
// timestamp has the following format: 1999-10-10-00.00.00.0
// Return day as a string
////////////////////////////////////////////////////////////////
function getDayFromTimeStamp(timestamp) {  
        return timestamp.substring(8,10);
}


//////////////////////////////////////////////////////////////
// get date based on a locale
// paraemter: year, month, day, locale
// return: a formatted date string
//////////////////////////////////////////////////////////////
 function getDateFormat(year, month, day, alocale) {

    var separator = calendarInfo[alocale]["separator"];
  
    if ( calendarInfo[alocale]["format"] == "mmddyy" ) {
                return month + separator + day + separator + year; 
         } else
         if ( calendarInfo[alocale]["format"] == "ddmmyy" ) {
                return day + separator + month + separator  + year;
         } else
         if ( calendarInfo[alocale]["format"] == "yymmdd" ) {
           return year + separator + month + separator + day;
         }
    else { // default
        return month + separator + day + separator + year; 
         }
}



//////////////////////////////////////////////////////////////
// get date based on a locale
// paraemter: year, month, day, locale
// return: a fixed format of yymmdd with locale specific separator
//////////////////////////////////////////////////////////////
/*
function getDateFormat(year, month, day, alocale) {

    var separator = calendarInfo[alocale]["separator"];
  
    return year + separator + month + separator + day;
}
*/




/////////////////////////////////////////////////////////////
// get formated date based on the locale,
// parameter: timestamp
// return a formatted date string
////////////////////////////////////////////////////////////
function getDate(timestamp, alocale) {
   var year = getYearFromTimeStamp(timestamp);
        var month= getMonthFromTimeStamp(timestamp);
        var day  = getDayFromTimeStamp(timestamp);
        return getDateFormat(year, month, day, alocale);
}


////////////////////////////////////////////////////////////
// Get a year value from a given date with a specific locale
// parameter: a formatted date,  a locale
// return: year as a string value
// If any error occurs, it will return today's year by default
////////////////////////////////////////////////////////////
function getYear(adate, alocale) {

  var yy;

  var dateObj = getDateObject(adate, alocale);
  yy =dateObj.yy;

  if ( isNaN(yy) ) {      
    // SET DAY MONTH AND YEAR TO TODAY'S DATE
    var now   = new Date();    
    var year  = now.getYear();
    if (year < 100) year += 1900;
    else year += 2000;
    return year;  // year is not a number
  }  // isNaN
  return yy;
}


////////////////////////////////////////////////////////////
// Get a month value from a given date with a specific locale
// parameter: a formatted date,  a locale
// return: month as a string value
// If any error occurs, it will return '12' by default
////////////////////////////////////////////////////////////
function getMonth(adate, alocale)
{
  var mm;
  var dateObj = getDateObject(adate, alocale);
  mm = dateObj.mm;

  if (isNaN(mm)) {
    return "12";  // year is not a number
  }
  if (parseInt(mm) <= 9 && (parseInt(mm) > 0)) {
    return "0" + parseInt(mm);
  }

  return mm;
}


////////////////////////////////////////////////////////////
// Get a day value from a given date with a specific locale
// parameter: a formatted date,  a locale
// return: month as a string value
// If any error occurs, it will return '30' by default
////////////////////////////////////////////////////////////
function getDay(adate, alocale)
{
  var dd;
  var dateObj = getDateObject(adate, alocale);
  dd = dateObj.dd;

  if (isNaN(dd)) {
    return "30";  // year is not a number
  }
  if (parseInt(dd) <= 9 && (parseInt(dd) > 0)) {
    return "0" + parseInt(dd);
  }

  return dd;
}


//////////////////////////////////////////////////////////////////
// Get hour string from a given time
// for example: 02:10:50 PM will return 14
/////////////////////////////////////////////////////////////////
function getHour(time)
{
  var res;
  var delimiter = ":";
  var index = time.search(delimiter);
  var hh = time.substring(0, index);
  var afternoon;

  afternoon = time.substring(time.lastIndexOf(" ") + 1, time.length);
  if (afternoon == "PM") {
    if (hh == "08") res = 20;
    else if (hh == "09") res = 21;
    else if (hh == "12") res = 12;
    else res = parseInt(hh) + 12;
  }
  else if (parseInt(hh) <= 9 && (parseInt(hh) > 0)) {
    res = "0" + parseInt(hh);
  }
  else {
    if (hh == "08") res = "0" + 8;
    else if (hh == "09") res = "0" + 9;
    else if (hh == "12") res = 00;
    else res = parseInt(hh);
  }

  return res;
}


//////////////////////////////////////////////////////////////////
// Get min string from a given time
// for example: 02:10:50 PM will return 10
/////////////////////////////////////////////////////////////////
function getMinutes(time)
{
  var delimiter = ":";
  var res;

  var index = time.search(delimiter);
  var minSecString = time.substring(index + 1, time.length);

  index = minSecString.search(delimiter);
  var min = minSecString.substring(0, index);

//  if (parseInt(min) <= 9) {
  if (parseInt(min) <= 9 && (parseInt(min) > 0)) {
    res = "0" + parseInt(min);
  }
  else {
    if (min == "00") res = "0" + 0;
    else if (min == "08") res = "0" + 8;
    else if (min == "09") res = "0" + 9;
    else res = parseInt(min);
  }

  return res;
}


//////////////////////////////////////////////////////////////////
// Get seconds string from a given time
// for example: 02:10:50 PM will return 50
/////////////////////////////////////////////////////////////////
function getSeconds(time)
{
  var delimiter = ":";
  var res;

  var index = time.search(delimiter);
  var minSecString = time.substring(index + 1, time.length);

  index = minSecString.search(delimiter);
  var sec = minSecString.substring(index + 1, minSecString.length);

//  if (parseInt(sec) <= 9) {
  if (parseInt(sec) <= 9 && (parseInt(sec) > 0)) {
    res = "0" + parseInt(sec);
  }
  else {
    var secTemp = sec.substring(0, 2);
    if (secTemp == "00") res = "0" + 0;
    else if (secTemp == "08") res = "0" + 8;
    else if (secTemp == "09") res = "0" + 9;
    else res = parseInt(sec);
  }

  return res;
}


/////////////////////////////////////////////////////////////////
// Given a date/time string and a locale, return a timestamp   //
/////////////////////////////////////////////////////////////////
function formatTimeStamp(date, time, alocale)
{
  var yr, mo, day, hr, min, sec, ts;

  yr = getYear(date, alocale);
  mo = getMonth(date, alocale);
  day = getDay(date, alocale);
  hr = getHour(time);
  sec = getSeconds(time);
  min = getMinutes(time);

  ts = yr + "-" + mo + "-" + day + " " + hr + ":" + min + ":" + sec;

  return ts;
}


//////////////////////////////////////////////////////////////
// get time which can be used to display on the GUI
// the returned time is in the following format:
//      hh:mm:ss AM
//   or hh:mm:ss PM
// paraemter: hour, minute, second
//            Note that the hour is in a 24-hour clock.
//            hour is in a range from 0 to 23
// return: a formatted time string
//////////////////////////////////////////////////////////////
function getTimeFormat(hour, minute, second) {

    var temp, tempHour;
    
    tempHour = (hour > 12) ? hour - 12 : hour
    temp =  ((tempHour < 10) ? "0" : "") + tempHour
    temp += ((minute < 10) ? ":0" : ":") + minute
    temp += ((second < 10) ? ":0" : ":") + second
    temp += (hour >= 12) ? " PM" : " AM"
    return temp         
}

//***************************************************************************
//  The following code is auction's own javascript functions
//***************************************************************************
//////////////////////////////////////////////////////////////
// get time which is in the VALID AMPM format
//      hh:mm:ss AM
//   or hh:mm:ss PM
// the returned value is a 24 hour time.
//      hh:mm:ss
// NOTE: PLEASE PERFORM VALIDITY CHECKS FOR TIME BEFORE CALLING
// THIS FUNCTION.
//////////////////////////////////////////////////////////////
			     
function convertTo24HourFormat(inTime){
    //alert("inTime=" +  inTime);
    //alert("inTimeLength=" +  inTime.length);

    if (inTime.length < 11)
		return NaN;

    var index      = inTime.search(" ");
    if (index == -1)
        return NaN;

    var AMPMString = inTime.substring(index + 1, inTime.length);
    var AMPMTime   = inTime.substring(0,index);

    var tempHour     = getHour(AMPMTime);
    var tempMinute   = getMinutes(AMPMTime);
    var tempSecond   = getSeconds(AMPMTime);
    tempHour = (AMPMString == "PM") ? tempHour + 12 : tempHour;
    var outTime =  tempHour + ":" + tempMinute + ":" + tempSecond;
    //alert(outTime);
    return outTime;
}


//////////////////////////////////////////////////////////
// This function will check whether or not the time has 
// a valid format. hh:mm:ss 
//
// Input: time
// Return code = "true", time has a right format
// Return code = "false", time format is wrong
//////////////////////////////////////////////////////////
function valid24HourTime(time1) {

   var delimiter = ":"; 
   var hh, mm, ss;

   if (time1 == "" || time1.indexOf(delimiter) == -1) return "false";
   
   hh = time1.substring(0,time1.indexOf(delimiter));
   mm = time1.substring(time1.indexOf(delimiter) + 1, time1.lastIndexOf(delimiter));
   ss = time1.substring(time1.lastIndexOf(delimiter) + 1, time1.length - 1); 
            
   if (hh=="" || mm == "" || ss == "") return "false";
   if (isNaN(hh) || isNaN(mm) || isNaN(ss)) return "false";

   if ( parseInt(hh) > 23 || parseInt(hh) < 0 ) return "false";
   if ( parseInt(mm) > 59 || parseInt(mm) < 0 ) return "false";
   if ( parseInt(ss) > 59 || parseInt(ss) < 0 ) return "false";
   return "true";
}


////////////////////////////////////////////////////////////////////////
// This function will be used to compare 2 times to determine whether 
// or not the first time is smaller than the 2nd time
// 
// Input:  time one(12:00), date two(15:00)
// Return value:
// If return code = "true", the first time is smaller than 2nd time 
// If return code = "false",  first time is larger than 2nd time
////////////////////////////////////////////////////////////////////////

function is24HourTimeOrdered(time1, time2) {

   var delimiter = ":"; 
   var hr1, min1, sec1, hr2, min2, sec2; 

   hr1  = time1.substring(0,time1.indexOf(delimiter));
   min1 = time1.substring(time1.indexOf(delimiter) + 1,5);
   //sec1 = time1.substring(time1.lastIndexOf(delimiter) + 1, 8); 
               
   hr2  = time2.substring(0,time2.indexOf(delimiter));
   min2 = time2.substring(time2.indexOf(delimiter) + 1,5);
   //sec2 = time2.substring(time2.lastIndexOf(delimiter) + 1, 8); 
  
   var diff= eval("hr1-hr2");
   if ( parseInt(diff) > 0 ) {       
      return "false"; // hour check
   } else 
   if ( parseInt(diff) == 0 ) { // further check for hours are the same
     var minDiff = eval("min1-min2");          
     if ( parseInt(minDiff) > 0 ) {                  
       return "false";
     }
     else if ( parseInt(minDiff) == 0) {                  
       return "false1";
     }

   //else
   //  if ( parseInt(minDiff) == 0 ) { // further check for seconds if minutes are the same
   //     var secDiff = eval("sec1-sec2");
   //     if ( parseInt(secDiff) >= 0 ) {             
   //        return "false";
   //      }
   //   } // end of further check for seconds
   } // end of further check for minutes
   
   return "true";

}

////////////////////////////////////////////////////////////////////////
// This function will be used to compare 2 times to determine whether 
// or not the first time is smaller than the 2nd time
// 
// Input:  time one(12:00:00 AM), date two(12:00:00 PM)
// Return value:
// If return code = "true", the first time is smaller than 2nd time 
// If return code = "false",  first time is larger than 2nd time
////////////////////////////////////////////////////////////////////////

function isTimeOrdered(time1, time2) {

   var hr1, min1, sec1, hr2, min2, sec2;

   hr1 = getHour(time1);
   min1 = getMinutes(time1);
   sec1 = getSeconds(time1);
   hr2 = getHour(time2);
   min2 = getMinutes(time2);
   sec2 = getSeconds(time2);
   
   var diff= eval("hr1-hr2");      
   if ( parseInt(diff) > 0 ) {       
      return "false"; // hour check
   } else 
   if ( parseInt(diff) == 0 ) { // further check for hours are the same
     var minDiff = eval("min1-min2");          
     if ( parseInt(minDiff) > 0 ) {                  
       return "false";
     } else
     if ( parseInt(minDiff) == 0 ) { // further check for seconds if minutes are the same
        var secDiff = eval("sec1-sec2");
        if ( parseInt(secDiff) >= 0 ) {             
           return "false";
         }
      } // end of further check for seconds
   } // end of further check for minutes
   
   return "true";

}


