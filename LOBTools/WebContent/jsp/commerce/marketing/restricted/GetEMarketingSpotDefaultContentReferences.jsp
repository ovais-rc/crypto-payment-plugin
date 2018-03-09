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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<reference>
			
	<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingContentType[]" var="contents" expressionBuilder="findByUniqueIDs">
		<wcf:param name="UniqueID" value="${param.collateralId}" />
		<wcf:contextData name="storeId" data="${param.storeId}"/>
	</wcf:getData>			
		
	<c:forEach var="content" items="${contents}">
		
		<c:set var="inheritedChildObject" value=""/>
		<c:set var="inherited" value=""/>
		<c:if test="${defaultContent.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="inherited" value="Inherited"/>
		</c:if>
		<c:if test="${content.marketingContentIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="inheritedChildObject" value="Inherited"/>
		</c:if>
			
		<object objectType="${inheritedChildObject}DefaultEMarketingSpot${inherited}MarketingContentReference">				
			<uniqueId>${defaultContent.uniqueID}</uniqueId>
			<parent>
				<jsp:directive.include file="SerializeEMarketingSpot.jspf"/>
			</parent>
		</object>
	</c:forEach>
</reference>
