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
	var="rule" expressionBuilder="getInstallmentRuleDetailsById" varShowVerb="showVerb">
	<wcf:contextData name="storeId" data="${param.storeId}" />
	<wcf:param name="uniqueID" value="${param.uniqueId}" />
</wcf:getData>
<c:set var="showVerb" value="${showVerb}" scope="request"/>
<c:set var="businessObject" value="${rule}" scope="request"/>

<objects>

<c:forEach var="category" items="${rule.catalogGroupAssociation}">
	<c:choose>
		<c:when test="${!empty category.catalogGroupIdentifier.uniqueID}">
			<c:set var="uniqueIDs" value="${category.catalogGroupIdentifier.uniqueID}"/>
			<jsp:directive.include file="GetCategoriesById.jsp" />
		</c:when>
		<c:when test="${category.associationType.name == 'Inclusion'}">
			<object objectType="InclusionChildCatalogGroup">
				<childCatalogGroupId>${category.installmentRuleCatalogGroupAssociationIdentifier.uniqueID}</childCatalogGroupId>
				<associationType><wcf:cdata data="${category.associationType}"/></associationType>
			</object>
		</c:when>
	</c:choose>
</c:forEach>

<c:forEach var="product" items="${rule.catalogEntryAssociation}">
	<c:choose>
		<c:when test="${!empty product.catalogEntryIdentifier.uniqueID}">
			<c:set var="uniqueIDs" value="${product.catalogEntryIdentifier.uniqueID}"/>
			<jsp:directive.include file="GetProductsById.jsp" />
		</c:when>
		<c:when test="${product.associationType.name == 'Inclusion'}">
			<object objectType="AllInclusionChildCatentry">
				<childCatentryId><wcf:cdata data="${product.installmentRuleCatalogEntryAssociationIdentifier.uniqueID}"/></childCatentryId>
				<associationType><wcf:cdata data="${product.associationType}"/></associationType>
			</object>
		</c:when>
	</c:choose>
</c:forEach>

<c:forEach var="paymentMethod" items="${rule.paymentMethodAssociation}">
	<c:choose>
		<c:when test="${empty paymentMethod.paymentMethodName}">
			<object objectType="AllPaymentMethod">
				<paymentId><wcf:cdata data="${paymentMethod.installmentRulePaymentMethodAssociationIdentifier.uniqueID}"/></paymentId>
			</object>
		</c:when>
		<c:when test="${paymentMethod.associationType.name == 'Inclusion'}">
			<object objectType="PaymentMethod">
				<paymentId><wcf:cdata data="${paymentMethod.installmentRulePaymentMethodAssociationIdentifier.uniqueID}"/></paymentId>
				<payMethod><wcf:cdata data="${paymentMethod.paymentMethodName}"/></payMethod>
			</object>
		</c:when>
	</c:choose>
</c:forEach>

<c:forEach var="cond" items="${rule.condition}">
	<c:forEach var="userDataField" items="${cond.userData.userDataField}">
		<c:if test="${userDataField.typedKey == 'manufacturerName'}">
			<object objectType="ManufacturerCondition">
				<conditionId><wcf:cdata data="${cond.installmentRuleConditionIdentifier.uniqueID}"/></conditionId>
				<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
			</object>
		</c:if>
	</c:forEach>
</c:forEach>

<c:forEach var="option" items="${rule.installmentOption}">
	<object objectType="InstallmentOption">
		<optionId><wcf:cdata data="${option.installmentOptionIdentifier.uniqueID}"/></optionId>
		<currency><wcf:cdata data="${option.minimumInstallmentAmount.currency}"/></currency>
		<minInstallmentAmt><wcf:cdata data="${option.minimumInstallmentAmount.value}"/></minInstallmentAmt>
		<numInstallments><wcf:cdata data="${option.numberOfInstallments}"/></numInstallments>
		<rate><wcf:cdata data="${option.interestRate}"/></rate>
	</object>
</c:forEach>

</objects>