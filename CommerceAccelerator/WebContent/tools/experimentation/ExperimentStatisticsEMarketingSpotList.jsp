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
	import="com.ibm.commerce.experimentation.dependency.*,
	com.ibm.commerce.experimentation.util.ExperimentUtil,
	com.ibm.commerce.marketingcenter.events.databeans.ExperimentResultDataBean,
	com.ibm.commerce.marketingcenter.events.databeans.ExperimentResultsListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.tools.experimentation.ExperimentConstants,
	com.ibm.commerce.tools.experimentation.ExperimentRuleConstants" %>

<%@ include file="common.jsp" %>

<jsp:useBean id="experimentDataBean" scope="request" class="com.ibm.commerce.tools.experimentation.beans.ExperimentDataBean">
<%	com.ibm.commerce.beans.DataBeanManager.activate(experimentDataBean, request); %>
</jsp:useBean>

<%
	// if this experiment has been completed, hide all the checkboxes in the list
	boolean showListCheckBox = true;
	if (experimentDataBean.getStatus().equals(ExperimentConstants.EXPERIMENT_STATUS_COMPLETED)) {
		showListCheckBox = false;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<style type="text/css">
TH.list_header {
	font-family: Verdana,Arial,Helvetica; font-size: 8pt; color: Black; font-weight: normal; border-top: 1px solid #E8E9E9; border-bottom: 1px solid #DADBE3; border-left: 1px solid #6D6D7C; background-image: url("/wcs/images/tools/list/table_header.gif"); padding-left: 7px; padding-right: 7px; padding-top: 2px; padding-bottom: 2px; vertical-align: middle; text-align: center;
}
TD.list_info_with_left_border {
	font-family: Verdana,Arial,Helvetica; font-size: 8pt; color: #373741; word-wrap: break-word; border-left: 1px solid #6D6D7C; padding-left: 8px; padding-right: 8px; padding-top: 5px; padding-bottom: 5px;
}
TD.list_info_with_bottom_border {
	font-family: Verdana,Arial,Helvetica; font-size: 8pt; color: #373741; word-wrap: break-word; border-bottom: 1px solid #6D6D7C; padding-left: 8px; padding-right: 8px; padding-top: 5px; padding-bottom: 5px;
}
TD.list_info_with_bottom_left_border {
	font-family: Verdana,Arial,Helvetica; font-size: 8pt; color: #373741; word-wrap: break-word; border-bottom: 1px solid #6D6D7C; border-left: 1px solid #6D6D7C; padding-left: 8px; padding-right: 8px; padding-top: 5px; padding-bottom: 5px;
}
</style>
<title><%= experimentRB.get("experimentStatisticsListTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/experimentation/Experiment.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
<%
	// if the control activity belongs to another store, then hide the 'update control activity' button
	if (showListCheckBox && experimentDataBean.getRuleDefinition() != null) {
		InitiativeKey controlElementKey = (InitiativeKey) experimentDataBean.getRuleDefinition().getControlElementKey();
		Integer controlElementStoreId = ExperimentUtil.getStoreIdByIdentifier(controlElementKey.getStoreIdentifier(), controlElementKey.getStoreMemberDN());
		if (controlElementStoreId != null && controlElementStoreId.compareTo(experimentCommandContext.getStoreId()) != 0) {
%>
parent.Buttons["updateActivityButton"].display = false;
<%
		}
	}
%>

var elementContainer = new Array();
var currentIndex = 0;

// if the selected element object already exists in the top model, remove it
if (top.getData("experimentSelectedElement", null) != null) {
	top.saveData(null, "experimentSelectedElement");
}

// build the object which contains all experimental elements
<%
	if (experimentDataBean.getRuleDefinition() != null) {
		String experimentType = experimentDataBean.getRuleDefinition().getExperimentType();
		EMarketingSpotKey storeElementKey = (EMarketingSpotKey) experimentDataBean.getRuleDefinition().getStoreElementKey();
		Integer storeElementStoreId = ExperimentUtil.getStoreIdByIdentifier(storeElementKey.getStoreIdentifier(), storeElementKey.getStoreMemberDN());
%>
elementContainer[currentIndex] = new Object();
elementContainer[currentIndex].id = "<%= experimentDataBean.getRuleDefinition().getControlElementId() %>";
elementContainer[currentIndex].initiativeId = "<%= experimentDataBean.getRuleDefinition().getControlElementKey().getObjectId() %>";
elementContainer[currentIndex].elements = new Array();
elementContainer[currentIndex].elements[0] = new Object();
elementContainer[currentIndex].elements[0].objectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>";
elementContainer[currentIndex].elements[0].objectId = "<%= storeElementKey.getObjectId() %>";
elementContainer[currentIndex].elements[0].objectName = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getStoreElementName()) %>";
elementContainer[currentIndex].elements[0].objectStoreId = "<%= storeElementStoreId %>";
currentIndex++;
<%
		if (experimentType.equals(ExperimentRuleConstants.XML_CONSTANT_TYPE_ACTIVITY)) {
			for (int i=0; i<experimentDataBean.getRuleDefinition().getTestElementId().size(); i++) {
%>
elementContainer[currentIndex] = new Object();
elementContainer[currentIndex].id = "<%= experimentDataBean.getRuleDefinition().getTestElementId().elementAt(i) %>";
elementContainer[currentIndex].initiativeId = "<%= ((DynamicKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i)).getObjectId() %>";
elementContainer[currentIndex].elements = new Array();
elementContainer[currentIndex].elements[0] = new Object();
elementContainer[currentIndex].elements[0].objectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>";
elementContainer[currentIndex].elements[0].objectId = "<%= storeElementKey.getObjectId() %>";
elementContainer[currentIndex].elements[0].objectName = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getStoreElementName()) %>";
elementContainer[currentIndex].elements[0].objectStoreId = "<%= storeElementStoreId %>";
currentIndex++;
<%
			}
		}
		else if (experimentType.equals(ExperimentRuleConstants.XML_CONSTANT_TYPE_CONTENT)) {
			for (int i=0; i<experimentDataBean.getRuleDefinition().getTestElementId().size(); i++) {
%>
elementContainer[currentIndex] = new Object();
elementContainer[currentIndex].id = "<%= experimentDataBean.getRuleDefinition().getTestElementId().elementAt(i) %>";
elementContainer[currentIndex].initiativeId = "<%= experimentDataBean.getRuleDefinition().getControlElementKey().getObjectId() %>";
elementContainer[currentIndex].elements = new Array();
elementContainer[currentIndex].elements[0] = new Object();
elementContainer[currentIndex].elements[0].objectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>";
elementContainer[currentIndex].elements[0].objectId = "<%= storeElementKey.getObjectId() %>";
elementContainer[currentIndex].elements[0].objectName = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getStoreElementName()) %>";
elementContainer[currentIndex].elements[0].objectStoreId = "<%= storeElementStoreId %>";
<%
				String thisTestElementType = experimentDataBean.getRuleDefinition().getTestElementType().elementAt(i).toString();
				Vector thisTestElementObjectType = new Vector();
				Vector thisTestElementObjectId = new Vector();
				Vector thisTestElementObjectIdentifier = new Vector();
				Vector thisTestElementObjectName = new Vector();
				Vector thisTestElementObjectStoreId = new Vector();
				if (thisTestElementType.equals(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION)) {
					PromotionKey thisKey = (PromotionKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i);
					thisTestElementObjectType.addElement(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION);
					thisTestElementObjectId.addElement(thisKey.getCalcodeId());
					thisTestElementObjectIdentifier.addElement(thisKey.getCalcodeUsage());
					thisTestElementObjectName.addElement(thisKey.getCalcodeCode());
					thisTestElementObjectStoreId.addElement(ExperimentUtil.getStoreIdByIdentifier(thisKey.getStoreIdentifier(), thisKey.getStoreMemberDN()));
					for (int j=0; j<thisKey.getCollateralKey().length; j++) {
						thisTestElementObjectType.addElement(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PROMOTION_COLLATERAL);
						thisTestElementObjectId.addElement(thisKey.getCollateralKey()[j].getCollateralId());
						thisTestElementObjectIdentifier.addElement("");
						thisTestElementObjectName.addElement(thisKey.getCollateralKey()[j].getCollateralName());
						thisTestElementObjectStoreId.addElement(ExperimentUtil.getStoreIdByIdentifier(thisKey.getCollateralKey()[j].getStoreIdentifier(), thisKey.getCollateralKey()[j].getStoreMemberDN()));
					}
				}
				else if (thisTestElementType.equals(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION)) {
					CatalogEntryKey thisKey = (CatalogEntryKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i);
					thisTestElementObjectType.addElement(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_PRODUCT_RECOMMENDATION);
					thisTestElementObjectId.addElement(thisKey.getCatalogEntryId());
					thisTestElementObjectIdentifier.addElement(thisKey.getCatalogEntryIdentifier());
					thisTestElementObjectName.addElement(experimentDataBean.getRuleDefinition().getTestElementName().elementAt(i).toString());
					thisTestElementObjectStoreId.addElement("");
				}
				else if (thisTestElementType.equals(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION)) {
					CatalogGroupKey thisKey = (CatalogGroupKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i);
					thisTestElementObjectType.addElement(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_CATEGORY_RECOMMENDATION);
					thisTestElementObjectId.addElement(thisKey.getCatalogGroupId());
					thisTestElementObjectIdentifier.addElement(thisKey.getCatalogGroupIdentifier());
					thisTestElementObjectName.addElement(experimentDataBean.getRuleDefinition().getTestElementName().elementAt(i).toString());
					thisTestElementObjectStoreId.addElement("");
				}
				else if (thisTestElementType.equals(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL)) {
					CollateralKey thisKey = (CollateralKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i);
					thisTestElementObjectType.addElement(ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_COLLATERAL);
					thisTestElementObjectId.addElement(thisKey.getCollateralId());
					thisTestElementObjectIdentifier.addElement("");
					thisTestElementObjectName.addElement(thisKey.getCollateralName());
					thisTestElementObjectStoreId.addElement(ExperimentUtil.getStoreIdByIdentifier(thisKey.getStoreIdentifier(), thisKey.getStoreMemberDN()));
				}
				else {
					thisTestElementObjectType.addElement(thisTestElementType);
					thisTestElementObjectId.addElement(((DynamicKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i)).getObjectId());
					thisTestElementObjectIdentifier.addElement("");
					thisTestElementObjectName.addElement(experimentDataBean.getRuleDefinition().getTestElementName().elementAt(i).toString());
					thisTestElementObjectStoreId.addElement("");
				}
				for (int j=0; j<thisTestElementObjectType.size(); j++) {
%>
elementContainer[currentIndex].elements[<%= j+1 %>] = new Object();
elementContainer[currentIndex].elements[<%= j+1 %>].objectType = "<%= thisTestElementObjectType.elementAt(j).toString() %>";
elementContainer[currentIndex].elements[<%= j+1 %>].objectId = "<%= thisTestElementObjectId.elementAt(j).toString() %>";
elementContainer[currentIndex].elements[<%= j+1 %>].objectIdentifier = "<%= thisTestElementObjectIdentifier.elementAt(j).toString() %>";
elementContainer[currentIndex].elements[<%= j+1 %>].objectName = "<%= UIUtil.toJavaScript(thisTestElementObjectName.elementAt(j).toString()) %>";
elementContainer[currentIndex].elements[<%= j+1 %>].objectStoreId = "<%= UIUtil.toJavaScript(thisTestElementObjectStoreId.elementAt(j).toString()) %>";
<%				} %>
currentIndex++;
<%
			}
		}
		else if (experimentType.equals(ExperimentRuleConstants.XML_CONSTANT_TYPE_SEGMENT)) {
			for (int i=0; i<experimentDataBean.getRuleDefinition().getTestElementId().size(); i++) {
%>
elementContainer[currentIndex] = new Object();
elementContainer[currentIndex].id = "<%= experimentDataBean.getRuleDefinition().getTestElementId().elementAt(i) %>";
elementContainer[currentIndex].initiativeId = "<%= experimentDataBean.getRuleDefinition().getControlElementKey().getObjectId() %>";
elementContainer[currentIndex].elements = new Array();
elementContainer[currentIndex].elements[0] = new Object();
elementContainer[currentIndex].elements[0].objectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>";
elementContainer[currentIndex].elements[0].objectId = "<%= storeElementKey.getObjectId() %>";
elementContainer[currentIndex].elements[0].objectName = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getStoreElementName()) %>";
elementContainer[currentIndex].elements[0].objectStoreId = "<%= storeElementStoreId %>";
elementContainer[currentIndex].elements[1] = new Object();
elementContainer[currentIndex].elements[1].objectType = "<%= experimentDataBean.getRuleDefinition().getTestElementType().elementAt(i) %>";
elementContainer[currentIndex].elements[1].objectId = "<%= ((DynamicKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i)).getObjectId() %>";
elementContainer[currentIndex].elements[1].objectName = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getTestElementName().elementAt(i).toString()) %>";
currentIndex++;
<%
			}
		}
		else if (experimentType.equals(ExperimentRuleConstants.XML_CONSTANT_TYPE_SPOT)) {
			for (int i=0; i<experimentDataBean.getRuleDefinition().getTestElementId().size(); i++) {
				EMarketingSpotKey thisTestKey = (EMarketingSpotKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i);
				Integer thisTestElementStoreId = ExperimentUtil.getStoreIdByIdentifier(thisTestKey.getStoreIdentifier(), thisTestKey.getStoreMemberDN());
%>
elementContainer[currentIndex] = new Object();
elementContainer[currentIndex].id = "<%= experimentDataBean.getRuleDefinition().getTestElementId().elementAt(i) %>";
elementContainer[currentIndex].initiativeId = "<%= experimentDataBean.getRuleDefinition().getControlElementKey().getObjectId() %>";
elementContainer[currentIndex].elements = new Array();
elementContainer[currentIndex].elements[0] = new Object();
elementContainer[currentIndex].elements[0].objectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>";
elementContainer[currentIndex].elements[0].objectId = "<%= ((DynamicKey) experimentDataBean.getRuleDefinition().getTestElementKey().elementAt(i)).getObjectId() %>";
elementContainer[currentIndex].elements[0].objectName = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getTestElementName().elementAt(i).toString()) %>";
elementContainer[currentIndex].elements[0].objectStoreId = "<%= thisTestElementStoreId %>";
elementContainer[currentIndex].elements[1] = new Object();
elementContainer[currentIndex].elements[1].objectType = "<%= ExperimentRuleConstants.XML_CONSTANT_CONTENT_TYPE_SPOT %>";
elementContainer[currentIndex].elements[1].objectId = "<%= storeElementKey.getObjectId() %>";
elementContainer[currentIndex].elements[1].objectName = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getStoreElementName()) %>";
elementContainer[currentIndex].elements[1].objectStoreId = "<%= storeElementStoreId %>";
elementContainer[currentIndex].elements[1].objectActionType = "remove";
currentIndex++;
<%
			}
		}
	}
