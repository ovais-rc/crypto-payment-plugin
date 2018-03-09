<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@include file="common.jsp" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = null;

	// use server default locale if no command context is found
	if (cmdContext != null) {
		locale = cmdContext.getLocale();
	}
	else {
		locale = Locale.getDefault();
	}

	Hashtable resourceNLS = (Hashtable)ResourceDirectory.lookup("common.mccNLS", locale);
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>">
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script>

var winObj = opener;

function onLoad() {
	addObjEventListener(document, "keypress", trapKey, false);
	document.forms[0].okButton.focus();
}

function trapKey(evt) {
	var e = new XBEvent(evt);

	if (e.keyCode == 13) {
		closeWindow();
	}
}

function closeWindow() {
	window.close();
}

document.oncontextmenu=new Function("return false");

</script>
<bgsound src="dialog.wav">
</head>

<body class="dialogBody" onload="onLoad();">
<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<script>
		var originalObj = winObj.debugMessage;

		var message = inspect(originalObj);
		if (message) {
			var pairs = message.split("<end>\n");
			var pattern = new RegExp(":::", "i");
		
			if (pairs.length == 1) {
				document.writeln("<tr>");
				document.writeln("<td align='left' valign='left' colspan='2'><pre>" + convertFromTextToHTML(pairs[0]) + "</pre></td>");
				document.writeln("</tr>");
			}
			else {
				for (i=0; i<pairs.length; i++) {
					if (pairs[i].match(pattern)) {
						document.writeln("<tr>");
						document.writeln("<td align='left' valign='top'>" + pairs[i].substring(0, pairs[i].indexOf(":::")) + "</td>");
						document.writeln("<td align='left' valign='top'><pre>" + convertFromTextToHTML(pairs[i].substring(pairs[i].indexOf(":::") + 3)) + "</pre></td>");
						document.writeln("</tr>");
					}
				}
			}
		}
		else {
			document.writeln("<tr>");
			document.writeln("<td align='left' valign='left' colspan='2'><pre>" + convertFromTextToHTML(message) + "</pre></td>");
			document.writeln("</tr>");		
		}
	</script>
</table>
<form>
<div align="center">
	<button name="okButton" onClick="closeWindow();"  class="dialogButton"><%= resourceNLS.get("ok") %></button>
</div>
</form>
</body>
</html>
