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

<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.math.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.base.objects.*"   %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.usermanagement.commands.ECUserConstants" %>

<%@ include file="../common/common.jsp" %>

<%

// Set Command Context
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
String webalias = UIUtil.getWebPrefix(request);

// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
   if (orgEntityNLS == null) System.out.println("!!!! RS is null");


	String strMessage = "";
	String strMessageKey = "";
	Object[] strMessageParams = null;
	String strFieldName = "";
	boolean bOrgEntityFound = false;
	String strOrgEntityName = "";
        String strDistinguishedName = "";


	String strOrgEntityId = cmdContext.getRequestProperties().getString("nestOrgEntityId");
		
	if (!(strOrgEntityId == null || strOrgEntityId.equals(""))) {
	    bOrgEntityFound = true;
	}
	
	OrgEntityDataBean bnOrgEntity = new OrgEntityDataBean();
	
	if (!(strOrgEntityId == null || strOrgEntityId.equals(""))) {
	bnOrgEntity.setOrgEntityId(strOrgEntityId);
	com.ibm.commerce.beans.DataBeanManager.activate(bnOrgEntity, request);
	bOrgEntityFound = bnOrgEntity.findOrgEntity();
	strOrgEntityName = bnOrgEntity.getOrgEntityName();
        strDistinguishedName = bnOrgEntity.getDistinguishedName();
	}

	String strOrgEntityType = "";
	String strMemberId = "";
	String strLegalId = "";
	String strBusinessCategory = "";
	String strDescription = "";
	String parentName = "";
	
	//String[][] OrgEntityTypeOptions = (String[][])hshOrgEntityType.get(ECUserConstants.EC_RB_OPTIONS);
	//String[][] MemberIdOptions = bnOrgEntity.getOrgEntityList();	


	if (bOrgEntityFound)
	{
		String otype = bnOrgEntity.getOrgEntityType();
		String memberId = bnOrgEntity.getAttribute(ECUserConstants.EC_PARENTMEMBERID);
		OrgEntityDataBean oedb = new OrgEntityDataBean();
		oedb.setOrgEntityId(memberId);
		try {
			com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
			parentName = oedb.getOrgEntityName();
		}  catch (Exception e) {
			parentName = null;
			
		}
	}

        if (strDistinguishedName == null) strDistinguishedName = "";
	if (strOrgEntityType == null) strOrgEntityType = "";
	if (strMemberId == null) strMemberId = "";
	if (strLegalId == null) strLegalId = "";
	if (strBusinessCategory == null) strBusinessCategory = "";
	if (strOrgEntityName == null) strOrgEntityName = "";
	if (strDescription == null) strDescription = "";

%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><title><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneral")) %></title>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 40%;}
</STYLE>

<script LANGUAGE="JavaScript1.2" SRC="<%=webalias%>javascript/tools/common/SwapList.js"></script>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

////////////////////////////////////////////////
// Load data from state of info for this page
// add them to the GUI
///////////////////////////////////////////////

function initializeState()
{

   top.setContentFrameLoaded(true);

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
<BODY ONLOAD="parent.initializeState();" CLASS="content">
   <H1><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneral")) %></H1>

<FORM NAME="f1">
<table border=0>

<TR>
<TD>
<% if (bOrgEntityFound) { %>
	<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralShortName")) %><BR>
	<i><%= UIUtil.toHTML(strOrgEntityName) %></i>
<%} else {%>
	<label for="shortName1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralShortNameReq")) %></label><BR>
	<INPUT size="30" type="text" name="shortName" value="<%= UIUtil.toHTML( strOrgEntityName ) %>" id="shortName1">
<%}%>
</TD>
</TR>
<TR>
<TD>
<% if (bOrgEntityFound) { %>
       <%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralDistinguishedName")) %><BR>
       <i><%= UIUtil.toHTML( strDistinguishedName ) %></i>
<%}%>       
</TD>
</TR>

<TR> 
<TD>
	<label for="description1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityDeliveryDescription")) %></label><BR>
	<INPUT size="30" type="text" name="description" value="<%= UIUtil.toHTML( strDescription ) %>" id="description1">
</TD>
</TR>
<TR>
<TD>
	<label for="buscat1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralBusCat")) %></label><BR>
	<INPUT size="30" type="text" name="buscat" value="<%= UIUtil.toHTML( strBusinessCategory ) %>" id="buscat1">
</TD>
</TR>

<TR>
<TD>
	<label for="SelectOrgType1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralOrgType")) %></label><BR>

	<SELECT NAME="SelectOrgType" id="SelectOrgType1">

		<OPTION  VALUE="O"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrg")) %></OPTION>
		<OPTION  VALUE="OU"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrgUnit")) %></OPTION>
		<%  if (bOrgEntityFound) { // Display the AD type only on update, because cannot create AD through this tool. %>
			<OPTION  VALUE="AD"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectAuthDomain")) %></OPTION>
		<% } %>
	</SELECT>
</TD>
</TR>
<% if (bOrgEntityFound) { 
	if (parentName != null) {%>
<TR>
<TD>
	<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralParentOrg")) %><BR>
	<i><%= UIUtil.toHTML(parentName) %></i>
</TD>
</TR>
<% 	}
} else {%>
<TR><TD>  
      	<LABEL>
      	<%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralParentOrgReq"))%><BR>
      	<INPUT size="32" type="input" name="orgname">
      	</LABEL>
</TD>
<TD WIDTH=20 VALIGN=BOTTOM>
	<INPUT type="button" id='content' value="<%=UIUtil.toHTML((String)orgEntityNLS.get("find"))%>" onClick="parent.findOrg()">
</TD></TR>

<% } %>
<TR><TD><BR></TD></TR>
</table>



</FORM>
</body>
</html>
