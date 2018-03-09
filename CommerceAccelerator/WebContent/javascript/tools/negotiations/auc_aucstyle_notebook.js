//********************************************************************

//*-------------------------------------------------------------------

//* Licensed Materials - Property of IBM

//*

//* 5697-D24

//*

//* (c) Copyright IBM Corp. 2000, 2002

//*

//* US Government Users Restricted Rights - Use, duplication or

//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

//*

//*-------------------------------------------------------------------
   function submitErrorHandler (errMessage)
   {
     alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage){
     alertDialog(finishMessage);
     top.goBack();
     location.replace('/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionstyleList&amp;cmd=AuctionStyleList&amp;listsize=15&amp;startindex=0&amp;orderby=ASNAME&amp;selected=SELECTED&amp;refnum=0');
   }

   function submitCancelHandler()
   {
     top.goBack();
     location.replace('/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.auctionstyleList&amp;cmd=AuctionStyleList&amp;listsize=15&amp;startindex=0&amp;orderby=ASNAME&amp;selected=SELECTED&amp;refnum=0');
   }

 /*
   -- validateAllPanels(name)
   -- Read data stored in model and validate it
   -- If a frame contains invalid data, call gotoPanel to switch to that panel and display an error msg
   -- Return true if all data is valid
   -- false otherwise
   -- */
  function validateAllPanels()
  {
      //alert("checking ProfileName");
	var tempvalue = get("ProfileName");
	if (isInputStringEmpty(tempvalue)) {
		gotoPanel("Type","profileNameMissing");
		return false;
	}

	if(!isValidUTF8length(tempvalue.toString(),38)){
		gotoPanel("Type","profileNameInvalidSize");
		return false;
	}		

	var lang = get("lang","-1");
	var currency = get("defaultcurrency","USD");

      //alert("checking Quantity");
	var tempquant = get("quant_ds","");
	if (tempquant != null && !isInputStringEmpty(tempquant.toString())){
		
		if(!isValidInteger(tempquant,lang)){
			gotoPanel("Pricing","quantityError");
			return false;  
		}
		if (tempquant.toString().charAt(0) == '-'){
			gotoPanel("Pricing","quantityNegative");
			return false;
		}
		put("quant",strToNumber(tempquant,lang));
	} else
		put("quant","");
	
      //alert("checking Deposit");
	tempvalue = get("audeposit_ds","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())){
		if (!isValidCurrency(tempvalue,currency,lang)){
			gotoPanel("Pricing","depositError");
			return false;  
		}
		if (tempvalue.toString().charAt(0) == '-'){
			gotoPanel("Pricing","depositNegative");
			return false;
		}
		put("audeposit",currencyToNumber(tempvalue,currency,lang));
	}else
		put("audeposit","");

      //alert("checking MinBid");
	tempvalue = get("minbid_ds","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())){
		if (!isValidCurrency(tempvalue,currency,lang)){
			gotoPanel("Pricing","minbidError");
			return false  
		}
		if (tempvalue.toString().charAt(0) == '-'){
			gotoPanel("Pricing","minbidNegative");
			return false
		}
		put("minbid",currencyToNumber(tempvalue,currency,lang));
	}else
		put("minbid","");

      //alert("checking OfferedPrice");
	tempvalue = get("aucurprice_ds","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())){
		if (!isValidCurrency(tempvalue,currency,lang)){
			gotoPanel("Pricing","curpriceError");
			return false  
		}
		if (tempvalue.toString().charAt(0) == '-'){
			gotoPanel("Pricing","curpriceNegative");
			return false
		}
		put("aucurprice",currencyToNumber(tempvalue,currency,lang));
	}else
		put("aucurprice","");	

	//alert("Checking rulemacro");
	tempvalue = get("aurulemacro","");
	if(!isValidUTF8length(tempvalue.toString(),254)){
		gotoPanel("Display","rulemacroInvalidSize");
		return false;
	}		

	tempvalue = get("auprdmacro","");
	if(!isValidUTF8length(tempvalue.toString(),254)){
		gotoPanel("Display","producttemplateInvalidSize");
		return false;
	}

      //alert("checking StartDay");
	tempvalue = get("austday_ds","");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())){
		if (!isValidInteger(tempvalue,lang)){
			gotoPanel("Duration","startdayError");
			return false  
		}
		var p_stday = strToNumber(tempvalue.toString(), lang)
		if (parseInt(p_stday) < 0) {
			gotoPanel("Duration","startdayNegative");
			return false  
		}
		put("austday",p_stday);
	}else
		put("austday","");

      //alert("checking StartTime");
	tempvalue = get("austtim_ds");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())) {
		var temp = validTime(tempvalue);
		if (!temp || temp == "false"){
	    		gotoPanel("Duration","starttimeError");
    			return false  
 		}
		put("austtim",tempvalue.toString() + ":00");
	}else
		put("austtim","");

      //alert("checking Endday");
	tempvalue = get("auendday_ds");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())) {	
		if (!isValidInteger(tempvalue,lang)){
			gotoPanel("Duration","enddayError");
			return false  
		}
		var p_endday = strToNumber(tempvalue.toString(), lang)
		if (parseInt(p_endday) < 0) {
			gotoPanel("Duration","enddayNegative");
			return false  
		}
		put("auendday",p_endday);
	}else
		put("auendday","");

      //alert("checking EndTime");
	tempvalue = get("auendtim_ds");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())) {
		var temp = validTime(tempvalue);
		if (!temp || temp == "false"){
	    		gotoPanel("Duration","endtimeError");
    			return false  
 		}
		put("auendtim",tempvalue.toString() + ":00");
	}else
		put("auendtim","");

      //alert("checking DayDur");
	tempvalue = get("audaydur_ds");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())) {	
		if (!isValidInteger(tempvalue,lang)){
			gotoPanel("Duration","daydurError");
			return false  
		}
		var p_daydur = strToNumber(tempvalue.toString(), lang)
		if (parseInt(p_daydur) < 0) {
			gotoPanel("Duration","daydurNegative");
			return false  
		}
		put("audaydur",p_daydur);
	}else
		put("audaydur","");

      //alert("checking HourDur");
	tempvalue = get("auhourdur_ds");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())) {	
		if (!isValidInteger(tempvalue,lang)){
			gotoPanel("Duration","hourdurError");
			return false  
		}
		var p_hourdur = strToNumber(tempvalue.toString(), lang)
		if (parseInt(p_hourdur) > 23) {
			gotoPanel("Duration","hourdurError");
			return false  
		}
		put("auhourdur",p_hourdur);
	}else
		put("auhourdur","00");

      //alert("checking MinDur");
	tempvalue = get("aumindur_ds");
	if (tempvalue != null && !isInputStringEmpty(tempvalue.toString())) {	
		if (!isValidInteger(tempvalue,lang)){
			gotoPanel("Duration","minutedurError");
			return false  
		}
		var p_mindur = strToNumber(tempvalue.toString(), lang)
		if (parseInt(p_mindur) > 59) {
			gotoPanel("Duration","minutedurError");
			return false  
		}
		put("aumindur",p_mindur);
	}else
		put("aumindur","00");


	if (daytimeCompare()) {
		var hourdur = get("auhourdur","00");
		var mindur =  get("aumindur","00");

		var timdur =  hourdur.toString() + ":" +  mindur.toString()  + ":00";
		if (timdur != "00:00:00")
			put("autimdur",timdur);
		else 
			put("autimdur","");
		return true;
	}
	else 
		return false;
  }

