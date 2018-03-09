<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>


<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="onlineStore"
	varShowVerb="showVerbOnlineStore"
	expressionBuilder="findStoreByUniqueIDWithLanguage">
	<wcf:param name="usage" value="IBM_ViewCatalogTool"/>
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>
	
	
<objects>


<c:if test="${!empty onlineStore && !empty onlineStore.defaultCatalog}">
	<c:forEach var="defaultCat" items="${onlineStore.defaultCatalog}">
		<c:if test="${!empty defaultCat.catalogIdentifier}">
			<c:set var="catalogId" value="${defaultCat.catalogIdentifier.uniqueID}"/>
			
			<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType"
			var="catalog"
			varShowVerb="showVerb"
			expressionBuilder="getCatalogDetailsByID">
			<wcf:param name="catalogId" value="${catalogId}"/>
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			</wcf:getData> 
			
			<c:choose>	
				<c:when test="${defaultCat.storeIdentifier.uniqueID != param.storeId}">
					<c:set var="objectType" value="InheritedDefaultCatalogReference"/>
				</c:when>
				<c:otherwise>
					<c:set var="objectType" value="DefaultCatalogReference"/>
				</c:otherwise>
			</c:choose>
			
				
			<object objectType="${objectType}">
				<objectStoreId>${defaultCat.storeIdentifier.uniqueID}</objectStoreId>
				<storeDefCatId>${defaultCat.uniqueID}</storeDefCatId>
				<c:forEach var="userDataField" items="${defaultCat.userData.userDataField}">
					<xdefcat_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></xdefcat_${userDataField.typedKey}>
				</c:forEach>
				<jsp:directive.include file="serialize/SerializeCatalog.jspf"/>
			</object>
		</c:if>			
	</c:forEach> 
	
</c:if>
			
	
</objects>





