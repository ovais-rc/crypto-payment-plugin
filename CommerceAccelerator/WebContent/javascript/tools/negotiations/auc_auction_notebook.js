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

function submitErrorHandler (errMessage) {
   	alertDialog(errMessage);
}

function submitFinishHandler (finishMessage) {
     alertDialog(finishMessage);
     top.goBack();
}

function submitCancelHandler()
{
     top.goBack();
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
 
    var temp;
    var temp1;
    var temp2;
    var err = "0";
    var theLocale   =  get("locale");  
    var theLang     =  get("lang");  
    var autype      =  get("autype");  
    var quant       =  get("quant_ds");
    var curprice    =  get("aucurprice_ds");
    var minbid      =  get("minbid_ds");
    var deposit     =  get("audeposit_ds");
    var curcode     =  get("aucur");
   
    var rulemacro   =  get("aurulemacro");
    var prdmacro    =  get("auprdmacro");
    var ausdesc     =  get("ausdesc");
    var auldesc     =  get("auldesc");

    var styear      =  get("austyear_ds");   
    var stmonth     =  get("austmonth_ds");   
    var stday       =  get("austday_ds");   
    var stdate      =  " ";   
    var sttim       =  get("austtim_ds");   

    var endyear     =  get("auendyear_ds");   
    var endmonth    =  get("auendmonth_ds");   
    var endday      =  get("auendday_ds");   
    var enddat      =  " "; 
    var endtim      =  get("auendtim_ds");   

    var durday      =  get("audaydur", " ");   
    var duration    =  get("autimdur", " ");   
    var durhour     =  get("auhourdur", " ");   
    var durmin      =  get("aumindur", " ");

    var stAMPM      =  get("austAMPM");   
    var endAMPM     =  get("auendAMPM");   

    var aRuletype   =  get("auruletype");
    var or_checked  =  get("or_checked");
    var and_checked =  get("and_checked");
    var tmflag      = get("tmflag");
    var editable    = get("editable");

    var today;
    var t_year;
    var t_month;
    var t_day; 
    var t_hour;
    var t_minute;
    var t_second;

   //Display panel field check
    if ( isInputStringEmpty(rulemacro.toString()) ){
    	err = "errRule"            //msgMandatoryField
        gotoPanel("Display", err);
        return false;
    }
    else {
       if (!isValidUTF8length(rulemacro.toString(), 254)) {
    	  err = "errRule1"            //msgInvalidSize
          gotoPanel("Display", err);
          return false;
       }
    }	

    if ( isInputStringEmpty(prdmacro.toString()) ) {
    	err = "errProd"            //msgMandatoryField
        gotoPanel("Display", err);
        return false;
    }
    else {
       if (!isValidUTF8length(prdmacro.toString(), 254)) {
    	  err = "errProd1"            //msgInvalidSize
          gotoPanel("Display", err);
          return false;
       }
    }	

    if (!isInputStringEmpty(ausdesc.toString())){
        if ( !isValidUTF8length(ausdesc.toString(), 254) ) {
    	  err = "errShortDesc"            //msgInvalidSize254
          gotoPanel("Display", err);
          return false;
        }
    }

    if (!isInputStringEmpty(auldesc.toString())){
       if ( !isValidUTF8length(auldesc.toString(), 2048) ) {
    	  err = "errLongDesc"            //msgInvalidSize2048
          gotoPanel("Display", err);
          return false;
       }    
    }


   //Item panel field check     
    if (isInputStringEmpty(quant.toString())) {
    	err = "errQuant1"            //msgMandatoryField
       gotoPanel("Item", err);     
       return false;
    }	
    else {
      temp = strToNumber(quant.toString(), theLang);
       if ( !isValidInteger(quant.toString(), theLang) ) {
  	 err = "errQuant4" 	    //msgInvalidInteger
         gotoPanel("Item", err);
  	 return false;
       }
       var p_quant = quant;
       if (p_quant.charAt(0) == '-'){
  	  err = "errQuant5" 	    //msgNegativeNumber
          gotoPanel("Item", err);
   	  return false;  
       }

       if ( temp < 1 ) {
    	err = "errQuant3"            //msgQuantityCheck
    	gotoPanel("Item", err);
  	return false;
       }

      temp = strToNumber(quant.toString(), theLang);
      put("quant", temp);   
    } 

   //Pricing panel field check     
   if ( autype == "D" ){

        if (isInputStringEmpty(curprice.toString())) {
           err = "errCurprice1";
           gotoPanel("Pricing", err);   //msgMandatoryField
           return false;
        }
        if ( isValidCurrency(curprice.toString(), curcode, theLang) == false ) {
           err = "errCurprice2";
           gotoPanel("Pricing", err);   //msgInvalidPrice
  	   return false;
	}

        temp = currencyToNumber(curprice.toString(), curcode, theLang)
        if ( temp != null) {
            if ( temp < 0 ) {
               err = "errCurprice3";
               gotoPanel("Pricing", err);   //msgNegativeNumber
  	        return false;
            }
        }

         put("aucurprice", temp);   

    } 
    else {
        
	if ( !isInputStringEmpty(minbid.toString()) ) {
           if ( !isValidNumber(minbid.toString(), theLang) ) {
             err = "errMinbid3";
             gotoPanel("Pricing", err);   //msgInvalidNumber
  	     return false;
  	   }  
           		
           if ( !isValidCurrency(minbid.toString(), curcode, theLang) ) {
             err = "errMinbid1";
             gotoPanel("Pricing", err);   //msgInvalidPrice
  	     return false;
  	   }  
		
           temp = currencyToNumber(minbid.toString(), curcode, theLang);
           if ( temp != null) {
              if ( temp < 0 ) {
                err = "errMinbid2";
                gotoPanel("Pricing", err);   //msgNegativeNumber
  	        return false;
              }
           }

            put("minbid", temp);   

	}	
        
	
	if ( !isInputStringEmpty(deposit.toString()) ) {
           if ( !isValidNumber(deposit.toString(), theLang) ) {
             err = "errDeposit3";
             gotoPanel("Pricing", err);   //msgInvalidNumber
  	     return false;
  	   }  

          if ( !isValidCurrency( deposit.toString(), curcode, theLang) ) {
             err = "errDeposit1";
             gotoPanel("Pricing", err);   //msgInvalidPrice
  	     return false;
  	   }  
 
           temp = currencyToNumber( deposit.toString(), curcode, theLang)
           if ( temp != null) {
              if ( temp < 0 ) {
               err = "errDeposit2";
               gotoPanel("Pricing", err);   //msgNegativeNumber
  	       return false;
              }
           }
           
            put("audeposit", temp);   
        }

    }

  //Duration panel field check
  //Validate Start date
    if ( !isInputStringEmpty(styear.toString()) || !isInputStringEmpty(stmonth.toString()) || !isInputStringEmpty(stday.toString()) ) {
      if ( !validDate(styear, stmonth, stday) ) {
         err = "errStDate"; //msgInvalidStDate
         gotoPanel("Duration", err);
         return false;
      }   
  }    


  //Validate End date
    if ( !isInputStringEmpty(endyear.toString()) || !isInputStringEmpty(endmonth.toString()) || !isInputStringEmpty(endday.toString()) ) {
      if ( !validDate(endyear, endmonth, endday) ) {
         err = "errEndDate"; //msgInvalidEndDate
         gotoPanel("Duration", err);
         return false;
      }   
  }    

  //format dates for additional validation usage 
   if (!isInputStringEmpty(styear.toString()) && !isInputStringEmpty(stmonth.toString()) && !isInputStringEmpty(stday.toString()) )
     stdate = getDateFormat( styear, stmonth, stday, theLocale);
   if ( !isInputStringEmpty(endyear.toString()) && !isInputStringEmpty(endmonth.toString()) && !isInputStringEmpty(endday.toString()) ) 
     enddat = getDateFormat( endyear, endmonth, endday, theLocale);

 
  //Validate Start time
  //Validate Start time either in 12 or 24 hour format
  if ( tmflag == "1" ) {
     temp = sttim + " " + stAMPM; 
     this.inTime = temp;
     if (!isInputStringEmpty(sttim.toString())){
	if ( !validateTime(inTime) || validateTime(inTime)  == "false") {
            err = "errStTime"; //msgInvalidTime
            gotoPanel("Duration", err);
	    return false;
	}    
     }
  }   
  else {
     if (!isInputStringEmpty(sttim.toString())){
  	if ( !validTime(sttim) ) {
            err = "errStTime"; //msgInvalidTime
            gotoPanel("Duration", err);
    	    return false;
    	}    
     }
  	
  }	

  //Validate End time
  //Validate Start time either in 12 or 24 hour format
  if ( tmflag == "1" ) {
     temp = endtim + " " + endAMPM; 
     this.inTime = temp;
     if (!isInputStringEmpty(endtim.toString())){
	if ( !validateTime(inTime) || validateTime(inTime)  == "false") {
            err = "errEndTime"; //msgInvalidTime
            gotoPanel("Duration", err);
	    return false;
	}    
     }
  }
  else {
     if (!isInputStringEmpty(endtim.toString())){
  	if ( !validTime(endtim) ) {
            err = "errEndTime"; //msgInvalidTime
            gotoPanel("Duration", err);
    	    return false;
    	}    
     }
  	  
  }

    today = new Date();
    t_year = today.getFullYear();
    t_month = today.getMonth() + 1;
    t_day  = today.getDate();
    t_hour = today.getHours();
    t_minute = today.getMinutes();
    t_second  = today.getSeconds();
    var now = getDateFormat( t_year, t_month, t_day, theLocale);

  //If start date is not blank, then it must be  >= current date
    if( !isInputStringEmpty(stdate.toString()) )
    {
      if ( editable == "true" ) {  
        this.inDate = stdate;
        if ( isDateOrdered(now, inDate, theLocale) == "0" ) {
          err = "errStEndCompare"; //msgStartEndCompare
          gotoPanel("Duration", err);
	  return false;  
        }
      } 
     }

  //If end date is not blank, then it must be  >= current date
    if( !isInputStringEmpty(enddat.toString()) )
    {
     
       this.inDate = enddat;
       if ( isDateOrdered(now, inDate, theLocale) == "0" ) {
          err = "errCurEndCompare"; //msgCurrentEndCompare
          gotoPanel("Duration", err);
	  return false;  
       }
     }

  //Check that enddate is >= start date
    if (!isInputStringEmpty(stdate.toString()) && !isInputStringEmpty(enddat.toString()) ) {
       this.inDate = stdate;
       temp = enddat; 
       if (isDateOrdered(inDate, temp, theLocale) == "0") {
           err = "errStWrongDate"; //msgWrongStartDate
           gotoPanel("Duration", err);
           return false ; 
       }
         
    }
  
  //Check that Start Date and time must be entered together as a pair 
  if ((!isInputStringEmpty(stdate.toString()) && isInputStringEmpty(sttim.toString()))
   || (isInputStringEmpty(stdate.toString()) && !isInputStringEmpty(sttim.toString())) ){

        if ( isInputStringEmpty(stdate.toString()) ) {
           err = "errStDateTime1"; //msgDateAndTimeTogether, prompt on start date
           gotoPanel("Duration", err);
	   return false;

	}
	if ( isInputStringEmpty(sttim.toString()) ) {    
           err = "errStDateTime2"; //msgDateAndTimeTogether, prompt on start time
           gotoPanel("Duration", err);
	   return false;
	}

  }

  //Check that End Date and time must be entered together as a pair 
  if ((!isInputStringEmpty(enddat.toString()) && isInputStringEmpty(endtim.toString())) 
   || (isInputStringEmpty(enddat.toString()) && !isInputStringEmpty(endtim.toString()))) {

        if ( isInputStringEmpty(enddat.toString()) ) {
           err = "errEndDateTime1"; //msgDateAndTimeTogether, prompt on end date
           gotoPanel("Duration", err);
	   return false;
	}   
	if ( isInputStringEmpty(endtim.toString()) ) {    
           err = "errEndDateTime2"; //msgDateAndTimeTogether, prompt on end time
           gotoPanel("Duration", err);
	   return false;
;
	}

  }



  //Check that if start date and end date are not blanks, and start date equals end date,
  //           then end time is > start time
if (!isInputStringEmpty(stdate.toString()) && !isInputStringEmpty(enddat.toString()) ) {
  
  if (   styear == endyear  && stmonth == endmonth && stday == endday ) {

     if ( tmflag  == "1" ) {
        temp = stAMPM; 
        temp1 = sttim + " " + temp; 
        temp = endAMPM; 
        temp2 = endtim + " " + temp; 
        if ( isTimeOrdered(temp1, temp2) == "false") {
          err = "errStWrongDate"; //msgWrongStartDate
          gotoPanel("Duration", err);
          return false ; 
        }
     }          
     else {
      //check 24 hour clock
       if ( is24HourTimeOrdered(sttim, endtim) == "false") {
          err = "errStWrongDate"; //msgWrongStartDate
          gotoPanel("Duration", err);
          return false ; 
       }
       else if ( is24HourTimeOrdered(sttim, endtim) == "false1") {
             err = "errEndWrongDate"; //msgWrongEndDate
             gotoPanel("Duration", err);
             return false ; 
            }
     	
     }	  
  }
}
  
//Check that if start date equals current date, then start time is > current time
if ( editable == "true" ) {  
  today = new Date();
  t_year = today.getFullYear();
  t_month = today.getMonth() + 1;
  t_day  = today.getDate();
  t_hour = today.getHours();
  t_minute = today.getMinutes();
  t_second  = today.getSeconds();
  var now = getDateFormat( t_year, t_month, t_day, theLocale);

  if ( tmflag  == "1" ) {
     temp = stAMPM; 
     temp2 = sttim + " " + temp; 
     if ( styear == t_year && stmonth == t_month  && stday == t_day  ) {

       if ( parseInt(t_hour) > parseInt(getHour(temp2)) ) {
          err = "errStTimeEndCompare"; //msgStartEndCompare
          gotoPanel("Duration", err);
          return false ; 
       }
       else
         if (  parseInt(t_hour) == parseInt(getHour(temp2)) 
            && parseInt(t_minute) > parseInt(getMinutes(temp2)) ) {
              err = "errStTimeEndCompare"; //msgStartEndCompare
              gotoPanel("Duration", err);
              return false ; 
         }
         //else
         //   if (  parseInt(t_hour) == parseInt(getHour(temp2)) 
         //      && parseInt(t_minute) == parseInt(getMinutes(temp2))
         //      && parseInt(t_second) > parseInt(getSeconds(temp2)) ) {
         //     err = "errStTimeEndCompare"; //msgStartEndCompare
         //     gotoPanel("Duration", err);
         //     return false ; 
         //   } 
     } 
  }  // end timflag	      
  else {
   //check 24 hour time compare if start date equals current date, then start time is > current time  
    if (    styear == t_year && stmonth == t_month  && stday == t_day ) {
        temp1 = t_hour + ":" + t_minute; 
        if ( is24HourTimeOrdered(temp1, sttim) == "false") {
           err = "errStTimeEndCompare"; //msgStartEndCompare
           gotoPanel("Duration", err);
           return false ; 
         }
    } 
    	
  }
} // end current time  check when editable is true  


  //Check that if end date exists and equals current date, then end time is > current time
if ( !isInputStringEmpty(enddat.toString()) ) {
  if ( tmflag  == "1" ) {
     //same logic check as start time if we are to implement am/pm indicator
  }  	      
  else {
   //check 24 hour time compare if end date equals current date, then end time is > end time  
    if (    endyear == t_year && endmonth == t_month  && endday == t_day ) {
        temp1 = t_hour + ":" + t_minute; 
        if ( is24HourTimeOrdered(temp1, endtim) == "false") {
           err = "errCurEndCompare2";  //msgCurrentEndCompare
           gotoPanel("Duration", err);
           return false ; 
         }
    } 
    	
  }
	
}

  if ( autype  != "D") {
   
    //Validate Duration Day
    if (!isInputStringEmpty(durday.toString())){
        if ( !isValidInteger(durday.toString(), theLang) ) {
           err = "errDurDay"; //msgInvalidDurationDay
           gotoPanel("Duration", err);
  	   return false;
        }
      temp = strToNumber(durday.toString(), theLang);
      put("audaydur", temp);
     }  

    //Validate duration hours. Allows 24 hour format  
    if (!isInputStringEmpty(durhour.toString())){
        if ( !isValidInteger(durhour.toString(), theLang) ) {
            err = "errDurHour"; //msgInvalidHour
            gotoPanel("Duration", err);
  	   return false;
        }
        if ( parseInt(durhour) < 0 || parseInt(durhour) > 24) { 
            err = "errDurHour"; //msgInvalidHour
            gotoPanel("Duration", err);
	    return false;
	}    

     }  
      
    //Validate duration minutes.   
    if (!isInputStringEmpty(durmin.toString())){
        if ( !isValidInteger(durmin.toString(), theLang) ) {
            err = "errDurMinute"; //msgInvalidMinute
            gotoPanel("Duration", err);
  	   return false;
        }
        if ( parseInt(durmin) < 0 || parseInt(durmin) > 60) { 
            err = "errDurMinute"; //msgInvalidMinute
            gotoPanel("Duration", err);
	    return false;
	}    

     }  

      
    // Check that at least fixed time  or duration is specified
    if (    isInputStringEmpty(endyear.toString()) 
         && isInputStringEmpty(endmonth.toString())
         && isInputStringEmpty(endday.toString())
         && isInputStringEmpty(durday.toString())
         && isInputStringEmpty(durhour.toString())	
         && isInputStringEmpty(durmin.toString()) ) {

        err = "errEndMissing"; //msgMissingAuctionEndCriterion
        gotoPanel("Duration", err);
        return false;
    }   

    // Check that  fixed time and duration is specified when user selects AND option
    if ( autype != "D" &&
	 (   isInputStringEmpty(enddat.toString())
	  ||  (isInputStringEmpty(durday.toString()) && isInputStringEmpty(durhour.toString()) && isInputStringEmpty(durmin.toString()))) 
	  &&  (and_checked == "true")){

        err = "errBothEndMissing"; //msgMissingBothAuctionEndCriterion
        gotoPanel("Duration", err);
        return false;
    }  

  } // end auctype != "D"


  //Check that End Date and time is entered for Dutch
  if (  autype == "D" && isInputStringEmpty(enddat.toString())){
        err = "errEndDutchDate";  //msgDutchEndDate
        gotoPanel("Duration", err);
	return false;
  }

  // Assing auruletype
  if ( autype == "D" )
      aRuletype = 1;
  else {
       if ( !isInputStringEmpty(enddat.toString()) && !isInputStringEmpty(endtim.toString()) 
        &&  ( !isInputStringEmpty(durday.toString()) || !isInputStringEmpty(durhour.toString()) || !isInputStringEmpty(durmin.toString())) 
        &&  (and_checked == "true") ) 
       {
          aRuletype = 4;
       }
       if  ( !isInputStringEmpty(enddat.toString()) && !isInputStringEmpty(endtim.toString()) 
         && ( !isInputStringEmpty(durday.toString()) || !isInputStringEmpty(durhour.toString()) || !isInputStringEmpty(durmin.toString())) 
         && (or_checked == "true") ) 
       {
          aRuletype = 3;
       }
       if ( isInputStringEmpty(enddat.toString()) && isInputStringEmpty(endtim.toString())  &&
            ( !isInputStringEmpty(durday.toString()) || !isInputStringEmpty(durhour.toString()) || !isInputStringEmpty(durmin.toString())) ) 
       {
          aRuletype = 2;
       }

       if ( !isInputStringEmpty(enddat.toString()) && !isInputStringEmpty(endtim.toString())  &&
            isInputStringEmpty(durday.toString()) && isInputStringEmpty(durhour.toString()) && isInputStringEmpty(durmin.toString()) ) 
       {
          aRuletype = 1;
       }
    
    }  
     put("auruletype", aRuletype );  

}
