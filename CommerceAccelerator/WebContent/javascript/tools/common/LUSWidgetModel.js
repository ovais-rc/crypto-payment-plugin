/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corp. 2003
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 *-------------------------------------------------------------------
 */



/////////////////////////////////////////////////////////////////////////////
//
// A NOTE TO DEVELOPERS:
//
//    This javascript file LUSWidget.js defines all the attributes &
// behaviours for a Look-up Selection (a.k.a 'LUS') widget (refer to
// LI#1099). This file encapsulates the LUS's model but not coupling
// to the GUI view. Developers can freely plug-in different GUI look &
// feel with this javascrpit file to perform similar behaviours, with
// the restriction of the LUS design scope.
//
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_LookUpSelectionWidget
// Desc.   : This function serves as a constructor and defines a LookUp
//           Selection Widget model
// Input   : The input parameters are described as below
//           the_form        - the name of the LookUp Selection widget's form
//           search_text     - the name of the text field that allows user to
//                             type a keyword for search
//           criteria_list   - the name of the dropdown list box that displays
//                             the search criteria menu
//           quick_entry     - the name of the text field that allows user to
//                             type and navigate items from the resulting list
//           result_list     - the name of the list box that displays the
//                             resulting items
//           status_line_id  - the unique <TD> identifier for the status line
//                             that displays the number of items currently shown
//           status_line_msg - the default status line message
//
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_LookUpSelectionWidget(the_form,
                                   search_text,
                                   criteria_list,
                                   quick_entry,
                                   result_list,
                                   status_line_id,
                                   status_line_msg)
{
   // LUS Attributes
   this.formName                = the_form;
   this.keywordTxtEntryName     = search_text
   this.searchCriteriaListName  = criteria_list;
   this.searchTxtEntryName      = quick_entry;
   this.searchResultListName    = result_list;
   this.searchResultListEntries = new Array(); // array of opton objects list
   this.statusLineId            = status_line_id;
   this.statusLineDefaultMsg    = status_line_msg;
  
   // LUS Methods
   this.LUS_autoNavigate          = LUS_autoNavigate;
   this.LUS_setResultingList      = LUS_setResultingList;
   this.LUS_getSelectedResults    = LUS_getSelectedResults;
   this.LUS_getSelectedResultNames= LUS_getSelectedResultNames;
   this.LUS_setStatusLine         = LUS_setStatusLine;
   this.LUS_refreshCurrentlyShown = LUS_refreshCurrentlyShown;
   this.LUS_setSearchKeyword      = LUS_setSearchKeyword;
   this.LUS_getSearchKeyword      = LUS_getSearchKeyword;
   this.LUS_getSelectedCriteria   = LUS_getSelectedCriteria;
   this.LUS_clearComboBox         = LUS_clearComboBox;
   this.LUS_disableAll            = LUS_disableAll;
   this.LUS_enableAll             = LUS_enableAll;
   this.LUS_clearComboBoxWithOutStatusLine = LUS_clearComboBoxWithOutStatusLine;
   this.LUS_clearComboBoxAllWithOutStatusLine = LUS_clearComboBoxAllWithOutStatusLine;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_autoNavigate
// Desc.   : This is a LookUpSelectionWidget's function which provides the
//           behaviour of automatic scrolling to the item entry that matches
//           the input from user at the quick selection textfield. Scroll
//           to the list item entry but not select it.
// Input   : void
// Output  : void
// Remarks : This function should be invoked when a OnKeyUp event happens
//           in the quick search text field.
/////////////////////////////////////////////////////////////////////////////

function LUS_autoNavigate()
{  
   // First check the resulting list box, if it's empty, do nothing & skip
   if (document.forms[this.formName][this.searchResultListName].options[0] == null)
   { 
   	return;
   }
   
   var str = document.forms[this.formName][this.searchTxtEntryName].value.replace('^\\s*', '');
   str = str.replace(/[\\*\[\]+()]/g, "");

   // Specify "i" to allow case insensitive
   pattern = new RegExp("^" + str, "i");

   for (var i=0; i < this.searchResultListEntries.length; i++)
   {    
      // Does the result item entry match the user input quick selection text ?
      if (pattern.test(this.searchResultListEntries[i].text))
      {
         // Yes, scroll to the matched item entry but not select it
         document.forms[this.formName][this.searchResultListName].options[i].selected = true;
         document.forms[this.formName][this.searchResultListName].selectedIndex = -1;
         return;
      }
   }
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_setResultingList
// Desc.   : This is a LookUpSelectionWidget's function which sets the
//           resulting list model with a given array of items, and also
//           stores the items in the resulting listbox.
// Input   : itemNameList - array of item names in string
//           itemValueList - array of item values in string
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_setResultingList(itemNameList, itemValueList)
{
   this.searchResultListEntries = new Array();

   for (var i=0; i < itemValueList.length; i++)
   {
      var tmpOption = new Option(itemNameList[i], itemValueList[i]);
      this.searchResultListEntries[i] = tmpOption;
      document.forms[this.formName][this.searchResultListName].options[i] = tmpOption;
   }

   document.forms[this.formName][this.searchResultListName].options.length = itemValueList.length;
   return;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_getSelectedResults
// Desc.   : This is a LookUpSelectionWidget's function which retrieves and
//           returns a list of user selected resulting list item values.
// Input   : void
// Output  : Array of selected item values
/////////////////////////////////////////////////////////////////////////////

function LUS_getSelectedResults()
{
   var selectedChoices = new Array();
   var count = 0;

   for (var i=0; i < document.forms[this.formName][this.searchResultListName].options.length; i++)
   {
      if (document.forms[this.formName][this.searchResultListName].options[i].selected)
      {
         selectedChoices[count] = document.forms[this.formName][this.searchResultListName].options[i].value;
         count++;
      }
   }

   return selectedChoices;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_getSelectedResultNames
// Desc.   : This is a LookUpSelectionWidget's function which retrieves and
//           returns a list of user selected resulting list item names.
// Input   : void
// Output  : Array of selected item names
/////////////////////////////////////////////////////////////////////////////

function LUS_getSelectedResultNames()
{
   var selectedChoices = new Array();
   var count = 0;

   for (var i=0; i < document.forms[this.formName][this.searchResultListName].options.length; i++)
   {
      if (document.forms[this.formName][this.searchResultListName].options[i].selected)
      {
         selectedChoices[count] = document.forms[this.formName][this.searchResultListName].options[i].text;
         count++;
      }
   }

   return selectedChoices;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_setStatusLine
// Desc.   : This is a LookUpSelectionWidget's function which display a
//           message on the status line, for example, "Total accounts
//           currently showing: ".
// Input   : a new message in string format
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_setStatusLine(newMsg)
{
   document.all[this.statusLineId].innerText = newMsg;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_refreshCurrentlyShown
// Desc.   : This is a LookUpSelectionWidget's function which refreshes the
//           the status line message with the updated numbers of item currently
//           showing. If the input parameter 'newValue' is given, it will
//           simply refresh the status line with the specified value. Or else,
//           it will get the total number of entries in the resulting listbox
//           and display on the status line.
// Input   : (optional) a new integer value of total items currently showing
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_refreshCurrentlyShown(newValue)
{
   var statusLineMsg = this.statusLineDefaultMsg;
   if (newValue!=null)
   {
      statusLineMsg += newValue;
   }
   else
   {
      var currNum = document.forms[this.formName][this.searchResultListName].options.length;
      statusLineMsg += " " + currNum;
   }

   this.LUS_setStatusLine(statusLineMsg);
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_setSearchKeyword
// Desc.   : This is a LookUpSelectionWidget's function which assigns a
//           text string in the keyword search text field.
// Input   : defaultValue - the string shown in the search keyword field
//           isHighlighted - a boolean (true/false) to indicate the
//                                  field should be selected
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_setSearchKeyword(defaultValue, isHighlighted)
{
   document.forms[this.formName][this.keywordTxtEntryName].value = defaultValue;
   if (isHighlighted==true)
   {
      document.forms[this.formName][this.keywordTxtEntryName].select();
   }
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_getSearchKeyword
// Desc.   : This is a LookUpSelectionWidget's function which returns the
//           current text string in the keyword search text field.
// Input   : void
// Output  : a string content in the keyword search text field.
/////////////////////////////////////////////////////////////////////////////

function LUS_getSearchKeyword()
{
   return document.forms[this.formName][this.keywordTxtEntryName].value;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_getSelectedCriteria
// Desc.   : This is a LookUpSelectionWidget's function which returns the
//           user selected search criteria option
// Input   : void
// Output  : a string value of the selected search criteria
/////////////////////////////////////////////////////////////////////////////

function LUS_getSelectedCriteria()
{
   var selectedCriteriaIdx = document.forms[this.formName][this.searchCriteriaListName].selectedIndex;
   return document.forms[this.formName][this.searchCriteriaListName].options[selectedCriteriaIdx].value;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_clearComboBox
// Desc.   : This is a LookUpSelectionWidget's function which empties the
//           quick search text field and the search resulting list box.
// Input   : void
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_clearComboBox()
{
   document.forms[this.formName][this.searchTxtEntryName].value = "";

   while (document.forms[this.formName][this.searchResultListName].options.length > 0 )
   {
      // Delete all item entries in the resulting list box
      document.forms[this.formName][this.searchResultListName].options[0] = null;
   }
   this.LUS_refreshCurrentlyShown(0);
}

/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_clearComboBoxWithOutStatusLine
// Desc.   : This is a LookUpSelectionWidget's function which empties the
//           quick search text field and the search resulting list box. 
//	     It does not refresh the current shown number.
//	     It is useful when the page does not have the status line. 
// Input   : void
// Output  : void
/////////////////////////////////////////////////////////////////////////////
function LUS_clearComboBoxWithOutStatusLine()
{
   document.forms[this.formName][this.searchTxtEntryName].value = "";

   while (document.forms[this.formName][this.searchResultListName].options.length > 0 )
   {
      // Delete all item entries in the resulting list box
      document.forms[this.formName][this.searchResultListName].options[0] = null;
   }

}

/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_clearComboBoxAllWithOutStatusLine
// Desc.   : This is a LookUpSelectionWidget's function which empties the
//           quick search text field, the search resulting list box, and 
//	     keyword text entry. It does not refresh the current shown number.
//	     It is useful when the page does not have the status line. 
// Input   : void
// Output  : void
/////////////////////////////////////////////////////////////////////////////
function LUS_clearComboBoxAllWithOutStatusLine()
{
   document.forms[this.formName][this.searchTxtEntryName].value = "";

   while (document.forms[this.formName][this.searchResultListName].options.length > 0 )
   {
      // Delete all item entries in the resulting list box
      document.forms[this.formName][this.searchResultListName].options[0] = null;
   }
   document.forms[this.formName][this.keywordTxtEntryName].value = "";
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_disableAll
// Desc.   : This is a LookUpSelectionWidget's function which disables all
//           the registered GUI parts to prevent user's interaction.
// Input   : void
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_disableAll()
{
   document.forms[this.formName][this.keywordTxtEntryName].disabled=true;
   document.forms[this.formName][this.searchCriteriaListName].disabled=true;
   document.forms[this.formName][this.searchResultListName].disabled=true;
   document.forms[this.formName][this.searchTxtEntryName].disabled=true;
}



/////////////////////////////////////////////////////////////////////////////
// Class   : LUS (Look-up Selection Widget)
// Function: LUS_enableAll
// Desc.   : This is a LookUpSelectionWidget's function which enables all
//           the registered GUI parts to allow user's interaction.
// Input   : void
// Output  : void
/////////////////////////////////////////////////////////////////////////////

function LUS_enableAll()
{
   document.forms[this.formName][this.keywordTxtEntryName].disabled=false;
   document.forms[this.formName][this.searchCriteriaListName].disabled=false;
   document.forms[this.formName][this.searchResultListName].disabled=false;
   document.forms[this.formName][this.searchTxtEntryName].disabled=false;
}

