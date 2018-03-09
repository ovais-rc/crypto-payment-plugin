
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="javax.servlet.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.user.beans.*" %>
<%@page import="com.ibm.commerce.user.objects.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.util.*" %>
<%@include file="common.jsp" %>
<%
	// Get the resource bundle with all the NLS strings
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContextLocale.getLocale();
	Hashtable commonResource = (Hashtable)ResourceDirectory.lookup("common.logonNLS", locale);
	String passwordStr = (String)commonResource.get("password");
	String passwordReEnterStr = (String)commonResource.get("passwordReEnterTitle");
	String continueStr = (String)commonResource.get("continue");
	String title = (String)commonResource.get("passwordReEnterTitle");
	String errMsg = (String)commonResource.get("passwordReEnterErrorMsg");
	JSPHelper jsphelper = new JSPHelper(request);
	String origFinish = jsphelper.getParameter(ECConstants.EC_PASSWORD_REREQUEST_URL);
	String strErrorCode = jsphelper.getParameter(ECConstants.EC_PASSWORD_REREQUEST_MSGCODE);

	if(strErrorCode!=null && strErrorCode.length()>0)
	{
		if(strErrorCode.equals("1"))
			errMsg = (String)commonResource.get("passwordsDoNotMatch");
		else if(strErrorCode.equals("2"))
			errMsg = (String)commonResource.get("passwordNotEntered");
		else if(strErrorCode.equals("3"))
			errMsg = (String)commonResource.get("passwordWrong");
	}

%>

<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<title><%= title %></title>
	<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>" />
	<script src="/wcs/javascript/tools/common/Util.js"></script>
	<script>

		function submitForm() {
			var password = document.TempForm.password.value;
			document.PasswordForm.<%=ECConstants.EC_PASSWORD_REREQUEST_PASSWORD1 %>.value = password;
			document.PasswordForm.<%=ECConstants.EC_PASSWORD_REREQUEST_PASSWORD2 %>.value = password;
			document.PasswordForm.submit();
		}

		function showPasswordPrompt() {
			var password = promptDialog('<%= errMsg %>', "", null, true);

			if (password != null) {
				document.PasswordForm.<%=ECConstants.EC_PASSWORD_REREQUEST_PASSWORD1 %>.value = password;
				document.PasswordForm.<%=ECConstants.EC_PASSWORD_REREQUEST_PASSWORD2 %>.value = password;
				document.PasswordForm.submit();
			}
			else {
				if (top.goBack) {
					top.goBack();
				}
				else {
					window.history.back();
				}
			}
		}
	</script>
</head>

<body class="button">
<div align="center">
<%
try {
//	int i = -1;
	// java.net.URLDecoder decoder = new java.net.URLDecoder();
	// URLUTF8Encoder decoder = new URLUTF8Encoder();

//	if (origFinish != null) {
//		i = origFinish.indexOf("?");
//		// if no parameters specified, simply set the form's action attribute to be the url specified
//		if (i <= 1) {
//			String finishAction = origFinish;
//			out.println("<form name=\"PasswordForm\" method=\"POST\" action=\"" + finishAction + "\">");
//		}
//		else {
//			// if parameters are specified, add them as html input parameters
//			String finishAction = origFinish.substring(0, i);
//			String finishParameter = origFinish.substring(i + 1);
//
//			out.println("<form name=\"PasswordForm\" method=\"POST\" action=\"" + finishAction + "\">");
//			StringTokenizer st = new StringTokenizer(finishParameter, "&");
//			while (st.hasMoreTokens()) {
//				String nvp = st.nextToken();
//				StringTokenizer st2 = new StringTokenizer(nvp, "=");
//
//				out.println("<input type=\"hidden\" name=\"" + st2.nextToken() + "\" value=\"" + URLUTF8Encoder.decode(st2.nextToken()) + "\">");
//			}
//		}
//	}
//	else {
//		out.println("<form name=\"PasswordForm\" method=\"POST\" action=\"\">");
//	}
	out.println("<form name=\"PasswordForm\" method=\"POST\" action=\"PasswordRequest\">");
%>
<input type="hidden" name="<%=ECConstants.EC_PASSWORD_REREQUEST_PASSWORD1 %>" value="">
<input type="hidden" name="<%=ECConstants.EC_PASSWORD_REREQUEST_PASSWORD2 %>" value="">
<input type="hidden" name="<%=ECConstants.EC_PASSWORD_REREQUEST_URL %>" value="<%=origFinish %>">
</form>
<script>
	if (top.mccmain) {
		showPasswordPrompt();
	}
	else {
		document.writeln('<b><%= errMsg %></b><br/><br/>');
		document.writeln('<form name="TempForm">');
		document.writeln('<label for="password"><%= passwordStr %>:</label>');
		document.writeln('<input type="password" autocomplete="off" id="password" name="password" size="18" maxlength="254" />');
		document.writeln('<button id="logon" onclick="submitForm();"><%= UIUtil.toJavaScript(continueStr) %></button>');
		document.writeln('</form>');
	}
</script>
</div>
<%
}
catch (Exception e) {
	out.println("<hr/>");
	out.println("<b>Stack Trace:</b><br/>");
	out.println("<pre>");
	e.printStackTrace();
	out.println("</pre>");
}
%>
</body>
</html>
