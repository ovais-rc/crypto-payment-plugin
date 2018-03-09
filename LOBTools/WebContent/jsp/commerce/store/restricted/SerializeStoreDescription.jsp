<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<object objectType="StoreDescription">
	<languageId><wcf:cdata data="${storeDesc.language}"/></languageId>
	<description><wcf:cdata data="${storeDesc.description}"/></description>
	<displayName><wcf:cdata data="${storeDesc.displayName}"/></displayName>
	<c:forEach var="userDataField" items="${storeDesc.userData}">
		<xdesc_${userDataField.typedKey}><wcf:cdata data="${userDataField.typedValue}"/></xdesc_${userDataField.typedKey}>
	</c:forEach>
</object>