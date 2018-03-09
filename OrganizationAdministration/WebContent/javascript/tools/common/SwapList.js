/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/


///////////////////////////////////////////////////////////////
// This function handles to move one or more items from 1 list
// box to the other. It is called menu-swapper
// input: component name (from);  component name (to)
//////////////////////////////////////////////////////////////	
function move(fromList,toList) {
  for(var i=0; i<fromList.options.length; i++) {
    if(fromList.options[i].selected && fromList.options[i].value != "") {
       var no = new Option();
       no.value = fromList.options[i].value;
       no.text = fromList.options[i].text;
       toList.options[toList.options.length] = no;
    }
  } 
  for(var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options[i].selected) fromList.options[i] = null;
  } 
 
  // Refresh to correct for bug in IE5.5 in list box
  // If more than the list box's displayable contents are moved, a phantom
  // line appears.  This refresh corrects the problem.
  for (var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options.length!=0) {
      fromList.options[i].selected = true;
    }
  }
  for (var i=fromList.options.length-1; i>=0; i--) {
    if(fromList.options.length!=0) {
      fromList.options[i].selected = false;
    }
  }
}

////////////////////////////////////////////////////////////////
// Slosh bucket function 
///////////////////////////////////////////////////////////////
function BumpUp(box)  {
   for(var i=0; i<box.options.length; i++) {
      if(box.options[i].value == "")  {
        for(var j=i; j<box.options.length-1; j++)  {
          box.options[j].value = box.options[j+1].value;
          box.options[j].text = box.options[j+1].text;
        }
       var ln = i;
       break;
      }
   }
   if(ln < box.options.length)  {
      box.options.length -= 1;
      BumpUp(box);
     }
 }


//////////////////////////////////////////////////////////////
// This function is used to determine whether or not user
// has selected all items in a list box
// return true if all items have been selected, otherwise
// return false
/////////////////////////////////////////////////////////////
function allItemsSelected(aComponent) {

   var numOfItems     = aComponent.options.length;
	var numItemSelected= 0;
   for (var i=0; i<aComponent.options.length; i++) {
      if (aComponent.options[i].selected && aComponent.options[i].value != "") {
         numItemSelected ++;
		}
	}	
	if ( numOfItems == numItemSelected ){ // all items selected	   
    	return false;
	 }
	return true;
}

////////////////////////////////////////////////////////////////
// Set all items unselected for a given list box
////////////////////////////////////////////////////////////////
function setItemsUnselected(aComponent) {

  for (var i=0; i<aComponent.options.length; i++)
     aComponent.options[i].selected = false;
}


////////////////////////////////////////////////////////////////
// Set all items selected for a given list box
////////////////////////////////////////////////////////////////
function setItemsSelected(aComponent) {

  for (var i=0; i<aComponent.options.length; i++)
     aComponent.options[i].selected = true;
}

//////////////////////////////////////////////////////////////
// Set a specific item selected for a given list box
//////////////////////////////////////////////////////////////
function setAnItemSelected(aComponent, value) {
   for (var i=0; i<aComponent.options.length;i++) {	   
	   if ( aComponent.options[i].value == value ) {          
			   aComponent.options[i].selected = true;
				return;
		  }
	} // end of for
}


///////////////////////////////////////////////////////////////
// This function is used to determine whether or not user has
// choosen the a selected item by given its value
// Return true if it is true
// otherwise return false
//////////////////////////////////////////////////////////////
function isItemSelected(aComponent, value) {
   for (var i=0; i< aComponent.options.length; i++) {
	   if ( aComponent.options[i].selected &&
		     aComponent.options[i].value == value )
         return true; 
	}
	return false;
}


////////////////////////////////////////////////////////////
// This function is used to determine wheter or not a given
// item value is in the list box, it returns true if it is
// otherwise, it returns false
///////////////////////////////////////////////////////////
function hasItem(aComponent, item) {
	for (var i=0; i< aComponent.options.length; i++) {
	   if ( aComponent.options[i].value == item )
         return true; 
	}
	return false;
}


///////////////////////////////////////////////////////////
// This function is used to determine whether or not a given
// list box empty. Returns true if it is empty
//////////////////////////////////////////////////////////
function isListBoxEmpty(aComponent) {
  if ( aComponent.options.length == 0 ) return true;
  return false;
}


///////////////////////////////////////////////////////////////
// This function is used to determine which item the user
// has selected in an option box.  It returns the value
// of the *first* selected item if found, 
// otherwise it return empty ""
//////////////////////////////////////////////////////////////
function whichItemIsSelected(aComponent) {
   for (var i=0; i< aComponent.options.length; i++) {
       if (aComponent.options[i].selected) {
	   return aComponent.options[i].value;
       }
   }
   return "";
}

///////////////////////////////////////////////////////////////
// This function is used to determine how many items the user
// has selected.  It return 0 if no items are selected, 
// or an interger for the number of selected options.
//////////////////////////////////////////////////////////////
function countSelected(aComponent) {
   var selectedCount = 0;
   for (var i=0; i<aComponent.options.length; i++) {
      if (aComponent.options[i].selected) {
	 selectedCount++;
      }
   }
   return selectedCount;
}

///////////////////////////////////////////////////////////////
// This function is used to enable/disable a button that is 
// associated with a sloshbucket option box.  Input args include
// an option box and a button.  If any options are selected in 
// the option box, the button is enabled, otherwise, it is disabled.
// Use this function in the onChange block of the SELECT html
//////////////////////////////////////////////////////////////
function setButtonContext(aComponent, aButton) {
    var selectedCount = countSelected(aComponent);
    // at least one item is selected... enable the button.
    if (selectedCount > 0) { 
        aButton.disabled=false;
        aButton.className='enabled';        
        aButton.id='enabled';   
    }
    else {
        aButton.disabled=true;
        aButton.className='disabled';        
        aButton.id='disabled';    
    }
}

///////////////////////////////////////////////////////////////
// This function is used to update the enable/disable settings of
// the buttons associated with 2 sloshbuckets.
// This function would nomally be called in the onChange event
// of each sloshbucket SELECT form element.
// The first arg is generally set to "this" or the SELECT form element
// The second arg is a reference to the button that would normally
// be enabled if "this" sloshbucket had one or more elements selected
// The 3rd arg is the other sloshbucket
// The 4th arg is the other sloshbuckets button that would normally 
// be enabled if the other sloshbucket had one or more elements enabled.
// This may all sound very confusing... look at MIconditionsWhat.jsp to
// see how this is implemented. 
//////////////////////////////////////////////////////////////
function updateSloshBuckets(aComponent1, aButton1, aComponent2, aButton2) {  
    // the user has selected an item from component1, clear out component 2...
    setItemsUnselected(aComponent2);
        
    // activate/deactivate button 1...
    setButtonContext(aComponent1, aButton1);  
        
    // activate/deactivate button 2...
    setButtonContext(aComponent2, aButton2); 
}


///////////////////////////////////////////////////////////////
// This function is similar to "updateSloshBuckets()"
// except that it is designed to be called when the page is first loaded
// ie: call this function as part of the "onLoad" event.
//////////////////////////////////////////////////////////////   
function initializeSloshBuckets(aComponent1, aButton1, aComponent2, aButton2) {    
    // deselect all from both sloshbuckets
    setItemsUnselected(aComponent1);
    setItemsUnselected(aComponent2);
  
    // deactivate button 1...
    setButtonContext(aComponent1, aButton1);  
        
    // deactivate button 2...
    setButtonContext(aComponent2, aButton2); 
}

