//-----------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (C) Copyright IBM Corp. 2000, 2009 All Rights Reserved.
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with
// IBM Corp.
//-----------------------------------------------------------------


   var panelMsgs = new Object(); 

 function getPanelMsgs(key, defaultValue)
  {
    if (panelMsgs[key] == null) return defaultValue;
    return panelMsgs[key];
  }

 
  function removePanelMsgs(key)
  {
    panelMsgs[key] = null;

  }

 
  function putPanelMsgs(key, value)
  {
    panelMsgs[key] = value;
  }


  function submitErrorHandler (errMessage) {
   	alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage)
   {
   	alertDialog(finishMessage);
   	top.put("SKUUpdateDetailCatentryId", NAVIGATION.requestProperties["SKU_CatentryId"]);
	top.goBack();
   } 
  
    function submitCancelHandler() {
      top.goBack();
    }
 /*
   -- validateAllPanels(name)
   -- Read data stored in model and validate it
   -- If a frame contains invalid data, call gotoPanel to switch to that panel and display an error msg
   -- Return true if all data is valid
   -- false otherwise
   -- */
  function validateAllPanels() {   
    if (validDetails() && validDescription() && validImage() && validAttribute() && validAdvanced() && validVendor() && validUnitOfMeasure())
        return true;
    else
        return false;
    
        
  }


 
  function validDetails()
  {
  	
     var details = get("details");

     if (details != null )
     {
     	var sku = details.sku;
     	var name = details.name;
     	var objStartYear = details.startYear;
    	var objStartMonth = details.startMonth;
   		var objStartDay = details.startDay;
    	var objEndYear = details.endYear;
    	var objEndMonth = details.endMonth;
    	var objEndDay = details.endDay;
     	var objAvailabilityYear = details.availabilityYear;
    	var objAvailabilityMonth = details.availabilityMonth;
    	var objAvailabilityDay = details.availabilityDay;
     	var objLastOrderYear = details.lastOrderYear;
    	var objLastOrderMonth = details.lastOrderMonth;
    	var objLastOrderDay = details.lastOrderDay;
     	var objEndOfServiceYear = details.endOfServiceYear;
    	var objEndOfServiceMonth = details.endOfServiceMonth;
    	var objEndOfServiceDay = details.endOfServiceDay;
     	var objDiscontinueYear = details.discontinueYear;
    	var objDiscontinueMonth = details.discontinueMonth;
    	var objDiscontinueDay = details.discontinueDay;

	if (!details.sku) {	    
	    put("itemSkuRequiredMessage", true);
     	    gotoPanel("General");
            return false;
     	}

	if (!details.name) {
	    put("itemNameRequiredMessage", true);	    
     	    gotoPanel("General");
            return false;
     	}

    	if (! isValidItemName(name)){
	    put("itemNameNotValidMessage", true);	    
     	    gotoPanel("General");
            return false;
    	}

	if ( !isValidUTF8length(sku, 64)  )
      	{
	    put("fieldSizeExceeded_sku", true);
     	    gotoPanel("General");
	    return false;
      	}

	if ( !isValidUTF8length(name, 128)  )
      	{
	    put("fieldSizeExceeded_name", true);
     	    gotoPanel("General");
	    return false;
      	}
      
    if ( !(objStartYear == "") || !(objStartMonth == "") || !(objStartDay == "") ) {
    	if ( !validDate(objStartYear,objStartMonth,objStartDay)  ){
		put("notValidStartDate",true);
		gotoPanel("General");
		return false;
    	}
    }

	if ( !(objEndYear == "") || !(objEndMonth == "") || !(objEndDay == "") ) {
    	if ( !validDate(objEndYear,objEndMonth,objEndDay)  ){
		put("notValidEndDate",true);
		gotoPanel("General");     	 
   		return false;
   		 }
    }
    
    if ( !(objStartYear == "") && !(objStartMonth == "") && !(objStartDay == "") && !(objEndYear == "") && !(objEndMonth == "") && !(objEndDay == "") ) {
    	if ( !validateStartEndDateTime(objStartYear,objStartMonth,objStartDay,objEndYear,objEndMonth,objEndDay,null,null) || (validateStartEndDateTime(objStartYear,objStartMonth,objStartDay,objEndYear,objEndMonth,objEndDay,null,null) == -1) ){
		put("notValidStartEndDate",true);
		gotoPanel("General");
		return false;
    	}
    }

    if ( !(objAvailabilityYear == "") || !(objAvailabilityMonth == "") || !(objAvailabilityDay == "") ) {
    	if ( !validDate(objAvailabilityYear,objAvailabilityMonth,objAvailabilityDay)  ){
		put("notValidAvailabilityDate",true);
		gotoPanel("General");
		return false;
    	}
    }

    if ( !(objLastOrderYear == "") || !(objLastOrderMonth == "") || !(objLastOrderDay == "") ) {
    	if ( !validDate(objLastOrderYear,objLastOrderMonth,objLastOrderDay)  ){
		put("notValidLastOrderDate",true);
		gotoPanel("General");
		return false;
    	}
    }

    if ( !(objEndOfServiceYear == "") || !(objEndOfServiceMonth == "") || !(objEndOfServiceDay == "") ) {
    	if ( !validDate(objEndOfServiceYear,objEndOfServiceMonth,objEndOfServiceDay)  ){
		put("notValidEndOfServiceDate",true);
		gotoPanel("General");
		return false;
    	}
    }

    if ( !(objDiscontinueYear == "") || !(objDiscontinueMonth == "") || !(objDiscontinueDay == "") ) {
    	if ( !validDate(objDiscontinueYear,objDiscontinueMonth,objDiscontinueDay)  ){
		put("notValidDiscontinueDate",true);
		gotoPanel("General");
		return false;
    	}
    }
    }
    return true;
  }


