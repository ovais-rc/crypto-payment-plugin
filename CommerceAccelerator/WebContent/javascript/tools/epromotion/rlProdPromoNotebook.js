//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
// accepts date in YYYY-MM-DD format and validates it if is within
// the year range of 1900 to 9999
// Returns true if date is a valid date
//         false otherwise
function validDate (inYear,inMonth,inDay) {
	if (inDay.length > 0 && inDay.charAt(0) == "0") {
		inDay = inDay.substring(1, inDay.length);
	}

	if (inMonth.length > 0 && inMonth.charAt(0) == "0") {
		inMonth = inMonth.substring(1, inMonth.length);
	}

	if (inYear.length == 4 && (inMonth.length == 1 || inMonth.length == 2) && (inDay.length == 1 || inDay.length == 2)) {
		var day = parseInt(inDay);
		var month = parseInt(inMonth);
		var year = parseInt(inYear);
		var dayString = day.toString();
		var monthString = month.toString();
		var yearString = year.toString();

		if ((year != NaN && yearString.length == 4 && year >= 1900 && year <= 9999 ) && (month != NaN && month >= 1 && month <= 12 && (monthString.length == inMonth.length)) && (day != NaN && (inDay.length == dayString.length))) {
			var daysMonth = getDaysInMonth(month, year);

			if (day >= 1 && day <= daysMonth) {
				return true;
			}
		}
		else {
			return false;
		}
	}
	return false;
}

// check to see if year is a leap year
function isLeapYear (Year) {
	if (((Year % 4) == 0) && ((Year % 100) != 0) || ((Year % 400) == 0)) {
		return (true);
	}
	else {
		return (false);
	}
}

// get number of days in month
function getDaysInMonth (month, year) {
	var days;

	if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
		days = 31;
	}
	else if (month == 4 || month == 6 || month == 9 || month == 11) {
		days = 30;
	}
	else if (month == 2) {
		if (isLeapYear(year)) {
			days = 29;
		}
		else {
			days = 28;
		}
	}
	return (days);
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

function isValidPercentage(pValue, languageId)
{
	if ( !isValidInteger(pValue, languageId))
	{
		return false;
	}
	else if( ! (eval(pValue) <= 100))
	{
		return false;
	}
	else if (! (eval(pValue) >= 0) )
	{
		return false;
	}
	return true;
}

function submitErrorHandler (errMessage, errStatus)
{	
	alertDialog(errMessage);
	if (errStatus == "rlPromotionDuplicateName")
	{
		gotoPanel("RLPromotionProperties");
	}
	else
	{
		top.goBack();
	}

}

function submitFinishHandler (finishMessage)
{	
	alertDialog(finishMessage);
	top.goBack();
}

