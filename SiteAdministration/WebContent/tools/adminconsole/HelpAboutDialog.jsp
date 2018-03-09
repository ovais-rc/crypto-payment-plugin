<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2000, 2002, 2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
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
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.user.beans.*"   %>
<%@ page import="com.ibm.commerce.user.objects.*"   %>
<%@ page import="com.ibm.commerce.wc.version.CommerceEARVersionInfo" %>

<%@ include file="../common/common.jsp" %>

<%
    
%>

<%
    try{
    
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
    
    // obtain the resource bundle for display
    Hashtable helpAboutNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.HelpAboutNLS", locale);
    Hashtable adminNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
     if (helpAboutNLS == null) System.out.println("!!!! RS is null");
     
     // Find edition-specific .product file 
     FilenameFilter filter = new FilenameFilter() {
         public boolean accept(File dir, String name) {
           if (name.endsWith(".product")) { return true; }
              else { return false; }
         }
       };


     CommerceEARVersionInfo verInfo = new CommerceEARVersionInfo();
     
     String server=null;
     if (verInfo.isToolKit()) {
     	server = "IBM WebSphere Commerce Developer";
     }
     else {
     	server = "IBM WebSphere Commerce";
     }
     
     String serverEd = verInfo.getLongEditionName();
     String serverVer = String.valueOf(verInfo.getVersion());
     String serverRel = String.valueOf(verInfo.getRelease());
     String serverMod = String.valueOf(verInfo.getModification());
     String serverFP = String.valueOf(verInfo.getFixpack());
     

     
   
     
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
   <H1><%=UIUtil.toHTML((String)adminNLS.get("CommerceSuiteTitle"))%></H1>

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

<%	if (!verInfo.isExpress()) { %>
<tr><td>
<%= UIUtil.toHTML((String)helpAboutNLS.get("productInformationPatentStatement")) %>
</td></tr>
<%	} %>

</TABLE>
</FORM>
<%} catch (Exception e) {
e.printStackTrace();
} %>
</body>
</html>
