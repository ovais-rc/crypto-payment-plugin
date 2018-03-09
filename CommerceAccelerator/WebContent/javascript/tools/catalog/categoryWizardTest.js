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

 
    if (validGeneral() && validImage () && validParent () )
        return true;
    else
        return false;

  }
 
  function validGeneral()
  {
  	
     var general = get("categorygeneral");
 

     if (general != null )
     {
     	var name = general.name;
        var desc = general.description;
		var longdesc = general.longdescription;
		var keywrd = general.keyword;


	if ( !isValidUTF8length(name, 254)  )
      	{
     		gotoPanel("CategoryGeneral", "fieldSizeExceeded_cname");
   	  	return false;
      	}

     	
     	if ((name == "") || ( name == null )) {
     	    gotoPanel("CategoryGeneral", "missname_cname");
            return false;
     	}

        if ( !isValidUTF8length(desc, 254)  )
      	{
     	     gotoPanel("CategoryGeneral", "fieldSizeExceeded_description");
   	     return false;
      	}

        if ( !isValidUTF8length(longdesc, 254)  )
      	{
     	     gotoPanel("CategoryGeneral", "fieldSizeExceeded_description");
   	     return false;
      	}

        if ( !isValidUTF8length(keywrd, 254)  )
      	{
     	     gotoPanel("CategoryGeneral", "fieldSizeExceeded_description");
   	     return false;
      	}
           
     }
     return true;
  }

  function validImage() {
      		
      var category_image = get("image");
    
      if (category_image != null) {
         
          var full = category_image.fullimage;
          var thumb = category_image.thumbnail;

          if ( !isValidUTF8length(full, 254) )
      	  {
     	  	gotoPanel("CategoryImage", "fieldSizeExceeded_fullimage");
   	  	return false;
      	  }

          if ( !isValidUTF8length(thumb, 254) )
      	  {
     	  	gotoPanel("CategoryImage", "fieldSizeExceeded_thumbnail");
   	  	return false;
      	  }
          
      	  if (numOfOccur(full, ' ') > 0) {
      	  	gotoPanel("CategoryImage", "noSpaceForImageLocation_fullimage");
      	  	return false;
      	  }
      	  
      	  if (numOfOccur(thumb, ' ') > 0) {
      	  	gotoPanel("CategoryImage", "noSpaceForImageLocation_thumbnail");
      	  	return false;
      	  } 
      	   
      }
      return true;
  }

  function validParent () {

   var category_parent = get( "categoryparent" );
   if ( category_parent != null ) {
          thisCategoryId = category_parent.category_id;
          parentCategoryId = category_parent.parent_category_id;
          if ( thisCategoryId == parentCategoryId ) {
     	  	gotoPanel("CategoryParent", "samechosen");
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
