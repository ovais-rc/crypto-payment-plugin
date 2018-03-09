<!-- ========================================================================
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2008
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
	com.ibm.commerce.tools.campaigns.CampaignEmsListCursorDataBean,
	com.ibm.commerce.tools.campaigns.CampaignUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*" %>

<%@ include file="common.jsp" %>

<%
	Locale jLocale = campaignCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	CampaignEmsListCursorDataBean emsList = new CampaignEmsListCursorDataBean();
	emsList.setEmsUsageType(CampaignConstants.EMS_USAGE_TYPE_MARKETING);
	
	//get the start and list sizes from the xml file
  int startIndex = Integer.parseInt(request.getParameter("startindex"));
  int listSize = Integer.parseInt(request.getParameter("listsize"));
  int endIndex = startIndex + listSize;

  //initialize the start and end indicies
  emsList.setIndexEnd("" + endIndex);
  emsList.setIndexBegin("" + startIndex);
   
	DataBeanManager.activate(emsList, request);
	CampaignEmsDataBean [] ems = emsList.getEmsList();
	
	int numberOfEms = 0;
	int totalNumberOfEms = 0;
	
	if (ems != null) {
		numberOfEms = ems.length;
	  totalNumberOfEms = emsList.getResultSetSize();
	}
	
	//set up paging
	int rowselect = 1;
	int totalpage = 0;
	if (listSize != 0) {
		totalpage = totalNumberOfEms/listSize;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= campaignsRB.get(CampaignConstants.MSG_EMS_LIST_TITLE) %></title>

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

function showPreview () {
	var url = "<%= UIUtil.getWebappPath(request)%>DialogView?XMLFile=preview.PreviewDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("preview")) %>", url, true);
}

function newEms () {
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignEmsDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_EMS_NEW)) %>", url, true);
}

function emsProperties () {
	var emsId = -1;
	var emsEditableFlag = "Y";
	if (arguments.length > 0) {
		emsId = arguments[0];
		emsEditableFlag = arguments[1];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			emsId = getListEmsId(checked[0]);
			emsEditableFlag = getListEditableFlag(checked[0]);
		}
	}
	if (emsId != -1) {
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.CampaignEmsDialog&emsId=" + emsId + "&emsEditableFlag=" + emsEditableFlag;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_EMS_CHANGE)) %>", url, true);
	}
}

function summaryEms () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var emsId = getListEmsId(checked[0]);
		var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=campaigns.EmsSummaryDialog&emsId=" + emsId;
		top.setContent("<%= UIUtil.toJavaScript((String)campaignsRB.get("emsSummaryDialogTitle")) %>", url, true);
	}
}

function deleteEms () {
	var checked = parent.getChecked();
	var isDeleting = false;
	if (checked.length > 0) {
		var emsId, editableFlag;
		var url = "<%= UIUtil.getWebappPath(request) %>CampaignEmsDelete?emsIds=";
		for (var i=0; i<checked.length; i++) {
			emsId = getListEmsId(checked[i]);
			editableFlag = getListEditableFlag(checked[i]);
			if (editableFlag == "Y") {
				url += emsId + ",";
				isDeleting = true;
			}
		}
		if (isDeleting) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_DELETE_CONFIRMATION)) %>")) {
				parent.location.replace(url.substring(0, url.length-1));
			}
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)campaignsRB.get("listEntryCannotBeDeleted")) %>");
		}
	}
}

function getResultsSize () {
	return <%= totalNumberOfEms %>;
}

function getListEmsId (checkValue) {
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

<%= comm.addControlPanel("campaigns.CampaignEmsList", listSize, totalNumberOfEms, jLocale) %>

<form name="emsForm" id="emsForm">
<%= comm.startDlistTable((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_SUMMARY)) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_NAME_COLUMN), CampaignConstants.ORDER_BY_NAME, CampaignConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_DESCRIPTION_COLUMN), CampaignConstants.ORDER_BY_DESCRIPTION, CampaignConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)campaignsRB.get(CampaignConstants.MSG_EMS_LIST_SCHEDULE_NUMBER_COLUMN), null, false) %>
<%= comm.endDlistRow() %>
  <%
	//make sure the endIndex is greater than the number of spots
	if (endIndex > totalNumberOfEms) {
		endIndex = totalNumberOfEms;
	}
	int indexFrom = startIndex;
	for (int i = 0; i < numberOfEms; i++) {
	    CampaignEmsDataBean emsDb = ems[i];
  %>
<%= comm.startDlistRow(rowselect) %>
<%		if (emsDb.getStoreId().equals(campaignCommandContext.getStoreId())) { %>
<%= comm.addDlistCheck(emsDb.getId().toString() + "|Y", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getEmsName()), "javascript:emsProperties(" + emsDb.getId() + ", 'Y')") %>
<%		} else { %>
<%= comm.addDlistCheck(emsDb.getId().toString() + "|N", "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getEmsName()), "javascript:emsProperties(" + emsDb.getId() + ", 'N')") %>
<%		} %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(emsDb.getNumberOfSchedule().toString()), "none") %>
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
<%	if (numberOfEms == 0) { %>
<p/><p/>
<%= campaignsRB.get(CampaignConstants.MSG_EMS_LIST_EMPTY) %>
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