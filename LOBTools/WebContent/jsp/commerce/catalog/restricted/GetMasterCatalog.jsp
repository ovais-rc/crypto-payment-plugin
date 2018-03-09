<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<values>
	<c:if test="${(param.catalogViewRole == true) || (param.marketingViewRole == true) || (param.promotionViewRole == true) || (param.attachmentViewRole == true) || (param.pricingViewRole == true) || (param.layoutViewRole == true)}">
		<%--
			==========================================================================
			Call the get service for catalog to retrieve the
			master catalog for the store currently selected.
			==========================================================================
		--%>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
			var="masterCatalog"
			expressionBuilder="getMasterCatalog">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
		</wcf:getData>
		
		<wcf:getData
			type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
			var="searchEnabled" expressionBuilder="findByUniqueID">
			<wcf:contextData name="storeId" data="${param.storeId}" />
			<wcf:param name="uniqueId"
				value="com.ibm.commerce.foundation.search" />
		</wcf:getData>
		
		<masterCatalogId>${masterCatalog.catalogIdentifier.uniqueID}</masterCatalogId>
		<masterCatalogIdentifier><wcf:cdata data="${masterCatalog.catalogIdentifier.externalIdentifier.identifier}"/></masterCatalogIdentifier>
		<masterCatalogStoreId>${masterCatalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID}</masterCatalogStoreId>
		<c:forEach var="attribute"	items="${searchEnabled.configurationAttribute}">
			<c:if test="${attribute.primaryValue.name=='searchEnabled'}">
				<searchEnabled>${attribute.primaryValue.value}</searchEnabled>
			</c:if>
		</c:forEach>
	</c:if>
	<c:if test="${(param.catalogViewRole == true) || (param.marketingViewRole == true) || (param.promotionViewRole == true) || (param.attachmentViewRole == true) || (param.pricingViewRole == true)}">
		<%--
			==========================================================================
			Call the get service for attribute dictionary to retrieve the
			attribute dictionary for the store currently selected.
			==========================================================================
		--%>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryType"
			var="attributeDictionary"
			expressionBuilder="findAttributeDictionary"
			maxItems="1">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
		</wcf:getData>
		
		<%--
			Determine if the attribute dictionary has been mass loaded
			for the current store.  If it has set 'attributeDictionaryEnabledForStore'
			to 'true'.
		--%>
		<c:choose>
			<c:when test="${!(empty attributeDictionary)}">
				<attributeDictionaryEnabledForStore>enabled</attributeDictionaryEnabledForStore>
			</c:when>
			<c:otherwise>
				<attributeDictionaryEnabledForStore>disabled</attributeDictionaryEnabledForStore>
			</c:otherwise>
		</c:choose>
		<attributeDictionaryId>${attributeDictionary.attributeDictionaryIdentifier.uniqueID}</attributeDictionaryId>

		<%--
			==========================================================================
			Call the get service for online store to retrieve the
			flag used to determine if catalog entry description override
			is enabled or not.
			==========================================================================
		--%>
		<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
			var="onlineStore"
			varShowVerb="showVerb"
			expressionBuilder="findByUniqueID">
			<wcf:param name="usage" value="IBM_ViewCatalogTool"/>
			<wcf:param name="storeId" value="${param.storeId}"/>
			<wcf:param name="accessProfile" value="IBM_Admin_All"/>
		</wcf:getData>
		
		<%--
			Determine if the description override feature has been enabled for this store.
			If it has then set 'descriptionOverrideEnabledForStore' to 'enabled'.
		--%>
		<c:set var="enabled" value="false" />
		<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
			<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
				<c:if test="${userDataField.typedKey == 'isCatalogOverrideEnabled'}">
					<c:if test="${userDataField.typedValue == 1}">
						<c:set var="enabled" value="true" />
					</c:if>
				</c:if>
			</c:forEach>
		</c:if>
		<descriptionOverrideEnabledForStore>${enabled}</descriptionOverrideEnabledForStore>
	</c:if>
</values>
