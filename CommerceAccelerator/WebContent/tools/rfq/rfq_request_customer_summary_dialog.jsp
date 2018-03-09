<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
-->
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.common.ui.UIProperties" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>

<%@ include file="../common/common.jsp" %>

<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean" ></jsp:useBean>

<%
    Locale aLocale = null;
    String storeId= null;
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
    String ErrorMessage = request.getParameter(UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) {
	ErrorMessage = "";
    }
    if( aCommandContext!= null ) {
       	aLocale = aCommandContext.getLocale();
       	storeId = aCommandContext.getStoreId().toString();
    }
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);
    String lang = aCommandContext.getLanguageId().toString();
    if (lang == null) {
		lang =  "-1";
    } 
	String rfqId = request.getParameter("rfqId");  
	
	rfq.setInitKey_referenceNumber(new Long(rfqId));	
	com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
	
	String memberId = rfq.getMemberId();	
	UserRegistrationDataBean urdb = new UserRegistrationDataBean();	
	urdb.setDataBeanKeyMemberId(memberId);
	urdb.setCommandContext(aCommandContext);
	//as we only need to get the username for the owner of the RFQ
	//and we have already check for access control on the RFQ object.
	//com.ibm.commerce.beans.DataBeanManager.activate(urdb, request);
	urdb.populate();
		
	String logonId = urdb.getLogonId();
	
	String customerName = "";
	if(urdb.getFirstName()!=null&& !urdb.getFirstName().equals("")) {	
		customerName= urdb.getFirstName() + " " + urdb.getLastName();
	} else {
		customerName= urdb.getLastName();
	}
	String phoneNumber = "";
	if(urdb.getPhone1()!=null && !urdb.getPhone1().equals("")) {
		phoneNumber = urdb.getPhone1();
	}
	String emailAddr = "";
	if(urdb.getEmail1()!=null && !urdb.getEmail1().equals("")) {
		emailAddr = urdb.getEmail1();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>

<script type="text/javascript">
function initializeState() {
  	parent.setContentFrameLoaded(true);
}
function savePanelData() {
	return true;
}
function validatePanelData() {
	return true;
}
</script>
</head>

<body class="content" onload="initializeState();">

<br /><h1><%= rfqNLS.get("rfqcustomersummary") %></h1>
<br />

<table>
    <tr>
		<td><b><%= rfqNLS.get("rfqgeneralinformation") %></b><br /></td>
    </tr>
</table>
<br />

<table>
    <tr>
		<td><%= rfqNLS.get("rfqcustomerlogonid") %>: <%= logonId %><br /></td>
    </tr>
    <tr>
		<td><%= rfqNLS.get("rfqcustomername") %>: <%= customerName %><br /></td>
    </tr>
</table>
<br />

<table>
    <tr>
		<td><b><%= rfqNLS.get("rfqcontactinformation") %></b><br /></td>
    </tr>
</table>
<br />

<table>
    <tr>
		<td><%= rfqNLS.get("Reg_Phone") %>: <%= phoneNumber %><br /></td>
    </tr>
    <tr>
		<td><%= rfqNLS.get("Reg_Email") %>: <%= emailAddr %><br /></td>
    </tr>
</table>

<br /><br />

</body>
</html>
