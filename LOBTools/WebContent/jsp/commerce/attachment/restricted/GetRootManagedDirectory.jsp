<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>

<wcf:getData type = "com.ibm.commerce.content.facade.datatypes.ManagedDirectoryType[]"
     var="managedDirectories"
     expressionBuilder="getManagedDirectoryChildren">
     <wcf:contextData name="storeId" data="${param.storeId}" />
     <wcf:param name="parentDirectoryPath" value="null" />
</wcf:getData>

<objects>
  <c:if test="${!(empty managedDirectories)}">
  
	<c:forEach var="managedDirectory" items="${managedDirectories}">
       <jsp:directive.include file="serialize/SerializeManagedDirectory.jspf"/>
	</c:forEach>
  </c:if>	
</objects>

