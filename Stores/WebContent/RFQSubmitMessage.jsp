<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*
//*-------------------------------------------------------------------
//*Note: DataBeanManager.activate() is not called because there is no 
//*CommandContext set up when jsp is executed by messaging system thru
//*scheduler 
//*-------------------------------------------------------------------
//*
--%>
<%@ page import="com.ibm.commerce.common.beans.*,
com.ibm.commerce.negotiation.beans.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.member.helpers.*,
com.ibm.commerce.negotiation.util.*,
com.ibm.commerce.utf.utils.*,
java.text.*,
java.sql.*" %>
<%@include file="RFQCommonMessage.jsp" %>
<%
 // Body content section
String sBuyer = "";
String sBuyerOrg = "";
String sShortDesc = "";
Integer endResult = null;
String sSubmissionDate = "";	
Timestamp dateSubmission = null;

try {
	endResult = rfqdb.getEndResultInEntityType();
	// get and format the date and time as per locale/language 
	DateFormat df_d = DateFormat.getDateInstance(DateFormat.SHORT, locale);
	DateFormat df_t = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
	java.sql.Timestamp activateTime = rfqdb.getActivateTimeInEntityType();
	if(activateTime != null)		
		sSubmissionDate = df_d.format(activateTime) + " " + df_t.format(activateTime);	

	String sMemberId = rfqdb.getMemberId();
	UserManageBean user = new UserManageBean();
	user.setInitKey(sMemberId);
	sBuyer = user.getAttribute("displayName");

	Long[] ancestors = user.getAncestors();
	if(ancestors != null) {
		OrgEntityManageBean org = new OrgEntityManageBean();
		org.setInitKey(ancestors[0].toString());
		sBuyerOrg = org.getAttribute("displayName");			
	}

	TradingDescriptionAccessBean tdab = rfqdb.getDescription(langId);
	sShortDesc = tdab.getShortDescription();

} catch(Exception exValues){}
response.setContentType("text/html;charset=UTF-8");
String sEndResult = UTFToolsMessageHelper.getUserMessage("rfqEndResult", filename, null, locale) + ": ";
if (endResult.equals(UTFConstants.EC_UTF_ENDRESULT_CONTRACT)) {
	sEndResult += UTFToolsMessageHelper.getUserMessage("contract", filename, null, locale);
} else {
	sEndResult += UTFToolsMessageHelper.getUserMessage("order", filename, null, locale);
}
%>
<%= UTFToolsMessageHelper.getUserMessage("rfqBuyer", filename, null, locale) + ": " + sBuyer %>
<%= UTFToolsMessageHelper.getUserMessage("rfqBuyerOrg", filename, null, locale) + ": " + sBuyerOrg%>
<%= UTFToolsMessageHelper.getUserMessage("rfqName", filename, null, locale) + ": " + rfqName %>
<%= sEndResult %>
<%= UTFToolsMessageHelper.getUserMessage("rfqShortDesc", filename, null, locale) + ": " + sShortDesc %>
<%= UTFToolsMessageHelper.getUserMessage("rfqSubmissionDate", filename, null, locale) + ": " + sSubmissionDate %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">

<html lang="en">
<head>
<title></title>
</head>
</html>