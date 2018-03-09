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
                com.ibm.commerce.tools.catalog.helpers.*" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>
<%@page import="com.ibm.commerce.ruleservice.admin.beans.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>


<%
CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();
Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("adminconsole.rulesNLS",locale);
String webalias = UIUtil.getWebPrefix(request);
%>

<HTML>

<HEAD>

<LINK rel="stylesheet" href="<%=webalias%>tools/common/centre.css" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="<%=webalias%>javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

var kServletUrlPrefix = top.getWebappPath();
var kRuleDynamicListUrl = kServletUrlPrefix + "NewDynamicListView?ActionXMLFile=adminconsole.ruleList&cmd=RuleServiceListView";

ruleServiceList = new Array();
projectList = new Array();
var ruleListString = parent.get("ruleListString");
var projectListString = parent.get("projectListString");

function initializeState() {
    parent.setContentFrameLoaded(true);
    ruleListString = parent.get("ruleListString");
    projectListString = parent.get("projectListString");
}

function savePanelData() {
    var iteminfo = parent.get("RuleBean");
    iteminfo.numberOfAgents = document.panel1.numAgents.value;
    iteminfo.sessionTimeout = document.panel1.sTimeout.value;
    iteminfo.projectPath = document.panel1.proj.value;
    iteminfo.ruleServiceName = document.panel1.name.value;
    parent.put("RuleBean",iteminfo);
}

//returns true if the rule service name added exists in the list and
//false otherwise
function isItemInList() {
    var properPath = "";
    ruleServiceList = ruleListString.split("&");
    projectList = projectListString.split("&");

    //alertDialog("In the isItemInList function");
    //alertDialog("Number of items in ruleServiceList is: " + ruleServiceList.length + "number of items in projectList is: " + projectList.length);

    for (var i = 0; i<ruleServiceList.length; i++) {
        //alertDialog("current item in list: " + ruleServiceList[i]);
        if (ruleServiceList[i] == document.panel1.name.value) {
            alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("RSAlreadyInList"))%>');
            return true;
        }
        //alertDialog("current item in list: " + projectList[i]);
        properPath = getProperPath(document.panel1.proj.value);
        if (properPath.length > 0) {
            if (projectList[i].toLowerCase() == properPath.toLowerCase()) {
                alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("PathAlreadyInList"))%>');
                return true;
            }
        }
    }
    return false;
}

function getProperPath(initPath) {
    finalPath = "";
    tempPath = initPath;
    ch = "";
    //alertDialog("inside getProperPath");
    //alertDialog("tempPath is: " + tempPath);
    for (var i= 0; i < tempPath.length; i++) {
        //alertDialog("inside for loop");
        ch = tempPath.charAt(i);
        //alertDialog("character is " + ch);
        //alertDialog("final path is: " + finalPath);
        if (ch == "\\") {
            finalPath += "<WBR>";
            //break;
        } else if (ch == "/") {
            finalPath += "<WBR>";
            //break;
        } else {
            finalPath += ch;
            //break;
        }
        //alertDialog("ch = " + ch);
    }

    //alertDialog("this is the final string: " + finalPath);
    return finalPath;
}

