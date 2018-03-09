<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.MarketingSpotType"
	var="spot" expressionBuilder="findMarketingSpotDefaultContentByMarketingSpotId"
	varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="UniqueId" value="${param.uniqueId}" />
</wcf:getData>

<objects>
	<jsp:directive.include file="SerializeEMarketingSpotDefaultContent.jspf" />
	<jsp:directive.include file="SerializeEMarketingSpotDefaultTitleContent.jspf" />
</objects>