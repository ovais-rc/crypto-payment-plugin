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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2013
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" type="text/css" href="<%= UIUtil.getCSSFile(locale) %>"/>
<style type="text/css">

html,body { height: 100%; overflow: hidden; }

</style>
<script type="text/javascript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script type="text/javascript">

var winObj = (isIE)?(window):(opener);

function onLoad() {
	var message = winObj.dialogArguments.message;
	var messageArea = document.getElementById("messageArea");
	messageArea.innerHTML = message;
	autoResizeModalDialog();
	document.promptForm.defaultValue.value = winObj.dialogArguments.defaultValue;
	addObjEventListener(document, "keypress", trapKey, false);	
	document.promptForm.defaultValue.focus();
}

function onExit(value) {
	if (!value)
		winObj.returnValue = null;
	else
		winObj.returnValue = document.forms[0].defaultValue.value;

	this.window.close();
}

function doNothing() {
	onExit(true);
	return false;
}

function trapKey(evt) {
	var e = new XBEvent(evt);

	// Traps for ESC key.
	if (e.keyCode == 27) {
		onExit(false);
	}
}

document.oncontextmenu=new Function("return false");

</script>
</head>
<body class="dialogBody" onload="onLoad();">
<form name="promptForm" onsubmit="return doNothing();">
	<table border="0" width="100%" cellpadding="1" cellspacing="0">
		<tbody>
			<tr>
				<td bgcolor="#4D2698" colspan="2" height="10"></td>
			</tr>
			<tr>
				<td colspan="2" height="5"></td>
			</tr>		
			<tr>
	    	    <td rowspan="2" align="center" width="75"><img alt="" src="<%= UIUtil.getWebPrefix(request) %>images/tools/uiproperties/m_information.gif"/></td>
	    	    <label for="input1">
	    	    <td align="left" id="messageArea" class="dialogText"></td>
	    	    </label>
	    	</tr>
	    	<tr>
	    	    <td align="left">
				<script type="text/javascript">
					if (winObj.dialogArguments.passwordInput != null && winObj.dialogArguments.passwordInput == true)
						document.writeln('<input type="password" autocomplete="off" id="input1" name="defaultValue" style="width: 420px" maxLength="' + winObj.dialogArguments.iLength + '"/>');
					else
						document.writeln('<input type="text" id="input1" name="defaultValue" style="width: 400px" maxLength="' + winObj.dialogArguments.iLength + '"/>');
				</script>
				</td>
			</tr>
			<tr>
				<td colspan="2" height="5"></td>
			</tr>
			<tr>
	    	    <td colspan="2" align="center">
	    	    	<button onclick="onExit(true);"><%= resourceNLS.get("ok") %></button>
	    	    	&nbsp;&nbsp;
	    	    	<button onclick="onExit(false);"><%= resourceNLS.get("cancel") %></button>
	    	    </td>
			</tr>
		</tbody>
	</table>
</form>
</body>
</html>