function validateAllPanels () {	
	var o = get("rlpromotion");
	var languageId = get("languageId");
		if (o.rlDescription.length > 254)
		{
			put("invalidDiscountDesc", true);
			gotoPanel("RLPromotionProperties");
			return false;
		}
		if (o.rlDescriptionNL.length > 254)
		{
			put("invalidNLDiscountDesc", true);
			gotoPanel("RLPromotionProperties");
			return false;
		}
		if (o.rlLongDescriptionNL.length > 32700)
		{
			put("invalidNLDiscountLongDesc", true);
			gotoPanel("RLPromotionProperties");
			return false;
		}
		if (currencyToNumber(trim(o.rlTargetSales),o.rlCurrency,languageId).toString().length >14)
		{
			put("currencyTooLong", true);
			gotoPanel("RLPromotionProperties");
			return false;
		}
		if ( !isValidCurrency(trim(o.rlTargetSales),o.rlCurrency,languageId))
		{
			put("invalidCurrency", true);
			gotoPanel("RLPromotionProperties");
			return false;
		}
		hasDate = new Boolean();
		hasDate=o.rlDateRanged;
		if(hasDate.valueOf())
		{
			if ( !validDate(o.rlStartYear,o.rlStartMonth,o.rlStartDay))
			{
				put("invalidStartDate", true);
				gotoPanel("RLPromotionWhen");
				return false;
			}
			if ( !validDate(o.rlEndYear,o.rlEndMonth,o.rlEndDay))
			{
				put("invalidEndDate", true);
				gotoPanel("RLPromotionWhen");
				return false;
			}
		    	var startTime=o.rlStartHour+":00";
		    	var endTime=o.rlEndHour+":00";
			rc = validateStartEndDateTime(o.rlStartYear,o.rlStartMonth,o.rlStartDay,o.rlEndYear,o.rlEndMonth,o.rlEndDay, startTime, endTime);
			if ((rc==false)||(eval(rc)==-1))
			{
				put("notOrderedStartEndDate", true);
				gotoPanel("RLPromotionWhen");
				return false;
			}
		}
		if(!o.rlIsEveryDayFlag)
		{
			if (o.rlDaysInWeek.length == 0)
			{
				put("dayNotSelected", true);
				gotoPanel("RLPromotionWhen");
				return false;
			}
		}
		if(!o.validForAllCustomers)
		{
			if(o.assignedSegments == null || o.assignedSegments.length == 0)
			{
				put("noAssignedMbrGrps", true);
				gotoPanel("RLPromotionWho");
				return false;
			}
		}	
		
		if(o.rlPromotionType == "ItemLevelPercentDiscount" || o.rlPromotionType == "ProductLevelPercentDiscount"|| o.rlPromotionType == "CategoryLevelPercentDiscount")
		{

			if(o.rlValues.length == 1)
			{
				if(!isValidPercentage(o.rlValues[0], languageId))
				{
					put("percentageInvalid", true);
					gotoPanel("RLProdPromoPercent");
					return false;
				}
			}
			if(o.rlValues.length == 2)
			{
				if (strToNumber(trim(o.rlRanges[1]), languageId).toString().length > 14)
				{
					put("numberTooLong", true);
					gotoPanel("RLProdPromoPercent");
					return false;
				}
				else if ( !isValidInteger(trim(o.rlRanges[1]), languageId))
				{
					put("minQualNotNumber", true);
					gotoPanel("RLProdPromoPercent");
					return false;
				}
				else if (!(eval(strToNumber(trim(o.rlRanges[1]),languageId)) > 0))
				{
					put("minQualNotNumber", true);
					gotoPanel("RLProdPromoPercent");
					return false;
				}
				else if (eval(strToNumber(trim(o.rlRanges[1]),languageId)) == 0)
				{
					put("minQualNotNumber", true);
					gotoPanel("RLProdPromoPercent");
					return false;
				}
				if(!isValidPercentage(o.rlValues[1], languageId))
				{
					put("percentageInvalid", true);
					gotoPanel("RLProdPromoPercent");
					return false;
				}
			}
			if(o.rlValues.length == 0)
			{
				put("discountNotDefined", true);
				gotoPanel("RLProdPromoWizardRanges");
				return false;
			}
		}
		if((o.rlPromotionType == "ItemLevelPerItemValueDiscount") || (o.rlPromotionType == "ItemLevelValueDiscount") || (o.rlPromotionType == "ProductLevelPerItemValueDiscount") || (o.rlPromotionType == "ProductLevelValueDiscount")|| (o.rlPromotionType == "CategoryLevelPerItemValueDiscount") || (o.rlPromotionType == "CategoryLevelValueDiscount"))
		{
			if(o.rlValues.length == 1)
			{
				var numValue=currencyToNumber(trim(o.rlValues[0]), o.rlCurrency,languageId);
				if ( !isValidCurrency(trim(o.rlValues[0]), o.rlCurrency, languageId))
				{
					put("currencyInvalid", true);
					gotoPanel("RLProdPromoFixed");
					return false;
				}
				else if (numValue.toString().length >14)
				{
					put("currencyTooLong", true);
					gotoPanel("RLProdPromoFixed");
					return false;
				}
			}
			if(o.rlValues.length == 2)
			{
				var numValue=currencyToNumber(trim(o.rlValues[1]), o.rlCurrency,languageId);
				if ( !isValidCurrency(trim(o.rlValues[1]), o.rlCurrency, languageId))
				{
					put("currencyInvalid", true);
					gotoPanel("RLProdPromoFixed");
					return false;
				}
				else if (numValue.toString().length >14)
				{
					put("currencyTooLong", true);
					gotoPanel("RLProdPromoFixed");
					return false;
				}
				var numMin=strToNumber(trim(o.rlRanges[1]),languageId);
				if (numMin.toString().length > 14)
				{	
					put("numberTooLong", true);
					gotoPanel("RLProdPromoFixed");
					return false;
				}
				else if ( !isValidInteger(trim(o.rlRanges[1]), languageId))
				{
					put("minQualNotNumber", true);
					gotoPanel("RLProdPromoFixed");
					return false;
				}
				else if (eval(o.rlRanges[1]) <= 0)
				{
					put("minQualNotNumber", true);
					gotoPanel("RLProdPromoFixed");
					return false;
				}
			}
			if(o.rlValues.length == 0)
			{
				put("discountNotDefined", true);
				gotoPanel("RLProdPromoWizardRanges");
				return false;
			}
		}
		if(o.rlPromotionType == "ItemLevelSameItemPercentDiscount" || o.rlPromotionType == "ProductLevelSameItemPercentDiscount"|| o.rlPromotionType == "CategoryLevelSameItemPercentDiscount")
		{			
			if(strToNumber(trim(o.rlRequiredQty),languageId).toString().length > 14)
			{
				put("prodQtyTooLong", true);
				gotoPanel("RLProdPromoBXGY");
				return false;
			}
			else if ( !isValidInteger(trim(o.rlRequiredQty), languageId)) 
			{
				put("prodQtyNotNumber", true);
				gotoPanel("RLProdPromoBXGY");
				return false;
			}
			else if (!(eval(strToNumber(trim(o.rlRequiredQty),languageId)) >= 1))
			{
				put("prodQtyNotNumber", true);
				gotoPanel("RLProdPromoBXGY");
				return false;
			}
			if (!isValidPercentage(trim(o.rlValue),languageId))
			{
				put("percentNotValid", true);
				gotoPanel("RLProdPromoBXGY");
				return false;
			}
			if(!(o.rlMaxDiscountItemQty == '-1'))
			{
				if(strToNumber(trim(o.rlMaxDiscountItemQty),languageId).toString().length > 14)
				{
					put("maxProdQtyTooLong", true);
					gotoPanel("RLProdPromoBXGY");
					return false;
				}
				else if ( !isValidInteger(trim(o.rlMaxDiscountItemQty), languageId)) 
				{
					put("maxProdQtyNotNumber", true);
					gotoPanel("RLProdPromoBXGY");
					return false;
				}
				else if (!(eval(strToNumber(trim(o.rlMaxDiscountItemQty),languageId)) >= 1))
				{
					put("maxProdQtyNotNumber", true);
					gotoPanel("RLProdPromoBXGY");
					return false;
				}
			}
			
		}
		if(o.rlPromotionType == "ItemLevelBuyXGetYFree" || o.rlPromotionType == "ProductLevelBuyXGetYFree" || o.rlPromotionType == "CategoryLevelBuyXGetYFree")
		{		
			
				if(strToNumber(trim(o.rlMaxDiscountItemQty),languageId).toString().length > 14)
				{
					put("prodQtyTooLong", true);
					gotoPanel("RLProdPromoGWP");
					return false;
				}
				else if ( !isValidInteger(trim(o.rlMaxDiscountItemQty), languageId)) 
				{
					put("prodQtyNotNumber", true);
					gotoPanel("RLProdPromoGWP");
					return false;
				}
				else if (!(eval(strToNumber(trim(o.rlMaxDiscountItemQty),languageId)) >= 1))
				{
					put("prodQtyNotNumber", true);
					gotoPanel("RLProdPromoGWP");
					return false;
				}
				
			if(!(o.rlRequiredQty == '-1'))
			{
				if(strToNumber(trim(o.rlRequiredQty),languageId).toString().length > 14)
				{
					put("reqProdQtyTooLong", true);
					gotoPanel("RLProdPromoGWP");
					return false;
				}
				else if ( !isValidInteger(trim(o.rlRequiredQty), languageId)) 
				{
					put("reqProdQtyNotNumber", true);
					gotoPanel("RLProdPromoGWP");
					return false;
				}
				else if (!(eval(strToNumber(trim(o.rlRequiredQty),languageId)) >= 1))
				{
					put("reqProdQtyNotNumber", true);
					gotoPanel("RLProdPromoGWP");
					return false;
				}
			}
			if(trim(o.rlDiscountItemSku) == "" || trim(o.rlDiscountItemSku) == null)
			{
				put("noSKUEntered", true);
				gotoPanel("RLProdPromoGWP");
				return false;
			}	
	}
return true;
}

function submitCancelHandler()
{
	top.goBack();
}

function preSubmitHandler()
{
}

function getCurrency()
{
	//return get("rlCurrency");
	var rlpromotion = get("rlpromotion","");
	if(rlpromotion != null)
	{
		return rlpromotion.rlCurrency;
	}

}
