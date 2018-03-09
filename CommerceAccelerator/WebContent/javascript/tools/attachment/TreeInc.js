//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

DTreeAbstractNode.prototype.onSelect = function() { onSelectAttachmentTreeNode(); }

/////////////////////////////////////////////////////////////////////////////////////
// TreeNodeValueObj()
//
// - the value object attached to each node
/////////////////////////////////////////////////////////////////////////////////////
function TreeNodeValueObj(strId, strName, strPath, strTree)
{
	this.id   = strId;
	this.name = strName;
	this.path = strPath;
	this.tree = strTree;
}


/////////////////////////////////////////////////////////////////////////////////////
// onSelectAttachmentTreeNode()
//
// - callback function
/////////////////////////////////////////////////////////////////////////////////////
function onSelectAttachmentTreeNode()
{
	var nodeHighlighted = getHighlightedNode();
	var nodeValue       = eval(nodeHighlighted.value);

	if (nodeValue == null) return;

	if (parent.currentTreeNode != null && parent.currentTreeNode.id == nodeValue.id) return;

	parent.currentTreeNode = nodeValue;
	parent.setBrowseResultListFrame(nodeValue.id);
}

function onDataFetched()
{
	if (parent.startBrowseTree != null) gotoAndHighlightByName(parent.startBrowseTree);
}

