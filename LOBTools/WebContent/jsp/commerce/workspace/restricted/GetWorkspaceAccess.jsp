<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/xml;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<c:set var="managerRole" value="false"/>
<c:set var="approverRole" value="false"/>
<c:set var="contributorRole" value="false"/>

<wcf:getData var="onlineStores"
			 type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
			 expressionBuilder="findAll"
			 maxItems="1">
	<wcf:param name="accessProfile" value="IBM_Summary" />
	<wcf:param name="usage" value="IBM_WorkspaceManager" />
</wcf:getData>
<c:if test="${!empty onlineStores}">
	<c:set var="managerRole" value="true"/>
</c:if>
<wcf:getData var="onlineStores"
			 type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
			 expressionBuilder="findAll"
			 maxItems="1">
	<wcf:param name="accessProfile" value="IBM_Summary" />
	<wcf:param name="usage" value="IBM_WorkspaceApprover" />
</wcf:getData>
<c:if test="${!empty onlineStores}">
	<c:set var="approverRole" value="true"/>
</c:if>
<wcf:getData var="onlineStores"
			 type="com.ibm.commerce.infrastructure.facade.datatypes.OnlineStoreType[]"
			 expressionBuilder="findAll"
			 maxItems="1">
	<wcf:param name="accessProfile" value="IBM_Summary" />
	<wcf:param name="usage" value="IBM_WorkspaceContributor" />
</wcf:getData>
<c:if test="${!empty onlineStores}">
	<c:set var="contributorRole" value="true"/>
</c:if>

<values>
	<workspaceManager>${managerRole}</workspaceManager>
	<workspaceApprover>${approverRole}</workspaceApprover>
	<workspaceContributor>${contributorRole}</workspaceContributor>
</values>



