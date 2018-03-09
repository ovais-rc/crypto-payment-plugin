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

   function submitErrorHandler (errMessage){
        alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage){
        alertDialog(finishMessage);
        top.goBack();
	location.replace( '/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.bidruleList&cmd=BidRuleList&amp;listsize=15&amp;startindex=0&amp;orderby=RULENAME&amp;selected=SELECTED&amp;refnum=0');
   }

   function submitCancelHandler()
   {
        top.goBack();
        location.replace('/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=negotiations.bidruleList&cmd=BidRuleList&amp;listsize=15&amp;startindex=0&amp;orderby=RULENAME&amp;selected=SELECTED&amp;refnum=0');
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
	   if (isInputStringEmpty(get("rulename",""))) {
		 gotoPanel("General","rulenameMissing");
	       return false;
 	   }

	   if (!isValidUTF8length(get("ruledesc","") , 254)) {
		 gotoPanel("General","ruledescTooLong");
	       return false;
 	   }

	   var tempvalue = get("minvalue_ds","");
	   var defaultCurrency = get("currency" , "");
	   var lang = get("lang" , "");
	   if (tempvalue != null && tempvalue != "") {
		     if (!isValidCurrency(tempvalue,defaultCurrency,lang)){
		           gotoPanel("Rule","minvalError");
			     return false  
     			}
		     if (tempvalue.toString().charAt(0) == '-'){
		           gotoPanel("Rule","minvalNegative");
			     return false  ;
     		    }
		    put("minvalue",currencyToNumber(tempvalue, defaultCurrency, lang));
     	    } else
		    put("minvalue","");
	    
	    var tempquant = get("minquant_ds","");
     	    if (tempquant != null && !isInputStringEmpty(tempquant.toString())){
		  var t= formatInteger(tempquant,lang);
     		  if(t == null || t== "NaN"){
	           gotoPanel("Rule","minquantError");
		     return false  
	        }
		  if (tempquant.toString().charAt(0) == '-'){
	           gotoPanel("Rule","minquantNegative");
			return false  ;
     		  }
	    	  put("minquant",strToNumber(tempquant,lang))
	   }
	   else
		 put("minquant","");
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


