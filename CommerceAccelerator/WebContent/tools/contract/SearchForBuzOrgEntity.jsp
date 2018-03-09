<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2004, 2017 All Rights Reserved.

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

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandFactory" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.AccountListDataBean" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.AccountDataBean" %>
<%@ page import="com.ibm.commerce.user.beans.OrganizationDataBean" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ListBusinessOrgEntityCmd" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.ras.ECTrace" %>
<%@ page import="com.ibm.commerce.ras.ECTraceIdentifiers" %>
<%@ page import="com.ibm.commerce.account.util.AccountTCHelper" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>
<%@ page import="com.ibm.commerce.user.objects.MemberGroupAccessBean" %>
<%@ page import="com.ibm.commerce.user.objects.MemberGroupMemberAccessBean" %>
<%@ page import="com.ibm.commerce.registry.StoreRegistry" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.base.objects.ServerJDBCHelperBean" %>
<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>


<%--
//---------------------------------------------------------------------
//
// Name       : SearchForBuzOrgEntity.jsp
//
// Description: This JSP applies given search criteria and performs
//              searching of business organization entities which have
//              not assoicated with business accounts yet.
//              Based on the search results, it will generate the
//              proper javascript functions allowing the callers
//              to call-back for retrieving the search results. It
//              is designed to be used with an IFRAME and does not
//              produce any GUI to users.
//
// Parameters : The parameters for using this JSP are described below:
//
//              searchType   - specify the search type, valid options
//                             are listed below:
//                             0 - No criteria, it will search all
//                             1 - Match case, beginning with
//                             2 - Match case, containing
//                             3 - Ignore case, beginning with
//                             4 - Ignore case, containing
//                             5 - Exact match
//
//              searchString - specify the search keyword
//
//              maxThreshold - the max. number of returning matched
//                             results allowed
//
// Output     : There are three javascript functions will be generated
//              after this JSP being executed. The caller programs can
//              invoke these javascript functions to access the search
//              result. The javascript functions are list below:
//                 - getSearchResultCondition()
//                 - getBuzOrgEntityIdList()
//                 - getBuzOrgEntityNameList()
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
   int searchType   = 0;
   int maxThreshold = 0;
   String searchString = jhelper.getParameter("searchString");
   Vector buzOrgEntityIDList = new Vector();
   Vector buzOrgEntityNameList = new Vector();


   // This indicates the following search result conditions:
   //    '0' - no match found
   //    '1' - match found within max. threshold
   //    '2' - match found exceeding max. threshold
   int searchResultCondition = 0;


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
      ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/SearchForBuzOrgEntity.jsp",
                    "service",
                    "Invalid maxThreshold=" + jhelper.getParameter("maxThreshold") + ", default to 100 now.");
   }

   AccountTCHelper tcHelper = new AccountTCHelper();
   Vector filteredIDList = new Vector();
   
   boolean getBusinessEntityOrganizations = false;
   
   com.ibm.commerce.common.objects.StoreAccessBean sab = StoreRegistry.singleton().find(fStoreId);
   if ( sab.getStoreType().equals( "SHS" ) ) {
      // supplier stores want both orgs registered to their store, and orgs registered on the site
      getBusinessEntityOrganizations = true;
   }
   
      //Check to see if the organization has a Member Group (RegisterCustomers)
      //that stores the Buyer Organizations that have registered to it.
      try {
         MemberGroupAccessBean abMemberGroup = new MemberGroupAccessBean().findByOwnerName(new Long(fStoreMemberId), ECUserConstants.REGISTERED_CUSTOMER_MEMBERGROUP_NAME);

	  ServerJDBCHelperBean JDBChelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
	  String query = "SELECT DISTINCT T3.MEMBER_ID, O.ORGENTITYNAME FROM MBRGRP T1, MEMBER T2, MBRGRPMBR T3, ORGENTITY O WHERE T2.TYPE = 'G' AND T2.MEMBER_ID = T1.MBRGRP_ID AND (T1.OWNER_ID = ";
	  query += fStoreMemberId;
	  query += " ) AND (T1.MBRGRPNAME = '";
	  query += ECUserConstants.REGISTERED_CUSTOMER_MEMBERGROUP_NAME;
	  query += "') AND (T3.MBRGRP_ID = T1.MBRGRP_ID) AND (T3.MEMBER_ID = O.ORGENTITY_ID) AND NOT EXISTS (SELECT * FROM PARTICIPNT P, ACCOUNT A, TRADING T WHERE P.MEMBER_ID = T3.MEMBER_ID AND P.TRADING_ID = A.ACCOUNT_ID AND P.PARTROLE_ID = 5 AND A.STORE_ID = ";
	  query += fStoreId.toString();
	  query += " AND P.TRADING_ID = T.TRADING_ID AND T.MARKFORDELETE <> 1 ) ";
	  query += tcHelper.getSQLForFindBuzOrgEntityByOrgName(searchType, searchString);
          ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/SearchForBuzOrgEntity.jsp",
                    "service",
                    "member group query=" + query);	  
	  Vector orgList = JDBChelper.executeQuery(query);
	  
	  if (orgList != null && orgList.size() > 0) {
		for (int i=0; i<orgList.size(); i++) {
			Vector orgRow = (Vector)orgList.elementAt(i);
			if (orgRow != null && orgRow.size() > 0) {
				String orgId = orgRow.elementAt(0).toString();
				if (!fStoreMemberId.equals(orgId)) {
					filteredIDList.addElement(new Long(orgId));
				}
			} // end if orgRow
		} // end for orgList
	  } // end if orgList  	  

      } catch(javax.persistence.NoResultException e) {
     
     		// there is no registered customers member group, so get the business entity orgs
		getBusinessEntityOrganizations = true;
       
      //finders will automatically trigger ObjectNotFound if row does not exist
      } // end NoResultException
      
      if (getBusinessEntityOrganizations == true) {
         //Some orgs where the user has a role may not have this member group; this is ok
         try {

	  ServerJDBCHelperBean JDBChelper = SessionBeanHelper.lookupSessionBean(ServerJDBCHelperBean.class);
	  String query = "SELECT DISTINCT T1.MEMBER_ID, O.ORGENTITYNAME FROM MBRATTRVAL T1, ORGENTITY O WHERE T1.MEMBER_ID = O.ORGENTITY_ID AND T1.MBRATTR_ID=-21 AND T1.INTEGERVALUE=1 AND NOT EXISTS (SELECT * FROM PARTICIPNT P, ACCOUNT A WHERE P.MEMBER_ID = T1.MEMBER_ID AND P.TRADING_ID = A.ACCOUNT_ID AND P.PARTROLE_ID = 5 AND A.STORE_ID = ";
	  query += fStoreId.toString();
	  query += " ) ";
	  query += tcHelper.getSQLForFindBuzOrgEntityByOrgName(searchType, searchString);
          ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/SearchForBuzOrgEntity.jsp",
                    "service",
                    "org query=" + query);	  
	  Vector orgList = JDBChelper.executeQuery(query);
	  
	  if (orgList != null && orgList.size() > 0) {
		for (int i=0; i<orgList.size(); i++) {
			Vector orgRow = (Vector)orgList.elementAt(i);
			if (orgRow != null && orgRow.size() > 0) {
				String orgId = orgRow.elementAt(0).toString();
				if (!fStoreMemberId.equals(orgId)) {
					filteredIDList.addElement(new Long(orgId));
				}
			} // end if orgRow
		} // end for orgList
	  } // end if orgList  	  
		  
         } catch (Exception ex) {
	  com.ibm.commerce.ras.ECTrace.trace(com.ibm.commerce.ras.ECTraceIdentifiers.COMPONENT_CONTRACT, getClass().getName(), "getMemberGropus", ex.toString());			
         }    
      }  

   ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                    "tools/contract/SearchForBuzOrgEntity.jsp",
                    "service",
                    "filteredIDList.size=" + filteredIDList.size());
                    
      //-------------------------------------------------------------
      // Check the number of found results exceeding given threshold
      //-------------------------------------------------------------

   if (filteredIDList.size() > maxThreshold)
   {
         // Search found results exceed the given max. threshold value
         searchResultCondition = 2;
         ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                       "tools/contract/SearchForBuzOrgEntity.jsp",
                       "service",
                       "Found results exceed the given max. threshold value, searchResultCondition=2, filteredIDList.size=" + filteredIDList.size());
   }
   else if (filteredIDList.size() == 0)
   {
         // Cann't find any matching results
         searchResultCondition = 0;
         ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                       "tools/contract/SearchForBuzOrgEntity.jsp",
                       "service",
                       "Cannot find any matching results, filteredIDList.size()=0, searchResultCondition=0.");
   }
   else
   {
         searchResultCondition = 1;
         ECTrace.trace(ECTraceIdentifiers.COMPONENT_CONTRACT,
                       "tools/contract/SearchForBuzOrgEntity.jsp",
                       "service",
                       "filteredIDList.size()=" + filteredIDList.size());

         // Traverse the filtered list and retrieve all the org. entity names
         // and prepare the business org. entity IDs & names lists.

         for (int i=0; i<filteredIDList.size(); i++)
         {
            Long orgId = (Long) filteredIDList.elementAt(i);
            OrganizationDataBean OrgEntityDB = new OrganizationDataBean();
            OrgEntityDB.setDataBeanKeyMemberId(orgId.toString());
            DataBeanManager.activate(OrgEntityDB, request);

            // Make sure the orgentity name exists and is valid
            if (OrgEntityDB.getOrganizationName().length() > 0)
            {
               // Prepare the ID & name lists for later access
               buzOrgEntityIDList.addElement(orgId.toString());
               buzOrgEntityNameList.addElement(OrgEntityDB.getOrganizationName());
            }

         } //end-for-i

   }//end-else (filteredIDList.size() > maxThreshold)

