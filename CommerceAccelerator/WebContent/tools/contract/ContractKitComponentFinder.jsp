<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
  ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page language="java"
   import="com.ibm.commerce.tools.util.UIUtil,
      com.ibm.commerce.command.CommandFactory,
      com.ibm.commerce.beans.DataBeanManager,
      com.ibm.commerce.datatype.TypedProperty,
      com.ibm.commerce.tools.contract.beans.AccountListDataBean,
      com.ibm.commerce.tools.contract.beans.AccountDataBean,
      com.ibm.commerce.user.beans.OrganizationDataBean,
      java.util.Enumeration,
      com.ibm.commerce.usermanagement.commands.ECUserConstants,
      com.ibm.commerce.user.objects.MemberGroupAccessBean,
      com.ibm.commerce.user.objects.MemberGroupMemberAccessBean,
      com.ibm.commerce.usermanagement.commands.ListBusinessOrgEntityCmd" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<html>

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

 <title><%= contractsRB.get("KCF_Title") %></title>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Vector.js">
</script>
 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

 <script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Account.js">
</script>

<!----------------------------------------------->
<!-- Define the CSS for the Finder's GUI parts -->
<!----------------------------------------------->
<style type='text/css'>
.KCF_CSS_QuickTextEntryWidth {width: 450px;}
.KCF_CSS_ResultListBoxWidth  {width: 450px;}
.KCF_CSS_KeywordEntryWidth   {width: 180px;}
.KCF_CSS_CriteriaListWidth   {width: auto; }
</style>

<!-------------------------------------------->
<!-- Import the LUS Widget Model javascript -->
<!-------------------------------------------->
<script language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>



<!-- ******************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
<!-- ******************************************************************** -->
<script>

