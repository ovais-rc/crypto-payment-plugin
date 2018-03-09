<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2013 All Rights Reserved.

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
	var="pagelayouts" expressionBuilder="getLayoutsByUniqueID"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="accessProfile" value="IBM_Admin_Details"/>
	<wcf:param name="layoutId" value="${param.pageLayoutId }"/>
</wcf:getData>

<c:set var="showVerb1" value="${showVerb}" scope="request"/>

<c:forEach var="pagelayout" items="${pagelayouts}">	
	<c:if test="${pagelayout != null }">
			<%-- Default case: assume everything is one store --%>
			<c:set var="inherited" value="" />   
	        <c:set var="layoutOwningStoreId" value="${pagelayout.layoutIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
			 <c:if test="${param.storeId != layoutOwningStoreId}">
					<%-- esite case--%>
				<c:set var="inherited" value="Inherited" />
			</c:if> 
		<jsp:directive.include file="serialize/SerializePageLayout.jspf" />
	</c:if>
</c:forEach>

