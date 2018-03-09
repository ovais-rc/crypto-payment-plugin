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

// @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.

// code for disbling the button
function disableButton(b) {
	if (defined(b)) {
		b.disabled=false;
		b.className='disabled';
		b.id='disabled';
	}
}

// code for disbling the button
function enableButton(b) {
	if (defined(b)) {
		b.disabled=false;
		b.className='enabled';
		b.id='enabled';
	}
}

//code for checking button status
function isButtonDisabled(b) {
    if (b.className =='disabled' &&	b.id == 'disabled')
	return true;
    return false;
}

//trimming function
//trim the left of the string
function ltrim(s){
	return s.replace(/^\s*/,"");
}

//trim the right of the function
function rtrim(s){
	return s.replace(/\s*$/,"");
}

// Remove the object from the vector
function gsRemoveElement(element, owner)
{
  if ( owner == null )
  {
      var buffer = new Array();
  
      for(var i=0; i<this.container.length; i++)
      {
        if(this.container[i] == element)
          continue;
        
        buffer[buffer.length] = this.container[i];
      }
  
      if (this.container.length == buffer.length) return(false);
      
      this.container = buffer;
      return(true);
    
  } // end of owner= null
  else
  { //owner != null
      var buffer = new Array();
  
      for(var i=0; i<owner.container.length; i++)
      {
        if(owner.container[i] == element)
          continue;
        
        buffer[buffer.length] = owner.container[i];
      }  

      if (owner.container.length == buffer.length) return(false);

      owner.container = buffer;
      return(true);    

  } // end of owner is not null
}// END paRemoveElement

function disableElements(form){
	var length = form.elements.length;
	for(var i=0;i<length;i++){
		var e = form.elements[i];
		e.disabled=true;
	}
}

function enableElements(form){
	var length = form.elements.length;
	for(var i=0;i<length;i++){
		var e = form.elements[i];
		e.disabled=false;
	}
}

function gsModifyBCT(languageId){
	var current = top.mccbanner.trail[top.mccbanner.counter-1].location;
	var changed = '';
	var split1 = current.split('?');
	changed += split1[0]+'?';
	var split2 = split1[1].split('&');
	var s2length = split2.length;
	for(var i=0;i<s2length;i++){
		var split3 = split2[i].split('=');
		var key = split3[0];
		var value = split3[1];
		if(key == 'gsLanguageId'){
			value = languageId;
		}
		changed += key+'='+value;
		if(i != s2length-1){
			changed += '&';
		}
	}
	top.mccbanner.trail[top.mccbanner.counter-1].location = changed;
}

function removeTopContents(){
	top.remove("answersVector");
	top.remove("questionObject");
	top.remove("featureArray");
	top.remove("constraintData");
	top.remove("linkArray");
	top.remove("checkedVals");
	top.remove("changedLinkData");
}
