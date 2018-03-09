<?xml version="1.0" encoding="UTF-8"?>

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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<object>
	<objectStoreId>${param.storeId}</objectStoreId>
	<c:if test="${param.attrUsage == 'Defining' }">
		<attrId>${param.attrDictAttrId}</attrId>
	</c:if>
	<c:if test="${param.attrUsage == 'Descriptive' }">
		<referenceAttributeDictionaryAttributeId>${param.attrDictAttrId}_${catalogEntries[0].catalogEntryAttributes.attributes[0].value.identifier}</referenceAttributeDictionaryAttributeId>
		<attrValId>${catalogEntries[0].catalogEntryAttributes.attributes[0].value.identifier}</attrValId>
		<c:if test="${param.type == 'allowed' }">
			<xdata_existingAttrValId>${catalogEntries[0].catalogEntryAttributes.attributes[0].value.identifier}</xdata_existingAttrValId>
		</c:if>
		<attrId>${param.attrDictAttrId}</attrId>
		<attrDataType><c:out value="${param.attrDataType}"/></attrDataType>
	</c:if>
</object>

