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
<%@page contentType="application/json;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
{
	"errors": [
		<c:forEach var="exception" items="${requestScope['com.ibm.commerce.exceptions']}" varStatus="count">
		{<c:if test="${!(empty exception.code)}">
			"errorKey": "${exception.code}",</c:if>
			"errorMessage": "${exception.message}"
		}<c:if test="${!count.last}">,</c:if></c:forEach>
	]
}