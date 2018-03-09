<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="uniqueIDs" value="" />
<c:set var="associatedElementInfo" value="" />
<object objectType="displayTitle">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${elementVariable.name != 'collateralIdList'}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
		</c:if>
		<c:if test="${elementVariable.name == 'collateralIdList'}">
			<c:choose>
				<c:when test="${uniqueIDs != ''}">
					<c:set var="uniqueIDs"
						value="${uniqueIDs}${','}${elementVariable.value}" />
				</c:when>
				<c:otherwise>
					<c:set var="uniqueIDs" value="${elementVariable.value}" />
				</c:otherwise>
			</c:choose>
			
			<c:set var="sequenceOrder" value="${elementVariable.sequenceOrder}" />
			<c:if test="${empty elementVariable.sequenceOrder}">
				<c:set var="sequenceOrder" value="1" />
			</c:if>	
			<c:choose>
				<c:when test="${associatedElementInfo != ''}">
					<c:set var="associatedElementInfo"
						value="${associatedElementInfo}${','}${elementVariable.value}${'|'}${sequenceOrder}" />
				</c:when>
				<c:otherwise>
					<c:set var="associatedElementInfo" value="${elementVariable.value}${'|'}${sequenceOrder}" />
				</c:otherwise>
			</c:choose>
						
		</c:if>
	</c:forEach>
	<c:if test="${uniqueIDs != ''}">
		<jsp:directive.include file="GetChildMarketingContentById.jsp" />
	</c:if>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
