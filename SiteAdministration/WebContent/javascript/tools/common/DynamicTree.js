/********************************************************************
*-------------------------------------------------------------------
* Licensed Materials - Property of IBM
*
* WebSphere Commerce
*
* (c) Copyright IBM Corp. 2000, 2002
*
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*
*-------------------------------------------------------------------*/

/**
 * DTree configuration variables.
 *
 * rootIcon          : root folder icon.
 * openRootIcon      : root open folder icon.
 * folderIcon        : folder icon for node that has child nodes.
 * openFolderIcon    : open folder icon for node that has child nodes.
 * fileIcon          : file icon for node that has no child nodes.
 * minusIcon         : [-] image to denote the root node is collapsible.
 * plusIcon          : [+] image to denote the root node is expandable.
 * iIcon             : | image connector.
 * lIcon             : L image connector.
 * lMinusIcon        : L[-] image connector.
 * lPlusIcon         : L[+] image connector.
 * tIcon             : |- image connector.
 * tMinusIcon        : |-[-] image connector.
 * tPlusIcon         : |-[+] image connector.
 * blankIcon         : blank image.
 * defaultName       : default display name of a node.
 * defaultAction     : default action of a node when clicking on it.
 * defaultValue      : default value associated with a node.
 * contextMenuButton : mouse button to invoke the context menu, valid values are 'right', 'left', or 'both'.
 *                     Pressing shortcut key 'c' may also able to invoke the context menu.
 * useFileIcon       : boolean value to indicate if file icon should be displayed for node that has no child nodes.
 * useFolderIcons    : boolean value to indicate if folder icons should be displayed for node that has child nodes.
 * multiSelect       : boolean value to indicate if multi-select nodes is allowed.
 *                     If true, context menu will be disabled automatically.
 * showRoot          : boolean value to indicate if the root node should be visible.
 */
var DTreeConfig = {
	rootIcon          : '/wcs/images/tools/dtree/folderclosed.gif',
	openRootIcon      : '/wcs/images/tools/dtree/folderopen.gif',
	folderIcon        : '/wcs/images/tools/dtree/folderclosed.gif',
	openFolderIcon    : '/wcs/images/tools/dtree/folderopen.gif',
	fileIcon          : null,
	minusIcon         : '/wcs/images/tools/dtree/minusalone.gif',
	plusIcon          : '/wcs/images/tools/dtree/plusalone.gif',
	iIcon             : '/wcs/images/tools/dtree/linestraight.gif',
	lIcon             : '/wcs/images/tools/dtree/linebottom.gif',
	lMinusIcon        : '/wcs/images/tools/dtree/minusbottom.gif',
	lPlusIcon         : '/wcs/images/tools/dtree/plusbottom.gif',
	tIcon             : '/wcs/images/tools/dtree/linemiddle.gif',
	tMinusIcon        : '/wcs/images/tools/dtree/minusmiddle.gif',
	tPlusIcon         : '/wcs/images/tools/dtree/plusmiddle.gif',
	blankIcon         : '/wcs/images/tools/dtree/clear.gif',
	defaultName       : 'null',
	defaultAction     : 'javascript:void(0);',
	defaultValue      : null,
	contextMenuButton : 'right',
	useFileIcon       : true,
	useFolderIcons    : true,
	multiSelect       : false,
	showRoot          : true
};

/**
 * Global variables and functions to support DTree.
 *
 * -- Variables --
 * idCounter          : counter to keep track of number of nodes that have been created.
 * idPrefix           : append a prefix to the counter to form an id.
 * nodes              : global hashtable to store all the node objects.
 * menus              : global hashtable to store all the context menu objects.
 * selectedNodes      : an array to keep track of the current selected nodes.
 * focusNode          : a node object that is currently selected.
 * isLoading          : boolean to indicate if a node is fetching its child nodes.
 * cmLastNodeId       : id of the node in which its context menu is last visible.
 * cmPaddingLeft      : left/right offset from the mouse x-coordinate to show the context menu.
 * cmPaddingTop       : amount of offset from the node to show the context menu.
 * scrollX            : current amount of horizontal page offset.
 * scrollY            : current amount of vertical page offset.
 *
 * -- functions --
 * getId              : generates a new DTree id to create a node object.
 *                         @return a new DTree id
 * toDTreeId          : converts from HTML id to DTree id format.
 *                         @param id a HTML id
 *                         @return DTree id
 * toggle             : selects and toggles a given node to expand or collapse, and hide the context menu.
 *                         @param id a HTML id
 *                         @param e window event
 * doKeyPress         : handles keystroke events. 'Enter' to select a node, or toggle a node on selected node;
 *                      'c' to show the context menu of a node; 'ESC' to hide the context menu.
 *                         @param id a HTML id
 *                         @param e window event
 * doCMKeyPress       : handles keystroke events when context menu is shown and focused. 'ESC' to hide the context menu.
 *                         @param e window event
 * selectAllNodes     : selects all the nodes in the tree.
 * deselectAllNodes   : deselect all selected nodes.
 * selectNode         : highlights and selects a node.
 *                         @param id a HTML id
 *                         @param e window event
 * deselectNode       : deselects a selected node.
 *                         @param id a HTML id
 * showContextMenu    : shows the context menu of a given node id.
 *                         @param id a HTML id
 *                         @param e window event
 * hideContextMenu    : shows the context menu of a given node id. If id is not given, hides the last visible context menu.
 *                         @param id a HTML id
 * stopBubbling       : stops the window event from bubbling.
 *                         @param e window event
 * getTarget          : returns the target element fired from a window event.
 *                         @param e window event
 *                         @return an HTML element or null
 * insertHTMLBeforeEnd: inserts HTML string before the end of an HTML element, without reparsing everything.
 *                      This will speed up the rendering time significantly.
 *                         @param oElement an HTML element
 *                         @param sHTML HTML string
 * getClientHeight    : returns the height of the browser in pixels.
 *                         @return height of the browser in pixels
 * getClientWidth     : returns the width of the browser in pixels.
 *                         @return width of the browser in pixels
 * getPageXOffset     : returns the amount of content that has been hidden by scrolling to the right.
 *                         @return the amount of content that has been hidden by scrolling to the right in pixels.
 * getPageYOffset     : returns the amount of content that has been hidden by scrolling down.
 *                         @return the amount of content that has been hidden by scrolling down in pixels.
 * getObjPageX        : returns Returns the horizontal position of a given DOM element elative to the page.
 * getObjPageY        : returns Returns the vertical position of a given DOM element elative to the page.
 * getContextMenuLeft : returns the appropriate left position to show the context menu.
 *                      By default, it will try to show on the right side of the mouse pointer, if there is enough space to show.
 *                      or else try to show on the left side if there is enough space. In the worse case, show it on the right side;
 * getContextMenuTop  : returns the appropriate top position to show the context menu.
 *                      By default, it will try to show just below the node, if there is enough space;
 *                      or else show it just above the node.
 * highlightFocusNode : focuses and select the focus node.
 * stayOnFocusNode    : stays focused on the focus node, do not do anything else.
 * setScrollings      : sets the current amount of scrollings.
 * restoreScrollings  : restores the previously set scrollings.
 * preventScrolling   : prevent from auto scrolling by browser when focuses on a node.
 * prefetchIcons      : prefetches all icons.
 */
