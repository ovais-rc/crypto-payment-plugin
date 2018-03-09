<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@	page session="false"%><%@ 
	page pageEncoding="UTF-8"%><%@
	taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %><%@
	taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %><%@ 
	taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@
	taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<wcbase:useBean id="errorBean" classname="com.ibm.commerce.beans.ErrorDataBean"/>

<%--
  **
  * Try to retrieve the store error message otherwise default to return the server side error message.
  **
--%>
<c:catch>
	<wcbase:useBean id="storeBean" classname="com.ibm.commerce.common.beans.StoreDataBean" scope="request"/>
	<c:set var="storeDirectory" value="${storeBean.jspPath}"/>
	
	<%
	Integer[] relatedStoreIds = storeBean.getStorePath("com.ibm.commerce.propertyFiles");
	if (relatedStoreIds != null && relatedStoreIds.length >= 2) {
		request.setAttribute("relatedStoreId", relatedStoreIds[1].toString());
	}
	%>
	<c:if test="${!empty relatedStoreId}">
		<wcbase:useBean id="relatedStoreBean" classname="com.ibm.commerce.common.beans.StoreDataBean">
			<c:set target="${relatedStoreBean}" property="storeId" value="${relatedStoreId}"/>
		</wcbase:useBean>
		<c:set var="storeDirectory" value="${relatedStoreBean.jspPath}"/>
	</c:if>
	
	<wcbase:useBean id="storeErrorBean" classname="com.ibm.commerce.common.beans.StoreErrorDataBean">
		<c:set target="${storeErrorBean}" property="resourceBundleName" value="${storeDirectory}/storeErrorMessages"/>
	</wcbase:useBean>
	<c:set var="errorMessage" value="${storeErrorBean.message}"/>
</c:catch>
<c:if test="${empty errorMessage}">
	<c:set var="errorMessage" value="${errorBean.message}"/>
</c:if>
	
<c:set var="callback" value="${param.callback}"/>
<c:set var="jsonp" value="${!empty callback && !fn:contains(callback, '(') && !fn:contains(callback, ')') && !fn:contains(callback, '=') && !fn:contains(callback, ';')}"/>
<c:choose>
<c:when test="${jsonp}"><c:out value="${callback}"/>(</c:when>
<c:otherwise><% out.print("/*"); %></c:otherwise>
</c:choose>
{
	"errorCode": <wcf:json object="${errorBean.errorCode}"/>,
	"errorMessage": <wcf:json object="${errorMessage}"/>,
	"errorMessageKey": <wcf:json object="${errorBean.messageKey}"/>,
	"errorMessageParam": <wcf:json object="${errorBean.messageParam}"/>,
	"correctiveActionMessage": <wcf:json object="${errorBean.correctiveActionMessage}"/>,
	"correlationIdentifier": <wcf:json object="${errorBean.correlationIdentifier}"/>,
	"exceptionData": <wcf:json object="${errorBean.exceptionData}"/>,
	"exceptionType": <wcf:json object="${errorBean.exceptionType}"/>,
	"originatingCommand": <wcf:json object="${errorBean.originatingCommand}"/>,
	"systemMessage": <wcf:json object="${errorBean.systemMessage}"/>
}
<c:choose>
<c:when test="${jsonp}">);</c:when>
<c:otherwise><% out.print("*/"); %></c:otherwise>
</c:choose>
