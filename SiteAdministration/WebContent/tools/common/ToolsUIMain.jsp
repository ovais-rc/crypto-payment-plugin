<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@include file="../common/common.jsp" %>
<%
	// Get Locale
	CommandContext cc = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cc.getLocale();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<style type="text/css">

html,body { height: 100%; margin: 0 0 0 0; }

</style>
<script type="text/javascript" src="<%=  UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script type="text/javascript">

var menu = parent.menu;
var arrow = parent.arrow;

var activeMenu = -1; // current active menu index
var activeNode = -1; // current active node index
var activeHelpKey;   // current node's helpkey, if defined
var menuFrameSrc = new Array();
var submenuFrameSrc = new Object();
var enableGotoMenuPath = true;
var subMenuLevel = 0;
var menuPosTop = new Array();
var menuOffsetTop = 8;
var subMenuOverlapLeft = -8;
var counter = 0; // used for gotoMenu() to avoid loading forever

var defaultClientWidth = document.documentElement.clientWidth;
var defaultClientHeight = document.documentElement.clientHeight;

//***************************************************************************
//** show/hide menu layer
//**
//**
//***************************************************************************
function menuvis(num, vis) {
	var menuObjDoc, menuDiv, menuWidth, menuHeight;
	var menuFrameObj = document.getElementById("mcsubmenu0");	
	var offsetW = (isIE)?(1):(0);
	var offsetH = (isIE)?(0):(1); 	

	// "hidden" already handled in hideall()
	if (vis == "visible") { 		
 		if (top.mccmenu && top.mccmenu.highlight) {
 			top.mccmenu.highlight(num);
 		}
 	
		menuFrameObj = document.getElementById("mcsubmenu");
		menuFrameObj.style.width = "100%";
		
		menuObjDoc = getIFrameDocumentById("mcsubmenu0");
		menuObjDoc.body.innerHTML = menuFrameSrc[num].src;
		menuDiv = menuObjDoc.getElementById("menu");
		
		menuWidth = menuDiv.offsetWidth;
		menuHeight = menuDiv.offsetHeight;
  
		menuFrameObj.style.width = parseInt(menuWidth) + offsetW + "px";
		menuFrameObj.style.height = parseInt(menuHeight) + offsetH + "px";	
		menuFrameObj.style.left = menu[num].startpos -1 +"px";
		menuFrameObj.style.visibility = vis;
		menuFrameObj.contentWindow.focus();
	}
	else {
 		if (top.mccmenu && top.mccmenu.noHighlight) {
 			top.mccmenu.noHighlight(num);
 		}
	
		menuFrameObj.style.visibility = vis;
	}
}

function setPosTop(level, pos) {
	menuPosTop[level] = pos;
}

function setHighlight(obj, vis) {
	if (vis == "on") {
		obj.style.backgroundColor = "#EDAC40";
	}
	else {
		obj.style.backgroundColor = "#E0E0E0";
	}
}

function submenuvis(menuIndex, vis) {
	var levels = menuIndex.split(".");
	var menuLevel = levels[0];
	var levelDepth = levels.length - 1;

	var menuObjDoc, menuDiv, menuWidth, menuHeight;
	var menuFrameObj = document.getElementById("mcsubmenu" + levelDepth);	
	var offsetW = (isIE)?(0):(0);
	var offsetH = (isIE)?(0):(1);

	// "hidden" already handled in hideall()
	if (vis == "visible") {
		menuFrameObj = document.getElementById("mcsubmenu" + levelDepth);
		menuFrameObj.style.width = "100%";
		
		menuObjDoc = getIFrameDocumentById("mcsubmenu" + levelDepth);		
	
		var posLeft = menu[levels[0]].startpos - 1;
	
		for (var i = 0; i < levelDepth; i++) {
			posLeft += document.getElementById("mcsubmenu" + i).offsetWidth + subMenuOverlapLeft;
		}
		
		var posTop = 0;

		for (var i = levelDepth; i >= 0; i--) {
			if (typeof(menuPosTop[i]) != "undefined") {
				posTop += menuPosTop[i];
			}
		}
		
		menuObjDoc.body.innerHTML = submenuFrameSrc[menuIndex].src;
		menuDiv = menuObjDoc.getElementById("menu");
		
		menuWidth = menuDiv.offsetWidth;
		menuHeight = menuDiv.offsetHeight;
  
		menuFrameObj.style.width = parseInt(menuWidth) + offsetW + "px";
		menuFrameObj.style.height = parseInt(menuHeight) + offsetH + "px";	
		menuFrameObj.style.left = posLeft + "px";
		menuFrameObj.style.top = posTop + menuOffsetTop + "px";
		menuFrameObj.style.visibility = vis;
		menuFrameObj.contentWindow.focus();
	}
	else {
		menuFrameObj.style.visibility = vis;
	}
}


