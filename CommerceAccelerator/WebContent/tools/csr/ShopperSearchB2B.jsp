<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2001, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.*" %>

<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
try {
   // obtain the resource bundle for display
   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Locale jLocale = cmdContext.getLocale();
   Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", jLocale);
   Hashtable buyAdminConsoleNLS = (Hashtable)ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", jLocale);
   Hashtable formats = (Hashtable)ResourceDirectory.lookup("csr.nlsFormats");
   Hashtable format = (Hashtable)XMLUtil.get(formats, "nlsFormats."+ jLocale.toString());
   if (format == null) {
      format = (Hashtable)XMLUtil.get(formats, "nlsFormats.default");
   }
   String nameOrder = (String)XMLUtil.get(format, "name.order");
	com.ibm.commerce.common.beans.StoreDataBean  store = new com.ibm.commerce.common.beans.StoreDataBean();
    Integer storeId 	= cmdContext.getStoreId();
    store.setStoreId(storeId.toString());
    com.ibm.commerce.beans.DataBeanManager.activate(store, request);

/*d66719:del*/ //   // retrieve store's account list
/*d66719:del*/ //   AccountListDataBean accountBean;
/*d66719:del*/ //   AccountDataBean accountList[] = null;
/*d66719:del*/ //   int numAccounts = 0;
/*d66719:del*/ //   accountBean = new AccountListDataBean();
/*d66719:del*/ //   DataBeanManager.activate(accountBean, request);
/*d66719:del*/ //   accountList = accountBean.getAccountList();
/*d66719:del*/ //   if (accountList != null) {
/*d66719:del*/ //      numAccounts = accountList.length;
/*d66719:del*/ //   }

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<title><%=userNLS.get("custSearch")%></title>
<script type="text/javascript" src="/wcs/javascript/tools/csr/user.js">
</script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>

<!-- /*d66719:add-begin*/ -->
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
<!-- /*d66719:add-end*/ -->



<script type="text/javascript" >
<%@ include file = "CaseSelection.jspf" %>

var dynamicTagCounter = 0;

//---------------------------------------------------------------------
//  Required javascript function for Dialog
//---------------------------------------------------------------------
function savePanelData() {
   debugAlert("savePanelData() ...begin...");
}

function vaildatePanelData() {
   debugAlert("validatePanelData() ...begin...");

   if (isEmpty(document.searchForm.logonid.value)  &&
       isEmpty(document.searchForm.firstName.value)&&
       isEmpty(document.searchForm.lastName.value) &&
       isEmpty(document.searchForm.phone.value)    &&
       isEmpty(document.searchForm.email.value)    &&
       isEmpty(document.searchForm.city.value)     &&
       isEmpty(document.searchForm.zip.value)      &&
       isEmpty(document.searchForm.account.value)     ) {

      alertDialog("<%=UIUtil.toJavaScript((String)userNLS.get("missingSearchCriteria")) %>");
      return false;

   }
   return true;
}

//---------------------------------------------------------------------
//  User defined javascript function
//---------------------------------------------------------------------
function debugAlert(msg) {
// alert("DEBUG: " + msg);
}
function isEmpty(id) {
   return !id.match(/[^\s]/);
}

function loadPanelData() {
   document.searchForm.logonid.focus();
   parent.setContentFrameLoaded(true);
}

function filterAction() {
   debugAlert("filterAction() ...begin...");
   if (vaildatePanelData()) {
      debugAlert("Pass validation ");
      var url = "/webapp/wcs/tools/servlet/NewDynamicListView";
      var urlPara = new Object();
      
	  urlPara.ActionXMLFile='csr.shopperListB2B';

      urlPara.cmd='ShopperListB2B';
      urlPara.listsize='22';
      urlPara.startindex='0';
      urlPara.orderby='LOGONID';
      urlPara.selected='SELECTED';  // Do I need this parameters?
      urlPara.doSearch='YES';       // Do I need this parameters?

      urlPara.logonid   =  document.searchForm.logonid.value;
      urlPara.firstName =  document.searchForm.firstName.value;
      urlPara.lastName  =  document.searchForm.lastName.value;
      urlPara.phone     =  document.searchForm.phone.value;
      urlPara.email     =  document.searchForm.email.value;
      urlPara.city      =  document.searchForm.city.value;
      urlPara.zip       =  document.searchForm.zip.value;
      urlPara.account   =  document.searchForm.account.value;

      urlPara.logonidSearchType = document.searchForm.logonidSearchType.value;
      urlPara.firstNameSearchType = document.searchForm.firstNameSearchType.value;
      urlPara.lastNameSearchType = document.searchForm.lastNameSearchType.value;
      urlPara.phoneSearchType = document.searchForm.phoneSearchType.value;
      urlPara.emailSearchType = document.searchForm.emailSearchType.value;
      urlPara.citySearchType = document.searchForm.citySearchType.value;
      urlPara.zipSearchType = document.searchForm.zipSearchType.value;
      top.setContent("<%= UIUtil.toJavaScript((String)userNLS.get("custSearchResult")) %>",url,true,urlPara);
   }
}

function cancelAction() {
   top.goBack();
}


function getNameOrder() {
   return "<%=nameOrder%>";
}


function displayNameSearchField()
{
   var tempList = getNameOrder();
   var nameOrderList = tempList.split(",");

   for (var i=0; i<nameOrderList.length; i++) {
      if (nameOrderList[i] == "last")
      {
         println("<tr><td id=\'ShopperSearchB2B_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_1\'>");
      println("<%=UIUtil.toJavaScript((String)userNLS.get("lastName"))%><br />");
      println("<label for=\'ShopperSearchB2B_FormInput_lastName"+ dynamicTagCounter +"_"+ i +"\'><span style='display:none;'><%=userNLS.get("lastName")%></span></label>");  
      println("<input size='30' type='text' name='lastName' maxlength='64' id=\'ShopperSearchB2B_FormInput_lastName"+ dynamicTagCounter +"_"+ i +"\' />");
      println("</td><td id=\'ShopperSearchB2B_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_2\'>");
      println("<label for='lastNameSearchType1'><span style='display:none;'><%=userNLS.get("lastName")%></span></label>");
      println("<br /><select name='lastNameSearchType' id='lastNameSearchType1'>");
      displayCaseSelection();
      println("</select>");
      println("</td></tr>");

      }
      else if (nameOrderList[i] == "first")
      {
         println("<tr><td id=\'ShopperSearchB2B_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_1\'>");
         println("<%=UIUtil.toJavaScript((String)userNLS.get("firstName"))%><br />");
         println("<label for=\'ShopperSearchB2B_FormInput_firstName"+ dynamicTagCounter +"_"+ i +"\'><span style='display:none;'><%=userNLS.get("firstName")%></span></label>"); 
         println("<input size='30' type='text' name='firstName' maxlength='64' id=\'ShopperSearchB2B_FormInput_firstName"+ dynamicTagCounter +"_"+ i +"\' />");
         println("</td><td id=\'ShopperSearchB2B_DynamicTableCell_"+ dynamicTagCounter +"_"+ i +"_2\'>");
         println("<label for='firstNameSearchType1'><span style='display:none;'><%=userNLS.get("firstName")%></span></label>");
         println("<br /><select name='firstNameSearchType' id='firstNameSearchType1'>");
      displayCaseSelection();
      println("</select>");
      println("</td></tr>");
      }
   }
   dynamicTagCounter++;
}

</script>


<!-- /*d66719:add-begin*/ -->
<!-- ******************************************************************** -->
<!-- *  START HERE --- Javascript Functions for Wiring the LUS Widget   * -->
<!-- ******************************************************************** -->
<script type="text/javascript" >

/////////////////////////////////////////////////////////////////////////////
// Function: LUS_Setup
// Desc.   : Register the GUI parts to the LUS Widget object instance
/////////////////////////////////////////////////////////////////////////////
function LUS_Setup()
{
   lusWidget = new LUS_LookUpSelectionWidget
                     ('searchForm',
                      'LUS_SearchTextField',
                      'LUS_CriteriaDropDown',
                      'LUS_QuickTextEntry',
                      'LUS_SearchResultListBox',
                      'LUS_NumOfCurrentlyShowing',
                      '<%=UIUtil.toJavaScript((String)userNLS.get("LUS_Label_statusLine")) %> ');

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
                   + "&maxThreshold=" + "<%= (String)userNLS.get("LUS_MaxNumOfResultForAccountSearch") %>"
                   + "&firstLoad=1";

   // Construct the IFRAME as the data frame for getting the search result
   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var dataFrame = "<iframe name='CSRShopperSearchB2B_dataFrame' "
                         + "id='CSRShopperSearchB2B_dataFrame' "
                         + "onload='LUS_ProcessDataFrameSearchResults()' "
                         + "width='0' height='0' "
                         + "src='" + webAppPath + "CSRSearchForAccountsView?"
                         + queryString
                         + "' title='<%=userNLS.get("custSearch")%>'></iframe>";

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
   var resultCondition = CSRShopperSearchB2B_dataFrame.getSearchResultCondition();
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
         lusWidget.LUS_setResultingList(CSRShopperSearchB2B_dataFrame.getAccountNameList(),
                                        CSRShopperSearchB2B_dataFrame.getAccountIdList());
         lusWidget.LUS_refreshCurrentlyShown();
      }
      else if (resultCondition=='2')
      {
         // Too many entries, show msg in widget to let user type account name to search
         lusWidget.LUS_setSearchKeyword('<%=UIUtil.toJavaScript((String)userNLS.get("LUS_Label_keywordDefaultText")) %> ', true);
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
      msg = "<%= UIUtil.toJavaScript((String)userNLS.get("LUS_Msg_NotFound")) %>";
      alertDialog(msg);
      return;
   }
   else if (resultCondition=='2')
   {
      // Too many entries
      msg = "<%= UIUtil.toJavaScript((String)userNLS.get("LUS_Msg_TooManyFound")) %>";
      var thresholdValue = new Number('<%= (String)userNLS.get("LUS_MaxNumOfResultForAccountSearch") %>');
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

      lusWidget.LUS_setResultingList(CSRShopperSearchB2B_dataFrame.getAccountNameList(),
                                     CSRShopperSearchB2B_dataFrame.getAccountIdList());
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
                   + "&maxThreshold=" + "<%= (String)userNLS.get("LUS_MaxNumOfResultForAccountSearch") %>";

   var webAppPath = "<%= UIUtil.getWebappPath(request) %>";
   var newURL     = webAppPath + 'CSRSearchForAccountsView?' + queryString;

   top.showProgressIndicator(true);
   CSRShopperSearchB2B_dataFrame.location.replace(newURL);

}//end-function


/////////////////////////////////////////////////////////////////////////////
// Function: LUS_SelectResultItem
// Desc.   : Rewire the user selected item from the resuling list box to
//           the expected form's field.
/////////////////////////////////////////////////////////////////////////////
function LUS_SelectResultItem()
{
   var selectedItem = lusWidget.LUS_getSelectedResults();
   document.searchForm.account.value = selectedItem;
}


</script>
<!-- ******************************************************************** -->
<!-- *   END HERE --- Javascript Functions for Wiring the LUS Widget    * -->
<!-- ******************************************************************** -->
<!-- /*d66719:add-end*/ -->


</head>
<body class="content" onload="loadPanelData()">

<h1><%=userNLS.get("custSearch")%></h1>
<p><%=userNLS.get("findInstMsg")%></p>
<form action="" name="searchForm" method="get" id="searchForm">

<table border="0" id="ShopperSearchB2B_Table_1">
  <tr><th></th></tr>
  <tbody>
    <tr>
      <td id="ShopperSearchB2B_TableCell_1"><%=userNLS.get("custLogonID")%><br />
      <label for="ShopperSearchB2B_FormInput_logonid_In_searchForm_1"><span style='display:none;'><%=userNLS.get("custLogonID")%></span></label>
          <input size="30" type="text" name="logonid" maxlength="31" id="ShopperSearchB2B_FormInput_logonid_In_searchForm_1" />
      </td>
      <td id="ShopperSearchB2B_TableCell_2"><br />
          <label for="logonidSearchType1"><span style='display:none;'><%=userNLS.get("logonid")%></span></label>
          <select name="logonidSearchType" id="logonidSearchType1">
            <script type="text/javascript">displayCaseSelection()
</script>
          </select>
      </td>
    </tr>

    <script type="text/javascript">displayNameSearchField()
</script>

    <tr>
      <td id="ShopperSearchB2B_TableCell_3"><%=userNLS.get("phone1")%><br />
      	  <label for="ShopperSearchB2B_FormInput_phone_In_searchForm_1"><span style='display:none;'><%=userNLS.get("phone1")%></span></label>
          <input size="30" type="text" name="phone" maxlength="32" id="ShopperSearchB2B_FormInput_phone_In_searchForm_1" />
      </td>
      <td id="ShopperSearchB2B_TableCell_4"><br />
      	  <label for="phoneSearchType1"><span style='display:none;'><%=userNLS.get("phone1")%></span></label>
          <select name="phoneSearchType" id="phoneSearchType1">
               <script type="text/javascript">displayCaseSelection()
	       </script>
          </select>
      </td>
    </tr>
    <tr>
      <td id="ShopperSearchB2B_TableCell_5"><%=userNLS.get("email1")%><br />
      <label for="ShopperSearchB2B_FormInput_email_In_searchForm_1"><span style='display:none;'><%=userNLS.get("email1")%></span></label>
      <input size="30" type="text" name="email" maxlength="254" id="ShopperSearchB2B_FormInput_email_In_searchForm_1" /></td>
      <td id="ShopperSearchB2B_TableCell_6"><br />
      		<label for="emailSearchType1"><span style='display:none;'><%=userNLS.get("email1")%></span></label>
                <select name="emailSearchType" id='emailSearchType1'>
                  <script type="text/javascript">displayCaseSelection()
</script>
                </select>
      </td>
    </tr>
    <tr>
      <td id="ShopperSearchB2B_TableCell_7"><%=userNLS.get("city")%><br />
      <label for="ShopperSearchB2B_FormInput_city_In_searchForm_1"><span style='display:none;'><%=userNLS.get("city")%></span></label>
      <input size="30" type="text" name="city" maxlength="128" id="ShopperSearchB2B_FormInput_city_In_searchForm_1" /></td>
      <td id="ShopperSearchB2B_TableCell_8"><br />
      		<label for="citySearchType1"><span style='display:none;'><%=userNLS.get("city")%></span></label>
                <select name="citySearchType" id="citySearchType1">
                  <script type="text/javascript">displayCaseSelection()
</script>
                </select>
      </td>
    </tr>
    <tr>
      <td id="ShopperSearchB2B_TableCell_9"><%=userNLS.get("zip")%><br />
      <label for="ShopperSearchB2B_FormInput_zip_In_searchForm_1"><span style='display:none;'><%=userNLS.get("zip")%></span></label>
      <input size="30" type="text" name="zip" maxlength="40" id="ShopperSearchB2B_FormInput_zip_In_searchForm_1" /></td>
      <td id="ShopperSearchB2B_TableCell_10"><br />
      		<label for="zipSearchType1"><span style='display:none;'><%=userNLS.get("zip")%></span></label>
                <select name="zipSearchType" id='zipSearchType1'>
                  <script type="text/javascript">displayCaseSelection()
</script>
                </select>
      </td>
    </tr>


<!-- /*d66719:chg-begin*/ -->
<input type="hidden" name="account" />
<!-- /*d66719:chg-end*/ -->

  </tbody>
</table>


<!-- /*d66719:add-begin*/ -->
<!-- ******************************************************************** -->
<!-- *****        LUS Widget GUI Component Scope START HERE         ***** -->
<!-- ******************************************************************** -->

<table>
   <tbody>

      <tr>
         <!---------------------------------------------------------------->
         <!-- Status line showing currently items in the result list box -->
         <!---------------------------------------------------------------->
         <td id="LUS_NumOfCurrentlyShowing" colspan="2"><%= userNLS.get("LUS_Label_statusLine") %> 0</td>
      </tr>

      <tr> <!-- Building GUI Body Parts BEGIN ------------------------------>


         <!----------------------------------------------------------->
         <!-- Quick search text entry field with resulting list box -->
         <!----------------------------------------------------------->
         <td valign="top" id="LUS_TableCell_SelectAccount"><label for="LUS_FormInput_QuickTextEntry"><%= userNLS.get("LUS_Label_selectAccount") %></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_QuickNavigation">
                     
                        <input  name="LUS_QuickTextEntry"
                                type="text"
                                size="20"
                                class="LUS_CSS_QuickTextEntryWidth"
                                onkeyup="javascript:lusWidget.LUS_autoNavigate();"
                                id="LUS_FormInput_QuickTextEntry" /><br />
                        <label for="LUS_SearchResultListBox1" style="display:none;"><%= buyAdminConsoleNLS.get("SelectSearchResult") %></label>
                        <select name="LUS_SearchResultListBox" size="4"
                                onchange="javascript:LUS_SelectResultItem();"
                                class="LUS_CSS_ResultListBoxWidth"
                                single="single" id='LUS_SearchResultListBox1'>
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
         <td valign="top" id="LUS_TableCell_SearchAccount"><label for="LUS_SearchTextField1"><%= userNLS.get("LUS_Label_searchAccount") %></label><br />
            <table border="0">
               <tbody>
                  <tr>
                     <td id="LUS_TableCell_KeywordSearch"> 
                        <input  name="LUS_SearchTextField"
                                type="text"
                                size="20"
                                class="LUS_CSS_KeywordEntryWidth" 
                                id='LUS_SearchTextField1' /><br /> 
                        <label for="LUS_CriteriaDropDown1" style="display:none;"><%= buyAdminConsoleNLS.get("SearchOptions") %></label>                       
                        <select name="LUS_CriteriaDropDown"
                                class="LUS_CSS_CriteriaListWidth" 
                                id='LUS_CriteriaDropDown1'>
                           <option value="1"><%= userNLS.get("LUS_SearchType1") %></option>
                           <option value="2"><%= userNLS.get("LUS_SearchType2") %></option>
                           <option value="3"><%= userNLS.get("LUS_SearchType3") %></option>
                           <option value="4"><%= userNLS.get("LUS_SearchType4") %></option>
                           <option value="5"><%= userNLS.get("LUS_SearchType5") %></option>
                        </select><br /><br />
                     </td>
                  </tr>
                  <tr>
                     <td align="right" id="LUS_FormInput_FindAction">
                        <button name="LUS_ActionButton" class="general" onclick="javascript:LUS_FindAction();"><%= userNLS.get("LUS_Label_findButton") %></button><br />
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
<!-- /*d66719:add-end*/ -->



</form>

<!-- /*d66719:add-begin*/ -->
<!-- Initialize the LUS Widget -->
<script type="text/javascript">
   LUS_Setup();
</script>
<!-- /*d66719:add-end*/ -->


</body>
</html>
<%
} catch (Exception e) {
   e.printStackTrace();
}
%>

