<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page contentType="application/xml" %>        
<%@ page language="java" %>
<%@ page import="com.ibm.commerce.server.JSPResourceBundle"%>

<%
JSPResourceBundle myResourceBundle = null;
try {
	myResourceBundle = new JSPResourceBundle(java.util.ResourceBundle.getBundle("GenericSystemError"));
} catch (java.util.MissingResourceException mre) {
	myResourceBundle = new JSPResourceBundle();
}
%>
<?xml version="1.0" encoding="UTF-8"?>
<oa:ResponseActionCriteriaType xmlns:oa="http://www.openapplications.org/oagis/9">
  <oa:ChangeStatus>
    <oa:Code>ERROR</oa:Code>
    <oa:Description><%= myResourceBundle.getString("head1") %></oa:Description>
    <oa:ReasonCode>500</oa:ReasonCode>
    <oa:Reason></oa:Reason>
  </oa:ChangeStatus>
</oa:ResponseActionCriteriaType>


	