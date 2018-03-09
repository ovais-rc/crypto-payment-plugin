<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!-- 
  //*----
  //* @deprecated The Product Advisor feature has been deprecated. For more information, see <a href="../../../../../../com.ibm.commerce.productadvisor.doc/concepts/cpaintro.htm">Product Advisor</a>.
  //*----
-->
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.common.ui.*" %>
<%@page import="com.ibm.commerce.tools.common.*" %>
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellUIConstants" %>
<%@page import="com.ibm.commerce.pa.tools.guidedsell.utils.GuidedSellHelper" %>

<%@ include file="/tools/guidedsell/GuidedSellCommon.jsp" %>

<jsp:useBean id="tree" scope="request" class="com.ibm.commerce.tools.common.ui.DynamicTreeBean"></jsp:useBean>

<%
    CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale locale = null;

    // use server default locale if no command context is found
    if (cmdContext != null) {
        locale = cmdContext.getLocale();
    } else {
        locale = Locale.getDefault();
    }

    if (locale==null) {
        locale=Locale.US;
    }

    // set databean request properties
 	tree.setRequest(request);

%>
<html>
<head>
<%
	// obtain the resource bundle for display of Expand/Collapse NL translations
    Hashtable dtreeNLS = (Hashtable)ResourceDirectory.lookup("common.uiNLS", locale);

	String searchFailedMsg;
	String treeTitle = tree.getTreeTitle();
	try {
		// get error message for Failed Search
	    Hashtable searchFailedNLS = (Hashtable)ResourceDirectory.lookup(tree.getTreeSearchFailedResourceBundle(), locale);
	    searchFailedMsg = (String) searchFailedNLS.get("treeSearchFailed");
	    if (treeTitle.equals("true")) {
			treeTitle = (String) searchFailedNLS.get("treeTitle");
		}
		else {
			treeTitle = "";
		}
	} catch (Exception e) {
		searchFailedMsg = e.getMessage();
		treeTitle = e.getMessage();
	}


	// Put all request NVPs into a string so we can resend them to the dataBean
	Enumeration e = request.getParameterNames();
	StringBuffer NVPs = new StringBuffer();
	while (e.hasMoreElements()) {
		String paramName = e.nextElement().toString();
		if (paramName.equals("gotoNode")) {
			continue;
		}
		NVPs.append("&");
		NVPs.append(paramName);
		NVPs.append("=");
		NVPs.append(request.getParameter(paramName));
	}

	boolean useFolderIcons = (tree.getFolderIcon().equals("false"))?(false):(true);
	boolean expandInContextMenu = (tree.getExpand().equals("true"))?(true):(false);
	boolean multiSelect = (tree.getMultiSelect().equals("true"))?(true):(false);
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/DynamicTree.js"></script>
<script>

/**********************************************************************
 DynamicTree configurations and variables

 DTreeConfig.useFolderIcons - flag to use folder icons for node that has child nodes.
 DTreeConfig.multiSelect - flag to allow multi-select.
 expandInContextMenu - flag to automatically add Expand and Collapse menu items to every context menu.
 targetFrame - target frame name when a javascript action in context menu is launched.
 expandLevel - number of level to expand down when the tree is first loaded.
 searchFailMsg - NL message to display when a node cannot be found.
 webappPath - webapp path to call DynamicTreeFetchData view.
 imagePrefix - default tools image path to load the default images.
 tree - the root node of dynamic tree.
 userIcons - an array of to hold icons defined by user.
 stopFindLevel - internal variable used when performing find node.

**********************************************************************/
DTreeConfig.useFolderIcons = <%= useFolderIcons %>;
DTreeConfig.multiSelect = <%= multiSelect %>;
var expandInContextMenu = <%= expandInContextMenu %>;
var highlightedNodeTitle = "<%= UIUtil.toJavaScript((String)dtreeNLS.get("highlightedNodeTitle")) %>";
var targetFrame = "<%= tree.getTargetFrame() %>";
var expandLevel = <%= tree.getExpandLevel() %>;
var searchFailedMsg = "<%= searchFailedMsg %>";
var webappPath = "<%= UIUtil.getWebappPath(request) %>";
var imagePrefix = "<%= UIUtil.getWebPrefix(request) %>images/tools/";
var tree = null;
var userIcons = new Object();
var stopFindLevel = 0;

