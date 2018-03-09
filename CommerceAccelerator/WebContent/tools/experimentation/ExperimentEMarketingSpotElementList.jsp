<!-- ==================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2005
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.tools.experimentation.ExperimentRuleConstants,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= experimentRB.get("experimentEMarketingSpotElementListTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/experimentation/Experiment.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var selectedExperimentType = null;
var elementSelectionContainer = new Array();
var initialLoad = true;

function loadPanelData () {
	// initialization routine for dynamic list
	parent.loadFrames();

	// initializes element selection container
	for (var i=0; i<parent.parent.experimentRuleDefinition.testElements.testElement.length; i++) {
		elementSelectionContainer[i] = false;
	}

	// load value for experiment type and update the test element list accordingly
	selectedExperimentType = parent.parent.experimentRuleDefinition.testElements.type;
	if (selectedExperimentType == "") {
		parent.parent.updateExperimentType();
	}
	else {
		updateExperimentType();
	}
}

function isElementInCurrentType (elementIndex) {
	return parent.parent.experimentRuleDefinition.testElements.testElement[elementIndex].testElementType == selectedExperimentType;
}

function newTestElement () {
	// persist panel data
	parent.parent.persistPanelData();

	// launch the appropriate panel according to the experiment type
	var url = "";
	if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>") {
		top.saveData("testElementActivitySelection", "pageActionType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&fromPanel=experiment";
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createInitiative")) %>", url, true);
	}
	else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT %>") {
		top.saveData("testElementSegmentSelection", "pageActionType");
		url = "<%= UIUtil.getWebappPath(request) %>SegmentNotebookView?XMLFile=segmentation.SegmentNotebook&newSegment=true";
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createSegment")) %>", url, true);
	}
}

function changeTestElement () {
	// persist panel data
	parent.parent.persistPanelData();

	// get test element object ID based on the checkbox value
	var checked = parent.getChecked();
	var objectId = "";
	var storeId = "";
	if (checked.length > 0) {
		objectId = parent.parent.experimentRuleDefinition.testElements.testElement[checked[0]].testElementObject[0].testElementObjectId;
		storeId = parent.parent.experimentRuleDefinition.testElements.testElement[checked[0]].testElementObject[0].testElementStoreId;
	}

	// launch the appropriate panel according to the experiment type
	if (storeId == "<%= experimentCommandContext.getStoreId() %>") {
		var url = "";
		if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>") {
			top.saveData("testElementActivitySelection", "pageActionType");
			url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + objectId + "&fromPanel=experiment";
			top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("updateInitiative")) %>", url, true);
		}
		else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT %>") {
			top.saveData("testElementSegmentSelection", "pageActionType");
			url = "<%= UIUtil.getWebappPath(request) %>SegmentNotebookView?XMLFile=segmentation.SegmentNotebookChange&segmentId=" + objectId;
			top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("updateSegment")) %>", url, true);
		}
	}
	else {
		alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("listEntryCannotBeModified")) %>");
	}
}

function summaryTestElement () {
	// persist panel data
	parent.parent.persistPanelData();

	// get test element object ID based on the checkbox value
	var checked = parent.getChecked();
	var objectId = "";
	if (checked.length > 0) {
		objectId = parent.parent.experimentRuleDefinition.testElements.testElement[checked[0]].testElementObject[0].testElementObjectId;
	}

	// launch the appropriate panel according to the experiment type
	if (objectId != "") {
		var url = "";
		if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>") {
			url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSummaryDialog&initiativeId=" + objectId;
			top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryInitiative")) %>", url, true);
		}
		else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_CONTENT %>") {
			var selectedContentType = parent.parent.experimentRuleDefinition.testElements.testElement[checked[0]].testElementObject[0].testElementObjectType;
			if (selectedContentType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>") {
				url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=RLPromotion.RLDiscountDetails&calcodeId=" + objectId;
				top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryPromotion")) %>", url, true);
			}
			else if (selectedContentType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL %>") {
				url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignsCollateralPreviewDialog&collateralId=" + objectId;
				top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryCollateral")) %>", url, true);
			}
			else {
				alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("contentSummaryNotAvailable")) %>");
			}
		}
		else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT %>") {
			url = "<%= UIUtil.getWebappPath(request) %>SegmentDetailsDialogView?XMLFile=segmentation.SegmentDetailsDialog&segmentId=" + objectId;
			top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summarySegment")) %>", url, true);
		}
		else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT %>") {
			url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.EmsSummaryDialog&emsId=" + objectId;
			top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryEms")) %>", url, true);
		}
	}
}

