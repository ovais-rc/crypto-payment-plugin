<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="uniqueIDs" value="" />
<c:set var="uniquePromotionID" value="" />
<c:set var="uniqueCollateralIDs" value="" />
<object objectType="displayPromotion">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${elementVariable.name == 'promotionId'}">
			<c:set var="uniquePromotionID" value="${elementVariable.value}" />
		</c:if>
		<c:if test="${elementVariable.name == 'collateralIdList'}">
			<c:choose>
				<c:when test="${uniqueCollateralIDs != ''}">
					<c:set var="uniqueCollateralIDs"
						value="${uniqueCollateralIDs}${','}${elementVariable.value}" />
				</c:when>
				<c:otherwise>
					<c:set var="uniqueCollateralIDs" value="${elementVariable.value}" />
				</c:otherwise>
			</c:choose>
		</c:if>
		<c:if test="${elementVariable.name != 'promotionId'} && ${elementVariable.name != 'collateralIdList'}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
		</c:if>
	</c:forEach>

	<c:if test="${uniquePromotionID != ''}">
		<c:set var="uniqueID" value="${uniquePromotionID}" />
		<jsp:directive.include file="GetChildPromotionsById.jsp" />
	</c:if>

	<c:if test="${uniqueCollateralIDs != ''}">
		<c:set var="uniqueIDs" value="${uniqueCollateralIDs}" />
		<jsp:directive.include file="GetChildMarketingContentById.jsp" />
	</c:if>


	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
