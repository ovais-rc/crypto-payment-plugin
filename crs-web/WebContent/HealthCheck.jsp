<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page language="java" contentType="application/json"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://commerce.ibm.com/foundation-fep/stores" prefix="wcst" %>

<c:set var="storeId" value="${CommandContext.storeId}" scope="request"/>

<wcst:alias name="ModuleConfig" var="configInst" />
<wcst:mapper source="configInst" method="getWebModule" var="moduleConfig" />
<wcst:mapper source="configInst" method="getValue" var="propertyConfig"/>
<c:set var="restServerName" value="${propertyConfig['WebServer/HostName']}" scope="request"/>

<c:if test="${empty REST_CONFIG}">
    <jsp:useBean id="REST_CONFIG" class="java.util.HashMap" scope="request"/>
    <c:if test="${empty secureRestConfig}">
        <jsp:useBean id="secureRestConfig" class="java.util.HashMap" scope="request"/>
        <c:set target="${secureRestConfig}" property="schema" value="https"/>
        <c:set target="${secureRestConfig}" property="host" value="${restServerName}"/>
        <c:set target="${secureRestConfig}" property="port" value="${moduleConfig['Rest'].SSLPort}"/>
        <c:set target="${secureRestConfig}" property="contextPath" value="${moduleConfig['Rest'].contextPath}"/>
    </c:if>
    <c:set target="${REST_CONFIG}" property="${storeId}" value="${secureRestConfig}"/>
</c:if>

<wcst:alias name="BackendConfig" var="backendConfig" />
<c:if test="${empty searchHostNamePath}">
    <c:set var="hostname" value="${backendConfig.searchServerHostname}"/>
    <c:set var="searchHostNamePath" value="https://${hostname}:${backendConfig.searchServerPreviewSecuredPort}"/>
    <c:set var="searchContextPath" value="${backendConfig.searchServerContextPath}"/>
</c:if>

<%-- Transaction Server Health Status --%>
<c:catch var ="catchTSHealth">
    <wcf:rest var="getTSHealth" url="${secureRestConfig.schema }://${secureRestConfig.host }:${secureRestConfig.port }${secureRestConfig.contextPath }/health/ping" connectTimeout="60000" readTimeout="60000"/>
</c:catch>

<%-- Search Server Health Status --%>
<c:catch var ="catchSearchHealth">
    <wcf:rest var="getSearchHealth" url="${searchHostNamePath}/search/admin/resources/health/ping" />
</c:catch>

<c:if test="${!empty getTSHealth.responseCode || !empty getSearchHealth.responseCode || !empty catchTSHealth || !empty catchSearchHealth}" >
    <%
        // Set error code.
        response.setStatus(500);
    %>

    {
        "errors":[
        <c:if test="${!empty getTSHealth.responseCode}" >
            <c:forEach var="tsError" items="${getTSHealth.errors}" varStatus="status">
                ${tsError}
                <c:if test="${!status.last}">,</c:if>
            </c:forEach>
        </c:if>
        <c:if test="${!empty catchTSHealth}" >
            {
                "destination": "ts",
                "errorMessage": "Could not reach Transaction Server from Store Server.",
                "source": "crs",
                "checkName": "deep"
            }
        </c:if>

        <c:if test="${(!empty getTSHealth.responseCode || !empty catchTSHealth) && (!empty getSearchHealth.responseCode || !empty catchSearchHealth)}" >
            ,
        </c:if>
        <c:if test="${!empty getSearchHealth.responseCode || !empty catchSearchHealth}" >
            {
                "destination": "search",
                "errorMessage": "Could not reach Search Server from Store Server.",
                "source": "crs",
                "checkName": "ping"
            }
        </c:if>
        ]
    }
</c:if>