function addTestElement () {
	// persist panel data
	parent.parent.persistPanelData();

	// launch the appropriate panel according to the experiment type
	var url = "";
	if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>") {
		top.saveData("testElementActivitySelection", "pageActionType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSelectionDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("initiativeSelection")) %>", url, true);
	}
	else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_CONTENT %>") {
		top.saveData("testElementContentSelection", "pageActionType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=experiment.ExperimentContentSelectionDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("contentSelection")) %>", url, true);
	}
	else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT %>") {
		top.saveData("testElementSegmentSelection", "pageActionType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=segmentation.SegmentSelectionDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("segmentSelection")) %>", url, true);
	}
	else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT %>") {
		top.saveData("testElementSpotSelection", "pageActionType");
		url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.EmsSelectionDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("emsSelection")) %>", url, true);
	}
}

function removeTestElement () {
	// rebuild the test element list
	var oldTestElementData = parent.parent.experimentRuleDefinition.testElements.testElement;
	var newTestElementData = new Array();
	var dataIndex = 0;
	for (var i=0; i<parent.getChecked().length; i++) {
		for (var j=0; j<oldTestElementData.length; j++) {
			if (parent.getChecked()[i] == j.toString()) {
				oldTestElementData[j] = null;
				break;
			}
		}
	}
	for (var i=0; i<oldTestElementData.length; i++) {
		if (oldTestElementData[i] != null) {
			newTestElementData[dataIndex] = oldTestElementData[i];
			dataIndex++;
		}
	}
	parent.parent.experimentRuleDefinition.testElements.testElement = newTestElementData;

	// refresh this list page to display the updated list of test element data
	parent.location.reload();
}

function updateExperimentType () {
	// show or hide rows and content type column according to the experiment type
	var testElementData = parent.parent.experimentRuleDefinition.testElements.testElement;
	var numberOfElementInList = 0;
	for (var i=0; i<testElementData.length; i++) {
		if (isElementInCurrentType(i)) {
			if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_CONTENT %>") {
				document.all("typeColumn_" + i).style.display = "block";
			}
			else {
				document.all("typeColumn_" + i).style.display = "none";
			}
			document.all("row_" + i).style.display = "block";
			numberOfElementInList++;
		}
		else {
			document.all("row_" + i).style.display = "none";
		}
	}

	// show or hide buttons and content type column, and display list empty message if necessary
	// according to the experiment type
	document.all.listEmptyMessage.innerText = "";
	if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>" || selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT %>") {
		document.all.contentTypeColumnHeader.style.display = "none";
		parent.displayButton("new");
		parent.displayButton("properties");
		if (numberOfElementInList == 0) {
			document.all.listEmptyMessage.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("experimentElementListEmpty")) %>";
		}
	}
	else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_CONTENT %>") {
		document.all.contentTypeColumnHeader.style.display = "block";
		parent.hideButton("new");
		parent.hideButton("properties");
		if (numberOfElementInList == 0) {
			document.all.listEmptyMessage.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("experimentElementListEmptyNoNewOption")) %>";
		}
	}
	else if (selectedExperimentType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT %>") {
		document.all.contentTypeColumnHeader.style.display = "none";
		parent.hideButton("new");
		parent.hideButton("properties");
		if (numberOfElementInList == 0) {
			document.all.listEmptyMessage.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("experimentElementListEmptyNoNewOption")) %>";
		}
	}

	// refresh checkboxes and buttons state
	refreshCheckBoxes();
}

function refreshCheckBoxes () {
	// skip this method if this is called during page onload
	if (initialLoad) {
		initialLoad = false;
		return;
	}

	// add or remove checkbox objects in the parent according to the selection in the UI
	for (var i=0; i<elementSelectionContainer.length; i++) {
		if (elementSelectionContainer[i] && isElementInCurrentType(i)) {
			document.all(i.toString()).checked = true;
			if (!parent.checkeds.contains(i)) {
				parent.checkeds.addElement(i);
			}
		}
		else {
			document.all(i.toString()).checked = false;
			if (parent.checkeds.contains(i)) {
				parent.checkeds.removeElement(i);
			}
		}
	}

	// enable or disable buttons according to the number of selected checkboxes
	var numberOfSelected = parent.getChecked().length;
	if (numberOfSelected == 1) {
		parent.AdjustRefreshButton(parent.buttons.buttonForm.propertiesButton, "enabled");
		parent.AdjustRefreshButton(parent.buttons.buttonForm.summaryButton, "enabled");
	}
	else {
		parent.AdjustRefreshButton(parent.buttons.buttonForm.propertiesButton, "disabled");
		parent.AdjustRefreshButton(parent.buttons.buttonForm.summaryButton, "disabled");
	}
	if (numberOfSelected >= 1) {
		parent.AdjustRefreshButton(parent.buttons.buttonForm.removeButton, "enabled");
	}
	else {
		parent.AdjustRefreshButton(parent.buttons.buttonForm.removeButton, "disabled");
	}
}

