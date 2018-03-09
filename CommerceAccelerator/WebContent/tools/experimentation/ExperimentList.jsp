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
	import="com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.tools.experimentation.ExperimentConstants,
	com.ibm.commerce.tools.experimentation.beans.ExperimentDataBean,
	com.ibm.commerce.tools.experimentation.beans.ExperimentListDataBean,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	java.text.DateFormat" %>

<%@ include file="common.jsp" %>

<%
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, experimentCommandContext.getLocale());
	Locale jLocale = experimentCommandContext.getLocale();
	String orderByParm = request.getParameter("orderby");

	ExperimentListDataBean experimentList = new ExperimentListDataBean();
	DataBeanManager.activate(experimentList, request);
	ExperimentDataBean experiments[] = experimentList.getExperimentList();
	int numberOfExperiments = 0;
	if (experiments != null) {
		numberOfExperiments = experiments.length;
	}
%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= fHeader %>
<title><%= experimentRB.get("experimentListTitle") %></title>

<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" src="<%= UIUtil.getWebPrefix(request) %>javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!-- hide script from old browsers
var experimentContainer = new Array();
<%	for (int i=0; i<numberOfExperiments; i++) { %>
experimentContainer[<%= i %>] = new Object();
experimentContainer[<%= i %>].experimentId = "<%= experiments[i].getId() %>";
experimentContainer[<%= i %>].experimentStatus = "<%= UIUtil.toJavaScript(experiments[i].getStatus()) %>";
<%	} %>

function newExperiment () {
	var url = "<%= UIUtil.getWebappPath(request) %>NotebookView?XMLFile=experiment.ExperimentNotebook";
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createExperiment")) %>", url, true);
}

function changeExperiment () {
	var experimentId = -1;
	var validExperiment = true;

	// extract experiment ID either from checkbox or parameter of this function
	if (arguments.length > 0) {
		experimentId = arguments[0];
	}
	else {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			experimentId = checked[0];
		}
	}

	// check if the selected experiment is allowed to be updated or not
	for (var i=0; i<experimentContainer.length; i++) {
		if (experimentContainer[i].experimentId == experimentId) {
			if (experimentContainer[i].experimentStatus == "<%= ExperimentConstants.EXPERIMENT_STATUS_COMPLETED %>") {
				validExperiment = false;
			}
			break;
		}
	}

	if (experimentId != -1) {
		if (validExperiment) {
			var url = "<%= UIUtil.getWebappPath(request) %>NotebookView?XMLFile=experiment.ExperimentNotebook&experimentId=" + experimentId;
			top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("updateExperiment")) %>", url, true);
		}
		else {
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("completedExperimentCannotBeModified")) %>");
		}
	}
}

function summaryExperiment () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var url = "<%= UIUtil.getWebappPath(request) %>UniversalDialogView?XMLFile=experiment.ExperimentSummaryDialog&experimentId=" + checked[0];
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("summaryExperiment")) %>", url, true);
	}
}

function copyExperiment () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var url = "<%= UIUtil.getWebappPath(request) %>NotebookView?XMLFile=experiment.ExperimentNotebook&experimentId=" + checked[0] + "&newExperiment=true";
		top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("createExperiment")) %>", url, true);
	}
}

function activateExperiment () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var url = "<%= UIUtil.getWebappPath(request) %>ExperimentStatusUpdate?experimentStatus=<%= ExperimentConstants.EXPERIMENT_STATUS_ACTIVE %>&experimentIds=";
		var experimentIds = "";
		var validExperiment = 0;
		var invalidExperiment = 0;
		// put together all inactive experiments
		for (var i=0; i<checked.length; i++) {
			for (var j=0; j<experimentContainer.length; j++) {
				if (experimentContainer[j].experimentId == checked[i]) {
					if (experimentContainer[j].experimentStatus == "<%= ExperimentConstants.EXPERIMENT_STATUS_INACTIVE %>") {
						experimentIds += checked[i] + ",";
						validExperiment++;
					}
					else {
						invalidExperiment++;
					}
					break;
				}
			}
		}
		if (validExperiment > 0 && invalidExperiment > 0) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentListActivateConfirmation")) %>")) {
				parent.location.replace(url + experimentIds.substring(0, experimentIds.length-1));
			}
		}
		else if (validExperiment == 0 && invalidExperiment > 0) {
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("listEntryCannotBeActivated")) %>");
		}
		else {
			parent.location.replace(url + experimentIds.substring(0, experimentIds.length-1));
		}
	}
}

