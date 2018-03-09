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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>

<%@ page language="java" %>
<%@ page import="java.util.*" %>

<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.user.beans.RoleDataBean" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.user.beans.RoleAssignmentPermissionDataBean" %>

<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//
// Name       : GetUseRolesForOrg.jsp
//
// Description: This JSP uses both RoleAssignmentPermissionDataBean and RoleDataBean
//              to retrieve a list of belonging roles for a specific
//              organization. Based on the results, it will generate the
//              proper javascript functions allowing the callers
//              to call-back for retrieving the role results. It
//              is designed to be used with an invisible IFRAME.
//
// Parameters : The parameters for using this JSP are described below:
//              oid - specify the organization ID
//
// Output     : There are two javascript functions will be generated
//              after this JSP being executed. The caller programs can
//              invoke these javascript functions to access the search
//              result. The javascript functions are list below:
//                 - getRoleIdList()
//                 - getRoleNameList()
//
//---------------------------------------------------------------------
--%>

<%
try {
	// Parameters may be encrypted. Use JSPHelper to get URL parameter
	// instead of request.getParameter().
	JSPHelper jhelper = new JSPHelper(request);

	// Get the current locale
	CommandContext cmdContext = 
		(CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();

	// Declare operation variables & retrieve the given parameter
	String oid = jhelper.getParameter("oid");
   
	Vector roleList = new Vector();
	Integer[] rootRoleIDs = null;
	int numOfRoles = 0;

	if (((oid==null) || "".equals(oid))==false) {

		// The list of assignable roles is fetched from the RoleAssignmentPermissionDataBean
		rootRoleIDs = RoleAssignmentPermissionDataBean
			.getRolesThatUserCanAssignInOrg(
				cmdContext.getUser().getUserId(),
				oid);
			
		// Loop through the rootRoleIDs list and store the ID & Name to roleList
		for (int j =0; j < rootRoleIDs.length; j++) {
			RoleDataBean roleDataBean = new RoleDataBean();
			roleDataBean.setDataBeanKeyRoleId(rootRoleIDs[j].toString());
			com.ibm.commerce.beans.DataBeanManager.activate(roleDataBean, request);

			// Form a data cell record
			Vector tmp = new Vector();
			tmp.addElement(rootRoleIDs[j].toString());
			tmp.addElement(roleDataBean.getDisplayName());
			tmp.addElement(roleDataBean.getName()); 
			roleList.addElement(tmp);
		}

		numOfRoles = roleList.size();

		// Perform sorting on the role names
      	java.text.Collator collator = java.text.Collator.getInstance(locale);
		for (int m = 0; m < numOfRoles; m++) {
			
			for (int n = m + 1; n < roleList.size(); n++) {
				Vector vec1 = (Vector) roleList.elementAt(m);
				Vector vec2 = (Vector) roleList.elementAt(n);
				if (collator.compare((String) vec1.elementAt(1),(String) vec2.elementAt(1) ) > 0) {
					roleList.setElementAt(vec2, m);
					roleList.setElementAt(vec1, n);
				}
			}
		}

	}
%>


<html>
<head>

<script>


/////////////////////////////////////////////////////////////////////////////
// Function: getRoleIdList
// Desc.   : Return the list of role ID values from the search result
// Input   : void
// Output  : an array of role IDs
/////////////////////////////////////////////////////////////////////////////
function getRoleIdList()
{
   var resultIDs = new Array();
<%
   for (int i=0; i<numOfRoles; i++)
   {
      Vector roleDataCell = (Vector) roleList.elementAt(i);
      String roleID       = (String) roleDataCell.elementAt(0);
      out.println("   resultIDs[" + i + "] = '"
                    + UIUtil.toJavaScript(roleID.toString())
                    + "';" );
   }//end-for
%>
   return resultIDs;
}


/////////////////////////////////////////////////////////////////////////////
// Function: getRoleNameList
// Desc.   : Return the list of role display name values from the search result
// Input   : void
// Output  : an array of role display names
/////////////////////////////////////////////////////////////////////////////
function getRoleNameList()
{
   var resultNames = new Array();
<%
   for (int i=0; i<numOfRoles; i++)
   {
      Vector roleDataCell = (Vector) roleList.elementAt(i);
      String roleName     = (String) roleDataCell.elementAt(1);
      
      out.println("   resultNames[" + i + "] = '"
                    + UIUtil.toJavaScript(roleName.toString())
                    + "';" );
   }//end-for
%>
   return resultNames;
}

/////////////////////////////////////////////////////////////////////////////
// Function: getInternalRoleNameList
// Desc.   : Return the list of internal role name values from the search result
// Input   : void
// Output  : an array of internal role names
/////////////////////////////////////////////////////////////////////////////
function getInternalRoleNameList()
{
   var resultInternalNames = new Array();
<%
   for (int i=0; i<numOfRoles; i++)
   {
      Vector roleDataCell = (Vector) roleList.elementAt(i);
      String roleInternalName     = (String) roleDataCell.elementAt(2);
      
      out.println("   resultInternalNames[" + i + "] = '"
                    + UIUtil.toJavaScript(roleInternalName.toString())
                    + "';" );
   }//end-for
%>
   return resultInternalNames;
}

</script>

</head>

<body onload="parent.RolesHelper_ProcessDataFrameSearchResults();" >
GetRolesForOrg
</body>
</html>

<%
}
catch (Exception e)
{
   e.printStackTrace();
}
%>

