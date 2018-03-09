<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="readonly" value="true" />
<c:set var="deletable" value="false" />
<c:if test="${promotions[0].status =='Inactive'}">
	<c:set var="deletable" value="true" />
	<c:if test="${promotions[0].controlParameter == 'CMC'}">
		<c:set var="readonly" value="false" />
	</c:if>
</c:if>
<object readonly="${readonly}" deletable="${deletable}">
	<status>${promotions[0].status}</status>
	<c:set var="populationStatus" value="${promotions[0].promotionCodeSpecification.promotionCodePopulationStatus}"/>
	<c:if test="${populationStatus != null && populationStatus != ''}">
		<promotionCodePopulationStatus>${populationStatus}</promotionCodePopulationStatus>		
	</c:if>	
</object>

