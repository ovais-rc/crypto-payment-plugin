<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<objects>
        <object objectType="StoreSEO">
                <wcf:getData type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
                        var="seoConfig" expressionBuilder="findByUniqueID">
                        <wcf:contextData name="storeId" data="${param.storeId}" />
                        <wcf:param name="uniqueId" value="com.ibm.commerce.foundation.seo" />
                </wcf:getData>
                <c:forEach var="attribute" items="${seoConfig.configurationAttribute}">
                        <${attribute.primaryValue.name}><wcf:cdata data="${attribute.primaryValue.value}"/></${attribute.primaryValue.name}>
                        <c:forEach var="additionalValue" items="${attribute.additionalValue}">
                                <${additionalValue.name}><wcf:cdata data="${additionalValue.value}"/></${additionalValue.name}>
                        </c:forEach>
                </c:forEach>
        </object>
</objects>
