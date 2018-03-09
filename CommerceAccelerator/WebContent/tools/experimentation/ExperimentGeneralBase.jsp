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
	com.ibm.commerce.tools.experimentation.ExperimentConstants,
	com.ibm.commerce.tools.experimentation.beans.ExperimentTypeDataBean,
	com.ibm.commerce.tools.experimentation.beans.ExperimentTypeListDataBean" %>

<%@ include file="common.jsp" %>

<script language="JavaScript">
<!-- hide script from old browsers
// put ratio limit size to parent
parent.put("displayFrequencyTotalSize", "<%= experimentRB.get("displayFrequencyTotalSize") %>");

// get experiment data bean javascript object from parent
var experimentDataBean = null;
if (parent.get) {
	experimentDataBean = parent.get("experiment", null);
}

function init () {
	with (document.experimentGeneralForm) {
		// populate experiment attributes to all fields in the form
		if (experimentDataBean != null) {
			// disable name field if changing this experiment
			if (experimentDataBean.id != "" && "<%=UIUtil.toJavaScript( request.getParameter("newExperiment") )%>" != "true") {
				experimentName.readOnly = true;
				experimentName.style.borderStyle = "none";
			}

			if (document.all("storeElementType") != null) {
				loadSelectValue(storeElementType, experimentDataBean.storeElementTypeId);
			}
			storeElementTypeId.value = experimentDataBean.storeElementTypeId;
			storeElementTypeName.value = experimentDataBean.storeElementTypeName;
			experimentId.value = experimentDataBean.id;
			ruleXml.value = experimentDataBean.ruleXml;
			experimentName.value = experimentDataBean.experimentName;
			description.value = experimentDataBean.description;
			loadSelectValue(priority, experimentDataBean.priority);
			loadSelectValue(resultScope, experimentDataBean.resultScope);
			startDate_year.value = experimentDataBean.startYear;
			startDate_month.value = experimentDataBean.startMonth;
			startDate_day.value = experimentDataBean.startDay;
			startDate_time.value = experimentDataBean.startTime;
			if (experimentDataBean.endYear != null) {
				endDate_year.value = experimentDataBean.endYear;
			}
			if (experimentDataBean.endMonth != null) {
				endDate_month.value = experimentDataBean.endMonth;
			}
			if (experimentDataBean.endDay != null) {
				endDate_day.value = experimentDataBean.endDay;
			}
			if (experimentDataBean.endTime != null) {
				endDate_time.value = experimentDataBean.endTime;
			}
			expireCount.value = experimentDataBean.expireCount;
		}

		// display message for error found during validation on panel data
		if (parent.get("experimentExists", false)) {
			parent.remove("experimentExists");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentExists")) %>");
			experimentName.select();
			experimentName.focus();
			return;
		}
		if (parent.get("experimentNameRequired", false)) {
			parent.remove("experimentNameRequired");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentNameRequired")) %>");
			experimentName.select();
			experimentName.focus();
			return;
		}
		if (parent.get("experimentNameTooLong", false)) {
			parent.remove("experimentNameTooLong");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentNameTooLong")) %>");
			experimentName.select();
			experimentName.focus();
			return;
		}
		if (parent.get("experimentDescriptionTooLong", false)) {
			parent.remove("experimentDescriptionTooLong");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentDescriptionTooLong")) %>");
			description.select();
			description.focus();
			return;
		}
		if (parent.get("experimentStartDateInvalid", false)) {
			parent.remove("experimentStartDateInvalid");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("invalidStartDate")) %>");
			startDate_year.focus();
			return;
		}
		if (parent.get("experimentStartTimeInvalid", false)) {
			parent.remove("experimentStartTimeInvalid");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("invalidStartTime")) %>");
			startDate_time.focus();
			return;
		}
		if (parent.get("experimentEndDateInvalid", false)) {
			parent.remove("experimentEndDateInvalid");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("invalidEndDate")) %>");
			endDate_year.focus();
			return;
		}
		if (parent.get("experimentEndTimeInvalid", false)) {
			parent.remove("experimentEndTimeInvalid");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("invalidEndTime")) %>");
			endDate_time.focus();
			return;
		}
		if (parent.get("experimentStartDateAfterEndDate", false)) {
			parent.remove("experimentStartDateAfterEndDate");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("pleaseEnterEndAfterStartDate")) %>");
			endDate_year.focus();
			return;
		}
		if (parent.get("experimentExpireCountInvalid", false)) {
			parent.remove("experimentExpireCountInvalid");
			alertDialog("<%= UIUtil.toJavaScript((String)experimentRB.get("experimentExpireCountInvalid")) %>");
			expireCount.select();
			expireCount.focus();
			return;
		}

		// set default focus
		if (experimentName.readOnly) {
			description.focus();
		}
		else {
			experimentName.focus();
		}
	}
}

function updateStoreElementType () {
<%
	ExperimentTypeListDataBean experimentTypeList = new ExperimentTypeListDataBean();
	DataBeanManager.activate(experimentTypeList, request);
	ExperimentTypeDataBean experimentTypes[] = experimentTypeList.getExperimentTypeList();
	if (experimentTypes != null && experimentTypes.length > 0) {
		for (int i=0; i<experimentTypes.length; i++) {
%>
	if (getSelectValue(document.experimentGeneralForm.storeElementType) == "<%= experimentTypes[i].getId() %>") {
		document.experimentGeneralForm.storeElementTypeId.value = "<%= experimentTypes[i].getId() %>";
		document.experimentGeneralForm.storeElementTypeName.value = "<%= UIUtil.toJavaScript(experimentTypes[i].getTypeName()) %>";
	}
<%
		}
	}
%>
}

function savePanelData () {
	with (document.experimentGeneralForm) {
		if (experimentDataBean != null) {
			// save all fields from the form to attributes in the experiment object
			if (document.all("storeElementType") != null) {
				experimentDataBean.storeElementTypeId = getSelectValue(storeElementType);
			}
			experimentDataBean.experimentName = experimentName.value;
			experimentDataBean.description = description.value;
			experimentDataBean.priority = getSelectValue(priority);
			experimentDataBean.resultScope = getSelectValue(resultScope);
			experimentDataBean.startYear = startDate_year.value;
			experimentDataBean.startMonth = startDate_month.value;
			experimentDataBean.startDay = startDate_day.value;
			experimentDataBean.startTime = startDate_time.value;
			experimentDataBean.endYear = endDate_year.value;
			experimentDataBean.endMonth = endDate_month.value;
			experimentDataBean.endDay = endDate_day.value;
			experimentDataBean.endTime = endDate_time.value;
			experimentDataBean.expireCount = expireCount.value;
			experimentDataBean.experimentRuleDefinition = top.getData("experimentRuleDefinition");
		}
	}
}
//-->
</script>
