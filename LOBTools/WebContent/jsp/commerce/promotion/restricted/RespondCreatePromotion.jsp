<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object>
	<identifier	readonly="true">
		<wcf:cdata data="${promotions[0].promotionIdentifier.externalIdentifier.name}"/>
	</identifier>
	<promotionId>${promotions[0].promotionIdentifier.uniqueID}</promotionId>
	<startDate>${promotions[0].schedule.startDate}</startDate>
</object>
