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

// Names(keys) in model
var respName = "respname";
var respMessage="respmessage";





//********** I don't know if we need these following controlling fields anymore for NLS???? *************
var dayOrder   = 3;	     // You can set the date format by specifying the order of year, month, and date	
var monthOrder = 2;	     // by changing the number. 
var yearOrder  = 1;
var dateDelimiter = "-";
var timeDelimiter = ":";
var yearRange = 50;
var AMPMIndicator = "No";   // "No" would set the time fields to the 24 hour format.

var decimalDelimiter  = ".";				// can be "." or "," depending on the country
var thousandDelimiter = ",";				// can be "," or "." depending on the country
var displayThousandDelimiter = true;	 // set it to true if the thousand delimiter is to be shown when displaying search result in the form

/* Currency parameters */

var decimalPlacesInPrice = 2;	  // Set to zero for Japan, Italy, &c. . .

//*********************************************************************************************************

function requiredFieldsCheck()
{
    alertDialog("Inside the requiredFieldsCheck()");
  //If finish button has been clicked.  Check in model that all required fields are non-blank.
        
}


//This function determines whether the incoming string
//is within its maximum allowable length or not.
//Returns 1 when the string length is greater than maxlen
//Returns 0 when the string length is less than or equal to maxlen.

function isStringTooLong(str,maxlen)
{
   if  (str==null || str=="")
		return 0;
   
   var len = str.toString().length;
   if (len > maxlen)
	return 1;
   else
      return 0;
}