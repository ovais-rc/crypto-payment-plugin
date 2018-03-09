<%--
 ===================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright International Business Machines Corporation.
      2007, 2008
      All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="categoryUniqueIDs" value="" />
<c:set var="productUniqueIDs" value="" />

<object objectType="shoppingCart">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:choose>
			<c:when test="${elementVariable.name == 'categoryIdList'}">
				<c:choose>
					<c:when test="${categoryUniqueIDs != ''}">
						<c:set var="categoryUniqueIDs" value="${categoryUniqueIDs}${','}${elementVariable.value}" />
					</c:when>
					<c:otherwise>
						<c:set var="categoryUniqueIDs" value="${elementVariable.value}" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:when test="${elementVariable.name == 'catalogEntryIdList'}">
				<c:choose>
					<c:when test="${productUniqueIDs != ''}">
						<c:set var="productUniqueIDs" value="${productUniqueIDs}${','}${elementVariable.value}" />
					</c:when>
					<c:otherwise>
						<c:set var="productUniqueIDs" value="${elementVariable.value}" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:if test="${categoryUniqueIDs != ''}">
		<c:set var="uniqueIDs" value="${categoryUniqueIDs}" />
		<jsp:directive.include file="GetCategoriesById.jsp" />
	</c:if>
	<c:if test="${productUniqueIDs != ''}">
		<c:set var="uniqueIDs" value="${productUniqueIDs}" />
		<jsp:directive.include file="GetProductsById.jsp" />
	</c:if>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
