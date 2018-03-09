<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<object>
	<childCatalogEntryId>${catalogGroup[0].catalogGroupIdentifier.uniqueID}_${catalogGroup[0].navigationRelationship[0].catalogEntryReference.catalogEntryIdentifier.uniqueID}</childCatalogEntryId>
	<objectStoreId>${param.storeId}</objectStoreId>
</object>