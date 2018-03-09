<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

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
<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
    recordSetCount="${showVerb.recordSetCount}"
    recordSetReferenceId="${showVerb.recordSetReferenceId}"
    recordSetStartNumber="${showVerb.recordSetStartNumber}"
    recordSetTotal="${showVerb.recordSetTotal}">
    <c:forEach var="catalogGroup" items="${topCategories}">
		<%-- Default case: assume everything is one store --%>
		<c:set var="inherited" value="" />    
        <c:set var="layoutOwningStoreId" value="${catalogGroup.catalogGroupIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		 <c:if test="${param.storeId != layoutOwningStoreId}">
		 	<%-- asset store case--%>
		 	<c:set var="layoutOwningStoreId" value="${param.assetStoreId}" />
			<c:if test="${param.storeId != param.assetStoreId}">
				<%-- esite case--%>
				<c:set var="inherited" value="Inherited" />
			</c:if>
		</c:if> 
		<c:set var="objectType" value="${inherited}TopCatalogGroupPage" />
		<c:set var="pageType" value="TopCategoryPage" />
        <object objectType="ChildCatalogGroupPage">
            <childCatalogGroupPageId>${param.parentId}_${catalogGroup.catalogGroupIdentifier.uniqueID}</childCatalogGroupPageId>
            <jsp:directive.include file="serialize/SerializeCatalogGroupPage.jspf"/>
        </object>
    </c:forEach>
</objects>
