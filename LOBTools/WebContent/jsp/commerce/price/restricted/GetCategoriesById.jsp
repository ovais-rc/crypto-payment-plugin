<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="categories" expressionBuilder="getCatalogGroupWithAllParentDetailsByIDs" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<c:forTokens var="value" items="${uniqueIDs}" delims=",">
		<wcf:param name="UniqueID" value="${value}" />
	</c:forTokens>
</wcf:getData>
<c:forEach var="catalogGroup" items="${categories}">
	<c:set var="showVerb" value="${showVerb}" scope="request"/>
	<c:set var="businessObject" value="${catalogGroup}" scope="request"/>
	<c:set var="type" value="CatalogGroup" />
	<c:set var="dynamic" value=""/>
	<c:set var="inherited" value=""/>
	
	<c:forEach var="attribute" items="${catalogGroup.attributes}">
		<%-- Get the catalog group type: master category (CatalogGroup) or sales category (SalesCatalogGroup) --%>
		<c:if test="${attribute.typedKey == 'catalog_group_type'}">
			<c:set var="type" value="${attribute.typedValue}"/>
		</c:if>
		<c:if test="${attribute.typedKey == 'owning_catalog_id'}">
			<c:set var="owningCatalog" value="${attribute.typedValue}"/>
		</c:if>
		<c:if test="${attribute.typedKey == 'owning_catalog_identifier'}">
			<c:set var="owningCatalogIdentifier" value="${attribute.typedValue}"/>
		</c:if>
		<c:if test="${attribute.typedKey == 'catalog_store_id'}">
			<c:set var="catalogStoreId" value="${attribute.typedValue}"/>
		</c:if>
	</c:forEach>
	<c:if test="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">	
		<c:set var="inherited" value="Inherited"/>
	</c:if>
	<c:if test="${catalogGroup.dynamicCatalogGroup == '1'}">
		<c:set var="dynamic" value="Dynamic"/>
	</c:if>
	<c:set var="objectType" value="${inherited}${dynamic}${type}"/>
	<c:set var="referenceObjectType" value="Child${inherited}CatalogGroup"/>	
	
	<object objectType="${referenceObjectType}">
		<childCatalogGroupId>${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupId>
		
		<c:choose>
			<c:when test="${type == 'SalesCatalogGroup'}">
				<jsp:directive.include file="../../catalog/restricted/serialize/SerializeSalesCatalogGroup.jspf" />
			</c:when>
			<c:otherwise>
				<jsp:directive.include file="../../catalog/restricted/serialize/SerializeCatalogGroup.jspf" />
			</c:otherwise>
		</c:choose>	
		
	</object>
</c:forEach>
