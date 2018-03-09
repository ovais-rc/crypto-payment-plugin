<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
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
<%@ page import="java.util.*,
com.ibm.commerce.utf.utils.*,
com.ibm.commerce.utf.objects.*,
com.ibm.commerce.server.*,
com.ibm.commerce.contract.objects.*,
com.ibm.commerce.user.objects.*,
com.ibm.commerce.rfq.objects.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.catalog.beans.*,
com.ibm.commerce.common.beans.*,
javax.servlet.*,
java.io.*,
com.ibm.commerce.command.*,
com.ibm.commerce.beans.*,
com.ibm.commerce.datatype.*,
com.ibm.commerce.common.objects.*,
com.ibm.commerce.common.objimpl.*,
com.ibm.commerce.usermanagement.commands.ECUserConstants,
com.ibm.commerce.security.commands.ECSecurityConstants,
com.ibm.commerce.user.beans.*" %>
<%
Integer langId = null;
String localeString = null;
Locale locale = null;
String rfqId = "";
String rfqName = "";
String filename = "com/ibm/commerce/tools/utf/properties/utfNLS";
String storeDir = "";
String storeId = null;

CommandContext aCommandContext = (CommandContext) request.getAttribute("CommandContext");
langId = aCommandContext.getLanguageId();
locale = aCommandContext.getLocale();

rfqId = request.getParameter(UTFConstants.EC_RFQ_RFQID);
if( rfqId  == null || rfqId .equals("") ){
	rfqId = (String)request.getAttribute(UTFConstants.EC_RFQ_RFQID);   
} 
%>
<jsp:useBean id="rfqdb" class="com.ibm.commerce.utf.beans.RFQDataBean" >
<jsp:setProperty property="*" name="rfqdb" />
<jsp:setProperty property="rfqId" name="rfqdb" value="<%= rfqId %>" />
</jsp:useBean>
<%
rfqdb.populate(); 
rfqName = rfqdb.getName(); 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">

<html lang="en">
<head>
<title></title>
</head>
</html>