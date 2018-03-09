<!--
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
-->

<%@ page import="com.ibm.commerce.beans.DataBeanManager,
   com.ibm.commerce.tools.segmentation.SegmentAccountListDataBean" %>

<%@ include file="SegmentCommon.jsp" %>

<%
/*d67155:del*/ // SegmentAccountListDataBean accountList = new SegmentAccountListDataBean();
/*d67155:del*/ // DataBeanManager.activate(accountList, request);
/*d67155:del*/ // String[] accounts = accountList.getAccounts();
/*d67155:add*/ CommandContext commandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
/*d67155:add*/ Locale locale = commandContext.getLocale();
/*d67155:add*/ Hashtable resources = (Hashtable) ResourceDirectory.lookup(SegmentConstants.SEGMENTATION_RESOURCES, locale);
%>

<style type="text/css">
.selectWidth {width: 200px;}
</style>


<!-- /*d67155:add-begin*/ -->
<!-------------------------------------------->
<!-- Define the CSS for the LUS's GUI parts -->
<!-------------------------------------------->
<style type='text/css'>
.LUS_CSS_QuickTextEntryWidth {width: 320px;}
.LUS_CSS_ResultListBoxWidth  {width: 320px;}
.LUS_CSS_KeywordEntryWidth   {width: 200px;}
.LUS_CSS_CriteriaListWidth   {width: auto; }
</style>

<!-------------------------------------------->
<!-- Import the LUS Widget Model javascript -->
<!-------------------------------------------->
<script language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<!-- /*d67155:add-end*/ -->

<!-- /*d67155:add-begin*/ -->
<script>
///////////////////////////////////////////////////////////////
// This function is copied, pasted, & modified from the move()
// in SwapList.js. Behaviour changes are described below:
//    - check any duplicated entry before moving
//    - allow optional delete selected entry from fromList
//////////////////////////////////////////////////////////////
function my_move(fromList, toList, optionType)
{
   if (optionType=='addTo')
   {
      for (var i=0; i<fromList.options.length; i++)
      {
         if (fromList.options[i].selected && fromList.options[i].text != "")
         {
            // Check duplicated entry
            var duplcationFound=false;
            for (var chk=0; chk<toList.options.length; chk++)
            {
               if (toList.options[chk].value == fromList.options[i].text)
                  { duplcationFound = true; continue; }
            }

            if (duplcationFound==false)
            {
               var no = new Option();
               no.value = fromList.options[i].text;  // they expect the text is the value
               no.text = fromList.options[i].text;
               toList.options[toList.options.length] = no;

            }//end-if duplcationFound

         }//end-if

      }//end-for-i
   }
   else if (optionType=='removeFrom')
   {
      // Clean up the selected items from the "fromList"
      for(var i=fromList.options.length-1; i>=0; i--)
      {
         if(fromList.options[i].selected) fromList.options[i] = null;
      }
   }

   // Refresh to correct for bug in IE5.5 in list box
   // If more than the list box's displayable contents are moved, a phantom
   // line appears.  This refresh corrects the problem.
   for (var i=fromList.options.length-1; i>=0; i--)
   {
     if(fromList.options.length!=0)
     {
       fromList.options[i].selected = true;
     }
   }

   for (var i=fromList.options.length-1; i>=0; i--)
   {
     if(fromList.options.length!=0)
     {
       fromList.options[i].selected = false;
     }
   }
}

</script>
<!-- /*d67155:add-end*/ -->


<script language="JavaScript">
<!-- hide script from old browsers
/*d67155:del*/ // var allAccounts = new Array();
<%
/*d67155:del-begin*/
/*
if (accounts != null)
 {
  for (int i = 0; i < accounts.length; i++)
   {
*/
/*d67155:del-end*/
%>
/*d67155:del*/ // allAccounts[<%-- /*d67155:del*/ <%=i%> --%>] = "<%-- /*d67155:del*/ <%=accounts[i]%> --%>";
<%
/*d67155:del*/ //   }
/*d67155:del*/ // }
%>

function showAccounts () {
   with (document.segmentForm) {
      var selectValue = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>);
      showDivision(document.all.accountsDiv, (selectValue == "<%= SegmentConstants.VALUE_ONE_OF %>" ||
         selectValue == "<%= SegmentConstants.VALUE_NOT_ONE_OF %>"));
   }
}

