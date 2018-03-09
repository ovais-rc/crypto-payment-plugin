<%
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
%>
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
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.user.beans.MemberGroupListDataBean" %>

<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//
// Name       : ACSearchForCustGrpsICanAdmin.jsp
//
// Description: This JSP uses an MemberGroupListDataBean to perform the
//              member group search with a set of given search criteria.
//              Based on the search results, it will generate the
//              proper javascript functions allowing the callers
//              to call-back for retrieving the search results. It
//              is designed to be used with an invisible IFRAME.
//
// Parameters : The parameters for using this JSP are described below:
//              searchType   - specify the search type, please to the
//                             MemberGroupListDataBean for details
//              maxThreshold - the max. number of returning member groups
//                             allowed
//		searchString - the part of the member group name for search
//		adminId      - the user ID of the current logon user
//
// Output     : There are three javascript functions will be generated
//              after this JSP being executed. The caller programs can
//              invoke these javascript functions to access the search
//              result. The javascript functions are list below:
//                 - getSearchResultCondition()
//                 - getCustGrpIdList()
//                 - getCustGrpNameList()
//
//---------------------------------------------------------------------
--%>
<%
try
{
   // Parameters may be encrypted. Use JSPHelper to get URL parameter
   // instead of request.getParameter().
   JSPHelper jhelper = new JSPHelper(request);

   // Declare all wiring variables
   MemberGroupListDataBean mbrgrpDB = new MemberGroupListDataBean();
   
   Vector mbrGrpIDs = null;
   Vector mbrGrpNames = null;
   
   int numMbrGrps = 0;
   String searchType   = null;
   int maxThreshold = 0;

   // This indicates the following search result conditions:
   //    '0' - no match found
   //    '1' - match found within max. threshold
   //    '2' - match found exceeding max. threshold
   int searchResultCondition = 0;

   // Ready the search string
   String searchString = jhelper.getParameter("searchString");
   
   // Ready the admin user ID 
   String adminId = jhelper.getParameter("adminId");

   // Ready the search type
   try
   { 
   	int searchTypeInt = Integer.parseInt(jhelper.getParameter("searchType")); 
      	searchType=jhelper.getParameter("searchType");
   }
   catch (NumberFormatException ne){ 
   	searchType = "0"; 
   } // default to search all

   // Ready the search max threshold value
   try
   {
      maxThreshold = Integer.parseInt(jhelper.getParameter("maxThreshold"));
   }
   catch (NumberFormatException ne)
   {
      maxThreshold = 100; // default to 100
      ECTrace.trace(ECTraceIdentifiers.COMPONENT_USER,
                    "tools/buyerconsole/ACSearchForCustGrpsICanAdmin.jsp",
                    "service",
                    "Invalid maxThreshold=" + jhelper.getParameter("maxThreshold"));
   }


        // Setup the search criteria and perform the searching!
        mbrgrpDB.setSearchCriteria(new Long(adminId), searchString, new Integer(-5), searchType);
        
	DataBeanManager.activate(mbrgrpDB, request);
	numMbrGrps = mbrgrpDB.getMemberGroupLength();
	mbrGrpIDs = mbrgrpDB.getMemberGroupIds();
        mbrGrpNames = mbrgrpDB.getMemberGroupNames();
	
	if(numMbrGrps > maxThreshold ){
	    // Ooops... too many returning results
     	    searchResultCondition = 2;
     	} else {

   	   // Good, numbers of found entries within max threshold
   	   // but it may be the case of search not found, so need
   	   // to verify this scenario as well.	
   	   searchResultCondition = (numMbrGrps> 0) ? 1 : 0;
       }	
     
%>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<script type="text/javascript" >

/////////////////////////////////////////////////////////////////////////////
// Function: getSearchResultCondition
// Desc.   : Return the search result condition after the Orgs search.
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
// Function: getCustGrpIdList
// Desc.   : Return the list of member group ID values from the search result
// Input   : void
// Output  : an array of member group IDs
/////////////////////////////////////////////////////////////////////////////
function getCustGrpIdList()
{
   var resultIDs = new Array();
<%
  for (int i=0; i<numMbrGrps; i++)
   {
      String   mbrGrpID = (String) mbrGrpIDs.elementAt(i);
      out.println("   resultIDs[" + i + "] = '"
                    + UIUtil.toJavaScript(mbrGrpID)
                    + "';" );
   }//end-for
%>
   return resultIDs;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getCustGrpNameList
// Desc.   : Return the list of member group name values from the search result
// Input   : void
// Output  : an array of member group names
/////////////////////////////////////////////////////////////////////////////
function getCustGrpNameList()
{
   var resultNames = new Array();
<% 
   for (int i=0; i<numMbrGrps; i++)
   {
      String mbrGrpName    = (String) mbrGrpNames.elementAt(i);
      out.println("   resultNames[" + i + "] = '"
                    + UIUtil.toJavaScript(mbrGrpName.toString())
                    + "';" );
   } //end-for
%>
   return resultNames;
}

</script>


</head>
<body onload="parent.LUS_ProcessDataFrameSearchResults();">
ACSearchForCustGrpsICanAdmin
</body>
</html>
<%
} catch (Exception e) {
   e.printStackTrace();
}
%>

