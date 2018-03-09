<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2005
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
	com.ibm.commerce.tools.campaigns.CampaignEmsDataBean,
	com.ibm.commerce.tools.campaigns.CampaignEmsListDataBean,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignEmsListDataBean contentSpotList;
	CampaignEmsDataBean contentSpots[] = null;
	int numberOfContentSpot = 0;
	contentSpotList = new CampaignEmsListDataBean();
	contentSpotList.setEmsUsageType(CampaignConstants.EMS_USAGE_TYPE_CONTENT);
	DataBeanManager.activate(contentSpotList, request);
	contentSpots = contentSpotList.getEmsList();
	if (contentSpots != null) {
		numberOfContentSpot = contentSpots.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get("contentSpotListTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
//
// If the current store doesn't have the permission to create, update or delete an entry,
// hide those buttons from the button frame.
//
<%	if (!CampaignUtil.isEmsEditable(campaignCommandContext.getStore().getStoreType())) { %>
parent.hideButton("new");
parent.hideButton("delete");
<%	} %>

function newContentSpot () {
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.ContentSpotDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotNew")) %>", url, true);
}

function changeContentSpot () {
	var contentSpotId = -1;
	var contentSpotEditableFlag = "Y";
	if (arguments.length > 0) {
		contentSpotId = arguments[0];
		contentSpotEditableFlag = arguments[1];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			contentSpotId = getListContentSpotId(checked[0]);
			contentSpotEditableFlag = getListEditableFlag(checked[0]);
		}
	}
	if (contentSpotId != -1) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.ContentSpotDialog&emsId=" + contentSpotId + "&contentSpotEditableFlag=" + contentSpotEditableFlag;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotChange")) %>", url, true);
	}
}

function summaryContentSpot () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var contentSpotId = getListContentSpotId(checked[0]);
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.ContentSpotSummaryDialog&emsId=" + contentSpotId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotSummaryDialogTitle")) %>", url, true);
	}
}

function deleteContentSpot () {
	var checked = parent.getChecked();
	var isDeleting = false;
	if (checked.length > 0) {
		var contentSpotId, editableFlag;
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignEmsDelete?emsIds=";
		for (var i=0; i<checked.length; i++) {
			contentSpotId = getListContentSpotId(checked[i]);
			editableFlag = getListEditableFlag(checked[i]);
			if (editableFlag == "Y") {
				url += contentSpotId + ",";
				isDeleting = true;
			}
		}
		if (isDeleting) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("contentSpotListDeleteConfirmation")) %>")) {
				parent.location.replace(url.substring(0, url.length-1));
			}
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeDeleted")) %>");
		}
	}
}

function getResultsSize () {
	return <%= numberOfContentSpot %>;
}

function getListContentSpotId (checkValue) {
	return checkValue.substring(0, checkValue.indexOf("|"));
}

function getListEditableFlag (checkValue) {
	return checkValue.substring(checkValue.indexOf("|") + 1, checkValue.length);
}

function onLoad () {
	parent.loadFrames();
}
//-->
</script>
</head>

<body onload="onLoad()" class="content_list">

<%
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;
	int rowselect = 1;
	int totalsize = numberOfContentSpot;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("campaigns.ContentSpotList", totalpage, totalsize, jLocale) %>
<form name="contentSpotForm" id="contentSpotForm">
<%= comm.startDlistTable((String)campaignsRB.get("contentSpotListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentSpotListNameColumn"), "name", "name".equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentSpotListDescriptionColumn"), "description", "description".equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get("contentSpotListScheduleNumberColumn"), "schedulenumber", "schedulenumber".equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfContentSpot) {
		endIndex = numberOfContentSpot;
	}

	CampaignEmsDataBean contentSpotDb;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		contentSpotDb = contentSpots[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%		if (contentSpotDb.getStoreId().equals(campaignCommandContext.getStoreId())) { %>
<%= comm.addDlistCheck(contentSpotDb.getId().toString() + "|Y", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(contentSpotDb.getEmsName()), "javascript:changeContentSpot(" + contentSpotDb.getId() + ", 'Y')") %>
<%		} else { %>
<%= comm.addDlistCheck(contentSpotDb.getId().toString() + "|N", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(contentSpotDb.getEmsName()), "javascript:changeContentSpot(" + contentSpotDb.getId() + ", 'N')") %>
<%		} %>
<%= comm.addDlistColumn(UIUtil.toHTML(contentSpotDb.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(contentSpotDb.getNumberOfSchedule().toString()), "none") %>
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
<%	if (numberOfContentSpot == 0) { %>
<p/><p/>
<%= campaignsRB.get("contentSpotListEmpty") %>
<%	} %>
</form>

<script language="JavaScript">
<!-- hide script from old browsers
parent.afterLoads();
parent.setResultssize(getResultsSize());
//-->
</script>

</body>

</html>