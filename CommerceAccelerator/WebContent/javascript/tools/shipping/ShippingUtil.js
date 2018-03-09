//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*


// Set the values in a Select box - text is same as value
function loadSelectValues(select, values)
 {
  for (var i = 0; i < values.length; i++)
   {
    select.options[i] = new Option(values[i], values[i], false, false);
   }
 }

// Set the values in a Select box - value is different from text
function loadTextValueSelectValues(select, values)
 {
  for (var i = 0; i < values.length; i++)
   {
    select.options[i] = new Option(values[i].text, values[i].value, false, false);
   }
 }

// Load the values from a Select box - text is same as value
function getSelectValues(select)
 {
  var values = new Array();
  for (var i = 0; i < select.options.length; i++)
   {
    values[i] = select.options[i].value;
   }
  return values;
 }

// Load the values from a Select box - value is different from text
function getTextValueSelectValues(select)
 {
  var values = new Array();
  for (var i = 0; i < select.options.length; i++)
   {
    var vt = new Object();
    vt.text = select.options[i].text;
    vt.value = select.options[i].value;
    values[i] = vt;
   }
  return values;
 }

// Is an item in a Select box - value is different from text
function isInTextValueList(select, v)
 {
  for (var i = 0; i < select.options.length; i++)
   {
    if (select.options[i].value == v)
	return true;
   }
  return false;
 }
 
 // Return index of an item in a Select box, -1 if item is not in there
function indexOfValueList(select, v)
 {
  for (var i = 0; i < select.options.length; i++)
   {
    if (select.options[i].value == v)
	return i;
   }
  return -1;
 }

// Set the value in an entryfield
function loadValue(entryField, value)
 {
  if (value != top.undefined)
   {
    entryField.value = value;
   }
 }

// Is an item in an array of text-value pairs
function isNameInTextValueArray(n, a) {
   for (index = 0; index < a.length; index++) {
	if (a[index].value == n)
		return true;
   }
   return false;
}

// Is an item in an array of values
function isNameInArray(n, a) {
   for (index = 0; index < a.length; index++) {
	if (a[index] == n)
		return true;
   }
   return false;
}

// Return index of an item in a array, -1 if item is not in there
function indexOfValueInArray(n, a) {
   for (index = 0; index < a.length; index++) {
	if (a[index] == n)
		return index;
   }
   return -1;
}
// code for disbling the button
function disableButton(b) {
	if (defined(b)) {
		b.disabled=true;
		b.className='disabled';
		b.id='disabled';
	}
}

// code for enabling the button
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

