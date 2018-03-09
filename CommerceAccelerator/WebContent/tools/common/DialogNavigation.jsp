<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@include file="../common/common.jsp" %>
<%-- Include our data bean. This bean wrappers the dialog XML. --%>
<jsp:useBean id="UIProperties" scope="request" class="com.ibm.commerce.tools.common.ui.DialogBean"></jsp:useBean>
<%-- Initialize our UIProperties bean. --%>
<%
	UIProperties.setRequestProperties((TypedProperty)request.getAttribute(ECConstants.EC_REQUESTPROPERTIES));
	UIProperties.setCommandContext((CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT));
	Locale locale = UIProperties.getLocale();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
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
-->
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title>DialogNavigation</title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<%@include file="UIPropertiesNavigation.jspf" %>
<script type="text/javascript">

function cancel() {
    // check whether warning dialog is required
    if (parent.warningOnClose()) {
        if (!confirmDialog("<%= UIUtil.toJavaScript(UIProperties.getCancelConfirmation()) %>")) {
            return;
        }
    }
            
    if (parent.submitCancelHandler) {
		parent.submitCancelHandler();
	}
	else { // default action is just one step back
        top.goBack();
    }
}

</script>
</head>
<body class="button">
<form name="DialogForm">
<script type="text/javascript">

viewname = 'DialogNavigation';

hasCancel = new String(parent.getCurrentPanelAttribute("hasCancel"));
hasFinish = new String(parent.getCurrentPanelAttribute("hasFinish"));

document.writeln('<table border="0" cellspacing="0" cellpadding="2" width="100%">');
document.writeln('	<tr>');
document.writeln('		<td class="dottedLine" height="1" width="100%"></td>');
document.writeln('	</tr>');
document.writeln('	<tr>');
document.writeln('		<td align="right">');
document.writeln('			<table border="0" cellspacing="0" cellpadding="0" height="26">');
document.writeln('				<tr>');

createDynamicButtons("dialog");
	
if (hasFinish.toUpperCase() != "NO") {
	document.writeln('<td align="center">');
	document.writeln('	<button id="OKButton" name="OKButton" onclick="parent.finish();">' + parent.getOkNLS() + '</button>');
	document.writeln('</td>');
}

if (hasCancel.toUpperCase() != "NO") {
	document.writeln('<td align="center">');
	document.writeln('	<button id="CancelButton" name="CancelButton" onclick="cancel();">' + parent.getCancelNLS() + '</button>');
	document.writeln('</td>');
}

document.writeln('				</tr>');
document.writeln('			</table>');
document.writeln('		</td');
document.writeln('	</tr>');
document.writeln('	<tr>');
document.writeln('		<td class="dottedLine" colspan="height="1" width="100%"></td>');
document.writeln('	</tr>');
document.writeln('</table>');

</script>
</form>
<%
	UIProperties.getFinishForm(out);
%>
<script type="text/javascript">

if (parent.finishClicked == true) {
	handleFinish();
}

</script>
</body>
</html>


