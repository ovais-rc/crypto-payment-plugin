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
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>
<%@ page import="com.ibm.commerce.securitygui.commands.*" %>


<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String langId = (cmdContext.getLanguageId()).toString();
    String webalias = UIUtil.getWebPrefix(request);
%>

<%
    // obtain the resource bundle for display
    Hashtable securityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.SecurityNLS", locale);
     if (securityNLS == null) System.out.println("!!!! RS is null");
     String memberGroupGeneralNameEmpty = UIUtil.toJavaScript((String)securityNLS.get("memberGroupGeneralNameEmpty"));
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)securityNLS.get("SecurityExceedMaxLength"));
     
     String desc = "";
     String thresh = "6";
     String waitT = "10";
     
     String accLckId = request.getParameter("accLckId");
     PolicyAccountLockoutDataBean palab = new PolicyAccountLockoutDataBean();;
     palab.setCommandContext(cmdContext);
     Vector lckVec = palab.getPolicyAccLck();
     
     if (accLckId != null) {
     for (int i=0; i < lckVec.size(); i++) {
     	    Vector tmpLckVec = (Vector) lckVec.elementAt(i);
     	    if (accLckId.equals((String) tmpLckVec.elementAt(0))) {
		desc = (String) tmpLckVec.elementAt(3);
		thresh = (String) tmpLckVec.elementAt(1);
		waitT = (String) tmpLckVec.elementAt(2);
	    }
     }
     }

     
     
     
        
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head><title><%=UIUtil.toHTML((String)securityNLS.get("acctLckPolicy"))%></title>
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
   
   document.wizard1.name.value = "<%=desc%>";
   document.wizard1.lckThresh.value = "<%=thresh%>";
   document.wizard1.waitTime.value = "<%=waitT%>";
   
   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
   if (!(isEmpty(document.wizard1.name.value))) {
     	parent.put('<%=ToolsSecurityConstants.TSC_PLCY_DESCRIPTION%>', document.wizard1.name.value);
   }
   
   parent.put('<%=ToolsSecurityConstants.TSC_PLCYACCLCK_LOCKOUTTHRESHOLD%>', document.wizard1.lckThresh.value);
   parent.put('<%=ToolsSecurityConstants.TSC_PLCYACCLCK_WAITTIME%>', document.wizard1.waitTime.value);
   
   parent.put('<%=ECConstants.EC_REDIRECTURL%>', 'DialogNavigation');
   
   var id = "<%=UIUtil.toJavaScript(accLckId)%>";
   if (!(id == null || id == "")) {	
   	parent.put("<%=ToolsSecurityConstants.TSC_PLCYACCLCK_PLCYACCLCK_ID%>", "<%=UIUtil.toJavaScript(accLckId)%>");
   }
   parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData()
{
     var nameArray = new Array();
       
     <% for (int i =0; i < lckVec.size(); i++) {
   	    Vector tmpVec = (Vector) lckVec.elementAt(i);
	    String lckName = (String) tmpVec.elementAt(3);
	    String id = (String) tmpVec.elementAt(0);
            out.println("nameArray[" + i + "] = new Array();");
            out.println("nameArray[" + i + "].name ='" + UIUtil.toJavaScript(lckName) + "';");
            out.println("nameArray[" + i + "].id ='" + id + "';");
     } %>
 
     if (isEmpty(document.wizard1.name.value)) {
     	alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("memberGroupGeneralNameEmpty"))%>");
     	return false;
     }
     
     if(!isValidUTF8length(document.wizard1.name.value, 256)) 	{
     	document.wizard1.name.select();
	alertDialog("<%= AdminConsoleExceedMaxLength %>");
      	return false;
     }
     
        for (var j=0; j < nameArray.length; j++) {
            if (trim(document.wizard1.name.value) == nameArray[j].name && nameArray[j].id != '<%=UIUtil.toJavaScript(accLckId)%>') {
	       alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("nameAlreadyExists"))%>");
     	       return false;
     	    }
        }
     
     
     if(!parent.isValidInteger(document.wizard1.lckThresh.value, '<%=locale%>')) {
        document.wizard1.lckThresh.select();
        alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
        return false;
     }
     
     if(!isValidUTF8length(document.wizard1.lckThresh.value, 5)) 	{
     	document.wizard1.lckThresh.select();
	alertDialog("<%= AdminConsoleExceedMaxLength %>");
      	return false;
     }
     
     if(!parent.isValidInteger(document.wizard1.waitTime.value, '<%=locale%>')) {
     	document.wizard1.waitTime.select();
     	alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
     	return false;
     }
     
     if(!isValidUTF8length(document.wizard1.waitTime.value, 5)) 	{
     	document.wizard1.waitTime.select();
	alertDialog("<%= AdminConsoleExceedMaxLength %>");
      	return false;
     }
     
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
<BODY ONLOAD="initializeState();" class="content">
   <H1><%=UIUtil.toHTML((String)securityNLS.get("acctLckPolicy"))%></H1>
   <LINE3><%=UIUtil.toHTML((String)securityNLS.get("accLckPolMsg"))%></LINE3>

<FORM NAME="wizard1">
<TABLE border=0>
<TR><TD>

<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("memberGroupGeneralNameReq"))%><BR>
<INPUT size="35" type="input" name="name"><BR><BR>
</LABEL>

</TD></TR>
<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("accLckThresh"))%><BR>
<INPUT size="35" type="input" name="lckThresh"><BR><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("accLckWaitTime"))%><BR>
<INPUT size="35" type="input" name="waitTime"><BR><BR>
</LABEL>
</TD></TR>
</TABLE>
</FORM>
</body>
</html>
