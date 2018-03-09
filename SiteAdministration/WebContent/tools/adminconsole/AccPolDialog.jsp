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
<%@ page import="com.ibm.commerce.securitygui.commands.ToolsSecurityConstants"   %>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = cmdContext.getLocale();
    String webalias = UIUtil.getWebPrefix(request);
%>

<%
    // obtain the resource bundle for display
    Hashtable securityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.SecurityNLS", locale);
     if (securityNLS == null) System.out.println("!!!! RS is null");
     String memberGroupGeneralNameEmpty = UIUtil.toJavaScript((String)securityNLS.get("memberGroupGeneralNameEmpty"));
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)securityNLS.get("SecurityExceedMaxLength"));
     
     String accId = request.getParameter("accId");
     String editPassId = "";
     String editLckId = "";
     PolicyAccountDataBean padb = new PolicyAccountDataBean();
     padb.setCommandContext(cmdContext);
     Vector accVec = (Vector) padb.getPolicyAcct();
     String editDesc = "";
     
     if (accId != null) {
     	padb.setDataBeanKeyIPolicyAccountId(accId);
     	for (int i=0; i < accVec.size(); i++) {
     	    Vector tmpAccVec = (Vector) accVec.elementAt(i);
     	    if (accId.equals((String) tmpAccVec.elementAt(0))) {
     	        editDesc = (String) tmpAccVec.elementAt(1);
     	        editPassId = (String) tmpAccVec.elementAt(5);
     	        editLckId = (String) tmpAccVec.elementAt(3);
     	    }
     	}
     }
     
     PolicyAccountLockoutDataBean paldb = new PolicyAccountLockoutDataBean();
     paldb.setCommandContext(cmdContext);
     Vector lckVec = paldb.getPolicyAccLck();
     
     int numLck = lckVec.size();
     
     PolicyPasswordDataBean ppdb = new PolicyPasswordDataBean();
     ppdb.setCommandContext(cmdContext);
     Vector passVec = ppdb.getPolicyPassword();
     
     int numPass = passVec.size();
     
     
     
        
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
<head><title><%=UIUtil.toHTML((String)securityNLS.get("secAcctPolicy"))%></title>
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
   var x = "<%=UIUtil.toJavaScript(accId)%>";
   if (!(x == null || x== "")) {
   
   	document.wizard1.name.value = "<%=editDesc%>";
   	
   	for (var i=0; i < <%=numPass%>; i++) {
   	        if (document.wizard1.SelectPwdPol[i].value == "<%=editPassId%>") document.wizard1.SelectPwdPol[i].selected = true;
   	}
   	
   	for (var j=0; j < <%=numLck%>; j++) {
   		if (document.wizard1.SelectAccLckPol[j].value == "<%=editLckId%>") document.wizard1.SelectAccLckPol[j].selected = true;
   	}
       
   }
 
   
   parent.setContentFrameLoaded(true);

}


/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function savePanelData()
{
        
    parent.put("<%=ToolsSecurityConstants.TSC_PLCYACCT_PLCYACCT_ID%>","<%=UIUtil.toJavaScript(accId)%>");
	parent.put("<%=ToolsSecurityConstants.TSC_PLCY_DESCRIPTION%>",document.wizard1.name.value);
	var pwdId = document.wizard1.SelectPwdPol.selectedIndex;
	parent.put("<%=ToolsSecurityConstants.TSC_PLCYACCT_PLCYPASSWD_ID%>",document.wizard1.SelectPwdPol[pwdId].value);
	var lckId = document.wizard1.SelectAccLckPol.selectedIndex;
	parent.put("<%=ToolsSecurityConstants.TSC_PLCYACCT_PLCYACCLCK_ID%>",document.wizard1.SelectAccLckPol[lckId].value);
	parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData()
{
     var nameArray = new Array();
       
     <% for (int i =0; i < accVec.size(); i++) {
   	    Vector tmpVec = (Vector) accVec.elementAt(i);
	    String accName = (String) tmpVec.elementAt(1);
	    String id = (String) tmpVec.elementAt(0);
            out.println("nameArray[" + i + "] = new Array();");
            out.println("nameArray[" + i + "].name ='" + UIUtil.toJavaScript(accName) + "';");
            out.println("nameArray[" + i + "].id ='" + id + "';");
     } %>
     
 
     if (isEmpty(document.wizard1.name.value)) {
     	alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("memberGroupGeneralNameEmpty"))%>");
     	return false;
     }
     
     
     
     
        for (var j=0; j < nameArray.length; j++) {
            if (trim(document.wizard1.name.value) == nameArray[j].name && nameArray[j].id != '<%=UIUtil.toJavaScript(accId)%>') {
	       alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("nameAlreadyExists"))%>");
     	       return false;
     	    }
        }
     

     
     if(!isValidUTF8length(document.wizard1.name.value, 256))
  	{
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
   <H1><%=UIUtil.toHTML((String)securityNLS.get("secAcctPolicy"))%></H1>
   <LINE3><%=UIUtil.toHTML((String)securityNLS.get("accPolMsg"))%></LINE3>

<FORM NAME="wizard1">
<TABLE border=0>
<TR><TD>

<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("memberGroupGeneralNameReq"))%><BR>
<INPUT size="35" type="input" name="name"><BR><BR>
</LABEL>

</TD></TR>
<TR><TD>
<LABEL for="SelectPwdPol1">
<%=UIUtil.toHTML((String)securityNLS.get("secPassPolicy"))%><BR>
<SELECT NAME="SelectPwdPol" id="SelectPwdPol1">
<% for (int i=0; i < numPass; i++) {

	Vector tmp1 = (Vector) passVec.elementAt(i);
	String passId = (String) tmp1.elementAt(0);
	String passDescription = (String) tmp1.elementAt(9);
%>
		<OPTION  VALUE="<%=passId%>"><%=passDescription%></OPTION>
<%}%>
</SELECT><BR><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL for="SelectAccLckPol1">
<%=UIUtil.toHTML((String)securityNLS.get("secLockPolicy"))%><BR>
<SELECT NAME="SelectAccLckPol" id="SelectAccLckPol1" >
<% for (int i=0; i < numLck; i++) {

	Vector tmp2 = (Vector) lckVec.elementAt(i);
	String lckId = (String) tmp2.elementAt(0);
	String lckDescription = (String) tmp2.elementAt(3);
%>
		<OPTION  VALUE="<%=lckId%>"><%=lckDescription%></OPTION>
<%}%>
</SELECT>
</LABEL>
</TD></TR>
</TABLE>
</FORM>
</body>
</html>