var DTreeHandler = {
	idCounter          : 0,
	idPrefix           : "DTreeObject-",
	nodes              : {},
	menus              : {},
	selectedNodes      : [],
	focusNode          : null,
	isLoading          : false,
	cmLastNodeId       : null,
	cmPaddingLeft      : 5,
	cmPaddingTop       : 0,
	scrollX            : 0,
	scrollY            : 0,
	getId              : function () { return this.idPrefix + (this.idCounter++); },
	toDTreeId          : function (id) {
		id = id.replace("-container", "");
		id = id.replace("-item", "");
		id = id.replace("-connector", "");
		id = id.replace("-anchor", "");
		id = id.replace("-icon", "");
		return id;
	},
	toggle              : function (id, e) {
		if (this.isLoading) {
			this.stayOnFocusNode();
			return;
		}
		if (!e.ctrlKey) {
			this.selectNode(id, e);
			if (this.focusNode != null)
				this.focusNode.toggle();
			this.hideContextMenu();
		}
	},
	doKeyPress      : function (id, e) {
		if (this.isLoading) {
			this.stayOnFocusNode();
			return;
		}

		// If 'Enter' key is pressed.
		if (e.keyCode == 13) {
			// If the node has not been highlighted, select and highlight it,
			// otherwise toggle the node to expand or collapse.
			if (this.focusNode == null || this.focusNode.id != this.toDTreeId(id))
				this.selectNode(id, e);
			else
				this.toggle(id, e);
		}
		// If 'c' key is pressed, show the context menu.
		else if (e.keyCode == 99 && !DTreeConfig.multiSelect) {
			this.selectNode(id, e);
			this.showContextMenu(id, e);
		}
		// if 'Esc' key is pressed, hide the context menu.
		else if (e.keyCode == 27 && !DTreeConfig.multiSelect) {
			this.hideContextMenu(id);
		}
	},
	doCMKeyPress      : function (e) {
		if (this.isLoading) {
			this.stayOnFocusNode();
			return;
		}

		// If ESC key is pressed, hide the context menu.
		if (e.keyCode == 27 && !DTreeConfig.multiSelect)
			this.hideContextMenu();
	},
	selectAllNodes      : function () {
		this.deselectAllNodes();
		for (var i in this.nodes)
			this.selectedNodes[this.selectedNodes.length] = this.nodes[i];
	},
	deselectAllNodes    : function () {
		for (var i = 0; i < this.selectedNodes.length; i++) {
			var oSelectedNode = this.selectedNodes[i];
			var oElement = document.getElementById(oSelectedNode.id + "-anchor");

			if (oElement != null) {
				oElement.title = oSelectedNode.name;
				oElement.className = "dtreeItemNormal";
			}
		}
		this.focusNode = null;
		this.selectedNodes.length = 0;
	},
	selectNode          : function (id, e) {
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
	},
	deselectNode        : function (id) {
		if (this.isLoading) {
			this.stayOnFocusNode();
			return;
		}

		var oNode = this.nodes[this.toDTreeId(id)];
		oNode.deselect();
	},
	showContextMenu     : function (id, e) {
		if (this.isLoading) {
			this.stayOnFocusNode();
			return;
		}

		var treeId = this.toDTreeId(id);
		this.cmLastNodeId = treeId;
		this.nodes[treeId].showContextMenu(e);
		this.stopBubbling(e);
	},
	hideContextMenu     : function (id, e) {
		var targetId = (id)?(this.toDTreeId(id)):(this.cmLastNodeId);

		if (targetId)
			this.nodes[targetId].hideContextMenu();

		if (this.focusNode != null) {
			// Reset the focus to the highlighted node.
			var oElement = document.getElementById(this.focusNode.id + "-anchor");
			oElement.focus();
		}

		if (e)
			this.stopBubbling(e);
	},
	stopBubbling        : function (e) {
		if (e != null) {
			// Prevent the event from bubbling up.
			if (typeof(e.stopPropagation) != "undefined")
				e.stopPropagation();
			else if (typeof(e.cancelBubble) != "undefined")
				e.cancelBubble = true;
		}
	},
	getTarget          : function (e) {
		var result = null;

		if (e.srcElement)
			result = e.srcElement;
		else {
			var node = e.target;
			if (node) {
			    while (node.nodeType != 1)
			        node = node.parentNode;
			    result = node;
		    }
		}

		return (result)?(result):(null);
	},
	insertHTMLBeforeEnd	: function (oElement, sHTML) {
		// IE way to speed up rendering.
		if (oElement.insertAdjacentHTML) {
			oElement.insertAdjacentHTML("BeforeEnd", sHTML);
		}
		// Netscape/standard way to speed up rendering.
		else {
			var df;	// DocumentFragment
			var r = oElement.ownerDocument.createRange();
			r.selectNodeContents(oElement);
			r.collapse(false);
			df = r.createContextualFragment(sHTML);
			oElement.appendChild(df);
		}
	},
	getClientWidth      : function () { return (document.all)?(document.documentElement.clientWidth):(window.innerWidth); },
	getClientHeight     : function () { return (document.all)?(document.documentElement.clientHeight):(window.innerHeight); },
	getPageXOffset      : function () { return (document.all)?(document.documentElement.scrollLeft):(window.pageXOffset); },
	getPageYOffset      : function () { return (document.all)?(document.documentElement.scrollTop):(window.pageYOffset); },
	getObjPageX         : function (obj) {
		var num = 0;
		if (obj != document) {
			for (var p = obj; p && p.tagName != "BODY"; p = p.offsetParent)
				num += p.offsetLeft;
		}
		return num;
	},
	getObjPageY         : function (obj) {
		var num = 0;
		if (obj != document) {
			for (var p = obj; p && p.tagName != "BODY"; p = p.offsetParent)
				num += p.offsetTop;
		}
		return num;
	},
	getContextMenuLeft  : function (posX, width) {
		// If there is not enough space to show on right side of the mouse, but enough to show on left side, then show it on left side.
		if (posX + width + this.cmPaddingLeft + this.scrollX >= this.getClientWidth() && (posX - width - this.cmPaddingLeft + this.scrollX >= 0))
			return posX - width - this.cmPaddingLeft + this.scrollX;
		else
			return posX + this.cmPaddingLeft + this.scrollX;
	},
	getContextMenuTop   : function (posY, height, textHeight) {
		// If there is not enough space to show down, but enough to show up, then show up.
		if (posY + height + this.cmPaddingTop  - this.scrollY >= this.getClientHeight() && (posY - height - this.cmPaddingTop >=0))
			return posY - height - this.cmPaddingTop;
		else
			return posY + textHeight + this.cmPaddingTop;
	},
	highlightFocusNode  : function (e) {
		if (this.isLoading) {
			this.stayOnFocusNode();
			return;
		}

		var target = this.getTarget(e);

		if (this.focusNode != null) {
			if (DTreeConfig.multiSelect) {
				// if not in multi-select mode and target is not on the link, but previously multi-selected, reset the selections.
				if (!e.ctrlKey && target != null && target.tagName != "A" && this.selectedNodes.length > 1)
					this.deselectAllNodes();
			}
			else {
				// if use clicks on a link, update the focus node, otherwise just put a focus on the focus node.
				if (target.tagName == "A")
					this.focusNode.select();
				else
					document.getElementById(this.focusNode.id + "-anchor").focus();
			}
		}

		// Prevent Netscape from doing event propagation.
		this.stopBubbling(e);
	},
	stayOnFocusNode : function () {
		if (this.focusNode) {
			var oElement = document.getElementById(this.focusNode.id + "-anchor");
			if (oElement != null)
					oElement.focus();
		}
	},
	setScrollings : function () {
		this.scrollX = this.getPageXOffset();
		this.scrollY = this.getPageYOffset();
	},
	restoreScrollings : function () {
		window.scrollTo(this.scrollX, this.scrollY);
	},
	preventScrolling : function() {
		this.setScrollings();
		setTimeout("DTreeHandler.restoreScrollings();", 1);
	},
	prefetchIcons : function() {
		var cachedIcons = new Array();
		var index = 0;

		for (var icon in DTreeConfig) {
			if (icon != "useFileIcon" && icon != "useFolderIcons" && icon.indexOf("Icon") > 0 && DTreeConfig[icon] != null) {
				cachedIcons[index] = new Image();
				cachedIcons[index].src = DTreeConfig[icon];
				index++;
			}
		}
	}
};

