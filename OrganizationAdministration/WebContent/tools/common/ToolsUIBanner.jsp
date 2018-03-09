<%@page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.util.SecurityHelper" %>
<%@include file="../common/common.jsp" %>
<%
	// Get Locale
	CommandContext cc = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cc.getLocale();
	// obtain the resource bundle for workspaces
	Hashtable rbWorkspace = (Hashtable)ResourceDirectory.lookup("workspaceadmin.WorkspaceAdminNLS", locale);
	boolean isIBMidEnabled = SecurityHelper.isIBMidEnabled();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/> 
<title>Banner</title>
<script type="text/javascript" src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/URLParser.js"></script>
<script type="text/javascript">

var trail = new Array();

trail[0] = new Object();
trail[0].name = top.logout;
trail[0].location = top.logout_page;
trail[0].parameters = null;
trail[0].hidden = false;

trail[1] = new Object();
trail[1].name = top.home;
trail[1].location = top.homepage;
trail[1].action = "";
trail[1].parameters = null;
trail[1].hidden = false;

var counter = 1; // count of BCT items
var fixItems = 2; // home and logout links

var waitForCancel = true; // wait for cancelOnBCT() to come back

var waitTime = 300; // time (in seconds) to wait before showing the loading indicator.
var waitState = false; // flag to indicate it is waiting to show the loading indicator.

var showWarningUponClosing = true; 

// if no logout page defined, don't show logout link and warning message
if (top.logout_page == '') {
   showWarningUponClosing = false;
}


//***************************************************************************
//** Function: set/replace last item in the bread crumb trail (BCT)
//**     txt  - name appear in the BCT
//**     link - URL
//**     parameters (optional) - javascript object, if used, a form will be 
//**           dynamically generated and data will be submitted using form 
//**           (for NL strings parameters)
//***************************************************************************
function setbct(txt, link, parameters) {
	if (counter < 2) { // make sure don't overwrite home and logout
		counter = 2;
	}
			
	trail[counter] = new Object();
	trail[counter].name = txt;
	trail[counter].location = link;
	trail[counter].action = ""; // may need this later.
	trail[counter].model = new Object();
	trail[counter].parameters = parameters;
	trail[counter].hidden = false;

	top.showContent(trail[counter].location, trail[counter].parameters);
	showbct();
}

//***************************************************************************
//** Function: reload the last item in the bread crumb trail (BCT)
//***************************************************************************
function loadbct() {
	top.showContent(trail[counter].location, trail[counter].parameters);
	showbct();
}	


//***************************************************************************
//** Function: append an item in the bread crumb trail (BCT)
//**     txt  - name appear in the BCT
//**     link - URL
//**     parameters (optional) - javascript object, if used, a form will be 
//**           dynamically generated and data will be submitted using form 
//**           (for NL strings parameters)
//***************************************************************************
function addbct(txt, link, parameters) {
	if (txt != trail[counter].name) {
		counter++;
	}			
	setbct(txt, link, parameters);
}

//***************************************************************************
//** Function: remove the last item in the bread crumb trail (BCT)
//***************************************************************************
function removebct() {
	if (counter > 1)
		counter--;
	showbct();
}

//***************************************************************************
//** Function: go back _stepsBack_ steps in BCT 
//**           (model will be auto restored if going back to notebook/wizard/dialog)
//***************************************************************************
function goBack(stepsBack) {
	if (stepsBack == null) {
		i = 1; // default is one step back
	}
	else {
		i = stepsBack;
	}
	
	if (counter - i <= 0) {	// cannot go back anymore (have to keep logout and home state)
		return;
	}		

	counter -= i;
	top.showContent(trail[counter].location, trail[counter].parameters);
	showbct();
}

//***************************************************************************
//** Function: reset BCT to be initial state, ie "LOGOUT - HOME"
//***************************************************************************
function resetBCT() {
	counter = 1;
	showbct();
}

//***************************************************************************
//** Function: wait to close the ui center until main frame finished loading,
//**           used when user chooses to logout, have to wait for the logout 
//**           command to finish executing
//***************************************************************************
function waitToClose() {
	if (top.mccmain.document.readyState == "complete") {
<%
	if (isIBMidEnabled) {
%>
		top.mccmain.location = "<%=UIUtil.getWebPrefix(request)%>tools/common/ibmIdLogoff.html";
		window.setTimeout(ibmIdLogoffWaitToClose, 5000);
<%	}
	else {
%>
 		showWarningUponClosing=false;
		top.close();
<%	} %>
	}
	else {
		window.setTimeout(waitToClose, 500);
		showProgressIndicator(true);
	}
}

