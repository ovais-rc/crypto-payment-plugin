<!--
//********************************************************************
//*------------------------------------------------------------------- 
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
--> 
<%@ page language="java" %>

<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.member.helpers.*" %>
<%@ page import="com.ibm.commerce.member.search.WhereClauseSearchCondition" %>

<%@ include file= "../common/common.jsp" %>

<!-- RESOURCE: tools/buyerconsole/BuyUserFindData.jsp -->
<!-- Dependencies: BuyUserFind.jsp -->
<!-- Property files: com\ibm\commerce\tools\buyerconsole\properties\BuyAdminConsoleNLS.properties -->

<%
		CommandContext cmdContext = 
			(CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
		Locale locale = cmdContext.getLocale();
		String webalias = UIUtil.getWebPrefix(request);

		// obtain the resource bundle for display
		Hashtable userWizardNLS = 
			(Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyAdminConsoleNLS", locale);
		if (userWizardNLS == null) {
			System.out.println("!!!! RS is null");
		}

		// Get the role Ids/names to use for populating the role drop-down list
		String[][] roleNames = MemberRoleDataBean.getAllRolesForDisplay(cmdContext);
		int numberOfRoles = roleNames.length;
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
<%= fHeader%>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("find"))%></TITLE>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>


////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{
   parent.setContentFrameLoaded(true);
}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
}
 
function validatePanelData()
{
  //alertDialog("validate panel data");
   return true;
}

</SCRIPT>

<!-- ============================================================================
The sample Templates, HTML and Macros are furnished by IBM as simple
examples to provide an illustration. These examples have not been
thoroughly tested under all conditions.  IBM, therefore, cannot guarantee reliability, 
serviceability or function of these programs. All programs contained herein are provided 
to you "AS IS".

The sample Templates, HTML and Macros may include the names of individuals,
companies, brands and products in order to illustrate them as completely as
possible.  All of these are names are ficticious and any similarity to the names
and addresses used by actual persons or business enterprises is entirely coincidental.

Licensed Materials - Property of IBM

5697-D24

(c)  Copyright  IBM Corp.  1997, 1999.      All Rights Reserved

US Government Users Restricted Rights - Use, duplication or 
disclosure restricted by GSA ADP Schedule Contract with IBM Corp

=============================================================================== -->

</head>
<BODY ONLOAD="parent.initializeState();" class="content">
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("find"))%></H1>

<LINE3><%=UIUtil.toHTML((String)userWizardNLS.get("userAdminFind"))%></LINE3>
<FORM NAME="wizard1">
<table border=0 summary="<%=UIUtil.toHTML((String)userWizardNLS.get("AdminConsoleTableSumUserAdminGeneral"))%>">

<!-- LOGONID SEARCH PARAMETER -->
<TR>
       <!-- Row for labels -->
       <TD>
              <LABEL for="userLognId1">
                     <%=UIUtil.toHTML((String)userWizardNLS.get("userAdminListLogonIdColumn"))%><BR>
              </LABEL>
       </TD>
       <TD>
              <LABEL for="SelectUserLogonIdSearchType1"></LABEL>
       </TD>
</TR>
<TR>
       <!-- Row for input fields -->
       <TD>
             <INPUT size="32" type="input" name="userLogonId" id="userLognId1">
       </TD>
       <TD>
              <SELECT NAME="SelectUserLogonIdSearchType" id="SelectUserLogonIdSearchType1">
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_CONTAINS"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_CONTAINS"))%>
                     </OPTION>
              </SELECT>
       </TD>
</TR>

<!-- LASTNAME SEARCH PARAMETER -->
<TR>
       <!-- Row for labels -->
       <TD>
              <LABEL for="userAdminListLastNameColumn">
                     <%=UIUtil.toHTML((String)userWizardNLS.get("userAdminListLastNameColumn"))%><BR>
              </LABEL>
       </TD>
       <TD>
              <LABEL for="SelectUserLastNameSearchType1"></LABEL>
       </TD>
</TR>
<TR>
       <!-- Row for input fields -->
       <TD>
             <INPUT size="32" type="input" name="userLastName" id="userAdminListLastNameColumn">
       </TD>
       <TD>
              <SELECT NAME="SelectUserLastNameSearchType" id="SelectUserLastNameSearchType1">
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_CONTAINS"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_CONTAINS"))%>
                     </OPTION>
              </SELECT>
       </TD>
</TR>

<!-- FIRSTNAME SEARCH PARAMETER -->
<TR>
       <!-- Row for labels -->
       <TD>
              <LABEL for="userAdminListFirstNameColumn">
                     <%=UIUtil.toHTML((String)userWizardNLS.get("userAdminListFirstNameColumn"))%><BR>
              </LABEL>
       </TD>
       <TD>
              <LABEL for="SelectUserFirstNameSearchType1"></LABEL>
       </TD>
</TR>
<TR>
       <!-- Row for input fields -->
       <TD>
             <INPUT size="32" type="input" name="userFirstName" id="userAdminListFirstNameColumn">
       </TD>
       <TD>
              <SELECT NAME="SelectUserFirstNameSearchType" id="SelectUserFirstNameSearchType1">
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_CONTAINS"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_CONTAINS"))%>
                     </OPTION>
              </SELECT>
       </TD>
</TR>

<!-- PARENT ORGNANIZATION NAME SEARCH PARAMETER -->
<TR>
       <!-- Row for labels -->
       <TD>
              <LABEL for="userAdminParentOrg">
                     <%=UIUtil.toHTML((String)userWizardNLS.get("userAdminParentOrg"))%>
              </LABEL>
       </TD>
       <TD>
              <LABEL for="SelectParentOrgNameSearchType1"></LABEL>
       </TD>
</TR>
<TR>
       <!-- Row for input fields -->
       <TD>
              <INPUT size="32" type="input" name="parentOrgName" id="userAdminParentOrg">
       </TD>
       <TD>       
              <SELECT NAME="SelectParentOrgNameSearchType" id="SelectParentOrgNameSearchType1">
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASESENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASESENSITIVE_CONTAINS"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_STARTSWITH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_STARTSWITH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_EXACTMATCH"))%>
                     </OPTION>
                     <OPTION VALUE=<%=WhereClauseSearchCondition.SEARCHTYPE_CASEINSENSITIVE_CONTAINS%>>
                            <%=UIUtil.toHTML((String)userWizardNLS.get("SEARCHTYPE_CASEINSENSITIVE_CONTAINS"))%>
                     </OPTION>
              </SELECT>
       </TD>
</TR>

<!-- ROLE ID SEARCH PARAMETER -->
<TR>
<TD>
       <LABEL for="SelectRoleType1"><%= UIUtil.toHTML((String)userWizardNLS.get("userGeneralRoles")) %></label><BR>

       <SELECT NAME="SelectRoleType" id="SelectRoleType1">
              <OPTION VALUE="norole"></OPTION> 
              <% for (int i=0; i < numberOfRoles; i++) { %>
                     <OPTION  VALUE="<%= UIUtil.toHTML(roleNames[i][0]) %>"><%= UIUtil.toHTML(roleNames[i][1]) %></OPTION>
              <%}%>
       </SELECT>
</TD>
</TR>

</TABLE>


</FORM>
</BODY>
</HTML>
