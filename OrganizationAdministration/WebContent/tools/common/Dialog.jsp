<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@include file="../common/common.jsp" %>
<%--
   Include our data bean. This bean wrappers the dialog XML.
--%>
<jsp:useBean id="UIProperties" scope="request" class="com.ibm.commerce.tools.common.ui.DialogBean"></jsp:useBean>
<%--
   Initialize our UIProperties bean.
--%>
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
<title><%out.print(UIProperties.getTitle());%></title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/> 
<%--
   Define the needed javascript functions
--%>
<script type="text/javascript" src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<%@include file="NumberFormat.jsp" %>
<%
	// Include user javascript files
	out.println(UIProperties.getJSIncludeTags());
%>
<%
	// Include file of general functions
%>
<script type="text/javascript">

// does this dialog need a warning before user exit?
var needWarning = "<%= UIProperties.getXMLValue("warningOnClose") %>";

<%@include file="UIPropertiesJSFunctions.jspf" %>
<%
   // Include dialog specific javascript functions here
%>

/**
 * setPanelAccess(name,access)
 * this function accepts a panel name and access for that panel
 * and sets the access field of that panel
 */
function setPanelAccess(name,access) {
	if (pageArray[name] != null) {
		pageArray[name].access = access;
	}
}

/**
 * validatePanel()
 * - this function determines if the panel in the CONTENTS frame has
 *   a validateEntries function and executes it if it does.
 * - if the validateEntries was not found or was successfully executed
 *   it sets the validated field of the current panel to YES and returns true
 *   otherwise it returns false
 */ 
function validatePanel() {
    if (this.CONTENTS.validatePanelData && this.CONTENTS.validatePanelData() == false) {
		setContentFrameLoaded(true);
		return false;
    }
    
	pageArray[currPanel].validated = "YES";
	return true;
}

function isDialog() {
	return true;
}

function finish() {
    finishClicked = true;
    if (waitForPageToLoad == true && isContentFrameLoaded() == false) {
        return;
    }

    savePanelData();
    
    if (validatePanel() == false) {
        finishClicked = false;
        return;
    }

    // An impatient user could click finish several times. Add a check to prevent this
    if (!finishAlreadyClicked) {

        finishAlreadyClicked = true;

        // call a user defined javascript function before call to server
        if (this.preSubmitHandler) {
            preSubmitHandler();
        }
        
        // trigger the progress indicator to display
        setContentFrameLoaded(false);

<%
	// only call server command if one exists
	if (UIProperties.getXMLValue("finishURL") != null && !UIProperties.getXMLValue("finishURL").equals("")) {
%>
		window.NAVIGATION.document.forms.submitForm.XMLString.value = XmodelToXML("XMLString");
	    
		// if the Xmodel is empty, then submit the regular model
	    // length of empty model is 40 <xml ... />
	    if (window.NAVIGATION.document.forms.submitForm.XMLString.value.length <= 40) {
			window.NAVIGATION.document.forms.submitForm.XML.value = modelToXML("XML");
		}
		window.NAVIGATION.document.forms.submitForm.submit();
<%
	}
%>
		finishAlreadyClicked = false;
	}
}

<%
	// Include general initialization code
%>
<%@include file="UIPropertiesInitialization.jspf"%>

</script>
</head>
<%
	//Create the frameset for this notebookWizard.
	UIProperties.getFrameset(out);
%>
</html>

