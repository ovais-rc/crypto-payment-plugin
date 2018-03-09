<%
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
//*
%>

<%@page import="java.util.*" %> 
<%@page import="com.ibm.commerce.tools.util.*" %> 
<%@page import="com.ibm.commerce.tools.common.*" %>                          
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %> 
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.contract.beans.*" %> 
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.user.beans.*" %>
<%@page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.StringPair" %>
<%@page import="com.ibm.commerce.contract.helper.*" %>

<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
	try{
   		JSPHelper jspHelper = new JSPHelper(request);	      	
		String org_id = jspHelper.getParameter("orgID");

   		StoreCreationWizardDataBean scDB = new StoreCreationWizardDataBean ();
   		DataBeanManager.activate(scDB, request);

   		String ownerPrimaryAdressId = scDB.getOwnerPrimaryAddressId(org_id);

   		AddressDataBean addDB = new AddressDataBean(); 
   		addDB.setAddressId(ownerPrimaryAdressId);
   		addDB.setMemberId(org_id);
   		DataBeanManager.activate(addDB, request);

   		String orgAddress = (String) resourceBundle.get("summaryNA");
   		String orgCountry = null;
   		String orgZipCode = null;
   		String orgCity = null;
   		String orgState = null;

   		orgAddress = addDB.getAddress1();
   		orgCountry = addDB.getCountryDisplayName();
   		orgZipCode = addDB.getZipCode();
   		orgCity = addDB.getCity();
   		orgState = addDB.getStateProvDisplayName();
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">

<script language="JavaScript">
function init(){
	parent.summaryArray["summaryOrgAddress"] = "<%=UIUtil.toJavaScript(orgAddress)%>";
	parent.summaryArray["summaryOrgCountry"] = "<%=UIUtil.toJavaScript(orgCountry)%>";
	parent.summaryArray["summaryOrgCity"] = "<%=UIUtil.toJavaScript(orgCity)%>";
	parent.summaryArray["summaryOrgState"] = "<%=UIUtil.toJavaScript(orgState)%>";
	parent.summaryArray["summaryOrgZipCode"] = "<%=UIUtil.toJavaScript(orgZipCode)%>";		
	parent.summaryArray["summaryOrgAddress"] = parent.generateAddress();
	parent.summaryArray["summaryFulfillment"] = parent.generateFulfillment();
	parent.summaryArray["summaryPayments"] = parent.generatePaymentTable();	
	parent.generateSummaryTable();
}

</script>
</head>
<body onload="init()" class="content">
</body>
</html>
<%
    }catch (Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
    <% }	
%>
