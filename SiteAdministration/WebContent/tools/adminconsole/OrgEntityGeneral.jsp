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
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
   if (orgEntityNLS == null) System.out.println("!!!! RS is null");


	String strMessage = "";
	String strMessageKey = "";
	Object[] strMessageParams = null;
	String strFieldName = "";
	boolean bOrgEntityFound = false;
	String strOrgEntityName = "";
	

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
	}

	String strOrgEntityType = "";
	String strMemberId = "";
	String strLegalId = "";
	String strBusinessCategory = "";
	String strDescription = "";
	String parentName = "";
	

	if (bOrgEntityFound)
	{
		String memberId = bnOrgEntity.getAttribute(ECUserConstants.EC_PARENTMEMBERID);
		OrgEntityDataBean oedb = new OrgEntityDataBean();
		oedb.setOrgEntityId(memberId);
		com.ibm.commerce.beans.DataBeanManager.activate(oedb, request);
		
		parentName = oedb.getOrgEntityName();
		
	}

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

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>
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

// This function is the toggle for the peekaboo of the Dynamic Tree to select the Parent Organization
function newOrgTypeSelected()
{	
	if (document.f1.SelectOrgType.value == 'O') document.all["orgParent"].style.display = "none";	
	else document.all["orgParent"].style.display = "block";	
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
	<i><%=strOrgEntityName%></i>
<%} else {%>
	<LABEL for="shortName1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralShortNameReq")) %></LABEL><BR>
	<INPUT size="30" type="text" name="shortName" id="shortName1" value="<%= strOrgEntityName %>">
<%}%>
</TD>
</TR>
<TR>
<TD>
	<LABEL for="description1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityDeliveryDescription")) %></LABEL><BR>
	<INPUT size="30" type="text" name="description" id="description1" value="<%= strDescription %>">
</TD>
</TR>
<TR>
<TD>
	<LABEL for="buscat1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralBusCat")) %></LABEL><BR>
	<INPUT size="30" type="text" name="buscat" id="buscat1" value="<%= strBusinessCategory %>">
</TD>
</TR>

<TR>
<TD>
	<LABEL for="SelectOrgType1"><%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralOrgType")) %></LABEL><BR>

	<SELECT NAME="SelectOrgType" id="SelectOrgType1" OnChange='parent.newOrgTypeSelected()'>

		<OPTION  VALUE="O"
		<% if (strOrgEntityType != null && strOrgEntityType.equals("O")) { %> SELECTED <% } %>>
		<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrg")) %>

		<OPTION  VALUE="OU"
		<% if (strOrgEntityType != null && strOrgEntityType.equals("OU")) { %> SELECTED <% } %>>
		<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralSelectOrgUnit")) %>

	</SELECT>
</TD>
</TR>
<% if (bOrgEntityFound) { %>
<TR>
<TD>
	<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralParentOrg")) %><BR>
	<i><%=parentName%></i>
</TD>
</TR>
<%}else {%>
<TR><TD>
<DIV ID="orgArea" STYLE="display:none;">
<TABLE BORDER='0' summary="Div Block 1">
  <TR><TD>  
      <LABEL>
      <%=UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralParentOrgReq"))%><BR>
      <INPUT size="32" type="input" name="orgname">
      </LABEL>
  </TD>
  <TD WIDTH=20 VALIGN=BOTTOM>
	    <INPUT type="button" id='content' value="<%=UIUtil.toHTML((String)userWizardNLS.get("find"))%>" onClick="parent.findOrg()">
  </TD></TR>
</TABLE>  
</DIV>
</TD></TR>
<%}%>

<TR><TD><BR></TD></TR>
</table>



</FORM>
</body>
</html>
