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
<%
//* This JSP is responsible for getting the configuration for a specified store.
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType[]"
		var="configurations"
		expressionBuilder="findAll">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
</wcf:getData>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="onlineStore"
	expressionBuilder="findByUniqueID">
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="accessProfile" value="IBM_Details"/>
</wcf:getData>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
		var="onlineStore2"
		expressionBuilder="findByUniqueID">
	<wcf:param name="accessProfile" value="IBM_All"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
</wcf:getData>

<c:set var="assetStoreId" value="${param.storeId}"/>

<c:forEach var="relatedStore" items="${onlineStore2.onlineStoreRelatedStores}">
	<c:if test="${relatedStore.relationshipType == '-11' && relatedStore.state == '1' && relatedStore.storeIdentifier.uniqueID != onlineStore2.onlineStoreIdentifier.uniqueID}">
		<c:set var="assetStoreId" value="${relatedStore.storeIdentifier.uniqueID}"/>
	</c:if>
</c:forEach>

<c:if test="${assetStoreId != param.storeId}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
		var="assetStore"
		expressionBuilder="findByUniqueID">
		<wcf:param name="storeId" value="${assetStoreId}"/>
		<wcf:param name="accessProfile" value="IBM_Details"/>
	</wcf:getData>
</c:if>

<object objectType="Store">
	<storeId>${param.storeId}</storeId>
	<c:forEach var="config" items="${configurations}">
		<c:choose>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.supportedLanguages'}"><c:set var="objectType" value="StoreLanguage"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.supportedCurrencies'}"><c:set var="objectType" value="StoreCurrency"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.defaultCurrency'}"><c:set var="objectType" value="StoreDefaultCurrency"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.inventorySystem'}"><c:set var="objectType" value="StoreInventorySystem"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.fulfillmentCenter'}"><c:set var="objectType" value="StoreFulfillmentCenter"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.staticContent'}"><c:set var="objectType" value="StoreStaticContent"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.shippingMode'}"><c:set var="objectType" value="StoreShippingMode"/></c:when>
			<c:when test="${config.configurationIdentifier.uniqueID == 'com.ibm.commerce.foundation.analytics'}"><c:set var="objectType" value="StoreAnalytics"/></c:when>
			<c:otherwise><c:set var="objectType" value=""/></c:otherwise>
		</c:choose>
		<c:if test="${objectType != ''}">
			<c:forEach var="attribute" items="${config.configurationAttribute}">
				<object objectType="${objectType}">
					<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
					<c:forEach var="additionalValue" items="${attribute.additionalValue}">
						<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
					</c:forEach>
				</object>
			</c:forEach>
		</c:if>
	</c:forEach>

<c:if test="${param.storeId != '0'}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="remoteWidgetsConfig" varException="e" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.remoteWidgets" />
	</wcf:getData>
	<c:if test="${empty e}">
		<c:forEach var="attribute" items="${remoteWidgetsConfig.configurationAttribute}">
			<object objectType="StoreRemoteWidgets">
				<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
				<c:forEach var="additionalValue" items="${attribute.additionalValue}">
					<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
				</c:forEach>
			</object>
		</c:forEach>
	</c:if>
</c:if>

<c:if test="${param.storeId != '0'}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		         var="isRemoteStoreConfig" expressionBuilder="findByUniqueID">
		    <wcf:contextData name="storeId" data="${param.storeId}" />
		    <wcf:param name="uniqueId" value="com.ibm.commerce.foundation.isRemoteStore" />
	</wcf:getData>
	
	<c:forEach var="attribute" items="${isRemoteStoreConfig.configurationAttribute}">
		<object objectType="IsRemoteStore">
			<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
			<c:forEach var="additionalValue" items="${attribute.additionalValue}">
				<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
			</c:forEach>
		</object>
	</c:forEach>
</c:if>
	
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="listPriceListConfig" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.listPriceList" />
	</wcf:getData>
	<c:forEach var="attribute" items="${listPriceListConfig.configurationAttribute}">
		<object objectType="StoreListPriceList">
			<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
			<c:forEach var="additionalValue" items="${attribute.additionalValue}">
				<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
			</c:forEach>
		</object>
	</c:forEach>

<c:if test="${param.storeId != '0'}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="sterlingConfig" varException="e" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.configurator" />
	</wcf:getData>
	<c:if test="${empty e}">
		<c:forEach var="attribute" items="${sterlingConfig.configurationAttribute}">
			<object objectType="StoreSterlingConfig">
				<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
				<c:forEach var="additionalValue" items="${attribute.additionalValue}">
					<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
				</c:forEach>
			</object>
		</c:forEach>
	</c:if>
