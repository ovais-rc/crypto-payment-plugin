<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object objectType="dynamicKitBranch">
    <parent><object objectId="${element.parentElementIdentifier.name}"/></parent>
    <elemTemplateName><wcf:cdata data="${element.elementTemplateIdentifier.externalIdentifier.name}"/></elemTemplateName>
    <elementName>${element.elementIdentifier.name}</elementName>
    <sequence>${element.elementSequence}</sequence>
    <c:forEach var="userDataField" items="${element.userData.userDataField}">
        <x_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></x_${userDataField.typedKey}>
    </c:forEach>
</object>