function daytimeCompare()
{
	var startday   = get("austday","");
	var endday     = get("auendday","");
	var starttime  = get("austtim","").toString();
	var endtime    = get("auendtim","").toString();

	// Only-one-day/No-day is specified. Return true, no comparisons are possible
	if ( isInputStringEmpty(startday.toString()) || isInputStringEmpty(endday.toString()) ) 
		return true;

	// Both days specified. Check for startday <= endday
	// If endday > startday, return true. No need for time comparisons.
	if (!isInputStringEmpty(startday.toString()) && !isInputStringEmpty(endday.toString()) )
	{
		if (strToNumber(startday.toString(),null)  > strToNumber(endday.toString(),null) ) 
		{
    			gotoPanel("Duration","daycompareError");
	    		return false
		}
		if (strToNumber(startday.toString(),null) != strToNumber(endday.toString(),null) )
			return true;
   	}

	// Both times are specified and days are equal or not specified.
	if (!isInputStringEmpty(starttime) && !isInputStringEmpty(endtime))
	{
		var hh1 = starttime.substring(0,starttime.indexOf(":"));
		var mm1 = starttime.substring(starttime.indexOf(":") + 1);
		var hh2 = endtime.substring(0,endtime.indexOf(":"));
		var mm2 = endtime.substring(endtime.indexOf(":") + 1);
	
		if (parseInt(hh2) > parseInt(hh1)) 
			return true;
		if (parseInt(hh2) < parseInt(hh1)) 
		{
		    	gotoPanel("Duration","timecompareError");
			return false;
		}
	
		if (parseInt(mm2) > parseInt(mm1)) 
			return true;
		if (parseInt(mm2) < parseInt(mm1)) 
		{
		    	gotoPanel("Duration","timecompareError");
			return false;
		}		

		// both times are equal. Disallow it, as both days are equal too.
		gotoPanel("Duration","timestampcompareError");
		return false;
   	}
   
	return true;
}
