<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
	var="searchColumnConfig" expressionBuilder="findByUniqueID">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueId" value="com.ibm.commerce.catalog.searchFacetColumns" />
</wcf:getData>

<objects>
	<c:forEach var="attribute" items="${searchColumnConfig.configurationAttribute}">
		<object	objectType="Facet">
			<searchColumn_Logical><wcf:cdata data="${attribute.primaryValue.name}"/></searchColumn_Logical>
			<c:forEach var="additionalValue" items="${attribute.additionalValue}">
				<c:if test="${additionalValue.name == 'UNIQUE_ID'}">
					<searchColumnId><wcf:cdata data="${additionalValue.value}"/></searchColumnId>
				</c:if>		
				<c:if test="${additionalValue.name == 'DISPLAY_NAME'}">
					<displayName><wcf:cdata data="${additionalValue.value}"/></displayName>
					<searchColumn_Physical><wcf:cdata data="${attribute.primaryValue.value}"/></searchColumn_Physical>
				</c:if>
				<c:if test="${additionalValue.name == 'DATA_TYPE'}">
					<dataType><wcf:cdata data="${attribute.primaryValue.value}"/></dataType>
				</c:if>
			</c:forEach>
		</object>
	</c:forEach>
</objects>
