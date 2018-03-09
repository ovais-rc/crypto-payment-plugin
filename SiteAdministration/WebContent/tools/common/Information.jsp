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
//* (c) Copyright IBM Corp. 2000-2004
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
	var messageArea = new XBElement("messageArea");
	messageArea.setInnerHTML(message);
	autoResizeModalDialog();
	addObjEventListener(document, "keypress", trapKey, false);
	document.getElementById("okButton").focus();
}

function trapKey(evt) {
	var e = new XBEvent(evt);

	// Traps for Enter and ESC keys.
	if (e.keyCode == 13 || e.keyCode == 27) {
		closeWindow();
	}
}

function closeWindow() {
	window.close();
}

document.oncontextmenu=new Function("return false");

</script>
<object classid="clsid:22D6F312-B0F6-11D0-94AB-0080C74C7E95" width="0" height="0">
	<param name="src" valuetype="data" value="<%= UIUtil.getWebappPath(request) %>tools/common/dialog.wav"/>
</object>
</head>
<body class="dialogBody" onload="onLoad();">
<form>
	<table border="0" width="100%" cellpadding="1" cellspacing="0">
	    <tbody>
			<tr>
				<td bgcolor="#4D2698" colspan="2" height="10"></td>
			</tr>
			<tr>
				<td colspan="2" height="5"></td>
			</tr>		
			<tr>
				<td align="center" valign="middle">
					<table border="0" cellpadding="1" cellspacing="0">
						<tbody>											
						    <tr>
								<td align="center" width="75"><img alt="" src="<%= UIUtil.getWebPrefix(request) %>images/tools/uiproperties/m_information.gif"/></td>
								<td align="left" id="messageArea" class="dialogText"></td>
						    </tr>
						    <tr>
			    				<td colspan="2" height="5"></td>
						    </tr>
						    <tr>
						        <td colspan="2" align="center">
						        	<button name="okButton" id="okButton" onclick="closeWindow();"><%= resourceNLS.get("ok") %></button>
						        </td>
						    </tr>
		    			</tbody>
		    		</table>
	    		</td>
			</tr>	    								    
	    </tbody>
	</table>
</form>
</body>
</html>
