<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000-2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<script type="text/javascript" src="/wcs/javascript/tools/common/URLParser.js"></script>
<script type="text/javascript">

var urlObj = new URLParser(parent.document.URL);
var xmlFile = urlObj.getParameterValue("ActionXMLFile");
var servletPath = urlObj.getRequestPath();
var searchCriteriaURL = servletPath + "/SearchDialogCriteriaView";
var paramNames = urlObj.getParameterNames();
parent.userParams = "";

// Extract user's parameters for later resultURL redirection.
for (var i = 0; i < paramNames.length; i++) {
	if (paramNames[i].indexOf("ActionXMLFile") == -1) {
		parent.userParams += (parent.userParams == "")?(""):("&");
		parent.userParams += paramNames[i] + "=" + urlObj.getParameterValue(paramNames[i]);
	}	
}

parent.searchDialogContentURL = document.URL;
document.location.replace(searchCriteriaURL + "?XMLFile=" + xmlFile);

</script>
</head>
</html>
