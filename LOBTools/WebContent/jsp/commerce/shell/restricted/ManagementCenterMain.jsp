
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2007, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<fmt:setLocale value="${param.locale}" />
<fmt:setBundle basename="com.ibm.commerce.foundation.client.lobtools.properties.ShellLOB" var="resources" />

<c:set var="backSlash" value="\\\\" />
<c:set var="escapedBackSlash" value="\\\\\\\\" />
<c:set var="singleQuote" value="'" />
<c:set var="escapedSingleQuote" value="\\\\'" />
<c:set var="doubleQuote" value="\"" />
<c:set var="escapedDoubleQuote" value="\\\\\"" />
<c:set var="forwardSlash" value="/" />
<c:set var="escapedForwardSlash" value="\\\\/" />
<c:set var="localeValue" value="${fn:replace(param.locale, backSlash, escapedBackSlash)}" />
<c:set var="localeValue" value="${fn:replace(localeValue, singleQuote, escapedSingleQuote)}" />
<c:set var="localeValue" value="${fn:replace(localeValue, doubleQuote, escapedDoubleQuote)}" />
<c:set var="localeValue" value="${fn:replace(localeValue, forwardSlash, escapedForwardSlash)}" />

<%
	request.setAttribute(com.ibm.commerce.foundation.internal.client.lobtools.servlet.TrimWhitespacePrintWriterImpl.TRIM_WHITESPACE, Boolean.FALSE);
	boolean workspacesEnabled = com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled("WorkspaceTaskList");
	boolean contentVersionEnabled = com.ibm.commerce.content.config.ContentVersionConfigHelper.isContentVersionEnabledInDatabase();
	String previewWebPath = null;
	String previewWebAlias = null;
	com.ibm.commerce.server.WebModuleConfig previewConfig = com.ibm.commerce.server.WcsApp.configProperties.getWebModule("Preview");
	if (previewConfig != null) {
		previewWebPath = previewConfig.getContextPath() + previewConfig.getUrlMappingPath();
		previewWebAlias = previewConfig.getWebAlias();
	}
	String restWebAlias = null;
	com.ibm.commerce.server.WebModuleConfig restConfig = com.ibm.commerce.server.WcsApp.configProperties.getWebModule("Rest");
	if (restConfig != null) {
		restWebAlias = restConfig.getWebAlias();
	}
	boolean ibmIdEnabled = com.ibm.commerce.util.SecurityHelper.isIBMidEnabled();
%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="${pageContext.request.locale.language}" lang="${pageContext.request.locale.language}">

