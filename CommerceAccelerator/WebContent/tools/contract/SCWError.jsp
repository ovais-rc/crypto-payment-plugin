<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->

<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@page import="java.util.*" %>

<%
try{

   CommandContext cc = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
   Locale locale = cc.getLocale();
   Hashtable resourceBundle = (Hashtable)ResourceDirectory.lookup("contract.contractRB", locale);
%>
<html>
<head>

<script language="JavaScript">
function disableNextFinishButton () {
	
	if (parent.NAVIGATION) {
		var nextButton = parent.NAVIGATION.document.getElementsByName("NextButton")[0];
		var finishButton = parent.NAVIGATION.document.getElementsByName("FinishButton")[0];
		if (nextButton) {
			nextButton.disabled = "true";
			clearTimeout (buttonCheckTimeout);
		}
		if (finishButton) {
			finishButton.disabled = "true";
			clearTimeout (buttonCheckTimeout);
		}
	}
}

function init () {
	buttonCheckTimeout = setTimeout ("disableNextFinishButton()", 1000);
	if (parent.setContentFrameLoaded) {
		parent.setContentFrameLoaded(true);
	}
}

function savePanelData () {
}

function validatePanelData () {
	disableNextFinishButton();
	if (parent.NAVIGATION) {
		var closeButton = parent.NAVIGATION.document.getElementsByName("OKButton")[0];
		if (closeButton) {
			return true;
		}
	}
	return false;
}

</script>
</head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<body onload="init()" class="content">
      <center>
      <br><br><h1>
      <%=UIUtil.toHTML((String)resourceBundle.get("configurationErrorMessage"))%>
      </h1>
      </center>
      <br>
</body>
</html>
<% }catch (Exception SCWexception) { %>
<html>
<head>
</head>
<body class="content">
<!-- A serious configuration error has occurred, please contact the site administrator 
<% SCWexception.printStackTrace();
%>
-->
</body>
</html>
<% } %>