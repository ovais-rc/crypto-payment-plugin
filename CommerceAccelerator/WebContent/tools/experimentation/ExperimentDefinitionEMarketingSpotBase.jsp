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
<%@ page import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.experimentation.dependency.*,
	com.ibm.commerce.experimentation.util.ExperimentUtil,
	com.ibm.commerce.tools.experimentation.ExperimentConstants,
	com.ibm.commerce.tools.experimentation.ExperimentRuleConstants,
	com.ibm.commerce.tools.experimentation.ExperimentRuleDefinition,
	com.ibm.commerce.tools.experimentation.beans.ExperimentDataBean,
	com.ibm.commerce.tools.experimentation.beans.ExperimentTypeDataBean,
	com.ibm.commerce.tools.experimentation.beans.ExperimentTypeListDataBean" %>

<%@ include file="common.jsp" %>

<%
	ExperimentDataBean experimentDataBean = null;
	String experimentId = request.getParameter("experimentId");
	if (experimentId != null && !experimentId.equals("")) {
		experimentDataBean = new ExperimentDataBean();
		experimentDataBean.setId(Integer.valueOf(experimentId));
		experimentDataBean.setCommandContext(experimentCommandContext);
		experimentDataBean.populate();
	}
%>

<script language="JavaScript">
<!-- hide script from old browsers
// put ratio limit size to parent
parent.put("displayFrequencyTotalSize", "<%= experimentRB.get("displayFrequencyTotalSize") %>");

