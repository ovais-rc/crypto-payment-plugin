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
	<objectStoreId><wcf:cdata data="${landingPage[0].storeIdentifier.uniqueID}"/></objectStoreId>
	<uniqueId><wcf:cdata data="${landingPage[0].uniqueID}"/></uniqueId>
	<searchTerms><wcf:cdata data="${landingPage[0].searchTerms}"/></searchTerms>
	<landingPage><wcf:cdata data="${landingPage[0].associatedTerms}"/></landingPage>
</object>
