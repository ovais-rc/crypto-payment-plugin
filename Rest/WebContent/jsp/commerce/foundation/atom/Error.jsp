<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%-- Include common environment. --%>
<%@ include file="../../foundation/atom/FeedEnvironment.jspf"%>

<feed xmlns="http://www.w3.org/2005/Atom" xmlns:ns2="http://a9.com/-/spec/opensearch/1.1/" xmlns:ns3="http://www.w3.org/1999/xhtml">
	<author></author>
	<updated>${currentDate}</updated>
	<id>feed:id:ERROR</id>
	<title type="text">ERROR</title>
	<errors>
	<c:forEach items="${errors}" var="errorMap">
		<errorCode>${errorMap['errorCode']}</errorCode>
		<errorKey>${errorMap['errorKey']}</errorKey>
		<errorMessage>${errorMap['errorMessage']}</errorMessage>
		<errorParameters>${errorMap['errorParameters']}</errorParameters>
	</c:forEach>
	</errors>
</feed>