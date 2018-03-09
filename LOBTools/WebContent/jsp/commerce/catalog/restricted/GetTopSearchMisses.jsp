<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
 
<c:choose>
	<c:when test="${(param.getReport == null) || (empty param.getReport)}">
		<%-- No reporting criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>
	
	<c:otherwise>
		<c:set var="searchTerm" value="${param.searchTerm}" />
		<c:if test="${empty param.searchTerm}">
			<c:set var="searchTerm" value="*" />
		</c:if>
		<wcf:getData type="com.ibm.commerce.search.facade.datatypes.SearchTermAssociationType[]"
			var="topSearchMisses"	
			varShowVerb="showVerb"
			expressionBuilder="findTopMissesStatistics"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="dataLanguageIds" value="${param.reportLanguageId}"/>
			<wcf:param name="datestart" value="${param.datestart}"/>
			<wcf:param name="dateend" value="${param.dateend}"/>
			<wcf:param name="searchTerm" value="${searchTerm}"/>	
			<wcf:param name="topkeywords" value="${param.topkeywords}"/>	
			<wcf:param name="suggestion" value="${param.suggestion}"/>
		</wcf:getData>
		
		<jsp:directive.include file="serialize/SerializeTopSearchMisses.jspf"/>
	</c:otherwise>
</c:choose>