/**********************************************************************
 Enhanced functions to make the tree dynamic, by extending functions
 from DynamicTree.js
**********************************************************************/

/**
 * Dynamically fetches child nodes.
 */
DTreeAbstractNode.prototype.loadChildNodes = function () {
	DTreeHandler.isLoading = true;
	dframe.location.replace(webappPath + 'DynamicTreeFetchDataView?' + this.childrenUrlParam + '<%=UIUtil.toJavaScript( NVPs.toString() )%>');
	document.getElementById(this.id + "-anchor").innerHTML = "<%= dtreeNLS.get("loading") %> ...";
	document.getElementById(this.id + "-anchor").focus();
	top.showProgressIndicator(true);
}

/**
 * Enables/Disables the Expand and Collapse menu item in the context menu before showing it.
 */
ContextMenu.prototype.onBeforeToString = function () {
	this.menu = processExpandInContextMenu(this.menu);
}

/**
 * Process the context menu HTML just before it sends out for rendering.
 *
 * @param str - HTML string for displaying the context menu
 *
 * @return modified HTML string
 */
ContextMenu.prototype.onToString = function (str) {
	str = processContextMenuHTML(str);
	return str;
}

/**
 * Key action listener for this document.
 * Press '+' to collapse the tree recursively;
 * Press '-' to expand the tree recursively.
 *
 * @param event - window event that fires this action
 */
function keyPressListener(event) {
	var keyCode = (event.keyCode)?(event.keyCode):(event.which);

	if (keyCode == 95)
		tree.collapseAll();
	else if (keyCode == 43)
		tree.expandAll();
}

/**
 * Processes the icon type populated from the data bean.
 *
 * @param iconsGroup - an array of icons group
 *
 * @return a new array of icons
 */
function processIconType(iconsGroup) {
	var icons = new Array();

	for (var i = 0; i < iconsGroup.length; i++) {
		if (iconsGroup[i] != "" && userIcons[iconsGroup[i]]) {
			for (var j = 0; j < userIcons[iconsGroup[i]].length; j++) {
				icons[icons.length] = userIcons[iconsGroup[i]][j];
			}
		}
	}
	return icons;
}

/**
 * Handler to process find node by name.
 *
 * @param oNodes - an array of nodes populated from data bean
 * @param oFindNode - a find node object returns from data bean
 *
 * @return an array of nodes object
 */
function processFindNodeByName(oNodes, oFindNode) {
	var path = oFindNode.value.split("/");

	for (var i = 0; i < stopFindLevel; i++) {
		var matchIndex = -1;
		for (var j = 0; j < oNodes.length; j++) {
			if (oNodes[j].name == path[i]) {
				matchIndex = j;
				j = oNodes.length;
			}
		}

		if (matchIndex > -1 && oNodes[matchIndex].children)
			oNodes = oNodes[matchIndex].children;
	}

	stopFindLevel = 0;
	return oNodes;
}

/**
 * Handler to process find node by value.
 * @param oNodes - an array of nodes populated from data bean
 * @param oFindNode - a find node object returns from data bean
 *
 * @return an array of nodes object
 */
function processFindNodeByValue(oNodes, oFindNode) {
	var path = oFindNode.value.split("/");

	for (var i = 0; i < stopFindLevel; i++) {
		var matchIndex = -1;
		for (var j = 0; j < oNodes.length; j++) {
			if (oNodes[j].value == path[i]) {
				matchIndex = j;
				j = oNodes.length;
			}
		}

		if (matchIndex > -1 && oNodes[matchIndex].children)
			oNodes = oNodes[matchIndex].children;
	}

	stopFindLevel = 0;
	return oNodes;
}

