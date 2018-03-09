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

<object objectType="${element.elementSubType}">
	<parent>
		<object objectId="${element.parentElementName}"/>
	</parent>
	<elementName>${element.elementName}</elementName>
	<elementSequence>${element.elementSequence}</elementSequence>
	<elementType>${element.elementType}</elementType>
	<c:forEach var="elementVariable" items="${element.elementVariable}">
		<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
	</c:forEach>
</object>