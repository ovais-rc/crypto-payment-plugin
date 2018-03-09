<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
    type="com.ibm.commerce.member.facade.datatypes.MemberGroupType[]"
    var="memberGroups"
    expressionBuilder="findByUniqueIDs"
    varShowVerb="showVerb">

    <wcf:contextData name="storeId" data="${param.storeId}" />
    <wcf:param name="UniqueID" value="${param.uniqueId}" />
    <wcf:param name="accessProfile" value="IBM_Admin_Details" />
</wcf:getData>

<objects>
	<c:forEach var="group" items="${memberGroups}">
	    <c:set var="showVerb" value="${showVerb}" scope="request"/>
	    <c:set var="businessObject" value="${group}" scope="request"/>
	    <jsp:directive.include file="SerializeCustomerSegmentDescription.jspf" />

		<c:forEach var="customer" items="${group.includedPerson}">
			<object objectType="IncludedCustomerAssociation">
		    	<objectStoreId>${param.storeId}</objectStoreId>
				<associationId>${customer.uniqueID}</associationId>
				<c:if test="${customer.uniqueID != ''}">
					<c:set var="memberId" value="${customer.uniqueID}" scope="request"/>
					<jsp:directive.include file="GetCustomerById.jsp"/>
				</c:if>
			</object>
		</c:forEach>

		<c:forEach var="customer" items="${group.excludedPerson}">
			<object objectType="ExcludedCustomerAssociation">
		    	<objectStoreId>${param.storeId}</objectStoreId>
				<associationId>${customer.uniqueID}</associationId>
				<c:if test="${customer.uniqueID != ''}">
					<c:set var="memberId" value="${customer.uniqueID}" scope="request"/>
					<jsp:directive.include file="GetCustomerById.jsp"/>
				</c:if>
			</object>
		</c:forEach>

		<c:set var="allElements" value="${group.conditionElement}" scope="request"/>
		<c:forEach var="groupElement" items="${group.conditionElement}">
			<c:set var="element" value="${groupElement}" scope="request"/>
			<c:choose>
				<c:when test="${!empty element.simpleConditionVariable}">
					<jsp:include page="${'/cmc/SerializeCustomerSegment-'}${element.simpleConditionVariable}"/>
				</c:when>
				<c:otherwise>
					<jsp:include page="${'/cmc/SerializeCustomerSegment-'}${element.memberGroupConditionElementIdentifier.name}"/>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:forEach>
</objects>