/**
 * Enables/Disables the Expand and Collapse menu item in the context menu based on the node type and state.
 *
 * @param oMenu - a ContextMenu object
 */
function processExpandInContextMenu(oMenu) {
	if (expandInContextMenu) {
		if (DTreeHandler.focusNode != null && (DTreeHandler.focusNode.nodeType == "branch" || DTreeHandler.focusNode.nodeType == "root")) {
			if (DTreeHandler.focusNode.opened) {
				oMenu[oMenu.length - 2].enabled = false;
				oMenu[oMenu.length - 1].enabled = true;
			}
			else {
				oMenu[oMenu.length - 2].enabled = true;
				oMenu[oMenu.length - 1].enabled = false;
			}
		}
		else if (DTreeHandler.focusNode != null && DTreeHandler.focusNode.nodeType == "leaf") {
			oMenu[oMenu.length - 2].enabled = false;
			oMenu[oMenu.length - 1].enabled = false;
		}
	}

	return oMenu;
}

/**
 * Automtically sets the target for those menu items that have javascript action.
 *
 * @param str - HTML string
 */
function processContextMenuHTML(str) {
	str = str.replace(/target=""/gi, 'target="' + targetFrame + '"');
	return str;
}

/**
 * Creates and initializes a context menu object.
 *
 * @param oMenu - an array of menu item objects populated from data bean
 *
 * @return a ContextMenu object
 */
function createContextMenu(oMenu) {
	var contextMenu = new ContextMenu();

	if (oMenu != null) {
		for (var i = 0; i < oMenu.length; i++) {
			if (oMenu[i][0] == "" && oMenu[i][1] == "")
				contextMenu.addMenuSeparator();
			else
					contextMenu.addMenuItem(oMenu[i][0], oMenu[i][1], true);
		}

		if (expandInContextMenu) {
			if (contextMenu.getMenuLength() > 0)
				contextMenu.addMenuSeparator();

			contextMenu.addMenuItem("<%= dtreeNLS.get("expand") %>", "javascript:DTreeHandler.focusNode.toggle();", false);
			contextMenu.addMenuItem("<%= dtreeNLS.get("collapse") %>", "javascript:DTreeHandler.focusNode.toggle();", false);
		}
	}

	return contextMenu;
}

/**
 * Adds Expand and Collapse menu items to every context menu.
 *
 * @param oMenus - an array of context menu objects populated from data bean
 *
 * @return null
 */
function processContextMenus(oMenus) {
	if (oMenus != null) {
		for (var i = 0; i < oMenus.length; i++) {
			var contextMenu = new ContextMenu(oMenus[i].menuType);
			for (var j = 0; j < oMenus[i].menu.length; j++) {
				if (oMenus[i].menu[j][0] == "" && oMenus[i].menu[j][1] == "")
					contextMenu.addMenuSeparator();
				else
					contextMenu.addMenuItem(oMenus[i].menu[j][0], oMenus[i].menu[j][1], true);
			}

			if (expandInContextMenu) {
				if (contextMenu.getMenuLength() > 0)
					contextMenu.addMenuSeparator();

				contextMenu.addMenuItem("<%= dtreeNLS.get("expand") %>", "javascript:DTreeHandler.focusNode.toggle();", false);
				contextMenu.addMenuItem("<%= dtreeNLS.get("collapse") %>", "javascript:DTreeHandler.focusNode.toggle();", false);
			}
		}
		oMenus = null;
	}
	return oMenus;
}

/**
 * Processes the icons array populated from the data bean, and add them into global userIcons object.
 *
 * @param oIcons - an array of icons populated from data bea
 *
 * @return null
 */
