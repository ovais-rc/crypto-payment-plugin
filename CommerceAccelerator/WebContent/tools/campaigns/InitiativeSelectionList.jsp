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
	com.ibm.commerce.tools.campaigns.CampaignConstants,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeDataBean,
	com.ibm.commerce.tools.campaigns.CampaignInitiativeListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignInitiativeListDataBean initiativeList;
	CampaignInitiativeDataBean initiatives[] = null;
	int numberOfInitiatives = 0;
	initiativeList = new CampaignInitiativeListDataBean();
	DataBeanManager.activate(initiativeList, request);
	initiatives = initiativeList.getInitiativeList();
	if (initiatives != null) {
		numberOfInitiatives = initiatives.length;
	}

	String resultLimit = "multiple";
	if (request.getParameter("resultLimit") != null && !request.getParameter("resultLimit").equals("")) {
		resultLimit = request.getParameter("resultLimit");
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_TITLE) %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var resultLimit = "<%= UIUtil.toJavaScript(resultLimit) %>";
var currentArray = top.getData("currentArray", null);
var resultContainer = new Array();
var resultIndex = 0;

if (currentArray == null) {
	currentArray = new Array();
}

function performFinish () {
	// put the selected initiatives into an array in the model
	var initiativeResult = new Array();

	// check if no checkboxes has been selected, or checked boxes exceeds allowed result limit
	if ((resultLimit == "single") && (currentArray.length == 0)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectOneInitiative")) %>");
		return;
	}
	if ((resultLimit == "single") && (currentArray.length > 1)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtMostOneInitiative")) %>");
		return;
	}
	if ((resultLimit == "multiple") && (currentArray.length == 0)) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("pleaseSelectAtLeastOneInitiative")) %>");
		return;
	}

	initiativeResult = currentArray;
	top.sendBackData(initiativeResult, "initiativeResult");
	top.saveData(null, "currentArray");

	// go back to the finder's caller!
	top.goBack();
}

// called when a checkbox is clicked
function performUpdate (isAll, checkObject) {
	var newIndex;
	var resultFound = false;

	if (isAll) {
		for (var i=0; i<resultContainer.length; i++) {
			for (var j=0; j<currentArray.length; j++) {
				// case 1: if deselect and current entry found, remove current entry
				// case 2: if select and current entry found, do nothing
				if (currentArray[j] != null) {
					if (resultContainer[i].initiativeId == currentArray[j].initiativeId) {
						resultFound = true;
						if (!checkObject.checked) {
							currentArray[j] = null;
							break;
						}
					}
				}
			}
			// case 3: if select and current entry not found, add current entry
			// case 4: if deselect and current entry not found, do nothing
			if (!resultFound) {
				if (checkObject.checked) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
				}
			}
			else {
				resultFound = false;
			}
		}
	}
	else {
		if (checkObject.checked) {
			for (var i=0; i<resultContainer.length; i++) {
				if (resultContainer[i].initiativeId == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].initiativeId == checkObject.name) {
					currentArray[i] = null;
					break;
				}
			}
		}
	}

	var tempArray = new Array();
	for (var i=0; i<currentArray.length; i++) {
		if (currentArray[i] != null) {
			tempArray[tempArray.length] = currentArray[i];
		}
	}
	currentArray = tempArray;

	top.saveData(currentArray, "currentArray");
}

function performCancel () {
	top.goBack();
}

function getResultsSize () {
	return <%= numberOfInitiatives %>;
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad();" class="content_list">

<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfInitiatives;
	int totalpage = totalsize/listSize;
	int indexFrom = startIndex;

	if (endIndex > numberOfInitiatives) {
		endIndex = numberOfInitiatives;
	}
%>

<script language="JavaScript">
<!-- hide script from old browsers
<%
	for (int i=indexFrom; i<endIndex; i++) {
		// get one of the e-Marketing Spot ID and name that the current initiative has been scheduled to
		String scheduledEmsId = "";
		String scheduledEmsName = "";
		if (initiatives[i].getEmsSchedule() != null && initiatives[i].getEmsSchedule().length > 0) {
			scheduledEmsId = initiatives[i].getEmsSchedule()[0].getEmsId().toString();
			scheduledEmsName = initiatives[i].getEmsSchedule()[0].getEmsName();
		}
%>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].initiativeId = "<%= initiatives[i].getId() %>";
resultContainer[resultIndex].initiativeName = "<%= UIUtil.toJavaScript(initiatives[i].getInitiativeName()) %>";
resultContainer[resultIndex].initiativeDesc = "<%= UIUtil.toJavaScript(initiatives[i].getDescription()) %>";
resultContainer[resultIndex].initiativeContentType = "<%= UIUtil.toJavaScript(initiatives[i].getContentType()) %>";
resultContainer[resultIndex].initiativeStoreId = "<%= initiatives[i].getStoreId() %>";
resultContainer[resultIndex].initiativeStatus = "<%= initiatives[i].getStatus() %>";
resultContainer[resultIndex].scheduledEmsId = "<%= scheduledEmsId %>";
resultContainer[resultIndex].scheduledEmsName = "<%= UIUtil.toJavaScript(scheduledEmsName) %>";
resultIndex++;
<%	} %>
//-->
</script>

<%= comm.addControlPanel("campaigns.InitiativeSelectionList", totalpage, totalsize, jLocale) %>
<form name="initiativeSelectionForm" id="initiativeSelectionForm">
<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_DESCRIPTION_COLUMN), CampaignConstants.ORDER_BY_DESCRIPTION, CampaignConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_TYPE_COLUMN), CampaignConstants.ORDER_BY_TYPE, CampaignConstants.ORDER_BY_TYPE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_CAMPAIGN_COLUMN), CampaignConstants.ORDER_BY_CAMPAIGN, CampaignConstants.ORDER_BY_CAMPAIGN.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_STATUS_COLUMN), CampaignConstants.ORDER_BY_STATUS, CampaignConstants.ORDER_BY_STATUS.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	CampaignInitiativeDataBean initiative;
	for (int i=indexFrom; i<endIndex; i++) {
		initiative = initiatives[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(initiative.getId().toString(), "parent.setChecked();performUpdate(false, this);", UIUtil.toHTML(UIUtil.toJavaScript(initiative.getInitiativeName()))) %>
<%= comm.addDlistColumn(UIUtil.toHTML(initiative.getInitiativeName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(initiative.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)campaignsRB.get(initiative.getContentType())), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(initiative.getCampaignName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)campaignsRB.get(initiative.getStatus())), "none") %>
<%= comm.endDlistRow() %>
<%
		if (rowselect == 1) {
			rowselect = 2;
		}
		else {
			rowselect = 1;
		}
	}
%>
<%= comm.endDlistTable() %>
<%	if (numberOfInitiatives == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_SELECTION_LIST_EMPTY) %>
<%	} %>
</form>

<script>
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>
