<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@include file="../common/common.jsp" %>
<%-- Include our data bean. This bean wrappers the dialog XML. --%>
<jsp:useBean id="UIProperties" scope="request" class="com.ibm.commerce.tools.common.ui.WizardBean"></jsp:useBean>
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
<title>WizardNavigation</title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<%@include file="UIPropertiesNavigation.jspf" %>
</head>

<body class="button">
<form name="WizardForm">
<script type="text/javascript">

viewname = 'WizardNavigation';

hasCancel = new String(parent.getCurrentPanelAttribute("hasCancel"));
hasFinish = new String(parent.getCurrentPanelAttribute("hasFinish"));
hasPrev   = parent.getCurrentPanelAttribute("prev");
hasNext   = parent.getCurrentPanelAttribute("next");
  
document.writeln('<table border="0" cellspacing="0" cellpadding="2" width="100%">');
document.writeln('	<tr>');
document.writeln('		<td class="dottedLine" height="1" width="100%"></td>');
document.writeln('	</tr>');
document.writeln('	<tr>');
document.writeln('		<td align="right">');
document.writeln('			<table border="0" cellspacing="0" cellpadding="0" height="26">');
document.writeln('				<tr>');

createDynamicButtons("dialog");

if ((hasPrev != null) && (parent.isPrevPanel() == true)) {
	document.writeln('<td align="center">');
	document.writeln('	<button id="wizardPrev" name="PreviousButton" onclick="parent.gotoPrevPanel();">' + parent.getPreviousNLS() + '</button>');
	document.writeln('</td>');
}

if ((hasNext != null) && (parent.isNextPanel() == true)) {
	document.writeln('<td align="center">');
	document.writeln('	<button id="wizardNext" name="NextButton" onclick="parent.gotoNextPanel();">' + parent.getNextNLS() + '</button>');
	document.writeln('</td>');
}

if (hasFinish.toUpperCase() == "YES") {
	document.writeln('<td align="center">');
	document.writeln('	<button id="wizardFinish" name="FinishButton" onclick="parent.finish();">' + parent.getFinishNLS() + '</button>');
	document.writeln('</td>');
}

if (hasCancel.toUpperCase() != "NO") {
	document.writeln('<td align="center">');
	document.writeln('	<button id="wizardCancel" name="CancelButton" onclick="parent.cancel();">' + parent.getCancelNLS() + '</button>');
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