/**********************************************************************
 DTreeAbstractNode
**********************************************************************/

/**
 * DTree abstract node object.
 *
 * @param sName - display name on the node
 * @param sValue - value associated with the node
 * @param sAction - action to be performed when clicking on the node. It can be an URL or javascript function
 * @param sChildrenUrlParam - parameters to fetch the child nodes
 * @param oContextMenu - context menu asscoiated with the node. It could be a ContextMenu object;
 *                       or a string type to denote that the context menu is a shared resource
 * @param sContextMenuUrlParam -  url parameter to pass to each context menu item action
 */
function DTreeAbstractNode(sName, sValue, sAction, sChildrenUrlParam, oContextMenu, sContextMenuUrlParam) {
	this.nodeType = (sChildrenUrlParam)?("branch"):("leaf");
	this.parentNode = null;
	this.childNodes = [];
	this.id = DTreeHandler.getId();
	this.name = (sName)?(sName):(DTreeConfig.defaultName);
	this.value = (sValue)?(sValue):(DTreeConfig.defaultValue);
	this.action = (sAction)?(sAction):(DTreeConfig.defaultAction);
	this.childrenUrlParam = sChildrenUrlParam;
	this.contextMenu = (typeof(oContextMenu) == "undefined")?(null):(oContextMenu);
	this.contextMenuUrlParam = (sContextMenuUrlParam)?(sContextMenuUrlParam):(null);
	this.rendered = false;
	this.childNodesLoaded = false;
	DTreeHandler.nodes[this.id] = this;
}

/**
 * Appends a new child node to this node.
 *
 * @param oNode - a new DTreeItem object
 * @param bNoUpdate - boolean to indicate if refreshing the tree is required, default is false
 */
DTreeAbstractNode.prototype.appendChild = function (oNode, bNoUpdate) {
	// By default, the node will be updated and drawn automatically.
	bNoUpdate = (typeof(bNoUpdate) == "undefined")?(false):(bNoUpdate);

	// If the node has already been referenced, don't proceed.
	if (oNode.parentNode != null) return null;

	oNode.parentNode = this;
	this.childNodes[this.childNodes.length] = oNode;
	this.updateProperties();

	var root = this;
	while (root.parentNode) { root = root.parentNode; }

	if (root.rendered && !bNoUpdate) {
		if (this.childNodes.length >= 2) {
			// Change the connector image.
			if (this.childNodes[this.childNodes.length - 2].nodeType == "branch")
				document.getElementById(this.childNodes[this.childNodes.length - 2].id + '-connector').src = ((this.childNodes[this.childNodes.length - 2].opened)?(DTreeConfig.tMinusIcon):(DTreeConfig.tPlusIcon));
			else
				document.getElementById(this.childNodes[this.childNodes.length - 2].id + '-connector').src = DTreeConfig.tIcon;
		}

		// Convert the node to string and insert it to the bottom of the container.
		DTreeHandler.insertHTMLBeforeEnd(document.getElementById(this.id + '-container'), oNode.toString());
	}

	return oNode;
}

/**
 * Collapses first level child nodes.
 */
DTreeAbstractNode.prototype.collapse = function () {
	if (this.onBeforeCollapse)
		this.onBeforeCollapse();

	if (this.opened) {
		this.opened = false;
		document.getElementById(DTreeHandler.toDTreeId(this.id) + "-container").style.display = "none";

		// If this is a root node or there is no root node
		if (this.nodeType == "root" || (this.isFirstChild() && (this.parentNode != null && this.parentNode.nodeType == "root") && !DTreeConfig.showRoot))
			document.getElementById(DTreeHandler.toDTreeId(this.id) + "-connector").src = DTreeConfig.plusIcon;
		else
			document.getElementById(DTreeHandler.toDTreeId(this.id) + "-connector").src = ((this.isLastChild())?(DTreeConfig.lPlusIcon):(DTreeConfig.tPlusIcon));

		if (document.getElementById(DTreeHandler.toDTreeId(this.id) + "-icon"))
			document.getElementById(DTreeHandler.toDTreeId(this.id) + "-icon").src = this.icon;
	}

	if (this.onBeforeCollapse)
		this.onCollapse();
}

/**
 * Collapse all child nodes recursively.
 */
DTreeAbstractNode.prototype.collapseAll = function () {
	DTreeHandler.hideContextMenu();
	DTreeHandler.deselectAllNodes();
	this.select();
	this.collapse();
	for (var i = 0; i < this.childNodes.length; i++)
		this.childNodes[i].collapse();
}

/**
 * Deselects this node.
 */
DTreeAbstractNode.prototype.deselect = function () {
	for (var i = 0; i < DTreeHandler.selectedNodes.length; i++) {
		if (DTreeHandler.selectedNodes[i] == this) {
			for (var j = i; j < DTreeHandler.selectedNodes.length - 1; j++)
				DTreeHandler.selectedNodes[j] = DTreeHandler.selectedNodes[j + 1];

			DTreeHandler.selectedNodes.length--;
			var oElement = document.getElementById(this.id + "-anchor");
			if (oElement != null) {
				oElement.title = this.name;
				oElement.className = "dtreeItemNormal";
			}

			i = DTreeHandler.selectedNodes.length;
		}
	}
}

/**
 * Expands first level child nodes.
 */