%>



<html>
<head>

<script>

/////////////////////////////////////////////////////////////////////////////
// Function: getSearchResultCondition
// Desc.   : Return the search result condition after the search.
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
// Function: getBuzOrgEntityIdList
// Desc.   : Return the list of business org. entity ID values from the
//           search result
// Input   : void
// Output  : an array of org. IDs
/////////////////////////////////////////////////////////////////////////////
function getBuzOrgEntityIdList()
{
   var resultIDs = new Array();
<%
   for (int i=0; i<buzOrgEntityIDList.size(); i++)
   {
      String id = (String) buzOrgEntityIDList.elementAt(i);
      if (id != null)
      {
         out.println("   resultIDs[" + i + "] = '"
                    + UIUtil.toJavaScript(id)
                    + "';" );
      }//end-if

   }//end-for
%>
   return resultIDs;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getBuzOrgEntityNameList
// Desc.   : Return the list of buz org. entity name values from the
//           search result
// Input   : void
// Output  : an array of org. names
/////////////////////////////////////////////////////////////////////////////
function getBuzOrgEntityNameList()
{
   var resultNames = new Array();
<%
   for (int i=0; i<buzOrgEntityIDList.size(); i++)
   {
      String name = (String) buzOrgEntityNameList.elementAt(i);
      if (name != null)
      {
         out.println("   resultNames[" + i + "] = '"
                    + UIUtil.toJavaScript(name)
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

