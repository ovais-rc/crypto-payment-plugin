<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object>
	<objectStoreId><wcf:cdata data="${replacements[0].storeIdentifier.uniqueID}"/></objectStoreId>
	<uniqueId><wcf:cdata data="${replacements[0].uniqueID}"/></uniqueId>
	<searchTerm><wcf:cdata data="${replacements[0].searchTerms}"/></searchTerm>
	<replacementTerms><wcf:cdata data="${replacements[0].associatedTerms}"/></replacementTerms>
	<associationType readonly="true"><wcf:cdata data="${param.associationType}"/></associationType>
</object>