DTreeAbstractNode.prototype.expand = function () {
	if (this.onBeforeExpand)
		this.onBeforeExpand();

	if (!this.opened) {
		this.opened = true;
		document.getElementById(DTreeHandler.toDTreeId(this.id) + "-container").style.display = "block";

		// If this is a root node or there is no root node
		if (this.nodeType == "root" || (this.isFirstChild() && (this.parentNode != null && this.parentNode.nodeType == "root") && !DTreeConfig.showRoot))
			document.getElementById(DTreeHandler.toDTreeId(this.id) + "-connector").src = DTreeConfig.minusIcon;
		else
			document.getElementById(DTreeHandler.toDTreeId(this.id) + "-connector").src = ((this.isLastChild())?(DTreeConfig.lMinusIcon):(DTreeConfig.tMinusIcon));

		if (document.getElementById(DTreeHandler.toDTreeId(this.id) + "-icon"))
			document.getElementById(DTreeHandler.toDTreeId(this.id) + "-icon").src = this.openIcon;
	}

	if (this.onExpand)
		this.onExpand();
}

/**
 * Expands all child nodes recursively.
 */
DTreeAbstractNode.prototype.expandAll = function () {
	DTreeHandler.hideContextMenu();
	DTreeHandler.deselectAllNodes();
	this.select();
	this.expand();
	for (var i = 0; i < this.childNodes.length; i++)
		this.childNodes[i].expand();
}

/**
 * Finds a particular node by display name, starting from this node.
 *
 * @param sName - display name
 * @param nSkipOccurrence - number of occurrence to skip before finding the next matching display name. default is 0
 * @param nOccurrence - current number of occurrence. This parameter is for internal use only
 *
 * @return DTreeItem - returns the matching DTreeItem object, or null if not found
 */
DTreeAbstractNode.prototype.findNodeByName = function (sName, nSkipOccurrence, nOccurrence) {
	var nSkipOccurrence = (typeof(nSkipOccurrence) != "number")?(0):(nSkipOccurrence);
	var occurrence = (typeof(nOccurrence) != "number")?(0):(nOccurrence);
	var result = null;

	if (typeof(sName) == "undefined")
		return null;
	else if (this.name == sName) {
		occurrence++;
		if (occurrence > nSkipOccurrence)
			return this;
	}

	if (!this.hasChildNodes())
		return null;

	for (var i = 0; i < this.childNodes.length; i++) {
		result = this.childNodes[i].findNodeByName(sName, nSkipOccurrence, occurrence);
		if (result != null)
			i = this.childNodes.length;
		else
			occurrence++;
	}

	return result;
}

/**
 * Finds a particular node by node value, starting from this node.
 *
 * @param sValue - node value
 * @param nSkipOccurrence - number of occurrence to skip before finding the next matching node value. default is 0
 * @param nOccurrence - current number of occurrence. This parameter is for internal use only
 *
 * @return DTreeItem - returns the matching DTreeItem object, or null if not found
 */
DTreeAbstractNode.prototype.findNodeByValue = function (sValue, nSkipOccurrence, nOccurrence) {
	var nSkipOccurrence = (typeof(nSkipOccurrence) != "number")?(0):(nSkipOccurrence);
	var occurrence = (typeof(nOccurrence) != "number")?(0):(nOccurrence);
	var result = null;

	if (typeof(sValue) == "undefined")
		return null;
	else if (this.value == sValue) {
		occurrence++;

		if (occurrence > nSkipOccurrence)
			return this;
	}

	if (!this.hasChildNodes())
		return null;

	for (var i = 0; i < this.childNodes.length; i++) {
		result = this.childNodes[i].findNodeByValue(sValue, nSkipOccurrence, occurrence);
		if (result != null)
			i = this.childNodes.length;
		else
			occurrence++;
	}

	return result;
}

/**
 * Retrieves the first child node.
 *
 * @return DTreeItem - returns the first child node, or null if there is no child node
 */
DTreeAbstractNode.prototype.getFirstChild = function () {
	return this.childNodes[0];
}

/**
 * Retrieves the last child node.
 *
 * @return DTreeItem - returns the last child node, or null if there is no child node
 */
DTreeAbstractNode.prototype.getLastChild = function () {
	if (this.childNodes.length > 0)
		return this.childNodes[this.childNodes.length - 1];
	else
		return null;
}

/**
 * Retrieves the parent node.
 *
 * @return DTreeItem - returns the parent node, or null if there is a DTree object or root node
 */
DTreeAbstractNode.prototype.getParentNode = function () {
	return this.parentNode;
}

/**
 * Returns boolean to indicate if this node has any child nodes.
 *
 * @return boolean - true if this node has one or more child nodes; false otherwise
 */
DTreeAbstractNode.prototype.hasChildNodes = function () {
	return (this.childNodes.length > 0)?(true):(false);
}

/**
 * Hides the context menu
 */
DTreeAbstractNode.prototype.hideContextMenu = function () {
	var oMenu = document.getElementById("ContextMenu");

	if (this.onBeforeHideContextMenu) {
		this.onBeforeHideContextMenu();
	}
	
	if (oMenu) {
		oMenu.visibility = "hidden";
		oMenu.innerHTML = "";
	}
	
	if (this.onHideContextMenu) {
		this.onHideContextMenu();
	}
}

/**
 * Inserts a new node before a particular child node. If a reference is not found, append
 * the new node to the last child node.
 *
 * @param oNewNode - a new DTreeItem object
 * @param oRefNode - a child DTreeItem object
 *
 * @return a reference to the newly inserted node.
 */
DTreeAbstractNode.prototype.insertBefore = function (oNewNode, oRefNode) {
	// If the node has already been referenced, don't proceed.
	if (oNewNode.parentNode != null) return null;

	var root = this;

	while (root.parentNode) { root = root.parentNode; }

	for (var i = this.childNodes.length; i >= 0; i--) {
		if (this.childNodes[i] == oRefNode) {
			oNewNode.parentNode = this;

			// Shift the nodes below down by one position.
			for (var j = this.childNodes.length - 1; j >= i; j--) {
				this.childNodes[j + 1] = this.childNodes[j];
			}
			// Put the new node in the target position
			this.childNodes[i] = oNewNode;

			// Display the newly inserted node.
			if (root.rendered) {
				// Temporarily render the node at the end of the document.
				DTreeHandler.insertHTMLBeforeEnd(document.body, oNewNode.toString());

				// Move the rendered item to the appropriate place.
				var oNewItem = document.getElementById(oNewNode.id + '-item');
				var oRefItem = document.getElementById(oRefNode.id + '-item');
				document.getElementById(this.id + '-container').insertBefore(oNewItem, oRefItem);

				// Move the rendered container to the item.
				var oNewContainer = document.getElementById(oNewNode.id + '-container');
				oNewItem.appendChild(oNewContainer);
			}
			return oNewNode;
		}
	}

	// If can't find oRefNode, append it to the end.
	return this.appendChild(oNewNode);
}

/**
 * Returns boolean to indicate if this node is the first child node of its parent.
 *
 * @return true if this is the first child node of its parent, or this is a root node,
 *         false otherwise
 */
DTreeAbstractNode.prototype.isFirstChild = function () {
	var parent = this.parentNode;

	if (parent != null)
		return (this.id == parent.getFirstChild().id)?(true):(false);
	else
		return true;
}

/**
 * Returns boolean to indicate if this node is the last child node of its parent.
 *
 * @return true if this is the last child node of its parent, or this is a root node,
 *         false otherwise
 */