//***************************************************************************
//** hide all menu layers
//**
//**
//***************************************************************************
function hideall() {

	for (var i = 0; i < menu.length; i++) {
		if (menu[i].type == "help")
			continue;
		menuvis(i, "hidden");
	}
	
	for (var j = 1; j <= subMenuLevel; j++) {
		hidesubmenu(j);
	}
	
	if (top.mccmenu) {
		top.mccmenu.menuShowed = false;
	}
	
	top.visibleList("visible");	
}

function hidesubmenu(level) {
	for (var i = level; i <= subMenuLevel; i++) {	
		var subMenuObj = document.getElementById("mcsubmenu" + i);
			
		if (subMenuObj != null) {
			subMenuObj.style.visibility = "hidden";
		}
	}
}

//***************************************************************************
//** wait before showing link until the _waitForCancel_ is set to false by
//** user's page. (no pause/sleep functions available in javascript)
//**
//***************************************************************************
function waitForCancelBack(menuIndex) {
	if (top.mccbanner.waitForCancel) {
		window.setTimeout("waitForCancelBack('" + menuIndex + "')", 500);
		return;
	}
	var levels = menuIndex.split(".");
	activeMenu = levels[0];
	activeHelpKey = activeNode.helpkey;
	if (!activeNode.keepBCT) {
		top.resetBCT();
	}
	top.setContent(activeNode.name, activeNode.url, true);
}

//***************************************************************************
//** launch menu node and update bread crumb trail
//**
//**
//***************************************************************************
function writebct(menuIndex) {
	var levels = menuIndex.split(".");
	var menuLevel = levels[0];
	var levelDepth = levels.length - 1;

	if (top.menu && top.menu[menuLevel] && top.menu[menuLevel].node) {
		activeNode = top.menu[menuLevel];
	
		for (var i = 1; i <= levelDepth; i++) {
			if (activeNode.node[levels[i]]) {
				activeNode = activeNode.node[levels[i]];
			}
		}
	}
	
	hideall();

	// check and execute content page's cancelOnBCT function if any (so that developer can put any cleanup tasks there)
	if (mcccontent.cancelOnBCT) {
		if (!mcccontent.cancelOnBCT()) {
			return;
		}
		top.showProgressIndicator(true);
		window.setTimeout("waitForCancelBack('" + menuIndex + "')", 500);
		return;
	}
	else if (top.needWarning()) {
		if (!parent.confirmDialog(top.confirm_message)) {
			return;
		}
	}

	activeMenu = levels[0];
	activeHelpKey = activeNode.helpkey;

	if (!activeNode.keepBCT) {
		top.resetBCT();
	}

	top.setContent(activeNode.name, activeNode.url, true);
}


//***************************************************************************
//** show/hide arrow (inside menu layer)
//**
//**
//***************************************************************************
function arrowvis(name, vis) {
	var menuObjDoc = getIFrameDocumentById("mcsubmenu");
}