function loadAccounts ()
{
   with (document.segmentForm)
   {
      if (parent.get)
      {
         var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
         if (o != null)
         {
            loadSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>, o.<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>);
            var values = o.<%= SegmentConstants.ELEMENT_ACCOUNTS %>;
/*d67155:del*/ //  var currentSelected = 0;
/*d67155:del*/ //  var currentAvailable = 0;
/*d67155:del*/ //  for (var i=0; i<allAccounts.length; i++)
/*d67155:del*/ //  {
/*d67155:del*/ //     var found = false;
               for (var j=0; j<values.length; j++)
               {
/*d67155:del*/ //  if (allAccounts[i] == values[j])
/*d67155:del*/ //  {
/*d67155:del*/ //    <%= SegmentConstants.ELEMENT_ACCOUNTS %>.options[currentSelected] = new Option(allAccounts[i], allAccounts[i]);
/*d67155:add*/       <%=SegmentConstants.ELEMENT_ACCOUNTS%>.options[j] = new Option(values[j], values[j]);
/*d67155:del*/ //    currentSelected++;
/*d67155:del*/ //    found = true;
/*d67155:del*/ //    break;
/*d67155:del*/ //  }
               }
/*d67155:del*/ //  if (!found)
/*d67155:del*/ //  {
/*d67155:del*/ //    availableAccounts.options[currentAvailable] = new Option(allAccounts[i], allAccounts[i]);
/*d67155:del*/ //    currentAvailable++;
/*d67155:del*/ //  }
/*d67155:del*/ //  }
         }
/*d67155:chg*/ initializeSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNTS %>, removeFromAccountsSloshBucketButton, LUS_SearchResultListBox, addToAccountsSloshBucketButton);

      }
      showAccounts();
      <%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>.focus();
   }
}

function saveAccounts () {
   with (document.segmentForm) {
      if (parent.get) {
         var o = parent.get("<%= SegmentConstants.ELEMENT_SEGMENT_DETAILS %>", null);
         if (o != null) {
            o.<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %> = getSelectValue(<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>);
            var values = new Array();
            for (var i=0; i < <%= SegmentConstants.ELEMENT_ACCOUNTS %>.length; i++) {
               values[i] = <%= SegmentConstants.ELEMENT_ACCOUNTS %>.options[i].value;
            }
            o.<%= SegmentConstants.ELEMENT_ACCOUNTS %> = values;
         }
      }
   }
}

function addToSelectedAccounts () {
   with (document.segmentForm) {
/*d67155:chg*/ my_move(LUS_SearchResultListBox, <%= SegmentConstants.ELEMENT_ACCOUNTS %>, "addTo");
/*d67155:chg*/ updateSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNTS %>, addToAccountsSloshBucketButton, LUS_SearchResultListBox, removeFromAccountsSloshBucketButton);
   }
}

function removeFromSelectedAccounts () {
   with (document.segmentForm) {
/*d67155:chg*/ my_move(<%= SegmentConstants.ELEMENT_ACCOUNTS %>, LUS_SearchResultListBox, "removeFrom");
/*d67155:chg*/ updateSloshBuckets(<%= SegmentConstants.ELEMENT_ACCOUNTS %>, removeFromAccountsSloshBucketButton, LUS_SearchResultListBox, addToAccountsSloshBucketButton);
   }
}
//-->
</script>


<!-- /*d67155:add-begin*/ -->
<!-- ******************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
<!-- ******************************************************************** -->
<script>