<head>
<title><fmt:message key="applicationTitle" bundle="${resources}" /></title>
<style type="text/css">
html { height: 100%; width: 100%; overflow: hidden; }
body { margin: 0 0 0 0; background-image: url('${pageContext.request.contextPath}/images/commerce/shell/restricted/resources/welcome_background.jpg'); background-repeat: no-repeat; width: 100%; height: 100%; }
td.textTitle { font-family: Helvetica,Arial,sans-serif; font-size: 24px; word-wrap: break-word; color: #464646; }
td.textMessage { font-family: Helvetica,Arial,sans-serif; font-size: 13px; word-wrap: break-word; color: #464646; }
.selectDisabled {
	-moz-user-select:-moz-none;
    -moz-user-select:none;
    -o-user-select:none;
    -khtml-user-select:none;
    -webkit-user-select:none;
    -ms-user-select:none;
    user-select:none
}
.selectEnabled {
	-moz-user-select:text;
    -o-user-select:text;
    -khtml-user-select:text;
    -webkit-user-select:text;
    -ms-user-select:text;
    user-select:text
}
.cmcContextMenu {
	list-style: none;
	margin: 0;
	padding: 0;
	font-weight: normal;
	font-style: normal;
	font-family:Helvetica,Arial,sans-serif;
	font-size: 13px;
	background: white;
	color: #464646;
	border-color: #959595;
	border-width: 1px;
	border-style: solid;
}
.cmcContextMenuItem span{
	padding: 5px 20px;
	box-sizing: border-box;
}
.cmcContextMenuItem.cmcDisabledContextMenuItem{
	color:grey;
}
.cmcContextMenuItem.cmcMenuItemHilte{
	background-color:#e6effb;
	color: #464646
}
ul {
	offset: 0;
	margin: 0;
	padding-left: 12px;
}

</style>
<script>
var dojoConfig = {
	async: true,
	baseUrl: "${pageContext.request.contextPath}/",
	tlmSiblingOfDojo: false,
	packages: [
		{ name: "dojo", location: "dojo/dojo" },
		{ name: "dijit", location: "dojo/dijit" },
		{ name: "dojox", location: "dojo/dojox" },
		{ name: "cmc", location: "dojo/cmc" }
	]	
};
var CKEDITOR_BASEPATH = "${pageContext.request.contextPath}/ckeditor/";
</script>
<script src="${pageContext.request.contextPath}/dojo/dojo/dojo.js"></script>
<script src="${pageContext.request.contextPath}/javascript/shell/ManagementCenter.js"></script>
<script src="${pageContext.request.contextPath}/ckeditor/ckeditor.js"></script>
<script>
<!-- hide script from old browsers
var rootComponent = null;
var isUserLoggedOn = false;
var loggedInUserLocale = "<c:out value="${localeValue}" escapeXml="false" />";
var windowBaseName = "cmcMainWindow_" + removeInvalidChar(window.location.hostname);
var isCMCApplicationInitialized = false;
var automationStatusMsg = "";
var automationLastAction = "";
window.name = windowBaseName;
var newWindowObjs = new Object();
var initializePostMessageSrc = "";
<c:if test="${not empty param.initializePostMessageSrc }">
	initializePostMessageSrc = "<c:out value="${param.initializePostMessageSrc}"/>"
</c:if>

//
// Sets the status message to "initiated", "complete" or "aborted" when automation is initialized, complete or aborted.
//
function setAutomationStatusMsg(statusMsg){
	automationStatusMsg = statusMsg;
}

if (String.prototype.endsWith === undefined ){
	String.prototype.endsWith = function(suffix) {
		return this.indexOf(suffix, this.length - suffix.length) !== -1;
	};
}

//
// Sets the last automation action
//
function setAutomationLastAction(action){
	automationLastAction = action;
}

//
// This function will be called when CMC is initialized
//
function cmcApplicationInitialized() {
	isCMCApplicationInitialized = true;
	if (initializePostMessageSrc !== '' ){
		if (window.top !== window.self){
			//Embed in iFrame, if the CI launched in IE 10 or below, postMessage works fine using Edge
			window.top.postMessage(JSON.stringify({"cmd" : "cmcInitialized", "title": document.title}), initializePostMessageSrc);
		}
		else if (window.opener){
			window.opener.postMessage(JSON.stringify({"cmd" : "cmcInitialized"}), initializePostMessageSrc);
		}
	}
}

//
// Reset CMC keys
//
function resetCMCKeys() {
	if (isCMCApplicationInitialized && rootComponent != null && rootComponent.resetKeys) {
		rootComponent.resetKeys();
	}
}

//
// If the user has logged on when this window is attempted to close, pop up an alert dialog.
//
function beforeExit () {
	if (isUserLoggedOn) {
        return ''; // Empty message for the dialog.
	}
}

window.onbeforeunload = beforeExit;
window.onunload = closeAllChildWindows;

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

//
// Gets the locale of the logged on user in Management Center. This locale is used to determine the resourceBundle
// for displaying the texts in AlertDialog.jsp.
//
function getLoggedInUserLocale(){
	return loggedInUserLocale;
}

//
// Opens a new browser window positioned at the center with the URL specified.
// the arg object should contain : windowName, URL or content, windowFeatures, windowHeight and windowWidth.
// windowFeatures should not contain: left, top, width and height. It will calculate and set them before opening the window.
//
function openNewCenteredWindow (arg) {
	var left = 0;
	var top = 0;
	left = window.screenX + ((window.outerWidth - parseInt(arg.windowWidth)) / 2);
	top = window.screenY + ((window.outerHeight - parseInt(arg.windowHeight)) / 2);
	var newWindowFeatures = "left=" + left + ",top=" + top + ",width=" + arg.windowWidth + ",height=" + arg.windowHeight + "," + arg.windowFeatures;
	var newWindowObj = new Object();
	newWindowObj.URL = arg.URL;
	newWindowObj.content = arg.content;
	newWindowObj.windowName = removeInvalidChar(arg.windowName);
	newWindowObj.windowFeatures = newWindowFeatures;
	newWindowObj.submitForm = arg.submitForm;
	
	var newWindow = openNewWindow(newWindowObj);
}

//
// Launches openNewModalDialog on a timer.
//
function launchModalDialog (arg) {
	setTimeout(function() {
		openNewModalDialog(arg);
		}, 1);
}

//
// Opens a new modal dialog with the URL specified.
//
function openNewModalDialog (arg) {
	var dialogArguments = arg.windowArguments;
	var dialogName = arg.windowName;
	var dialogWidth = arg.windowWidth;
	var dialogHeight = arg.windowHeight;
	var features = "dialogWidth: " + dialogWidth + "px; dialogHeight: " + dialogHeight + "px; center: yes; status: no; help: no; scroll: yes;";
	if (arg.windowResizable) {
		features += "resizable: yes;";
	}
	var returnValue = window.showModalDialog(arg.URL, dialogArguments, features);
	if (typeof(returnValue) != "undefined") {
		rootComponent.setCallbackValue(returnValue, returnValue == "");
	}
	else {
		rootComponent.setCallbackValue(null, false);
	}
	resetCMCKeys();
}

//
// Opens a new browser window with the URL or content specified. If the URL is missing or blank,
// the new window will contain the HTML in the arg.content parameter.
//
function openNewWindow (arg) {
    var newWindow;
	var windowName = removeInvalidChar(arg.windowName);
	if(arg.URL && arg.URL != "") {
		var newWindowObj = window.open(arg.URL, windowName, arg.windowFeatures);
		newWindowObj.focus();
		newWindow = newWindowObj;

		newWindowObjs[windowName] = newWindowObj;
	} else if (arg.content && arg.content != "") {
		var newWindowObj = window.open("about:blank", windowName, arg.windowFeatures, true);
		newWindow = newWindowObj;
		newWindowObjs[windowName] = newWindowObj;
		setTimeout(function() {
			try{
				newWindowObj.document.write(arg.content);
			}
			catch (e) {
				newWindowObj.close();
				newWindowObj = window.open("", windowName, arg.windowFeatures, true);
				newWindowObjs[windowName] = newWindowObj;
				newWindowObj.document.write(arg.content);
			}
			newWindowObj.focus();
			if (arg.submitForm) {
				newWindowObj.document.forms[0].submit();
			}
		}, 1);
	}
	resetCMCKeys();
	return newWindow;
}

//
// Closes all child windows that have been opened
//
function closeAllChildWindows() {
	for(var win in newWindowObjs) {
		if(!newWindowObjs[win].closed) {
			newWindowObjs[win].close();
		}
	}
}

//
// Sets the locale of the logged on user in Management Center. This locale is used to determine the resourceBundle
// for displaying the texts in AlertDialog.jsp.
// This method is called from CMC after user is logged successfuly and user locale is retrieved from database.
//
function setLoggedInUserLocale(locale){
	loggedInUserLocale = locale;
}

//
// Sets the ID of the user who has logged on.
//
function setUserLogonId (arg) {
	window.name = arg == null ? windowBaseName : windowBaseName + "_" + removeInvalidChar(arg);
	isUserLoggedOn = arg == null ? false : true;

	if(arg == null) {
		closeAllChildWindows();
	}
}

// Get the current window name
function getWindowName() {
	return window.name;
}

//
// Forces a user re-login in Management Center
//
function doRelogon(reason) {
	if(reason == "CWXBB1011E" || reason == "1011") {
		rootComponent.doSessionTimeout();
	}
	else if(reason == "CWXBB1012E" || reason == "1012") {
		rootComponent.doSessionTerminated();
	}
	else {
		rootComponent.doSessionCorrupted();
	}
}

//Open tool from CI
function openBusinessTool(toolId, WCToken, WCTrustedToken){
	rootComponent.addWCTokenPendingActions({
		"name": "openToolByToolId", 
		"toolId": toolId
	});
	rootComponent.resolveWCToken(WCToken, WCTrustedToken);
}

function editBusinessObject(toolId, storeId, storeSelection, languageId, searchType, searchOptions, openOptions, WCToken, WCTrustedToken, workspaceTaskSelection) {
	
	if (WCToken != null && WCTrustedToken != null){
		rootComponent.addWCTokenPendingActions({
			"name":"cmc/foundation/OpenObjectActionHandler", 
			"args" : {
				toolId: toolId,
				storeId: storeId,
				storeSelection: storeSelection,
				workspaceTaskSelection: workspaceTaskSelection,
				languageId: languageId,
				searchType: searchType,
				searchOptions: searchOptions,
				select: true,
				openOptions: openOptions
			}
		});
		rootComponent.resolveWCToken(WCToken, WCTrustedToken);
	}
	else {
		rootComponent.triggerAction("cmc/foundation/OpenObjectActionHandler", {
			toolId: toolId,
			storeId: storeId,
			storeSelection: storeSelection,
			workspaceTaskSelection: workspaceTaskSelection,
			languageId: languageId,
			searchType: searchType,
			searchOptions: searchOptions,
			select: true,
			openOptions: openOptions
		});
	}
}

function createBusinessObject(toolId, storeId, storeSelection, languageId, objectType, newObjectOptions, WCToken, WCTrustedToken, workspaceTaskSelection) {
	if (WCToken != null && WCTrustedToken != null){
		rootComponent.addWCTokenPendingActions({
			"name":"cmc/foundation/CreateObjectActionHandler", 
			"args" : {
				toolId: toolId,
				storeId: storeId,
				storeSelection: storeSelection,
				workspaceTaskSelection: workspaceTaskSelection,
				languageId: languageId,
				objectType: objectType,
				newObjectOptions: newObjectOptions
			}
		});
		rootComponent.resolveWCToken(WCToken, WCTrustedToken);
	}
	else {
		rootComponent.triggerAction("cmc/foundation/CreateObjectActionHandler", {
			toolId: toolId,
			storeId: storeId,
			storeSelection: storeSelection,
			workspaceTaskSelection: workspaceTaskSelection,
			languageId: languageId,
			objectType: objectType,
			newObjectOptions: newObjectOptions
		});
	}
}

function receiveMessage(event){
	var origin = event.origin;
	var portRex = /:[0-9]+/g;
	var isHttpsRex = /https/ig;
	var hasPortNumber = portRex.test(origin);
	var isHTTPS = isHttpsRex.test(origin);
	if (window.top !== window.self && window.top !== event.source){
		//as embeded in iFrame, only consume message from current browser window
		return;
	}
	else if (hasPortNumber && origin !== initializePostMessageSrc)  {
		//must be equal is origin has port number
		return;
	}
	else if (isHTTPS && origin !== initializePostMessageSrc && (origin + ":443") !== initializePostMessageSrc){
		//test match default port number for https
		return;
	}
	else if (!isHTTPS && origin !== initializePostMessageSrc && (origin + ":80") !== initializePostMessageSrc) {
		//test match default port number for http
		return;
	}
	else {
		var data = JSON.parse(event.data);
		var command = data.cmd;
		var args = data.args;
		if (command == 'editBusinessObject'){
			editBusinessObject(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
		}
		else if (command == 'createBusinessObject') {
			createBusinessObject(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
		}
		else if (command == 'openBusinessTool') {
			openBusinessTool(args[0], args[1], args[2]);
		}
	}
}

if (initializePostMessageSrc !== ''){
	window.addEventListener("message", receiveMessage, false);
}

function bodyOnResize() {
	require(["cmc/foundation/EventUtil", "dojo/dom-style", "dojo/dom"], function(EventUtil, domStyle, dom) {
		domStyle.set(dom.byId("mainContent"), "height", document.documentElement.clientHeight + "px");
		domStyle.set(dom.byId("mainContent"), "width", document.documentElement.clientWidth + "px");
		EventUtil.trigger(document, "onresize");
	});
}

require(["dojo/domReady!"], function() {
//	console.log("ready!");
	bodyOnResize();
});

//-->
</script>
</head>

<%-- 
	Defined and added css class "selectDisabled" to body, disable html native range select. 
	So that, dragging will not cause whole/part of the page be highlighted.
	If html navtive range select is needed, we will need to find an alternative approach.
	Could be set this class dynamically ... 
--%>
<body onresize="bodyOnResize();" class="selectDisabled">

<div id="mainContent" style="overflow: hidden;position: absolute;display: none;">

<script type="text/javascript">
if (!checkBrowser()) {
	document.writeln('<div style="display: block;">');
}
else {
	document.writeln('<div style="display: none;">');
}
</script>
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td height="75"></td></tr>
	<tr>
		<td width="135"></td>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorSupportedBrowserTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10"></td></tr>
				<tr><td class="textMessage"><fmt:message key="errorSupportedBrowserMessage" bundle="${resources}" /></td></tr>
			</table>
		</td>
		<td width="135"></td>
	</tr>
</table>
<script type="text/javascript">
document.writeln('</div>');
</script>

<script type="text/javascript">
if (checkBrowser()) {
	//
	// set up global CMC config object
	//
	var cmcConfig = {};

	var previewPort = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("WebServer/PreviewPort") %>';
	if (previewPort != "null" && previewPort != "") {
		cmcConfig.previewPort = previewPort;
	}

	var previewWebPath = '<%= previewWebPath %>';
	if (previewWebPath != "null" && previewWebPath != "") {
		cmcConfig.previewWebPath = previewWebPath;
	}

	var previewWebAlias = '<%= previewWebAlias %>';
	if (previewWebAlias != "null" && previewWebAlias != "") {
		cmcConfig.previewWebAlias = previewWebAlias;
	}
	
	var restWebAlias = '<%= restWebAlias %>';
	if (restWebAlias != "null" && restWebAlias != "") {
		cmcConfig.restWebAlias = restWebAlias;
	}
	
	var helpServerHostName = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("Websphere/HelpServerHostName") %>';
	if (helpServerHostName != "null" && helpServerHostName != "") {
		cmcConfig.helpServerHostName = helpServerHostName;
	}

	var helpServerPort = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("Websphere/HelpServerPort") %>';
	if (helpServerPort != "null" && helpServerPort != "") {
		cmcConfig.helpServerPort = helpServerPort;
	}
	
	var helpServerContextPath = '<%= com.ibm.commerce.server.ConfigProperties.singleton().getValue("Websphere/HelpServerContextPath") %>';
	if (helpServerContextPath != "null" && helpServerContextPath != "") {
		cmcConfig.helpServerContextPath = helpServerContextPath;
	}

<c:forEach var="aParam" items="${paramValues}">
	<c:forEach var="aValue" items="${aParam.value}">
	cmcConfig["<c:out value="${aParam.key}" />"] = "<c:out value="${aValue}" />";
	</c:forEach>
</c:forEach>
	
	cmcConfig.workspacesEnabled = "<%=workspacesEnabled%>";
	cmcConfig.contentVersionEnabled = "<%=contentVersionEnabled%>";
	cmcConfig.createFileEnabled = "<%=!com.ibm.commerce.foundation.internal.server.services.search.util.StoreHelper.isUsingUCDUpload()%>";
	
	cmcConfig.serviceContextRoot = '${pageContext.request.contextPath}';
	cmcConfig.ruleBasedCategoryEnabled = "<%=com.ibm.commerce.catalog.facade.server.helpers.RuleBasedCategoryConfig.getInstance().getCategoryRuleEvaluationEnabled()%>";	
	var ruleBasedCategoryEvaluationTimeValue = '<%=com.ibm.commerce.catalog.facade.server.helpers.RuleBasedCategoryConfig.getInstance().getRuleEvaluationTimeInterval()%>';
	if (ruleBasedCategoryEvaluationTimeValue != "null") {
		cmcConfig.ruleBasedCategoryEvaluationTime = "<%=com.ibm.commerce.catalog.facade.server.helpers.RuleBasedCategoryConfig.getInstance().getRuleEvaluationTimeInterval().toString()%>";
	}
	cmcConfig.ibmIdEnabled = "<%=ibmIdEnabled%>";

	window.onfocus = resetCMCKeys;
	window.onblur = resetCMCKeys;

	require(["cmc/RootComponent"], function(RootComponent) {
		rootComponent = RootComponent.Singleton;
	});
}
</script>

</div>

<script type="text/javascript">
document.getElementById("mainContent").style.display = "block";
</script>
<noscript>
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td height="75"></td></tr>
	<tr>
		<td width="105"></td>
		<td width="130" height="130" background="${pageContext.request.contextPath}/images/shell/mc_logo.png" style="background: transparent url('${pageContext.request.contextPath}/images/shell/mc_logo.png') none; background-repeat: no-repeat; background-color: rgb(182, 199, 246); filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, src='${pageContext.request.contextPath}/images/shell/mc_logo.png', sizingMethod='image')"></td>
		<td width="35"></td>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="textTitle"><fmt:message key="errorEnableJavaScriptTitle" bundle="${resources}" /></td></tr>
				<tr><td height="10" /></tr>
				<tr><td class="textMessage"><fmt:message key="errorEnableJavaScriptMessage" bundle="${resources}" /></td></tr>
			</table>
		</td>
	</tr>
	<tr><td height="425"></td></tr>
</table>
</noscript>

</body>

</html>
