<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<%
   //If the error was due to missing LTPAToken, which is the normal case if SSO is not enabled,
   //then simply return an empty "values" element. If it's due to another problem, then
   //return an "exception" element inside an "errors" element.
 %>

<c:forEach var="clientError" items="${requestScope['com.ibm.commerce.clientErrors']}">
	<c:if test="${clientError.errorCode == '2160'}">
		<values>
		</values>
		<c:set var="MissingLTPAToken" value="true" />
	</c:if>
</c:forEach>

<c:if test="${!MissingLTPAToken}">
	<errors>
	 <c:forEach var="clientError" items="${requestScope['com.ibm.commerce.clientErrors']}">
	    <exception code="${clientError.errorCode}"><wcf:cdata data="${clientError.message}"/></exception>
	 </c:forEach>
	</errors>
</c:if>





