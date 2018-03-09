<%--
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation.
 *     2006
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *
 *-------------------------------------------------------------------
 */
--%> 

<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.user.beans.*" %>
<%@page import="com.ibm.commerce.user.objects.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@include file="/tools/common/common.jsp" %>
<%

	// Get the resource bundle with all the NLS strings
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContextLocale.getLocale();
	Hashtable resourceBundle = (Hashtable)ResourceDirectory.lookup("common.mccNLS", locale);

%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>" />
	<script src="/wcs/javascript/tools/common/Util.js"></script>
</head>
<body class="content">
	<script>
			if (defined(top.mccmain) && top.mccmain.location != self.location) {
				top.mccmain.location.replace(this.document.URL);
			}
			else {
				alert("<%= resourceBundle.get("timeout") %>");
				top.close();
			}
	</script>
</body>
</html>