function isValidItemName(myString) {
    var invalidChars = ""; // invalid chars
    invalidChars += "\t"; // escape sequences
    
    // if the string is empty it is not a valid name
    if (isEmpty(myString)) return false;
 
    // look for presence of invalid characters.  if one is
    // found return false.  otherwise return true
    for (var i=0; i<myString.length; i++) {
      if (invalidChars.indexOf(myString.substring(i, i+1)) >= 0) {
        return false;
      }
    }    
        
    return true;
}


 function validDescription() {
      		
      var itemdescription = get("description");
    
      if (itemdescription != null) {
         
          var shortDesc = itemdescription.shortDesc;
          var long1 = itemdescription.longDesc;
          var long2 = itemdescription.auxDesc1;
          var long3 = itemdescription.auxDesc2;

      	  if ( !isValidUTF8length(shortDesc, 254)  )
      	  {
		put("fieldSizeExceeded_shortDesc", true);
     	  	gotoPanel("Description");
   	  	return false;
      	  }

// commented out due to defect 67374
/*
      	  if ( !isValidUTF8length(long1, 32700) )
      	  {	
		put("fieldSizeExceeded_longDesc", true);
     	  	gotoPanel("Description");
   	  	return false;
      	  }
*/
      	  if ( !isValidUTF8length(long2, 4000) )
      	  {
		put("fieldSizeExceeded_auxDesc1", true);
     	  	gotoPanel("Description");
   	  	return false;
      	  }

      	  if ( !isValidUTF8length(long3, 4000) )
      	  {
		put("fieldSizeExceeded_auxDesc2", true);
     	  	gotoPanel("Description");
   	  	return false;
      	  }
      }
      return true;
  }
           
  function validImage() {
      		
      var itemimage = get("image");
    
      if (itemimage != null) {
         
          var full = itemimage.fullimage;
          var thumb = itemimage.thumbnail;
          
          if ( !isValidUTF8length(full, 254) )
      	  {
		put("fieldSizeExceeded_fullimage", true);
     	  	gotoPanel("Image");
   	  	return false;
      	  }

          if ( !isValidUTF8length(thumb, 254) )
      	  {
		put("fieldSizeExceeded_thumbnail", true);
     	  	gotoPanel("Image");
   	  	return false;
      	  }
          
      	  if (numOfOccur(full, ' ') > 0) {
		put("noSpaceForImageLocation_fullimage", true);
     	  	gotoPanel("Image");
   	  	return false;
      	  }
      	  
      	  if (numOfOccur(thumb, ' ') > 0) {
		put("noSpaceForImageLocation_thumbnail", true);
     	  	gotoPanel("Image");
   	  	return false;
      	  } 
      	   
      }
      return true;
  }
  
  // validate "attribute" panel
  function validAttribute() {

      var itemattribute = get("attribute");
      if (itemattribute != null) {
      	  
      	  var size = itemattribute.size;
      	  var langid = itemattribute.langid;
      
          var attrvalue = new Array(size);
          var attrtype = new Array(size);
          var attrname = new Array(size);
          var attrId = new Array(size);
	  var attrEmptyValueList = new Array(size);
         
      
          for (var i = 0; i < size; i++) 
          {
     
      	      var x = itemattribute.attribute["attr" + i];
      
      	      attrvalue[i] = x.attrvalue;
      	      attrtype[i] = x.attrtype;
      	      attrname[i] = x.attrname;
              attrId[i] = x.attrid;
	      attrEmptyValueList[i] = x.isEmptyValueList; 

	     if(attrEmptyValueList[i] == "YES"){
		   put("attributeValueListEmptyMessage", true);
      	      	   gotoPanel("Attributes");
      	     	   return false;
	     }		   
            
                         
             if (attrvalue[i] == "" || attrvalue[i] == "NaN") 
               {
		   put("selectAttributeMessage", true);
      	      	   gotoPanel("Attributes");
      	     	   return false;
      	       }
      	      
      	 }   // end for
     }  // end if
     
     return true;
      
  }
 

  function validListPrice() {

      var listprice = get("listprice");
      if (listprice != null) {
      
      	  var size = listprice.size;
      	  var langid = listprice.langid;
          var currency = new Array(size);
          var price = new Array(size);
          var formattedPrice = new Array(size);
       
          for (i = 0; i < size; i++) {
      
      	      var x = listprice.listprice["curr" + i];
               
              currency[i] = x.currency;
      	      price[i] = x.listprice;
              formattedPrice[i] = x.formattedPrice;
      	      
      	      if (formattedPrice[i] == "") {
      	      	  gotoPanel("ListPrices", currency[i] + "_missprice_" + i);
      	     	  return false;
      	      }
      	       
      	      if (!isValidNumber(formattedPrice[i], langid)) {
      	          gotoPanel("ListPrices", currency[i] + "_" + i);
      	     	  return false;
      	      }
      	      	
      	      x.listprice = strToNumber(x.formattedPrice, langid);
          }
      }
       
      return true;
  }
  
 
 function validVendor()
 {
      var vendor = get("manufacturer");
    
      if (vendor != null) {
         
          var mftnum = vendor.mftnum;
          var mftname = vendor.mftname;
          if ( !isValidUTF8length(mftnum, 64) )
      	  {
		put("fieldSizeExceeded_mftnum", true);
     	  	gotoPanel("Manufacturer");
   	  	return false;
      	  }

          if ( !isValidUTF8length(mftname, 64) )
      	  {
		put("fieldSizeExceeded_mftname", true);
     	  	gotoPanel("Manufacturer");
   	  	return false;
      	  }
      }
      return true;
 } 


