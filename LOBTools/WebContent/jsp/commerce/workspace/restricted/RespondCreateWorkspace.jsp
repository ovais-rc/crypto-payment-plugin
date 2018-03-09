<?xml version="1.0" encoding="UTF-8"?>

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page contentType="text/xml;charset=UTF-8" %>

<object deletable="false">
	<workspaceId>${workspaces[0].workspaceIdentifier.uniqueID}</workspaceId>
	<workspaceIdentifier>${workspaces[0].workspaceIdentifier.identifier}</workspaceIdentifier>
	<workspaceEmergencyFix readonly="true">${workspaces[0].emergencyUse}</workspaceEmergencyFix>
</object>
