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

<c:set var="emailUniqueIDs" value="" />
<c:set var="smsUniqueIDs" value="" />

<object objectType="sendMessage">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:choose>
			<c:when test="${elementVariable.name == 'emailMessageId'}">
				<c:choose>
					<c:when test="${emailUniqueIDs != ''}">
						<c:set var="emailUniqueIDs" value="${emailUniqueIDs}${','}${elementVariable.value}" />
					</c:when>
					<c:otherwise>
						<c:set var="emailUniqueIDs" value="${elementVariable.value}" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:when test="${elementVariable.name == 'contentId'}">
				<c:choose>
					<c:when test="${smsUniqueIDs != ''}">
						<c:set var="smsUniqueIDs" value="${smsUniqueIDs}${','}${elementVariable.value}" />
					</c:when>
					<c:otherwise>
						<c:set var="smsUniqueIDs" value="${elementVariable.value}" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:if test="${emailUniqueIDs != ''}">
		<c:set var="uniqueIDs" value="${emailUniqueIDs}" />
		<jsp:directive.include file="GetEmailTemplatesById.jsp" />
	</c:if>
	<c:if test="${smsUniqueIDs != ''}">
		<c:set var="uniqueIDs" value="${smsUniqueIDs}" />
		<jsp:directive.include file="GetChildMarketingContentById.jsp" />
	</c:if>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>

