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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.ActivityType[]"
	var="activities" expressionBuilder="findByFamilyID"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:param name="familyId" value="${param.familyId}" />
	<wcf:contextData name="storeId" data="${param.storeId}" />
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:forEach var="activity" items="${activities}">
		<c:choose>
			<c:when test="${activity.format == 'Web'}">
				<c:set var="objectType" value="WebActivity" />
			</c:when>
			<c:when test="${activity.format == 'Dialog'}">
				<c:set var="objectType" value="DialogActivity" />
			</c:when>
		</c:choose>

		<c:choose>
			<c:when test="${activity.activityIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
				<c:set var="referenceObjectType" value="RelatedInherited${objectType}" />
			</c:when>
			<c:otherwise>
				<c:set var="referenceObjectType" value="Related${objectType}" />
			</c:otherwise>
		</c:choose>
		<object objectType="${referenceObjectType}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${activity}" scope="request"/>
			<relatedActivityId>${activity.activityIdentifier.uniqueID}</relatedActivityId>
			<jsp:directive.include file="SerializeActivity.jspf" />
		</object>
	</c:forEach>
</objects>
