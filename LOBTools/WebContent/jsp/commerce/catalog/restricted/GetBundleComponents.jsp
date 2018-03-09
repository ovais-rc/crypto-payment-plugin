<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="en_US" />
<c:choose>
	<c:when test="${!(param.sterlingConfigEnabled == 'true' and param.catenttypeId == 'DynamicKitBean')}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
			var="catalogEntries"
			expressionBuilder="getCatalogEntryComponentsByID"
			varShowVerb="showVerb2"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:contextData name="versionId" data="${param.objectVersionId}"/>
			<wcf:param name="catEntryId" value="${param.parentId}"/>
			<wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
		</wcf:getData>
	 
		<objects recordSetCompleteIndicator="${showVerb2.recordSetCompleteIndicator}"
			recordSetReferenceId="${showVerb2.recordSetReferenceId}"
			recordSetStartNumber="${showVerb2.recordSetStartNumber}"
			recordSetCount="${showVerb2.recordSetCount}"
			recordSetTotal="${showVerb2.recordSetTotal}">
		
	
			<c:if test="${!(empty catalogEntries)}">
				<c:forEach var="catentry" items="${catalogEntries}">
		   		 <%-- 
		    	GetCatalogEntryDetailsByID.jspf needs to have the variable catalogEntryReferenceList set.
		        Each element of catalogEntryReferenceList needs to be able retrieve catalogEntryReferenceList[].catalogEntryReference.catalogEntryIdentifier.uniqueID 
		        A hashmap CATALOG_ENTRIES_HASH_MAP will be returned. This hashmap contains CatalogEntry nouns. The key is the catalog entry id.
		        The varShowVerb used by GetCatalogEntryDetailsByID.jspf is showVerb_1 and it should be used when setting the locking information on the catalog entry object.
				--%>
					<c:set var="catalogEntryReferenceList" value="${catentry.kitComponent}"/>
					<jsp:directive.include file="GetCatalogEntryDetailsByIDs.jspf"/>
	
		    		<%-- Iterate through each component of the kit to create the reference child object --%>		
					<c:forEach var="component" items="${catentry.kitComponent}">
						<c:set var="objectTypePrefix" value=""/>
						<c:if test="${component.catalogEntryReference.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
							<c:set var="objectTypePrefix" value="Inherited"/>
						</c:if>
						<c:set var="objectStoreId" value="${component.catalogEntryReference.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
						<c:set var="componentTypePrefix" value=""/>
						<c:if test="${catentry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
							<c:set var="componentTypePrefix" value="Inherited"/>
						</c:if>
						<c:choose>
							<c:when test="${component.catalogEntryReference.catalogEntryTypeCode == 'ProductBean'}">
								<c:set var="childType" value="Product"/>
							</c:when>
							<c:when test="${component.catalogEntryReference.catalogEntryTypeCode == 'ItemBean'}">
									<c:set var="objectStoreId" value="${CATALOG_ENTRIES_HASH_MAP[component.catalogEntryReference.catalogEntryIdentifier.uniqueID].catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
									<c:choose>
										<c:when test="${(!empty CATALOG_ENTRIES_HASH_MAP[component.catalogEntryReference.catalogEntryIdentifier.uniqueID].parentCatalogEntryIdentifier)}">
											<c:set var="childType" value="ProductSKU"/>
										</c:when>
										<c:when test="${(empty CATALOG_ENTRIES_HASH_MAP[component.catalogEntryReference.catalogEntryIdentifier.uniqueID].parentCatalogEntryIdentifier) && (!empty CATALOG_ENTRIES_HASH_MAP[component.catalogEntryReference.catalogEntryIdentifier.uniqueID].parentCatalogGroupIdentifier)}">
											<c:set var="childType" value="CatalogGroupSKU"/>
										</c:when>
										<c:otherwise>
											<c:set var="childType" value="ProductSKU"/>
										</c:otherwise>
									</c:choose>
							</c:when>
						</c:choose>
						<c:set var="compObjectType" value="${componentTypePrefix}${param.componentType}Component"/>
						<c:if test="${param.sterlingConfigEnabled == 'true' and catentry.catalogEntryTypeCode == 'PredDynaKitBean'}">
							<c:set var="compObjectType" value="${componentTypePrefix}SterlingDynamicKitComponent"/>
						</c:if>
						<object objectType="${compObjectType}">
							<catentrelId>${param.parentId}_${component.catalogEntryReference.catalogEntryIdentifier.uniqueID}</catentrelId>
							<componentId>${component.catalogEntryReference.catalogEntryIdentifier.uniqueID}</componentId>
							<quantity><fmt:formatNumber value="${component.quantity}" pattern="0"/></quantity>
							<sequence><fmt:formatNumber type="number" value="${component.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
							<c:if test="${param.componentType == 'PreDefinedKit'}">
								<c:forEach var="userDataField" items="${component.attributes}">
									<${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></${userDataField.typedKey}>
								</c:forEach>
							</c:if>
							<%-- Set the variables to call the serialize jspf --%>
							<c:set var="objectType" value="${objectTypePrefix}${childType}" />
							<c:set var="catalogEntry" value="${CATALOG_ENTRIES_HASH_MAP[component.catalogEntryReference.catalogEntryIdentifier.uniqueID]}" />
							<c:set var="showVerb" value="${showVerb_1}" />
							<c:set var="serializeParentReferenceObject" value="false" />
							<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
						</object>
					</c:forEach>
				</c:forEach>
			</c:if>	
		</objects>
	</c:when>
	<c:otherwise>
	<objects/>
	</c:otherwise>
</c:choose>