function processIcons(oIcons) {
	if (oIcons != null) {
		for (var i = 0; i < oIcons.length; i++) {
			userIcons[oIcons[i].iconType] = new Array();
			for (var j = 0; j < oIcons[i].icons.length; j++) {
				var src = (typeof(oIcons[i].icons[j]) == "object")?(oIcons[i].icons[j].source):(oIcons[i].icons[j]);
				var title = (typeof(oIcons[i].icons[j]) == "object")?(oIcons[i].icons[j].title):("");
										
				// Use user specified path if it is starting from root
				if (src.indexOf("/") != 0) {
					src = imagePrefix + src;
				}
				
				userIcons[oIcons[i].iconType][j] = new DTreeIcon(src, title);
			}
		}
		oIcons = null;
	}
	return oIcons;
}

/**
 * Expands the tree down to the level that specified by the user.
 *
 * @param expandNode - node to be expanded
 * @param level - number of level down to expand
 */
function doLevelExpand(expandNode, level) {
	var maxLevel = (DTreeConfig.showRoot)?(expandLevel):(expandLevel + 1);
	level = (typeof(level) == "undefined")?(0):(level);

	if (level < maxLevel) {
		expandNode.expand();
		level++;
		if (level < maxLevel) {
			for (var i = 0; i < expandNode.childNodes.length; i++) {
				doLevelExpand(expandNode.childNodes[i], level);
			}
		}
	}
}

/**
 * Sets the resulting nodes when performing search on the server.
 *
 * @param oExpandNode - target node to attach the child nodes to
 * @param oNodes - an array of child nodes populated from data bean
 * @param oFindNode - a find node object populated from data bean
 * @param oFindMode - boolean to indicate if it is finding a node
 */
function setFindNode(oExpandNode, oNodes, oFindNode, oFindMode) {
	var bFindMode = (typeof(bFindMode) == "undefined")?(false):(bFindMode);

	if (!bFindMode && oFindNode != null) {
		// Get rid of nodes that have been previsouly loaded.
		if (oFindNode.type == "name")
			oNodes = processFindNodeByName(oNodes, oFindNode);
		else if (oFindNode.type == "value")
			oNodes = processFindNodeByValue(oNodes, oFindNode);

		oFindNode = null;
		bFindMode = true;
	}

	for (var i = 0; i < oNodes.length; i++) {
		var oUserIcons = processIconType(oNodes[i].iconType);
		var oContextMenu = (oNodes[i].menuType)?(oNodes[i].menuType):(createContextMenu(oNodes[i].contextMenu));
		var item = new DTreeItem(oNodes[i].name, oNodes[i].value, null, oNodes[i].childrenUrlParam, oContextMenu, oNodes[i].contextMenuParams, oUserIcons);
		var newItem = oExpandNode.appendChild(item, true);
		if (oNodes[i].children) {
			setFindNode(newItem, oNodes[i].children, oFindNode, oFindMode);
		}
	}
}

/**
 * Set nodes that populated from the data bean.
 * @param oExpandNode - target node to attach the child nodes to
 * @param oNodes - an array of child nodes populated from data bean
 * @param oMenus - an array of context menu objects populated from data bean
 * @param oIcons - an array of icon objects populated from data bean
 */
function setNode(oExpandNode, oNodes, oMenus, oIcons) {
	var newItem, oContextMenu;

	oMenus = (oMenus != null)?(processContextMenus(oMenus)):(oMenus);
	oIcons = (oIcons != null)?(processIcons(oIcons)):(oIcons);

	if (oNodes != null) {
		for (var i = 0; i < oNodes.length; i++) {
			var oUserIcons = processIconType(oNodes[i].iconType);

			if (tree == null && oNodes.length == 1) {
				oContextMenu = (oNodes[i].menuType)?(oNodes[i].menuType):(createContextMenu(oNodes[i].contextMenu));
				tree = new DTree(oNodes[i].name, oNodes[i].value, null, oNodes[i].childrenUrlParam, oContextMenu, oNodes[i].contextMenuParams, oUserIcons);
				newItem = tree;
				DTreeConfig.showRoot = true;
			}
			else {
				oContextMenu = (oNodes[i].menuType)?(oNodes[i].menuType):(createContextMenu(oNodes[i].contextMenu));
				var item = new DTreeItem(oNodes[i].name, oNodes[i].value, null, oNodes[i].childrenUrlParam, oContextMenu, oNodes[i].contextMenuParams, oUserIcons);

				if (tree == null && oNodes.length > 1) {
					// Create a virtual root and hide it.
					tree = new DTree("Root");
					oExpandNode = tree;
					DTreeConfig.showRoot = false;
				}

				newItem = oExpandNode.appendChild(item, true);
			}

			if (this.userSetNode)
				newItem = this.userSetNode(newItem);

			if (oNodes[i].children)
				setNode(newItem, oNodes[i].children, oMenus, oIcons);
		}
	}
}

