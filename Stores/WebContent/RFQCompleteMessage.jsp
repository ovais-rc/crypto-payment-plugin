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
java.text.*,
java.sql.*,
java.text.*"  %>
<%@include file="RFQCommonMessage.jsp" %>
<%
String sBuyer = "";
String sBuyerOrg = "";
String sShortDesc = "";
String sCompletionDate = "";
String sResponseName = "";
String sResponseState = "";
Timestamp dateCompleted = null;

try {
	// get and format the date and time as per locale/language 
	DateFormat df_d = DateFormat.getDateInstance(DateFormat.SHORT, locale);
	DateFormat df_t = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
	java.sql.Timestamp completeTime = rfqdb.getCompleteTimeInEntityType();
	if(completeTime != null)		
		sCompletionDate = df_d.format(completeTime) + " " + df_t.format(completeTime);	

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
	
} catch(Exception exValues) {}
response.setContentType("text/html;charset=UTF-8");
%>
<%= UTFToolsMessageHelper.getUserMessage("rfqBuyer",filename,null,locale) + ": " + sBuyer %>
<%= UTFToolsMessageHelper.getUserMessage("rfqBuyerOrg",filename,null,locale) + ": " + sBuyerOrg%>
<%= UTFToolsMessageHelper.getUserMessage("rfqName",filename,null,locale) + ": " + rfqName %>
<%= UTFToolsMessageHelper.getUserMessage("rfqShortDesc",filename,null,locale) + ": " + sShortDesc %>
<%= UTFToolsMessageHelper.getUserMessage("rfqCompletionDate",filename,null,locale) + ": " + sCompletionDate %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">

<html lang="en">
<head>
<title></title>
</head>
</html>