// populate rule definition object if it does not exist
var experimentRuleDefinition = top.getData("experimentRuleDefinition");
if (experimentRuleDefinition == null) {
	experimentRuleDefinition = new Object();
	experimentRuleDefinition.storeElementType = "";
	experimentRuleDefinition.storeElementObjectId = "";
	experimentRuleDefinition.storeElementName = "";
	experimentRuleDefinition.controlElementId = "";
	experimentRuleDefinition.controlElementRatio = "";
	experimentRuleDefinition.controlElementType = "";
	experimentRuleDefinition.controlElementObjectId = "";
	experimentRuleDefinition.controlElementName = "";
	experimentRuleDefinition.controlElementStoreId = "";
	experimentRuleDefinition.testElements = new Object();
	experimentRuleDefinition.testElements.idCounter = "";
	experimentRuleDefinition.testElements.type = "";
	experimentRuleDefinition.testElements.testElement = new Array();
<%
	if (experimentDataBean != null) {
		ExperimentRuleDefinition ruleObj = experimentDataBean.getRuleDefinition();
		if (ruleObj != null) {
			if (ruleObj.getStoreElementKey().getObjectId() != null) {
%>
	experimentRuleDefinition.storeElementType = "<%= UIUtil.toJavaScript(ruleObj.getStoreElementType()) %>";
	experimentRuleDefinition.storeElementObjectId = "<%= ruleObj.getStoreElementKey().getObjectId() %>";
	experimentRuleDefinition.storeElementName = "<%= UIUtil.toJavaScript(ruleObj.getStoreElementName()) %>";
<%
			}
			if (ruleObj.getControlElementKey().getObjectId() != null) {
				InitiativeKey controlElementKey = (InitiativeKey) ruleObj.getControlElementKey();
%>
	experimentRuleDefinition.controlElementId = "<%= ruleObj.getControlElementId() %>";
	experimentRuleDefinition.controlElementRatio = "<%= ruleObj.getControlElementRatio() %>";
	experimentRuleDefinition.controlElementType = "<%= UIUtil.toJavaScript(ruleObj.getControlElementType()) %>";
	experimentRuleDefinition.controlElementObjectId = "<%= ruleObj.getControlElementKey().getObjectId() %>";
	experimentRuleDefinition.controlElementName = "<%= UIUtil.toJavaScript(ruleObj.getControlElementName()) %>";
	experimentRuleDefinition.controlElementStoreId = "<%= ExperimentUtil.getStoreIdByIdentifier(controlElementKey.getStoreIdentifier(), controlElementKey.getStoreMemberDN()) %>";
<%			} %>
	experimentRuleDefinition.testElements.idCounter = "<%= ruleObj.getTestElementIdCounter() %>";
	experimentRuleDefinition.testElements.type = "<%= UIUtil.toJavaScript(ruleObj.getExperimentType()) %>";
<%
			int testElementCounter = 0;
			for (int i=0; i<ruleObj.getTestElementId().size(); i++) {
				if (((DynamicKey)ruleObj.getTestElementKey().elementAt(i)).getObjectId() != null) {
%>
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>] = new Object();
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementId = "<%= ruleObj.getTestElementId().elementAt(i) %>";
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementRatio = "<%= ruleObj.getTestElementRatio().elementAt(i) %>";
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementType = "<%= UIUtil.toJavaScript(ruleObj.getExperimentType()) %>";
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementObject = new Array();
<%
					String thisTestElementType = (String) ruleObj.getTestElementType().elementAt(i);
					Vector thisTestElementObjectType = new Vector();
					Vector thisTestElementObjectId = new Vector();
					Vector thisTestElementName = new Vector();
					Vector thisTestElementStoreId = new Vector();
					if (ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION.equals(thisTestElementType)) {
						PromotionKey thisKey = (PromotionKey) ruleObj.getTestElementKey().elementAt(i);
						thisTestElementObjectType.addElement(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION);
						thisTestElementObjectId.addElement(thisKey.getCalcodeId());
						thisTestElementName.addElement(thisKey.getCalcodeCode());
						thisTestElementStoreId.addElement("");
						for (int j=0; j<thisKey.getCollateralKey().length; j++) {
							thisTestElementObjectType.addElement(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION_COLLATERAL);
							thisTestElementObjectId.addElement(thisKey.getCollateralKey()[j].getCollateralId());
							thisTestElementName.addElement(thisKey.getCollateralKey()[j].getCollateralName());
							thisTestElementStoreId.addElement("");
						}
					}
					else if (ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_ACTIVITY.equals(thisTestElementType)) {
						InitiativeKey thisKey = (InitiativeKey) ruleObj.getTestElementKey().elementAt(i);
						thisTestElementObjectType.addElement(thisTestElementType);
						thisTestElementObjectId.addElement(thisKey.getInitiativeId());
						thisTestElementName.addElement(thisKey.getInitiativeName());
						thisTestElementStoreId.addElement(ExperimentUtil.getStoreIdByIdentifier(thisKey.getStoreIdentifier(), thisKey.getStoreMemberDN()));
					}
					else if (ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SEGMENT.equals(thisTestElementType)) {
						SegmentKey thisKey = (SegmentKey) ruleObj.getTestElementKey().elementAt(i);
						thisTestElementObjectType.addElement(thisTestElementType);
						thisTestElementObjectId.addElement(thisKey.getSegmentId());
						thisTestElementName.addElement(thisKey.getSegmentName());
						thisTestElementStoreId.addElement(ExperimentUtil.getStoreIdByMemberGroupId(thisKey.getSegmentId(), experimentCommandContext));
					}
					else {
						DynamicKey thisKey = (DynamicKey) ruleObj.getTestElementKey().elementAt(i);
						thisTestElementObjectType.addElement(thisTestElementType);
						thisTestElementObjectId.addElement(thisKey.getObjectId());
						thisTestElementName.addElement(ruleObj.getTestElementName().elementAt(i));
						thisTestElementStoreId.addElement("");
					}
					for (int j=0; j<thisTestElementObjectType.size(); j++) {
%>
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementObject[<%= j %>] = new Object();
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementObject[<%= j %>].testElementObjectType = "<%= UIUtil.toJavaScript(thisTestElementObjectType.elementAt(j)) %>";
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementObject[<%= j %>].testElementObjectId = "<%= thisTestElementObjectId.elementAt(j) %>";
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementObject[<%= j %>].testElementName = "<%= UIUtil.toJavaScript(thisTestElementName.elementAt(j)) %>";
	experimentRuleDefinition.testElements.testElement[<%= testElementCounter %>].testElementObject[<%= j %>].testElementStoreId = "<%= UIUtil.toJavaScript(thisTestElementStoreId.elementAt(j).toString()) %>";
<%
					}
					testElementCounter++;
				}
			}
		}
	}
%>
	top.saveData(experimentRuleDefinition, "experimentRuleDefinition");
}

