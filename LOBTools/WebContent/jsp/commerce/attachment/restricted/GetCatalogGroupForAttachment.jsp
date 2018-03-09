<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
	var="catalogGroups"
	expressionBuilder="getCatalogGroupForAttachment"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:param name="attachmentId" value="${param.attachmentId}"/>
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:set var="attachmentId" value = "${param.attachmentId}" />
<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty catalogGroups)}">
	<c:forEach var="catalogGroup" items="${catalogGroups}">

	    <reference>

	           <c:forEach var="attachmentReference" items="${catalogGroup.attachmentReference}">
	          	<c:choose>
	              <c:when test= "${attachmentId == attachmentReference.attachmentIdentifier.uniqueID}">
	                 	<c:set var="attachmentRefId" value="${attachmentReference.attachmentReferenceIdentifier.uniqueID}"/>
	             		<c:set var="attachmentReferenceObjectType" value="AttachmentReference" />
						<c:set var="owningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
						<c:set var="attachmentStoreId" value="${attachmentReference.attachmentIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
						<c:if test="${(param.storeId) == owningStoreId && (param.storeId) != attachmentStoreId}">
						    <c:set var="attachmentReferenceObjectType" value="BusinessObjectToInheritedAttachment" />
						</c:if>
						<c:if test="${(param.storeId) != owningStoreId}">
							<c:set var="attachmentReferenceObjectType" value="InheritedBusinessObjectToInheritedAttachment" />
						</c:if>
	              </c:when>
	          	</c:choose>
	          	</c:forEach>

	          	<object objectType="${attachmentReferenceObjectType}">
				 <attachmentRefId><wcf:cdata data="${attachmentRefId}"/></attachmentRefId>
			 	 <parent>
			 	 <c:forEach var="attribute" items="${catalogGroup.attributes}">
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
				<c:choose>
						<c:when test="${type == 'SalesCatalogGroup'}">
								<c:set var="dynamic" value=""/>	
								<c:if test="${catalogGroup.dynamicCatalogGroup == '1'}">
									<c:set var="dynamic" value="Dynamic"/>
								</c:if>	
								<c:set var="objectType" value="${dynamic}SalesCatalogGroup" />
								<c:set var="owningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
								<c:if test="${(param.storeId) != owningStoreId}">
									<c:set var="objectType" value="Inherited${dynamic}SalesCatalogGroup" />
								</c:if>
							 	<jsp:directive.include file="../../catalog/restricted/serialize/SerializeSalesCatalogGroup.jspf"/>										
						</c:when>
						<c:otherwise>
								<c:set var="objectType" value="CatalogGroup" />
								<c:set var="owningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
								<c:if test="${(param.storeId) != owningStoreId}">
									<c:set var="objectType" value="InheritedCatalogGroup" />
								</c:if>
								<jsp:directive.include file="../../catalog/restricted/serialize/SerializeCatalogGroup.jspf"/>
						</c:otherwise>
				</c:choose>
			  </parent>
			</object>
		</reference>
	</c:forEach>
</c:if>
</objects>
