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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<%--
	==========================================================================
	Call the get service for online store to retrieve the
	flag used to determine if catalog entry description override
	is enabled or not.
	==========================================================================
--%>
<c:choose>
	<c:when test="${(param.catalogViewRole == true) || (param.marketingViewRole == true) || (param.promotionViewRole == true) || (param.attachmentViewRole == true) || (param.pricingViewRole == true)}">		
		<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
			var="onlineStore"
			varShowVerb="showVerb"
			expressionBuilder="findByUniqueID">
			<wcf:param name="usage" value="IBM_ViewCatalogTool"/>
			<wcf:param name="storeId" value="${param.storeId}"/>
			<wcf:param name="accessProfile" value="IBM_Admin_All"/>
		</wcf:getData>
		
		<%--
			Determine if the description override feature has been enabled for this store.
			If it has then set 'descriptionOverrideEnabledForStore' to 'enabled'.
		--%>
		<c:set var="enabled" value="false" />
		<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
			<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
				<c:if test="${userDataField.typedKey == 'isCatalogOverrideEnabled'}">
					<c:if test="${userDataField.typedValue == 1}">
						<c:set var="enabled" value="true" />
					</c:if>
				</c:if>
			</c:forEach>
		</c:if>
		<values>
			<descriptionOverrideEnabledForStore>${enabled}</descriptionOverrideEnabledForStore>
		</values>
	</c:when>
	<c:otherwise>
		<values/>
	</c:otherwise>
</c:choose>
