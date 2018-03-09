<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.AccountDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.AccountListDataBean" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//
// Name       : SearchForAccounts.jsp
//
// Description: This JSP uses an AccountListDataBean to perform the
//              accounts search with a set of given search criteria.
//              Based on the search results, it will generate the
//              proper javascript functions allowing the callers
//              to call-back for retrieving the search results. It
//              is designed to be used with an IFRAME.
//
// Parameters : The parameters for using this JSP are described below:
//              searchType   - specify the search type, please to the
//                             AccountListDataBean for details
//              maxThreshold - the max. number of returning accounts
//                             allowed
//              firstLoad    - '0' or '1', to indicate this is the
//                             first time where the caller program
//                             invokes this JSP, to help and enhance
//                             the performance during load up
//
// Output     : There are three javascript functions will be generated
//              after this JSP being executed. The caller programs can
//              invoke these javascript functions to access the search
//              result. The javascript functions are list below:
//                 - getSearchResultCondition()
//                 - getAccountIdList()
//                 - getAccountNameList()
//
//---------------------------------------------------------------------
--%>
<%
try
{
   // Parameters may be encrypted. Use JSPHelper to get URL parameter
   // instead of request.getParameter().
   JSPHelper jhelper    = new JSPHelper(request);

   // Declare all wiring variables
   AccountListDataBean accountListBean = new AccountListDataBean();
   AccountDataBean accountList[] = null;
   int numAccounts = 0;
   int searchType   = 0;
   int maxThreshold = 0;
   int firstLoad = 0;

   // This indicates the following search result conditions:
   //    '0' - no match found
   //    '1' - match found within max. threshold
   //    '2' - match found exceeding max. threshold
   int searchResultCondition = 0;

   // Ready the search string
   String searchString = jhelper.getParameter("searchString");

   // Ready the search type
   try
      { searchType = Integer.parseInt(jhelper.getParameter("searchType")); }
   catch (NumberFormatException ne)
      { searchType = 0; } // default to search all

   // Ready the search max threshold value
   try
   {
      maxThreshold = Integer.parseInt(jhelper.getParameter("maxThreshold"));
   }
   catch (NumberFormatException ne)
   {
      maxThreshold = 100; // default to 100
      ECTrace.trace(ECTraceIdentifiers.COMPONENT_TOOLSFRAMEWORK,
                    "tools/csr/SearchForAccounts.jsp",
                    "service",
                    "Invalid maxThreshold=" + jhelper.getParameter("maxThreshold"));
   }

   // Turn on the performance boost
   accountListBean.setLightWeightAccountDataBeanFlag(true);

   // Check first load indicator for additional performance boost
   try
      { firstLoad = Integer.parseInt(jhelper.getParameter("firstLoad")); }
   catch (NumberFormatException ne)
      { firstLoad = 0; } // default to search all


   // Additional performance enhancement during the first load
   boolean skipNextPart=false;
   if (firstLoad!=0)
   {
      // Get the total accounts count first
      int tmpSearchType = 9;
      accountListBean.setSearchCriteria(tmpSearchType, null, maxThreshold);
      DataBeanManager.activate(accountListBean, request);

      if (accountListBean.hasNumOfSearchResultsExceededMax())
      {
         // Ooops... too many accounts, skip the account IDs & names loading
         searchResultCondition = 2;
         skipNextPart = true;
      }
   }

   if (!skipNextPart)
   {
      // Setup the search criteria and perform the searching!
      accountListBean.setSearchCriteria(searchType, searchString, maxThreshold);
      DataBeanManager.activate(accountListBean, request);

      // Examine the results
      if (accountListBean.hasNumOfSearchResultsExceededMax()==false)
      {
         // Good, numbers of found entries within max threshold
         accountList = accountListBean.getAccountList();
         numAccounts = accountList.length;
         searchResultCondition = (accountList.length > 0) ? 1 : 0;
      }
      else
      {
         // Ooops... too many returning results
         searchResultCondition = 2;
      }
   }
%>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SearchForAccounts</title>
<script type="text/javascript">

/////////////////////////////////////////////////////////////////////////////
// Function: getSearchResultCondition
// Desc.   : Return the search result condition after the accounts search.
// Input   : void
// Output  : Possible returning values are listed below:
//             '0' - no match found
//             '1' - match found within max. threshold
//             '2' - match found exceeding max. threshold
/////////////////////////////////////////////////////////////////////////////
function getSearchResultCondition()
{
   return <%= searchResultCondition %>;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getAccountIdList
// Desc.   : Return the list of account ID values from the search result
// Input   : void
// Output  : an array of account IDs
/////////////////////////////////////////////////////////////////////////////
function getAccountIdList()
{
   var resultIDs = new Array();
<%
   for (int i=0; i<numAccounts; i++)
   {
      if (accountList[i] != null)
      {
         out.println("   resultIDs[" + i + "] = '"
                    + UIUtil.toJavaScript(accountList[i].getAccountId())
                    + "';" );
      }//end-if

   }//end-for
%>
   return resultIDs;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getAccountNameList
// Desc.   : Return the list of account name values from the search result
// Input   : void
// Output  : an array of account names
/////////////////////////////////////////////////////////////////////////////
function getAccountNameList()
{
   var resultNames = new Array();
<%
   for (int i=0; i<numAccounts; i++)
   {
      if (accountList[i] != null)
      {
         out.println("   resultNames[" + i + "] = '"
                    + UIUtil.toJavaScript(accountList[i].getAccountName())
                    + "';" );
      }//end-if

   }//end-for
%>
   return resultNames;
}

</script>




</head>
<body>
</body>
</html>
<%
} catch (Exception e) {
   e.printStackTrace();
}
%>

