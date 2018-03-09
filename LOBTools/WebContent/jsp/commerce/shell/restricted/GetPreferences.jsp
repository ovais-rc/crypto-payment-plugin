<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ page import="com.ibm.commerce.member.facade.client.MemberFacadeClient" %>
<%@ page import="com.ibm.commerce.member.facade.datatypes.PersonType" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<wcf:getData var="person" type="com.ibm.commerce.member.facade.datatypes.PersonType" expressionBuilder="findCurrentPerson">
	<wcf:param name="accessProfile" value="IBM_All" />
</wcf:getData>

<values>
	<c:forEach items="${person.contextAttribute}" var="contextAttribute">
		<${contextAttribute.name}>
			<c:forEach items="${contextAttribute.attributeValue}" var="attributeValue">
				<c:if test="${attributeValue.value[0] != null}">
					<attributeValue>${attributeValue.value[0]}</attributeValue>
				</c:if>
			</c:forEach>
		</${contextAttribute.name}>
	</c:forEach>
	<preferredLanguage>
		<attributeValue>${person.personalProfile.preferredLanguage}</attributeValue>
	</preferredLanguage>
</values>
