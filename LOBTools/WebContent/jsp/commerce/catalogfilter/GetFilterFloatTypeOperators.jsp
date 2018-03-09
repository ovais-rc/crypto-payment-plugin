<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page import="java.util.Locale" %>
<%@page import="java.util.ResourceBundle" %>
<%@page import="com.ibm.commerce.foundation.client.lobtools.actions.ResourceBundleHelper" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%
	String curLocale = request.getParameter("locale");
	Locale currentLocale = new Locale(curLocale);
	ResourceBundle cftResourceBundle = ResourceBundleHelper.getBundle("com.ibm.commerce.catalogfilter.client.lobtools.properties.CatalogFilterLOB", currentLocale);
%>

<objects> 
   <object type="Operator">
   		<displayName><wcf:cdata data='<%= cftResourceBundle.getString("catalogFilterFloatOperatorEqauls")%>'/></displayName>
   		<value><wcf:cdata data="NUMBER_EQUALS"/></value>
   </object>
   <object type="Operator">
   		<displayName><wcf:cdata data='<%= cftResourceBundle.getString("catalogFilterFloatOperatorNotEqauls")%>'/></displayName>
   		<value><wcf:cdata data="NUMBER_NOT_EQUALS"/></value>
   </object>
      <object type="Operator">
   		<displayName><wcf:cdata data='<%= cftResourceBundle.getString("catalogFilterFloatOperatorLessThan")%>'/></displayName>
   		<value><wcf:cdata data="NUMBER_LESS_THAN"/></value>
   </object>
   <object type="Operator">
   		<displayName><wcf:cdata data='<%= cftResourceBundle.getString("catalogFilterFloatOperatorNotLessThan")%>'/></displayName>
   		<value><wcf:cdata data="NUMBER_NOT_LESS_THAN"/></value>
   </object>
      <object type="Operator">
   		<displayName><wcf:cdata data='<%= cftResourceBundle.getString("catalogFilterFloatOperatorGreaterThan")%>'/></displayName>
   		<value><wcf:cdata data="NUMBER_GREATER_THAN"/></value>
   </object>
   <object type="Operator">
   		<displayName><wcf:cdata data='<%= cftResourceBundle.getString("catalogFilterFloatOperatorNotGreaterThan")%>'/></displayName>
   		<value><wcf:cdata data="NUMBER_NOT_GREATER_THAN"/></value>
   </object>
</objects>