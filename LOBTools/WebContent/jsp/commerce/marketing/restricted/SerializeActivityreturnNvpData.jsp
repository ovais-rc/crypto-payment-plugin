<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<object objectType="returnNvpData">
	<parent>
		<object objectId="${element.parentElementIdentifier.name}"/>
	</parent>
	<elemTemplateName><wcf:cdata data="${element.campaignElementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
	<elementName>${element.campaignElementIdentifier.name}</elementName>
	<sequence>${element.elementSequence}</sequence>
	<customerCount readonly="true">${element.count}</customerCount>
	<c:forEach var="elementVariable" items="${element.campaignElementVariable}">
			<${elementVariable.name}><wcf:cdata data="${elementVariable.value}"/></${elementVariable.name}>
	</c:forEach>
	<c:forEach var="userDataField" items="${element.userData.userDataField}">
		<x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
	</c:forEach>
</object>
