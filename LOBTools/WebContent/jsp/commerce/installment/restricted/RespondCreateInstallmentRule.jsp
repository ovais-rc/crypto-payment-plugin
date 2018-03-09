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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>

<object>
	<uniqueId><wcf:cdata data="${rules[0].installmentRuleIdentifier.uniqueID}"/></uniqueId>
	<name><wcf:cdata data="${rules[0].installmentRuleIdentifier.externalIdentifier.name}"/></name>
</object>