function ibmIdLogoffWaitToClose() {
	if (top.mccmain.document.readyState == "complete") {
		showWarningUponClosing = false;
		top.close();
	}
	else {
		window.setTimeout(waitToClose, 500);
		showProgressIndicator(true);
	}
}

//***************************************************************************
//** Function: wait before showing link until the _waitForCancel_
//**           is set to false by user's page. (no pause/sleep functions 
//**           available in javascript)
//***************************************************************************
function waitForCancelBack(i) {
	if (waitForCancel) {
		window.setTimeout("waitForCancelBack(" + i + ")", 500);
		return;
	}

	if (i == 0) { // logout
		var loc = trail[0].location;
		var url = new URLParser(loc);
		var pathInfo = url.getPathInfo();

		// Check if the given URL is a relative URL.
		// If yes, we will append the WebAppPath prefix to it.
		if (pathInfo != null && pathInfo.indexOf("/") != 0) {
			loc = "<%= UIUtil.getWebappPath(request) %>" + loc;
		}
<%
	if (isIBMidEnabled) {
%>
		loc += "&ibmIdLogoff=true";
<%
	}
%>
		// run logout command here
		top.mccmain.location = loc;
		waitToClose();
		return;
	}

	showLink(i);
}

//***************************************************************************
//** Function: open URL of item _i_ of BCT in the mccmain frame
//**           check and execute user page's cancelOnBCT first, 
//**           show warning message if inside notebook/wizard
//***************************************************************************
function openLink(i) {
	// check and execute content page's cancelOnBCT function if any (so that developer can put any cleanup tasks there)
	if (top.mccmain.mcccontent.cancelOnBCT) {
		if (!top.mccmain.mcccontent.cancelOnBCT()) {
			return;
		}
		showProgressIndicator(true);
		window.setTimeout("waitForCancelBack(" + i + ")", 500);
		return;
	}
	else if (top.needWarning()) {
		if (!parent.confirmDialog(top.confirm_message)) {
			return;
		}
	}

	if (i == 0) { // logout
		var loc = trail[0].location;
		var url = new URLParser(loc);
		var pathInfo = url.getPathInfo();

		// Check if the given URL is a relative URL.
		// If yes, we will append the WebAppPath prefix to it.
		if (pathInfo != null && pathInfo.indexOf("/") != 0) {
			loc = "<%= UIUtil.getWebappPath(request) %>" + loc;
		}
<%
	if (isIBMidEnabled) {
%>
		loc += "&ibmIdLogoff=true";
<%
	}
%>
		// run logout command here
		top.mccmain.location = loc;
		waitToClose();
		return;
	}

	showLink(i);
}

//***************************************************************************
//** Function: open URL of item _i_ of BCT in the mccmain frame
//***************************************************************************
function showLink(i) {
	top.showContent(trail[i].location, trail[i].parameters);

	counter = i; 
	showbct();
	eval(trail[i].action);
	waitForCancel = true;
}

//***************************************************************************
//** Function: update BCT text
//***************************************************************************
function showbct() {
	// reset bct item hidden attribute
	for (i = fixItems; i <= counter; i++) {
		trail[i].hidden = false;
	}					
	  
	drawbct();
}			   

//***************************************************************************
//** Function: adjust BCT text to fit in the area, avoid text overflow
//***************************************************************************
function adjustbct() {
	// if text overflow in bct area, hide the left most item and refresh bct string
	if (parent.mccmain.mcbct.document.getElementById("bct").offsetHeight > 25 && counter > fixItems + 1)
		for (i = fixItems; i < counter; i++)
			if (!trail[i].hidden) {
				trail[i].hidden = true;
				drawbct();
			}
}

