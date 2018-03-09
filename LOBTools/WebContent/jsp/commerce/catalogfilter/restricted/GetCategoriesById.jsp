<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="categories" expressionBuilder="getCatalogGroupDetailsByIDs" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<c:forTokens var="value" items="${uniqueIDs}" delims=",">
		<wcf:param name="UniqueID" value="${value}" />
	</c:forTokens>
</wcf:getData>

<c:forEach var="catalogGroup" items="${categories}">
	<c:set var="showVerb" value="${showVerb}" scope="request"/>
	<c:set var="businessObject" value="${catalogGroup}" scope="request"/>
	<c:choose>
		<c:when test="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="referencedObjectType" value="InheritedCategoryElement" />
			<c:set var="objectType" value="InheritedCatalogGroup" />
		</c:when>
		<c:otherwise>
			<c:set var="referencedObjectType" value="CategoryElement" />
			<c:set var="objectType" value="CatalogGroup" />
		</c:otherwise>
	</c:choose>
	<object objectType="${referencedObjectType}">
		<uniqueId>${catalogGroupConditionGroup.catalogGroupSelectionIdentifier.uniqueID}</uniqueId>
		<elementId>${catalogGroup.catalogGroupIdentifier.uniqueID}</elementId>
	    <xclude><wcf:cdata data="${catalogGroupConditionGroup.selection}"/></xclude>
		<jsp:directive.include file="/jsp/commerce/catalog/restricted/serialize/SerializeCatalogGroup.jspf" />
		
		<c:forEach var="catalogFilterAttributeSet" items="${catalogGroupConditionGroup.conditionGroup}">
			<jsp:directive.include file="serialize/SerializeCatalogFilterAttributeSet.jspf" />
		</c:forEach>
		
	</object>
</c:forEach>