%>

function getSelectedElementIndex () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		for (var i=0; i<elementContainer.length; i++) {
			if (checked[0] == elementContainer[i].id) {
				return i;
			}
		}
	}
	return -1;
}

function updateActivity () {
	var currentSelectedElementIndex = getSelectedElementIndex();
	if (currentSelectedElementIndex > -1) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + elementContainer[currentSelectedElementIndex].initiativeId;
		top.saveData(elementContainer[currentSelectedElementIndex].id, "preferredElementId");
		top.saveData(elementContainer[currentSelectedElementIndex].elements, "experimentSelectedElement");
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("updateInitiative")) %>", url, true);
	}
}

function duplicateActivity () {
	var currentSelectedElementIndex = getSelectedElementIndex();
	if (currentSelectedElementIndex > -1) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + elementContainer[currentSelectedElementIndex].initiativeId + "&newInitiative=true";
		top.saveData(elementContainer[currentSelectedElementIndex].id, "preferredElementId");
		top.saveData(elementContainer[currentSelectedElementIndex].elements, "experimentSelectedElement");
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createInitiative")) %>", url, true);
	}
}

function onLoad () {
	// initialization routine for dynamic list
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad()" class="content_list" style="margin-left: 0px; margin-top: 0px;">

<form id="experimentStatisticsForm" name="experimentStatisticsForm">

<%
	// instantiate the statistics beans
	ExperimentResultsListDataBean resultListDataBean = new ExperimentResultsListDataBean(experimentDataBean.getId(), experimentDataBean.getStoreId());
	resultListDataBean.populate();
	ExperimentResultDataBean controlElementResult = resultListDataBean.getControlElementResult();
	ExperimentResultDataBean[] testElementResults = resultListDataBean.getTestElementResults();
	String resultCurrency = controlElementResult.getCurrency();
	if (resultCurrency == null || resultCurrency.equals("")) {
		resultCurrency = experimentCommandContext.getCurrency();
	}
	Integer languageId = experimentCommandContext.getLanguageId();
%>

<p/>
<script language="JavaScript">
<!-- hide script from old browsers
startDlistTable("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentElementListSummary")) %>");
document.writeln('<tr>');
<%	if (showListCheckBox) { %>
document.writeln('<th id="th00" class="list_header" rowspan="2"><div style="display:none;"><input name="select_deselect" type="checkbox" value="Select Deselect All"></div></th>');
<%	} %>
document.writeln('<th id="th01" class="list_header" rowspan="2"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentElementListRatioColumn")) %></th>');
document.writeln('<th id="th02" class="list_header" rowspan="2"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListViewsColumn")) %></th>');
document.writeln('<th id="th03" class="list_header" rowspan="2"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListClickColumn")) %></th>');
document.writeln('<th id="th04" class="list_header" rowspan="2"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListClickRatioColumn")) %></th>');
document.writeln('<th id="th05" class="list_header" nowrap="nowrap" colspan="4" align="center"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListFromViews")) %></th>');
document.writeln('<th id="th06" class="list_header" nowrap="nowrap" colspan="4" align="center"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListFromClick")) %></th>');
document.writeln('</tr>');
document.writeln('<tr>');
document.writeln('<th id="th07" class="list_header"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListOrdersColumn")) %></th>');
document.writeln('<th id="th08" class="list_header"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListConversionRateColumn")) %></th>');
document.writeln('<th id="th09" class="list_header">' + replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListTotalRevenueColumn")) %>", "?", "<%= resultCurrency %>") + '</th>');
document.writeln('<th id="th10" class="list_header">' + replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListAverageRevenueColumn")) %>", "?", "<%= resultCurrency %>") + '</th>');
document.writeln('<th id="th11" class="list_header"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListOrdersColumn")) %></th>');
document.writeln('<th id="th12" class="list_header"><%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListConversionRateColumn")) %></th>');
document.writeln('<th id="th13" class="list_header">' + replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListTotalRevenueColumn")) %>", "?", "<%= resultCurrency %>") + '</th>');
document.writeln('<th id="th14" class="list_header">' + replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListAverageRevenueColumn")) %>", "?", "<%= resultCurrency %>") + '</th>');
document.writeln('</tr>');
//-->
</script>