function writeMenus() {
	var i, j;

	for (i = 0; i < menu.length; i++) {
		if (menu[i].type == "help") {
			continue;
		}
		menuFrameSrc[i] = writeNodes(new String(i), menu[i]);
	}
}

//***************************************************************************
//** write menu layers recursively
//***************************************************************************
function writeNodes(menuIndex, menuObj) {
	var levels = menuIndex.split(".");
	var levelDepth = levels.length;

	var menuSrc = new Object();
	menuSrc.src = "";
	menuSrc.src += '<div id="menu" class="submenu">';
	menuSrc.src += '<table border="0" cellpadding="0" cellspacing="0" nowrap="true">';
					
	var cflag = false; // no submenu has been rendered yet
	
	for (var j = 0; j < menuObj.node.length; j++) {
		// a separate line
		if (menuObj.node[j].url == "" ) {
			// if first item is a separator line, ignore it
			if (cflag == false) {
				continue;
			}

			// if last item is a separator line, ignore it
			if (j == menuObj.node.length - 1) {
				continue;
			}

			// if next item is a separator line, ignore it	
			if (menuObj.node[j+1].url == "" ) {
				continue;
			}
		}
		cflag = true;

		if (menuObj.node[j].url == "") {
			menuSrc.src += '<tr onmouseover="parent.hidesubmenu(' + levelDepth + ');">';
		}
		else if (menuObj.node[j].type == "menu") {
			menuSrc.src += '<tr style="cursor: hand;" onmouseover="parent.hidesubmenu(' + levelDepth + '); parent.setHighlight(this, \'on\'); parent.setPosTop(' + levelDepth + ', this.offsetTop); parent.submenuvis(\'' + menuIndex + '.' + j + '\', \'visible\');" onmouseout="parent.setHighlight(this, \'off\');" onclick="javascript:void(0);">';
		}
		else {			
			menuSrc.src += '<tr style="cursor: hand;" onmouseover="parent.hidesubmenu(' + levelDepth + '); parent.setHighlight(this, \'on\');" onmouseout="parent.setHighlight(this, \'off\');" onclick="javascript:parent.writebct(\'' + menuIndex + '.' + j + '\');">';
		}
		
		if (menuObj.node[j].url == "") {
			menuSrc.src += '<td colspan="2">';
			menuSrc.src += '<div><hr class="separator" size="1"/></div>';				
		}
		else if (menuObj.node[j].type == "menu") {
			menuSrc.src += '<td>';
			menuSrc.src += '<div>';
			menuSrc.src += '<a href="javascript:void(0);" onclick="parent.hidesubmenu(' + levelDepth + '); parent.setPosTop(' + levelDepth + ', this.parentNode.parentNode.parentNode.offsetTop); parent.submenuvis(\'' + menuIndex + '.' + j + '\', \'visible\'); event.cancelBubble = true;">';
			menuSrc.src += menuObj.node[j].name + ' &nbsp;</a></div>';
			menuSrc.src += '<td width="20" align="center" valign="middle"><img alt="" src="' + top.getWebPrefix() + 'images/tools/mcc/arrow.gif"/>';
			
			submenuFrameSrc[menuIndex + '.' + j] = writeNodes(menuIndex + '.' + j, menuObj.node[j]);
			computeSubMenuLevel(menuIndex + '.' + j);
		}
		else {               
			menuSrc.src += '<td>';
			menuSrc.src += '<div>';
			menuSrc.src += '<a href="javascript:parent.writebct(\'' + menuIndex + '.' + j + '\');" onclick="event.cancelBubble = true;">';
			menuSrc.src += menuObj.node[j].name + ' &nbsp;</a></div>';
			menuSrc.src += '</td>';
			menuSrc.src += '<td>';				
		}
		
		menuSrc.src += '</td></tr>';
	}
	
	menuSrc.src += '</table>';
	menuSrc.src += '</div>';

	return menuSrc;
}

function computeSubMenuLevel(nodeLevel) {
	var level = nodeLevel.split(".");
	
	if (level.length > subMenuLevel) {
		subMenuLevel++;
	}
}

