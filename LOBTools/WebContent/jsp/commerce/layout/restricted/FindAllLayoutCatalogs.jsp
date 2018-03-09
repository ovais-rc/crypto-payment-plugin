<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${(empty param.searchText)}">
		<%-- No search criteria is specified --%>
		<objects
			recordSetCompleteIndicator="true"
			recordSetReferenceId=""
			recordSetStartNumber="0"
			recordSetCount="0"
			recordSetTotal="0">
		</objects>
	</c:when>
	<c:otherwise>
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.CatalogType[]"
			var="catalogs"
			expressionBuilder="findAllCatalogsDetailsQuickSearch"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
			<wcf:param name="searchText" value="${param.searchText}"/>
		</wcf:getData>
		<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}" recordSetReferenceId="${showVerb.recordSetReferenceId}" recordSetStartNumber="${showVerb.recordSetStartNumber}" recordSetCount="${showVerb.recordSetCount}" recordSetTotal="${showVerb.recordSetTotal}">
			<c:forEach var="catalog" items="${catalogs}">		
				<jsp:directive.include file="serialize/SerializeLayoutCatalog.jspf"/>
			</c:forEach>
		</objects>		
	</c:otherwise> 
</c:choose>
