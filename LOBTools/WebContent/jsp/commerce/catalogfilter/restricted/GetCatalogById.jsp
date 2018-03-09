<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
	var="catalogs"
	expressionBuilder="getCatalogDetailsByID">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<c:forTokens var="value" items="${uniqueIDs}" delims=",">
		<wcf:param name="catalogId" value="${value}" />
	</c:forTokens>
</wcf:getData>

<c:if test="${!(empty catalogs)}">
<c:forEach var="catalog" items="${catalogs}">
		<c:choose>
			<c:when test="${catalog.catalogIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
				<c:set var="referencedObjectType" value="InheritedCatalogElement" />
				<c:set var="objectType" value="InheritedCatalog" />
			</c:when>
		<c:otherwise>
				<c:set var="referencedObjectType" value="CatalogElement" />
				<c:set var="objectType" value="Catalog" />
		</c:otherwise>
	    </c:choose>
		<object objectType="${referencedObjectType}">
		    <uniqueId>${catalogGroupConditionGroup.catalogGroupSelectionIdentifier.uniqueID}</uniqueId>
		    <elementId>0</elementId>
			<xclude><wcf:cdata data="${catalogGroupConditionGroup.selection}"/></xclude>
			<jsp:directive.include file="/jsp/commerce/catalog/restricted/serialize/SerializeCatalog.jspf" />
			
			<c:forEach var="catalogFilterAttributeSet" items="${catalogGroupConditionGroup.conditionGroup}">
				<jsp:directive.include file="serialize/SerializeCatalogFilterAttributeSet.jspf" />
			</c:forEach>
		
		</object>
</c:forEach>
</c:if>
