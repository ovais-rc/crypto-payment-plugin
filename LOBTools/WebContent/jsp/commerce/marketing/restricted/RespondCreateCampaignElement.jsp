<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="readonly" value="" />
<c:set var="filterName" value="" />
<c:set var="filterNameValue" value="" />
<c:set var="facetExclusionField" value="" />
<c:forEach var="elementVariable" items="${activities[0].campaignElement[0].campaignElementVariable}">
	<c:if test="${elementVariable.name == 'filterType' || elementVariable.name == 'orderByFieldType'}">
		<c:if test="${elementVariable.value == 'catalogEntryProperty'}">
			<c:set var="readonly" value="readonly='true'" />
		</c:if>
	</c:if>
	<c:if test="${elementVariable.name == 'filterName' || elementVariable.name == 'orderByField'}">
		<c:set var="filterName" value="${elementVariable.name}" />
		<c:set var="filterNameValue" value="${elementVariable.value}" />
	</c:if>
	<c:if test="${elementVariable.name == 'facetExclusionField'}">
		<c:set var="facetExclusionField" value="${elementVariable.value}" />
	</c:if>
</c:forEach>
<object>
	<elementName>${activities[0].campaignElement[0].campaignElementIdentifier.name}</elementName>
	<c:if test="${filterName != ''}">
		<${filterName} ${readonly}><wcf:cdata data="${filterNameValue}"/></${filterName}>
	</c:if>
	<c:if test="${facetExclusionField != ''}">
		<facetExclusionField readonly="true">
			<wcf:cdata data="${facetExclusionField}"/>
		</facetExclusionField>
	</c:if>	
</object>
