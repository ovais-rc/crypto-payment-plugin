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
    // use the invalidParameters message from the rules resource bundle since no NL message are allowed to be added in fp
    Hashtable rulesNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.rulesNLS", locale);
    if (rulesNLS == null) System.out.println("!!!! rules RS is null");
    String strInvalidParameterMsg = UIUtil.toJavaScript((String)rulesNLS.get("invalidParameters"));
    // obtain the resource bundle for display
    Hashtable securityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.SecurityNLS", locale);
     if (securityNLS == null) System.out.println("!!!! security RS is null");
     String memberGroupGeneralNameEmpty = UIUtil.toJavaScript((String)securityNLS.get("memberGroupGeneralNameEmpty"));
     String AdminConsoleExceedMaxLength = UIUtil.toJavaScript((String)securityNLS.get("SecurityExceedMaxLength"));


     String desc = "";
     String matchPwdPol = "0";
     String maxConsChar = "4";
     String maxInstChar = "3";
     String reuse = "4";
     String minNumNum = "1";
     String minNumAlpha = "1";
     String maxLifePass = "90";
     String minLengthPass = "8";

     String passId = request.getParameter("passId");
     PolicyPasswordDataBean ppdb = new PolicyPasswordDataBean();;
     ppdb.setCommandContext(cmdContext);
     Vector ppVec = ppdb.getPolicyPassword();

     if (passId != null) {
     for (int i=0; i < ppVec.size(); i++) {
     	    Vector tmpPPVec = (Vector) ppVec.elementAt(i);
     	    if (passId.equals((String) tmpPPVec.elementAt(0))) {

     		desc = (String) tmpPPVec.elementAt(9);
		matchPwdPol = (String) tmpPPVec.elementAt(1);
	        maxConsChar = (String) tmpPPVec.elementAt(2);
        	maxInstChar = (String) tmpPPVec.elementAt(3);
	        reuse = (String) tmpPPVec.elementAt(8);
	        int nReuse = Integer.valueOf(reuse).intValue();
	        if (nReuse < 0) {
	        	nReuse = -nReuse;
	        	reuse = String.valueOf(nReuse);
	        }
	        else if (nReuse == 0) {
	        	reuse = "1";
	        }
	        else {
	        	reuse = "0";
	        }
        	minNumNum = (String) tmpPPVec.elementAt(6);
	        minNumAlpha = (String) tmpPPVec.elementAt(5);
        	maxLifePass = (String) tmpPPVec.elementAt(4);
	        minLengthPass = (String) tmpPPVec.elementAt(7);
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
<head><title><%=UIUtil.toHTML((String)securityNLS.get("passPolicy"))%></title>
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
   document.wizard1.maxConsChar.value = "<%=maxConsChar%>";
   document.wizard1.maxInstChar.value = "<%=maxInstChar%>";
   document.wizard1.minLengthPass.value = "<%=minLengthPass%>";
   document.wizard1.minNumNum.value = "<%=minNumNum%>";
   document.wizard1.minNumAlpha.value = "<%=minNumAlpha%>";
   document.wizard1.maxLifePass.value = "<%=maxLifePass%>";

   var id = "<%=UIUtil.toJavaScript(passId)%>";
   if (!(id == null || id == "")) {
        document.wizard1.reuse[<%=reuse%>].selected = true;
        document.wizard1.matchPwdPol[<%=matchPwdPol%>].selected = true;
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

     parent.put("<%=ToolsSecurityConstants.TSC_PLCY_DESCRIPTION%>",document.wizard1.name.value);
     var matchIndex = document.wizard1.matchPwdPol.selectedIndex;
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_MATCHUSERID%>",document.wizard1.matchPwdPol[matchIndex].value);
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_MAXINSTANCES%>",document.wizard1.maxInstChar.value);
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_MAXLIFETIME%>",document.wizard1.maxLifePass.value);
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_MINALPHABETIC%>",document.wizard1.minNumAlpha.value);
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_MINNUMERIC%>",document.wizard1.minNumNum.value);
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_MINPASSWDLENGTH%>",document.wizard1.minLengthPass.value);
     var reuseIndex = document.wizard1.reuse.selectedIndex;
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_REUSEPASSWORD%>",document.wizard1.reuse[reuseIndex].value);
     parent.put("<%=ToolsSecurityConstants.TSC_PLCYPASSWD_MAXCONSECUTIVETYPE%>",document.wizard1.maxConsChar.value);

     parent.put("<%=ToolsSecurityConstants.TSC_PLCYACCT_PLCYPASSWD_ID%>", "<%=UIUtil.toJavaScript(passId)%>");
     parent.addURLParameter("authToken", "${authToken}");
}

function validatePanelData()
{
     var nameArray = new Array();

     <% for (int i =0; i < ppVec.size(); i++) {
   	    Vector tmpVec = (Vector) ppVec.elementAt(i);
	    String ppName = (String) tmpVec.elementAt(9);
	    String id = (String) tmpVec.elementAt(0);
            out.println("nameArray[" + i + "] = new Array();");
            out.println("nameArray[" + i + "].name ='" + UIUtil.toJavaScript(ppName) + "';");
            out.println("nameArray[" + i + "].id ='" + id + "';");
     } %>


     if (isEmpty(document.wizard1.name.value)) {
     	alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("memberGroupGeneralNameEmpty"))%>");
     	return false;
     }

     if(!isValidUTF8length(document.wizard1.name.value, 256))
  	{
  		document.wizard1.name.select();
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }

        for (var j=0; j < nameArray.length; j++) {
            if (trim(document.wizard1.name.value) == nameArray[j].name && nameArray[j].id != '<%=UIUtil.toJavaScript(passId)%>') {
	       alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("nameAlreadyExists"))%>");
     	       return false;
     	    }
        }


     if(!parent.isValidInteger(document.wizard1.maxConsChar.value, '<%=locale%>')) {
        document.wizard1.maxConsChar.select();
        alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
        return false;
     }

     if(!isValidPositiveInteger(document.wizard1.maxConsChar.value))
     {
  		document.wizard1.maxConsChar.select();
		alertDialog("<%= strInvalidParameterMsg %>");
      		return false;
     }

     if(!isValidUTF8length(document.wizard1.maxConsChar.value, 5))
  	{
  		document.wizard1.maxConsChar.select();
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }

     if(!parent.isValidInteger(document.wizard1.maxInstChar.value, '<%=locale%>')) {
        document.wizard1.maxInstChar.select();
        alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
        return false;
     }

     if(!isValidPositiveInteger(document.wizard1.maxInstChar.value))
     {
  		document.wizard1.maxInstChar.select();
		alertDialog("<%= strInvalidParameterMsg %>");
      		return false;
     }

     if(!isValidUTF8length(document.wizard1.maxInstChar.value, 5))
  	{
  		document.wizard1.maxInstChar.select();
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }

     if(!parent.isValidInteger(document.wizard1.minNumNum.value, '<%=locale%>')) {
        document.wizard1.minNumNum.select();
        alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
        return false;
     }

     if(!isValidPositiveInteger(document.wizard1.minNumNum.value))
     {
  		document.wizard1.minNumNum.select();
		alertDialog("<%= strInvalidParameterMsg %>");
      		return false;
     }

     if(!isValidUTF8length(document.wizard1.minNumNum.value, 5))
  	{
  		document.wizard1.minNumNum.select();
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }

     if(!parent.isValidInteger(document.wizard1.minNumAlpha.value, '<%=locale%>')) {
        document.wizard1.minNumAlpha.select();
        alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
        return false;
     }

     if(!isValidPositiveInteger(document.wizard1.minNumAlpha.value))
     {
  		document.wizard1.minNumAlpha.select();
		alertDialog("<%= strInvalidParameterMsg %>");
      		return false;
     }

     if(!isValidUTF8length(document.wizard1.minNumAlpha.value, 5))
  	{
  		document.wizard1.minNumAlpha.select();
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }

     if(!parent.isValidInteger(document.wizard1.maxLifePass.value, '<%=locale%>')) {
        document.wizard1.maxLifePass.select();
        alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
        return false;
     }

     if(!isValidPositiveInteger(document.wizard1.maxLifePass.value))
     {
  		document.wizard1.maxLifePass.select();
		alertDialog("<%= strInvalidParameterMsg %>");
      		return false;
     }

     if(!isValidUTF8length(document.wizard1.maxLifePass.value, 5))
  	{
  		document.wizard1.maxLifePass.select();
		alertDialog("<%= AdminConsoleExceedMaxLength %>");
      		return false;
     }

     if(!parent.isValidInteger(document.wizard1.minLengthPass.value, '<%=locale%>')) {
        document.wizard1.minLengthPass.select();
        alertDialog("<%=UIUtil.toHTML((String)securityNLS.get("SecurityNotAnInteger"))%>");
        return false;
     }

     if(!isValidPositiveInteger(document.wizard1.minLengthPass.value))
     {
  		document.wizard1.minLengthPass.select();
		alertDialog("<%= strInvalidParameterMsg %>");
      		return false;
     }

     if(!isValidUTF8length(document.wizard1.minLengthPass.value, 5))
  	{
  		document.wizard1.minLengthPass.select();
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
   <H1><%=UIUtil.toHTML((String)securityNLS.get("passPolicy"))%></H1>
   <LINE3><%=UIUtil.toHTML((String)securityNLS.get("passPolMsg"))%></LINE3>

<FORM NAME="wizard1">
<TABLE border=0>
<TR><TD>

<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("memberGroupGeneralNameReq"))%><BR>
<INPUT size="35" type="input" name="name"><BR>
</LABEL>

</TD></TR>
<TR><TD>
<LABEL for="matchPwdPol1">
<%=UIUtil.toHTML((String)securityNLS.get("match"))%><BR>
<SELECT NAME="matchPwdPol" id="matchPwdPol1">

		<OPTION  VALUE="0"><%=UIUtil.toHTML((String)securityNLS.get("no"))%></OPTION>
		<OPTION  VALUE="1"><%=UIUtil.toHTML((String)securityNLS.get("yes"))%></OPTION>
</SELECT><BR><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("maxConsChar"))%><BR>
<INPUT size="35" type="input" name="maxConsChar"><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("maxInstChar"))%><BR>
<INPUT size="35" type="input" name="maxInstChar"><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("maxLifePass"))%><BR>
<INPUT size="35" type="input" name="maxLifePass"><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("minNumAlpha"))%><BR>
<INPUT size="35" type="input" name="minNumAlpha"><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("minNumNum"))%><BR>
<INPUT size="35" type="input" name="minNumNum"><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL>
<%=UIUtil.toHTML((String)securityNLS.get("minLengthPass"))%><BR>
<INPUT size="35" type="input" name="minLengthPass"><BR>
</LABEL>
</TD></TR>

<TR><TD>
<LABEL for="reuse1">
<%=UIUtil.toHTML((String)securityNLS.get("reuse"))%><BR>
<SELECT NAME="reuse" id="reuse1" >

		<OPTION  VALUE="0">0</OPTION>
		<OPTION  VALUE="1">1</OPTION>
		<OPTION  VALUE="2">2</OPTION>
		<OPTION  VALUE="3">3</OPTION>
		<OPTION  VALUE="4">4</OPTION>
		<OPTION  VALUE="5">5</OPTION>
		<OPTION  VALUE="6">6</OPTION>
		<OPTION  VALUE="7">7</OPTION>
		<OPTION  VALUE="8">8</OPTION>
		<OPTION  VALUE="9">9</OPTION>
		<OPTION  VALUE="10">10</OPTION>
</SELECT><BR><BR>
</LABEL>
</TD></TR>
</TABLE>
</FORM>
</body>
</html>
