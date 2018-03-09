<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2004
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
=========================================================================== -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.emarketing.beans.EmailActivityListDataBean,
	com.ibm.commerce.emarketing.beans.EmailActivityListEntry,
	com.ibm.commerce.emarketing.commands.EmailActivityConstants,
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");
	Hashtable emailActivityRB = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("emailactivity.EmailActivityNLS", campaignCommandContext.getLocale());

	EmailActivityListDataBean emailActivityList = new EmailActivityListDataBean();
	DataBeanManager.activate(emailActivityList, request);
	EmailActivityListEntry emailActivities[] = emailActivityList.getEmailActivityList();
	int numberOfEmailActivities = 0;
	if (emailActivities != null) {
		numberOfEmailActivities = emailActivities.length;
	}

	String[] availableActivityView = CampaignUtil.getActivityViewByStoreType(campaignCommandContext.getStore().getStoreType());
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_GENERAL_PANEL_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/campaigns/Campaign.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
//
// Retrieve the initiative list data from the model, and initialize critical variables in this page.
//
var campaignDataBean = parent.parent.parent.get("<%= CampaignConstants.ELEMENT_CAMPAIGN %>", null);
var initiativeListData = campaignDataBean.<%= CampaignConstants.ELEMENT_CAMPAIGN_INITIATIVE %>;
var emailActivityListData = campaignDataBean.<%= CampaignConstants.ELEMENT_EMAIL_ACTIVITY %>;
var numberOfInitiatives = initiativeListData.length;
var numberOfEmailActivities = emailActivityListData.length;

//
// After action is completed, initiativeResult object is expected to be returned from the previous panel.
// Go through each entry in the object to determine which initiatives should be added to the initiative
// list.
//
var initiativeResult = top.getData("initiativeResult", null);
var isAdd = true;
if (initiativeResult != null) {
	// go through each entry in the result array
	for (var i=0; i<initiativeResult.length; i++) {
		var thisResult = initiativeResult[i];
		// go through each entry in the initiative list
		for (var j=0; j<numberOfInitiatives; j++) {
			var thisInitiative = initiativeListData[j];
			// check if there is any duplicate entry ... there are 4 cases:
			// 1. no duplicate, then add it to the initiative list with action flag sets to createAction
			// 2. duplicate found and action flag is not deleteAction, then ignore it and skip the rest
			// 3. duplicate found and action flag is deleteAction, then set flag to updateAction and reset all attributes
			// 4. duplicate found and action flag is destroyAction, then set flag to createAction and reset all attributes
			if (thisInitiative.id == thisResult.initiativeId) {
				if (thisInitiative.actionFlag == "<%= CampaignConstants.ACTION_FLAG_DELETE %>") {
					thisInitiative.actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
					thisInitiative.id = thisResult.initiativeId;
					thisInitiative.name = thisResult.initiativeName;
					thisInitiative.description = thisResult.initiativeDesc;
					thisInitiative.contentType = thisResult.initiativeContentType;
					thisInitiative.storeId = thisResult.initiativeStoreId;
					thisInitiative.status = thisResult.initiativeStatus;
				}
				else if (thisInitiative.actionFlag == "<%= CampaignConstants.ACTION_FLAG_DESTROY %>") {
					thisInitiative.actionFlag = "<%= CampaignConstants.ACTION_FLAG_CREATE %>";
					thisInitiative.id = thisResult.initiativeId;
					thisInitiative.name = thisResult.initiativeName;
					thisInitiative.description = thisResult.initiativeDesc;
					thisInitiative.contentType = thisResult.initiativeContentType;
					thisInitiative.storeId = thisResult.initiativeStoreId;
					thisInitiative.status = thisResult.initiativeStatus;
				}
				isAdd = false;
				break;
			}
		}

		// if no duplicate is found, create a new object to the initiative list
		// else action should have been taken, move on to the next entry in the result
		if (isAdd) {
			if (!initiativeListData) {
				initiativeListData = new Array();
			}
			initiativeListData[numberOfInitiatives] = new Object();
			initiativeListData[numberOfInitiatives].actionFlag = "<%= CampaignConstants.ACTION_FLAG_CREATE %>";
			initiativeListData[numberOfInitiatives].id = thisResult.initiativeId;
			initiativeListData[numberOfInitiatives].name = thisResult.initiativeName;
			initiativeListData[numberOfInitiatives].description = thisResult.initiativeDesc;
			initiativeListData[numberOfInitiatives].contentType = thisResult.initiativeContentType;
			initiativeListData[numberOfInitiatives].storeId = thisResult.initiativeStoreId;
			initiativeListData[numberOfInitiatives].status = thisResult.initiativeStatus;
			numberOfInitiatives++;
		}
		else {
			isAdd = true;
		}
	}
	top.saveData(null, "initiativeResult");
}

