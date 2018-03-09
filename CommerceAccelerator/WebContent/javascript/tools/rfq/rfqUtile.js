/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2001, 2003
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

function ToHTML(inValue){
  var outString = new String(inValue);
  var regExp1= /&/g;
  var regExp2= /\"/g;
  var regExp3= /</g;
  var regExp4= />/g;	
  outString = outString.replace(regExp1,"&amp;");	
  outString = outString.replace(regExp2,"&quot;");	
  outString = outString.replace(regExp3,"&lt;");	
  outString = outString.replace(regExp4,"&gt;");	
  return outString;	
}

function getFormattedDate(year, month, day, inLocale) {
	var delimeter;
	var formattedDate;
	// if (year.length == 4)
	//	year = year.substring(2,4);
	
	if (inLocale == "pt_BR" || inLocale == "fr_FR" || inLocale == "it_IT" || inLocale == "es_ES") {
		delimeter = "/";
		formattedDate = day + delimeter + month + delimeter + year;
	} else if (inLocale == "de_DE") {
		delimeter = ".";
		formattedDate = day + delimeter + month + delimeter + year;
	} else if (inLocale == "zh_CN") {
		delimeter = "-";
		formattedDate = year + delimeter + month + delimeter + day;
	} else if (inLocale == "ja_JP" || inLocale == "Ja_JP" || inLocale == "ko_KR") {
		delimeter = "/";
		formattedDate = year + delimeter + month + delimeter + day;
	} else if (inLocale == "zh_TW") {
		delimeter = "/";
		formattedDate = year + delimeter + month + delimeter + day;
	} else if (inLocale == "en_US") {
		delimeter = "/";
		formattedDate = month + delimeter + day + delimeter + year;
	} else {
		delimeter = "/";
		formattedDate = day + delimeter + month + delimeter + year;
	}
	
	return formattedDate;
}
