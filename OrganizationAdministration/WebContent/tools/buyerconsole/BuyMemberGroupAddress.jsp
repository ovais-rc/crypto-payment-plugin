<!--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005, 2016
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
-->
<%@ page language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.base.objects.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %> 
<%@ page import="com.ibm.commerce.tools.xml.*" %> 
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.user.helpers.*" %>
<%@ page import="com.ibm.commerce.member.constants.ECMemberConstants" %>
<%@ page import="com.ibm.commerce.tools.segmentation.SegmentConstants"   %>

<%@ include file="../common/common.jsp" %>

<HTML>
<HEAD>
<%= fHeader%>
 
<style type='text/css'>
.selectWidth {width: 235px;}
</style>

<%
   Locale locale = null;
   String lang = null;   
                    
   CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext"); 
   String webalias = UIUtil.getWebPrefix(request);     
   if( aCommandContext!= null )
   {
      locale = aCommandContext.getLocale();
      lang = aCommandContext.getLanguageId().toString();
   }

   String mbrGrpId = request.getParameter("segmentId");
  
   // obtain the resource bundle for display        
  Hashtable userWizardNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.AdminConsoleNLS", locale);
  if (userWizardNLS == null) System.out.println("!!!! RS is null");
   
   String localeStr = locale.toString();
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelectMemberGroupType"))%></TITLE>

<SCRIPT SRC="<%=webalias%>javascript/tools/segmentation/SegmentNotebook.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/SwapList.js"></SCRIPT>


<SCRIPT Language="JavaScript">
var radiovalue = 0;

function savePanelData()
{
  var mgt =  parent.get("memberGroupType");
  parent.put("memberGroupType", mgt);    
  saveFormData();   
}

function validatePanelData()
{
  
}


function initializeState()
{   	
	 	
   init(); 
   parent.setContentFrameLoaded(true);
}


</SCRIPT>
 
</HEAD>

<BODY ONLOAD="initializeState()" class="content">
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupAddressTitle"))%></H1>
<%@ include file="SegmentCommon.jsp" %>
<%@ include file="StringValuesControl.jspf" %>

<%@ include file="AddressUDInit.jsp" %>
<FORM name="segmentForm">
<%
if (localeStr.equals("zh_TW") || localeStr.equals("zh_CN") || localeStr.equals("ja_JP") 
     || localeStr.equals("ko_KR")) {
     %>
        <%@ include file="CountryPanel.jspf" %>
<%
} else {
%>
	<%@ include file="CityPanel.jspf" %>
<%
}

if (localeStr.equals("ja_JP") || localeStr.equals("ko_KR")) {
     %>
	<%@ include file="ZipCodePanel.jspf" %>
<%
} else {
%>
	<%@ include file="StatePanel.jspf" %>
<%
}

if (localeStr.equals("zh_CN")) {
     %>
	<%@ include file="CityPanel.jspf" %>
<%
} else if (localeStr.equals("ja_JP") || localeStr.equals("ko_KR")) {
%>
	<%@ include file="StatePanel.jspf" %>
<%
} else {
%>
	<%@ include file="ZipCodePanel.jspf" %>
<%
}

if (localeStr.equals("zh_CN")) {
     %>
	<%@ include file="ZipCodePanel.jspf" %>
<%
} else if (localeStr.equals("ja_JP") || localeStr.equals("ko_KR") || localeStr.equals("zh_TW")) {
%>
	<%@ include file="CityPanel.jspf" %>
<%
} else {
%>
	<%@ include file="CountryPanel.jspf" %>
<%
}
%>
<%@ include file="PhonePanel.jspf" %>
<%@ include file="EMailPanel.jspf" %>
<p></p>
</FORM>

</BODY>
</HTML>



