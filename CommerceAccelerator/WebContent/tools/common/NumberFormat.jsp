<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
--%>
<%@page import="java.text.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<% 
	// WARNING: PLEASE INCLUDE FILE "Util.js" WHEN USING THIS FILE
%>
<script type="text/javascript">
<%=
    CurrencyFormatGenerator.getJSObjects()
%>
</script>

<script type="text/javascript" src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/NumberFormat.js"></script>