//***************************************************************************
//** Function: writes bct text
//***************************************************************************
function drawbct() {
	var s = ""; //temp string
	
	// display current workspace task
	if (top.taskName != "") {
		if (top.taskId != "") {
		    s += '<a href="javascript:top.mccbanner.launchTaskDetails();">' + top.taskName + '&nbsp;>&nbsp;</a>';
		}
	}

	for (i = 0; i < counter; i++) {

		// don't display logout link if no logout page defined
		if (top.logout_page == '' && i == 0) {
			continue;
		}

		// use "..." for hidden items
		if (!trail[i].hidden) {
			s = s + '<a href="javascript:top.mccbanner.openLink(' + i + ');" class="breadcrumb">' + trail[i].name + '&nbsp;>&nbsp;</a>';
		}
		else if (!trail[i-1].hidden) {
			s = s + '<a class="breadcrumb">...&nbsp;>&nbsp;</a>';
		}
	}
		
	var bctDoc = getIFrameDocumentById("mcbct", parent.mccmain);
	
	if (bctDoc != null) {
		var bctDiv = bctDoc.getElementById("bct");
		if (bctDiv != null) {
			bctDiv.innerHTML = s + trail[counter].name;
			adjustbct();
		}
	}		
}

//***************************************************************************
//** Function: show/hide progress indicator
//***************************************************************************
function showProgressIndicator(flag) {
	var progressObj = parent.mccmain.document.getElementById("mcprogress");
	
	if (flag) {
		if (progressObj != null) {
			progressObj.style.left = ((getClientWidth(parent.mccmain) - progressObj.offsetWidth) / 2) + "px";	
			progressObj.style.top = ((getClientHeight(parent.mccmain) - progressObj.offsetHeight) / 2) + "px";		
			progressObj.style.zIndex = 11;
			progressObj.style.visibility = "visible";
		}
	}		
	else {
		if (progressObj != null) {
			progressObj.style.left = ((getClientWidth(parent.mccmain) - progressObj.offsetWidth) / 2) + "px";	
			progressObj.style.top = ((getClientHeight(parent.mccmain) - progressObj.offsetHeight) / 2) + "px";
			progressObj.style.zIndex = 0;
			progressObj.style.visibility = "hidden";
		}		
	}
}

function dumpbct() {
	for (i=1; i<trail.length; i++) {
		alert("bct dump\ncounter="+i+"\ntxt="+trail[i].name+"\nlink="+trail[i].location);
	}
}

function setbcttxt(txt, bctindex) {
	if (bctindex == null) {
		bctindex = counter;
	}        
	
	if (bctindex < 2 || bctindex > counter) {
	    // make sure don't go out of bounds
	    return;
	}	
	
	if (txt != null) {
	    trail[bctindex].name = txt;
	}
	
	showbct();
}

function getbcttxt(bctindex) {
	if (bctindex == null) {
		bctindex = counter;
	}   
	
	if (bctindex < 2 || bctindex > counter) {
	    // make sure don't go out of bounds
	    return "";
	}
	else {
		return trail[bctindex].name;
	}
}

//***************************************************************************
//** Function: save data to BCT's model object (each item in BCT has its own)
//**     slotName - name
//**     model    - value
//***************************************************************************
function saveData(model, slotName) {
	if (counter < 2) { // make sure don't overwrite home and logout
		return;
	}		
	trail[counter].model[slotName] = model;
}

//***************************************************************************
//** Function: get data back from BCT's model object
//**     slotName  - name
//**     stepsBack - default is 0 (current item)
//***************************************************************************
function getData(slotName,stepsBack) 
{
    if (stepsBack == null) {
		stepsBack = 0;
	}

	if (counter-stepsBack < 2) { // home and logout
		return null;
	}
	
	if (slotName == "model" && trail[counter-stepsBack].model[slotName] == null) {
		return (new Object());
	}
			
	return trail[counter-stepsBack].model[slotName];
}

//***************************************************************************
//** Function: set the returning panel name during wizard chaining
//***************************************************************************
function setReturningPanel(panelName) {
	var index = trail[counter].location.indexOf("startingPage=");
	
	if (index >= 0) { // replacing starting page
		var firstPart = trail[counter].location.substring(0, index + 13); // "startingPage=".length() == 13
		var lastPart = trail[counter].location.substring(index);
		var lastIndex = lastPart.indexOf("&");	
		if(lastIndex > 0) lastPart = lastPart.substring(lastIndex); // there is any other parameters
		else lastPart = "";					    // nothing left
		trail[counter].location = firstPart + panelName + lastPart; // the starting page replaced
	} 
	else if (trail[counter].location.indexOf("?") > 0) { // adding starting page as additional parameter
		trail[counter].location = trail[counter].location + "&startingPage=" + panelName;
	}
	else {	// starting page is the first paramter
		trail[counter].location = trail[counter].location + "?startingPage=" + panelName;
	}
}
		
