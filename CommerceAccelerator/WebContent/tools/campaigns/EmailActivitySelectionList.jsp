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
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	EmailActivityListDataBean emailActivityList;
	EmailActivityListEntry emailActivities[] = null;
	int numberOfEmailActivities = 0;
	emailActivityList = new EmailActivityListDataBean();
	DataBeanManager.activate(emailActivityList, request);
	emailActivities = emailActivityList.getEmailActivityList();
	if (emailActivities != null) {
		numberOfEmailActivities = emailActivities.length;
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
var currentArray = top.getData("currentArray", null);
var resultContainer = new Array();
var resultIndex = 0;

if (currentArray == null) {
	currentArray = new Array();
}

function performFinish () {
	// put the selected e-mail activities into an array in the model
	var emailActivityResult = new Array();

	// at least one e-mail activity must be selected before this add action can be completed
	if (currentArray.length == 0) {
		alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_PLEASE_SELECT_AT_LEAST_ONE_INITIATIVE)) %>");
		return;
	}

	emailActivityResult = currentArray;
	top.sendBackData(emailActivityResult, "emailActivityResult");
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
					if (resultContainer[i].emailActivityId == currentArray[j].emailActivityId) {
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
				if (resultContainer[i].emailActivityId == checkObject.name) {
					newIndex = currentArray.length;
					currentArray[newIndex] = new Object();
					currentArray[newIndex] = resultContainer[i];
					break;
				}
			}
		}
		else {
			for (var i=0; i<currentArray.length; i++) {
				if (currentArray[i].emailActivityId == checkObject.name) {
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
	return <%= numberOfEmailActivities %>;
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
	int totalsize = numberOfEmailActivities;
	int totalpage = totalsize/listSize;
%>

<script language="JavaScript">
<!-- hide script from old browsers
<%	for (int i=0; i<emailActivities.length; i++) { %>
resultContainer[resultIndex] = new Object();
resultContainer[resultIndex].emailActivityId = "<%= emailActivities[i].getId() %>";
resultContainer[resultIndex].emailActivityStoreId = "<%= emailActivities[i].getStoreId() %>";
resultIndex++;
<%	} %>
//-->
</script>

<%= comm.addControlPanel("campaigns.EmailActivitySelectionList", totalpage, totalsize, jLocale) %>
<form name="emailActivitySelectionForm" id="emailActivitySelectionForm">
<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true, "parent.selectDeselectAll();performUpdate(true, this);") %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListNameColumn"), EmailActivityConstants.ORDER_BY_NAME, EmailActivityConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListDescriptionColumn"), EmailActivityConstants.ORDER_BY_DESCRIPTION, EmailActivityConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListCustomerSegmentColumn"), EmailActivityConstants.ORDER_BY_CUSTOMERSEGMENTNAME, EmailActivityConstants.ORDER_BY_CUSTOMERSEGMENTNAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListSendDateColumn"), EmailActivityConstants.ORDER_BY_SENDDATE, EmailActivityConstants.ORDER_BY_SENDDATE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListCampaignColumn"), EmailActivityConstants.ORDER_BY_CAMPAIGNNAME, EmailActivityConstants.ORDER_BY_CAMPAIGNNAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("campaignEmailActivityListStatusColumn"), EmailActivityConstants.ORDER_BY_STATUS, EmailActivityConstants.ORDER_BY_STATUS.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfEmailActivities) {
		endIndex = numberOfEmailActivities;
	}

	EmailActivityListEntry emailActivity;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		emailActivity = emailActivities[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(emailActivity.getId().toString(), "parent.setChecked();performUpdate(false, this);", UIUtil.toHTML(UIUtil.toJavaScript(emailActivity.getName()))) %>
<%= comm.addDlistColumn(UIUtil.toHTML(emailActivity.getName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emailActivity.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emailActivity.getCustomerSegmentName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(com.ibm.commerce.utils.TimestampHelper.getDateTimeFromTimestamp(emailActivity.getSendDate(), jLocale)), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emailActivity.getCampaignName()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)campaignsRB.get(emailActivity.getStatusString())), "none") %>
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
<%	if (numberOfEmailActivities == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_INITIATIVE_LIST_EMPTY) %>
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