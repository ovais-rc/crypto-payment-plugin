<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.MarketingContentType[]"
	var="marketingContents" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<c:forTokens var="value" items="${uniqueIDs}" delims=",">
		<wcf:param name="UniqueID" value="${value}" />
	</c:forTokens>
</wcf:getData>

<c:forEach var="content" items="${marketingContents}">
	<c:set var="showVerb" value="${showVerb}" scope="request"/>
	<c:set var="businessObject" value="${content}" scope="request"/>
	<c:choose>
		<c:when test="${content.marketingContentIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="referenceObjectType" value="ChildInheritedMarketingContent" />
		</c:when>
		<c:otherwise>
			<c:set var="referenceObjectType" value="ChildMarketingContent" />
		</c:otherwise>
	</c:choose>
	<object objectType="${referenceObjectType}">
		<childMarketingContentId>${content.marketingContentIdentifier.uniqueID}</childMarketingContentId>
		
		<c:forTokens items="${associatedElementInfo}" delims="," var="contentInfoFromAssociatedElement">
			<c:forTokens items="${contentInfoFromAssociatedElement}" delims="|" var="token" begin="0" end="0">
				<c:set var="contentIdFromAssociatedElement" value="${token}" />
			</c:forTokens>
			<c:if test="${contentIdFromAssociatedElement == content.marketingContentIdentifier.uniqueID}">
				<c:forTokens items="${contentInfoFromAssociatedElement}" delims="|" var="element" begin="1" varStatus="status">
					<c:choose>
						<c:when test="${status.count == 1}">
							<sequence>${element}</sequence>
						</c:when>
					</c:choose>
				</c:forTokens>
			</c:if>
		</c:forTokens>		
				
		<jsp:directive.include file="SerializeMarketingContent.jspf" />
	</object>
</c:forEach>