//
// After action is completed, emailActivityResult object is expected to be returned from the previous
// panel.  Go through each entry in the object to determine which e-mail activities should be added to
// the e-mail activity list.
//
var emailActivityResult = top.getData("emailActivityResult", null);
isAdd = true;
if (emailActivityResult != null) {
	// go through each entry in the result array
	for (var i=0; i<emailActivityResult.length; i++) {
		var thisResult = emailActivityResult[i];
		// go through each entry in the e-mail activity list
		for (var j=0; j<numberOfEmailActivities; j++) {
			var thisEmailActivity = emailActivityListData[j];
			// check if there is any duplicate entry ... there are 3 cases:
			// 1. no duplicate, then add it to the initiative list with action flag sets to createAction
			// 2. duplicate found and action flag is not deleteAction, then ignore it and skip the rest
			// 3. duplicate found and action flag is deleteAction, then set flag to updateAction
			// 4. duplicate found and action flag is destroyAction, then set flag to createAction
			if (thisEmailActivity.id == thisResult.emailActivityId) {
				if (thisEmailActivity.actionFlag == "<%= CampaignConstants.ACTION_FLAG_DELETE %>") {
					thisEmailActivity.actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
					thisEmailActivity.id = thisResult.emailActivityId;
					thisEmailActivity.storeId = thisResult.emailActivityStoreId;
				}
				else if (thisEmailActivity.actionFlag == "<%= CampaignConstants.ACTION_FLAG_DESTROY %>") {
					thisEmailActivity.actionFlag = "<%= CampaignConstants.ACTION_FLAG_CREATE %>";
					thisEmailActivity.id = thisResult.emailActivityId;
					thisEmailActivity.storeId = thisResult.emailActivityStoreId;
				}
				isAdd = false;
				break;
			}
		}

		// if no duplicate is found, create a new object to the e-mail activity list
		// else action should have been taken, move on to the next entry in the result
		if (isAdd) {
			if (!emailActivityListData) {
				emailActivityListData = new Array();
			}
			emailActivityListData[numberOfEmailActivities] = new Object();
			emailActivityListData[numberOfEmailActivities].actionFlag = "<%= CampaignConstants.ACTION_FLAG_CREATE %>";
			emailActivityListData[numberOfEmailActivities].id = thisResult.emailActivityId;
			emailActivityListData[numberOfEmailActivities].storeId = thisResult.emailActivityStoreId;
			numberOfEmailActivities++;
		}
		else {
			isAdd = true;
		}
	}
	top.saveData(null, "emailActivityResult");
}

//
// Persists initiative list data to the model.
//
campaignDataBean.<%= CampaignConstants.ELEMENT_CAMPAIGN_INITIATIVE %> = initiativeListData;
campaignDataBean.<%= CampaignConstants.ELEMENT_EMAIL_ACTIVITY %> = emailActivityListData;

