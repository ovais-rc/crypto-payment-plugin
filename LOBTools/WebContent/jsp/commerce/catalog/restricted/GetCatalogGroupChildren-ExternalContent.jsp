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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType"
	var="catalogGroup"
	expressionBuilder="getCatalogGroupExternalContentByID"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="catGroupId" value="${param.parentId}"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	
	<c:forEach var="externalContentReference" items="${catalogGroup.externalContentReference}">
		<object objectType="CatalogGroupExternalContentReference">
			<catId><wcf:cdata data="${param.parentId}"/></catId>
			<externalContentId><wcf:cdata data="${externalContentReference.externalContentIdentifier}"/></externalContentId>
			<languageId><wcf:cdata data="${externalContentReference.language}"/></languageId>
			<relationshipIdentifier><wcf:cdata data="${externalContentReference.uniqueID}"/></relationshipIdentifier>
			
			<object objectType="CatalogGroupExternalContent">
				<catId><wcf:cdata data="${param.parentId}"/></catId>
				<identifier><wcf:cdata data="${externalContentReference.externalContentIdentifier}"/></identifier>
				<name><wcf:cdata data="${externalContentReference.name}"/></name>
				<description><wcf:cdata data="${externalContentReference.externalContentDescription}"/></description>
				<contentType><wcf:cdata data="${externalContentReference.externalContentType}"/></contentType>
				<lastUpdateTime><wcf:cdata data="${externalContentReference.lastUpdateTime}"/></lastUpdateTime>
				<c:forEach var="asset" items="${externalContentReference.externalContentAsset}">
					<object objectType="ExternalContentAsset">
						<assetName><wcf:cdata data="${asset.name}"/></assetName>
						<assetPath><wcf:cdata data="${asset.assetPath}"/></assetPath>
						<assetFullPath><wcf:cdata data="${asset.assetPath}"/></assetFullPath>
						<assetMimeType><wcf:cdata data="${asset.mimeType}"/></assetMimeType>
					</object>
				</c:forEach>
			</object>

			<%-- 
			<c:forEach var="userDataField" items="${description.attributes}">
				<xdesc_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></xdesc_${userDataField.typedKey}>
			</c:forEach> --%>
		</object>
	</c:forEach>
</objects>