<!--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2005, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
-->

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../common/common.jsp" %>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContext.getLocale();
    Hashtable adminConsoleRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", jLocale );
%>

<!-------------------------------------------->
<!-- Import the LUS Widget Model javascript -->  
<!-------------------------------------------->
<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>

<!-- ******************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
<!-- ******************************************************************** -->
<script type="text/javascript" >
<!---- hide script from old browsers
/////////////////////////////////////////////////////////////////////////////
// Function: LUS_Setup
// Desc.   : Register the GUI parts to the LUS Widget object instance
/////////////////////////////////////////////////////////////////////////////
function LUS_Setup()
{
   top.showProgressIndicator(true);
   lusWidget = new LUS_LookUpSelectionWidget
                     ('entryForm',
                      'LUS_SearchTextField',
                      'LUS_CriteriaDropDown',
                      'LUS_QuickTextEntry',
                      'parentMemberId',
                      'LUS_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String)adminConsoleRB.get("LUS_Label_statusLineACOrg")) %> ');
 
   LUS_DataFrameInitialization();
   
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_DataFrameInitialization
// Desc.   : Initialize the data frame for performing search action
/////////////////////////////////////////////////////////////////////////////
function LUS_DataFrameInitialization()
{  

   var searchType   = 0;  // default to search all
   var searchString = ""; // default to wildcard search

   // Building the search parameter as a query string
   var queryString = "taskName=ManageExcludingAD"
   		   + "&searchType="    + searchType
                   + "&adminId=" + <%= cmdContext.getUserId() %>
                   + "&searchString=" + searchString
                   + "&returningUserCriteria=1"
                   + "&maxThreshold=" + "<%= UIUtil.toJavaScript((String)adminConsoleRB.get("LUS_MaxNumOfResultForACSearch")) %>"
                   + "&firstLoad=1";
 
   // Construct the IFRAME as the data frame for getting the search result
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var dataFrame = "<iframe name='SearchForOrgsICanAdmin_dataFrame' "
                         + "id='SearchForOrgsICanAdmin_dataFrame' "
                      // + "onLoad='LUS_ProcessDataFrameSearchResults()' "
                         + "width='0' height='0' "
                         + "src='" + webAppPath + "OASearchForOrgsICanAdminView?"
                         + queryString
                         + "' title=''></iframe>";

   // Execute the data fream to perform the search
   document.write(dataFrame);
 	        
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_ProcessDataFrameSearchResults
// Desc.   : Process the search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////
var LUS_isOrgsDataFrameInitialized=false;

function LUS_ProcessDataFrameSearchResults()
{
  top.showProgressIndicator(false);

   var resultCondition = SearchForOrgsICanAdmin_dataFrame.getSearchResultCondition();
  
       // Possible search result conditions:
       //    '0' - no match found
       //    '1' - match found within max. threshold
       //    '2' - match found exceeding max. threshold
   
   if (LUS_isOrgsDataFrameInitialized==false)
      {
         // Toggle ON to skip this block for all subsequent calls
         LUS_isOrgsDataFrameInitialized=true;
   
         if (resultCondition=='1')
         {
            // Re-wiring the data frame's result to LUS widget
            // and display the results in the resulting list box
            // and update the currently showing status line.      
            lusWidget.LUS_setResultingList(SearchForOrgsICanAdmin_dataFrame.getOrgNameList(),
                                           SearchForOrgsICanAdmin_dataFrame.getOrgIdList());
         }
         else if (resultCondition=='2')
         {
            // Too many entries, show msg in widget to let user type account name to search
            lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)adminConsoleRB.get("LUS_Label_keywordDefaultTextOrgs")) %> ', true);
        }
         else if (resultCondition=='0')
         {
            // No entries avaliable in system, disable the widget
            lusWidget.LUS_disableAll();
         }
   
        return;
   
   }//end-if (LUS_isOrgsDataFrameInitialized==false)
  
  
   //----------------------------------------------------------
   // Process the search resulting data for various conditions
   //----------------------------------------------------------
   var msg = "";
   if (resultCondition=='0')
   {
      // No entries avaliable in system, disable the widget
      msg = "<%= UIUtil.toJavaScript((String)adminConsoleRB.get("LUS_ACMsg_NotFound")) %>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
      // Too many entries
      msg = "<%= UIUtil.toJavaScript((String)adminConsoleRB.get("LUS_ACMsg_TooManyFound")) %>";
      var thresholdValue = new Number('<%= (String)adminConsoleRB.get("LUS_MaxNumOfResultForACSearch") %>');
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
     	lusWidget.LUS_setResultingList(SearchForOrgsICanAdmin_dataFrame.getOrgNameList(),
                                           SearchForOrgsICanAdmin_dataFrame.getOrgIdList());
  
   }
}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_FindAction
// Desc.   : This triggers the search action in the data frame
/////////////////////////////////////////////////////////////////////////////
function LUS_FindAction()
{  
   var searchType   = lusWidget.LUS_getSelectedCriteria();
   var searchString = lusWidget.LUS_getSearchKeyword();

   // Building the search parameter as a query string
   var queryString = "taskName=ManageExcludingAD"
   		   + "&searchType="    + searchType
   		   + "&adminId=" + <%= cmdContext.getUserId() %>
                   + "&searchString=" + searchString
                   + "&returningUserCriteria=1"
                   + "&maxThreshold=" + "<%= (String)adminConsoleRB.get("LUS_MaxNumOfResultForACSearch") %>";
                   
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   
   var newURL = webAppPath + 'OASearchForOrgsICanAdminView?' + queryString;
   top.showProgressIndicator(true);
   SearchForOrgsICanAdmin_dataFrame.location.replace(newURL);
 	  
}//end-function