//***************************************************************************
//** use form to submite URL, which may contain NL strings.
//**
//**
//***************************************************************************
function submitForm(loc, parameters, target) {
	var form1 = document.mainForm;

	form1.action=loc;

	if (parameters == null || parameters == undefined) {
		// if no parameters passed in, just do nothing
	}
	else {
		// remove old input fields first
		if (form1.hasChildNodes()) {
			for (i = form1.childNodes.length - 1; i >= 0 ; i--) {
				form1.removeChild(form1.childNodes[i]);
			}
		}

		// add input fields from the hashtable
		for (var i in parameters) {
			var input = document.createElement("INPUT");
			input.setAttribute("type", "hidden");
			input.setAttribute("name", i);
			input.setAttribute("value", parameters[i]);
			form1.appendChild(input);
		}

		// default target window/frame is mcccontent
		if (target == null || target == undefined) {
			form1.target="mcccontent";
		}
		else {
			form1.target=target;
		}			
	}
	form1.submit();
}

//***************************************************************************
//** show/hide progress indicator depending on frame loading status
//** (blank pages are not considerred to be finished)
//**
//***************************************************************************
function loadingStatus() {
	try {
		if (mcccontent.document.readyState=="complete" &&
		    mcccontent.document.location.pathname.indexOf("blank.html") < 0 &&
		    mcccontent.document.location.pathname.indexOf("about:blank") < 0 ) {
			top.showProgressIndicator(false);
		}
		else {
			top.showProgressIndicator(true);
		}
	}
	catch (e) {  // "access denied" exception when accessing external site
		top.showProgressIndicator(false);
	}
}

//***************************************************************************
//** show/hide any combo and drop-down list in content frame,
//** which are always on top of menu (bug in IE)
//**
//***************************************************************************
function visibleList(s) {
	try {
		if (mcccontent.visibleList) {
			mcccontent.visibleList(s);
		}
		else if (mcccontent.document.forms[0]) {
			for (var i = 0; i < mcccontent.document.forms[0].elements.length; i++) {
				if (mcccontent.document.forms[0].elements[i].type.substring(0,6) == "select") {
					mcccontent.document.forms[0].elements[i].style.visibility = s;
				}
			}
		}
	}
	catch (e) {}
}

writeMenus();

window.onerror=errorTrap;


//***************************************************************************
//** catch errors to prevent javascript errors being shown
//***************************************************************************
function errorTrap(sMsg,sUrl,sLine){
	top.mccbanner.showProgressIndicator(false);
	s="Gotcha!! Javascript error!!!\n\n";
	s+="Error: " + sMsg;
	s+="Line: " + sLine + "\n";
	s+="URL: " + sUrl + "\n\n";
	// alert(s);
	return false;
}

function drawProgressIndicator() {
	var progressObjDoc = getIFrameDocumentById("mcprogress");
	
	var source = '<div class="blackBorder"><table border="0" width="100%" cellspacing="0" cellpadding="2" style="height: 98%;">';
	source += '<tbody>';
	source += '<tr><td class="waitText" align="center" valign="bottom">';
	source += parent.progress_message;
	source += '</td></tr>';
	source += '<tr><td align="center" valign="top">';
	source += '<img alt="' + parent.progress_message + '" border="1" style="padding: 5px;" width="316" height="16" src="' + top.getWebPrefix() + 'images/tools/mcc/progress.gif"/>';
	source += '</td></tr>';
	source += '</tbody>';
	source += '</table></div>';
	
	progressObjDoc.body.style.backgroundColor = "#FFFFFF";
	progressObjDoc.body.innerHTML = source;
}