/////////////////////////////////////////////////////////////////////////////
// Function: LUS_Setup
// Desc.   : Register the GUI parts to the LUS Widget object instance
/////////////////////////////////////////////////////////////////////////////
function LUS_Setup()
{
   lusWidget = new LUS_LookUpSelectionWidget
                     ('segmentForm',
                      'LUS_SearchTextField',
                      'LUS_CriteriaDropDown',
                      'LUS_QuickTextEntry',
                      'LUS_SearchResultListBox',
                      'LUS_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String)resources.get("LUS_Label_statusLine")) %> ');

   LUS_DataFrameInitialization();

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_DataFrameInitialization
// Desc.   : Initialize the data frame for performing search action
/////////////////////////////////////////////////////////////////////////////
function LUS_DataFrameInitialization()
{
   var searchType   = 0;  // search all
   var searchString = ""; // wildcard search

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%= (String)resources.get("LUS_MaxNumOfResultForAccountSearch") %>";

   // Construct the IFRAME as the data frame for getting the search result
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var dataFrame  = "<iframe name='AccountsPanel_dataFrame' "
                         + "title='LUS hidden data frame' "
                         + "id='AccountsPanel_dataFrame' "
                         + "onLoad='LUS_ProcessDataFrameSearchResults()' "
                         + "width='0' height='0' "
                         + "src='" + webAppPath + "CSRSearchForAccountsView?"
                         + queryString
                         + "'></iframe>";

   // Execute the data fream to perform the search
   document.write(dataFrame);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_ProcessDataFrameSearchResults
// Desc.   : Process the search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////
var LUS_isDataFrameInitialized=false;
function LUS_ProcessDataFrameSearchResults()
{
   top.showProgressIndicator(false);
   var resultCondition = AccountsPanel_dataFrame.getSearchResultCondition();
   // Possible search result conditions:
   //    '0' - no match found
   //    '1' - match found within max. threshold
   //    '2' - match found exceeding max. threshold

   //-------------------------------------------------
   // Handle the first time of this page being loaded
   //-------------------------------------------------
   if (LUS_isDataFrameInitialized==false)
   {
      // Toggle ON to skip this block for all subsequent calls
      LUS_isDataFrameInitialized=true;

      if (resultCondition=='1')
      {
         // Re-wiring the data frame's result to LUS widget
         // and display the results in the resulting list box
         // and update the currently showing status line.
         lusWidget.LUS_setResultingList(AccountsPanel_dataFrame.getAccountNameList(),
                                        AccountsPanel_dataFrame.getAccountIdList());
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='2')
      {
         // Too many entries, show msg in widget to let user type account name to search
         lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)resources.get("LUS_Label_keywordDefaultText")) %> ', true);
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='0')
      {
         // No entries avaliable in system, disable the widget
         lusWidget.LUS_disableAll();
      }

      return;

   }//end-if (LUS_isDataFrameInitialized==false)


   //----------------------------------------------------------
   // Process the search resulting data for various conditions
   //----------------------------------------------------------
   var msg = "";
   if (resultCondition=='0')
   {
      // No entries avaliable in system, disable the widget
      msg = "<%= UIUtil.toJavaScript((String)resources.get("LUS_Msg_NotFound")) %>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
      // Too many entries
      msg = "<%= UIUtil.toJavaScript((String)resources.get("LUS_Msg_TooManyFound")) %>";
      var thresholdValue = new Number('<%= (String)resources.get("LUS_MaxNumOfResultForAccountSearch") %>');
      if (isNaN(thresholdValue))
      {
         msg = msg.replace(/%1/, '100'); //default to 100 if invalid value
      }
      else
      {
         msg = msg.replace(/%1/, thresholdValue.toString());
      }
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='1')
   {
      // Re-wiring the data frame's result to LUS widget
      // and display the results in the resulting list box
      // and update the currently showing status line.

      lusWidget.LUS_setResultingList(AccountsPanel_dataFrame.getAccountNameList(),
                                     AccountsPanel_dataFrame.getAccountIdList());
      lusWidget.LUS_refreshCurrentlyShown();
   }

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_FindAction
// Desc.   : This triggers the search action in the data frame
/////////////////////////////////////////////////////////////////////////////
function LUS_FindAction()
{
   lusWidget.LUS_clearComboBox();
   lusWidget.LUS_refreshCurrentlyShown();

   var searchType   = lusWidget.LUS_getSelectedCriteria();
   var searchString = lusWidget.LUS_getSearchKeyword();

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%= (String)resources.get("LUS_MaxNumOfResultForAccountSearch") %>";

   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var newURL     = webAppPath + 'CSRSearchForAccountsView?' + queryString;

   top.showProgressIndicator(true);
   AccountsPanel_dataFrame.location.replace(newURL);

}//end-function


</script>
<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->
<!-- /*d67155:add-end*/ -->


<p><label for="<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNTS_PANEL_TITLE) %></label><br>
<select name="<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>" id="<%= SegmentConstants.ELEMENT_ACCOUNTS_OP %>" onChange="showAccounts()">
   <option value="<%= SegmentConstants.VALUE_DO_NOT_USE %>"><%= segmentsRB.get(SegmentConstants.MSG_DO_NOT_USE_ACCOUNTS) %></option>
   <option value="<%= SegmentConstants.VALUE_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNTS_ONE_OF) %></option>
   <option value="<%= SegmentConstants.VALUE_NOT_ONE_OF %>"><%= segmentsRB.get(SegmentConstants.MSG_ACCOUNTS_NOT_ONE_OF) %></option>
</select>

<div id="accountsDiv" style="display: none; margin-left: 20">
<table border="0">
   <tr>
      <td width="160"></td>
      <td width="70"></td>
      <td width="10"></td>
      <td width="160"></td>
   </tr>
   <tr>
      <td valign="top">
<!-- /*d67155:add*/ --> <br><br>
         <label for="<%= SegmentConstants.ELEMENT_ACCOUNTS %>"><%= segmentsRB.get(SegmentConstants.MSG_SELECTED_ACCOUNTS_PROMPT) %></label><br>
         <select name="<%= SegmentConstants.ELEMENT_ACCOUNTS %>"
         	id="<%= SegmentConstants.ELEMENT_ACCOUNTS %>"
            tabindex="1"
            class="selectWidth"
            size="5"
            multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.removeFromAccountsSloshBucketButton, document.segmentForm.LUS_SearchResultListBox, document.segmentForm.addToAccountsSloshBucketButton);">
         </select>
      </td>
      <td>
         <br>
