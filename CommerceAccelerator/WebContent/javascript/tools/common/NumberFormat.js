/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2004
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/


function getNumericInfo(currencyCode, languageID) 
{
    curkey = "(" + currencyCode + "," + languageID + ")";
    for (i = 0; i < numericInfo["curGroup"].length; i++) {
        if (numericInfo["curGroup"][i]["curKey"].indexOf(curkey) >= 0)
            return numericInfo["curGroup"][i];
    }
    
    // if not found, return default object
    return numericInfo["default"]["currency"];
}    

function isValidCurrency(currency, currencyCode, languageID)
{
  var maxFrac;

  // scientific format is not allowed, for instance, 1e-09
  var currResult = new String(trim(currency));
  if (currResult.indexOf("e") >= 0)
      return false;

  var numResult = currencyToNumber(currency,currencyCode,languageID);
  
  if(numResult < 0)
      return false;

  currResult = new String(numResult);
  if (currResult == "NaN" || currResult.indexOf("e") >= 0)
      return false;

  ninfo = getNumericInfo(currencyCode, languageID) ;

  maxFrac  = ninfo["maxFrac"];

  if ( numberOfDecimalPlaces(numResult) > maxFrac)
  {
      return false;
  }    
  else
  {
      return true;
  }

  
}// END isValidCurrency

/****************************************************************************
* Format and validate a given currency value. If no locale is provided,
* en_US is used by default.
*
* currency - The currency value to be formatted and validated.
* locale   - The locale used to determine the currency.
*
* Returns the formatted currency if successful; string "NaN" if an invalid
* currency is provided or null if an unsupported locale value was provided.
****************************************************************************/
function formatCurrency(currency, currencyCode, languageID)
{
  var thouSep;
  var decSep;
  var minFrac;
  var maxFrac;
  var groupingSize;
  
  if ( (currency == null) || (currency == "") )	   
	return ("NaN");

  var currencyString = new String(currency);
  if ( currencyString.indexOf("-") != -1 ) 
	return ("NaN");

  ninfo = getNumericInfo(currencyCode, languageID) ;

  thouSep    = ninfo["thouSep"];
  decSep     = ninfo["decSep"];
  minFrac  = ninfo["minFrac"];
  maxFrac  = ninfo["maxFrac"];
  groupingSize = ninfo["groupingSize"];
  
  return(formatNum(currency, thouSep, decSep, minFrac, maxFrac,groupingSize));
  
}// END formatCurrency

/****************************************************************************
* Convert a properly formatted currency value to a primative numeric value.
* If no locale is provided, en_US is used by default.
*
* currency - The currency value to be formatted and validated.
* locale   - The locale used to determine the currency.
*
* Returns a primative numeric value if successfull; string "NaN" if the
* conversion has failed or null if an unsupported locale is provided.
****************************************************************************/
function currencyToNumber(currency,  currencyCode, languageID)
{
  var thouSep;
  var decSep;
  var groupingSize;

  // If no locale is specified, use en_US as default
  ninfo = getNumericInfo(currencyCode, languageID) ;

  thouSep    = ninfo["thouSep"];
  decSep     = ninfo["decSep"];
  groupingSize = ninfo["groupingSize"];
  
  return(toNum(currency, thouSep, decSep,groupingSize));
  
}// END currencyToNumber

/****************************************************************************
* Convert a primative numeric value to a particular currency. If no locale
* is provided, en_US is used by default.
*
* num    - The primative numeric value to be converted to a currency.
* locale - The locale used to determine the currency.
*
* Returns a correctly formatted currency; string "NaN" if the conversion
* failed or null if an unsupported locale was provided.
****************************************************************************/
function numberToCurrency(num, currencyCode, languageID)
{
  var thouSep;
  var decSep;
  var minFrac;
  var maxFrac;
  var groupingSize;
  
  ninfo = getNumericInfo(currencyCode, languageID) ;

  thouSep    = ninfo["thouSep"];
  decSep     = ninfo["decSep"];
  minFrac  = ninfo["minFrac"];
  maxFrac  = ninfo["maxFrac"];
  groupingSize = ninfo["groupingSize"];
  
  var buffer = numericToString(num,minFrac,decSep);
  
  return(formatNum(buffer, thouSep, decSep, minFrac, maxFrac,groupingSize));
  
}// END numberToCurrency