/////////////////////////////////////////////////////////////////////////////
// Function: KCF_Setup
// Desc.   : Register the GUI parts to the LUS Widget object instance
/////////////////////////////////////////////////////////////////////////////
function KCF_Setup()
{
   lusWidget = new LUS_LookUpSelectionWidget
                     ('kitComponentFinderForm',
                      'KCF_SearchTextField',
                      'KCF_CriteriaDropDown',
                      'KCF_QuickTextEntry',
                      'KCF_SearchResultListBox',
                      'KCF_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String)contractsRB.get("KCF_Label_statusLine")) %> ');

   KCF_DataFrameInitialization();

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: KCF_DataFrameInitialization
// Desc.   : Initialize the data frame for performing search action
/////////////////////////////////////////////////////////////////////////////
function KCF_DataFrameInitialization()
{
//   var searchType   = -1;  // default to perform no search
   var searchType   = 0;  // default to search all
   var searchString = "";  // default to wildcard search

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%= (String)contractsRB.get("KCF_MaxNumOfResultForKitComponentSearch") %>";

   // Construct the IFRAME as the data frame for getting the search result
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var dataFrame = "<iframe name='SearchForCatEntry_dataFrame' "
                         + "id='SearchForCatEntry_dataFrame' "
                         + "onLoad='KCF_ProcessDataFrameSearchResults()' "
                         + "width='0' height='0' "
                         + "src='" + webAppPath + "SearchForCatEntryView?"
                         + queryString
                         + "' title='SearchForCatEntry_dataFrame'></iframe>";

   // Execute the data fream to perform the search
   top.showProgressIndicator(true);
   document.write(dataFrame);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: KCF_ProcessDataFrameSearchResults
// Desc.   : Process the search results from the data frame. This is a
//           call-back method invoking from the data frame after the frame
//           is loaded
/////////////////////////////////////////////////////////////////////////////
var KCF_isDataFrameInitialized=false;
function KCF_ProcessDataFrameSearchResults()
{
   top.showProgressIndicator(false);
   var resultCondition = SearchForCatEntry_dataFrame.getSearchResultCondition();
   // Possible search result conditions:
   //    '0' - no match found
   //    '1' - match found within max. threshold
   //    '2' - match found exceeding max. threshold

   //-------------------------------------------------
   // Handle the first time of this page being loaded
   //-------------------------------------------------
   if (KCF_isDataFrameInitialized==false)
   {
      // Toggle ON to skip this block for all subsequent calls
      KCF_isDataFrameInitialized=true;

      if (resultCondition=='1')
      {
         // Re-wiring the data frame's result to LUS widget
         // and display the results in the resulting list box
         // and update the currently showing status line.
         lusWidget.LUS_setResultingList(SearchForCatEntry_dataFrame.getResultNameList(),
                                        SearchForCatEntry_dataFrame.getResultIdList());
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='2')
      {
         // Too many entries, show msg in widget to let user type org name to search
         lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)contractsRB.get("KCF_Label_keywordDefaultText")) %> ', true);
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='0')
      {
         // No entries avaliable in system
         //lusWidget.LUS_disableAll();
         //kitComponentFinderForm.LUS_ActionButton.disabled=true;
      }

      return;

   }//end-if (KCF_isDataFrameInitialized==false)


   //----------------------------------------------------------
   // Process the search resulting data for various conditions
   //----------------------------------------------------------
   var msg = "";
   if (resultCondition=='0')
   {
      // No entries avaliable in system
      msg = "<%= UIUtil.toJavaScript((String)contractsRB.get("KCF_Msg_NotFound")) %>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
      // Too many entries
      msg = "<%= UIUtil.toJavaScript((String)contractsRB.get("KCF_Msg_TooManyFound")) %>";
      var thresholdValue = new Number('<%= (String)contractsRB.get("KCF_MaxNumOfResultForBuzOrgEntitySearch") %>');
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

      lusWidget.LUS_setResultingList(SearchForCatEntry_dataFrame.getResultNameList(),
                                     SearchForCatEntry_dataFrame.getResultIdList());
      lusWidget.LUS_refreshCurrentlyShown();
   }

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: KCF_FindAction
// Desc.   : This triggers the search action in the data frame
/////////////////////////////////////////////////////////////////////////////
function KCF_FindAction()
{
   lusWidget.LUS_clearComboBox();
   lusWidget.LUS_refreshCurrentlyShown();

   var searchType   = lusWidget.LUS_getSelectedCriteria();
   var searchString = lusWidget.LUS_getSearchKeyword();

   // Building the search parameter as a query string
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%= (String)contractsRB.get("KCF_MaxNumOfResultForKitComponentSearch") %>";

   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var newURL     = webAppPath + 'SearchForCatEntryView?' + queryString;

   // Perform backend searching
   top.showProgressIndicator(true);
   SearchForCatEntry_dataFrame.location.replace(newURL);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: KCF_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           the expected form's field.
/////////////////////////////////////////////////////////////////////////////
function KCF_SelectResultItem()
{

}



/////////////////////////////////////////////////////////////////////////////
// Function: KCF_OKAction
// Desc.   : It passes all the user selected items to the invoker
/////////////////////////////////////////////////////////////////////////////
function KCF_OKAction()
{
   var selectedID   = lusWidget.LUS_getSelectedResults();
   var selectedName = lusWidget.LUS_getSelectedResultNames();
   var skuList      = SearchForCatEntry_dataFrame.getResultSKUList();
   var selectedSKU  = new Array();

   var count=0;
   for (var i=0; i < document.kitComponentFinderForm.KCF_SearchResultListBox.options.length; i++)
   {
      if (document.kitComponentFinderForm.KCF_SearchResultListBox.options[i].selected)
      {
         selectedSKU[count] = skuList[i];
         count++;
      }
   }

   /*
   alert("IDs=" + selectedID);
   alert("Names=" + selectedName);
   alert("SKUs=" + selectedSKU);
   */

   parent.document.getElementById("kitComponentFinderIframe").style.visibility = "hidden";
   lusWidget.LUS_clearComboBox();
   lusWidget.LUS_refreshCurrentlyShown();
   parent.callbackFromFinder(selectedID, selectedName, selectedSKU);
}


/////////////////////////////////////////////////////////////////////////////
// Function: KCF_CancelAction
// Desc.   : It returns to the invoker
/////////////////////////////////////////////////////////////////////////////
function KCF_CancelAction()
{
   parent.document.getElementById("kitComponentFinderIframe").style.visibility = "hidden";
   lusWidget.LUS_clearComboBox();
   lusWidget.LUS_refreshCurrentlyShown();
}




</script>
<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->

</head>

<body onload="" class="content">

<h1><%= contractsRB.get("KCF_Title") %></h1>

<form NAME="kitComponentFinderForm" id="kitComponentFinderForm">

<table border="0" id="KCF_Table_1">


<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<input type="hidden" name="KitComp_Name">
<input type="hidden" name="KitComp_ID">

      <tr>
         <!---------------------------------------------------------------->
         <!-- Status line showing currently items in the result list box -->
         <!---------------------------------------------------------------->
         <td id="KCF_NumOfCurrentlyShowing" colspan="2"><%= contractsRB.get("KCF_Label_statusLine") %> 0</td>
      </tr>

      <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>

         <!--------------------------------------------------------------->
         <!-- Keyword field, criteria drop down, & search action button -->
         <!--------------------------------------------------------------->
         <td valign="top" id="KCF_TableCell_SearchComp"><%= contractsRB.get("KCF_Label_searchComponent") %><br>
            <table border="0">
               <tbody>
                  <tr>
                     <td id="KCF_TableCell_KeywordSearch">
                        <label for="KCF_SearchTextField1">
                        <input  name="KCF_SearchTextField"
                                type="text"
                                size="20"
                                tabindex="1"
                                class="KCF_CSS_KeywordEntryWidth"
                                id='KCF_SearchTextField1'><br></label>
                        <label for="KCF_CriteriaDropDown1">
                        <select name="KCF_CriteriaDropDown"
                                class="KCF_CSS_CriteriaListWidth"
                                tabindex="2"
                                id='KCF_CriteriaDropDown1'>
                           <option value="2"><%= contractsRB.get("KCF_SearchType2") %></option>
                           <option value="4"><%= contractsRB.get("KCF_SearchType4") %></option>
                           <option value="5"><%= contractsRB.get("KCF_SearchType5") %></option>
                        </select><br><br></label>
                     </td>
                  </tr>
                  <tr>
                     <td align="left" id="KCF_FormInput_FindAction">
                        <button name="KCF_ActionButton" class="general" tabindex="3" onClick="javascript:KCF_FindAction();"><%= contractsRB.get("KCF_Label_findButton") %></button><br>
                     </td>
                  </tr>
               </tbody>
            </table>
         </td>

         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="KCF_TableCell_SelectComp"><%= contractsRB.get("KCF_Label_selectComponent") %><br>
            <table border="0">
               <tbody>
                  <tr>
                     <td id="KCF_TableCell_QuickNavigation">
                        <label for="KCF_FormInput_QuickTextEntry">
                        <input  name="KCF_QuickTextEntry"
                                type="text"
                                size="20"
                                tabindex="4"
                                class="KCF_CSS_QuickTextEntryWidth"
                                onKeyUp="javascript:lusWidget.LUS_autoNavigate();"
                                id="KCF_FormInput_QuickTextEntry"><br></label>
                        <label for="KCF_SearchResultListBox1">
                        <select name="KCF_SearchResultListBox" size="4"
                                onChange="javascript:KCF_SelectResultItem();"
                                tabindex="5"
                                class="KCF_CSS_ResultListBoxWidth"
                                multiple
                                id='KCF_SearchResultListBox1'>
                        </select></label>
                        <br>
                     </td>
                  </tr>

                  <tr>
                     <table border="0">
                        <tbody>
                           <tr>
                              <td id="KCF_FormInput_OKAction">
                                 <button name="KCF_OKButton" class="general" tabindex="6" onClick="javascript:KCF_OKAction();"><%= contractsRB.get("ok") %></button><br>
                              </td>
                              <td id="KCF_FormInput_CancelAction">
                                 <button name="KCF_CancelButton" class="general" tabindex="7" onClick="javascript:KCF_CancelAction();"><%= contractsRB.get("cancel") %></button><br>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </tr>

               </tbody>
            </table>
         </td>

      </tr> <!-- Building GUI Body Parts End ------------------------------->



<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope END HERE           ***** -->
<!-- ******************************************************************** -->

</table>

</form>

<script>
   KCF_Setup();
</script>

</body>
</html>