// Grab this from the editDialog.js file?
function validatePanelData() {
    var nameMaxLength = 256;
    var timeoutMaxLength =  10;
    var numAgentsMaxLength = 10 ;
    var projectPathMaxLength = 256;

    //check if the name is a valid name
    if (document.panel1.name.value.length <= 0 || !isValidName(document.panel1.name.value) || isEmpty(document.panel1.name.value)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("invalidParameters"))%>');
        document.panel1.name.select();
        document.panel1.name.focus();
        return false;
    }

    //check if the name is valid UTF-8 length
    if ( !isValidUTF8length(document.panel1.name.value, nameMaxLength)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("stringTooLong"))%>');
        document.panel1.name.select();
        document.panel1.name.focus();
        return false;
    }

    //check if the project path is valid
    if (document.panel1.proj.value.length <= 0 || isEmpty(document.panel1.proj.value)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("invalidParameters"))%>');
        document.panel1.proj.select();
        document.panel1.proj.focus();
        return false;
    }

    //check if the project path is valid UTF-8 length
    if ( !isValidUTF8length(document.panel1.proj.value, projectPathMaxLength)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("stringTooLong"))%>');
        document.panel1.proj.select();
        document.panel1.proj.focus();
        return false;
    }

    //check if the number of Agents is valid
    if (document.panel1.numAgents.value.length <= 0 || isEmpty(document.panel1.numAgents.value)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("invalidParameters"))%>');
        document.panel1.numAgents.select();
        document.panel1.numAgents.focus();
        return false;
    }

    //check if the number of Agents is valid UTF-8 length
    if (!isValidUTF8length(document.panel1.numAgents.value, numAgentsMaxLength)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("stringTooLong"))%>');
        document.panel1.numAgents.select();
        document.panel1.numAgents.focus();
        return false;
    }

    // check to see if the number of Agents is an integer > -1.  -1 and 0 agents are special allowed cases.
    if (String(document.panel1.numAgents.value) != String(parseInt(document.panel1.numAgents.value)) || document.panel1.numAgents.value < -1) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("invalidParameters"))%>');
        document.panel1.numAgents.select();
        document.panel1.numAgents.focus();
        return false;
    }

    //check if the session Timeout is empty
    if (document.panel1.sTimeout.value.length <= 0 || isEmpty(document.panel1.sTimeout.value)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("invalidParameters"))%>');
        document.panel1.sTimeout.select();
        document.panel1.sTimeout.focus();
        return false;
    }

    //check if the session Timeout is valid UTF-8 length
    if (!isValidUTF8length(document.panel1.sTimeout.value, timeoutMaxLength)) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("stringTooLong"))%>');
        document.panel1.sTimeout.select();
        document.panel1.sTimeout.focus();
        return false;
    }

    //session timeout should be a positive integer or 0
    if (String(document.panel1.sTimeout.value) != String(parseInt(document.panel1.sTimeout.value)) || document.panel1.sTimeout.value < 0) {
        // alert message
        alertDialog('<%= UIUtil.toJavaScript( (String) itemResource.get("invalidParameters"))%>');
        document.panel1.sTimeout.select();
        document.panel1.sTimeout.focus();
        return false;
    }

    return true;
}

function doAdd() {
    var redirectPage = kRuleDynamicListUrl;

    if (! validatePanelData() || isItemInList()) {
        return;
    }

    var urlParameters = new Object();
    urlParameters.rsname = document.panel1.name.value;
    urlParameters.projectPath = document.panel1.proj.value;
    urlParameters.numAgents = document.panel1.numAgents.value;
    urlParameters.timeout = document.panel1.sTimeout.value;
    urlParameters.storeId = <%=(request.getParameter("storeId") == null ? null : UIUtil.toJavaScript(request.getParameter("storeId")))%>;
    urlParameters.URL = redirectPage;

    if (confirmDialog("<%=itemResource.get("finishConfirmation")%>")) {
        top.resetBCT();
        top.setContent("<%=itemResource.get("Administration")%>", kServletUrlPrefix + "AddRuleService", true, urlParameters);
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

<h1><%=itemResource.get("AddServiceTitle")%></h1>

<FORM METHOD=GET NAME="panel1">

<P><label for="addNameLabel"><%=itemResource.get("addNameLabel")%></label><BR>
<INPUT size="30" type="input" name="name" maxlength="256" id="addNameLabel">

<P><label for="addProjectLabel"><%=itemResource.get("addProjectLabel")%></label><BR>
<INPUT size="60" type="input" name="proj" maxlength="256" id="addProjectLabel">

<P><label for="addNumAgentsLabel"><%=itemResource.get("addNumAgentsLabel")%></label><BR>
<INPUT size="10" type="input" name="numAgents" maxlength="10" id="addNumAgentsLabel">

<P><label for="addSessionTimeLabel"><%=itemResource.get("addSessionTimeLabel")%></label><BR>
<INPUT size="10" type="input" name="sTimeout" maxlength="10" id="addSessionTimeLabel">

</FORM>

</BODY>

</HTML>
