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
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf"%>
<object readonly="false">
	<changeControlModifiable>true</changeControlModifiable>
	<folderItemID>${folder[0].folderIdentifier.uniqueID}_${folder[0].folderItem[0].referenceID}</folderItemID>
	<folderItemReferenceId>${folder[0].folderItem[0].referenceID}</folderItemReferenceId>
	<objectStoreId>${param.objectStoreId}</objectStoreId>
</object>
