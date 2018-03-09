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

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntries"
	expressionBuilder="getCatalogEntryMerchandisingAssociationReferencesDetailsById"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="catEntryId" value="${param.catentryId}"/>
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:if test="${!(empty catalogEntries)}">
		<c:forEach var="catalogEntry" items="${catalogEntries}">
			<c:forEach var="association1" items="${catalogEntry.association}">
				<c:if test="${association1.catalogEntryReference.catalogEntryIdentifier.uniqueID==param.catentryId}">
					<c:set var="childCatalogEntryStore" value="${association1.catalogEntryReference.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
					<c:set var="owningStoreId" value="${association1.attributes.storeID}"/>
					<c:set var="parentCatalogEntryStore" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>

					<reference>

					<c:choose>
						<c:when test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
								<c:set var="objectType" value="Product"/>
							</c:if>
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
								<c:set var="objectType" value="InheritedProduct"/>
							</c:if>
						</c:when>

						<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
								<c:set var="objectType" value="Bundle"/>
							</c:if>
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
								<c:set var="objectType" value="InheritedBundle"/>
							</c:if>
						</c:when>


						<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean'}">
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
								<c:set var="objectType" value="Kit"/>
							</c:if>
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
								<c:set var="objectType" value="InheritedKit"/>
							</c:if>
						</c:when>


						<c:when test="${catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
								<c:set var="objectType" value="Kit"/>
							</c:if>
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
								<c:set var="objectType" value="InheritedKit"/>
							</c:if>
						</c:when>
						
						<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
								<c:set var="objectType" value="PredefinedDKit"/>
							</c:if>
							<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
								<c:set var="objectType" value="InheritedPredefinedDKit"/>
							</c:if>
						</c:when>

						<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
							<c:if test="${catalogEntry.parentCatalogEntryIdentifier != null}">
								<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
									<c:set var="objectType" value="ProductSKU"/>
								</c:if>
								<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
									<c:set var="objectType" value="InheritedProductSKU"/>
								</c:if>
							</c:if>

							<c:if test="${catalogEntry.parentCatalogEntryIdentifier == null && catalogEntry.parentCatalogGroupIdentifier != null}">
								<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
									<c:set var="objectType" value="CatalogGroupSKU"/>
								</c:if>
								<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
									<c:set var="objectType" value="InheritedCatalogGroupSKU"/>
								</c:if>
							</c:if>

							<c:if test="${catalogEntry.parentCatalogEntryIdentifier == null && catalogEntry.parentCatalogGroupIdentifier == null}">
								<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId}">
									<c:set var="objectType" value="ProductSKU"/>
								</c:if>
								<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
									<c:set var="objectType" value="InheritedProductSKU"/>
								</c:if>
							</c:if>

						</c:when>
					</c:choose>

							<c:if test="${association1.attributes.storeID == param.storeId}">
								<c:set var="associationObjectType" value="MerchandisingAssociationReferencedCatalogEntries"/>
							</c:if>
							<c:if test="${association1.catalogEntryReference.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
								<c:set var="associationObjectType" value="MerchandisingAssociationReferencedInheritedCatalogEntries"/>
							</c:if>
							<c:if test="${(association1.catalogEntryReference.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId) && (association1.attributes.storeID != param.storeId)}">
								<c:set var="associationObjectType" value="InheritedMerchandisingAssociationReferencedInheritedCatalogEntries"/>
							</c:if>

						<object objectType="${associationObjectType}">

							<c:set var="showVerb" value="${showVerb}" scope="request"/>
							<c:set var="businessObject" value="${association1}" scope="request"/>
							<jsp:include page="/cmc/SerializeChangeControlMetaData" />

							<associationId>${association1.uniqueID}</associationId>
							<objectStoreId>${association1.attributes.storeID}</objectStoreId>
							<fmt:setLocale value="en_US"/>
							<name><wcf:cdata data="${association1.name}"/></name>
							<assocPartNumber><wcf:cdata data="${association1.catalogEntryReference.catalogEntryIdentifier.externalIdentifier.partNumber}"/></assocPartNumber>
							<quantity><fmt:formatNumber value="${association1.quantity}" pattern="0"/></quantity>
							<sequence><fmt:formatNumber type="number" value="${association1.displaySequence}" maxIntegerDigits="10" maxFractionDigits="13" pattern="#0.#" /></sequence>
							<semantic>${association1.semantic}</semantic>
							<c:forEach var="userDataField" items="${association1.attributes}">
								<xasso_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></xasso_${userDataField.typedKey}>
							</c:forEach>
							<parent>
								<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
							</parent>
						</object>
					</reference>
				</c:if>
			</c:forEach>
		</c:forEach>
	</c:if>
</objects>