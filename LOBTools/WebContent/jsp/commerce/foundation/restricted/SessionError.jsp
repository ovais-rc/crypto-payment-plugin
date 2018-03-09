<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:forEach var="exception" items="${requestScope['com.ibm.commerce.exceptions']}" begin="0" end="0">
	<c:set var="errorCode" value="${exception.code}"/>
</c:forEach>

<html>
<head>
<script type="text/javascript">
<!--
	var errorCode = "<c:out value="${errorCode}"/>";
	window.opener.doRelogon(errorCode);
	window.close();
// -->
</script>
</head>
<body></body>
</html>