//***************************************************************************
//** Function: save data in back item's model object
//**     slotName - name
//**     model    - value
//**     stepsBack - default is 1 (previous item)
//***************************************************************************
function sendBackData(data, slotName,stepsBack) {
	if (stepsBack == null) {
		stepsBack = 1;
	}
	if (counter <= 2) {
		return;
	}
	trail[counter-stepsBack].model[slotName] = data;
}

//***************************************************************************
//** Function: show storeLanguageSelection page in content frame
//***************************************************************************
function selectStore() {
	if (top.choose_store_link == "" || top.choose_store_link == null) {
		return;
	}
	
	if (top.needWarning()) {
		if (!parent.confirmDialog(top.confirm_message)) {
			return;
		}
	}
	
	// check if there are any preview window opened and show a warning
	if (top.previewWindowOpened()) {
		if (!parent.confirmDialog(top.confirm_message_preview)) {
			return;
		}
	}

	top.resetBCT();
	showWarningUponClosing = false;
	top.closeChildWindows();
	top.showContent(top.choose_store_link);
}

//***************************************************************************
//** Function: write/update title in banner frame
//***************************************************************************
function writeBannerTitle(t) {
	var s = "";
	var storeNameObj = document.getElementById("storeName");
	
	if (storeNameObj == null) {
		return;
	}

	if (t == "" || t == null || t == "undefined") {	// no banner title defined, use fulfillment center name, store name and language as default
		if (top.ffmName != "")  { // fulfillment center name
			s = top.ffmName + "&nbsp;-&nbsp;";
		}
		s = s + top.store_name;
		s = s + "&nbsp;-&nbsp;";
		s = s + top.language;
		storeNameObj.innerHTML = s;
	}
	else {
		storeNameObj.innerHTML = t;
	}
}

//***************************************************************************
//** Function: Launch the current task details
//***************************************************************************
function launchTaskDetails() {

	var	param= new Object();
		param["XMLFile"]="workspaceadmin.TaskDetailsDialog";
		param["redirectURL"]=top.getWebPath() + "DialogView";
		param["taskgroupId"]=top.taskGroupId;
		param["taskId"]=top.taskId;
		
   	   	top.setContent("<%=UIUtil.toJavaScript(rbWorkspace.get("taskDetailsBCT"))%>", top.getWebPath() + "DialogView", true, param);
}
</script>
</head>

<body bgcolor="yellow" onmouseover="if (top.mccmain && top.mccmain.hideall) top.mccmain.hideall();">
<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tbody>
		<tr>
			<td bgcolor="#BC6C0D"><img alt="" border="0" width="100%" height="5" src="<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/orange_stripe.gif"/></td>
		</tr>	
		<tr>
			<td bgcolor="#FFFFFF"><img alt="" border="0" width="100%" height="1" src="<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/white_stripe.gif"/></td>
		</tr>
		<tr>
			<td>
				<table border="0" bgcolor="#552BA1" width="100%" cellpadding="0" cellspacing="0" style="background-image: url('<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/dropdwn_bk.gif'); background-repeat: repeat;">
					<tbody>
						<tr>
							<td style="padding-left: 23px;">
								<table border="0" cellpadding="0" cellspacing="0" style="height: 23px; background-color: #4D2698;">
									<tbody>
										<tr>
												<script type="text/javascript">
        											if (top.choose_store_link != null && top.choose_store_link != "") {
														document.writeln('<td align="center" valign="middle" style="border-style: solid; border-top-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-right-width: 0px; border-color: #9470BF;">');
														document.writeln('<button onclick="selectStore();" style="font-size: 10pt;">' + top.select_button + ' <img alt="" src="<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/select_button_arrow.gif"/></button></td>');
		        									}
												</script>
											<td class="store" id="storeName"></td>
										</tr>
									</tbody>
								</table>
							</td>		
							<td width="1"><img alt="" border="0" width="1" height="33" src="<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/white_stripe_v.gif"/></td>
							<td width="360"><img alt="" border="0" width="361" height="33" src="<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/mosaic.jpg"/></td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td bgcolor="#FFFFFF"><img alt="" border="0" width="100%" height="1" src="<%= UIUtil.getWebPrefix(request) %>images/tools/mcc/white_stripe.gif"/></td>		
		</tr>
	</tbody>
</table>
<script type="text/javascript">
	writeBannerTitle(top.banner_title);
</script>

</body>
</html>