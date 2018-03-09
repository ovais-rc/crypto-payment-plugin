<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 1997, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
response.setContentType("text/html;charset=UTF-8");
%>

<fmt:setLocale value="${CommandContext.locale}" />
<fmt:setBundle basename="com.ibm.commerce.stores.widget.properties.widgettext" var="storeWidgetText"/>

<c:set var="logonId" value="${WCParam.logonId}" />
<c:set var="logonPassword" value="${WCParam.logonPassword}" />

<c:choose>
    <c:when test="${empty logonId || empty logonPassword}" >
        <fmt:message bundle="${storeWidgetText}" key="PasswordResetNotification.ErrorMessage1"/>
    </c:when>
    <c:otherwise>
        <fmt:message bundle="${storeWidgetText}" key="PasswordResetNotification.MessagePart1"/> ${logonId} <fmt:message bundle="${storeWidgetText}" key="PasswordResetNotification.MessagePart2"/> ${logonPassword}
    </c:otherwise>
</c:choose>