/****************************************************************************
* Convert a primative numeric value to a string value. If no locale
* is provided, en_US is used by default.
*
* num       - The primative numeric value to be converted.
* locale    - The locale used to determine the format.
* decPlaces - The number of decimal places for rounding purposes.
*
* Returns a correctly formatted number of type String; string "NaN" if the
* conversion failed or null if an unsupported locale was provided.
****************************************************************************/
function numberToStr(num, languageID, decPlaces)
{
  var thouSep;
  var decSep;
  var minFrac = decPlaces;
  var maxFrac = decPlaces;
  var groupingSize;

  // If no locale is specified, use en_US as default
  if(languageID != null && defined(numericInfo[languageID]))
  {
      thouSep    = numericInfo[languageID]["number"]["thouSep"];
      decSep     = numericInfo[languageID]["number"]["decSep"];
      groupingSize = numericInfo[languageID]["number"]["groupingSize"];
  }
  else
  {
    thouSep    = numericInfo["default"]["number"]["thouSep"];
    decSep     = numericInfo["default"]["number"]["decSep"];
    groupingSize = numericInfo["default"]["number"]["groupingSize"];
  }
  
  // make sure it is proper form 
  var buffer = numericToString(num,minFrac,decSep);
  
  return(formatNum(buffer, thouSep, decSep, minFrac, maxFrac,groupingSize));
  
}// END numberToStr

/****************************************************************************
* Convert a properly formatted string to a primative numeric value.
*
* num       - The number to be formatted and validated.
* locale    - The locale used to determine proper number formatting.
*
* Returns a primative numeric value or null if an unsupported locale is
* provided.
****************************************************************************/
function strToNumber(num, languageID)
{
  var thouSep;
  var decSep;
  var groupingSize;
  
  // If no locale is specified, use en_US as default
  if(languageID != null && defined(numericInfo[languageID]))
  {
      thouSep = numericInfo[languageID]["number"]["thouSep"];
      decSep  = numericInfo[languageID]["number"]["decSep"];
      groupingSize = numericInfo[languageID]["number"]["groupingSize"];
  }
  else
  {
    thouSep = numericInfo["default"]["number"]["thouSep"];
    decSep  = numericInfo["default"]["number"]["decSep"];
    groupingSize = numericInfo["default"]["number"]["groupingSize"];
  }
  
  return(toNum(num, thouSep, decSep,groupingSize));
  
}// END strToNumber

/****************************************************************************
* validate a given number.
*
* num       - The number to be formatted and validated.
* locale    - The locale used to determine proper number formatting.
* allowNegativeNumber - if negative number is valid (default is FALSE if this parameter omitted)
*
* Return true or false depending on whether num is a valid number for the given language
****************************************************************************/
function isValidNumber(num, languageID, allowNegativeNumber)
{
  var res = strToNumber(num, languageID);

  if (allowNegativeNumber == null || allowNegativeNumber == undefined)
      allowNegativeNumber = false;

  if ( (new String(res)) == "NaN" || (!allowNegativeNumber && res < 0 ) )
  {
      return false;
  }
  else
  {
      return true;
  }
  
}// END isValidNumber


