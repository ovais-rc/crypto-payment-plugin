<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<fmt:setLocale value="en_US" />

<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogGroupType[]"
    var="topCategories"
    expressionBuilder="getTopCategoriesDetails"
    varShowVerb="showVerb"
    recordSetStartNumber="${param.recordSetStartNumber}"
    recordSetReferenceId="${param.recordSetReferenceId}"
    maxItems="${param.maxItems}">
    <wcf:contextData name="storeId" data="${param.storeId}"/>
    <wcf:contextData name="catalogId" data="${param.parentId}"/>
    <wcf:param name="dataLanguageIds" value="${param.defaultLanguageId}"/>
</wcf:getData>
<c:set var="owningCatalog" value="${param.parentId}" />
<c:set var="showVerb2" value="${showVerb}" scope="request"/>
<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
    recordSetCount="${showVerb.recordSetCount}"
    recordSetReferenceId="${showVerb.recordSetReferenceId}"
    recordSetStartNumber="${showVerb.recordSetStartNumber}"
    recordSetTotal="${showVerb.recordSetTotal}">
    <c:forEach var="catalogGroup" items="${topCategories}">
		<%-- Default case: assume everything is one store --%>
		<c:set var="inherited" value="" />    
		<c:set var="pageOwningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:if test="${param.storeId != pageOwningStoreId}">
		 	<%-- asset store case--%>
		 	<c:set var="pageOwningStoreId" value="${param.assetStoreId}" />
			<c:if test="${param.storeId != param.assetStoreId}">
				<%-- esite case--%>
				<c:set var="inherited" value="Inherited" />
			</c:if>
		</c:if> 
		<c:set var="objectType" value="${inherited}CatalogGroupBrowsingPage" />
		<c:set var="pageType" value="CategoryBrowsingPage" />
        <object objectType="ChildCatalogGroupBrowsingPage" readonly="true">
            <childCatalogGroupId>${param.parentId}_${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupId>
            <jsp:directive.include file="serialize/SerializeCatalogGroupPage.jspf"/>
        </object>
    </c:forEach>
</objects>
