<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${!empty param.searchUniqueId && param.searchUniqueId != ''}">
		<c:set var="searchText" value="${param.searchUniqueId}" />
	</c:when>
	<c:when test="${!empty param.searchText && param.searchText != ''}">
		<c:set var="searchText" value="${param.searchText}" />
	</c:when>
	<c:when test="${!empty param.layoutName && param.layoutName != ''}">
		<c:set var="searchText" value="${param.layoutName}" />
	</c:when>	
	<c:otherwise>
		<c:set var="searchText" value="" />
	</c:otherwise>
</c:choose>

<c:set var="startDate" value="" />
<c:set var="endDate" value="" />
<c:set var="deviceClass" value="" />

<c:if test="${!empty param.startDate}" >
	<c:set var="startDate" value="${param.startDate }" />
</c:if>
<c:if test="${!empty param.endDate}" >
	<c:set var="endDate" value="${param.endDate }" />
</c:if>
<c:if test="${!empty param.deviceClass && param.deviceClass != ''}" >
	<c:set var="deviceClass" value="${param.deviceClass}" />
</c:if>

<c:choose>
	<c:when test="${param.advancedSearch eq 'true'}">
		<c:set var="expressionBuilder" value="searchLayouts" />			
	</c:when>
	<c:when test="${!empty param.searchUniqueId && param.searchUniqueId != ''}">
		<c:set var="expressionBuilder" value="getLayoutsByUniqueID"/>
	</c:when>
	<c:otherwise>
		<c:set var="expressionBuilder" value="getLayoutsByName" />
	</c:otherwise>
</c:choose> 

<c:if test="${!empty searchText}">
	<wcf:getData
				type="com.ibm.commerce.pagelayout.facade.datatypes.LayoutType[]"
				var="layouts" expressionBuilder="${expressionBuilder}" varShowVerb="showVerb"
				recordSetStartNumber="${param.recordSetStartNumber}"
				recordSetReferenceId="${param.recordSetReferenceId}"
				maxItems="${param.maxItems}">
				<wcf:contextData name="storeId" data="${param.storeId}" />
				<wcf:param name="accessProfile" value="IBM_Admin_Details"/>
				<c:choose>
					<c:when test="${param.advancedSearch eq 'true'}">
						<wcf:param name="layoutName" value="${searchText}"/>
						<wcf:param name="startDate" value="${startDate}"/>
						<wcf:param name="endDate" value="${endDate}"/>
						<wcf:param name="devices" value="${deviceClass}"/>
						<wcf:param name="isTemplate" value="false"/>
					</c:when>
					<c:when test="${!empty param.searchUniqueId && param.searchUniqueId != ''}">
						<wcf:param name="layoutId" value="${searchText}"/>
					</c:when>
					<c:otherwise>
						<wcf:param name="name" value="${searchText}"/>
						<wcf:param name="isTemplate" value="false"/>
					</c:otherwise>
				</c:choose> 								
	</wcf:getData> 
	<c:set var="showVerb1" value="${showVerb}" scope="request"/> 
</c:if>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty layouts)}">

	<c:forEach var="pagelayout" items="${layouts}">
			<%-- Default case: assume everything is one store --%>
			<c:set var="inherited" value="" />   
	        <c:set var="layoutOwningStoreId" value="${pagelayout.layoutIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			<c:if test="${param.storeId != layoutOwningStoreId}">
					<%-- esite case--%>
				<c:set var="inherited" value="Inherited" />
			</c:if> 
		<jsp:directive.include file="serialize/SerializePageLayout.jspf" />
	</c:forEach>
</c:if>
</objects>

