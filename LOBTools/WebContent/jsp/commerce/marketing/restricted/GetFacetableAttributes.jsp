<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:set var="searchText" value="*" />

<wcf:getData
	type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryAttributeType[]"
	var="attributes" expressionBuilder="getFacetablePredefinedAttributeDictionaryAttributeByIdentifierOrName" varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="searchText" value="${searchText}" />
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:forEach var="attribute" items="${attributes}">
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${attribute}" scope="request"/>
		<%-- Test if attribute is inherited --%>
		<c:set var="inheritedAttribute" value="" />
		<c:if test="${attribute.attributeIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
			<c:set var="inheritedAttribute" value="Inherited" />
		</c:if>
		<%--Set the attribute type --%>
		<c:set var="attributeType" value="AssignedValues" />
		<c:if test="${!(empty attribute.attributeType)}">
			<c:if test="${attribute.attributeType != attributeType}">
			    <c:set var="attributeType" value="${attribute.attributeType}" />
					<jsp:directive.include file="/jsp/commerce/catalog/restricted/serialize/SerializeAttributeDictionaryAttribute.jspf"/>
			</c:if>
		</c:if>
</c:forEach>
</objects>