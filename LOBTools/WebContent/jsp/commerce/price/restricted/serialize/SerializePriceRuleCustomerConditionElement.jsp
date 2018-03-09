<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<object objectType="${element.elementTemplateIdentifier.externalIdentifier.name}">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.elementTemplateIdentifier.externalIdentifier.name}" /></elemTemplateName>
	<elementName>${element.elementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<c:forEach var="elementVariable" items="${element.elementAttribute}">
		<c:choose>
			<c:when test="${elementVariable.name == 'memberGroupIdentifier'}">
				<object objectType="MemberGroupEntry">
					<memberGroupIdentifier>${elementVariable.value}</memberGroupIdentifier>
				</object>
			</c:when>
			<c:when test="${elementVariable.name == 'organizationIdentifier'}">
				<object objectType="OrganizationEntry">
					<organizationIdentifier>${elementVariable.value}</organizationIdentifier>
				</object>
			</c:when>
			<c:when test="${elementVariable.name == 'customerSegmentIdentifier'}">
				   <c:set var="uniqueIDs" value="${elementVariable.value}" />
				   <jsp:directive.include file="../../../marketing/restricted/GetCustomerSegmentsById.jsp" />
			</c:when>
			<c:when test="${elementVariable.name == 'buyerOrganizationIdentifier'}">
				   <c:set var="uniqueIDs" value="${elementVariable.value}" />
				   <jsp:directive.include file="../GetBuyerOrganization.jsp" />
			</c:when>
			<c:otherwise>
				<${elementVariable.name}><wcf:cdata data="${elementVariable.value}" /></${elementVariable.name}>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}" /></x_${userDataField.typedKey}>
	</c:forEach>

</object>
