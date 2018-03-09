<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.member.facade.datatypes.OrganizationType[]"
	var="buyerOrganizations"
	expressionBuilder="findByUniqueID"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<c:forTokens var="value" items="${uniqueIDs}" delims=",">
		<wcf:param name="organizationId" value="${value}" />
	</c:forTokens>
</wcf:getData>

<c:forEach var="buyerOrganization" items="${buyerOrganizations}">
    <c:set var="showVerb" value="${showVerb}" scope="request"/>
    <c:set var="businessObject" value="${group}" scope="request"/>
	
	<object objectType="ChildBuyerOrganization">
		<childBuyerOrganizationId>${buyerOrganization.organizationIdentifier.uniqueID}</childBuyerOrganizationId>
		<jsp:directive.include file="serialize/SerializeBuyerOrganization.jspf" />
	</object>
    
</c:forEach>
