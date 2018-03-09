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
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/> 
<style type="text/css">

html,body { height: 100%; margin: 0 0 0 0; }

</style>
<script type="text/javascript">

var pp = new Object();
var highlightColor = "#B2B2B6";
var menuShowed = false;

function highlight(num) {
	var node = document.getElementById("menu" + num);
	
	if (node != null) {
		node.style.backgroundColor = highlightColor;
	}
}

function noHighlight(num) {
	var node = document.getElementById("menu" + num);
	
	if (node != null) {
		node.style.backgroundColor = document.body.style.backgroundColor;
	}
}

function showit(num) {
	self.focus();
	var mainMenu = document.getElementById("menu" + num);
	
	if (top.mccmain.hideall && top.mccmain.menuvis) {
		top.mccmain.hideall();
		top.mccmain.menuvis(num, "visible");
		menuShowed = true;
	}		
}

function clickToShowit(num) {
	menuShowed = true;
	showit(num);
}

function moveToShowit(num) {
	if (menuShowed) {
		if (top.mccmain.hideall) {
			top.mccmain.hideall();
		}
		showit(num);
	}
	else {
		if (top.mccmain.hideall) {
			top.mccmain.hideall();
		}
		highlight(num);
	}
}

function writemenu(num) {
	var m = "menu" + num;
	var text = parent.menu[num].name;
	var pos = parent.menu[num].startpos;

	// check for empty menu and hide them if any
	eflag = true;
	if (parent.menu[num].type == "help") {
		eflag = false;
	}
	else { 
		for (j = 0; j < parent.menu[num].node.length; j++) {
			if (parent.menu[num].node[j].url != "") {
				eflag = false;
				break;
			}
		}
	}

	if (num > 0 && pos == 0) { 
		// if position (left offset) not defined, we will calcuate from last menu item's position
		pos = parent.menu[num-1].startpos + parent.menu[num-1].width + parent.space;
		parent.menu[num].startpos = pos;
	}

	document.writeln('<div id="' + m + '"style="position: absolute; padding-left: 5px; padding-bottom: 3px; padding-top: 2px; visibility: visible; top: 0px; left: ' + pos + 'px;">');
	if (parent.menu[num].type == "help") {		
		document.writeln('<a href="javascript:top.openHelp();" onmouseover="top.mccmain.hideall(); highlight(' + num + ');" onmouseout="noHighlight(' + num + ');">' + text + '</a>');

		// get and save the width property of this menu item
		parent.menu[num].width = document.getElementById(m).offsetWidth;
	}
	else {
		document.writeln('<a href="javascript:clickToShowit(' + num + ');" onmouseover="moveToShowit(' + num + ');">' + text + '</a>');
		
		// get and save the width property of this menu item
		parent.menu[num].width = document.getElementById(m).offsetWidth;
		
		if (eflag) {
			parent.menu[num].display = false;
		}
	}
	document.writeln('</div>');	
}


function init() {
	var i;
	
	for (i = 0; i < parent.menu.length; i++) {
		writemenu(i);
	}
}

</script>
</head>

<body class="menu">

<script type="text/javascript">
init();
</script>

</body>
</html>
