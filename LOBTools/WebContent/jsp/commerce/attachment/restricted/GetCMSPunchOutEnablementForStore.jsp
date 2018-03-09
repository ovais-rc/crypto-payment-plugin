<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013, 2017 All Rights Reserved.

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
	flag used to determine if cms punch-out is enabled or not.
	==========================================================================
--%>
<wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType"
	var="onlineStore"
	varShowVerb="showVerb"
	expressionBuilder="findByUniqueID">
	<wcf:param name="usage" value="IBM_ManageAttachmentTool"/>
	<wcf:param name="storeId" value="${param.storeId}"/>
	<wcf:param name="accessProfile" value="IBM_Admin_All"/>
</wcf:getData>

<%--
	Determine if the cms punch-out enablement feature has been enabled for this store.
	If it has then set 'cmsPunchOutEnabled' to 'true'.
--%>
<c:set var="cmsPunchOutEnabled" value="false" />
<c:set var="externalContentEnablementMode" value="DISABLED" />
<c:set var="externalContentTenantId" value="" />
<c:set var="externalContentHostname" value="" />
<c:if test="${!(empty onlineStore) && !(empty onlineStore.userData)}">
	<c:forEach var="userDataField" items="${onlineStore.userData.userDataField}">
		<c:if test="${userDataField.typedKey == 'wc.cmsPunchOut.enabled'}">
			<c:set var="cmsPunchOutEnabled" value="${userDataField.typedValue}" />
		</c:if>
		<c:if test="${userDataField.typedKey == 'externalContentEnablementMode'}">
			<c:set var="externalContentEnablementMode" value="${userDataField.typedValue}" />
		</c:if>
		<c:if test="${userDataField.typedKey == 'wc.externalContent.tenant-id'}">
			<c:set var="externalContentTenantId" value="${userDataField.typedValue}" />
		</c:if>
		<c:if test="${userDataField.typedKey == 'wc.externalContent.hostName'}">
			<c:set var="externalContentHostname" value="${userDataField.typedValue}" />
		</c:if>
	</c:forEach>
</c:if>
<values>
<%-- cmsPunchOut and ExternalContent cannot be enabled at same time --%>
	<c:choose>
		<c:when test="${externalContentEnablementMode ne 'DISABLED' }">
			<cmsPunchOutEnabled>false</cmsPunchOutEnabled>
			<externalContentEnablementModeForStore>${externalContentEnablementMode}</externalContentEnablementModeForStore>
		</c:when>
		<c:otherwise>
			<cmsPunchOutEnabled>${cmsPunchOutEnabled}</cmsPunchOutEnabled>
			<externalContentEnablementModeForStore>${externalContentEnablementMode}</externalContentEnablementModeForStore>
		</c:otherwise>
	</c:choose>
	<externalContentTenantId>${externalContentTenantId}</externalContentTenantId>
	<externalContentHostname>${externalContentHostname}</externalContentHostname>
</values>
