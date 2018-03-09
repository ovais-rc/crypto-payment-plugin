<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.datatype.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>

<%@include file="../common/common.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
<jsp:useBean id="mc" scope="request" class="com.ibm.commerce.tools.common.ui.MerchantCenterBean"></jsp:useBean>
<%
	// Get Locale
	CommandContext cc = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cc.getLocale();

	// Initialize our bean.  
	mc.setCommandContext((CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT));
	mc.setRequestProperties((TypedProperty)request.getAttribute(ECConstants.EC_REQUESTPROPERTIES));
	
	// obtain the resource bundle for calendar
	Hashtable calendarNLS = (Hashtable) ResourceDirectory.lookup("common.calendarNLS", locale);
	
	JSPHelper jspHelper = new JSPHelper(request);
	String gotoMenuPath = jspHelper.getParameter("gotoMenuPath");
	
	if (gotoMenuPath == null) {
		gotoMenuPath = "";
	}

%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<title> <%= mc.getResourceString("title") %> - <%= cc.getUser().getDisplayName() %></title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/> 
<script type="text/javascript" src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/URLParser.js"></script>

<%@include file="NumberFormat.jsp" %>

<script type="text/javascript">

// Determine if MerchantCenter is launched.
var urlObj = new URLParser(document.URL);
var viewName = urlObj.getPathInfo();
var inMerchantCenter = (viewName.indexOf("/MerchantCenterView") != -1)?(true):(false);
var isCustomFrameset = (urlObj.getParameterValue("customFrameset"))?(true):(false);
var showStoreSelection = (urlObj.getParameterValue("showStoreSelection"))?(true):(false);
var noLogout = (urlObj.getParameterValue("noLogout"))?(true):(false);

// Your role(s) are: <%= mc.getRole() %>.

var homepage = '<%= mc.getXMLValue("homepage") %>';
var logout_page = (isCustomFrameset || noLogout)?(''):('<%= mc.getXMLValue("logoutPage") %>');
var startpos = <%= mc.getXMLValue("startPos") %>;
var space = <%= mc.getXMLValue("space") %>;
var arrow  = '<%= mc.getXMLValue("arrowGif") %>';

var choose_store_link = '<%= mc.getXMLValue("storeSelectionPage") %>';
var store_image = '<%= mc.getXMLValue("storeGif") %>';

// environment information

var ffmId = '<%= UIUtil.toJavaScript(mc.getFfmId()) %>';
var ffmName = '<%= UIUtil.toHTML(UIUtil.toJavaScript(mc.getFfmName())) %>';
var storeId = '<%= mc.getStoreId() %>';
var langId = '<%= mc.getLangId() %>';
var store_name = '<%= UIUtil.toJavaScript(mc.getStoreName()) %>';
var language = '<%= UIUtil.toJavaScript(mc.getLanguage()) %>';
var storeType = '<%= mc.getStoreType() %>';
var taskId = '<%= mc.getTaskId() %>';
var taskGroupId = '<%= mc.getTaskGroupId() %>';
var taskName = '<%= mc.getTaskName() %>';
var m_wndTaskDetails=null;
var gotoMenuPath = '<%= UIUtil.toJavaScript(gotoMenuPath) %>';

// NLV strings, from resource bundle

var title = '<%= UIUtil.toJavaScript(mc.getResourceString("title")) %>';
var home = '<%= UIUtil.toJavaScript(mc.getResourceString("home")) %>';
var logout = '<%= UIUtil.toJavaScript(mc.getResourceString("logout")) %>';
var banner_title = '<%= UIUtil.toJavaScript(mc.getResourceString(mc.getXMLValue("bannerTitle"))) %>';
var store_img_alt = '<%= UIUtil.toJavaScript(mc.getResourceString("storeImgAltText")) %>';
var indicator_img_alt = '<%= UIUtil.toJavaScript(mc.getResourceString("indicatorAltText")) %>';
var select_button = '<%= UIUtil.toJavaScript(mc.getResourceString("select")) %>';
var confirm_message = '<%= UIUtil.toJavaScript(mc.getResourceString("confirm")) %>';
var confirm_message2 = '<%= UIUtil.toJavaScript(mc.getResourceString("confirmLogout")) %>';
var confirm_message_preview = '<%= UIUtil.toJavaScript(mc.getResourceString("confirmPreviewClosing")) %>';
var closewindow_warning = '<%= UIUtil.toJavaScript(mc.getResourceString("closeWindow")) %>';
var progress_message = '<%= UIUtil.toJavaScript(mc.getResourceString("progress_message")) %>';

