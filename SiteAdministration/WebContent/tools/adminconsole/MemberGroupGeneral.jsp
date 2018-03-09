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
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants"   %>


<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>

<%
    // obtain the resource bundle for display
    Hashtable memberGroupWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
    Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.OrgEntityNLS", locale);
     if (memberGroupWizardNLS == null) System.out.println("!!!! RS is null");
     String memberGroupGeneralNameEmpty = UIUtil.toJavaScript((String)memberGroupWizardNLS.get("memberGroupGeneralNameEmpty"));
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)memberGroupWizardNLS.get("AdminConsoleExceedMaxLength"));
     
     String mbrGrpId = cmdContext.getRequestProperties().getString("nestMbrGrpId");
     
     MemberGroupDataBean mgdb = new MemberGroupDataBean();
     DataBeanManager.activate(mgdb, cmdContext);
     String ownerId = "";
     String name = "";
     String mgrpname = "";
     
     for (int i=0; i < mgdb.getSize(); i++) {
     
         String id = mgdb.getMemberGroupId(i);
         if (id.equals(mbrGrpId)) {
             mgrpname = mgdb.getName(i);
             OrgEntityDataBean oedb = new OrgEntityDataBean();
             oedb.setDataBeanKeyMemberId(mgdb.getOwnerId(i));
             DataBeanManager.activate(oedb, cmdContext);
             
             name = oedb.getOrgEntityName();
             break;
         }
     }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><TITLE><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralIndex"))%></TITLE>
<%= fHeader%>
<LINK rel=stylesheet href="<%=UIUtil.getCSSFile(cmdContext.getLocale())%>" type="text/css">

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
   <H1><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralIndex"))%></H1>
   <LINE3><%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralMsg"))%></LINE3>

<FORM NAME="wizard1">
<table border=0>
<% if (!(mbrGrpId == null || mbrGrpId.equals(""))) {  %>
<TR>
<TD>
	<%= UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralName")) %><BR>
	<i><%=mgrpname%></i>
</TD>
</TR>

<%}else {%>
<TR<TD>
<LABEL>
<%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralNameReq"))%><BR>
<INPUT size="35" type="input" name="name"><BR><BR>
</LABEL>
</TD><TR>
<%}%>
<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)memberGroupWizardNLS.get("memberGroupGeneralDesc"))%><BR>
<INPUT size="35" type="input" name="desc"><BR>
</LABEL>
</TD><TR>

<% if (!(mbrGrpId == null || mbrGrpId.equals(""))) {  %>
<TR>
<TD>
	<%= UIUtil.toHTML((String)orgEntityNLS.get("OrgEntityGeneralParentOrg")) %><BR>
	<i><%=name%></i>
</TD>
</TR>
<%} else {%>
<TR>
<TD>
      <LABEL>
      <%=UIUtil.toHTML((String)memberGroupWizardNLS.get("userAdminParentOrgReq"))%><BR>
      <INPUT size="32" type="input" name="orgname">
      </LABEL>
</TD>
<TD WIDTH=20 VALIGN=BOTTOM>
	    <INPUT type="button" id='content' value="<%=UIUtil.toHTML((String)memberGroupWizardNLS.get("find"))%>" onClick="parent.findOrg()">
</TD>
</TR>
<% } %>


</FORM>
</body>
</html>
