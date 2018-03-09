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
   
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupSelectMemberGroupType"))%></TITLE>

<SCRIPT SRC="<%=webalias%>javascript/tools/segmentation/SegmentNotebook.js"></SCRIPT>
<SCRIPT Language="JavaScript">
var radiovalue = 0;

function savePanelData()
{
  var mgt =  parent.get("memberGroupType");
  parent.put("memberGroupType", mgt);
  saveFormData();
  <% if ((mbrGrpId == null || mbrGrpId.equals(""))) {  %>
  	parent.setNextBranch("Address"); 
  <% } %>  
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
<H1><%=UIUtil.toHTML((String)userWizardNLS.get("memberGroupDemographicsTitle"))%></H1>
<%@ include file="SegmentCommon.jsp" %>
<%@ include file="ValueCheckBoxes.jspf" %>
<%@ include file="IntegerSelect.jspf" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.common.beans.ResourceBundleDataBean" %>
<%
	ResourceBundleDataBean usrResourceBundle= new ResourceBundleDataBean();
	usrResourceBundle.setPropertyFileName(SegmentConstants.SEGMENTATION_USER_REGISTRATION);
	DataBeanManager.activate(usrResourceBundle, request);
	Hashtable userRegistration = (Hashtable) usrResourceBundle.getPropertyHashtable();
%>	
	
<%@ include file="DemographicsUDInit.jsp" %>
<FORM name="segmentForm">
<%@ include file="GenderPanel.jspf" %>
<%@ include file="AgePanel.jspf" %>
<%@ include file="IncomePanel.jspf" %>
<%@ include file="MaritalStatusPanel.jspf" %>
<%@ include file="ChildrenPanel.jspf" %> 
<%@ include file="HouseholdPanel.jspf" %> 
 <p></p>
</FORM>

</BODY>
</HTML>