/****************************************************************************
* Format and validate a given number.
*
* num       - The number to be formatted and validated.
* locale    - The locale used to determine proper number formatting.
* decPlaces - The number of decimal places for rounding purposes.
*
* Returns the formatted number of type String if successfull; Nan if an
* invalid currency is provided or null if an unsupported locale value was
* provided.
****************************************************************************/
function formatNumber(num, languageID, decPlaces)
{
  var thouSep;
  var decSep;
  var minFrac = decPlaces;
  var maxFrac = decPlaces;
  var groupingSize;
  
  // If no locale is specified, use en_US as default
  if(languageID != null && defined(numericInfo[languageID]))
  {
      thouSep = numericInfo[languageID]["number"]["thouSep"];
      decSep  = numericInfo[languageID]["number"]["decSep"];
      groupingSize = numericInfo[languageID]["number"]["groupingSize"];
  }
  else
  {
    thouSep = numericInfo["default"]["number"]["thouSep"];
    decSep  = numericInfo["default"]["number"]["decSep"];
    groupingSize = numericInfo["default"]["number"]["groupingSize"];
  }
  
  return(formatNum(num, thouSep, decSep, minFrac, maxFrac,groupingSize));
  
}// END formatNumber

/****************************************************************************
* Format and validate a given integer.
*
* num       - The number to be formatted and validated.
* locale    - The locale used to determine proper number formatting.
*
* Returns the formatted integer of type String if successfull; string "NaN"
* if an invalid integer is provided or null if an unsupported locale value
* was provided.
****************************************************************************/
function formatInteger(num, languageID)
{
  var thouSep;
  var groupingSize;

  // If no locale is specified, use en_US as default
  if(languageID != null && defined(numericInfo[languageID]))
  {
      thouSep = numericInfo[languageID]["number"]["thouSep"];
      groupingSize = numericInfo[languageID]["number"]["groupingSize"];
  }
  else
  {
    thouSep = numericInfo["default"]["number"]["thouSep"];
    groupingSize = numericInfo["default"]["number"]["groupingSize"];
  }

  return(formatInt(num, thouSep,groupingSize));
  
}// END formatInteger

/****************************************************************************
* Format and validate a given number
*
* num       - The number to be formatted and validated.
* thouSep   - The thousand separator to be used in validation and formatting.
* decSep    - The decimal separator to be used in validation and formatting.
* decPlaces - The number of decimal places for rounding purposes.
* groupingSize - Grouping size is the number of digits between grouping
*                separators in the integer portion of a number
*
* Returns the formatted number of type String or string "NaN" if an invalid
* currency value was provided.
****************************************************************************/
function formatNum(num, thouSep, decSep, minFrac, maxFrac,groupingSize)
{

  var segments;
  var leftSide;     // Value to the left of the decimal place
  var rightSide;    // Value to the right of the decimal place
  var decPos;       // Position of the decimal place in the given number
  var result = "";  // Formatted number that is returned to the user
  var buffer = "";  // Buffer used to store temporary info

  // trim the space strip out the "+" and keep the "-" of the num

  var tempNum= new String(trim(num));
  var number = new Object;
  if(tempNum.charAt(0)=="+")
  	 number = tempNum.substring(1);    	
  else if (tempNum.charAt(0)=="-") {
  	 number = tempNum.substring(1);    	
	 result += "-";
  }
  else
  	 number = tempNum;
  
  if( (number == null) || (number == "") )
    return("NaN");

  segments = number.split(decSep);

  // Determine the values on the left and right side of the decimal place
  if( (decPos = number.indexOf(decSep)) == -1)
  {
    leftSide  = segments[0];
    rightSide = null;
  }
  else if(segments.length <= 2)
  {
    if(decPos > 0)
    {
      leftSide  = segments[0];
      rightSide = segments[1];
    }
    else
    {
      leftSide  = null;
      rightSide = segments[1];
    }
  }
  else
    return("NaN");
  
  // Validate the number on the left side of the decimal place
  if(leftSide == null)
    buffer = "0";
  else
  {
    var value;
    
    segments = leftSide.split(thouSep);
    value = segments[0];
    
    if(isNaN(Number(value)))
      return("NaN");
    
    if(segments.length == 1)
      buffer = value;
    else
    {
      if(value.length <= groupingSize)
        buffer = value;
      else
        return("NaN");
        
      for(var j=1; j<segments.length; j++)
      {
        value = segments[j];
        
        if( isNaN(Number(value)) || (value.length != groupingSize) )
          return("NaN");
          
        buffer += value;
      
      }// END for
    }// END else
  }// END else
  
  // Validate the number on the right side of the decimal place
  if(rightSide != null)
  {
    if(isNaN(Number(rightSide)))
      return("NaN");
  
// allow less that the minimum fraction digits and just format properly
//    if (rightSide.length < minFrac)
//      return ("NaN");
        
    buffer += "." + rightSide;
  }
  
  // if maxFrac is null do not round the fraction digits
  if ( maxFrac == null)
	buffer = new String( Number(buffer));
  else
  {
  	// Format validated number...
  	if (buffer == Number(buffer).toString()) {
  		buffer = round(Number(buffer), maxFrac);
  	}
  }

  if(isNaN(buffer))
    return("NaN");

  segments = buffer.split(".");
  leftSide = segments[0];
  
    
  var offset;
  
  buffer = leftSide.length % groupingSize;
  
  if(buffer == 0)
    offset = groupingSize;
  else
    offset = buffer;
  
  result += leftSide.substring(0, offset);
  
  for(var k=offset; k<leftSide.length; k += groupingSize)
  {
    result += thouSep + leftSide.substring(k, k+groupingSize);
  }// END for
  
  if(maxFrac != null)
  {
    	rightSide = segments[1];

  	if(maxFrac > 0 && rightSide != null)
    	result += decSep + rightSide.substring(0, maxFrac);
  }
  else
  {
	if (segments.length == 2)
		result += decSep + rightSide;
  }
  
  return(result);
}// END formatNum