/**********************************************************************
 Original DynamicTree functions
**********************************************************************/

/**
 * Returns currently highlighted/selected node.
 *
 * @return a DTreeItem node object
 */
function getHighlightedNode() {
	return DTreeHandler.focusNode;
}

/**
 * Returns currently highlighted/selected nodes when multi-select is enabled.
 *
 * @return an array of DTreeItem nodes
 */
function getHighlightedNodes() {
	return DTreeHandler.selectedNodes;
}

/**
 * Returns the path to the target node in terms of display names.
 * e.g.: Root/Item 1.2/Item 1.2.3/Item 1.2.3.2
 *
 * @param node - DTreeItem node object
 *
 * @return name path leads to the target node
 */
function getNamePath(node) {
	var str = "";
	var counter = 0;

	if (!DTreeConfig.showRoot) {
		while (node.parentNode != null) {
			str = node.name + ((counter > 0)?("/" + str):(""));
			node = node.parentNode;
			counter++;
		}
	}
	else {
		while (node != null) {
			str = node.name + ((counter > 0)?("/" + str):(""));
			node = node.parentNode;
			counter++;
		}
	}
	return str;
}

/**
 * Returns the path to the target node in terms of associated values.
 * e.g.: root value/Item 1.2 value/Item 1.2.3 value/Item 1.2.3.2 value
 *
 * @param node - DTreeItem node object
 *
 * @return value path leads to the target node.
 */
function getValuePath(node) {
	var str = "";
	var counter = 0;

	if (!DTreeConfig.showRoot) {
		while (node.parentNode != null) {
			str = node.value + ((counter > 0)?("/" + str):(""));
			node = node.parentNode;
			counter++;
		}
	}
	else {
		while (node != null) {
			str = node.value + ((counter > 0)?("/" + str):(""));
			node = node.parentNode;
			counter++;
		}
	}
	return str;
}

/**
 * Fetches data from the server using the name path or value path.
 *
 * @param gotoPath - path leads to the target node
 * @param searchBy - path type: 'name' or 'value'
 */
function gotoDataFrame(path, searchBy)  {
	if (searchBy == "name") {
		DTreeHandler.isLoading = true;
		dframe.location.replace(webappPath + 'DynamicTreeFetchDataView?<%=UIUtil.toJavaScript( NVPs.toString() )%>&gotoNodeByName=' + path);
	}
	else if (searchBy == "value") {
		DTreeHandler.isLoading = true;
		dframe.location.replace(webappPath + 'DynamicTreeFetchDataView?<%=UIUtil.toJavaScript( NVPs.toString() )%>&gotoNodeByValue=' + path);
	}
}

/**
 * Highlights a node sepcified by its name path.
 *
 * @param gotoPath - name path leads to the target node
 */
function gotoAndHighlightByName(gotoPath) {
	gotoAndHighlightNode(gotoPath, "name");
}

/**
 * Highlights a node specified by its value path.
 *
 * @param gotoPath - value path leads to the target node
 */
function gotoAndHighlightByValue(gotoPath) {
	gotoAndHighlightNode(gotoPath, "value");
}

/**
 * Higlights a node specified by its path and the path type.
 *
 * @param gotoPath - path leads to the target node
 * @param searchBy - path type : 'name' or 'value'
 */
