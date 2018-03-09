//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------

/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2004
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/


// accepts date in YYYY-MM-DD format and validates it if is within
// the year range of 1900 to 9999
// Returns true if date is a valid date
//         false otherwise
function wc_validateDate(yearStr,monthStr,dayStr)
{
   if (yearStr == null || monthStr == null || dayStr == null)
       return false;
       
   if (dayStr.length > 0 && dayStr.charAt(0) == "0")
     {
      dayStr = dayStr.substring(1, dayStr.length);
     }

   if (monthStr.length > 0 && monthStr.charAt(0) == "0")
     {
      monthStr = monthStr.substring(1, monthStr.length);
     }

   if (yearStr.length == 4 &&
       (monthStr.length == 1 || monthStr.length == 2) &&
       (dayStr.length == 1 || dayStr.length == 2))
    {
        var day = parseInt(dayStr);
        var month = parseInt(monthStr);
        var year = parseInt(yearStr);
        var dayString = day.toString();
        var monthString = month.toString();
        var yearString = year.toString();

        if ((year != NaN && yearString.length == 4 && year >= 1900 && year <= 9999 ) &&
           (month != NaN && month >= 1 && month <= 12 && (monthString.length == monthStr.length)) && (day != NaN && (dayStr.length == dayString.length)))
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

//////////////////////////////////////////////////////////
// This function will validate a positive integer quantity
//
// arg1 = the object you want info on...
// Return true is this input arg is a valid positive int,
// otherwise return false...
//////////////////////////////////////////////////////////
function wc_validateInt(intStr) {
    var validChars = "-0123456789";

    // if the string is empty it is not a valid integer
    if (isEmpty(intStr)) return false;

    // look for non numeric characters in the input string
    for (var i=0; i<intStr.length; i++) {
      if (validChars.indexOf(intStr.substring(i, i+1)) == "-1") {
        return false;
      }
    }
    // look for bad leading zeroes in the input string
    if (intStr.length > 1 && intStr.substring(0,1) == "0") {
       return false;
    }

    // "-" can only be at the very beginning
    if (intStr.lastIndexOf("-") > 0) {
       return false;
    }

    var iValue = parseInt(intStr);
    if (isNaN(iValue) || iValue < -2147483648 || iValue > 2147483647) {
        return false;
    }
        
    return true;
}

function wc_validateIntRange(intStr, min, max) {
    if (intStr == null || min == null || max == null)
        return false;
        
    if (!wc_validateInt(intStr))
        return false;
        
    var iValue = parseInt(intStr);    
    if (!(iValue >= min && iValue <= max))
        return false;
        
    return true;
}

//////////////////////////////////////////////////////////
// This function will count the number of bytes
// represented in a UTF-8 string
//
// arg1 = the UTF-8 string
// arg2 = the maximum number of bytes allowed in your input field
// Return false is this UTF-8 string is larger then arg2
// Otherwise return true...
//////////////////////////////////////////////////////////
function wc_validateUTF8length(inputStr, maxlength) {
    // alert('inputStr='+inputStr+'\nUTF-8 length='+inputStrByteLength(inputStr)+'\nmaxlength='+maxlength);
    if (utf8StringByteLength(inputStr) > maxlength) return false;
    else return true;
}


//////////////////////////////////////////////////////////
// This function will validate a typical name field
// and restrict it to pretty much alphanumerics.
// All special characters are invalid with some exceptions
// " ", "-", "_", and "." are all valid
// The string can also not start with a leading number
// The string can also not be empty
// call with ::
//    arg1=<myInputString>
//
// return true is name is valid, false otherwise
//////////////////////////////////////////////////////////
function wc_validateName(inputStr) {
    var invalidChars = "~!@#$%^&*()+=[]{};:,<>?/|`"; // invalid chars
    invalidChars += "\t\'\"\\"; // escape sequences
    var invalidStartChars = "0123456789";

    // if the string is empty it is not a valid name
    if (isEmpty(inputStr)) return false;

    // look for presence of invalid characters.  if one is
    // found return false.  otherwise return true
    for (var i=0; i<inputStr.length; i++) {
      if (invalidChars.indexOf(inputStr.substring(i, i+1)) >= 0) {
        return false;
      }
    }

    // look for a leading number... and disallow it.
    var startChar = inputStr.substring(0,1);
    for (var i=0; i<invalidStartChars.length; i++) {
      if (invalidStartChars.indexOf(startChar) >= 0) {
        return false;
      }
    }

    return true;
}

//////////////////////////////////////////////////////////
// This function will check whether or not the time has
// a valid format. hh:mm
//
// Input: time
// Return code = "true", time has a right format
// Return code = "false", time format is wrong
//
//////////////////////////////////////////////////////////
function wc_validateTime(timeStr) {
    
   if (timeStr == null)
       return false;
        
   var delimiter = ":";
   var hh, mm;
   var timeStrLength;
   var hhlength;
   var mmlength;

   timeStrLength = timeStr.length;

   if (timeStr == "" || timeStr.indexOf(delimiter) == -1 ||  timeStrLength > 5 ) return false;

   hh = timeStr.substring(0,timeStr.indexOf(delimiter));
   mm = timeStr.substring(timeStr.indexOf(delimiter) + 1);

   hhlength = hh.length;
   mmlength = mm.length;

   if (hhlength <1 || hhlength >2 || mmlength <1 || mmlength >2) return false;
   if (hh=="" || mm == "" ) return false;
   if (isNaN(hh) || isNaN(mm) ) return false;

   if ( parseInt(hh) > 23 || parseInt(hh) < 0 ) return false;
   if ( parseInt(mm) > 59 || parseInt(mm) < 0 ) return false;

   return true;
}


function wc_validateNonEmpty(inputStr) {
    return !isEmpty(inputStr);
}    


//////////////////////////////////////////////////////////
// This function will count the number of bytes
// represented in a UTF-8 string
//
// arg1 = the UTF-8 string you want a byte count of...
// Return the integer number of bytes represented by the string
//////////////////////////////////////////////////////////
function utf8StringByteLength(inputStr) {
  if (inputStr === null) return 0;
  var str = String(inputStr);
  var oneByteMax = 0x007F;
  var twoByteMax = 0x07FF;
  var byteSize = str.length;

  for (i = 0; i < str.length; i++) {
    chr = str.charCodeAt(i);
    if (chr > oneByteMax) byteSize = byteSize + 1;
    if (chr > twoByteMax) byteSize = byteSize + 1;
  }
  return byteSize;
}

function isEmpty(inputStr) {
   if (inputStr == null)
       return true;
   else    
       return !inputStr.match(/[^\s]/);
}


//////////////////////////////////////////////////////////
//Checks whether a string contains a double byte character
//target = the string to be checked
//
//Return true if target contains a double byte char; false otherwise
//////////////////////////////////////////////////////////
function containsDoubleByte (target) {
var str = new String(target);
var oneByteMax = 0x007F;

for (var i=0; i < str.length; i++){
chr = str.charCodeAt(i);
if (chr > oneByteMax) {return true;}
}
return false;
}

//////////////////////////////////////////////////////////
//A simple function to validate an email address
//It does not allow double byte characters
//strEmail = the email address string to be validated
//
//Return true if the email address is valid; false otherwise
//////////////////////////////////////////////////////////
function isValidEmail(strEmail){
	// check if email contains dbcs chars
	if (containsDoubleByte(strEmail)){
		return false;
	}
	
	if(strEmail.length == 0) {
		return true;
	} else if (strEmail.length < 5) {
             return false;
    } else {
    	if (strEmail.indexOf(" ") > 0){
    		return false;
        } else {
            if (strEmail.indexOf("@") < 1) {
            	return false;
            } else if (strEmail.indexOf(".") < 1) {
            	return false;
            } else {
            	if (strEmail.lastIndexOf(".") < (strEmail.indexOf("@") + 2)){
            		return false;
                } else {
                    if (strEmail.lastIndexOf(".") >= strEmail.length-1){
                    	return false;
                    }
                }
             }
         }
     }
     return true;
}