/****************************************************************************
* Format and validate a given integer
*
* num       - The number to be formatted and validated.
* thouSep   - The thousand separator to be used in validation and formatting.
* groupingSize - Grouping size is the number of digits between grouping
*                separators in the integer portion of a number
*
* Returns the formatted number of type String or string "NaN" if an invalid
* integer value was provided.
****************************************************************************/
function formatInt(num, thouSep, groupingSize)
{
  var number = new String(trim(num));
  var segments;
  var leftSide;     // Value to the left of the decimal place
  var result = "";  // Formatted number that is returned to the user
  var buffer = "";  // Buffer used to store temporary info
  
  // Validate the number on the left side of the decimal place
  if( (number == null) || (number == "") )
    return("NaN");
  else
  {
    var value;
    
    segments = number.split(thouSep);
    value = segments[0];

    if(isNaN(Number(value)))
      return("NaN");
    
    if(segments.length == 1)
      buffer = value;
    else
    {
      if(value.length <= groupingSize)
        buffer = value;
      else
        return("NaN");
        
      for(var j=1; j<segments.length; j++)
      {
        value = segments[j];
        
        if( isNaN(Number(value)) || (value.length != groupingSize) )
          return("NaN");
          
        buffer += value;
      
      }// END for
    }// END else
  }// END else
  
  for(var i=0; i<buffer.length; i++)
  {
    var ch = Number(buffer.charAt(i));
    
    if(isNaN(ch))
      return("NaN");
  }

  var offset;
  
  number = buffer;
  
  if((number.length % groupingSize) == 0)
    offset = groupingSize;
  else
    offset = number.length % groupingSize;
  
  result = number.substring(0, offset);
  
  for(var k=offset; k<number.length; k += groupingSize)
  {
    result += thouSep + number.substring(k, k+groupingSize);
  }// END for
  
  return(result);
}// END formatInt

