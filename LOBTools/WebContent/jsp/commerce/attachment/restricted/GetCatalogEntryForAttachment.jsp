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
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntries"
	expressionBuilder="getCatalogEntryForAttachment"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">

	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="attachmentId" value="${param.attachmentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:set var="attachmentId" value = "${param.attachmentId}" />
<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty catalogEntries)}">
<c:forEach var="catalogEntry" items="${catalogEntries}">
<c:choose>
<c:when test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
		<c:set var="objectType" value="Product"/>
	</c:if>
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
		<c:set var="objectType" value="InheritedProduct"/>
	</c:if>
</c:when>
<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
		<c:set var="objectType" value="Bundle"/>
	</c:if>
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
		<c:set var="objectType" value="InheritedBundle"/>
	</c:if>
</c:when>
<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean'}">
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
		<c:set var="objectType" value="Kit"/>
	</c:if>
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
		<c:set var="objectType" value="InheritedKit"/>
	</c:if>
</c:when>
<c:when test="${catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
		<c:set var="objectType" value="Kit"/>
	</c:if>
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
		<c:set var="objectType" value="InheritedKit"/>
	</c:if>
</c:when>
<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
		<c:set var="objectType" value="PredefinedDKit"/>
	</c:if>
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
		<c:set var="objectType" value="InheritedPredefinedDKit"/>
	</c:if>
</c:when>
<c:when
	test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
	<c:choose>
		<c:when test="${(!empty catalogEntry.parentCatalogEntryIdentifier)}">
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
				<c:set var="objectType" value="ProductSKU"/>
			</c:if>
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
				<c:set var="objectType" value="InheritedProductSKU"/>
			</c:if>
		</c:when>
		<c:when test="${(empty catalogEntry.parentCatalogEntryIdentifier) && (!empty catalogEntry.parentCatalogGroupIdentifier)}">
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
				<c:set var="objectType" value="CatalogGroupSKU"/>
			</c:if>
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
				<c:set var="objectType" value="InheritedCatalogGroupSKU"/>
			</c:if>
		</c:when>
		<c:otherwise>
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID == param.storeId }">
				<c:set var="objectType" value="ProductSKU"/>
			</c:if>
			<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
				<c:set var="objectType" value="InheritedProductSKU"/>
			</c:if>
		</c:otherwise>
	</c:choose>
</c:when>
<c:otherwise><c:set var="objectType" value="unknown"/></c:otherwise>
</c:choose>



	<reference>

	          <c:forEach var="attachmentReference" items="${catalogEntry.attachmentReference}">
	          	<c:choose>
	              <c:when test= "${attachmentId == attachmentReference.attachmentIdentifier.uniqueID}">
	                 <c:set var="attachmentRefId" value="${attachmentReference.attachmentReferenceIdentifier.uniqueID}"/>
	             	 <c:set var="attachmentReferenceObjectType" value="AttachmentReference" />
					 <c:set var="owningStoreId" value="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
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
			    <jsp:directive.include file="../../catalog/restricted/serialize/SerializeCatalogEntry.jspf"/>
			  </parent>
			</object>
		</reference>

</c:forEach>
</c:if>

</objects>
