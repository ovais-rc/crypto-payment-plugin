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
<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType[]"
	var="spots" expressionBuilder="findDefaultContentByMarketingContentID"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="collateralId" value="${param.collateralId}"/>
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	
	<c:forEach var="spot" items="${spots}">
		<spUI>${spot.UIDisplayable}</spUI>
		<c:choose>
			<c:when test="${!empty spot.UIDisplayable && spot.UIDisplayable == '0'}">
				<c:forEach var="defaultContent" items="${spot.defaultContent}">
					<c:set var="showVerb" value="${showVerb}" scope="request"/>
					<c:set var="businessObject" value="${spot}" scope="request"/>
					<jsp:directive.include file="GetLayoutMarketingContentReferences.jsp" />
				</c:forEach>				
			</c:when>
			<c:otherwise>
				<c:forEach var="defaultContent" items="${spot.defaultContent}">
					<c:set var="showVerb" value="${showVerb}" scope="request"/>
					<c:set var="businessObject" value="${spot}" scope="request"/>
					<jsp:directive.include file="GetEMarketingSpotDefaultContentReferences.jsp" />
				</c:forEach>		
			</c:otherwise>
		</c:choose>
		
		<c:forEach var="defaultTitle" items="${spot.defaultMarketingSpotTitle}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${spot}" scope="request"/>
			<jsp:directive.include file="GetEMarketingSpotDefaultTitleReferences.jsp" />
		</c:forEach>	
				
	</c:forEach>

</objects>
