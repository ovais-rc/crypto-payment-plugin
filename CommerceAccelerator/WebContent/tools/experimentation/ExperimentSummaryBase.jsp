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
<%@ page import="com.ibm.commerce.tools.experimentation.beans.ExperimentDataBean,
	java.text.DateFormat" %>

<%@ include file="common.jsp" %>

<%
	ExperimentDataBean experimentDataBean = (ExperimentDataBean) request.getAttribute("experiment");
	DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.SHORT, experimentCommandContext.getLocale());
%>

<script language="JavaScript">
<!-- hide script from old browsers
//
// Before loading this page, check if an update or duplicate control activity had just been performed
// based on the initiativeResult object which potentially being passed from the activity panel ... if
// so, load the ID of the selected element as the preferred element to be persisted in this experiment
// record, and invoke the controller command to update this experiment.
//
var preferredElementId = top.getData("preferredElementId");
var initiativeResult = top.getData("initiativeResult");
if (preferredElementId != null && initiativeResult != null) {
	// if update or duplicate control activity action has been completed, mark this experiment as
	// completed and persist the preferred element
	top.saveData(null, "preferredElementId");
	top.saveData(null, "initiativeResult");
	var url = "<%= UIUtil.getWebappPath(request) %>ExperimentComplete?experimentId=<%= experimentDataBean.getId() %>&preferredElementId=" + preferredElementId;
	window.location.replace(url);
}

//
// Retrieve the status of the selected experiment, which will be used to determine the XML definition
// for the statistics section of this page.  If the status is 'completed', then buttons should be
// hidden from the list.
//
var experimentStatus = "<%= experimentDataBean.getStatus() %>";

function init () {
	with (document.experimentSummaryForm) {
		// populate experiment attributes to all fields in the form
		startDate.innerText = "<%= UIUtil.toJavaScript(dateFormat.format(experimentDataBean.getStartDate())) %>";
<%	if (experimentDataBean.getEndDate() == null) { %>
		endDate.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("experimentSummaryDataNotAvailable")) %>";
<%	} else { %>
		endDate.innerText = "<%= UIUtil.toJavaScript(dateFormat.format(experimentDataBean.getEndDate())) %>";
<%
	}
	if (experimentDataBean.getExpireCount() == null) {
%>
		expireCount.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("experimentSummaryDataNotAvailable")) %>";
<%	} else { %>
		expireCount.innerText = top.formatInteger("<%= UIUtil.toJavaScript(experimentDataBean.getExpireCount().toString()) %>", <%= experimentCommandContext.getLanguageId() %>);
<%	} %>
		resultScope.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("resultScope" + experimentDataBean.getResultScope())) %>";
<%	if (experimentDataBean.getRuleDefinition() == null) { %>
		storeElement.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("experimentSummaryDataNotAvailable")) %>";
		experimentType.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get("experimentSummaryDataNotAvailable")) %>";
<%	} else { %>
		storeElement.innerText = "<%= UIUtil.toJavaScript(experimentDataBean.getRuleDefinition().getStoreElementName()) %>";
		experimentType.innerText = "<%= UIUtil.toJavaScript((String)experimentRB.get(experimentDataBean.getRuleDefinition().getExperimentType() + "ExperimentType")) %>";
<%	} %>
	}
}
//-->
</script>
