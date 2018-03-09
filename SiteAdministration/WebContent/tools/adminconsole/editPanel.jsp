<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="java.util.*,
                com.ibm.commerce.beans.*,
                com.ibm.commerce.tools.catalog.beans.*,
                com.ibm.commerce.tools.catalog.helpers.*"
%>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.rulesNLS",locale);
String webalias = UIUtil.getWebPrefix(request);

final int kNameMaximumLength = 256;
final int kSessionTimeoutMaximumLength = 10;
final int kAgentsMaximumLength = 10;
final int kProjectPathMaximumLength = 256;
%>

<HTML>

<HEAD>

<LINK rel="stylesheet" href="<%=webalias%>tools/common/centre.css" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>

<SCRIPT>
var kServletUrlPrefix = top.getWebappPath();
var kRuleDynamicListUrl = kServletUrlPrefix + "NewDynamicListView?ActionXMLFile=adminconsole.ruleList&cmd=RuleServiceListView";

function getMainPanel() {
    return document.ruleServiceDetails;
}

function getAgentsElement() {
    return getMainPanel().numAgents;
}

function getSessionTimeoutElement() {
    return getMainPanel().sTimeout;
}

function getProjectPathElement() {
    return getMainPanel().proj;
}

function getServiceNameElement() {
    return getMainPanel().name;
}


function initializeState() {
    getAgentsElement().value = parent.get("numAgents");
    getSessionTimeoutElement().value = parent.get("timeout");
    getProjectPathElement().value = parent.get("projectPath");
    getServiceNameElement().value = parent.get("rsname");
    parent.setContentFrameLoaded(true);
}

function savePanelData() {
    var iteminfo = parent.get("RuleBean");
    iteminfo.numberOfAgents = getAgentsElement().value;
    iteminfo.sessionTimeout = getSessionTimeoutElement().value;
    iteminfo.projectPath = getProjectPathElement().value;
    // Don't pass the service name, since it's read-only.
    parent.put("RuleBean", iteminfo);
}

function handleInvalidParameter(element) {
    alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("invalidParameters"))%>');
    element.select();
    element.focus();
}

function handleStringTooLong(element) {
    alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("stringTooLong"))%>');
    element.select();
    element.focus();
}

function checkNameIsValidParameter(stringElement, stringElementMaximumLength) {
    if (!checkStringIsValidParameter(stringElement, stringElementMaximumLength)) {
        return false;
    }
    else if (!isValidName(stringElement.value)) {
        handleInvalidParameter(stringElement);
        return false;
    }
    return true;
}

function checkStringIsValidParameter(stringElement, stringElementMaximumLength) {
    if (stringElement.value.length <= 0 || isEmpty(stringElement.value)) {
        handleInvalidParameter(stringElement);
        return false;
    }
    else if (!isValidUTF8length(stringElement.value, stringElementMaximumLength)) {
        handleStringTooLong(stringElement);
        return false;
    }
    return true;
}

function isNumber(value) {
    return (String(value) == String(parseInt(value)));
}

function validatePanelData() {
    if (!checkStringIsValidParameter(getProjectPathElement(), <%= kProjectPathMaximumLength %>)) {
        return false;
    }
    else if (!checkStringIsValidParameter(getAgentsElement(), <%= kAgentsMaximumLength %>)) {
        return false;
    }
    else if (!isNumber(getAgentsElement().value) || getAgentsElement().value < -1) {
        // check to see if the number of Agents is an integer > -1.  -1 and 0 agents are special allowed cases.
        handleInvalidParameter(getAgentsElement());
        return false;
    }
    else if (!checkStringIsValidParameter(getSessionTimeoutElement(), <%= kSessionTimeoutMaximumLength %>)) {
        return false;
    }
    else if (!isNumber(getSessionTimeoutElement().value) || getSessionTimeoutElement().value < 0) {
        // session timeout should be a positive integer or 0
        handleInvalidParameter(getSessionTimeoutElement());
        return false;
    }
    else {
        return true;
    }
}

function doEdit() {
    if (!validatePanelData()) {
        return;
    }

    var urlParameters = new Object();
    urlParameters.rsname = getServiceNameElement().value;
    urlParameters.projectPath = getProjectPathElement().value;
    urlParameters.numAgents = getAgentsElement().value;
    urlParameters.timeout = getSessionTimeoutElement().value;
    urlParameters.storeId = <%=(request.getParameter("storeId") == null ? null : UIUtil.toJavaScript(request.getParameter("storeId")))%>;
    urlParameters.redirecturl = kRuleDynamicListUrl;

    if (confirmDialog("<%=itemResource.get("editConfirmation")%>")) {
        top.resetBCT();
        top.setContent("<%=itemResource.get("Administration")%>", kServletUrlPrefix + "EditRuleService", true, urlParameters);
    }
}

function doCancel() {
    if (confirmDialog("<%=itemResource.get("cancelConfirmation")%>")) {
		top.goBack();
	}
}
</SCRIPT>

</HEAD>

<BODY ONLOAD="initializeState()" CLASS="content">

<h1><%=itemResource.get("EditServiceTitle")%></h1>

<FORM METHOD=POST NAME="ruleServiceDetails">

<P><label for="addNameLabel"><%=itemResource.get("addNameLabel")%></label><BR>
<INPUT size="30" type="input" name="name" maxlength="<%= kNameMaximumLength %>" onFocus="blur()" id="addNameLabel">

<P><label for="addProjectLabel"><%=itemResource.get("addProjectLabel")%></label><BR>
<INPUT size="60" type="input" name="proj" maxlength="<%= kProjectPathMaximumLength %>" id="addProjectLabel">

<P><label for="addNumAgentsLabel"><%=itemResource.get("addNumAgentsLabel")%></label><BR>
<INPUT size="10" type="input" name="numAgents" maxlength="<%= kAgentsMaximumLength %>" id="addNumAgentsLabel">

<P><label for="addSessionTimeLabel"><%=itemResource.get("addSessionTimeLabel")%></label><BR>
<INPUT size="10" type="input" name="sTimeout" maxlength="<%= kSessionTimeoutMaximumLength %>" id="addSessionTimeLabel">

</FORM>

</BODY>

</HTML>
