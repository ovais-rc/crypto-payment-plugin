<?xml version="1.0" encoding="UTF-8"?>

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
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<object>
	<uniqueId>${marketingSpots[0].defaultMarketingSpotTitle[0].uniqueID}</uniqueId>
	<objectStoreId>${param.storeId}</objectStoreId>
	<changeControlModifiable>true</changeControlModifiable>
</object>