function deactivateExperiment () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var url = "<%= UIUtil.getWebappPath(request) %>ExperimentStatusUpdate?experimentStatus=<%= ExperimentConstants.EXPERIMENT_STATUS_INACTIVE %>&experimentIds=";
		var experimentIds = "";
		var validExperiment = 0;
		var invalidExperiment = 0;
		// put together all active experiments
		for (var i=0; i<checked.length; i++) {
			for (var j=0; j<experimentContainer.length; j++) {
				if (experimentContainer[j].experimentId == checked[i]) {
					if (experimentContainer[j].experimentStatus == "<%= ExperimentConstants.EXPERIMENT_STATUS_ACTIVE %>") {
						experimentIds += checked[i] + ",";
						validExperiment++;
					}
					else {
						invalidExperiment++;
					}
					break;
				}
			}
		}
		if (validExperiment > 0 && invalidExperiment > 0) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentListDeactivateConfirmation")) %>")) {
				parent.location.replace(url + experimentIds.substring(0, experimentIds.length-1));
			}
		}
		else if (validExperiment == 0 && invalidExperiment > 0) {
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("listEntryCannotBeDeactivated")) %>");
		}
		else {
			parent.location.replace(url + experimentIds.substring(0, experimentIds.length-1));
		}
	}
}

function previewExperiment () {
	var url = "<%= UIUtil.getWebappPath(request) %>DialogView?XMLFile=preview.PreviewDialog";
	top.setContent("<%= UIUtil.toJavaScript((String)experimentRB.get("preview")) %>", url, true);
}

function deleteExperiment () {
	var checked = parent.getChecked();
	if (checked.length > 0) {
		var url = "<%= UIUtil.getWebappPath(request) %>ExperimentDelete?experimentIds=";
		for (var i=0; i<checked.length; i++) {
			url += checked[i] + ",";
		}
		if (confirmDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentListDeleteConfirmation")) %>")) {
			parent.location.replace(url.substring(0, url.length-1));
		}
	}
}

function getResultsSize () {
	return <%= numberOfExperiments %>;
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
	int totalsize = numberOfExperiments;
	int totalpage = totalsize/listSize;
%>
<%= comm.addControlPanel("experiment.ExperimentList", totalpage, totalsize, jLocale) %>
<form name="experimentListForm" id="experimentListForm">
<%= comm.startDlistTable((String)experimentRB.get("experimentListSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)experimentRB.get("experimentListNameColumn"), ExperimentConstants.ORDER_BY_NAME, ExperimentConstants.ORDER_BY_NAME.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)experimentRB.get("experimentListDescriptionColumn"), ExperimentConstants.ORDER_BY_DESCRIPTION, ExperimentConstants.ORDER_BY_DESCRIPTION.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)experimentRB.get("experimentListStartDateColumn"), ExperimentConstants.ORDER_BY_START_DATE, ExperimentConstants.ORDER_BY_START_DATE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)experimentRB.get("experimentListEndDateColumn"), ExperimentConstants.ORDER_BY_END_DATE, ExperimentConstants.ORDER_BY_END_DATE.equals(orderByParm)) %>
<%= comm.addDlistColumnHeading((String)experimentRB.get("experimentListStatusColumn"), ExperimentConstants.ORDER_BY_STATUS, ExperimentConstants.ORDER_BY_STATUS.equals(orderByParm)) %>
<%= comm.endDlistRow() %>
<%
	if (endIndex > numberOfExperiments) {
		endIndex = numberOfExperiments;
	}

	ExperimentDataBean experiment;
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
		experiment = experiments[i];
%>
<%= comm.startDlistRow(rowselect) %>
<%= comm.addDlistCheck(experiment.getId().toString(), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(experiment.getExperimentName()), "javascript:changeExperiment(" + experiment.getId() + ")") %>
<%= comm.addDlistColumn(UIUtil.toHTML(experiment.getDescription()), "none") %>
<%= comm.addDlistColumn(UIUtil.toHTML(dateFormat.format(experiment.getStartDate())), "none") %>
<%		if (experiment.getEndDate() == null) { %>
<%= comm.addDlistColumn("", "none") %>
<%		} else { %>
<%= comm.addDlistColumn(UIUtil.toHTML(dateFormat.format(experiment.getEndDate())), "none") %>
<%		} %>
<%= comm.addDlistColumn(UIUtil.toHTML((String)experimentRB.get("experimentStatus" + experiment.getStatus())), "none") %>
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
<%	if (numberOfExperiments == 0) { %>
<p/><p/>
<%= experimentRB.get("experimentListEmpty") %>
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