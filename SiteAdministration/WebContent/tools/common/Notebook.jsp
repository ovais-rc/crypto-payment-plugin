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
<jsp:useBean id="UIProperties" scope="request" class="com.ibm.commerce.tools.common.ui.NotebookBean"></jsp:useBean>
<%--
   Initialize our UIProperties bean.
--%>
<%
   UIProperties.setRequestProperties((TypedProperty)request.getAttribute(ECConstants.EC_REQUESTPROPERTIES));
   UIProperties.setCommandContext((CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT));
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
<%@include file="UIPropertiesJSFunctions.jspf" %>
<%
   // Include notebook specific javascript functions here
%>

/**
 * finish()
 * If the content frame has not finished loading then do nothing
 * otherwise save the current content panels information
 * then validate all of the panels
 * If the validation succeeds, then convert model to xml and call finish 
 * command passing in the xml as a parameter
 */
function finish() {
	finishClicked = true;
	if (waitForPageToLoad == true && isContentFrameLoaded() == false) {
		return;
	}

	savePanelData();

	// requested by CSR team (d12652) to validate panel data in a Notebook
	if (this.CONTENTS.validateNoteBookPanel && this.CONTENTS.validateNoteBookPanel() == false) {
		finishClicked = false;
		return;
	}

	if (this.validateAllPanels && this.validateAllPanels() == false) {
		finishClicked = false;
		return;
	}

	// An impatient user could click finish several times. Add a check to prevent this
	if (!finishAlreadyClicked) {
		finishAlreadyClicked = true;

		// call a user defined javascript function before call to server
		if (this.preSubmitHandler) {
			this.preSubmitHandler();
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

/**
 * getTocBackgroundImage()
 * Gets the TOC background image.
 */
function getTocBackgroundImage() {
	var imagesrc='';
<%
	String image = UIProperties.getXMLValue("tocBackgroundImage");
	if (image != null && !image.equals("")) { 
%>	
	imagesrc = '<%= image %>';
<%
	}						
%>
	return imagesrc;
}	 	
	
<%--
   Include general initialization code
--%>  
<%@include file="UIPropertiesInitialization.jspf" %>

</script>
</head>
<%
	// Create the frameset for this notebookWizard.
    UIProperties.getFrameset(out);
%>
</html>