/****************************************************************************
* Convert a number to a primitive numeric value
*
* num          - The number to be formatted and validated.
* thouSep      - The thousand separator to be used in validation and formatting.
* decSep       - The decimal separator to be used in validation and formatting.
* groupingSize - Grouping size is the number of digits between grouping
*                separators in the integer portion of a number
*
* Returns a primitive numeric value; string "NaN" if the conversion failed.
****************************************************************************/
function toNum(num, thouSep, decSep, groupingSize)
{
  var currChar;
  var buffer = "";
  var number = new String(trim(num));
  var thouHit = false;
  var decHit = false;
  var groupCount = 0;

  if( (number == null) || (number == "") )
    return("NaN");

  for(var i=0; i < number.length; i++)
  {
    currChar = number.charAt(i);
    groupCount++;

  if ( (( currChar == ' ')  && ((thouSep.charCodeAt(0) == 160) && thouSep.length == 1)) || (currChar == thouSep)  )  
  {
      if (decHit == true)
      {
          return("NaN");
      }
      if (thouHit == true)
      {
          if (groupCount-1 != groupingSize)
          {
              return("NaN");
          }
      }
      thouHit = true;
      groupCount = 0;
      continue;
    }
    else if(currChar == decSep)
    {   
        decHit = true;

        if (thouHit == true)
        {
          if (groupCount-1 != groupingSize)
          {
              return("NaN");
          }            
        }
        groupCount = 0;
        buffer += ".";
    }
     
    // Even if the decimal point is not '.' the javascript function Number() accepts '.'
    // We need the following check to prevent this
    else if ( currChar == '.')  
	return("NaN");
    else
      buffer += currChar;
  }// END for

  if (decHit == false && thouHit == true && groupCount != groupingSize)
  {
    return("NaN");
  }
  
  return(Number(buffer));
  
}// END toNum

/****************************************************************************
* Round off a primitive numeric to the given decimal places
*
* num - The number to be rounded.
* decPlaces - The number of decimal places for rounding purposes.
*
* Returns the rounder number as a String object; string "NaN" if "num" is not
* a valid number.
****************************************************************************/
function round(num, decPlaces)
{
  var decSep = ".";  // Decimal separator
  var buff;          // Buffer used to determine rounded number
  var i;             // Location of the decimal place
  
  var descrep;
  var segments;
  var leftSide;
  var rightSide;
  
  num = Number(num);

  if(isNaN(num))
    return("NaN");

  buffer = "" + Math.round(num * Math.pow(10, decPlaces)) / Math.pow(10,
                                                                   decPlaces);
  
  // Damn!! Math.round does not work correctly; so, we must double check
  // the formatting...
  i = buffer.indexOf(decSep);
  segments = buffer.split(".");

  if(i == 0)
    buffer = "0" + buffer;
  
  if(segments.length == 2)  
    descrep = decPlaces - segments[1].length;
  else
  {
    descrep = decPlaces;
    
    if(descrep > 0)
      buffer += decSep;
  }
  
  for(var j=0; j<descrep; j++)
    buffer += "0";
      
  return(buffer);
}// END round

/****************************************************************************
* Convert a primitive number into a language specific string by
* adding zeros and converting the decimal separator into the language specific
* separator
*
* This is necessary because when you convert a numeric to a string it removes the zeroes
*
* num - A primitive number
* decPlaces - The number of decimal places for rounding purposes.
* decSep - The decimal separator to replace
*
****************************************************************************/
function numericToString(num, decPlaces,decSep)
{
  var number = new String(num);
  var segments = number.split(".");
  var leftSide;     // Value to the left of the decimal place
  var rightSide;    // Value to the right of the decimal place
  var decPos;       // Position of the decimal place in the given number
  var buffer;

  if( (number == null) || (number == "") || isNaN(Number(num)))
  {
    return("NaN");
  }

  // Replace the decimal separator with the currency-specific decimal
  // separator (there isn't a thousand separator since the number was primitive numeric)
  if( (decPos = number.indexOf(".")) == -1)
  {
    leftSide  = segments[0];
    rightSide = "";
  }
  else if(segments.length <= 2)
  {
    if(decPos > 0)
    {
      leftSide  = segments[0];
      rightSide = segments[1];
    }
    else
    {
      leftSide  = "0";
      rightSide = segments[1];
    }
  }
  else
  {
    return("NaN");
  }


  // And add zeros to end of string as required for number
  while (rightSide.length < decPlaces)
  {
    rightSide += "0";
  }

  buffer = leftSide + decSep + rightSide;

  return buffer;
}

