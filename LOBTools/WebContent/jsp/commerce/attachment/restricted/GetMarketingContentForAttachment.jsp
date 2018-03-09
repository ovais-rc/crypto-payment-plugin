<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"
%><%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"
%>
<wcf:getData type="com.ibm.commerce.marketing.facade.datatypes.MarketingContentType[]"
	var="marketingContents"
	expressionBuilder="findMarketingContentByAttachmentId"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:param name="attachmentId" value="${param.attachmentId}"/>
	<wcf:contextData name="storeId" data="${param.storeId}"/>
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
</wcf:getData>

<c:set var="attachmentId" value = "${param.attachmentId}" />
<objects recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}">
<c:if test="${!(empty marketingContents)}">
	<c:forEach var="content" items="${marketingContents}">
	        <reference>
			    <c:set var="attachmentReference" value="${content.attachment}"/>
               	<c:set var="attachmentRefId" value="${attachmentReference.attachmentReferenceIdentifier.uniqueID}"/>

	          	<object objectType="${param.attachmentReferenceObjectType}">
	          	<attachmentRefId><wcf:cdata data="${attachmentRefId}"/></attachmentRefId>

	          	<parent>
			    	<c:set var="showVerb" value="${showVerb}" scope="request"/>
					<c:set var="businessObject" value="${content}" scope="request"/>
					 <jsp:directive.include file="../../marketing/restricted/SerializeMarketingContent.jspf"/>
			    </parent>
			</object>
		</reference>
	</c:forEach>

</c:if>
</objects>

