
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<% 
	request.setAttribute(
			com.ibm.commerce.foundation.internal.client.lobtools.servlet.TrimWhitespacePrintWriterImpl.TRIM_WHITESPACE
			, Boolean.FALSE);
%>

<fmt:setLocale value="${pageContext.request.locale}" />
<fmt:setBundle basename="com.ibm.commerce.foundation.client.lobtools.properties.ShellLOB" var="resources" />

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">

<head>
<title><fmt:message key="applicationTitle" bundle="${resources}" /></title>
<style type="text/css">
body { margin: 0 0 0 0; background-image: url('${pageContext.request.contextPath}/images/commerce/shell/restricted/resources/welcome_background.jpg'); background-repeat: no-repeat; }
td.textTitle { font-family: Helvetica,Arial,sans-serif; font-size: 24px; word-wrap: break-word; color: #464646; }
td.textMessage { font-family: Helvetica,Arial,sans-serif; font-size: 13px; word-wrap: break-word; color: #464646; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/shell/ManagementCenter.js"></script>
<script type="text/javascript">
<!-- hide script from old browsers
//
// Checks the browser and block IE 10 and earlier version.
//
function checkBrowser () {
	var isBrowserSupported = true;
	if (navigator.appName == "Microsoft Internet Explorer") {
		isBrowserSupported = false;
	}
	return isBrowserSupported;
}

function window_onLoad () {
	if (checkBrowser()) {
		//
		// set up variables to be used in this function
		//
		var launchURL = "${pageContext.request.contextPath}/cmc/ManagementCenterMain";
		var launchURLParams = "?locale=${pageContext.request.locale}";
		var windowName = "cmcMainWindow_" + removeInvalidChar(window.location.hostname);

		//
		// append parameters to the launch URL
		//
<c:forEach var="aParam" items="${paramValues}">
	<c:forEach var="aValue" items="${aParam.value}">
		launchURLParams += "&<wcf:out value='${aParam.key}' escapeFormat='url'/>=<wcf:out value='${aValue}' escapeFormat='url'/>";
	</c:forEach>
</c:forEach>

		//
		// open the main management center page in a separate window
		//
		window.open(launchURL + launchURLParams, windowName, "left=0,top=0,width=1200,height=780,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes").focus();
	}
}
//-->
</script>
</head>

<body onload="window_onLoad()">

<table border="0" cellpadding="0" cellspacing="0">
	<tr><td height="75" /></tr>
	<tr>
		<td width="270" />
		<td>
			<div id="mainContent" style="display: none;">
<script type="text/javascript">
if (!checkBrowser()) {
	document.writeln('<div style="display: block;">');
}
else {
	document.writeln('<div style="display: none;">');
}
</script>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorSupportedBrowserTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorSupportedBrowserMessage" bundle="${resources}" /></td></tr>
			</table>
<script type="text/javascript">
document.writeln('</div>');
</script>

<script type="text/javascript">
if (checkBrowser()) {
	document.writeln('<div style="display: block;">');
}
else {
	document.writeln('<div style="display: none;">');
}
</script>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="applicationTitle" bundle="${resources}" /></td></tr>
				<tr><td height="20" /></tr>
				<tr><td class="textMessage"><fmt:message key="launchPageInformationMessage1" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="launchPageInformationMessage2" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="launchPageInformationMessage3" bundle="${resources}" /></td></tr>
			</table>
<script type="text/javascript">
document.writeln('</div>');
</script>
			</div>

			<script type="text/javascript">
				document.getElementById("mainContent").style.display = "block";
			</script>
			<noscript>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorEnableJavaScriptTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorEnableJavaScriptMessage" bundle="${resources}" /></td></tr>
			</table>
			</noscript>
		</td>
	</tr>
</table>

</body>

</html>
