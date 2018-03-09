<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002, 2003
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants" %>
<%@page import="com.ibm.commerce.pa.tools.guidedsell.beans.GuidedSellAllLanguageLoaderBean" %>

<%@ include file="/tools/guidedsell/GuidedSellCommon.jsp" %>
<html>
<head>
<%=fHeader%>
<title><%=guidedSellRB.get(GuidedSellUIConstants.GS_LANGUAGE_TITLE)%></title>
<script language="javascript">
function visibleList(s){
   if (this.listForm.listSelect)
   {
      this.listForm.listSelect.style.visibility = s;
   }
}
</script>
</head>
<body class="content">
<SCRIPT>
if(parent.gsframe.getNLSLanguageTitle || parent.getNLSLanguageTitle)
{
	document.writeln("<span id=\"language_title\" style=\"font-family: Verdana,Arial,Helvetica; font-size: 16pt; color: #565665; font-weight: normal; word-wrap: break-word;\"></span><BR>");
}	
</SCRIPT>
<form name="listForm" OnSubmit="return false;">
<TABLE CELLPADDING=1 CELLSPACING=5 BORDER=0 style="position: absolute; top: 35px;">
<TR>
<TD colspan="5">
<span id="language_text"  style="height: 11px; font-size: 9pt;"></span>
</TD>
</TR>
<TR>
	<TD ALIGN="LEFT" VALIGN="TOP">
	<label id="language_select" for="language_select_list"></label>
	<script>
	   <!--
      	if(parent.gsframe.getLanguageSelectText)
			this.document.all("language_select").innerHTML=parent.gsframe.getLanguageSelectText();
		else if(parent.getLanguageSelectText)
			this.document.all("language_select").innerHTML=parent.getLanguageSelectText();
	
	   //-->
	</script>
	<select id="language_select_list" name="listSelect" onChange="parent.languageListSelect(this)">
	<%
		String gsLanguageId = request.getParameter(GuidedSellUIConstants.GS_LANGUAGE_ID);

		GuidedSellAllLanguageLoaderBean gsallb = new GuidedSellAllLanguageLoaderBean();
		DataBeanManager.activate(gsallb,request);

		Vector vectIds =  gsallb.getAllLanguageIds();
		Vector vectDescs =  gsallb.getAllLanguageDescriptions();

		int length = vectIds.size();

		for(int i=0;i<length;i++){
			String langID =  (String)vectIds.elementAt(i);
			String description =  (String)vectDescs.elementAt(i);
			if(langID.equals(gsLanguageId)) {
	%>
			<option value="<%=langID%>" selected><%=toHTML(description)%></option>
	<%
			} else {
	%>
			<option value="<%=langID%>"><%=toHTML(description)%></option>
	<%
			}
		}
	%>
	</select>
	</TD>
</TR>
</TABLE>
<script>
   <!--
      if(parent.gsframe.getNLSLanguageTitle)
          this.document.all("language_title").innerHTML=parent.gsframe.getNLSLanguageTitle();
      else if(parent.getNLSLanguageTitle)
          this.document.all("language_title").innerHTML=parent.getNLSLanguageTitle();

      if(parent.getNLSInstruction)
          this.document.all("language_text").innerHTML=parent.getNLSInstruction();

   //-->
</script>
</form>
</body>
</html>
