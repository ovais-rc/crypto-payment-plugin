<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->
<%@include file="epromotionCommon.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="/wcs/javascript/tools/common/URLParser.js">
</script>
<script src="/wcs/javascript/tools/epromotion/RLSearchDialog.js">
</script>
<script>
var urlObj = new URLParser(parent.document.URL);
var xmlFile = urlObj.getParameterValue("ActionXMLFile");
var servletPath = urlObj.getRequestPath();
var searchCriteriaURL = servletPath + "/RLSearchDialogCriteriaView";
parent.searchDialogContentURL = document.URL;
document.location.replace(searchCriteriaURL + "?XMLFile=" + xmlFile);
</script>
</head>
</html>
