

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
<c:choose>
	<c:when test="${!empty uniqueIDs}">
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingEmailTemplateType[]"
			var="emailTemplates" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<c:forTokens var="value" items="${uniqueIDs}" delims=",">
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
	</c:when>
	<c:otherwise>
		<wcf:getData
			type="com.ibm.commerce.marketing.facade.datatypes.MarketingEmailTemplateType[]"
			var="emailTemplates" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="UniqueID" value="${param.templateId}" />
		</wcf:getData>
		<c:forEach var="template" items="${emailTemplates}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${template}" scope="request"/>
			<jsp:directive.include file="SerializeEmailTemplate.jspf" />
		</c:forEach>
	</c:otherwise>
</c:choose>
