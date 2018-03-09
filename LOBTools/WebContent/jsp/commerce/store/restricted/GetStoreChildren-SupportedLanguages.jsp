<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="supportedLanguages" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.supportedLanguages" />
</wcf:getData>
<values>
	<c:forEach var="attribute" items="${supportedLanguages.configurationAttribute}">
		<c:forEach var="additionalValue" items="${attribute.additionalValue}">
			<c:if test="${not empty additionalValue.name}">
				<c:choose>
	    			<c:when test="${additionalValue.name == 'languageId'}">
	    				<c:set var="languageId" value="${additionalValue.value}" />
	    			</c:when>
	    		</c:choose>
			</c:if>
		</c:forEach>
		<%-- ex: <value displayName="United States English"><![CDATA[-1]]></value>--%>
		<value displayName="${attribute.primaryValue.value}"><wcf:cdata data="${languageId}"/></value>
	</c:forEach>
</values>
