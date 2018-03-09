<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<errors>
 <c:forEach var="clientError" items="${requestScope['com.ibm.commerce.clientErrors']}">
    <validationError propertyName="${clientError.clientProperty}"><wcf:cdata data="${clientError.message}"/></validationError>
 </c:forEach>
</errors>