DTreeAbstractNode.prototype.isLastChild = function () {
	var parent = this.parentNode;

	if (parent != null)
		return (this.id == parent.getLastChild().id)?(true):(false);
	else
		return true;
}

/**
 * Dynamically loads and appends the child nodes.
 */
DTreeAbstractNode.prototype.loadChildNodes = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on before collapsing the child nodes.
 */
DTreeAbstractNode.prototype.onBeforeCollapse = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on before expanding the child nodes.
 */
DTreeAbstractNode.prototype.onBeforeExpand = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on before hiding the context menu.
 */
DTreeAbstractNode.prototype.onBeforeHideContextMenu = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on before showing the context menu.
 */
DTreeAbstractNode.prototype.onBeforeShowContextMenu = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on before toggling to expand or collapse the child nodes.
 */
DTreeAbstractNode.prototype.onBeforeToggle = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on collapsing the child nodes.
 */
DTreeAbstractNode.prototype.onCollapse = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on expanding the child nodes.
 */
DTreeAbstractNode.prototype.onExpand = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on hiding the context menu.
 */
DTreeAbstractNode.prototype.onHideContextMenu = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on showing the context menu.
 */
DTreeAbstractNode.prototype.onShowContextMenu = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on toggling the child nodes to expand or collapse.
 */
DTreeAbstractNode.prototype.onToggle = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Event listener on selecting a node.
 */
DTreeAbstractNode.prototype.onSelect = function () {
	// Virtual method to be implemented.
	return;
}

/**
 * Redraws this node for display.
 */
DTreeAbstractNode.prototype.redraw = function () {
	var oItem = document.getElementById(this.id + "-item");
	var str = "";

	if (oItem != null) {
		str = this.toHTML();
		
		// Redraw the item.
		oItem.innerHTML = "";
		DTreeHandler.insertHTMLBeforeEnd(oItem, str);
	}
}

/**
 * Redraws this node and all its child nodes for display.
 */
DTreeAbstractNode.prototype.redrawAll = function () {
	this.redraw();
	if (this.hasChildNodes()) {
		for (var i = 0; i < this.childNodes.length; i++) {
			this.childNodes[i].redrawAll();
		}
	}
}

/**
 * Removes a child node from this node.
 *
 * @param oNode - a DTreeItem child node to be removed
 *
 * @return if the child node has been removed successfully, returns a reference of this removed child node,
 *         or returns null otherwise
 */
DTreeAbstractNode.prototype.removeChild = function (oNode) {
	var found = false;
	var root = this;

	while (root.parentNode) { root = root.parentNode; }

	for (var i = this.childNodes.length; i >= 0; i--) {
		if (this.childNodes[i] == oNode) {
			// If we are removing the last node.
			if (i == this.childNodes.length - 1) {
				if (this.childNodes[this.childNodes.length - 1].nodeType == "branch")
					document.getElementById(this.childNodes[i].id + '-connector').src = ((this.childNodes[i].opened)?(DTreeConfig.lMinusIcon):(DTreeConfig.lPlusIcon));
				else
					document.getElementById(this.childNodes[i].id + '-connector').src = DTreeConfig.lIcon;
			}

			// Remove the node from displaying.
			if (root.rendered) {
				var item = document.getElementById(oNode.id + '-item');
				var container = document.getElementById(oNode.id + '-container');
				document.getElementById(this.id + '-container').removeChild(item);
				if (container != null)
					document.getElementById(this.id + '-container').removeChild(container);
			}

			// Shift the nodes below up by one position.
			for (var j = i; j < this.childNodes.length - 1; j++) {
				this.childNodes[j] = this.childNodes[j + 1];
			}

			// Delete the last node, and adjust the length.
			this.childNodes[j] = null;
			this.childNodes.length--;
			this.updateProperties();

			// Remove the parentNode reference.
			oNode.parentNode = null;

			return oNode;
		}
	}
	return null;
}

/**
 * Renders the first level child nodes that have not been rendered for display.
 */
DTreeAbstractNode.prototype.renderChildNodes = function () {
	var oContainer = document.getElementById(this.id + "-container");

	if (oContainer != null) {
		for (var i = 0; i < this.childNodes.length; i++)
			DTreeHandler.insertHTMLBeforeEnd(oContainer, this.childNodes[i].toString());
	}
}

/**
 * Replaces a child node with another node.
 *
 * @param oNewNode - a new DTreeItem object
 * @param oChildNode - target child node to be replaced
 *
 * @return a reference to the newly replaced child node, or null if the child node did not get replaced successfully.
 */
DTreeAbstractNode.prototype.replaceChild = function (oNewNode, oChildNode) {
	// If the node has already been referenced, don't proceed.
	if (oNewNode.parentNode != null) return null;

	var root = this;

	while (root.parentNode) { root = root.parentNode; }

	for (var i = this.childNodes.length; i >= 0; i--) {
		if (this.childNodes[i] == oChildNode) {
			found = true;
			oNewNode.parentNode = this;
			oChildNode.parentNode = null;

			// Replace the new node in the target position
			this.childNodes[i] = oNewNode;

			// Display the newly inserted node.
			if (root.rendered) {
				// Temporarily render the node at the end of the document.
				DTreeHandler.insertHTMLBeforeEnd(document.body, oNewNode.toString());

				// Move the rendered item to the appropriate place.
				var oNewItem = document.getElementById(oNewNode.id + '-item');
				var oChildItem = document.getElementById(oChildNode.id + '-item');
				document.getElementById(this.id + '-container').replaceChild(oNewItem, oChildItem);

				// Move the rendered container to the item.
				var oNewContainer = document.getElementById(oNewNode.id + '-container');
				oNewItem.appendChild(oNewContainer);
			}
			return oNewNode;
		}
	}
	return null;
}

/**
 * Select and highlight this node.
 *
 * @param bMultiSelect - flag to indicate if this operation is in multi-select mode.
 *                       This parameter is for internal use only.
 */
