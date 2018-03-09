<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType[]"
	var="catalogEntryChildren"
	expressionBuilder="getCatalogEntryForAttribute"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="attrId" value="${param.parentId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>


<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}" recordSetReferenceId="${showVerb.recordSetReferenceId}" recordSetStartNumber="${showVerb.recordSetStartNumber}" recordSetCount="${showVerb.recordSetCount}" recordSetTotal="${showVerb.recordSetTotal}">
<c:forEach var="catalogEntry" items="${catalogEntryChildren}">
	<c:set var="attrId" value="${param.parentId}"/>
	<c:set var="attrUsage" value="Descriptive"/>
	<c:set var="attrUsageVal" value="1"/>
	<c:set var="attrValues" value=''/>
	<c:set var="deletable" value="true"/>
	<c:set var="inherited" value=''/>
	<c:set var="childTypeLocked" value=''/>
	<c:if test="${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId }">
		<c:set var="inherited" value="Inherited"/>
		<c:set var="childTypeLocked" value='readonly="true"'/>
	</c:if>
	<c:choose>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'ProductBean'}">
			<c:set var="objectType" value="${inherited}Product"/>
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'ItemBean'}">
			<c:set var="objectType" value="${inherited}ProductSKU"/>
			<c:if test="${(empty catalogEntry.parentCatalogEntryIdentifier)}">
				<c:set var="objectType" value="${inherited}CatalogGroupSKU"/>
 			</c:if> 		
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'BundleBean'}">
			<c:set var="objectType" value="${inherited}Bundle"/>
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'PackageBean' || catalogEntry.catalogEntryTypeCode == 'DynamicKitBean'}">
			<c:set var="objectType" value="${inherited}Kit"/>
		</c:when>
		<c:when test="${catalogEntry.catalogEntryTypeCode == 'PredDynaKitBean'}">
			<c:set var="objectType" value="${inherited}PredefinedDKit"/>
		</c:when>
	</c:choose>
 
    <c:forEach var="attribute" items="${catalogEntry.catalogEntryAttributes.attributes}">
		<c:if test="${!empty attribute.usage}">
			<c:if test="${attribute.attributeIdentifier.uniqueID != '' && attribute.attributeIdentifier.uniqueID == attrId }">

				<c:set var="attrUsage" value="${attribute.usage}"/>

			    <c:forEach var="attrval" items="${attribute.values}">
				    <c:choose>
						<c:when test="${ attrValues == '' }">
							<c:set var="attrValues" value="${attrval.value}"/>
						</c:when>
						<c:otherwise>
							<c:set var="attrValues" value="${attrValues},${attrval.value}"/>
						</c:otherwise>
			    	</c:choose>
				</c:forEach>					
				
				<c:if test="${attribute.usage == 'Defining'}">
					<c:set var="deletable" value="false"/>
					<c:set var="attrUsageVal" value="2"/>
				</c:if> 
				
				<c:if test="${attribute.attributeIdentifier.externalIdentifier.storeIdentifier != '' &&
				 attribute.attributeIdentifier.externalIdentifier.storeIdentifier != param.storeId &&
				 inherited == 'Inherited'}">
					<c:set var="deletable" value="false"/>
				</c:if> 
			</c:if>
		</c:if>
	</c:forEach>

	<object objectType="AttributeReferenceCatalogEntry" deletable='${deletable}'>
			<catentryId>${catalogEntry.catalogEntryIdentifier.uniqueID}</catentryId>
			<objectStoreId>${catalogEntry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID}</objectStoreId>
			<attrUsage>${attrUsage}</attrUsage>
			<attrRelationshipType>${attrUsageVal}</attrRelationshipType>
			<attrDisplaySequence>0</attrDisplaySequence>
			<changeControlModifiable>true</changeControlModifiable>
			<attrValues><![CDATA[${attrValues}]]></attrValues>
			<jsp:directive.include file="serialize/SerializeCatalogEntry.jspf"/>
	</object>
</c:forEach>
</objects>