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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.marketing.facade.datatypes.MarketingContentType[]"
	var="marketingContents" expressionBuilder="findByUniqueIDs" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}"/>
	<c:forTokens var="value" items="${param.uniqueIDs}" delims=",">
		<wcf:param name="UniqueID" value="${value}" />
	</c:forTokens>
</wcf:getData>

<c:choose>
	<c:when test="${!empty marketingContents}">
		<c:forEach var="content" items="${marketingContents}">
			<c:set var="showVerb" value="${showVerb}" scope="request"/>
			<c:set var="businessObject" value="${content}" scope="request"/>
			<jsp:directive.include file="SerializeMarketingContent.jspf" />
		</c:forEach>
	</c:when>
	<c:otherwise>
		<object/>
	</c:otherwise>
</c:choose>