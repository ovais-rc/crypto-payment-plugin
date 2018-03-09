<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.pagelayout.facade.datatypes.LayoutType[]"
	var="pagelayouts" expressionBuilder="getAllLayouts"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="accessProfile" value="IBM_Admin_Details"/>
	<wcf:param name="isTemplate" value="false"/>
</wcf:getData>

<c:set var="showVerb1" value="${showVerb}" scope="request"/>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty pagelayouts)}">

	<c:forEach var="pagelayout" items="${pagelayouts}">
		<%-- Default case: assume everything is one store --%>
		<c:set var="inherited" value="" />   
		<c:set var="layoutOwningStoreId" value="${pagelayout.layoutIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
		<c:if test="${param.storeId != layoutOwningStoreId}">
		<%-- esite case--%>
			<c:set var="inherited" value="Inherited" />
		</c:if> 
		<jsp:directive.include file="serialize/SerializePageLayout.jspf" />
	</c:forEach>
</c:if>
</objects>

