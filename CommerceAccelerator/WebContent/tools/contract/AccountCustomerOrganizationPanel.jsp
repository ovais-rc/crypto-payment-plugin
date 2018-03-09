<!--==========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2006, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
  ===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 

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

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
 <%= fHeader %>
 <style type='text/css'>
 .selectWidth {width: 200px;}

</style>
 <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css" />

 <title><%= contractsRB.get("accountCustomerOrganizationDisplay") %></title>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/FieldEntryUtil.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/Vector.js">
</script>
 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/ConvertToXML.js">
</script>

 <script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/contract/Account.js">
</script>

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
<script type="text/javascript" language="JavaScript" src="/wcs/javascript/tools/common/LUSWidgetModel.js"></script>


 <script type="text/javascript" language="JavaScript">

  // This function detect if the panel has been load before
  function loadPanelData()
  {
    if (parent.parent.get)
    {
       var hereBefore = parent.parent.get("AccountCustomerModelLoaded", null);

       if (hereBefore != null)
       {

          // have been to this page before - load from the model
          var o = parent.parent.get("AccountCustomerModel", null);
          if (o != null)
          {
             // Display the selected organization name
             DisplayCustomerOrgName(o.accountName);

             // Initialize the previously selected org info
             document.orgForm.BuzOrg_ID.value = o.org;
             document.orgForm.BuzOrg_Name.value = o.accountName;

             /*78166:del*/ //organizationChange(o.org);
             parent.contactSelectionBody.location.replace("AccountCustomerContactSelectionPanelView?OrgId=" + o.org + "&ContactId=" + o.contact);

             // handle error messages back from the validate page
             if (parent.parent.get("accountCustomerOrgRequired", false))
             {
                 parent.parent.remove("accountCustomerOrgRequired");
                 alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountCustomerOrgRequired"))%>");
             }
             else if (parent.parent.get("accountCustomerContactRequired", false))
             {
                 parent.parent.remove("accountCustomerContactRequired");
                 alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountCustomerContactRequired"))%>");
             }
          }//end-if(o != null)
       }
       else
       {
          // load AccountCommonDataModel
          parent.loadCommonDataModel();

          // this is the first time on this page - create the customer model
          var acm = new AccountCustomerModel();
          parent.parent.put("AccountCustomerModel", acm);
          parent.parent.put("AccountCustomerModelLoaded", true);

          // this is the first time on this page - create the representative model
          var arm = new AccountRepresentativeModel();
          parent.parent.put("AccountRepresentativeModel", arm);
          arm.org = "<%=fStoreMemberId%>";

          <%

          try
          {
             OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
             OrgEntityDB.setDataBeanKeyMemberId(fStoreMemberId.toString());
             DataBeanManager.activate(OrgEntityDB, request);
             String DN = (OrgEntityDB.getDistinguishedName().toString()).trim();
          %>
             arm.orgDN = "<%=UIUtil.toJavaScript(DN)%>";
          <%

          }
          catch (Exception e)
          {   }

          %>

          parent.checkForUpdate(acm, arm);
          parent.contactSelectionBody.location.replace("AccountCustomerContactSelectionPanelView?OrgId=" + acm.initialOrg + "&ContactId=" + acm.initialContact);

       }//end-if-else

    }//end-if(parent.parent.get)


    // handle error messages back from the validate page
    if (parent.parent.get("accountExists", false))
    {
      parent.parent.remove("accountExists");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountExists"))%>");
    }
    else if (parent.parent.get("accountMarkForDelete", false))
    {
      parent.parent.remove("accountMarkForDelete");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountMarkedForDeleteError"))%>");
    }
    else if (parent.parent.get("accountHasBeenChanged", false))
    {
      parent.parent.remove("accountHasBeenChanged");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountChanged"))%>");
    }
    else if (parent.parent.get("accountGenericError", false))
    {
      parent.parent.remove("accountGenericError");
      alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountNotSaved"))%>");
    }

  }//end-function




  // This function allows the user select an organization
  function organizationChange(orgId)
  {
    var allOrg;

    allOrg = self.document.orgForm.OrgName;
    for (var i=0; i<allOrg.length; i++)
    {
      if (allOrg.options[i].value == orgId)
      {
         allOrg.selectedIndex = i;
         break;
      }
    }

  }//end-function


</script>


<!-- ******************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
<!-- ******************************************************************** -->
<script type="text/javascript">