// find out the kind of selection result needs to be populated to this panel
var pageActionType = top.getData("pageActionType");
if (pageActionType != null) {
	if (pageActionType == "storeElementSelection") {
		// load e-Marketing Spot data from the selection panel into this one
		var emsResult = top.getData("emsResult");
		if (emsResult != null) {
			experimentRuleDefinition.storeElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT %>";
			experimentRuleDefinition.storeElementObjectId = emsResult[0].emsId;
			experimentRuleDefinition.storeElementName = emsResult[0].emsName;
			top.saveData(null, "emsResult");
		}
	}
	else if (pageActionType == "controlElementSelection") {
		// load initiative data from the selection panel into this one
		var initiativeResult = top.getData("initiativeResult");
		if (initiativeResult != null) {
			experimentRuleDefinition.controlElementId = "0";
			experimentRuleDefinition.controlElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>";
			experimentRuleDefinition.controlElementObjectId = initiativeResult[0].initiativeId;
			experimentRuleDefinition.controlElementName = initiativeResult[0].initiativeName;
			experimentRuleDefinition.controlElementStoreId = initiativeResult[0].initiativeStoreId;

			// pre-fill e-Marketing Spot data from the selection panel into this one if it is available
			if (initiativeResult[0].scheduledEmsId != undefined && initiativeResult[0].scheduledEmsId != "") {
				experimentRuleDefinition.storeElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT %>";
				experimentRuleDefinition.storeElementObjectId = initiativeResult[0].scheduledEmsId;
				experimentRuleDefinition.storeElementName = initiativeResult[0].scheduledEmsName;
			}

			top.saveData(null, "initiativeResult");
		}
	}
	else if (pageActionType == "testElementActivitySelection") {
		// load initiative data from the selection panel into this one
		var initiativeResult = top.getData("initiativeResult");
		if (initiativeResult != null) {
			for (var i=0; i<initiativeResult.length; i++) {
				var isDuplicateFound = false;
				for (var j=0; j<experimentRuleDefinition.testElements.testElement.length; j++) {
					if (experimentRuleDefinition.testElements.testElement[j].testElementType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>" && initiativeResult[i].initiativeId == experimentRuleDefinition.testElements.testElement[j].testElementObject[0].testElementObjectId) {
						experimentRuleDefinition.testElements.testElement[j].testElementObject[0].testElementName = initiativeResult[i].initiativeName;
						isDuplicateFound = true;
						break;
					}
				}
				if (!isDuplicateFound) {
					var currentIndex = experimentRuleDefinition.testElements.testElement.length;
					experimentRuleDefinition.testElements.testElement[currentIndex] = new Object();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementId = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementRatio = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY %>";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject = new Array();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0] = new Object();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_ACTIVITY %>";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectId = initiativeResult[i].initiativeId;
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementName = initiativeResult[i].initiativeName;
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementStoreId = initiativeResult[i].initiativeStoreId;
				}
			}
			top.saveData(null, "initiativeResult");
		}
	}
	else if (pageActionType == "testElementContentSelection") {
		// load content data from the selection panel into this one
		var contentResult = top.getData("contentResult");
		var contentResultType = top.getData("contentResultType");
		if (contentResult != null) {
			if (contentResultType == "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION %>") {
				var isDuplicateFound = false;
				for (var i=0; i<experimentRuleDefinition.testElements.testElement.length; i++) {
					if (experimentRuleDefinition.testElements.testElement[i].testElementObject[0].testElementObjectType == contentResultType && contentResult[0].id == experimentRuleDefinition.testElements.testElement[i].testElementObject[0].testElementObjectId) {
						isDuplicateFound = true;
						break;
					}
				}
				if (!isDuplicateFound) {
					var currentIndex = experimentRuleDefinition.testElements.testElement.length;
					experimentRuleDefinition.testElements.testElement[currentIndex] = new Object();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementId = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementRatio = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_CONTENT %>";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject = new Array();
					for (var i=0; i<contentResult.length; i++) {
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[i] = new Object();
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[i].testElementObjectType = contentResult[i].type;
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[i].testElementObjectId = contentResult[i].id;
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[i].testElementName = contentResult[i].name;
					}
				}
			}
			else {
				for (var i=0; i<contentResult.length; i++) {
					var isDuplicateFound = false;
					for (var j=0; j<experimentRuleDefinition.testElements.testElement.length; j++) {
						if (experimentRuleDefinition.testElements.testElement[j].testElementObject[0].testElementObjectType == contentResultType && contentResult[i].id == experimentRuleDefinition.testElements.testElement[j].testElementObject[0].testElementObjectId) {
							isDuplicateFound = true;
							break;
						}
					}
					if (!isDuplicateFound) {
						var currentIndex = experimentRuleDefinition.testElements.testElement.length;
						experimentRuleDefinition.testElements.testElement[currentIndex] = new Object();
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementId = "";
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementRatio = "";
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_CONTENT %>";
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject = new Array();
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0] = new Object();
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectType = contentResultType;
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectId = contentResult[i].id;
						experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementName = contentResult[i].name;
					}
				}
			}
			top.saveData(null, "contentResult");
			top.saveData(null, "contentResultType");
		}
	}
	else if (pageActionType == "testElementSegmentSelection") {
		// load segment data from the selection panel into this one
		var segmentResult = top.getData("segmentResult");
		if (segmentResult != null) {
			for (var i=0; i<segmentResult.length; i++) {
				var isDuplicateFound = false;
				for (var j=0; j<experimentRuleDefinition.testElements.testElement.length; j++) {
					if (experimentRuleDefinition.testElements.testElement[j].testElementType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT %>" && segmentResult[i].segmentId == experimentRuleDefinition.testElements.testElement[j].testElementObject[0].testElementObjectId) {
						experimentRuleDefinition.testElements.testElement[j].testElementObject[0].testElementName = segmentResult[i].segmentName;
						isDuplicateFound = true;
						break;
					}
				}
				if (!isDuplicateFound) {
					var currentIndex = experimentRuleDefinition.testElements.testElement.length;
					experimentRuleDefinition.testElements.testElement[currentIndex] = new Object();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementId = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementRatio = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT %>";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject = new Array();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0] = new Object();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SEGMENT %>";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectId = segmentResult[i].segmentId;
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementName = segmentResult[i].segmentName;
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementStoreId = segmentResult[i].segmentStoreId;
				}
			}
			top.saveData(null, "segmentResult");
		}
	}
	else if (pageActionType == "testElementSpotSelection") {
		// load e-Marketing Spot data from the selection panel into this one
		var emsResult = top.getData("emsResult");
		if (emsResult != null) {
			for (var i=0; i<emsResult.length; i++) {
				var isDuplicateFound = false;
				for (var j=0; j<experimentRuleDefinition.testElements.testElement.length; j++) {
					if (experimentRuleDefinition.testElements.testElement[j].testElementType == "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT %>" && emsResult[i].emsId == experimentRuleDefinition.testElements.testElement[j].testElementObject[0].testElementObjectId) {
						isDuplicateFound = true;
						break;
					}
				}
				if (!isDuplicateFound) {
					var currentIndex = experimentRuleDefinition.testElements.testElement.length;
					experimentRuleDefinition.testElements.testElement[currentIndex] = new Object();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementId = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementRatio = "";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementType = "<%= ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT %>";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject = new Array();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0] = new Object();
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>";
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementObjectId = emsResult[i].emsId;
					experimentRuleDefinition.testElements.testElement[currentIndex].testElementObject[0].testElementName = emsResult[i].emsName;
				}
			}
			top.saveData(null, "emsResult");
		}
	}
	top.saveData(null, "pageActionType");
}

