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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="branchtypeReadOnly" value="false" />
<object objectType="${element.campaignElementTemplateIdentifier.externalIdentifier.name}">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${elementVariable.name == 'branchtypeReadOnly'}">
			<c:set var="branchtypeReadOnly" value="${elementVariable.value}"/>
		</c:if>
	</c:forEach>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:choose>
			<c:when test="${elementVariable.name == 'branchtype'}">
				<${elementVariable.name} readonly="${branchtypeReadOnly}"><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>

	<c:choose>
		<c:when test="${!empty element.experimentStatistics}">
			<uniqueCustomerCount readonly="true">${element.experimentStatistics.customersParticipated}</uniqueCustomerCount>
			<c:forEach var="testElement" items="${element.experimentStatistics.testElementStatistics}">
				<object objectType="path">
					<elementName>${testElement.testElement.name}</elementName>
					<customerCount readonly="true">${element.count}</customerCount>
					<object objectType="ExperimentStatistics">
						<uniqueId>1</uniqueId>
						<views readonly="true">${testElement.views}</views>
						<viewOrders readonly="true">${testElement.viewOrders}</viewOrders>
						<viewRevenue readonly="true">${testElement.viewRevenue}</viewRevenue>
						<clicks readonly="true">${testElement.clicks}</clicks>
						<clickOrders readonly="true">${testElement.clickOrders}</clickOrders>
						<clickRevenue readonly="true">${testElement.clickRevenue}</clickRevenue>
						<currency readonly="true">${testElement.currency}</currency>
						<c:forEach var="userDataField" items="${testElement.userData.userDataField}">
							<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
						</c:forEach>
					</object>
				</object>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<uniqueCustomerCount readonly="true">${element.count}</uniqueCustomerCount>
		</c:otherwise>
	</c:choose>
</object>
