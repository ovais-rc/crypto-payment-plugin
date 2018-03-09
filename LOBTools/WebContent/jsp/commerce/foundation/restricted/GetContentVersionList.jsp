<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<wcf:getData type="com.ibm.commerce.content.facade.datatypes.ContentVersionType[]" var="versions" expressionBuilder="getVersionDetailsByID" varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="objectId" value="${param.objectId}" />
	<wcf:param name="objectType" value="${param.objectType}" />
</wcf:getData>

<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
	<c:if test="${!(empty versions)}">
		<c:forEach var="version" items="${versions}">
			<object objectType="ContentVersion" >
				<c:set var="showVerb" value="${showVerb}" scope="request"/>
				<objectStoreId><wcf:cdata data="${version.contentVersionIdentifier.externalIdentifier.storeIdentifier.uniqueID}"/></objectStoreId>
				<versionNumber><wcf:cdata data="${version.contentVersionIdentifier.externalIdentifier.versionNumber}"/></versionNumber>
				<c:choose>
					<c:when test="${version.userData.userDataField.isBasedOnVersion}">	
						<isBasedOnVersion>true</isBasedOnVersion>
					</c:when>
					<c:otherwise>
						<isBasedOnVersion>false</isBasedOnVersion>
					</c:otherwise>
				</c:choose>
				<versionId><wcf:cdata data="${version.contentVersionIdentifier.uniqueID}"/></versionId>
				<versionName><wcf:cdata data="${version.versionName}"/></versionName>
				<user><wcf:cdata data="${version.user.uniqueID}"/></user>
				<comment><wcf:cdata data="${version.comment}"/></comment>
				<time><wcf:cdata data="${version.createTime}"/></time>
				<jsp:include page="/cmc/GetVersioned${version.contentVersionIdentifier.externalIdentifier.objectType}">
					<jsp:param name="versionId" value="${version.contentVersionIdentifier.uniqueID}" />
					<jsp:param name="UniqueID" value="${param.objectId}" />
					<jsp:param name="objectVersionId" value="${version.contentVersionIdentifier.uniqueID}" />
					<jsp:param name="objectVersionNumber" value="${version.contentVersionIdentifier.externalIdentifier.versionNumber}" />
				</jsp:include>
			</object>
		</c:forEach>
	</c:if>
</objects>