function init () {
	with (document.experimentDefinitionForm) {
		// populate attributes of store and control elements in the form
		storeElementObjectId.value = experimentRuleDefinition.storeElementObjectId;
		storeElementName.value = experimentRuleDefinition.storeElementName;
		controlElementObjectId.value = experimentRuleDefinition.controlElementObjectId;
		controlElementName.value = experimentRuleDefinition.controlElementName;
		controlElementRatio.value = experimentRuleDefinition.controlElementRatio;
		loadSelectValue(experimentType, experimentRuleDefinition.testElements.type);

		// initialize state of buttons
		if (storeElementName.value == "") {
			summaryStoreElementButton.disabled = true;
			summaryStoreElementButton.className = "disabled";
			summaryStoreElementButton.id = "disabled";
		}
		if (controlElementName.value == "") {
			changeControlElementButton.disabled = true;
			changeControlElementButton.className = "disabled";
			changeControlElementButton.id = "disabled";
			summaryControlElementButton.disabled = true;
			summaryControlElementButton.className = "disabled";
			summaryControlElementButton.id = "disabled";
		}

		// display message for error found during validation on panel data
		if (parent.get("experimentStoreElementRequired", false)) {
			parent.remove("experimentStoreElementRequired");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStoreElementRequired")) %>");
			return;
		}
		if (parent.get("experimentControlElementRequired", false)) {
			parent.remove("experimentControlElementRequired");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentControlElementRequired")) %>");
			return;
		}
		if (parent.get("experimentControlRatioInvalid", false)) {
			parent.remove("experimentControlRatioInvalid");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentControlRatioInvalid")) %>");
			controlElementRatio.select();
			controlElementRatio.focus();
			return;
		}
		if (parent.get("experimentTestRatioInvalid", false)) {
			parent.remove("experimentTestRatioInvalid");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentTestRatioInvalid")) %>");
			return;
		}
		if (parent.get("experimentRatioOutOfRange", false)) {
			parent.remove("experimentRatioOutOfRange");
			alertDialog(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentRatioOutOfRange")) %>", "?", parent.get("displayFrequencyTotalSize", "100")));
			return;
		}

		controlElementRatio.focus();
	}
}