function gotoMenu() {
	if (counter > 20) {
		// alert the loading is not good due to other reasons
		// right now let the problem occur if objects are not loaded
	}

	if (!top.mccbanner.addbct) {
		counter++;
		setTimeout("gotoMenu();", 100);
		return;
	}
	
	if (top.gotoMenuPath && top.gotoMenuPath != "") {
		var path = top.gotoMenuPath.split("/");
		var menus = null;
		var node = null;
		
		for (var i = 0; i < path.length; i++) {
			if (i == 0) {
				menus = findMenu(top.menu, path[i]);	
			}
			else {
				node = findNode(menus.node, path[i]);
			}
		}
		
		if (node != null) {
			top.setContent(node.name, node.url, true, null);
			top.gotoMenuPath = "";
		}
	}
}

function findMenu(menus, id) {
	if (menus != null) {
		for (var i = 0; i < menus.length; i++) {
			if (menus[i].type && menus[i].type == "menu" && menus[i].id == id) {
				return menus[i];
			}
		}
	}
	return null;
}

function findNode(nodes, id) {
	if (nodes != null) {
		for (var i = 0; i < nodes.length; i++) {
			if (nodes[i].id == id) {
				return nodes[i];
			}
		}
	}
	return null;	
}

function adjustFrameSize () {
	if (document.documentElement.clientWidth > defaultClientWidth) {
		document.getElementById("mcbct").style.width = document.documentElement.clientWidth;
		document.getElementById("iframe1").style.width = document.documentElement.clientWidth;
	}
	if (document.documentElement.clientHeight > defaultClientHeight && document.documentElement.clientHeight > 46) {
		document.getElementById("iframe1").style.height = document.documentElement.clientHeight - 46;
	}
}

</script>
</head>

<body onclick="hideall();" onresize="adjustFrameSize()">

<script type="text/javascript">

var contentURL = top.homepage;

if (top.inMerchantCenter && (top.storeId == null || top.storeId == "" || top.storeId == 0 || top.showStoreSelection)) {
	contentURL = top.choose_store_link;
	top.mccbanner.showWarningUponClosing = false;
	enableGotoMenuPath = false;	
}

if (top.gotoMenuPath != "" && enableGotoMenuPath) {
	contentURL =  top.getWebPrefix() + 'tools/common/blank.html';
}


document.writeln('<iframe id="mcsubmenu0" title="' + top.submenuFrameTitle + '" name="mcsubmenu" class="submenu" frameborder="0" scrolling="no" src="' + top.getWebPrefix() + 'tools/common/blank.html"></iframe>');

var zIndex = 10;
for (var i = 1; i <= subMenuLevel; i++) {
	zIndex++;
	document.writeln('<iframe id="mcsubmenu' + i + '" title="' + top.submenuFrameTitle + '" name="mcsubmenu' + i + '" class="submenu" style="z-index: ' + zIndex + ';" frameborder="0" scrolling="no" src="' + top.getWebPrefix() + 'tools/common/blank.html"></iframe>');
}

document.writeln('<iframe id="mcprogress" title="' + top.pbFrameTitle + '" name="mcprogress" class="progress" width="400" height="110" frameborder="0" scrolling="no" onload="drawProgressIndicator();" src="' + top.getWebPrefix() + 'tools/common/blank.html"></iframe>');
document.writeln('<iframe id="mcbct" title="' + top.bctFrameTitle + '" name="mcbct" style="height: 27px; width: expression(document.documentElement.clientWidth);" frameborder="0" style="z-index: 5;" scrolling="no" onmouseover="hideall();" src="' + top.getWebPrefix() + 'tools/common/ToolsUIBCT.html"></iframe>');
document.writeln('<iframe id="iframe1" title="' + top.contentFrameTitle + '" name="mcccontent" style="height: expression(document.documentElement.clientHeight - 46); width: expression(document.documentElement.clientWidth);" frameborder="0" border="0" style="z-index: 0;" onreadystatechange="loadingStatus();" onload="gotoMenu();" onmouseover="hideall();" allowtransparency="true" src="' + contentURL + '"></iframe>');

</script>

<form method="post" name="mainForm" target="mcccontent" action="">
</form>

</body>
</html>