</c:if>

<c:if test="${param.storeId != '0'}">
	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="wchConfig" varException="e" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${param.storeId}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.watsoncontenthub" />
	</wcf:getData>
	<c:if test="${empty e}">
		<c:forEach var="attribute" items="${wchConfig.configurationAttribute}">
			<object objectType="StoreWCHConfig">
				<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
				<c:forEach var="additionalValue" items="${attribute.additionalValue}">
					<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
				</c:forEach>
			</object>
		</c:forEach>
	</c:if>
</c:if>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="seoConfig" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.seo" />
</wcf:getData>
<c:forEach var="attribute" items="${seoConfig.configurationAttribute}">
	<object objectType="StoreSEO">
		<${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
		<c:forEach var="additionalValue" items="${attribute.additionalValue}">
			<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
		</c:forEach>
	</object>
</c:forEach>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="remoteStoreServerConfig" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.remoteStoreServer" />
</wcf:getData>
<c:forEach var="attribute" items="${remoteStoreServerConfig.configurationAttribute}">
	<object objectType="RemoteStoreServer">
		<c:forEach var="additionalValue" items="${attribute.additionalValue}">
			<${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
		</c:forEach>
	</object>
</c:forEach>

	<object objectType="StoreResolveContentURL">
		<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
			<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
				<c:if test="${fn:startsWith(userDataField.typedKey, 'wc.resolveContentURL.')}">
					<c:set var="propertyName" value="${fn:substring(userDataField.typedKey,fn:length('wc.resolveContentURL.'),fn:length(userDataField.typedKey))}" />
					<${propertyName}><wcf:cdata data="${userDataField.typedValue}"/></${propertyName}>
				</c:if>
			</c:forEach>
		</c:if>
	</object>

	<object objectType="CKEditorSubstitutionTags">
		<c:if test="${!(empty assetStore) && !(empty assetStore.userData)}">
			<c:forEach var="userDataField" items="${assetStore.userData.userDataField}">
				<c:if test="${fn:startsWith(userDataField.typedKey, 'CK_') && fn:length(userDataField.typedKey) > 3}">
					<c:set var="propertyName" value="${fn:substring(userDataField.typedKey,fn:length('CK_'),fn:length(userDataField.typedKey))}" />
					<${propertyName}><wcf:cdata data="${userDataField.typedValue}"/></${propertyName}>
				</c:if>
			</c:forEach>
		</c:if>
		<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
			<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
				<c:if test="${fn:startsWith(userDataField.typedKey, 'CK_') && fn:length(userDataField.typedKey) > 3}">
					<c:set var="propertyName" value="${fn:substring(userDataField.typedKey,fn:length('CK_'),fn:length(userDataField.typedKey))}" />
					<${propertyName}><wcf:cdata data="${userDataField.typedValue}"/></${propertyName}>
				</c:if>
			</c:forEach>
		</c:if>
	</object>

<c:set var="UseCommerceComposer" value="false"/>
<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotDataType" var="espot" expressionBuilder="findByMarketingSpotName">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="DM_Emspot_Usage" value="STOREFEATURE"/>
	<wcf:param name="DM_EmsName" value="UseCommerceComposer" />
</wcf:getData>

<c:forEach var="content" items="${espot.baseMarketingSpotActivityData}">
	<c:if test="${content.dataType == 'FeatureEnabled'}">
		<c:set var="UseCommerceComposer" value="${content.name}"/>
	</c:if>
</c:forEach>

	<object objectType="StoreFlowOptions">
		<UseCommerceComposer>${UseCommerceComposer}</UseCommerceComposer>
	</object>
	
<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotDataType" var="espot" expressionBuilder="findByMarketingSpotName">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="DM_Emspot_Usage" value="STOREFILEREF"/>
	<wcf:param name="DM_EmsName" value="vfile.stylesheetbase" />
</wcf:getData>

<c:forEach var="content" items="${espot.baseMarketingSpotActivityData}">
	<c:choose>
		<c:when test="${content.dataType == 'URL'}">
			<c:set var="storeCSS" value="${content.name}"/>
		</c:when>
		<c:when test="${content.dataType == 'Locales'}">
			<c:set var="storeCSSLocales" value="${content.name}"/>
		</c:when>
	</c:choose>
</c:forEach>

	<object objectType="StoreCSS">
		<url>${storeCSS}</url>
		<locales>${storeCSSLocales}</locales>
	</object>
	
</object>
