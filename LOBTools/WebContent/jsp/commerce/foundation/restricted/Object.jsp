<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<c:set var="responseMap" value="${requestScope['com.ibm.commerce.responseMap']}"/>
<c:set var="attrResponseMap" value="${requestScope['com.ibm.commerce.attrResponseMap']}"/>
<object
	<c:forEach var="attr" items="${attrResponseMap}">
		${attr.key}="${attr.value}"
	</c:forEach>
>
<c:forEach var="property" items="${responseMap}">
<${property.key}><wcf:cdata data="${property.value}"/></${property.key}>
</c:forEach>
</object>