var contentFrameTitle = '<%= UIUtil.toJavaScript(mc.getResourceString("contentFrame")) %>';
var submenuFrameTitle = '<%= UIUtil.toJavaScript(mc.getResourceString("submenuFrame")) %>';
var pbFrameTitle = '<%= UIUtil.toJavaScript(mc.getResourceString("pbFrame")) %>';
var bctFrameTitle = '<%= UIUtil.toJavaScript(mc.getResourceString("bctFrame")) %>';
var blankFrameTitle = '<%= UIUtil.toJavaScript(mc.getResourceString("blankFrame")) %>';
var calendarTitle = '<%=  UIUtil.toJavaScript(calendarNLS.get("calendarTitle")) %>';

// NL-Dialogs button lables
var okLabel = '<%= UIUtil.toJavaScript(mc.getResourceString("ok")) %>';
var cancelLabel = '<%= UIUtil.toJavaScript(mc.getResourceString("cancel")) %>';
var yesLabel = '<%= UIUtil.toJavaScript(mc.getResourceString("yes")) %>';
var noLabel = '<%= UIUtil.toJavaScript(mc.getResourceString("no")) %>';
// keeps track of child windows
var childWindowArray = new Array();

// DynamicList Table
var dlSelectDeselectAll = '<%= UIUtil.toJavaScript(mc.getResourceString("dlSelectDeselectAll")) %>';
var dlSelectRow = '<%= UIUtil.toJavaScript(mc.getResourceString("dlSelectRow")) %>';

// web prefix for static and dynamic files
var webPrefix = "<%= UIUtil.getWebPrefix(request) %>";
var webappPath = "<%= UIUtil.getWebappPath(request) %>";

<%--
   Populate javascript Help array
  --%>
<%
   mc.getHelp("help", out);
%>


<%--
   Populate javascript Menu array
  --%>
<%
   mc.getMenu("menu", out);
%>

var pdata = new Object();  // a "model" like object to hold temporary data, persistant through out CSA

//***************************************************************************
//**
//** Return the value of the given key from our data model
//**
//***************************************************************************
function get(key, defaultValue) {
	if (pdata[key] == null) {
		return defaultValue;
	}
	else {
    		return pdata[key];
    	}
}

//***************************************************************************
//**
//** Remove the given key from our model
//**
//***************************************************************************
function remove(key) {
	pdata[key] = null;
}

//***************************************************************************
//**
//** Store the given (key,value) in our data model
//**
//***************************************************************************
function put(key, value) {
	pdata[key] = value;
}

