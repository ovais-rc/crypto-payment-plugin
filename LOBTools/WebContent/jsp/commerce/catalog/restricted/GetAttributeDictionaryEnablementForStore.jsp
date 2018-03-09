<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%--
	==========================================================================
	Call the get service for attribute dictionary to retrieve the
	attribute dictionary for the store currently selected.
	==========================================================================
--%>
<c:choose>
	<c:when test="${(param.catalogViewRole == true) || (param.marketingViewRole == true) || (param.promotionViewRole == true) || (param.attachmentViewRole == true) || (param.pricingViewRole == true)}">
		<wcf:getData type="com.ibm.commerce.catalog.facade.datatypes.AttributeDictionaryType"
			var="attributeDictionary"
			expressionBuilder="findAttributeDictionary"
			maxItems="1">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
		</wcf:getData>
		
		<values>
			<%--
				Determine if the attribute dictionary has been mass loaded
				for the current store.  If it has set 'attributeDictionaryEnabledForStore'
				to 'true'.
			--%>
			<c:choose>
				<c:when test="${!(empty attributeDictionary)}">
					<attributeDictionaryEnabledForStore>enabled</attributeDictionaryEnabledForStore>
				</c:when>
				<c:otherwise>
					<attributeDictionaryEnabledForStore>disabled</attributeDictionaryEnabledForStore>
				</c:otherwise>
			</c:choose>
			<attributeDictionaryId>${attributeDictionary.attributeDictionaryIdentifier.uniqueID}</attributeDictionaryId>
		</values>
	</c:when>
	<c:otherwise>
		<values/>
	</c:otherwise>
</c:choose>
