<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
	<c:if test="${elementVariable.name == 'filterName'}">
		<c:set var="filterName" value="${elementVariable.value}" />
	</c:if>
	<c:if test="${elementVariable.name == 'filterValue'}">
		<c:set var="filterValue" value="${elementVariable.value}" />
	</c:if>
</c:forEach>

<c:set var="elementObjectType" value="${filterName}" />
<c:if test="${filterName == 'categoryId'}">
	<c:set var="owningCatalog" value="${param.masterCatalogId}"/>
	<c:set var="owningCatalogIdentifier" value="${param.masterCatalogIdentifier}"/>
	<c:set var="catalogStoreId" value="${param.masterCatalogStoreId}"/>
	<c:set var="catGroupId" value="${filterValue}"/>
	<c:set var="filterValues" value="${fn:split(filterValue, '_')}"/>
	<c:if test="${fn:length(filterValues) == 2}">
		<c:set var="owningCatalog" value="${filterValues[0]}"/>
		<c:set var="catGroupId" value="${filterValues[1]}"/>
	</c:if>
	<c:if test="${owningCatalog != param.masterCatalogId}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
			var="salesCatalog"
			expressionBuilder="getCatalogDetailsByID">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="catalogId" value="${owningCatalog}"/>
		</wcf:getData>
		<c:set var="owningCatalogIdentifier" value="${salesCatalog.catalogIdentifier.externalIdentifier.identifier}"/>
		<c:set var="catalogStoreId" value="${salesCatalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/>
	</c:if>
	<wcf:getData
		type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType"
		var="catalogGroup" expressionBuilder="getCatalogGroupDetailsByID" varShowVerb="showVerb">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:contextData name="catalogId" data="${owningCatalog}" />
		<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
		<wcf:param name="catGroupId" value="${catGroupId}" />
	</wcf:getData>
	
	<c:set var="inherited" value=""/>
	<c:set var="dynamic" value=""/>	
	<c:set var="type" value="CatalogGroup"/>	
		
	<c:if test="${param.storeId != catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}">
		<c:set var="inherited" value="Inherited"/>
	</c:if>
	<c:if test="${catalogGroup.dynamicCatalogGroup == '1'}">
		<c:set var="dynamic" value="Dynamic"/>
	</c:if>	
	<c:forEach var="attribute" items="${catalogGroup.attributes}">
		<c:if test="${attribute.typedKey == 'catalog_group_type'}">
			<c:set var="type" value="${attribute.typedValue}"/>
		</c:if>
	</c:forEach>	

  <c:set var="objectType" value="${inherited}${dynamic}${type}"/>	
  <c:set var="elementObjectType" value="Child${inherited}CatalogGroup" />

</c:if>

<c:if test="${filterName == 'catEntryId'}">
	<c:set var="catentryId" value="${filterValue}"/>
	<c:if test="${catentryId != ''}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogEntryType" var="catentry" expressionBuilder="getCatalogEntryDetailsByID" varShowVerb="showVerb">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:contextData name="catalogId" data="${param.masterCatalogId}" />
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="catEntryId" value="${catentryId}" />
		</wcf:getData>
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${catentry}" scope="request"/>
		<c:choose>
			<c:when test="${catentry.catalogEntryIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
				<c:set var="elementObjectType" value="ChildInheritedCatentry" />
			</c:when>
			<c:otherwise>
				<c:set var="elementObjectType" value="ChildCatentry" />
			</c:otherwise>
		</c:choose>
	</c:if>
</c:if>

<object objectType="${elementObjectType}">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${elementVariable.name != 'filterValue'}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
		</c:if>
		<c:if test="${elementVariable.name == 'filterValue'}">
			<c:choose>
				<c:when test="${elementObjectType == filterName}">
					<object objectType="filterValue">
						<filterValueId><wcf:cdata data="${elementVariable.value}"/></filterValueId>
						<filterValue><wcf:cdata data="${elementVariable.value}"/></filterValue>
					</object>
				</c:when>
				<c:when test="${elementObjectType == 'ChildCatentry' or elementObjectType == 'ChildInheritedCatentry'}">
					<jsp:directive.include file="../../catalog/restricted/serialize/SerializeGenericCatalogEntry.jspf" />
				</c:when>
				<c:otherwise>
					<c:if test="${owningCatalog == param.masterCatalogId}">
						<jsp:directive.include file="../../catalog/restricted/serialize/SerializeCatalogGroup.jspf" />
					</c:if>
					<c:if test="${owningCatalog != param.masterCatalogId}">
						<jsp:directive.include file="../../catalog/restricted/serialize/SerializeSalesCatalogGroup.jspf" />
					</c:if>
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:forEach>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
 