function validUnitOfMeasure(){

	var uom = get("catentship");

	if(uom != null){

		var langId = uom.langid;
		var weight = uom.weight;
		var quantityMultiple = uom.quantitymultiple;
		var nominalQuantity = uom.nominalquantity;

		if(weight != "" && !isValidNumber(numberToStr(weight,langId) , langId)){
   			put("weightSelectNumberMessage", true);
			gotoPanel("UnitOfMeasure");
   			return false;
   		}

		if(quantityMultiple != "" && !isValidNumber(numberToStr(quantityMultiple,langId) , langId)){
   			put("quantityMultipleSelectNumberMessage", true);
			gotoPanel("UnitOfMeasure");
   			return false;
   		}

		if(nominalQuantity != "" && !isValidNumber(numberToStr(nominalQuantity,langId) , langId)){
   			put("nominalQuantitySelectNumberMessage", true);
			gotoPanel("UnitOfMeasure");
   			return false;
   		}

	} 

	return true;


}

 
 function validAdvanced() {
      		
      var itemadvanced = get("advanced");
    
      if (itemadvanced != null) {
         
          var aurl = itemadvanced.aurl;

    	  if (numOfOccur(aurl, ' ') > 0) {
		put("aurlSpace_aurl", true);
      	  	gotoPanel("Advanced");
      	  	return false;
      	  }

          if ( !isValidUTF8length(aurl, 254) )
      	  {
		put("fieldSizeExceeded_aurl", true);
     	  	gotoPanel("Advanced");
   	  	return false;
      	  }	  
      	   
      }
      return true;
  }
 

////////////////////////////////////////////////////////////////////////////////////////////////
 
function cutspace(word) {
	
    return trim(word);
   
}


function prepareMessage(msgTemplate, parameters)
{
   return replaceMsgs(msgTemplate, "?", parameters);
}


//note: messages is Array type.
function replaceMsgs(source, pattern, messages) {

    pos = source.indexOf(pattern);
    
    if (pos != -1) {
    	var before = source.substring(0, pos);
    	var after = source.substring(pos+1);
       	var shifted = messages.shift(); 
    
        after = replaceMsgs(after, pattern, messages);
            
        source = before + shifted + after;
    }
   
    return source;
     
}
