<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.util.UIUtil" %>

<%@ include file="common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(campaignCommandContext.getLocale()) %>" type="text/css"/>

<style type='text/css'>
.selectWidth {
	width: 200px;
}

</style>

<title><%= campaignsRB.get("ProductBrowseContentPanelTitle") %></title>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
var allowMultipleObject = top.getData("allowMultiple", 1);
var allowMultiple = true;

if (allowMultipleObject != null) {
	allowMultiple = allowMultipleObject;
}

function loadPanelData () {
	if (parent.parent.setContentFrameLoaded) {
		parent.parent.setContentFrameLoaded(true);
	}
}

function finderChangeSpecialText (rawDisplayText, textOne, textTwo, textThree, textFour) {
	var displayText = rawDisplayText.replace(/%1/, textOne);
	if (textTwo != null)
		displayText = displayText.replace(/%2/, textTwo);
	if (textThree != null)
		displayText = displayText.replace(/%3/, textThree);
	if (textFour != null)
		displayText = displayText.replace(/%4/, textFour);
	return displayText;
}

function performAdd () {
	var localSelectionArray = new Array();
	var treeValue = "";
	var catentryNode = 0;

	if (parent.tree.getHighlightedNodes == undefined) {
		// fatal error!  getHighlightedNodes does not exist in the base frame.
		return;
	}

	// count number of selected catentry nodes in the tree
	for (var i=0; i<parent.tree.getHighlightedNodes().length; i++) {
		treeValue = parent.tree.getHighlightedNodes()[i].value;
		if ((treeValue == "") || (treeValue == null)) {
			// either catalog or category node, do nothing
		}
		else {
			catentryNode++;
		}
	}

	// if there is no selected catentry nodes in the tree, warn user and stop here
	if (catentryNode == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("ProductBrowseItemNotSpecified")) %>");
		return;
	}
	// if there are more than 1 selected catentry nodes in the tree and multiple selection is not
	// allowed, warn user and stop here
	else if (catentryNode > 1) {
		if (!allowMultiple) {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtMostOneSKU")) %>");
			return;
		}
	}

	// loop through each selected nodes, and save catentry data
	for (var i=0; i<parent.tree.getHighlightedNodes().length; i++) {
		treeValue = parent.tree.getHighlightedNodes()[i].value;
		if ((treeValue == "") || (treeValue == null)) {
			// either catalog or category node, do nothing
		}
		else {
			var selectTypeIndex = treeValue.indexOf("selectType=");
			var objectIdIndex = treeValue.indexOf("objectId=");
			var refNumIndex = treeValue.indexOf("objectRefNum=");
			var refNumEncodedIndex = treeValue.indexOf("objectEncodedRefNum=");
			var refNameIndex = treeValue.indexOf("objectRefName=");
			var selectType = treeValue.substring(selectTypeIndex+11, objectIdIndex-1);
			var objectId = trim(treeValue.substring(objectIdIndex+9, refNumIndex-1));
			var refnum = trim(treeValue.substring(refNumIndex+13, refNumEncodedIndex-1));
			var refnumEncoded = trim(treeValue.substring(refNumEncodedIndex+20, refNameIndex-1));
			var refName = trim(treeValue.substring(refNameIndex+14, treeValue.length));
			var displayText = refName + " (" + refnum + ")";

			// add new product to local sku array
			var localIndex = localSelectionArray.length;
			localSelectionArray[localIndex] = new Object();
			localSelectionArray[localIndex].selectType = selectType;
			localSelectionArray[localIndex].objectId = objectId;
			localSelectionArray[localIndex].refnum = refnum;
			localSelectionArray[localIndex].refnumEncoded = refnumEncoded;
			localSelectionArray[localIndex].refName = refName;
			localSelectionArray[localIndex].displayText = displayText;
		}
	}

	// go back to the browser's caller!
	top.sendBackData(localSelectionArray, "browserSelection");
	top.goBack();
}

function performCancel () {
	// take the user back to the previous entry in the model...
	top.goBack();
}
//-->
</script>
</head>

<body onload="loadPanelData();" class="content">

<h1><%= campaignsRB.get("ProductBrowsePrompt") %></h1>

</body>

</html>