function gotoAndHighlightNode(gotoPath, searchBy) {
	// Parse the gotoPath (in the form "root/node/node/leaf")
	var path = gotoPath.split("/");
	var startNode = tree;
	var node = null;
	var skipOccurrence = 0;

	for (var i = 0; i < path.length; i++) {
		if (searchBy == "name")
			node = startNode.findNodeByName(path[i], skipOccurrence);
		else if (searchBy == "value")
			node = startNode.findNodeByValue(path[i], skipOccurrence);

		// If node is null, means no match, should exit.
		if (node == null) {
			// Try to fetch from the server.
			if (!startNode.childNodesLoaded && !startNode.hasChildNodes() && startNode.childrenUrlParam) {
				stopFindLevel = i;
				DTreeHandler.focusNode = startNode;
				gotoDataFrame(gotoPath, searchBy);
				return;
			}
			i = path.length;
		}
		else {
			// Since we got the path, we can find from the node instead of from the tree.
			// But have to skip matching the startNode itself.
			startNode = node;
			if (searchBy == "name")
				skipOccurrence = (startNode.name == path[i+1])?(1):(0);
			else if (searchBy == "value")
				skipOccurrence = (startNode.value == path[i+1])?(1):(0);
		}
	}

	if (node != null && node.rendered) {
		var tempNode = node.parentNode;
		// Expand parentNode up all the way up to the root.
		while (tempNode != null) {
			tempNode.expand();
			tempNode = tempNode.parentNode;
		}
		if (node.rendered) {
			node.select();
		}
	}
	else {
		alertDialog(searchFailedMsg);
	}
}

//function added by us
DTreeHandler.selectNode = function(id,e){
		if (this.isLoading) {
			this.stayOnFocusNode();
			return;
		}

		// Deselects all the previously selected nodes.
		if ((DTreeConfig.multiSelect && e != null && !e.ctrlKey && this.focusNode != null) || (!DTreeConfig.multiSelect && this.focusNode != null)) {
			this.deselectAllNodes();
		}

		var oNode = this.nodes[this.toDTreeId(id)];

		if (DTreeConfig.multiSelect && e != null && e.ctrlKey)
			oNode.select(true);
		else
			oNode.select();

		this.hideContextMenu(id);
	
		if(parent.myRefreshButtons){
			parent.myRefreshButtons();
		}
}
//

</script>
<script src="<%= tree.getJsFile()%>"></script>
<title><%=guidedSellRB.get(GuidedSellUIConstants.GSQAT_FRAME_TITLE)%></title>
</head>
<body onclick="DTreeHandler.hideContextMenu(); DTreeHandler.highlightFocusNode(event);" onkeypress="keyPressListener(event);" onselectstart="return false;" onLoad="parent.displayPathNew();top.showProgressIndicator(false);" onUnload="parent.saveHighLightedPathNew()" class="content" >
<% if (!treeTitle.equals("")) {%>
	<h1><%= treeTitle %></h1>
<%}%>
	<script>

	var dataFrame = '<iframe name="dframe" id="dataframe" width="0" height="0" src="' + webappPath + 'DynamicTreeFetchDataView?<%= tree.getInitDataURLParam() %><%=UIUtil.toJavaScript( NVPs.toString() )%><%if (request.getParameter("gotoNode")!=null) { %>&gotoNode=<%=UIUtil.toJavaScript((String)request.getParameter("gotoNode"))%><%}%>"></iframe>';
	document.write(dataFrame);

	</script>
	
<script language="JavaScript">
<%
	String treeId = request.getParameter(GuidedSellUIConstants.GS_TREE_ID);
	boolean hasRootQuestion = (new GuidedSellHelper()).hasRootQuestion(new Integer(treeId));
%>
	if(!<%=hasRootQuestion%>){
		document.writeln("<%=getNLString(guidedSellRB,GuidedSellUIConstants.GSQAT_EMPTY)%>");
	}	
</script>

</body>
</html>