function persistPanelData () {
	savePanelData();
	top.setReturningPanel("experimentNotebookDefinitionPanel");
	top.saveModel(parent.model);
}

function addStoreElement () {
	persistPanelData();
	top.saveData("storeElementSelection", "pageActionType");
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.EmsSelectionDialog&resultLimit=single";
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("emsSelection")) %>", url, true);
}

function summaryStoreElement () {
	if (document.experimentDefinitionForm.storeElementObjectId.value != "") {
		persistPanelData();
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.EmsSummaryDialog&emsId=" + document.experimentDefinitionForm.storeElementObjectId.value;
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryEms")) %>", url, true);
	}
}

function newControlElement () {
	persistPanelData();
	top.saveData("controlElementSelection", "pageActionType");
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createInitiative")) %>", url, true);
}

function changeControlElement () {
	if (document.experimentDefinitionForm.controlElementObjectId.value != "") {
		if (experimentRuleDefinition.controlElementStoreId == "<%= experimentCommandContext.getStoreId() %>") {
			persistPanelData();
			var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + document.experimentDefinitionForm.controlElementObjectId.value;
			top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("updateInitiative")) %>", url, true);
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentControlElementCannotBeModified")) %>");
		}
	}
}

function addControlElement () {
	persistPanelData();
	top.saveData("controlElementSelection", "pageActionType");
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSelectionDialog&resultLimit=single";
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("initiativeSelection")) %>", url, true);
}

function summaryControlElement () {
	if (document.experimentDefinitionForm.controlElementObjectId.value != "") {
		persistPanelData();
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSummaryDialog&initiativeId=" + document.experimentDefinitionForm.controlElementObjectId.value;
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryInitiative")) %>", url, true);
	}
}

function updateExperimentType () {
	experimentRuleDefinition.testElements.type = getSelectValue(document.experimentDefinitionForm.experimentType);
	if (document.all.experimentalElementList.contentWindow.basefrm.updateExperimentType != undefined) {
		document.all.experimentalElementList.contentWindow.basefrm.selectedExperimentType = getSelectValue(document.experimentDefinitionForm.experimentType);
		document.all.experimentalElementList.contentWindow.basefrm.updateExperimentType();
	}
}

function savePanelData () {
	with (document.experimentDefinitionForm) {
		experimentRuleDefinition.controlElementRatio = controlElementRatio.value;
		experimentRuleDefinition.testElements.type = getSelectValue(experimentType);
		for (var i=0; i<experimentRuleDefinition.testElements.testElement.length; i++) {
			if (document.all.experimentalElementList.contentWindow.basefrm.document.all("testElementRatio_" + i) != undefined) {
				experimentRuleDefinition.testElements.testElement[i].testElementRatio = document.all.experimentalElementList.contentWindow.basefrm.document.all("testElementRatio_" + i).value;
			}
		}
		top.saveData(experimentRuleDefinition, "experimentRuleDefinition");
		if (parent.get) {
			var experimentDataBean = parent.get("experiment", null);
			experimentDataBean.experimentRuleDefinition = experimentRuleDefinition;
		}
	}
}
//-->
</script>