<tr class="list_row1">
<%	if (showListCheckBox) { %>
	<td class="list_check">&nbsp;</td>
<%	} %>
	<td class="section_title" colspan="12" height="30"><%= experimentRB.get("experimentDefinitionControlElementSectionHeader") %></td>
</tr>

<%
	// get control element data from rule definition and statistics bean
	int rowselect = 2;
	if (experimentDataBean.getRuleDefinition() != null) {
		if (controlElementResult == null) {
			controlElementResult = new ExperimentResultDataBean();
		}
		Integer controlElementId = experimentDataBean.getRuleDefinition().getControlElementId();

		// highlight this row if it is already selected as the preferred element
		String rowStyle = "list_info1";
		if (experimentDataBean.getPreferredElement() != null && experimentDataBean.getPreferredElement().toString().equals(controlElementId.toString())) {
			rowStyle = "section_title";
		}
%>
<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<tr id="controlRowName_<%= controlElementId %>" class="list_row<%= rowselect %>" onmouseover="parent.tempClass=this.className;this.className=\'list_row3\';controlRowResult_<%= controlElementId %>.className=\'list_row3\';" onmouseout="this.className=parent.tempClass;controlRowResult_<%= controlElementId %>.className=parent.tempClass;">');
<%	if (showListCheckBox) { %>
addDlistCheck("<%= controlElementId %>", null, null);
<%	} %>
document.writeln('<td class="<%= rowStyle %>" colspan="12">' + replaceField(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListNameAndType")) %>", "?", "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getControlElementName()) %>"), "?", "<%= UIUtil.toJavaScript((String)experimentRB.get(experimentDataBean.getRuleDefinition().getControlElementType() + "ContentType")) %>") + '</td>');
document.writeln('</tr>');

