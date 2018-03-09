<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.ActivityType"
	var="activity" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="UniqueID" value="${param.activityId}" />
</wcf:getData>

<c:set var="inherited" value=""/>
<c:if test="${activity.activityIdentifier.externalIdentifier.storeIdentifier.uniqueID != param.storeId}">
	<c:set var="inherited" value="Inherited"/>
</c:if>

<objects>
	<c:if test="${!empty activity.campaignIdentifier.uniqueID}">
		<c:set var="campaignId" value="${activity.campaignIdentifier.uniqueID}" scope="request" />
		<reference>
			<object objectType="Child${inherited}Activity">
				<childActivityId>${activity.activityIdentifier.uniqueID}</childActivityId>
				<parent>
					<jsp:directive.include file="GetCampaignsById.jspf" />
				</parent>
			</object>
		</reference>
	</c:if>
</objects>

