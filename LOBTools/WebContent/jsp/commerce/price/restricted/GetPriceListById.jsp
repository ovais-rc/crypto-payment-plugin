<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:if test="${param.priceListId != null and param.priceListId != ''}">
	<c:set var="priceListID" value="${param.priceListId}"/>
	<objects>
</c:if>

<wcf:getData
	type="com.ibm.commerce.price.facade.datatypes.PriceListType[]"
	var="priceLists" expressionBuilder="getPriceListsByID"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="priceListId" value="${priceListID}" />
</wcf:getData>


<c:if test="${!(empty priceLists)}">
	<c:forEach var="priceList" items="${priceLists}">
		<c:set var="objectType" value="RefPriceList" />
		<c:set var="objStoreId" value="${priceList.priceListIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:if test="${objStoreId == '0'}">
			<c:set var="objStoreId" value="${param.storeId}"/>
		</c:if>
		<c:if test="${(param.storeId) != objStoreId}">
			<c:set var="objectType" value="RefInheritedPriceList" />
		</c:if>
		<object objectType="${objectType}">
			<priceListId>${priceList.priceListIdentifier.uniqueID}</priceListId>
			<jsp:directive.include file="serialize/SerializePriceList.jspf" />
		</object>
	</c:forEach>
</c:if> 


<c:if test="${param.priceListId != null and param.priceListId != ''}">
	</objects>
</c:if>