document.writeln('<tr id="controlRowResult_<%= controlElementId %>" class="list_row<%= rowselect %>" onmouseover="parent.tempClass=this.className;this.className=\'list_row3\';controlRowName_<%= controlElementId %>.className=\'list_row3\';" onmouseout="this.className=parent.tempClass;controlRowName_<%= controlElementId %>.className=parent.tempClass;">');
<%	if (showListCheckBox) { %>
document.writeln('<td class="list_check">&nbsp;</td>');
<%	} %>
document.writeln('<td id="controlColumnRatio_<%= controlElementId %>" class="list_info1" align="right">' + top.formatInteger("<%= experimentDataBean.getRuleDefinition().getControlElementRatio() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnDisplays_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.formatInteger("<%= controlElementResult.getDisplays() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnClicks_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.formatInteger("<%= controlElementResult.getClicks() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnClickRatio_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.formatInteger("<%= controlElementResult.getClickRatio() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnDisplayOrders_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.formatInteger("<%= controlElementResult.getDisplayOrders() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnDisplayConversionRate_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.formatInteger("<%= controlElementResult.getDisplayConversionRate() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnDisplayTotalOrderAmount_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.numberToCurrency("<%= controlElementResult.getDisplayTotalOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnDisplayAverageOrderAmount_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.numberToCurrency("<%= controlElementResult.getDisplayAverageOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnClickOrders_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.formatInteger("<%= controlElementResult.getClickOrders() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnClickedConversionRate_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.formatInteger("<%= controlElementResult.getClickedConversionRate() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnClickedTotalOrderAmount_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.numberToCurrency("<%= controlElementResult.getClickedTotalOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('<td id="controlColumnClickedAverageOrderAmount_<%= controlElementId %>" class="list_info_with_left_border" align="right">' + top.numberToCurrency("<%= controlElementResult.getClickedAverageOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('</tr>');
//-->
</script>
<%	} %>

<tr class="list_row1">
<%	if (showListCheckBox) { %>
	<td class="list_check">&nbsp;</td>
<%	} %>
	<td class="section_title_with_top_dash" colspan="12" height="30"><%= experimentRB.get("experimentDefinitionTestElementSectionHeader") %></td>
</tr>

<%
	// get test element data from rule definition and statistics beans
	int resultSize = 0;
	if (experimentDataBean.getRuleDefinition() != null) {
		for (int i=0; i<experimentDataBean.getRuleDefinition().getTestElementId().size(); i++) {
			ExperimentResultDataBean thisResultDataBean = null;
			for (int j=0; j<testElementResults.length; j++) {
				if (experimentDataBean.getRuleDefinition().getTestElementId().elementAt(i).toString().equals(testElementResults[j].getTestElementId())) {
					thisResultDataBean = testElementResults[j];
					break;
				}
			}
			if (thisResultDataBean == null) {
				thisResultDataBean = new ExperimentResultDataBean();
			}
			String thisTestElementId = experimentDataBean.getRuleDefinition().getTestElementId().elementAt(i).toString();

			// highlight this row if it is already selected as the preferred element
			String rowStyle = "list_info1";
			if (experimentDataBean.getPreferredElement() != null && experimentDataBean.getPreferredElement().toString().equals(thisTestElementId)) {
				rowStyle = "section_title";
			}

			// define cell styles
			String ratioStyle = "list_info_with_bottom_border";
			String cellStyle = "list_info_with_bottom_left_border";
			if (i == experimentDataBean.getRuleDefinition().getTestElementId().size() - 1) {
				ratioStyle = "list_info1";
				cellStyle = "list_info_with_left_border";
			}
%>
<script language="JavaScript">
<!-- hide script from old browsers
document.writeln('<tr id="testRowName_<%= thisTestElementId %>" class="list_row<%= rowselect %>" onmouseover="parent.tempClass=this.className;this.className=\'list_row3\';testRowResult_<%= thisTestElementId %>.className=\'list_row3\';" onmouseout="this.className=parent.tempClass;testRowResult_<%= thisTestElementId %>.className=parent.tempClass;">');
<%	if (showListCheckBox) { %>
addDlistCheck("<%= thisTestElementId %>", null, null);
<%	} %>
document.writeln('<td class="<%= rowStyle %>" colspan="12">' + replaceField(replaceField("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentStatisticsListNameAndType")) %>", "?", "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getTestElementName().elementAt(i).toString()) %>"), "?", "<%= UIUtil.toJavaScript((String)experimentRB.get(experimentDataBean.getRuleDefinition().getTestElementType().elementAt(i).toString() + "ContentType")) %>") + '</td>');
document.writeln('</tr>');

document.writeln('<tr id="testRowResult_<%= thisTestElementId %>" class="list_row<%= rowselect %>" onmouseover="parent.tempClass=this.className;this.className=\'list_row3\';testRowName_<%= thisTestElementId %>.className=\'list_row3\';" onmouseout="this.className=parent.tempClass;testRowName_<%= thisTestElementId %>.className=parent.tempClass;">');
<%	if (showListCheckBox) { %>
document.writeln('<td class="list_check">&nbsp;</td>');
<%	} %>
document.writeln('<td id="testColumnRatio_<%= thisTestElementId %>" class="<%= ratioStyle %>" align="right">' + top.formatInteger("<%= experimentDataBean.getRuleDefinition().getTestElementRatio().elementAt(i) %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnDisplays_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.formatInteger("<%= thisResultDataBean.getDisplays() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnClicks_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.formatInteger("<%= thisResultDataBean.getClicks() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnClickRatio_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.formatInteger("<%= thisResultDataBean.getClickRatio() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnDisplayOrders_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.formatInteger("<%= thisResultDataBean.getDisplayOrders() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnDisplayConversionRate_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.formatInteger("<%= thisResultDataBean.getDisplayConversionRate() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnDisplayTotalOrderAmount_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.numberToCurrency("<%= thisResultDataBean.getDisplayTotalOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnDisplayAverageOrderAmount_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.numberToCurrency("<%= thisResultDataBean.getDisplayAverageOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnClickOrders_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.formatInteger("<%= thisResultDataBean.getClickOrders() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnClickedConversionRate_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.formatInteger("<%= thisResultDataBean.getClickedConversionRate() %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnClickedTotalOrderAmount_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.numberToCurrency("<%= thisResultDataBean.getClickedTotalOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('<td id="testColumnClickedAverageOrderAmount_<%= thisTestElementId %>" class="<%= cellStyle %>" align="right">' + top.numberToCurrency("<%= thisResultDataBean.getClickedAverageOrderAmount() %>", "<%= resultCurrency %>", <%= languageId %>) + '</td>');
document.writeln('</tr>');
//-->
</script>
<%
			if (rowselect == 1) {
				rowselect = 2;
			}
			else {
				rowselect = 1;
			}
			resultSize++;
		}
	}
	if (resultSize == 0) {
%>
<tr class="list_row2">
<%	if (showListCheckBox) { %>
	<td class="list_check">&nbsp;</td>
<%	} %>
	<td class="list_info1" colspan="12" height="20"><%= experimentRB.get("experimentSummaryExperimentResultsListEmpty") %></td>
</tr>
<%	} %>

<%= comm.endDlistTable() %>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(<%= resultSize %>);
<%	if (showListCheckBox) { %>
parent.setButtonPos("0px", "-10px");
<%	} %>
//-->
</script>

</form>

</body>

</html>