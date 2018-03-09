<%@page import="java.util.*,
                com.ibm.commerce.tools.common.*,
                com.ibm.commerce.command.*,
                com.ibm.commerce.server.*,
                com.ibm.commerce.tools.util.*,
                com.ibm.commerce.tools.xml.*,
                com.ibm.commerce.datatype.*,
                com.ibm.commerce.beans.*"
%>
<%@page import="com.ibm.commerce.tools.resourcebundle.*"
%>
<%
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
  CommandContext cmdContext  = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
  Locale locale = cmdContext.getLocale();
  ResourceBundleProperties taxNLS = (ResourceBundleProperties)ResourceDirectory.lookup("taxation.taxationNLS", locale);
%>
<%@include file="../common/common.jsp" %>
<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%= UIUtil.getCSSFile(locale) %>" TYPE="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 370px;}
</STYLE>
<SCRIPT LANGUAGE="JavaScript">
function visibleList(s){
 if (this.f1.langList)
 {
    this.f1.langList.style.visibility = s;
 }
}
</SCRIPT>
</HEAD>
<BODY ONLOAD="parent.populateLanguageList();" CLASS="content">  
 <FORM NAME="f1">
  <H1><%=taxNLS.getProperty("taxWizardCategoriesMLSTab")%></H1>
  <%=taxNLS.getProperty("CategoriesLangMsg")%>
  <BR>
  <BR>
  <TABLE>
   <TR>
	  <TD><%=taxNLS.getProperty("SelectLanguage")%></TD>
	</TR>
	<TR>
	  <TD><LABEL for="langList"><SELECT NAME="langList" ID="langList" WIDTH=200 SIZE=1 ONCHANGE="parent.languageChanged()"></SELECT></LABEL></TD>
	</TR>
  </TABLE>
 </FORM>
</BODY>
</HTML>

