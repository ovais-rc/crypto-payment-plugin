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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<object>
	<extDataId>${layout[0].widget[0].extendedData[0].uniqueID}</extDataId>
	<c:if test="${layout[0].widget[0].extendedData[0].dataType=='IBM_DefaultMarketingContent'}">
		<uniqueId>${layout[0].widget[0].extendedData[0].uniqueID}</uniqueId>
	</c:if>
</object>