/////////////////////////////////////////////////////////////////////////////
// Function: LUS_Setup
// Desc.   : Register the GUI parts to the LUS Widget object instance
/////////////////////////////////////////////////////////////////////////////
function LUS_Setup()
{
   lusWidget = new LUS_LookUpSelectionWidget
                     ('orgForm',
                      'LUS_SearchTextField',
                      'LUS_CriteriaDropDown',
                      'LUS_QuickTextEntry',
                      'LUS_SearchResultListBox',
                      'LUS_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String)contractsRB.get("LUS_Label_statusLine")) %> ');

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
   var queryString = "searchType="    + searchType
                   + "&searchString=" + searchString
                   + "&maxThreshold=" + "<%= (String)contractsRB.get("LUS_MaxNumOfResultForBuzOrgEntitySearch") %>";

   // Construct the IFRAME as the data frame for getting the search result
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var dataFrame = "<iframe name='SearchForBuzOrgEntity_dataFrame' "
                         + "id='SearchForBuzOrgEntity_dataFrame' "
                         + "onload='LUS_ProcessDataFrameSearchResults()' "
                         + "width='0' height='0' "
                         + "src='" + webAppPath + "SearchForBuzOrgEntityView?"
                         + queryString
                         + "' title='SearchForBuzOrgEntity_dataFrame'></iframe>";

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
   var resultCondition = SearchForBuzOrgEntity_dataFrame.getSearchResultCondition();
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
         lusWidget.LUS_setResultingList(SearchForBuzOrgEntity_dataFrame.getBuzOrgEntityNameList(),
                                        SearchForBuzOrgEntity_dataFrame.getBuzOrgEntityIdList());
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='2')
      {
         // Too many entries, show msg in widget to let user type org name to search
         lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)contractsRB.get("LUS_Label_keywordDefaultText")) %> ', true);
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='0')
      {
         // No entries avaliable in system, disable the widget
         lusWidget.LUS_disableAll();
         orgForm.LUS_ActionButton.disabled=true;
      }

      return;

   }//end-if (LUS_isDataFrameInitialized==false)


   //----------------------------------------------------------
   // Process the search resulting data for various conditions
   //----------------------------------------------------------
   var msg = "";
   if (resultCondition=='0')
   {
      // No entries avaliable in system
      msg = "<%= UIUtil.toJavaScript((String)contractsRB.get("LUS_Msg_NotFound")) %>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
      // Too many entries
      msg = "<%= UIUtil.toJavaScript((String)contractsRB.get("LUS_Msg_TooManyFound")) %>";
      var thresholdValue = new Number('<%= UIUtil.toJavaScript((String)contractsRB.get("LUS_MaxNumOfResultForBuzOrgEntitySearch")) %>');
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

      lusWidget.LUS_setResultingList(SearchForBuzOrgEntity_dataFrame.getBuzOrgEntityNameList(),
                                     SearchForBuzOrgEntity_dataFrame.getBuzOrgEntityIdList());
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
                   + "&maxThreshold=" + "<%= (String)contractsRB.get("LUS_MaxNumOfResultForBuzOrgEntitySearch") %>";

   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var newURL     = webAppPath + 'SearchForBuzOrgEntityView?' + queryString;

   // Reset the contact drop down selection list to avoid user to select
   // previous org. contacts from the last search result.
   document.orgForm.BuzOrg_ID.value = "";
   document.orgForm.BuzOrg_Name.value = "";
   DisplayCustomerOrgName("");
   parent.contactSelectionChange();

   // Perform backend searching
   top.showProgressIndicator(true);
   SearchForBuzOrgEntity_dataFrame.location.replace(newURL);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           the expected form's field.
/////////////////////////////////////////////////////////////////////////////
function LUS_SelectResultItem()
{
   var selectedID = lusWidget.LUS_getSelectedResults();
   var selectedName = lusWidget.LUS_getSelectedResultNames();
   document.orgForm.BuzOrg_ID.value = selectedID;
   document.orgForm.BuzOrg_Name.value = selectedName;
   //alert("ID=" + document.orgForm.BuzOrg_ID.value + ", Name=" + document.orgForm.BuzOrg_Name.value);

   // Display the selected organization name
   document.orgForm.LUS_QuickTextEntry.value=selectedName;
   DisplayCustomerOrgName(selectedName);

/*
   // Save the selected organization information
   if (parent.parent.get)
   {
      var o = parent.parent.get("AccountCustomerModel", null);
      if (o != null)
      {
         // Display the selected organization name
         o.accountName = selectedName;
         o.org = selectedID;
      }
   }
*/

   // Refresh the contact selection list
   parent.contactSelectionChange();

}


/////////////////////////////////////////////////////////////////////////////
// Function: DisplayCustomerOrgName
// Desc.   : Display the customer organization name on the panel
/////////////////////////////////////////////////////////////////////////////
function DisplayCustomerOrgName(buzOrgName)
{
   document.all["LUS_SelectedOrgName"].innerText
      = "<%= contractsRB.get("accountCustomerOrganizationPrompt") %>"
      + ": "
      + buzOrgName;
}



</script>
<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->

</head>

<body onload="loadPanelData();" class="content">

<h1><%= contractsRB.get("accountCustomerPanelTitle") %></h1>

<form action="" name="orgForm" id="orgForm">

<table border="0" id="AccountCustomerOrganizationPanel_Table_1">

<!-- /*78166:del-begin*/
 <tr>
  <td valign='top' id="AccountCustomerOrganizationPanel_TableCell_1">
    <label for="AccountCustomerOrganizationPanel_FormInput_OrgName_In_orgForm_1"><%= contractsRB.get("accountCustomerOrganizationPrompt") %></label><br />
    <select name="OrgName" id="AccountCustomerOrganizationPanel_FormInput_OrgName_In_orgForm_1" tabindex="1" size="1" onchange="parent.contactSelectionChange();"></select>
  </td>
 </tr>
/*78166:del-end*/ -->


<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<input type="hidden" name="BuzOrg_Name" />
<input type="hidden" name="BuzOrg_ID" />

      <tr>
         <td id="LUS_SelectedOrgName" colspan="2"><%= contractsRB.get("accountCustomerOrganizationDisplay") %> </td>
      </tr>

      <tr>
         <td id="LUS_TableCell_CR">&nbsp;&nbsp;&nbsp;<br /></td>
      </tr>
      <tr>
         <!---------------------------------------------------------------->
         <!-- Status line showing currently items in the result list box -->
         <!---------------------------------------------------------------->
         <td id="LUS_NumOfCurrentlyShowing" colspan="2"><%= contractsRB.get("LUS_Label_statusLine") %> 0</td>
      </tr>

      <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>


         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SelectOrg"><label for="LUS_FormInput_QuickTextEntry"><label for="LUS_SearchResultListBox1"><%= contractsRB.get("LUS_Label_selectOrg") %></label></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_QuickNavigation">
                        <input  name="LUS_QuickTextEntry"
                                type="text"
                                size="20"
                                tabindex="4"
                                class="LUS_CSS_QuickTextEntryWidth"
                                onkeyup="javascript:lusWidget.LUS_autoNavigate();"
                                id="LUS_FormInput_QuickTextEntry" /><br />
                        <select name="LUS_SearchResultListBox" size="4"
                                onchange="javascript:LUS_SelectResultItem();"
                                tabindex="5"
                                class="LUS_CSS_ResultListBoxWidth"
                                id='LUS_SearchResultListBox1'>
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
         <td valign="top" id="LUS_TableCell_SearchOrg"><label for="LUS_CriteriaDropDown1"><label for="LUS_SearchTextField1"><%= contractsRB.get("LUS_Label_searchOrg") %></label></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch">
                        <input  name="LUS_SearchTextField"
                                type="text"
                                size="20"
                                tabindex="1"
                                class="LUS_CSS_KeywordEntryWidth"
                                id='LUS_SearchTextField1' /><br />
                        <select name="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth"
                                tabindex="2"
                                id='LUS_CriteriaDropDown1'>
                           <option value="1"><%= contractsRB.get("LUS_SearchType1") %></option>
                           <option value="2"><%= contractsRB.get("LUS_SearchType2") %></option>
                           <option value="3"><%= contractsRB.get("LUS_SearchType3") %></option>
                           <option value="4"><%= contractsRB.get("LUS_SearchType4") %></option>
                           <option value="5"><%= contractsRB.get("LUS_SearchType5") %></option>
                        </select><br /><br />
                     </td>
                  </tr>
                  <tr>
                     <td align="right" id="LUS_FormInput_FindAction">
                        <button name="LUS_ActionButton" class="general" tabindex="3" onclick="javascript:LUS_FindAction();"><%= contractsRB.get("LUS_Label_findButton") %></button><br />
                     </td>
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

<script type="text/javascript">
   LUS_Setup();
</script>

</body>
</html>
