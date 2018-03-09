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


    
 /*
   -- validateAllPanels(name)
   -- Read data stored in model and validate it
   -- If a frame contains invalid data, call gotoPanel to switch to that panel and display an error msg
   -- Return true if all data is valid
   -- false otherwise
   -- */

  function validateAllPanels() 
  {

    if (validDetails() && validDescription() && validImage() && validAdvanced() && validVendor() && validFulfillment() && validUnitOfMeasure() && validCategory())
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
    	var configuratorUrl = details.configuratorUrl;
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
	    put("productSkuRequiredMessage", true);
     	    gotoPanel("General");
            return false;
     	}

	if (!details.name) {
	    put("productNameRequiredMessage", true);	    
     	    gotoPanel("General");
            return false;
     	}
     	
     	if ( (details.type=="DynamicKitBean") && (!details.configuratorUrl)  ) {
		    put("configuratorURLNameRequiredMessage", true);	    
	     	    gotoPanel("General");
	            return false;
     	}

    	if (! isValidProductName(name)){
	    put("productNameNotValidMessage", true);	    
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
        
	if ( !isValidUTF8length(configuratorUrl, 254)  )
      	{
	    put("fieldSizeExceeded_configuratorUrl", true);
     	    gotoPanel("General");
	    return false;
      	}
 	if (numOfOccur(configuratorUrl, ' ') > 0) {
	    put("configuratorUrlSpace_url", true);
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


function isValidProductName(myString) 
{
    var invalidChars = "<>"; // invalid chars
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


 function validDescription() 
 {
      		
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
           


  function validCategory()
  {

      var category = get("productcategory");
    
      if (category != null) {
         
          var path1 = category.path;
          
          if (isPathCatalog(path1))
      	  {
		put("selectCategory", true);
     	  	gotoPanel("Category");
   	  	return false;
      	  }
      }
      return true;
  }


function isPathCatalog( path ) 
{

  var sep = "/";
  var pos1 = 0;


  pos1 = path.indexOf( sep );

  result = ( path.length > 0 && pos1 == -1 );
  return result;

}


  function validImage() 
  {
      		
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

function validUnitOfMeasure()
{

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

function validFulfillment() 
{

     var storeitem = get("storeitem");

     if (storeitem != null )
     {
	var langId = storeitem.langid;
     	var quantitymeasure = storeitem.quantitymeasure;
	var quantitymultiple = storeitem.quantitymultiple;

	if ( !isValidUTF8length(quantitymultiple, 8)  )
      	{
   		put("fieldSizeExceeded", true);
     		gotoPanel("Fulfillment");
   	  	return false;
      	}

	if(quantitymultiple != "" && !isValidNumber(quantitymultiple , langId)){
   		put("quantityMultipleSelectNumberMessage", true);
		gotoPanel("Fulfillment");
   		return false;
   	}
     }
     return true;
}
 
 function validAdvanced() 
 {
      		
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


///////////////////////////////////////////////////////////////////////////////
function preSubmitHandler()
{
}

function submitErrorHandler (errMessage) 
{
	alertDialog(errMessage);
}

function submitFinishHandler (finishMessage)
{
	alertDialog(finishMessage);

	top.put("ProductUpdateDetailCatentryId", NAVIGATION.requestProperties["KIT_CatentryId"]);

	var urlParam=top.mccbanner.trail[top.mccbanner.counter-1].parameters;
		if(urlParam==null)
			urlParam = new Object();
		urlParam['actionKit']= "LOAD_KIT";
		urlParam['LOAD_KIT_catentryId']=NAVIGATION.requestProperties["KIT_CatentryId"];

	top.mccbanner.counter --;
	top.mccbanner.showbct();
		
	top.showContent(top.mccbanner.trail[top.mccbanner.counter].location, urlParam);
} 
  
function submitCancelHandler() 
{
	top.goBack();
}
    
