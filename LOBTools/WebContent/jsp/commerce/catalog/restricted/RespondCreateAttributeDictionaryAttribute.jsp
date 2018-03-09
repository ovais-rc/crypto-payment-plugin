<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object>
	<attrId>${attributeDictionaryAttributes[0].attributeIdentifier.uniqueID}</attrId>
	<objectStoreId>${param.storeId}</objectStoreId>
	<attrDataType readonly="true"><wcf:cdata data="${attributeDictionaryAttributes[0].attributeDataType}"/></attrDataType>
	<c:choose>
		<c:when test="${attributeDictionaryAttributes[0].facetable=='true'}">
			<facetable>${attributeDictionaryAttributes[0].facetable}</facetable>
		    <%--  
		     If facetable is set to true explicitly, we want to also imply that searchable is true.
			 However if facetable is explicitly set to false, we do not want to imply that the attribute is not
			 searchable, especially if it was previously being used as searchable.
			 --%>
			<searchable readonly="true">true</searchable>
		</c:when>
		<c:otherwise>
			<searchable>${attributeDictionaryAttributes[0].searchable}</searchable>
		</c:otherwise>
	</c:choose>	
</object>
