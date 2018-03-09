<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@include file="../common/common.jsp" %>

<%@page buffer="64kb" %>

<%--
   Include our data bean. This bean wrappers the dialog XML.
--%>
<jsp:useBean id="UIProperties" scope="request" class="com.ibm.commerce.tools.common.ui.WizardBean"></jsp:useBean>
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
   // Include wizard specific javascript functions here
%>

/**
 * gotoNextPanel()
 * if the current panel does not produce a validation error this
 * function determines the next accessible panel and displays that panel
 */
function gotoNextPanel() {  
    var panel = pageArray[currPanel];

	if (waitForPageToLoad == true && isContentFrameLoaded() == false) {
		displayPanel(pageArray[currPanel]);
		return false;
	}
    
	setContentFrameLoaded(false);
	savePanelData();

    if (validatePanel() == false) {
    	return;
    }
    
	while (panel.next != null && pageArray[panel.next].access == false) {
		panel = pageArray[panel.next];
	}
	
	setPanelAttribute(panel.name, "hasTab", "YES" );

    // turn on all panels between this branching panel and the next branching panel
    if (panel.hasBranch == "YES") {
		for (tabPanel=panel; !isLastPanel(tabPanel.name); tabPanel=pageArray[tabPanel.next]) {
			setPanelAttribute(tabPanel.next, "hasTab", "YES");
			if (pageArray[tabPanel.next].hasBranch == "YES") {
				break;
			}
		}
	}		

	displayPanel(pageArray[panel.next]);
}

/**
 * gotoPrevPanel()
 * If the current panel does not produce a validation error, this
 * function determines the prev accessible panel and displays that panel
 */
function gotoPrevPanel() {  
	var panel = pageArray[currPanel];
	
	if (waitForPageToLoad == true && isContentFrameLoaded() == false) {
		displayPanel(pageArray[currPanel]);
		return false;
	}
    
    setContentFrameLoaded(false);
    savePanelData();
    
    // this special function is called when previous button action needs validation too
    if (validatePanel2() == false) {
    	return;
    }
    
    while (panel.prev != null && pageArray[panel.prev].access == false) {
		panel = pageArray[panel.prev];
	}		

	panel = pageArray[panel.prev];

	// turn on all panels between this branching panel and the next branching panel
	if (panel.hasBranch == "YES") {
		for (tabPanel=panel; !isLastPanel(tabPanel.name); tabPanel=pageArray[tabPanel.next]) {
			setPanelAttribute(tabPanel.next, "hasTab", "NO");
			if (pageArray[tabPanel.next].hasBranch == "YES") {
				break;
			}
		}
	}      

	displayPanel(panel);
}

/**
 * setPanelAccess(name,access)
 * This function accepts a panel name and access for that panel
 * and sets the access field of that panel
 */
function setPanelAccess(name,access) {
	if (pageArray[name] != null) {
		pageArray[name].access = access;
	}
}

/**
 * validatePanel()
 * This function determines if the panel in the CONTENTS frame has
 * a validateEntries function and executes it if it does.
 * If the validateEntries was not found or was successfully executed,
 * it sets the validated field of the current panel to YES and returns true
 * otherwise it returns false
 *
 * Note: this function is only called when next button is clicked
 */
function validatePanel() {  
	if (this.CONTENTS.validatePanelData && this.CONTENTS.validatePanelData() == false) {
		setContentFrameLoaded(true);
		return false;
	}
    
	pageArray[currPanel].validated = "YES";
	return true;
}

/**
 * validatePanel2()
 * This function determines if the panel in the CONTENTS frame has
 * a validateEntries function and executes it if it does.
 * If the validateEntries was not found or was successfully executed,
 * it sets the validated field of the current panel to YES and returns true
 * otherwise it returns false
 *
 * Note: this function is only called when previous button is clicked
 */
function validatePanel2() {  
	if (this.CONTENTS.validatePanelData2 && this.CONTENTS.validatePanelData2() == false) {
		setContentFrameLoaded(true);
		return false;
	}
    
	pageArray[currPanel].validated = "YES";
	return true;
}

/**
 * finish()
 * This function performs a save and validation check before actually submitting the form
 */
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

/**
 * isPrevPanel() 
 * check whether a previous  accessible panel exists
 */
function isPrevPanel() {  
	var panelIndex = pageArray[currPanel].prev;	
    var panel;
    
    while (panelIndex != null ) {
		panel = pageArray[panelIndex];	
	
		if (panel.access != false) {
			return true;
		}
		
		panelIndex = panel.prev;
	}
    
    return false;
}

/**
 * isNextPanel()
 * check whether a next  accessible panel exists
 */
function isNextPanel() {  
    var panelIndex = pageArray[currPanel].next;	
    var panel;

	if (getCurrentPanelAttribute("hasNext") == "NO") {
		return false;
	}

	while (panelIndex != null ) {
		panel = pageArray[panelIndex];	
	
		if (panel.access != false) {
			return true;
		}
		panelIndex = panel.next;
	}

    return false;
}

/**
 * getTocBackgroundImage()
 * Gets the TOC background image.
 */
function getTocBackgroundImage() {
<%
	String image = UIProperties.getXMLValue("tocBackgroundImage");
	if (image != null && !image.equals("")) { 
%>	
	var imagesrc = "<%= image %>";
<%
	}
	else {
%>
	var imagesrc = "<%= UIUtil.getWebPrefix(request) %>images/tools/toc/W_generic.jpg";
<%
	}
%>
	return imagesrc;
}	 	

/**
 * setNextBranch(nextPanelName)
 */
function setNextBranch(nextPanelName) {
	setCurrentPanelAttribute("next", nextPanelName);
	setPanelAttribute(nextPanelName, "prev", getCurrentPanelAttribute("name"));
}

/**
 * setPreviousPanel(prevPanelName)
 */
function setPreviousPanel(prevPanelName) {
	setCurrentPanelAttribute("prev", prevPanelName);
}

/**
 * isLastPanel(panelname)
 */
function isLastPanel(panelname) {
	var hasNext = getPanelAttribute(panelname, "hasNext");
	var next = getPanelAttribute(panelname, "next");

	if (hasNext == "NO" || next == null) {
		return true;
	}
	else {
		return false;
	}
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