//***************************************************************************
//** Function: open help window (same as user clicks HELP link)
//***************************************************************************
function openHelp() {
	var helpkey;

	try {
		if (mccmain.mcccontent.getHelp) {
			helpkey = mccmain.mcccontent.getHelp();
		}
		else if (mccbanner.counter > 1) { // not "home" state
         		helpkey = mccmain.activeHelpKey;
         	}
	} 
	catch (e) { // if "access denided" accessing content URL, look for the "helpkey" under menu
		if (mccbanner.counter > 1) {
			helpkey = mccmain.activeHelpKey;
		}
	}

	if (helpkey == null || helpkey == "") {
		helpkey = default_help;
	}
	
 	var hwin = window.open("<%= WcsApp.configProperties.getValue("Websphere/HelpServerProtocol", "http") + "://" + WcsApp.configProperties.getValue("Websphere/HelpServerHostName")%>" + help_base + help[helpkey], "Help", "width=700,height=450,toolbar=no,resizable=yes,scrollbars=yes,menubar=yes,copyhistory=no");

 	hwin.focus();
}

//***************************************************************************
//** Function: reset content frame's URL
//**     loc - URL
//**     parameters (optional) - javascript object, if used, a form will be
//**           dynamically generated and data will be submitted using form
//**           (for NL strings parameters)
//***************************************************************************
function showContent(loc, parameters) {
	var url = new URLParser(loc);
	var pathInfo = url.getPathInfo();

	// turn on progress indicator, it'll be turned off after content page is loaded (code in ToolsUIMain.jsp/html)
	showProgressIndicator(true);
	
	// Check if the given URL is a relative URL.
	// If yes, we will append the WebAppPath prefix to it.
	if (pathInfo != null && pathInfo.indexOf("/") != 0) {
		loc = getWebappPath() + loc;
	}
		
	if (parameters == null || parameters == undefined) {
		mccmain.mcccontent.location = loc;
		return;
	}
	
	mccmain.submitForm(loc, parameters);
}

//***************************************************************************
//** Function: (re)set home for the UI center window
//***************************************************************************
function setHome() {
	mccbanner.resetBCT();
	showContent(homepage);
}

//***************************************************************************
//** Function: set content frame URL and update bread crumb trail (BCT)
//**     txt  - name appear in the BCT
//**     link - URL
//**     newtrail - boolean.
//**           if true, a new item will be appended to the end of BCT
//**           if false, last item in BCT will be replace with current one
//**     parameters (optional) - javascript object, if used, a form will be
//**           dynamically generated and data will be submitted using form
//**           (for NL strings parameters)
//***************************************************************************
function setContent(txt, link, newtrail, parameters) {
	if (newtrail == true) {
		mccbanner.addbct(txt, link, parameters);		
	}
	else {
		mccbanner.setbct(txt, link, parameters);
	}
}

//***************************************************************************
//** Function: go back _stepsBack_ steps in BCT
//**           (model will be auto restored if going back to notebook/wizard/dialog)
//***************************************************************************
function goBack(stepsBack) {
	mccbanner.goBack(stepsBack);
}

//***************************************************************************
//** Function: reset BCT to be initial state, ie "LOGOUT - HOME"
//***************************************************************************
function resetBCT() {
	if (mccbanner && mccbanner.resetBCT) {
		mccbanner.resetBCT();
	}
}

//***************************************************************************
//** Function: update BCT text
//***************************************************************************
function refreshBCT() {
	if (mccbanner && mccbanner.showbct) {
		mccbanner.showbct();
	}
}

//***************************************************************************
//** Function: save data to BCT's model object (each item in BCT has its own)
//**     slotName - name
//**     model    - value
//***************************************************************************
function saveData(model, slotName) {
	mccbanner.saveData(model, slotName);
}

//***************************************************************************
//** Function: get data back from BCT's model object
//**     slotName  - name
//**     stepsBack - default is 0 (current item)
//***************************************************************************
function getData(slotName,stepsBack) {
	return mccbanner.getData(slotName,stepsBack);
}

//***************************************************************************
//** Function: convenient function to save notebook/wizard model to "model" slot
//***************************************************************************
function saveModel(model) {
	mccbanner.saveData(model, "model");
}

//***************************************************************************
//** Function: convenient function to get back "model" object
//***************************************************************************
function getModel(stepsBack) {
	return mccbanner.getData("model",stepsBack);
}

//***************************************************************************
//** Function: set the returning panel name during wizard chaining
//***************************************************************************
function setReturningPanel(panelName) {
	mccbanner.setReturningPanel(panelName);
}

//***************************************************************************
//** Function: save data in back item's model object
//**     slotName - name
//**     model    - value
//**     stepsBack - default is 1 (previous item)
//***************************************************************************
function sendBackData(data, slotName,stepsBack) {
	mccbanner.sendBackData(data, slotName,stepsBack);
}

//***************************************************************************
//** Function: write/update title in banner frame
//***************************************************************************
function writeBannerTitle(t) {
	mccbanner.writeBannerTitle(t);
}

//***************************************************************************
//** Function: if inside notebook or wizard, a warning message is needed when
//**           user chooses to leave by clicking on a link in BCT
//***************************************************************************
function needWarning() {
	if (mccmain.mcccontent && mccmain.mcccontent.warningOnClose) {
		return mccmain.mcccontent.warningOnClose();
	}
	else {
		return false;
	}
}

//***************************************************************************
//** Function: used to hide combo list box in content frame (menu gets hidden otherwise)
//***************************************************************************
function visibleList(s) {
	if (mccmain && mccmain.visibleList) {
		mccmain.visibleList(s);
	}
}

//***************************************************************************
//** Function: show/hide progress indicator
//***************************************************************************
function showProgressIndicator(flag) {
	if (mccbanner && mccbanner.showProgressIndicator) {
		mccbanner.showProgressIndicator(flag);
	}
}

//***************************************************************************
//** Function: show warning message if user closes CSA without logging out
//***************************************************************************
function beforeExit() {
	if (top.mccbanner && top.mccbanner.showWarningUponClosing && logout_page != '') {
		alertDialog(closewindow_warning);
	}

	closeChildWindows();
}

//***************************************************************************
//** Function: get locale dependent CSS file name
//***************************************************************************
function getCSSFile() {
	return "<%= UIUtil.getCSSFile(locale) %>";
}

//***************************************************************************
//** Function: dynamically show/hide menu
//***************************************************************************
function menuVisible(index, flag) {
	if (mccmenu && mccmenu.menuVisible) {
		mccmenu.menuVisible(index, flag);
	}
}

//****************************************
//* get the current webpath - DEPRECATED *
//****************************************
function getWebPath() {
	var path = location.pathname;

	for (var x=path.length-1; x>=0; x--) {
		if (path.charAt(x)=="/") {
			return location.protocol + "//" + location.host + path.substr(0,x+1);
		}
	}
}

//****************************************
//* web prefix for static files, for example, "/wcs/"
//****************************************
function getWebPrefix() {
	return webPrefix;
}

//****************************************
//* webapp path prefix for view/controller commands, for example, "/webapp/wcs/tools/servlet"
//****************************************
function getWebappPath() {
	return webappPath;
}

//*****************************************
//* Open and keep track of a child window *
//* Windows opened in this fashion will be closed when user logs out (or presses X) *
//*****************************************
function openChildWindow( URL, windowTitle, attributes) {
	var childWindow = window.open(URL,windowTitle, attributes);
	childWindowArray[childWindowArray.length]=childWindow;
	childWindow.focus();
	return childWindow;
}

//*********************************************
// Closes anything that openChildWindow opened
//*********************************************
function closeChildWindows() {
	for (var i=0; i<childWindowArray.length; i++) {
		childWindowArray[i].close();
	}
}

//*********************************************
// Returns true if a preview chid window is opened
//*********************************************
function previewWindowOpened() {
	for (var i=0; i<childWindowArray.length; i++) {
		if (!childWindowArray[i].closed && childWindowArray[i].name == "Preview_Window") {
			return true;
		};
	}
	return false;
}

//*********************************************
// Replace the mcc top content frame.
// Only works when mcc is wrapped with another
// frameset.
//*********************************************
function replaceMCCTop(url) {
	if (!document.getElementById("mcctop")) {
		if (needWarning()) {
			if (!confirmDialog(confirm_message)) {
				return;
			}
		}

		if (document.getElementsByName("mccbanner")[0].parentNode.parentNode) {
			// Destroy the parent frameset element.
			var mccFramesetNode = document.getElementsByName("mccbanner")[0].parentNode.parentNode;
			var mcctopNode = document.getElementsByName("mccbanner")[0].parentNode;
			mccFramesetNode.removeChild(mcctopNode);

			// Prepare and append a new frame element to parent parent frameset element.
			var newFrameNode = document.createElement("FRAME");
			newFrameNode.id = "mcctop";
			newFrameNode.name = "mcctop";
			newFrameNode.src = url;
			mccFramesetNode.appendChild(newFrameNode);
		}
	}
	else {
		top.mcctop.location = url;
	}
}

</script>

</head>

<%--
   Create the frameset
--%>

<%
    mc.getFrameset(out);
%>

</html>
