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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.user.beans.*" %>
<%@page import="com.ibm.commerce.user.objects.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@include file="common.jsp" %>
<%

	// Get the resource bundle with all the NLS strings
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContextLocale.getLocale();
	Hashtable resourceBundle = (Hashtable)ResourceDirectory.lookup("common.mccNLS", locale);

%>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>" />
	<script src="/wcs/javascript/tools/common/Util.js"></script>
</head>
<body class="content">
	<script>
			if (defined(top.mccmain) && top.mccmain.location != self.location) {
				top.mccmain.location.replace(this.document.URL);
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript(resourceBundle.get("timeout")) %>");
				if (window.dialogArguments) {
					window.dialogArguments.timeout = true;
				}
				if (defined(top.mccbanner)) {
					top.mccbanner.showWarningUponClosing = false;
				}
				top.close();
			}
	</script>
</body>
</html>