function loadPanelData () {
	// load the button frame
	parent.loadFrames();

	// make sure the campaign name field gets the initial focus when the page loads
	if ((parent.parent.document.campaignForm != undefined) && (parent.parent.document.campaignForm.<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %> != null)) {
		parent.parent.document.campaignForm.<%= CampaignConstants.ELEMENT_CAMPAIGN_NAME %>.focus();
	}

	// loop through each entry to update fields
	for (var i=0; i<numberOfInitiatives; i++) {
		if ((initiativeListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (initiativeListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
			var thisInitiative = initiativeListData[i];

			// populate initiative status
			loadSelectValue(document.all("<%= CampaignConstants.ELEMENT_INITIATIVE_STATUS %>_" + i), thisInitiative.status);
		}
	}

	// get current view selection from top data object
	var currentViewSelection = top.getData("campaignInitiativeMappingListView", null);
	if (currentViewSelection == null) {
		currentViewSelection = "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>";
	}
	loadSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>, currentViewSelection);
	top.saveData(null, "campaignInitiativeMappingListView");

	// show divisions depending on the current view selection
	showViewDivisions();

	parent.parent.setReadyFlag("initiativeMappingPanel");
}

function savePanelData () {
	campaignDataBean.<%= CampaignConstants.ELEMENT_CAMPAIGN_INITIATIVE %> = initiativeListData;
	campaignDataBean.<%= CampaignConstants.ELEMENT_EMAIL_ACTIVITY %> = emailActivityListData;
}

function updateActionFlag (rowIndex) {
	if (initiativeListData[rowIndex].actionFlag == "<%= CampaignConstants.ACTION_FLAG_NO_ACTION %>") {
		initiativeListData[rowIndex].actionFlag = "<%= CampaignConstants.ACTION_FLAG_UPDATE %>";
	}
}

function updateStatus (rowIndex) {
	updateActionFlag(rowIndex);
	initiativeListData[rowIndex].status = getSelectValue(document.all("<%= CampaignConstants.ELEMENT_INITIATIVE_STATUS %>_" + rowIndex));
	savePanelData();
}

function newInitiative () {
	parent.parent.persistPanelData();
	saveCurrentListView();

	var selectedViewValue = getSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);
	if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&fromPanel=campaign&campaignName=" + escapeURLSpecialChar(campaignDataBean.campaignName);
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_INITIATIVE)) %>", url, true);
	}
	else if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailActivityDialogAdd&fromPanel=campaign&campaignName=" + escapeURLSpecialChar(campaignDataBean.campaignName);
		top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("createEmailActivity")) %>", url, true);
	}
}

function changeInitiative () {
	var rowIndex = "";
	var selectedViewValue = getSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);

	if (arguments.length > 0) {
		rowIndex = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			var thisStoreId;
			var thisStatus;
			if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
				thisStoreId = initiativeListData[getListInitiativeId(checked[0])].storeId;
				thisStatus = getListStatus(checked[0]);
			}
			else if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
				thisStoreId = emailActivityListData[getListInitiativeId(checked[0])].storeId;
				thisStatus = getListStatus(checked[0]);
			}
			if (thisStoreId != "<%= campaignCommandContext.getStoreId() %>") {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeModified")) %>");
			}
			else if (thisStatus == "1") {
				alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("emailActivityCannotBeModified")) %>");
			}
			else {
				rowIndex = checked[0];
			}
		}
	}

	if (rowIndex != "") {
		parent.parent.persistPanelData();
		saveCurrentListView();

		if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
			var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + initiativeListData[getListInitiativeId(rowIndex)].id + "&fromPanel=campaign&campaignName=" + escapeURLSpecialChar(campaignDataBean.campaignName);
			top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_UPDATE_INITIATIVE)) %>", url, true);
		}
		else if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
			var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailActivityDialogChange&emailActivityId=" + emailActivityListData[getListInitiativeId(rowIndex)].id + "&fromPanel=campaign&campaignName=" + escapeURLSpecialChar(campaignDataBean.campaignName);
			top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("changeEmailActivity")) %>", url, true);
		}
	}
}