DTreeAbstractNode.prototype.select = function (bMultiSelect) {
	var oElement = document.getElementById(this.id + "-anchor");

	DTreeHandler.preventScrolling();

	if (bMultiSelect) {
		// Check if this item has been selected before.
		var bSelected = false;
		for (var i = 0; i < DTreeHandler.selectedNodes.length; i++) {
			if (DTreeHandler.selectedNodes[i] == this) {
				bSelected = true;
				i = DTreeHandler.selectedNodes.length;
			}
		}
		if (bSelected) {
			this.deselect();

			if (DTreeHandler.selectedNodes.length > 1)
				DTreeHandler.focusNode = DTreeHandler.selectedNodes[DTreeHandler.selectedNodes.length - 1];
			else
				DTreeHandler.focusNode = null;

			// Focus on last selected node.
			if (DTreeHandler.focusNode && DTreeHandler.focusNode != this) {
				var oFocusElement = document.getElementById(DTreeHandler.focusNode.id + "-anchor");
				if (oFocusElement != null) {
					oFocusElement.title = highlightedNodeTitle.replace(/%1/, DTreeHandler.focusNode.name);
					oFocusElement.className = "dtreeItemHighlight";
					oFocusElement.focus();
				}
			}
		}
		else {
			if (DTreeHandler.selectedNodes.length > 0) {
				var lastSelectedNode = DTreeHandler.selectedNodes[DTreeHandler.selectedNodes.length - 1];
				var oLastSelectedElement = document.getElementById(lastSelectedNode.id + "-anchor");

				// Remains highlighted on last selected node.
				if (oLastSelectedElement != null) {
					oLastSelectedElement.title = highlightedNodeTitle.replace(/%1/, lastSelectedNode.name);
					oLastSelectedElement.className = "dtreeItemHighlight";
					oLastSelectedElement.focus();
				}
			}

			DTreeHandler.focusNode = this;
			DTreeHandler.selectedNodes[DTreeHandler.selectedNodes.length] = this;

			// Highlight the current node.
			var oFocusElement = document.getElementById(this.id + "-anchor");
			if (oFocusElement != null)	{
				oFocusElement.title = highlightedNodeTitle.replace(/%1/, this.name);
				oFocusElement.className = "dtreeItemHighlight";
				oFocusElement.focus();
			}
		}
	}
	else {
		DTreeHandler.deselectAllNodes();
		DTreeHandler.selectedNodes[0] = this;
		DTreeHandler.focusNode = this;
		var oFocusElement = document.getElementById(DTreeHandler.focusNode.id + "-anchor");
		if (oFocusElement != null) {
			if (this.onSelect)
				this.onSelect();

			oFocusElement.title = highlightedNodeTitle.replace(/%1/, DTreeHandler.focusNode.name);
			oFocusElement.className = "dtreeItemHighlight";
			oFocusElement.focus();
		}
	}
}

/**
 * Sets the icon image for this node.
 *
 * @param oIcon - a DTreeIcon object.
 */
DTreeAbstractNode.prototype.setIcon = function (oIcon) {
	this.icon = oIcon;
	this.userIcon = oIcon;
}

/**
 * Sets the open icon image for this node when this node is expanded.
 *
 * @param oOpenIcon - a DTreeIcon object.
 */
DTreeAbstractNode.prototype.setOpenIcon = function (oOpenIcon) {
	this.openIcon = oOpenIcon;
	this.userOpenIcon = oOpenIcon;
}

/**
 * Invokes and displays the context menu associated with this node.
 *
 * @param e - a window event that fires this action.
 */
DTreeAbstractNode.prototype.showContextMenu = function (e) {
	var menu = (typeof(this.contextMenu) == "string")?(DTreeHandler.menus[this.contextMenu]):(this.contextMenu);
	var posX = (e != null && e.keyCode == 99)?(DTreeHandler.getObjPageX(document.getElementById(this.id + "-anchor"))):(e.clientX);

	if (this.onBeforeShowContextMenu) {
		this.onBeforeShowContextMenu();
	}
	
	if (menu != null && typeof(menu) == "object") {
		this.hideContextMenu();
		var oCM = document.getElementById("ContextMenu");
		if (oCM == null) {
			var str = '<div id="ContextMenu" style="position: absolute; visibility: hidden;" onkeypress="DTreeHandler.doCMKeyPress(event);"></div>';
			DTreeHandler.insertHTMLBeforeEnd(document.body, str);
			oCM = document.getElementById("ContextMenu");
		}
		DTreeHandler.insertHTMLBeforeEnd(oCM, menu.toString(this.contextMenuUrlParam));
		var oMenu = document.getElementById("ContextMenu");
		var oItem = document.getElementById(this.id + "-item");

		oMenu.style.left = DTreeHandler.getContextMenuLeft(posX, oMenu.offsetWidth);
		oMenu.style.top = DTreeHandler.getContextMenuTop(DTreeHandler.getObjPageY(oItem), oMenu.offsetHeight, oItem.offsetHeight);
		oMenu.style.visibility = "visible";
		oMenu.focus();
	}
	
	if (this.onShowContextMenu) {
		this.onShowContextMenu();
	}
}

/**
 * Toggles this node to expand or collapse if there are child nodes.
 */
DTreeAbstractNode.prototype.toggle = function () {
	if (this.onBeforeToggle)
		this.onBeforeToggle();

	if (this.nodeType == "branch" || this.nodeType == "root") {
		if (this.opened)
			this.collapse();
		else {
			if (!this.childNodesLoaded && !this.hasChildNodes() && this.childrenUrlParam) {
				this.loadChildNodes();
				this.childNodesLoaded = true;
			}
			else
				this.expand();
		}

		var oElement = document.getElementById(this.id + "-anchor");

		// Focus on the toggling element.
		if (oElement != null)
			oElement.focus();
	}

	if (this.onToggle)
		this.onToggle();
}

/**
 * Returns the actual HTML code for rendering this node and all its child nodes.
 */
