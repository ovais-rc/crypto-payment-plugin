<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<c:set var="categoryID" value="" />
<object objectType="${element.elementSubType}">
	<parent>
		<object objectId="${element.parentElementName}"/>
	</parent>
	<elementName>${element.elementName}</elementName>
	<elementType>${element.elementType}</elementType>
	<elementSequence>${element.elementSequence}</elementSequence>
	<c:forEach var="elementVariable" items="${element.elementVariable}">
		<c:if test="${elementVariable.name != 'Id'}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
		</c:if>
		<c:if test="${elementVariable.name == 'Id'}">
			<c:set var="categoryID" value="${elementVariable.value}" />
		</c:if>
	</c:forEach>
	<c:if test="${categoryID != ''}">
		<c:set var="uniqueIDs" value="${categoryID}" />
		<jsp:directive.include file="GetCategoriesById.jsp" />
	</c:if>
</object>