function selectSingleClicked (checkboxIndex, checkboxObj) {
	elementSelectionContainer[checkboxIndex] = checkboxObj.checked;
	refreshCheckBoxes();
}

function selectAllClicked () {
	for (var i=0; i<elementSelectionContainer.length; i++) {
		if (isElementInCurrentType(i)) {
			elementSelectionContainer[i] = document.experimentTestElementForm.select_deselect.checked;
		}
	}
	refreshCheckBoxes();
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content_list" style="margin-left: 0px; margin-top: 0px;">

<form name="experimentTestElementForm" id="experimentTestElementForm">

<%= comm.startDlistTable((String)experimentRB.get("experimentElementListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "selectAllClicked()") %>
<%= comm.addDlistColumnHeading((String)experimentRB.get("experimentElementListElementColumn"), null, false, null, false) %>
<%= comm.addDlistColumnHeading((String)experimentRB.get("experimentElementListRatioColumn"), null, false, null, false) %>
<th id="contentTypeColumnHeader" name="contentTypeColumnHeader" class="list_header" style="display:none;"><%= (String)experimentRB.get("experimentElementListContentTypeColumn") %></th>
<%= comm.endDlistRow() %>

<script language="JavaScript">
<!-- hide script from old browsers
var rowselect = 1;
var testElementData = parent.parent.experimentRuleDefinition.testElements.testElement;

for (var i=0; i<testElementData.length; i++) {
	document.writeln('<tr id="row_' + i + '" name="row_' + i + '" class="list_row' + rowselect + '" onmouseover="parent.tempClass=this.className;this.className=\'list_row3\';" onmouseout="this.className=parent.tempClass">');
	addDlistCheck(i, "selectSingleClicked(" + i + ", this)");

	// element name column for the current test element
	var nameText = testElementData[i].testElementObject[0].testElementName;
	addDlistColumn(nameText, "none");

	// ratio column for the current test element
	document.writeln('<td id="ratioColumn_' + i + '" name="ratioColumn_' + i + '" class="list_info1">');
	document.writeln('<input type="text" id="testElementRatio_' + i + '" name="testElementRatio_' + i + '" size="5" maxlength="3" value="' + testElementData[i].testElementRatio + '">');
	document.writeln('</td>');

	// content type for the current test element
	var contentTypeText = "";
	var thisContentType = testElementData[i].testElementObject[0].testElementObjectType;
	if (thisContentType == "<%= UIUtil.toJavaScript(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION) %>") {
		contentTypeText = "<%= UIUtil.toJavaScript((String)experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION + "ContentType")) %>";
	}
	else if (thisContentType == "<%= UIUtil.toJavaScript(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION) %>") {
		contentTypeText = "<%= UIUtil.toJavaScript((String)experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION + "ContentType")) %>";
	}
	else if (thisContentType == "<%= UIUtil.toJavaScript(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION) %>") {
		contentTypeText = "<%= UIUtil.toJavaScript((String)experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION + "ContentType")) %>";
	}
	else if (thisContentType == "<%= UIUtil.toJavaScript(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL) %>") {
		contentTypeText = "<%= UIUtil.toJavaScript((String)experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL + "ContentType")) %>";
	}
	else if (thisContentType == "<%= UIUtil.toJavaScript(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_UP_SELL) %>") {
		contentTypeText = "<%= UIUtil.toJavaScript((String)experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_UP_SELL + "ContentType")) %>";
	}
	else if (thisContentType == "<%= UIUtil.toJavaScript(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CROSS_SELL) %>") {
		contentTypeText = "<%= UIUtil.toJavaScript((String)experimentRB.get(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CROSS_SELL + "ContentType")) %>";
	}
	document.writeln('<td id="typeColumn_' + i + '" name="typeColumn_' + i + '" class="list_info1" style="display:none;">');
	document.writeln(contentTypeText);
	document.writeln('</td>');

	document.writeln('</tr>');

	if (rowselect == 1) {
		rowselect = 2;
	}
	else {
		rowselect = 1;
	}
}
//-->
</script>

<%= comm.endDlistTable() %>

<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<p/><p/>');
document.writeln('<div id="listEmptyMessage"></div>');
//-->
</script>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(testElementData.length);
parent.setButtonPos("0px", "-10px");
//-->
</script>

</body>

</html>