DTreeAbstractNode.prototype.toHTML = function () {
	var parentNode = this.parentNode;
	var indent = "";
	var str = "";
	
	// Only need indentation when this is not root.
	if (this.nodeType != "root") {
		// Do the indentation.
		while (parentNode != null && parentNode.parentNode) {
			indent = '<img alt="" onclick="DTreeHandler.preventScrolling();" src="' + ((parentNode.isLastChild())?(DTreeConfig.blankIcon):(DTreeConfig.iIcon)) + '"/>' + indent;
			parentNode = parentNode.parentNode;
		}

		// Indentation is required only if the tree has root node.
		if (DTreeConfig.showRoot) {
			indent = '<img alt="" onclick="DTreeHandler.preventScrolling();" src="' + DTreeConfig.blankIcon + '"/>' + indent;
		}

		str += indent;
	}

	// If this is a root node or there is no root node
	if (this.nodeType == "root" || (this.isFirstChild() && (this.parentNode != null && this.parentNode.nodeType == "root") && !DTreeConfig.showRoot))
		str += '<img alt="" id="' + this.id + '-connector" ondblclick="DTreeHandler.toggle(this.id, event);" onclick="DTreeHandler.toggle(this.id, event);" src="' + ((this.opened)?(DTreeConfig.minusIcon):(DTreeConfig.plusIcon)) + '"/>';
	// If this is a last branch node.
	else if (this.isLastChild() && this.nodeType == "branch")
		str += '<img alt="" id="' + this.id + '-connector" ondblclick="DTreeHandler.toggle(this.id, event);" onclick="DTreeHandler.toggle(this.id, event);" src="' + ((this.opened)?(DTreeConfig.lMinusIcon):(DTreeConfig.lPlusIcon)) + '"/>';
	// If this is a branch node, but not last node.
	else if (!this.isLastChild() && this.nodeType == "branch")
		str += '<img alt="" id="' + this.id + '-connector" ondblclick="DTreeHandler.toggle(this.id, event);" onclick="DTreeHandler.toggle(this.id, event);" src="' + ((this.opened)?(DTreeConfig.tMinusIcon):(DTreeConfig.tPlusIcon)) + '"/>';
	// If this is a last leaf node.
	else if (this.isLastChild() && this.nodeType == "leaf")
		str += '<img alt="" id="' + this.id + '-connector" src="' + DTreeConfig.lIcon + '" onclick="DTreeHandler.preventScrolling();"/>';
	// If this is a leaf node, but not last node.
	else if (!this.isLastChild() && this.nodeType == "leaf")
		str += '<img alt="" id="' + this.id + '-connector" src="' + DTreeConfig.tIcon + '" onclick="DTreeHandler.preventScrolling();"/>';

	// Display the correct folder icon.
	if (DTreeConfig.useFolderIcons && this.icon != null)
		str += '<img alt="" id="' + this.id + '-icon" class="dtreeIcon" onclick="DTreeHandler.toggle(this.id, event);" src="' + ((this.opened)?(this.openIcon):(this.icon)) + '"/>';

	// Display user icons.
	if (this.userIcons != null && this.userIcons.length) {
		for (var i = 0; i < this.userIcons.length; i++) {
			var src = (typeof(this.userIcons[i]) == "object")?(this.userIcons[i].source):(this.userIcons[i]);
			var title = (typeof(this.userIcons[i]) == "object")?(this.userIcons[i].title):("");
			str += '<img alt="' + title + '" title="' + title + '" id="' + this.id + '-userIcon-' + i + '" class="dtreeIcon" src="' + src + '" onclick="DTreeHandler.preventScrolling();"/>';
		}
	}

	// Display the action link and name.
	str += '<a id="' + this.id + '-anchor" ondblclick="DTreeHandler.toggle(this.id, event);" href="' +  this.action + '"';

	// Show context menu on appropriate button(s).
	if (!DTreeConfig.multiSelect) {
		// Enable context menu on left click.
		if (DTreeConfig.contextMenuButton == "left")
			str += ' onclick="DTreeHandler.selectNode(this.id); DTreeHandler.showContextMenu(this.id, event); return false;" oncontextMenu="return false;"';
		// Enable context menu on right click.
		else if (DTreeConfig.contextMenuButton == "right")
			str += ' onclick="DTreeHandler.selectNode(this.id); DTreeHandler.hideContextMenu(this.id, event); return false;" oncontextmenu="DTreeHandler.selectNode(this.id); DTreeHandler.showContextMenu(this.id, event); return false;"';
		// Enable context menu on both buttons.
		else if (DTreeConfig.contextMenuButton == "both")
			str += ' onclick="DTreeHandler.selectNode(this.id); DTreeHandler.showContextMenu(this.id, event); return false;" oncontextmenu="DTreeHandler.selectNode(this.id); DTreeHandler.showContextMenu(this.id, event); return false;"';
	}
	else {
		str += ' onclick="DTreeHandler.selectNode(this.id, event); return false;"';
	}

	str += ' onkeypress="DTreeHandler.doKeyPress(this.id, event); return false;" title="' + this.name + '">' + this.name + '</a>\n';
	
	return str;	
}

/**
 * Generates the HTML code for rendering this node and all its child nodes.
 */
DTreeAbstractNode.prototype.toString = function () {
	var str = "";

	str += '<div id="' + this.id + '-item" class="dtreeItem" style="display: block;">\n';
	str += this.toHTML();
	str += '</div>\n';

	// Display the children.
	str += '<div id="' + this.id + '-container" class="dtreeContainer" style="display: ' + ((this.opened)?('block'):('none')) + ';">\n'

	if(!isRenderChildrenOnDemand()){
	if (this.hasChildNodes()) {
		for (var i = 0; i < this.childNodes.length; i++)
			str += this.childNodes[i].toString();
		}
	}

	str += '</div>\n';
	this.rendered = true;

	return str;
}

/**
 * Updates the properties associated with this node.
 */
DTreeAbstractNode.prototype.updateProperties = function () {
	// virtual method to be implemented.
	return;
}

/**********************************************************************
 DTree
**********************************************************************/

/**
 * DTree root node object.
 *
 * @param sName - display name on the node
 * @param sValue - value associated with the node
 * @param sAction - action to be performed when clicking on the node. It can be an URL or javascript function
 * @param sChildrenUrlParam - parameters to fetch the child nodes
 * @param oContextMenu - context menu asscoiated with the node. It could be a ContextMenu object;
 *                       or a string type to denote that the context menu is a shared resource
 * @param sContextMenuUrlParam -  url parameter to pass to each context menu item action
 * @param oUserIcons - an array of user icons to be displayed on this node
 * @param sIcon - icon to be displayed when this node is collapsed or has no child nodes
 * @param sOpenIcon - icon to be displayed when this node is expanded
 */
function DTree(sName, sValue, sAction, sChildrenUrlParam, oContextMenu, sContextMenuUrlParam, oUserIcons, sIcon, sOpenIcon) {
	this.base = DTreeAbstractNode;
	this.base(sName, sValue, sAction, sChildrenUrlParam, oContextMenu, sContextMenuUrlParam);
	this.nodeType = "root";
	this.userIcons = (oUserIcons)?(oUserIcons):(null);
	this.userIcon = sIcon;
	this.userOpenIcon = sOpenIcon;
	this.icon = (this.userIcon)?(this.userIcon):(DTreeConfig.rootIcon);
	this.openIcon = (this.userOpenIcon)?(this.userOpenIcon):(DTreeConfig.openRootIcon);
	this.opened = false;
}

/**
 * Inherits all the methods from DTreeAbstractNode.
 */
DTree.prototype = new DTreeAbstractNode();

/**
 * Retrieves node in this tree by DTreeId.
 *
 * @param id - a DTreeId
 *
 * @return a DTreeItem object if found, or null otherwise
 */
DTree.prototype.getNodeById = function (id) {
	var dtreeNode = DTreeHandler.nodes[DTreeHandler.toDTreeId(id)];

	if (dtreeNode) {
		var root = dtreeNode.parentNode;

		// Make sure this node is inside the tree.
		while (root != null && root.parentNode)
			root = root.parentNode;

		return (root == this)?(dtreeNode):(null);
	}
	return null;
}

/**
 * Updates the properties of this node.
 */
DTree.prototype.updateProperties = function () {
	this.icon = (this.userIcon)?(this.userIcon):(DTreeConfig.rootIcon);
	this.openIcon = (this.userOpenIcon)?(this.userOpenIcon):(DTreeConfig.openRootIcon);
}

/**********************************************************************
 DTreeItem
**********************************************************************/

/**
 * DTreeItem node object.
 *
 * @param sName - display name on the node
 * @param sValue - value associated with the node
 * @param sAction - action to be performed when clicking on the node. It can be an URL or javascript function
 * @param sChildrenUrlParam - parameters to fetch the child nodes
 * @param oContextMenu - context menu asscoiated with the node. It could be a ContextMenu object;
 *                       or a string type to denote that the context menu is a shared resource
 * @param sContextMenuUrlParam -  url parameter to pass to each context menu item action
 * @param oUserIcons - an array of user icons to be displayed on this node
 * @param sIcon - icon to be displayed when this node is collapsed or has no child nodes
 * @param sOpenIcon - icon to be displayed when this node is expanded
 */
