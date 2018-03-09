<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2003, 2016
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
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.user.beans.CustomerSearchDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.OrganizationDataBean" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//
// Name       : SearchForOrgsICanAdmin.jsp
//
// Description: This JSP uses an CustomerSearchDataBean to perform the
//              organization search with a set of given search criteria.
//              Based on the search results, it will generate the
//              proper javascript functions allowing the callers
//              to call-back for retrieving the search results. It
//              is designed to be used with an invisible IFRAME.
//
// Parameters : The parameters for using this JSP are described below:
//              searchType   - specify the search type, please to the
//                             UserRegistrationDataBean for details
//              maxThreshold - the max. number of returning orgs
//                             allowed
//
// Output     : There are three javascript functions will be generated
//              after this JSP being executed. The caller programs can
//              invoke these javascript functions to access the search
//              result. The javascript functions are list below:
//                 - getSearchResultCondition()
//                 - getOrgIdList()
//                 - getOrgNameList()
//
//---------------------------------------------------------------------
--%>
<%
try {

	// Parameters may be encrypted. Use JSPHelper to get URL parameter
	// instead of request.getParameter().
	JSPHelper jhelper = new JSPHelper(request);

	// Declare all wiring variables
	Vector orgsList = null;
	int numOrgs = 0;
	int searchType   = 0;
	int maxThreshold = 0;

	// This indicates the following search result conditions:
	//    '0' - no match found
	//    '1' - match found within max. threshold
	//    '2' - match found exceeding max. threshold
	int searchResultCondition = 0;

	// Ready the search string
	String searchString = jhelper.getParameter("searchString");

	// Ready the search type
	try { 
		searchType = Integer.parseInt(jhelper.getParameter("searchType")); }
	catch (NumberFormatException ne) { 
		// default to search all
		searchType = 0; 
	} 

	// Ready the search max threshold value
	try {
		maxThreshold = Integer.parseInt(jhelper.getParameter("maxThreshold"));
	}
	catch (NumberFormatException ne) {
		// default to 100
		maxThreshold = 100; 
		ECTrace.trace(
			ECTraceIdentifiers.COMPONENT_USER,
			"tools/buyerconsole/ACSearchForOrgsICanAdmin.jsp",
			"service",
			"Invalid maxThreshold=" + jhelper.getParameter("maxThreshold"));
	}
  
  	CommandContext cmdContext = 
		(CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  
	CustomerSearchDataBean dbCustomerSearch = new CustomerSearchDataBean();
	dbCustomerSearch.setCommandContext(cmdContext);
	if (searchString != null) {
		int lastPos = 0;
		while (searchString.indexOf('\'', lastPos) != - 1) {
			lastPos = searchString.indexOf('\'', lastPos);
			searchString = searchString.substring(0,lastPos) + '\'' + searchString.substring(lastPos);
			lastPos += 2; 
		}
	}	
	
	Vector vecResults = dbCustomerSearch.findOrganizationsICanAdminister(
		jhelper.getParameter("taskName"),
		searchString,
		new Integer(searchType).toString(),
		null,
		null,
		new Integer(0).toString(),
		new Integer(maxThreshold + 1).toString());

	orgsList = new Vector();   
	if (vecResults.size() > maxThreshold) {
		// Ooops... too many returning results
		searchResultCondition = 2;
		numOrgs = 0;
	}   
	else if (vecResults.size() == 0) {
		searchResultCondition = 0;
		numOrgs = 0;
	}
	else {
		searchResultCondition = 1;
		numOrgs = vecResults.size();
		for (int i=0; i<vecResults.size(); i++) {
		        Vector dataCell = (Vector) vecResults.elementAt(i);
         	        String organizationID = (String) dataCell.elementAt(0);
                        if ("-2000".equals(organizationID.toString())) {
		            numOrgs = numOrgs - 1;
	                } else {
			    orgsList.add((Vector) vecResults.elementAt(i));
			}
		}
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
function getSearchResultCondition() {

   return <%=searchResultCondition%>;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getOrgIdList
// Desc.   : Return the list of Org ID values from the search result
// Input   : void
// Output  : an array of Org IDs
/////////////////////////////////////////////////////////////////////////////
function getOrgIdList() {

	var resultIDs = new Array();
	
	<%
	for (int i=0; i<numOrgs; i++) {

		Vector orgDataCell = (Vector)orgsList.elementAt(i);
		Long orgID = new Long(orgDataCell.elementAt(0).toString());
		out.println("   resultIDs[" + i + "] = '"
                    + UIUtil.toJavaScript(orgID.toString())
                    + "';" );
	}
	%>
	
   return resultIDs;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getOrgNameList
// Desc.   : Return the list of Org name values from the search result
// Input   : void
// Output  : an array of Org names
/////////////////////////////////////////////////////////////////////////////
function getOrgNameList() {

	var resultNames = new Array();

	<%
	for (int i=0; i<numOrgs; i++) {
           
		Vector orgDataCell = (Vector)orgsList.elementAt(i);
		String orgId = null;
		String orgName = null;
		
		try {
			orgId = (String)orgDataCell.elementAt(0);
			OrganizationDataBean dbOrganization = new OrganizationDataBean();
			dbOrganization.setInitKey_memberId(orgId);
			dbOrganization.populate();
			
			orgName = dbOrganization.getOrganizationDisplayName();	

			out.println("   resultNames[" + i + "] = '"
				+ UIUtil.toJavaScript(orgName.toString())
				+ "';" );
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
	
	return resultNames;
}

</script>

</head>

<body onload="parent.LUS_ProcessDataFrameSearchResults();" >
SearchForOrgsICanAdmin
</body>
</html>

<%
} catch (Exception e) {
   e.printStackTrace();
}
%>
