<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="storeType" value="Store"/>
<c:set var="readonly" value="false"/>
<c:choose>
	<c:when test="${store.storeType == 'B2B' || store.storeType == 'BBB' || store.storeType == 'B2C'}">
		<c:set var="storeType" value="DirectStore"/>
	</c:when>
	<c:when test="${store.storeType == 'MHS' || store.storeType == 'BMH' || store.storeType == 'RHS' || store.storeType == 'BRH' || store.storeType == 'SHS'}">
		<c:set var="storeType" value="EsiteStore"/>
	</c:when>
	<c:when test="${store.storeType == 'HCP' || store.storeType == 'SCP' || store.storeType == 'CHS'}">
		<c:set var="storeType" value="HubStore"/>
	</c:when>
	<c:when test="${store.storeType == 'RPS' || store.storeType == 'BRP'  || store.storeType == 'SPS' || store.storeType == 'MPS' || store.storeType == 'BMP'}">
		<c:set var="storeType" value="AssetStore"/>
	</c:when>
	<c:when test="${store.storeType == 'CPS' || store.storeType == 'SCS'}">
		<c:set var="storeType" value="CatAssetStore"/>
	</c:when>
	<c:when test="${store.storeType == 'DPS' || store.storeType == 'PBS' || store.storeType == 'DPX'}">
		<c:set var="storeType" value="AuxiliaryStore"/>
		<c:set var="readonly" value="true"/>
	</c:when>
</c:choose>

<object objectType="${storeType}" readonly="${readonly}">
	<storeId>${store.onlineStoreIdentifier.uniqueID}</storeId>
	<storeIdentifier><wcf:cdata data="${store.onlineStoreIdentifier.externalIdentifier.nameIdentifier}"/></storeIdentifier>
	<storeCategory><wcf:cdata data="${store.storeType}"/></storeCategory>

	<state><wcf:cdata data="${store.state}"/></state>
	<defaultCurrency><wcf:cdata data="${store.onlineStoreSupportedCurrencies.defaultCurrency}"/></defaultCurrency>
	<defaultLanguage><wcf:cdata data="${store.onlineStoreSupportedLanguages.defaultLanguage}"/></defaultLanguage>

	<c:forEach var="relatedStore" items="${store.onlineStoreRelatedStores}">
		<c:if test="${relatedStore.relationshipType == '-11' && relatedStore.state == '1' && relatedStore.storeIdentifier.uniqueID != store.onlineStoreIdentifier.uniqueID}">
			<assetStoreId>${relatedStore.storeIdentifier.uniqueID}</assetStoreId>
		</c:if>
	</c:forEach>

	<c:forEach var="userDataField" items="${store.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
	<c:forEach var="desc" items="${store.onlineStoreDescription}">
		<c:set var="storeDesc" value="${desc}" scope="request"/>
		<jsp:include page="/cmc/SerializeStoreDescription"/>
	</c:forEach>

	<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		var="sterlingConfig" expressionBuilder="findByUniqueID">
		<wcf:contextData name="storeId" data="${store.onlineStoreIdentifier.uniqueID}" />
		<wcf:param name="uniqueId" value="com.ibm.commerce.foundation.configurator" />
	</wcf:getData>
	<c:forEach var="attribute" items="${sterlingConfig.configurationAttribute}">
			<c:if test="${'isEnabled' == attribute.primaryValue.name}">
				<isSterlingConfigEnabled><wcf:cdata data="${attribute.primaryValue.value}"/></isSterlingConfigEnabled>
			</c:if>
	</c:forEach>
	
        <wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
		         var="isRemoteStoreConfig" expressionBuilder="findByUniqueID">
		    <wcf:contextData name="storeId" data="${store.onlineStoreIdentifier.uniqueID}" />
		    <wcf:param name="uniqueId" value="com.ibm.commerce.foundation.isRemoteStore" />
	</wcf:getData>
	<c:forEach var="attribute" items="${isRemoteStoreConfig.configurationAttribute}">
			<c:if test="${'isRemote' == attribute.primaryValue.name}">
				<isRemote><wcf:cdata data="${attribute.primaryValue.value}"/></isRemote>
			</c:if>
	</c:forEach>  

	<jsp:include page="/cmc/SerializeChangeControlMetaData" />
</object>