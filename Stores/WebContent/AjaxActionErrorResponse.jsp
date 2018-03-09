<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@	page session="false"%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/base" prefix="wcbase" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation-fep/stores" prefix="wcst" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<wcst:aliasBean id="errorBean" name="ErrorDataBean" scope="request"/>
<%--
  **
  * Try to retrieve the store error message otherwise default to return the server side error message.
  **
--%>
<c:catch>
	<c:set var="langId" value="${CommandContext.languageId}" />
	<c:set var="storeId" value="${CommandContext.storeId}" />
	<wcf:rest var="sdb" url="store/{storeId}/databean" cached="true">
		<wcf:var name="storeId" value="${storeId}" encode="true"/>
		<wcf:param name="profileName" value="IBM_Store_Details" encode="true"/>
		<wcf:param name="langId" value="${langId}" encode="true"/>
		<wcf:param name="jspStoreDir" value="${jspStoreDir}" encode="true" />
		<wcf:param name="storeRelationshipTypeName" value="com.ibm.commerce.propertyFiles" encode="true" />
	</wcf:rest>
	
	<c:set var="storeDirectory" value="${sdb.jspPath}"/>
	<c:set var="relatedStoreIds" value="${sdb.relatedStores}"/>
	
	<c:if test="${!empty relatedStoreIds && fn:length(relatedStoreIds)>=2}">
		<c:set var="relatedStoreId" value="${relatedStoreIds[1]}"/>
	</c:if>
	
	<c:if test="${!empty relatedStoreId}">
		<wcf:rest var="relatedStoreBean" url="store/{storeId}/databean" cached="true">
			<wcf:var name="storeId" value="${relatedStoreId}" encode="true"/>
			<wcf:param name="profileName" value="IBM_Store_Details" encode="true"/>
			<wcf:param name="langId" value="${langId}" encode="true"/>
		</wcf:rest>
		<c:if test="${!empty relatedStoreBean.jspPath}">
			<c:set var="storeDirectory" value="${relatedStoreBean.jspPath}"/>
		</c:if>
	</c:if>
	
	<c:if test="${!empty storeDirectory}">
	    <wcst:aliasBean id="storeErrorBean" name="StoreErrorDataBean">
	    	<c:set target="${storeErrorBean}" property="resourceBundleName" value="${storeDirectory}/storeErrorMessages"/>
	    </wcst:aliasBean>
	    <c:set var="errorMessage" value="${storeErrorBean.message}"/>
	</c:if>
</c:catch>
<c:if test="${empty errorMessage}">
	<c:set var="errorMessage" value="${errorBean.message}"/>
</c:if>
	
/*
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
*/
