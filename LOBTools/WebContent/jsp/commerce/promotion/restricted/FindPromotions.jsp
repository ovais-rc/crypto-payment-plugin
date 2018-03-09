<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${!empty param.searchText && param.searchText != ''}">
		<c:set var="searchText" value="${param.searchText}" />
	</c:when>
	<c:when test="${!empty param.promotionName && param.promotionName != ''}">
		<c:set var="searchText" value="${param.promotionName}" />
	</c:when>	
	<c:otherwise>
		<c:set var="searchText" value="*" />
	</c:otherwise>
</c:choose>

<c:choose>

	<c:when test="${param.advancedSearch eq 'true' && (param.statusSelection == 2 && (empty param.promotionStatus || param.promotionStatus == ''))}">
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber=""
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>
	
	<c:otherwise>
		<c:choose>
			<c:when test="${param.advancedSearch eq 'true'}">
				<c:set var="startDateDate1" value="" />		
				<c:set var="startDateDate2" value="" />
				<c:set var="promotionType" value="" />
				<c:set var="status" value="" />
				<c:set var="promotionRedemptionMethod" value="" />
				
				<c:if test="${!empty param.startDateDate1}" >
					<c:set var="startDateDate1" value="${param.startDateDate1}" />
				</c:if>
				<c:if test="${!empty param.startDateDate2}" >
					<c:set var="startDateDate2" value="${param.startDateDate2}" />
				</c:if>
				<c:if test="${!empty param.promotionType && param.promotionType != ''}" >
					<c:set var="promotionType" value="${param.promotionType}" />
				</c:if>
				<c:if test="${!empty param.promotionStatus && param.promotionStatus != ''}" >
					<c:set var="promotionStatus" value="${param.promotionStatus}" />
				</c:if>			
				<c:if test="${!empty param.promotionRedemptionMethod && param.promotionRedemptionMethod != ''}" >
					<c:set var="promotionRedemptionMethod" value="${param.promotionRedemptionMethod}" />
				</c:if>
				<c:set var="expressionBuilder" value="searchPromotionsAdvanced" />			
			</c:when>
			<c:otherwise>
				<c:set var="expressionBuilder" value="getPromotionDetailsByNameAndCodePattern" />
			</c:otherwise>
		</c:choose> 

		<wcf:getData
			type="com.ibm.commerce.promotion.facade.datatypes.PromotionType[]"
			var="promotions"
			expressionBuilder="${expressionBuilder}"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="searchText" value="${searchText}" />
			<c:if test="${param.advancedSearch eq 'true'}">
				<wcf:param name="startDateDate1" value="${startDateDate1}"/>
				<wcf:param name="startDateDate2" value="${startDateDate2}"/>
				<wcf:param name="promotionStatus" value="${promotionStatus}"/>
				<wcf:param name="promotionType" value="${promotionType}"/>
				<wcf:param name="promotionRedemptionMethod" value="${promotionRedemptionMethod}"/>
			</c:if>
		</wcf:getData>

		<objects
			recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
			recordSetReferenceId="${showVerb.recordSetReferenceId}"
			recordSetStartNumber="${showVerb.recordSetStartNumber}"
			recordSetCount="${showVerb.recordSetCount}"
			recordSetTotal="${showVerb.recordSetTotal}">
			<c:forEach var="promotion" items="${promotions}">
				<c:set var="showVerb" value="${showVerb}" scope="request"/>
				<c:set var="businessObject" value="${promotion}" scope="request"/>
				<jsp:directive.include file="SerializePromotion.jspf" />
			</c:forEach>
		</objects>
	</c:otherwise>

</c:choose>