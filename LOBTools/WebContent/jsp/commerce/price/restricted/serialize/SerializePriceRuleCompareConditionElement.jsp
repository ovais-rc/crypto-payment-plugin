<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object objectType="compareCondition">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.elementTemplateIdentifier.externalIdentifier.name}" /></elemTemplateName>
	<elementName>${element.elementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<c:forEach var="elementVariable" items="${element.elementAttribute}">
		<c:choose>
			<c:when test="${elementVariable.name == 'inputOperandReferenceId'}">
				<c:set var="inputOperandReferenceId" value="${elementVariable.value}" />
			</c:when>
			<c:when test="${elementVariable.name == 'comparisonOperandReferenceId'}">
				<c:set var="comparisonOperandReferenceId" value="${elementVariable.value}" />
			</c:when>
			<c:when test="${elementVariable.name == 'inputOperandType'}">
				<inputOperandType>${elementVariable.value}</inputOperandType>
				<c:set var="inputOperandType" value="${elementVariable.value}" />
			</c:when>
			<c:when test="${elementVariable.name == 'comparisonOperandType'}">
				<comparisonOperandType>${elementVariable.value}</comparisonOperandType>
				<c:set var="comparisonOperandType" value="${elementVariable.value}" />
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}" /></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	
	<c:choose>
		<c:when test="${inputOperandType == 'PriceList'}">
			<c:if test="${inputOperandReferenceId != ''}">
				<wcf:getData
					type="com.ibm.commerce.price.facade.datatypes.PriceListType"
					var="priceList" expressionBuilder="getPriceListsByID"
					varShowVerb="showVerb">
					<wcf:contextData name="storeId" data="${param.storeId}" />
					<wcf:param name="priceListId" value="${inputOperandReferenceId}" />
				</wcf:getData>
				
				<c:if test="${!(empty priceList)}">
					<c:set var="objectType" value="InputPriceList" />
					<c:set var="objStoreId" value="${priceList.priceListIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
					<c:if test="${objStoreId == '0'}">
						<c:set var="objStoreId" value="${param.storeId}"/>
					</c:if>
					<c:if test="${(param.storeId) != objStoreId}">
						<c:set var="objectType" value="InheritedInputPriceList" />
					</c:if>
					<object objectType="${objectType}">
						<referenceId>${priceList.priceListIdentifier.uniqueID}</referenceId>
						<jsp:directive.include file="SerializePriceList.jspf" />
					</object>
				</c:if> 

			</c:if>
		</c:when>
		<c:when test="${inputOperandType == 'PriceConstant'}">
			<c:if test="${inputOperandReferenceId != ''}">
				<wcf:getData
					type="com.ibm.commerce.price.facade.datatypes.PriceConstantType"
					var="priceConstant" expressionBuilder="getPriceConstantByID"
					varShowVerb="showVerb">
					<wcf:contextData name="storeId" data="${param.storeId}" />
					<wcf:param name="priceConstantId" value="${inputOperandReferenceId}" />
				</wcf:getData>
				
				<c:if test="${!empty priceConstant}">
					<c:set var="objectType" value="InputPriceConstant" />
					<c:set var="objStoreId" value="${priceConstant.priceConstantIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
					<c:if test="${objStoreId == '0'}">
						<c:set var="objStoreId" value="${param.storeId}"/>
					</c:if>
					<c:if test="${(param.storeId) != objStoreId}">
						<c:set var="objectType" value="InheritedInputPriceConstant" />
					</c:if>
					<object objectType="${objectType}">
						<c:set var="showVerb" value="${showVerb}" scope="request"/>
						<c:set var="businessObject" value="${priceConstant}" scope="request"/>
						<referenceId>${priceConstant.priceConstantIdentifier.uniqueID}</referenceId>
						<jsp:directive.include file="SerializePriceConstant.jspf" />
					</object>
				</c:if>
			</c:if>
		</c:when>
		<c:when test="${inputOperandType == 'PriceEquation'}">
			<c:if test="${inputOperandReferenceId != ''}">
				<wcf:getData type="com.ibm.commerce.price.facade.datatypes.PriceEquationType" var="priceEquation" expressionBuilder="getPriceEquationByID" varShowVerb="showVerb">
					<wcf:contextData name="storeId" data="${param.storeId}" />
					<wcf:param name="priceEquationId" value="${inputOperandReferenceId}" />
				</wcf:getData>
				
				<c:if test="${!empty priceEquation}">
					<c:set var="objectType" value="InputPriceEquation" />
					<c:set var="objStoreId" value="${priceEquation.formulaIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
					<c:if test="${objStoreId == '0'}">
						<c:set var="objStoreId" value="${param.storeId}"/>
					</c:if>
					<c:if test="${(param.storeId) != objStoreId}">
						<c:set var="objectType" value="InheritedInputPriceEquation" />
					</c:if>
					<object objectType="${objectType}">
						<c:set var="showVerb" value="${showVerb}" scope="request"/>
						<c:set var="businessObject" value="${priceEquation}" scope="request"/>
						<referenceId>${priceEquation.formulaIdentifier.uniqueID}</referenceId>
						<jsp:directive.include file="SerializePriceEquation.jspf" />
					</object>
				</c:if>
			</c:if>
		</c:when>
	</c:choose>
	
	<c:choose>
		<c:when test="${comparisonOperandType == 'PriceList'}">
			<c:if test="${comparisonOperandReferenceId != ''}">
				<wcf:getData
					type="com.ibm.commerce.price.facade.datatypes.PriceListType"
					var="priceList" expressionBuilder="getPriceListsByID"
					varShowVerb="showVerb">
					<wcf:contextData name="storeId" data="${param.storeId}" />
					<wcf:param name="priceListId" value="${comparisonOperandReferenceId}" />
				</wcf:getData>
				
				<c:if test="${!(empty priceList)}">
					<c:set var="objectType" value="ComparisonPriceList" />
					<c:set var="objStoreId" value="${priceList.priceListIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
					<c:if test="${objStoreId == '0'}">
						<c:set var="objStoreId" value="${param.storeId}"/>
					</c:if>
					<c:if test="${(param.storeId) != objStoreId}">
						<c:set var="objectType" value="InheritedComparisonPriceList" />
					</c:if>
					<object objectType="${objectType}">
						<referenceId>${priceList.priceListIdentifier.uniqueID}</referenceId>
						<jsp:directive.include file="SerializePriceList.jspf" />
					</object>
				</c:if>
			</c:if>
		</c:when>
		<c:when test="${comparisonOperandType == 'PriceConstant'}">
			<c:if test="${comparisonOperandReferenceId != ''}">
				<wcf:getData
					type="com.ibm.commerce.price.facade.datatypes.PriceConstantType"
					var="priceConstant" expressionBuilder="getPriceConstantByID"
					varShowVerb="showVerb">
					<wcf:contextData name="storeId" data="${param.storeId}" />
					<wcf:param name="priceConstantId" value="${comparisonOperandReferenceId}" />
				</wcf:getData>
				
				<c:if test="${!empty priceConstant}">
					<c:set var="objectType" value="ComparisonPriceConstant" />
					<c:set var="objStoreId" value="${priceConstant.priceConstantIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
					<c:if test="${objStoreId == '0'}">
						<c:set var="objStoreId" value="${param.storeId}"/>
					</c:if>
					<c:if test="${(param.storeId) != objStoreId}">
						<c:set var="objectType" value="InheritedComparisonPriceConstant" />
					</c:if>
					<object objectType="${objectType}">
						<c:set var="showVerb" value="${showVerb}" scope="request"/>
						<c:set var="businessObject" value="${priceConstant}" scope="request"/>
						<referenceId>${priceConstant.priceConstantIdentifier.uniqueID}</referenceId>
						<jsp:directive.include file="SerializePriceConstant.jspf" />
					</object>
				</c:if>
			</c:if>
		</c:when>
		<c:when test="${comparisonOperandType == 'PriceEquation'}">
			<c:if test="${comparisonOperandReferenceId != ''}">
				<wcf:getData
					type="com.ibm.commerce.price.facade.datatypes.PriceEquationType"
					var="priceEquation" expressionBuilder="getPriceEquationByID"
					varShowVerb="showVerb">
					<wcf:contextData name="storeId" data="${param.storeId}" />
					<wcf:param name="priceEquationId" value="${comparisonOperandReferenceId}" />
				</wcf:getData>
				
				<c:if test="${!empty priceEquation}">
					<c:set var="objectType" value="ComparisonPriceEquation" />
					<c:set var="objStoreId" value="${priceEquation.formulaIdentifier.externalIdentifier.storeIdentifier.uniqueID}" />
					<c:if test="${objStoreId == '0'}">
						<c:set var="objStoreId" value="${param.storeId}"/>
					</c:if>
					<c:if test="${(param.storeId) != objStoreId}">
						<c:set var="objectType" value="InheritedComparisonPriceEquation" />
					</c:if>
					<object objectType="${objectType}">
						<c:set var="showVerb" value="${showVerb}" scope="request"/>
						<c:set var="businessObject" value="${priceConstant}" scope="request"/>
						<referenceId>${priceEquation.formulaIdentifier.uniqueID}</referenceId>
						<jsp:directive.include file="SerializePriceEquation.jspf" />
					</object>
				</c:if>
			</c:if>
		</c:when>
	</c:choose>
	
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}" /></x_${userDataField.typedKey}>
	</c:forEach>
</object>
