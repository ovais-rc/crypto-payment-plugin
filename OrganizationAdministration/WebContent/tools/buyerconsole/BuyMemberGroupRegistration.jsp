<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM 
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
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
   
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelectMemberGroupType"))%></TITLE>

<SCRIPT SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/DateUtil.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/common/Calendar.js"></SCRIPT>
<SCRIPT SRC="<%=webalias%>javascript/tools/buyerconsole/MemberGroupCustomerTerritoryGroup.js"></SCRIPT>
<SCRIPT Language="JavaScript"> 
var radiovalue = 0;

function savePanelData()
{
  var mgt =  parent.get("memberGroupType");
  parent.put("memberGroupType", mgt);
  saveFormData();
  <% if ((mbrGrpId == null || mbrGrpId.equals(""))) {  %> 
  parent.setNextBranch("Demographics"); 
  <% } %>    
}

function validatePanelData()
{
	if (!validateRegistrationDate()) {
		return false;
	}
	if (!validateRegistrationChangeDate()) {
		return false;
	}
	return true;
}

function initializeState()
{
   init();
   parent.setContentFrameLoaded(true);
}
  
</SCRIPT>
 
</HEAD> 

<BODY ONLOAD="initializeState()" class="content">
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupRegistrationTitle"))%></H1>
<IFRAME STYLE="display:none;position:absolute;width:198;height:230;z-index=100" ID="CalFrame" TITLE="calendarTitle" MARGINHEIGHT=0 MARGINWIDTH=0  FRAMEBORDER=0 SCROLLING=NO SRC="/webapp/wcs/orgadmin/servlet/tools/common/Calendar.jsp" ></IFRAME>
<%@ include file="SegmentCommon.jsp" %>
<%@ include file="ValueCheckBoxes.jspf" %>
<%@ include file="DateEntryfield.jspf" %>
<%@ include file="StringValuesControl.jspf" %>
<%@ include file="ValueCheckBox.jspf" %>

<%@ include file="RegistrationUDInit.jsp" %>
<FORM name="segmentForm"> 

<%@ include file="RegistrationDatePanel.jspf" %>
<%@ include file="RegistrationChangeDatePanel.jspf" %>
<%@ include file="InterestsPanel.jspf" %>
<%@ include file="CompanyPanel.jspf" %>
<%-- @ include file="CurrencyPanel.jsp" --%><%-- problem: currency databean uses storeId --%>
<%@ include file="LanguagePanel.jspf" %>
<%@ include file="JobFunctionPanel.jspf" %>
<%@ include file="PreferredCommunicationPanel.jspf" %>

<p></p>
 
</FORM>

</BODY>
</HTML>



