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
		<objects/>
	</c:when>
	
	<c:otherwise>
		<wcf:getData type="com.ibm.commerce.search.facade.datatypes.SearchTermAssociationType[]"
			var="topSearchMisses"
			varShowVerb="showVerb"
			expressionBuilder="findTopMissesStatistics"
			maxItems="1">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="dataLanguageIds" value="${param.reportLanguageId}"/>
			<wcf:param name="datestart" value="${param.datestart}"/>
			<wcf:param name="dateend" value="${param.dateend}"/>
			<wcf:param name="searchTerm" value="*"/>	
			<wcf:param name="topkeywords" value="-1"/>	
			<wcf:param name="suggestion" value="KEYWORDS_ALL"/>
		</wcf:getData>
		
		<c:set var="totalSessionCount" value="0" />
		<wcf:metadata showVerb="${showVerb}"
			businessObject="${showVerb}"
			usage="staStatistics"
			var="staMap"/>
		<c:if test="${!empty staMap.totalSearchingSession}">
			<c:set var="totalSessionCount" value="${staMap.totalSearchingSession}" />
		</c:if>
		
		<objects>
			<object objectType="TopSearchMissTotal" readonly="true">
				<uniqueId>"TopSearchMissTotal"</uniqueId>
				<totalSessionCount>${totalSessionCount}</totalSessionCount>
			</object>
		</objects>
	</c:otherwise>
</c:choose>
