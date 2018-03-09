<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%@ page import="java.net.URLDecoder" %>

<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.MarketingContentType[]"
	var="marketingContents" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<c:forTokens var="value" items="${param.uniqueIDs}" delims=",">
		<wcf:param name="UniqueID" value="${value}" />
	</c:forTokens>
</wcf:getData>

<objects>
	<c:forEach var="content" items="${marketingContents}">
		<%-- Look up catalog entries and categories for URL generator --%>
		<c:if test="${!empty content.url}">
			<c:choose>
				<c:when test="${fn:contains(content.url, 'partNumber=') || fn:contains(content.url, 'catEntryId=') || fn:contains(content.url, 'productId=')}">
					<c:set var="partNumber" value=""/>
					<c:set var="catEntryId" value=""/>
					<c:choose>
						<c:when test="${fn:contains(content.url, 'partNumber=')}">
							<c:set var="endOfUrl" value="${fn:substringAfter(content.url, 'partNumber=')}"/>
							<c:set var="indexOfNextAmp" value="${fn:indexOf(endOfUrl, '&')}"/>
							<c:set var="partNumber" value="${fn:substring(endOfUrl, 0, indexOfNextAmp)}"/>
							<% String decodedPartNumber = URLDecoder.decode((String)pageContext.getAttribute("partNumber"));%>
							<% pageContext.setAttribute("partNumber", decodedPartNumber);%>
						</c:when>
						<c:when test="${fn:contains(content.url, 'catEntryId=')}">
							<c:set var="endOfUrl" value="${fn:substringAfter(content.url, 'catEntryId=')}"/>
							<c:set var="indexOfNextAmp" value="${fn:indexOf(endOfUrl, '&')}"/>
							<c:set var="catEntryId" value="${fn:substring(endOfUrl, 0, indexOfNextAmp)}"/>
						</c:when>
						<c:when test="${fn:contains(content.url, 'productId=')}">
							<c:set var="endOfUrl" value="${fn:substringAfter(content.url, 'productId=')}"/>
							<c:set var="indexOfNextAmp" value="${fn:indexOf(endOfUrl, '&')}"/>
							<c:set var="catEntryId" value="${fn:substring(endOfUrl, 0, indexOfNextAmp)}"/>
						</c:when>
					</c:choose>
					
					<c:choose>
						<c:when test="${!empty partNumber}">
							<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
								var="catentries" expressionBuilder="getCatalogEntryDetailsByPartNumbers"
								varShowVerb="showVerbContent">
								<wcf:contextData name="storeId" data="${param.storeId}" />
								<wcf:contextData name="catalogId" data="${param.masterCatalogId}" />
								<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
								<wcf:param name="PartNumber" value="${partNumber}" />
							</wcf:getData>
						</c:when>
						<c:when test="${!empty catEntryId}">
							<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
								var="catentries" expressionBuilder="getCatalogEntryDetailsByIDs"
								varShowVerb="showVerbContent">
								<wcf:contextData name="storeId" data="${param.storeId}" />
								<wcf:contextData name="catalogId" data="${param.masterCatalogId}" />
								<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
								<wcf:param name="UniqueID" value="${catEntryId}" />
							</wcf:getData>
						</c:when>
					</c:choose>
					
					<c:if test="${!empty catentries}">
						<c:forEach var="catentry" items="${catentries}">
							<c:choose>
								<c:when test="${catentry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
									<c:choose>
										<c:when test="${fn:contains(content.url, 'ProductDisplay')}">
											<c:set var="referenceObjectType" value="ChildInheritedProducts" />
										</c:when>
										<c:otherwise>
											<c:set var="referenceObjectType" value="ChildInheritedItems" />
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${fn:contains(content.url, 'ProductDisplay')}">
											<c:set var="referenceObjectType" value="ChildProducts" />
										</c:when>
										<c:otherwise>
											<c:set var="referenceObjectType" value="ChildItems" />
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
							<object objectType="${referenceObjectType}">
								<childCatentryId>${catentry.catalogEntryIdentifier.uniqueID}</childCatentryId>
								<c:set var="showVerb" value="${showVerbContent}" scope="request" />
								<c:set var="businessObject" value="${catentry}" scope="request"/>
								<jsp:directive.include file="../../catalog/restricted/serialize/SerializeGenericCatalogEntry.jspf" />
							</object>
						</c:forEach>
					</c:if>
				</c:when>
				<c:when test="${fn:contains(content.url, 'categoryId=')}">
					<c:set var="endOfUrl" value="${fn:substringAfter(content.url, 'categoryId=')}"/>
					<c:set var="indexOfNextAmp" value="${fn:indexOf(endOfUrl, '&')}"/>
					<c:set var="uniqueIDs" value="${fn:substring(endOfUrl, 0, indexOfNextAmp)}"/>
					
					<c:if test="${!empty uniqueIDs}">
						<jsp:directive.include file="GetCategoriesById.jsp" />
					</c:if>
				</c:when>
			</c:choose>
		</c:if>
		<%-- Return Attachment --%>
		<c:if test="${!empty content.attachment}">
			<c:choose>
				<c:when test="${content.attachment.attachmentIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
					<c:set var="referenceObjectType" value="InheritedAttachmentReference" />
				</c:when>
				<c:otherwise>
					<c:set var="referenceObjectType" value="AttachmentReference" />
				</c:otherwise>
			</c:choose>
			<c:set var="attachment" value="${content.attachment}"/>
			<object objectType="${referenceObjectType}">
				<attachmentRefId>${content.attachment.attachmentReferenceIdentifier.uniqueID}</attachmentRefId>
				<jsp:directive.include file="../../attachment/restricted/serialize/SerializeAttachment.jspf" />
			</object>
		</c:if>
	</c:forEach>
</objects>