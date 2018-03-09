<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<jsp:useBean id="now" class="java.util.Date"/>

<object>
	<object objectType="ChildEMarketingSpot" new="true">
		<object objectType="EMarketingSpot">
			<name><wcf:cdata data="${param.widgetDefinitionName}${param.widgetDefinitionId}${now.time}"/></name>
		</object>
	</object>
</object>
