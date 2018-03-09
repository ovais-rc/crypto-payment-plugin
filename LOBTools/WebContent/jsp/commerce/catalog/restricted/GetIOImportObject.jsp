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
	<c:when test="${(param.catalogFileUploadRole == null) || (param.catalogFileUploadRole=='false')}">
		<%-- no catalogFileUploadRole is specified --%>
		<objects/>
	</c:when>
	<c:otherwise>
		<wcf:getData type="com.ibm.commerce.content.facade.datatypes.FileUploadJobType[]"
			var="ioImports"
			expressionBuilder="getAllCatalogImportJobs"
			varShowVerb="showVerb"
			recordSetStartNumber="${param.recordSetStartNumber}"
			recordSetReferenceId="${param.recordSetReferenceId}"
			maxItems="${param.maxItems}">
			<wcf:contextData name="storeId" data="${param.storeId}"/>
			<wcf:param name="uploadType" value="IntelligentOfferFlatFileImport"/>
		</wcf:getData>
		
		<objects>
		<c:if test="${!empty ioImports}">
			<object objectType="IntelligentOfferImportsTop">
				<ioImportsTopId>1</ioImportsTopId>
			</object>
		</c:if>
		</objects>
	</c:otherwise>
</c:choose>