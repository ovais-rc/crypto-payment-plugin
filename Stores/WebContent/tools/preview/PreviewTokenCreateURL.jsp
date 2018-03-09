<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation-fep/stores" prefix="wcst" %>

<wcst:alias name="ConfigProperties" var="ConfigProperties" />
<wcst:mapper source="ConfigProperties" method="getWebModule" var="configWebModuleMap" />
<wcst:mapper source="ConfigProperties" method="getValue" var="configWebModuleProperties" />
<c:set var="acceleratorModuleName" value ="CommerceAccelerator"/>
<c:set var="acceleratorPort" value ="WebServer/ToolsPort"/>
<c:if test="${empty env_accelerator_port}">
	<c:set var="env_accelerator_port" value="${configWebModuleProperties[acceleratorPort]}"/>
</c:if>
<c:if test="${empty env_accelerator_contextPath}">
	<c:set var="env_accelerator_contextPath" value="${configWebModuleMap[acceleratorModuleName].contextPath}"/>
</c:if>
<c:if test="${empty env_accelerator_urlMappingPath}">
	<c:set var="env_accelerator_urlMappingPath" value="${configWebModuleMap[acceleratorModuleName].urlMappingPath}"/>
</c:if>

<wcst:alias name="StoreServer" var="isStoreServer" />

<c:choose>
	<c:when test="${isStoreServer == 'true' }">
		<c:url value="AjaxPreviewTokenCreate">
			<c:param name="storeId" value="${param.storeId}"/>
			<c:param name="krypto" value="${param.krypto}"/>
		</c:url>
	</c:when>
	<c:otherwise>
		<c:url value="https://${pageContext.request.serverName}:${env_accelerator_port}${env_accelerator_contextPath}${env_accelerator_urlMappingPath}/AjaxPreviewTokenCreate">
			<c:param name="storeId" value="${param.storeId}"/>
			<c:param name="krypto" value="${param.krypto}"/>
		</c:url>	
	</c:otherwise>
</c:choose>