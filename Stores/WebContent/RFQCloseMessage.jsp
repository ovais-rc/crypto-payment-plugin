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
String sShortDesc = "";
String sCloseDate = "";
Timestamp dateClosed = null;

try {
	// get and format the date and time as per locale/language 
	DateFormat df_d = DateFormat.getDateInstance(DateFormat.SHORT, locale);
	DateFormat df_t = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
	java.sql.Timestamp closeTime = rfqdb.getCloseTimeInEntityType();
	if(closeTime != null)
		sCloseDate = df_d.format(closeTime) + " " + df_t.format(closeTime);	

	TradingDescriptionAccessBean tdab = rfqdb.getDescription(langId);
	sShortDesc = tdab.getShortDescription();
} catch(Exception exValues) {}
response.setContentType("text/html;charset=UTF-8");
%>
<%= UTFToolsMessageHelper.getUserMessage("rfqName",filename,null,locale) + ": " + rfqName %>
<%= UTFToolsMessageHelper.getUserMessage("rfqShortDesc",filename,null,locale) + ": " + sShortDesc %>
<%= UTFToolsMessageHelper.getUserMessage("rfqCloseDate",filename,null,locale) + ": " + sCloseDate %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">

<html lang="en">
<head>
<title></title>
</head>
</html>
