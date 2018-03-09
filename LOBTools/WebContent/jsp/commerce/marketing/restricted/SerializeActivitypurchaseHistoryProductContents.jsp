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

<c:set var="uniqueIDs" value="" />
<object objectType="purchaseHistoryProductContents">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
		<c:if test="${elementVariable.name != 'catalogEntryIdList'}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
		</c:if>
		<c:if test="${elementVariable.name == 'catalogEntryIdList'}">
			<c:choose>
				<c:when test="${uniqueIDs != ''}">
					<c:set var="uniqueIDs"
						value="${uniqueIDs}${','}${elementVariable.value}" />
				</c:when>
				<c:otherwise>
					<c:set var="uniqueIDs" value="${elementVariable.value}" />
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:forEach>
	<c:if test="${uniqueIDs != ''}">
		<jsp:directive.include file="GetProductsById.jsp" />
	</c:if>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
