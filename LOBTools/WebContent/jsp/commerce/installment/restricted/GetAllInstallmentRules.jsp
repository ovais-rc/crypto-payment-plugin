<?xml version="1.0" encoding="UTF-8"?>

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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<wcf:getData
	type="com.ibm.commerce.installment.facade.datatypes.InstallmentRuleType[]"
	var="installmentRules" expressionBuilder="getAllInstallmentRules"
	varShowVerb="showVerb"
	recordSetStartNumber="${param.recordSetStartNumber}"
	recordSetReferenceId="${param.recordSetReferenceId}"
	maxItems="${param.maxItems}">
	<wcf:contextData name="storeId" data='${param.storeId}' />
	<wcf:param name="dataLanguageIds" value="${param.dataLanguageIds}" />
	<wcf:param name="accessProfile" value="IBM_Admin_All" />
</wcf:getData>
<objects
	recordSetCompleteIndicator="${showVerb.recordSetCompleteIndicator}"
	recordSetReferenceId="${showVerb.recordSetReferenceId}"
	recordSetStartNumber="${showVerb.recordSetStartNumber}"
	recordSetCount="${showVerb.recordSetCount}"
	recordSetTotal="${showVerb.recordSetTotal}"> 
	<c:forEach var="installmentRule" items="${installmentRules}">
		<c:set var="showVerb" value="${showVerb}" scope="request" />
		<c:set var="businessObject" value="${installmentRule}" scope="request" />
		<jsp:directive.include file="SerializeInstallmentRule.jspf" />
	</c:forEach> 
</objects>
