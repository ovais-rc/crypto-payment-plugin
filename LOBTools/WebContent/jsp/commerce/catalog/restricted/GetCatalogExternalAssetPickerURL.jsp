<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="onlineStore"
	expressionBuilder="findByUniqueID">
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="accessProfile" value="IBM_Admin_All"/>
</wcf:getData>
	<c:set var="pickerURL" value="" />
	<c:set var="tenantId"  value="" />
	<object>
		<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
			<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
				<c:if test="${userDataField.typedKey == 'wc.externalContent.UIContextRoot'}">
					<externalAssetHost><wcf:cdata data="${userDataField.typedValue}"/></externalAssetHost>
				</c:if>
				<c:if test="${userDataField.typedKey == 'wc.externalContent.pickerURL'}">
					<c:set var="pickerURL" value="${userDataField.typedValue}"/>
				</c:if>
				<c:if test="${userDataField.typedKey == 'wc.externalContent.tenant-id'}">
					<c:set var="tenantId" value="${userDataField.typedValue}"/>
				</c:if>
			</c:forEach>
			
			<%
				boolean ibmIdEnabled = com.ibm.commerce.util.SecurityHelper.isIBMidEnabled();	
			%>
			<c:set var="ibmIdEnabled" value ="<%=ibmIdEnabled%>"/>
			<c:choose>
					<c:when test="${ !(empty ibmIdEnabled) && (ibmIdEnabled == 'false') }">
						<externalAssetPickerUrl><wcf:cdata data="${pickerURL}?lang=${param.locale}&fq=classification:(asset)"/></externalAssetPickerUrl>
					</c:when>
					
					<c:otherwise>
						<externalAssetPickerUrl><wcf:cdata data="${pickerURL}?extAuth=true&tenantId=${tenantId}&lang=${param.locale}&fq=classification:(asset)"/></externalAssetPickerUrl>
					</c:otherwise>
			</c:choose>
			
			</c:if>
    </object>



