<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:choose>
	<c:when test="${param.lbsEnabled == 'true'}">

<wcf:getData type="com.ibm.commerce.location.facade.datatypes.PointOfInterestType[]"
             var="poiList" 
             expressionBuilder="findRegions" 
             varShowVerb="showVerb"
             recordSetStartNumber="${param.recordSetStartNumber}"
             recordSetReferenceId="${param.recordSetReferenceId}"
             maxItems="${param.maxItems}" >
    <wcf:param name="StoreId" value="${param.storeId}" />
</wcf:getData>


<objects     recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
             recordSetReferenceId="${showVerb.recordSetReferenceId}"
             recordSetStartNumber="${showVerb.recordSetStartNumber}"
             recordSetCount="${showVerb.recordSetCount}"
             recordSetTotal="${showVerb.recordSetTotal}" >

	<c:forEach var="poi" items="${poiList}">
		<c:set var="showVerb" value="${showVerb}" scope="request"/>
		<c:set var="businessObject" value="${poi}" scope="request"/>

        <jsp:directive.include file="SerializeLocationRegion.jspf" />
    </c:forEach>
    
</objects>

	</c:when>

	<c:otherwise>
		<objects/>
	</c:otherwise>
</c:choose>
