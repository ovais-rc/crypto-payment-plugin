<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<object>
	<c:forEach var="widget" items="${layout[0].widget}">
		<widgetId>${widget.widgetIdentifier.uniqueID}</widgetId>
		<c:forEach var="property" items="${widget.widgetProperty}">
			<xWidgetProp_${property.name}><wcf:cdata data="${property.value}"/></xWidgetProp_${property.name}>
		</c:forEach>
	</c:forEach>
</object>
