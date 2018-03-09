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


  function submitErrorHandler (errMessage) {
   	alertDialog(errMessage);
   }

   function submitFinishHandler (finishMessage)
   {
   	alertDialog(finishMessage);
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
   
    if (validDetails() && validDescription() && validImage() && validAttribute() && validInventory() && validListPrice() && validAdvanced() && validVendor() )
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

	if ( !isValidUTF8length(sku, 64)  )
      	{
     		gotoPanel("General", "fieldSizeExceeded_sku");
   	  	return false;
      	}

	if ( !isValidUTF8length(name, 128)  )
      	{
     		gotoPanel("General", "fieldSizeExceeded_name");
   	  	return false;
      	}
     	
     	if (sku == "") {
     	    gotoPanel("General", "misssku_sku");
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
     	  	gotoPanel("Description", "fieldSizeExceeded_shortDesc");
   	  	return false;
      	  }
// commented out due to defect 67374
/*
      	  if ( !isValidUTF8length(long1, 32700) )
      	  {
     	  	gotoPanel("Description", "fieldSizeExceeded_longDesc");
   	  	return false;
      	  }
*/
      	  if ( !isValidUTF8length(long2, 4000) )
      	  {
     	  	gotoPanel("Description", "fieldSizeExceeded_auxDesc1");
   	  	return false;
      	  }

      	  if ( !isValidUTF8length(long3, 4000) )
      	  {
     	  	gotoPanel("Description", "fieldSizeExceeded_auxDesc2");
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
     	  	gotoPanel("Image", "fieldSizeExceeded_fullimage");
   	  	return false;
      	  }

          if ( !isValidUTF8length(thumb, 254) )
      	  {
     	  	gotoPanel("Image", "fieldSizeExceeded_thumbnail");
   	  	return false;
      	  }
          
      	  if (numOfOccur(full, ' ') > 0) {
      	  	gotoPanel("Image", "noSpaceForImageLocation_fullimage");
      	  	return false;
      	  }
      	  
      	  if (numOfOccur(thumb, ' ') > 0) {
      	  	gotoPanel("Image", "noSpaceForImageLocation_thumbnail");
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
          var formatValue = new Array(size);
      
          for (var i = 0; i < size; i++) 
          {
     
      	      var x = itemattribute.attribute["attr" + i];
      
      	      attrvalue[i] = x.attrvalue;
      	      attrtype[i] = x.attrtype;
      	      attrname[i] = x.attrname;
              attrId[i] = x.attrid;
              formatValue[i] = x.formatValue;

              
              if ( attrtype[i] == "AttributeIntegerValueBean" || attrtype[i] == "AttributeFloatValueBean" )
              {
                 if (formatValue[i] == "") 
                 {
      	      	     gotoPanel("Attributes", "missattr_" + attrId[i]);
      	     	     return false;
      	     	 }
              	
              }
              else
              {
                 if (attrvalue[i] == "") 
                 {
      	      	     gotoPanel("Attributes", "missattr_" + attrId[i]);
      	     	     return false;
      	     	 }
      	      }
      	      
              
      	      if (attrtype[i] == "AttributeIntegerValueBean") 
      	      {
      	      	
      	      	  if (!isValidInteger(formatValue[i], langid)) 
      	      	  {
      	     	      gotoPanel("Attributes", "int_" + attrId[i]);
      	     	      return false;
      	          }
      	          x.attrvalue = strToInteger(formatValue[i], langid); 
      	      }	
      	      else if (attrtype[i] == "AttributeFloatValueBean") 
      	      {
                
      	          if (!isValidNumber(formatValue[i], langid)) 
      	          {
      	     	      gotoPanel("Attributes", "float_" + attrId[i]);
      	     	      return false;
      	          }
      	          x.attrvalue = strToNumber(formatValue[i], langid); 
      	      }
      	      else if (attrtype[i] == "AttributeStringValueBean") 
      	      {
      	          if ( !isValidUTF8length(attrvalue[i], 254) )
      	          {
     	  	     gotoPanel("Attributes", "string_" + attrId[i]);
   	  	     return false;
      	          }
      	      	  
      	      }
      	   }   // end for
     }  // end if
     
     return true;
      
  }
 

  function validInventory() {
  	
      var iteminventory = get("inventory");
      if (iteminventory != null) {
          
          var langid = iteminventory.langid;  
          var curInv = iteminventory.curInv;
          var invMode = iteminventory.invUpdateMode; 	   
      	  var invValue = iteminventory.invUpdateValue;
      	  
      	  if (invValue != "") {
      	      if (!isValidNumber(invValue, langid, true)) {
      	  	  gotoPanel("Inventory", "invnumerr");
      	  	  return false;
      	      }
      	  
      	      if ((invMode == "decrement" || invMode == "increment" ) && invValue < 0) {
      	  	  gotoPanel("Inventory", "neginv");
      	  	  return false;
      	      }
      	      iteminventory.invUpdateValue = strToNumber(invValue, langid);
      	  }
      }
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
     	  	gotoPanel("Manufacturer", "fieldSizeExceeded_mftnum");
   	  	return false;
      	  }

          if ( !isValidUTF8length(mftname, 64) )
      	  {
     	  	gotoPanel("Manufacturer", "fieldSizeExceeded_mftname");
   	  	return false;
      	  }
      }
      return true;
 } 
 
 function validAdvanced() {
      		
      var itemadvanced = get("advanced");
    
      if (itemadvanced != null) {
         
          var aurl = itemadvanced.aurl;
          var axml = itemadvanced.axml;

    	  if (numOfOccur(aurl, ' ') > 0) {
      	  	gotoPanel("Advanced", "aurlSpace_aurl");
      	  	return false;
      	  }

          if ( !isValidUTF8length(aurl, 254) )
      	  {
     	  	gotoPanel("Advanced", "fieldSizeExceeded_aurl");
   	  	return false;
      	  }

          if ( !isValidUTF8length(axml, 32700) )
      	  {
     	  	gotoPanel("Advanced", "fieldSizeExceeded_axml");
   	  	return false;
      	  }      	  
      	  
      	  var ayear = itemadvanced.availYear;
     	  var amonth = itemadvanced.availMonth;
     	  var aday = itemadvanced.availDay;
     	  var atime = itemadvanced.availTime;
     	
     	
     	  if (ayear == "" && amonth == "" && aday == "" && atime =="") {
     	      //do nothing
     	  } else {
     	      if (ayear != "" && amonth != "" && aday != "" && atime != "") {
     	          vd = validDate(ayear, amonth, aday);
     	          vt = validTime(atime);
     	        
     	          if (!vd) {
                      gotoPanel("Advanced", "availDate_availYear");
            	      return false;
                  }
                  if (!vt) {
                      gotoPanel("Advanced", "availTime_availTime");
                      return false;
                  }  	
     	       	   
     	      } else {
     		  gotoPanel("Advanced", "emptyDateMsg_availYear");
                  return false;
     	      }
     	 
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