function copyInitiative () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		parent.parent.persistPanelData();
		saveCurrentListView();

		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeDialog&initiativeId=" + initiativeListData[getListInitiativeId(checked[0])].id + "&newInitiative=true&fromPanel=campaign&campaignName=" + escapeURLSpecialChar(campaignDataBean.campaignName);
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CREATE_INITIATIVE)) %>", url, true);
	}
}

function addInitiative () {
	parent.parent.persistPanelData();
	saveCurrentListView();

	var selectedViewValue = getSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);
	if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSelectionDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("initiativeSelectionPanelTitle")) %>", url, true);
	}
	else if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.EmailActivitySelectionDialog";
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("emailActivitySelectionPanelTitle")) %>", url, true);
	}
}

function summaryInitiative () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		parent.parent.persistPanelData();
		saveCurrentListView();

		var selectedViewValue = getSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);
		if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
			var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.InitiativeSummaryDialog&initiativeId=" + initiativeListData[getListInitiativeId(checked[0])].id;
			top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SUMMARY_DIALOG_TITLE)) %>", url, true);
		}
		else if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
			var thisStoreId = emailActivityListData[getListInitiativeId(checked[0])].storeId;
			if (thisStoreId != "<%= campaignCommandContext.getStoreId() %>") {
				alertDialog("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivitySummaryNotAllowedStore")) %>");
			}
			else {
				var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=emailactivity.EmailActivitySummaryDialog&emailActivityId=" + emailActivityListData[getListInitiativeId(checked[0])].id;
				top.setContent("<%= UIUtil.toJavaScript((String)emailActivityRB.get("emailActivitySummary")) %>", url, true);
			}
		}
	}
}

function removeMapping () {
	var checkedInitiative = parent.getChecked();
	var selectedViewValue = getSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);
	if (checkedInitiative.length > 0) {
		if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_CAMPAIGN_INITIATIVE_MAPPING_DELETE_CONFIRMATION)) %>")) {
			for (i=0; i<checkedInitiative.length; i++) {
				var thisInitiative;

				// get the current initiative object
				if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
					thisInitiative = initiativeListData[getListInitiativeId(checkedInitiative[i])];
				}
				else if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
					thisInitiative = emailActivityListData[getListInitiativeId(checkedInitiative[i])];
				}

				// set the action flag appropriately
				if (thisInitiative.actionFlag == "<%= CampaignConstants.ACTION_FLAG_CREATE %>") {
					thisInitiative.actionFlag = "<%= CampaignConstants.ACTION_FLAG_DESTROY %>";
				}
				else {
					thisInitiative.actionFlag = "<%= CampaignConstants.ACTION_FLAG_DELETE %>";
				}

				// set the current initiative object
				if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
					initiativeListData[getListInitiativeId(checkedInitiative[i])] = thisInitiative;
				}
				else if (selectedViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
					emailActivityListData[getListInitiativeId(checkedInitiative[i])] = thisInitiative;
				}
			}

			saveCurrentListView();
			campaignDataBean.<%= CampaignConstants.ELEMENT_CAMPAIGN_INITIATIVE %> = initiativeListData;
			campaignDataBean.<%= CampaignConstants.ELEMENT_EMAIL_ACTIVITY %> = emailActivityListData;
			parent.location.reload();
		}
	}
}

function saveCurrentListView () {
	// save current view selection to top data object
	top.saveData(getSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>), "campaignInitiativeMappingListView");
}

function showViewDivisions () {
	var listViewValue = getSelectValue(document.campaignForm.<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>);

	// show division and button according to the list view value
	if (listViewValue == "<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>") {
		document.all.<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>Div.style.display = "none";
		document.all.<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>Div.style.display = "block";
		parent.displayButton("copy");
	}
	else if (listViewValue == "<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>") {
		document.all.<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>Div.style.display = "none";
		document.all.<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>Div.style.display = "block";
		parent.hideButton("copy");
	}
}

function selectDeselectAll (viewIndex, checkObject) {
	for (var i=0; i<document.campaignForm.elements.length; i++) {
		var e = document.campaignForm.elements[i];
		if (e.type == "checkbox") {
			if (e.name != "select_deselect") {
				if (getListViewType(e.name) == viewIndex) {
					e.checked = checkObject.checked;
				}
			}
		}
	}
	parent.setChecked();
}

