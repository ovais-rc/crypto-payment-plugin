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
	type="com.ibm.commerce.installment.facade.datatypes.InstallmentRuleType"
	var="installmentRule" expressionBuilder="getInstallmentRuleDetailsById" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueID" value="${param.uniqueId}" />
</wcf:getData>
<c:set var="showVerb" value="${showVerb}" scope="request"/>
<c:set var="businessObject" value="${installmentRule}" scope="request"/>
<jsp:directive.include file="SerializeInstallmentRule.jspf" />