<!-- /*d67155:chg*/ --> <input type="button" class="button" tabindex="4" name="addToAccountsSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_ADD_BUTTON) %>  " onClick="addToSelectedAccounts()">
         <br>
<!-- /*d67155:chg*/ --> <input type="button" class="button" tabindex="2" name="removeFromAccountsSloshBucketButton" value="  <%= segmentsRB.get(SegmentConstants.MSG_ACCOUNT_REMOVE_BUTTON) %>  " onClick="removeFromSelectedAccounts()">
      </td>
      <td width="20"></td>
      <td valign="top">
<!-- /*d67155:del-begin*/
         <label for="availableAccounts"><%= segmentsRB.get(SegmentConstants.MSG_AVAILABLE_ACCOUNTS_PROMPT) %></label><br>
         <select name="availableAccounts"
         	id="availableAccounts"
            tabindex="3"
            class="selectWidth"
            size="5"
            multiple onChange="javascript:updateSloshBuckets(this, document.segmentForm.addToAccountsSloshBucketButton, document.segmentForm.<%= SegmentConstants.ELEMENT_ACCOUNTS %>, document.segmentForm.removeFromAccountsSloshBucketButton);">
         </select>
/*d67155:del-end*/ -->


<!-- /*d67155:add-begin*/ -->
<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<table>
   <tbody>

      <tr>
         <!---------------------------------------------------------------->
         <!-- Status line showing currently items in the result list box -->
         <!---------------------------------------------------------------->
         <td id="LUS_NumOfCurrentlyShowing" colspan="2"><%= resources.get("LUS_Label_statusLine") %> 0</td>
      </tr>

      <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>


         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SelectAccount"><label for="LUS_SearchResultListBox"><%= resources.get("LUS_Label_selectAccount") %></label><br>
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_QuickNavigation">
                        <label for="LUS_FormInput_QuickTextEntry"></label>
                        <input  name="LUS_QuickTextEntry"
                                type="text"
                                size="20"
                                class="LUS_CSS_QuickTextEntryWidth"
                                onKeyUp="javascript:lusWidget.LUS_autoNavigate();"
                                id="LUS_FormInput_QuickTextEntry"><br>
                        <select name="LUS_SearchResultListBox" id="LUS_SearchResultListBox" size="4"
                                onChange="javascript:updateSloshBuckets(this, document.segmentForm.addToAccountsSloshBucketButton, document.segmentForm.<%=SegmentConstants.ELEMENT_ACCOUNTS%>, document.segmentForm.removeFromAccountsSloshBucketButton);"
                                class="LUS_CSS_ResultListBoxWidth"
                                multiple >
                        </select>
                        <br>
                     </td>
                  </tr>
                  <tr>
                     <td id="LUS_TableCell_Null"></td>
                  </tr>
               </tbody>
            </table>
         </td>

         <!--------------------------------------------------------------->
         <!-- Keyword field, criteria drop down, & search action button -->
         <!--------------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SearchAccount"><label for="LUS_CriteriaDropDown"><%= resources.get("LUS_Label_searchAccount") %></label><br>
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch">
                        <label for="LUS_SearchTextField"></label>
                        <input  name="LUS_SearchTextField"
                        		id="LUS_SearchTextField"
                                type="text"
                                size="20"
                                class="LUS_CSS_KeywordEntryWidth" ><br>
                        <select name="LUS_CriteriaDropDown" id="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth" >
                           <option value="1"><%= resources.get("LUS_SearchType1") %></option>
                           <option value="2"><%= resources.get("LUS_SearchType2") %></option>
                           <option value="3"><%= resources.get("LUS_SearchType3") %></option>
                           <option value="4"><%= resources.get("LUS_SearchType4") %></option>
                           <option value="5"><%= resources.get("LUS_SearchType5") %></option>
                        </select><br><br>
                     </td>
                  </tr>
                  <tr>
                     <td align="right" id="LUS_FormInput_FindAction">
                        <button name="LUS_ActionButton" class="general" onClick="javascript:LUS_FindAction();"><%= resources.get("LUS_Label_findButton") %></button><br>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>


      </tr> <!-- Building GUI Body Parts End ------------------------------->

   </tbody>
</table>

<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope END HERE           ***** -->
<!-- ******************************************************************** -->
<!-- /*d67155:add-end*/ -->


      </td>
   </tr>
</table>
</div>

<!-- /*d67155:add-begin*/ -->
<!-- Initialize the LUS Widget -->
<script>
   LUS_Setup();
</script>
<!-- /*d67155:add-end*/ -->

