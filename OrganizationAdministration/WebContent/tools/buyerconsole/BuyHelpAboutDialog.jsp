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
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>

<%@ include file="../common/common.jsp" %>

<%
    
%>

<%
    try{
    
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
    
    // obtain the resource bundle for display
    Hashtable helpAboutNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyHelpAboutNLS", locale);
     if (helpAboutNLS == null) System.out.println("!!!! RS is null");
     
     Hashtable wcsproduct = (Hashtable) ResourceDirectory.lookup("adminconsole.Product");
     
     String server = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.commerceserver.name");
     String serverEd = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.commerceserver.edition.name");
     String serverVer = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.commerceserver.version");
     String serverRel = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.commerceserver.release");
     String serverMod = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.commerceserver.modification");
     String serverFP = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.commerceserver.fixpak");
     
     
     String dbName = "";
     String dbEdit = "";
     String dbVer = "";
     String dbRel = "";
     String dbMod = "";
     String dbFP = "";
     
     
     Object temp = XMLUtil.get(wcsproduct,"websphere.commercesuite.database");
     if (temp instanceof Vector) {
     	Vector db = (Vector) temp;
     	String instDB = WcsApp.configProperties.getValue("Database/DB/DBMSName");
     	for (int i=0; i < db.size(); i++) {
     	    Hashtable dbhash = (Hashtable) db.elementAt(i);
     	    String dname = (String) XMLUtil.get(dbhash,"name");
     	    if (dname.equals(instDB)) {
     	    	dbName = (String)XMLUtil.get(dbhash,"name");
     		dbEdit = (String)XMLUtil.get(dbhash,"edition.name");
     		dbVer = (String)XMLUtil.get(dbhash,"version");
     		dbRel = (String)XMLUtil.get(dbhash,"release");
     		dbMod = (String)XMLUtil.get(dbhash,"modification");
     		dbFP = (String)XMLUtil.get(dbhash,"fixpak");
     		break;
     	    }
     	
     	}
     } else {
     
		dbName = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.database.name");
     		dbEdit = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.database.edition");
     		dbVer = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.database.version");
     		dbRel = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.database.release");
     		dbMod = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.database.modification");
     		dbFP = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.database.fixpak");
     }
     
     
     String wasName = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.appserver.name");
     String wasVer = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.appserver.version");
     String wasRel = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.appserver.release");
     String wasMod = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.appserver.modification");
     String wasFP = (String)XMLUtil.get(wcsproduct,"websphere.commercesuite.appserver.fixpak");
     
     
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head><TITLE><%=UIUtil.toHTML((String)helpAboutNLS.get("title"))%></TITLE>
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
     top.goBack();
 
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
<BODY ONLOAD="initializeState();" class="content">
   <H1><%=UIUtil.toHTML((String)helpAboutNLS.get("title"))%></H1>

<FORM NAME="wizard1">
<TABLE border=0>
<TR><TD>
<b><%=server%><b>
</TD></TR>


<TR><TD>
<%=UIUtil.toHTML((String)helpAboutNLS.get("edition"))%>:
</TD>
<TD>
<i><%=serverEd%></i>
</TD>
</TR>


<TR><TD>
<%=UIUtil.toHTML((String)helpAboutNLS.get("version"))%>:
</TD>
<TD>
<i><%=serverVer%>.<%=serverRel%></i>
</TD>
</TR>

<TR><TD>
<%=UIUtil.toHTML((String)helpAboutNLS.get("fixpak"))%>:
</TD>
<TD>
<i><%=serverFP%></i>
</TD>
</TR>


<TR><TD>
<BR>
</TD></TR>

<TR><TD>
<b><%=UIUtil.toHTML((String)helpAboutNLS.get("database"))%><b>
</TD>
<TD>
<i><%=dbName%></i>
</TD>
</TR>
<TR><TD>
<%=UIUtil.toHTML((String)helpAboutNLS.get("version"))%>:
</TD>
<TD>
<i><%=dbVer%>.<%=dbRel%></i>
</TD>
</TR>

<TR><TD>
<BR>
</TD></TR>

<TR><TD>
<BR>
</TD></TR>

<TR><TD>
<b><%=UIUtil.toHTML((String)helpAboutNLS.get("appserver2"))%><b>
</TD>
<TD>
<i><%=wasName%></i>
</TD>
</TR>
<TR><TD>
<%=UIUtil.toHTML((String)helpAboutNLS.get("version"))%>:
</TD>
<TD>
<i><%=wasVer%>.<%=wasRel%>.<%=wasFP%></i>
</TD>
</TR>


</TABLE>
</FORM>
<%} catch (Exception e) {
e.printStackTrace();
} %>
</body>
</html>