/////////////////////////////////////////////////////////////////////////////
// Function: LUS_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           trigger an action to retrieve a list of roles
/////////////////////////////////////////////////////////////////////////////
function LUS_SelectResultItem()
{
   var text = lusWidget.LUS_getSelectedResultNames();
   document.entryForm.LUS_QuickTextEntry.value = text[0];
}

//-->
</script>

<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->

<script type="text/javascript" >
<!---- hide script from old browsers
/////////////////////////////////////////////////////////////////////////////
// Function: validateParentOrg
// Desc.   : make sure an organization is selected
/////////////////////////////////////////////////////////////////////////////
function validateParentOrg()
{
	if (document.entryForm.parentMemberId.selectedIndex < 0) {
		return false;
	} else {
		return true;
	}
}
//-->
</script>

<style type='text/css'>
<!-------------------------------------------->
<!-- Define the CSS for the LUS's GUI parts -->
<!-------------------------------------------->
.LUS_CSS_QuickTextEntryWidth {width: 600px;}
.LUS_CSS_ResultListBoxWidth  {width: 600px;}
.LUS_CSS_KeywordEntryWidth   {width: 200px;}
.LUS_CSS_CriteriaListWidth   {width: auto; }
</style>

<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<table id='LUS_table'>
   <tbody>    
     <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>
     	 <td valign="top" id="LUS_TableCell_SelectText"><label for="LUS_FormInput_QuickTextEntry"><%= UIUtil.toHTML( (String)adminConsoleRB.get("orgSelectParentOrg") ) %></label></td>
         <td valign="top" id="LUS_TableCell_SearchText"><label for="LUS_SearchTextField1"><%= UIUtil.toHTML( (String)adminConsoleRB.get("orgSearchParentOrg") ) %></label></td>
      </tr>
      <tr>
         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_Select">
         <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_QuickNavigation">
                        <input  name="LUS_QuickTextEntry"
                                type="text"
                                size="30"
                                class="LUS_CSS_QuickTextEntryWidth"
                                onkeyup="javascript:lusWidget.LUS_autoNavigate();"
                                id="LUS_FormInput_QuickTextEntry" /><br />
                        <label for="LUS_SearchResultListBox1" class="hidden-label"><%= UIUtil.toHTML( (String)adminConsoleRB.get("SelectSearchResult") ) %></label>
                        <select name="parentMemberId" size="4"
                                onChange="javascript:LUS_SelectResultItem();"
                                class="LUS_CSS_ResultListBoxWidth"
                                single id='LUS_SearchResultListBox1'>
                        </select>
                        <br />
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
         <td valign="top" id="LUS_TableCell_Search">
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch">
                        <input  name="LUS_SearchTextField"
                                type="text"
                                size="30"
                                class="LUS_CSS_KeywordEntryWidth" 
                                id="LUS_SearchTextField1" /><br /> 

                        <label for="LUS_CriteriaDropDown1" class="hidden-label"><%= UIUtil.toHTML( (String)adminConsoleRB.get("SearchOptions") ) %></label>                                
                        <select name="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth" 
                                id="LUS_CriteriaDropDown1">
                           <option value="1"><%= UIUtil.toHTML( (String)adminConsoleRB.get("LUS_ACSearchType1") ) %></option>
                           <option value="2"><%= UIUtil.toHTML( (String)adminConsoleRB.get("LUS_ACSearchType2") ) %></option>
                           <option value="3"><%= UIUtil.toHTML( (String)adminConsoleRB.get("LUS_ACSearchType3") ) %></option>
                           <option value="4"><%= UIUtil.toHTML( (String)adminConsoleRB.get("LUS_ACSearchType4") ) %></option>
                           <option value="5"><%= UIUtil.toHTML( (String)adminConsoleRB.get("LUS_ACSearchType5") ) %></option>
                        </select><br /><br />
                     </td>
                  </tr>
                  <tr>
                     <td align="right" id="LUS_FormInput_FindAction">
                        <button name="LUS_ActionButton" class="general" onclick="javascript:LUS_FindAction();"><%= UIUtil.toHTML( (String)adminConsoleRB.get("find") ) %></button><br />
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>


      </tr> <!-- Building GUI Body Parts End ------------------------------->

   </tbody>
</table>

<script language="JavaScript">
<!---- hide script from old browsers
   LUS_Setup();
//-->
</script>

<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope FINISH HERE         ***** -->
<!-- ******************************************************************** -->