/****************************************************************************
* Return the number of decimal places after the decimal separator
*
* This is necessary because when you convert a numeric to a string it removes the zeroes
*
* num - A primitive number
*
****************************************************************************/
function numberOfDecimalPlaces(num)
{
  var number = new String(num);
  var segments = number.split(".");
  var rightSide;    // Value to the right of the decimal place
  var decPos;       // Position of the decimal place in the given number

  if( (number == null) || (number == "") || isNaN(Number(num)))
  {
    return("NaN");
  }

  // Replace the decimal separator with the currency-specific decimal
  // separator (there isn't a thousand separator since the number was primitive numeric)
  if( (decPos = number.indexOf(".")) == -1)
  {
    return 0;
  }
  else if(segments.length <= 2)
  {
    return segments[1].length;
  }
  else
  {
    return("NaN");
  }

  
}

/****************************************************************************
* Convert a properly formatted string to a primative numeric value.
*
* num       - The number to be formatted and validated.
* locale    - The locale used to determine proper number formatting.
*
* Returns a primative numeric value or null if an unsupported locale is
* provided.
****************************************************************************/
function strToInteger(intnum, languageID)
{
  var thouSep;
  var decSep;
  var groupingSize;
  
  // If no locale is specified, use en_US as default
  if(languageID != null && defined(numericInfo[languageID]))
  {
      thouSep = numericInfo[languageID]["number"]["thouSep"];
      decSep  = numericInfo[languageID]["number"]["decSep"];
      groupingSize = numericInfo[languageID]["number"]["groupingSize"];
  }
  else
  {
    thouSep = numericInfo["default"]["number"]["thouSep"];
    decSep  = numericInfo["default"]["number"]["decSep"];
    groupingSize = numericInfo["default"]["number"]["groupingSize"];
  }
  
  return(toIntegerNum(intnum, thouSep, decSep,groupingSize));
  
}// END strToNumber

/****************************************************************************
* validate a given Integer number.
*
* numint       - The number to be formatted and validated.
* locale    - The locale used to determine proper number formatting.
*
* Return true or false depending on whether num is a valid number for the given language
****************************************************************************/
function isValidInteger(numint, languageID)
{
  var res = strToInteger(numint, languageID);
  if ((new String(res)) == "NaN")
  {
      return false;
  }
  else
  {
      return true;
  }
  
}// END isValidInteger



/****************************************************************************
* validate and Convert an Integer number to a primitive numeric value
*
* intnum       - The integer number to be formatted and validated.
* thouSep      - The thousand separator to be used in validation and formatting.
* decSep       - The decimal separator to be used in validation and formatting.
* groupingSize - Grouping size is the number of digits between grouping
*                separators in the integer portion of a number
*
* Returns a primitive numeric value; string "NaN" if the conversion failed.
****************************************************************************/
function toIntegerNum(intnum, thouSep, decSep, groupingSize)
{
  var currChar;
  var buffer = "";
  var number = new String(trim(intnum));
  var thouHit = false;
  var decHit = false;
  var groupCount = 0;

  if( (number == null) || (number == "") )
    return("NaN");

  for(var i=0; i < number.length; i++)
  {
    currChar = number.charAt(i);
    groupCount++;

    if ( (( currChar == ' ')  && ((thouSep.charCodeAt(0) == 160) && thouSep.length == 1)) || (currChar == thouSep)  )  
    {
      
      if (thouHit == true)
      {
          if (groupCount-1 != groupingSize)
          {
              return("NaN");
          }
      }
      thouHit = true;
      groupCount = 0;
      continue;
    }
    else if(currChar == decSep)
    {           
              return("NaN");
    }
    // Even if the decimal point or thousand separator is not '.' the javascript function Number() accepts '.'
    // We need the following check to prevent this
    else if ( currChar == '.')  
	return("NaN");	
    else
      buffer += currChar;
  }// END for

  if (thouHit == true && groupCount != groupingSize)
  {
    return("NaN");
  }
  
  return(Number(buffer));
  
}// END toNum