function resetCheckBox () {
	for (var i=0; i<document.campaignForm.elements.length; i++) {
		var e = document.campaignForm.elements[i];
		if (e.type == "checkbox") {
			e.checked = false;
		}
	}
	parent.setChecked();
}

function getListViewType (checkValue) {
	return checkValue.substring(0, checkValue.indexOf("|"));
}

function getListInitiativeId (checkValue) {
	var sep1Index = checkValue.indexOf("|");
	var sep2Index = checkValue.substring(sep1Index+1, checkValue.length).indexOf("|") + sep1Index + 1;
	return checkValue.substring(sep1Index + 1, sep2Index);
}

function getListStatus (checkValue) {
	var sep1Index = checkValue.indexOf("|");
	var sep2Index = checkValue.substring(sep1Index+1, checkValue.length).indexOf("|") + sep1Index + 1;
	return checkValue.substring(sep2Index + 1, checkValue.length);
}

function escapeURLSpecialChar (originalStr) {
	var newStr = originalStr;

	// escape characters that are illegal in an URL
	for (var i=0; i<newStr.length; i++) {
		if (newStr.substring(i, i+1) == "%") {
			newStr = newStr.substring(0, i) + "%25" + newStr.substring(i+1, newStr.length);
		}
	}

	return newStr;
}
//-->
</script>
</head>

<body onload="loadPanelData()" class="content_list" style="margin-left: 0px; margin-top: 0px">

<form name="campaignForm" id="campaignForm">

<table border="0" cellpadding="0" cellspacing="0" id="WC_CampaignInitiativeMappingPanel_Table_1">
	<tr>
		<td id="WC_CampaignInitiativeMappingPanel_TableCell_1"><label for="<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>"><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_TYPE_VIEW) %></label></td>
	</tr>
	<tr>
		<td id="WC_CampaignInitiativeMappingPanel_TableCell_2">
			<select name="<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>" id="<%= CampaignConstants.ELEMENT_INITIATIVE_TYPE %>" onchange="showViewDivisions();resetCheckBox();">
<%	for (int i=0; i<availableActivityView.length; i++) { %>
				<option value="<%= availableActivityView[i] %>"><%= campaignsRB.get(availableActivityView[i]) %></option>
<%	} %>
			</select>
		</td>
	</tr>
</table>
<br/>

<script language="JavaScript">
<!-- hide script from old browsers
//
// Populate the data in the list by going through each e-mail activity in the emailActivityListData
// object, get the e-mail activity detail from the e-mail activity data bean, and populate a new list
// javascript object.
//
var emailActivityDisplayData = new Array();
var emailActivityDisplayDataSize = 0;
<%	for (int i=0; i<numberOfEmailActivities; i++) { %>
for (var i=0; i<numberOfEmailActivities; i++) {
	if (emailActivityListData[i].id == "<%= emailActivities[i].getId().toString() %>") {
		emailActivityDisplayData[emailActivityDisplayDataSize] = new Object();
		emailActivityDisplayData[emailActivityDisplayDataSize].originalIndex = i;
		emailActivityDisplayData[emailActivityDisplayDataSize].emailActivityName = "<%= UIUtil.toJavaScript(emailActivities[i].getName()) %>";
		emailActivityDisplayData[emailActivityDisplayDataSize].emailActivityDesc = "<%= UIUtil.toJavaScript(emailActivities[i].getDescription()) %>";
		emailActivityDisplayData[emailActivityDisplayDataSize].emailActivitySegment = "<%= UIUtil.toJavaScript(emailActivities[i].getCustomerSegmentName()) %>";
		emailActivityDisplayData[emailActivityDisplayDataSize].emailActivitySendDate = "<%= UIUtil.toJavaScript(com.ibm.commerce.utils.TimestampHelper.getDateTimeFromTimestamp(emailActivities[i].getSendDate(), jLocale)) %>";
		emailActivityDisplayData[emailActivityDisplayDataSize].emailActivityStatus = "<%= UIUtil.toJavaScript((String)campaignsRB.get(emailActivities[i].getStatus().toString())) %>";
		emailActivityDisplayData[emailActivityDisplayDataSize].emailActivityStatusInString = "<%= UIUtil.toJavaScript((String)campaignsRB.get(emailActivities[i].getStatusString())) %>";
		emailActivityDisplayDataSize++;
		break;
	}
}
<%	} %>
//-->
</script>

