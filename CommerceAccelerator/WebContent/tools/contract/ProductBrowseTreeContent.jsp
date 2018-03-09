<!-- ==========================================================================
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
===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
	import="com.ibm.commerce.tools.util.UIUtil" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="ContractCommon.jsp" %>

<html>

<head>
<%= fHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<style type='text/css'>
.selectWidth {width: 200px;}

</style>

<title><%= contractsRB.get("contractProductBrowseContentPanelTitle") %></title>

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/ContractUtil.js">
</script>
<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/contract/Pricing.js">
</script>

<script LANGUAGE="JavaScript">
<!---- hide script from old browsers
var skuArray = top.getData("browserSelectionArray", 1);
var allowMultipleObject = top.getData("allowMultiple", 1);
var localSelectionArray = top.getData("localSelectionArray", null);
var allowMultiple = true;

if (localSelectionArray == null) {
	localSelectionArray = new Array();
}
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
	var treeValue = null;
	if (parent.tree.getHighlightedNode != undefined) {
		var treeNode = parent.tree.getHighlightedNode();
		if (treeNode != null) {
			treeValue = treeNode.value;
		}
	}

	if (treeValue == null) {
		alertDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductBrowseItemNotSpecified")) %>");
		return;
	}

	var sep1Index = treeValue.indexOf("|");
	var sep2Index = treeValue.substring(sep1Index+1, treeValue.length).indexOf("|") + sep1Index + 1;
	var sep3Index = treeValue.substring(sep2Index+1, treeValue.length).indexOf("|") + sep2Index + 1;
	var sep4Index = treeValue.substring(sep3Index+1, treeValue.length).indexOf("|") + sep3Index + 1;
	var sep5Index = treeValue.substring(sep4Index+1, treeValue.length).indexOf("|") + sep4Index + 1;
	var sep6Index = treeValue.substring(sep5Index+1, treeValue.length).indexOf("|") + sep5Index + 1;
	var sep7Index = treeValue.substring(sep6Index+1, treeValue.length).indexOf("|") + sep6Index + 1;
	var sep8Index = treeValue.substring(sep7Index+1, treeValue.length).indexOf("|") + sep7Index + 1;
	var sep9Index = treeValue.substring(sep8Index+1, treeValue.length).indexOf("|") + sep8Index + 1;
	var selectType = treeValue.substring(0, sep1Index);
	var refnum = treeValue.substring(sep1Index+1, sep2Index);
	var memberId = treeValue.substring(sep2Index+1, sep3Index);
	var memberType = treeValue.substring(sep3Index+1, sep4Index);
	var memberDN = treeValue.substring(sep4Index+1, sep5Index);
	var memberGroupName = treeValue.substring(sep5Index+1, sep6Index);
	var memberGroupOwnerMemberType = treeValue.substring(sep6Index+1, sep7Index);
	var memberGroupOwnerMemberDN = treeValue.substring(sep7Index+1, sep8Index);
	var identifier = treeValue.substring(sep8Index+1, sep9Index);
	var displayText = treeValue.substring(sep9Index+1, treeValue.length);

	for (var i=0; i<localSelectionArray.length; i++) {
		if ((localSelectionArray[i].type == selectType) && (localSelectionArray[i].refnum == refnum)) {
			alertDialog(finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductBrowseSelectionAlreadyExists")) %>", displayText));
			return;
		}
	}

	// add new category or item to local sku array
	var memberObj = new Member(memberType, memberDN, memberGroupName, memberGroupOwnerMemberType, memberGroupOwnerMemberDN);
	localSelectionArray[localSelectionArray.length] = new CatEntry(displayText, refnum, identifier, memberObj, selectType);

	if (allowMultiple) {
		if (selectType == "CG") {
			alertDialog(finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductBrowseCategoryAdded")) %>", displayText));
		}
		else if (selectType == "CE") {
			alertDialog(finderChangeSpecialText("<%= UIUtil.toJavaScript((String)contractsRB.get("contractProductBrowseProductAdded")) %>", displayText));
		}
		top.saveData(localSelectionArray, "localSelectionArray");
	}
	else {
		performFinish();
	}
}

function performFinish () {
	var duplicateCheck = false;

	if (skuArray != null) {
		// add new category or item to skuArray
		// if duplicate is found, do nothing and move to the next item
		for (var i=0; i<localSelectionArray.length; i++) {
			for (var j=0; j<skuArray.length; j++) {
				if ((localSelectionArray[i].type == skuArray[j].type) && (localSelectionArray[i].refnum == skuArray[j].refnum)) {
					duplicateCheck = true;
					break;
				}
			}
			if (!duplicateCheck) {
				skuArray[skuArray.length] = localSelectionArray[i];
			}
			else {
				duplicateCheck = false;
			}
		}
	}

	// go back to the finder's caller!
	top.saveData(null, "localSelectionArray");
	top.goBack();
}

function performCancel () {
	// take the user back to the previous entry in the model...
	top.goBack();
}
//-->

</script>
</head>

<body onLoad="loadPanelData();" class="content">

<h1><%= contractsRB.get("contractProductBrowsePrompt") %></h1>

</body>

</html>