function DTreeItem(sName, sValue, sAction, sChildrenUrlParam, oContextMenu, sContextMenuUrlParam, oUserIcons, sIcon, sOpenIcon) {
	this.base = DTreeAbstractNode;
	this.base(sName, sValue, sAction, sChildrenUrlParam, oContextMenu, sContextMenuUrlParam);
	this.userIcons = (oUserIcons)?(oUserIcons):(null);
	this.userIcon = sIcon;
	this.userOpenIcon = sOpenIcon;
	this.opened = false;

	if (this.nodeType == "branch") {
		this.icon = (this.userIcon)?(this.userIcon):(DTreeConfig.folderIcon);
		this.openIcon = (this.userOpenIcon)?(this.userOpenIcon):(DTreeConfig.openFolderIcon);
	}
	else {
		this.icon = (this.userIcon)?(this.userIcon):(DTreeConfig.fileIcon);
		this.openIcon = this.icon;
	}

	if (!DTreeConfig.useFileIcon && this.nodeType == "leaf")
		this.icon = null;
}

/**
 * Inherits all the methods from DTreeAbstractNode.
 */
DTreeItem.prototype = new DTreeAbstractNode;

/**
 * Updates the properties of this node.
 */
DTreeItem.prototype.updateProperties = function () {
	this.nodeType = (this.hasChildNodes())?("branch"):("leaf");

	if (this.nodeType == "branch") {
		this.icon = (this.userIcon)?(this.userIcon):(DTreeConfig.folderIcon);
		this.openIcon = (this.userOpenIcon)?(this.userOpenIcon):(DTreeConfig.openFolderIcon);
	}
	else {
		this.icon = (this.userIcon)?(this.userIcon):(DTreeConfig.fileIcon);
		this.openIcon = this.icon;
	}

	if (!DTreeConfig.useFileIcon && this.nodeType == "leaf")
		this.icon = null;
}

/**********************************************************************
 ContextMenu
**********************************************************************/

/**
 * ContextMenu object.
 *
 * @param sType - an optional unique identifier to identify what type of context menu
 *                that will be shared with other DTreeItem
 */
function ContextMenu(sType) {
	this.type = (sType)?(sType):(null);
	this.menu = [];

	// Register this context menu to DTreeHandler.
	if (this.type)
		DTreeHandler.menus[this.type] = this;
}

/**
 * Adds a menu item to the context menu.
 *
 * @param sName - name to be displayed for this item
 * @param sAction - action associated with this item when it is clicked. It can be an URL or javascript function
 * @param bEnabled - flag to enable or disable this menu by default
 */
ContextMenu.prototype.addMenuItem = function (sName, sAction, bEnabled) {
	var index = this.menu.length;
	this.menu[index] = new Object();
	this.menu[index].name = sName;
	this.menu[index].action = (sAction)?(sAction):("javascript:void(0);");
	this.menu[index].enabled = (typeof(bEnabled) != "undefined")?(bEnabled):(true);
	this.menu[index].defaultEnabled = this.menu[index].enabled;
}

/**
 * Adds a menu separator to the context menu.
 */
ContextMenu.prototype.addMenuSeparator = function () {
	var index = this.menu.length;
	this.menu[index] = null;
}

/**
 * Disables a range of menu items.
 *
 * @param startIndex - inclusive start index menu item to be disabled
 * @param endIndex - inclusive end index menu item to be disabled
 */
ContextMenu.prototype.disableMenuItems = function (startIndex, endIndex) {
	var start = (typeof(startIndex) != "number" || startIndex < 0)?(0):(startIndex);
	var end = (typeof(endIndex) == "undefined" || typeof(endIndex) != "number")?(start):(endIndex);

	if (startIndex > endIndex) return;

	for (var i = start; i <= end; i++) {
		if (this.menu[i])
			this.menu[i].enabled = false;
	}
}

/**
 * Enables a range of menu items.
 *
 * @param startIndex - inclusive start index menu item to be enabled
 * @param endIndex - inclusive end index menu item to be enabled
 */
ContextMenu.prototype.enableMenuItems = function (startIndex, endIndex) {
	var start = (typeof(startIndex) != "number" || startIndex < 0)?(0):(startIndex);
	var end = (typeof(endIndex) == "undefined" || typeof(endIndex) != "number")?(start):(endIndex);

	if (startIndex > endIndex) return;

	for (var i = start; i <= end; i++) {
		if (this.menu[i])
			this.menu[i].enabled = true;
	}
}

/**
 * Returns the current size of the menu items in this context menu.
 *
 * @return current size of the menu items
 */
ContextMenu.prototype.getMenuLength = function () {
	return this.menu.length;
}

/**
 * Restores the original states for all the menu items.
 */
ContextMenu.prototype.restore = function () {
	for (var i = 0; i < this.menu.length; i++) {
		if (this.menu[i] != null)
			this.menu[i].enabled = this.menu[i].defaultEnabled;
	}
}

/**
 * Event listener on before showing the context menu.
 */
ContextMenu.prototype.onBeforeToString = function () {
	// virtual method to be implemented.
	return;
}

/**
 * Event listener on showing the context menu.
 *
 * @param str - HTML string for displaying the context menu
 *
 * @return HTML string
 */
ContextMenu.prototype.onToString = function (str) {
	// virtual method to be implemented.
	return str;
}

/**
 * Event listener on showing the context menu.
 *
 * @param sUrlParam - optional url parameter to be added to the menu item action if the action is an URL
 */
ContextMenu.prototype.toString = function (sUrlParam) {
	if (this.onBeforeToString)
		this.onBeforeToString();

	var str = '<table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td nowrap="nowrap">\n';
	str += '<div class="contextMenu" oncontextmenu="return false;">\n';

	for (var i = 0; i < this.menu.length; i++) {
		var item = this.menu[i];

		if (item == null) {
			str += '<div class="contextMenuSeparator"></div>\n';
		}
		else {
			str += (item.enabled)?('<div class="contextMenuItem">'):('<div class="contextMenuItemDisabled">');

			if (!item.enabled)
				str += '<a onclick="DTreeHandler.hideContextMenu();" href="' + DTreeConfig.defaultAction + '">';
			else if (item.action && sUrlParam && item.action.indexOf("javascript:") == -1)
				str += '<a onclick="DTreeHandler.hideContextMenu();" href="' + item.action + ((item.action.indexOf("?") == -1)?("?"):("&")) + sUrlParam + '">';
			else if (item.action.indexOf("javascript:") != -1)
				str += '<a onclick="DTreeHandler.hideContextMenu();" href="' + item.action + '">';
			else
				str += '<a target="" onclick="DTreeHandler.hideContextMenu();" href="' + item.action + '">';

			str += item.name + '</a></div>\n';
		}
	}

	str += '</div>\n'
	str += '</td></tr></tbody></table>\n';

	if (this.onToString)
		str = this.onToString(str);

	return str;
}

/**********************************************************************
 DTreeIcon
**********************************************************************/

/**
 * DTreeIcon object.
 *
 * @param sSource - image source location.
 * @param sTitle  - image title.
 */
function DTreeIcon(sSource, sTitle) {
	this.source = (sSource)?(sSource):("");
	this.title = (sTitle)?(sTitle):("");
}
var renderChildrenOnDemand = false;

setRenderChildrenOnDemand = function(renderChildren){
	renderChildrenOnDemand = renderChildren
}

isRenderChildrenOnDemand = function(){
	return renderChildrenOnDemand;
}
