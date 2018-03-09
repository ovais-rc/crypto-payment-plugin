<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<c:choose>
	<c:when test="${(param.catalogViewRole == true) || (param.marketingViewRole == true) || (param.attachmentViewRole == true) || (param.pageComposerViewRole == true)}">
		<wcf:getData
			type="com.ibm.commerce.infrastructure.facade.datatypes.ConfigurationType"
			var="mktAttachmentLimitConfig"
			expressionBuilder="findByUniqueID">
			<wcf:param 
				name="uniqueId"
				value="com.ibm.commerce.foundation.marketingAttachmentLimit" />	
		</wcf:getData>
		<values>
		<c:forEach var="attribute" items="${mktAttachmentLimitConfig.configurationAttribute}">
			<c:if test="${attribute.primaryValue.name=='marketingAttachmentLimit'}">
				<attachmentLimitEnabled>${attribute.primaryValue.value}</attachmentLimitEnabled>
			</c:if>
		</c:forEach>
		</values>
	</c:when>
	<c:otherwise>
		<values/>
	</c:otherwise>
</c:choose>
