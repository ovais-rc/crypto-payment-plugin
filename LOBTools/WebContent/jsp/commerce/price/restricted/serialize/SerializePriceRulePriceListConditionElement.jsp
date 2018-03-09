<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="priceListIDs" value="" />

<object objectType="priceListCondition">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.elementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
	<elementName>${element.elementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<c:forEach var="elementVariable" items="${element.elementAttribute}">
		<c:choose>
			<c:when test="${elementVariable.name == 'priceListId'}">
				<c:choose>
					<c:when test="${priceListIDs != ''}">
						<c:set var="priceListIDs" value="${priceListIDs}${','}${elementVariable.value}" />
					</c:when>
					<c:otherwise>
						<c:set var="priceListIDs" value="${elementVariable.value}" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	
	<c:if test="${priceListIDs != ''}">
		<c:forTokens var="value" items="${priceListIDs}" delims=",">
			<c:set var="priceListID" value="${value}" />
			<jsp:directive.include file="../GetPriceListById.jsp" />
		</c:forTokens>
	</c:if>

	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
