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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="segmentIDs" value="" />
<c:set var="templateIDs" value="" />
<c:set var="uniqueIDs" value="" />
<object objectType="sendBulkEmail">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${elementVariable.name != 'segmentIdList' && elementVariable.name != 'emailMessageId'}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
		</c:if>
		<c:if test="${elementVariable.name == 'segmentIdList'}">
			<c:choose>
				<c:when test="${segmentIDs != ''}">
					<c:set var="segmentIDs"
						value="${segmentIDs}${','}${elementVariable.value}" />
				</c:when>
				<c:otherwise>
					<c:set var="segmentIDs" value="${elementVariable.value}" />
				</c:otherwise>
			</c:choose>
		</c:if>
		<c:if test="${elementVariable.name == 'emailMessageId'}">
			<c:choose>
				<c:when test="${templateIDs != ''}">
					<c:set var="templateIDs"
						value="${templateIDs}${','}${elementVariable.value}" />
				</c:when>
				<c:otherwise>
					<c:set var="templateIDs" value="${elementVariable.value}" />
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:forEach>
	<c:if test="${segmentIDs != ''}">
		<c:set var="uniqueIDs" value="${segmentIDs}" />
		<jsp:directive.include file="GetCustomerSegmentsById.jsp" />
	</c:if>
	<c:if test="${templateIDs != ''}">
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingEmailTemplateType[]"
			var="emailTemplates" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<c:forTokens var="value" items="${templateIDs}" delims=",">
				<wcf:param name="UniqueID" value="${value}" />
			</c:forTokens>
		</wcf:getData>
		<c:forEach var="template" items="${emailTemplates}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${template}" scope="request"/>
			<c:choose>
				<c:when test="${template.marketingEmailTemplateIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
					<c:set var="referenceObjectType" value="ChildInheritedEmailTemplate" />
				</c:when>
				<c:otherwise>
					<c:set var="referenceObjectType" value="ChildEmailTemplate" />
				</c:otherwise>
			</c:choose>
			<object objectType="${referenceObjectType}">
				<childEmailTemplateId>${template.marketingEmailTemplateIdentifier.uniqueID}</childEmailTemplateId>
				<jsp:directive.include file="SerializeEmailTemplate.jspf" />
			</object>
		</c:forEach>
	</c:if>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
