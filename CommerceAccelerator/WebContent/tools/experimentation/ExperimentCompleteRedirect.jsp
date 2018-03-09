<!-- ==================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.datatype.TypedProperty,
	com.ibm.commerce.tools.experimentation.ExperimentConstants" %>

<%@ include file="common.jsp" %>

<%
	Boolean experimentCompleteStatus = null;
	TypedProperty requestProperties = (TypedProperty) request.getAttribute("RequestProperties");
	if (requestProperties != null) {
		experimentCompleteStatus = (Boolean) requestProperties.get(ExperimentConstants.PARAMETER_EXPERIMENT_COMPLETE_STATUS, Boolean.TRUE);
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= experimentRB.get("experimentCompleteDialogTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
<%	if (experimentCompleteStatus.booleanValue()) { %>
alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentCompleteConfirmation")) %>");
<%	} else { %>
alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentNotCompleted")) %>");
<%	} %>
top.goBack();
//-->
</script>
</head>

<body class="content">
</body>

</html>