<%
///////////////////////////////////////////////////////////////////////////////////////////////
// Web Activity list
///////////////////////////////////////////////////////////////////////////////////////////////
%>
<div id="<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>Div" style="display: none">

<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "selectDeselectAll('" + CampaignConstants.INITIATIVE_LIST_WEB_VIEW + "', this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.equals(orderByParm), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_DESCRIPTION_COLUMN), CampaignConstants.ORDER_BY_DESCRIPTION, CampaignConstants.ORDER_BY_DESCRIPTION.equals(orderByParm), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_TYPE_COLUMN), CampaignConstants.ORDER_BY_TYPE, CampaignConstants.ORDER_BY_TYPE.equals(orderByParm), null, false) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_STATUS_COLUMN), null, false, null, false) %>
<%= comm.endDlistRow() %>

<script language="JavaScript">
<!-- hide script from old browsers
var rowselect = 1;
var numberOfInitiativesInList = 0;

for (var i=0; i<numberOfInitiatives; i++) {
	if ((initiativeListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (initiativeListData[i].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
		var thisInitiative = initiativeListData[i];

		var disableFlag = "";
		if ((thisInitiative.storeId != "") && (thisInitiative.storeId != "<%= campaignCommandContext.getStoreId() %>")) {
			disableFlag = "disabled";
		}

		// table row definition for the current row
		document.writeln('<tr class="list_row' + rowselect + '" onmouseover="this.className=\'list_row3\';" onmouseout="if (this.className == \'list_row3\') {this.className=\'list_row' + rowselect + '\';}">');

		// check boxes column
		addDlistCheck("<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>|" + i + "|");

		// initiative name column
		if (thisInitiative.storeId == "<%= campaignCommandContext.getStoreId() %>") {
			addDlistColumn(thisInitiative.name, "javascript:changeInitiative('<%= CampaignConstants.INITIATIVE_LIST_WEB_VIEW %>|" + i + "|')");
		}
		else {
			addDlistColumn(thisInitiative.name, "none");
		}

		// initiative description and content type columns
		addDlistColumn(thisInitiative.description, "none");
<%	for (int i=0; i<CampaignConstants.whatTypeArrayWithCoupon.length; i++) { %>
		if (thisInitiative.contentType == "<%= CampaignConstants.whatTypeArrayWithCoupon[i] %>") {
			addDlistColumn("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.whatTypeArrayWithCoupon[i])) %>", "none");
		}
<%	} %>

		// initiative status column
		document.writeln('<td class="list_info1">');
		document.writeln('<select name="<%= CampaignConstants.ELEMENT_INITIATIVE_STATUS %>_' + i + '" id="<%= CampaignConstants.ELEMENT_INITIATIVE_STATUS %>_' + i + '" onClick="this.parentElement.parentElement.className=\'list_row' + rowselect + '\';" onChange="updateStatus(' + i + ');" ' + disableFlag + '>');
		document.writeln('<option value="<%= CampaignConstants.INITIATIVE_STATUS_ACTIVE %>"><%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.INITIATIVE_STATUS_ACTIVE)) %></option>');
		document.writeln('<option value="<%= CampaignConstants.INITIATIVE_STATUS_INACTIVE %>"><%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.INITIATIVE_STATUS_INACTIVE)) %></option>');
		document.writeln('</select>');
		document.writeln('</td>');

		// table row definition for the current row
		document.writeln('</tr>');

		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}

		numberOfInitiativesInList++;
	}
}
//-->
</script>

<%= comm.endDlistTable() %>

<script language="JavaScript">
<!-- hide script from old browsers
if (numberOfInitiativesInList == 0) {
	document.writeln('<p /><p />');
	document.writeln('<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_WEB_EMPTY)) %>');
}
//-->
</script>

</div>

<%
///////////////////////////////////////////////////////////////////////////////////////////////
// E-mail Activity list
///////////////////////////////////////////////////////////////////////////////////////////////
%>
<div id="<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>Div" style="display: none">

<%= comm.startDlistTable((String)campaignsRB.get("campaignEmailAcitivtyListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "selectDeselectAll('" + CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW + "', this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListNameColumn"), EmailActivityConstants.ORDER_BY_NAME, EmailActivityConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListDescriptionColumn"), EmailActivityConstants.ORDER_BY_DESCRIPTION, EmailActivityConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListCustomerSegmentColumn"), EmailActivityConstants.ORDER_BY_CUSTOMERSEGMENTNAME, EmailActivityConstants.ORDER_BY_CUSTOMERSEGMENTNAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListSendDateColumn"), EmailActivityConstants.ORDER_BY_SENDDATE, EmailActivityConstants.ORDER_BY_SENDDATE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListStatusColumn"), EmailActivityConstants.ORDER_BY_STATUS, EmailActivityConstants.ORDER_BY_STATUS.equals(orderByParm)) %>
<%= comm.endDlistRow() %>

<script language="JavaScript">
<!-- hide script from old browsers
rowselect = 1;
var numberOfEmailActivitiesInList = 0;

for (var i=0; i<emailActivityDisplayDataSize; i++) {
	if ((emailActivityListData[emailActivityDisplayData[i].originalIndex].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DELETE %>") && (emailActivityListData[emailActivityDisplayData[i].originalIndex].actionFlag != "<%= CampaignConstants.ACTION_FLAG_DESTROY %>")) {
		var thisEmailActivity = emailActivityListData[emailActivityDisplayData[i].originalIndex];

		startDlistRow(rowselect);

		// check boxes column
		addDlistCheck("<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>|" + emailActivityDisplayData[i].originalIndex + "|" + emailActivityDisplayData[i].emailActivityStatus);

		// e-mail activity name column
		if ((thisEmailActivity.storeId == "<%= campaignCommandContext.getStoreId() %>") && (emailActivityDisplayData[i].emailActivityStatus != "1")) {
			addDlistColumn(emailActivityDisplayData[i].emailActivityName, "javascript:changeInitiative('<%= CampaignConstants.INITIATIVE_LIST_EMAIL_VIEW %>|" + emailActivityDisplayData[i].originalIndex + "|" + emailActivityDisplayData[i].emailActivityStatus + "')");
		}
		else {
			addDlistColumn(emailActivityDisplayData[i].emailActivityName, "none");
		}

		// other e-mail activity columns
		addDlistColumn(emailActivityDisplayData[i].emailActivityDesc, "none");
		addDlistColumn(emailActivityDisplayData[i].emailActivitySegment, "none");
		addDlistColumn(emailActivityDisplayData[i].emailActivitySendDate, "none");
		addDlistColumn(emailActivityDisplayData[i].emailActivityStatusInString, "none");

		endDlistRow();

		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}

		numberOfEmailActivitiesInList++;
	}
}
//-->
</script>

<%= comm.endDlistTable() %>

<script language="JavaScript">
<!-- hide script from old browsers
if (numberOfEmailActivitiesInList == 0) {
	document.writeln('<p /><p />');
	document.writeln('<%= UIUtil.toJavaScript((String)campaignsRB.get("campaignEmailActivityListEmpty")) %>');
}
//-->
</script>

</div>

</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(numberOfInitiativesInList + numberOfEmailActivitiesInList);
parent.setButtonPos("0px", "44px");
//-->
</script>

</body>

</html>