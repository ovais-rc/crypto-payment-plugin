<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@	page session="false"%><%@ 
	page pageEncoding="UTF-8"%><%@
	taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@
	taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %><%@
	taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<c:set var="callback" value="${param.callback}"/>
<c:set var="jsonp" value="${!empty callback && !fn:contains(callback, '(') && !fn:contains(callback, ')') && !fn:contains(callback, '=') && !fn:contains(callback, ';')}"/>
<c:choose>
<c:when test="${jsonp}"><c:out value="${callback}"/>(</c:when>
<c:otherwise><% out.print("/*"); %></c:otherwise>
</c:choose>
<wcf:json object="${RequestProperties}"/>
<c:choose>
<c:when test="${jsonp}">);</c:when>
<c:otherwise><% out.print("*/"); %></c:otherwise>
</c:choose>
