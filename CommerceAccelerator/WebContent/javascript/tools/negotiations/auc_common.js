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
var auctOwnerid = "ownerid";
var auctLang = "lang";
var auctLocale = "locale";
var auctStoreid = "StoreId";
var auctStyle = "austyle";
var auctId = "aucrfn";
var auctType  = "autype";

var auctRuleMacro = "aurulemacro";
var auctPrdMacro = "auprdmacro";
var auctRuleType = "auruletype";
var auctItem = "catEntryId";
var auctSKU = "sku";
var auctProdName = "prodname";
var auctProdDesc = "proddesc";

var auctQuantity= "quant";
var auctQuantity_ds= "quant_ds";
var auctLongDesc = "auldesc";
var auctShortDesc = "ausdesc";
var auctBdrule = "aubdrule";
var auctCur = "aucur";
var auctCur_ds = "aucur_ds";

var auctPricing = "pricing";
var auctDayDur = "audaydur";
var auctTimDur = "autimdur";
var auctHourDur = "auhourdur";
var auctMinDur = "aumindur";

var auctStYear_ds = "austyear_ds";
var auctStMonth_ds = "austmonth_ds";
var auctStDay_ds = "austday_ds";
var auctStTime_ds  = "austtim_ds";

var auctEndYear_ds = "auendyear_ds";
var auctEndMonth_ds = "auendmonth_ds";
var auctEndDay_ds = "auendday_ds";
var auctEndTime_ds = "auendtim_ds";

var auctStDate = "austdate";
var auctStTime  = "austtim";
var auctEndDate = "auenddat";
var auctEndTime = "auendtim";

var auctMinbid_ds = "minbid_ds";
var auctDeposit_ds = "audeposit_ds";
var auctCurPrice_ds = "aucurprice_ds";

var auctMinbid = "minbid";
var auctDeposit = "audeposit";
var auctCurPrice = "aucurprice";


var auctTimeFlag = "tmflag";
var auctStAMPM = "austAMPM";
var auctEndAMPM = "auendAMPM";

var auctEditable = "editable";
var auctOrChecked = "or_checked";
var auctAndChecked = "and_checked";

var auctPartNumber = "aupartnum";
var auctItemName = "auitemname";
var auctItemDesc = "auitemdesc";


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